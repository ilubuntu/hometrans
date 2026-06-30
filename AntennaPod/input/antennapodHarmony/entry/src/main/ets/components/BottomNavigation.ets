@Component
export struct BottomNavigation {
  @Link currentTab: number;

  @Builder
  NavTab(index: number, icon: Resource, label: Resource, a11y: Resource) {
    Column() {
      Stack() {
        Image(icon)
          .width(24)
          .height(24)
          .fillColor(this.currentTab === index ? $r('app.color.accent_light') : $r('app.color.grey600'))
      }
      .width(56)
      .height(32)
      .borderRadius(16)
      .backgroundColor(this.currentTab === index ? $r('app.color.color_secondary_container_light') : Color.Transparent)

      Text(label)
        .fontSize(this.currentTab === index ? '14fp' : '11fp')
        .margin({ top: 4 })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontColor(this.currentTab === index ? $r('app.color.accent_light') : $r('app.color.grey600'))
    }
    .layoutWeight(1)
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .accessibilityText(a11y)
    .onClick(() => {
      this.currentTab = index;
    })
  }

  build() {
    Row() {
      this.NavTab(0, $r('app.media.ic_home'), $r('app.string.home_label_short'), $r('app.string.home_label'))
      this.NavTab(1, $r('app.media.ic_playlist_play_black'), $r('app.string.queue_label_short'), $r('app.string.queue_label'))
      this.NavTab(2, $r('app.media.ic_inbox'), $r('app.string.inbox_label_short'), $r('app.string.inbox_label'))
      this.NavTab(3, $r('app.media.ic_subscriptions_black'), $r('app.string.subscriptions_label_short'), $r('app.string.subscriptions_label'))
      this.NavTab(4, $r('app.media.ic_more_vert'), $r('app.string.overflow_more'), $r('app.string.overflow_more'))
    }
    .width('100%')
    .height(80)
    .backgroundColor($r('app.color.white'))
  }
}
