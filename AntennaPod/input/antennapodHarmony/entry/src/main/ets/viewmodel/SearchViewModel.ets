import { EpisodeData, SecondaryActionType, DownloadState } from '../model/EpisodeData';
import { FeedData } from '../model/FeedData';
import { repository } from '../common/data/Repository';
import { preferencesStore } from '../common/data/PreferencesStore';
import { serviceLocator } from '../common/service/ServiceLocator';

@Observed
export class SearchViewModel {
  @Track query: string = '';
  @Track history: string[] = [];
  @Track feedResults: FeedData[] = [];
  @Track episodeResults: EpisodeData[] = [];
  @Track hasSearched: boolean = false;
  @Track isLoading: boolean = false;

  loadHistory(): void {
    const obj: object | undefined = preferencesStore.getObjectSync('searchHistory');
    if (obj) {
      this.history = (obj as string[]).slice();
    }
  }

  private saveHistory(): void {
    preferencesStore.putObject('searchHistory', this.history.slice());
  }

  search(query: string): void {
    this.query = query;
    if (query.length === 0) {
      this.feedResults = [];
      this.episodeResults = [];
      this.hasSearched = false;
      this.isLoading = false;
      return;
    }
    this.hasSearched = true;
    const result = serviceLocator.searchService().searchAll(query);
    this.feedResults = result.feeds;
    this.episodeResults = result.episodes;
    this.isLoading = false;
  }

  setLoading(loading: boolean): void {
    this.isLoading = loading;
  }

  addToHistory(entry: string): void {
    const trimmed: string = entry.trim();
    if (trimmed.length === 0) {
      return;
    }
    const without: string[] = this.history.filter((h: string): boolean => h.toLowerCase() !== trimmed.toLowerCase());
    without.unshift(trimmed);
    this.history = without.slice(0, 8);
    this.saveHistory();
  }

  removeHistory(entry: string): void {
    this.history = this.history.filter((h: string): boolean => h !== entry);
    this.saveHistory();
  }

  clearHistory(): void {
    this.history = [];
    this.saveHistory();
  }

  toggleSecondaryAction(episode: EpisodeData): void {
    if (episode.downloadState === DownloadState.DOWNLOADING) {
      serviceLocator.downloadService().cancel(episode.id);
    } else if (episode.downloadState === DownloadState.NONE) {
      serviceLocator.downloadService().start(episode.id);
    }
  }

  togglePlayed(episode: EpisodeData): void {
    repository.markPlayed(episode.id, episode.progress < 100);
  }

  markPlayed(episode: EpisodeData): void {
    repository.markPlayed(episode.id, true);
  }

  toggleQueue(episode: EpisodeData): void {
    if (episode.inQueue) {
      repository.dequeue(episode.id);
    } else {
      repository.enqueue(episode.id);
    }
  }

  toggleFavorite(episode: EpisodeData): void {
    repository.setFavorite(episode.id, !episode.isFavorite);
  }

  resetPosition(episode: EpisodeData): void {
    repository.resetPosition(episode.id);
  }

  deleteEpisode(episode: EpisodeData): void {
    repository.setDownloadState(episode.id, DownloadState.NONE, 0);
  }
}

export const searchViewModel: SearchViewModel = new SearchViewModel();
