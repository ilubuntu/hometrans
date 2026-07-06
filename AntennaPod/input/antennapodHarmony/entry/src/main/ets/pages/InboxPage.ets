import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { EpisodeData, DownloadState } from '../model/EpisodeData';
import { inboxViewModel } from '../viewmodel/InboxViewModel';
import { repository } from '../common/data/Repository';
import { EpisodeListItem } from '../components/EpisodeListItem';
import { EpisodeContextMenu } from '../components/EpisodeContextMenu';
import { eventBus, AppEvent } from '../common/event/EventBus';

@Component
export struct InboxPage {
  @State episodes: EpisodeData[] = [];
  @State contextMenuVisible: boolean = false;
  @State contextEpisode: EpisodeData = new EpisodeData('_placeholder', '');
  @State undoBarVisible: boolean = false;
  private pendingUndoEpisode: EpisodeData = new EpisodeData('_none', '');
  private undoTimerId: number = -1;
  private listener: () => void = (): void => {
    inboxViewModel.reload();
    this.episodes = inboxViewModel.episodes.slice();
  };

  aboutToAppear(): void {
    inboxViewModel.load();
    this.episodes = inboxViewModel.episodes.slice();
    eventBus.on(AppEvent.INBOX_CHANGED, this.listener);
  }

  aboutToDisappear(): void {
    eventBus.off(AppEvent.INBOX_CHANGED, this.listener);
    if (this.undoTimerId !== -1) {
      clearTimeout(this.undoTimerId);
      this.undoTimerId = -1;
    }
  }

  private syncFromVm(): void {
    inboxViewModel.reload();
    this.episodes = inboxViewModel.episodes.slice();
  }

  private performRemoveWithUndo(episode: EpisodeData): void {
    this.pendingUndoEpisode = episode;
    inboxViewModel.removeFromInbox(episode);
    this.undoBarVisible = true;
    if (this.undoTimerId !== -1) {
      clearTimeout(this.undoTimerId);
    }
    this.undoTimerId = setTimeout((): void => {
      this.undoBarVisible = false;
      this.pendingUndoEpisode = new EpisodeData('_none', '');
      this.undoTimerId = -1;
    }, 2000);
  }

  private performUndo(): void {
    if (this.undoTimerId !== -1) {
      clearTimeout(this.undoTimerId);
      this.undoTimerId = -1;
    }
    if (this.pendingUndoEpisode.id.length > 0 && this.pendingUndoEpisode.id !== '_none') {
      inboxViewModel.restoreToInbox(this.pendingUndoEpisode);
    }
    this.undoBarVisible = false;
    this.pendingUndoEpisode = new EpisodeData('_none', '');
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
      if (this.episodes.length === 0) {
        Column() {
          Image($r('app.media.ic_inbox'))
            .width(72)
            .height(72)
            .fillColor($r('app.color.grey600'))
            .margin({ bottom: 12 })
          Text($r('app.string.no_inbox_head_label'))
            .fontSize(18)
            .fontColor($r('app.color.black'))
            .margin({ bottom: 4 })
          Text($r('app.string.home_new_empty_text'))
            .fontSize(14)
            .fontColor($r('app.color.grey600'))
            .textAlign(TextAlign.Center)
            .padding({ left: 32, right: 32 })
        }
        .width('100%')
        .height('100%')
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
                  inboxViewModel.toggleSecondaryAction(ep);
                },
                onLongPress: (ep: EpisodeData) => {
                  this.openEpisodeContextMenu(ep);
                }
              })
            }
            .swipeAction({
              end: {
                builder: () => {
                  this.SwipeRemoveFromInbox(episode)
                },
                actionAreaDistance: 80,
                onAction: () => {
                  this.performRemoveWithUndo(episode);
                }
              }
            })
          }, (episode: EpisodeData) => episode.id)
        }
        .width('100%')
        .height('100%')
        .divider({ strokeWidth: 1, color: $r('app.color.grey100'), startMargin: 88, endMargin: 16 })
        .padding({ left: 12, right: 0 })
        .backgroundColor($r('app.color.background_light'))
        .scrollBar(BarState.Auto)
      }

      EpisodeContextMenu({
        visible: this.contextMenuVisible,
        episode: this.contextEpisode,
        onSelect: (id: string) => {
          this.contextMenuVisible = false;
          switch (id) {
            case 'mark_read':
            case 'mark_unread':
              inboxViewModel.markPlayed(this.contextEpisode);
              break;
            case 'add_to_queue':
            case 'remove_from_queue':
              if (this.contextEpisode.inQueue) {
                repository.dequeue(this.contextEpisode.id);
              } else {
                repository.enqueue(this.contextEpisode.id);
              }
              this.syncFromVm();
              break;
            case 'add_to_favorites':
            case 'remove_from_favorites':
              repository.setFavorite(this.contextEpisode.id, !this.contextEpisode.isFavorite);
              this.syncFromVm();
              break;
            case 'remove_inbox':
              inboxViewModel.removeFromInbox(this.contextEpisode);
              break;
            case 'reset_position':
              repository.resetPosition(this.contextEpisode.id);
              this.syncFromVm();
              break;
            case 'delete':
              repository.setDownloadState(this.contextEpisode.id, DownloadState.NONE, 0);
              this.syncFromVm();
              break;
            case 'share':
              try {
                promptAction.showToast({ message: 'Sharing not available in this build' });
              } catch (e) {
                // ignore
              }
              break;
            case 'open_podcast':
              this.contextMenuVisible = false;
              router.pushUrl({
                url: 'pages/FeedDetailPage',
                params: { feedId: this.contextEpisode.feedId }
              });
              break;
            default:
              break;
          }
          this.syncFromVm();
        },
        onDismiss: () => {
          this.contextMenuVisible = false;
        }
      })

      if (this.undoBarVisible) {
        Stack({ alignContent: Alignment.Bottom }) {
          Row() {
            Text($r('app.string.removed_from_inbox_message'))
              .fontSize(14)
              .fontColor($r('app.color.white'))
              .layoutWeight(1)
            Button($r('app.string.undo'))
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .fontSize(14)
              .fontColor($r('app.color.accent_light'))
              .onClick(() => this.performUndo())
          }
          .width('100%')
          .backgroundColor($r('app.color.grey600'))
          .padding({ left: 16, right: 16, top: 14, bottom: 14 })
        }
        .width('100%')
        .height('100%')
        .hitTestBehavior(HitTestMode.Transparent)
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  SwipeRemoveFromInbox(episode: EpisodeData) {
    Button() {
      Image($r('app.media.ic_inbox'))
        .width(24)
        .height(24)
        .fillColor($r('app.color.white'))
    }
    .type(ButtonType.Normal)
    .backgroundColor($r('app.color.accent_light'))
    .height('100%')
    .width(80)
    .onClick(() => {
      this.performRemoveWithUndo(episode);
    })
    .accessibilityText($r('app.string.remove_inbox_label'))
  }
}
