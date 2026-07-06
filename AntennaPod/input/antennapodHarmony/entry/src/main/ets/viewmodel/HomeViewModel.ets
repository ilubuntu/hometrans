import { EpisodeData, SecondaryActionType, DownloadState } from '../model/EpisodeData';
import { HomeSection, HomeSectionType } from '../model/HomeSection';
import { FeedData } from '../model/FeedData';
import { repository } from '../common/data/Repository';
import { eventBus, AppEvent } from '../common/event/EventBus';

@Observed
export class HomeViewModel {
  sections: HomeSection[] = [];

  load(): void {
    this.reload();
  }

  reload(): void {
    const sections: HomeSection[] = [];

    const queue: EpisodeData[] = repository.queryQueue();
    const continueEp: EpisodeData | undefined = queue.length > 0 ? queue[0] : undefined;
    const continueList: EpisodeData[] = continueEp ? [continueEp] : [];
    sections.push(this.buildSection(HomeSectionType.CONTINUE_LISTENING, 'Continue listening',
      'Queue', continueList, ''));

    const inbox: EpisodeData[] = repository.queryInbox().slice(0, 10);
    sections.push(this.buildSection(HomeSectionType.SEE_WHATS_NEW, 'See what\'s new',
      'Inbox', inbox, ''));

    const allEpisodes: EpisodeData[] = repository.queryEpisodes([], 'date_desc');
    const random: EpisodeData[] = this.pickRandom(allEpisodes, 5);
    sections.push(this.buildSection(HomeSectionType.GET_SURPRISED, 'Get surprised',
      'Episodes', random, ''));

    const feeds: FeedData[] = repository.queryFeeds();
    const classicsEpisodes: EpisodeData[] = this.classicsEpisodes(feeds);
    sections.push(this.buildSection(HomeSectionType.CHECK_CLASSICS, 'Check your classics',
      'Subscriptions', classicsEpisodes, ''));

    const downloads: EpisodeData[] = repository.queryDownloads().slice(0, 5);
    sections.push(this.buildSection(HomeSectionType.MANAGE_DOWNLOADS, 'Manage downloads',
      'Downloads', downloads, ''));

    this.sections = sections;
  }

  private classicsEpisodes(feeds: FeedData[]): EpisodeData[] {
    if (feeds.length === 0) {
      return [];
    }
    const firstId: string = feeds[0].id;
    return repository.queryEpisodes([], 'date_desc', firstId).slice(0, 5);
  }

  private pickRandom(list: EpisodeData[], count: number): EpisodeData[] {
    if (list.length <= count) {
      return list.slice();
    }
    const shuffled: EpisodeData[] = list.slice();
    for (let i = shuffled.length - 1; i > 0; i--) {
      const j: number = Math.floor(Math.random() * (i + 1));
      const tmp: EpisodeData = shuffled[i];
      shuffled[i] = shuffled[j];
      shuffled[j] = tmp;
    }
    return shuffled.slice(0, count);
  }

  private buildSection(type: HomeSectionType, fallbackTitle: string, moreLabel: string,
    episodes: EpisodeData[], emptyText: string): HomeSection {
    const section: HomeSection = new HomeSection(type, fallbackTitle);
    section.moreLabel = moreLabel;
    section.episodes = episodes;
    section.isEmpty = episodes.length === 0;
    return section;
  }

  hasEpisodes(): boolean {
    return repository.countEpisodes() > 0;
  }
}

export const homeViewModel: HomeViewModel = new HomeViewModel();
