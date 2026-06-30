import emitter from '@ohos.events.emitter';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN: number = 0x0000;
const TAG: string = 'EventBus';

// Global typed event identifiers. Repository writes publish one of these after
// a successful DB mutation; ViewModels subscribe to their domain event(s) and
// re-query the repository on receipt, satisfying the spec's pervasive
// "real-time refresh" (queue, inbox, episodes, subscriptions, downloads).
export enum EventType {
  QUEUE_CHANGED = 1001, // QueueRepository writes
  EPISODE_UPDATED = 1002, // EpisodeRepository writes (read/favorite/downloaded)
  FEED_LIST_UPDATE = 1003, // FeedRepository / TagRepository writes + prefs changes affecting lists
  DOWNLOAD_EVENT = 1004, // DownloadService / DownloadRepository (progress + final result)
  MESSAGE_EVENT = 1005, // user-facing toast / snackbar messages
  PLAYBACK_POSITION = 1006 // PlaybackService progress ticks
}

// Generic payload carried by every event. Subscribers read only the fields
// relevant to their event; publishers populate exactly those fields.
export class EventPayload {
  feedId: number = 0;
  feedItemId: number = 0;
  progress: number = 0;
  message: string = '';
  ok: boolean = true;
  errorType: string = '';
  resultId: number = 0;

  constructor() {
  }
}

// Internal subscription record. Kept in a registry so a specific subscription
// can be removed without removing others that share the same event id.
class Subscription {
  eventType: number;
  wrapped: (eventData: emitter.EventData) => void;

  constructor(eventType: number, wrapped: (eventData: emitter.EventData) => void) {
    this.eventType = eventType;
    this.wrapped = wrapped;
  }
}

// Thin wrapper around @ohos.events.emitter. Single global bus; never duplicated.
// subscribe() returns a numeric handle; unsubscribe(handle) removes exactly that
// one listener, so coexisting pages subscribing to the same event do not
// clobber each other.
export class EventBus {
  private static registry: Map<number, Subscription> = new Map<number, Subscription>();
  private static nextHandle: number = 1;

  // Publish a typed event carrying a payload.
  static publish(eventType: EventType, payload: EventPayload): void {
    try {
      emitter.emit({ eventId: eventType as number }, { data: payload });
    } catch (err) {
      hilog.error(DOMAIN, TAG, 'publish failed: %{public}s', JSON.stringify(err));
    }
  }

  // Publish a signal-only event (no payload). Subscribers receive a default payload.
  static publishSignal(eventType: EventType): void {
    try {
      emitter.emit({ eventId: eventType as number });
    } catch (err) {
      hilog.error(DOMAIN, TAG, 'publishSignal failed: %{public}s', JSON.stringify(err));
    }
  }

  // Subscribe to an event. The callback receives the published payload, or a
  // default payload for signal-only events. Returns a handle for unsubscribe().
  static subscribe(eventType: EventType, callback: (payload: EventPayload) => void): number {
    const wrapped = (eventData: emitter.EventData): void => {
      const data = eventData.data;
      if (data !== undefined && data !== null) {
        callback(data as EventPayload);
      } else {
        callback(new EventPayload());
      }
    };
    emitter.on({ eventId: eventType as number }, wrapped);
    const handle = EventBus.nextHandle;
    EventBus.nextHandle = handle + 1;
    EventBus.registry.set(handle, new Subscription(eventType as number, wrapped));
    return handle;
  }

  // Remove exactly one subscription by its handle (does not affect siblings).
  static unsubscribe(handle: number): void {
    const sub = EventBus.registry.get(handle);
    if (sub === undefined || sub === null) {
      return;
    }
    try {
      emitter.off(sub.eventType, sub.wrapped);
    } catch (err) {
      hilog.error(DOMAIN, TAG, 'unsubscribe failed: %{public}s', JSON.stringify(err));
    }
    EventBus.registry.delete(handle);
  }
}
