import { MoreViewModel, MoreNavItem } from '../viewmodel/MoreViewModel';
import { BottomNavigation } from '../components/BottomNavigation';

@Entry
@Component
struct MorePage {
  @State items: MoreNavItem[] = [];
  @State currentTab: number = 4;
  private viewModel: MoreViewModel = new MoreViewModel();

  aboutToAppear() {
    this.viewModel.setRefreshCallback((): void => { this.items = this.viewModel.items; });
    this.viewModel.onAppear();
  }

  aboutToDisappear() {
    this.viewModel.onDisappear();
  }

  build() {
    Column() {
      this.ToolbarBuilder()

      Column() {
        this.NavListContent()
      }
      .layoutWeight(1)
      .width('100%')
      .backgroundColor($r('app.color.background_light'))

      BottomNavigation({ currentTab: $currentTab })
    }
    .height('100%')
    .backgroundColor($r('app.color.background_light'))
  }

  @Builder
  ToolbarBuilder() {
    Row() {
      Text($r('app.string.overflow_more'))
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.black'))
        .margin({ left: 16 })
        .layoutWeight(1)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .height(56)
    .backgroundColor($r('app.color.background_light'))
  }

  @Builder
  NavListContent() {
    List({ space: 0 }) {
      ForEach(this.items, (item: MoreNavItem) => {
        ListItem() {
          this.NavListItem(item)
        }
        .height(48)
        .onClick(() => {
          this.viewModel.onItemClick(item);
        })
      }, (item: MoreNavItem) => item.tag)
    }
    .width('100%')
    .height('100%')
    .padding({ top: 8, bottom: 8 })
    .scrollBar(BarState.Auto)
  }

  @Builder
  NavListItem(item: MoreNavItem) {
    Row() {
      Image(item.icon)
        .width(40)
        .height(40)
        .padding(8)
        .objectFit(ImageFit.Contain)
        .fillColor($r('app.color.grey600'))
        .margin({ left: 16 })
        .draggable(false)

      Text(item.title)
        .fontSize(16)
        .fontColor($r('app.color.black'))
        .margin({ left: 16, right: 16 })
        .layoutWeight(1)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .height('100%')
    .alignItems(VerticalAlign.Center)
  }
}
