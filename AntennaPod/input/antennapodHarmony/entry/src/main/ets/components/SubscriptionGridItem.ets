import { Feed } from '../model/EpisodeModel';

@Component
export struct SubscriptionGridItem {
  @Prop feed: Feed;
  @Prop counter: number = 0;
  @Prop showTitle: boolean = true;
  @Prop columnCount: number = 3;
  @Prop isSelected: boolean = false;
  @Prop selectMode: boolean = false;

  private getTitleSize(): number {
    // SubscriptionViewHolder.bind: 2 -> 16, 3 -> 15, else 14
    if (this.columnCount === 2) {
      return 16;
    } else if (this.columnCount === 3) {
      return 15;
    }
    return 14;
  }

  private getTitlePadding(): number {
    // columnCount <= 3 -> 16, else 8
    return this.columnCount <= 3 ? 16 : 8;
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // outerContainer CardView (cornerRadius 12dp, elevation 1dp)
      Column() {
        // Inner cover CardView (cornerRadius 12dp, non_square_icon_background)
        Stack() {
          // coverImage (SquareImageView, fitCenter)
          Image(this.feed.imageUrl)
            .width('100%')
            .height('100%')
            .objectFit(ImageFit.Contain)
            .borderRadius(12)
            .backgroundColor($r('app.color.non_square_icon_background'))
            .alt(this.feed.title)
            .accessibilityText(this.feed.title)
            .opacity(this.isSelected && this.selectMode ? 0.6 : 1)

          // fallbackTitleLabel (overlay on cover when title label is hidden)
          if (!this.showTitle && this.columnCount !== 1) {
            Text(this.feed.title)
              .fontSize(this.getTitleSize())
              .fontColor($r('app.color.white'))
              .backgroundColor($r('app.color.feed_text_bg'))
              .textAlign(TextAlign.Center)
              .maxLines(3)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .padding(this.getTitlePadding())
          }

          // countViewPill (top-right, TextPill style)
          if (this.counter > 0 && !(this.selectMode)) {
            Text(this.counter.toString())
              .fontSize(14)
              .fontColor($r('app.color.white'))
              .backgroundColor($r('app.color.accent_light'))
              .borderRadius(12)
              .padding({ left: 6, right: 6, top: 2, bottom: 2 })
              .margin(4)
              .align(Alignment.TopEnd)
              .maxLines(1)
          }

          // errorIcon (bottom-right, gone by default)
          if (this.feed.hasLastUpdateFailed) {
            // TODO: Replace placeholder with ic_error when available
            Image($r('app.media.ic_feed_black'))
              .width(24)
              .height(24)
              .fillColor($r('app.color.accent_light'))
              .margin(8)
              .align(Alignment.BottomEnd)
              .accessibilityText($r('app.string.refresh_failed_msg'))
          }
        }
        .width('100%')
        .aspectRatio(1)
        .borderRadius(12)
        .clip(true)

        // titleLabel (below cover, 2 lines)
        if (this.showTitle || this.columnCount === 1) {
          Text(this.feed.title)
            .width('100%')
            .fontSize(this.getTitleSize())
            .fontColor($r('app.color.black'))
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: 4 })
            .padding({
              left: this.getTitlePadding() / 2,
              right: this.getTitlePadding() / 2
            })
        }
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .borderRadius(12)
      .backgroundColor($r('app.color.background_light'))
      .shadow({ radius: 2, color: '#1A000000', offsetY: 1 })

      // selectedIcon (top, gone by default; shown in select mode)
      if (this.selectMode) {
        // TODO: Replace placeholder with circle_checked/circle_unchecked when available
        Stack() {
          Circle({ width: 32, height: 32 })
            .fill($r('app.color.white))
            .stroke($r('app.color.accent_light'))
            .strokeWidth(2)
          if (this.isSelected) {
            Circle({ width: 18, height: 18 })
              .fill($r('app.color.accent_light'))
          }
        }
        .width(32)
        .height(32)
        .margin(4)
      }
    }
    .width('100%')
  }
}
