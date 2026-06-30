import { FeedItem } from '../model/EpisodeModel';
import { QueueViewModel } from '../viewmodel/QueueViewModel';
import { QueueListItem } from '../components/QueueListItem';
import { BottomNavigation } from '../components/BottomNavigation';

@Entry
@Component
struct QueuePage {
  @State queue: FeedItem[] = [];
  @State isLoading: boolean = true;
  @State isLocked: boolean = false;
  @State isKeepSorted: boolean = false;
  @State currentTab: number = 1;
  private viewModel: QueueViewModel = new QueueViewModel();

  aboutToAppear() {
    this.viewModel.setRefreshCallback((): void => { this.syncFromViewModel(); });
    this.viewModel.onAppear();
  }

  aboutToAboutToDisappear() {
    this.viewModel.onDisappear();
  }

  private syncFromViewModel() {
    this.queue = this.viewModel.queue;
    this.isLoading = this.viewModel.isLoading;
    this.isLocked = this.viewModel.isLocked;
    this.isKeepSorted = this.viewModel.isKeepSorted;
  }

  build() {
    Column() {
      this.ToolbarBuilder()

      this.InfoBarBuilder()

      Column() {
        if (this.isLoading) {
          this.LoadingContent()
        } else if (this.queue.length === 0) {
          this.EmptyContent()
        } else {
          this.QueueListContent()
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
      Text($r('app.string.queue_label'))
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.black'))
        .layoutWeight(1)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .gesture(LongPressGesture().onAction(() => {
          // Android: toolbar long-press scrolls list to top
          console.info('TODO: Scroll queue list to top');
        }))

      // action_search (ifRoom icon)
      Image($r('app.media.ic_search'))
        .width(24)
        .height(24)
        .fillColor($r('app.color.black'))
        .margin({ right: 16 })
        .accessibilityText($r('app.string.search_label'))
        .onClick(() => {
          this.viewModel.search();
        })

      // More options overflow (refresh, lock queue, sort, clear queue)
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
  InfoBarBuilder() {
    Row() {
      Text(this.viewModel.infoBarText)
        .fontSize(12)
        .fontColor($r('app.color.grey600'))
        .width('100%')
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 0, bottom: 8 })
    .backgroundColor($r('app.color.background_light'))
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
    // EmptyViewHandler: icon ic_playlist_play, title no_items_header_label, message no_items_label
    Column() {
      Image($r('app.media.ic_playlist_play_black'))
        .width(80)
        .height(80)
        .fillColor($r('app.color.grey600'))

      Text($r('app.string.no_items_header_label'))
        .fontSize(20)
        .fontColor($r('app.color.black'))
        .margin({ top: 16 })

      Text($r('app.string.no_items_label'))
        .fontSize(14)
        .fontColor($r('app.color.grey600'))
        .margin({ top: 8 })
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .padding({ left: 32, right: 32 })
  }

  @Builder
  QueueListContent() {
    List({ space: 0 }) {
      ForEach(this.queue, (item: FeedItem, index: number) => {
        ListItem() {
          QueueListItem({
            item: item,
            canReorder: this.viewModel.canReorder(),
            dragStartHandler: (dragged: FeedItem) => {
              // TODO: Start ItemTouchHelper drag via swipeActions.startDrag
              console.info('TODO: Start drag for episode ' + dragged.id);
            }
          })
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
    menu.push({
      value: $r('app.string.refresh_label'),
      action: () => {
        this.viewModel.refresh();
      }
    });
    // queue_lock is checkable and hidden when keepSorted
    if (!this.isKeepSorted) {
      menu.push({
        value: $r('app.string.lock_queue'),
        action: () => {
          this.viewModel.toggleLock();
          this.syncFromViewModel();
        }
      });
    }
    menu.push({
      value: $r('app.string.sort'),
      action: () => {
        this.viewModel.sort();
      }
    });
    menu.push({
      value: $r('app.string.clear_queue_label'),
      action: () => {
        // TODO: Show ConfirmationDialog (clear_queue_confirmation_msg)
        this.viewModel.clearQueue();
        this.syncFromViewModel();
      }
    });
    return menu;
  }
}
