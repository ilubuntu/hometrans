import { EpisodeData } from '../../model/EpisodeData';

export interface FeedFetcher {
  fetchByUrl(url: string): Promise<FetchResult | undefined>;
  searchByTitle(title: string): Promise<FetchResult[]>;
}

export interface FetchResult {
  feedId: string;
  title: string;
  author: string;
  description: string;
  feedUrl: string;
  coverKey: string;
  tags: string[];
  episodes: EpisodeData[];
  subscribed: boolean;
}
