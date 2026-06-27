# Trace: theme-persist (REQ-038)

## 需求原文
用户选择的主题模式应保存到 SharedPreferences，重启应用后保持原选择。选择 Dark 后重启仍为 Dark。

## 代码追踪

### 1. SharedPreferences 初始化
**文件**: `app/src/main/java/com/whaticancook/app/data/repository/SettingsRepositoryImpl.kt:13-19`
```kotlin
class SettingsRepositoryImpl @Inject constructor(
    @ApplicationContext context: Context,
) : SettingsRepository {

    private val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    private val themeFlow = MutableStateFlow(
        ThemeMode.fromId(prefs.getString(KEY_THEME, null)),
    )
```
- SharedPreferences 文件名: `wcc_settings`（私有模式）。
- **启动时读取**: `prefs.getString(KEY_THEME, null)` 获取存储的主题名。
- `ThemeMode.fromId(null)` -> 默认 SYSTEM（首次安装无存储值）。

### 2. 存储键名
**文件**: `SettingsRepositoryImpl.kt:43-46`
```kotlin
private companion object {
    const val PREFS_NAME = "wcc_settings"
    const val KEY_THEME = "theme_mode"
    const val KEY_ONBOARDING = "onboarding_complete"
}
```
- 主题存储键: `"theme_mode"`，值为 ThemeMode 的 name（"SYSTEM"/"LIGHT"/"DARK"）。

### 3. 写入持久化
**文件**: `SettingsRepositoryImpl.kt:29-32`
```kotlin
override suspend fun setThemeMode(mode: ThemeMode) {
    prefs.edit { putString(KEY_THEME, mode.name) }
    themeFlow.value = mode
}
```
- `prefs.edit { putString("theme_mode", mode.name) }` — 同步写入磁盘。
- `mode.name` 存储枚举名称（如 "DARK"）。
- 写入后更新内存中的 `themeFlow`。

### 4. 重启后恢复
- App 启动 -> `SettingsRepositoryImpl` 被注入（Singleton）。
- 构造函数读取 `prefs.getString("theme_mode", null)`。
- 如果之前选择过 Dark，返回 `"DARK"`。
- `ThemeMode.fromId("DARK")` -> `ThemeMode.DARK`。
- `themeFlow` 初始值为 DARK -> AppViewModel 发射 themeMode=DARK -> MainActivity 设置 darkTheme=true。

### 5. fromId 容错
**文件**: `ThemeMode.kt:8-9`
```kotlin
fun fromId(id: String?): ThemeMode =
    entries.firstOrNull { it.name.equals(id, ignoreCase = true) } ?: SYSTEM
```
- null 或无效值 -> 默认 SYSTEM。
- 大小写不敏感匹配。

### 6. 响应式传播链
```
用户选择 Dark
  -> SettingsViewModel.setThemeMode(DARK)
  -> SettingsRepository.setThemeMode(DARK)
  -> prefs.writeString("theme_mode", "DARK")  [持久化]
  -> themeFlow.value = DARK                    [内存更新]
  -> AppViewModel.uiState 发射 themeMode=DARK  [Eagerly 共享]
  -> MainActivity.collectAsStateWithLifecycle   [重组触发]
  -> WccTheme(darkTheme=true)                   [深色主题应用]
```

重启应用:
```
App 启动 -> SettingsRepositoryImpl 构造
  -> prefs.getString("theme_mode") = "DARK"     [读取持久化值]
  -> ThemeMode.fromId("DARK") = DARK
  -> themeFlow 初始值 = DARK
  -> AppViewModel 发射 themeMode=DARK
  -> WccTheme(darkTheme=true)                    [深色主题恢复]
```

## 关键逻辑总结
1. 主题以枚举名称字符串存储在 SharedPreferences。
2. 写入和读取都通过同一个 Repository，保证一致性。
3. 从Id 容错确保旧版本或损坏数据不会崩溃。
4. 重启恢复在 Repository 构造时完成，无需额外逻辑。
