import { HomeSectionOrderEntry } from '../model/HomeSection';

@Component
export struct ConfigureHomeDialog {
  @Prop visible: boolean = false;
  @Prop shownSections: HomeSectionOrderEntry[] = [];
  @Prop hiddenSections: HomeSectionOrderEntry[] = [];
  onReset: () => void = () => {};
  onCancel: () => void = () => {};
  onOk: () => void = () => {};

  build() {
    if (this.visible) {
      Stack({ alignContent: Alignment.Center }) {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor($r('app.color.image_readability_tint'))

        Column() {
          Text($r('app.string.configure_home'))
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.black'))
            .margin({ top: 20, bottom: 16 })

          Scroll() {
            Column() {
              Text($r('app.string.section_shown'))
                .fontSize(14)
                .fontColor($r('app.color.grey600'))
                .margin({ top: 8, bottom: 8, left: 16 })
                .alignSelf(ItemAlign.Start)
              ForEach(this.shownSections, (entry: HomeSectionOrderEntry, index: number) => {
                Row() {
                  Image($r('app.media.ic_drag_lighttheme'))
                    .width(20)
                    .height(20)
                    .fillColor($r('app.color.grey600'))
                  Text(entry.label)
                    .fontSize(15)
                    .fontColor($r('app.color.black'))
                    .margin({ left: 16 })
                    .layoutWeight(1)
                }
                .width('100%')
                .height(48)
                .padding({ left: 16, right: 16 })
                .accessibilityText('Sort')
              }, (entry: HomeSectionOrderEntry, index: number) => `s${index}`)

              Text($r('app.string.section_hidden'))
                .fontSize(14)
                .fontColor($r('app.color.grey600'))
                .margin({ top: 16, bottom: 8, left: 16 })
                .alignSelf(ItemAlign.Start)
              ForEach(this.hiddenSections, (entry: HomeSectionOrderEntry, index: number) => {
                Row() {
                  Image($r('app.media.ic_drag_lighttheme'))
                    .width(20)
                    .height(20)
                    .fillColor($r('app.color.grey600'))
                  Text(entry.label)
                    .fontSize(15)
                    .fontColor($r('app.color.black'))
                    .margin({ left: 16 })
                    .layoutWeight(1)
                }
                .width('100%')
                .height(48)
                .padding({ left: 16, right: 16 })
                .accessibilityText('Sort')
              }, (entry: HomeSectionOrderEntry, index: number) => `h${index}`)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }
          .layoutWeight(1)

          Divider().color($r('app.color.light_gray'))

          Row() {
            Button($r('app.string.reset'))
              .layoutWeight(1)
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .fontColor($r('app.color.accent_light'))
              .onClick(() => this.onReset())
            Button($r('app.string.cancel_label'))
              .layoutWeight(1)
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .fontColor($r('app.color.accent_light'))
              .onClick(() => this.onCancel())
            Button($r('app.string.confirm_label'))
              .layoutWeight(1)
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .fontColor($r('app.color.accent_light'))
              .onClick(() => this.onOk())
          }
          .width('100%')
          .height(48)
        }
        .width('88%')
        .height('70%')
        .backgroundColor($r('app.color.background_light'))
        .borderRadius(12)
      }
      .width('100%')
      .height('100%')
    }
  }
}
