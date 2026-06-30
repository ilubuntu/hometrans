# Trace: REQ-008 单集详情页

## 关联需求
REQ-008: 点击单集后进入详情页，展示单集标题、播客名称、发布时间、描述、播放按钮、下载按钮、加入队列、收藏、分享等操作。

## 代码溯源

### 1. 单集详情页
- **ItemFragment.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/episode/ItemFragment.java:74`)
  - 展示单个 FeedItem 的详细信息和操作。

#### a) 页面初始化
  - `onCreate()`: 从参数获取 `itemId`。
  - `newInstance(feeditem)` (ItemFragment.java:85): 创建实例并传入单集 ID。
  - `onCreateView()` (ItemFragment.java):
    - 初始化视图绑定。
    - `txtvTitle`: 单集标题（支持连字符换行，长按可复制）。
    - `txtvPodcast`: 播客名称（可点击进入播客详情，长按可复制）。
    - `imgvCover`: 封面图片（可点击进入播客详情）。
    - `webvDescription`: 描述区域（支持 HTML 渲染、时间码点击跳转播放位置）。
    - `butAction1` / `butAction2`: 两个主要操作按钮。
    - `txtvDuration`: 时长显示。
    - `circularProgressBar`: 下载进度环形指示器。

#### b) 数据加载
  - `load()` (ItemFragment.java): 异步加载单集数据。
  - `loadInBackground()` (ItemFragment.java): 后台从数据库加载 FeedItem 及关联数据（Feed、Media）。
  - `onFragmentLoaded()` (ItemFragment.java): 数据加载完成后更新 UI。
    - `updateAppearance()`: 更新标题、播客名、封面、描述。
    - `updateButtons()`: 更新操作按钮状态。

#### c) 操作按钮 (ItemFragment.java:280)
  - `updateButtons()`:
    - **第一个按钮 (butAction1)**: 上下文感知的播放按钮
      - 正在播放 → `PauseActionButton`（暂停）
      - 本地 Feed → `PlayLocalActionButton`（本地播放）
      - 已下载 → `PlayActionButton`（播放）
      - 未下载 → `StreamActionButton`（在线播放/流式播放）
    - **第二个按钮 (butAction2)**: 上下文感知的下载按钮
      - 正在下载 → `CancelDownloadActionButton`（取消下载）
      - 未下载 → `DownloadActionButton`（下载）
      - 已下载 → `DeleteActionButton`（删除下载）
    - 无媒体时：butAction1 = 标记已播放，butAction2 = 访问网站。
    - 显示下载进度 `circularProgressBar`。

#### d) 智能行为配置提示
  - `showOnDemandConfigBalloon(offerStreaming)` (ItemFragment.java):
    - 基于使用统计（`UsageStatistics.hasSignificantBiasTo()`）判断用户偏好。
    - 若用户习惯与当前操作相反（如偏好流式但点了下载），弹出气球提示询问是否切换默认行为。

#### e) 上下文菜单
  - `onContextItemSelected()`: 描述区域的上下文菜单。
  - 上下文菜单/更多操作包含：加入/移出队列、收藏/取消收藏、分享、标记已播放、删除下载、复制链接等。

#### f) 导航
  - `openPodcast()` (ItemFragment.java:339): 点击播客名称或封面 → 进入播客详情页。
    - 已订阅 → `FeedItemlistFragment.newInstance(feedId)`。
    - 未订阅 → `OnlineFeedviewActivityStarter`。

#### g) 事件监听
  - `onEventMainThread(FeedItemEvent)`: 单集数据变化时重新加载。
  - `onEventMainThread(EpisodeDownloadEvent)`: 下载状态变化时更新按钮。
  - `onPlayerStatusChanged()`: 播放状态变化时更新按钮。

### 2. 单集详情页容器
- **ItemPagerFragment.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/episode/ItemPagerFragment.java:38`)
  - 单集详情的翻页容器，支持左右滑动切换相邻单集。
  - `newInstance(feedItemIds, feedItemId)`: 传入单集 ID 数组和当前 ID，支持翻页浏览。
  - 内部使用 ViewPager，每页是一个 ItemFragment。

### 3. 描述渲染
- `webvDescription`: 使用 WebView 渲染 HTML 描述。
  - 支持时间码点击跳转（`setTimecodeSelectedListener`）。
  - 支持长按复制。

## 关键发现
1. 单集详情页展示：标题、播客名称、发布时间、封面、描述（HTML）、时长。
2. 两个主要操作按钮根据状态动态切换：播放/暂停/流式播放 + 下载/取消/删除。
3. 通过 ItemPagerFragment 支持左右滑动切换相邻单集。
4. 描述区域支持时间码点击跳转到播放位置（需正在播放同一单集）。
5. 点击播客名称或封面可跳转到播客详情页。
6. 基于使用统计的智能行为配置：若检测到用户偏好与操作不符，提示是否切换默认行为。
7. 长按标题和播客名可复制到剪贴板。
8. 页面通过事件总线实时响应单集状态变化。
