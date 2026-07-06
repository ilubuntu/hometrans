import { EpisodeData, SecondaryActionType, DownloadState } from '../model/EpisodeData';
import { repository } from '../common/data/Repository';
import { serviceLocator } from '../common/service/ServiceLocator';

@Observed
export class DownloadsViewModel {
  episodes: EpisodeData[] = [];
  sortOrder: string = 'date_desc';

  load(): void {
    this.reload();
  }

  reload(): void {
    this.episodes = repository.queryDownloads();
  }

  delete(episode: EpisodeData): void {
    serviceLocator.downloadService().delete(episode.id);
    this.reload();
  }

  deletePlayed(): void {
    const played: EpisodeData[] = this.episodes.filter((ep: EpisodeData): boolean =>
      ep.downloadState === DownloadState.DOWNLOADED && ep.isPlayed);
    for (let i = 0; i < played.length; i++) {
      serviceLocator.downloadService().delete(played[i].id);
    }
    this.reload();
  }

  toggleSecondaryAction(episode: EpisodeData): void {
    if (episode.downloadState === DownloadState.DOWNLOADING) {
      serviceLocator.downloadService().cancel(episode.id);
    } else if (episode.downloadState === DownloadState.DOWNLOADED) {
      serviceLocator.playbackService().play(episode.id);
    }
    this.reload();
  }

  togglePlayed(episode: EpisodeData): void {
    repository.markPlayed(episode.id, episode.progress < 100);
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

  deleteEpisode(episode: EpisodeData): void {
    serviceLocator.downloadService().delete(episode.id);
    this.reload();
  }
}

export const downloadsViewModel: DownloadsViewModel = new DownloadsViewModel();
