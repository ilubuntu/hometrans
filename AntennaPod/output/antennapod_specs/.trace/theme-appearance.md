# Trace: REQ-033 主题与外观设置

## 关联需求
REQ-033: 主题、UI 外观和导航配置设置。

## 代码溯源

### 1. 设置主入口
- **MainPreferencesFragment.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/preferences/MainPreferencesFragment.java:21`)
  - `setupMainScreen()` (line 77): 构建设置主页面，包含各子设置入口。
  - 设置分类：用户界面、播放、下载、同步、存储、统计等。

### 2. 用户界面设置页
- **UserInterfacePreferencesFragment.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/preferences/UserInterfacePreferencesFragment.java:28`)
  - `onCreatePreferences()` (line 32): 加载 `preferences_user_interface.xml`。
  - `setupInterfaceScreen()` (line 44): 配置所有 UI 设置项。

#### 各设置项详情：
- **主题 (PREF_THEME)** (line 49):
  - `ThemePreference`: 主题选择器（系统默认/浅色/深色）。
  - 修改后重建 Activity 立即应用主题。

- **纯黑主题 (PREF_THEME_BLACK)** (line 50):
  - 开关：深色模式下使用纯黑背景（节省 OLED 电量）。
  - 修改后重建 Activity。

- **动态取色 (PREF_TINTED_COLORS)** (line 51):
  - 开关：根据壁纸动态调整主题颜色。
  - 仅 Android 12+ 显示 (line 52-54)。

- **剩余时间显示 (PREF_SHOW_TIME_LEFT)** (line 56-63):
  - 开关：显示剩余时间而非已播放时间。
  - 修改后广播 `FeedItemEvent` 和 `PlayerStatusEvent` 刷新 UI。

- **导航抽屉隐藏项 (PREF_HIDDEN_DRAWER_ITEMS)** (line 65-69):
  - `DrawerPreferencesDialog`: 选择在导航抽屉中隐藏哪些条目。

- **通知栏完整按钮 (PREF_FULL_NOTIFICATION_BUTTONS)** (line 71-75):
  - `showFullNotificationButtonsDialog()`: 选择通知栏显示的 2 个快捷按钮。
  - 可选：跳过、下一章节、播放速度、睡眠定时器。
  - 必须选择恰好 2 个。

- **全局默认排序 (PREF_GLOBAL_DEFAULT_SORTED_ORDER)** (line 76-81):
  - `EpisodeListGlobalDefaultSortDialog`: 设置剧集列表全局默认排序方式。

- **滑动手势 (PREF_SWIPE)** (line 82-86):
  - 打开滑动手势设置子页面。

- **优先流式播放 (PREF_STREAM_OVER_DOWNLOAD)** (line 87-94):
  - 开关：默认操作按钮显示"流式播放"而非"下载"。
  - 修改后刷新所有列表。

- **底部导航 (PREF_BOTTOM_NAVIGATION)** (line 104-115):
  - 开关：使用底部导航栏而非侧边抽屉。
  - 关闭时显示弃用警告。
  - 影响"返回键打开抽屉"设置可用性。

### 3. 主题切换器
- **ThemeSwitcher.java** (`ui/common/src/main/java/de/danoeh/antennapod/ui/common/ThemeSwitcher.java:7`)
  - `getNoTitleTheme()`: 根据设置获取无标题栏主题。
  - `readThemeValue()`: 读取主题偏好值（0=系统、1=浅色、2=深色）。

### 4. 主题偏好存储
- **UserPreferences.java** (`storage/preferences/src/main/java/de/danoeh/antennapod/storage/preferences/UserPreferences.java`)
  - `setTheme(int)` (line 163): 设置主题。
  - `getTheme()`: 获取当前主题。
  - `getIsBlackTheme()` (line 209): 是否纯黑主题。
  - `PREF_THEME`、`PREF_THEME_BLACK`、`PREF_TINTED_COLORS` 等偏好键。

### 5. 主题偏好选择器 UI
- **ThemePreference.java** (`ui/preferences/src/main/java/de/danoeh/antennapod/ui/preferences/preference/ThemePreference.java:12`)
  - `updateThemeCard()`: 更新主题预览卡片显示。

### 6. 滑动手势设置
- **SwipePreferencesFragment.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/preferences/SwipePreferencesFragment.java:14`)
  - 配置列表项滑动手势的动作。

### 7. 导航抽屉偏好
- **DrawerPreferencesDialog.java**: 选择隐藏/显示的导航条目。
