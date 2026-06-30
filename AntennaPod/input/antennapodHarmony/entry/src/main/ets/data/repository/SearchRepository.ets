import { EpisodeRepository } from './EpisodeRepository';
import { FeedRepository } from './FeedRepository';
import { FeedItem, Feed } from '../../model/EpisodeModel';

// Thin search facade over EpisodeRepository + FeedRepository. Kept as a separate
// repository per the decision contract so ViewModels depend on SearchRepository
// rather than reaching into episode/feed internals.
export class SearchRepository {
  private static instance: SearchRepository | null = null;
  private readonly episodes: EpisodeRepository = EpisodeRepository.getInstance();
  private readonly feeds: FeedRepository = FeedRepository.getInstance();

  private constructor() {
  }

  static getInstance(): SearchRepository {
    if (SearchRepository.instance === null) {
      SearchRepository.instance = new SearchRepository();
    }
    return SearchRepository.instance;
  }

  // Multi-word AND title/description LIKE match, newest first, capped at 300.
  async search(query: string): Promise<FeedItem[]> {
    return this.episodes.search(query, 300);
  }

  // Search scoped to a single feed (REQ-028 场景 2.4, incl. archived episodes).
  async searchInFeed(feedId: number, query: string): Promise<FeedItem[]> {
    return this.episodes.search(query, 300, feedId);
  }

  // Search subscribed podcasts by title/customTitle/author/description (REQ-027 场景 2.5).
  async searchFeeds(query: string): Promise<Feed[]> {
    return this.feeds.searchFeeds(query, 300);
  }
}
