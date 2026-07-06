import { EpisodeData } from '../../model/EpisodeData';
import { repository } from '../data/Repository';
import { eventBus, AppEvent } from '../event/EventBus';
import { preferencesStore } from '../data/PreferencesStore';

@Observed
class PlaybackControllerImpl {
  @Track currentEpisodeId: string = '';
  @Track title: string = '';
  @Track author: string = '';
  @Track cover: Resource = $r('app.media.ic_feed');
  @Track positionSec: number = 0;
  @Track durationSec: number = 0;
  @Track isPlaying: boolean = false;
  @Track speed: number = 1.0;
  @Track progressPct: number = 0;
  @Track hasEpisode: boolean = false;

  private timerId: number = -1;

  setEpisode(episode: EpisodeData): void {
    if (this.currentEpisodeId === episode.id && this.hasEpisode) {
      return;
    }
    this.stopTick();
    this.currentEpisodeId = episode.id;
    this.title = episode.title;
    this.author = episode.author;
    this.cover = episode.cover;
    this.positionSec = episode.positionSec;
    this.durationSec = episode.durationSec;
    this.speed = preferencesStore.getNumberSync('playbackSpeed', 1.0);
    this.progressPct = episode.durationSec > 0
      ? Math.min(100, Math.floor((episode.positionSec / episode.durationSec) * 100)) : 0;
    this.hasEpisode = true;
    this.isPlaying = false;
    eventBus.emit(AppEvent.PLAYBACK_STATE_CHANGED);
  }

  play(): void {
    if (!this.hasEpisode) return;
    this.isPlaying = true;
    this.startTick();
    eventBus.emit(AppEvent.PLAYBACK_STATE_CHANGED);
  }

  pause(): void {
    this.isPlaying = false;
    this.stopTick();
    this.persistPosition();
    eventBus.emit(AppEvent.PLAYBACK_STATE_CHANGED);
  }

  togglePlay(): void {
    if (this.isPlaying) {
      this.pause();
    } else {
      this.play();
    }
  }

  seekTo(sec: number): void {
    this.positionSec = Math.max(0, Math.min(sec, this.durationSec));
    this.progressPct = this.durationSec > 0
      ? Math.min(100, Math.floor((this.positionSec / this.durationSec) * 100)) : 0;
    eventBus.emit(AppEvent.PLAYBACK_STATE_CHANGED);
  }

  seekBy(deltaSec: number): void {
    this.seekTo(this.positionSec + deltaSec);
  }

  setSpeed(speed: number): void {
    this.speed = speed;
    preferencesStore.putNumber('playbackSpeed', speed);
    eventBus.emit(AppEvent.PLAYBACK_STATE_CHANGED);
  }

  skipToNext(): void {
    if (!this.hasEpisode) return;
    const queue: EpisodeData[] = repository.queryQueue();
    const idx: number = queue.findIndex((e: EpisodeData): boolean => e.id === this.currentEpisodeId);
    const next: EpisodeData | undefined = idx >= 0 && idx + 1 < queue.length ? queue[idx + 1] : undefined;
    this.pause();
    if (next) {
      this.setEpisode(next);
      this.play();
    } else {
      this.hasEpisode = false;
      this.currentEpisodeId = '';
      this.isPlaying = false;
      eventBus.emit(AppEvent.PLAYBACK_STATE_CHANGED);
    }
  }

  clear(): void {
    this.stopTick();
    this.hasEpisode = false;
    this.currentEpisodeId = '';
    this.isPlaying = false;
    this.positionSec = 0;
    this.progressPct = 0;
    eventBus.emit(AppEvent.PLAYBACK_STATE_CHANGED);
  }

  private startTick(): void {
    this.stopTick();
    this.timerId = setInterval((): void => {
      if (this.positionSec < this.durationSec) {
        this.positionSec = Math.min(this.durationSec, this.positionSec + 1);
        this.progressPct = this.durationSec > 0
          ? Math.min(100, Math.floor((this.positionSec / this.durationSec) * 100)) : 0;
        if (this.positionSec % 5 === 0) {
          this.persistPosition();
        }
      } else {
        this.completeEpisode();
      }
    }, 1000);
  }

  private stopTick(): void {
    if (this.timerId >= 0) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
  }

  private completeEpisode(): void {
    this.stopTick();
    this.isPlaying = false;
    if (this.currentEpisodeId.length > 0) {
      repository.markPlayed(this.currentEpisodeId, true);
      repository.recordHistory(this.currentEpisodeId, this.durationSec);
      repository.dequeue(this.currentEpisodeId);
    }
    const queue: EpisodeData[] = repository.queryQueue();
    if (queue.length > 0) {
      this.setEpisode(queue[0]);
      this.play();
    } else {
      this.hasEpisode = false;
      this.currentEpisodeId = '';
    }
    eventBus.emit(AppEvent.PLAYBACK_STATE_CHANGED);
  }

  private persistPosition(): void {
    if (this.currentEpisodeId.length === 0) return;
    repository.setPosition(this.currentEpisodeId, this.positionSec);
  }
}

const controller: PlaybackControllerImpl = new PlaybackControllerImpl();
AppStorage.setOrCreate<PlaybackControllerImpl>('playback', controller);

export const playbackController: PlaybackControllerImpl = controller;
export { PlaybackControllerImpl };
