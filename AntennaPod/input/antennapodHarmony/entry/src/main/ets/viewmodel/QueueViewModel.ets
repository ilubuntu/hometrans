import { FeedItem } from '../model/EpisodeModel';
import { ViewModelBase } from './ViewModelBase';
import { EventBus, EventType, EventPayload } from '../data/event/EventBus';
import { QueueRepository } from '../data/repository/QueueRepository';
import { PreferencesRepository } from '../data/repository/PreferencesRepository';
import { ServiceLocator } from '../data/service/ServiceLocator';

// Queue page ViewModel. Reads the queue from QueueRepository, reflects lock /
// keep-sorted preferences, and re-queries on QUEUE_CHANGED events. It owns no
// truth — the Queue table (via the repository) is the single live fact.
export class QueueViewModel extends ViewModelBase {
  queue: FeedItem[] = [];
  isLoading: boolean = true;
  isLocked: boolean = false;
  isKeepSorted: boolean = false;
  infoBarText: string = '';

  subscribeEvents(): void {
    this.subscribe(EventType.QUEUE_CHANGED, (payload: EventPayload): void => {
      this.loadItems();
    });
  }

  async onAppear(): Promise<void> {
    await super.onAppear();
    await this.loadItems();
  }

  async loadItems(): Promise<void> {
    this.isLoading = true;
    this.notify();
    try {
      const repo = QueueRepository.getInstance();
      const prefs = PreferencesRepository.getInstance();
      this.queue = await repo.getQueue();
      this.isLocked = await prefs.getQueueLocked();
      this.isKeepSorted = await prefs.getKeepQueueSorted();
    } catch (err) {
      console.error('QueueViewModel loadItems failed: ' + JSON.stringify(err));
      this.queue = [];
    }
    this.isLoading = false;
    this.refreshInfoBar();
    this.notify();
  }

  refreshInfoBar(): void {
    if (this.queue.length === 0) {
      this.infoBarText = '0 episodes • 0 minutes left';
      return;
    }
    let timeLeft = 0;
    for (const item of this.queue) {
      if (item.media !== null) {
        timeLeft += Math.max(item.media.duration - item.media.position, 0);
      }
    }
    const episodesWord = this.queue.length === 1 ? 'episode' : 'episodes';
    this.infoBarText = this.queue.length + ' ' + episodesWord + ' • ' + this.formatDuration(timeLeft) + ' left';
  }

  private formatDuration(ms: number): string {
    const totalSec = Math.floor(ms / 1000);
    const hours = Math.floor(totalSec / 3600);
    const minutes = Math.floor((totalSec % 3600) / 60);
    if (hours > 0) {
      return hours + (hours === 1 ? ' hour' : ' hours');
    }
    return minutes + (minutes === 1 ? ' minute' : ' minutes');
  }

  async toggleLock(): Promise<void> {
    this.isLocked = !this.isLocked;
    await PreferencesRepository.getInstance().setQueueLocked(this.isLocked);
    this.refreshInfoBar();
    this.notify();
  }

  async clearQueue(): Promise<void> {
    await QueueRepository.getInstance().clearQueue();
    // The QUEUE_CHANGED event will trigger loadItems(); refresh optimistically.
    this.queue = [];
    this.refreshInfoBar();
    this.notify();
  }

  sort(): void {
    // Queue sort dialog is a UI-stage concern; the keep-sorted preference is
    // the data path and already reflected via loadItems().
    console.info('QueueViewModel: open queue sort dialog (UI stage)');
  }

  async refresh(): Promise<void> {
    await ServiceLocator.getFeedUpdateService().refreshAllFeeds();
  }

  search(): void {
    // Navigate to the search page scoped to queued items (UI stage).
    console.info('QueueViewModel: navigate to search (queued filter)');
  }

  canReorder(): boolean {
    return !this.isLocked && !this.isKeepSorted;
  }
}
