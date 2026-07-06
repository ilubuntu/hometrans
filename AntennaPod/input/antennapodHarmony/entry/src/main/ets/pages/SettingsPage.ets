import { router } from '@kit.ArkUI';
import { preferencesStore } from '../common/data/PreferencesStore';
import { AppToolbar } from '../components/AppToolbar';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct SettingsPage {
  @State bottomNavEnabled: boolean = false;
  @State showRemainingTime: boolean = false;
  @State playbackSpeed: number = 1.0;
  @State enqueuePosition: string = 'BACK';
  @State mobileDownloadPolicy: string = 'WIFI_ONLY';
  @State removeFromInboxDontAsk: boolean = false;

  aboutToAppear(): void {
    this.bottomNavEnabled = preferencesStore.getBooleanSync('bottomNavEnabled', true);
    this.showRemainingTime = preferencesStore.getBooleanSync('showRemainingTime', false);
    this.playbackSpeed = preferencesStore.getNumberSync('playbackSpeed', 1.0);
    this.enqueuePosition = preferencesStore.getSync('enqueuePosition', 'BACK');
    this.mobileDownloadPolicy = preferencesStore.getSync('mobileDownloadPolicy', 'WIFI_ONLY');
    this.removeFromInboxDontAsk = preferencesStore.getBooleanSync('removeFromInboxDontAsk', false);
  }

  private notAvailable(feature: string): void {
    try {
      promptAction.showToast({ message: `${feature} is not available in this build` });
    } catch (e) {
      // ignore
    }
  }

  @Builder
  SectionTitle(label: string) {
    Text(label)
      .fontSize(13)
      .fontColor($r('app.color.grey600'))
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 4 })
  }

  @Builder
  ToggleRow(label: string, value: boolean, onChange: (v: boolean) => void) {
    Row() {
      Text(label)
        .fontSize(15)
        .fontColor($r('app.color.black'))
        .layoutWeight(1)
      Toggle({ type: ToggleType.Switch, isOn: value })
        .onChange((v: boolean): void => onChange(v))
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
  }

  @Builder
  TextRow(label: string, value: string, onClick: () => void) {
    Row() {
      Text(label)
        .fontSize(15)
        .fontColor($r('app.color.black'))
        .layoutWeight(1)
      Text(value)
        .fontSize(14)
        .fontColor($r('app.color.grey600'))
      Image($r('app.media.ic_arrow_right_white'))
        .width(16)
        .height(16)
        .fillColor($r('app.color.grey600'))
        .margin({ left: 8 })
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 14, bottom: 14 })
    .onClick((): void => onClick())
  }

  build() {
    Stack() {
      Column() {
        AppToolbar({
          title: $r('app.string.settings_label'),
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
            this.SectionTitle('User interface')
            this.ToggleRow('Show bottom navigation', this.bottomNavEnabled, (v: boolean): void => {
              this.bottomNavEnabled = v;
              preferencesStore.putBoolean('bottomNavEnabled', v);
            })
            Divider().color($r('app.color.grey100')).strokeWidth(1)

            this.SectionTitle('Playback')
            this.TextRow('Playback speed', this.playbackSpeed.toFixed(2), (): void => {
              const next: number = this.playbackSpeed >= 2.0 ? 0.75
                : Math.round((this.playbackSpeed + 0.25) * 100) / 100;
              this.playbackSpeed = next;
              preferencesStore.putNumber('playbackSpeed', next);
            })
            Divider().color($r('app.color.grey100')).strokeWidth(1)
            this.ToggleRow('Show remaining time', this.showRemainingTime, (v: boolean): void => {
              this.showRemainingTime = v;
              preferencesStore.putBoolean('showRemainingTime', v);
            })
            Divider().color($r('app.color.grey100')).strokeWidth(1)

            this.SectionTitle('Queue')
            this.TextRow('Enqueue position', this.enqueuePosition === 'FRONT' ? 'Front' : 'Back', (): void => {
              const next: string = this.enqueuePosition === 'FRONT' ? 'BACK' : 'FRONT';
              this.enqueuePosition = next;
              preferencesStore.putString('enqueuePosition', next);
            })
            Divider().color($r('app.color.grey100')).strokeWidth(1)

            this.SectionTitle('Downloads')
            this.TextRow('Mobile download policy', this.mobileDownloadPolicy.replace(/_/g, ' ').toLowerCase(), (): void => {
              const next: string = this.mobileDownloadPolicy === 'WIFI_ONLY' ? 'ALWAYS_ASK' : 'WIFI_ONLY';
              this.mobileDownloadPolicy = next;
              preferencesStore.putString('mobileDownloadPolicy', next);
            })
            Divider().color($r('app.color.grey100')).strokeWidth(1)
            this.ToggleRow('Don\'t ask again before removing from inbox', this.removeFromInboxDontAsk, (v: boolean): void => {
              this.removeFromInboxDontAsk = v;
              preferencesStore.putBoolean('removeFromInboxDontAsk', v);
            })
            Divider().color($r('app.color.grey100')).strokeWidth(1)

            this.SectionTitle('Network & sync')
            this.TextRow('OPML import', 'Off', (): void => this.notAvailable('OPML import'))
            Divider().color($r('app.color.grey100')).strokeWidth(1)
            this.TextRow('OPML export', 'Off', (): void => this.notAvailable('OPML export'))
            Divider().color($r('app.color.grey100')).strokeWidth(1)
            this.TextRow('gpodder.net synchronization', 'Off', (): void => this.notAvailable('gpodder sync'))
            Divider().color($r('app.color.grey100')).strokeWidth(1)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
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

export default SettingsPage;
