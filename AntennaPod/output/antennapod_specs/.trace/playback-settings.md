# Trace: REQ-034 播放设置

## 关联需求
REQ-034: 全局播放设置，包括快退/快进秒数、自动播放、耳机按键、播放完成行为等。

## 代码溯源

### 1. 播放设置页面
- **PlaybackPreferencesFragment.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/preferences/PlaybackPreferencesFragment.java:19`)
  - `onCreatePreferences()` (line 25): 加载 `preferences_playback.xml`。
  - `setupPlaybackScreen()` (line 38): 配置播放设置项。

#### 各设置项详情：
- **播放速度启动器 (prefPlaybackSpeedLauncher)** (line 41-44):
  - `VariableSpeedDialog`: 全局播放速度设置对话框。

- **快退秒数 (prefPlaybackRewindDeltaLauncher)** (line 45-48):
  - `SkipPreferenceDialog.showSkipPreference(SKIP_REWIND)`: 设置快退秒数。
  - 可选值：10/15/30 秒等。

- **快进秒数 (prefPlaybackFastForwardDeltaLauncher)** (line 49-52):
  - `SkipPreferenceDialog.showSkipPreference(SKIP_FORWARD)`: 设置快进秒数。

- **耳机重连恢复播放 (PREF_UNPAUSE_ON_HEADSET_RECONNECT)** (line 53-54):
  - 有线耳机插入时自动恢复播放。
  - Android 12+ 隐藏（系统接管）。

- **蓝牙重连恢复播放 (PREF_UNPAUSE_ON_BLUETOOTH_RECONNECT)** (line 55-56):
  - 蓝牙耳机连接时自动恢复播放。
  - Android 12+ 隐藏。

- **入队位置 (PREF_ENQUEUE_LOCATION)** (line 58, 61-83):
  - `buildEnqueueLocationPreference()`: 设置新单集加入队列的位置。
  - 选项：队尾、队首、当前播放项之后。
  - 修改后更新设置摘要。

- **智能标记已播阈值 (PREF_SMART_MARK_AS_PLAYED_SECS)** (line 29, 96-116):
  - `buildSmartMarkAsPlayedPreference()`: 设置"接近播放完成时自动标记为已播"的阈值。
  - 可选值：禁用、15秒、30秒、1分钟等。
  - 根据秒数自动格式化显示（秒/分钟）。

### 2. 快进/快退秒数对话框
- **SkipPreferenceDialog.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/feed/preferences/SkipPreferenceDialog.java:16`)
  - `showSkipPreference(activity, direction, callback)`: 弹出秒数选择对话框。
  - 支持快进和快退两个方向。
  - 选项：10、15、30 秒等预设值。

### 3. 播放速度设置
- **VariableSpeedDialog** (`app/src/main/java/de/danoeh/antennapod/ui/screen/playback/VariableSpeedDialog.java`)
  - 全局播放速度管理，可选预设速度和自定义速度。

### 4. 播放偏好存储
- **UserPreferences.java** (`storage/preferences/`)
  - `PREF_FAST_FORWARD_SECS`: 快进秒数。
  - `PREF_REWIND_SECS`: 快退秒数。
  - `PREF_ENQUEUE_LOCATION`: 入队位置。
  - `PREF_SMART_MARK_AS_PLAYED_SECS`: 智能标记已播阈值。
  - `PREF_UNPAUSE_ON_HEADSET_RECONNECT` / `PREF_UNPAUSE_ON_BLUETOOTH_RECONNECT`: 耳机/蓝牙恢复。
  - `PREF_RESUME_AFTER_CALL`: 通话结束后恢复播放。

### 5. 偏好 XML 定义
- **preferences_playback.xml**: 定义所有播放偏好项及其默认值。

### 6. 播放服务中的应用
- **PlaybackService.java** (`playback/service/`)
  - 读取播放偏好，在播放过程中应用：
    - 快进/快退按钮使用设定的秒数。
    - 入队位置影响新剧集添加行为。
    - 智能标记阈值决定何时自动标记已播。
    - 耳机/蓝牙连接事件触发播放恢复。
