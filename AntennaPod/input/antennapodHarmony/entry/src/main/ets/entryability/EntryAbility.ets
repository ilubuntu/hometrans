import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { AppContext } from '../data/AppContext';
import { PodcastDatabase } from '../data/db/PodcastDatabase';
import { PreferencesStore } from '../data/prefs/PreferencesStore';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');

    // Bootstrap the data layer: register the app context, then open the single
    // relational store + preferences store. Fire-and-forget so the UI is never
    // blocked; errors are logged per the robustness contract (1.7).
    AppContext.init(this.context);
    this.bootData();
  }

  private async bootData(): Promise<void> {
    try {
      await PodcastDatabase.getInstance().getStore();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'PodcastDatabase ready');
    } catch (e) {
      hilog.error(DOMAIN, 'testTag', 'PodcastDatabase init failed: %{public}s', JSON.stringify(e));
    }
    try {
      await PreferencesStore.getInstance().getPreferences();
      hilog.info(DOMAIN, 'testTag', '%{public}s', 'PreferencesStore ready');
    } catch (e) {
      hilog.error(DOMAIN, 'testTag', 'PreferencesStore init failed: %{public}s', JSON.stringify(e));
    }
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
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
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}