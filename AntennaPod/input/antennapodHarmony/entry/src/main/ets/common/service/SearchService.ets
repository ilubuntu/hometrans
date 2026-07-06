import { EpisodeData } from '../../model/EpisodeData';
import { FeedData } from '../../model/FeedData';
import { repository } from '../data/Repository';

export interface SearchResult {
  feeds: FeedData[];
  episodes: EpisodeData[];
}

export interface SearchService {
  searchAll(query: string): SearchResult;
  searchInFeed(query: string, feedId: string): EpisodeData[];
}
