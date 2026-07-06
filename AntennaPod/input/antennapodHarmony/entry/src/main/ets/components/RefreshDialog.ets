@Component
export struct RefreshDialog {
  @Prop visible: boolean = false;
  onAlways: () => void = () => {};
  onNo: () => void = () => {};
  onOnce: () => void = () => {};

  build() {
    if (this.visible) {
      Stack({ alignContent: Alignment.Center }) {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor($r('app.color.image_readability_tint'))
          .onClick(() => {})

        Column() {
          // TODO: replace with $r('app.string.refresh_podcast_label') once added
          Text('Refresh podcasts')
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.black'))
            .margin({ top: 24, bottom: 16 })

          Divider().color($r('app.color.light_gray'))

          // TODO: replace with $r('app.string.refresh_over_mobile_dialog_message') once added
          Text('Refreshing podcasts over mobile data connection can use a lot of data.')
            .fontSize(14)
            .fontColor($r('app.color.text_color_secondary_light'))
            .margin({ top: 16, bottom: 24, left: 24, right: 24 })

          Divider().color($r('app.color.light_gray'))

          Row() {
            // TODO: replace with $r('app.string.always_label') once added
            Button('Always')
              .layoutWeight(1)
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .fontColor($r('app.color.accent_light'))
              .onClick(() => this.onAlways())
            Button($r('app.string.no'))
              .layoutWeight(1)
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .fontColor($r('app.color.accent_light'))
              .onClick(() => this.onNo())
            // TODO: replace with $r('app.string.once_label') once added
            Button('Once')
              .layoutWeight(1)
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .fontColor($r('app.color.accent_light'))
              .onClick(() => this.onOnce())
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
}
