import { router } from '@kit.ArkUI';
import { EpisodeData, SecondaryActionType, DownloadState } from '../model/EpisodeData';
import { HomeSection, HomeSectionType } from '../model/HomeSection';
import { homeViewModel } from '../viewmodel/HomeViewModel';
import { EpisodeListItem } from '../components/EpisodeListItem';
import { repository } from '../common/data/Repository';
import { serviceLocator } from '../common/service/ServiceLocator';
import { eventBus, AppEvent } from '../common/event/EventBus';

@Component
export struct HomePage {
  @State sections: HomeSection[] = [];
  @State hasEpisodes: boolean = true;
  onMoreSection: (section: HomeSection) => void = () => {};
  private listener: () => void = (): void => {
    homeViewModel.reload();
    this.sections = homeViewModel.sections.slice();
    this.hasEpisodes = homeViewModel.hasEpisodes();
  };

  aboutToAppear(): void {
    homeViewModel.load();
    this.sections = homeViewModel.sections.slice();
    this.hasEpisodes = homeViewModel.hasEpisodes();
    eventBus.on(AppEvent.FEEDS_CHANGED, this.listener);
    eventBus.on(AppEvent.EPISODES_CHANGED, this.listener);
    eventBus.on(AppEvent.QUEUE_CHANGED, this.listener);
    eventBus.on(AppEvent.DOWNLOAD_PROGRESS, this.listener);
    eventBus.on(AppEvent.INBOX_CHANGED, this.listener);
    eventBus.on(AppEvent.REPOSITORY_READY, this.listener);
  }

  aboutToDisappear(): void {
    eventBus.off(AppEvent.FEEDS_CHANGED, this.listener);
    eventBus.off(AppEvent.EPISODES_CHANGED, this.listener);
    eventBus.off(AppEvent.QUEUE_CHANGED, this.listener);
    eventBus.off(AppEvent.DOWNLOAD_PROGRESS, this.listener);
    eventBus.off(AppEvent.INBOX_CHANGED, this.listener);
    eventBus.off(AppEvent.REPOSITORY_READY, this.listener);
  }

  private openEpisode(episode: EpisodeData): void {
    router.pushUrl({
      url: 'pages/EpisodeDetailPage',
      params: { episodeId: episode.id, episodeTitle: episode.title }
    });
  }

  private secondaryAction(episode: EpisodeData): void {
    if (episode.secondaryAction === SecondaryActionType.PLAY
      || episode.secondaryAction === SecondaryActionType.PAUSE) {
      serviceLocator.playbackService().play(episode.id);
    } else if (episode.downloadState === DownloadState.DOWNLOADING) {
      serviceLocator.downloadService().cancel(episode.id);
    } else if (episode.downloadState === DownloadState.NONE) {
      serviceLocator.downloadService().start(episode.id);
    }
    this.listener();
  }

  @Builder
  SectionHeader(section: HomeSection) {
    Row() {
      Text(section.title)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.black'))
        .layoutWeight(1)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Start)
      if (section.type === HomeSectionType.GET_SURPRISED) {
        Button() {
          Image($r('app.media.ic_shuffle'))
            .width(24)
            .height(24)
            .fillColor($r('app.color.black'))
        }
        .type(ButtonType.Normal)
        .backgroundColor(Color.Transparent)
        .width(48)
        .height(48)
        .margin({ left: 4, right: 4 })
        .onClick(() => {
          homeViewModel.load();
          this.sections = homeViewModel.sections.slice();
        })
        .accessibilityText($r('app.string.shuffle_suggestions'))
      }
      Button() {
        Row() {
          Text(section.moreLabel)
            .fontSize(14)
            .fontColor($r('app.color.accent_light'))
            .margin({ right: 4 })
          Image($r('app.media.ic_arrow_right_white'))
            .width(16)
            .height(16)
            .fillColor($r('app.color.accent_light'))
        }
      }
      .type(ButtonType.Normal)
      .backgroundColor(Color.Transparent)
      .padding({ left: 12, right: 12, top: 8, bottom: 8 })
      .onClick(() => this.onMoreSection(section))
    }
    .width('100%')
    .padding({ left: 16, right: 8, top: 12, bottom: 4 })
  }

  @Builder
  HorizontalCarousel(section: HomeSection) {
    List({ space: 0 }) {
      ForEach(section.episodes, (episode: EpisodeData) => {
        ListItem() {
          Column() {
            Stack({ alignContent: Alignment.BottomEnd }) {
              Image(episode.cover)
                .width(128)
                .height(128)
                .borderRadius(12)
                .backgroundColor($r('app.color.image_readability_tint'))
                .objectFit(ImageFit.Cover)
              Stack() {
                Image(episode.secondaryAction === SecondaryActionType.DOWNLOAD
                  ? $r('app.media.ic_download') : $r('app.media.ic_play_24dp'))
                  .width(24)
                  .height(24)
                  .fillColor($r('app.color.white'))
              }
              .width(48)
              .height(48)
              .backgroundColor($r('app.color.image_readability_tint'))
              .borderRadius(24)
              .margin({ bottom: 4, right: 4 })
              .onClick(() => {
                this.secondaryAction(episode);
              })
              .accessibilityText(episode.secondaryAction === SecondaryActionType.DOWNLOAD
                ? 'Download' : 'Play')
            }
            .width(128)
            .height(128)

            Text(episode.title)
              .width(128)
              .fontSize(14)
              .fontColor($r('app.color.black'))
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .textAlign(TextAlign.Start)
              .margin({ top: 4 })
              .padding({ left: 4, right: 4 })
            if (episode.pubDate) {
              Text(episode.pubDate)
                .width(128)
                .fontSize(14)
                .fontColor($r('app.color.grey600'))
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .textAlign(TextAlign.Start)
                .padding({ left: 4, right: 4, bottom: 4 })
                .accessibilityText(episode.pubDateDesc)
            }
          }
          .width(128)
          .borderRadius(12)
          .backgroundColor($r('app.color.grey100'))
          .margin({ left: 4, right: 4 })
          .onClick(() => {
            this.openEpisode(episode);
          })
        }
      }, (episode: EpisodeData) => episode.id)
    }
    .listDirection(Axis.Horizontal)
    .scrollBar(BarState.Off)
    .width('100%')
    .height(210)
    .padding({ left: 12, right: 12 })
  }

  @Builder
  DownloadsList(section: HomeSection) {
    Column() {
      ForEach(section.episodes, (episode: EpisodeData) => {
        EpisodeListItem({
          episode: episode,
          showDragHandle: false,
          onItemClick: (ep: EpisodeData) => {
            this.openEpisode(ep);
          },
          onSecondaryAction: (ep: EpisodeData) => {
            this.secondaryAction(ep);
          }
        })
      }, (episode: EpisodeData) => episode.id)
    }
    .width('100%')
  }

  build() {
    Scroll() {
      Column() {
        if (!this.hasEpisodes) {
          this.EmptyLibraryState()
        }
        ForEach(this.sections, (section: HomeSection) => {
          Column() {
            this.SectionHeader(section)
            if (section.isEmpty) {
              Text(section.type === HomeSectionType.SEE_WHATS_NEW
                ? $r('app.string.home_new_empty_text') : '')
                .width('100%')
                .fontSize(14)
                .fontColor($r('app.color.grey600'))
                .padding({ left: 16, right: 16, top: 12, bottom: 24 })
            } else if (section.type === HomeSectionType.MANAGE_DOWNLOADS) {
              this.DownloadsList(section)
            } else {
              this.HorizontalCarousel(section)
            }
          }
          .width('100%')
          .margin({ bottom: 8 })
        }, (section: HomeSection) => `${section.type}`)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_light'))
    .scrollBar(BarState.Auto)
  }

  @Builder
  EmptyLibraryState() {
    Column() {
      Image($r('app.media.ic_feed'))
        .width(96)
        .height(96)
        .fillColor($r('app.color.grey600'))
        .margin({ bottom: 16 })
      Text($r('app.string.home_welcome_title'))
        .fontSize(22)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.black'))
        .margin({ bottom: 8 })
      Text($r('app.string.home_welcome_text'))
        .fontSize(14)
        .fontColor($r('app.color.grey600'))
        .textAlign(TextAlign.Center)
        .padding({ left: 32, right: 32, bottom: 16 })
      Button($r('app.string.add_feed_label'))
        .type(ButtonType.Capsule)
        .backgroundColor($r('app.color.accent_light'))
        .fontColor($r('app.color.white'))
        .fontSize(14)
        .height(40)
        .margin({ bottom: 16 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/AddFeedPage' });
        })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('app.color.background_light'))
    .padding({ top: 48, bottom: 24 })
  }
}
