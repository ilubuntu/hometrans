# Code trace · playback-history

## Status
status: ok
repo-id: AntennaPod
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 播放历史页 (PlaybackHistoryFragment) — app/src/main/java/de/danoeh/antennapod/ui/screen/PlaybackHistoryFragment.java:27 — recalled by: both
- Entry 2: 抽屉导航入口 — NavigationNames.java (PlaybackHistoryFragment.TAG) + MainActivity.createFragmentInstance — recalled by: path 2

## Entry · 播放历史页容器 (PlaybackHistoryFragment)
- claim: 展示所有进入过播放历史的单集（含已退订节目），按完成时间倒序分页加载
- layers:
  - code:     PlaybackHistoryFragment.java:27 (extends EpisodesListFragment); FILTER_HISTORY = IS_IN_HISTORY + INCLUDE_ALL_FEED_STATES (:29-30); getFilter:55 → FeedItemFilter.unfiltered()（列表项匹配用，实际加载用 FILTER_HISTORY）; loadData:102 → DBReader.getEpisodes(0, page*150, FILTER_HISTORY, COMPLETION_DATE_NEW_OLD); loadMoreData:108; loadTotalItemCount:114
  - resource: app/src/main/res/menu/playback_history.xml (仅 clear_history_item，无 search/refresh/sort); R.string.playback_history_label 标题; R.drawable.ic_history 空状态图标; R.string.no_history_head_label / R.string.no_history_label 空状态文案
  - manifest: N/A: 由宿主 Activity 承载
- interaction: 内存 episodes 列表、page、hasMoreItems
- data_flow: onStart → loadItems → loadData → DBReader.getEpisodes(IS_IN_HISTORY filter, COMPLETION_DATE_NEW_OLD) → PodDBAdapter

## Entry · 清空播放历史
- claim: 一键清空全部播放历史（弹确认框），清空后列表为空并隐藏清空入口
- layers:
  - code:     PlaybackHistoryFragment.onMenuItemClick:76 (R.id.clear_history_item) → ConfirmationDialog(getActivity, clear_history_label, clear_playback_history_msg) onConfirmButtonPressed:88 → DBWriter.clearPlaybackHistory() (storage/database/.../DBWriter.java:263 → adapter.clearPlaybackHistory() + EventBus PlaybackHistoryEvent.listUpdated); updateToolbar:96 (clear_history_item 可见性 = !episodes.isEmpty())
  - resource: app/src/main/res/menu/playback_history.xml:4 clear_history_item; R.drawable.ic_delete; R.string.clear_history_label; R.string.clear_playback_history_msg
  - manifest: N/A
- interaction: 数据库清空历史记录（清除单集的"在历史中"标记）
- data_flow: 工具栏"清空历史" → 确认对话框 → DBWriter.clearPlaybackHistory → adapter.clearPlaybackHistory → PlaybackHistoryEvent → onHistoryUpdated → loadItems + updateToolbar（列表清空，清空入口隐藏）

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: PlaybackHistoryEvent（历史变化，如单集被标记已播/完成）— PlaybackHistoryFragment.onHistoryUpdated:100 — 行为：重新加载历史列表并更新工具栏
- Trigger: 单集播放完成被写入历史 — 间接经 PlaybackHistoryEvent 刷新
- Trigger: 页面可见 onStart — 继承 EpisodesListFragment — 行为：加载首屏历史

## Core business entities (data model / persistence key / state machine)
- FeedItemFilter.IS_IN_HISTORY / INCLUDE_ALL_FEED_STATES: 历史页固定筛选（含退订节目）
- SortOrder.COMPLETION_DATE_NEW_OLD: 固定排序（完成时间倒序，最新优先）
- EPISODES_PER_PAGE=150: 分页大小

## Cross-entry shared declarations
- MainActivity（清单声明的宿主 Activity）承载播放历史页；无针对本页的独立清单组件声明

## Deviations from REQ_DESC
1. REQ_DESC 提及"clear history"，代码实现为 clearPlaybackHistory（清空全部历史标记），语义一致
2. 历史页无排序/筛选入口，排序固定为完成时间倒序——属实现细节，spec 以固定排序为准
3. 历史页无 search/refresh 入口（菜单仅 clear_history_item）——属实现细节，spec 以实际入口为准
(empty → None)

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 抽屉导航"播放历史"入口 → MainActivity.createFragmentInstance → PlaybackHistoryFragment
（仅一条进入路径，无其他独立入口）

### Consumers (who reads this state / data)
- PlaybackHistoryFragment: 按 IS_IN_HISTORY 筛选展示
- 播放服务在播放完成时将单集写入历史（触发 PlaybackHistoryEvent）

### Non-consumers (boundary counter-examples with evidence)
- claim: 单集总列表/收件箱/收藏页不限定为"在历史中"，不展示清空历史入口
  closure_layers: [code, resource]
  tools: [Read playback_history.xml, mcp__gitnexus__context PlaybackHistoryFragment]
  zero_hits: clear_history_item 仅在 playback_history.xml；其他页面菜单（episodes.xml/favorites.xml/inbox.xml）无 clear_history_item

## Same-source cross-reference (if applicable)
- 播放历史页与总列表页共用 EpisodesListFragment 基类机制；两 spec 独立生成
