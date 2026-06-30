import { FeedItem } from '../model/EpisodeModel';

@Component
export struct QueueListItem {
  @Prop item: FeedItem;
  @Prop canReorder: boolean = true;
  dragStartHandler?: (item: FeedItem) => void;

  build() {
    Row() {
      // Drag handle (left_padding / drag_handle) — shown only when reordering allowed
      if (this.canReorder) {
        Image($r('app.media.ic_feed_black'))
          .width(16)
          .height('100%')
          .fillColor($r('app.color.grey600'))
          .objectFit(ImageFit.Contain)
          .margin({ right: 4 })
          // Android: drag_handle importantForAccessibility="no"
          .accessibilityLevel('no')
          .gesture(LongPressGesture().onAction(() => {
            if (this.dragStartHandler) {
              this.dragStartHandler(this.item);
            }
          }))
      }

      // Cover holder (CardView 8dp radius)
      Stack() {
        // Placeholder text (feed title) behind cover
        Text(this.item.feedTitle)
          .fontSize(10)
          .fontColor($r('app.color.grey600'))
          .maxLines(3)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .textAlign(TextAlign.Center)
          .padding(2)
        // Cover image
        // TODO: Load actual episode cover from item.imageUrl via CoverLoader
        Image($r('app.media.ic_feed_black'))
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
          .fillColor($r('app.color.grey600'))
      }
      .width(56)
      .height(56)
      .borderRadius(8)
      .backgroundColor($r('app.color.non_square_icon_background'))
      .clip(true)
      .margin({ top: 11, bottom: 11, right: 16 })

      // Text + status + progress column (weight 1)
      Column() {
        // Status icons row
        Row() {
          if (this.item.isNew) {
            // statusInbox
            // TODO: Replace placeholder with ic_inbox
            Image($r('app.media.ic_feed_black'))
              .width(12)
              .height(12)
              .fillColor($r('app.color.text_color_secondary_light'))
              .accessibilityText($r('app.string.inbox_label'))
          }
          if (this.item.isDownloaded && this.item.media && this.item.media.mimeType === 'video') {
            // ivIsVideo
            // TODO: Replace placeholder with ic_videocam
            Image($r('app.media.ic_feed_black'))
              .width(12)
              .height(12)
              .fillColor($r('app.color.text_color_secondary_light'))
          }

          Text('·')
            .fontSize(12)
            .fontColor($r('app.color.grey600'))
            .margin({ left: 4, right: 4 })

          // pubDate
          Text(this.item.pubDate)
            .fontSize(12)
            .fontColor($r('app.color.grey600'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ right: 4 })

          Text('·')
            .fontSize(12)
            .fontColor($r('app.color.grey600'))
            .margin({ right: 4 })

          // size
          // TODO: Show formatted media size when available
          Text('')
            .fontSize(12)
            .fontColor($r('app.color.grey600'))
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)

        // Title
        Text(this.item.title)
          .fontSize(16)
          .fontWeight(FontWeight.Normal)
          .fontColor($r('app.color.black'))
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')
          .margin({ top: 2 })

        // Progress row (position / progressbar / duration)
        if (this.item.media && (this.item.media.position > 0)) {
          Row() {
            Text(this.formatTime(this.item.media.position))
              .fontSize(12)
              .fontColor($r('app.color.grey600'))

            Progress({ value: this.progressPercent(), total: 100, type: ProgressType.Linear })
              .layoutWeight(1)
              .margin({ left: 4, right: 4 })
              .color($r('app.color.accent_light'))

            Text(this.formatTime(this.item.media.duration))
              .fontSize(12)
              .fontColor($r('app.color.grey600'))
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)
          .margin({ top: 2 })
        }
      }
      .layoutWeight(1)
      .margin({ top: 11, bottom: 11, right: 8 })
      .alignItems(HorizontalAlign.Start)

      // Secondary action button (play / download)
      // TODO: Use ItemActionButton.forItem to pick play vs download icon
      Image($r('app.media.ic_animate_play'))
        .width(32)
        .height(32)
        .fillColor($r('app.color.accent_light'))
        .onClick(() => {
          console.info('TODO: Play/download episode ' + this.item.id);
        })
    }
    .width('100%')
    .padding({ left: 12, right: 12 })
    .alignItems(VerticalAlign.Center)
    .opacity(this.item.isPlayed ? 0.5 : 1.0)
  }

  private progressPercent(): number {
    if (!this.item.media || this.item.media.duration <= 0) {
      return 0;
    }
    return Math.min(100, Math.max(0, Math.floor(100 * this.item.media.position / this.item.media.duration)));
  }

  private formatTime(ms: number): string {
    // TODO: Replace with Converter.getDurationStringLong
    const totalSec = Math.floor(ms / 1000);
    const h = Math.floor(totalSec / 3600);
    const m = Math.floor((totalSec % 3600) / 60);
    const s = totalSec % 60;
    const mm = m < 10 ? '0' + m : '' + m;
    const ss = s < 10 ? '0' + s : '' + s;
    if (h > 0) {
      return h + ':' + mm + ':' + ss;
    }
    return mm + ':' + ss;
  }
}
