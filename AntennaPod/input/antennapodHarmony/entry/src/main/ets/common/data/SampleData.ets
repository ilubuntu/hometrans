import { EpisodeData, SecondaryActionType, DownloadState } from '../../model/EpisodeData';
import { FeedData } from '../../model/FeedData';

export interface SampleEpisode {
  id: string;
  feedId: string;
  title: string;
  author: string;
  pubDate: string;
  pubDateMs: number;
  durationSec: number;
  positionSec: number;
  sizeBytes: number;
  isInbox: boolean;
  isFavorite: boolean;
  inQueue: boolean;
  isPlayed: boolean;
  isNew: boolean;
  isVideo: boolean;
  downloadState: DownloadState;
  downloadProgress: number;
  mediaUrl: string;
  websiteUrl: string;
  shownotes: string;
}

export interface SampleFeed {
  id: string;
  title: string;
  author: string;
  description: string;
  coverKey: string;
  feedUrl: string;
  supportUrl: string;
  subscribed: boolean;
  tags: string[];
}

export interface SampleQueueEntry {
  episodeId: string;
  position: number;
}

export interface SampleChapter {
  index: number;
  title: string;
  startSec: number;
  endSec: number;
}

export class SampleData {
  static readonly FEED_MORBID: string = 'feed_morbid';
  static readonly FEED_CRIMEJUNKIE: string = 'feed_crimejunkie';
  static readonly FEED_GOODHANG: string = 'feed_goodhang';
  static readonly FEED_THIS_AMERICAN_LIFE: string = 'feed_thisamericanlife';
  static readonly FEED_MEGYN: string = 'feed_megyn';
  static readonly FEED_DAILY: string = 'feed_daily';
  static readonly FEED_ABC: string = 'feed_abc';
  static readonly FEED_BLOOMBERG: string = 'feed_bloomberg';
  static readonly FEED_NPR: string = 'feed_npr';
  static readonly FEED_EZRA: string = 'feed_ezra';

  static coverForFeed(feedId: string): Resource {
    if (feedId === SampleData.FEED_CRIMEJUNKIE || feedId === SampleData.FEED_MEGYN) {
      return $r('app.media.ic_feed_black');
    }
    if (feedId === SampleData.FEED_GOODHANG) {
      return $r('app.media.ic_shortcut_feed');
    }
    return $r('app.media.ic_feed');
  }

  static feeds(): SampleFeed[] {
    const list: SampleFeed[] = [];
    list.push({
      id: SampleData.FEED_MORBID, title: 'Morbid', author: 'Ash Kelley & Alaina Urquhart',
      description: 'Morbid is a true crime, creepy history and all things spooky podcast hosted by an autopsy technician and a hairstylist. New episodes every Tuesday and Thursday.',
      coverKey: 'ic_feed', feedUrl: 'https://morbid.libsyn.com/rss',
      supportUrl: 'https://www.patreon.com/morbidpodcast', subscribed: true, tags: ['True Crime']
    });
    list.push({
      id: SampleData.FEED_CRIMEJUNKIE, title: 'Crime Junkie', author: 'audiochuck | Ashley Flowers',
      description: 'If you can never get enough true crime... Congratulations, you\'re a Crime Junkie! Every Monday, Ashley Flowers tells you about whatever crime she\'s been obsessing over that week.',
      coverKey: 'ic_feed_black', feedUrl: 'https://feeds.megaphone.fm/crimejunkie',
      supportUrl: 'https://www.crimejunkiepodcast.com', subscribed: true, tags: ['True Crime']
    });
    list.push({
      id: SampleData.FEED_GOODHANG, title: 'Good Hang with Amy Poehler', author: 'Amy Poehler',
      description: 'Each week on Good Hang, Amy Poehler and her hilarious friends share stories, laughs, and unexpected conversations about life, work, and everything in between.',
      coverKey: 'ic_shortcut_feed', feedUrl: 'https://feeds.example.com/goodhang',
      supportUrl: 'https://www.goodhang.show', subscribed: true, tags: ['Comedy']
    });
    list.push({
      id: SampleData.FEED_THIS_AMERICAN_LIFE, title: 'This American Life', author: 'This American Life',
      description: 'This American Life is a weekly public radio program and podcast. Each week we choose a theme and put together different kinds of stories on that theme.',
      coverKey: 'ic_feed', feedUrl: 'https://www.thisamericanlife.org/rss',
      supportUrl: 'https://www.thisamericanlife.org/donate', subscribed: true, tags: ['Society']
    });
    list.push({
      id: SampleData.FEED_MEGYN, title: 'The Megyn Kelly Show', author: 'Megyn Kelly',
      description: 'The Megyn Kelly Show is your home for open, honest and provocative conversations about the issues that matter most. New episodes every weekday.',
      coverKey: 'ic_feed_black', feedUrl: 'https://feeds.megaphone.fm/megynkelly',
      supportUrl: 'https://www.megynkellyshow.com', subscribed: true, tags: ['News']
    });
    list.push({
      id: SampleData.FEED_DAILY, title: 'The Daily', author: 'The New York Times',
      description: 'This is what the news should sound like. The biggest stories of our time, told by the best journalists in the world.',
      coverKey: 'ic_feed', feedUrl: 'https://feeds.example.com/the-daily',
      supportUrl: 'https://www.nytimes.com/newsletters', subscribed: true, tags: ['News']
    });
    list.push({
      id: SampleData.FEED_ABC, title: 'ABC News', author: 'ABC News',
      description: 'Your daily briefing of the latest news headlines from ABC News.',
      coverKey: 'ic_feed', feedUrl: 'https://feeds.example.com/abc-news',
      supportUrl: 'https://abcnews.go.com', subscribed: true, tags: ['News']
    });
    list.push({
      id: SampleData.FEED_BLOOMBERG, title: 'Bloomberg', author: 'Bloomberg',
      description: 'Bloomberg news, markets, and analysis in daily podcasts.',
      coverKey: 'ic_feed', feedUrl: 'https://feeds.example.com/bloomberg',
      supportUrl: 'https://www.bloomberg.com', subscribed: true, tags: ['Business']
    });
    return list;
  }

  static episodes(): SampleEpisode[] {
    const list: SampleEpisode[] = [];
    const push = (spec: SampleEpisode): void => { list.push(spec); };

    push({
      id: 'feed_morbid_ep1', feedId: SampleData.FEED_MORBID,
      title: 'Morbid Book Club: Victorian Psycho By Virginia Feito',
      author: 'Morbid', pubDate: 'Jun 29', pubDateMs: 1751232000000,
      durationSec: 3720, positionSec: 0, sizeBytes: 62 * 1024 * 1024,
      isInbox: false, isFavorite: false, inQueue: false, isPlayed: false, isNew: true,
      isVideo: false, downloadState: DownloadState.NONE, downloadProgress: 0,
      mediaUrl: 'https://example.com/morbid_ep1.mp3',
      websiteUrl: 'https://morbid.libsyn.com/victorian-psycho',
      shownotes: 'A morbid book club discussion of Victorian Psycho by Virginia Feito.'
    });
    push({
      id: 'feed_morbid_ep2', feedId: SampleData.FEED_MORBID,
      title: 'Listener Tales 111: Camping Tales',
      author: 'Morbid', pubDate: 'Jun 25', pubDateMs: 1750886400000,
      durationSec: 6009, positionSec: 2820, sizeBytes: 96 * 1024 * 1024,
      isInbox: false, isFavorite: true, inQueue: true, isPlayed: false, isNew: false,
      isVideo: false, downloadState: DownloadState.DOWNLOADED, downloadProgress: 100,
      mediaUrl: 'https://example.com/morbid_ep2.mp3',
      websiteUrl: 'https://morbid.libsyn.com/listener-tales-111-camping-tales',
      shownotes: 'Camping tales from our listeners. Spooky stories from the woods, strange encounters at remote campsites, and the unexplained sounds that made everyone pack up early.'
    });
    push({
      id: 'feed_morbid_ep3', feedId: SampleData.FEED_MORBID,
      title: 'Rewind: The Horrific Murders of Annie Le',
      author: 'Morbid', pubDate: 'Jun 22', pubDateMs: 1750627200000,
      durationSec: 4080, positionSec: 0, sizeBytes: 68 * 1024 * 1024,
      isInbox: false, isFavorite: false, inQueue: false, isPlayed: false, isNew: false,
      isVideo: false, downloadState: DownloadState.NONE, downloadProgress: 0,
      mediaUrl: 'https://example.com/morbid_ep3.mp3',
      websiteUrl: 'https://morbid.libsyn.com/annie-le',
      shownotes: 'A rewind episode about the tragic case of Annie Le.'
    });

    push({
      id: 'feed_crimejunkie_ep1', feedId: SampleData.FEED_CRIMEJUNKIE,
      title: 'MISSING: Jennifer, Sidney, & Monique',
      author: 'Crime Junkie', pubDate: 'Jun 26', pubDateMs: 1750972800000,
      durationSec: 3120, positionSec: 0, sizeBytes: 55 * 1024 * 1024,
      isInbox: true, isFavorite: false, inQueue: false, isPlayed: false, isNew: true,
      isVideo: false, downloadState: DownloadState.NONE, downloadProgress: 0,
      mediaUrl: 'https://example.com/cj_ep1.mp3',
      websiteUrl: 'https://www.crimejunkiepodcast.com/missing-jennifer-sidney-monique',
      shownotes: 'Three women. Three disappearances. Are they connected?'
    });
    push({
      id: 'feed_crimejunkie_ep2', feedId: SampleData.FEED_CRIMEJUNKIE,
      title: 'MURDERED: Christine Banfield & Joseph Ryan',
      author: 'Crime Junkie', pubDate: 'Jun 25', pubDateMs: 1750886400000,
      durationSec: 3240, positionSec: 0, sizeBytes: 49 * 1024 * 1024,
      isInbox: true, isFavorite: false, inQueue: false, isPlayed: false, isNew: true,
      isVideo: false, downloadState: DownloadState.NONE, downloadProgress: 0,
      mediaUrl: 'https://example.com/cj_ep2.mp3',
      websiteUrl: 'https://www.crimejunkiepodcast.com/murdered-christine-banfield-joseph-ryan',
      shownotes: 'A horrifying home invasion that left two people dead. Was it self defense or something far more sinister?'
    });
    push({
      id: 'feed_crimejunkie_ep3', feedId: SampleData.FEED_CRIMEJUNKIE,
      title: 'WARNING: AI Voice Cloning and Virtual Kidnappings',
      author: 'Crime Junkie', pubDate: 'Jun 28', pubDateMs: 1751145600000,
      durationSec: 2830, positionSec: 1698, sizeBytes: 52 * 1024 * 1024,
      isInbox: false, isFavorite: false, inQueue: true, isPlayed: false, isNew: false,
      isVideo: false, downloadState: DownloadState.DOWNLOADING, downloadProgress: 45,
      mediaUrl: 'https://example.com/cj_ep3.mp3',
      websiteUrl: 'https://www.crimejunkiepodcast.com/ai-voice-cloning',
      shownotes: 'A new wave of scams using AI voice cloning to fake family emergencies.'
    });

    push({
      id: 'feed_megyn_ep1', feedId: SampleData.FEED_MEGYN,
      title: 'Supreme Court BOMBSHELLS: Against Trump on Birthright Citizenship',
      author: 'The Megyn Kelly Show', pubDate: 'Jul 1', pubDateMs: 1751404800000,
      durationSec: 10032, positionSec: 0, sizeBytes: 84 * 1024 * 1024,
      isInbox: true, isFavorite: false, inQueue: false, isPlayed: false, isNew: true,
      isVideo: false, downloadState: DownloadState.NONE, downloadProgress: 0,
      mediaUrl: 'https://example.com/megyn_ep1.mp3',
      websiteUrl: 'https://www.megynkellyshow.com/scotus-birthright',
      shownotes: 'Analysis of the Supreme Court\'s birthright citizenship ruling.'
    });
    push({
      id: 'feed_megyn_ep2', feedId: SampleData.FEED_MEGYN,
      title: 'The Founding Fathers and One Jewish Mother',
      author: 'The Megyn Kelly Show', pubDate: 'May 20', pubDateMs: 1747728000000,
      durationSec: 6760, positionSec: 0, sizeBytes: 78 * 1024 * 1024,
      isInbox: false, isFavorite: false, inQueue: false, isPlayed: false, isNew: false,
      isVideo: false, downloadState: DownloadState.DOWNLOADED, downloadProgress: 100,
      mediaUrl: 'https://example.com/megyn_ep2.mp3',
      websiteUrl: 'https://www.megynkellyshow.com/founding-fathers',
      shownotes: 'A historical deep dive into America\'s founding.'
    });

    push({
      id: 'feed_daily_ep1', feedId: SampleData.FEED_DAILY,
      title: '128: Four Corners',
      author: 'The Daily', pubDate: 'Jun 29', pubDateMs: 1751232000000,
      durationSec: 2834, positionSec: 0, sizeBytes: 48 * 1024 * 1024,
      isInbox: false, isFavorite: false, inQueue: false, isPlayed: false, isNew: false,
      isVideo: false, downloadState: DownloadState.NONE, downloadProgress: 0,
      mediaUrl: 'https://example.com/daily_ep1.mp3',
      websiteUrl: 'https://www.nytimes.com/four-corners',
      shownotes: 'A look at the Four Corners region.'
    });

    push({
      id: 'feed_abc_ep1', feedId: SampleData.FEED_ABC,
      title: 'Dems\' Socialism Infighting, Three Firefighters Killed: AM Update 6/29',
      author: 'ABC News', pubDate: 'Jun 30', pubDateMs: 1751318400000,
      durationSec: 765, positionSec: 0, sizeBytes: 12 * 1024 * 1024,
      isInbox: false, isFavorite: false, inQueue: false, isPlayed: false, isNew: false,
      isVideo: false, downloadState: DownloadState.NONE, downloadProgress: 0,
      mediaUrl: 'https://example.com/abc_ep1.mp3',
      websiteUrl: 'https://abcnews.go.com/am-update',
      shownotes: 'Your morning news update from ABC News.'
    });

    push({
      id: 'feed_bloomberg_ep1', feedId: SampleData.FEED_BLOOMBERG,
      title: 'Global Markets Wrap: Weekly Recap',
      author: 'Bloomberg', pubDate: 'Jun 25', pubDateMs: 1750886400000,
      durationSec: 2062, positionSec: 0, sizeBytes: 32 * 1024 * 1024,
      isInbox: false, isFavorite: false, inQueue: false, isPlayed: false, isNew: false,
      isVideo: false, downloadState: DownloadState.NONE, downloadProgress: 0,
      mediaUrl: 'https://example.com/bloomberg_ep1.mp3',
      websiteUrl: 'https://www.bloomberg.com/weekly-recap',
      shownotes: 'A weekly recap of global markets.'
    });

    push({
      id: 'feed_goodhang_ep1', feedId: SampleData.FEED_GOODHANG,
      title: 'Amy & Tina\'s Ultimate Hollywood Send-Up',
      author: 'Good Hang with Amy Poehler', pubDate: 'Jun 27', pubDateMs: 1751059200000,
      durationSec: 3669, positionSec: 0, sizeBytes: 61 * 1024 * 1024,
      isInbox: false, isFavorite: false, inQueue: false, isPlayed: false, isNew: false,
      isVideo: false, downloadState: DownloadState.NONE, downloadProgress: 0,
      mediaUrl: 'https://example.com/goodhang_ep1.mp3',
      websiteUrl: 'https://www.goodhang.show/amy-tina',
      shownotes: 'Amy and Tina share their funniest Hollywood stories.'
    });

    push({
      id: 'feed_thisamericanlife_ep1', feedId: SampleData.FEED_THIS_AMERICAN_LIFE,
      title: 'The Hand-Me-Down',
      author: 'This American Life', pubDate: 'Jun 24', pubDateMs: 1750886400000,
      durationSec: 3540, positionSec: 0, sizeBytes: 58 * 1024 * 1024,
      isInbox: false, isFavorite: false, inQueue: false, isPlayed: false, isNew: false,
      isVideo: false, downloadState: DownloadState.NONE, downloadProgress: 0,
      mediaUrl: 'https://example.com/tal_ep1.mp3',
      websiteUrl: 'https://www.thisamericanlife.org/hand-me-down',
      shownotes: 'Stories about things handed down through generations.'
    });
    push({
      id: 'feed_npr_ep1', feedId: SampleData.FEED_NPR,
      title: 'Daily Briefing: Midweek Edition',
      author: 'NPR', pubDate: 'Jun 23', pubDateMs: 1750713600000,
      durationSec: 1135, positionSec: 0, sizeBytes: 18 * 1024 * 1024,
      isInbox: true, isFavorite: false, inQueue: false, isPlayed: false, isNew: true,
      isVideo: false, downloadState: DownloadState.NONE, downloadProgress: 0,
      mediaUrl: 'https://example.com/npr_ep1.mp3',
      websiteUrl: 'https://www.npr.org/midweek',
      shownotes: 'Your midweek daily briefing.'
    });
    push({
      id: 'feed_ezra_ep1', feedId: SampleData.FEED_EZRA,
      title: 'Tech & Society: The Attention Economy',
      author: 'Ezra Klein Show', pubDate: 'Jun 24', pubDateMs: 1750886400000,
      durationSec: 3669, positionSec: 0, sizeBytes: 61 * 1024 * 1024,
      isInbox: false, isFavorite: false, inQueue: false, isPlayed: false, isNew: false,
      isVideo: false, downloadState: DownloadState.NONE, downloadProgress: 0,
      mediaUrl: 'https://example.com/ezra_ep1.mp3',
      websiteUrl: 'https://www.nytimes.com/ezra-klein/attention-economy',
      shownotes: 'How the attention economy reshapes society.'
    });

    return list;
  }

  static queue(): SampleQueueEntry[] {
    const list: SampleQueueEntry[] = [];
    list.push({ episodeId: 'feed_morbid_ep2', position: 0 });
    list.push({ episodeId: 'feed_crimejunkie_ep3', position: 1 });
    list.push({ episodeId: 'feed_crimejunkie_ep1', position: 2 });
    return list;
  }

  static chaptersFor(episodeId: string): SampleChapter[] {
    if (episodeId === 'feed_morbid_ep2') {
      const list: SampleChapter[] = [];
      list.push({ index: 0, title: 'Intro', startSec: 0, endSec: 145 });
      list.push({ index: 1, title: 'Tale #1 — The Whispering Pines', startSec: 145, endSec: 1820 });
      list.push({ index: 2, title: 'Tale #2 — Bear or Not Bear', startSec: 1820, endSec: 3650 });
      list.push({ index: 3, title: 'Tale #3 — The Last Campfire', startSec: 3650, endSec: 5400 });
      list.push({ index: 4, title: 'Outro', startSec: 5400, endSec: 6009 });
      return list;
    }
    return [];
  }

  static toFeedData(spec: SampleFeed): FeedData {
    const feed: FeedData = new FeedData(spec.id, spec.title, 0, SampleData.coverForFeed(spec.id));
    feed.author = spec.author;
    feed.description = spec.description;
    feed.subscribed = spec.subscribed;
    feed.feedUrl = spec.feedUrl;
    feed.supportUrl = spec.supportUrl;
    feed.tags = spec.tags.slice();
    return feed;
  }

  static toEpisodeData(spec: SampleEpisode): EpisodeData {
    const ep: EpisodeData = new EpisodeData(spec.id, spec.title);
    ep.feedId = spec.feedId;
    ep.author = spec.author;
    ep.cover = SampleData.coverForFeed(spec.feedId);
    ep.pubDate = spec.pubDate;
    ep.pubDateDesc = spec.pubDate;
    ep.sizeText = SampleData.formatSize(spec.sizeBytes);
    ep.position = SampleData.formatClock(spec.positionSec);
    ep.duration = SampleData.formatClock(spec.durationSec);
    ep.positionDesc = `Position: ${ep.position}`;
    ep.durationDesc = SampleData.formatDurationDesc(spec.durationSec);
    ep.progress = spec.durationSec > 0
      ? Math.min(100, Math.floor((spec.positionSec / spec.durationSec) * 100)) : 0;
    ep.isInbox = spec.isInbox;
    ep.isFavorite = spec.isFavorite;
    ep.inQueue = spec.inQueue;
    ep.isVideo = spec.isVideo;
    ep.downloadState = spec.downloadState;
    ep.downloadProgress = spec.downloadProgress;
    ep.isPlayed = spec.isPlayed;
    ep.isNew = spec.isNew;
    ep.positionSec = spec.positionSec;
    ep.durationSec = spec.durationSec;
    ep.mediaUrl = spec.mediaUrl;
    ep.websiteUrl = spec.websiteUrl;
    ep.sizeBytes = spec.sizeBytes;
    ep.pubDateMs = spec.pubDateMs;
    ep.secondaryAction = SampleData.secondaryActionFor(spec);
    return ep;
  }

  static secondaryActionFor(spec: SampleEpisode): SecondaryActionType {
    if (spec.downloadState === DownloadState.DOWNLOADING) {
      return SecondaryActionType.CANCEL_DOWNLOAD;
    }
    if (spec.positionSec > 0 || spec.downloadState === DownloadState.DOWNLOADED) {
      return SecondaryActionType.PLAY;
    }
    return SecondaryActionType.DOWNLOAD;
  }

  static formatClock(totalSec: number): string {
    if (totalSec <= 0) {
      return '';
    }
    const sec: number = Math.floor(totalSec % 60);
    const min: number = Math.floor((totalSec / 60) % 60);
    const hr: number = Math.floor(totalSec / 3600);
    const ss: string = sec < 10 ? `0${sec}` : `${sec}`;
    const mm: string = min < 10 ? `0${min}` : `${min}`;
    if (hr > 0) {
      return `${hr}:${mm}:${ss}`;
    }
    return `${mm}:${ss}`;
  }

  static formatDurationDesc(totalSec: number): string {
    if (totalSec <= 0) {
      return '';
    }
    const hr: number = Math.floor(totalSec / 3600);
    const min: number = Math.floor((totalSec % 3600) / 60);
    if (hr > 0) {
      return `Duration: ${hr} hour${hr > 1 ? 's' : ''}${min > 0 ? ` ${min} minutes` : ''}`;
    }
    return `Duration: ${min} minutes`;
  }

  static formatSize(bytes: number): string {
    const mb: number = Math.floor(bytes / (1024 * 1024));
    return `${mb} MB`;
  }
}
