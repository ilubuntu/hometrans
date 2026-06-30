import { Feed } from '../../model/EpisodeModel';
import { RepositoryResult } from '../../model/EpisodeModel';

// Online podcast directory search interface (iTunes / fyyd / PodcastIndex).
// Real directory transport is deferred; the interface is defined so the
// "Add podcast" discovery/search flow can be wired without live network.
export interface OnlineSearchService {
  // Search the directory for a query. Returns matching feeds.
  search(query: string): Promise<Feed[]>;
  // Fetch a discovery toplist (QuickFeedDiscovery). Empty in the stub.
  loadToplist(limit: number): Promise<Feed[]>;
}

// Stub: returns empty results and an unreachable-network result so the Add
// Podcast page's error/empty paths resolve deterministically.
export class StubOnlineSearchService implements OnlineSearchService {
  async search(query: string): Promise<Feed[]> {
    return [];
  }

  async loadToplist(limit: number): Promise<Feed[]> {
    return [];
  }
}

// Convenience: builds a RepositoryResult describing an unreachable directory.
export class OnlineSearchErrors {
  static offline(): RepositoryResult {
    const r = new RepositoryResult();
    r.ok = false;
    r.errorType = 'no_connection';
    r.message = 'no_connection';
    return r;
  }
}
