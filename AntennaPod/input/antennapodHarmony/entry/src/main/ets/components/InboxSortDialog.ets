import { InboxSortOrder } from '../viewmodel/InboxViewModel';

class SortOption {
  order: InboxSortOrder = InboxSortOrder.DATE_NEW_OLD;
  label: string = '';
}

@CustomDialog
export struct InboxSortDialog {
  controller: CustomDialogController;
  selected: InboxSortOrder = InboxSortOrder.DATE_NEW_OLD;
  onConfirm: (order: InboxSortOrder) => void = () => {};
  private options: SortOption[] = [
    { order: InboxSortOrder.DATE_OLD_NEW, label: 'Date (oldest first)' } as SortOption,
    { order: InboxSortOrder.DATE_NEW_OLD, label: 'Date (newest first)' } as SortOption,
    { order: InboxSortOrder.DURATION_SHORT_LONG, label: 'Duration (shortest first)' } as SortOption,
    { order: InboxSortOrder.DURATION_LONG_SHORT, label: 'Duration (longest first)' } as SortOption,
  ];

  build() {
    Column() {
      Text($r('app.string.sort'))
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.black'))
        .width('100%')
        .padding({ top: 16, bottom: 8, left: 24, right: 24 })

      // Android InboxSortDialog only allows Date and Duration (each asc/desc)
      ForEach(this.options, (item: SortOption) => {
        Row() {
          Radio({ value: String(item.order), group: 'inboxSort' })
            .checked(this.selected === item.order)
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                this.selected = item.order;
              }
            })
            .width(20)
            .height(20)

          Text(item.label)
            .fontSize(15)
            .fontColor($r('app.color.black'))
            .margin({ left: 12 })
            .layoutWeight(1)
        }
        .width('100%')
        .height(48)
        .padding({ left: 24, right: 24 })
        .alignItems(VerticalAlign.Center)
        .onClick(() => {
          this.selected = item.order;
        })
      }, (item: SortOption) => String(item.order))

      Row() {
        Button($r('app.string.cancel_label'))
          .layoutWeight(1)
          .backgroundColor($r('app.color.background_light'))
          .fontColor($r('app.color.black'))
          .onClick(() => {
            this.controller.close();
          })

        Button($r('app.string.confirm_label'))
          .layoutWeight(1)
          .backgroundColor($r('app.color.accent_light'))
          .fontColor($r('app.color.white'))
          .onClick(() => {
            this.onConfirm(this.selected);
            this.controller.close();
          })
      }
      .width('100%')
      .padding({ top: 12, bottom: 12, left: 16, right: 16 })
    }
    .width('85%')
    .backgroundColor($r('app.color.background_elevated_light'))
    .borderRadius(16)
  }
}
