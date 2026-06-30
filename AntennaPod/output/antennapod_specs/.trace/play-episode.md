# REQ-009 播放单集 - 代码追踪

## 需求
播放单集：启动音频，显示迷你播放器/播放页，标题、播放/暂停、进度、跳过

## 核心代码路径

### 1. 启动播放
- `PlaybackServiceStarter` (playback/service/.../PlaybackServiceStarter.java:13)
  - 构造函数接收 `Playable` 媒体对象
  - `start()` (L44): 若 Media3 模式，绑定 MediaController → setMediaItem → prepare → play
  - 传统模式：通过 `ContextCompat.startForegroundService()` 启动服务

### 2. 播放控制器
- `PlaybackController` (playback/service/.../PlaybackController.java:49)
  - 抽象类，UI 层通过它控制播放
  - `playPause()` (L302): 根据当前状态决定播放/暂停/准备
  - `bindToService()` / `bindToMedia3Service()` (L495/L518): 静态方法绑定到播放服务
  - `init()` (L71): 注册 EventBus，若服务已运行则初始化连接

### 3. 迷你播放器 (ExternalPlayerFragment)
- `ExternalPlayerFragment` (app/.../ExternalPlayerFragment.java:45)
  - 嵌在底部 BottomSheet 中，折叠状态显示
  - `onViewCreated()` (L86): 设置 butPlay 点击监听 → 播放/暂停
  - `loadMediaInfo()` (L148): 从 `DBReader.getFeedMedia()` 加载当前播放媒体
  - `updateUi()` (L163): 显示标题、作者、封面、进度条
  - 点击布局 → 展开 BottomSheet（音频）或打开视频播放页

### 4. 播放详情页 (AudioPlayerFragment)
- `AudioPlayerFragment` (app/.../AudioPlayerFragment.java:81)
  - `onCreateView()` (L110): 初始化 UI 组件（进度条、控制按钮等）
  - 嵌入 `ExternalPlayerFragment` 到 playerFragment 容器 (L124)
  - ViewPager2 包含 CoverFragment (POS_COVER=0) 和 ItemDescriptionFragment (POS_DESCRIPTION=1)
  - `setupControlButtons()` (L189): 设置后退、播放、快进、跳过按钮
  - `loadMediaInfo()` (L284): 异步加载媒体信息及章节
  - `updatePosition()` (L372): 订阅 PlaybackPositionEvent 更新进度
  - `updateUi()` (L310): 更新进度、速度、章节、播放按钮状态

### 5. 播放按钮
- `PlayButton` (app/.../PlayButton.java:11)
  - 自定义 ImageButton，`setIsShowPlay()` (L31): 动画切换播放/暂停图标
  - 根据 isShowPlay 切换 AnimatedVectorDrawable (play↔pause 动画)

### 6. 播放状态管理
- `PlaybackService.handleKeycode()` (playback/service/.../PlaybackService.java:688)
  - KEYCODE_MEDIA_PLAY_PAUSE: 根据状态暂停/恢复/准备播放
- `PlaybackPreferences.getCurrentPlayerStatus()`: 获取当前播放状态
- `PlayerStatusEvent`: EventBus 事件通知 UI 更新

## 关键交互流
1. 用户点击剧集播放 → `PlaybackServiceStarter.start()`
2. 服务启动 → 通知 UI (`PlayerStatusEvent`)
3. `ExternalPlayerFragment.loadMediaInfo()` → 显示迷你播放器
4. `AudioPlayerFragment.loadMediaInfo()` → 显示播放详情页
5. `PlayButton.setIsShowPlay(false)` → 显示暂停图标
6. `updatePosition()` → 实时更新进度条
