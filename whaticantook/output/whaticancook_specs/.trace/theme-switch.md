# Code trace · theme-switch

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: Settings 页面外观区块的主题 chip（三选一） — app/src/main/java/com/whaticancook/app/feature/settings/SettingsScreen.kt:62-71 — recalled by: path 1 (explore "setThemeMode")
- Entry 2: 全局主题消费点（决定整页配色） — app/src/main/java/com/whaticancook/app/MainActivity.kt:31-36 (WccTheme darkTheme 计算) — recalled by: path 2 (callers/impact of observeThemeMode → AppViewModel)

## Entry · 主题 chip 选择（三选一交互）
- claim: 用户在设置页外观区块点击"Light / Dark / Match system"任一 chip，新主题立即生效，被选中的 chip 立即变为选中高亮，未被选中的变为未选中。
- layers:
  - code:     app/src/main/java/com/whaticancook/app/feature/settings/SettingsScreen.kt:62-71 (Row 内 ThemeMode.entries.forEach 渲染 WccChip，onClick = viewModel.setThemeMode(mode))
  - resource: N/A: chip 为 Compose 组件 WccChip，无 res 资源引用
  - manifest: N/A: 主题切换为应用内状态变更，无 manifest 声明
- interaction: 点击 chip → viewModel.setThemeMode(mode) (SettingsScreen.kt:67) → SettingsViewModel.setThemeMode (SettingsViewModel.kt:30-32) 异步执行 settings.setThemeMode(mode)。
  - SettingsRepositoryImpl.setThemeMode (SettingsRepositoryImpl.kt:30-33)：① 写入持久化键 "theme_mode"=mode.name；② themeFlow.value = mode（内存状态即时刷新）。
  - chip 选中态刷新链：themeFlow → SettingsViewModel.uiState (SettingsViewModel.kt:26-28 map) → SettingsScreen state.themeMode == mode (SettingsScreen.kt:66) → 选中 chip 高亮。
- data_flow: chip onClick (SettingsScreen.kt:67) → SettingsViewModel.setThemeMode (SettingsViewModel.kt:30) → SettingsRepository.setThemeMode (SettingsRepository.kt:8) → SettingsRepositoryImpl.setThemeMode (SettingsRepositoryImpl.kt:30) → themeFlow.value 写入 (SettingsRepositoryImpl.kt:32)。

## Entry · 整页配色即时跟随主题
- claim: 选择主题后，整个应用所有页面的配色方案立即刷新为新主题对应配色，无需重新打开页面。
- layers:
  - code:     app/src/main/java/com/whaticancook/app/MainActivity.kt:31-36 (darkTheme 计算 + WccTheme(darkTheme))
  - resource: N/A: 配色定义于代码 LightColors/DarkColors (Theme.kt:17/48)，无 res/values-night 资源参与
  - manifest: N/A: 配色切换为运行时状态，无 manifest 声明
- interaction: darkTheme 计算逻辑 (MainActivity.kt:31-35)：SYSTEM→isSystemInDarkTheme()；LIGHT→false；DARK→true。WccTheme 据 darkTheme 选择 LightColors 或 DarkColors (Theme.kt:84)；并经 SideEffect 同步状态栏/导航栏图标外观（亮色或暗色，Theme.kt:89-93）。
  - 整页配色刷新链（与 chip 选中态共享同一 themeFlow）：themeFlow → AppViewModel.uiState.themeMode (AppViewModel.kt:25-31，combine + SharingStarted.Eagerly) → MainActivity collectAsStateWithLifecycle (MainActivity.kt:30) → darkTheme 重算 → WccTheme 重渲染 → MaterialTheme.colorScheme 切换 → 全应用界面重组为新配色。
- data_flow: themeFlow.value 写入 (SettingsRepositoryImpl.kt:32) → AppViewModel.uiState (AppViewModel.kt:27) → MainActivity darkTheme (MainActivity.kt:31) → WccTheme colorScheme (Theme.kt:84)。

## Implicit triggers (non-UI state changes that activate this feature)
- 触发: 系统深浅色模式变化 — 当当前主题为"Match system"时，系统在深色/浅色之间切换会令 isSystemInDarkTheme() 取值改变 (MainActivity.kt:32, Theme.kt:81)，从而令整页配色跟随系统即时刷新（无需用户在应用内操作）。"Light"/"Dark"主题不受系统变化影响。

## Core business entities (data model / persistence key / state machine)
- ThemeMode 枚举: app/src/main/java/com/whaticancook/app/domain/model/ThemeMode.kt:3-11 — SYSTEM/LIGHT/DARK 三态，label 分别"Match system"/"Light"/"Dark"。
- 持久化键 "theme_mode"（存储于配置存储 wcc_settings）: app/src/main/java/com/whaticancook/app/data/repository/SettingsRepositoryImpl.kt:44 — 写入与持久化细节属 REQ-038 范围，本 REQ 仅用到"写入会同步刷新内存 themeFlow"这一即时生效机制。
- 内存状态 themeFlow（MutableStateFlow<ThemeMode>）: SettingsRepositoryImpl.kt:21-23 — 选择主题后 value 被即时替换，驱动 chip 选中态与整页配色两条消费链同时刷新。
- 配色方案 LightColors / DarkColors: Theme.kt:17-77 — 两套完整配色（主色/背景/表面/错误色等）。

## Cross-entry shared declarations
- None（主题切换的两条消费链共享同一 themeFlow 内存状态与 SettingsRepository，均无 manifest/build 声明）

## Deviations from REQ_DESC
1. REQ_DESC 未说明"Match system"在系统深浅色切换时的即时跟随行为；代码经 isSystemInDarkTheme() 实时跟随（MainActivity.kt:32）。属补充说明，非冲突。
2. REQ_DESC 未提及切换主题会同步调整状态栏/导航栏图标外观；代码经 SideEffect 调整（Theme.kt:89-93）。属补充说明，非冲突。
3. REQ_DESC 称"切换过程中当前页面和数据状态不丢失"。代码实现为：选择主题只触发整页重组（颜色刷新），不触发任何导航或页面重建，页面所在导航栈与对应页面状态、已输入数据均保持不变。属实现确认，与需求一致。

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 主题 chip 三选一交互：见上文 Entry · 主题 chip 选择
- 整页配色即时跟随：见上文 Entry · 整页配色即时跟随

### Consumers (who reads this state / data)
- Consumer: SettingsScreen（chip 选中态） — app/src/main/java/com/whaticancook/app/feature/settings/SettingsViewModel.kt:26
- Consumer: MainActivity / AppViewModel（整页 darkTheme） — app/src/main/java/com/whaticancook/app/MainActivity.kt:30-31

### Non-consumers (boundary counter-examples with evidence)
- claim: 主题切换不经过任何一级 tab 页面或详情页自身逻辑；这些页面仅作为 WccTheme 子内容被动刷新配色，不直接读取 themeMode
  - closure_layers: [code, resource, manifest]
  - tools: [homegraph_search "ThemeMode" projectPath, homegraph_callers "observeThemeMode" projectPath]
  - zero_hits: ThemeMode 的 8 个引用方仅 MainActivity / SettingsRepositoryImpl / SettingsRepository / AppViewModel + 2 处（homegraph impact 结果）；HomeScreen/SearchScreen/PantryScreen/FavoritesScreen/RecipeDetailScreen 均无 ThemeMode / darkTheme / observeThemeMode 引用 (Grep "ThemeMode\|darkTheme" over feature/{home,search,pantry,favorites,detail} 命中 0)

## Same-source cross-reference (if applicable)
- 选择主题后的持久保存（重启仍保持）由 `theme-persist-SPEC.md` 独立生成；主题 chip 的静态展示与所在区块结构见 `settings-overview-SPEC.md`。三份共享同一 ThemeMode 枚举与 themeFlow 状态源。
