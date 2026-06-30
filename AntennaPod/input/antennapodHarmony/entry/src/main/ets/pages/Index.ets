import { HomeViewModel } from '../viewmodel/HomeViewModel';
import { FeedItem } from '../model/EpisodeModel';
import { BottomNavigation } from '../components/BottomNavigation';
import { EpisodeListItem } from '../components/EpisodeListItem';

@Entry
@Component
struct Index {
  @State currentTab: number = 0;
  @State hasSubscriptions: boolean = false;
  @State episodes: FeedItem[] = [];
  private viewModel: HomeViewModel = new HomeViewModel();

  aboutToAppear() {
    this.viewModel.setRefreshCallback((): void => {
      this.hasSubscriptions = this.viewModel.hasSubscriptions;
      this.episodes = this.viewModel.episodes;
    });
    this.viewModel.onAppear();
  }

  aboutToAboutToDisappear() {
    this.viewModel.onDisappear();
  }

  getTabTitle(): Resource {
    if (this.currentTab === 1) {
      return $r('app.string.queue_label');
    } else if (this.currentTab === 2) {
      return $r('app.string.inbox_label');
    } else if (this.currentTab === 3) {
      return $r('app.string.subscriptions_label');
    }
    return $r('app.string.home_label');
  }

  build() {
    Column() {
      this.ToolbarBuilder()

      if (this.currentTab === 0) {
        this.InfoBarBuilder()
      }

      Column() {
        if (this.currentTab === 0) {
          if (this.hasSubscriptions) {
            this.EpisodeListContent()
          } else {
            this.WelcomeContent()
          }
        } else if (this.currentTab === 1) {
          this.QueuePlaceholder()
        } else if (this.currentTab === 2) {
          this.InboxPlaceholder()
        } else if (this.currentTab === 3) {
          this.SubscriptionsPlaceholder()
        } else if (this.currentTab === 4) {
          this.MorePlaceholder()
        }
      }
      .layoutWeight(1)
      .width('100%')
      .backgroundColor($r('app.color.background_light'))

      BottomNavigation({ currentTab: $currentTab })
    }
    .height('100%')
  }

  @Builder
  ToolbarBuilder() {
    Row() {
      Text(this.getTabTitle())
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.black'))
        .margin({ left: 16 })
        .layoutWeight(1)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Image($r('app.media.ic_search'))
        .width(24)
        .height(24)
        .fillColor($r('app.color.black'))
        .margin({ right: 16 })
        .accessibilityText($r('app.string.search_label'))
        .onClick(() => {
          console.info('TODO: Navigate to SearchPage');
        })

      Image($r('app.media.ic_more_vert'))
        .width(24)
        .height(24)
        .fillColor($r('app.color.black'))
        .margin({ right: 8 })
        .accessibilityText($r('app.string.overflow_more'))
        .bindMenu([
          {
            value: $r('app.string.refresh_label'),
            action: () => {
              this.viewModel.refresh();
            }
          },
          {
            value: $r('app.string.configure_home'),
            action: () => {
              console.info('TODO: Open home screen settings dialog');
            }
          },
        ])
    }
    .width('100%')
    .height(56)
    .backgroundColor($r('app.color.background_light'))
  }

  @Builder
  InfoBarBuilder() {
    Row() {
      Text(this.episodes.length + ' episodes · 0 minutes left')
        .fontSize(12)
        .fontColor($r('app.color.grey600'))
        .width('100%')
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 0, bottom: 8 })
    .backgroundColor($r('app.color.background_light'))
  }

  @Builder
  WelcomeContent() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Column() {
        Image($r('app.media.logo_monochrome'))
          .width(64)
          .height(64)
          .objectFit(ImageFit.Contain)
          .margin({ top: 48 })

        Text($r('app.string.home_welcome_title'))
          .fontSize(20)
          .fontColor($r('app.color.black'))
          .margin({ top: 16 })
          .textAlign(TextAlign.Center)
          .width('100%')

        Text($r('app.string.home_welcome_text'))
          .fontSize(14)
          .fontColor($r('app.color.black'))
          .margin({ top: 8 })
          .textAlign(TextAlign.Center)
          .width('100%')
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
      .padding({ left: 32, right: 32 })

      Stack() {
        Image($r('app.media.ic_add'))
          .width(24)
          .height(24)
          .fillColor($r('app.color.white'))
      }
      .width(56)
      .height(56)
      .borderRadius(28)
      .backgroundColor($r('app.color.accent_light'))
      .shadow({ radius: 4, color: '#66000000', offsetX: 0, offsetY: 2 })
      .margin({ bottom: 16, right: 16 })
      .accessibilityText($r('app.string.add_feed_label'))
      .onClick(() => {
        console.info('TODO: Navigate to AddPodcastPage');
      })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  EpisodeListContent() {
    List({ space: 0 }) {
      ForEach(this.episodes, (item: FeedItem) => {
        ListItem() {
          EpisodeListItem({ item: item })
        }
      }, (item: FeedItem) => item.id.toString())
    }
    .width('100%')
    .height('100%')
    .divider({
      strokeWidth: 1,
      color: $r('app.color.light_gray'),
      startMargin: 16,
      endMargin: 16,
    })
  }

  @Builder
  QueuePlaceholder() {
    Column() {
      Text($r('app.string.queue_label'))
        .fontSize(16)
        .fontColor($r('app.color.grey600'))
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  InboxPlaceholder() {
    Column() {
      Text($r('app.string.inbox_label'))
        .fontSize(16)
        .fontColor($r('app.color.grey600'))
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  SubscriptionsPlaceholder() {
    Column() {
      Text($r('app.string.subscriptions_label'))
        .fontSize(16)
        .fontColor($r('app.color.grey600'))
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  MorePlaceholder() {
    Column() {
      Text($r('app.string.overflow_more'))
        .fontSize(16)
        .fontColor($r('app.color.grey600'))
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
