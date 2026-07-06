import { EpisodeData, SecondaryActionType, DownloadState } from '../model/EpisodeData';
import { repository } from '../common/data/Repository';
import { serviceLocator } from '../common/service/ServiceLocator';

@Observed
export class InboxViewModel {
  episodes: EpisodeData[] = [];
  sortOrder: string = 'date_desc';

  load(): void {
    this.reload();
  }

  reload(): void {
    const sort: 'date_desc' | 'date_asc' = this.sortOrder === 'date_asc' ? 'date_asc' : 'date_desc';
    this.episodes = repository.queryInbox(sort);
  }

  setSortOrder(order: string): void {
    this.sortOrder = order;
    this.reload();
  }

  removeAll(): void {
    repository.removeAllFromInbox();
    this.reload();
  }

  markPlayed(episode: EpisodeData): void {
    repository.markPlayed(episode.id, true);
    this.reload();
  }

  toggleQueue(episode: EpisodeData): void {
    if (episode.inQueue) {
      repository.dequeue(episode.id);
    } else {
      repository.enqueue(episode.id);
    }
    this.reload();
  }

  toggleFavorite(episode: EpisodeData): void {
    repository.setFavorite(episode.id, !episode.isFavorite);
    this.reload();
  }

  resetPosition(episode: EpisodeData): void {
    repository.resetPosition(episode.id);
    this.reload();
  }

  removeFromInbox(episode: EpisodeData): void {
    repository.removeFromInbox(episode.id);
    this.reload();
  }

  toggleSecondaryAction(episode: EpisodeData): void {
    if (episode.downloadState === DownloadState.DOWNLOADING) {
      serviceLocator.downloadService().cancel(episode.id);
    } else if (episode.downloadState === DownloadState.NONE) {
      serviceLocator.downloadService().start(episode.id);
    }
    this.reload();
  }
}

export const inboxViewModel: InboxViewModel = new InboxViewModel();
