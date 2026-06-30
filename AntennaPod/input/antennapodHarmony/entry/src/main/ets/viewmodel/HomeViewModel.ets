import { FeedItem, EpisodeFilter } from '../model/EpisodeModel';
import { ViewModelBase } from './ViewModelBase';
import { EventBus, EventType, EventPayload } from '../data/event/EventBus';
import { EpisodeRepository } from '../data/repository/EpisodeRepository';
import { FeedRepository } from '../data/repository/FeedRepository';
import { ServiceLocator } from '../data/service/ServiceLocator';

// Home page ViewModel. Shows the most recent unplayed episodes plus the inbox
// count and whether any subscriptions exist. Re-queries on feed/episode events.
export class HomeViewModel extends ViewModelBase {
  episodes: FeedItem[] = [];
  hasSubscriptions: boolean = false;
  inboxCount: number = 0;

  subscribeEvents(): void {
    this.subscribe(EventType.EPISODE_UPDATED, (payload: EventPayload): void => {
      this.loadData();
    });
    this.subscribe(EventType.FEED_LIST_UPDATE, (payload: EventPayload): void => {
      this.loadData();
    });
    this.subscribe(EventType.QUEUE_CHANGED, (payload: EventPayload): void => {
      this.loadData();
    });
  }

  async onAppear(): Promise<void> {
    await super.onAppear();
    await this.loadData();
  }

  async loadData(): Promise<void> {
    try {
      const episodeRepo = EpisodeRepository.getInstance();
      const feedRepo = FeedRepository.getInstance();
      this.episodes = await episodeRepo.getRecentlyPublished(20);
      const filter = new EpisodeFilter();
      filter.unplayed = true;
      this.inboxCount = await episodeRepo.getTotalCount(filter);
      this.hasSubscriptions = (await feedRepo.getFeedCount()) > 0;
    } catch (err) {
      console.error('HomeViewModel loadData failed: ' + JSON.stringify(err));
      this.episodes = [];
      this.inboxCount = 0;
      this.hasSubscriptions = false;
    }
    this.notify();
  }

  async refresh(): Promise<void> {
    await ServiceLocator.getFeedUpdateService().refreshAllFeeds();
  }

  search(query: string): void {
    // Navigate to the search page with the query (UI stage).
    console.info('HomeViewModel: navigate to search for: ' + query);
  }
}
