import { OverflowMenuOption } from '../model/HomeSection';

@Component
export struct OverflowMenu {
  @Prop visible: boolean = false;
  @Prop items: OverflowMenuOption[] = [];
  onSelect: (id: string) => void = () => {};
  onDismiss: () => void = () => {};

  build() {
    if (this.visible) {
      Stack({ alignContent: Alignment.TopEnd }) {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor($r('app.color.image_readability_tint'))
          .onClick(() => this.onDismiss())

        Column() {
          ForEach(this.items, (item: OverflowMenuOption) => {
            Row() {
              Text(item.label)
                .fontSize(16)
                .fontColor($r('app.color.black'))
                .layoutWeight(1)
            }
            .width('100%')
            .height(48)
            .padding({ left: 24, right: 24 })
            .onClick(() => {
              if (item.enabled) {
                this.onSelect(item.id);
              }
            })
            .enabled(item.enabled)
          }, (item: OverflowMenuOption) => item.id)
        }
        .width(280)
        .backgroundColor($r('app.color.background_light'))
        .borderRadius(8)
        .margin({ top: 64, right: 8 })
        .shadow({ radius: 12, color: $r('app.color.image_readability_tint'), offsetY: 2 })
        .clip(true)
      }
      .width('100%')
      .height('100%')
    }
  }
}
