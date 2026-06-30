import { Feed } from '../model/EpisodeModel';
import { SubscriptionsViewModel } from '../viewmodel/SubscriptionsViewModel';
import { SubscriptionGridItem } from '../components/SubscriptionGridItem';
import { BottomNavigation } from '../components/BottomNavigation';

@Entry
@Component
struct SubscriptionsPage {
  @State feeds: Feed[] = [];
  @State isLoading: boolean = true;
  @State currentTab: number = 3;
  @State columnCount: number = 3;
  @State showSubscriptionTitle: boolean = true;
  @State selectMode: boolean = false;
  @State selectedIds: Set<number> = new Set<number>();
  private viewModel: SubscriptionsViewModel = new SubscriptionsViewModel();
  private gridScroller: Scroller = new Scroller();

  aboutToAppear() {
    this.viewModel.setRefreshCallback((): void => { this.syncFromViewModel(); });
    this.viewModel.onAppear();
  }

  aboutToAboutToDisappear() {
    this.viewModel.onDisappear();
  }

  private syncFromViewModel(): void {
    this.feeds = this.viewModel.feeds;
    this.isLoading = this.viewModel.isLoading;
    this.columnCount = this.viewModel.columnCount;
    this.showSubscriptionTitle = this.viewModel.showSubscriptionTitle;
  }

  private getColumnsTemplate(): string {
    const cols: string[] = [];
    for (let i = 0; i < this.columnCount; i++) {
      cols.push('1fr');
    }
    return cols.join(' ');
  }

  private getCounter(feedId: number): number {
    return this.viewModel.getCounter(feedId);
  }

  private isFeedSelected(feedId: number): boolean {
    return this.selectedIds.has(feedId);
  }

  private toggleFeedSelection(feedId: number): void {
    const next = new Set<number>(this.selectedIds);
    if (next.has(feedId)) {
      next.delete(feedId);
    } else {
      next.add(feedId);
    }
    this.selectedIds = next;
    if (this.selectedIds.size === 0) {
      this.endSelectMode();
    }
  }

  private startSelectMode(feedId: number): void {
    this.selectMode = true;
    const next = new Set<number>();
    next.add(feedId);
    this.selectedIds = next;
  }

  private endSelectMode(): void {
    this.selectMode = false;
    this.selectedIds = new Set<number>();
  }

  private setColumnCount(columns: number): void {
    this.viewModel.setColumnCount(columns);
    this.columnCount = this.viewModel.columnCount;
  }

  private toggleShowTitle(): void {
    this.viewModel.setShowSubscriptionTitle(!this.viewModel.showSubscriptionTitle);
    this.showSubscriptionTitle = this.viewModel.showSubscriptionTitle;
  }

  build() {
    Column() {
      this.ToolbarBuilder()

      this.FilteredBarBuilder()

      Stack({ alignContent: Alignment.BottomEnd }) {
        Column() {
          if (this.isLoading) {
            this.LoadingContent()
          } else if (this.feeds.length === 0) {
            this.EmptyContent()
          } else {
            this.GridContent()
          }
        }
        .layoutWeight(1)
        .width('100%')
        .backgroundColor($r('app.color.background_light'))

        if (!this.selectMode) {
          this.FabButton()
        }
      }
      .layoutWeight(1)
      .width('100%')

      BottomNavigation({ currentTab: $currentTab })
    }
    .height('100%')
    .backgroundColor($r('app.color.background_light'))
  }

  @Builder
  ToolbarBuilder() {
    Row() {
      Text($r('app.string.subscriptions_label'))
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.black'))
        .layoutWeight(1)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .gesture(LongPressGesture().onAction(() => {
          // Android: toolbar long-press scrolls to position 5 then smooth-scrolls to 0
          this.gridScroller.scrollToIndex(0);
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

      // More options overflow
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
  FilteredBarBuilder() {
    // feeds_filtered_message: "Filtered" — gone by default (no user-applied filter)
    Row() {
      Text($r('app.string.filtered_label'))
        .fontSize(14)
        .fontColor($r('app.color.grey600'))
        .width('100%')
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 4, bottom: 4 })
    .backgroundColor($r('app.color.background_light'))
    .visibility(Visibility.None)
    .onClick(() => {
      this.viewModel.openFilterDialog();
    })
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
    // EmptyViewHandler: icon ic_subscriptions, title, message, centered
    Column() {
      Image($r('app.media.ic_subscriptions_black'))
        .width(32)
        .height(32)
        .fillColor($r('app.color.grey600'))

      Text($r('app.string.no_subscriptions_head_label'))
        .fontSize(16)
        .fontColor($r('app.color.black'))
        .margin({ top: 16 })

      Text($r('app.string.no_subscriptions_label'))
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
  GridContent() {
    // subscriptions_grid RecyclerView with GridLayoutManager
    Grid({ scroller: this.gridScroller }) {
      ForEach(this.feeds, (feed: Feed) => {
        GridItem() {
          SubscriptionGridItem({
            feed: feed,
            counter: this.getCounter(feed.id),
            showTitle: this.showSubscriptionTitle,
            columnCount: this.columnCount,
            isSelected: this.isFeedSelected(feed.id),
            selectMode: this.selectMode
          })
        }
        .onClick(() => {
          if (this.selectMode) {
            this.toggleFeedSelection(feed.id);
          } else {
            this.viewModel.openPodcastDetail(feed.id);
          }
        })
        .gesture(LongPressGesture().onAction(() => {
          if (!this.selectMode) {
            this.startSelectMode(feed.id);
          }
        }))
      }, (feed: Feed) => feed.id.toString())
    }
    .columnsTemplate(this.getColumnsTemplate())
    .columnsGap(8)
    .rowsGap(8)
    .padding({ left: 4, right: 4, top: 4, bottom: 88 })
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Auto)
  }

  @Builder
  FabButton() {
    // subscriptions_add FloatingActionButton (56dp, bottom|end, ic_add)
    Stack() {
      Image($r('app.media.ic_add'))
        .width(24)
        .height(24)
        .fillColor($r('app.color.white'))
    }
    .width(56)
    .height(56)
    .borderRadius(28)
    .backgroundColor($r('app.color.accent_light'))
    .shadow({ radius: 4, color: '#66000000', offsetX: 0, offsetY: 2 })
    .margin({ bottom: 16, right: 16 })
    .accessibilityText($r('app.string.add_feed_label'))
    .onClick(() => {
      this.viewModel.openAddPodcast();
    })
  }

  private buildOverflowMenu(): MenuElement[] {
    const menu: MenuElement[] = [];
    // refresh_item
    menu.push({
      value: $r('app.string.refresh_label'),
      action: () => {
        this.viewModel.refresh();
      }
    });
    // subscriptions_filter
    menu.push({
      value: $r('app.string.filter'),
      action: () => {
        this.viewModel.openFilterDialog();
      }
    });
    // subscriptions_sort
    menu.push({
      value: $r('app.string.sort'),
      action: () => {
        this.viewModel.openSortDialog();
      }
    });
    // subscriptions_counter
    menu.push({
      value: $r('app.string.pref_nav_drawer_feed_counter_title'),
      action: () => {
        this.viewModel.openCounterDialog();
      }
    });
    // subscription_num_columns (submenu)
    menu.push({
      value: $r('app.string.subscription_num_columns'),
      action: () => {
        this.showColumnPicker();
      }
    });
    // pref_show_subscription_title (checkable)
    menu.push({
      value: $r('app.string.pref_show_subscription_title'),
      action: () => {
        this.toggleShowTitle();
      }
    });
    // show_archive
    menu.push({
      value: $r('app.string.archive_feed_label_noun'),
      action: () => {
        this.viewModel.openArchive();
      }
    });
    return menu;
  }

  private showColumnPicker(): void {
    ActionSheet.show({
      title: $r('app.string.subscription_num_columns'),
      sheets: [
        { title: $r('app.string.subscription_display_list'), action: () => this.setColumnCount(1) },
        { title: '2', action: () => this.setColumnCount(2) },
        { title: '3', action: () => this.setColumnCount(3) },
        { title: '4', action: () => this.setColumnCount(4) },
        { title: '5', action: () => this.setColumnCount(5) }
      ]
    });
  }
}
