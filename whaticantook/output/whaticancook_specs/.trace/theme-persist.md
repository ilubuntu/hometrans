# Code trace · theme-persist

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 主题写入持久化（选择主题时保存） — app/src/main/java/com/whaticancook/app/data/repository/SettingsRepositoryImpl.kt:30-33 — recalled by: path 2 (callees of SettingsViewModel.setThemeMode)
- Entry 2: 启动时读取已保存主题并生效 — app/src/main/java/com/whaticancook/app/data/repository/SettingsRepositoryImpl.kt:21-23 (themeFlow 初始值读取) — recalled by: path 1 (impact of observeThemeMode → AppViewModel → MainActivity)

## Entry · 选择主题时写入持久化存储
- claim: 用户每次选择主题，主题名（"LIGHT"/"DARK"/"SYSTEM"）都被写入应用的私有配置存储，即使关闭应用也不会丢失。
- layers:
  - code:     app/src/main/java/com/whaticancook/app/data/repository/SettingsRepositoryImpl.kt:30-33 (setThemeMode: prefs.edit { putString(KEY_THEME, mode.name) }；KEY_THEME = "theme_mode"，存储名 "wcc_settings"，SettingsRepositoryImpl.kt:43-44)
  - resource: N/A: 持久化为应用私有配置存储，无 res/xml 资源参与
  - manifest: N/A: 无 manifest 权限或组件声明
- interaction: 写入键值对 theme_mode = mode.name（枚举名字符串）；同时刷新内存 themeFlow.value = mode（保证当前会话即时生效，与 REQ-037 共享）。写入与读取使用同一存储名 "wcc_settings" 与同一键 "theme_mode"。
- data_flow: chip 选择 (SettingsScreen.kt:67) → SettingsViewModel.setThemeMode (SettingsViewModel.kt:30-32) → SettingsRepositoryImpl.setThemeMode (SettingsRepositoryImpl.kt:30) → prefs.edit putString(KEY_THEME) (SettingsRepositoryImpl.kt:31)。

## Entry · 应用启动时读取并生效上次主题
- claim: 应用每次启动时，从配置存储读取上次保存的主题值作为本次生效主题；从未设置过或值无法识别时回退为"Match system"。
- layers:
  - code:     app/src/main/java/com/whaticancook/app/data/repository/SettingsRepositoryImpl.kt:21-23 (themeFlow 初始值 = ThemeMode.fromId(prefs.getString(KEY_THEME, null)))；fromId 大小写不敏感匹配，未命中回退 SYSTEM (ThemeMode.kt:9-11)
  - resource: N/A
  - manifest: N/A
- interaction: 配置存储实例在 SettingsRepositoryImpl 构造时建立 (SettingsRepositoryImpl.kt:19: getSharedPreferences("wcc_settings", MODE_PRIVATE))；themeFlow 初始值在该构造时一次性读取，作为整个会话的起始主题。
- data_flow: 应用进程启动 → SettingsRepositoryImpl(@Singleton, Hilt) 构造 (SettingsRepositoryImpl.kt:15-19) → prefs.getString(KEY_THEME) (SettingsRepositoryImpl.kt:22) → ThemeMode.fromId (ThemeMode.kt:9) → themeFlow 初始值 → AppViewModel.uiState.themeMode (AppViewModel.kt:25-31，SharingStarted.Eagerly，进程级尽早发射) → MainActivity darkTheme (MainActivity.kt:31-35) → WccTheme (Theme.kt:80)。

## Implicit triggers (non-UI state changes that activate this feature)
- 触发: 应用进程冷启动 — 配置存储实例重建并读取已保存值（Entry 2 描述）；这是"重启仍保持主题"的唯一隐式触发。本 REQ 不涉及前台切换主题的隐式触发（该部分归 REQ-037）。

## Core business entities (data model / persistence key / state machine)
- 持久化存储 "wcc_settings"（应用私有配置存储）: app/src/main/java/com/whaticancook/app/data/repository/SettingsRepositoryImpl.kt:19,43。
- 持久化键 "theme_mode": SettingsRepositoryImpl.kt:44 — 存储值为 ThemeMode 枚举名字符串（"LIGHT"/"DARK"/"SYSTEM"，由 mode.name 得来，SettingsRepositoryImpl.kt:31）。
- 内存状态 themeFlow（MutableStateFlow<ThemeMode>）: SettingsRepositoryImpl.kt:21-23 — 启动时由持久化值初始化，运行时由 setThemeMode 同步刷新；是 REQ-037 即时生效与 REQ-038 持久生效的共享桥梁。
- ThemeMode.fromId(id): ThemeMode.kt:9-11 — 大小写不敏感匹配枚举名，null 或无法识别时回退 SYSTEM。这是"值无法识别回退默认"的回退点。

## Cross-entry shared declarations
- None（主题持久化的写入与读取共享同一存储名/键/内存状态，无 manifest/build 跨条目声明）

## Deviations from REQ_DESC
1. REQ_DESC 仅要求"主题选择应持久保存""重启后仍保持 Dark 主题"。代码将主题以枚举名字符串持久化，并在启动时经 fromId 大小写不敏感解析回枚举；其中"值无法识别回退 Match system"是需求未明示的健壮性处理 (ThemeMode.kt:10)，属补充说明，非冲突。
2. REQ_DESC 未提及默认值；代码默认（从未设置过）主题为"Match system" (SYSTEM)，与 REQ-036/037 一致。属补充说明，非冲突。

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 选择主题时写入持久化：见上文 Entry · 选择主题时写入持久化存储
- 启动时读取并生效：见上文 Entry · 应用启动时读取并生效上次主题

### Consumers (who reads this state / data)
- Consumer: AppViewModel（启动后读取主题，驱动整页配色） — app/src/main/java/com/whaticancook/app/feature/app/AppViewModel.kt:27
- Consumer: SettingsViewModel（驱动设置页 chip 选中态） — app/src/main/java/com/whaticancook/app/feature/settings/SettingsViewModel.kt:26

### Non-consumers (boundary counter-examples with evidence)
- claim: 主题持久化值不被任何菜谱/食材/收藏业务逻辑读取；这些业务存储（如食材库存储）独立于 wcc_settings
  - closure_layers: [code, resource, manifest]
  - tools: [homegraph_impact "KEY_THEME" depth 2 projectPath, Grep "theme_mode\|wcc_settings" over app/src]
  - zero_hits: Grep "theme_mode" 仅命中 SettingsRepositoryImpl.kt (2 处)；Grep "wcc_settings" 仅命中 SettingsRepositoryImpl.kt；菜谱库/食材库（RecipeDao/PantryDao 等）无任何 theme_mode/wcc_settings 引用

## Same-source cross-reference (if applicable)
- 本 REQ 与 `theme-switch-SPEC.md` 共享同一 ThemeMode 枚举、themeFlow 内存状态与 SettingsRepositoryImpl；`theme-switch-SPEC.md` 覆盖"选择即时生效"，本 SPEC 覆盖"重启仍保持"。主题选项所在区块结构见 `settings-overview-SPEC.md`。
