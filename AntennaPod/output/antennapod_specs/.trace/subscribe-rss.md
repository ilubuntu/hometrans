# Trace: REQ-004 通过稳定 RSS feed 订阅播客

## 关联需求
REQ-004: 用户输入稳定 podcast RSS feed URL 后，应用应解析 feed 信息，展示播客名称、封面、描述和单集列表，并允许确认订阅。

## 代码溯源

### 1. RSS 预览页
- **OnlineFeedViewActivity.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/onlinefeedview/OnlineFeedViewActivity.java:79`)
  - 接收 URL，下载并解析 Feed，展示预览信息，确认订阅。

#### a) 初始化与下载
  - `onCreate()` (OnlineFeedViewActivity.java): 从 Intent 获取 URL。
  - `lookupUrlAndDownload(url)` (OnlineFeedViewActivity.java): URL 查找并启动下载。
    - 若 URL 是网页而非直接 Feed，尝试通过搜索找到 Feed URL。
    - `tryToRetrieveFeedUrlBySearch()` (OnlineFeedViewActivity.java:205): 通过搜索反查 Feed URL。
    - `searchFeedUrlByTrackName()`: 按曲名搜索找到 Feed URL。
  - `downloadIfNotAlreadySubscribed()` (OnlineFeedViewActivity.java): 检查是否已订阅，若未订阅则继续。
  - `startFeedDownload(url)` (OnlineFeedViewActivity.java): 启动 Feed 下载任务。
    - 支持认证（username/password）。

#### b) 解析
  - `checkDownloadResult()` (OnlineFeedViewActivity.java): 检查下载结果状态。
  - `parseFeed()` (OnlineFeedViewActivity.java): 解析已下载的 Feed 文件。
  - `doParseFeed()` (OnlineFeedViewActivity.java): 执行实际解析逻辑。
    - 使用 FeedHandler 解析 RSS/Atom XML。
  - `onEventMainThread()`: 监听下载完成事件。

#### c) Feed 发现（多 Feed 选择）
  - `showFeedDiscoveryDialog(downloadedUrl, feeds)`: 当页面包含多个 Feed 时，弹出选择对话框让用户选择具体的 Feed。

#### d) 预览展示
  - `showFeedFragment(feed)` (OnlineFeedViewActivity.java:362):
    - 展示解析后的 Feed 信息：标题、封面、描述、单集列表。
    - 显示订阅确认按钮。

#### e) 错误处理
  - `showErrorDialog()` (OnlineFeedViewActivity.java): 显示错误对话框（解析失败、网络错误等）。
  - `showNoPodcastFoundError()` (OnlineFeedViewActivity.java): 未找到播客的错误提示。
  - `editUrl()`: 允许用户编辑/修正 URL 后重试。

### 2. 订阅确认
  - 用户在预览页点击订阅按钮后：
    - 调用 `FeedDatabaseWriter.updateFeed()` 将 Feed 保存到数据库。
    - `openFeed(feedId)` (OnlineFeedViewActivity.java): 导航到播客详情页（FeedItemlistFragment）。
    - 返回主应用，新订阅出现在订阅列表中。

### 3. Feed 解析器
- **parser/feed 模块**: 
  - `FeedHandler`: 主解析入口，检测 RSS/Atom 格式。
  - `SyndHandler` (`parser/feed/src/main/java/de/danoeh/antennapod/parser/feed/SyndHandler.java`): SAX 处理器，处理 XML 元素。
  - 支持多种命名空间（RSS 2.0, Atom, iTunes, Media RSS, Podcast Index 等）。

### 4. URL 校验
- **UrlChecker** (`net/common/`): URL 规范化与校验。
  - 补全协议前缀（http → https）。
  - 处理 deeplink（如 antennapod://subscribe/）。

### 5. 认证支持
- 属性 `username`, `password` (OnlineFeedViewActivity.java): 支持需要认证的 Feed。
- 订阅时可输入用户名密码。

## 关键发现
1. RSS 订阅流程：输入 URL → 下载 → 解析 → 预览 → 确认订阅。
2. URL 可能不是直接 Feed，应用会尝试搜索反查真实 Feed URL。
3. 支持多 Feed 发现：当页面包含多个 Feed 链接时，让用户选择。
4. 解析支持 RSS 2.0、Atom 及多种播客扩展命名空间。
5. 支持需要认证的私有 Feed。
6. 订阅前可查看 Feed 预览（标题、封面、描述、单集列表），确认后才正式订阅。
7. 错误处理完善：网络错误、解析失败、未找到播客都有对应的错误提示和重试入口。
