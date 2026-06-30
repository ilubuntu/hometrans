# Trace: REQ-037 统计页面

## 关联需求
REQ-037: 收听统计：播放时长、订阅数、单集数等统计数据。

## 代码溯源

### 1. 统计页面主框架
- **StatisticsFragment.java** (`ui/statistics/src/main/java/de/danoeh/antennapod/ui/statistics/StatisticsFragment.java:40`)
  - 使用 ViewPager2 + TabLayout 实现三个标签页。
  - `StatisticsPagerAdapter` (line 149): 管理三个子页面。

#### 三个标签页：
- **POS_SUBSCRIPTIONS (0)**: 按订阅统计 → `SubscriptionStatisticsFragment` (line 159)。
- **POS_YEARS (1)**: 按年份统计 → `YearsStatisticsFragment` (line 161)。
- **POS_SPACE_TAKEN (2)**: 下载空间统计 → `DownloadStatisticsFragment` (line 164)。

### 2. 按订阅统计
- **SubscriptionStatisticsFragment** (`ui/statistics/.../subscriptions/SubscriptionStatisticsFragment.java`)
  - 显示每个播客的播放时长。
  - 按播放时长降序排列。

- **PlaybackStatisticsListAdapter.java** (`ui/statistics/src/main/java/de/danoeh/antennapod/ui/statistics/subscriptions/PlaybackStatisticsListAdapter.java:19`)
  - `getHeaderCaption()` (line 37): 统计摘要文字（总时长）。
  - 显示播客封面、标题、播放时长条形图。

### 3. 按年份统计
- **YearsStatisticsFragment** (`ui/statistics/.../years/YearsStatisticsFragment.java`)
  - 显示每年的总播放时长。
  - 柱状图展示年度数据。

### 4. 下载空间统计
- **DownloadStatisticsFragment** (`ui/statistics/.../downloads/DownloadStatisticsFragment.java`)
  - 显示每个播客占用的存储空间。
  - 总下载空间统计。

### 5. 统计数据来源
- **PodDBAdapter.java** (`storage/database/src/main/java/de/danoeh/antennapod/storage/database/PodDBAdapter.java`)
  - `getMonthlyStatisticsCursor()` (line 1227): 按月统计播放时长。
  - `getTimeBetweenReleaseAndPlayback()` (line 1289): 发布到首次播放的时间间隔。
  - `getRandomEpisodesCursor()` (line 1145): 随机剧集采样。

### 6. 统计偏好设置
- **StatisticsFragment** 中定义的偏好 (line 42-45):
  - `PREF_INCLUDE_MARKED_PLAYED = "countAll"`: 是否包含手动标记为已播的时长。
  - `PREF_FILTER_FROM`: 统计开始时间过滤。
  - `PREF_FILTER_TO`: 统计结束时间过滤。

### 7. 重置统计数据
- `confirmResetStatistics()` (line 120):
  - 弹出确认对话框。
  - 用户确认后执行 `doResetStatistics()`。
- `doResetStatistics()` (line 135):
  - 清除统计偏好设置。
  - 调用 `DBWriter.resetStatistics()` 重置数据库中的统计数据。
  - 广播 `StatisticsEvent` 刷新页面。

### 8. 年度回顾
- `show_echo` 菜单项 (line 69-71):
  - 特定条件下显示年度回顾入口。
  - `EchoActivity`: 年度精彩回顾页面。
  - `EchoConfig.isCurrentlyVisible()`: 控制是否在特定时段显示。

### 9. 统计事件
- **StatisticsEvent**: 统计数据变更事件，触发页面刷新。
- 通过 EventBus 广播。

### 10. 数据读取
- **DBReader**: 提供统计相关的数据查询。
  - 播放历史 (`getPlaybackHistory()`)。
  - 订阅列表 (`getFeedList()`)。
  - 剧集计数。
