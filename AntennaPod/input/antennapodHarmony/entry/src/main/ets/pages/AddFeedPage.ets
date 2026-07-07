import { router } from '@kit.ArkUI';
import { EpisodeData } from '../model/EpisodeData';
import { FeedData } from '../model/FeedData';
import { repository } from '../common/data/Repository';
import { serviceLocator } from '../common/service/ServiceLocator';
import { FeedFetcher, FetchResult } from '../common/service/FeedFetcher';
import { SampleData, SampleFeed, SampleEpisode } from '../common/data/SampleData';
import { AppToolbar } from '../components/AppToolbar';
import { EpisodeListItem } from '../components/EpisodeListItem';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct AddFeedPage {
  @State query: string = '';
  @State results: FetchResult[] = [];
  @State hasSearched: boolean = false;
  @State isSearching: boolean = false;
  @State rssDialogVisible: boolean = false;
  @State rssUrlInput: string = '';
  @State rssLoading: boolean = false;

  private doSearch(): void {
    const q: string = this.query.trim();
    if (q.length === 0) {
      this.results = [];
      this.hasSearched = false;
      return;
    }
    this.isSearching = true;
    serviceLocator.feedFetcher().searchByTitle(q).then((items: FetchResult[]): void => {
      this.results = items;
      this.hasSearched = true;
      this.isSearching = false;
    }).catch((): void => {
      this.isSearching = false;
      this.hasSearched = true;
      this.results = [];
    });
  }

  private subscribeTo(result: FetchResult): void {
    const spec: SampleFeed = {
      id: result.feedId,
      title: result.title,
      author: result.author,
      description: result.description,
      coverKey: result.coverKey,
      feedUrl: result.feedUrl,
      supportUrl: '',
      subscribed: true,
      tags: result.tags.slice()
    } as SampleFeed;
    const episodes: SampleEpisode[] = result.episodes.map((ep: EpisodeData): SampleEpisode => {
      return {
        id: ep.id,
        feedId: ep.feedId,
        title: ep.title,
        author: ep.author,
        pubDate: ep.pubDate,
        pubDateMs: ep.pubDateMs,
        durationSec: ep.durationSec,
        positionSec: ep.positionSec,
        sizeBytes: ep.sizeBytes,
        isInbox: ep.isInbox,
        isFavorite: false,
        inQueue: false,
        isPlayed: false,
        isNew: ep.isNew,
        isVideo: ep.isVideo,
        downloadState: ep.downloadState,
        downloadProgress: 0,
        mediaUrl: ep.mediaUrl,
        websiteUrl: ep.websiteUrl,
        shownotes: ''
      } as SampleEpisode;
    });
    repository.subscribe(spec, episodes).then((): void => {
      try {
        promptAction.showToast({ message: `Subscribed to ${result.title}` });
      } catch (e) {
        // ignore toast errors
      }
      router.back();
    });
  }

  private openRssDialog(): void {
    this.rssUrlInput = '';
    this.rssDialogVisible = true;
  }

  private confirmRssUrl(): void {
    const url: string = this.rssUrlInput.trim();
    if (url.length === 0) {
      try {
        promptAction.showToast({ message: 'Please enter an RSS feed URL' });
      } catch (e) {
        // ignore toast errors
      }
      return;
    }
    this.rssLoading = true;
    serviceLocator.feedFetcher().fetchByUrl(url).then((result: FetchResult | undefined): void => {
      this.rssLoading = false;
      if (result) {
        this.rssDialogVisible = false;
        this.subscribeTo(result);
      } else {
        try {
          promptAction.showToast({ message: 'Could not parse feed. Please check the URL and try again.' });
        } catch (e) {
          // ignore toast errors
        }
      }
    }).catch((): void => {
      this.rssLoading = false;
      try {
        promptAction.showToast({ message: 'Could not parse feed. Please check the URL and try again.' });
      } catch (e) {
        // ignore toast errors
      }
    });
  }

  @Builder
  ResultRow(result: FetchResult) {
    Column() {
      Row() {
        Column() {
          Text(result.title)
            .fontSize(16)
            .fontColor($r('app.color.black'))
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text(result.author)
            .fontSize(13)
            .fontColor($r('app.color.grey600'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: 2 })
          Text(result.description)
            .fontSize(13)
            .fontColor($r('app.color.grey600'))
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Button(result.subscribed ? 'Added' : 'Subscribe')
          .type(ButtonType.Normal)
          .enabled(!result.subscribed)
          .fontSize(13)
          .fontColor($r('app.color.white'))
          .backgroundColor($r('app.color.accent_light'))
          .borderRadius(16)
          .height(32)
          .margin({ left: 8 })
          .onClick((): void => this.subscribeTo(result))
      }
      .width('100%')
      .alignItems(VerticalAlign.Top)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
  }

  build() {
    Stack() {
      Column() {
        AppToolbar({
          title: $r('app.string.add_feed_label'),
          showBack: true,
          showSearch: false,
          showFilter: false,
          showOverflow: false,
          onBack: () => {
            router.back();
          }
        })

        Row() {
          TextInput({ text: this.query, placeholder: 'Search for podcasts' })
            .layoutWeight(1)
            .fontSize(15)
            .backgroundColor($r('app.color.background_elevated_light'))
            .borderRadius(24)
            .height(40)
            .onChange((v: string): void => {
              this.query = v;
            })
          Button('Search')
            .type(ButtonType.Normal)
            .fontSize(14)
            .fontColor($r('app.color.white'))
            .backgroundColor($r('app.color.accent_light'))
            .borderRadius(20)
            .height(36)
            .margin({ left: 8 })
            .onClick((): void => this.doSearch())
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 12, bottom: 8 })

        Row() {
          Button('Add by RSS URL')
            .type(ButtonType.Normal)
            .fontSize(13)
            .fontColor($r('app.color.black'))
            .backgroundColor($r('app.color.background_elevated_light'))
            .borderRadius(20)
            .height(36)
            .margin({ left: 16, right: 8 })
            .onClick((): void => this.openRssDialog())
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .margin({ bottom: 8 })

        if (this.isSearching) {
          Column() {
            LoadingProgress().width(40).height(40).color($r('app.color.accent_light'))
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        } else if (this.hasSearched && this.results.length === 0) {
          Column() {
            Text('No podcasts found')
              .fontSize(14)
              .fontColor($r('app.color.grey600'))
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        } else {
          Scroll() {
            Column() {
              ForEach(this.results, (result: FetchResult): void => {
                this.ResultRow(result)
              }, (result: FetchResult): string => result.feedId)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }
          .layoutWeight(1)
          .scrollBar(BarState.Auto)
        }
      }
      .width('100%')
      .height('100%')

      if (this.rssDialogVisible) {
        Stack({ alignContent: Alignment.Center }) {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor($r('app.color.image_readability_tint'))
            .onClick(() => {
              if (!this.rssLoading) {
                this.rssDialogVisible = false;
              }
            })

          Column() {
            Text('Add podcast by RSS URL')
              .fontSize(20)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.black'))
              .margin({ top: 24, bottom: 16 })

            Divider().color($r('app.color.light_gray'))

            TextInput({ text: this.rssUrlInput, placeholder: 'RSS address' })
              .width('90%')
              .fontSize(15)
              .backgroundColor($r('app.color.background_elevated_light'))
              .borderRadius(8)
              .height(44)
              .margin({ top: 16, bottom: 16 })
              .onChange((v: string): void => {
                this.rssUrlInput = v;
              })

            Divider().color($r('app.color.light_gray'))

            Row() {
              Button('Cancel')
                .layoutWeight(1)
                .type(ButtonType.Normal)
                .backgroundColor(Color.Transparent)
                .fontColor($r('app.color.accent_light'))
                .enabled(!this.rssLoading)
                .onClick(() => {
                  this.rssDialogVisible = false;
                })
              Button(this.rssLoading ? 'Adding...' : 'Add')
                .layoutWeight(1)
                .type(ButtonType.Normal)
                .backgroundColor(Color.Transparent)
                .fontColor($r('app.color.accent_light'))
                .enabled(!this.rssLoading)
                .onClick(() => this.confirmRssUrl())
            }
            .width('100%')
            .height(48)
          }
          .width('80%')
          .backgroundColor($r('app.color.background_light'))
          .borderRadius(12)
        }
        .width('100%')
        .height('100%')
      }
    }
    .width('100%')
    .height('100%')
  }
}

export default AddFeedPage;
