@Observed
export class FeedData {
  @Track id: string = '';
  @Track title: string = '';
  @Track author: string = '';
  @Track description: string = '';
  @Track cover: Resource = $r('app.media.ic_feed');
  @Track count: number = 0;
  @Track subscribed: boolean = true;
  @Track hasUpdateFailed: boolean = false;
  @Track layer: number = 0;
  @Track feedUrl: string = '';
  @Track supportUrl: string = '';

  @Track lastUpdateFailed: boolean = false;
  @Track downloadCount: number = 0;
  @Track playState: number = 0;
  @Track isNewCount: number = 0;
  @Track unplayedCount: number = 0;
  @Track tags: string[] = [];
  @Track lastUpdateMs: number = 0;

  constructor(id: string, title: string, count: number, cover: Resource) {
    this.id = id;
    this.title = title;
    this.count = count;
    this.cover = cover;
  }
}

export type FeedCounterDisplay = 'SHOW_TOTAL' | 'SHOW_NEW' | 'SHOW_UNPLAYED' | 'SHOW_NONE';
