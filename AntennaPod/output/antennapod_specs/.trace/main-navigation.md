# Trace: REQ-002 主导航结构

## 关联需求
REQ-002: 应用应保留 AntennaPod 的主要导航结构，包括 Home、Queue、Episodes、Subscriptions、Downloads、Playback History、Favorites、Settings 等入口。底部导航或侧边导航的选中状态应和当前页面一致。

## 代码溯源

### 1. 导航入口定义
- **NavigationNames.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/drawer/NavigationNames.java:16`)
  - 集中定义所有导航标签的图标和文本。
  - `getDrawable(tag)` (NavigationNames.java:18): 返回导航项图标资源。
    - HomeFragment.TAG → ic_home
    - QueueFragment.TAG → ic_playlist_play
    - InboxFragment.TAG → ic_inbox
    - AllEpisodesFragment.TAG → ic_feed
    - CompletedDownloadsFragment.TAG → ic_download
    - PlaybackHistoryFragment.TAG → ic_history
    - SubscriptionFragment.TAG → ic_subscriptions
    - StatisticsFragment.TAG → ic_chart_box
    - AddFeedFragment.TAG → ic_add
    - FavoritesFragment.TAG → ic_star
  - `getLabel(tag)` (NavigationNames.java:44): 返回导航项显示文本。
  - `getShortLabel(tag)` (NavigationNames.java:72): 返回底部导航用的短文本。
  - `getBottomNavigationItemId(tag)` (NavigationNames.java:102): 标签 → 底部导航项ID映射。
  - `getBottomNavigationFragmentTag(id)` (NavigationNames.java:128): 底部导航项ID → 标签映射。

### 2. 底部导航
- **BottomNavigation.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/drawer/BottomNavigation.java:32`)
  - `showBottomNavigationMorePopup()` (BottomNavigation.java:95): 显示溢出导航项弹窗（当导航项超出底部栏容量时）。
  - 底部导航项选中时触发页面切换。
  - 通过 `UserPreferences.isBottomNavigationEnabled()` 控制是否启用底部导航模式。

### 3. 侧边导航抽屉
- **NavDrawerFragment.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/drawer/NavDrawerFragment.java:74`)
  - 侧边导航面板，包含固定导航项 + 订阅列表。
  - `onItemClick()`: 导航项点击 → 切换页面。
  - `loadData()` (NavDrawerFragment.java): 加载导航数据（订阅列表、计数等）。
  - `makeFlatDrawerData()`: 构建扁平化的抽屉数据（导航项 + 标签 + 订阅）。
  - `feedCounter()`: 显示每个订阅的新单集计数。
  - `saveLastNavFragment()` / `getLastNavFragment()`: 记住最后访问的页面。
  - `isSelected()`: 判断当前选中状态。
  - 计数方法：`getNumberOfNewItems()`, `getNumberOfDownloadedItems()`, `getQueueSize()`, `getReclaimableItems()`, `getFeedCounterSum()`.
  - `onSharedPreferenceChanged()`: 偏好变化时刷新导航（如过滤设置变更）。

### 4. 导航路由
- **MainActivity.java** (`app/src/main/java/de/danoeh/antennapod/activity/MainActivity.java:100`)
  - `loadFragment(tag)` (MainActivity.java:492): 统一页面加载入口。
    - 加载页面组件，更新标题，同步导航选中状态。
  - `onItemSelected()`: 底部导航选中回调。
  - 页面切换时保存 last nav fragment，下次启动恢复。

### 5. 溢出导航项
- **BottomNavigationMoreAdapter.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/drawer/BottomNavigationMoreAdapter.java:13`)
  - 底部导航"更多"弹窗的适配器，列出无法在底部栏直接显示的导航项。

### 6. 导航模式切换
- `UserPreferences.isBottomNavigationEnabled()` / `setBottomNavigationEnabled()` (UserPreferences.java:782):
  - 用户可在界面设置中切换底部导航 / 侧边导航。
  - 切换后导航结构重建。

## 关键发现
1. 导航入口共 10 个：Home、Queue、Inbox、Episodes、Subscriptions、Downloads、Playback History、Favorites、Statistics、Add Feed，加上 Settings（通过菜单或溢出项进入）。
2. 底部导航有容量限制，超出项折叠到"更多"弹窗。
3. 导航选中状态通过 `isSelected()` + `saveLastNavFragment()` 维持一致性。
4. 订阅列表也在导航抽屉中展示，带有新单集计数 badge。
5. Settings 不作为标准导航项，而通过工具栏菜单或溢出项进入。
