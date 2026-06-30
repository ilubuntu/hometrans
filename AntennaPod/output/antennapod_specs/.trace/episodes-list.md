# Code trace · episodes-list

## Status
status: ok
repo-id: AntennaPod
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: "单集"总列表页 (AllEpisodesFragment) — app/src/main/java/de/danoeh/antennapod/ui/screen/AllEpisodesFragment.java:33 — recalled by: both (Path 1 concept query; Path 2 NavigationNames/MainActivity host)
- Entry 2: 抽屉导航入口 — app/src/main/java/de/danoeh/antennapod/ui/screen/drawer/NavigationNames.java:135 (returns AllEpisodesFragment.TAG) — recalled by: path 2
- Entry 3: 首页"更多"入口 (EpisodesSurpriseSection.handleMoreClick) — app/src/main/java/de/danoeh/antennapod/ui/screen/home/sections/EpisodesSurpriseSection.java — recalled by: path 2

## Entry · 单集总列表页 (AllEpisodesFragment, 容器)
- claim: 聚合展示所有订阅节目下的全部单集，支持分页加载、排序、筛选与多选批量操作
- layers:
  - code:     app/src/main/java/de/danoeh/antennapod/ui/screen/AllEpisodesFragment.java:33 (extends EpisodesListFragment at app/src/main/java/de/danoeh/antennapod/ui/episodeslist/EpisodesListFragment.java:64)
  - resource: app/src/main/res/menu/episodes.xml (工具栏菜单 search/refresh/filter/sort); app/src/main/res/menu/episodes_apply_action_speeddial.xml (多选悬浮菜单); R.string.episodes_label 标题
  - manifest: N/A: 无独立 Activity/Service 声明，页面由 MainActivity 容器承载（宿主 Activity 已在清单声明）

## Entry · 数据加载与分页 (loadData / loadMoreData / loadTotalItemCount)
- claim: 首次按 150 条/页加载首页数据，滚动到底部自动追加下一页，并显示总数
- layers:
  - code:     AllEpisodesFragment.loadData:64 → DBReader.getEpisodes(offset, limit, filter, sortOrder) at storage/database/src/main/java/de/danoeh/antennapod/storage/database/DBReader.java:223; loadMoreData:75 (AllEpisodesFragment.java); loadTotalItemCount:82 → DBReader.getTotalEpisodeCount; EpisodesListFragment.loadItems:401; setupLoadMoreScrollListener:261 (EPISODES_PER_PAGE=150 at EpisodesListFragment.java:70); loadMoreItems:276
  - resource: N/A: 分页阈值由代码逻辑（滚动到底部）驱动，无资源声明
  - manifest: N/A: 纯本地数据库读取，无清单条目
- interaction: 内存态 episodes 列表（EpisodesListFragment.java:75）、page 计数（:72）、hasMoreItems/isLoadingMore 标志（:73-74）
- data_flow: onStart → loadItems() → loadData() → DBReader.getEpisodes → PodDBAdapter.getEpisodesCursor(offset,limit,filter,sortOrder); 滚动到底 → page++ → loadMoreItems → loadMoreData(page) → DBReader.getEpisodes；loadTotalItemCount → DBReader.getTotalEpisodeCount

## Entry · 排序 (AllEpisodesSortDialog)
- claim: 提供"日期（旧→新/新→旧）"与"时长（短→长/长→短）"两种排序维度，选中后持久化并刷新列表
- layers:
  - code:     AllEpisodesFragment.onMenuItemClick:98 (R.id.episodes_sort) → AllEpisodesSortDialog (内部类 :139, extends ItemSortDialog app/src/main/java/de/danoeh/antennapod/ui/screen/feed/ItemSortDialog.java:19); onAddItem 仅保留 DATE_OLD_NEW / DURATION_SHORT_LONG (AllEpisodesFragment.java:153); onSelectionChanged:162 → UserPreferences.setAllEpisodesSortOrder + EventBus.post(FeedListUpdateEvent)
  - resource: R.string.sort、R.string.date、R.string.duration; sort_dialog 布局
  - manifest: N/A: 排序值为偏好键，无清单条目
- interaction: 持久化排序值于 UserPreferences.getAllEpisodesSortOrder() (storage/preferences/.../UserPreferences.java)
- data_flow: 工具栏"排序" → AllEpisodesSortDialog → onSelectionChanged → setAllEpisodesSortOrder → 发送 FeedListUpdateEvent → onFeedListChanged → loadItems 重新读取

## Entry · 筛选 (AllEpisodesFilterDialog)
- claim: 弹出筛选面板，可按"已播/未播、暂停/未暂停、收藏/非收藏、有媒体/无媒体、在队列/不在队列、已下载/未下载"逐组切换，更改后重置到第 1 页并刷新；支持重置全部
- layers:
  - code:     AllEpisodesFragment.onMenuItemClick:100 (R.id.filter_items) & txtvInformation 点击:46 → AllEpisodesFilterDialog.newInstance; onFilterChanged:114 → UserPreferences.setPrefFilterAllEpisodes → updateFilterUi + page=1 + loadItems; getFilter:88 读取 UserPreferences.getPrefFilterAllEpisodes; AllEpisodesFilterDialog app/src/main/java/de/danoeh/antennapod/ui/AllEpisodesFilterDialog.java:11 (extends ItemFilterDialog :29)
  - resource: filter_dialog 布局; FeedItemFilterGroup 6 组枚举 (app/.../feed/FeedItemFilterGroup.java:6): PLAYED/UNPLAYED, PAUSED/NOT_PAUSED, IS_FAVORITE/NOT_FAVORITE, HAS_MEDIA/NO_MEDIA, QUEUED/NOT_QUEUED, DOWNLOADED/NOT_DOWNLOADED; R.string.filter
  - manifest: N/A: 筛选值为偏好键，无清单条目
- interaction: 持久化筛选值 UserPreferences.getPrefFilterAllEpisodes (UserPreferences.java:908); 内存态 FeedItemFilter
- data_flow: 工具栏"筛选"/信息条点击 → AllEpisodesFilterDialog(底部弹层) → 切换 toggle → onFilterChanged → AllEpisodesFilterChangedEvent → setPrefFilterAllEpisodes → 重置 page=1 → loadItems → DBReader.getEpisodes(带 filter)

## Entry · 多选批量操作 (Action Mode)
- claim: 长按进入多选模式，浮出悬浮操作菜单，可对所选单集批量执行：删除、下载、标记未播、标记已播、移出队列、加入队列、分享、移出收件箱、加入收藏、取消收藏、重置播放进度；选中≥25项或含懒加载项时对"标记已播/未播"二次确认
- layers:
  - code:     EpisodesListFragment.onStartSelectMode:314 (显示 floatingSelectMenu); 悬浮菜单回调:210 → performMultiSelectAction:240 → EpisodeMultiSelectActionHandler.handleAction (app/.../episodeslist/EpisodeMultiSelectActionHandler.java:51); 确认逻辑:216 (>=25 或 shouldSelectLazyLoadedItems); ConfirmationDialog:227
  - resource: app/src/main/res/menu/episodes_apply_action_speeddial.xml:10-76 (13 个动作项，move_to_top/bottom 默认隐藏)
  - manifest: N/A: 批量动作为数据写入，无清单条目
- interaction: DBWriter 写入（加队列/移队列/标记已播未播/下载/删除/收藏/重置进度）；SynchronizationQueue 同步（gpodder）；showMessage 提示 plurals
- data_flow: 多选菜单点击 → 校验选中数 → (确认弹窗) → EpisodeMultiSelectActionHandler → DBWriter.* → DB；懒加载模式下循环加载后续页并应用 (performMultiSelectAction:245-253)

## Entry · 单项上下文菜单与刷新
- claim: 单集长按弹出单项操作菜单；下拉刷新触发节目更新；工具栏"刷新"同效
- layers:
  - code:     EpisodesListFragment.onContextItemSelected:119 → FeedItemMenuHandler.onMenuItemClicked; onMenuItemClick:106 (R.id.refresh_item) → FeedUpdateManager.runOnceOrAsk; swipeRefreshLayout:194 setOnRefreshListener
  - resource: R.string.refresh_label; R.drawable.ic_feed 空状态
  - manifest: N/A
- interaction: 下载/播放状态随事件更新
- data_flow: 下拉/工具栏刷新 → FeedUpdateManager.runOnceOrAsk

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: FeedItemEvent（单集状态变化）— EpisodesListFragment.onEventMainThread:329 — 行为：增量更新匹配项，不匹配则移除/重新加载
- Trigger: EpisodeDownloadEvent（下载进度变化）— EpisodesListFragment.java:382 — 行为：刷新对应单集视图
- Trigger: PlayerStatusEvent（播放状态变化）— EpisodesListFragment.java:392 — 行为：重新加载列表
- Trigger: FeedListUpdateEvent（订阅/排序变更）— EpisodesListFragment.java:397 — 行为：重新加载列表
- Trigger: PlaybackPositionEvent（播放进度变化）— EpisodesListFragment.java:354 — 行为：更新当前播放项进度显示
- Trigger: 页面可见 onStart — EpisodesListFragment.java:91 — 行为：注册事件总线并加载首屏数据

## Core business entities (data model / persistence key / state machine)
- FeedItem: 单集实体（model 模块），含播放状态、下载状态、收藏标记、队列标记
- FeedItemFilter: 筛选条件集合（model），filterId 字符串如 played/unplayed/downloaded 等
- EPISODES_PER_PAGE=150: 分页大小常量（EpisodesListFragment.java:70）
- 偏好键：PrefAllEpisodesFragment 下的筛选值（UserPreferences.getPrefFilterAllEpisodes）、排序值（getAllEpisodesSortOrder）

## Cross-entry shared declarations
- MainActivity（清单声明的宿主 Activity）承载所有 Fragment 页面，单集总列表通过抽屉/首页进入；无针对本页面的独立清单组件声明

## Deviations from REQ_DESC
1. REQ_DESC 提及"aggregate（聚合）"，代码实现为聚合所有订阅节目的单集（不区分节目来源），与描述一致
2. 多选菜单中 move_to_top / move_to_bottom 两项默认 android:visible="false"（episodes_apply_action_speeddial.xml:69,75），仅在队列等场景可见，本页默认不展示——属实现细节，spec 以实际可见动作为准
(empty → None)

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 抽屉导航"单集"入口 — NavigationNames.java:135 → MainActivity.createFragmentInstance → AllEpisodesFragment（与 Entry 1 同一页面）
- 首页"惊喜单集"卡片的"更多"入口 — EpisodesSurpriseSection.handleMoreClick → AllEpisodesFragment（与 Entry 1 同一页面）
（以上均为同一 AllEpisodesFragment 页面的不同进入路径，无额外独立页面）

### Consumers (who reads this state / data)
- EpisodeItemListAdapter: 渲染单集列表项（app/.../episodeslist/EpisodeItemListAdapter.java）
- FeedItemMenuHandler / EpisodeMultiSelectActionHandler: 读取选中单集执行操作
- 各事件订阅者读取 episodes 内存列表

### Non-consumers (boundary counter-examples with evidence)
- claim: 首页"惊喜单集"卡片不展示全部单集，仅展示随机子集（进入总列表才展示全部）
  closure_layers: [code]
  tools: [mcp__gitnexus__context EpisodesSurpriseSection]
  zero_hits: EpisodesSurpriseSection 为独立 section，仅 handleMoreClick 跳转至总列表，不直接读取 getEpisodes 全量

## Same-source cross-reference (if applicable)
- None
