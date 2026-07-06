import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { repository } from '../common/data/Repository';
import { preferencesStore } from '../common/data/PreferencesStore';
import { eventBus, AppEvent } from '../common/event/EventBus';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
    preferencesStore.init(this.context).then((): Promise<void> => {
      return repository.init(this.context);
    }).then((): void => {
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'Repository initialized');
      // Notify pages so they can re-render after the async repository load completes.
      try {
        eventBus.emit(AppEvent.REPOSITORY_READY);
        eventBus.emit(AppEvent.FEEDS_CHANGED);
        eventBus.emit(AppEvent.EPISODES_CHANGED);
        eventBus.emit(AppEvent.INBOX_CHANGED);
      } catch (e) {
        hilog.error(DOMAIN, 'testTag', 'Repository ready emit failed: %{public}s', `${e}`);
      }
    }).catch((e: Error): void => {
      hilog.error(DOMAIN, 'testTag', 'Repository init failed: %{public}s', `${e}`);
      // Even on failure, broadcast ready so pages can render whatever data was seeded.
      try {
        eventBus.emit(AppEvent.REPOSITORY_READY);
      } catch (err) {
        // ignore
      }
    });
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
