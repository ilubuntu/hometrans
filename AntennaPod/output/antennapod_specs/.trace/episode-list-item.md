# Trace: REQ-007 单集列表项

## 关联需求
REQ-007: 单集列表项应展示标题、发布日期/时长、播放状态、下载状态、是否在队列、更多操作等信息。

## 代码溯源

### 1. 单集列表项视图持有者
- **EpisodeItemViewHolder.java** (`app/src/main/java/de/danoeh/antennapod/ui/episodeslist/EpisodeItemViewHolder.java:39`)
  - 每个单集列表项的视图绑定与渲染逻辑。

#### a) UI 元素定义 (EpisodeItemViewHolder.java:42-61)
  - `container`: 整个列表项容器（透明度反映已播放状态）。
  - `cover` / `coverHolder`: 封面图片（点击进入播客详情）。
  - `placeholder`: 封面占位文本（播客标题）。
  - `title`: 单集标题。
  - `pubDate`: 发布日期。
  - `position`: 播放进度文本。
  - `duration`: 时长文本。
  - `size`: 文件大小。
  - `isInbox`: 新单集标记图标（新/未读标记）。
  - `isInQueue`: 在队列中标记图标。
  - `isVideo`: 视频类型标记图标。
  - `isFavorite`: 收藏标记图标。
  - `progressBar`: 播放进度条。
  - `secondaryActionButton` / `secondaryActionIcon`: 次要操作按钮（播放/下载/取消下载等）。
  - `secondaryActionProgress`: 下载进度环形指示器。
  - `separatorIcons`: 图标分隔符。
  - `dragHandle`: 拖拽手柄（队列页面用）。

#### b) 数据绑定 (EpisodeItemViewHolder.java:93)
  - `bind(FeedItem item)`:
    - 设置标题 `title.setText(item.getTitle())`。
    - 设置发布日期 `pubDate.setText(DateFormatter.formatAbbrev(...))`。
    - 新单集标记：`isInbox.setVisibility(item.isNew() ? VISIBLE : GONE)`。
    - 收藏标记：`isFavorite.setVisibility(item.isTagged(TAG_FAVORITE) ? VISIBLE : GONE)`。
    - 队列标记：`isInQueue.setVisibility(item.isTagged(TAG_QUEUE) ? VISIBLE : GONE)`。
    - 已播放状态：`container.setAlpha(item.isPlayed() ? 0.5f : 1.0f)`（已播放半透明）。
    - 配置次要操作按钮 `ItemActionButton.forItem(item)`。

#### c) 媒体信息绑定 (EpisodeItemViewHolder.java:135)
  - `bind(FeedMedia media)`:
    - 视频标记：`isVideo.setVisibility(media.getMediaType() == VIDEO ? VISIBLE : GONE)`。
    - 时长显示：`duration.setText(Converter.getDurationStringLong(media.getDuration()))`。
    - 下载状态判断：
      - 正在下载 → `secondaryActionProgress.setPercentage(percent)` 显示进度。
      - 已下载 → 进度100%。
      - 未下载 → 进度0%。
    - 正在播放：`itemView.setActivated(PlaybackStatus.isCurrentlyPlaying(media))`。
    - 播放进度：`progressBar` 显示已播放百分比，`position` 显示当前播放位置文本。

#### d) 封面加载 (EpisodeItemViewHolder.java:125)
  - `CoverLoader`: 异步加载单集封面，回退到播客封面。

#### e) 次要操作按钮
  - `ItemActionButton.forItem(item)`: 根据单集状态动态选择操作：
    - 正在播放 → 暂停按钮。
    - 已下载 → 播放按钮。
    - 未下载 → 下载按钮。
    - 正在下载 → 取消下载按钮。

### 2. 列表适配器
- **EpisodeItemListAdapter.java** (`app/src/main/java/de/danoeh/antennapod/ui/episodeslist/EpisodeItemListAdapter.java:31`)
  - 管理 EpisodeItemViewHolder 列表。
  - 支持多选模式。
  - 提供 OnSelectModeListener 回调。
  - 被多个列表页面复用：FeedItemlistFragment, AllEpisodesFragment, InboxFragment, FavoritesFragment, QueueFragment 等。

### 3. 更多操作菜单
- 列表项长按或点击更多图标 → 上下文菜单/底部弹窗。
- 菜单项包括：播放、下载、加入队列/移出队列、收藏/取消收藏、分享、标记已播放、删除下载、访问网站等。

## 关键发现
1. 单集列表项是一个高度信息密集的卡片，包含标题、日期、时长、进度、多种状态图标。
2. 已播放的单集透明度降低（0.5），视觉上与未播放的区分。
3. 次要操作按钮（右侧）是上下文感知的：根据下载/播放状态自动切换为播放/下载/暂停/取消。
4. 下载进度通过环形进度条实时显示在操作按钮位置。
5. 状态图标（新、队列、视频、收藏）以小图标形式排列在标题下方。
6. 封面图片可点击进入播客详情页。
7. 该 ViewHolder 被多个页面复用（单集列表、全部单集、收件箱、收藏、队列等），保持一致的展示风格。
8. 更多操作通过长按或菜单按钮触发，提供完整的单集操作集。
