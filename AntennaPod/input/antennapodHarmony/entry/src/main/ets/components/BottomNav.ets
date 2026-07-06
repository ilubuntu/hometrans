interface BottomNavItem {
  icon: Resource;
  label: Resource;
}

@Component
export struct BottomNav {
  @Link currentIndex: number;
  @Prop inboxBadge: number = 0;
  onTabSelected: (index: number) => void = () => {};

  private items: BottomNavItem[] = [
    { icon: $r('app.media.ic_home'), label: $r('app.string.home_label') },
    { icon: $r('app.media.ic_shortcut_playlist'), label: $r('app.string.queue_label') },
    { icon: $r('app.media.ic_inbox'), label: $r('app.string.inbox_label') },
    { icon: $r('app.media.ic_subscriptions'), label: $r('app.string.subscriptions_label') },
    { icon: $r('app.media.dots_vertical'), label: $r('app.string.overflow_more') }
  ];

  build() {
    Row() {
      ForEach(this.items, (item: BottomNavItem, index: number) => {
        Stack({ alignContent: Alignment.TopEnd }) {
          Column() {
            Image(item.icon)
              .width(24)
              .height(24)
              .fillColor(this.currentIndex === index ? $r('app.color.accent_light') : $r('app.color.grey600'))
            Text(item.label)
              .fontSize(12)
              .margin({ top: 4 })
              .fontColor(this.currentIndex === index ? $r('app.color.accent_light') : $r('app.color.grey600'))
          }
          .layoutWeight(1)
          .height('100%')
          .padding({ top: 6, bottom: 12 })
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            this.currentIndex = index;
            this.onTabSelected(index);
          })
          .accessibilityText(item.label)

          if (index === 2 && this.inboxBadge > 0) {
            Text(this.inboxBadge > 99 ? '99+' : `${this.inboxBadge}`)
              .fontSize(10)
              .fontColor($r('app.color.white'))
              .backgroundColor($r('app.color.accent_light'))
              .borderRadius(8)
              .padding({ left: 4, right: 4, top: 1, bottom: 1 })
              .margin({ top: 2, right: 8 })
              .align(Alignment.TopEnd)
          }
        }
        .layoutWeight(1)
        .height('100%')
      }, (item: BottomNavItem, index: number) => `${index}`)
    }
    .width('100%')
    .height(64)
    .backgroundColor($r('app.color.background_light'))
    .justifyContent(FlexAlign.SpaceAround)
  }
}
