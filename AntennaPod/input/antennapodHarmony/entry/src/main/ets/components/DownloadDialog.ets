@Component
export struct DownloadDialog {
  @Prop visible: boolean = false;
  @Prop title: string = 'Confirm mobile download';
  @Prop message: string = '';
  onDownloadLater: () => void = () => {};
  onDownloadAnyway: () => void = () => {};
  onCancel: () => void = () => {};

  build() {
    if (this.visible) {
      Stack({ alignContent: Alignment.Center }) {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor($r('app.color.image_readability_tint'))
          .onClick(() => this.onCancel())

        Column() {
          Text(this.title)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.black'))
            .width('100%')
            .margin({ bottom: 12 })

          if (this.message.length > 0) {
            Text(this.message)
              .fontSize(14)
              .fontColor($r('app.color.text_color_secondary_light'))
              .lineHeight(20)
              .width('100%')
              .margin({ bottom: 8 })
          }

          Column({ space: 0 }) {
            // TODO: replace with $r('app.string.confirm_mobile_download_dialog_download_later') once resource is migrated
            Button('Download later')
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .fontSize(14)
              .fontColor($r('app.color.accent_light'))
              .width('100%')
              .height(48)
              .onClick(() => this.onDownloadLater())
            Divider().color($r('app.color.grey100')).strokeWidth(1)
            Button($r('app.string.cancel_label'))
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .fontSize(14)
              .fontColor($r('app.color.text_color_secondary_light'))
              .width('100%')
              .height(48)
              .onClick(() => this.onCancel())
            Divider().color($r('app.color.grey100')).strokeWidth(1)
            // TODO: replace with $r('app.string.confirm_mobile_download_dialog_allow_this_time') once resource is migrated
            Button('Download anyway')
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .fontSize(14)
              .fontColor($r('app.color.accent_light'))
              .width('100%')
              .height(48)
              .onClick(() => this.onDownloadAnyway())
          }
          .width('100%')
          .margin({ top: 8 })
        }
        .width('82%')
        .padding({ left: 24, right: 24, top: 20, bottom: 12 })
        .backgroundColor($r('app.color.background_light'))
        .borderRadius(12)
      }
      .width('100%')
      .height('100%')
    }
  }
}
