# Code trace · download-log

## Status
status: ok
repo-id: AntennaPod
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 下载日志面板 (DownloadLogFragment) — app/src/main/java/de/danoeh/antennapod/ui/screen/download/DownloadLogFragment.java:34 — recalled by: both
- Entry 2: 已下载页"下载日志"按钮 — CompletedDownloadsFragment.onMenuItemClick:177 (R.id.action_download_logs) → DownloadLogFragment.show — recalled by: path 2
- Entry 3: 已下载页自动弹出（有失败时）— CompletedDownloadsFragment ARG_SHOW_LOGS:69 → 自动 show :132 — recalled by: path 2

## Entry · 下载日志面板容器 (DownloadLogFragment)
- claim: 以底部弹层展示历次下载的成功/失败记录，点击可查看失败详情，可清空全部日志
- layers:
  - code:     DownloadLogFragment.java:34 (extends BottomSheetDialogFragment); loadDownloadLog:109 → DBReader.getDownloadLog() (返回 DownloadResult 列表); onStart:44 触发加载; DownloadLogAdapter 渲染
  - resource: R.layout.download_log_fragment (含 toolbar/list); app/src/main/res/menu/download_log.xml (clear_logs_item); R.drawable.ic_download 空状态图标; R.string.no_log_downloads_head_label / R.string.no_log_downloads_label 空状态文案; R.string.downloads_log_label
  - manifest: N/A: 弹层组件，无独立清单声明
- interaction: 内存 downloadLog 列表
- data_flow: onStart → loadDownloadLog → DBReader.getDownloadLog → PodDBAdapter → 展示

## Entry · 日志条目渲染（成功/失败、原因、重试）
- claim: 每条记录展示标题、类型（节目源/单集媒体）、完成时间、成功或失败图标及失败原因；失败且无更新成功记录时提供重试按钮
- layers:
  - code:     DownloadLogAdapter.bind:55 — 成功→ic_check + 隐藏原因/详情/重试 (:73-78)；失败→ic_error（重复解析异常用 ic_info）+ 原因 DownloadErrorLabel.from(reason) (:80-87) + 重试按钮；newerWasSuccessful:125（同一文件更新记录已成功则隐藏重试）；重试：节目源 FeedUpdateManager.runOnce(feed) (:99-107)，单集媒体 DownloadActionButton 重新下载 (:108-119)
  - resource: R.drawable.ic_check / ic_error / ic_info / ic_refresh; R.string.download_successful / R.string.error_label; R.string.download_type_feed / R.string.download_type_media; DownloadErrorLabel (app/.../download/DownloadErrorLabel.java:11) 映射各 DownloadError 到用户可见文案（连接错误、IO错误、空间不足、未知主机、未授权、禁止访问、未找到、证书错误、被拦截等）
  - manifest: N/A
- interaction: 读取 DownloadResult 字段（title/feedfileType/reason/reasonDetailed/successful/completionDate）
- data_flow: 日志条目渲染 → 读取 DownloadResult → 成功/失败分支

## Entry · 查看失败详情 (DownloadLogDetailsDialog)
- claim: 点击某条记录弹出详情对话框，展示节目名、单集名、文件地址、技术原因（成功则展示"下载成功"），可复制地址/原因，可跳转到节目
- layers:
  - code:     DownloadLogFragment.onItemClick:87 → DownloadLogDetailsDialog.newInstance(item, true).show (app/.../download/DownloadLogDetailsDialog.java:30); loadData:108 按 feedfileType 查询 FeedMedia/Feed 得到 podcastName/episodeName/url; updateUi 失败展示 getReasonDetailed、成功展示 download_successful; goToFeed 跳转节目; ClipboardUtils 复制地址/技术原因
  - resource: R.string.download_error_details 标题; R.string.download_successful; R.string.copy_to_clipboard; R.string.download_log_details_file_url_title / R.string.download_log_details_technical_reason_title
  - manifest: N/A
- interaction: 无写入，纯读取展示
- data_flow: 点击日志条目 → DownloadLogDetailsDialog → loadData(DBReader.getFeedMedia/getFeed) → updateUi 展示

## Entry · 清空下载日志
- claim: 一键清空全部下载日志记录
- layers:
  - code:     DownloadLogFragment.onMenuItemClick:101 (R.id.clear_logs_item) → DBWriter.clearDownloadLog() (storage/database/.../DBWriter.java，删除全部下载日志 → EventBus DownloadLogEvent.listUpdated)
  - resource: app/src/main/res/menu/download_log.xml:6 clear_logs_item; R.drawable.ic_delete; R.string.clear_history_label
  - manifest: N/A
- interaction: 数据库清空下载日志表
- data_flow: 工具栏"清空" → DBWriter.clearDownloadLog → DownloadLogEvent → onDownloadLogChanged:96 → loadDownloadLog（列表清空）

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: DownloadLogEvent（下载完成/失败/取消产生新日志记录）— DownloadLogFragment.onDownloadLogChanged:96 — 行为：重新加载日志列表
- Trigger: 下载任务结束写入 DownloadResult — MediaDownloadedHandler.run / FeedUpdateWorker.refreshFeeds / FeedParserTask 等 → 经 DownloadLogEvent 刷新
- Trigger: 已下载页带失败时打开自动弹出日志（ARG_SHOW_LOGS）— CompletedDownloadsFragment.java:132

## Core business entities (data model / persistence key / state machine)
- DownloadResult: 下载结果实体（model/download），字段 title/feedfileId/feedfileType/reason(DownloadError)/reasonDetailed/successful/completionDate
- DownloadError: 失败原因枚举（连接错误/IO错误/空间不足/未知主机/未授权/禁止访问/未找到/证书错误/被拦截/取消等），经 DownloadErrorLabel 映射为用户可见文案
- feedfileType: FEEDFILETYPE_FEED（节目源）/ FEEDFILETYPE_FEEDMEDIA（单集媒体）

## Cross-entry shared declarations
- 无独立清单声明；下载日志由后台下载任务（节目更新/单集下载）写入 DownloadResult，下载日志面板仅读取展示

## Deviations from REQ_DESC
1. REQ_DESC 提及"failure details"，代码实现为 DownloadLogDetailsDialog 展示 reasonDetailed 等技术细节，语义一致
2. 成功记录也可在日志中查看（不限于失败），代码展示成功图标与"下载成功"——spec 同时覆盖成功与失败记录
(empty → None)

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 已下载页工具栏"下载日志"按钮 → DownloadLogFragment 弹层
- 已下载页打开时若有失败记录（ARG_SHOW_LOGS）自动弹出
（均为同一 DownloadLogFragment 弹层）

### Consumers (who reads this state / data)
- DownloadLogAdapter: 渲染日志条目
- DownloadLogDetailsDialog: 渲染失败详情
- 已下载页 onDownloadLogChanged: 监听日志变化以刷新已下载列表

### Non-consumers (boundary counter-examples with evidence)
- claim: 单集总列表/收件箱/收藏/播放历史页不展示下载日志入口
  closure_layers: [code, resource]
  tools: [Read episodes.xml/inbox.xml/favorites.xml/playback_history.xml]
  zero_hits: action_download_logs 仅在 downloads_completed.xml；其他页面菜单无下载日志入口

## Same-source cross-reference (if applicable)
- 下载日志与已下载页（completed-downloads）通过 DownloadLogFragment 关联；两 spec 独立生成
