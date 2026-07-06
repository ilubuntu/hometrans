import { relationalStore } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { EpisodeData, SecondaryActionType, DownloadState } from '../../model/EpisodeData';
import { FeedData } from '../../model/FeedData';
import { SampleData, SampleFeed, SampleEpisode, SampleQueueEntry } from './SampleData';
import { eventBus, AppEvent, EpisodePayload, DownloadPayload } from '../event/EventBus';
import { preferencesStore } from './PreferencesStore';

export type EpisodeFilter = string;
export type SortOrder = 'date_desc' | 'date_asc';

class RepositoryImpl {
  private feeds: Map<string, FeedData> = new Map<string, FeedData>();
  private episodes: Map<string, EpisodeData> = new Map<string, EpisodeData>();
  private queueOrder: string[] = [];
  private favorites: Set<string> = new Set<string>();
  private downloadStates: Map<string, DownloadState> = new Map<string, DownloadState>();
  private downloadProgress: Map<string, number> = new Map<string, number>();
  private history: string[] = [];
  private historyPositions: Map<string, number> = new Map<string, number>();
  private historyTimes: Map<string, number> = new Map<string, number>();
  private feedTagMap: Map<string, string[]> = new Map<string, string[]>();

  ready: boolean = false;
  private store: relationalStore.RdbStore | null = null;

  async init(context: common.Context): Promise<void> {
    if (this.ready) {
      return;
    }
    try {
      this.store = await this.openStore(context);
      await this.loadAllFromDb();
      const firstLaunch: boolean = !(await preferencesStore.getBoolean('firstLaunchDone', false));
      if (firstLaunch && this.feeds.size === 0) {
        await this.seedFromSample();
        await preferencesStore.putBoolean('firstLaunchDone', true);
      }
    } catch (e) {
      console.error(`Repository.init failed: ${e}`);
      if (this.feeds.size === 0) {
        await this.seedFromSample();
      }
    }
    this.ready = true;
  }

  private async openStore(context: common.Context): Promise<relationalStore.RdbStore> {
    const config: relationalStore.StoreConfig = {
      name: 'antennapod.db',
      securityLevel: relationalStore.SecurityLevel.S1
    } as relationalStore.StoreConfig;
    const store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, config);
    if (store.version === 0) {
      store.version = 1;
    }
    await this.runSchema(store);
    return store;
  }

  private async runSchema(store: relationalStore.RdbStore): Promise<void> {
    const stmts: string[] = this.schemaStatements();
    for (let i = 0; i < stmts.length; i++) {
      await store.executeSql(stmts[i]);
    }
  }

  private schemaStatements(): string[] {
    const out: string[] = [];
    out.push(`CREATE TABLE IF NOT EXISTS feeds (id TEXT PRIMARY KEY, title TEXT NOT NULL, author TEXT, description TEXT, cover_key TEXT, feed_url TEXT, support_url TEXT, subscribed INTEGER NOT NULL DEFAULT 1, last_update_failed INTEGER NOT NULL DEFAULT 0, last_update_ms INTEGER NOT NULL DEFAULT 0, tags TEXT)`);
    out.push(`CREATE TABLE IF NOT EXISTS episodes (id TEXT PRIMARY KEY, feed_id TEXT NOT NULL, title TEXT NOT NULL, author TEXT, pub_date TEXT, pub_date_ms INTEGER NOT NULL DEFAULT 0, duration_sec INTEGER NOT NULL DEFAULT 0, position_sec INTEGER NOT NULL DEFAULT 0, size_bytes INTEGER NOT NULL DEFAULT 0, is_inbox INTEGER NOT NULL DEFAULT 0, is_new INTEGER NOT NULL DEFAULT 0, is_played INTEGER NOT NULL DEFAULT 0, is_video INTEGER NOT NULL DEFAULT 0, is_favorite INTEGER NOT NULL DEFAULT 0, in_queue INTEGER NOT NULL DEFAULT 0, download_state TEXT NOT NULL DEFAULT 'NONE', download_progress INTEGER NOT NULL DEFAULT 0, downloaded_at INTEGER NOT NULL DEFAULT 0, media_url TEXT, website_url TEXT, shownotes TEXT, tags TEXT)`);
    out.push(`CREATE TABLE IF NOT EXISTS queue (episode_id TEXT PRIMARY KEY, position INTEGER NOT NULL)`);
    out.push(`CREATE TABLE IF NOT EXISTS downloads (episode_id TEXT PRIMARY KEY, state TEXT NOT NULL, percent INTEGER NOT NULL DEFAULT 0, completed_at INTEGER NOT NULL DEFAULT 0)`);
    out.push(`CREATE TABLE IF NOT EXISTS favorites (episode_id TEXT PRIMARY KEY, added_at INTEGER NOT NULL DEFAULT 0)`);
    out.push(`CREATE TABLE IF NOT EXISTS playback_history (episode_id TEXT PRIMARY KEY, feed_id TEXT, played_at INTEGER NOT NULL DEFAULT 0, position_sec INTEGER NOT NULL DEFAULT 0)`);
    out.push(`CREATE TABLE IF NOT EXISTS feed_tags (feed_id TEXT NOT NULL, tag TEXT NOT NULL, PRIMARY KEY (feed_id, tag))`);
    out.push(`CREATE INDEX IF NOT EXISTS idx_episodes_feed ON episodes(feed_id)`);
    out.push(`CREATE INDEX IF NOT EXISTS idx_episodes_pubdate ON episodes(pub_date_ms)`);
    return out;
  }

  private async loadAllFromDb(): Promise<void> {
    if (!this.store) {
      return;
    }
    await this.loadFeeds();
    await this.loadEpisodes();
    await this.loadQueue();
    await this.loadFavorites();
    await this.loadDownloads();
    await this.loadHistory();
    await this.loadFeedTags();
    this.refreshFeedCounts();
  }

  private async loadFeeds(): Promise<void> {
    if (!this.store) {
      return;
    }
    const pred: relationalStore.RdbPredicates = new relationalStore.RdbPredicates('feeds');
    const rs: relationalStore.ResultSet = await this.store.query(pred);
    while (rs.goToNextRow()) {
      const id: string = rs.getString(rs.getColumnIndex('id'));
      const title: string = rs.getString(rs.getColumnIndex('title'));
      const feed: FeedData = new FeedData(id, title, 0, SampleData.coverForFeed(id));
      feed.author = this.readStr(rs, 'author');
      feed.description = this.readStr(rs, 'description');
      feed.feedUrl = this.readStr(rs, 'feed_url');
      feed.supportUrl = this.readStr(rs, 'support_url');
      feed.subscribed = rs.getLong(rs.getColumnIndex('subscribed')) === 1;
      feed.lastUpdateFailed = rs.getLong(rs.getColumnIndex('last_update_failed')) === 1;
      feed.hasUpdateFailed = feed.lastUpdateFailed;
      feed.lastUpdateMs = rs.getLong(rs.getColumnIndex('last_update_ms'));
      feed.tags = this.parseTags(this.readStr(rs, 'tags'));
      this.feeds.set(id, feed);
    }
    rs.close();
  }

  private async loadEpisodes(): Promise<void> {
    if (!this.store) {
      return;
    }
    const pred: relationalStore.RdbPredicates = new relationalStore.RdbPredicates('episodes');
    pred.orderByDesc('pub_date_ms');
    const rs: relationalStore.ResultSet = await this.store.query(pred);
    while (rs.goToNextRow()) {
      const ep: EpisodeData = this.readEpisode(rs);
      this.episodes.set(ep.id, ep);
    }
    rs.close();
  }

  private async loadQueue(): Promise<void> {
    if (!this.store) {
      return;
    }
    const pred: relationalStore.RdbPredicates = new relationalStore.RdbPredicates('queue');
    pred.orderByAsc('position');
    const rs: relationalStore.ResultSet = await this.store.query(pred);
    const ids: string[] = [];
    while (rs.goToNextRow()) {
      ids.push(rs.getString(rs.getColumnIndex('episode_id')));
    }
    rs.close();
    this.queueOrder = ids;
    for (let i = 0; i < this.queueOrder.length; i++) {
      const ep: EpisodeData | undefined = this.episodes.get(this.queueOrder[i]);
      if (ep) {
        ep.inQueue = true;
      }
    }
  }

  private async loadFavorites(): Promise<void> {
    if (!this.store) {
      return;
    }
    const pred: relationalStore.RdbPredicates = new relationalStore.RdbPredicates('favorites');
    const rs: relationalStore.ResultSet = await this.store.query(pred);
    const ids: string[] = [];
    while (rs.goToNextRow()) {
      ids.push(rs.getString(rs.getColumnIndex('episode_id')));
    }
    rs.close();
    for (let i = 0; i < ids.length; i++) {
      this.favorites.add(ids[i]);
      const ep: EpisodeData | undefined = this.episodes.get(ids[i]);
      if (ep) {
        ep.isFavorite = true;
      }
    }
  }

  private async loadDownloads(): Promise<void> {
    if (!this.store) {
      return;
    }
    const pred: relationalStore.RdbPredicates = new relationalStore.RdbPredicates('downloads');
    const rs: relationalStore.ResultSet = await this.store.query(pred);
    while (rs.goToNextRow()) {
      const id: string = rs.getString(rs.getColumnIndex('episode_id'));
      const stateStr: string = rs.getString(rs.getColumnIndex('state'));
      const percent: number = rs.getLong(rs.getColumnIndex('percent'));
      const state: DownloadState = this.parseDownloadState(stateStr);
      this.downloadStates.set(id, state);
      this.downloadProgress.set(id, percent);
      const ep: EpisodeData | undefined = this.episodes.get(id);
      if (ep) {
        ep.downloadState = state;
        ep.downloadProgress = percent;
        ep.secondaryAction = this.secondaryActionForState(ep, state);
      }
    }
    rs.close();
  }

  private async loadHistory(): Promise<void> {
    if (!this.store) {
      return;
    }
    const pred: relationalStore.RdbPredicates = new relationalStore.RdbPredicates('playback_history');
    pred.orderByDesc('played_at');
    const rs: relationalStore.ResultSet = await this.store.query(pred);
    const ids: string[] = [];
    while (rs.goToNextRow()) {
      const id: string = rs.getString(rs.getColumnIndex('episode_id'));
      ids.push(id);
      this.historyPositions.set(id, rs.getLong(rs.getColumnIndex('position_sec')));
      this.historyTimes.set(id, rs.getLong(rs.getColumnIndex('played_at')));
    }
    rs.close();
    this.history = ids;
  }

  private async loadFeedTags(): Promise<void> {
    if (!this.store) {
      return;
    }
    const pred: relationalStore.RdbPredicates = new relationalStore.RdbPredicates('feed_tags');
    const rs: relationalStore.ResultSet = await this.store.query(pred);
    while (rs.goToNextRow()) {
      const feedId: string = rs.getString(rs.getColumnIndex('feed_id'));
      const tag: string = rs.getString(rs.getColumnIndex('tag'));
      let arr: string[] | undefined = this.feedTagMap.get(feedId);
      if (!arr) {
        arr = [];
        this.feedTagMap.set(feedId, arr);
      }
      arr.push(tag);
    }
    rs.close();
  }

  private readEpisode(rs: relationalStore.ResultSet): EpisodeData {
    const id: string = rs.getString(rs.getColumnIndex('id'));
    const title: string = rs.getString(rs.getColumnIndex('title'));
    const feedId: string = rs.getString(rs.getColumnIndex('feed_id'));
    const ep: EpisodeData = new EpisodeData(id, title);
    ep.feedId = feedId;
    ep.author = this.readStr(rs, 'author');
    ep.cover = SampleData.coverForFeed(feedId);
    ep.pubDate = this.readStr(rs, 'pub_date');
    ep.pubDateDesc = ep.pubDate;
    ep.pubDateMs = rs.getLong(rs.getColumnIndex('pub_date_ms'));
    ep.durationSec = rs.getLong(rs.getColumnIndex('duration_sec'));
    ep.positionSec = rs.getLong(rs.getColumnIndex('position_sec'));
    ep.sizeBytes = rs.getLong(rs.getColumnIndex('size_bytes'));
    ep.sizeText = SampleData.formatSize(ep.sizeBytes);
    ep.duration = SampleData.formatClock(ep.durationSec);
    ep.position = SampleData.formatClock(ep.positionSec);
    ep.durationDesc = SampleData.formatDurationDesc(ep.durationSec);
    ep.positionDesc = `Position: ${ep.position}`;
    ep.progress = ep.durationSec > 0 ? Math.min(100, Math.floor((ep.positionSec / ep.durationSec) * 100)) : 0;
    ep.isInbox = rs.getLong(rs.getColumnIndex('is_inbox')) === 1;
    ep.isNew = rs.getLong(rs.getColumnIndex('is_new')) === 1;
    ep.isPlayed = rs.getLong(rs.getColumnIndex('is_played')) === 1;
    ep.isVideo = rs.getLong(rs.getColumnIndex('is_video')) === 1;
    ep.isFavorite = rs.getLong(rs.getColumnIndex('is_favorite')) === 1 || this.favorites.has(id);
    ep.inQueue = rs.getLong(rs.getColumnIndex('in_queue')) === 1;
    const stateStr: string = this.readStr(rs, 'download_state');
    ep.downloadState = this.parseDownloadState(stateStr);
    ep.downloadProgress = rs.getLong(rs.getColumnIndex('download_progress'));
    ep.downloadedAt = rs.getLong(rs.getColumnIndex('downloaded_at'));
    ep.mediaUrl = this.readStr(rs, 'media_url');
    ep.websiteUrl = this.readStr(rs, 'website_url');
    ep.tags = this.parseTags(this.readStr(rs, 'tags'));
    ep.secondaryAction = this.secondaryActionForState(ep, ep.downloadState);
    return ep;
  }

  private readStr(rs: relationalStore.ResultSet, col: string): string {
    const idx: number = rs.getColumnIndex(col);
    if (idx < 0) {
      return '';
    }
    if (rs.isColumnNull(idx)) {
      return '';
    }
    return rs.getString(idx);
  }

  private parseTags(s: string): string[] {
    if (!s || s.length === 0) {
      return [];
    }
    const parts: string[] = s.split('|');
    const out: string[] = [];
    for (let i = 0; i < parts.length; i++) {
      const t: string = parts[i].trim();
      if (t.length > 0) {
        out.push(t);
      }
    }
    return out;
  }

  private parseDownloadState(s: string): DownloadState {
    if (s === 'QUEUED') return DownloadState.QUEUED;
    if (s === 'DOWNLOADING') return DownloadState.DOWNLOADING;
    if (s === 'DOWNLOADED') return DownloadState.DOWNLOADED;
    if (s === 'CANCELED') return DownloadState.CANCELED;
    if (s === 'FAILED') return DownloadState.FAILED;
    return DownloadState.NONE;
  }

  private secondaryActionForState(ep: EpisodeData, state: DownloadState): SecondaryActionType {
    if (state === DownloadState.DOWNLOADING) return SecondaryActionType.CANCEL_DOWNLOAD;
    if (ep.positionSec > 0 || state === DownloadState.DOWNLOADED) return SecondaryActionType.PLAY;
    return SecondaryActionType.DOWNLOAD;
  }

  private serializeTags(tags: string[]): string {
    return tags.join('|');
  }

  async seedFromSample(): Promise<void> {
    const feeds: SampleFeed[] = SampleData.feeds();
    const episodes: SampleEpisode[] = SampleData.episodes();
    const queue: SampleQueueEntry[] = SampleData.queue();
    for (let i = 0; i < feeds.length; i++) {
      const f: SampleFeed = feeds[i];
      const feed: FeedData = SampleData.toFeedData(f);
      this.feeds.set(f.id, feed);
      this.feedTagMap.set(f.id, f.tags.slice());
      await this.upsertFeedRow(f);
    }
    for (let i = 0; i < episodes.length; i++) {
      const spec: SampleEpisode = episodes[i];
      const ep: EpisodeData = SampleData.toEpisodeData(spec);
      this.episodes.set(spec.id, ep);
      if (spec.isFavorite) {
        this.favorites.add(spec.id);
      }
      await this.upsertEpisodeRow(spec);
      if (spec.isFavorite) {
        await this.putFavoriteRow(spec.id);
      }
    }
    this.queueOrder = [];
    for (let i = 0; i < queue.length; i++) {
      const entry = queue[i];
      this.queueOrder.push(entry.episodeId);
      await this.putQueueRow(entry.episodeId, entry.position);
    }
    this.refreshFeedCounts();
  }

  private refreshFeedCounts(): void {
    const feedIds: string[] = Array.from(this.feeds.keys());
    for (let i = 0; i < feedIds.length; i++) {
      const feedId: string = feedIds[i];
      const feed: FeedData | undefined = this.feeds.get(feedId);
      if (!feed) continue;
      let total: number = 0;
      let isNew: number = 0;
      let unplayed: number = 0;
      const epIds: string[] = Array.from(this.episodes.keys());
      for (let j = 0; j < epIds.length; j++) {
        const ep: EpisodeData | undefined = this.episodes.get(epIds[j]);
        if (!ep || ep.feedId !== feedId) continue;
        total++;
        if (ep.isNew) isNew++;
        if (!ep.isPlayed) unplayed++;
      }
      feed.count = total;
      feed.isNewCount = isNew;
      feed.unplayedCount = unplayed;
    }
  }

  // ---------- DB upsert helpers (best-effort write-through) ----------

  private async upsertFeedRow(spec: SampleFeed): Promise<void> {
    if (!this.store) return;
    try {
      const tagsStr: string = this.serializeTags(spec.tags);
      await this.store.executeSql(
        `INSERT OR REPLACE INTO feeds (id,title,author,description,cover_key,feed_url,support_url,subscribed,last_update_failed,last_update_ms,tags) VALUES (?,?,?,?,?,?,?,?,?,?,?)`,
        [spec.id, spec.title, spec.author, spec.description, spec.coverKey, spec.feedUrl, spec.supportUrl, spec.subscribed ? 1 : 0, 0, 0, tagsStr]
      );
      await this.replaceFeedTagRows(spec.id, spec.tags);
    } catch (e) {
      console.error(`upsertFeedRow failed: ${e}`);
    }
  }

  private async upsertFeedRowFromData(feed: FeedData): Promise<void> {
    if (!this.store) return;
    try {
      const tagsStr: string = this.serializeTags(feed.tags);
      await this.store.executeSql(
        `INSERT OR REPLACE INTO feeds (id,title,author,description,cover_key,feed_url,support_url,subscribed,last_update_failed,last_update_ms,tags) VALUES (?,?,?,?,?,?,?,?,?,?,?)`,
        [feed.id, feed.title, feed.author, feed.description, 'ic_feed', feed.feedUrl, feed.supportUrl, feed.subscribed ? 1 : 0, feed.lastUpdateFailed ? 1 : 0, feed.lastUpdateMs, tagsStr]
      );
    } catch (e) {
      console.error(`upsertFeedRowFromData failed: ${e}`);
    }
  }

  private async upsertEpisodeRow(spec: SampleEpisode): Promise<void> {
    if (!this.store) return;
    try {
      await this.store.executeSql(
        `INSERT OR REPLACE INTO episodes (id,feed_id,title,author,pub_date,pub_date_ms,duration_sec,position_sec,size_bytes,is_inbox,is_new,is_played,is_video,is_favorite,in_queue,download_state,download_progress,downloaded_at,media_url,website_url,shownotes,tags) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`,
        [spec.id, spec.feedId, spec.title, spec.author, spec.pubDate, spec.pubDateMs, spec.durationSec, spec.positionSec, spec.sizeBytes, spec.isInbox ? 1 : 0, spec.isNew ? 1 : 0, spec.isPlayed ? 1 : 0, spec.isVideo ? 1 : 0, spec.isFavorite ? 1 : 0, spec.inQueue ? 1 : 0, spec.downloadState, spec.downloadProgress, 0, spec.mediaUrl, spec.websiteUrl, spec.shownotes, '']
      );
    } catch (e) {
      console.error(`upsertEpisodeRow failed: ${e}`);
    }
  }

  private async persistEpisode(ep: EpisodeData): Promise<void> {
    if (!this.store) return;
    try {
      await this.store.executeSql(
        `INSERT OR REPLACE INTO episodes (id,feed_id,title,author,pub_date,pub_date_ms,duration_sec,position_sec,size_bytes,is_inbox,is_new,is_played,is_video,is_favorite,in_queue,download_state,download_progress,downloaded_at,media_url,website_url,shownotes,tags) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)`,
        [ep.id, ep.feedId, ep.title, ep.author, ep.pubDate, ep.pubDateMs, ep.durationSec, ep.positionSec, ep.sizeBytes, ep.isInbox ? 1 : 0, ep.isNew ? 1 : 0, ep.isPlayed ? 1 : 0, ep.isVideo ? 1 : 0, this.favorites.has(ep.id) ? 1 : 0, ep.inQueue ? 1 : 0, ep.downloadState, ep.downloadProgress, ep.downloadedAt, ep.mediaUrl, ep.websiteUrl, '', this.serializeTags(ep.tags)]
      );
    } catch (e) {
      console.error(`persistEpisode failed: ${e}`);
    }
  }

  private async putFavoriteRow(id: string): Promise<void> {
    if (!this.store) return;
    try {
      await this.store.executeSql(`INSERT OR REPLACE INTO favorites (episode_id, added_at) VALUES (?,?)`, [id, Date.now()]);
    } catch (e) {
      console.error(`putFavoriteRow failed: ${e}`);
    }
  }

  private async removeFavoriteRow(id: string): Promise<void> {
    if (!this.store) return;
    try {
      await this.store.executeSql(`DELETE FROM favorites WHERE episode_id = ?`, [id]);
    } catch (e) {
      console.error(`removeFavoriteRow failed: ${e}`);
    }
  }

  private async putQueueRow(id: string, position: number): Promise<void> {
    if (!this.store) return;
    try {
      await this.store.executeSql(`INSERT OR REPLACE INTO queue (episode_id, position) VALUES (?,?)`, [id, position]);
    } catch (e) {
      console.error(`putQueueRow failed: ${e}`);
    }
  }

  private async removeQueueRow(id: string): Promise<void> {
    if (!this.store) return;
    try {
      await this.store.executeSql(`DELETE FROM queue WHERE episode_id = ?`, [id]);
    } catch (e) {
      console.error(`removeQueueRow failed: ${e}`);
    }
  }

  private async clearQueueRows(): Promise<void> {
    if (!this.store) return;
    try {
      await this.store.executeSql(`DELETE FROM queue`, []);
    } catch (e) {
      console.error(`clearQueueRows failed: ${e}`);
    }
  }

  private async putDownloadRow(id: string, state: string, percent: number): Promise<void> {
    if (!this.store) return;
    try {
      await this.store.executeSql(`INSERT OR REPLACE INTO downloads (episode_id, state, percent, completed_at) VALUES (?,?,?,?)`, [id, state, percent, state === 'DOWNLOADED' ? Date.now() : 0]);
    } catch (e) {
      console.error(`putDownloadRow failed: ${e}`);
    }
  }

  private async putHistoryRow(id: string, feedId: string, positionSec: number): Promise<void> {
    if (!this.store) return;
    try {
      await this.store.executeSql(`INSERT OR REPLACE INTO playback_history (episode_id, feed_id, played_at, position_sec) VALUES (?,?,?,?)`, [id, feedId, Date.now(), positionSec]);
    } catch (e) {
      console.error(`putHistoryRow failed: ${e}`);
    }
  }

  private async replaceFeedTagRows(feedId: string, tags: string[]): Promise<void> {
    if (!this.store) return;
    try {
      await this.store.executeSql(`DELETE FROM feed_tags WHERE feed_id = ?`, [feedId]);
      for (let i = 0; i < tags.length; i++) {
        await this.store.executeSql(`INSERT OR IGNORE INTO feed_tags (feed_id, tag) VALUES (?,?)`, [feedId, tags[i]]);
      }
    } catch (e) {
      console.error(`replaceFeedTagRows failed: ${e}`);
    }
  }

  private async deleteEpisodeRow(id: string): Promise<void> {
    if (!this.store) return;
    try {
      await this.store.executeSql(`DELETE FROM episodes WHERE id = ?`, [id]);
    } catch (e) {
      console.error(`deleteEpisodeRow failed: ${e}`);
    }
  }

  private async deleteFeedRow(id: string): Promise<void> {
    if (!this.store) return;
    try {
      await this.store.executeSql(`DELETE FROM feeds WHERE id = ?`, [id]);
    } catch (e) {
      console.error(`deleteFeedRow failed: ${e}`);
    }
  }

  // ---------- Queries (synchronous reads from cache) ----------

  getFeed(id: string): FeedData | undefined {
    return this.feeds.get(id);
  }

  getEpisode(id: string): EpisodeData | undefined {
    return this.episodes.get(id);
  }

  queryFeeds(): FeedData[] {
    return Array.from(this.feeds.values());
  }

  queryEpisodes(filter: string[], sort: SortOrder, feedId?: string): EpisodeData[] {
    let list: EpisodeData[] = Array.from(this.episodes.values());
    if (feedId && feedId.length > 0) {
      list = list.filter((ep: EpisodeData): boolean => ep.feedId === feedId);
    }
    if (filter.length > 0) {
      list = list.filter((ep: EpisodeData): boolean => this.matchesEpisodeFilter(ep, filter));
    }
    list = this.sortEpisodes(list, sort);
    return list;
  }

  private matchesEpisodeFilter(ep: EpisodeData, filter: string[]): boolean {
    for (let i = 0; i < filter.length; i++) {
      const f: string = filter[i];
      if (f === 'played' && ep.progress <= 0) return false;
      if (f === 'unplayed' && ep.progress > 0) return false;
      if (f === 'paused' && (ep.progress <= 0 || ep.progress >= 100)) return false;
      if (f === 'not_paused' && ep.progress > 0 && ep.progress < 100) return false;
      if (f === 'is_favorite' && !ep.isFavorite) return false;
      if (f === 'not_favorite' && ep.isFavorite) return false;
      if (f === 'no_media') return false;
      if (f === 'queued' && !ep.inQueue) return false;
      if (f === 'not_queued' && ep.inQueue) return false;
      if (f === 'downloaded' && ep.downloadState !== DownloadState.DOWNLOADED) return false;
      if (f === 'not_downloaded' && ep.downloadState === DownloadState.DOWNLOADED) return false;
    }
    return true;
  }

  private sortEpisodes(list: EpisodeData[], sort: SortOrder): EpisodeData[] {
    const sorted: EpisodeData[] = list.slice();
    if (sort === 'date_asc') {
      sorted.sort((a: EpisodeData, b: EpisodeData): number => a.pubDateMs - b.pubDateMs);
    } else {
      sorted.sort((a: EpisodeData, b: EpisodeData): number => b.pubDateMs - a.pubDateMs);
    }
    return sorted;
  }

  queryQueue(): EpisodeData[] {
    const out: EpisodeData[] = [];
    for (let i = 0; i < this.queueOrder.length; i++) {
      const ep: EpisodeData | undefined = this.episodes.get(this.queueOrder[i]);
      if (ep) {
        out.push(ep);
      }
    }
    return out;
  }

  queryInbox(sort?: SortOrder): EpisodeData[] {
    let list: EpisodeData[] = Array.from(this.episodes.values()).filter((ep: EpisodeData): boolean => ep.isNew);
    if (sort === 'date_asc') {
      list = list.slice().sort((a: EpisodeData, b: EpisodeData): number => a.pubDateMs - b.pubDateMs);
    } else {
      list = list.slice().sort((a: EpisodeData, b: EpisodeData): number => b.pubDateMs - a.pubDateMs);
    }
    return list;
  }

  queryFavorites(): EpisodeData[] {
    const ids: string[] = Array.from(this.favorites);
    const out: EpisodeData[] = [];
    for (let i = 0; i < ids.length; i++) {
      const ep: EpisodeData | undefined = this.episodes.get(ids[i]);
      if (ep) {
        out.push(ep);
      }
    }
    out.sort((a: EpisodeData, b: EpisodeData): number => b.pubDateMs - a.pubDateMs);
    return out;
  }

  queryDownloads(): EpisodeData[] {
    return Array.from(this.episodes.values()).filter((ep: EpisodeData): boolean =>
      ep.downloadState === DownloadState.DOWNLOADED || ep.downloadState === DownloadState.DOWNLOADING || ep.downloadState === DownloadState.QUEUED);
  }

  queryHistory(): EpisodeData[] {
    const out: EpisodeData[] = [];
    for (let i = 0; i < this.history.length; i++) {
      const ep: EpisodeData | undefined = this.episodes.get(this.history[i]);
      if (ep) {
        out.push(ep);
      }
    }
    return out;
  }

  search(query: string, feedId?: string): EpisodeData[] {
    const needle: string = query.trim().toLowerCase();
    if (needle.length === 0) {
      return [];
    }
    return Array.from(this.episodes.values()).filter((ep: EpisodeData): boolean => {
      if (feedId && feedId.length > 0 && ep.feedId !== feedId) {
        return false;
      }
      return ep.title.toLowerCase().includes(needle)
        || ep.author.toLowerCase().includes(needle);
    });
  }

  searchFeeds(query: string): FeedData[] {
    const needle: string = query.trim().toLowerCase();
    if (needle.length === 0) {
      return [];
    }
    return Array.from(this.feeds.values()).filter((f: FeedData): boolean =>
      f.title.toLowerCase().includes(needle) || f.author.toLowerCase().includes(needle));
  }

  countEpisodes(): number {
    return this.episodes.size;
  }

  newEpisodeCount(): number {
    let count: number = 0;
    const ids: string[] = Array.from(this.episodes.keys());
    for (let i = 0; i < ids.length; i++) {
      const ep: EpisodeData | undefined = this.episodes.get(ids[i]);
      if (ep && ep.isNew) {
        count++;
      }
    }
    return count;
  }

  queueRemainingSec(): number {
    let total: number = 0;
    for (let i = 0; i < this.queueOrder.length; i++) {
      const ep: EpisodeData | undefined = this.episodes.get(this.queueOrder[i]);
      if (ep) {
        total += Math.max(0, ep.durationSec - ep.positionSec);
      }
    }
    return total;
  }

  // ---------- Mutates (write-through + emit) ----------

  async subscribe(spec: SampleFeed, episodes: SampleEpisode[]): Promise<void> {
    if (this.feeds.has(spec.id)) {
      const existing: FeedData | undefined = this.feeds.get(spec.id);
      if (existing) {
        existing.subscribed = true;
        await this.upsertFeedRowFromData(existing);
      }
      eventBus.emit(AppEvent.FEEDS_CHANGED);
      return;
    }
    const feed: FeedData = SampleData.toFeedData(spec);
    feed.subscribed = true;
    this.feeds.set(spec.id, feed);
    this.feedTagMap.set(spec.id, spec.tags.slice());
    await this.upsertFeedRow(spec);
    for (let i = 0; i < episodes.length; i++) {
      const e: SampleEpisode = episodes[i];
      const ep: EpisodeData = SampleData.toEpisodeData(e);
      this.episodes.set(e.id, ep);
      await this.upsertEpisodeRow(e);
    }
    this.refreshFeedCounts();
    eventBus.emit(AppEvent.FEEDS_CHANGED);
    eventBus.emit(AppEvent.EPISODES_CHANGED, { feedId: spec.id } as EpisodePayload);
    eventBus.emit(AppEvent.INBOX_CHANGED);
  }

  async unsubscribe(feedId: string): Promise<void> {
    const feed: FeedData | undefined = this.feeds.get(feedId);
    if (!feed) {
      return;
    }
    this.feeds.delete(feedId);
    this.feedTagMap.delete(feedId);
    const epIds: string[] = Array.from(this.episodes.keys()).filter((id: string): boolean => {
      const ep: EpisodeData | undefined = this.episodes.get(id);
      return !!ep && ep.feedId === feedId;
    });
    for (let i = 0; i < epIds.length; i++) {
      this.episodes.delete(epIds[i]);
      await this.deleteEpisodeRow(epIds[i]);
      this.queueOrder = this.queueOrder.filter((qid: string): boolean => qid !== epIds[i]);
      await this.removeQueueRow(epIds[i]);
      this.favorites.delete(epIds[i]);
      await this.removeFavoriteRow(epIds[i]);
    }
    await this.deleteFeedRow(feedId);
    await this.replaceFeedTagRows(feedId, []);
    eventBus.emit(AppEvent.FEEDS_CHANGED);
    eventBus.emit(AppEvent.EPISODES_CHANGED);
    eventBus.emit(AppEvent.QUEUE_CHANGED);
    eventBus.emit(AppEvent.FAVORITES_CHANGED);
    eventBus.emit(AppEvent.INBOX_CHANGED);
  }

  async setFavorite(episodeId: string, favorite: boolean): Promise<void> {
    const ep: EpisodeData | undefined = this.episodes.get(episodeId);
    if (!ep) return;
    if (favorite) {
      this.favorites.add(episodeId);
      ep.isFavorite = true;
      await this.putFavoriteRow(episodeId);
    } else {
      this.favorites.delete(episodeId);
      ep.isFavorite = false;
      await this.removeFavoriteRow(episodeId);
    }
    await this.persistEpisode(ep);
    eventBus.emit(AppEvent.FAVORITES_CHANGED);
    eventBus.emit(AppEvent.EPISODES_CHANGED, { feedId: ep.feedId, episodeId } as EpisodePayload);
  }

  async enqueue(episodeId: string): Promise<void> {
    if (this.queueOrder.indexOf(episodeId) >= 0) {
      return;
    }
    const position: number = preferencesStore.getSync('enqueuePosition', 'BACK') === 'FRONT' ? 0 : this.queueOrder.length;
    if (position === 0) {
      this.queueOrder.unshift(episodeId);
    } else {
      this.queueOrder.push(episodeId);
    }
    await this.rewriteQueueRows();
    const ep: EpisodeData | undefined = this.episodes.get(episodeId);
    if (ep) {
      ep.inQueue = true;
      await this.persistEpisode(ep);
    }
    eventBus.emit(AppEvent.QUEUE_CHANGED);
  }

  async dequeue(episodeId: string): Promise<void> {
    this.queueOrder = this.queueOrder.filter((id: string): boolean => id !== episodeId);
    await this.removeQueueRow(episodeId);
    const ep: EpisodeData | undefined = this.episodes.get(episodeId);
    if (ep) {
      ep.inQueue = false;
      await this.persistEpisode(ep);
    }
    eventBus.emit(AppEvent.QUEUE_CHANGED);
  }

  async moveTo(from: number, to: number): Promise<void> {
    if (from < 0 || from >= this.queueOrder.length || to < 0 || to >= this.queueOrder.length) {
      return;
    }
    const moved: string | undefined = this.queueOrder.splice(from, 1)[0];
    if (moved === undefined) return;
    this.queueOrder.splice(to, 0, moved);
    await this.rewriteQueueRows();
    eventBus.emit(AppEvent.QUEUE_CHANGED);
  }

  async moveAll(episodeIds: string[]): Promise<void> {
    for (let i = 0; i < episodeIds.length; i++) {
      const id: string = episodeIds[i];
      if (this.queueOrder.indexOf(id) < 0) {
        this.queueOrder.push(id);
        const ep: EpisodeData | undefined = this.episodes.get(id);
        if (ep) {
          ep.inQueue = true;
          await this.persistEpisode(ep);
        }
      }
    }
    await this.rewriteQueueRows();
    eventBus.emit(AppEvent.QUEUE_CHANGED);
  }

  async sortQueueAlpha(): Promise<void> {
    this.queueOrder.sort((a: string, b: string): number => {
      const ea: EpisodeData | undefined = this.episodes.get(a);
      const eb: EpisodeData | undefined = this.episodes.get(b);
      const ta: string = ea ? ea.title : '';
      const tb: string = eb ? eb.title : '';
      return ta.localeCompare(tb);
    });
    await this.rewriteQueueRows();
    eventBus.emit(AppEvent.QUEUE_CHANGED);
  }

  async clearQueue(): Promise<void> {
    for (let i = 0; i < this.queueOrder.length; i++) {
      const ep: EpisodeData | undefined = this.episodes.get(this.queueOrder[i]);
      if (ep) {
        ep.inQueue = false;
        await this.persistEpisode(ep);
      }
    }
    this.queueOrder = [];
    await this.clearQueueRows();
    eventBus.emit(AppEvent.QUEUE_CHANGED);
  }

  private async rewriteQueueRows(): Promise<void> {
    await this.clearQueueRows();
    for (let i = 0; i < this.queueOrder.length; i++) {
      await this.putQueueRow(this.queueOrder[i], i);
    }
  }

  async removeFromInbox(episodeId: string): Promise<void> {
    const ep: EpisodeData | undefined = this.episodes.get(episodeId);
    if (!ep) return;
    ep.isNew = false;
    ep.isInbox = false;
    await this.persistEpisode(ep);
    eventBus.emit(AppEvent.INBOX_CHANGED);
    eventBus.emit(AppEvent.EPISODES_CHANGED, { feedId: ep.feedId, episodeId } as EpisodePayload);
  }

  async restoreToInbox(episodeId: string): Promise<void> {
    const ep: EpisodeData | undefined = this.episodes.get(episodeId);
    if (!ep) return;
    ep.isNew = true;
    ep.isInbox = true;
    await this.persistEpisode(ep);
    eventBus.emit(AppEvent.INBOX_CHANGED);
    eventBus.emit(AppEvent.EPISODES_CHANGED, { feedId: ep.feedId, episodeId } as EpisodePayload);
  }

  async removeAllFromInbox(feedId?: string): Promise<void> {
    const ids: string[] = Array.from(this.episodes.keys());
    for (let i = 0; i < ids.length; i++) {
      const ep: EpisodeData | undefined = this.episodes.get(ids[i]);
      if (!ep || !ep.isNew) continue;
      if (feedId && feedId.length > 0 && ep.feedId !== feedId) continue;
      ep.isNew = false;
      ep.isInbox = false;
      await this.persistEpisode(ep);
    }
    eventBus.emit(AppEvent.INBOX_CHANGED);
    eventBus.emit(AppEvent.EPISODES_CHANGED, { feedId } as EpisodePayload);
  }

  async markPlayed(episodeId: string, played: boolean): Promise<void> {
    const ep: EpisodeData | undefined = this.episodes.get(episodeId);
    if (!ep) return;
    ep.isPlayed = played;
    if (played) {
      ep.positionSec = ep.durationSec;
      ep.progress = 100;
      ep.position = ep.duration;
      ep.isNew = false;
      ep.isInbox = false;
    } else {
      ep.positionSec = 0;
      ep.progress = 0;
      ep.position = '';
    }
    await this.persistEpisode(ep);
    eventBus.emit(AppEvent.EPISODES_CHANGED, { feedId: ep.feedId, episodeId } as EpisodePayload);
    eventBus.emit(AppEvent.INBOX_CHANGED);
    this.refreshFeedCounts();
  }

  async resetPosition(episodeId: string): Promise<void> {
    const ep: EpisodeData | undefined = this.episodes.get(episodeId);
    if (!ep) return;
    ep.positionSec = 0;
    ep.progress = 0;
    ep.position = '';
    await this.persistEpisode(ep);
    eventBus.emit(AppEvent.EPISODES_CHANGED, { feedId: ep.feedId, episodeId } as EpisodePayload);
  }

  async setPosition(episodeId: string, positionSec: number): Promise<void> {
    const ep: EpisodeData | undefined = this.episodes.get(episodeId);
    if (!ep) return;
    ep.positionSec = Math.max(0, Math.min(positionSec, ep.durationSec));
    ep.progress = ep.durationSec > 0 ? Math.min(100, Math.floor((ep.positionSec / ep.durationSec) * 100)) : 0;
    ep.position = SampleData.formatClock(ep.positionSec);
    await this.persistEpisode(ep);
    eventBus.emit(AppEvent.EPISODES_CHANGED, { feedId: ep.feedId, episodeId } as EpisodePayload);
  }

  async setDownloadState(episodeId: string, state: DownloadState, percent: number): Promise<void> {
    const ep: EpisodeData | undefined = this.episodes.get(episodeId);
    if (!ep) return;
    ep.downloadState = state;
    ep.downloadProgress = percent;
    if (state === DownloadState.DOWNLOADED) {
      ep.downloadedAt = Date.now();
      ep.secondaryAction = SecondaryActionType.PLAY;
    } else if (state === DownloadState.DOWNLOADING) {
      ep.secondaryAction = SecondaryActionType.CANCEL_DOWNLOAD;
    } else if (state === DownloadState.NONE || state === DownloadState.CANCELED) {
      ep.secondaryAction = ep.positionSec > 0 ? SecondaryActionType.PLAY : SecondaryActionType.DOWNLOAD;
    }
    this.downloadStates.set(episodeId, state);
    this.downloadProgress.set(episodeId, percent);
    await this.putDownloadRow(episodeId, state, percent);
    await this.persistEpisode(ep);
    eventBus.emit(AppEvent.DOWNLOAD_PROGRESS, { episodeId, percent, state } as DownloadPayload);
    eventBus.emit(AppEvent.EPISODES_CHANGED, { feedId: ep.feedId, episodeId } as EpisodePayload);
  }

  async recordHistory(episodeId: string, positionSec: number): Promise<void> {
    const ep: EpisodeData | undefined = this.episodes.get(episodeId);
    if (!ep) return;
    this.history = this.history.filter((id: string): boolean => id !== episodeId);
    this.history.unshift(episodeId);
    this.historyPositions.set(episodeId, positionSec);
    this.historyTimes.set(episodeId, Date.now());
    await this.putHistoryRow(episodeId, ep.feedId, positionSec);
    eventBus.emit(AppEvent.PLAYBACK_HISTORY_CHANGED);
  }

  async setFeedTags(feedId: string, tags: string[]): Promise<void> {
    const feed: FeedData | undefined = this.feeds.get(feedId);
    if (!feed) return;
    feed.tags = tags.slice();
    this.feedTagMap.set(feedId, tags.slice());
    await this.upsertFeedRowFromData(feed);
    await this.replaceFeedTagRows(feedId, tags);
    eventBus.emit(AppEvent.FEEDS_CHANGED);
  }

  feedTags(feedId: string): string[] {
    const arr: string[] | undefined = this.feedTagMap.get(feedId);
    return arr ? arr.slice() : [];
  }

  async refreshFeed(feedId: string): Promise<void> {
    const feed: FeedData | undefined = this.feeds.get(feedId);
    if (!feed) return;
    feed.lastUpdateFailed = false;
    feed.hasUpdateFailed = false;
    feed.lastUpdateMs = Date.now();
    await this.upsertFeedRowFromData(feed);
    eventBus.emit(AppEvent.FEEDS_CHANGED);
    eventBus.emit(AppEvent.EPISODES_CHANGED, { feedId } as EpisodePayload);
    eventBus.emit(AppEvent.INBOX_CHANGED);
  }
}

export const repository: RepositoryImpl = new RepositoryImpl();
