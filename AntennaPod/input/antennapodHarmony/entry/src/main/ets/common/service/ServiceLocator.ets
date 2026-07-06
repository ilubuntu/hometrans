import { FeedFetcher } from './FeedFetcher';
import { sampleFeedFetcher } from './SampleFeedFetcher';
import { DownloadService } from './DownloadService';
import { localDownloadService } from './LocalDownloadService';
import { PlaybackService } from './LocalPlaybackService';
import { localPlaybackService } from './LocalPlaybackService';
import { SearchService, SearchResult } from './SearchService';
import { repository } from '../data/Repository';
import { EpisodeData } from '../../model/EpisodeData';

class LocalSearchServiceImpl implements SearchService {
  searchAll(query: string): SearchResult {
    return {
      feeds: repository.searchFeeds(query),
      episodes: repository.search(query)
    } as SearchResult;
  }

  searchInFeed(query: string, feedId: string): EpisodeData[] {
    return repository.search(query, feedId);
  }
}

class ServiceLocatorImpl {
  feedFetcher(): FeedFetcher {
    return sampleFeedFetcher;
  }

  downloadService(): DownloadService {
    return localDownloadService;
  }

  playbackService(): PlaybackService {
    return localPlaybackService;
  }

  searchService(): SearchService {
    return new LocalSearchServiceImpl();
  }
}

export const serviceLocator: ServiceLocatorImpl = new ServiceLocatorImpl();
