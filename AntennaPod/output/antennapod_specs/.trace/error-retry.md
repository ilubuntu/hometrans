# Trace: REQ-039 错误状态与重试

## 关联需求
REQ-039: 错误处理：网络失败、RSS 解析失败、下载失败，提供错误信息和重试。

## 代码溯源

### 1. 下载错误类型定义
- **DownloadError.java** (`model/src/main/java/de/danoeh/antennapod/model/download/DownloadError.java:4`)
  - 枚举所有下载错误类型（22 种）：
    - `SUCCESS(0)`: 成功
    - `ERROR_PARSER_EXCEPTION(1)`: 解析异常
    - `ERROR_UNSUPPORTED_TYPE(2)`: 不支持的类型
    - `ERROR_CONNECTION_ERROR(3)`: 连接错误
    - `ERROR_MALFORMED_URL(4)`: URL 格式错误
    - `ERROR_IO_ERROR(5)`: IO 错误
    - `ERROR_DOWNLOAD_CANCELLED(7)`: 下载取消
    - `ERROR_HTTP_DATA_ERROR(9)`: HTTP 数据错误
    - `ERROR_NOT_ENOUGH_SPACE(10)`: 空间不足
    - `ERROR_UNKNOWN_HOST(11)`: 未知主机
    - `ERROR_UNAUTHORIZED(14)`: 未授权（需认证）
    - `ERROR_FORBIDDEN(16)`: 禁止访问
    - `ERROR_NOT_FOUND(20)`: 资源不存在
    - `ERROR_CERTIFICATE(21)`: 证书错误
    - 等。
  - `fromCode(int)`: 从代码转换为枚举。

### 2. 错误标签映射
- **DownloadErrorLabel.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/download/DownloadErrorLabel.java:11`)
  - `from(DownloadError)` (line 14): 将错误枚举映射为用户可读的文本资源 ID。
  - 为每种错误提供本地化的错误描述。
  - 未映射的错误返回"未知错误"。

### 3. 下载错误结果
- **DownloadResult.java** (`model/src/main/java/de/danoeh/antennapod/model/download/DownloadResult.java:10`)
  - 下载结果记录对象。
  - 字段：reason (DownloadError)、reasonDetailed (详细信息)、successful、cancelled。
  - `setCancelled()` (line 119): 标记为已取消。
  - 存储到下载日志中。

### 4. 单集下载错误处理与重试
- **EpisodeDownloadWorker.java** (`net/download/service/src/main/java/de/danoeh/antennapod/net/download/service/episode/EpisodeDownloadWorker.java`)
  - `performDownload()` (line 138): 执行下载并处理结果。

#### a) 下载失败处理 (line 188-217):
  - HTTP 416 错误（无效范围）→ 删除文件并重试 (line 198-204)。
  - 不可恢复错误（FORBIDDEN、NOT_FOUND、UNAUTHORIZED、IO_BLOCKED）→ 立即失败，发送通知 (line 208-215)。
  - 其他错误 → 尝试重试。

#### b) 重试机制 (line 220-227):
  - `retry3times()`: 最多重试 3 次（`getRunAttemptCount() >= 2`）。
  - 最后一次重试失败后发送错误通知。
  - 非最后一次重试时返回 `Result.retry()`。

#### c) 重试状态通知:
  - `sendMessage(title, isImmediateFail)` (line 233): 显示"正在重试"或"下载失败"提示。
  - `sendErrorNotification(title)`: 发送下载失败通知。

#### d) 下载结果记录:
  - `DBWriter.addDownloadStatus(status)`: 记录下载结果到日志。

### 5. Feed 解析错误处理
- **FeedParserTask.java** (`net/download/service/src/main/java/de/danoeh/antennapod/net/download/service/feed/remote/FeedParserTask.java:23`)
  - `call()` (line 37): 执行 Feed 解析。
  - 解析失败时返回 `DownloadResult` 带有 `ERROR_PARSER_EXCEPTION`。

### 6. HTTP 下载错误处理
- **HttpDownloader.java** (`net/download/service/src/main/java/de/danoeh/antennapod/net/download/service/feed/remote/HttpDownloader.java`)
  - `callOnFailByResponseCode(int code)` (line 260): 根据 HTTP 状态码判断错误类型。
    - 401 → UNAUTHORIZED
    - 403 → FORBIDDEN
    - 404 → NOT_FOUND
    - 等。
  - `onSuccess()` (line 292): 下载成功处理。

### 7. 在线 Feed 查看错误处理
- **OnlineFeedViewActivity.java**
  - `checkDownloadResult()` (line 273): 检查 Feed 下载结果。
  - 根据错误类型显示不同的错误对话框。
  - 提供编辑 URL 和重试入口。

### 8. 下载日志查看
- **DownloadLogFragment**:
  - 显示所有下载结果的日志。
  - 包含成功和失败的记录。
  - 每条记录显示：时间、标题、状态、错误详情。
  - 失败记录可查看错误详情和重试。

### 9. 同步错误处理
- **SyncService.java** (`net/sync/service/.../SyncService.java`)
  - `doWork()` (line 64): 执行同步，捕获 `SyncServiceException`。
  - 同步失败时记录错误状态。
  - 用户可在同步设置页查看错误状态。

### 10. 数据库错误处理
- **PodDBAdapter.java** (`storage/database/src/main/java/de/danoeh/antennapod/storage/database/PodDBAdapter.java`)
  - `PodDBErrorHandler` (line 1534): 数据库错误处理器。
  - `PodDBHelper` (line 1556): 数据库创建和升级。

### 11. 下载日志测试
- **DownloadLogTest.java** (`app/src/androidTest/java/de/test/antennapod/ui/DownloadLogTest.java:40`)
  - `testNonExistingFeed()` (line 89): 测试不存在的 Feed 的错误处理。
