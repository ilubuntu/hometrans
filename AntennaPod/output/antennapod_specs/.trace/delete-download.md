# Code trace · delete-download

## Status
status: ok
repo-id: AntennaPod
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 单集长按菜单"删除" (FeedItemMenuHandler.remove_item) — app/.../episodeslist/FeedItemMenuHandler.java:187 — recalled by: both
- Entry 2: 已下载页"删除"按钮 (DeleteActionButton) — app/.../actionbutton/DeleteActionButton.java:15 — recalled by: path 2
- Entry 3: 多选批量"删除" (EpisodeMultiSelectActionHandler.remove_item → deleteChecked) — app/.../episodeslist/EpisodeMultiSelectActionHandler.java:55,152 — recalled by: path 2
- Entry 4: 列表项滑动删除 (DeleteSwipeAction) — app/.../swipeactions/DeleteSwipeAction.java:13 — recalled by: path 2
- Entry 5: 自动删除（接近播放完时）— FeedItemMenuHandler:265 — recalled by: path 2

## Entry · 删除本地媒体（核心实现 deleteFeedMediaOfItem）
- claim: 删除单集已下载的本地媒体文件与字幕文件，将单集标记为未下载，但保留单集本身与媒体元数据（标题、描述、下载地址等）
- layers:
  - code:     DBWriter.deleteFeedMediaOfItem:103 → deleteFeedMediaSynchronous:118 (storage/database/.../DBWriter.java)：本地节目（content://）→ DocumentFile.delete + setLocalFileUrl(null) + 刷新节目源；普通下载文件→先删字幕文件(media.getTranscriptFileUrl)→再删媒体文件(media.getLocalFileUrl)→media.setDownloaded(false)、setLocalFileUrl(null)、setHasEmbeddedPicture(false)→PodDBAdapter.setMediaDownloadInformation；若为当前播放→writeNoMediaPlaying + 发送 MEDIA_STOP 停止播放；enqueueEpisodeAction(DELETE) 同步；deleteFeedMediaOfItem 发 FeedItemEvent
  - resource: N/A: 无资源声明（文件操作 + 数据库写入）
  - manifest: N/A: 无新增清单条目
- interaction: FeedMedia.downloaded→false、localFileUrl→null、hasEmbeddedPicture→false（保留 FeedItem 与 media 的 title/downloadUrl/description 等元数据，仅清除本地文件与下载状态）；若 shouldDeleteRemoveFromQueue 则移出队列
- data_flow: 删除触发 → DBWriter.deleteFeedMediaOfItem → deleteFeedMediaSynchronous（删文件 + 置未下载 + 写库）→ FeedItemEvent → 各列表刷新为"未下载"

## Entry · 本地节目删除二次确认 (LocalDeleteModal)
- claim: 删除涉及本地媒体源节目的下载时弹确认框；非本地节目直接删除
- layers:
  - code:     LocalDeleteModal.showLocalFeedDeleteWarningIfNecessary:8 (app/.../view/LocalDeleteModal.java) — 若任一 item.getFeed().isLocalFeed() → MaterialAlertDialog(delete_label, delete_local_feed_confirmation_dialog_message) 正向确认→deleteCommand.run；否则直接 run
  - resource: R.string.delete_label; R.string.delete_local_feed_confirmation_dialog_message; R.string.cancel_label
  - manifest: N/A
- interaction: 仅本地节目触发二次确认
- data_flow: 删除入口 → LocalDeleteModal → (确认) → DBWriter.deleteFeedMediaOfItem

## Entry · 单集长按菜单删除（单项）
- claim: 在单集长按菜单中对已下载或下载中的单集执行删除
- layers:
  - code:     FeedItemMenuHandler.onPrepareMenu canDelete:89 (hasMedia && isDownloaded) || isDownloading → remove_item 可见 :129; onMenuItemClicked:187 remove_item → LocalDeleteModal → DBWriter.deleteFeedMediaOfItem
  - resource: R.id.remove_item; R.string.delete_label; R.drawable.ic_delete
  - manifest: N/A
- interaction: 已下载则删文件置未下载；下载中则交由取消逻辑
- data_flow: 单集长按菜单"删除" → LocalDeleteModal → DBWriter.deleteFeedMediaOfItem

## Entry · 已下载页删除按钮 (DeleteActionButton)
- claim: 已下载页/单集详情页对已下载单集提供"删除"按钮，点击删除其本地下载
- layers:
  - code:     DeleteActionButton.onClick:32 → LocalDeleteModal.showLocalFeedDeleteWarningIfNecessary → DBWriter.deleteFeedMediaOfItem; getVisibility:42 仅 isDownloaded 时可见
  - resource: R.drawable.ic_delete; R.string.delete_label
  - manifest: N/A
- interaction: 同核心实现
- data_flow: 删除按钮 → LocalDeleteModal → DBWriter.deleteFeedMediaOfItem

## Entry · 多选批量删除
- claim: 多选模式下批量删除所选单集的下载（已下载的删文件，下载中的取消）
- layers:
  - code:     EpisodeMultiSelectActionHandler.handleAction:55 remove_item → LocalDeleteModal:56 → deleteChecked:152：isDownloaded→DBWriter.deleteFeedMediaOfItem；isDownloadingEpisode→DownloadServiceInterface.cancel; showMessage deleted_episode_message
  - resource: app/src/main/res/menu/episodes_apply_action_speeddial.xml:10 remove_item; R.plurals.deleted_episode_message
  - manifest: N/A
- interaction: 批量删文件/取消下载
- data_flow: 多选菜单"删除" → LocalDeleteModal → deleteChecked → DBWriter / cancel

## Entry · 滑动删除 (DeleteSwipeAction)
- claim: 在已下载筛选下列表项滑动删除已下载单集的本地文件
- layers:
  - code:     DeleteSwipeAction.performAction:33 — 仅 isDownloaded 时执行 → LocalDeleteModal → DBWriter.deleteFeedMediaOfItem; willRemove:42 (filter.showDownloaded && isDownloaded)
  - resource: R.drawable.ic_delete; R.attr.icon_red; R.string.delete_label
  - manifest: N/A
- interaction: 同核心实现
- data_flow: 列表项滑动 → DeleteSwipeAction → LocalDeleteModal → DBWriter.deleteFeedMediaOfItem

## Entry · 自动删除（接近播放完）
- claim: 开启自动删除且单集接近播放完成时，自动删除其本地下载
- layers:
  - code:     FeedItemMenuHandler:260-266 — isAutoDelete() && (!isLocalFeed || isAutoDeleteLocal()) 且 almostEnded → DBWriter.deleteFeedMediaOfItem
  - resource: N/A（设置项控制）
  - manifest: N/A
- interaction: 自动删除同核心实现（保留元数据）
- data_flow: 播放接近完成 → FeedItemMenuHandler → DBWriter.deleteFeedMediaOfItem

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 单集播放接近完成（自动删除开启时）— FeedItemMenuHandler:265 — 行为：自动删除本地下载
- Trigger: 存储空间自动清理（按清理算法）— 各 CleanupAlgorithm.performCleanup — 行为：删除未受保护的已下载单集（收藏项受保护）
- Trigger: 删除单集后若为当前播放项 — DBWriter.deleteFeedMediaSynchronous:153 — 行为：停止播放

## Core business entities (data model / persistence key / state machine)
- FeedMedia.downloaded / localFileUrl / hasEmbeddedPicture / transcriptFileUrl: 删除时被清除/置空，但 media 记录与 FeedItem（标题、描述、downloadUrl）保留
- FeedItem / Feed: 单集与节目元数据，删除时不删除记录（仅删本地文件）
- 偏好键：shouldDeleteRemoveFromQueue（删除是否移出队列）、isAutoDelete / isAutoDeleteLocal（自动删除）

## Cross-entry shared declarations
- 无独立清单声明；删除为本地文件操作 + 数据库状态更新，复用 DBWriter 与 LocalDeleteModal

## Deviations from REQ_DESC
1. REQ_DESC 提及"keep metadata"，代码实现为仅删除本地媒体文件与下载状态位，保留单集与媒体元数据记录（标题/描述/下载地址），与描述一致
2. 本地媒体源节目的删除需二次确认（LocalDeleteModal）——属实现细节，spec 覆盖该边界
3. 若删除的恰为当前播放单集，会停止播放——属副作用，spec 覆盖
(empty → None)

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 任意单集列表（总列表/收件箱/收藏/历史/已下载/节目详情/队列等）单集长按菜单"删除"
- 已下载页/单集详情页的"删除"按钮
- 多选批量删除菜单
- 列表项滑动删除（若配置）
- 自动删除（接近播放完 / 存储清理）

### Consumers (who reads this state / data)
- 各 EpisodeListFragment: 监听 FeedItemEvent 刷新为"未下载"
- CompletedDownloadsFragment: 已下载单集删除后移出列表
- 自动清理算法: 读取已下载单集决定清理

### Non-consumers (boundary counter-examples with evidence)
- claim: 删除下载不删除单集元数据记录（单集本身仍存在于节目列表中，可再次下载）
  closure_layers: [code]
  tools: [Read DBWriter.java:118-169]
  zero_hits: deleteFeedMediaSynchronous 仅置 downloaded=false/localFileUrl=null，未删除 FeedItem/FeedMedia 记录

## Same-source cross-reference (if applicable)
- 删除下载与下载单集（download-episode）互为逆操作；与收藏保护（favorites 的自动清理保护）相关；各 spec 独立生成
