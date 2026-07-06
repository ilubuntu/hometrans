@Component
export struct AppToolbar {
  @Prop title: ResourceStr = $r('app.string.home_label');
  @Prop showBack: boolean = false;
  @Prop showSearch: boolean = true;
  @Prop showFilter: boolean = false;
  @Prop showOverflow: boolean = true;
  onBack: () => void = () => {};
  onSearch: () => void = () => {};
  onFilter: () => void = () => {};
  onMore: () => void = () => {};

  build() {
    Row() {
      if (this.showBack) {
        Image($r('app.media.ic_arrow_right_white'))
          .width(24)
          .height(24)
          .margin({ left: 12, right: 8 })
          .fillColor($r('app.color.black'))
          .rotate({ angle: 180 })
          .onClick(() => this.onBack())
          .accessibilityText($r('app.string.toolbar_back_button_content_description'))
      }
      Text(this.title)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.black'))
        .layoutWeight(1)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ left: this.showBack ? 0 : 16 })
      if (this.showSearch) {
        Button() {
          Image($r('app.media.ic_search'))
            .width(24)
            .height(24)
            .fillColor($r('app.color.black'))
        }
        .type(ButtonType.Normal)
        .backgroundColor(Color.Transparent)
        .width(48)
        .height(48)
        .margin({ right: 4 })
        .onClick(() => this.onSearch())
        .accessibilityText($r('app.string.search_label'))
      }
      if (this.showFilter) {
        Button() {
          Image($r('app.media.ic_filter'))
            .width(24)
            .height(24)
            .fillColor($r('app.color.black'))
        }
        .type(ButtonType.Normal)
        .backgroundColor(Color.Transparent)
        .width(48)
        .height(48)
        .margin({ right: 4 })
        .onClick(() => this.onFilter())
        .accessibilityText($r('app.string.filter'))
      }
      if (this.showOverflow) {
        Button() {
          Image($r('app.media.dots_vertical'))
            .width(24)
            .height(24)
            .fillColor($r('app.color.black'))
        }
        .type(ButtonType.Normal)
        .backgroundColor(Color.Transparent)
        .width(48)
        .height(48)
        .margin({ right: 8 })
        .onClick(() => this.onMore())
        .accessibilityText('More options')
        .gesture(LongPressGesture().onAction(() => this.onMore()))
      }
    }
    .width('100%')
    .height(56)
    .padding({ top: 0, bottom: 0 })
    .alignItems(VerticalAlign.Center)
    .backgroundColor($r('app.color.background_light'))
  }
}
