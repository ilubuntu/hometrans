import { EventBus, EventType, EventPayload } from '../data/event/EventBus';

// Base for every page ViewModel. Provides:
//  - a refresh callback the page registers so async repository reads + event
//    reloads can push new state into page-bound @State fields, and
//  - per-subscription handle tracking so domain-event subscriptions are removed
//    cleanly in aboutToAboutToDisappear without affecting other pages.
//
// ViewModels are READERS/CONSUMERS only. They never own truth or persist
// directly — every value they hold is the result of a repository read.
export class ViewModelBase {
  private refreshCallback: (() => void) | null = null;
  private handles: number[] = [];

  // Page registers a callback invoked whenever the VM's observable state
  // changes (after an async load completes, or after a domain event re-query).
  setRefreshCallback(callback: () => void): void {
    this.refreshCallback = callback;
  }

  protected notify(): void {
    if (this.refreshCallback !== null) {
      this.refreshCallback();
    }
  }

  // Subscribe to a domain event; the callback re-runs on the main thread.
  // The handle is tracked for automatic unsubscribe in onDisappear().
  protected subscribe(eventType: EventType, callback: (payload: EventPayload) => void): void {
    const handle = EventBus.subscribe(eventType, callback);
    this.handles.push(handle);
  }

  // Override to register domain-event subscriptions.
  subscribeEvents(): void {
  }

  // Called by the page when it leaves; removes every subscription this VM made.
  unsubscribeEvents(): void {
    for (let i = 0; i < this.handles.length; i++) {
      EventBus.unsubscribe(this.handles[i]);
    }
    this.handles = [];
  }

  // Lifecycle entry: register subscriptions. Subclasses override and also kick
  // off their initial load after calling super.onAppear().
  async onAppear(): Promise<void> {
    this.subscribeEvents();
  }

  // Lifecycle exit: remove subscriptions.
  onDisappear(): void {
    this.unsubscribeEvents();
  }
}
