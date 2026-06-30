import { relationalStore } from '@kit.ArkData';
import { PodcastDatabase } from '../db/PodcastDatabase';
import { EventBus, EventType, EventPayload } from '../event/EventBus';
import { RowMappers } from './RowMappers';
import { FeedItem } from '../../model/EpisodeModel';

// Owns the in_history flag on FeedItem (playback history). Writes publish
// EPISODE_UPDATED; clearAll also publishes a user-facing message.
export class HistoryRepository {
  private static instance: HistoryRepository | null = null;

  private constructor() {
  }

  static getInstance(): HistoryRepository {
    if (HistoryRepository.instance === null) {
      HistoryRepository.instance = new HistoryRepository();
    }
    return HistoryRepository.instance;
  }

  private async getStore(): Promise<relationalStore.RdbStore> {
    return PodcastDatabase.getInstance().getStore();
  }

  async getHistory(): Promise<FeedItem[]> {
    const store = await this.getStore();
    const sql = 'SELECT fi.*, f.title AS feed_title, ' +
      'EXISTS (SELECT 1 FROM Queue q WHERE q.feeditem_id = fi.id) AS in_queue ' +
      'FROM FeedItem fi LEFT JOIN Feed f ON f.id = fi.feed_id WHERE fi.in_history = 1 ' +
      'ORDER BY fi.completed_date_ms DESC, fi.pub_date_ms DESC';
    const rs = await store.querySql(sql);
    const items = RowMappers.collectFeedItems(rs);
    rs.close();
    return items;
  }

  async addItem(itemId: number): Promise<void> {
    const store = await this.getStore();
    await store.executeSql(
      'UPDATE FeedItem SET in_history = 1, completed_date_ms = ' + Date.now().toString() +
      ' WHERE id = ' + itemId.toString());
    const p = new EventPayload();
    p.feedItemId = itemId;
    EventBus.publish(EventType.EPISODE_UPDATED, p);
  }

  async clearHistory(): Promise<void> {
    const store = await this.getStore();
    await store.executeSql('UPDATE FeedItem SET in_history = 0');
    EventBus.publish(EventType.EPISODE_UPDATED, new EventPayload());
    const msg = new EventPayload();
    msg.message = 'history_cleared_msg';
    EventBus.publish(EventType.MESSAGE_EVENT, msg);
  }
}
