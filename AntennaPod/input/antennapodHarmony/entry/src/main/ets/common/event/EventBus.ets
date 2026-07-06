export enum AppEvent {
  FEEDS_CHANGED = 'FEEDS_CHANGED',
  EPISODES_CHANGED = 'EPISODES_CHANGED',
  QUEUE_CHANGED = 'QUEUE_CHANGED',
  DOWNLOAD_PROGRESS = 'DOWNLOAD_PROGRESS',
  INBOX_CHANGED = 'INBOX_CHANGED',
  FAVORITES_CHANGED = 'FAVORITES_CHANGED',
  PLAYBACK_STATE_CHANGED = 'PLAYBACK_STATE_CHANGED',
  PREFERENCES_CHANGED = 'PREFERENCES_CHANGED',
  PLAYBACK_HISTORY_CHANGED = 'PLAYBACK_HISTORY_CHANGED'
}

export interface EpisodePayload {
  episodeId: string;
  feedId?: string;
}

export interface DownloadPayload {
  episodeId: string;
  percent: number;
  state: string;
}

export interface PrefPayload {
  key: string;
}

type EventListener = (payload?: object) => void;

class EventBusImpl {
  private listeners: Map<string, EventListener[]> = new Map<string, EventListener[]>();

  on(event: AppEvent, listener: EventListener): void {
    const key: string = event as string;
    const existing: EventListener[] | undefined = this.listeners.get(key);
    let arr: EventListener[];
    if (existing) {
      arr = existing;
    } else {
      arr = [];
      this.listeners.set(key, arr);
    }
    arr.push(listener);
  }

  off(event: AppEvent, listener: EventListener): void {
    const key: string = event as string;
    const arr: EventListener[] | undefined = this.listeners.get(key);
    if (!arr) {
      return;
    }
    const idx: number = arr.indexOf(listener);
    if (idx >= 0) {
      arr.splice(idx, 1);
    }
    if (arr.length === 0) {
      this.listeners.delete(key);
    }
  }

  emit(event: AppEvent, payload?: object): void {
    const key: string = event as string;
    const arr: EventListener[] | undefined = this.listeners.get(key);
    if (!arr) {
      return;
    }
    const snapshot: EventListener[] = arr.slice();
    for (let i = 0; i < snapshot.length; i++) {
      try {
        snapshot[i](payload);
      } catch (e) {
        console.error(`EventBus listener for ${key} threw: ${e}`);
      }
    }
  }

  clearAll(): void {
    this.listeners.clear();
  }
}

export const eventBus: EventBusImpl = new EventBusImpl();
