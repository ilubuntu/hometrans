# REQ-014 睡眠定时器 - 代码追踪

## 需求
睡眠定时器：倒计时或按集数停止播放

## 核心代码路径

### 1. SleepTimerDialog 睡眠定时器对话框
- `SleepTimerDialog` (app/.../SleepTimerDialog.java:60)
  - 继承 BottomSheetDialogFragment
  
  - 定时器类型选择 (L159):
    - `SleepTimerType.CLOCK`: 时间倒计时（分钟）
    - `SleepTimerType.EPISODES`: 按集数停止
    - 通过 Spinner 切换类型
  
  - 时间输入 (L189):
    - `timeEditText`: 输入分钟数或集数
    - 上次使用的值通过 `SleepTimerPreferences.lastTimerValue()` 加载
  
  - 设置定时器 (L246):
    - `setSleeptimerButton` 点击:
      - 验证播放服务正在运行
      - `SleepTimerPreferences.setLastTimer()` 保存值
      - `SleepTimerPreferences.timerMillisOrEpisodes()` 获取定时值
      - Media3: 发送 `SESSION_COMMAND_SET_SLEEP_TIMER` 自定义命令
      - 传统: `controller.setSleepTimer(time)`
  
  - 禁用定时器 (L235):
    - `disableSleeptimerButton` 点击:
      - Media3: 发送 `SESSION_COMMAND_DISABLE_SLEEP_TIMER`
      - 传统: `controller.disableSleepTimer()`
  
  - 延长定时器 (L407):
    - 三个延长按钮：+5/+10/+30（分钟或集数）
    - Media3: 发送 `SESSION_COMMAND_EXTEND_SLEEP_TIMER`
    - 传统: `controller.extendSleepTimer(extendValue)`
  
  - 高级选项:
    - 摇晃重置 (shakeToReset): 摇晃手机重置定时器
    - 震动 (vibrate): 定时器结束时震动
    - 自动启用 (autoEnable): 指定时间段自动启用
    - 时间范围设置 (showTimeRangeDialog): autoEnableFrom / autoEnableTo

### 2. SleepTimerPreferences 定时器偏好
- `SleepTimerPreferences` (storage/preferences/...)
  - `getSleepTimerType()`: 获取定时器类型 (CLOCK/EPISODES)
  - `lastTimerValue()`: 上次输入的值
  - `timerMillisOrEpisodes()`: 转换为毫秒或集数
  - `autoEnable()` / `autoEnableFrom()` / `autoEnableTo()`: 自动启用配置
  - `shakeToReset()` / `vibrate()`: 摇晃重置和震动

### 3. PlaybackController 定时器控制
- `PlaybackController` (playback/service/.../PlaybackController.java:49)
  - `setSleepTimer(long time)` (L384): 设置定时器
  - `disableSleepTimer()` (L363): 禁用定时器
  - `sleepTimerActive()` (L359): 检查定时器是否激活
  - `getSleepTimerTimeLeft()` (L369): 获取剩余时间
  - `extendSleepTimer(long extendTime)` (L377): 延长定时器

### 4. SleepTimerUpdatedEvent 事件
- `timerUpdated()` (SleepTimerDialog.java:465):
  - 订阅 SleepTimerUpdatedEvent
  - 定时器激活时显示剩余时间/剩余集数
  - 定时器结束时切换到设置界面
  
### 5. AudioPlayerFragment 睡眠定时器入口
- `sleepTimerUpdate()` (AudioPlayerFragment.java:330):
  - 订阅 SleepTimerUpdatedEvent
  - 定时器激活 → 显示"禁用"菜单项，隐藏"设置"菜单项
  - 定时器未激活 → 显示"设置"菜单项，隐藏"禁用"菜单项
- `onMenuItemClick()` (L506):
  - 点击睡眠定时器菜单 → 弹出 SleepTimerDialog

### 6. 集数类型定时器的特殊逻辑
- `refreshUiState()` (L315):
  - EPISODES 类型 + 连续播放未开启 → 只允许 1 集
  - EPISODES 类型 + 选择的集数 > 队列剩余集数 → 显示提示
  - CLOCK 类型 + 定时超过当前集剩余时间 + 连续播放未开启 → 显示提示

## 关键交互流
1. 用户从工具栏打开睡眠定时器面板
2. 选择类型（时间/集数）→ 输入值 → 点击设置
3. 定时器开始倒计时，界面显示剩余时间
4. 可延长定时器（+5/+10/+30）
5. 可手动禁用定时器
6. 定时器结束 → 播放暂停
