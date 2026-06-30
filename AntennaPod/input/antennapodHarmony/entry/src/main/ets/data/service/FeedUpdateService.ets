import { Feed } from '../../model/EpisodeModel';
import { EventBus, EventType, EventPayload } from '../event/EventBus';

// Feed refresh / RSS fetch transport interface. Real network parsing
// (@kit.NetworkKit + RSS parser) is deferred to a later stage; this interface
// lets the data layer and ViewModels reference feed-update flow without a live
// network dependency.
export interface FeedUpdateService {
  // Refresh every subscribed feed. Returns the number of feeds processed.
  refreshAllFeeds(): Promise<number>;
  // Refresh a single feed.
  refreshFeed(feedId: number): Promise<void>;
  // Fetch + parse a feed URL into a Feed value object (stubbed: returns a
  // minimal Feed seeded from the URL; the data row path is complete).
  parseFeed(url: string): Promise<Feed>;
}

// Stub implementation: no network. Refresh is a no-op that signals completion;
// parseFeed returns a Feed whose title/download_url are derived from the URL so
// the subscription data path resolves end-to-end.
export class StubFeedUpdateService implements FeedUpdateService {
  async refreshAllFeeds(): Promise<number> {
    EventBus.publish(EventType.FEED_LIST_UPDATE, new EventPayload());
    return 0;
  }

  async refreshFeed(feedId: number): Promise<void> {
    const p = new EventPayload();
    p.feedId = feedId;
    EventBus.publish(EventType.FEED_LIST_UPDATE, p);
  }

  async parseFeed(url: string): Promise<Feed> {
    const feed = new Feed();
    feed.downloadUrl = url;
    feed.title = this.deriveTitle(url);
    feed.link = url;
    return feed;
  }

  private deriveTitle(url: string): string {
    // Strip scheme + leading www; keep host+path as a readable placeholder.
    let s = url;
    const schemeEnd = s.indexOf('://');
    if (schemeEnd >= 0) {
      s = s.substring(schemeEnd + 3);
    }
    if (s.indexOf('www.') === 0) {
      s = s.substring(4);
    }
    return s;
  }
}
