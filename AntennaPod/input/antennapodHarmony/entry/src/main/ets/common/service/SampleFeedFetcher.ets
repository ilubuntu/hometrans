import { EpisodeData, DownloadState } from '../../model/EpisodeData';
import { SampleData, SampleFeed, SampleEpisode } from '../data/SampleData';
import { repository } from '../data/Repository';
import { FeedFetcher, FetchResult } from './FeedFetcher';

class SampleFeedFetcherImpl implements FeedFetcher {
  async fetchByUrl(url: string): Promise<FetchResult | undefined> {
    const feeds: SampleFeed[] = SampleData.feeds();
    for (let i = 0; i < feeds.length; i++) {
      const f: SampleFeed = feeds[i];
      if (f.feedUrl === url) {
        return this.toFetchResult(f);
      }
    }
    return undefined;
  }

  async searchByTitle(title: string): Promise<FetchResult[]> {
    const needle: string = title.trim().toLowerCase();
    if (needle.length === 0) {
      return [];
    }
    const feeds: SampleFeed[] = SampleData.feeds();
    const out: FetchResult[] = [];
    for (let i = 0; i < feeds.length; i++) {
      const f: SampleFeed = feeds[i];
      if (f.title.toLowerCase().includes(needle) || f.author.toLowerCase().includes(needle)) {
        out.push(this.toFetchResult(f));
      }
    }
    return out;
  }

  private toFetchResult(f: SampleFeed): FetchResult {
    const episodes: SampleEpisode[] = SampleData.episodes().filter((e: SampleEpisode): boolean => e.feedId === f.id);
    const list: EpisodeData[] = [];
    for (let i = 0; i < episodes.length; i++) {
      list.push(SampleData.toEpisodeData(episodes[i]));
    }
    return {
      feedId: f.id,
      title: f.title,
      author: f.author,
      description: f.description,
      feedUrl: f.feedUrl,
      coverKey: f.coverKey,
      tags: f.tags.slice(),
      episodes: list,
      subscribed: repository.getFeed(f.id) !== undefined,
    } as FetchResult;
  }
}

export const sampleFeedFetcher: FeedFetcher = new SampleFeedFetcherImpl();
