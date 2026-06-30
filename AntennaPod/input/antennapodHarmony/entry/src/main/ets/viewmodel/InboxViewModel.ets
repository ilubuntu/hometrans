import { FeedItem, EpisodeFilter, SortOrder } from '../model/EpisodeModel';
import { ViewModelBase } from './ViewModelBase';
import { EventBus, EventType, EventPayload } from '../data/event/EventBus';
import { EpisodeRepository } from '../data/repository/EpisodeRepository';
import { PreferencesRepository } from '../data/repository/PreferencesRepository';
import { ServiceLocator } from '../data/service/ServiceLocator';

// Inbox sort order enum kept in the ViewModel for UI binding (InboxSortDialog).
export enum InboxSortOrder {
  DATE_OLD_NEW,
  DATE_NEW_OLD,
  DURATION_SHORT_LONG,
  DURATION_LONG_SHORT
}

// Inbox page ViewModel. Reads new (unplayed) episodes via EpisodeRepository
// with pagination + sort, reflects the persisted inbox sort order, and
// re-queries on EPISODE_UPDATED / FEED_LIST_UPDATE events.
export class InboxViewModel extends ViewModelBase {
  episodes: FeedItem[] = [];
  isLoading: boolean = true;
  totalItemCount: number = 0;
  hasMoreItems: boolean = false;
  page: number = 1;
  sortOrder: InboxSortOrder = InboxSortOrder.DATE_NEW_OLD;

  subscribeEvents(): void {
    this.subscribe(EventType.EPISODE_UPDATED, (payload: EventPayload): void => {
      this.loadItems();
    });
    this.subscribe(EventType.FEED_LIST_UPDATE, (payload: EventPayload): void => {
      this.loadItems();
    });
  }

  async onAppear(): Promise<void> {
    await super.onAppear();
    await this.loadItems();
  }

  private toSortOrder(order: InboxSortOrder): number {
    if (order === InboxSortOrder.DATE_OLD_NEW) {
      return SortOrder.DATE_OLD_NEW;
    }
    if (order === InboxSortOrder.DURATION_SHORT_LONG) {
      return SortOrder.DURATION_SHORT_LONG;
    }
    if (order === InboxSortOrder.DURATION_LONG_SHORT) {
      return SortOrder.DURATION_LONG_SHORT;
    }
    return SortOrder.DATE_NEW_OLD;
  }

  async loadItems(): Promise<void> {
    this.isLoading = true;
    this.notify();
    try {
      const repo = EpisodeRepository.getInstance();
      this.sortOrder = (await PreferencesRepository.getInstance().getInboxSortOrder()) as InboxSortOrder;
      const filter = new EpisodeFilter();
      filter.unplayed = true;
      this.episodes = await repo.getEpisodes(filter, this.toSortOrder(this.sortOrder), 1);
      this.totalItemCount = await repo.getTotalCount(filter);
      this.hasMoreItems = this.episodes.length < this.totalItemCount;
    } catch (err) {
      console.error('InboxViewModel loadItems failed: ' + JSON.stringify(err));
      this.episodes = [];
      this.totalItemCount = 0;
      this.hasMoreItems = false;
    }
    this.isLoading = false;
    this.notify();
  }

  async loadMoreData(nextPage: number): Promise<FeedItem[]> {
    const repo = EpisodeRepository.getInstance();
    const filter = new EpisodeFilter();
    filter.unplayed = true;
    const items = await repo.getEpisodes(filter, this.toSortOrder(this.sortOrder), nextPage);
    this.page = nextPage;
    return items;
  }

  async setSortOrder(order: InboxSortOrder): Promise<void> {
    this.sortOrder = order;
    await PreferencesRepository.getInstance().setInboxSortOrder(this.toSortOrder(order));
    await this.loadItems();
  }

  async removeAllFromInbox(): Promise<void> {
    await EpisodeRepository.getInstance().removeAllNewFlags();
    // EPISODE_UPDATED will trigger loadItems(); refresh optimistically.
    this.episodes = [];
    this.totalItemCount = 0;
    this.hasMoreItems = false;
    this.notify();
  }

  async refresh(): Promise<void> {
    await ServiceLocator.getFeedUpdateService().refreshAllFeeds();
  }

  search(): void {
    // Navigate to the search page scoped to new episodes (UI stage).
    console.info('InboxViewModel: navigate to search (new episodes filter)');
  }
}
