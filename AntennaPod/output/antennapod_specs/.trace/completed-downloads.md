# Code trace · completed-downloads

## Status
status: ok
repo-id: AntennaPod
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 已下载页 (CompletedDownloadsFragment) — app/src/main/java/de/danoeh/antennapod/ui/screen/download/CompletedDownloadsFragment.java:66 — recalled by: both
- Entry 2: 抽屉导航入口 — NavigationNames.java (TAG "DownloadsFragment") + MainActivity.createFragmentInstance — recalled by: path 2

## Entry · 已下载页容器 (CompletedDownloadsFragment)
- claim: 展示所有已下载完成的单集（含退订节目），并显示正在下载的单集，支持排序、查看下载日志、删除已播下载与多选批量操作
- layers:
  - code:     CompletedDownloadsFragment.java:66 (extends Fragment，自实现列表，非 EpisodesListFragment 子类); loadItems:307 → DBReader.getEpisodes(0, Integer.MAX_VALUE, DOWNLOADED+INCLUDE_ALL_FEED_STATES, getDownloadsSortedOrder()) 合并 runningDownloads (getFeedItemsWithUrl)
  - resource: app/src/main/res/menu/downloads_completed.xml (search/download_logs/delete_downloads_played/refresh/downloads_sort); R.string.downloads_label 标题; R.drawable.ic_download 空状态图标; R.string.no_comp_downloads_head_label / R.string.no_comp_downloads_label 空状态文案
  - manifest: N/A: 由宿主 Activity 承载
- interaction: 内存 items 列表、runningDownloads 集合（正在下载的 url）
- data_flow: onStart → loadItems → DBReader.getEpisodes(DOWNLOADED filter) + DBReader.getFeedItemsWithUrl(进行中) → 合并展示

## Entry · 排序 (DownloadsSortDialog)
- claim: 提供"日期/时长/标题/大小"四种排序维度，持久化后刷新
- layers:
  - code:     CompletedDownloadsFragment.onMenuItemClick:183 (R.id.downloads_sort) → DownloadsSortDialog (内部类 :397, extends ItemSortDialog); onAddItem 仅保留 DATE_OLD_NEW / DURATION_SHORT_LONG / EPISODE_TITLE_A_Z / SIZE_SMALL_LARGE (:405-408); onSelectionChanged:412 → UserPreferences.setDownloadsSortedOrder + EventBus DownloadLogEvent.listUpdated
  - resource: R.string.sort; sort_dialog 布局
  - manifest: N/A
- interaction: 持久化 UserPreferences.getDownloadsSortedOrder()
- data_flow: 工具栏"排序" → DownloadsSortDialog → onSelectionChanged → setDownloadsSortedOrder → DownloadLogEvent → loadItems

## Entry · 单集状态与播放/删除操作按钮
- claim: 每个已下载单集项提供操作按钮，根据设置该按钮为"播放"或"删除"，点击可播放或删除该下载
- layers:
  - code:     CompletedDownloadsListAdapter.afterBindViewHolder:370 — 若 isDownloaded 且 !UserPreferences.shouldDownloadsButtonActionPlay() → 绑定 DeleteActionButton (app/.../actionbutton/DeleteActionButton.java:15，onClick → DBWriter.deleteFeedMediaOfItem)；否则按钮为播放（ItemActionButton 默认 PlayActionButton）；点击单集进入单集详情可播放
  - resource: R.drawable.ic_delete; R.string.delete_label; R.drawable.ic_play（播放）
  - manifest: N/A
- interaction: DeleteActionButton.getVisibility:42 仅 isDownloaded 时可见；删除触发 DBWriter.deleteFeedMediaOfItem（含本地节目删除警告 LocalDeleteModal）
- data_flow: 单集项操作按钮点击 → (删除) DeleteActionButton.onClick → DBWriter.deleteFeedMediaOfItem → 列表移除；(播放) 进入播放

## Entry · 删除已播下载 (action_delete_downloads_played)
- claim: 一键删除所有"已下载且已播"的单集下载（弹确认框）
- layers:
  - code:     CompletedDownloadsFragment.onMenuItemClick:186 (R.id.action_delete_downloads_played) → ConfirmationDialog(delete_downloads_played, delete_downloads_played_confirmation) onConfirmButtonPressed:190 → DBReader.getEpisodes(0, MAX_VALUE, DOWNLOADED+INCLUDE_ALL_FEED_STATES+PLAYED, DATE_OLD_NEW) → EpisodeMultiSelectActionHandler(remove_item).handleAction
  - resource: R.string.delete_downloads_played; R.string.delete_downloads_played_confirmation
  - manifest: N/A
- interaction: 数据库批量删除已播单集的本地媒体
- data_flow: 工具栏"删除已播下载" → 确认对话框 → 查询 DOWNLOADED+PLAYED → EpisodeMultiSelectActionHandler.deleteChecked → DBWriter

## Entry · 查看下载日志 (DownloadLogFragment)
- claim: 在已下载页可打开下载日志，查看下载成功/失败记录
- layers:
  - code:     CompletedDownloadsFragment.onMenuItemClick:177 (R.id.action_download_logs) → new DownloadLogFragment().show; 另 ARG_SHOW_LOGS:69 为真时自动弹出 (:132)
  - resource: R.drawable.ic_history; R.string.downloads_log_label
  - manifest: N/A
- interaction: 下载日志为独立弹层（详见 download-log 特性）
- data_flow: 工具栏"下载日志" → DownloadLogFragment 弹层

## Entry · 多选批量操作与单项菜单
- claim: 长按进入多选可批量操作（删除/下载/标记等）；单项长按弹出单项菜单
- layers:
  - code:     onStartSelectMode:347 (悬浮菜单 episodes_apply_action_speeddial → EpisodeMultiSelectActionHandler:127); onContextItemSelected:230 → FeedItemMenuHandler; SwipeActions (DOWNLOADED filter :115)
  - resource: app/src/main/res/menu/episodes_apply_action_speeddial.xml; R.string.no_items_selected_message（未选中提示）
  - manifest: N/A
- interaction: DBWriter 批量写入
- data_flow: 多选菜单 → EpisodeMultiSelectActionHandler → DBWriter

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: EpisodeDownloadEvent（下载状态变化）— CompletedDownloadsFragment.onEventMainThread:209 — 行为：更新进行中下载集合并重新加载
- Trigger: DownloadLogEvent（下载日志变化）— onDownloadLogChanged:298 — 行为：重新加载列表
- Trigger: FeedItemEvent（单集状态变化）— onEventMainThread:252 — 行为：增量更新（下载完成的加入，已删除的移除）
- Trigger: PlayerStatusEvent（播放状态变化）— onPlayerStatusChanged:293 — 行为：重新加载列表
- Trigger: 页面可见 onStart — :159 — 行为：加载已下载列表

## Core business entities (data model / persistence key / state machine)
- FeedItemFilter.DOWNLOADED / INCLUDE_ALL_FEED_STATES: 已下载页固定筛选（含退订节目）
- 偏好键：UserPreferences.getDownloadsSortedOrder()（排序）、shouldDownloadsButtonActionPlay()（操作按钮是播放还是删除）
- runningDownloads: 正在下载的 url 集合（内存）

## Cross-entry shared declarations
- MainActivity（清单声明的宿主 Activity）承载已下载页；下载日志复用 DownloadLogFragment；批量操作复用 EpisodeMultiSelectActionHandler；无针对本页的独立清单组件声明

## Deviations from REQ_DESC
1. REQ_DESC 提及"pagination"，代码实现为一次性加载全部已下载单集（limit=Integer.MAX_VALUE，无分页），与描述存在差异——spec 以代码实现为准（一次加载全部）
2. 操作按钮（播放/删除）行为取决于 shouldDownloadsButtonActionPlay 偏好——属实现细节，spec 两种行为均覆盖
(empty → None)

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 抽屉导航"下载"入口 → MainActivity.createFragmentInstance → CompletedDownloadsFragment
（仅一条进入路径，无其他独立入口）

### Consumers (who reads this state / data)
- CompletedDownloadsListAdapter: 渲染已下载/下载中单集项及操作按钮
- DeleteActionButton: 读取 isDownloaded 决定删除按钮可见性
- EpisodeMultiSelectActionHandler: 批量操作读取所选单集

### Non-consumers (boundary counter-examples with evidence)
- claim: 已下载页不展示未下载的单集
  closure_layers: [code]
  tools: [mcp__gitnexus__context CompletedDownloadsFragment]
  zero_hits: loadItems 仅查询 DOWNLOADED 筛选；未下载单集不在列表

## Same-source cross-reference (if applicable)
- 已下载页与下载日志（download-log）通过 DownloadLogFragment 关联；两 spec 独立生成
