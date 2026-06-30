# Trace: REQ-001 首次启动与空库首页

## 关联需求
REQ-001: AntennaPod 首次启动后应进入主界面。空库状态下页面需要清楚展示应用名称、主导航入口、添加播客入口，以及当前没有订阅/没有内容的空状态提示。

## 代码溯源

### 1. 应用入口
- **MainActivity.java** (`app/src/main/java/de/danoeh/antennapod/activity/MainActivity.java:100`)
  - 应用主入口，在 `onCreate()` 中初始化导航（NavDrawerFragment 或 BottomNavigation），加载默认页面（HomeFragment）。
  - `loadFragment(tag)` (MainActivity.java:492): 根据导航标签加载对应页面组件。
  - `createFragmentInstance(tag)` (MainActivity.java): 根据标签字符串创建对应的页面实例。

### 2. 首页组件
- **HomeFragment.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/home/HomeFragment.java:47`)
  - 继承自平台基础页面类，实现工具栏菜单点击监听。
  - `onCreateView()` (HomeFragment.java:68):
    - 初始化工具栏，关联搜索、刷新菜单项。
    - 调用 `populateSectionList()` 填充首页分区。
    - 调用 `updateWelcomeScreenVisibility()` 判断空库状态。
    - 配置下拉刷新 → `FeedUpdateManager.getInstance().runOnceOrAsk()`.
  - `populateSectionList()` (HomeFragment.java:87):
    - 读取首页分区配置 `HomePreferences.getSortedSectionTags()`。
    - 动态添加分区：QueueSection, InboxSection, EpisodesSurpriseSection, SubscriptionsSection, DownloadsSection。
    - 也可能包含 EchoSection（年度回顾）。

### 3. 空状态逻辑（核心）
- **updateWelcomeScreenVisibility()** (HomeFragment.java:171):
  - 异步查询 `DBReader.getTotalEpisodeCount(FeedItemFilter.unfiltered())` 获取总单集数。
  - 若 `numEpisodes == 0`（空库）：
    - 显示欢迎容器 `welcomeContainer`（空状态提示文案 + 添加播客入口指引）。
    - 隐藏首页分区容器 `homeContainer`。
    - 隐藏下拉刷新 `swipeRefresh`。
    - 重置滚动位置到顶部。
  - 若 `numEpisodes > 0`：
    - 隐藏欢迎容器，显示首页分区。
  - 根据导航模式（底部导航 vs 侧边导航）：
    - `arrowBottomIcon` 在底部导航时可见（箭头指向底部添加按钮）。
    - `arrowSidebarIcon` 在侧边导航时可见（箭头指向侧边添加按钮）。
  - 检查 `UserPreferences.isBottomNavigationEnabled()` 判断当前导航模式。

### 4. 空状态交互
- 欢迎页面的添加播客入口指向导航中的 "Add Feed" 入口。
- 数据变化时通过事件 `FeedListUpdateEvent` 触发 `onFeedListChanged()` → `updateWelcomeScreenVisibility()` 重新评估空状态。

### 5. 数据来源
- `DBReader.getTotalEpisodeCount()`: 查询数据库中所有 FeedItem 的总数。
- `UserPreferences.isBottomNavigationEnabled()`: 读取用户导航模式偏好。
- `HomePreferences.getSortedSectionTags()`: 读取首页分区排序配置。

## 关键发现
1. 空库判断依据是"总单集数 == 0"，而非"订阅数 == 0"。即使有订阅但无单集，也显示空状态。
2. 空状态页面同时展示添加播客入口指引，方向取决于用户选择的导航模式。
3. 订阅播客后（触发 FeedListUpdateEvent），首页会自动从空状态切换到分区列表。
4. 首页支持自定义分区排列（HomeSectionsSettingsDialog）。
