import { relationalStore } from '@kit.ArkData';
import { PodcastDatabase } from '../db/PodcastDatabase';
import { EventBus, EventType, EventPayload } from '../event/EventBus';
import { RowMappers } from './RowMappers';
import { FeedItem, EpisodeFilter, SortOrder } from '../../model/EpisodeModel';

const EPISODES_PER_PAGE: number = 150;
const SEARCH_MAX_RESULTS: number = 300;

// Owns the FeedItem table. Single read/write entry point for episode data.
// Writes publish EPISODE_UPDATED so every subscribed page re-queries.
export class EpisodeRepository {
  private static instance: EpisodeRepository | null = null;

  private constructor() {
  }

  static getInstance(): EpisodeRepository {
    if (EpisodeRepository.instance === null) {
      EpisodeRepository.instance = new EpisodeRepository();
    }
    return EpisodeRepository.instance;
  }

  private async getStore(): Promise<relationalStore.RdbStore> {
    return PodcastDatabase.getInstance().getStore();
  }

  // Builds the WHERE clause from an EpisodeFilter. Returns empty string when
  // the filter enables no dimension (matches "all episodes").
  private buildWhere(filter: EpisodeFilter): string {
    const clauses: string[] = [];
    if (filter.unplayed) {
      clauses.push('read = 0');
    }
    if (filter.played) {
      clauses.push('read = 1');
    }
    if (filter.downloaded) {
      clauses.push('downloaded = 1');
    }
    if (filter.notDownloaded) {
      clauses.push('downloaded = 0');
    }
    if (filter.favorite) {
      clauses.push('is_favorite = 1');
    }
    if (filter.inHistory) {
      clauses.push('in_history = 1');
    }
    if (filter.inQueue) {
      clauses.push('fi.id IN (SELECT feeditem_id FROM Queue)');
    }
    if (filter.feedId > 0) {
      clauses.push('feed_id = ' + filter.feedId.toString());
    }
    if (clauses.length === 0) {
      return '';
    }
    return ' WHERE ' + clauses.join(' AND ');
  }

  private buildOrderBy(sort: number): string {
    if (sort === SortOrder.DATE_OLD_NEW) {
      return ' ORDER BY pub_date_ms ASC';
    }
    if (sort === SortOrder.DURATION_SHORT_LONG) {
      return ' ORDER BY media_duration ASC';
    }
    if (sort === SortOrder.DURATION_LONG_SHORT) {
      return ' ORDER BY media_duration DESC';
    }
    if (sort === SortOrder.TITLE_A_Z) {
      return ' ORDER BY title COLLATE NOCASE ASC';
    }
    if (sort === SortOrder.TITLE_Z_A) {
      return ' ORDER BY title COLLATE NOCASE DESC';
    }
    return ' ORDER BY pub_date_ms DESC'; // DATE_NEW_OLD (default)
  }

  // Manual whitespace tokenizer (no regex literals).
  private tokenize(text: string): string[] {
    const words: string[] = [];
    let current: string = '';
    const len = text.length;
    for (let i = 0; i < len; i++) {
      const ch = text.charAt(i);
      if (ch === ' ' || ch === '\t' || ch === '\n' || ch === '\r') {
        if (current.length > 0) {
          words.push(current);
          current = '';
        }
      } else {
        current += ch;
      }
    }
    if (current.length > 0) {
      words.push(current);
    }
    return words;
  }

  // Paged episode read joined with the feed title for display.
  async getEpisodes(filter: EpisodeFilter, sort: number, page: number): Promise<FeedItem[]> {
    const store = await this.getStore();
    const offset = Math.max(0, (page - 1) * EPISODES_PER_PAGE);
    const sql = 'SELECT fi.*, f.title AS feed_title, ' +
      'EXISTS (SELECT 1 FROM Queue q WHERE q.feeditem_id = fi.id) AS in_queue ' +
      'FROM FeedItem fi LEFT JOIN Feed f ON f.id = fi.feed_id' +
      this.buildWhere(filter) +
      this.buildOrderBy(sort) +
      ' LIMIT ' + EPISODES_PER_PAGE.toString() + ' OFFSET ' + offset.toString();
    const rs = await store.querySql(sql);
    const items = RowMappers.collectFeedItems(rs);
    rs.close();
    return items;
  }

  // Total episode count for a filter (pagination "hasMore" + counters).
  async getTotalCount(filter: EpisodeFilter): Promise<number> {
    const store = await this.getStore();
    const sql = 'SELECT COUNT(*) AS c FROM FeedItem fi' + this.buildWhere(filter);
    const rs = await store.querySql(sql);
    let count = 0;
    if (rs.goToFirstRow()) {
      count = rs.getLong(rs.getColumnIndex('c'));
    }
    rs.close();
    return count;
  }

  // Home screen: most recently published unplayed episodes.
  async getRecentlyPublished(limit: number): Promise<FeedItem[]> {
    const store = await this.getStore();
    const filter = new EpisodeFilter();
    filter.unplayed = true;
    const sql = 'SELECT fi.*, f.title AS feed_title, ' +
      'EXISTS (SELECT 1 FROM Queue q WHERE q.feeditem_id = fi.id) AS in_queue ' +
      'FROM FeedItem fi LEFT JOIN Feed f ON f.id = fi.feed_id' +
      this.buildWhere(filter) +
      this.buildOrderBy(SortOrder.DATE_NEW_OLD) +
      ' LIMIT ' + limit.toString();
    const rs = await store.querySql(sql);
    const items = RowMappers.collectFeedItems(rs);
    rs.close();
    return items;
  }

  async getEpisode(id: number): Promise<FeedItem | null> {
    const store = await this.getStore();
    const rs = await store.querySql(
      'SELECT fi.*, f.title AS feed_title, ' +
      'EXISTS (SELECT 1 FROM Queue q WHERE q.feeditem_id = fi.id) AS in_queue ' +
      'FROM FeedItem fi LEFT JOIN Feed f ON f.id = fi.feed_id WHERE fi.id = ' + id.toString());
    let item: FeedItem | null = null;
    if (rs.goToFirstRow()) {
      item = RowMappers.toFeedItem(rs);
    }
    rs.close();
    return item;
  }

  // Search via SQL LIKE, multi-word AND-combined, newest first, capped.
  // FTS5 is an optimization only; LIKE is the correctness path (decision contract).
  // When feedId > 0, results are scoped to that single feed (REQ-028 场景 2.4).
  async search(query: string, max: number, feedId?: number): Promise<FeedItem[]> {
    const trimmed = query.trim();
    if (trimmed.length === 0) {
      return [];
    }
    const limit = max > 0 ? max : SEARCH_MAX_RESULTS;
    const words = this.tokenize(trimmed);
    if (words.length === 0) {
      return [];
    }
    const store = await this.getStore();
    const clauses: string[] = [];
    const bindArgs: Array<relationalStore.ValueType> = [];
    for (let i = 0; i < words.length; i++) {
      const token = '%' + words[i] + '%';
      clauses.push('(LOWER(title) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?))');
      bindArgs.push(token);
      bindArgs.push(token);
    }
    let scopeClause = '';
    if (feedId !== undefined && feedId > 0) {
      scopeClause = ' AND fi.feed_id = ?';
      bindArgs.push(feedId);
    }
    const sql = 'SELECT fi.*, f.title AS feed_title, ' +
      'EXISTS (SELECT 1 FROM Queue q WHERE q.feeditem_id = fi.id) AS in_queue ' +
      'FROM FeedItem fi LEFT JOIN Feed f ON f.id = fi.feed_id WHERE ' + clauses.join(' AND ') +
      scopeClause +
      ' ORDER BY pub_date_ms DESC LIMIT ' + limit.toString();
    const rs = await store.querySql(sql, bindArgs);
    const items = RowMappers.collectFeedItems(rs);
    rs.close();
    return items;
  }

  // ---- Writes (each publishes EPISODE_UPDATED) ----

  async setRead(id: number, read: boolean): Promise<void> {
    const store = await this.getStore();
    const value = read ? 1 : 0;
    await store.executeSql(
      'UPDATE FeedItem SET read = ' + value.toString() + ' WHERE id = ' + id.toString());
    EventBus.publish(EventType.EPISODE_UPDATED, this.payload(id));
  }

  async setDownloaded(id: number, downloaded: boolean): Promise<void> {
    const store = await this.getStore();
    const value = downloaded ? 1 : 0;
    await store.executeSql(
      'UPDATE FeedItem SET downloaded = ' + value.toString() + ' WHERE id = ' + id.toString());
    EventBus.publish(EventType.EPISODE_UPDATED, this.payload(id));
  }

  async setFavorite(id: number, favorite: boolean): Promise<void> {
    const store = await this.getStore();
    const value = favorite ? 1 : 0;
    await store.executeSql(
      'UPDATE FeedItem SET is_favorite = ' + value.toString() + ' WHERE id = ' + id.toString());
    EventBus.publish(EventType.EPISODE_UPDATED, this.payload(id));
  }

  async setMediaPosition(id: number, positionMs: number, completion: number): Promise<void> {
    const store = await this.getStore();
    await store.executeSql(
      'UPDATE FeedItem SET media_position = ' + positionMs.toString() +
      ', played_completion = ' + completion.toString() + ' WHERE id = ' + id.toString());
    EventBus.publish(EventType.PLAYBACK_POSITION, this.payload(id));
  }

  // Inbox "remove all": clear the new/unplayed flag on every FeedItem.
  async removeAllNewFlags(): Promise<void> {
    const store = await this.getStore();
    await store.executeSql('UPDATE FeedItem SET read = 1 WHERE read = 0');
    EventBus.publish(EventType.EPISODE_UPDATED, new EventPayload());
    EventBus.publish(EventType.MESSAGE_EVENT, this.message('removed_all_inbox_msg'));
  }

  async markAllRead(): Promise<void> {
    const store = await this.getStore();
    await store.executeSql('UPDATE FeedItem SET read = 1');
    EventBus.publish(EventType.EPISODE_UPDATED, new EventPayload());
  }

  // Insert a feed item row (used by the stub FeedUpdateService / OPML import).
  async insertFeedItem(item: FeedItem): Promise<number> {
    const store = await this.getStore();
    const bucket: relationalStore.ValuesBucket = {
      feed_id: item.feedId,
      title: item.title,
      description: item.description,
      link: item.link,
      pub_date: item.pubDate,
      pub_date_ms: item.pubDateMs,
      image_url: item.imageUrl,
      media_duration: item.media !== null ? item.media.duration : 0,
      media_position: item.media !== null ? item.media.position : 0,
      media_size: item.media !== null ? item.media.size : 0,
      mime_type: item.media !== null ? item.media.mimeType : '',
      media_download_url: item.mediaDownloadUrl,
      read: 0,
      downloaded: 0,
      auto_download: item.autoDownload ? 1 : 0,
      is_favorite: 0,
      in_history: 0,
      played_completion: 0,
      video: 0
    } as relationalStore.ValuesBucket;
    const newId = await store.insert('FeedItem', bucket);
    EventBus.publish(EventType.EPISODE_UPDATED, this.payload(newId));
    return newId;
  }

  private payload(id: number): EventPayload {
    const p = new EventPayload();
    p.feedItemId = id;
    return p;
  }

  private message(msg: string): EventPayload {
    const p = new EventPayload();
    p.message = msg;
    return p;
  }

  static getPageSize(): number {
    return EPISODES_PER_PAGE;
  }
}
