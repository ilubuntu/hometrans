import { EpisodeData, SecondaryActionType, DownloadState } from '../model/EpisodeData';
import { FeedData } from '../model/FeedData';
import { repository } from '../common/data/Repository';
import { preferencesStore } from '../common/data/PreferencesStore';
import { serviceLocator } from '../common/service/ServiceLocator';

@Observed
export class FeedDetailViewModel {
  feed: FeedData = new FeedData('feed_morbid', 'Morbid', 0, $r('app.media.ic_feed'));
  allEpisodes: EpisodeData[] = [];
  episodes: EpisodeData[] = [];
  filterValues: string[] = [];
  sortOrder: string = 'date_desc';

  loadById(feedId: string): void {
    this.sortOrder = preferencesStore.getSync('feedDetailSortOrder', 'date_desc');
    this.filterValues = this.loadFilter();
    this.reload(feedId);
  }

  private loadFilter(): string[] {
    const obj: object | undefined = preferencesStore.getObjectSync('feedDetailFilter');
    if (!obj) {
      return [];
    }
    return (obj as string[]).slice();
  }

  private saveFilter(): void {
    preferencesStore.putObject('feedDetailFilter', this.filterValues.slice());
  }

  reload(feedId: string): void {
    const feed: FeedData | undefined = repository.getFeed(feedId);
    if (feed) {
      this.feed = feed;
    }
    this.allEpisodes = repository.queryEpisodes([], this.sortOrder === 'date_asc' ? 'date_asc' : 'date_desc', feedId);
    this.applyFilter();
  }

  applyFilter(values?: string[]): void {
    if (values) {
      this.filterValues = values;
      this.saveFilter();
    }
    this.episodes = repository.queryEpisodes(this.filterValues,
      this.sortOrder === 'date_asc' ? 'date_asc' : 'date_desc', this.feed.id);
  }

  setSortOrder(order: string): void {
    this.sortOrder = order;
    preferencesStore.putString('feedDetailSortOrder', order);
    this.applyFilter();
  }

  resetFilter(): void {
    this.filterValues = [];
    this.saveFilter();
    this.applyFilter();
  }

  hasActiveFilter(): boolean {
    return this.filterValues.length > 0;
  }

  toggleSubscribe(): void {
    if (this.feed.subscribed) {
      repository.unsubscribe(this.feed.id);
    } else {
      this.feed.subscribed = true;
    }
  }

  toggleSecondaryAction(episode: EpisodeData): void {
    if (episode.downloadState === DownloadState.DOWNLOADING) {
      serviceLocator.downloadService().cancel(episode.id);
    } else if (episode.downloadState === DownloadState.NONE) {
      serviceLocator.downloadService().start(episode.id);
    }
    this.reload(this.feed.id);
  }

  togglePlayed(episode: EpisodeData): void {
    repository.markPlayed(episode.id, episode.progress < 100);
    this.reload(this.feed.id);
  }

  markPlayed(episode: EpisodeData): void {
    repository.markPlayed(episode.id, true);
    this.reload(this.feed.id);
  }

  toggleQueue(episode: EpisodeData): void {
    if (episode.inQueue) {
      repository.dequeue(episode.id);
    } else {
      repository.enqueue(episode.id);
    }
    this.reload(this.feed.id);
  }

  toggleFavorite(episode: EpisodeData): void {
    repository.setFavorite(episode.id, !episode.isFavorite);
    this.reload(this.feed.id);
  }

  resetPosition(episode: EpisodeData): void {
    repository.resetPosition(episode.id);
    this.reload(this.feed.id);
  }

  deleteEpisode(episode: EpisodeData): void {
    repository.setDownloadState(episode.id, DownloadState.NONE, 0);
    this.reload(this.feed.id);
  }

  removeAllFromInbox(): void {
    repository.removeAllFromInbox(this.feed.id);
    this.reload(this.feed.id);
  }

  refresh(): Promise<void> {
    return repository.refreshFeed(this.feed.id);
  }

  setFeedTags(tags: string[]): Promise<void> {
    return repository.setFeedTags(this.feed.id, tags);
  }

  feedTags(): string[] {
    return repository.feedTags(this.feed.id);
  }
}

export const feedDetailViewModel: FeedDetailViewModel = new FeedDetailViewModel();
