import { EpisodeData, SecondaryActionType, DownloadState } from '../model/EpisodeData';
import { repository } from '../common/data/Repository';
import { preferencesStore } from '../common/data/PreferencesStore';
import { serviceLocator } from '../common/service/ServiceLocator';

export interface FilterValue {
  filterId: string;
  label: Resource;
}

export interface FilterGroup {
  values: FilterValue[];
}

export const EPISODE_FILTER_GROUPS: FilterGroup[] = [
  { values: [
    { filterId: 'played', label: $r('app.string.hide_played_episodes_label') },
    { filterId: 'unplayed', label: $r('app.string.not_played') }
  ] },
  { values: [
    { filterId: 'paused', label: $r('app.string.hide_paused_episodes_label') },
    { filterId: 'not_paused', label: $r('app.string.not_paused') }
  ] },
  { values: [
    { filterId: 'is_favorite', label: $r('app.string.hide_is_favorite_label') },
    { filterId: 'not_favorite', label: $r('app.string.not_favorite') }
  ] },
  { values: [
    { filterId: 'has_media', label: $r('app.string.has_media') },
    { filterId: 'no_media', label: $r('app.string.no_media') }
  ] },
  { values: [
    { filterId: 'queued', label: $r('app.string.queued_label') },
    { filterId: 'not_queued', label: $r('app.string.not_queued_label') }
  ] },
  { values: [
    { filterId: 'downloaded', label: $r('app.string.hide_downloaded_episodes_label') },
    { filterId: 'not_downloaded', label: $r('app.string.hide_not_downloaded_episodes_label') }
  ] }
];

@Observed
export class EpisodesViewModel {
  allEpisodes: EpisodeData[] = [];
  episodes: EpisodeData[] = [];
  filterValues: string[] = [];
  sortOrder: string = 'date_desc';
  isLoading: boolean = false;

  load(): void {
    this.sortOrder = preferencesStore.getSync('episodesSortOrder', 'date_desc');
    this.filterValues = this.loadFilter();
    this.reload();
  }

  private loadFilter(): string[] {
    const obj: object | undefined = preferencesStore.getObjectSync('episodesFilter');
    if (!obj) {
      return [];
    }
    const arr: string[] = obj as string[];
    return arr.slice();
  }

  private saveFilter(): void {
    preferencesStore.putObject('episodesFilter', this.filterValues.slice());
  }

  reload(): void {
    this.allEpisodes = repository.queryEpisodes([], this.sortOrder === 'date_asc' ? 'date_asc' : 'date_desc');
    this.applyFilter();
  }

  applyFilter(values?: string[]): void {
    if (values) {
      this.filterValues = values;
      this.saveFilter();
    }
    this.episodes = repository.queryEpisodes(this.filterValues,
      this.sortOrder === 'date_asc' ? 'date_asc' : 'date_desc');
  }

  resetFilter(): void {
    this.filterValues = [];
    this.saveFilter();
    this.applyFilter();
  }

  setSortOrder(order: string): void {
    this.sortOrder = order;
    preferencesStore.putString('episodesSortOrder', order);
    this.applyFilter();
  }

  hasActiveFilter(): boolean {
    return this.filterValues.length > 0;
  }

  toggleSecondaryAction(episode: EpisodeData): void {
    if (episode.downloadState === DownloadState.DOWNLOADING) {
      serviceLocator.downloadService().cancel(episode.id);
    } else if (episode.downloadState === DownloadState.NONE) {
      serviceLocator.downloadService().start(episode.id);
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
    repository.setDownloadState(episode.id, DownloadState.NONE, 0);
    this.reload();
  }
}

export const episodesViewModel: EpisodesViewModel = new EpisodesViewModel();
