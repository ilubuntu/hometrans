import { EpisodeData, SecondaryActionType, DownloadState } from '../model/EpisodeData';
import { repository } from '../common/data/Repository';
import { preferencesStore } from '../common/data/PreferencesStore';
import { serviceLocator } from '../common/service/ServiceLocator';

@Observed
export class QueueViewModel {
  episodes: EpisodeData[] = [];
  isLocked: boolean = false;

  load(): void {
    this.reload();
  }

  reload(): void {
    this.episodes = repository.queryQueue();
    this.isLocked = preferencesStore.getBooleanSync('queueLock', false);
  }

  isLockedOrKeepSort(): boolean {
    return this.isLocked || preferencesStore.getBooleanSync('queueKeepSort', false);
  }

  buildInfoBar(): string {
    const count: number = this.episodes.length;
    const episodeWord: string = count === 1 ? 'episode' : 'episodes';
    const remaining: number = repository.queueRemainingSec();
    return `${count} ${episodeWord} • ${this.formatRemaining(remaining)} left`;
  }

  private formatRemaining(sec: number): string {
    if (sec <= 0) {
      return '0 minutes';
    }
    const hr: number = Math.floor(sec / 3600);
    const min: number = Math.floor((sec % 3600) / 60);
    if (hr > 0 && min > 0) {
      return `${hr} hour${hr > 1 ? 's' : ''} ${min} minutes`;
    }
    if (hr > 0) {
      return `${hr} hour${hr > 1 ? 's' : ''}`;
    }
    return `${min} minute${min === 1 ? '' : 's'}`;
  }

  reorder(from: number, to: number): void {
    if (this.isLockedOrKeepSort()) {
      this.reload();
      return;
    }
    repository.moveTo(from, to);
    this.reload();
  }

  removeAt(index: number): void {
    if (index < 0 || index >= this.episodes.length) {
      return;
    }
    const ep: EpisodeData = this.episodes[index];
    repository.dequeue(ep.id);
    this.reload();
  }

  setLocked(locked: boolean): void {
    this.isLocked = locked;
    preferencesStore.putBoolean('queueLock', locked);
  }

  toggleLock(): void {
    this.setLocked(!this.isLocked);
  }

  sortQueue(): Promise<void> {
    return repository.sortQueueAlpha();
  }

  clearQueue(): Promise<void> {
    return repository.clearQueue();
  }

  toggleSecondaryAction(episode: EpisodeData): void {
    if (episode.downloadState === DownloadState.DOWNLOADING) {
      serviceLocator.downloadService().cancel(episode.id);
    } else if (episode.downloadState === DownloadState.NONE) {
      serviceLocator.downloadService().start(episode.id);
    } else {
      this.reload();
    }
  }
}

export const queueViewModel: QueueViewModel = new QueueViewModel();
