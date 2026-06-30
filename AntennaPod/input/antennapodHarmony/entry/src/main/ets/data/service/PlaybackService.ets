import { EventBus, EventType, EventPayload } from '../event/EventBus';
import { EpisodeRepository } from '../repository/EpisodeRepository';
import { HistoryRepository } from '../repository/HistoryRepository';

// Playback transport interface. Real AVPlayer (@kit.Multimedia) wiring is
// deferred; this interface keeps playback actions + position events wired.
export interface PlaybackService {
  play(itemId: number): Promise<void>;
  pause(): void;
  // Persist playback position and emit a PLAYBACK_POSITION event.
  setPosition(itemId: number, positionMs: number, durationMs: number): Promise<void>;
  // Mark an episode fully played: read=1, history recorded.
  markCompleted(itemId: number): Promise<void>;
}

// Stub implementation: no audio device. Position is persisted and events are
// emitted so every UI that depends on playback state stays correct.
export class StubPlaybackService implements PlaybackService {
  private readonly episodes: EpisodeRepository = EpisodeRepository.getInstance();
  private readonly history: HistoryRepository = HistoryRepository.getInstance();

  async play(itemId: number): Promise<void> {
    const p = new EventPayload();
    p.feedItemId = itemId;
    p.progress = 0;
    EventBus.publish(EventType.PLAYBACK_POSITION, p);
  }

  pause(): void {
    // No transport; no-op.
  }

  async setPosition(itemId: number, positionMs: number, durationMs: number): Promise<void> {
    const completion = durationMs > 0 ? Math.min(100, Math.floor(100 * positionMs / durationMs)) : 0;
    await this.episodes.setMediaPosition(itemId, positionMs, completion);
  }

  async markCompleted(itemId: number): Promise<void> {
    await this.episodes.setRead(itemId, true);
    await this.history.addItem(itemId);
  }
}
