import { EPISODE_FILTER_GROUPS, FilterGroup, FilterValue } from '../viewmodel/EpisodesViewModel';

@Component
export struct EpisodesFilterDialog {
  @Prop visible: boolean = false;
  @Prop selected: string[] = [];
  onConfirm: (values: string[]) => void = () => {};
  onReset: () => void = () => {};
  onDismiss: () => void = () => {};
  @State localSelected: string[] = [];

  aboutToAppear(): void {
    this.localSelected = this.selected.slice();
  }

  private isSelected(filterId: string): boolean {
    return this.localSelected.indexOf(filterId) >= 0;
  }

  private toggle(group: FilterGroup, filterId: string): void {
    const next: string[] = this.localSelected.filter((id: string) => {
      return group.values.findIndex((v: FilterValue) => v.filterId === id) < 0;
    });
    if (this.isSelected(filterId)) {
      this.localSelected = next;
    } else {
      next.push(filterId);
      this.localSelected = next;
    }
  }

  @Builder
  FilterRow(group: FilterGroup) {
    Row({ space: 8 }) {
      ForEach(group.values, (value: FilterValue) => {
        Text(value.label)
          .fontSize(14)
          .fontColor(this.isSelected(value.filterId)
            ? $r('app.color.accent_light') : $r('app.color.black'))
          .maxLines(3)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .textAlign(TextAlign.Center)
          .layoutWeight(1)
          .height(56)
          .borderRadius(8)
          .border({
            width: 1,
            color: this.isSelected(value.filterId)
              ? $r('app.color.accent_light') : $r('app.color.grey600')
          })
          .backgroundColor(this.isSelected(value.filterId)
            ? $r('app.color.grey100') : $r('app.color.background_light'))
          .onClick(() => this.toggle(group, value.filterId))
      }, (value: FilterValue) => value.filterId)
    }
    .width('100%')
    .margin({ bottom: 8 })
  }

  build() {
    if (this.visible) {
      Stack({ alignContent: Alignment.Bottom }) {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor($r('app.color.image_readability_tint'))
          .onClick(() => this.onDismiss())

        Column() {
          Text($r('app.string.filter'))
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.black'))
            .width('100%')
            .margin({ bottom: 12 })

          Scroll() {
            Column() {
              ForEach(EPISODE_FILTER_GROUPS, (group: FilterGroup) => {
                this.FilterRow(group)
              }, (group: FilterGroup, index: number) => `fg${index}`)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }
          .layoutWeight(1)
          .scrollBar(BarState.Auto)

          Row({ space: 0 }) {
            Button($r('app.string.reset'))
              .layoutWeight(1)
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .fontSize(14)
              .fontColor($r('app.color.accent_light'))
              .onClick(() => {
                this.localSelected = [];
                this.onReset();
              })
            Button($r('app.string.confirm_label'))
              .layoutWeight(1)
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .fontSize(14)
              .fontColor($r('app.color.accent_light'))
              .onClick(() => this.onConfirm(this.localSelected.slice()))
          }
          .width('100%')
          .height(52)
          .justifyContent(FlexAlign.SpaceAround)
        }
        .width('100%')
        .height('70%')
        .padding({ left: 24, right: 24, top: 16, bottom: 8 })
        .backgroundColor($r('app.color.background_light'))
        .borderRadius({ topLeft: 16, topRight: 16 })
      }
      .width('100%')
      .height('100%')
    }
  }
}
