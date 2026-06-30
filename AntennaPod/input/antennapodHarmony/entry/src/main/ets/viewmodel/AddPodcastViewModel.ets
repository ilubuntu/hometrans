import { ViewModelBase } from './ViewModelBase';
import { EventBus, EventType, EventPayload } from '../data/event/EventBus';
import { FeedRepository } from '../data/repository/FeedRepository';
import { ServiceLocator } from '../data/service/ServiceLocator';

export interface PodcastSearchResult {
  title: string;
  author: string;
  imageUrl: string;
  feedUrl: string;
  isDummy: boolean;
}

const NUM_SUGGESTIONS: number = 12;

// Add Podcast page ViewModel. URL input is routed to FeedRepository (subscribe);
// discovery is served by OnlineSearchService (stubbed → offline error path
// today); OPML import is served by OpmlRepository. Transport is deferred.
export class AddPodcastViewModel extends ViewModelBase {
  discoveryItems: PodcastSearchResult[] = [];
  isLoadingDiscovery: boolean = true;
  hasDiscoveryError: boolean = false;
  errorMessage: string = '';

  subscribeEvents(): void {
    this.subscribe(EventType.FEED_LIST_UPDATE, (payload: EventPayload): void => {
      // A feed was added/changed; the discovery grid itself is directory-sourced,
      // so no local reload is needed here.
    });
  }

  async onAppear(): Promise<void> {
    await super.onAppear();
    await this.loadDiscovery();
  }

  async loadDiscovery(): Promise<void> {
    // Pre-fill with dummy items to reserve height (matches QuickFeedDiscovery).
    this.isLoadingDiscovery = true;
    this.hasDiscoveryError = false;
    this.errorMessage = '';
    this.notify();
    const dummies: PodcastSearchResult[] = [];
    for (let i = 0; i < NUM_SUGGESTIONS; i++) {
      dummies.push({ title: '', author: '', imageUrl: '', feedUrl: '', isDummy: true });
    }
    this.discoveryItems = dummies;
    this.notify();

    try {
      const feeds = await ServiceLocator.getOnlineSearchService().loadToplist(NUM_SUGGESTIONS);
      if (feeds.length === 0) {
        // No live directory transport available yet → deterministic offline path.
        this.discoveryItems = [];
        this.hasDiscoveryError = true;
        this.errorMessage = 'no_connection';
      } else {
        const results: PodcastSearchResult[] = [];
        for (let i = 0; i < feeds.length; i++) {
          const f = feeds[i];
          results.push({
            title: f.title,
            author: f.author,
            imageUrl: f.imageUrl,
            feedUrl: f.downloadUrl,
            isDummy: false
          });
        }
        this.discoveryItems = results;
      }
    } catch (err) {
      this.discoveryItems = [];
      this.hasDiscoveryError = true;
      this.errorMessage = 'error_unknown';
    }
    this.isLoadingDiscovery = false;
    this.notify();
  }

  async retryDiscovery(): Promise<void> {
    await this.loadDiscovery();
  }

  async search(query: string): Promise<void> {
    const trimmed = query.trim();
    if (trimmed.length === 0) {
      return;
    }
    // A typed URL is treated as an RSS feed address (matches AddFeedFragment).
    if (trimmed.indexOf('://') > 0 && (trimmed.indexOf('http') === 0)) {
      await this.addByUrl(trimmed);
      return;
    }
    // Directory search is served by OnlineSearchService (UI-stage navigation).
    console.info('AddPodcastViewModel: navigate to combined online search: ' + trimmed);
  }

  async addByUrl(url: string): Promise<void> {
    // Route the URL through the feed-update service (parse) + FeedRepository
    // (persist) so the subscription data path completes end-to-end.
    const feed = await ServiceLocator.getFeedUpdateService().parseFeed(url);
    await FeedRepository.getInstance().addFeed(feed);
    console.info('AddPodcastViewModel: subscribed to feed by URL: ' + url);
  }

  showAddByUrlDialog(): void {
    // Add-by-URL dialog (UI stage).
    console.info('AddPodcastViewModel: show add podcast by URL dialog');
  }

  searchItunes(): void {
    console.info('AddPodcastViewModel: navigate to Apple Podcasts search (UI stage)');
  }

  searchFyyd(): void {
    console.info('AddPodcastViewModel: navigate to fyyd search (UI stage)');
  }

  searchPodcastIndex(): void {
    console.info('AddPodcastViewModel: navigate to Podcast Index search (UI stage)');
  }

  importOpml(): void {
    // Launch the OPML import file picker (UI stage). Once a file is chosen, its
    // contents flow into OpmlRepository.importOpml(content).
    console.info('AddPodcastViewModel: start OPML import file picker');
  }

  addLocalFolder(): void {
    // Local folder feed creation (UI stage).
    console.info('AddPodcastViewModel: start local folder picker');
  }

  openDiscoverMore(): void {
    // Navigate to the full Discovery page (UI stage).
    console.info('AddPodcastViewModel: navigate to discovery page');
  }

  openDiscoveryItem(item: PodcastSearchResult): void {
    if (item.isDummy) {
      return;
    }
    // Open the online feed view for the selected directory item (UI stage).
    console.info('AddPodcastViewModel: open online feed view for: ' + item.title);
  }
}
