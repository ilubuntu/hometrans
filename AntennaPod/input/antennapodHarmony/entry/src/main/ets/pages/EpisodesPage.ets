import { router, promptAction } from '@kit.ArkUI';
import { EpisodeData } from '../model/EpisodeData';
import { episodesViewModel } from '../viewmodel/EpisodesViewModel';
import { OverflowMenuOption } from '../model/HomeSection';
import { AppToolbar } from '../components/AppToolbar';
import { OverflowMenu } from '../components/OverflowMenu';
import { EpisodesFilterDialog } from '../components/EpisodesFilterDialog';
import { EpisodeListItem } from '../components/EpisodeListItem';
import { EpisodeContextMenu } from '../components/EpisodeContextMenu';
import { MiniPlayerBar } from '../components/MiniPlayerBar';
import { BottomNav } from '../components/BottomNav';
import { serviceLocator } from '../common/service/ServiceLocator';
import { playbackController, PlaybackControllerImpl } from '../common/playback/PlaybackController';

@Entry
@Component
struct EpisodesPage {
  @State episodes: EpisodeData[] = [];
  @State filterValues: string[] = [];
  @State hasActiveFilter: boolean = false;
  @State overflowVisible: boolean = false;
  @State filterDialogVisible: boolean = false;
  @State refreshing: boolean = false;
  @State bottomTab: number = -1;
  @State contextMenuVisible: boolean = false;
  @State contextEpisode: EpisodeData = new EpisodeData('_placeholder', '');

  private episodesMenu: OverflowMenuOption[] = [
    { id: 'episodes_sort', label: $r('app.string.sort'), enabled: true },
    { id: 'refresh', label: $r('app.string.refresh_label'), enabled: true }
  ];

  aboutToAppear(): void {
    episodesViewModel.load();
    this.syncFromVm();
  }

  private syncFromVm(): void {
    this.episodes = episodesViewModel.episodes;
    this.filterValues = episodesViewModel.filterValues;
    this.hasActiveFilter = episodesViewModel.hasActiveFilter();
  }

  private handleOverflowSelect(id: string): void {
    this.overflowVisible = false;
    if (id === 'refresh') {
      this.refreshing = true;
      setTimeout(() => {
        episodesViewModel.load();
        this.syncFromVm();
        this.refreshing = false;
      }, 600);
    } else if (id === 'episodes_sort') {
      const next = episodesViewModel.sortOrder === 'date_desc' ? 'date_asc' : 'date_desc';
      episodesViewModel.setSortOrder(next);
      this.syncFromVm();
    } else {
      
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

  build() {
    Stack() {
      Column() {
        AppToolbar({
          title: $r('app.string.episodes_label'),
          showBack: true,
          showSearch: true,
          showFilter: true,
          showOverflow: true,
          onBack: () => {
            router.back();
          },
          onSearch: () => {
            router.pushUrl({ url: 'pages/SearchPage' });
          },
          onFilter: () => {
            this.filterDialogVisible = true;
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

        if (this.episodes.length === 0) {
          Column() {
            Text(this.hasActiveFilter
              ? $r('app.string.no_all_episodes_filtered_label')
              : $r('app.string.no_all_episodes_label'))
              .fontSize(14)
              .fontColor($r('app.color.grey600'))
              .textAlign(TextAlign.Center)
              .padding({ left: 32, right: 32 })
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .backgroundColor($r('app.color.background_light'))
        } else {
          List({ space: 0 }) {
            ForEach(this.episodes, (episode: EpisodeData) => {
              ListItem() {
                EpisodeListItem({
                  episode: episode,
                  showDragHandle: false,
                  onItemClick: (ep: EpisodeData) => {
                    this.openEpisodeDetail(ep);
                  },
                  onSecondaryAction: (ep: EpisodeData) => {
                    episodesViewModel.toggleSecondaryAction(ep);
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
          author: 'Morbid',
          cover: $r('app.media.ic_feed'),
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
        items: this.episodesMenu,
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
          episodesViewModel.applyFilter(values);
          this.syncFromVm();
        },
        onReset: () => {
          episodesViewModel.resetFilter();
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
              episodesViewModel.togglePlayed(this.contextEpisode);
              break;
            case 'add_to_queue':
            case 'remove_from_queue':
              episodesViewModel.toggleQueue(this.contextEpisode);
              break;
            case 'add_to_favorites':
            case 'remove_from_favorites':
              episodesViewModel.toggleFavorite(this.contextEpisode);
              break;
            case 'remove_inbox':
              episodesViewModel.markPlayed(this.contextEpisode);
              break;
            case 'reset_position':
              episodesViewModel.resetPosition(this.contextEpisode);
              break;
            case 'delete':
              episodesViewModel.deleteEpisode(this.contextEpisode);
              break;
            case 'share':
              try { promptAction.showToast({ message: 'Sharing not available in this build' }); } catch (e) { }
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

export default EpisodesPage;
