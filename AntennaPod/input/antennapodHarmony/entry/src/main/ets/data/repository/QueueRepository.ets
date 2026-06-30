import { relationalStore } from '@kit.ArkData';
import { PodcastDatabase } from '../db/PodcastDatabase';
import { EventBus, EventType, EventPayload } from '../event/EventBus';
import { RowMappers } from './RowMappers';
import { PreferencesRepository } from './PreferencesRepository';
import { FeedItem, EnqueueLocation } from '../../model/EpisodeModel';

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
    const sql = 'SELECT fi.*, f.title AS feed_title FROM FeedItem fi ' +
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
    const p = new EventPayload();
    p.feedItemId = itemId;
    EventBus.publish(EventType.QUEUE_CHANGED, p);
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
