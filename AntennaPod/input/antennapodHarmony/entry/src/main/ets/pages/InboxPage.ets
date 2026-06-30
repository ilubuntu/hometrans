import { FeedItem } from '../model/EpisodeModel';
import { InboxViewModel, InboxSortOrder } from '../viewmodel/InboxViewModel';
import { EpisodeListItem } from '../components/EpisodeListItem';
import { BottomNavigation } from '../components/BottomNavigation';
import { InboxSortDialog } from '../components/InboxSortDialog';

@Entry
@Component
struct InboxPage {
  @State episodes: FeedItem[] = [];
  @State isLoading: boolean = true;
  @State currentTab: number = 2;
  private viewModel: InboxViewModel = new InboxViewModel();
  private sortDialogController: CustomDialogController = new CustomDialogController({
    builder: InboxSortDialog({
      selected: this.viewModel.sortOrder,
      onConfirm: (order: InboxSortOrder) => {
        this.viewModel.setSortOrder(order);
        this.syncFromViewModel();
      }
    }),
    alignment: DialogAlignment.Center,
    customStyle: true,
  });

  aboutToAppear() {
    this.viewModel.setRefreshCallback((): void => { this.syncFromViewModel(); });
    this.viewModel.onAppear();
  }

  aboutToAboutToDisappear() {
    this.viewModel.onDisappear();
  }

  private syncFromViewModel() {
    this.episodes = this.viewModel.episodes;
    this.isLoading = this.viewModel.isLoading;
  }

  build() {
    Column() {
      this.ToolbarBuilder()

      this.InformationBarBuilder()

      Column() {
        if (this.isLoading) {
          this.LoadingContent()
        } else if (this.episodes.length === 0) {
          this.EmptyContent()
        } else {
          this.InboxListContent()
        }
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
      Text($r('app.string.inbox_label'))
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.black'))
        .layoutWeight(1)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .gesture(LongPressGesture().onAction(() => {
          // Android: toolbar long-press scrolls list to top
          console.info('TODO: Scroll inbox list to top');
        }))

      // action_search (showAsAction=always)
      Image($r('app.media.ic_search'))
        .width(24)
        .height(24)
        .fillColor($r('app.color.black'))
        .margin({ right: 16 })
        .accessibilityText($r('app.string.search_label'))
        .onClick(() => {
          this.viewModel.search();
        })

      // More options overflow (refresh, sort, remove all)
      Image($r('app.media.ic_more_vert'))
        .width(24)
        .height(24)
        .fillColor($r('app.color.black'))
        .margin({ right: 8 })
        .accessibilityText($r('app.string.overflow_more'))
        .bindMenu(this.buildOverflowMenu())
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 8 })
    .backgroundColor($r('app.color.background_light'))
  }

  @Builder
  InformationBarBuilder() {
    // txtvInformation: "Filtered" label — gone by default (inbox has no user-applied filter)
    Row() {
      Text($r('app.string.filtered_label'))
        .fontSize(12)
        .fontColor($r('app.color.grey600'))
        .width('100%')
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 0, bottom: 8 })
    .backgroundColor($r('app.color.background_light'))
    .visibility(Visibility.None)
  }

  @Builder
  LoadingContent() {
    Column() {
      LoadingProgress()
        .width(48)
        .height(48)
        .color($r('app.color.accent_light'))
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  EmptyContent() {
    // EmptyViewHandler (empty_view_layout.xml): icon ic_inbox 32dp, title 16sp, message 14sp
    // Centered in parent (RelativeLayout.CENTER_IN_PARENT), padding 40dp horizontal
    Column() {
      Image($r('app.media.ic_inbox'))
        .width(32)
        .height(32)
        .fillColor($r('app.color.grey600'))

      Text($r('app.string.no_inbox_head_label'))
        .fontSize(16)
        .fontColor($r('app.color.black'))
        .margin({ top: 16 })

      Text($r('app.string.home_new_empty_text'))
        .fontSize(14)
        .fontColor($r('app.color.grey600'))
        .margin({ top: 8 })
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding({ left: 40, right: 40 })
  }

  @Builder
  InboxListContent() {
    List({ space: 0 }) {
      ForEach(this.episodes, (item: FeedItem) => {
        ListItem() {
          EpisodeListItem({ item: item })
        }
      }, (item: FeedItem) => item.id.toString())
    }
    .width('100%')
    .height('100%')
    .divider({
      strokeWidth: 1,
      color: $r('app.color.light_gray'),
      startMargin: 12,
      endMargin: 12,
    })
    .scrollBar(BarState.Auto)
  }

  private buildOverflowMenu(): MenuElement[] {
    const menu: MenuElement[] = [];
    // refresh_item (showAsAction=never)
    menu.push({
      value: $r('app.string.refresh_label'),
      action: () => {
        this.viewModel.refresh();
      }
    });
    // inbox_sort
    menu.push({
      value: $r('app.string.sort'),
      action: () => {
        this.sortDialogController.open();
      }
    });
    // remove_all_inbox_item
    menu.push({
      value: $r('app.string.remove_all_inbox_label'),
      action: () => {
        // TODO: Show confirmation dialog (remove_all_inbox_confirmation_msg) with
        //   "do not ask again" checkbox before removeAllFromInbox()
        this.viewModel.removeAllFromInbox();
        this.syncFromViewModel();
      }
    });
    return menu;
  }
}
