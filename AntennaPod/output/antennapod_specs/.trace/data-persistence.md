# Trace: REQ-040 数据持久化

## 关联需求
REQ-040: 数据持久化：订阅、队列、收藏、播放历史、下载、设置在重启后保持。

## 代码溯源

### 1. 数据库核心
- **PodDBAdapter.java** (`storage/database/src/main/java/de/danoeh/antennapod/storage/database/PodDBAdapter.java`)
  - SQLite 数据库适配器，所有数据的持久化入口。
  - **PodDBHelper** (line 1556): 继承 SQLiteOpenHelper，管理数据库创建和升级。
    - `onCreate()`: 创建所有表。
    - `onUpgrade()`: 处理数据库版本升级和数据迁移。
  - **PodDBErrorHandler** (line 1534): 数据库错误处理器。
  
#### 数据库表结构（关键字段）：
  - **Feeds 表**: 订阅的播客（标题、URL、描述、封面、状态等）。
  - **FeedItems 表**: 剧集（标题、描述、发布日期、状态等）。
  - **FeedMedia 表**: 媒体文件（下载 URL、本地路径、时长、位置等）。
  - **FeedPreferences 表**: 播客偏好设置（自动下载、标签等）。
  - **Queue 表**: 播放队列（排序顺序）。
  - **Favorites 表**: 收藏列表。
  - **PlaybackHistory 表**: 播放历史。
  - **DownloadLog 表**: 下载日志。
  - **SimpleChapters 表**: 章节信息。

#### 关键方法：
  - `getMonthlyStatisticsCursor()` (line 1227): 统计查询。
  - `getRandomEpisodesCursor()` (line 1145): 随机剧集查询。
  - 各种 CRUD 操作。

### 2. 数据库写入器
- **DBWriter.java** (`storage/database/src/main/java/de/danoeh/antennapod/storage/database/DBWriter.java:37`)
  - 所有数据写入操作的异步入口。
  - 返回 `Future<?>` 支持异步等待。

#### 关键写入方法：
  - **订阅管理**: `addNewFeed()`、`deleteFeed()`、`setFeedPreferences()`。
  - **队列管理**: `addQueueItem()`、`addQueueItemAt()`、`removeQueueItem()`、`moveQueueItem()`、`clearQueue()`、`moveQueueItemsToBottom()`、`moveQueueItemsToTop()`。
  - **收藏管理**: `addFavoriteItems()`、`removeFavoriteItems()`。
  - **播放历史**: `addItemToPlaybackHistory()`、`deleteFromPlaybackHistory()`、`clearPlaybackHistory()`。
  - **下载状态**: `addDownloadStatus()`、`clearDownloadLog()`、`setMediaDownloadInformation()`。
  - **播放状态**: `markItemsPlayed()`、`removeFeedNewFlag()`、`removeAllNewFlags()`。
  - **排序**: `applySortOrder()`（队列重排序）。
  - **统计**: `resetStatistics()`。
  - **清理**: `deleteFeedItems()`、`deleteFeedMediaOfItem()`。

### 3. 数据库读取器
- **DBReader.java** (`storage/database/src/main/java/de/danoeh/antennapod/storage/database/DBReader.java:37`)
  - 所有数据读取操作的入口。
  - **关键读取方法**:
    - `getFeed()`: 读取单个 Feed 及其剧集。
    - `getFeedList()`: 获取所有订阅列表。
    - `getNavDrawerData()`: 导航抽屉数据（标签分组、订阅列表）。
    - `getPlaybackHistory()`: 播放历史。
    - `getQueue()`: 播放队列。
    - `getFavoriteItemsList()`: 收藏列表。
    - `getDownloadLog()`: 下载日志。
    - `getRecentlyPublishedEpisodes()`: 最新剧集。

### 4. 数据库游标映射
- **FeedItemCursor.java** (`storage/database/.../mapper/FeedItemCursor.java:13`)
  - `getFeedItem()` (line 60): 从数据库游标构建 FeedItem 对象。
- **FeedItemFilterQuery.java**: 基于过滤条件构建查询。
- **FeedItemSortQuery.java**: 基于排序条件构建查询。

### 5. 偏好持久化
- **UserPreferences.java** (`storage/preferences/`)
  - 使用 SharedPreferences 存储所有用户设置。
  - 主题、播放设置、下载设置、导航偏好等。
  - `setTheme()`、`getTheme()` 等方法。

- **SynchronizationCredentials.java** (`storage/preferences/`)
  - 同步凭证的持久化存储。
  - Serializable 对象存储到 SharedPreferences。

- **FeedPreferences.java** (`model/`)
  - 单播客偏好，Serializable，存储在数据库中。
  - tags、autoDownload、认证信息等。

### 6. Feed 数据库写入器
- **FeedDatabaseWriter.java** (`storage/database/`)
  - `updateFeed()`: 更新或新建 Feed。
  - 合并新旧 Feed 数据（保留播放位置等状态）。

### 7. 数据库导出/导入
- **DatabaseExporter.java** (`storage/importexport/src/main/java/de/danoeh/antennapod/storage/importexport/DatabaseExporter.java:19`)
  - `exportToStream()` (line 44): 导出数据库到文件流。
  - 支持完整数据库备份和恢复。

### 8. OPML 备份代理
- **OpmlBackupAgent.java** (`storage/importexport/src/main/java/de/danoeh/antennapod/storage/importexport/OpmlBackupAgent.java:36`)
  - **OpmlBackupHelper** (line 47): 系统级自动备份。
  - `onCreate()` (line 39): 备份初始化。
  - 将订阅列表备份到系统备份服务。

### 9. 自动数据库导出
- **AutomaticDatabaseExportWorker**: 定期自动导出数据库备份。
  - `UserPreferences.getAutomaticExportFolder()`: 获取自动备份目录。

### 10. 数据库维护
- **storage/database-maintenance-service**: 定期清理数据库。
  - 清理孤立的剧集记录。
  - 清理过期的下载日志。
  - 优化数据库大小。

### 11. 播放位置持久化
- **FeedMedia**: 记录 `position`（当前播放位置）和 `duration`（总时长）。
- 播放服务定期保存播放位置到数据库。
- 重启后恢复到上次播放位置。

### 12. EventBus 数据变更通知
- 数据变更后通过 EventBus 广播事件：
  - `FeedItemEvent`: 剧集数据变更。
  - `MessageEvent`: 通用消息。
  - `StatisticsEvent`: 统计数据变更。
  - `SyncServiceEvent`: 同步状态变更。
- UI 组件监听事件实时更新。
