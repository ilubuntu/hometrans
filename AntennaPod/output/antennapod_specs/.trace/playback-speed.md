# REQ-013 播放速度 - 代码追踪

## 需求
播放速度：弹出对话框，选择速度，保存并影响播放

## 核心代码路径

### 1. VariableSpeedDialog 速度选择对话框
- `VariableSpeedDialog` (app/.../VariableSpeedDialog.java:40)
  - 继承 BottomSheetDialogFragment
  - `onCreateView()` (L116):
    - `PlaybackSpeedSeekBar` (speedSeekBar): 自定义滑动条选择速度
      - `setProgressChangedListener()` (L120): 拖动时实时回调
        - `UserPreferences.setPlaybackSpeed(multiplier)` 保存到偏好
        - Media3: `MediaController.setPlaybackSpeed(multiplier)`
        - 传统: `PlaybackController.setPlaybackSpeed(multiplier)`
    - 预设速度网格 (selectedSpeedsGrid): 3 列 GridLayoutManager
      - `SpeedSelectionAdapter`: 展示用户保存的预设速度
      - 点击预设 → 设置速度 + 保存 + 关闭对话框
      - 长按预设 → 删除该预设
    - `addCurrentSpeedChip`: 将当前速度添加为预设
      - 点击 → `addCurrentSpeed()`: 检查重复 → 添加 → 排序 → 保存
    - `skipSilenceCheckbox`: 跳过静音开关
      - `UserPreferences.setSkipSilence(isChecked)`
      - Media3: 发送 SESSION_COMMAND_SKIP_SILENCE
      - 传统: `PlaybackController.setSkipSilence(isChecked)`

### 2. PlaybackController 速度控制
- `PlaybackController` (playback/service/.../PlaybackController.java:49)
  - `setPlaybackSpeed(float speed)` (L416):
    - 服务运行 → `playbackService.setSpeed(speed)`
    - 服务未运行 → 发 SpeedChangedEvent
  - `getCurrentPlaybackSpeedMultiplier()` (L430):
    - 服务运行 → `playbackService.getCurrentPlaybackSpeed()`
    - 服务未运行 → `PlaybackSpeedUtils.getCurrentPlaybackSpeed(getMedia())`

### 3. UserPreferences 速度存储
- `UserPreferences` (storage/preferences/.../UserPreferences.java)
  - `setPlaybackSpeed(float speed)` (L637): 存储 PREF_PLAYBACK_SPEED
  - `getPlaybackSpeedArray()`: 获取用户预设速度列表
  - `setPlaybackSpeedArray(List<Float>)`: 存储预设速度列表

### 4. PlaybackSpeedUtils 速度工具
- `PlaybackSpeedUtils` (ui/episodes/.../PlaybackSpeedUtils.java)
  - `getCurrentPlaybackSpeed(Playable)`: 获取当前媒体的播放速度
  - 支持按播客设置不同速度

### 5. AudioPlayerFragment 速度显示
- `updatePlaybackSpeedButton(SpeedChangedEvent)` (AudioPlayerFragment.java:279)
  - 订阅 SpeedChangedEvent
  - 格式化速度为 "0.00" 格式显示
  - 速度按钮入口 → `new VariableSpeedDialog().show()` (L146)

### 6. 速度影响时间显示
- `updatePosition()` (AudioPlayerFragment.java:372):
  - 使用 `PlaybackSpeedUtils.getCurrentPlaybackSpeed(currentMedia)` 获取当前速度
  - `TimeSpeedConverter`: 将实际时间按速度转换显示
  - 位置和时长显示都考虑了播放速度

## 关键交互流
1. 用户点击播放页速度按钮 → 弹出速度选择面板
2. 拖动滑块 → 实时保存速度 + 实时应用到播放服务
3. 点击预设速度 → 设置 + 应用 + 关闭面板
4. SpeedChangedEvent → AudioPlayerFragment 更新速度文字显示
5. 进度位置按速度转换显示
