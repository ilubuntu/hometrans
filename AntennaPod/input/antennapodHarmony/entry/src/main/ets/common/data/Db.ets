import { relationalStore } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';

export const DB_NAME: string = 'antennapod.db';
export const DB_VERSION: number = 1;

class DbSchema {
  store: relationalStore.RdbStore | null = null;
  private opening: boolean = false;
  private openWaiters: Array<() => void> = [];

  async open(context: common.Context): Promise<void> {
    if (this.store) {
      return;
    }
    if (this.opening) {
      await new Promise<void>((resolve: () => void): void => {
        this.openWaiters.push(resolve);
      });
      return;
    }
    this.opening = true;
    const config: relationalStore.StoreConfig = {
      name: DB_NAME,
      securityLevel: relationalStore.SecurityLevel.S1
    } as relationalStore.StoreConfig;
    const opened: relationalStore.RdbStore = await relationalStore.getRdbStore(context, config);
    await this.migrate(opened);
    this.store = opened;
    this.opening = false;
    const waiters: Array<() => void> = this.openWaiters;
    this.openWaiters = [];
    for (let i = 0; i < waiters.length; i++) {
      waiters[i]();
    }
  }

  async migrate(store: relationalStore.RdbStore): Promise<void> {
    if (store.version === undefined || store.version === 0) {
      store.version = DB_VERSION;
    }
    await this.createV1(store);
  }

  async close(): Promise<void> {
    if (this.store) {
      try {
        await this.store.delete?.('');
      } catch (e) {
        // Best-effort; RdbStore lifecycle is owned by the platform
      }
      this.store = null;
    }
  }

  private async createV1(store: relationalStore.RdbStore): Promise<void> {
    const stmts: string[] = [];
    stmts.push(`CREATE TABLE IF NOT EXISTS feeds (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      author TEXT,
      description TEXT,
      cover_key TEXT,
      feed_url TEXT,
      support_url TEXT,
      subscribed INTEGER NOT NULL DEFAULT 1,
      last_update_failed INTEGER NOT NULL DEFAULT 0,
      last_update_ms INTEGER NOT NULL DEFAULT 0,
      tags TEXT
    )`);
    stmts.push(`CREATE TABLE IF NOT EXISTS episodes (
      id TEXT PRIMARY KEY,
      feed_id TEXT NOT NULL,
      title TEXT NOT NULL,
      author TEXT,
      pub_date TEXT,
      pub_date_ms INTEGER NOT NULL DEFAULT 0,
      duration_sec INTEGER NOT NULL DEFAULT 0,
      position_sec INTEGER NOT NULL DEFAULT 0,
      size_bytes INTEGER NOT NULL DEFAULT 0,
      is_inbox INTEGER NOT NULL DEFAULT 0,
      is_new INTEGER NOT NULL DEFAULT 0,
      is_played INTEGER NOT NULL DEFAULT 0,
      is_video INTEGER NOT NULL DEFAULT 0,
      is_favorite INTEGER NOT NULL DEFAULT 0,
      in_queue INTEGER NOT NULL DEFAULT 0,
      download_state TEXT NOT NULL DEFAULT 'NONE',
      download_progress INTEGER NOT NULL DEFAULT 0,
      downloaded_at INTEGER NOT NULL DEFAULT 0,
      media_url TEXT,
      website_url TEXT,
      shownotes TEXT,
      tags TEXT
    )`);
    stmts.push(`CREATE TABLE IF NOT EXISTS queue (
      episode_id TEXT PRIMARY KEY,
      position INTEGER NOT NULL
    )`);
    stmts.push(`CREATE TABLE IF NOT EXISTS downloads (
      episode_id TEXT PRIMARY KEY,
      state TEXT NOT NULL,
      percent INTEGER NOT NULL DEFAULT 0,
      completed_at INTEGER NOT NULL DEFAULT 0
    )`);
    stmts.push(`CREATE TABLE IF NOT EXISTS favorites (
      episode_id TEXT PRIMARY KEY,
      added_at INTEGER NOT NULL DEFAULT 0
    )`);
    stmts.push(`CREATE TABLE IF NOT EXISTS playback_history (
      episode_id TEXT PRIMARY KEY,
      feed_id TEXT,
      played_at INTEGER NOT NULL DEFAULT 0,
      position_sec INTEGER NOT NULL DEFAULT 0
    )`);
    stmts.push(`CREATE TABLE IF NOT EXISTS feed_tags (
      feed_id TEXT NOT NULL,
      tag TEXT NOT NULL,
      PRIMARY KEY (feed_id, tag)
    )`);
    stmts.push(`CREATE INDEX IF NOT EXISTS idx_episodes_feed ON episodes(feed_id)`);
    stmts.push(`CREATE INDEX IF NOT EXISTS idx_episodes_pubdate ON episodes(pub_date_ms)`);
    for (let i = 0; i < stmts.length; i++) {
      await store.executeSql(stmts[i]);
    }
  }
}

export const dbSchema: DbSchema = new DbSchema();
