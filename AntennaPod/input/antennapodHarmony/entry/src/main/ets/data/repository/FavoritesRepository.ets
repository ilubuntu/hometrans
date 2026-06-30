import { relationalStore } from '@kit.ArkData';
import { PodcastDatabase } from '../db/PodcastDatabase';
import { EventBus, EventType, EventPayload } from '../event/EventBus';
import { RowMappers } from './RowMappers';
import { FeedItem, SortOrder } from '../../model/EpisodeModel';

// Owns the is_favorite flag on FeedItem. Favorites are a derived view, not a
// separate table. Writes publish EPISODE_UPDATED.
export class FavoritesRepository {
  private static instance: FavoritesRepository | null = null;

  private constructor() {
  }

  static getInstance(): FavoritesRepository {
    if (FavoritesRepository.instance === null) {
      FavoritesRepository.instance = new FavoritesRepository();
    }
    return FavoritesRepository.instance;
  }

  private async getStore(): Promise<relationalStore.RdbStore> {
    return PodcastDatabase.getInstance().getStore();
  }

  async getFavorites(sort: number): Promise<FeedItem[]> {
    const store = await this.getStore();
    const orderBy = this.buildOrderBy(sort);
    const sql = 'SELECT fi.*, f.title AS feed_title, ' +
      'EXISTS (SELECT 1 FROM Queue q WHERE q.feeditem_id = fi.id) AS in_queue ' +
      'FROM FeedItem fi LEFT JOIN Feed f ON f.id = fi.feed_id WHERE fi.is_favorite = 1' +
      orderBy;
    const rs = await store.querySql(sql);
    const items = RowMappers.collectFeedItems(rs);
    rs.close();
    return items;
  }

  private buildOrderBy(sort: number): string {
    if (sort === SortOrder.DATE_OLD_NEW) {
      return ' ORDER BY fi.pub_date_ms ASC';
    }
    if (sort === SortOrder.DURATION_SHORT_LONG) {
      return ' ORDER BY fi.media_duration ASC';
    }
    if (sort === SortOrder.DURATION_LONG_SHORT) {
      return ' ORDER BY fi.media_duration DESC';
    }
    if (sort === SortOrder.TITLE_A_Z) {
      return ' ORDER BY fi.title COLLATE NOCASE ASC';
    }
    if (sort === SortOrder.TITLE_Z_A) {
      return ' ORDER BY fi.title COLLATE NOCASE DESC';
    }
    return ' ORDER BY fi.pub_date_ms DESC'; // DATE_NEW_OLD (default)
  }

  async add(itemId: number): Promise<void> {
    const store = await this.getStore();
    await store.executeSql(
      'UPDATE FeedItem SET is_favorite = 1 WHERE id = ' + itemId.toString());
    const p = new EventPayload();
    p.feedItemId = itemId;
    EventBus.publish(EventType.EPISODE_UPDATED, p);
  }

  async remove(itemId: number): Promise<void> {
    const store = await this.getStore();
    await store.executeSql(
      'UPDATE FeedItem SET is_favorite = 0 WHERE id = ' + itemId.toString());
    const p = new EventPayload();
    p.feedItemId = itemId;
    EventBus.publish(EventType.EPISODE_UPDATED, p);
  }

  async toggle(itemId: number): Promise<void> {
    const store = await this.getStore();
    const rs = await store.querySql(
      'SELECT is_favorite FROM FeedItem WHERE id = ' + itemId.toString());
    let current = false;
    if (rs.goToFirstRow()) {
      current = rs.getLong(rs.getColumnIndex('is_favorite')) !== 0;
    }
    rs.close();
    if (current) {
      await this.remove(itemId);
    } else {
      await this.add(itemId);
    }
  }
}
