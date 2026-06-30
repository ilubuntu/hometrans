import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN: number = 0x0000;
const TAG: string = 'AppContext';

// Holds the application-level Context that repositories need in order to open
// the relational store and the preferences store. Initialized exactly once in
// EntryAbility.onCreate BEFORE any repository is used. Repositories obtain the
// context from here so ViewModels never have to thread a Context through.
export class AppContext {
  private static context: common.Context | null = null;

  static init(context: common.Context): void {
    if (AppContext.context === null) {
      AppContext.context = context;
    }
  }

  static get(): common.Context {
    if (AppContext.context === null) {
      hilog.error(DOMAIN, TAG, 'AppContext.get() called before init()');
      throw new Error('AppContext is not initialized');
    }
    return AppContext.context;
  }

  static isInitialized(): boolean {
    return AppContext.context !== null;
  }
}
