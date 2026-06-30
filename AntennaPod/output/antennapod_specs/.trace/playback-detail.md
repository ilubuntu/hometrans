# REQ-010 播放页详情 - 代码追踪

## 需求
播放页详情：封面、标题、播客标题、进度条、速度、睡眠定时器、章节/描述

## 核心代码路径

### 1. AudioPlayerFragment 播放页主体
- `AudioPlayerFragment` (app/.../AudioPlayerFragment.java:81)
  - ViewPager2 包含两个子页面：CoverFragment (POS_COVER=0) 和 ItemDescriptionFragment (POS_DESCRIPTION=1)
  - 工具栏 (MaterialToolbar): 菜单包含睡眠定时器、转录文本、打开所属播客等选项
  - `setupOptionsMenu()` (L487): 根据当前媒体准备菜单项可见性
  - `onMenuItemClick()` (L495): 处理睡眠定时器、转录文本、打开播客源

### 2. CoverFragment 封面页
- `CoverFragment` (app/.../CoverFragment.java:69)
  - `displayMediaInfo()` (L133):
    - 显示播客标题（`txtvPodcastTitle`）+ 发布日期
    - 显示剧集标题（`txtvEpisodeTitle`）
    - 点击标题可触发文字滚动动画
  - `displayCoverImage()` (L303): 使用图片加载库显示封面，支持章节专属图片
  - 章节导航：上一章/下一章按钮
  - `updateChapterControlVisibility()` (L192): 根据是否有章节显示/隐藏章节按钮
  - 点击封面 → 播放/暂停

### 3. 进度条 (ChapterSeekBar)
- AudioPlayerFragment `sbPosition` (L92)
  - `updatePosition()` (L372): 订阅 PlaybackPositionEvent
    - 计算考虑播放速度的转换后位置/时长
    - 显示当前位置和总时长（或剩余时间）
    - 点击时长文字可切换"总时长"/"剩余时间"显示模式
  - `setChapterDividers()` (L168): 在进度条上标记章节分隔点
  - 拖动监听：`onProgressChanged` / `onStartTrackingTouch` / `onStopTrackingTouch`
    - 拖动时显示预览卡片（章节名+位置）
    - 松手后 seek 到目标位置

### 4. 播放速度显示
- `txtvPlaybackSpeed` (L88)
  - `updatePlaybackSpeedButton()` (L279): 订阅 SpeedChangedEvent，格式化显示速度（如 "1.00x"）
  - 点击速度按钮 → 弹出 VariableSpeedDialog

### 5. 睡眠定时器入口
- 工具栏菜单项 `set_sleeptimer_item` / `disable_sleeptimer_item`
  - `onMenuItemClick()` (L506): 点击 → 显示 SleepTimerDialog
  - `sleepTimerUpdate()` (L330): 订阅 SleepTimerUpdatedEvent
    - 定时器激活时显示"禁用"菜单项
    - 定时器未激活时显示"设置"菜单项

### 6. 描述页 (ItemDescriptionFragment)
- ViewPager 的第二个页面
- 显示剧集的 show notes / 描述文本

### 7. 底部控制栏布局
- 后退按钮 (butRev) + 秒数标签 (txtvRev)
- 播放/暂停按钮 (butPlay)
- 快进按钮 (butFF) + 秒数标签 (txtvFF)
- 跳过按钮 (butSkip)
- 加载进度指示器 (progressIndicator)
- 拖动预览卡片 (cardViewSeek + txtvSeek)

## 关键交互流
1. 用户展开播放页 → loadMediaInfo() 加载完整媒体信息
2. CoverFragment 显示封面、标题、播客名、章节导航
3. 水平滑动切换封面页 ↔ 描述页
4. 进度条实时更新，支持拖动 seek
5. 工具栏提供睡眠定时器、速度、转录等入口
