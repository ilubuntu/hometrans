# Trace: REQ-029 播客设置

## 关联需求
REQ-029: 单播客级别设置，包括新单集处理方式、自动下载、播放速度、标签、认证、来源 URL。

## 代码溯源

### 1. 播客设置入口
- **FeedSettingsFragment.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/feed/preferences/FeedSettingsFragment.java:24`)
  - 播客设置页面的容器，通过 `newInstance(feedId)` 接收播客 ID。
  - 加载 `feed_settings.xml` 偏好定义。

### 2. 播客偏好设置项
- **FeedSettingsPreferenceFragment.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/feed/preferences/FeedSettingsPreferenceFragment.java:58`)
  - 核心设置逻辑，从数据库异步加载 Feed 对象及 `FeedPreferences`。
  - `onCreatePreferences()` (line 120): 加载偏好 XML，隐藏屏幕直到数据加载完成。
  - `setupPreferences()` (line 165): 配置所有偏好项的交互。

#### 各设置项详情：
- **新单集处理 (feedNewEpisodesAction)** (line 231-245):
  - 选项：GLOBAL（跟随全局）、ADD_TO_INBOX（加入收件箱）、ADD_TO_QUEUE（加入队列）、NOTHING（不做任何操作）。
  - 若播客已开启自动下载，显示提示信息且不可修改。
  - `FeedPreferences.NewEpisodesAction` 枚举 (FeedPreferences.java:41)。

- **自动下载 (includeAutoDownload)** (line 255-262):
  - 选项：GLOBAL、ENABLED、DISABLED。
  - `FeedPreferences.AutoDownloadSetting` 枚举 (FeedPreferences.java:82)。
  - `isAutoDownload(globalDefault)`: 计算实际是否自动下载 (line 207)。

- **自动删除 (autoDelete)** (line 214-220):
  - 选项：GLOBAL、ALWAYS、NEVER。
  - `FeedPreferences.AutoDeleteAction` 枚举 (FeedPreferences.java:20)。
  - `updateAutoDeleteSummary()`: 显示全局默认值或自定义值。

- **播放速度 (feedPlaybackSpeed)** (line 405-448):
  - `showPlaybackSpeedDialog()`: 弹出速度选择对话框，支持滑块（0.25x~4x）和"使用全局"复选框。
  - 同时可设置静音跳过 (SkipSilence): GLOBAL/OFF/AGGRESSIVE。
  - `FeedPreferences.SPEED_USE_GLOBAL = -1` 表示跟随全局。

- **跳过片头片尾 (feedAutoSkip)** (line 166-180):
  - `FeedPreferenceSkipDialog`: 设置跳过片头秒数和片尾秒数。
  - `feedSkipIntro` / `feedSkipEnding` 字段。

- **音量适配 (volumeReduction)** (line 221-230):
  - `VolumeAdaptionSetting`: 音量增益/减弱设置。
  - 修改后发送 `VolumeAdaptionChangedEvent`。

- **标签 (tags)** (line 263-267):
  - 打开 `TagSettingsDialog`，为播客设置标签。
  - 标签存储在 `FeedPreferences.tags` Set 中。

- **认证 (authentication)** (line 192-213):
  - `AuthenticationDialog`: 输入用户名和密码。
  - 保存后触发 Feed 刷新（`FeedUpdateManager.runOnce()`）。

- **剧集过滤器 (episodeFilter)** (line 182-191):
  - `EpisodeFilterDialog`: 设置剧集标题过滤规则。
  - `FeedFilter` 对象存储过滤条件。

- **保持更新 (keepUpdated)** (line 246-254):
  - 开关：是否在全局刷新时更新该播客。

- **剧集通知 (episodeNotification)** (line 268-281):
  - 开关：新剧集到达时显示通知。
  - 需通知权限（Android 13+）。

- **重命名 (rename)** (line 282-285):
  - `RenameFeedDialog`: 修改播客显示名称。

- **编辑 Feed URL (editFeedUrl)** (line 286-294):
  - `EditUrlSettingsDialog`: 修改播客的下载来源 URL。

- **重新连接本地文件夹 (reconnectLocalFolder)** (line 295-308):
  - 仅本地 Feed 显示，重新选择本地文件夹路径。

### 3. 设置数据模型
- **FeedPreferences.java** (`model/src/main/java/de/danoeh/antennapod/model/feed/FeedPreferences.java:13`)
  - 所有偏好字段的持有者，`Serializable`。
  - 字段：feedID, autoDownload, keepUpdated, autoDeleteAction, volumeAdaptionSetting, newEpisodesAction, username, password, feedPlaybackSpeed, feedSkipIntro, feedSkipEnding, feedSkipSilence, showEpisodeNotification, tags, filter。

### 4. 设置持久化
- **DBWriter.setFeedPreferences()**: 异步将 `FeedPreferences` 保存到数据库。
- **DBReader.getFeed()**: 异步读取 Feed 及其偏好设置。

### 5. 设置变更事件通知
- `SkipIntroEndingChangedEvent`: 跳过片头片尾变更。
- `SpeedPresetChangedEvent`: 播放速度变更。
- `VolumeAdaptionChangedEvent`: 音量适配变更。
- 通过 EventBus 广播，播放服务和 UI 实时响应。

### 6. 本地 Feed 特殊处理
- 本地 Feed 隐藏认证、自动下载、剧集过滤、编辑 URL 等不适用项 (line 146-151)。
- 显示"重新连接本地文件夹"选项。
