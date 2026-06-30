# Trace: REQ-005 订阅列表

## 关联需求
REQ-005: Subscriptions 页面应展示已订阅播客列表。每个播客项展示标题、封面、新单集/未播放计数等基础信息，并支持点击进入播客详情。

## 代码溯源

### 1. 订阅列表页面
- **SubscriptionFragment.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/subscriptions/SubscriptionFragment.java:59`)
  - 展示已订阅播客的网格/列表页面。

#### a) 页面初始化
  - `onCreateView()` (SubscriptionFragment.java:109):
    - 初始化工具栏（排序、列数、过滤菜单）。
    - 创建网格列表 `subscriptionRecycler`，使用 `SubscriptionsRecyclerAdapter`。
    - `setColumnNumber()`: 设置网格列数（2~5列，用户可调）。
    - `setupEmptyView()`: 配置空状态视图。
    - 显示进度条 `progressBar`。
    - 添加浮动按钮 `subscriptionAddButton`（快捷添加播客）。
    - 配置下拉刷新。
    - 配置标签行 `tagsRecycler` + `SubscriptionTagAdapter`。

#### b) 数据加载
  - `loadSubscriptionsAndTags()` (SubscriptionFragment.java):
    - 异步从数据库加载订阅列表 `DBReader.getFeedList()` 和标签。
    - 加载完成后更新适配器，隐藏进度条。
  - `onEventMainThread(FeedListUpdateEvent)`: 订阅列表变化时重新加载。
  - `onUnreadItemsChanged()`: 单集状态变化时刷新计数。

#### c) 列表项交互
  - 点击播客项 → `onItemClick` → 导航到 `FeedItemlistFragment.newInstance(feedId)`。
  - 长按 → 进入选择模式（多选），底部显示批量操作菜单。
  - 右键上下文菜单 → 播客操作（取消订阅等）。

#### d) 排序与过滤
  - `onMenuItemClick()` (SubscriptionFragment.java): 工具栏菜单。
    - 列数选择（2/3/4/5列）。
    - 排序（标题、最近更新、新单集数等）→ `FeedSortDialog`。
    - 计数器设置 → `FeedCounterDialog`。
    - 过滤 → `SubscriptionsFilterDialog`。
  - `refreshToolbarState()`: 刷新工具栏状态。
  - `updateFilterVisibility()`: 根据标签过滤情况显示/隐藏过滤提示。

#### e) 标签分组
  - `tagsRecycler` + `tagAdapter`: 顶部水平标签行。
  - `onTagClick(tag)`: 点击标签 → 过滤显示该标签下的播客。
  - `onTagContextItemSelected()`: 标签上下文菜单。

#### f) 空状态
  - `setupEmptyView()`: 当无订阅时显示空状态提示和添加播客入口。

### 2. 列表适配器
- **SubscriptionsRecyclerAdapter.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/subscriptions/SubscriptionsRecyclerAdapter.java`)
  - 渲染每个订阅播客卡片。
  - 显示：封面图片、标题、新单集计数 badge。
  - 支持选择模式（多选操作）。

### 3. 滚动状态保持
  - `scrollPosition` (静态变量): 记住滚动位置。
  - `getScrollPosition()` / `restoreScrollPosition()`: 恢复滚动位置。

### 4. 页面状态
  - `stateToShow` (SubscriptionFragment.java): 可显示已订阅 `Feed.STATE_SUBSCRIBED` 或未订阅 `Feed.STATE_NOT_SUBSCRIBED`。
  - `newInstance(state)`: 可指定显示哪种状态的 Feed。

### 5. 折叠工具栏
  - `collapsingContainer`: 折叠式工具栏，滚动时标题从大变小。
  - `setCollapsingToolbarFlags()`: 设置折叠行为。

## 关键发现
1. 订阅列表以网格形式展示，列数可调（2-5列），默认根据屏幕宽度自动计算。
2. 每个播客项展示封面、标题和新单集计数 badge。
3. 支持按标签分组过滤，标签在顶部水平列表中展示。
4. 支持多选模式，可批量操作选中的播客。
5. 滚动位置在页面切换间保持。
6. 排序选项包括标题、最近更新、新单集数等。
7. 空状态有专门的引导提示。
8. 该页面可复用于显示未订阅的 Feed（通过 state 参数）。
