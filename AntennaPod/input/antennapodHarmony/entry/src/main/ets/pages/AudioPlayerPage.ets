import { router, promptAction } from '@kit.ArkUI';
import { EpisodeData, SecondaryActionType } from '../model/EpisodeData';
import { OverflowMenuOption } from '../model/HomeSection';
import { episodeDetailViewModel } from '../viewmodel/EpisodeDetailViewModel';
import { AppToolbar } from '../components/AppToolbar';
import { OverflowMenu } from '../components/OverflowMenu';
import { EpisodeContextMenu } from '../components/EpisodeContextMenu';
import { DownloadDialog } from '../components/DownloadDialog';
import { serviceLocator } from '../common/service/ServiceLocator';

@Component
struct PlayerCoverHeader {
  @ObjectLink episode: EpisodeData;
  @Prop podcastTitle: string = '';
  @Prop pubDate: string = '';
  onOpenPodcast: () => void = () => {};

  build() {
    Column() {
      Image(this.episode.cover)
        .aspectRatio(1)
        .width('82%')
        .objectFit(ImageFit.Cover)
        .backgroundColor($r('app.color.non_square_icon_background'))
        .borderRadius(8)
        .margin({ top: 8, bottom: 20 })
        .onClick(() => this.onOpenPodcast())
        .accessibilityText(this.episode.title)

      Text(`${this.podcastTitle}${this.pubDate.length > 0 ? ' ・ ' + this.pubDate : ''}`)
        .fontSize(14)
        .fontColor($r('app.color.text_color_secondary_light'))
        .maxLines(2)
        .textAlign(TextAlign.Center)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')
        .padding({ top: 2, bottom: 2 })
        .onClick(() => this.onOpenPodcast())
        .accessibilityText(`Podcast ${this.podcastTitle}`)

      Text(this.episode.title)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.black'))
        .maxLines(2)
        .textAlign(TextAlign.Center)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')
        .padding({ top: 2, bottom: 2 })
        .margin({ bottom: 16 })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .padding({ left: 24, right: 24, top: 4 })
  }
}

@Component
struct FullPlayerControlRow {
  @Prop isPlaying: boolean = false;
  @Prop playbackSpeedLabel: string = '1.00';
  @Prop rewindSeconds: number = 30;
  @Prop fastForwardSeconds: number = 30;
  onSpeed: () => void = () => {};
  onRewind: () => void = () => {};
  onPlay: () => void = () => {};
  onForward: () => void = () => {};
  onSkip: () => void = () => {};

  build() {
    Row() {
      Column() {
        Image($r('app.media.ic_playback_speed'))
          .width(48)
          .height(48)
          .fillColor($r('app.color.black'))
        Text(this.playbackSpeedLabel)
          .fontSize(12)
          .fontColor($r('app.color.text_color_secondary_light'))
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .onClick(() => this.onSpeed())
      .accessibilityText($r('app.string.playback_speed'))

      Column() {
        Image($r('app.media.ic_fast_rewind'))
          .width(48)
          .height(48)
          .fillColor($r('app.color.black'))
        Text(`${this.rewindSeconds}`)
          .fontSize(12)
          .fontColor($r('app.color.text_color_secondary_light'))
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .onClick(() => this.onRewind())
      .accessibilityText($r('app.string.rewind_label'))

      Stack() {
        Image(this.isPlaying ? $r('app.media.ic_pause') : $r('app.media.ic_play_48dp'))
          .width(64)
          .height(64)
          .fillColor($r('app.color.accent_light'))
      }
      .layoutWeight(1.3)
      .height(72)
      .alignContent(Alignment.Center)
      .onClick(() => this.onPlay())
      .accessibilityText(this.isPlaying ? $r('app.string.pause_label') : $r('app.string.play_label'))

      Column() {
        Image($r('app.media.ic_fast_forward'))
          .width(48)
          .height(48)
          .fillColor($r('app.color.black'))
        Text(`${this.fastForwardSeconds}`)
          .fontSize(12)
          .fontColor($r('app.color.text_color_secondary_light'))
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .onClick(() => this.onForward())
      .accessibilityText($r('app.string.fast_forward_label'))

      Column() {
        Image($r('app.media.ic_skip_48dp'))
          .width(48)
          .height(48)
          .fillColor($r('app.color.black'))
      }
      .layoutWeight(1)
      .onClick(() => this.onSkip())
      .accessibilityText($r('app.string.skip_episode_label'))
    }
    .width('100%')
    .height(80)
    .margin({ top: 4, bottom: 4 })
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceAround)
  }
}

@Entry
@Component
struct AudioPlayerPage {
  @State episode: EpisodeData = new EpisodeData('feed_morbid_ep2', 'Listener Tales 111: Camping Tales');
  @State title: string = '';
  @State podcastTitle: string = '';
  @State feedId: string = '';
  @State pubDate: string = '';
  @State cover: Resource = $r('app.media.ic_feed');

  @State positionLabel: string = '00:00';
  @State durationLabel: string = '00:00';
  @State progressPct: number = 0;
  @State positionSec: number = 0;
  @State durationSec: number = 0;
  @State playbackSpeedLabel: string = '1.00';
  @State rewindSeconds: number = 30;
  @State fastForwardSeconds: number = 30;

  @State isPlaying: boolean = false;
  @State isFavorite: boolean = false;
  @State inQueue: boolean = false;
  @State sleepTimerEnabled: boolean = false;
  @State websiteUrl: string = '';

  @State overflowVisible: boolean = false;
  @State contextMenuVisible: boolean = false;
  @State downloadDialogVisible: boolean = false;
  @State seekCardVisible: boolean = false;
  @State seekCardText: string = '';

  private toolbarMenu: OverflowMenuOption[] = [
    { id: 'visit_website', label: $r('app.string.visit_website_label'), enabled: true },
    { id: 'open_podcast', label: $r('app.string.open_podcast'), enabled: true },
    { id: 'show_transcript', label: $r('app.string.show_transcript'), enabled: true },
    { id: 'audio_controls', label: $r('app.string.audio_controls'), enabled: true },
    { id: 'share', label: $r('app.string.share_label'), enabled: true }
  ];

  aboutToAppear(): void {
    let episodeId = 'feed_morbid_ep2';
    let episodeTitle = '';
    try {
      const params = router.getParams() as Record<string, string>;
      if (params) {
        if (params.episodeId && params.episodeId.length > 0) {
          episodeId = params.episodeId;
        }
        if (params.episodeTitle && params.episodeTitle.length > 0) {
          episodeTitle = params.episodeTitle;
        }
      }
    } catch (e) {
      console.info(`AudioPlayerPage: fallback to default episode (${e})`);
    }
    if (episodeTitle.length > 0) {
      episodeDetailViewModel.loadByTitle(episodeTitle);
    } else {
      episodeDetailViewModel.loadById(episodeId);
    }
    this.syncFromVm();
  }

  private syncFromVm(): void {
    this.episode = this.buildEpisodeProxy();
    this.title = episodeDetailViewModel.title;
    this.podcastTitle = episodeDetailViewModel.podcastTitle;
    this.feedId = episodeDetailViewModel.feedId;
    this.pubDate = episodeDetailViewModel.pubDate;
    this.cover = episodeDetailViewModel.cover;
    this.positionLabel = episodeDetailViewModel.positionLabel;
    this.durationLabel = episodeDetailViewModel.durationLabel;
    this.progressPct = episodeDetailViewModel.progressPct;
    this.positionSec = episodeDetailViewModel.positionSec;
    this.durationSec = episodeDetailViewModel.durationSec;
    this.playbackSpeedLabel = episodeDetailViewModel.playbackSpeedLabel;
    this.rewindSeconds = episodeDetailViewModel.rewindSeconds;
    this.fastForwardSeconds = episodeDetailViewModel.fastForwardSeconds;
    this.isPlaying = episodeDetailViewModel.isPlaying;
    this.isFavorite = episodeDetailViewModel.isFavorite;
    this.inQueue = episodeDetailViewModel.inQueue;
    this.sleepTimerEnabled = episodeDetailViewModel.sleepTimerEnabled;
    this.websiteUrl = episodeDetailViewModel.websiteUrl;
  }

  private buildEpisodeProxy(): EpisodeData {
    const ep = new EpisodeData(episodeDetailViewModel.episodeId, episodeDetailViewModel.title);
    ep.cover = episodeDetailViewModel.cover;
    ep.author = episodeDetailViewModel.podcastTitle;
    ep.pubDate = episodeDetailViewModel.pubDate;
    ep.duration = episodeDetailViewModel.durationLabel;
    ep.position = episodeDetailViewModel.positionLabel;
    ep.progress = episodeDetailViewModel.progressPct;
    ep.isFavorite = episodeDetailViewModel.isFavorite;
    ep.inQueue = episodeDetailViewModel.inQueue;
    ep.secondaryAction = episodeDetailViewModel.isPlaying
      ? SecondaryActionType.PAUSE : SecondaryActionType.PLAY;
    return ep;
  }

  private handleToolbarMenu(id: string): void {
    this.overflowVisible = false;
    switch (id) {
      case 'visit_website':
        try { promptAction.showToast({ message: this.websiteUrl }); } catch (e) { }
        break;
      case 'open_podcast':
        this.openPodcast();
        break;
      case 'show_transcript':
        try { promptAction.showToast({ message: 'Transcripts not available in this build' }); } catch (e) { }
        break;
      case 'audio_controls':
        try { promptAction.showToast({ message: 'Audio controls not available in this build' }); } catch (e) { }
        break;
      case 'share':
        try { promptAction.showToast({ message: 'Sharing not available in this build' }); } catch (e) { }
        break;
      default:
        
    }
  }

  private handleContextAction(id: string): void {
    this.contextMenuVisible = false;
    switch (id) {
      case 'mark_read':
      case 'mark_unread':
        episodeDetailViewModel.togglePlayed();
        break;
      case 'add_to_queue':
      case 'remove_from_queue':
        episodeDetailViewModel.toggleQueue();
        break;
      case 'add_to_favorites':
      case 'remove_from_favorites':
        episodeDetailViewModel.toggleFavorite();
        break;
      case 'reset_position':
        episodeDetailViewModel.resetPosition();
        break;
      case 'share':
        try { promptAction.showToast({ message: 'Sharing not available in this build' }); } catch (e) { }
        break;
      case 'open_podcast':
        this.openPodcast();
        break;
      case 'delete':
        serviceLocator.downloadService().delete(episodeDetailViewModel.episodeId);
        break;
      default:
        
    }
    this.syncFromVm();
  }

  private onSeekBarChange(value: number, mode: SliderChangeMode): void {
    const targetSec = Math.floor((value / 100) * this.durationSec);
    this.seekCardText = this.formatTime(targetSec);
    if (mode === SliderChangeMode.Moving) {
      this.seekCardVisible = true;
    } else if (mode === SliderChangeMode.End || mode === SliderChangeMode.Click) {
      episodeDetailViewModel.seekTo(targetSec);
      this.seekCardVisible = false;
      this.syncFromVm();
    }
  }

  private openPodcast(): void {
    router.pushUrl({
      url: 'pages/FeedDetailPage',
      params: { feedId: this.feedId }
    });
  }

  private confirmDownload(): void {
    this.downloadDialogVisible = true;
  }

  private onDownloadLater(): void {
    this.downloadDialogVisible = false;
    serviceLocator.downloadService().start(episodeDetailViewModel.episodeId);
  }

  private onDownloadAnyway(): void {
    this.downloadDialogVisible = false;
    serviceLocator.downloadService().start(episodeDetailViewModel.episodeId);
  }

  private formatTime(totalSec: number): string {
    if (totalSec <= 0) {
      return '00:00';
    }
    const sec = Math.floor(totalSec % 60);
    const min = Math.floor((totalSec / 60) % 60);
    const hr = Math.floor(totalSec / 3600);
    const ss = sec < 10 ? `0${sec}` : `${sec}`;
    const mm = min < 10 ? `0${min}` : `${min}`;
    if (hr > 0) {
      return `${hr}:${mm}:${ss}`;
    }
    return `${mm}:${ss}`;
  }

  build() {
    Stack() {
      Column() {
        AppToolbar({
          title: this.podcastTitle.length > 0 ? this.podcastTitle : $r('app.string.playback_control'),
          showBack: true,
          showSearch: false,
          showFilter: false,
          showOverflow: true,
          onBack: () => {
            router.back();
          },
          onMore: () => {
            this.overflowVisible = !this.overflowVisible;
          }
        })

        Column() {
          Column() {
            PlayerCoverHeader({
              episode: this.episode,
              podcastTitle: this.podcastTitle,
              pubDate: this.pubDate,
              onOpenPodcast: () => this.openPodcast()
            })
          }
          .layoutWeight(1)
          .width('100%')
          .justifyContent(FlexAlign.Center)

          Row() {
            Text($r('app.string.shownotes_label'))
              .fontSize(14)
              .fontColor($r('app.color.text_color_secondary_light'))
              .padding({ left: 16, right: 16, top: 6, bottom: 6 })
          }
          .border({ width: 1, color: $r('app.color.grey600') })
          .borderRadius(20)
          .margin({ bottom: 12 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/EpisodeDetailPage',
              params: { episodeId: this.episode.id, episodeTitle: this.episode.title }
            });
          })
          .accessibilityText($r('app.string.shownotes_label'))

          Stack({ alignContent: Alignment.Center }) {
            Column() {
              Slider({
                value: this.progressPct,
                min: 0,
                max: 100,
                step: 1,
                style: SliderStyle.OutSet
              })
                .width('100%')
                .blockColor($r('app.color.accent_light'))
                .selectedColor($r('app.color.accent_light'))
                .trackColor($r('app.color.grey100'))
                .onChange((value: number, mode: SliderChangeMode) => this.onSeekBarChange(value, mode))

              Row() {
                Text(this.positionLabel)
                  .fontSize(12)
                  .fontColor($r('app.color.text_color_secondary_light'))
                Blank()
                Text(this.durationLabel)
                  .fontSize(12)
                  .fontColor($r('app.color.text_color_secondary_light'))
              }
              .width('100%')
              .padding({ left: 16, right: 16 })
              .margin({ top: 2 })
            }
            .width('100%')
            .alignItems(HorizontalAlign.Center)

            if (this.seekCardVisible) {
              Text(this.seekCardText)
                .fontSize(16)
                .fontColor($r('app.color.white'))
                .backgroundColor($r('app.color.seek_background_light'))
                .borderRadius(8)
                .padding({ left: 24, right: 24, top: 4, bottom: 4 })
                .margin({ bottom: 56 })
            }
          }
          .width('100%')
          .padding({ left: 8, right: 8 })

          FullPlayerControlRow({
            isPlaying: this.isPlaying,
            playbackSpeedLabel: this.playbackSpeedLabel,
            rewindSeconds: this.rewindSeconds,
            fastForwardSeconds: this.fastForwardSeconds,
            onSpeed: () => {
              episodeDetailViewModel.cyclePlaybackSpeed();
              this.syncFromVm();
            },
            onRewind: () => {
              episodeDetailViewModel.seekBy(-this.rewindSeconds);
              this.syncFromVm();
            },
            onPlay: () => {
              episodeDetailViewModel.togglePlay();
              this.syncFromVm();
            },
            onForward: () => {
              episodeDetailViewModel.seekBy(this.fastForwardSeconds);
              this.syncFromVm();
            },
            onSkip: () => {
              episodeDetailViewModel.seekTo(this.durationSec);
              this.syncFromVm();
              serviceLocator.playbackService().next(); this.syncFromVm();
            }
          })

          Row({ space: 16 }) {
            Button() {
              Image(this.isFavorite ? $r('app.media.ic_star') : $r('app.media.ic_star_border'))
                .width(24)
                .height(24)
                .fillColor(this.isFavorite
                  ? $r('app.color.accent_light') : $r('app.color.black'))
            }
            .type(ButtonType.Normal)
            .backgroundColor(Color.Transparent)
            .width(48)
            .height(48)
            .onClick(() => {
              episodeDetailViewModel.toggleFavorite();
              this.syncFromVm();
            })
            .accessibilityText(this.isFavorite
              ? $r('app.string.remove_from_favorite_label')
              : $r('app.string.add_to_favorite_label'))

            Button() {
              Image($r('app.media.ic_sleep'))
                .width(24)
                .height(24)
                .fillColor(this.sleepTimerEnabled
                  ? $r('app.color.accent_light') : $r('app.color.black'))
            }
            .type(ButtonType.Normal)
            .backgroundColor(Color.Transparent)
            .width(48)
            .height(48)
            .onClick(() => {
              episodeDetailViewModel.toggleSleepTimer();
              this.syncFromVm();
              try { promptAction.showToast({ message: 'Sleep timer not available in this build' }); } catch (e) { }
            })
            .accessibilityText($r('app.string.set_sleeptimer_label'))

            Button() {
              Image($r('app.media.ic_share'))
                .width(24)
                .height(24)
                .fillColor($r('app.color.black'))
            }
            .type(ButtonType.Normal)
            .backgroundColor(Color.Transparent)
            .width(48)
            .height(48)
            .onClick(() => {
              try { promptAction.showToast({ message: 'Sharing not available in this build' }); } catch (e) { }
            })
            .accessibilityText($r('app.string.share_label'))

            Button() {
              Image($r('app.media.ic_download'))
                .width(24)
                .height(24)
                .fillColor($r('app.color.black'))
            }
            .type(ButtonType.Normal)
            .backgroundColor(Color.Transparent)
            .width(48)
            .height(48)
            .onClick(() => this.confirmDownload())
            .accessibilityText($r('app.string.downloads_label'))

            Button() {
              Image($r('app.media.dots_vertical'))
                .width(24)
                .height(24)
                .fillColor($r('app.color.black'))
            }
            .type(ButtonType.Normal)
            .backgroundColor(Color.Transparent)
            .width(48)
            .height(48)
            .onClick(() => {
              this.contextMenuVisible = true;
            })
            .accessibilityText($r('app.string.overflow_more'))
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .padding({ top: 8, bottom: 24 })
        }
        .layoutWeight(1)
        .width('100%')
        .backgroundColor($r('app.color.background_light'))
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.background_light'))

      OverflowMenu({
        visible: this.overflowVisible,
        items: this.toolbarMenu,
        onSelect: (id: string) => this.handleToolbarMenu(id),
        onDismiss: () => {
          this.overflowVisible = false;
        }
      })

      EpisodeContextMenu({
        visible: this.contextMenuVisible,
        episode: this.episode,
        onSelect: (id: string) => this.handleContextAction(id),
        onDismiss: () => {
          this.contextMenuVisible = false;
        }
      })

      DownloadDialog({
        visible: this.downloadDialogVisible,
        title: 'Confirm mobile download',
        message: 'Downloading over mobile data connection is disabled in the settings. AntennaPod can download the episode later automatically when Wi-Fi is available.',
        onDownloadLater: () => this.onDownloadLater(),
        onDownloadAnyway: () => this.onDownloadAnyway(),
        onCancel: () => {
          this.downloadDialogVisible = false;
        }
      })
    }
    .width('100%')
    .height('100%')
  }
}

export default AudioPlayerPage;
