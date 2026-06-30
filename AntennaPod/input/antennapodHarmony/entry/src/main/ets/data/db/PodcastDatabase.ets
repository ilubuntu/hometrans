import { relationalStore } from '@kit.ArkData';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { AppContext } from '../AppContext';

const DOMAIN: number = 0x0000;
const TAG: string = 'PodcastDatabase';

// Single relational-store truth owner for all structured app data
// (feeds, feed items, queue, feed preferences, download log, tags).
//
// Schema mirrors AntennaPod's DBReader/DBWriter surface so every ViewModel
// resolves against one coordinated store. ViewModels never persist directly.
export const DB_NAME: string = 'Antennapod.db';
export const DB_VERSION: number = 1;

export class PodcastDatabase {
  private static instance: PodcastDatabase | null = null;
  private store: relationalStore.RdbStore | null = null;
  private initializing: Promise<relationalStore.RdbStore> | null = null;

  private constructor() {
  }

  static getInstance(): PodcastDatabase {
    if (PodcastDatabase.instance === null) {
      PodcastDatabase.instance = new PodcastDatabase();
    }
    return PodcastDatabase.instance;
  }

  // Returns the (cached) RdbStore, creating + migrating the schema on first use.
  getStore(): Promise<relationalStore.RdbStore> {
    if (this.store !== null) {
      return Promise.resolve(this.store);
    }
    if (this.initializing !== null) {
      return this.initializing;
    }
    this.initializing = this.openAndMigrate();
    return this.initializing;
  }

  private async openAndMigrate(): Promise<relationalStore.RdbStore> {
    const context = AppContext.get();
    const config: relationalStore.StoreConfig = {
      name: DB_NAME,
      securityLevel: relationalStore.SecurityLevel.S1
    } as relationalStore.StoreConfig;
    let rdbStore: relationalStore.RdbStore;
    try {
      rdbStore = await relationalStore.getRdbStore(context, config);
    } catch (err) {
      hilog.error(DOMAIN, TAG, 'getRdbStore failed: %{public}s', JSON.stringify(err));
      this.initializing = null;
      throw new Error('PodcastDatabase getRdbStore failed: ' + JSON.stringify(err));
    }
    try {
      if (rdbStore.version === 0) {
        await this.onCreate(rdbStore);
        rdbStore.version = DB_VERSION;
      } else if (rdbStore.version < DB_VERSION) {
        await this.onUpgrade(rdbStore, rdbStore.version, DB_VERSION);
        rdbStore.version = DB_VERSION;
      }
    } catch (err) {
      hilog.error(DOMAIN, TAG, 'schema init failed: %{public}s', JSON.stringify(err));
      this.initializing = null;
      throw new Error('PodcastDatabase schema init failed: ' + JSON.stringify(err));
    }
    this.store = rdbStore;
    this.initializing = null;
    return rdbStore;
  }

  // Fresh-install DDL. One CREATE TABLE per decision-contract entity.
  private async onCreate(store: relationalStore.RdbStore): Promise<void> {
    await store.executeSql('CREATE TABLE IF NOT EXISTS Feed (' +
      'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
      'title TEXT NOT NULL DEFAULT \'\', ' +
      'custom_title TEXT NOT NULL DEFAULT \'\', ' +
      'author TEXT NOT NULL DEFAULT \'\', ' +
      'link TEXT NOT NULL DEFAULT \'\', ' +
      'description TEXT NOT NULL DEFAULT \'\', ' +
      'download_url TEXT NOT NULL DEFAULT \'\', ' +
      'image_url TEXT NOT NULL DEFAULT \'\', ' +
      'last_update TEXT NOT NULL DEFAULT \'\', ' +
      'last_update_ms INTEGER NOT NULL DEFAULT 0, ' +
      'state INTEGER NOT NULL DEFAULT 0, ' +
      'is_local INTEGER NOT NULL DEFAULT 0, ' +
      'has_last_update_failed INTEGER NOT NULL DEFAULT 0)');

    await store.executeSql('CREATE TABLE IF NOT EXISTS FeedItem (' +
      'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
      'feed_id INTEGER NOT NULL DEFAULT 0, ' +
      'title TEXT NOT NULL DEFAULT \'\', ' +
      'description TEXT NOT NULL DEFAULT \'\', ' +
      'link TEXT NOT NULL DEFAULT \'\', ' +
      'pub_date TEXT NOT NULL DEFAULT \'\', ' +
      'pub_date_ms INTEGER NOT NULL DEFAULT 0, ' +
      'image_url TEXT NOT NULL DEFAULT \'\', ' +
      'media_duration INTEGER NOT NULL DEFAULT 0, ' +
      'media_position INTEGER NOT NULL DEFAULT 0, ' +
      'media_size INTEGER NOT NULL DEFAULT 0, ' +
      'mime_type TEXT NOT NULL DEFAULT \'\', ' +
      'media_download_url TEXT NOT NULL DEFAULT \'\', ' +
      'read INTEGER NOT NULL DEFAULT 0, ' +
      'downloaded INTEGER NOT NULL DEFAULT 0, ' +
      'auto_download INTEGER NOT NULL DEFAULT 0, ' +
      'is_favorite INTEGER NOT NULL DEFAULT 0, ' +
      'in_history INTEGER NOT NULL DEFAULT 0, ' +
      'played_completion INTEGER NOT NULL DEFAULT 0, ' +
      'video INTEGER NOT NULL DEFAULT 0)');

    await store.executeSql('CREATE TABLE IF NOT EXISTS Queue (' +
      'feeditem_id INTEGER PRIMARY KEY, ' +
      'position INTEGER NOT NULL DEFAULT 0)');

    await store.executeSql('CREATE TABLE IF NOT EXISTS FeedPreferences (' +
      'feed_id INTEGER PRIMARY KEY, ' +
      'auto_download INTEGER NOT NULL DEFAULT 0, ' +
      'auto_delete INTEGER NOT NULL DEFAULT 1, ' +
      'new_episode_action INTEGER NOT NULL DEFAULT 0, ' +
      'playback_speed REAL NOT NULL DEFAULT 1.0, ' +
      'skip_intro INTEGER NOT NULL DEFAULT 0, ' +
      'skip_outro INTEGER NOT NULL DEFAULT 0, ' +
      'username TEXT NOT NULL DEFAULT \'\', ' +
      'password TEXT NOT NULL DEFAULT \'\', ' +
      'volume_reduction INTEGER NOT NULL DEFAULT 0)');

    await store.executeSql('CREATE TABLE IF NOT EXISTS DownloadResult (' +
      'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
      'completed_date_ms INTEGER NOT NULL DEFAULT 0, ' +
      'title TEXT NOT NULL DEFAULT \'\', ' +
      'reason INTEGER NOT NULL DEFAULT 0, ' +
      'source_type TEXT NOT NULL DEFAULT \'media\', ' +
      'feeditem_id INTEGER NOT NULL DEFAULT 0)');

    await store.executeSql('CREATE TABLE IF NOT EXISTS Tag (' +
      'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
      'name TEXT NOT NULL DEFAULT \'\')');

    await store.executeSql('CREATE TABLE IF NOT EXISTS FeedTag (' +
      'feed_id INTEGER NOT NULL, ' +
      'tag_id INTEGER NOT NULL, ' +
      'PRIMARY KEY (feed_id, tag_id))');

    await store.executeSql('CREATE INDEX IF NOT EXISTS idx_feeditem_feed_id ON FeedItem(feed_id)');
    await store.executeSql('CREATE INDEX IF NOT EXISTS idx_feeditem_pub_date_ms ON FeedItem(pub_date_ms)');
    await store.executeSql('CREATE INDEX IF NOT EXISTS idx_queue_position ON Queue(position)');
  }

  // Future migrations land here. Version 1 → no-op (created fresh).
  private async onUpgrade(store: relationalStore.RdbStore, oldVersion: number, newVersion: number): Promise<void> {
    hilog.info(DOMAIN, TAG, 'onUpgrade %{public}d -> %{public}d', oldVersion.toString(), newVersion.toString());
    // switch (oldVersion) { case 1: ...; break; }  -- reserved for later schema bumps
  }
}
