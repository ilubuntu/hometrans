import { router, promptAction } from '@kit.ArkUI';
import { EpisodeData } from '../model/EpisodeData';
import { FeedData } from '../model/FeedData';
import { feedDetailViewModel } from '../viewmodel/FeedDetailViewModel';
import { OverflowMenuOption } from '../model/HomeSection';
import { AppToolbar } from '../components/AppToolbar';
import { OverflowMenu } from '../components/OverflowMenu';
import { EpisodesFilterDialog } from '../components/EpisodesFilterDialog';
import { EpisodeListItem } from '../components/EpisodeListItem';
import { EpisodeContextMenu } from '../components/EpisodeContextMenu';
import { MiniPlayerBar } from '../components/MiniPlayerBar';
import { BottomNav } from '../components/BottomNav';
import { serviceLocator } from '../common/service/ServiceLocator';

@Component
struct FeedHeaderView {
  @ObjectLink feed: FeedData;
  @Prop episodeCount: number = 0;
  @Prop descExpanded: boolean = false;
  onSubscribe: () => void = () => {};
  onShowInfo: () => void = () => {};
  onFilter: () => void = () => {};
  onShowSettings: () => void = () => {};
  onToggleDescription: () => void = () => {};
  onCopyTitle: () => void = () => {};

  build() {
    Column() {
      Stack({ alignContent: Alignment.Bottom }) {
        Image(this.feed.cover)
          .width('100%')
          .height(156)
          .objectFit(ImageFit.Cover)
          .opacity(0.55)
        Column()
          .width('100%')
          .height(156)
          .backgroundColor($r('app.color.image_readability_tint'))

        Row() {
          Image(this.feed.cover)
            .width(124)
            .height(124)
            .borderRadius(16)
            .backgroundColor($r('app.color.non_square_icon_background'))
            .objectFit(ImageFit.Cover)
            .margin({ left: 16, right: 16, bottom: 24 })

          Column() {
            Text(this.feed.title)
              .fontSize(22)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.white'))
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .width('100%')
              .gesture(LongPressGesture().onAction(() => this.onCopyTitle()))
            Text(this.feed.author)
              .fontSize(14)
              .fontColor($r('app.color.white'))
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .width('100%')
              .margin({ top: 4 })
              .gesture(LongPressGesture().onAction(() => this.onCopyTitle()))
          }
          .layoutWeight(1)
          .margin({ right: 16, bottom: 16 })
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .alignItems(VerticalAlign.Bottom)

        Row() {
          Row().width(148).height('100%')

          if (!this.feed.subscribed) {
            Button($r('app.string.subscribe_label'))
              .type(ButtonType.Capsule)
              .backgroundColor($r('app.color.accent_light'))
              .fontColor($r('app.color.white'))
              .fontSize(14)
              .height(40)
              .margin({ top: 4, bottom: 4 })
              .onClick(() => this.onSubscribe())
          } else {
            Button() {
              Image($r('app.media.ic_info_white'))
                .width(24)
                .height(24)
                .fillColor($r('app.color.white'))
            }
            .type(ButtonType.Normal)
            .backgroundColor(Color.Transparent)
            .width(48)
            .height(48)
            .margin({ left: -4 })
            .onClick(() => this.onShowInfo())
            .accessibilityText($r('app.string.show_info_label'))

            Button() {
              Image($r('app.media.ic_filter_white'))
                .width(24)
                .height(24)
                .fillColor($r('app.color.white'))
            }
            .type(ButtonType.Normal)
            .backgroundColor(Color.Transparent)
            .width(48)
            .height(48)
            .onClick(() => this.onFilter())
            .accessibilityText($r('app.string.filter'))

            Button() {
              Image($r('app.media.ic_settings_white'))
                .width(24)
                .height(24)
                .fillColor($r('app.color.white'))
            }
            .type(ButtonType.Normal)
            .backgroundColor(Color.Transparent)
            .width(48)
            .height(48)
            .onClick(() => this.onShowSettings())
            .accessibilityText($r('app.string.show_feed_settings_label'))
          }
        }
        .width('100%')
        .height(48)
        .backgroundColor($r('app.color.image_readability_tint'))
        .alignItems(VerticalAlign.Center)
      }
      .width('100%')
      .height(156)

      if (this.feed.hasUpdateFailed) {
        Text($r('app.string.refresh_failed_msg'))
          .width('100%')
          .fontSize(14)
          .fontColor($r('app.color.accent_light'))
          .padding({ left: 16, right: 16, top: 8, bottom: 8 })
          .backgroundColor($r('app.color.background_light'))
          .onClick(() => {
            // Refresh failure details dialog deferred (E-group)
          })
      }

      if (this.feed.subscribed && this.feed.description.length > 0) {
        Column() {
          Text($r('app.string.description_label'))
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.black'))
            .margin({ bottom: 4 })
          Text(this.feed.description)
            .fontSize(14)
            .fontColor($r('app.color.grey600'))
            .lineHeight(20)
            .maxLines(this.descExpanded ? 100 : 3)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('100%')
            .backgroundColor($r('app.color.background_light'))
            .onClick(() => this.onToggleDescription())
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding({ left: 16, right: 16, top: 16, bottom: 16 })
        .backgroundColor($r('app.color.background_light'))
      } else if (!this.feed.subscribed) {
        Text($r('app.string.state_deleted_not_subscribed'))
          .fontSize(14)
          .fontColor($r('app.color.accent_light'))
          .width('100%')
          .padding({ left: 16, right: 16, top: 8, bottom: 8 })
          .backgroundColor($r('app.color.background_light'))
      }
    }
    .width('100%')
    .backgroundColor($r('app.color.background_light'))
  }
}

@Entry
@Component
struct FeedDetailPage {
  @State feed: FeedData = new FeedData('', '', 0, $r('app.media.ic_feed'));
  @State episodes: EpisodeData[] = [];
  @State filterValues: string[] = [];
  @State hasActiveFilter: boolean = false;
  @State overflowVisible: boolean = false;
  @State filterDialogVisible: boolean = false;
  @State refreshing: boolean = false;
  @State descExpanded: boolean = false;
  @State bottomTab: number = -1;
  @State contextMenuVisible: boolean = false;
  @State contextEpisode: EpisodeData = new EpisodeData('_placeholder', '');

  private feedMenu: OverflowMenuOption[] = [
    { id: 'sort', label: $r('app.string.sort'), enabled: true },
    { id: 'refresh', label: $r('app.string.refresh_label'), enabled: true },
    { id: 'load_complete', label: $r('app.string.load_complete_feed'), enabled: true },
    { id: 'visit_website', label: $r('app.string.visit_website_label'), enabled: true },
    { id: 'share', label: $r('app.string.share_label'), enabled: true },
    { id: 'remove_all_inbox', label: $r('app.string.remove_all_inbox_label'), enabled: true },
    { id: 'edit_tags', label: $r('app.string.edit_tags'), enabled: true },
    { id: 'unsubscribe', label: $r('app.string.remove_archive_feed_label'), enabled: true }
  ];

  aboutToAppear(): void {
    let feedId = 'feed_morbid';
    try {
      const params = router.getParams() as Record<string, string>;
      if (params && params.feedId && params.feedId.length > 0) {
        feedId = params.feedId;
      }
    } catch (e) {
      console.info(`FeedDetailPage: fallback to default feed (${e})`);
    }
    feedDetailViewModel.loadById(feedId);
    this.syncFromVm();
  }

  private syncFromVm(): void {
    this.feed = feedDetailViewModel.feed;
    this.episodes = feedDetailViewModel.episodes;
    this.filterValues = feedDetailViewModel.filterValues;
    this.hasActiveFilter = feedDetailViewModel.hasActiveFilter();
  }

  private handleOverflowSelect(id: string): void {
    this.overflowVisible = false;
    switch (id) {
      case 'sort': {
        const next = feedDetailViewModel.sortOrder === 'date_desc' ? 'date_asc' : 'date_desc';
        feedDetailViewModel.setSortOrder(next);
        this.syncFromVm();
        break;
      }
      case 'refresh':
        this.refreshing = true;
        setTimeout(() => {
          feedDetailViewModel.loadById(this.feed.id);
          this.syncFromVm();
          this.refreshing = false;
        }, 600);
        break;
      case 'remove_all_inbox':
        feedDetailViewModel.removeAllFromInbox();
        this.syncFromVm();
        break;
      case 'edit_tags':
        feedDetailViewModel.setFeedTags(feedDetailViewModel.feedTags());
        this.syncFromVm();
        break;
      case 'unsubscribe':
        feedDetailViewModel.toggleSubscribe();
        router.back();
        break;
      case 'share':
        try {
          promptAction.showToast({ message: 'Sharing not available in this build' });
        } catch (e) {
          // ignore
        }
        break;
      case 'visit_website':
        try {
          promptAction.showToast({ message: this.feed.feedUrl });
        } catch (e) {
          // ignore
        }
        break;
      case 'load_complete':
        feedDetailViewModel.refresh().then((): void => this.syncFromVm());
        break;
      default:
        break;
    }
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

  private openFeedInfo(): void {
    try {
      promptAction.showToast({ message: `Feed info: ${this.feed.title}` });
    } catch (e) {
      // ignore
    }
  }

  private openFeedSettings(): void {
    try {
      promptAction.showToast({ message: `Feed settings: ${this.feed.title}` });
    } catch (e) {
      // ignore
    }
  }

  build() {
    Stack() {
      Column() {
        AppToolbar({
          title: this.feed.title,
          showBack: true,
          showSearch: true,
          showFilter: false,
          showOverflow: true,
          onBack: () => {
            router.back();
          },
          onSearch: () => {
            router.pushUrl({ url: 'pages/SearchPage' });
          },
          onMore: () => {
            this.overflowVisible = !this.overflowVisible;
          }
        })

        if (this.hasActiveFilter) {
          Text($r('app.string.filtered_label'))
            .width('100%')
            .fontSize(12)
            .fontColor($r('app.color.grey600'))
            .padding({ left: 16, right: 16, top: 4, bottom: 4 })
            .backgroundColor($r('app.color.background_light'))
            .onClick(() => {
              this.filterDialogVisible = true;
            })
        }

        if (this.episodes.length === 0 && !this.feed.subscribed) {
          List({ space: 0 }) {
            ListItem() {
              FeedHeaderView({
                feed: this.feed,
                episodeCount: this.episodes.length,
                descExpanded: this.descExpanded,
                onSubscribe: () => {
                  feedDetailViewModel.toggleSubscribe();
                  this.syncFromVm();
                },
                onShowInfo: () => this.openFeedInfo(),
                onFilter: () => {
                  this.filterDialogVisible = true;
                },
                onShowSettings: () => this.openFeedSettings(),
                onToggleDescription: () => {
                  this.descExpanded = !this.descExpanded;
                },
                onCopyTitle: () => {
                  try { promptAction.showToast({ message: this.feed.title }); } catch (e) { }
                }
              })
            }
            ListItem() {
              Column() {
                Text(this.hasActiveFilter
                  ? $r('app.string.no_all_episodes_filtered_label')
                  : $r('app.string.no_all_episodes_label'))
                  .fontSize(14)
                  .fontColor($r('app.color.grey600'))
                  .textAlign(TextAlign.Center)
                  .padding({ left: 32, right: 32, top: 48, bottom: 48 })
              }
              .width('100%')
            }
          }
          .width('100%')
          .layoutWeight(1)
          .backgroundColor($r('app.color.background_light'))
        } else {
          List({ space: 0 }) {
            ListItem() {
              FeedHeaderView({
                feed: this.feed,
                episodeCount: this.episodes.length,
                descExpanded: this.descExpanded,
                onSubscribe: () => {
                  feedDetailViewModel.toggleSubscribe();
                  this.syncFromVm();
                },
                onShowInfo: () => this.openFeedInfo(),
                onFilter: () => {
                  this.filterDialogVisible = true;
                },
                onShowSettings: () => this.openFeedSettings(),
                onToggleDescription: () => {
                  this.descExpanded = !this.descExpanded;
                },
                onCopyTitle: () => {
                  try { promptAction.showToast({ message: this.feed.title }); } catch (e) { }
                }
              })
            }

            ForEach(this.episodes, (episode: EpisodeData) => {
              ListItem() {
                EpisodeListItem({
                  episode: episode,
                  showDragHandle: false,
                  onItemClick: (ep: EpisodeData) => {
                    this.openEpisodeDetail(ep);
                  },
                  onSecondaryAction: (ep: EpisodeData) => {
                    feedDetailViewModel.toggleSecondaryAction(ep);
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
          .padding({ left: 12, right: 0 })
          .backgroundColor($r('app.color.background_light'))
        }

        MiniPlayerBar({
          title: 'Listener Tales 111: Camping Tales',
          author: this.feed.author,
          cover: this.feed.cover,
          progress: 47,
          isPlaying: true,
          onPlayClick: () => {
            serviceLocator.playbackService().toggle();
          },
          onBarClick: () => {
            router.pushUrl({
              url: 'pages/AudioPlayerPage',
              params: { episodeId: 'feed_morbid_ep2', episodeTitle: 'Listener Tales 111: Camping Tales' }
            });
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

      if (this.refreshing) {
        Column() {
          Progress({ value: 0, total: 100, type: ProgressType.Eclipse })
            .width(40)
            .height(40)
            .color($r('app.color.accent_light'))
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor($r('app.color.image_readability_tint'))
      }

      OverflowMenu({
        visible: this.overflowVisible,
        items: this.feedMenu,
        onSelect: (id: string) => this.handleOverflowSelect(id),
        onDismiss: () => {
          this.overflowVisible = false;
        }
      })

      EpisodesFilterDialog({
        visible: this.filterDialogVisible,
        selected: this.filterValues,
        onConfirm: (values: string[]) => {
          this.filterDialogVisible = false;
          feedDetailViewModel.applyFilter(values);
          this.syncFromVm();
        },
        onReset: () => {
          feedDetailViewModel.resetFilter();
          this.syncFromVm();
        },
        onDismiss: () => {
          this.filterDialogVisible = false;
        }
      })

      EpisodeContextMenu({
        visible: this.contextMenuVisible,
        episode: this.contextEpisode,
        onSelect: (id: string) => {
          this.contextMenuVisible = false;
          switch (id) {
            case 'mark_read':
            case 'mark_unread':
              feedDetailViewModel.togglePlayed(this.contextEpisode);
              break;
            case 'add_to_queue':
            case 'remove_from_queue':
              feedDetailViewModel.toggleQueue(this.contextEpisode);
              break;
            case 'add_to_favorites':
            case 'remove_from_favorites':
              feedDetailViewModel.toggleFavorite(this.contextEpisode);
              break;
            case 'remove_inbox':
              feedDetailViewModel.markPlayed(this.contextEpisode);
              break;
            case 'reset_position':
              feedDetailViewModel.resetPosition(this.contextEpisode);
              break;
            case 'delete':
              feedDetailViewModel.deleteEpisode(this.contextEpisode);
              break;
            case 'share':
              try { promptAction.showToast({ message: 'Sharing not available in this build' }); } catch (e) { }
              break;
            case 'open_podcast':
              this.contextMenuVisible = false;
              router.pushUrl({
                url: 'pages/FeedDetailPage',
                params: { feedId: this.feed.id }
              });
              break;
            case 'multi_select':
              
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
}

export default FeedDetailPage;
