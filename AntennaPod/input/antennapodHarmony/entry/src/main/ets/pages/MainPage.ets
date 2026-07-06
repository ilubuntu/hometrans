import { router, promptAction } from '@kit.ArkUI';
import { AppToolbar } from '../components/AppToolbar';
import { BottomNav } from '../components/BottomNav';
import { OverflowMenu } from '../components/OverflowMenu';
import { MiniPlayerBar } from '../components/MiniPlayerBar';
import { RefreshDialog } from '../components/RefreshDialog';
import { ConfigureHomeDialog } from '../components/ConfigureHomeDialog';
import { HomePage } from './HomePage';
import { QueuePage } from './QueuePage';
import { InboxPage } from './InboxPage';
import { SubscriptionsPage } from './SubscriptionsPage';
import { MorePage } from './MorePage';
import { OverflowMenuOption, HomeSectionOrderEntry, HomeSection, HomeSectionType } from '../model/HomeSection';
import { FeedData } from '../model/FeedData';
import { repository } from '../common/data/Repository';
import { preferencesStore } from '../common/data/PreferencesStore';
import { playbackController, PlaybackControllerImpl } from '../common/playback/PlaybackController';
import { eventBus, AppEvent } from '../common/event/EventBus';
import { queueViewModel } from '../viewmodel/QueueViewModel';

@Entry
@Component
struct MainPage {
  @State currentTab: number = 0;
  @State lastContentTab: number = 0;
  @State overflowVisible: boolean = false;
  @State refreshDialogVisible: boolean = false;
  @State configureDialogVisible: boolean = false;
  @State moreMenuVisible: boolean = false;
  @State inboxBadge: number = 0;
  @StorageLink('playback') playbackObj: PlaybackControllerImpl = playbackController;

  private moreMenu: OverflowMenuOption[] = [
    { id: 'episodes', label: $r('app.string.episodes_label'), enabled: true },
    { id: 'downloads', label: $r('app.string.downloads_label'), enabled: true },
    { id: 'playback_history', label: $r('app.string.playback_history_label'), enabled: true },
    { id: 'favorites', label: $r('app.string.favorite_episodes_label'), enabled: true },
    { id: 'statistics', label: $r('app.string.statistics_label'), enabled: true },
    { id: 'add_podcast', label: $r('app.string.add_feed_label'), enabled: true },
    { id: 'customize_navigation', label: 'Customize navigation', enabled: true },
    { id: 'settings', label: $r('app.string.settings_label'), enabled: true }
  ];
  private moreMenuIcons: Resource[] = [
    $r('app.media.ic_feed'),
    $r('app.media.ic_download'),
    $r('app.media.ic_history'),
    $r('app.media.ic_star'),
    $r('app.media.ic_chart_box'),
    $r('app.media.ic_add'),
    $r('app.media.ic_filter'),
    $r('app.media.ic_settings')
  ];

  private homeMenu: OverflowMenuOption[] = [
    { id: 'refresh', label: $r('app.string.refresh_label'), enabled: true },
    { id: 'configure_home', label: $r('app.string.configure_home'), enabled: true }
  ];
  private queueMenu: OverflowMenuOption[] = [
    { id: 'refresh', label: $r('app.string.refresh_label'), enabled: true },
    { id: 'queue_lock', label: $r('app.string.lock_queue'), enabled: true },
    { id: 'queue_sort', label: $r('app.string.sort'), enabled: true },
    { id: 'clear_queue', label: $r('app.string.clear_queue_label'), enabled: true }
  ];
  private inboxMenu: OverflowMenuOption[] = [
    { id: 'sort', label: $r('app.string.sort'), enabled: true },
    { id: 'refresh', label: $r('app.string.refresh_label'), enabled: true },
    { id: 'remove_all_inbox', label: $r('app.string.remove_all_inbox_label'), enabled: true }
  ];
  private subscriptionsMenu: OverflowMenuOption[] = [
    { id: 'sort', label: $r('app.string.sort'), enabled: true },
    { id: 'refresh', label: $r('app.string.refresh_label'), enabled: true }
  ];

  private shownSections: HomeSectionOrderEntry[] = [
    { label: 'Continue listening', hidden: false },
    { label: 'See what\'s new', hidden: false },
    { label: 'Get surprised', hidden: false },
    { label: 'Check your classics', hidden: false },
    { label: 'Manage downloads', hidden: false }
  ];
  private hiddenSections: HomeSectionOrderEntry[] = [];

  private playbackListener: (() => void) | null = null;
  private inboxListener: (() => void) | null = null;
  private repositoryListener: (() => void) | null = null;

  aboutToAppear(): void {
    const lastPage: number = preferencesStore.getNumberSync('lastPage', -1);
    if (lastPage >= 0 && lastPage < 4) {
      this.currentTab = lastPage;
      this.lastContentTab = lastPage;
    }
    this.refreshInboxBadge();
    if (this.inboxListener === null) {
      this.inboxListener = (): void => this.refreshInboxBadge();
      eventBus.on(AppEvent.INBOX_CHANGED, this.inboxListener);
    }
    if (this.repositoryListener === null) {
      this.repositoryListener = (): void => this.refreshInboxBadge();
      eventBus.on(AppEvent.REPOSITORY_READY, this.repositoryListener);
      eventBus.on(AppEvent.EPISODES_CHANGED, this.repositoryListener);
    }
    if (this.playbackListener === null) {
      this.playbackListener = (): void => {
        // StorageLink auto-refreshes; this listener just keeps the wiring explicit
      };
      eventBus.on(AppEvent.PLAYBACK_STATE_CHANGED, this.playbackListener);
    }
  }

  aboutToDisappear(): void {
    if (this.inboxListener !== null) {
      eventBus.off(AppEvent.INBOX_CHANGED, this.inboxListener);
      this.inboxListener = null;
    }
    if (this.repositoryListener !== null) {
      eventBus.off(AppEvent.REPOSITORY_READY, this.repositoryListener);
      eventBus.off(AppEvent.EPISODES_CHANGED, this.repositoryListener);
      this.repositoryListener = null;
    }
    if (this.playbackListener !== null) {
      eventBus.off(AppEvent.PLAYBACK_STATE_CHANGED, this.playbackListener);
      this.playbackListener = null;
    }
  }

  private refreshInboxBadge(): void {
    this.inboxBadge = repository.newEpisodeCount();
  }

  private selectTab(index: number): void {
    this.currentTab = index;
    this.lastContentTab = index;
    preferencesStore.putNumber('lastPage', index);
  }

  private refreshAllFeeds(): void {
    const feeds = repository.queryFeeds();
    for (let i = 0; i < feeds.length; i++) {
      repository.refreshFeed(feeds[i].id);
    }
  }

  private saveHomeSectionOrder(): void {
    const labels: string[] = [];
    for (let i = 0; i < this.shownSections.length; i++) {
      labels.push(this.shownSections[i].label);
    }
    for (let i = 0; i < this.hiddenSections.length; i++) {
      labels.push(this.hiddenSections[i].label);
    }
    preferencesStore.putObject('homeSectionOrder', labels.slice());
  }

  private currentMenu(): OverflowMenuOption[] {
    switch (this.currentTab) {
      case 0: return this.homeMenu;
      case 1: return this.queueMenu;
      case 2: return this.inboxMenu;
      case 3: return this.subscriptionsMenu;
      default: return this.homeMenu;
    }
  }

  private titleRes(): Resource {
    switch (this.currentTab) {
      case 0: return $r('app.string.home_label');
      case 1: return $r('app.string.queue_label');
      case 2: return $r('app.string.inbox_label');
      case 3: return $r('app.string.subscriptions_label');
      default: return $r('app.string.home_label');
    }
  }

  private handleOverflowSelect(id: string): void {
    this.overflowVisible = false;
    switch (id) {
      case 'refresh':
        this.refreshDialogVisible = true;
        break;
      case 'configure_home':
        this.configureDialogVisible = true;
        break;
      case 'sort':
        if (this.lastContentTab === 0) {
          this.configureDialogVisible = true;
        }
        break;
      case 'queue_lock':
        queueViewModel.toggleLock();
        break;
      case 'queue_sort':
        queueViewModel.sortQueue().then((): void => {
          // QUEUE_CHANGED event will refresh QueuePage; nothing else to do
        });
        break;
      case 'clear_queue':
        this.confirmClearQueue();
        break;
      case 'remove_all_inbox':
        this.confirmRemoveAllFromInbox();
        break;
      default:
        break;
    }
  }

  private confirmClearQueue(): void {
    try {
      promptAction.showDialog({
        title: $r('app.string.clear_queue_label'),
        message: 'Remove all episodes from the queue?',
        buttons: [
          { text: $r('app.string.cancel_label'), color: '#666666' },
          { text: $r('app.string.clear_queue_label'), color: '#F3682A' }
        ]
      }).then((result: promptAction.ShowDialogSuccessResponse): void => {
        if (result.index === 1) {
          queueViewModel.clearQueue();
        }
      });
    } catch (e) {
      // ignore dialog errors
    }
  }

  private confirmRemoveAllFromInbox(): void {
    const dontAsk: boolean = preferencesStore.getBooleanSync('removeFromInboxDontAsk', false);
    if (dontAsk) {
      repository.removeAllFromInbox();
      return;
    }
    try {
      promptAction.showDialog({
        title: $r('app.string.remove_all_inbox_label'),
        message: 'Remove all episodes from the inbox?',
        buttons: [
          { text: $r('app.string.cancel_label'), color: '#666666' },
          { text: $r('app.string.remove_all_inbox_label'), color: '#F3682A' }
        ]
      }).then((result: promptAction.ShowDialogSuccessResponse): void => {
        if (result.index === 1) {
          repository.removeAllFromInbox();
        }
      });
    } catch (e) {
      // ignore dialog errors
    }
  }

  private openFeedDetail(feedId: string): void {
    router.pushUrl({ url: 'pages/FeedDetailPage', params: { feedId: feedId } });
  }

  private handleMoreSelect(id: string): void {
    this.moreMenuVisible = false;
    switch (id) {
      case 'episodes':
        router.pushUrl({ url: 'pages/EpisodesPage' });
        break;
      case 'downloads':
        router.pushUrl({ url: 'pages/DownloadsPage' });
        break;
      case 'playback_history':
        router.pushUrl({ url: 'pages/PlaybackHistoryPage' });
        break;
      case 'favorites':
        router.pushUrl({ url: 'pages/FavoritesPage' });
        break;
      case 'statistics':
        router.pushUrl({ url: 'pages/StatisticsPage' });
        break;
      case 'add_podcast':
        router.pushUrl({ url: 'pages/AddFeedPage' });
        break;
      case 'customize_navigation':
        this.configureDialogVisible = true;
        break;
      case 'settings':
        router.pushUrl({ url: 'pages/SettingsPage' });
        break;
      default:
        break;
    }
  }

  @Builder
  TabContent() {
    if (this.currentTab === 0) {
      HomePage({
        onMoreSection: (section: HomeSection) => {
          if (section.type === HomeSectionType.CONTINUE_LISTENING) {
            this.selectTab(1);
          } else if (section.type === HomeSectionType.SEE_WHATS_NEW) {
            this.selectTab(2);
          } else if (section.type === HomeSectionType.GET_SURPRISED) {
            router.pushUrl({ url: 'pages/EpisodesPage' });
          } else if (section.type === HomeSectionType.CHECK_CLASSICS) {
            this.selectTab(3);
          } else if (section.type === HomeSectionType.MANAGE_DOWNLOADS) {
            router.pushUrl({ url: 'pages/DownloadsPage' });
          }
        }
      })
    } else if (this.currentTab === 1) {
      QueuePage()
    } else if (this.currentTab === 2) {
      InboxPage()
    } else if (this.currentTab === 3) {
      SubscriptionsPage({
        onItemClick: (feed: FeedData) => {
          this.openFeedDetail(feed.id);
        },
        onAddPodcast: () => {
          router.pushUrl({ url: 'pages/AddFeedPage' });
        }
      })
    } else {
      Column() {
        Text(this.titleRes())
          .fontSize(16)
          .fontColor($r('app.color.grey600'))
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor($r('app.color.background_light'))
    }
  }

  build() {
    Stack() {
      Column() {
        AppToolbar({
          title: this.titleRes(),
          showBack: false,
          showSearch: true,
          showOverflow: true,
          onSearch: () => {
            router.pushUrl({ url: 'pages/SearchPage' });
          },
          onMore: () => {
            this.overflowVisible = !this.overflowVisible;
          }
        })

        this.TabContent()

        MiniPlayerBar({
          title: this.playbackObj.hasEpisode ? this.playbackObj.title : 'Listener Tales 111: Camping Tales',
          author: this.playbackObj.hasEpisode ? this.playbackObj.author : 'Morbid',
          cover: this.playbackObj.hasEpisode ? this.playbackObj.cover : $r('app.media.ic_feed'),
          progress: this.playbackObj.hasEpisode ? this.playbackObj.progressPct : 47,
          isPlaying: this.playbackObj.isPlaying,
          onPlayClick: () => {
            this.playbackObj.togglePlay();
          },
          onBarClick: () => {
            if (this.playbackObj.hasEpisode) {
              router.pushUrl({
                url: 'pages/AudioPlayerPage',
                params: { episodeId: this.playbackObj.currentEpisodeId, episodeTitle: this.playbackObj.title }
              });
            } else {
              router.pushUrl({
                url: 'pages/AudioPlayerPage',
                params: { episodeId: 'feed_morbid_ep2', episodeTitle: 'Listener Tales 111: Camping Tales' }
              });
            }
          }
        })

        BottomNav({
          currentIndex: this.currentTab,
          inboxBadge: this.inboxBadge,
          onTabSelected: (index: number) => {
            if (index === 4) {
              this.moreMenuVisible = true;
            } else {
              this.selectTab(index);
            }
          }
        })
      }
      .width('100%')
      .height('100%')

      OverflowMenu({
        visible: this.overflowVisible,
        items: this.currentMenu(),
        onSelect: (id: string) => this.handleOverflowSelect(id),
        onDismiss: () => {
          this.overflowVisible = false;
        }
      })

      RefreshDialog({
        visible: this.refreshDialogVisible,
        onAlways: () => {
          this.refreshDialogVisible = false;
          preferencesStore.putString('mobileDownloadPolicy', 'ALWAYS');
          this.refreshAllFeeds();
        },
        onNo: () => {
          this.refreshDialogVisible = false;
        },
        onOnce: () => {
          this.refreshDialogVisible = false;
          this.refreshAllFeeds();
        }
      })

      ConfigureHomeDialog({
        visible: this.configureDialogVisible,
        shownSections: this.shownSections,
        hiddenSections: this.hiddenSections,
        onReset: () => {
          this.shownSections = [
            { label: 'Continue listening', hidden: false },
            { label: 'See what\'s new', hidden: false },
            { label: 'Get surprised', hidden: false },
            { label: 'Check your classics', hidden: false },
            { label: 'Manage downloads', hidden: false }
          ];
          this.hiddenSections = [];
          preferencesStore.remove('homeSectionOrder');
        },
        onCancel: () => {
          this.configureDialogVisible = false;
        },
        onOk: () => {
          this.configureDialogVisible = false;
          this.saveHomeSectionOrder();
        }
      })

      MorePage({
        visible: this.moreMenuVisible,
        items: this.moreMenu,
        itemIcons: this.moreMenuIcons,
        onSelect: (id: string) => this.handleMoreSelect(id),
        onDismiss: () => {
          this.moreMenuVisible = false;
        }
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_light'))
  }
}

export default MainPage;
