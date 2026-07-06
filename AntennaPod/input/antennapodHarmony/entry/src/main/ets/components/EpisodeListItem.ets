import { EpisodeData, SecondaryActionType } from '../model/EpisodeData';

@Component
export struct EpisodeListItem {
  @ObjectLink episode: EpisodeData;
  @Prop showDragHandle: boolean = false;
  onItemClick: (episode: EpisodeData) => void = () => {};
  onSecondaryAction: (episode: EpisodeData) => void = () => {};
  onLongPress: (episode: EpisodeData) => void = () => {};

  private secondaryIcon(): Resource {
    switch (this.episode.secondaryAction) {
      case SecondaryActionType.PLAY: return $r('app.media.ic_play_48dp');
      case SecondaryActionType.DOWNLOAD: return $r('app.media.ic_download');
      case SecondaryActionType.CANCEL_DOWNLOAD: return $r('app.media.ic_cancel');
      default: return $r('app.media.ic_play_48dp');
    }
  }

  private secondaryDesc(): string {
    switch (this.episode.secondaryAction) {
      case SecondaryActionType.PLAY: return 'Play';
      case SecondaryActionType.DOWNLOAD: return 'Download';
      case SecondaryActionType.CANCEL_DOWNLOAD: return 'Cancel download';
      default: return 'Play';
    }
  }

  build() {
    Row() {
      // drag handle / left padding
      Column() {
        if (this.showDragHandle) {
          Image($r('app.media.ic_drag_lighttheme'))
            .width(16)
            .height(40)
            .fillColor($r('app.color.grey600'))
        }
      }
      .width(this.showDragHandle ? 24 : 12)
      .height('100%')
      .justifyContent(FlexAlign.Center)

      // cover
      Image(this.episode.cover)
        .width(56)
        .height(56)
        .borderRadius(8)
        .backgroundColor($r('app.color.non_square_icon_background'))
        .objectFit(ImageFit.Cover)
        .margin({ top: 11, bottom: 11, right: 16 })

      // text block
      Column() {
        // status row
        Row() {
          if (this.episode.isInbox) {
            Image($r('app.media.ic_inbox')).width(12).height(12)
              .fillColor($r('app.color.grey600')).margin({ right: 4 })
          }
          if (this.episode.isVideo) {
            Image($r('app.media.ic_videocam')).width(12).height(12)
              .fillColor($r('app.color.grey600')).margin({ right: 4 })
          }
          if (this.episode.isFavorite) {
            Image($r('app.media.ic_star')).width(12).height(12)
              .fillColor($r('app.color.grey600')).margin({ right: 4 })
          }
          if (this.episode.inQueue) {
            Image($r('app.media.ic_playlist_play')).width(12).height(12)
              .fillColor($r('app.color.grey600')).margin({ right: 4 })
          }
          if (this.episode.isFavorite || this.episode.inQueue) {
            Text('·').fontSize(12).fontColor($r('app.color.grey600')).margin({ right: 4 })
          }
          if (this.episode.pubDate) {
            Text(this.episode.pubDate)
              .fontSize(12)
              .fontColor($r('app.color.grey600'))
              .margin({ right: 4 })
              .accessibilityText(this.episode.pubDateDesc)
          }
          if (this.episode.sizeText) {
            Text('·').fontSize(12).fontColor($r('app.color.grey600')).margin({ right: 4 })
            Text(this.episode.sizeText)
              .fontSize(12)
              .fontColor($r('app.color.grey600'))
          }
        }
        .width('100%')

        // title
        Text(this.episode.title)
          .width('100%')
          .fontSize(16)
          .fontColor($r('app.color.black'))
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 2 })
          .accessibilityText(this.episode.title)

        // progress row
        Row() {
          if (this.episode.position) {
            Text(this.episode.position)
              .fontSize(12)
              .fontColor($r('app.color.grey600'))
              .accessibilityText(this.episode.positionDesc)
          }
          Progress({ value: this.episode.progress, total: 100, type: ProgressType.Linear })
            .layoutWeight(1)
            .height(2)
            .margin({ left: 8, right: 8 })
            .color($r('app.color.accent_light'))
            .visibility(this.episode.progress > 0 ? Visibility.Visible : Visibility.Hidden)
          if (this.episode.duration) {
            Text(this.episode.duration)
              .fontSize(12)
              .fontColor($r('app.color.grey600'))
              .accessibilityText(this.episode.durationDesc)
          }
        }
        .width('100%')
        .margin({ top: 2 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      // secondary action button
      Stack() {
        if (this.episode.secondaryAction === SecondaryActionType.DOWNLOAD ||
            this.episode.secondaryAction === SecondaryActionType.CANCEL_DOWNLOAD) {
          Progress({ value: this.episode.downloadProgress, total: 100, type: ProgressType.Ring })
            .width(40)
            .height(40)
            .color($r('app.color.accent_light'))
        }
        Image(this.secondaryIcon())
          .width(24)
          .height(24)
          .fillColor($r('app.color.black'))
      }
      .width(48)
      .height(48)
      .margin({ right: 12 })
      .onClick(() => this.onSecondaryAction(this.episode))
      .accessibilityText(this.secondaryDesc())
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .onClick(() => this.onItemClick(this.episode))
    .gesture(LongPressGesture().onAction(() => this.onLongPress(this.episode)))
  }
}
