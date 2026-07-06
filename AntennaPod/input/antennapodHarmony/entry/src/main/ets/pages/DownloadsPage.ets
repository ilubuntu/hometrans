import { router, promptAction } from '@kit.ArkUI';
import { EpisodeData } from '../model/EpisodeData';
import { downloadsViewModel } from '../viewmodel/DownloadsViewModel';
import { OverflowMenuOption } from '../model/HomeSection';
import { AppToolbar } from '../components/AppToolbar';
import { OverflowMenu } from '../components/OverflowMenu';
import { EpisodeListItem } from '../components/EpisodeListItem';
import { EpisodeContextMenu } from '../components/EpisodeContextMenu';
import { MiniPlayerBar } from '../components/MiniPlayerBar';
import { BottomNav } from '../components/BottomNav';
import { serviceLocator } from '../common/service/ServiceLocator';

@Entry
@Component
struct DownloadsPage {
  @State episodes: EpisodeData[] = [];
  @State overflowVisible: boolean = false;
  @State refreshing: boolean = false;
  @State bottomTab: number = -1;
  @State contextMenuVisible: boolean = false;
  @State contextEpisode: EpisodeData = new EpisodeData('_placeholder', '');

  private downloadsMenu: OverflowMenuOption[] = [
    { id: 'downloads_sort', label: $r('app.string.sort'), enabled: true },
    { id: 'refresh', label: $r('app.string.refresh_label'), enabled: true },
    { id: 'delete_played', label: 'Delete played downloads', enabled: true }
  ];

  aboutToAppear(): void {
    downloadsViewModel.load();
    this.episodes = downloadsViewModel.episodes;
  }

  private syncFromVm(): void {
    this.episodes = downloadsViewModel.episodes.slice();
  }

  private handleOverflowSelect(id: string): void {
    this.overflowVisible = false;
    if (id === 'refresh') {
      this.refreshing = true;
      setTimeout(() => {
        downloadsViewModel.load();
        this.syncFromVm();
        this.refreshing = false;
      }, 600);
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

  private openDownloadLogs(): void {
    
    try { promptAction.showToast({ message: 'Download log not available in this build' }); } catch (e) { }
  }

  build() {
    Stack() {
      Column() {
        AppToolbar({
          title: $r('app.string.downloads_label'),
          showBack: true,
          showSearch: true,
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

        if (this.episodes.length === 0) {
          Column() {
            Image($r('app.media.ic_download'))
              .width(72)
              .height(72)
              .fillColor($r('app.color.grey600'))
              .margin({ bottom: 12 })
            Text($r('app.string.no_comp_downloads_head_label'))
              .fontSize(18)
              .fontColor($r('app.color.black'))
              .margin({ bottom: 4 })
            Text($r('app.string.no_comp_downloads_label'))
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
                    downloadsViewModel.toggleSecondaryAction(ep);
                  },
                  onLongPress: (ep: EpisodeData) => {
                    this.openEpisodeContextMenu(ep);
                  }
                })
              }
              .swipeAction({
                end: {
                  builder: () => {
                    this.SwipeDelete(episode)
                  }
                }
              })
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
        items: this.downloadsMenu,
        onSelect: (id: string) => this.handleOverflowSelect(id),
        onDismiss: () => {
          this.overflowVisible = false;
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
              downloadsViewModel.togglePlayed(this.contextEpisode);
              break;
            case 'add_to_queue':
            case 'remove_from_queue':
              downloadsViewModel.toggleQueue(this.contextEpisode);
              break;
            case 'add_to_favorites':
            case 'remove_from_favorites':
              downloadsViewModel.toggleFavorite(this.contextEpisode);
              break;
            case 'reset_position':
              downloadsViewModel.resetPosition(this.contextEpisode);
              break;
            case 'delete':
              downloadsViewModel.deleteEpisode(this.contextEpisode);
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
  SwipeDelete(episode: EpisodeData) {
    Button() {
      Image($r('app.media.ic_delete'))
        .width(24)
        .height(24)
        .fillColor($r('app.color.white'))
    }
    .type(ButtonType.Normal)
    .backgroundColor($r('app.color.accent_light'))
    .height('100%')
    .width(80)
    .onClick(() => {
      downloadsViewModel.delete(episode);
      this.syncFromVm();
    })
    .accessibilityText('Delete')
  }
}

export default DownloadsPage;
