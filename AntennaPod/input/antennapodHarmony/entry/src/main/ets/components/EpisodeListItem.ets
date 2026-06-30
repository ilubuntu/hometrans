import { FeedItem } from '../model/EpisodeModel';

@Component
export struct EpisodeListItem {
  @Prop item: FeedItem;

  build() {
    Row() {
      // Cover image / feed thumbnail
      // TODO: Load actual feed cover image from item.imageUrl
      Image($r('app.media.ic_feed_black'))
        .width(56)
        .height(56)
        .borderRadius(4)
        .fillColor($r('app.color.grey600'))
        .objectFit(ImageFit.Cover)
        .backgroundColor($r('app.color.background_elevated_light'))

      // Text content
      Column() {
        Text(this.item.title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.black'))
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        Row() {
          Text(this.item.feedTitle)
            .fontSize(12)
            .fontColor($r('app.color.grey600'))
            .layoutWeight(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(this.item.pubDate)
            .fontSize(12)
            .fontColor($r('app.color.grey600'))
            .margin({ left: 8 })
        }
        .width('100%')
        .margin({ top: 4 })
      }
      .layoutWeight(1)
      .margin({ left: 12 })
      .alignItems(HorizontalAlign.Start)

      // Play / Download button
      // TODO: Show play icon if downloaded, download icon otherwise
      Image($r('app.media.ic_animate_play'))
        .width(32)
        .height(32)
        .fillColor($r('app.color.accent_light'))
        .onClick(() => {
          // TODO: Start playback or download
          console.info('TODO: Play episode ' + this.item.id);
        })
    }
    .width('100%')
    .padding({ top: 8, bottom: 8, left: 16, right: 16 })
    .alignItems(VerticalAlign.Center)
  }
}
