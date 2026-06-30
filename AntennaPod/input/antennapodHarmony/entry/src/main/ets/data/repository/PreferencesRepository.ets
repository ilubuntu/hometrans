import { PreferencesStore, PrefKey } from '../prefs/PreferencesStore';
import { EventBus, EventType, EventPayload } from '../event/EventBus';
import {
  EnqueueLocation,
  FeedCounterType,
  FeedOrder,
  SortOrder
} from '../../model/EpisodeModel';

// Domain wrapper over PreferencesStore used by ViewModels. Settings that change
// list display (feed order, counter, columns, sort, queue lock/keep-sorted)
// re-publish the relevant event so subscribed pages refresh.
export class PreferencesRepository {
  private static instance: PreferencesRepository | null = null;

  private constructor() {
  }

  static getInstance(): PreferencesRepository {
    if (PreferencesRepository.instance === null) {
      PreferencesRepository.instance = new PreferencesRepository();
    }
    return PreferencesRepository.instance;
  }

  private store(): PreferencesStore {
    return PreferencesStore.getInstance();
  }

  private publishListChange(): void {
    EventBus.publish(EventType.FEED_LIST_UPDATE, new EventPayload());
  }

  // ---- Theme (REQ-033) ----
  getTheme(): Promise<string> {
    return this.store().getString(PrefKey.THEME, 'system');
  }

  setTheme(theme: string): Promise<void> {
    return this.store().putString(PrefKey.THEME, theme).then((): void => {
      this.publishListChange();
    });
  }

  getPureBlack(): Promise<boolean> {
    return this.store().getBoolean(PrefKey.PURE_BLACK, false);
  }

  setPureBlack(value: boolean): Promise<void> {
    return this.store().putBoolean(PrefKey.PURE_BLACK, value).then((): void => {
      this.publishListChange();
    });
  }

  getDynamicColor(): Promise<boolean> {
    return this.store().getBoolean(PrefKey.DYNAMIC_COLOR, false);
  }

  setDynamicColor(value: boolean): Promise<void> {
    return this.store().putBoolean(PrefKey.DYNAMIC_COLOR, value);
  }

  // ---- Navigation / subscriptions (REQ-033) ----
  getFeedOrder(): Promise<number> {
    return this.store().getNumber(PrefKey.FEED_ORDER, FeedOrder.DATE);
  }

  setFeedOrder(order: number): Promise<void> {
    return this.store().putNumber(PrefKey.FEED_ORDER, order).then((): void => {
      this.publishListChange();
    });
  }

  getFeedCounter(): Promise<number> {
    return this.store().getNumber(PrefKey.FEED_COUNTER, FeedCounterType.INBOX);
  }

  setFeedCounter(setting: number): Promise<void> {
    return this.store().putNumber(PrefKey.FEED_COUNTER, setting).then((): void => {
      this.publishListChange();
    });
  }

  getNumColumns(): Promise<number> {
    return this.store().getNumber(PrefKey.NUM_COLUMNS, 3);
  }

  setNumColumns(columns: number): Promise<void> {
    return this.store().putNumber(PrefKey.NUM_COLUMNS, columns).then((): void => {
      this.publishListChange();
    });
  }

  getShowSubscriptionTitle(): Promise<boolean> {
    return this.store().getBoolean(PrefKey.SHOW_SUBSCRIPTION_TITLE, true);
  }

  setShowSubscriptionTitle(show: boolean): Promise<void> {
    return this.store().putBoolean(PrefKey.SHOW_SUBSCRIPTION_TITLE, show).then((): void => {
      this.publishListChange();
    });
  }

  // ---- Theme appearance extras (REQ-033) ----
  getShowRemainingTime(): Promise<boolean> {
    return this.store().getBoolean(PrefKey.SHOW_REMAINING_TIME, true);
  }

  setShowRemainingTime(value: boolean): Promise<void> {
    return this.store().putBoolean(PrefKey.SHOW_REMAINING_TIME, value);
  }

  getDefaultEpisodeSort(): Promise<number> {
    return this.store().getNumber(PrefKey.DEFAULT_EPISODE_SORT, SortOrder.DATE_NEW_OLD);
  }

  setDefaultEpisodeSort(sort: number): Promise<void> {
    return this.store().putNumber(PrefKey.DEFAULT_EPISODE_SORT, sort).then((): void => {
      EventBus.publishSignal(EventType.EPISODE_UPDATED);
    });
  }

  isPreferStreaming(): Promise<boolean> {
    return this.store().getBoolean(PrefKey.PREFER_STREAMING, false);
  }

  setPreferStreaming(value: boolean): Promise<void> {
    return this.store().putBoolean(PrefKey.PREFER_STREAMING, value);
  }

  getNotificationButtons(): Promise<string> {
    return this.store().getString(PrefKey.NOTIFICATION_BUTTONS, 'SKIP,SKIP2');
  }

  setNotificationButtons(value: string): Promise<void> {
    return this.store().putString(PrefKey.NOTIFICATION_BUTTONS, value);
  }

  getSwipeLeftAction(): Promise<string> {
    return this.store().getString(PrefKey.SWIPE_LEFT_ACTION, 'FAVORITE');
  }

  setSwipeLeftAction(value: string): Promise<void> {
    return this.store().putString(PrefKey.SWIPE_LEFT_ACTION, value);
  }

  getSwipeRightAction(): Promise<string> {
    return this.store().getString(PrefKey.SWIPE_RIGHT_ACTION, 'ADDTOQUEUE');
  }

  setSwipeRightAction(value: string): Promise<void> {
    return this.store().putString(PrefKey.SWIPE_RIGHT_ACTION, value);
  }

  // ---- Playback / queue (REQ-035) ----
  getFastForwardSecs(): Promise<number> {
    return this.store().getNumber(PrefKey.FAST_FORWARD_SECS, 30);
  }

  getRewindSecs(): Promise<number> {
    return this.store().getNumber(PrefKey.REWIND_SECS, 10);
  }

  getGlobalSpeed(): Promise<number> {
    return this.store().getNumber(PrefKey.GLOBAL_SPEED, 1.0);
  }

  getEnqueueLocation(): Promise<number> {
    return this.store().getNumber(PrefKey.ENQUEUE_LOCATION, EnqueueLocation.BACK);
  }

  setEnqueueLocation(location: number): Promise<void> {
    return this.store().putNumber(PrefKey.ENQUEUE_LOCATION, location);
  }

  getSmartMarkThreshold(): Promise<number> {
    return this.store().getNumber(PrefKey.SMART_MARK_AS_PLAYED_THRESHOLD, 30);
  }

  // ---- Auto-resume (REQ-034) ----
  isResumeAfterHeadsetConnect(): Promise<boolean> {
    return this.store().getBoolean(PrefKey.RESUME_AFTER_HEADSET_CONNECT, false);
  }

  setResumeAfterHeadsetConnect(value: boolean): Promise<void> {
    return this.store().putBoolean(PrefKey.RESUME_AFTER_HEADSET_CONNECT, value);
  }

  isResumeAfterBluetoothConnect(): Promise<boolean> {
    return this.store().getBoolean(PrefKey.RESUME_AFTER_BLUETOOTH_CONNECT, false);
  }

  setResumeAfterBluetoothConnect(value: boolean): Promise<void> {
    return this.store().putBoolean(PrefKey.RESUME_AFTER_BLUETOOTH_CONNECT, value);
  }

  getQueueLocked(): Promise<boolean> {
    return this.store().getBoolean(PrefKey.QUEUE_LOCKED, false);
  }

  setQueueLocked(locked: boolean): Promise<void> {
    return this.store().putBoolean(PrefKey.QUEUE_LOCKED, locked).then((): void => {
      EventBus.publishSignal(EventType.QUEUE_CHANGED);
    });
  }

  getKeepQueueSorted(): Promise<boolean> {
    return this.store().getBoolean(PrefKey.KEEP_QUEUE_SORTED, false);
  }

  setKeepQueueSorted(value: boolean): Promise<void> {
    return this.store().putBoolean(PrefKey.KEEP_QUEUE_SORTED, value).then((): void => {
      EventBus.publishSignal(EventType.QUEUE_CHANGED);
    });
  }

  getQueueSortOrder(): Promise<number> {
    return this.store().getNumber(PrefKey.QUEUE_SORT_ORDER, SortOrder.DATE_NEW_OLD);
  }

  // ---- Inbox (REQ-034) ----
  getInboxSortOrder(): Promise<number> {
    return this.store().getNumber(PrefKey.INBOX_SORT_ORDER, SortOrder.DATE_NEW_OLD);
  }

  setInboxSortOrder(order: number): Promise<void> {
    return this.store().putNumber(PrefKey.INBOX_SORT_ORDER, order).then((): void => {
      EventBus.publishSignal(EventType.EPISODE_UPDATED);
    });
  }

  getEpisodesPerPage(): Promise<number> {
    return this.store().getNumber(PrefKey.EPISODES_PER_PAGE, 150);
  }

  // ---- Downloads (REQ-036) ----
  isAutoDownload(): Promise<boolean> {
    return this.store().getBoolean(PrefKey.AUTO_DOWNLOAD, false);
  }

  setAutoDownload(value: boolean): Promise<void> {
    return this.store().putBoolean(PrefKey.AUTO_DOWNLOAD, value);
  }

  isMobileAutoDownload(): Promise<boolean> {
    return this.store().getBoolean(PrefKey.ALLOW_MOBILE_AUTO_DOWNLOAD, false);
  }

  isDownloadWifiOnly(): Promise<boolean> {
    return this.store().getBoolean(PrefKey.DOWNLOAD_MEDIA_ON_WIFI_ONLY, false);
  }

  isAutomaticDelete(): Promise<boolean> {
    return this.store().getBoolean(PrefKey.AUTOMATIC_DELETE, true);
  }

  // ---- Download settings extras (REQ-035) ----
  getUpdateInterval(): Promise<number> {
    return this.store().getNumber(PrefKey.UPDATE_INTERVAL, 12);
  }

  setUpdateInterval(hours: number): Promise<void> {
    return this.store().putNumber(PrefKey.UPDATE_INTERVAL, hours);
  }

  getProxyHost(): Promise<string> {
    return this.store().getString(PrefKey.PROXY_HOST, '');
  }

  setProxyHost(host: string): Promise<void> {
    return this.store().putString(PrefKey.PROXY_HOST, host);
  }

  getProxyPort(): Promise<number> {
    return this.store().getNumber(PrefKey.PROXY_PORT, 0);
  }

  setProxyPort(port: number): Promise<void> {
    return this.store().putNumber(PrefKey.PROXY_PORT, port);
  }

  getStorageDir(): Promise<string> {
    return this.store().getString(PrefKey.STORAGE_DIR, '');
  }

  setStorageDir(dir: string): Promise<void> {
    return this.store().putString(PrefKey.STORAGE_DIR, dir);
  }

  // ---- Sync (REQ-036) ----
  isSyncEnabled(): Promise<boolean> {
    return this.store().getBoolean(PrefKey.SYNC_ENABLED, false);
  }

  getSyncUsername(): Promise<string> {
    return this.store().getString(PrefKey.SYNC_USERNAME, '');
  }
}
