# Code trace · back-navigation

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 菜谱详情页顶部返回按钮 — app/src/main/java/com/whaticancook/app/feature/detail/RecipeDetailScreen.kt:193-198 — recalled by: path 1 (explore "onBack RecipeDetailScreen")
- Entry 2: 设置页顶部返回按钮 — app/src/main/java/com/whaticancook/app/core/designsystem/component/TopBar.kt:53-71 (WccTopBar 内 CircleIconButton ArrowBack) — recalled by: path 1
- Entry 3: 返回动作的统一实现（弹出当前页回上一级） — app/src/main/java/com/whaticancook/app/navigation/WccApp.kt:118,128 (onBack = navController.popBackStack()) — recalled by: path 2 (callers wiring)

## Entry · 菜谱详情页返回按钮
- claim: 菜谱详情页左上角提供一个返回按钮，点击后返回进入详情页之前的页面（通常是首页或搜索页或收藏页）。
- layers:
  - code:     app/src/main/java/com/whaticancook/app/feature/detail/RecipeDetailScreen.kt:186-198 (固定在顶部的 Row 内 CircleIconButton(icon=ArrowBack, onClick=onBack))；onBack 由 WccApp 注入 = navController.popBackStack() (WccApp.kt:128)
  - resource: N/A: 图标为代码内 Icons.AutoMirrored.Rounded.ArrowBack (RecipeDetailScreen.kt:194)
  - manifest: N/A: 应用内导航返回，无 manifest 声明
- interaction: 点击 → onBack → popBackStack()，弹出详情页这一层，回到上一条导航栈条目。无状态写入。
- data_flow: CircleIconButton onClick (RecipeDetailScreen.kt:196) → onBack (RecipeDetailScreen.kt:65) → WccApp.kt:128 navController.popBackStack()。

## Entry · 设置页返回按钮
- claim: 设置页顶部提供一个返回按钮（含"Settings"标题），点击后返回进入设置页之前的页面（通常是首页）。
- layers:
  - code:     app/src/main/java/com/whaticancook/app/feature/settings/SettingsScreen.kt:44 (WccTopBar(title="Settings", onBack=onBack))；WccTopBar 内 CircleIconButton(ArrowBack, onClick=onBack) 见 TopBar.kt:66-71；onBack 由 WccApp 注入 = navController.popBackStack() (WccApp.kt:118)
  - resource: N/A
  - manifest: N/A
- interaction: 点击 → onBack → popBackStack()，弹出设置页，回到首页。无状态写入。
- data_flow: CircleIconButton onClick (TopBar.kt:69) → onBack → SettingsScreen onBack (SettingsScreen.kt:38) → WccApp.kt:118 navController.popBackStack()。

## Entry · 返回后保持上一页数据状态
- claim: 从详情页或设置页返回后，上一页（如首页）的页面数据状态（如已选分类、已输入搜索词）保持不变。
- layers:
  - code:     首页已选分类: app/src/main/java/com/whaticancook/app/feature/home/HomeViewModel.kt:43,58-60 (selectedCategory = MutableStateFlow，ViewModel 在导航栈存活期间保持)；搜索页搜索词: app/src/main/java/com/whaticancook/app/feature/search/SearchViewModel.kt:50,67 (query = MutableStateFlow)
  - resource: N/A
  - manifest: N/A
- interaction: 这些页面数据状态保存在各自页面状态对象（随导航栈条目存活），返回上一页时页面重新订阅同一状态，已选分类/搜索词等数据保留。注意：列表精确滚动位置未在代码中以可持久化方式保存（HomeScreen 使用 LazyColumn 默认滚动状态，未显式保留），因此"列表位置"为尽力保留，不保证精确还原。
- data_flow: 返回 popBackStack → 上一页 composable 重建 → 重新收集同一页面状态对象的 uiState → 已选分类/搜索词等数据状态恢复。

## Implicit triggers (non-UI state changes that activate this feature)
- 触发: 系统返回（系统返回手势或系统返回键） — 导航宿主的默认返回行为同样执行弹出当前页（等效于点击页面内返回按钮），令用户回到上一级。两条返回路径（页面内返回按钮、系统返回）最终都落到弹出当前导航栈条目。

## Core business entities (data model / persistence key / state machine)
- 导航栈（NavController 回退栈）: WccApp.kt:35 (rememberNavController) — 返回操作即弹出栈顶条目。
- onBack 回调: 详情页 RecipeDetailScreen.onBack (RecipeDetailScreen.kt:65)、设置页 SettingsScreen.onBack (SettingsScreen.kt:38)，二者在 WccApp 统一绑定为 popBackStack() (WccApp.kt:118,128)。
- 页面状态对象 selectedCategory / query: HomeViewModel.kt:43 / SearchViewModel.kt:50 — 返回后数据状态恢复的来源。

## Cross-entry shared declarations
- None（返回导航为应用内组合 UI + 导航栈操作，无 manifest/build 跨条目声明）

## Deviations from REQ_DESC
1. REQ_DESC 要求详情页与设置页等二级页面提供返回按钮。代码在详情页左上角 (RecipeDetailScreen.kt:193-198) 与设置页顶部 (SettingsScreen.kt:44 + TopBar.kt:66-71) 均提供返回按钮。无冲突。
2. REQ_DESC 称"返回后保持上一页状态，例如分类、搜索词或列表位置尽量不丢失"。代码中分类 (HomeViewModel.kt:43)、搜索词 (SearchViewModel.kt:50) 等数据状态随页面状态对象保留，返回后恢复；但列表精确滚动位置未以可持久化方式保存，属"尽力保留"，可能与需求"尽量不丢失"的预期存在差异（列表位置可能回到顶部）。此为需求与实现间的潜在差异，需用户确认是否需要精确保留滚动位置。
3. REQ_DESC 未提及系统返回键/手势；代码经导航宿主默认返回行为支持系统返回（等效页面内返回按钮）。属补充说明，非冲突。

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 菜谱详情页返回：见 Entry · 菜谱详情页返回按钮
- 设置页返回：见 Entry · 设置页返回按钮
- 返回后数据状态保持：见 Entry · 返回后保持上一页数据状态

### Consumers (who reads this state / data)
- Consumer: RecipeDetailScreen（详情页返回按钮） — app/src/main/java/com/whaticancook/app/feature/detail/RecipeDetailScreen.kt:196
- Consumer: SettingsScreen（设置页返回按钮，经 WccTopBar） — app/src/main/java/com/whaticancook/app/feature/settings/SettingsScreen.kt:44

### Non-consumers (boundary counter-examples with evidence)
- claim: 一级 tab 页面（首页/搜索/食材库/收藏）本身不提供"返回上一级"的页面内返回按钮；这些页面通过底部导航相互切换
  - closure_layers: [code, resource, manifest]
  - tools: [homegraph_search "WccTopBar" projectPath, Grep "onBack\|ArrowBack" over feature/{home,search,pantry,favorites}]
  - zero_hits: Grep "WccTopBar" 命中仅 SettingsScreen 与 PantryScreen（PantryScreen 用作标题栏但 onBack 为占位）；Grep "ArrowBack" 命中仅 TopBar.kt/RecipeDetailScreen.kt；HomeScreen/SearchScreen/FavoritesScreen 顶部无 WccTopBar 返回按钮（首页用 HomeHeader，搜索页/收藏页用各自标题栏，无返回箭头）

## Same-source cross-reference (if applicable)
- 返回导航与 `bottom-nav-SPEC.md`（REQ-040）互补：本 SPEC 覆盖从二级页面（详情页/设置页）返回上一级，`bottom-nav-SPEC.md` 覆盖一级 tab 之间的切换。两者共享同一导航栈（NavController 回退栈）。
