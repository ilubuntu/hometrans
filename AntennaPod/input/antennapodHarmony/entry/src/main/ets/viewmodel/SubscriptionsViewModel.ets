import { Feed, FeedState, FeedCounterType } from '../model/EpisodeModel';
import { ViewModelBase } from './ViewModelBase';
import { EventBus, EventType, EventPayload } from '../data/event/EventBus';
import { FeedRepository } from '../data/repository/FeedRepository';
import { PreferencesRepository } from '../data/repository/PreferencesRepository';
import { ServiceLocator } from '../data/service/ServiceLocator';

// UI-facing enums kept in the ViewModel (consumed by dialogs/menus).
export enum FeedSortOrder {
  COUNTER,
  ALPHABETICAL,
  DATE,
  MOST_PLAYED
}

export enum FeedCounter {
  NONE,
  INBOX,
  UNPLAYED,
  DOWNLOADED,
  DOWNLOADED_UNPLAYED
}

const MIN_NUM_COLUMNS: number = 1;
const MAX_NUM_COLUMNS: number = 5;

// Subscriptions page ViewModel. Reads subscribed feeds + derived per-feed
// counters via FeedRepository, reflects feed-order / counter / column prefs,
// and re-queries on FEED_LIST_UPDATE events.
export class SubscriptionsViewModel extends ViewModelBase {
  feeds: Feed[] = [];
  feedCounters: Map<number, number> = new Map<number, number>();
  isLoading: boolean = true;
  columnCount: number = 3;
  showSubscriptionTitle: boolean = true;
  feedOrder: FeedSortOrder = FeedSortOrder.DATE;
  feedCounterSetting: FeedCounter = FeedCounter.INBOX;

  subscribeEvents(): void {
    this.subscribe(EventType.FEED_LIST_UPDATE, (payload: EventPayload): void => {
      this.loadSubscriptions();
    });
  }

  async onAppear(): Promise<void> {
    await super.onAppear();
    await this.loadSubscriptions();
  }

  private toFeedCounter(setting: FeedCounter): number {
    if (setting === FeedCounter.NONE) {
      return FeedCounterType.NONE;
    }
    if (setting === FeedCounter.UNPLAYED) {
      return FeedCounterType.UNPLAYED;
    }
    if (setting === FeedCounter.DOWNLOADED) {
      return FeedCounterType.DOWNLOADED;
    }
    if (setting === FeedCounter.DOWNLOADED_UNPLAYED) {
      return FeedCounterType.DOWNLOADED_UNPLAYED;
    }
    return FeedCounterType.INBOX;
  }

  async loadSubscriptions(): Promise<void> {
    this.isLoading = true;
    this.notify();
    try {
      const repo = FeedRepository.getInstance();
      const prefs = PreferencesRepository.getInstance();
      this.columnCount = await prefs.getNumColumns();
      this.showSubscriptionTitle = await prefs.getShowSubscriptionTitle();
      this.feedOrder = (await prefs.getFeedOrder()) as FeedSortOrder;
      this.feedCounterSetting = (await prefs.getFeedCounter()) as FeedCounter;
      this.feeds = await repo.getFeeds(FeedState.SUBSCRIBED);
      this.feedCounters = await repo.getFeedCounters(this.toFeedCounter(this.feedCounterSetting));
    } catch (err) {
      console.error('SubscriptionsViewModel loadSubscriptions failed: ' + JSON.stringify(err));
      this.feeds = [];
      this.feedCounters = new Map<number, number>();
    }
    this.isLoading = false;
    this.notify();
  }

  getCounter(feedId: number): number {
    const value = this.feedCounters.get(feedId);
    return value === undefined ? 0 : value;
  }

  getColumnLabel(index: number): number {
    return index + MIN_NUM_COLUMNS;
  }

  isColumnInRange(columns: number): boolean {
    return columns >= MIN_NUM_COLUMNS && columns <= MAX_NUM_COLUMNS;
  }

  async setColumnCount(columns: number): Promise<void> {
    if (!this.isColumnInRange(columns)) {
      return;
    }
    this.columnCount = columns;
    await PreferencesRepository.getInstance().setNumColumns(columns);
    this.notify();
  }

  async setShowSubscriptionTitle(show: boolean): Promise<void> {
    this.showSubscriptionTitle = show;
    await PreferencesRepository.getInstance().setShowSubscriptionTitle(show);
    this.notify();
  }

  async setFeedOrder(order: FeedSortOrder): Promise<void> {
    this.feedOrder = order;
    await PreferencesRepository.getInstance().setFeedOrder(order as number);
    await this.loadSubscriptions();
  }

  async setFeedCounterSetting(setting: FeedCounter): Promise<void> {
    this.feedCounterSetting = setting;
    await PreferencesRepository.getInstance().setFeedCounter(setting as number);
    await this.loadSubscriptions();
  }

  async refresh(): Promise<void> {
    await ServiceLocator.getFeedUpdateService().refreshAllFeeds();
  }

  search(): void {
    // Navigate to the search page (UI stage).
    console.info('SubscriptionsViewModel: navigate to search');
  }

  openAddPodcast(): void {
    // Navigate to the Add Podcast page (UI stage).
    console.info('SubscriptionsViewModel: navigate to add podcast');
  }

  openPodcastDetail(feedId: number): void {
    // Navigate to the feed detail page (UI stage).
    console.info('SubscriptionsViewModel: navigate to podcast detail, feedId=' + feedId.toString());
  }

  openFilterDialog(): void {
    // Subscriptions filter dialog (UI stage).
    console.info('SubscriptionsViewModel: open subscriptions filter dialog');
  }

  openSortDialog(): void {
    // Feed sort dialog (UI stage).
    console.info('SubscriptionsViewModel: open feed sort dialog');
  }

  openCounterDialog(): void {
    // Feed counter dialog (UI stage).
    console.info('SubscriptionsViewModel: open feed counter dialog');
  }

  openArchive(): void {
    // Navigate to the archived subscriptions (UI stage).
    console.info('SubscriptionsViewModel: navigate to archive');
  }
}
