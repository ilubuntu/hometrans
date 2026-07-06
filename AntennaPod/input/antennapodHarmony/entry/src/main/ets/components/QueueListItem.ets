import { EpisodeData } from '../model/EpisodeData';
import { EpisodeListItem } from './EpisodeListItem';

@Component
export struct QueueListItem {
  @ObjectLink episode: EpisodeData;
  @Prop showDragHandle: boolean = true;
  onItemClick: (episode: EpisodeData) => void = () => {};
  onSecondaryAction: (episode: EpisodeData) => void = () => {};
  onLongPress: (episode: EpisodeData) => void = () => {};
  onDragReorder: (from: number, to: number) => void = () => {};

  build() {
    Row() {
      EpisodeListItem({
        episode: this.episode,
        showDragHandle: this.showDragHandle,
        onItemClick: this.onItemClick,
        onSecondaryAction: this.onSecondaryAction,
        onLongPress: this.onLongPress
      })
        .layoutWeight(1)
    }
    .width('100%')
    .backgroundColor($r('app.color.background_light'))
  }
}
