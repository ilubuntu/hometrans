import { FeedUpdateService, StubFeedUpdateService } from './FeedUpdateService';
import { DownloadService, StubDownloadService } from './DownloadService';
import { PlaybackService, StubPlaybackService } from './PlaybackService';
import { OnlineSearchService, StubOnlineSearchService } from './OnlineSearchService';

// Single access point for transport services. Today all four are stub
// implementations; a later stage swaps in real network/media implementations
// without touching ViewModels.
export class ServiceLocator {
  private static feedUpdate: FeedUpdateService = new StubFeedUpdateService();
  private static download: DownloadService = new StubDownloadService();
  private static playback: PlaybackService = new StubPlaybackService();
  private static onlineSearch: OnlineSearchService = new StubOnlineSearchService();

  static getFeedUpdateService(): FeedUpdateService {
    return ServiceLocator.feedUpdate;
  }

  static getDownloadService(): DownloadService {
    return ServiceLocator.download;
  }

  static getPlaybackService(): PlaybackService {
    return ServiceLocator.playback;
  }

  static getOnlineSearchService(): OnlineSearchService {
    return ServiceLocator.onlineSearch;
  }
}
