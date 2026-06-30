# REQ-011 播放暂停状态 - 代码追踪

## 需求
播放暂停切换：按钮图标变化，UI 匹配播放状态

## 核心代码路径

### 1. PlayButton 播放按钮组件
- `PlayButton` (app/.../PlayButton.java:11)
  - 继承 AppCompatImageButton
  - `setIsShowPlay(boolean showPlay)` (L31):
    - 仅当状态发生变化时才执行动画
    - 设置无障碍描述："播放" 或 "暂停"
    - 视频模式：切换 ic_play_video_white / ic_pause_video_white
    - 不可见时：直接设置静态图标
    - 可见时：使用 AnimatedVectorDrawable 播放动画
      - showPlay=true: ic_animate_pause_play（暂停→播放动画）
      - showPlay=false: ic_animate_play_pause（播放→暂停动画）

### 2. AudioPlayerFragment 中的播放/暂停逻辑
- `setupControlButtons()` (AudioPlayerFragment.java:189)
  - `butPlay.setOnClickListener` (L204):
    - 判断当前是否正在播放：`PlaybackService.isRunning && getCurrentPlayerStatus() == PLAYER_STATUS_PLAYING`
    - 正在播放 → 暂停：Media3 调用 `MediaController.pause()`；传统发送 `KEYCODE_MEDIA_PAUSE` 广播
    - 未播放 → 启动播放：`new PlaybackServiceStarter().callEvenIfRunning(true).start()`
  - `updateUi()` (L310):
    - `butPlay.setIsShowPlay(!isPlaying)` 根据播放状态切换按钮图标

### 3. ExternalPlayerFragment 中的播放/暂停逻辑
- `onViewCreated()` (ExternalPlayerFragment.java:86)
  - `butPlay.setOnClickListener` (L88):
    - 同样的判断逻辑：正在播放 → 暂停；未播放 → 启动
  - `updateUi()` (L163):
    - `butPlay.setIsShowPlay(!isPlaying)` 更新迷你播放器按钮状态

### 4. CoverFragment 中的封面点击播放/暂停
- `CoverFragment.onCreateView()` (CoverFragment.java:77)
  - 封面图点击监听 (L79):
    - 正在播放 → 发送 `KEYCODE_MEDIA_PAUSE` 广播
    - 未播放 → `new PlaybackServiceStarter().callEvenIfRunning(true).start()`

### 5. PlaybackController 状态管理
- `PlaybackController.playPause()` (PlaybackController.java:302)
  - 根据状态决定操作：
    - PLAYING → pause(true, false)
    - PAUSED/PREPARED → resume()
    - PREPARING → toggle startWhenPrepared
    - INITIALIZED → setStartWhenPrepared(true) + prepare()
    - 默认 → new PlaybackServiceStarter().start()

- `handleStatus()` (L244):
  - PLAYING → updatePlayButtonShowsPlay(false)
  - PREPARING → 根据 startWhenPrepared 决定
  - PAUSED/PREPARED/STOPPED/INITIALIZED → updatePlayButtonShowsPlay(true)

### 6. PlaybackService 按键处理
- `handleKeycode()` (PlaybackService.java:688)
  - KEYCODE_MEDIA_PLAY_PAUSE (L694):
    - PLAYING → pause
    - PAUSED/PREPARED → resume
    - PREPARING → toggle startWhenPrepared
    - INITIALIZED → prepare
    - 无媒体 → startPlayingFromPreferences
  - KEYCODE_MEDIA_PLAY (L710): 仅恢复/准备
  - KEYCODE_MEDIA_PAUSE (L722): 仅暂停

### 7. 事件驱动 UI 更新
- `PlayerStatusEvent` (EventBus 事件): 状态变化通知所有 UI 组件
  - AudioPlayerFragment.onPlayerStatusEvent() → loadMediaInfo → updateUi → 更新按钮
  - ExternalPlayerFragment.onPlayerStatusEvent() → loadMediaInfo → updateUi → 更新按钮

## 关键交互流
1. 用户点击播放按钮 → 检查当前状态
2. 正在播放 → 发送暂停命令 → PlayButton 动画切换为播放图标
3. 未播放 → 发送播放命令 → PlayButton 动画切换为暂停图标
4. 状态变更通过 EventBus 广播 → 所有界面组件同步更新
