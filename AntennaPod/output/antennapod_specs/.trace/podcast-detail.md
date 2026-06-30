# Trace: REQ-006 播客详情页

## 关联需求
REQ-006: 播客详情页应展示播客标题、封面、描述、订阅状态、设置入口、筛选/排序入口和单集列表。

## 代码溯源

### 1. 播客单集列表页（含详情头部）
- **FeedItemlistFragment.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/feed/FeedItemlistFragment.java:83`)
  - 展示特定播客的单集列表，顶部折叠头部展示播客详情。

#### a) 页面初始化
  - `onCreate()`: 从参数获取 `feedID`。
  - `newInstance(feedId)` (FeedItemlistFragment.java:96): 创建实例并传入 Feed ID。
  - `onCreateView()` (FeedItemlistFragment.java):
    - 初始化折叠式工具栏 + 单集列表。
    - `setupHeaderView()`: 配置头部视图（播客封面、标题、描述、订阅状态）。
    - `setupLoadMoreScrollListener()`: 配置分页加载（滚动到底部加载更多）。
    - 创建 `FeedItemListAdapter` 绑定单集列表。
    - 配置 `SwipeActions`（左右滑动操作）。
    - 配置下拉刷新 → `FeedUpdateManager.runOnceOrAsk()`。
    - 配置折叠监听 `OnCollapseChangeListener`：折叠时在工具栏显示 Feed 标题。

#### b) 头部详情
  - `setupHeaderView()` (FeedItemlistFragment.java):
    - 显示播客封面、标题、描述。
    - 显示订阅状态（已订阅 / 未订阅）。
    - 提供设置入口（播客设置页）。
    - 提供筛选/排序入口。
  - `refreshHeaderView()`: 数据变化时刷新头部。

#### c) 分页加载
  - `EPISODES_PER_PAGE = 150`: 每页加载 150 集。
  - `page` / `isLoadingMore` / `hasMoreItems`: 分页状态。
  - `loadMoreData(page)`: 加载指定页数据。
  - `setupLoadMoreScrollListener()`: 滚动到底部自动加载下一页。
  - 底部 footer 显示"加载更多"按钮 → 触发 `FeedUpdateManager.runOnce(feed, true)` 拉取更多单集。

#### d) 工具栏菜单
  - `onMenuItemClick()` (FeedItemlistFragment.java):
    - 搜索当前播客单集。
    - 排序（日期、标题、时长等）。
    - 筛选（已播放、已下载、在队列等）。
    - 标记全部已播放。
    - 设置（跳转 FeedSettingsFragment）。
  - `updateToolbar()`: 刷新工具栏状态。

#### e) 单集列表交互
  - `onItemClick(item)`: 点击单集 → 导航到单集详情页 `ItemFragment`。
  - `onContextItemSelected()`: 上下文菜单（播放、下载、加入队列等）。
  - 左右滑动 → SwipeActions（可配置操作如加入队列、标记已播放等）。
  - 多选模式 → `onStartSelectMode()` / `onEndSelectMode()`。

#### f) 事件监听
  - `onEvent(FeedEvent)` / `onEventMainThread(FeedItemEvent)`: Feed 数据变化时刷新列表。
  - `onEventMainThread(EpisodeDownloadEvent)`: 下载进度变化时更新单项。
  - `onEventMainThread(PlaybackPositionEvent)`: 播放进度变化。
  - `onFeedListChanged()`: Feed 列表变化。
  - `onQueueChanged()`: 队列变化。
  - `onPlayerStatusChanged()`: 播放状态变化。

### 2. 播客信息页
- **FeedInfoFragment.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/feed/FeedInfoFragment.java:52`)
  - 播客详细信息页（从详情头部进入）。
  - `newInstance(feedId)`: 创建实例。
  - 展示：播客标题、作者、语言、封面、完整描述、源地址 URL。
  - 提供分享播客、访问网站入口。

### 3. 播客设置入口
- 从详情页工具栏可进入 FeedSettingsFragment（播客独立设置）。

## 关键发现
1. 播客详情页采用折叠式头部设计：展开时显示封面/标题/描述/订阅状态/设置入口，滚动折叠后在工具栏显示标题。
2. 单集列表支持分页加载（每页150集），滚动到底部自动加载。
3. 工具栏提供丰富的操作：搜索、排序、筛选、标记全部已播放、设置。
4. 支持左右滑动操作（SwipeActions），可自定义绑定的操作。
5. 单集项点击进入单集详情页。
6. 支持多选模式进行批量操作。
7. 页面通过事件总线实时响应数据变化（下载进度、播放状态、Feed 更新等）。
8. 播客信息页（FeedInfoFragment）是独立的详细信息展示页，从详情头部的信息入口进入。
