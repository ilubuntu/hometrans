import { relationalStore } from '@kit.ArkData';
import { PodcastDatabase } from '../db/PodcastDatabase';
import { EventBus, EventType, EventPayload } from '../event/EventBus';
import { RowMappers } from './RowMappers';
import { PreferencesRepository } from './PreferencesRepository';
import { FeedItem, EnqueueLocation, SortOrder } from '../../model/EpisodeModel';

// Owns the Queue table. Reorder = transactional rewrite of `position`.
// add() computes the insert index from the enqueueLocation preference
// (BACK / FRONT / AFTER_CURRENT) and writes Queue.position accordingly.
export class QueueRepository {
  private static instance: QueueRepository | null = null;

  private constructor() {
  }

  static getInstance(): QueueRepository {
    if (QueueRepository.instance === null) {
      QueueRepository.instance = new QueueRepository();
    }
    return QueueRepository.instance;
  }

  private async getStore(): Promise<relationalStore.RdbStore> {
    return PodcastDatabase.getInstance().getStore();
  }

  async getQueue(): Promise<FeedItem[]> {
    const store = await this.getStore();
    const sql = 'SELECT fi.*, f.title AS feed_title, 1 AS in_queue FROM FeedItem fi ' +
      'INNER JOIN Queue q ON q.feeditem_id = fi.id ' +
      'LEFT JOIN Feed f ON f.id = fi.feed_id ' +
      'ORDER BY q.position ASC';
    const rs = await store.querySql(sql);
    const items = RowMappers.collectFeedItems(rs);
    rs.close();
    return items;
  }

  async count(): Promise<number> {
    const store = await this.getStore();
    const rs = await store.querySql('SELECT COUNT(*) AS c FROM Queue');
    let count = 0;
    if (rs.goToFirstRow()) {
      count = rs.getLong(rs.getColumnIndex('c'));
    }
    rs.close();
    return count;
  }

  // Total remaining play time (ms) across the queue — used by the queue info bar.
  async totalRemainingDurationMs(): Promise<number> {
    const store = await this.getStore();
    const rs = await store.querySql(
      'SELECT SUM(MAX(media_duration - media_position, 0)) AS total FROM FeedItem fi ' +
      'INNER JOIN Queue q ON q.feeditem_id = fi.id');
    let total = 0;
    if (rs.goToFirstRow()) {
      total = rs.getLong(rs.getColumnIndex('total'));
    }
    rs.close();
    return total;
  }

  // Enqueue an episode honouring the enqueueLocation preference.
  //   BACK           → append at end (max position + 1)
  //   FRONT          → position 0 (existing rows shifted +1)
  //   AFTER_CURRENT  → right after the first queue item (current playing), if any
  async add(itemId: number): Promise<void> {
    const store = await this.getStore();
    // Skip duplicates — Android itemListContains check (REQ-015 scenario 5).
    if (await this.contains(itemId)) {
      return;
    }
    const location = await PreferencesRepository.getInstance().getEnqueueLocation();
    const maxPos = await this.maxPosition(store);

    let insertPos = maxPos + 1; // BACK (default)
    if (location === EnqueueLocation.FRONT) {
      insertPos = 0;
    } else if (location === EnqueueLocation.AFTER_CURRENT) {
      insertPos = await this.firstPosition(store) + 1;
    }

    store.beginTransaction();
    try {
      // Shift everything at/above insertPos up by one to make room.
      await store.executeSql(
        'UPDATE Queue SET position = position + 1 WHERE position >= ' + insertPos.toString());
      await store.executeSql(
        'INSERT OR REPLACE INTO Queue (feeditem_id, position) VALUES (' +
        itemId.toString() + ', ' + insertPos.toString() + ')');
      store.commit();
    } catch (err) {
      store.rollBack();
      throw new Error('QueueRepository.add failed: ' + JSON.stringify(err));
    }
    // Auto-sort when keep-sorted is enabled (Android applySortOrder, REQ-015 scenario 4).
    await this.applyKeepSorted(store);
    const p = new EventPayload();
    p.feedItemId = itemId;
    EventBus.publish(EventType.QUEUE_CHANGED, p);
  }

  // Batch enqueue (REQ-015 scenario 3). Skips duplicates per item.
  async addBatch(itemIds: number[]): Promise<void> {
    if (itemIds.length === 0) {
      return;
    }
    for (let i = 0; i < itemIds.length; i++) {
      await this.add(itemIds[i]);
    }
  }

  async remove(itemId: number): Promise<void> {
    const store = await this.getStore();
    await store.executeSql('DELETE FROM Queue WHERE feeditem_id = ' + itemId.toString());
    await this.compactPositions(store);
    const p = new EventPayload();
    p.feedItemId = itemId;
    EventBus.publish(EventType.QUEUE_CHANGED, p);
  }

  async clearQueue(): Promise<void> {
    const store = await this.getStore();
    await store.executeSql('DELETE FROM Queue');
    EventBus.publish(EventType.QUEUE_CHANGED, new EventPayload());
  }

  // Drag-to-reorder: move an item from one position to another transactionally.
  async reorder(fromPosition: number, toPosition: number): Promise<void> {
    const store = await this.getStore();
    store.beginTransaction();
    try {
      await store.executeSql(
        'UPDATE Queue SET position = -1 WHERE position = ' + fromPosition.toString());
      if (toPosition < fromPosition) {
        await store.executeSql(
          'UPDATE Queue SET position = position + 1 WHERE position >= ' +
          toPosition.toString() + ' AND position < ' + fromPosition.toString());
      } else {
        await store.executeSql(
          'UPDATE Queue SET position = position - 1 WHERE position <= ' +
          toPosition.toString() + ' AND position > ' + fromPosition.toString());
      }
      await store.executeSql(
        'UPDATE Queue SET position = ' + toPosition.toString() + ' WHERE position = -1');
      store.commit();
    } catch (err) {
      store.rollBack();
      throw new Error('QueueRepository.reorder failed: ' + JSON.stringify(err));
    }
    EventBus.publish(EventType.QUEUE_CHANGED, new EventPayload());
  }

  // Move a single item to the top of the queue (position 0). REQ-017 场景 3.
  async moveToTop(itemId: number): Promise<void> {
    const store = await this.getStore();
    const pos = await this.positionOf(store, itemId);
    if (pos < 0) {
      return;
    }
    await this.reorder(pos, 0);
  }

  // Move a single item to the bottom of the queue (last position). REQ-017 场景 4.
  async moveToBottom(itemId: number): Promise<void> {
    const store = await this.getStore();
    const pos = await this.positionOf(store, itemId);
    if (pos < 0) {
      return;
    }
    const maxPos = await this.maxPosition(store);
    await this.reorder(pos, maxPos);
  }

  // Move multiple items to the top, preserving their relative order. REQ-017 场景 5.
  async moveBatchToTop(itemIds: number[]): Promise<void> {
    for (let i = 0; i < itemIds.length; i++) {
      await this.moveToTop(itemIds[i]);
    }
  }

  // Move multiple items to the bottom, preserving their relative order. REQ-017 场景 6.
  async moveBatchToBottom(itemIds: number[]): Promise<void> {
    for (let i = 0; i < itemIds.length; i++) {
      await this.moveToBottom(itemIds[i]);
    }
  }

  private async positionOf(store: relationalStore.RdbStore, itemId: number): Promise<number> {
    const rs = await store.querySql(
      'SELECT position FROM Queue WHERE feeditem_id = ' + itemId.toString());
    let pos = -1;
    if (rs.goToFirstRow()) {
      pos = rs.getLong(rs.getColumnIndex('position'));
    }
    rs.close();
    return pos;
  }

  async contains(itemId: number): Promise<boolean> {
    const store = await this.getStore();
    const rs = await store.querySql(
      'SELECT COUNT(*) AS c FROM Queue WHERE feeditem_id = ' + itemId.toString());
    let count = 0;
    if (rs.goToFirstRow()) {
      count = rs.getLong(rs.getColumnIndex('c'));
    }
    rs.close();
    return count > 0;
  }

  // Re-sorts the queue positions 0..n-1 when keep-sorted is enabled.
  private async applyKeepSorted(store: relationalStore.RdbStore): Promise<void> {
    const keepSorted = await PreferencesRepository.getInstance().getKeepQueueSorted();
    if (!keepSorted) {
      return;
    }
    const sortOrder = await PreferencesRepository.getInstance().getQueueSortOrder();
    const orderClause = this.queueOrderBy(sortOrder);
    const rs = await store.querySql(
      'SELECT q.feeditem_id FROM Queue q INNER JOIN FeedItem fi ON fi.id = q.feeditem_id ' +
      orderClause);
    const ids: number[] = [];
    if (rs.goToFirstRow()) {
      do {
        ids.push(rs.getLong(rs.getColumnIndex('feeditem_id')));
      } while (rs.goToNextRow());
    }
    rs.close();
    for (let i = 0; i < ids.length; i++) {
      await store.executeSql(
        'UPDATE Queue SET position = ' + i.toString() +
        ' WHERE feeditem_id = ' + ids[i].toString());
    }
  }

  private queueOrderBy(sort: number): string {
    if (sort === SortOrder.DATE_OLD_NEW) {
      return 'ORDER BY fi.pub_date_ms ASC';
    }
    if (sort === SortOrder.DURATION_SHORT_LONG) {
      return 'ORDER BY fi.media_duration ASC';
    }
    if (sort === SortOrder.DURATION_LONG_SHORT) {
      return 'ORDER BY fi.media_duration DESC';
    }
    if (sort === SortOrder.TITLE_A_Z) {
      return 'ORDER BY fi.title COLLATE NOCASE ASC';
    }
    if (sort === SortOrder.TITLE_Z_A) {
      return 'ORDER BY fi.title COLLATE NOCASE DESC';
    }
    return 'ORDER BY fi.pub_date_ms DESC'; // DATE_NEW_OLD (default)
  }

  private async maxPosition(store: relationalStore.RdbStore): Promise<number> {
    const rs = await store.querySql('SELECT MAX(position) AS m FROM Queue');
    let max = -1;
    if (rs.goToFirstRow()) {
      max = rs.getLong(rs.getColumnIndex('m'));
    }
    rs.close();
    return max;
  }

  private async firstPosition(store: relationalStore.RdbStore): Promise<number> {
    const rs = await store.querySql('SELECT MIN(position) AS m FROM Queue');
    let min = -1;
    if (rs.goToFirstRow()) {
      min = rs.getLong(rs.getColumnIndex('m'));
    }
    rs.close();
    // No current item → behave like BACK (insert at end): return max so +1 lands last.
    if (min < 0) {
      return await this.maxPosition(store);
    }
    return min;
  }

  // Renumber positions 0..n-1 after a removal so they stay contiguous.
  private async compactPositions(store: relationalStore.RdbStore): Promise<void> {
    await store.executeSql(
      'UPDATE Queue SET position = (SELECT COUNT(*) FROM Queue q2 WHERE q2.position < Queue.position)');
  }
}
