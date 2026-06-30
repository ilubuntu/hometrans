import { ViewModelBase } from './ViewModelBase';

export interface MoreNavItem {
  icon: Resource;
  title: Resource;
  tag: string;
}

// "More" drawer ViewModel. Renders a fixed list of navigation entries sourced
// from resources. There is no domain event to subscribe to; the lifecycle hooks
// are provided so the page binds/unbinds uniformly with the other ViewModels.
export class MoreViewModel extends ViewModelBase {
  items: MoreNavItem[] = [];

  async onAppear(): Promise<void> {
    await super.onAppear();
    this.loadItems();
  }

  loadItems(): void {
    this.items = [
      {
        icon: $r('app.media.ic_feed_black'),
        title: $r('app.string.episodes_label'),
        tag: 'AllEpisodes'
      },
      {
        icon: $r('app.media.ic_refresh_black'),
        title: $r('app.string.downloads_label'),
        tag: 'CompletedDownloads'
      },
      {
        icon: $r('app.media.ic_refresh_black'),
        title: $r('app.string.playback_history_label'),
        tag: 'PlaybackHistory'
      },
      {
        icon: $r('app.media.ic_refresh_black'),
        title: $r('app.string.favorite_episodes_label'),
        tag: 'Favorites'
      },
      {
        icon: $r('app.media.ic_refresh_black'),
        title: $r('app.string.statistics_label'),
        tag: 'Statistics'
      },
      {
        icon: $r('app.media.ic_refresh_black'),
        title: $r('app.string.add_feed_label'),
        tag: 'AddFeed'
      },
      {
        icon: $r('app.media.ic_refresh_black'),
        title: $r('app.string.pref_nav_drawer_items_title'),
        tag: 'DrawerPreferences'
      },
      {
        icon: $r('app.media.ic_refresh_black'),
        title: $r('app.string.settings_label'),
        tag: 'Settings'
      }
    ];
    this.notify();
  }

  onItemClick(item: MoreNavItem): void {
    // Navigation to the target page is a UI-stage concern.
    console.info('MoreViewModel: navigate to ' + item.tag);
  }
}
