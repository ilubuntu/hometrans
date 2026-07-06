@Component
export struct MiniPlayerBar {
  @Prop title: string = 'Listener Tales 111: Camping Tales';
  @Prop author: string = 'Morbid';
  @Prop cover: Resource = $r('app.media.ic_feed');
  @Prop progress: number = 47;
  @Prop isPlaying: boolean = true;
  onPlayClick: () => void = () => {};
  onBarClick: () => void = () => {};

  build() {
    Column() {
      Row() {
        Image(this.cover)
          .width(56)
          .height(56)
          .objectFit(ImageFit.Cover)
          .backgroundColor($r('app.color.non_square_icon_background'))

        Column() {
          Text(this.title)
            .fontSize(14)
            .fontColor($r('app.color.black'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text(this.author)
            .fontSize(14)
            .fontColor($r('app.color.text_color_secondary_light'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ top: 2 })
        }
        .layoutWeight(1)
        .margin({ left: 16 })
        .alignItems(HorizontalAlign.Start)

        Image(this.isPlaying ? $r('app.media.ic_pause') : $r('app.media.ic_play_48dp'))
          .width(36)
          .height(36)
          .fillColor($r('app.color.black'))
          .margin({ right: 8 })
          .onClick(() => this.onPlayClick())
          .accessibilityText(this.isPlaying ? $r('app.string.pause_label') : $r('app.string.play_label'))
      }
      .width('100%')
      .height(60)
      .alignItems(VerticalAlign.Center)
      .onClick(() => this.onBarClick())

      Progress({ value: this.progress, total: 100, type: ProgressType.Linear })
        .width('100%')
        .height(4)
        .color($r('app.color.accent_light'))
    }
    .width('100%')
    .backgroundColor($r('app.color.background_light'))
  }
}
