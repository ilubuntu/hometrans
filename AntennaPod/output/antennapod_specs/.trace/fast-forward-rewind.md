# REQ-012 快进与后退 - 代码追踪

## 需求
快进与后退：可配置秒数，进度变化

## 核心代码路径

### 1. AudioPlayerFragment 快进/后退按钮设置
- `setupControlButtons()` (AudioPlayerFragment.java:189)
  - 后退按钮 (butRev) (L190):
    - Media3 模式：`MediaController.seekBack()`
    - 传统模式：`seekTo(currentPosition - UserPreferences.getRewindSecs() * 1000)`
  - 后退按钮长按 (L199):
    - 弹出 `SkipPreferenceDialog` (SKIP_REWIND 方向)，修改后退秒数
  - 快进按钮 (butFF) (L219):
    - Media3 模式：`MediaController.seekForward()`
    - 传统模式：`seekTo(currentPosition + UserPreferences.getFastForwardSecs() * 1000)`
  - 快进按钮长按 (L228):
    - 弹出 `SkipPreferenceDialog` (SKIP_FORWARD 方向)，修改快进秒数

### 2. 秒数显示
- `onStart()` (L340):
  - `txtvRev.setText(getRewindSecs())` 显示后退秒数
  - `txtvFF.setText(getFastForwardSecs())` 显示快进秒数
- 默认值：快进 30 秒，后退 10 秒

### 3. SkipPreferenceDialog 配置对话框
- `SkipPreferenceDialog` (app/.../SkipPreferenceDialog.java:17)
  - `showSkipPreference()` (L18):
    - 从资源数组 `R.array.seek_delta_values` 获取可选秒数列表
    - 用单选对话框展示（如 "10 秒"、"15 秒"、"30 秒"等）
    - 当前选中值高亮
    - 用户选择后：
      - 前进方向 → `UserPreferences.setFastForwardSecs(seconds)`
      - 后退方向 → `UserPreferences.setRewindSecs(seconds)`
    - 更新按钮旁的秒数标签

### 4. UserPreferences 存储
- `UserPreferences` (storage/preferences/.../UserPreferences.java)
  - `getFastForwardSecs()` (L582): 读取 PREF_FAST_FORWARD_SECS，默认 30
  - `getRewindSecs()` (L586): 读取 PREF_REWIND_SECS，默认 10
  - `setFastForwardSecs(int secs)` (L629): 存储快进秒数
  - `setRewindSecs(int secs)` (L633): 存储后退秒数

### 5. PlaybackService 硬件按键处理
- `handleKeycode()` (PlaybackService.java:688)
  - KEYCODE_MEDIA_FAST_FORWARD (L737):
    - `mediaPlayer.seekDelta(UserPreferences.getFastForwardSecs() * 1000)`
  - KEYCODE_MEDIA_REWIND (L752):
    - `mediaPlayer.seekDelta(-UserPreferences.getRewindSecs() * 1000)`
  - 仅在 PLAYING 或 PAUSED 状态时生效

### 6. 进度更新
- seek 后通过 PlaybackPositionEvent 事件通知
- AudioPlayerFragment.updatePosition() (L372) 更新进度条和位置文字
- CoverFragment 订阅 PlaybackPositionEvent 更新章节信息

## 关键交互流
1. 用户点击快进/后退按钮 → 读取配置秒数 → seek 到新位置
2. 长按按钮 → 弹出秒数选择对话框 → 选择新值 → 保存到偏好 → 更新按钮标签
3. seek 完成后 → 进度更新事件 → UI 同步更新进度条和位置显示
