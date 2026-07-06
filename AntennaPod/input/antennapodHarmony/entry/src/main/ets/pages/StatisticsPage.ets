import { router } from '@kit.ArkUI';
import { repository } from '../common/data/Repository';
import { AppToolbar } from '../components/AppToolbar';

@Entry
@Component
struct StatisticsPage {
  @State totalFeeds: number = 0;
  @State totalEpisodes: number = 0;
  @State totalPlayed: number = 0;
  @State totalFavorites: number = 0;
  @State totalQueue: number = 0;
  @State totalDownloads: number = 0;
  @State totalDurationSec: number = 0;

  aboutToAppear(): void {
    this.totalFeeds = repository.queryFeeds().length;
    this.totalEpisodes = repository.countEpisodes();
    const allEpisodes = repository.queryEpisodes([], 'date_desc');
    let played: number = 0;
    let duration: number = 0;
    for (let i = 0; i < allEpisodes.length; i++) {
      if (allEpisodes[i].isPlayed) {
        played++;
      }
      duration += allEpisodes[i].durationSec;
    }
    this.totalPlayed = played;
    this.totalDurationSec = duration;
    this.totalFavorites = repository.queryFavorites().length;
    this.totalQueue = repository.queryQueue().length;
    this.totalDownloads = repository.queryDownloads().length;
  }

  private formatDuration(sec: number): string {
    const hr: number = Math.floor(sec / 3600);
    const min: number = Math.floor((sec % 3600) / 60);
    if (hr > 0) {
      return `${hr} hour${hr > 1 ? 's' : ''} ${min} min`;
    }
    return `${min} min`;
  }

  @Builder
  StatRow(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(15)
        .fontColor($r('app.color.black'))
        .layoutWeight(1)
      Text(value)
        .fontSize(15)
        .fontColor($r('app.color.grey600'))
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 14, bottom: 14 })
  }

  build() {
    Stack() {
      Column() {
        AppToolbar({
          title: $r('app.string.statistics_label'),
          showBack: true,
          showSearch: false,
          showFilter: false,
          showOverflow: false,
          onBack: () => {
            router.back();
          }
        })

        Scroll() {
          Column() {
            this.StatRow('Subscribed podcasts', `${this.totalFeeds}`)
            Divider().color($r('app.color.grey100')).strokeWidth(1)
            this.StatRow('Total episodes', `${this.totalEpisodes}`)
            Divider().color($r('app.color.grey100')).strokeWidth(1)
            this.StatRow('Played episodes', `${this.totalPlayed}`)
            Divider().color($r('app.color.grey100')).strokeWidth(1)
            this.StatRow('Favorite episodes', `${this.totalFavorites}`)
            Divider().color($r('app.color.grey100')).strokeWidth(1)
            this.StatRow('Episodes in queue', `${this.totalQueue}`)
            Divider().color($r('app.color.grey100')).strokeWidth(1)
            this.StatRow('Downloaded episodes', `${this.totalDownloads}`)
            Divider().color($r('app.color.grey100')).strokeWidth(1)
            this.StatRow('Total duration', this.formatDuration(this.totalDurationSec))
            Divider().color($r('app.color.grey100')).strokeWidth(1)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .backgroundColor($r('app.color.background_light'))
        }
        .layoutWeight(1)
        .backgroundColor($r('app.color.background_light'))
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}

export default StatisticsPage;
