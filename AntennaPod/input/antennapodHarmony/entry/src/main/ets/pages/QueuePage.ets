import { router } from '@kit.ArkUI';
import { EpisodeData } from '../model/EpisodeData';
import { queueViewModel } from '../viewmodel/QueueViewModel';
import { QueueListItem } from '../components/QueueListItem';
import { eventBus, AppEvent } from '../common/event/EventBus';

@Component
export struct QueuePage {
  @State episodes: EpisodeData[] = [];
  @State infoBar: string = '';
  private listener: () => void = (): void => this.reload();

  aboutToAppear(): void {
    this.reload();
    eventBus.on(AppEvent.QUEUE_CHANGED, this.listener);
    eventBus.on(AppEvent.DOWNLOAD_PROGRESS, this.listener);
  }

  aboutToDisappear(): void {
    eventBus.off(AppEvent.QUEUE_CHANGED, this.listener);
    eventBus.off(AppEvent.DOWNLOAD_PROGRESS, this.listener);
  }

  private reload(): void {
    queueViewModel.reload();
    this.episodes = queueViewModel.episodes.slice();
    this.infoBar = queueViewModel.buildInfoBar();
  }

  build() {
    Column() {
      Text(this.infoBar)
        .width('100%')
        .fontSize(12)
        .fontColor($r('app.color.grey600'))
        .padding({ left: 16, right: 16, top: 4, bottom: 8 })
        .backgroundColor($r('app.color.background_light'))

      if (this.episodes.length === 0) {
        Column() {
          Image($r('app.media.ic_shortcut_playlist'))
            .width(72)
            .height(72)
            .fillColor($r('app.color.grey600'))
            .margin({ bottom: 12 })
          Text($r('app.string.queue_label'))
            .fontSize(18)
            .fontColor($r('app.color.black'))
            .margin({ bottom: 4 })
          Text('Your queue is empty. Add episodes from any list to build a queue.')
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
          ForEach(this.episodes, (episode: EpisodeData, index: number) => {
            ListItem() {
              QueueListItem({
                episode: episode,
                onItemClick: (ep: EpisodeData) => {
                  router.pushUrl({
                    url: 'pages/EpisodeDetailPage',
                    params: { episodeId: ep.id, episodeTitle: ep.title }
                  });
                },
                onSecondaryAction: (ep: EpisodeData) => {
                  queueViewModel.toggleSecondaryAction(ep);
                },
                onLongPress: (ep: EpisodeData) => {
                  router.pushUrl({
                    url: 'pages/EpisodeDetailPage',
                    params: { episodeId: ep.id, episodeTitle: ep.title }
                  });
                },
                onDragReorder: (from: number, to: number) => {
                  queueViewModel.reorder(from, to);
                }
              })
            }
          }, (episode: EpisodeData) => episode.id)
        }
        .width('100%')
        .layoutWeight(1)
        .divider({ strokeWidth: 1, color: $r('app.color.grey100'), startMargin: 88, endMargin: 16 })
        .padding({ left: 12, right: 0 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_light'))
  }
}
