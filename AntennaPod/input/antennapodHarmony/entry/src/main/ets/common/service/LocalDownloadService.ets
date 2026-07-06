import { DownloadState } from '../../model/EpisodeData';
import { repository } from '../data/Repository';
import { DownloadService } from './DownloadService';

class LocalDownloadServiceImpl implements DownloadService {
  private timers: Map<string, number> = new Map<string, number>();
  private percents: Map<string, number> = new Map<string, number>();
  private running: boolean = false;

  start(episodeId: string): void {
    if (this.timers.has(episodeId)) {
      return;
    }
    this.running = true;
    this.percents.set(episodeId, 0);
    repository.setDownloadState(episodeId, DownloadState.DOWNLOADING, 0);
    const timer: number = setInterval((): void => {
      const cur: number = this.percents.get(episodeId) ?? 0;
      const next: number = Math.min(100, cur + 10);
      this.percents.set(episodeId, next);
      repository.setDownloadState(episodeId, DownloadState.DOWNLOADING, next);
      if (next >= 100) {
        this.clearTimer(episodeId);
        repository.setDownloadState(episodeId, DownloadState.DOWNLOADED, 100);
        if (this.timers.size === 0) {
          this.running = false;
        }
      }
    }, 600);
    this.timers.set(episodeId, timer);
  }

  cancel(episodeId: string): void {
    this.clearTimer(episodeId);
    this.percents.set(episodeId, 0);
    repository.setDownloadState(episodeId, DownloadState.CANCELED, 0);
    if (this.timers.size === 0) {
      this.running = false;
    }
  }

  delete(episodeId: string): void {
    this.clearTimer(episodeId);
    this.percents.delete(episodeId);
    repository.setDownloadState(episodeId, DownloadState.NONE, 0);
    if (this.timers.size === 0) {
      this.running = false;
    }
  }

  isRunning(): boolean {
    return this.running;
  }

  private clearTimer(episodeId: string): void {
    const t: number | undefined = this.timers.get(episodeId);
    if (t !== undefined) {
      clearInterval(t);
      this.timers.delete(episodeId);
    }
  }
}

export const localDownloadService: DownloadService = new LocalDownloadServiceImpl();
