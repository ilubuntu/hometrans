import { router, promptAction } from '@kit.ArkUI';
import { EpisodeData, SecondaryActionType } from '../model/EpisodeData';
import { OverflowMenuOption } from '../model/HomeSection';
import { episodeDetailViewModel, ChapterItem } from '../viewmodel/EpisodeDetailViewModel';
import { AppToolbar } from '../components/AppToolbar';
import { OverflowMenu } from '../components/OverflowMenu';
import { EpisodeListItem } from '../components/EpisodeListItem';
import { EpisodeContextMenu } from '../components/EpisodeContextMenu';
import { DownloadDialog } from '../components/DownloadDialog';
import { BottomNav } from '../components/BottomNav';
import { serviceLocator } from '../common/service/ServiceLocator';

@Component
struct EpisodeCoverHeader {
  @ObjectLink episode: EpisodeData;
  @Prop podcastTitle: string = '';
  @Prop pubDate: string = '';
  onOpenPodcast: () => void = () => {};

  build() {
    Column() {
      Row() {
        Image(this.episode.cover)
          .width(56)
          .height(56)
          .borderRadius(8)
          .backgroundColor($r('app.color.non_square_icon_background'))
          .objectFit(ImageFit.Cover)
          .margin({ right: 16 })
          .onClick(() => this.onOpenPodcast())
          .accessibilityText($r('app.string.open_podcast'))

        Column() {
          Text(this.podcastTitle)
            .fontSize(13)
            .fontColor($r('app.color.text_color_secondary_light'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .textAlign(TextAlign.Start)
            .width('100%')
            .onClick(() => this.onOpenPodcast())
            .accessibilityText(`Podcast ${this.podcastTitle}`)

          Text(this.episode.title)
            .fontSize(16)
            .fontColor($r('app.color.black'))
            .maxLines(5)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .textAlign(TextAlign.Start)
            .width('100%')
            .margin({ top: 2 })

          Row() {
            if (this.episode.duration.length > 0) {
              Text(this.episode.duration)
                .fontSize(13)
                .fontColor($r('app.color.text_color_secondary_light'))
            }
            if (this.episode.duration.length > 0 && this.pubDate.length > 0) {
              Text(' · ')
                .fontSize(13)
                .fontColor($r('app.color.text_color_secondary_light'))
                .margin({ left: 4, right: 4 })
            }
            if (this.pubDate.length > 0) {
              Text(this.pubDate)
                .fontSize(13)
                .fontColor($r('app.color.text_color_secondary_light'))
            }
          }
          .width('100%')
          .margin({ top: 2 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
  }
}

@Component
struct PlayerControlRow {
  @Prop isPlaying: boolean = false;
  @Prop playbackSpeedLabel: string = '1.00';
  onSpeed: () => void = () => {};
  onRewind: () => void = () => {};
  onPlay: () => void = () => {};
  onForward: () => void = () => {};
  onSkip: () => void = () => {};

  build() {
    Row() {
      Column() {
        Image($r('app.media.ic_playback_speed'))
          .width(28)
          .height(28)
          .fillColor($r('app.color.black'))
        Text(this.playbackSpeedLabel)
          .fontSize(11)
          .fontColor($r('app.color.text_color_secondary_light'))
          .margin({ top: 2 })
      }
      .layoutWeight(1)
      .onClick(() => this.onSpeed())
      .accessibilityText($r('app.string.playback_speed'))

      Column() {
        Image($r('app.media.ic_fast_rewind'))
          .width(28)
          .height(28)
          .fillColor($r('app.color.black'))
        Text('30')
          .fontSize(11)
          .fontColor($r('app.color.text_color_secondary_light'))
          .margin({ top: 2 })
      }
      .layoutWeight(1)
      .onClick(() => this.onRewind())
      .accessibilityText($r('app.string.rewind_label'))

      Stack() {
        Image(this.isPlaying ? $r('app.media.ic_pause') : $r('app.media.ic_play_48dp'))
          .width(56)
          .height(56)
          .fillColor($r('app.color.accent_light'))
      }
      .layoutWeight(1.2)
      .height(64)
      .alignContent(Alignment.Center)
      .onClick(() => this.onPlay())
      .accessibilityText(this.isPlaying ? $r('app.string.pause_label') : $r('app.string.play_label'))

      Column() {
        Image($r('app.media.ic_fast_forward'))
          .width(28)
          .height(28)
          .fillColor($r('app.color.black'))
        Text('30')
          .fontSize(11)
          .fontColor($r('app.color.text_color_secondary_light'))
          .margin({ top: 2 })
      }
      .layoutWeight(1)
      .onClick(() => this.onForward())
      .accessibilityText($r('app.string.fast_forward_label'))

      Column() {
        Image($r('app.media.ic_skip_48dp'))
          .width(28)
          .height(28)
          .fillColor($r('app.color.black'))
      }
      .layoutWeight(1)
      .onClick(() => this.onSkip())
      .accessibilityText($r('app.string.skip_episode_label'))
    }
    .width('100%')
    .height(72)
    .margin({ top: 8 })
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceAround)
  }
}

@Entry
@Component
struct EpisodeDetailPage {
  @State episode: EpisodeData = new EpisodeData('feed_morbid_ep2', 'Listener Tales 111: Camping Tales');
  @State title: string = '';
  @State podcastTitle: string = '';
  @State podcastAuthor: string = '';
  @State feedId: string = '';
  @State pubDate: string = '';
  @State cover: Resource = $r('app.media.ic_feed');
  @State shownotes: string = '';
  @State chapters: ChapterItem[] = [];
  @State relatedEpisodes: EpisodeData[] = [];
  @State relatedFeedIds: string[] = [];

  @State positionLabel: string = '00:00';
  @State durationLabel: string = '00:00';
  @State durationDesc: string = '';
  @State progressPct: number = 0;
  @State positionSec: number = 0;
  @State durationSec: number = 0;
  @State playbackSpeedLabel: string = '1.00';
  @State isPlaying: boolean = false;
  @State isFavorite: boolean = false;
  @State inQueue: boolean = false;
  @State sleepTimerEnabled: boolean = false;
  @State websiteUrl: string = '';

  @State descExpanded: boolean = false;
  @State chaptersExpanded: boolean = false;
  @State overflowVisible: boolean = false;
  @State contextMenuVisible: boolean = false;
  @State downloadDialogVisible: boolean = false;
  @State bottomTab: number = -1;
  @State contextEpisode: EpisodeData = new EpisodeData('feed_morbid_ep2', 'Listener Tales 111: Camping Tales');

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
      console.info(`EpisodeDetailPage: fallback to default episode (${e})`);
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
    this.podcastAuthor = episodeDetailViewModel.podcastAuthor;
    this.feedId = episodeDetailViewModel.feedId;
    this.pubDate = episodeDetailViewModel.pubDate;
    this.cover = episodeDetailViewModel.cover;
    this.shownotes = episodeDetailViewModel.shownotes;
    this.chapters = episodeDetailViewModel.chapters.slice();
    this.relatedEpisodes = episodeDetailViewModel.relatedEpisodes.slice();
    this.relatedFeedIds = episodeDetailViewModel.relatedFeedIds.slice();
    this.positionLabel = episodeDetailViewModel.positionLabel;
    this.durationLabel = episodeDetailViewModel.durationLabel;
    this.durationDesc = episodeDetailViewModel.durationDesc;
    this.progressPct = episodeDetailViewModel.progressPct;
    this.positionSec = episodeDetailViewModel.positionSec;
    this.durationSec = episodeDetailViewModel.durationSec;
    this.playbackSpeedLabel = episodeDetailViewModel.playbackSpeedLabel;
    this.isPlaying = episodeDetailViewModel.isPlaying;
    this.isFavorite = episodeDetailViewModel.isFavorite;
    this.inQueue = episodeDetailViewModel.inQueue;
    this.sleepTimerEnabled = episodeDetailViewModel.sleepTimerEnabled;
    this.websiteUrl = episodeDetailViewModel.websiteUrl;
    this.contextEpisode = this.episode;
  }

  private buildEpisodeProxy(): EpisodeData {
    const ep = new EpisodeData(episodeDetailViewModel.episodeId, episodeDetailViewModel.title);
    ep.cover = episodeDetailViewModel.cover;
    ep.author = episodeDetailViewModel.podcastTitle;
    ep.pubDate = episodeDetailViewModel.pubDate;
    ep.pubDateDesc = episodeDetailViewModel.pubDate;
    ep.duration = episodeDetailViewModel.durationLabel;
    ep.durationDesc = episodeDetailViewModel.durationDesc;
    ep.position = episodeDetailViewModel.positionLabel;
    ep.positionDesc = episodeDetailViewModel.durationDesc;
    ep.progress = episodeDetailViewModel.progressPct;
    ep.isInbox = episodeDetailViewModel.isInbox;
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
        episodeDetailViewModel.togglePlayed();
        break;
      case 'mark_unread':
        episodeDetailViewModel.togglePlayed();
        break;
      case 'add_to_queue':
        episodeDetailViewModel.toggleQueue();
        break;
      case 'remove_from_queue':
        episodeDetailViewModel.toggleQueue();
        break;
      case 'remove_inbox':
        episodeDetailViewModel.removeFromInbox();
        break;
      case 'add_to_favorites':
        episodeDetailViewModel.toggleFavorite();
        break;
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
      case 'multi_select':
        
        break;
      case 'delete':
        episodeDetailViewModel.deleteDownload();
        break;
      default:
        
    }
    this.syncFromVm();
  }

  private onSeekBarChange(value: number, mode: SliderChangeMode): void {
    if (mode === SliderChangeMode.End || mode === SliderChangeMode.Click) {
      const targetSec = Math.floor((value / 100) * this.durationSec);
      episodeDetailViewModel.seekTo(targetSec);
      this.syncFromVm();
    }
  }

  private openPodcast(): void {
    router.pushUrl({
      url: 'pages/FeedDetailPage',
      params: { feedId: this.feedId }
    });
  }

  private openRelatedEpisode(ep: EpisodeData): void {
    router.pushUrl({
      url: 'pages/EpisodeDetailPage',
      params: { episodeId: ep.id, episodeTitle: ep.title }
    });
  }

  private openRelatedFeed(feedId: string): void {
    router.pushUrl({
      url: 'pages/FeedDetailPage',
      params: { feedId: feedId }
    });
  }

  private confirmDownload(): void {
    this.downloadDialogVisible = true;
  }

  private onDownloadLater(): void {
    this.downloadDialogVisible = false;
    episodeDetailViewModel.startDownload();
  }

  private onDownloadAnyway(): void {
    this.downloadDialogVisible = false;
    episodeDetailViewModel.startDownload();
  }

  build() {
    Stack() {
      Column() {
        AppToolbar({
          title: this.podcastTitle.length > 0 ? this.podcastTitle : $r('app.string.episodes_label'),
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

        Scroll() {
          Column() {
            EpisodeCoverHeader({
              episode: this.episode,
              podcastTitle: this.podcastTitle,
              pubDate: this.pubDate,
              onOpenPodcast: () => this.openPodcast()
            })

            Row() {
              Row() {
                Image($r('app.media.ic_stream'))
                  .width(24)
                  .height(24)
                  .fillColor($r('app.color.black'))
                  .margin({ right: 8 })
                Text($r('app.string.stream_label'))
                  .fontSize(14)
                  .fontColor($r('app.color.black'))
              }
              .layoutWeight(1)
              .height(48)
              .justifyContent(FlexAlign.Center)
              .onClick(() => {
                serviceLocator.playbackService().play(this.episode.id); episodeDetailViewModel.togglePlay(); this.syncFromVm();
              })
              .accessibilityText($r('app.string.stream_label'))

              Row() {
                Image($r('app.media.ic_download'))
                  .width(24)
                  .height(24)
                  .fillColor($r('app.color.black'))
                  .margin({ right: 8 })
                Text($r('app.string.download_label'))
                  .fontSize(14)
                  .fontColor($r('app.color.black'))
              }
              .layoutWeight(1)
              .height(48)
              .justifyContent(FlexAlign.Center)
              .onClick(() => this.confirmDownload())
              .accessibilityText($r('app.string.download_label'))
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceAround)
            .alignItems(VerticalAlign.Center)

            Divider()
              .color($r('app.color.grey100'))
              .strokeWidth(1)
              .width('100%')

            Row({ space: 8 }) {
              Row() {
                Image($r('app.media.ic_info'))
                  .width(20)
                  .height(20)
                  .fillColor($r('app.color.text_color_secondary_light'))
                Text(this.descExpanded ? $r('app.string.close_label') : $r('app.string.shownotes_label'))
                  .fontSize(14)
                  .fontColor($r('app.color.text_color_secondary_light'))
                  .margin({ left: 6 })
              }
              .layoutWeight(1)
              .height(40)
              .justifyContent(FlexAlign.Center)
              .border({ width: 1, color: $r('app.color.grey600') })
              .borderRadius(20)
              .onClick(() => {
                this.descExpanded = !this.descExpanded;
              })
              .accessibilityText($r('app.string.shownotes_contentdescription'))

              if (this.chapters.length > 0) {
                Row() {
                  Image($r('app.media.ic_chapter_prev'))
                    .width(20)
                    .height(20)
                    .fillColor($r('app.color.text_color_secondary_light'))
                  Text($r('app.string.chapters_label'))
                    .fontSize(14)
                    .fontColor($r('app.color.text_color_secondary_light'))
                    .margin({ left: 6, right: 6 })
                  Image($r('app.media.ic_chapter_next'))
                    .width(20)
                    .height(20)
                    .fillColor($r('app.color.text_color_secondary_light'))
                }
                .layoutWeight(1)
                .height(40)
                .justifyContent(FlexAlign.Center)
                .border({ width: 1, color: $r('app.color.grey600') })
                .borderRadius(20)
                .onClick(() => {
                  this.chaptersExpanded = !this.chaptersExpanded;
                })
                .accessibilityText($r('app.string.chapters_label'))
              }
            }
            .width('100%')
            .margin({ top: 4, bottom: 12 })

            if (this.descExpanded && this.shownotes.length > 0) {
              Text(this.shownotes)
                .fontSize(14)
                .fontColor($r('app.color.black'))
                .lineHeight(22)
                .width('100%')
                .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                .backgroundColor($r('app.color.background_elevated_light'))
            }

            if (this.chaptersExpanded && this.chapters.length > 0) {
              Column() {
                ForEach(this.chapters, (ch: ChapterItem) => {
                  Row() {
                    Text(ch.title)
                      .fontSize(14)
                      .fontColor($r('app.color.black'))
                      .layoutWeight(1)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                    Text(this.formatChapterTime(ch.startSec))
                      .fontSize(12)
                      .fontColor($r('app.color.text_color_secondary_light'))
                  }
                  .width('100%')
                  .height(40)
                  .padding({ left: 8, right: 8 })
                  .onClick(() => {
                    episodeDetailViewModel.seekTo(ch.startSec);
                    this.syncFromVm();
                  })
                }, (ch: ChapterItem) => `${ch.index}`)
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 4, bottom: 8 })
              .backgroundColor($r('app.color.background_elevated_light'))
              .margin({ bottom: 8 })
            }

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
                .accessibilityText(this.durationDesc)
            }
            .width('100%')
            .padding({ left: 16, right: 16 })
            .margin({ bottom: 4 })

            PlayerControlRow({
              isPlaying: this.isPlaying,
              playbackSpeedLabel: this.playbackSpeedLabel,
              onSpeed: () => {
                episodeDetailViewModel.cyclePlaybackSpeed();
                this.syncFromVm();
              },
              onRewind: () => {
                episodeDetailViewModel.seekBy(-30);
                this.syncFromVm();
              },
              onPlay: () => {
                episodeDetailViewModel.togglePlay();
                this.syncFromVm();
              },
              onForward: () => {
                episodeDetailViewModel.seekBy(30);
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
                  .width(20)
                  .height(20)
                  .fillColor(this.isFavorite
                    ? $r('app.color.accent_light') : $r('app.color.black'))
              }
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .width(44)
              .height(44)
              .onClick(() => {
                episodeDetailViewModel.toggleFavorite();
                this.syncFromVm();
              })
              .accessibilityText(this.isFavorite
                ? $r('app.string.remove_from_favorite_label')
                : $r('app.string.add_to_favorite_label'))

              Button() {
                Image($r('app.media.ic_sleep'))
                  .width(20)
                  .height(20)
                  .fillColor(this.sleepTimerEnabled
                    ? $r('app.color.accent_light') : $r('app.color.black'))
              }
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .width(44)
              .height(44)
              .onClick(() => {
                episodeDetailViewModel.toggleSleepTimer();
                this.syncFromVm();
                episodeDetailViewModel.toggleSleepTimer(); this.syncFromVm();
              })
              .accessibilityText($r('app.string.set_sleeptimer_label'))

              Button() {
                Image($r('app.media.ic_share'))
                  .width(20)
                  .height(20)
                  .fillColor($r('app.color.black'))
              }
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .width(44)
              .height(44)
              .onClick(() => {
                try { promptAction.showToast({ message: 'Sharing not available in this build' }); } catch (e) { }
              })
              .accessibilityText($r('app.string.share_label'))

              Button() {
                Image($r('app.media.ic_download'))
                  .width(20)
                  .height(20)
                  .fillColor($r('app.color.black'))
              }
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .width(44)
              .height(44)
              .onClick(() => this.confirmDownload())
              .accessibilityText($r('app.string.downloads_label'))

              Button() {
                Image($r('app.media.dots_vertical'))
                  .width(20)
                  .height(20)
                  .fillColor($r('app.color.black'))
              }
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .width(44)
              .height(44)
              .onClick(() => {
                this.contextMenuVisible = true;
              })
              .accessibilityText('More options')
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
            .padding({ top: 8, bottom: 16 })

            if (this.relatedEpisodes.length > 0) {
              Column() {
                Text($r('app.string.episodes_label'))
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('app.color.black'))
                  .margin({ bottom: 8 })
                ForEach(this.relatedEpisodes, (ep: EpisodeData) => {
                  EpisodeListItem({
                    episode: ep,
                    showDragHandle: false,
                    onItemClick: (item: EpisodeData) => this.openRelatedEpisode(item),
                    onSecondaryAction: (item: EpisodeData) => {
                      this.openRelatedEpisode(item);
                    },
                    onLongPress: (item: EpisodeData) => {
                      this.contextEpisode = item;
                      this.contextMenuVisible = true;
                    }
                  })
                }, (ep: EpisodeData) => ep.id)
              }
              .width('100%')
              .padding({ left: 12, right: 12, top: 8, bottom: 8 })
            }

            if (this.relatedFeedIds.length > 0) {
              Column() {
                Text($r('app.string.subscriptions_label'))
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('app.color.black'))
                  .margin({ bottom: 8 })
                Scroll() {
                  Row({ space: 12 }) {
                    ForEach(this.relatedFeedIds, (feedId: string) => {
                      Image(this.coverForFeed(feedId))
                        .width(96)
                        .height(96)
                        .borderRadius(8)
                        .backgroundColor($r('app.color.non_square_icon_background'))
                        .objectFit(ImageFit.Cover)
                        .onClick(() => this.openRelatedFeed(feedId))
                        .accessibilityText(`Open feed ${feedId}`)
                    }, (feedId: string) => feedId)
                  }
                  .padding({ left: 4, right: 4 })
                }
                .scrollable(ScrollDirection.Horizontal)
                .scrollBar(BarState.Off)
                .width('100%')
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 8, bottom: 16 })
            }
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
        }
        .layoutWeight(1)
        .scrollBar(BarState.Auto)
        .backgroundColor($r('app.color.background_light'))

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
        episode: this.contextEpisode,
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

  private formatChapterTime(sec: number): string {
    if (sec <= 0) {
      return '00:00';
    }
    const m = Math.floor(sec / 60);
    const s = sec % 60;
    const ss = s < 10 ? `0${s}` : `${s}`;
    if (m >= 60) {
      const h = Math.floor(m / 60);
      const mm = m % 60;
      return `${h}:${mm < 10 ? '0' + mm : mm}:${ss}`;
    }
    return `${m}:${ss}`;
  }

  private coverForFeed(feedId: string): Resource {
    if (feedId === 'feed_crimejunkie' || feedId === 'feed_megyn') {
      return $r('app.media.ic_feed_black');
    }
    if (feedId === 'feed_goodhang') {
      return $r('app.media.ic_shortcut_feed');
    }
    return $r('app.media.ic_feed');
  }
}

export default EpisodeDetailPage;
