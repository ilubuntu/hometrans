import { EpisodeData, SecondaryActionType, DownloadState } from '../model/EpisodeData';
import { repository } from '../common/data/Repository';
import { SampleData } from '../common/data/SampleData';
import { serviceLocator } from '../common/service/ServiceLocator';
import { preferencesStore } from '../common/data/PreferencesStore';

export interface ChapterItem {
  index: number;
  title: string;
  startSec: number;
  endSec: number;
}

@Observed
export class EpisodeDetailViewModel {
  @Track episodeId: string = '';
  @Track title: string = '';
  @Track podcastTitle: string = '';
  @Track podcastAuthor: string = '';
  @Track feedId: string = '';
  @Track pubDate: string = '';
  @Track cover: Resource = $r('app.media.ic_feed');
  @Track shownotes: string = '';
  @Track chapters: ChapterItem[] = [];
  @Track relatedEpisodes: EpisodeData[] = [];
  @Track relatedFeedIds: string[] = [];

  @Track positionSec: number = 0;
  @Track durationSec: number = 0;
  @Track positionLabel: string = '00:00';
  @Track durationLabel: string = '00:00';
  @Track durationDesc: string = '';
  @Track progressPct: number = 0;
  @Track playbackSpeed: number = 1.0;
  @Track playbackSpeedLabel: string = '1.00';

  @Track isPlaying: boolean = false;
  @Track isFavorite: boolean = false;
  @Track inQueue: boolean = false;
  @Track isInbox: boolean = false;
  @Track isPlayed: boolean = false;
  @Track sleepTimerEnabled: boolean = false;
  @Track websiteUrl: string = '';
  @Track downloadState: DownloadState = DownloadState.NONE;

  @Track rewindSeconds: number = 10;
  @Track fastForwardSeconds: number = 30;

  loadById(episodeId: string): void {
    const ep: EpisodeData | undefined = repository.getEpisode(episodeId);
    if (ep) {
      this.applyEpisode(ep);
    } else {
      this.applyFallback(episodeId);
    }
  }

  loadByTitle(title: string): void {
    const ep: EpisodeData | undefined = repository.search(title).find((e: EpisodeData): boolean => e.title === title);
    if (ep) {
      this.applyEpisode(ep);
    } else {
      this.applyFallback('');
    }
  }

  private applyEpisode(ep: EpisodeData): void {
    this.episodeId = ep.id;
    this.title = ep.title;
    this.podcastTitle = ep.author;
    this.feedId = ep.feedId;
    this.pubDate = ep.pubDate;
    this.cover = ep.cover;
    this.shownotes = '';
    this.chapters = SampleData.chaptersFor(ep.id).slice().map((c): ChapterItem => {
      return { index: c.index, title: c.title, startSec: c.startSec, endSec: c.endSec } as ChapterItem;
    });
    this.positionSec = ep.positionSec;
    this.durationSec = ep.durationSec;
    this.playbackSpeed = 1.0;
    this.isPlaying = false;
    this.isFavorite = ep.isFavorite;
    this.inQueue = ep.inQueue;
    this.isInbox = ep.isInbox || ep.isNew;
    this.isPlayed = ep.isPlayed;
    this.sleepTimerEnabled = false;
    this.websiteUrl = ep.websiteUrl;
    this.downloadState = ep.downloadState;
    this.rewindSeconds = preferencesStore.getNumberSync('rewindSeconds', 10);
    this.fastForwardSeconds = preferencesStore.getNumberSync('fastForwardSeconds', 30);
    this.relatedFeedIds = this.buildRelatedFeedIds(ep.feedId);
    this.relatedEpisodes = this.buildRelated(ep);
    this.refreshTimeLabels();
  }

  private applyFallback(episodeId: string): void {
    const fallback: EpisodeData | undefined = repository.queryEpisodes([], 'date_desc')[0];
    if (fallback) {
      this.applyEpisode(fallback);
      return;
    }
    this.episodeId = episodeId.length > 0 ? episodeId : 'unknown';
    this.title = '';
  }

  private buildRelatedFeedIds(currentFeedId: string): string[] {
    const feeds = repository.queryFeeds();
    const out: string[] = [];
    for (let i = 0; i < feeds.length; i++) {
      if (feeds[i].id !== currentFeedId) {
        out.push(feeds[i].id);
      }
      if (out.length >= 4) {
        break;
      }
    }
    return out;
  }

  private buildRelated(ep: EpisodeData): EpisodeData[] {
    return repository.queryEpisodes([], 'date_desc', ep.feedId)
      .filter((c: EpisodeData): boolean => c.id !== ep.id)
      .slice(0, 3);
  }

  private refreshTimeLabels(): void {
    this.positionLabel = SampleData.formatClock(this.positionSec);
    this.durationLabel = SampleData.formatClock(this.durationSec);
    this.durationDesc = SampleData.formatDurationDesc(this.durationSec);
    this.progressPct = this.durationSec > 0
      ? Math.min(100, Math.floor((this.positionSec / this.durationSec) * 100)) : 0;
    this.playbackSpeedLabel = this.playbackSpeed.toFixed(2);
  }

  hasChapters(): boolean {
    return this.chapters.length > 0;
  }

  togglePlay(): void {
    if (this.episodeId.length === 0) return;
    if (this.isPlaying) {
      serviceLocator.playbackService().pause();
      this.isPlaying = false;
    } else {
      serviceLocator.playbackService().play(this.episodeId);
      this.isPlaying = true;
    }
  }

  seekTo(sec: number): void {
    serviceLocator.playbackService().seekTo(Math.max(0, Math.min(sec, this.durationSec)));
    this.positionSec = Math.max(0, Math.min(sec, this.durationSec));
    this.refreshTimeLabels();
  }

  seekBy(deltaSec: number): void {
    this.seekTo(this.positionSec + deltaSec);
  }

  setPlaybackSpeed(speed: number): void {
    this.playbackSpeed = speed;
    serviceLocator.playbackService().setSpeed(speed);
    this.refreshTimeLabels();
  }

  cyclePlaybackSpeed(): void {
    const speeds: number[] = [1.0, 1.25, 1.5, 1.75, 2.0, 0.75];
    const idx: number = speeds.findIndex((v: number): boolean => Math.abs(v - this.playbackSpeed) < 0.01);
    const nextIdx: number = idx >= 0 ? (idx + 1) % speeds.length : 0;
    this.setPlaybackSpeed(speeds[nextIdx]);
  }

  toggleFavorite(): void {
    this.isFavorite = !this.isFavorite;
    repository.setFavorite(this.episodeId, this.isFavorite);
  }

  toggleQueue(): void {
    if (this.inQueue) {
      repository.dequeue(this.episodeId);
      this.inQueue = false;
    } else {
      repository.enqueue(this.episodeId);
      this.inQueue = true;
    }
  }

  togglePlayed(): void {
    this.isPlayed = !this.isPlayed;
    repository.markPlayed(this.episodeId, this.isPlayed);
  }

  toggleSleepTimer(): void {
    this.sleepTimerEnabled = !this.sleepTimerEnabled;
  }

  resetPosition(): void {
    this.positionSec = 0;
    repository.resetPosition(this.episodeId);
    this.refreshTimeLabels();
  }

  removeFromInbox(): void {
    this.isInbox = false;
    repository.removeFromInbox(this.episodeId);
  }

  startDownload(): void {
    serviceLocator.downloadService().start(this.episodeId);
  }

  cancelDownload(): void {
    serviceLocator.downloadService().cancel(this.episodeId);
  }

  deleteDownload(): void {
    serviceLocator.downloadService().delete(this.episodeId);
  }
}

export const episodeDetailViewModel: EpisodeDetailViewModel = new EpisodeDetailViewModel();
