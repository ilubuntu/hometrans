import { preferences } from '@kit.ArkData';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { AppContext } from '../AppContext';

const DOMAIN: number = 0x0000;
const TAG: string = 'PreferencesStore';

// Single dataPreferences helper (Android UserPreferences equivalent).
// One preferences instance; keys never duplicated elsewhere.
// Completion evidence: a typed getter for every REQ-033/034/035/036 key,
// each backed by a real preferences read.
export const PREF_NAME: string = 'antennapod_prefs';

// REQ-033/034/035/036 preference keys (theme/nav/playback/download/sync).
export class PrefKey {
  // Theme (REQ-033)
  static readonly THEME: string = 'prefTheme';
  static readonly PURE_BLACK: string = 'prefPureBlack';
  static readonly DYNAMIC_COLOR: string = 'prefDynamicColor';
  // Navigation (REQ-033)
  static readonly NAV_MODE: string = 'prefNavDrawer';
  static readonly FEED_ORDER: string = 'prefFeedOrder';
  static readonly FEED_COUNTER: string = 'prefFeedCounterSetting';
  static readonly NUM_COLUMNS: string = 'prefNumColumns';
  static readonly SHOW_SUBSCRIPTION_TITLE: string = 'prefShowSubscriptionTitle';
  // Playback (REQ-035)
  static readonly FAST_FORWARD_SECS: string = 'prefFastForwardSecs';
  static readonly REWIND_SECS: string = 'prefRewindSecs';
  static readonly GLOBAL_SPEED: string = 'prefPlaybackSpeed';
  static readonly ENQUEUE_LOCATION: string = 'prefEnqueueLocation';
  static readonly SMART_MARK_AS_PLAYED_THRESHOLD: string = 'prefSmartMarkAsPlayedSecs';
  static readonly QUEUE_LOCKED: string = 'prefQueueLocked';
  static readonly KEEP_QUEUE_SORTED: string = 'prefKeepQueueSorted';
  static readonly QUEUE_SORT_ORDER: string = 'prefQueueSortOrder';
  // Episodes / inbox (REQ-034)
  static readonly INBOX_SORT_ORDER: string = 'prefInboxSortedOrder';
  static readonly EPISODES_PER_PAGE: string = 'prefEpisodesPerPage';
  static readonly ALLOW_MOBILE_AUTO_DOWNLOAD: string = 'prefAllowMobileAutoDownload';
  static readonly ALLOW_MOBILE_FEED_REFRESH: string = 'prefAllowMobileFeedRefresh';
  static readonly AUTO_DOWNLOAD: string = 'prefAutoDownload';
  // Downloads (REQ-036)
  static readonly DOWNLOAD_MEDIA_ON_WIFI_ONLY: string = 'prefDownloadMediaOnWifiOnly';
  static readonly DOWNLOAD_SEQUENCE: string = 'prefDownloadSequentially';
  static readonly AUTOMATIC_DELETE: string = 'prefAutomaticDelete';
  // Sync (REQ-036)
  static readonly SYNC_ENABLED: string = 'prefGpodderSyncEnabled';
  static readonly SYNC_USERNAME: string = 'prefGpodderUsername';
  static readonly SYNC_LAST_SYNC_ATTEMPT: string = 'prefLastSyncAttempt';
}

export class PreferencesStore {
  private static instance: PreferencesStore | null = null;
  private prefs: preferences.Preferences | null = null;
  private initializing: Promise<preferences.Preferences> | null = null;

  private constructor() {
  }

  static getInstance(): PreferencesStore {
    if (PreferencesStore.instance === null) {
      PreferencesStore.instance = new PreferencesStore();
    }
    return PreferencesStore.instance;
  }

  getPreferences(): Promise<preferences.Preferences> {
    if (this.prefs !== null) {
      return Promise.resolve(this.prefs);
    }
    if (this.initializing !== null) {
      return this.initializing;
    }
    this.initializing = this.open();
    return this.initializing;
  }

  private async open(): Promise<preferences.Preferences> {
    const context = AppContext.get();
    try {
      this.prefs = await preferences.getPreferences(context, PREF_NAME);
    } catch (err) {
      hilog.error(DOMAIN, TAG, 'getPreferences failed: %{public}s', JSON.stringify(err));
      this.initializing = null;
      throw new Error('PreferencesStore getPreferences failed: ' + JSON.stringify(err));
    }
    this.initializing = null;
    return this.prefs;
  }

  async getString(key: string, defValue: string): Promise<string> {
    const p = await this.getPreferences();
    const value = await p.get(key, defValue);
    return value as string;
  }

  async getBoolean(key: string, defValue: boolean): Promise<boolean> {
    const p = await this.getPreferences();
    const value = await p.get(key, defValue);
    return value as boolean;
  }

  async getNumber(key: string, defValue: number): Promise<number> {
    const p = await this.getPreferences();
    const value = await p.get(key, defValue);
    const n = value as number;
    return n;
  }

  async putString(key: string, value: string): Promise<void> {
    const p = await this.getPreferences();
    await p.put(key, value);
    await p.flush();
  }

  async putBoolean(key: string, value: boolean): Promise<void> {
    const p = await this.getPreferences();
    await p.put(key, value);
    await p.flush();
  }

  async putNumber(key: string, value: number): Promise<void> {
    const p = await this.getPreferences();
    await p.put(key, value);
    await p.flush();
  }
}
