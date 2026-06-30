# Code trace · inbox-new

## Status
status: ok
repo-id: AntennaPod
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 收件箱页 (InboxFragment) — app/src/main/java/de/danoeh/antennapod/ui/screen/InboxFragment.java:38 — recalled by: both
- Entry 2: 抽屉导航入口 — NavigationNames.java (InboxFragment.TAG) + MainActivity.createFragmentInstance — recalled by: path 2
- Entry 3: 首页"收件箱"卡片"更多"入口 — InboxSection.handleMoreClick — recalled by: path 2

## Entry · 收件箱页容器 (InboxFragment)
- claim: 展示所有标记为"新（未播）"的单集，支持排序、滑动移除、批量移除与一键清空收件箱
- layers:
  - code:     InboxFragment.java:38 (extends EpisodesListFragment)
  - resource: app/src/main/res/menu/inbox.xml (search/refresh/inbox_sort/remove_all_inbox_item); R.string.inbox_label 标题; R.drawable.ic_inbox 空状态图标; R.string.no_inbox_head_label / R.string.home_new_empty_text 空状态文案
  - manifest: N/A: 无独立清单组件，由宿主 Activity 承载

## Entry · 数据加载（固定筛选"新单集"）与分页
- claim: 仅加载标记为"新"的单集，按 150 条/页分页
- layers:
  - code:     InboxFragment.getFilter:67 (return new FeedItemFilter(FeedItemFilter.NEW)); loadData:96 → DBReader.getEpisodes(0, page*EPISODES_PER_PAGE, NEW, getInboxSortedOrder()); loadMoreData:103; loadTotalItemCount:111 → DBReader.getTotalEpisodeCount(NEW); 分页继承自 EpisodesListFragment.setupLoadMoreScrollListener:261 (EPISODES_PER_PAGE=150)
  - resource: N/A
  - manifest: N/A
- interaction: 内存 episodes 列表、page、hasMoreItems 标志
- data_flow: onStart → loadItems → loadData → DBReader.getEpisodes(NEW filter) → PodDBAdapter

## Entry · 排序 (InboxSortDialog)
- claim: 提供"日期（旧→新/新→旧）""时长（短→长/长→短）"排序，持久化后刷新
- layers:
  - code:     InboxFragment.onMenuItemClick:81 (R.id.inbox_sort) → InboxSortDialog (内部类 :137, extends ItemSortDialog); onAddItem 仅保留 DATE_OLD_NEW / DURATION_SHORT_LONG (:149); onSelectionChanged:158 → UserPreferences.setInboxSortedOrder + EventBus.post(FeedListUpdateEvent)
  - resource: R.string.sort; sort_dialog 布局
  - manifest: N/A
- interaction: 持久化于 UserPreferences.getInboxSortedOrder()
- data_flow: 工具栏"排序" → InboxSortDialog → onSelectionChanged → setInboxSortedOrder → FeedListUpdateEvent → onFeedListChanged → loadItems

## Entry · 清空收件箱（一键移除全部新标记）
- claim: 一键将所有"新"单集标记为非新（移出收件箱），首次/未勾选免确认时弹确认框（可勾选不再询问）
- layers:
  - code:     InboxFragment.onMenuItemClick:83 (R.id.remove_all_inbox_item) → 免确认判断 prefs PREF_DO_NOT_PROMPT_REMOVE_ALL_FROM_INBOX (:85) → removeAllFromInbox:113 或 showRemoveAllDialog:119; removeAllFromInbox → DBWriter.removeAllNewFlags() (storage/database/.../DBWriter.java:686 → adapter.setFeedItems(NEW, UNPLAYED) + EventBus FeedItemEvent unreadStatusChanged=true) + MessageEvent(removed_all_inbox_msg)
  - resource: app/src/main/res/menu/inbox.xml:21 remove_all_inbox_item; R.string.remove_all_inbox_label 标题; R.string.remove_all_inbox_confirmation_msg; R.string.removed_all_inbox_msg; R.layout.checkbox_do_not_show_again (含"不再询问"勾选框); R.string.confirm_label / R.string.cancel_label
  - manifest: N/A
- interaction: 持久化偏好 PREF_DO_NOT_PROMPT_REMOVE_ALL_FROM_INBOX（SharedPreferences "PrefNewEpisodesFragment"）；数据库将所有 NEW 单集置为 UNPLAYED
- data_flow: 工具栏"全部移出收件箱" → (确认弹窗 + 不再询问勾选) → DBWriter.removeAllNewFlags → setFeedItems(NEW→UNPLAYED) → FeedItemEvent → 收件箱列表刷新（清空）

## Entry · 滑动移除单集 (RemoveFromInboxSwipeAction)
- claim: 在收件箱列表项上滑动可移除该"新"单集（标记为非新），并提供撤销
- layers:
  - code:     RemoveFromInboxSwipeAction.performAction (app/.../swipeactions/RemoveFromInboxSwipeAction.java:33) → 若 item.isNew() → FeedItemMenuHandler.markReadWithUndo(fragment, item, UNPLAYED, willRemove); willRemove:42 (filter.showNew 为真即移除); SwipeActions 绑定于 EpisodesListFragment.onCreateView
  - resource: R.drawable.ic_check; R.string.remove_inbox_label; R.attr.icon_purple
  - manifest: N/A
- interaction: 将单集 NEW 置为 UNPLAYED；提供撤销操作
- data_flow: 列表项滑动 → RemoveFromInboxSwipeAction.performAction → markReadWithUndo → DBWriter.markItemsPlayed → 列表移除该项

## Entry · 批量移出收件箱（多选）
- claim: 多选模式下可批量将所选"新"单集移出收件箱
- layers:
  - code:     EpisodeMultiSelectActionHandler.removeFromInboxChecked (app/.../episodeslist/EpisodeMultiSelectActionHandler.java:91) → 对 isNew 项 DBWriter.markItemsPlayed(UNPLAYED, false, markUnplayed); 触发于 EpisodesListFragment.performMultiSelectAction:240 (悬浮菜单 remove_inbox_item)
  - resource: app/src/main/res/menu/episodes_apply_action_speeddial.xml:46 remove_inbox_item; R.plurals.removed_from_inbox_batch_label
  - manifest: N/A
- interaction: 数据库写入 UNPLAYED
- data_flow: 多选 → remove_inbox_item → removeFromInboxChecked → DBWriter.markItemsPlayed

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: FeedItemEvent(unreadStatusChanged=true)（新单集状态变化）— EpisodesListFragment.onEventMainThread:329 — 行为：当 unreadStatusChanged 且 items 为空时整体重新加载（清空后刷新）
- Trigger: 节目更新/播放状态/订阅变化（继承自父类 FeedListUpdateEvent / PlayerStatusEvent）— EpisodesListFragment.java:392,397 — 行为：重新加载收件箱
- Trigger: 收到新单集通知（NotificationUtils 通知分组）— 间接：新单集进入数据库后通过 FeedItemEvent 刷新收件箱

## Core business entities (data model / persistence key / state machine)
- FeedItemFilter.NEW: 固定筛选条件，表示"新（未播）"单集
- EPISODES_PER_PAGE=150: 分页大小
- 偏好键：PrefNewEpisodesFragment 下的排序值（getInboxSortedOrder）、免确认偏好 PREF_DO_NOT_PROMPT_REMOVE_ALL_FROM_INBOX

## Cross-entry shared declarations
- MainActivity（清单声明的宿主 Activity）承载收件箱页；无针对本页面的独立清单组件声明

## Deviations from REQ_DESC
1. REQ_DESC 提及"clear all new"，代码实现为"全部移出新标记"（removeAllNewFlags），语义一致
2. 收件箱筛选条件为固定"新单集"，不可像总列表那样自定义状态筛选——属设计差异，spec 以固定筛选为准
(empty → None)

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 抽屉导航"收件箱"入口 → MainActivity.createFragmentInstance → InboxFragment
- 首页"收件箱"卡片"更多"入口 → InboxSection.handleMoreClick → InboxFragment
（均为同一 InboxFragment 页面的不同进入路径）

### Consumers (who reads this state / data)
- InboxSection（首页卡片）：展示"新单集"子集预览
- NotificationUtils：新单集通知分组读取 NEW 状态

### Non-consumers (boundary counter-examples with evidence)
- claim: 总列表页不限定为"新单集"，不展示收件箱的"全部移出/滑动移除"专属入口
  closure_layers: [code]
  tools: [mcp__gitnexus__context AllEpisodesFragment, Read inbox.xml]
  zero_hits: AllEpisodesFragment 菜单为 episodes.xml（含 filter/sort，无 remove_all_inbox_item）；inbox.xml 独有 remove_all_inbox_item

## Same-source cross-reference (if applicable)
- 收件箱页与总列表页共用 EpisodesListFragment 基类的分页/多选/事件刷新机制，但筛选条件与菜单不同；两 spec 独立生成
