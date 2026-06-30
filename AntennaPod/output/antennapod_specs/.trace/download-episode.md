# Code trace · download-episode

## Status
status: ok
repo-id: AntennaPod
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 单集"下载"操作按钮 (DownloadActionButton) — app/src/main/java/de/danoeh/antennapod/actionbutton/DownloadActionButton.java:18 — recalled by: both
- Entry 2: 多选批量下载 (EpisodeMultiSelectActionHandler.downloadChecked) — app/.../episodeslist/EpisodeMultiSelectActionHandler.java:140 — recalled by: path 2
- Entry 3: 滑动下载 (StartDownloadSwipeAction) — app/.../swipeactions/StartDownloadSwipeAction.java — recalled by: path 2
- Entry 4: 自动下载 (AutoDownloadManager) — net/download/service/.../autodownload — recalled by: path 2

## Entry · 发起下载（单集下载按钮）
- claim: 用户对未下载的单集点击"下载"按钮发起下载；若处于受限网络（如移动网络）则弹确认框选择稍后下载/本次允许/取消
- layers:
  - code:     DownloadActionButton.onClick:50 — 校验 media 非 null 且 !shouldNotDownload（未在下载且未已下载，:92）；NetworkUtils.isEpisodeDownloadAllowed() 或在 bypass 窗口内 → DownloadServiceInterface.get().downloadNow(context, item, bypassNow)；否则 confirm_mobile_download 弹窗 → download_later(BYPASS_TYPE_LATER)/allow_this_time(BYPASS_TYPE_NOW)/cancel；getVisibility:40 本地节目隐藏下载按钮
  - resource: R.drawable.ic_download; R.string.download_label; R.plurals.mobile_download_notice; R.string.confirm_mobile_download_dialog_title/message/message_vpn/download_later/allow_this_time; R.string.cancel_label
  - manifest: 需网络权限（见跨入口声明）
- interaction: bypassCellularNetworkType / bypassCellularNetworkWarningTimer（5 分钟内免再次确认，TIMEOUT=300s）；UsageStatistics.logAction(ACTION_DOWNLOAD)
- data_flow: 下载按钮点击 → DownloadActionButton.onClick → DownloadServiceInterface.downloadNow → WorkManager.enqueueUniqueWork(EpisodeDownloadWorker)

## Entry · 批量与滑动下载
- claim: 多选模式下批量下载所选单集（按列表顺序）；列表项滑动也可发起下载
- layers:
  - code:     EpisodeMultiSelectActionHandler.downloadChecked:140 — 对 hasMedia 且 !isDownloaded 的项 DownloadServiceInterface.get().download(activity, episode)（顺序），showMessage downloading_episodes_message; StartDownloadSwipeAction.performAction → DownloadActionButton.onClick
  - resource: R.plurals.downloading_episodes_message
  - manifest: 需网络权限
- interaction: 批量依次入队
- data_flow: 多选/滑动 → DownloadServiceInterface.download → WorkManager.enqueueUniqueWork(EpisodeDownloadWorker)

## Entry · 下载执行与进度上报 (EpisodeDownloadWorker)
- claim: 后台下载单集媒体，每秒上报进度并通过通知栏显示下载进度；完成或失败时更新状态
- layers:
  - code:     EpisodeDownloadWorker.doWork:67 (net/download/service/.../episode/EpisodeDownloadWorker.java) — 构建 DownloadRequest；DBWriter.setMediaDownloadInformation(media) 先写本地路径; 创建目标文件; DefaultDownloaderFactory.create 执行下载 (performDownload:131); progressUpdaterThread 每 1s → setProgressAsync(WORK_DATA_PROGRESS=进度%) + NotificationManager.notify(notification_downloading, generateProgressNotification); WifiLock 保持唤醒; retry3times; 失败删除部分文件 (:95); getForegroundInfoAsync:105 前台通知
  - resource: 下载进度通知 (notification_downloading); R.string.download_started_talkback / R.string.download_completed_talkback（DownloadAnnouncer.announceStart/Completed 无障碍播报）
  - manifest: net/download/service/AndroidManifest.xml 权限 INTERNET / ACCESS_NETWORK_STATE / ACCESS_WIFI_STATE / POST_NOTIFICATIONS；EpisodeDownloadWorker 经 WorkManager 以前台服务形式运行（getForegroundInfoAsync）
- interaction: DownloadRequest.progressPercent；notificationProgress 映射；DownloadServiceInterface.WORK_TAG / WORK_TAG_EPISODE_URL 标签
- data_flow: enqueueUniqueWork → EpisodeDownloadWorker.doWork → Downloader 下载 → 每秒进度 → DownloadAnnouncer/进度事件 → UI；完成 → MediaDownloadedHandler.run

## Entry · 下载进度 UI 展示
- claim: 列表项以环形进度展示下载进度，队列中为不确定态
- layers:
  - code:     EpisodeItemViewHolder:141-145（及 HorizontalItemViewHolder:86-90）— isDownloadingEpisode(url) 为真时 DownloadServiceInterface.getProgress(url) → secondaryActionProgress.setPercentage（环形进度，最小 1%）；isEpisodeQueued 为不确定态; 已下载 setPercentage(1); MainActivity.onCreate 注册 EpisodeDownloadEvent 分发
  - resource: CircularProgressBar (R.id.secondaryActionProgress); 进度通知图标
  - manifest: N/A
- interaction: 读取 DownloadServiceInterface 进度状态
- data_flow: EpisodeDownloadEvent（含 url→DownloadStatus，event 模块）→ 各列表 onEventMainThread → EpisodeItemViewHolder 重绘进度

## Entry · 下载完成状态变更 (MediaDownloadedHandler)
- claim: 下载完成后将单集标记为已下载，写入媒体文件信息（路径/大小/时长/章节/字幕），并记录下载日志
- layers:
  - code:     MediaDownloadedHandler.run:46 (net/download/service/.../episode/MediaDownloadedHandler.java) — media.setDownloaded(true) + setLocalFileUrl + setSize; 加载 chapters/transcript; MediaMetadataRetriever 取时长 setDuration; DBWriter.setFeedMedia; item.disableAutoDownload; 写入 DownloadResult(成功) → 下载日志; DownloadAnnouncer.announceCompleted
  - resource: R.string.download_completed_talkback
  - manifest: N/A
- interaction: 数据库更新 FeedMedia.downloaded=true、本地路径、大小、时长；DownloadResult 写入下载日志表
- data_flow: 下载完成回调 → MediaDownloadedHandler.run → DBWriter.setFeedMedia + DownloadResult → FeedItemEvent → 各列表刷新为"已下载"状态

## Entry · 下载失败/取消
- claim: 下载失败删除部分文件并记录失败日志；取消时移除部分文件并按需移出队列
- layers:
  - code:     EpisodeDownloadWorker.doWork:95（失败 FileUtils.deleteQuietly）；sendMessage/sendErrorNotification; DownloadResult(失败, reason/reasonDetailed) 写日志; DownloadServiceInterface.cancel:84（删除部分文件 + WorkManager.cancelAllWorkByTag + WORK_DATA_WAS_QUEUED 时 removeQueueItem）
  - resource: 失败通知（sendErrorNotification）
  - manifest: N/A
- interaction: 失败原因 DownloadError 写入 DownloadResult
- data_flow: 失败/取消 → 删除部分文件 → DownloadResult 写日志 → DownloadLogEvent 刷新下载日志

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 自动下载（满足自动下载条件时）— AutoDownloadManager.autodownloadUndownloadedItems — 行为：自动对符合条件的单集发起下载
- Trigger: 网络变化（受限→恢复）— ConnectivityActionReceiver（监听 CONNECTIVITY_CHANGE）— 行为：恢复符合约束的下载
- Trigger: 接入电源 — PowerConnectionReceiver — 行为：触发自动下载（依设置）

## Core business entities (data model / persistence key / state machine)
- FeedMedia.downloaded: 已下载状态位（model）；downloadUrl / localFileUrl / size / duration
- DownloadRequest.progressPercent: 下载进度百分比（0-100）
- DownloadStatus（event）：url→进度/状态映射（EpisodeDownloadEvent）
- DownloadResult: 下载结果（成功/失败，详见 download-log）
- 约束：isAllowMobileEpisodeDownload（是否允许移动网络下载）→ NetworkType.UNMETERED/CONNECTED；enqueueDownloadedEpisodes（下载后入队）

## Cross-entry shared declarations
- net/download/service/AndroidManifest.xml：权限 android.permission.INTERNET / ACCESS_NETWORK_STATE / ACCESS_WIFI_STATE / POST_NOTIFICATIONS；receiver FeedUpdateReceiver / ConnectivityActionReceiver（android.net.conn.CONNECTIVITY_CHANGE）/ PowerConnectionReceiver（POWER_CONNECTED/DISCONNECTED）；EpisodeDownloadWorker 以前台服务（通知 notification_downloading）运行

## Deviations from REQ_DESC
1. REQ_DESC 提及"progress, complete status change"，代码实现为每秒进度上报 + 完成后状态置为已下载，与描述一致
2. 受限网络（移动网络）下下载需用户确认（稍后/本次允许/取消），并在 5 分钟内免再次确认——属实现细节，spec 覆盖该边界
(empty → None)

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 单集下载按钮（任意单集列表项的操作按钮/单集详情页 ItemFragment.updateButtons）
- 多选批量下载（episodes_apply_action_speeddial download_item）
- 列表项滑动下载（StartDownloadSwipeAction，若配置）
- 自动下载（满足条件时后台触发）

### Consumers (who reads this state / data)
- EpisodeItemViewHolder / HorizontalItemViewHolder: 渲染下载进度环形条
- CompletedDownloadsFragment: 监听 EpisodeDownloadEvent 刷新已下载/下载中列表
- 下载日志: 读取下载结果记录

### Non-consumers (boundary counter-examples with evidence)
- claim: 本地节目（本地媒体源）不提供下载按钮
  closure_layers: [code]
  tools: [mcp__gitnexus__context DownloadActionButton]
  zero_hits: DownloadActionButton.getVisibility:40 本地节目返回 INVISIBLE

## Same-source cross-reference (if applicable)
- 下载产生的成功/失败记录由 download-log 特性展示；两 spec 独立生成
