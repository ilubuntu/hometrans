import { FeedData, FeedCounterDisplay } from '../model/FeedData';
import { repository } from '../common/data/Repository';
import { preferencesStore } from '../common/data/PreferencesStore';

@Observed
export class SubscriptionsViewModel {
  feeds: FeedData[] = [];
  sortOrder: string = 'date_desc';
  selectedTag: string = '';
  availableTags: string[] = [];

  load(): void {
    this.reload();
  }

  reload(): void {
    let feeds: FeedData[] = repository.queryFeeds().filter((f: FeedData): boolean => f.subscribed);
    if (this.selectedTag.length > 0) {
      feeds = feeds.filter((f: FeedData): boolean => f.tags.indexOf(this.selectedTag) >= 0);
    }
    feeds = feeds.slice().sort((a: FeedData, b: FeedData): number => {
      if (this.sortOrder === 'date_asc') {
        return a.title.localeCompare(b.title);
      }
      return b.title.localeCompare(a.title);
    });
    this.feeds = feeds;
    this.availableTags = this.collectTags();
  }

  private collectTags(): string[] {
    const all: FeedData[] = repository.queryFeeds();
    const seen: Set<string> = new Set<string>();
    for (let i = 0; i < all.length; i++) {
      const tags: string[] = all[i].tags;
      for (let j = 0; j < tags.length; j++) {
        seen.add(tags[j]);
      }
    }
    return Array.from(seen).sort();
  }

  totalCount(): number {
    let sum: number = 0;
    for (const feed of this.feeds) {
      sum += feed.count;
    }
    return sum;
  }

  setSortOrder(order: string): void {
    this.sortOrder = order;
    preferencesStore.putString('subscriptionsSortOrder', order);
    this.reload();
  }

  setSelectedTag(tag: string): void {
    this.selectedTag = tag;
    this.reload();
  }

  setColumns(count: number): void {
    preferencesStore.putNumber('subscriptionsColumns', count);
  }

  getColumns(): number {
    return preferencesStore.getNumberSync('subscriptionsColumns', 3);
  }

  counterDisplay(): FeedCounterDisplay {
    const v: string = preferencesStore.getSync('counterDisplay', 'SHOW_NEW');
    return v as FeedCounterDisplay;
  }

  unsubscribe(feedId: string): void {
    repository.unsubscribe(feedId);
    this.reload();
  }
}

export const subscriptionsViewModel: SubscriptionsViewModel = new SubscriptionsViewModel();
