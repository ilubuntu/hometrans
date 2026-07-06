export enum SecondaryActionType {
  PLAY,
  PAUSE,
  DOWNLOAD,
  CANCEL_DOWNLOAD
}

export enum DownloadState {
  NONE = 'NONE',
  QUEUED = 'QUEUED',
  DOWNLOADING = 'DOWNLOADING',
  DOWNLOADED = 'DOWNLOADED',
  CANCELED = 'CANCELED',
  FAILED = 'FAILED'
}

@Observed
export class EpisodeData {
  @Track id: string = '';
  @Track title: string = '';
  @Track author: string = '';
  @Track cover: Resource = $r('app.media.ic_feed');
  @Track pubDate: string = '';
  @Track pubDateDesc: string = '';
  @Track sizeText: string = '';
  @Track position: string = '';
  @Track duration: string = '';
  @Track positionDesc: string = '';
  @Track durationDesc: string = '';
  @Track progress: number = 0;
  @Track isInbox: boolean = false;
  @Track isFavorite: boolean = false;
  @Track inQueue: boolean = false;
  @Track isVideo: boolean = false;
  @Track secondaryAction: SecondaryActionType = SecondaryActionType.PLAY;
  @Track downloadProgress: number = 0;

  @Track feedId: string = '';
  @Track downloadState: DownloadState = DownloadState.NONE;
  @Track isPlayed: boolean = false;
  @Track positionSec: number = 0;
  @Track durationSec: number = 0;
  @Track isNew: boolean = false;
  @Track mediaUrl: string = '';
  @Track websiteUrl: string = '';
  @Track downloadedAt: number = 0;
  @Track pubDateMs: number = 0;
  @Track sizeBytes: number = 0;
  @Track tags: string[] = [];

  constructor(id: string, title: string) {
    this.id = id;
    this.title = title;
  }
}
