import { router, promptAction } from '@kit.ArkUI';
import { EpisodeData } from '../model/EpisodeData';
import { FeedData } from '../model/FeedData';
import { searchViewModel } from '../viewmodel/SearchViewModel';
import { EpisodeListItem } from '../components/EpisodeListItem';
import { EpisodeContextMenu } from '../components/EpisodeContextMenu';
import { MiniPlayerBar } from '../components/MiniPlayerBar';
import { BottomNav } from '../components/BottomNav';
import { playbackController, PlaybackControllerImpl } from '../common/playback/PlaybackController';
import { eventBus, AppEvent } from '../common/event/EventBus';
import { repository } from '../common/data/Repository';

@Entry
@Component
struct SearchPage {
  @State query: string = '';
  @State feedResults: FeedData[] = [];
  @State episodeResults: EpisodeData[] = [];
  @State history: string[] = [];
  @State isLoading: boolean = false;
  @State hasSearched: boolean = false;
  @State bottomTab: number = -1;
  @State contextMenuVisible: boolean = false;
  @State contextEpisode: EpisodeData = new EpisodeData('_placeholder', '');
  @State scopeFeedTitle: string = '';
  @StorageLink('playback') playbackObj: PlaybackControllerImpl = playbackController;

  private debounceId: number = -1;
  private listener: () => void = (): void => {
    if (this.query.length > 0) {
      searchViewModel.search(this.query);
    }
    this.syncFromVm();
  };

  aboutToAppear(): void {
    let scopeFeedId: string = '';
    let scopeFeedTitle: string = '';
    try {
      const params = router.getParams() as Record<string, string>;
      if (params) {
        if (params.feedId && params.feedId.length > 0) {
          scopeFeedId = params.feedId;
        }
        if (params.feedTitle && params.feedTitle.length > 0) {
          scopeFeedTitle = params.feedTitle;
        }
      }
    } catch (e) {
      // no params
    }
    if (scopeFeedId.length > 0 && scopeFeedTitle.length === 0) {
      const feed = repository.queryFeeds().find((f: FeedData): boolean => f.id === scopeFeedId);
      scopeFeedTitle = feed ? feed.title : '';
    }
    searchViewModel.setScope(scopeFeedId, scopeFeedTitle);
    this.scopeFeedTitle = scopeFeedTitle;
    this.syncFromVm();
    eventBus.on(AppEvent.EPISODES_CHANGED, this.listener);
    eventBus.on(AppEvent.FEEDS_CHANGED, this.listener);
  }

  aboutToDisappear(): void {
    eventBus.off(AppEvent.EPISODES_CHANGED, this.listener);
    eventBus.off(AppEvent.FEEDS_CHANGED, this.listener);
  }

  private syncFromVm(): void {
    this.query = searchViewModel.query;
    this.feedResults = searchViewModel.feedResults.slice();
    this.episodeResults = searchViewModel.episodeResults.slice();
    this.history = searchViewModel.history.slice();
    this.isLoading = searchViewModel.isLoading;
    this.hasSearched = searchViewModel.hasSearched;
  }

  private onQueryChange(value: string): void {
    this.query = value;
    searchViewModel.query = value;
    if (value.length === 0) {
      clearTimeout(this.debounceId);
      searchViewModel.search('');
      this.syncFromVm();
      return;
    }
    this.isLoading = true;
    searchViewModel.setLoading(true);
    clearTimeout(this.debounceId);
    this.debounceId = setTimeout(() => {
      searchViewModel.search(value);
      this.syncFromVm();
    }, 350);
  }

  private onSubmit(): void {
    clearTimeout(this.debounceId);
    searchViewModel.addToHistory(this.query);
    searchViewModel.search(this.query);
    this.syncFromVm();
  }

  private clearQuery(): void {
    clearTimeout(this.debounceId);
    searchViewModel.search('');
    this.syncFromVm();
  }

  private pickHistory(entry: string): void {
    this.onQueryChange(entry);
  }

  private removeHistory(entry: string): void {
    searchViewModel.removeHistory(entry);
    this.syncFromVm();
  }

  private clearHistory(): void {
    searchViewModel.clearHistory();
    this.syncFromVm();
  }

  private openFeedDetail(feed: FeedData): void {
    router.pushUrl({ url: 'pages/FeedDetailPage', params: { feedId: feed.id } });
  }

  private openEpisodeDetail(episode: EpisodeData): void {
    router.pushUrl({
      url: 'pages/EpisodeDetailPage',
      params: { episodeId: episode.id, episodeTitle: episode.title }
    });
  }

  private openEpisodeContextMenu(episode: EpisodeData): void {
    this.contextEpisode = episode;
    this.contextMenuVisible = true;
  }

  private searchOnline(): void {
    try {
      promptAction.showToast({ message: 'Online provider search is not available in this build' });
    } catch (e) {
      // ignore
    }
  }

  private get hasAnyResult(): boolean {
    return this.feedResults.length > 0 || this.episodeResults.length > 0;
  }

  build() {
    Stack() {
      Column() {
        Row() {
          Image($r('app.media.ic_arrow_right_white'))
            .width(24)
            .height(24)
            .margin({ left: 12, right: 8 })
            .fillColor($r('app.color.black'))
            .rotate({ angle: 180 })
            .onClick(() => router.back())
            .accessibilityText($r('app.string.toolbar_back_button_content_description'))

          TextInput({ text: this.query, placeholder: $r('app.string.search_label') })
            .type(InputType.Normal)
            .layoutWeight(1)
            .fontSize(16)
            .fontColor($r('app.color.black'))
            .placeholderColor($r('app.color.grey600'))
            .backgroundColor(Color.Transparent)
            .height(40)
            .onChange((value: string) => this.onQueryChange(value))
            .onSubmit(() => this.onSubmit())
            .accessibilityText($r('app.string.search_label'))

          if (this.query.length > 0) {
            Image($r('app.media.ic_close'))
              .width(24)
              .height(24)
              .margin({ right: 12 })
              .fillColor($r('app.color.grey600'))
              .onClick(() => this.clearQuery())
              .accessibilityText('Clear query')
          }
        }
        .width('100%')
        .height(56)
        .alignItems(VerticalAlign.Center)
        .backgroundColor($r('app.color.background_light'))

        if (this.scopeFeedTitle.length > 0) {
          Row() {
            Image($r('app.media.ic_subscriptions'))
              .width(16)
              .height(16)
              .margin({ left: 16, right: 6 })
              .fillColor($r('app.color.accent_light'))
            Text(this.scopeFeedTitle)
              .fontSize(13)
              .fontColor($r('app.color.accent_light'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .layoutWeight(1)
          }
          .width('100%')
          .height(32)
          .alignItems(VerticalAlign.Center)
          .backgroundColor($r('app.color.background_light'))
        }

        if (this.query.length === 0) {
          this.EmptyStateView()
        } else if (this.isLoading) {
          Column() {
            Progress({ value: 0, total: 100, type: ProgressType.Eclipse })
              .width(40)
              .height(40)
              .color($r('app.color.accent_light'))
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor($r('app.color.background_light'))
        } else if (!this.hasAnyResult) {
          Column() {
            Image($r('app.media.ic_search'))
              .width(72)
              .height(72)
              .fillColor($r('app.color.grey600'))
              .margin({ bottom: 12 })
            Text($r('app.string.no_results_for_query', this.query))
              .fontSize(14)
              .fontColor($r('app.color.grey600'))
              .textAlign(TextAlign.Center)
              .padding({ left: 32, right: 32 })
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor($r('app.color.background_light'))
        } else {
          if (this.feedResults.length > 0) {
            this.FeedResultsRow()
          }
          List({ space: 0 }) {
            ForEach(this.episodeResults, (episode: EpisodeData) => {
              ListItem() {
                EpisodeListItem({
                  episode: episode,
                  showDragHandle: false,
                  onItemClick: (ep: EpisodeData) => {
                    this.openEpisodeDetail(ep);
                  },
                  onSecondaryAction: (ep: EpisodeData) => {
                    searchViewModel.toggleSecondaryAction(ep);
                  },
                  onLongPress: (ep: EpisodeData) => {
                    this.openEpisodeContextMenu(ep);
                  }
                })
              }
            }, (episode: EpisodeData) => episode.id)
          }
          .width('100%')
          .layoutWeight(1)
          .divider({ strokeWidth: 1, color: $r('app.color.grey100'), startMargin: 88, endMargin: 16 })
          .padding({ left: 12, right: 0, top: 8 })
          .backgroundColor($r('app.color.background_light'))
          .scrollBar(BarState.Auto)
        }

        MiniPlayerBar({
          title: this.playbackObj.hasEpisode ? this.playbackObj.title : '',
          author: this.playbackObj.hasEpisode ? this.playbackObj.author : '',
          cover: this.playbackObj.hasEpisode ? this.playbackObj.cover : $r('app.media.ic_feed'),
          progress: this.playbackObj.progressPct,
          isPlaying: this.playbackObj.isPlaying,
          onPlayClick: () => {
            this.playbackObj.togglePlay();
          },
          onBarClick: () => {
            if (this.playbackObj.hasEpisode) {
              router.pushUrl({
                url: 'pages/AudioPlayerPage',
                params: { episodeId: this.playbackObj.currentEpisodeId, episodeTitle: this.playbackObj.title }
              });
            }
          }
        })

        BottomNav({
          currentIndex: this.bottomTab,
          onTabSelected: (index: number) => {
            this.bottomTab = index;
            router.back();
          }
        })
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.background_light'))

      EpisodeContextMenu({
        visible: this.contextMenuVisible,
        episode: this.contextEpisode,
        onSelect: (id: string) => {
          this.contextMenuVisible = false;
          switch (id) {
            case 'mark_read':
            case 'mark_unread':
              searchViewModel.togglePlayed(this.contextEpisode);
              break;
            case 'add_to_queue':
            case 'remove_from_queue':
              searchViewModel.toggleQueue(this.contextEpisode);
              break;
            case 'add_to_favorites':
            case 'remove_from_favorites':
              searchViewModel.toggleFavorite(this.contextEpisode);
              break;
            case 'reset_position':
              searchViewModel.resetPosition(this.contextEpisode);
              break;
            case 'delete':
              searchViewModel.deleteEpisode(this.contextEpisode);
              break;
            case 'share':
              try { promptAction.showToast({ message: 'Sharing not available in this build' }); } catch (e) { }
              break;
            case 'open_podcast':
              this.contextMenuVisible = false;
              router.pushUrl({
                url: 'pages/FeedDetailPage',
                params: { feedId: 'feed_morbid' }
              });
              break;
            default:
              
          }
          this.syncFromVm();
        },
        onDismiss: () => {
          this.contextMenuVisible = false;
        }
      })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  EmptyStateView() {
    Scroll() {
      Column() {
        Image($r('app.media.ic_search'))
          .width(72)
          .height(72)
          .fillColor($r('app.color.grey600'))
          .margin({ top: 80, bottom: 12 })
        Text($r('app.string.type_to_search'))
          .fontSize(18)
          .fontColor($r('app.color.black'))
          .margin({ bottom: 24 })

        if (this.history.length > 0) {
          Row() {
            Text('Recent searches')
              .fontSize(14)
              .fontColor($r('app.color.grey600'))
              .layoutWeight(1)
            Button() {
              Text('Clear')
                .fontSize(14)
                .fontColor($r('app.color.grey600'))
            }
            .type(ButtonType.Normal)
            .backgroundColor(Color.Transparent)
            .height(36)
            .onClick(() => this.clearHistory())
            .accessibilityText('Clear search history')
          }
          .width('100%')
          .padding({ left: 16, right: 16, bottom: 8 })
          .alignItems(VerticalAlign.Center)

          Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
            ForEach(this.history, (entry: string) => {
              Row() {
                Text(entry)
                  .fontSize(14)
                  .fontColor($r('app.color.black'))
                  .margin({ left: 12, right: 4 })
                Image($r('app.media.ic_close'))
                  .width(16)
                  .height(16)
                  .margin({ right: 8 })
                  .fillColor($r('app.color.grey600'))
                  .onClick(() => this.removeHistory(entry))
              }
              .height(36)
              .margin({ right: 8, bottom: 8 })
              .border({ width: 1, color: $r('app.color.grey100'), radius: 18 })
              .alignItems(VerticalAlign.Center)
              .onClick(() => this.pickHistory(entry))
              .accessibilityText(entry)
            }, (entry: string) => entry)
          }
          .width('100%')
          .padding({ left: 16, right: 16 })
        }
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .layoutWeight(1)
    .align(Alignment.Top)
    .scrollBar(BarState.Auto)
    .backgroundColor($r('app.color.background_light'))
  }

  @Builder
  FeedResultsRow() {
    Column() {
      Row() {
        Text($r('app.string.subscriptions_label'))
          .fontSize(14)
          .fontColor($r('app.color.grey600'))
          .layoutWeight(1)
        Button() {
          Row() {
            Image($r('app.media.ic_search'))
              .width(16)
              .height(16)
              .margin({ right: 6 })
              .fillColor($r('app.color.accent_light'))
            Text($r('app.string.search_online'))
              .fontSize(14)
              .fontColor($r('app.color.accent_light'))
          }
          .alignItems(VerticalAlign.Center)
        }
        .type(ButtonType.Normal)
        .backgroundColor(Color.Transparent)
        .height(36)
        .onClick(() => this.searchOnline())
        .accessibilityText($r('app.string.search_online'))
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 8 })
      .alignItems(VerticalAlign.Center)

      Scroll() {
        Row() {
          ForEach(this.feedResults, (feed: FeedData) => {
            Stack({ alignContent: Alignment.BottomEnd }) {
              Image(feed.cover)
                .width(96)
                .height(96)
                .borderRadius(8)
                .backgroundColor($r('app.color.non_square_icon_background'))
                .objectFit(ImageFit.Cover)
            }
            .width(96)
            .height(96)
            .margin({ right: 12 })
            .onClick(() => this.openFeedDetail(feed))
            .accessibilityText(feed.title)
          }, (feed: FeedData) => feed.id)
        }
        .padding({ left: 16, right: 16, bottom: 12 })
      }
      .width('100%')
      .height(120)
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .align(Alignment.Start)
    }
    .width('100%')
  }
}

export default SearchPage;
