import { EpisodeData } from '../model/EpisodeData';

export interface EpisodeContextOption {
  id: string;
  label: string;
  enabled: boolean;
  destructive?: boolean;
}

@Component
export struct EpisodeContextMenu {
  @Prop visible: boolean = false;
  @ObjectLink episode: EpisodeData;
  onSelect: (id: string) => void = () => {};
  onDismiss: () => void = () => {};

  private buildOptions(): EpisodeContextOption[] {
    const isPlayed = this.episode.progress >= 100;
    const isInbox = this.episode.isInbox;
    const isFavorite = this.episode.isFavorite;
    const inQueue = this.episode.inQueue;
    const list: EpisodeContextOption[] = [];
    list.push({ id: 'mark_read', label: 'Mark as played', enabled: !isPlayed });
    list.push({ id: 'mark_unread', label: 'Mark as unplayed', enabled: isPlayed });
    list.push({ id: 'add_to_queue', label: 'Add to queue', enabled: !inQueue });
    list.push({ id: 'remove_from_queue', label: 'Remove from queue', enabled: inQueue });
    list.push({ id: 'remove_inbox', label: 'Remove from inbox', enabled: isInbox });
    list.push({ id: 'add_to_favorites', label: 'Add to favorites', enabled: !isFavorite });
    list.push({ id: 'remove_from_favorites', label: 'Remove from favorites', enabled: isFavorite });
    list.push({ id: 'reset_position', label: 'Reset playback position', enabled: true });
    list.push({ id: 'share', label: 'Share', enabled: true });
    list.push({ id: 'open_podcast', label: 'Open podcast', enabled: true });
    list.push({ id: 'multi_select', label: 'Multi select', enabled: true });
    list.push({ id: 'delete', label: 'Delete', enabled: true, destructive: true });
    return list;
  }

  build() {
    if (this.visible) {
      Stack({ alignContent: Alignment.Bottom }) {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor($r('app.color.image_readability_tint'))
          .onClick(() => this.onDismiss())

        Column() {
          Text(this.episode.title)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.black'))
            .width('100%')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({ bottom: 8 })

          Scroll() {
            Column() {
              ForEach(this.buildOptions(), (opt: EpisodeContextOption) => {
                Row() {
                  Text(opt.label)
                    .fontSize(16)
                    .fontColor(opt.destructive
                      ? $r('app.color.accent_light') : $r('app.color.black'))
                    .layoutWeight(1)
                }
                .width('100%')
                .height(48)
                .padding({ left: 8, right: 8 })
                .onClick(() => {
                  if (opt.enabled) {
                    this.onSelect(opt.id);
                  }
                })
                .enabled(opt.enabled)
                .opacity(opt.enabled ? 1 : 0.4)
              }, (opt: EpisodeContextOption) => opt.id)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }
          .layoutWeight(1)
          .scrollBar(BarState.Auto)

          Row({ space: 0 }) {
            Button($r('app.string.cancel_label'))
              .layoutWeight(1)
              .type(ButtonType.Normal)
              .backgroundColor(Color.Transparent)
              .fontSize(14)
              .fontColor($r('app.color.accent_light'))
              .onClick(() => this.onDismiss())
          }
          .width('100%')
          .height(52)
        }
        .width('100%')
        .height('60%')
        .padding({ left: 24, right: 24, top: 16, bottom: 8 })
        .backgroundColor($r('app.color.background_light'))
        .borderRadius({ topLeft: 16, topRight: 16 })
      }
      .width('100%')
      .height('100%')
    }
  }
}
