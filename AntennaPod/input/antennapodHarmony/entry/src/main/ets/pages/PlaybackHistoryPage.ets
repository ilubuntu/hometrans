import { router } from '@kit.ArkUI';
import { EpisodeData } from '../model/EpisodeData';
import { repository } from '../common/data/Repository';
import { eventBus, AppEvent } from '../common/event/EventBus';
import { AppToolbar } from '../components/AppToolbar';
import { EpisodeListItem } from '../components/EpisodeListItem';

@Entry
@Component
struct PlaybackHistoryPage {
  @State episodes: EpisodeData[] = [];
  private listener: () => void = (): void => {
    this.reload();
  };

  aboutToAppear(): void {
    this.reload();
    eventBus.on(AppEvent.PLAYBACK_HISTORY_CHANGED, this.listener);
  }

  aboutToDisappear(): void {
    eventBus.off(AppEvent.PLAYBACK_HISTORY_CHANGED, this.listener);
  }

  private reload(): void {
    this.episodes = repository.queryHistory();
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
          title: $r('app.string.playback_history_label'),
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
            Image($r('app.media.ic_history'))
              .width(72)
              .height(72)
              .fillColor($r('app.color.grey600'))
              .margin({ bottom: 12 })
            Text($r('app.string.no_playback_history_label'))
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
                    router.pushUrl({
                      url: 'pages/AudioPlayerPage',
                      params: { episodeId: ep.id, episodeTitle: ep.title }
                    });
                  },
                  onLongPress: (_ep: EpisodeData): void => {
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
    }
    .width('100%')
    .height('100%')
  }
}

export default PlaybackHistoryPage;
