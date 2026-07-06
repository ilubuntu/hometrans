import { playbackController, PlaybackControllerImpl } from '../playback/PlaybackController';
import { repository } from '../data/Repository';

export interface PlaybackService {
  play(episodeId: string): void;
  pause(): void;
  toggle(): void;
  seekTo(sec: number): void;
  seekBy(deltaSec: number): void;
  setSpeed(speed: number): void;
  next(): void;
}

class LocalPlaybackServiceImpl implements PlaybackService {
  play(episodeId: string): void {
    const ep = repository.getEpisode(episodeId);
    if (!ep) return;
    playbackController.setEpisode(ep);
    playbackController.play();
    repository.recordHistory(episodeId, ep.positionSec);
  }

  pause(): void {
    playbackController.pause();
  }

  toggle(): void {
    playbackController.togglePlay();
  }

  seekTo(sec: number): void {
    playbackController.seekTo(sec);
  }

  seekBy(deltaSec: number): void {
    playbackController.seekBy(deltaSec);
  }

  setSpeed(speed: number): void {
    playbackController.setSpeed(speed);
  }

  next(): void {
    playbackController.skipToNext();
  }
}

export const localPlaybackService: PlaybackService = new LocalPlaybackServiceImpl();
export { PlaybackControllerImpl };
