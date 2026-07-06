import { FeedData } from '../model/FeedData';
import { subscriptionsViewModel } from '../viewmodel/SubscriptionsViewModel';
import { eventBus, AppEvent } from '../common/event/EventBus';

@Component
export struct SubscriptionsPage {
  @State feeds: FeedData[] = [];
  @State refreshing: boolean = false;
  onItemClick: (feed: FeedData) => void = () => {};
  onAddPodcast: () => void = () => {};

  private listener: () => void = (): void => {
    subscriptionsViewModel.load();
    this.feeds = subscriptionsViewModel.feeds.slice();
  };

  aboutToAppear(): void {
    subscriptionsViewModel.load();
    this.feeds = subscriptionsViewModel.feeds.slice();
    eventBus.on(AppEvent.FEEDS_CHANGED, this.listener);
    eventBus.on(AppEvent.EPISODES_CHANGED, this.listener);
  }

  aboutToDisappear(): void {
    eventBus.off(AppEvent.FEEDS_CHANGED, this.listener);
    eventBus.off(AppEvent.EPISODES_CHANGED, this.listener);
  }

  private formatCount(count: number): string {
    const raw = `${count}`;
    let out = '';
    for (let i = 0; i < raw.length; i++) {
      const digitFromEnd = raw.length - 1 - i;
      if (i > 0 && digitFromEnd % 3 === 0) {
        out = `${out},`;
      }
      out = `${out}${raw[i]}`;
    }
    return out;
  }

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      if (this.feeds.length === 0) {
        Column() {
          Image($r('app.media.ic_subscriptions'))
            .width(72)
            .height(72)
            .fillColor($r('app.color.grey600'))
            .margin({ bottom: 12 })
          Text($r('app.string.no_subscriptions_head_label'))
            .fontSize(18)
            .fontColor($r('app.color.black'))
            .margin({ bottom: 4 })
          Text($r('app.string.no_subscriptions_label'))
            .fontSize(14)
            .fontColor($r('app.color.grey600'))
            .textAlign(TextAlign.Center)
            .padding({ left: 32, right: 32 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor($r('app.color.background_light'))
      } else {
        Grid() {
          ForEach(this.feeds, (feed: FeedData) => {
            GridItem() {
              Column() {
                Stack({ alignContent: Alignment.TopEnd }) {
                  Image(feed.cover)
                    .width('100%')
                    .aspectRatio(1)
                    .borderRadius(12)
                    .backgroundColor($r('app.color.non_square_icon_background'))
                    .objectFit(ImageFit.Cover)
                  if (feed.count > 0) {
                    Text(this.formatCount(feed.count))
                      .fontSize(14)
                      .fontColor($r('app.color.accent_light'))
                      .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                      .backgroundColor($r('app.color.color_secondary_container_light'))
                      .borderRadius(12)
                      .margin({ top: 6, right: 6 })
                  }
                  if (feed.hasUpdateFailed) {
                    Image($r('app.media.ic_history_remove'))
                      .width(16)
                      .height(16)
                      .fillColor($r('app.color.accent_light'))
                      .position({ x: 6, y: 6 })
                  }
                }
                .width('100%')

                Text(feed.title)
                  .width('100%')
                  .fontSize(14)
                  .fontColor($r('app.color.black'))
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .textAlign(TextAlign.Start)
                  .margin({ top: 4 })
              }
              .borderRadius(12)
              .backgroundColor($r('app.color.grey100'))
              .padding(4)
              .onClick(() => {
                this.onItemClick(feed);
              })
              .accessibilityText(feed.title)
            }
          }, (feed: FeedData) => feed.id)
        }
        .columnsTemplate('1fr 1fr 1fr')
        .rowsGap(8)
        .columnsGap(8)
        .padding({ left: 4, right: 4, top: 4, bottom: 4 })
        .width('100%')
        .height('100%')
        .backgroundColor($r('app.color.background_light'))
        .scrollBar(BarState.Auto)
      }

      Button() {
        Image($r('app.media.ic_add'))
          .width(24)
          .height(24)
          .fillColor($r('app.color.white'))
      }
      .type(ButtonType.Circle)
      .width(56)
      .height(56)
      .backgroundColor($r('app.color.accent_light'))
      .margin({ right: 16, bottom: 16 })
      .shadow({ radius: 6, color: $r('app.color.image_readability_tint'), offsetY: 2 })
      .onClick(() => {
        this.onAddPodcast();
      })
      .accessibilityText($r('app.string.add_feed_label'))
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_light'))
  }
}
