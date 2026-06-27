# Trace: theme-switch (REQ-037)

## 需求原文
Settings 中 Theme 支持 Match system、Light、Dark 三种模式，点击后立即切换应用主题。选择 Dark 后页面整体切换到深色主题。

## 代码追踪

### 1. ThemeMode 枚举定义
**文件**: `app/src/main/java/com/whaticancook/app/domain/model/ThemeMode.kt:2-11`
```kotlin
enum class ThemeMode(val label: String) {
    SYSTEM("Match system"),
    LIGHT("Light"),
    DARK("Dark");

    companion object {
        fun fromId(id: String?): ThemeMode =
            entries.firstOrNull { it.name.equals(id, ignoreCase = true) } ?: SYSTEM
    }
}
```
- 三种模式：SYSTEM（跟随系统）、LIGHT（浅色）、DARK（深色）。
- `fromId` 用于从存储读取时反序列化，默认 SYSTEM。

### 2. 设置页主题选择器
**文件**: `app/src/main/java/com/whaticancook/app/feature/settings/SettingsScreen.kt:69-77`
```kotlin
ThemeMode.entries.forEach { mode ->
    WccChip(
        label = mode.label,
        selected = state.themeMode == mode,
        onClick = { viewModel.setThemeMode(mode) },
        modifier = Modifier.weight(1f),
    )
}
```
- 三个等宽 Chip（weight(1f)），当前选中模式高亮。
- 点击 -> `viewModel.setThemeMode(mode)`。

### 3. ViewModel 处理
**文件**: `app/src/main/java/com/whaticancook/app/feature/settings/SettingsViewModel.kt:30-32`
```kotlin
fun setThemeMode(mode: ThemeMode) {
    viewModelScope.launch { settings.setThemeMode(mode) }
}
```
- 调用 SettingsRepository 写入。

### 4. Repository 实现
**文件**: `app/src/main/java/com/whaticancook/app/data/repository/SettingsRepositoryImpl.kt:29-32`
```kotlin
override suspend fun setThemeMode(mode: ThemeMode) {
    prefs.edit { putString(KEY_THEME, mode.name) }
    themeFlow.value = mode
}
```
- 持久化到 SharedPreferences（详见 REQ-038）。
- 更新 `themeFlow`（MutableStateFlow），触发所有观察者。

### 5. AppViewModel 观察主题
**文件**: `app/src/main/java/com/whaticancook/app/feature/app/AppViewModel.kt:19-31`
```kotlin
val uiState: StateFlow<AppUiState> =
    combine(settings.observeThemeMode(), settings.observeOnboardingComplete()) { theme, onboarding ->
        AppUiState(isReady = true, themeMode = theme, onboardingComplete = onboarding)
    }.stateIn(viewModelScope, SharingStarted.Eagerly, AppUiState())
```
- AppViewModel 在 Activity 级别观察 themeMode。

### 6. MainActivity 应用主题（立即生效）
**文件**: `app/src/main/java/com/whaticancook/app/MainActivity.kt:28-39`
```kotlin
setContent {
    val state by appViewModel.uiState.collectAsStateWithLifecycle()
    val darkTheme = when (state.themeMode) {
        ThemeMode.SYSTEM -> isSystemInDarkTheme()
        ThemeMode.LIGHT -> false
        ThemeMode.DARK -> true
    }
    WccTheme(darkTheme = darkTheme) {
        if (state.isReady) {
            WccApp(startOnboarding = !state.onboardingComplete)
        }
    }
}
```
- `themeFlow` 变更 -> AppViewModel 重新发射 -> `collectAsStateWithLifecycle` 触发重组。
- `darkTheme` 计算：
  - SYSTEM -> `isSystemInDarkTheme()`（系统暗色模式）。
  - LIGHT -> false（强制浅色）。
  - DARK -> true（强制深色）。
- `WccTheme(darkTheme)` 包裹整个应用，切换 ColorScheme -> **立即生效**。

## 关键逻辑总结
1. 主题选择通过 StateFlow 传播，Compose 重组即时生效。
2. WccTheme 在最外层包裹所有 UI，主题切换影响全局。
3. SYSTEM 模式跟随系统设置，LIGHT/DARK 为强制模式。
