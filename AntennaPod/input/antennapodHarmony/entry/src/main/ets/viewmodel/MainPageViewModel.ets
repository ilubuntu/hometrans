export class MainPageViewModel {
  currentTabIndex: number = 0;
  overflowMenuVisible: boolean = false;
  refreshDialogVisible: boolean = false;
  configureDialogVisible: boolean = false;
  miniPlayerVisible: boolean = true;

  titleForTab(index: number): Resource {
    switch (index) {
      case 0: return $r('app.string.home_label');
      case 1: return $r('app.string.queue_label');
      case 2: return $r('app.string.inbox_label');
      case 3: return $r('app.string.subscriptions_label');
      case 4: return $r('app.string.overflow_more');
      default: return $r('app.string.home_label');
    }
  }

  selectTab(index: number): void {
    this.currentTabIndex = index;
  }
}

export const mainPageViewModel = new MainPageViewModel();
