import { EpisodeRepository } from './EpisodeRepository';
import { FeedItem } from '../../model/EpisodeModel';

// Thin search facade over EpisodeRepository. Kept as a separate repository per
// the decision contract so ViewModels depend on SearchRepository rather than
// reaching into episode internals.
export class SearchRepository {
  private static instance: SearchRepository | null = null;
  private readonly episodes: EpisodeRepository = EpisodeRepository.getInstance();

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
}
