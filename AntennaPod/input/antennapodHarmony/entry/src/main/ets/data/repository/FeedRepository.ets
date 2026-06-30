import { relationalStore } from '@kit.ArkData';
import { PodcastDatabase } from '../db/PodcastDatabase';
import { EventBus, EventType, EventPayload } from '../event/EventBus';
import { RowMappers } from './RowMappers';
import { Feed, FeedState, FeedCounterType } from '../../model/EpisodeModel';

// Owns the Feed table + derived per-feed counters. Counters/badges are
// derived COUNT(*) queries — never stored as persisted columns.
export class FeedRepository {
  private static instance: FeedRepository | null = null;

  private constructor() {
  }

  static getInstance(): FeedRepository {
    if (FeedRepository.instance === null) {
      FeedRepository.instance = new FeedRepository();
    }
    return FeedRepository.instance;
  }

  private async getStore(): Promise<relationalStore.RdbStore> {
    return PodcastDatabase.getInstance().getStore();
  }

  private orderClause(order: number): string {
    if (order === 1 /* ALPHABETICAL */) {
      return ' ORDER BY title COLLATE NOCASE ASC';
    }
    if (order === 0 /* COUNTER */) {
      return ' ORDER BY title COLLATE NOCASE ASC';
    }
    if (order === 3 /* MOST_PLAYED */) {
      return ' ORDER BY last_update_ms DESC';
    }
    return ' ORDER BY last_update_ms DESC'; // DATE
  }

  async getFeeds(state: number): Promise<Feed[]> {
    const store = await this.getStore();
    const sql = 'SELECT * FROM Feed WHERE state = ' + state.toString() + this.orderClause(2);
    const rs = await store.querySql(sql);
    const feeds = RowMappers.collectFeeds(rs);
    rs.close();
    return feeds;
  }

  async getFeed(id: number): Promise<Feed | null> {
    const store = await this.getStore();
    const rs = await store.querySql('SELECT * FROM Feed WHERE id = ' + id.toString());
    let feed: Feed | null = null;
    if (rs.goToFirstRow()) {
      feed = RowMappers.toFeed(rs);
    }
    rs.close();
    return feed;
  }

  async getFeedCount(): Promise<number> {
    const store = await this.getStore();
    const rs = await store.querySql(
      'SELECT COUNT(*) AS c FROM Feed WHERE state = ' + FeedState.SUBSCRIBED.toString());
    let count = 0;
    if (rs.goToFirstRow()) {
      count = rs.getLong(rs.getColumnIndex('c'));
    }
    rs.close();
    return count;
  }

  // Insert a feed. Used by subscribe flow + OPML import. The actual RSS fetch is
  // deferred to the transport stage; the data path is complete here.
  async addFeed(feed: Feed): Promise<number> {
    const store = await this.getStore();
    const bucket: relationalStore.ValuesBucket = {
      title: feed.title,
      custom_title: feed.customTitle,
      author: feed.author,
      link: feed.link,
      description: feed.description,
      download_url: feed.downloadUrl,
      image_url: feed.imageUrl,
      last_update: feed.lastUpdate,
      last_update_ms: feed.lastUpdateMs,
      state: feed.state,
      is_local: feed.isLocalFeed ? 1 : 0,
      has_last_update_failed: feed.hasLastUpdateFailed ? 1 : 0
    } as relationalStore.ValuesBucket;
    const newId = await store.insert('Feed', bucket);
    const p = new EventPayload();
    p.feedId = newId;
    EventBus.publish(EventType.FEED_LIST_UPDATE, p);
    return newId;
  }

  async setFeedState(id: number, state: number): Promise<void> {
    const store = await this.getStore();
    await store.executeSql(
      'UPDATE Feed SET state = ' + state.toString() + ' WHERE id = ' + id.toString());
    const p = new EventPayload();
    p.feedId = id;
    EventBus.publish(EventType.FEED_LIST_UPDATE, p);
  }

  async setLastUpdateFailed(id: number, failed: boolean): Promise<void> {
    const store = await this.getStore();
    const value = failed ? 1 : 0;
    await store.executeSql(
      'UPDATE Feed SET has_last_update_failed = ' + value.toString() +
      ' WHERE id = ' + id.toString());
    const p = new EventPayload();
    p.feedId = id;
    EventBus.publish(EventType.FEED_LIST_UPDATE, p);
  }

  // Derived per-feed counter map. Each counter type is a COUNT(*) on FeedItem —
  // never a stored column.
  async getFeedCounters(counterType: number): Promise<Map<number, number>> {
    const store = await this.getStore();
    const result = new Map<number, number>();
    let condition: string;
    if (counterType === FeedCounterType.NONE) {
      return result;
    } else if (counterType === FeedCounterType.INBOX) {
      condition = 'read = 0';
    } else if (counterType === FeedCounterType.UNPLAYED) {
      condition = 'read = 0';
    } else if (counterType === FeedCounterType.DOWNLOADED) {
      condition = 'downloaded = 1';
    } else if (counterType === FeedCounterType.DOWNLOADED_UNPLAYED) {
      condition = 'downloaded = 1 AND read = 0';
    } else {
      return result;
    }
    const sql = 'SELECT feed_id, COUNT(*) AS c FROM FeedItem WHERE ' + condition +
      ' GROUP BY feed_id';
    const rs = await store.querySql(sql);
    if (rs.goToFirstRow()) {
      do {
        const feedId = rs.getLong(rs.getColumnIndex('feed_id'));
        const count = rs.getLong(rs.getColumnIndex('c'));
        result.set(feedId, count);
      } while (rs.goToNextRow());
    }
    rs.close();
    return result;
  }

  // Subscribe to a feed by URL. Transport (RSS fetch + metadata) is deferred;
  // here we create the row so the data path resolves and a subscription shows.
  async subscribeByUrl(url: string): Promise<number> {
    const feed = new Feed();
    feed.downloadUrl = url;
    feed.title = url;
    feed.state = FeedState.SUBSCRIBED;
    return this.addFeed(feed);
  }
}
