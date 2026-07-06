import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { eventBus, AppEvent, PrefPayload } from '../event/EventBus';

const PREF_NAME: string = 'antennapod_prefs';

class PreferencesStoreImpl {
  private store: preferences.Preferences | null = null;
  private cache: Map<string, preferences.ValueType> = new Map<string, preferences.ValueType>();
  ready: boolean = false;

  async init(context: common.Context): Promise<void> {
    if (this.ready) {
      return;
    }
    try {
      this.store = await preferences.getPreferences(context, PREF_NAME);
      await this.loadAll();
    } catch (e) {
      console.error(`PreferencesStore.init failed: ${e}`);
    }
    this.ready = true;
  }

  private async loadAll(): Promise<void> {
    if (!this.store) return;
    const allKeys: Array<string> = [
      'firstLaunchDone',
      'visibleNavOrder',
      'defaultPage',
      'lastPage',
      'queueLock',
      'queueKeepSort',
      'queueSortRule',
      'enqueuePosition',
      'bottomNavEnabled',
      'counterDisplay',
      'showRemainingTime',
      'playbackSpeed',
      'mobileDownloadPolicy',
      'removeFromInboxDontAsk',
      'feed_autoDownload',
      'feed_autoQueue',
      'feed_newEpisodeAction',
      'episodesSortOrder',
      'episodesFilter',
      'feedDetailSortOrder',
      'feedDetailFilter',
      'homeSectionOrder',
      'subscriptionsSortOrder',
      'subscriptionsColumns',
      'searchHistory'
    ];
    for (let i = 0; i < allKeys.length; i++) {
      const key: string = allKeys[i];
      try {
        const has: boolean = await this.store.has(key);
        if (has) {
          const value: preferences.ValueType = await this.store.get(key, '');
          this.cache.set(key, value);
        }
      } catch (e) {
        // ignore individual key errors
      }
    }
  }

  private async flush(): Promise<void> {
    if (!this.store) return;
    try {
      await this.store.flush();
    } catch (e) {
      console.error(`PreferencesStore.flush failed: ${e}`);
    }
  }

  async putBoolean(key: string, value: boolean): Promise<void> {
    this.cache.set(key, value);
    if (this.store) {
      try {
        await this.store.put(key, value);
        await this.flush();
      } catch (e) {
        console.error(`PreferencesStore.putBoolean(${key}) failed: ${e}`);
      }
    }
    eventBus.emit(AppEvent.PREFERENCES_CHANGED, { key } as PrefPayload);
  }

  async putString(key: string, value: string): Promise<void> {
    this.cache.set(key, value);
    if (this.store) {
      try {
        await this.store.put(key, value);
        await this.flush();
      } catch (e) {
        console.error(`PreferencesStore.putString(${key}) failed: ${e}`);
      }
    }
    eventBus.emit(AppEvent.PREFERENCES_CHANGED, { key } as PrefPayload);
  }

  async putNumber(key: string, value: number): Promise<void> {
    this.cache.set(key, value);
    if (this.store) {
      try {
        await this.store.put(key, value);
        await this.flush();
      } catch (e) {
        console.error(`PreferencesStore.putNumber(${key}) failed: ${e}`);
      }
    }
    eventBus.emit(AppEvent.PREFERENCES_CHANGED, { key } as PrefPayload);
  }

  async putObject(key: string, value: object): Promise<void> {
    this.cache.set(key, value);
    if (this.store) {
      try {
        await this.store.put(key, value);
        await this.flush();
      } catch (e) {
        console.error(`PreferencesStore.putObject(${key}) failed: ${e}`);
      }
    }
    eventBus.emit(AppEvent.PREFERENCES_CHANGED, { key } as PrefPayload);
  }

  async getBoolean(key: string, def: boolean): Promise<boolean> {
    const v: preferences.ValueType | undefined = this.cache.get(key);
    if (v === undefined || v === null) {
      return def;
    }
    return v as boolean;
  }

  getSync(key: string, def: string): string {
    const v: preferences.ValueType | undefined = this.cache.get(key);
    if (v === undefined || v === null) {
      return def;
    }
    return v as string;
  }

  getBooleanSync(key: string, def: boolean): boolean {
    const v: preferences.ValueType | undefined = this.cache.get(key);
    if (v === undefined || v === null) {
      return def;
    }
    return v as boolean;
  }

  getNumberSync(key: string, def: number): number {
    const v: preferences.ValueType | undefined = this.cache.get(key);
    if (v === undefined || v === null) {
      return def;
    }
    return v as number;
  }

  getObjectSync(key: string): object | undefined {
    const v: preferences.ValueType | undefined = this.cache.get(key);
    if (v === undefined || v === null) {
      return undefined;
    }
    return v as object;
  }

  async remove(key: string): Promise<void> {
    this.cache.delete(key);
    if (this.store) {
      try {
        await this.store.delete(key);
        await this.flush();
      } catch (e) {
        console.error(`PreferencesStore.remove(${key}) failed: ${e}`);
      }
    }
    eventBus.emit(AppEvent.PREFERENCES_CHANGED, { key } as PrefPayload);
  }
}

export const preferencesStore: PreferencesStoreImpl = new PreferencesStoreImpl();
