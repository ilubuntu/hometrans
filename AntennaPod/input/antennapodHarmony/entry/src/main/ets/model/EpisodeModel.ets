// Domain model for the AntennaPod HarmonyOS port.
//
// These types are the single shared vocabulary between the data layer
// (repositories / DB / preferences) and the presentation layer (ViewModels /
// pages). The repository layer reads relational-store rows into these objects;
// ViewModels never own truth, they only hold results of repository reads in
// page-bound fields.

// ---------------------------------------------------------------------------
// Enums (shared by repositories + ViewModels)
// ---------------------------------------------------------------------------

// Feed.state column. Mapping per decision contract:
//   0 = subscribed, 1 = archived, 2 = unsubscribed.
export enum FeedState {
  SUBSCRIBED = 0,
  ARCHIVED = 1,
  UNSUBSCRIBED = 2
}

// Where a newly enqueued episode is placed relative to the queue.
export enum EnqueueLocation {
  BACK = 0,
  FRONT = 1,
  AFTER_CURRENT = 2
}

// Sort order for episode lists (inbox, search, per-feed).
export enum SortOrder {
  DATE_OLD_NEW = 0,
  DATE_NEW_OLD = 1,
  DURATION_SHORT_LONG = 2,
  DURATION_LONG_SHORT = 3,
  TITLE_A_Z = 4,
  TITLE_Z_A = 5
}

// Sort order for the subscription grid.
export enum FeedOrder {
  COUNTER = 0,
  ALPHABETICAL = 1,
  DATE = 2,
  MOST_PLAYED = 3
}

// Which counter badge is rendered on each subscription cover (derived COUNT(*)).
export enum FeedCounterType {
  NONE = 0,
  INBOX = 1,
  UNPLAYED = 2,
  DOWNLOADED = 3,
  DOWNLOADED_UNPLAYED = 4
}

// What happens to a feed's new episodes after download.
export enum NewEpisodeAction {
  ADD_TO_INBOX = 0,
  ADD_TO_QUEUE = 1,
  NOTHING = 2
}

// REQ-039 download / transport error type codes (mirrors AntennaPod DownloadError).
export enum DownloadErrorType {
  NONE = 'none',
  ERROR_UNKNOWN = 'error_unknown',
  ERROR_PARSER_EXCEPTION = 'error_parser_exception',
  ERROR_FILE_NOT_FOUND = 'error_file_not_found',
  ERROR_CONNECTION_ERROR = 'error_connection_error',
  ERROR_FORBIDDEN = 'error_forbidden',
  ERROR_NOT_FOUND = 'error_not_found',
  ERROR_NOT_SUPPORTED = 'error_not_supported',
  ERROR_DEVICE_NOT_FOUND = 'error_device_not_found',
  ERROR_HTTP_DATA = 'error_http_data',
  ERROR_NOT_ENOUGH_SPACE = 'error_not_enough_space',
  ERROR_AUTHENTICATION = 'error_authentication',
  ERROR_MALFORMED_URL = 'error_malformed_url',
  ERROR_IO = 'error_io',
  NO_CONNECTION = 'no_connection'
}

// ---------------------------------------------------------------------------
// Media
// ---------------------------------------------------------------------------

export class EpisodeMediaInfo {
  duration: number = 0;
  position: number = 0;
  size: number = 0;
  mimeType: string = '';
  downloadUrl: string = '';
  video: boolean = false;

  constructor() {
  }
}

// ---------------------------------------------------------------------------
// Feed
// ---------------------------------------------------------------------------

export class Feed {
  id: number = 0;
  title: string = '';
  author: string = '';
  imageUrl: string = '';
  downloadUrl: string = '';
  lastUpdate: string = '';
  isLocalFeed: boolean = false;
  hasLastUpdateFailed: boolean = false;
  // Decision-contract additions:
  state: number = FeedState.SUBSCRIBED;
  customTitle: string = '';
  link: string = '';
  description: string = '';
  lastUpdateMs: number = 0;

  constructor() {
  }
}

// ---------------------------------------------------------------------------
// FeedItem (episode)
// ---------------------------------------------------------------------------

export class FeedItem {
  id: number = 0;
  title: string = '';
  description: string = '';
  feedId: number = 0;
  feedTitle: string = '';
  pubDate: string = '';
  imageUrl: string = '';
  media: EpisodeMediaInfo | null = null;
  isPlayed: boolean = false;
  isDownloaded: boolean = false;
  isInQueue: boolean = false;
  isNew: boolean = false;
  // Decision-contract additions:
  isFavorite: boolean = false;
  inHistory: boolean = false;
  autoDownload: boolean = false;
  mediaDownloadUrl: string = '';
  playedCompletion: number = 0;
  link: string = '';
  pubDateMs: number = 0;
  // Transient download progress (0..100), not persisted as truth; updated via events.
  downloadProgress: number = 0;

  constructor(id: number = 0, title: string = '', feedTitle: string = '') {
    this.id = id;
    this.title = title;
    this.feedTitle = feedTitle;
  }
}

// ---------------------------------------------------------------------------
// Value objects
// ---------------------------------------------------------------------------

export class FeedPreferences {
  feedId: number = 0;
  autoDownload: boolean = false;
  autoDelete: boolean = true;
  newEpisodeAction: number = NewEpisodeAction.ADD_TO_INBOX;
  playbackSpeed: number = 1.0;
  skipIntro: number = 0;
  skipOutro: number = 0;
  username: string = '';
  password: string = '';
  volumeReduction: boolean = false;

  constructor() {
  }
}

// DownloadResult row (download log + error codes, REQ-039).
export class DownloadResult {
  id: number = 0;
  completedDateMs: number = 0;
  title: string = '';
  reason: number = 0; // DownloadErrorType-derived numeric reason (AntennaPod DownloadErrorReason)
  sourceType: string = ''; // 'feed' | 'media' | 'feeditem'
  feeditemId: number = 0;
  ok: boolean = true;
  errorType: string = DownloadErrorType.NONE;

  constructor() {
  }
}

export class Tag {
  id: number = 0;
  name: string = '';

  constructor() {
  }
}

// Per-feed statistics (derived aggregates, never stored as columns).
export class FeedStatistics {
  feedId: number = 0;
  title: string = '';
  episodesStarted: number = 0;
  episodesTotal: number = 0;
  episodesDownloaded: number = 0;
  timePlayedMs: number = 0;

  constructor() {
  }
}

// Filter for episode list queries. Each boolean enables a filter dimension.
export class EpisodeFilter {
  unplayed: boolean = false; // read = 0 (isNew inbox)
  played: boolean = false; // read = 1
  downloaded: boolean = false; // downloaded = 1
  notDownloaded: boolean = false; // downloaded = 0
  inQueue: boolean = false; // exists in Queue table
  favorite: boolean = false; // is_favorite = 1
  feedId: number = 0; // 0 = no feed filter
  inHistory: boolean = false; // in_history = 1

  constructor() {
  }
}

// Structured result for write operations that can fail (REQ-039).
export class RepositoryResult {
  ok: boolean = true;
  errorType: string = DownloadErrorType.NONE;
  itemId: number = 0;
  message: string = '';

  constructor() {
  }
}
