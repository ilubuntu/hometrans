# Trace: REQ-003 添加播客入口

## 关联需求
REQ-003: 用户可以从首页或导航进入 Add podcast 页面。页面应提供搜索播客、输入 RSS feed URL、导入 OPML 等入口。

## 代码溯源

### 1. 添加播客页面
- **AddFeedFragment.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/AddFeedFragment.java:60`)
  - 页面提供多种添加播客的途径。

#### a) 搜索入口
  - `searchItunesButton` (AddFeedFragment.java:93): 点击 → `OnlineSearchFragment.newInstance(ItunesPodcastSearcher.class)`。
  - `searchFyydButton` (AddFeedFragment.java:95): 点击 → `OnlineSearchFragment.newInstance(FyydPodcastSearcher.class)`。
  - `searchPodcastIndexButton` (AddFeedFragment.java:97): 点击 → `OnlineSearchFragment.newInstance(PodcastIndexPodcastSearcher.class)`。
  - `combinedFeedSearchEditText` (AddFeedFragment.java:100): 统一搜索输入框，输入后按搜索键或点击搜索按钮触发。
  - `searchButton` (AddFeedFragment.java:125): 搜索按钮。
  - `performSearch()` (AddFeedFragment.java:182):
    - 若输入匹配 URL 模式（`http[s]?://.*`）→ 直接走 `addUrl()` 添加。
    - 否则 → `OnlineSearchFragment.newInstance(CombinedSearcher.class, query)` 联合搜索。

#### b) RSS URL 输入
  - `addViaUrlButton` (AddFeedFragment.java:105): 点击 → `showAddViaUrlDialog()`。
  - `showAddViaUrlDialog()` (AddFeedFragment.java:145):
    - 弹出 URL 输入对话框，提示"RSS 地址"。
    - 自动从剪贴板预填（若剪贴板内容以 "http" 开头）。
    - 正面按钮点击时校验 URL 格式（`Patterns.WEB_URL`），无效则显示错误提示。
    - 有效 → `addUrl()`。
  - `addUrl(url)` (AddFeedFragment.java:178):
    - 启动在线 Feed 预览页 `OnlineFeedviewActivityStarter(context, url).withManualUrl().getIntent()`。

#### c) OPML 导入
  - `opmlImportButton` (AddFeedFragment.java:108): 点击 → 系统文件选择器（`chooseOpmlImportPathLauncher.launch("*/*")`）。
  - `chooseOpmlImportPathResult(uri)` (AddFeedFragment.java:194):
    - 启动 `OpmlImportActivity`，传入文件 URI。

#### d) 本地文件夹添加
  - `addLocalFolderButton` (AddFeedFragment.java:117): 点击 → 文件夹选择器（`addLocalFolderLauncher.launch(null)`）。
  - `addLocalFolderResult(uri)` (AddFeedFragment.java:203):
    - 异步将文件夹创建为本地 Feed（`addLocalFolder()`）。
    - 成功后导航到 FeedItemlistFragment。
  - `addLocalFolder(uri)` (AddFeedFragment.java:220):
    - 创建 `Feed(PREFIX_LOCAL_FOLDER + uri)` 并保存到数据库。
    - 触发 Feed 更新。

### 2. 导航入口
- 添加播客页面可通过以下方式进入：
  - 主导航的 "Add Feed" 入口（NavigationNames → AddFeedFragment.TAG）。
  - 订阅列表页面的浮动添加按钮（`subscriptionAddButton` in SubscriptionFragment.java）。
  - 空库首页的指引箭头指向添加入口。

### 3. 搜索服务
- **CombinedSearcher** (`net/discovery/`): 联合搜索，聚合多个搜索源。
- **ItunesPodcastSearcher** (`net/discovery/ItunesPodcastSearcher.java:22`): iTunes 搜索。
- **FyydPodcastSearcher** (`net/discovery/`): Fyyd 搜索。
- **PodcastIndexPodcastSearcher** (`net/discovery/PodcastIndexPodcastSearcher.java:27`): Podcast Index 搜索。

## 关键发现
1. 添加播客页面提供 4 种入口：联合搜索、按搜索平台搜索、RSS URL 输入、OPML 导入，外加本地文件夹添加。
2. 搜索框输入若为 URL 格式会自动识别并切换为 RSS 订阅流程，不需要用户手动区分。
3. RSS URL 输入支持剪贴板自动预填和格式校验。
4. OPML 导入通过系统文件选择器选择文件后进入专门的导入流程。
5. 本地文件夹可以作为一个"本地播客"添加，自动扫描其中的媒体文件。
