import { DownloadRepository } from '../repository/DownloadRepository';
import { EpisodeRepository } from '../repository/EpisodeRepository';
import { EventBus, EventType, EventPayload } from '../event/EventBus';
import { RepositoryResult, DownloadResult, DownloadErrorType } from '../../model/EpisodeModel';

// Media download transport interface. Real download worker
// (@kit.NetworkKit / file IO) is deferred; this interface keeps the download
// action, progress events, error mapping (REQ-039), and download log wired.
export interface DownloadService {
  // Begin downloading an episode. Emits progress events and, on completion,
  // writes a DownloadResult log row + flips FeedItem.downloaded.
  download(itemId: number, title: string): Promise<RepositoryResult>;
  // Cancel an in-flight download.
  cancel(itemId: number): Promise<void>;
}

// Stub implementation: simulates an immediate successful completion so the data
// path (downloaded flag + download log + events) is exercised without a live
// worker. Scenes asserting a real downloaded media file are NOT provable until
// the transport stage (decision contract "Unknown").
export class StubDownloadService implements DownloadService {
  private readonly downloads: DownloadRepository = DownloadRepository.getInstance();
  private readonly episodes: EpisodeRepository = EpisodeRepository.getInstance();

  async download(itemId: number, title: string): Promise<RepositoryResult> {
    // Emit a final progress event before recording the result.
    const progress = new EventPayload();
    progress.feedItemId = itemId;
    progress.progress = 100;
    EventBus.publish(EventType.DOWNLOAD_EVENT, progress);

    const now = Date.now();
    const log = new DownloadResult();
    log.completedDateMs = now;
    log.title = title;
    log.reason = 0; // success
    log.sourceType = 'feeditem';
    log.feeditemId = itemId;
    log.ok = true;
    log.errorType = DownloadErrorType.NONE;
    await this.downloads.addDownloadLog(log);
    await this.episodes.setDownloaded(itemId, true);

    const result = new RepositoryResult();
    result.ok = true;
    result.itemId = itemId;
    return result;
  }

  async cancel(itemId: number): Promise<void> {
    const now = Date.now();
    const log = new DownloadResult();
    log.completedDateMs = now;
    log.title = '';
    log.reason = 1; // cancelled / unknown
    log.sourceType = 'feeditem';
    log.feeditemId = itemId;
    log.ok = false;
    log.errorType = DownloadErrorType.ERROR_UNKNOWN;
    await this.downloads.addDownloadLog(log);
  }
}
