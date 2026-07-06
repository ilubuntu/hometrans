import { router } from '@kit.ArkUI';
import { EpisodeData, SecondaryActionType, DownloadState } from '../model/EpisodeData';
import { repository } from '../common/data/Repository';
import { eventBus, AppEvent } from '../common/event/EventBus';
import { serviceLocator } from '../common/service/ServiceLocator';
import { AppToolbar } from '../components/AppToolbar';
import { EpisodeListItem } from '../components/EpisodeListItem';
import { EpisodeContextMenu } from '../components/EpisodeContextMenu';

interface FavoritesPageState {
  episodes: EpisodeData[];
}

@Entry
@Component
struct FavoritesPage {
  @State episodes: EpisodeData[] = [];
  @State contextMenuVisible: boolean = false;
  @State contextEpisode: EpisodeData = new EpisodeData('_placeholder', '');
  private listener: () => void = (): void => {
    this.reload();
  };

  aboutToAppear(): void {
    this.reload();
    eventBus.on(AppEvent.FAVORITES_CHANGED, this.listener);
    eventBus.on(AppEvent.EPISODES_CHANGED, this.listener);
  }

  aboutToDisappear(): void {
    eventBus.off(AppEvent.FAVORITES_CHANGED, this.listener);
    eventBus.off(AppEvent.EPISODES_CHANGED, this.listener);
  }

  private reload(): void {
    this.episodes = repository.queryFavorites();
  }

  private openEpisodeDetail(episode: EpisodeData): void {
    router.pushUrl({
      url: 'pages/EpisodeDetailPage',
      params: { episodeId: episode.id, episodeTitle: episode.title }
    });
  }

  build() {
    Stack() {
      Column() {
        AppToolbar({
          title: $r('app.string.favorite_episodes_label'),
          showBack: true,
          showSearch: false,
          showFilter: false,
          showOverflow: false,
          onBack: () => {
            router.back();
          }
        })

        if (this.episodes.length === 0) {
          Column() {
            Image($r('app.media.ic_star_border'))
              .width(72)
              .height(72)
              .fillColor($r('app.color.grey600'))
              .margin({ bottom: 12 })
            Text($r('app.string.no_favorite_episodes_label'))
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
                  onItemClick: (ep: EpisodeData): void => {
                    this.openEpisodeDetail(ep);
                  },
                  onSecondaryAction: (ep: EpisodeData): void => {
                    if (ep.downloadState === DownloadState.DOWNLOADING) {
                      serviceLocator.downloadService().cancel(ep.id);
                    } else if (ep.downloadState === DownloadState.NONE) {
                      serviceLocator.downloadService().start(ep.id);
                    } else {
                      serviceLocator.playbackService().play(ep.id);
                    }
                    this.reload();
                  },
                  onLongPress: (ep: EpisodeData): void => {
                    this.contextEpisode = ep;
                    this.contextMenuVisible = true;
                  }
                })
              }
            }, (episode: EpisodeData): string => episode.id)
          }
          .width('100%')
          .layoutWeight(1)
          .divider({ strokeWidth: 1, color: $r('app.color.grey100'), startMargin: 88, endMargin: 16 })
          .padding({ left: 12, right: 0 })
          .backgroundColor($r('app.color.background_light'))
        }
      }
      .width('100%')
      .height('100%')

      EpisodeContextMenu({
        visible: this.contextMenuVisible,
        episode: this.contextEpisode,
        onSelect: (id: string): void => {
          this.contextMenuVisible = false;
          const ep: EpisodeData = this.contextEpisode;
          if (id === 'mark_read' || id === 'mark_unread') {
            repository.markPlayed(ep.id, id === 'mark_read');
          } else if (id === 'add_to_queue' || id === 'remove_from_queue') {
            if (ep.inQueue) {
              repository.dequeue(ep.id);
            } else {
              repository.enqueue(ep.id);
            }
          } else if (id === 'add_to_favorites' || id === 'remove_from_favorites') {
            repository.setFavorite(ep.id, !ep.isFavorite);
          } else if (id === 'reset_position') {
            repository.resetPosition(ep.id);
          } else if (id === 'open_podcast') {
            router.pushUrl({ url: 'pages/FeedDetailPage', params: { feedId: ep.feedId } });
          }
          this.reload();
        },
        onDismiss: (): void => {
          this.contextMenuVisible = false;
        }
      })
    }
    .width('100%')
    .height('100%')
  }
}

export default FavoritesPage;
