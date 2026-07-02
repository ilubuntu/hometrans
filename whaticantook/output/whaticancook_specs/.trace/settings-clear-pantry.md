# Code trace · settings-clear-pantry

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: Settings 页面数据区块的"Clear pantry"项 — app/src/main/java/com/whaticancook/app/feature/settings/SettingsScreen.kt:76-103 — recalled by: path 1 (explore "clearPantry")
- Entry 2: 清空后受影响的消费方（首页 / 详情页 / 搜索页 / 收藏页 / 食材库页） — recalled by: path 2 (callers of PantryRepository.observePantry / clear)

## Entry · Settings 页面"Clear pantry"触发清空
- claim: 用户在"设置"页面数据区块点击"Clear pantry"项，立即清空全部已添加食材，无需二次确认。
- layers:
  - code:     app/src/main/java/com/whaticancook/app/feature/settings/SettingsScreen.kt:76-103 (Row.bounceClick(onClick = viewModel::clearPantry, SettingsScreen.kt:80))；SettingsViewModel.clearPantry (SettingsViewModel.kt:34-36) → pantryRepository.clear()
  - resource: N/A: 行左侧为代码内图标 Icons.Rounded.DeleteSweep (SettingsScreen.kt:85)，无 res 资源
  - manifest: N/A: 应用内数据操作，无 manifest 声明
- interaction: 点击 → viewModel.clearPantry (SettingsScreen.kt:80) → SettingsViewModel.clearPantry (SettingsViewModel.kt:34) 异步执行 pantryRepository.clear()。无确认弹窗、无 toast 回执、无状态写入到设置态。
  - PantryRepositoryImpl.clear (PantryRepositoryImpl.kt:47-49) → PantryDao.clear (PantryDao.kt:22-23: @Query("DELETE FROM pantry_items"))。
- data_flow: bounceClick (SettingsScreen.kt:80) → SettingsViewModel.clearPantry (SettingsViewModel.kt:34) → PantryRepository.clear (PantryRepository.kt:14) → PantryRepositoryImpl.clear (PantryRepositoryImpl.kt:47) → PantryDao.clear → DELETE FROM pantry_items (PantryDao.kt:22)。

## Entry · 清空后首页恢复空食材提示
- claim: 清空食材后，首页食材数量归零，"可做菜谱"区不再展示，恢复为引导添加食材的空态提示。
- layers:
  - code:     app/src/main/java/com/whaticancook/app/feature/home/HomeViewModel.kt:68-79（combine observePantry → pantryCount）；HomeScreen.kt:98-120（PantrySummaryCard 计数 / cookNow 为空且 pantryCount==0 时展示 CookNowPrompt）
  - resource: N/A
  - manifest: N/A
- interaction: observePantry 发出空列表 → HomeViewModel.buildContent 中 pantry.size=0 (HomeViewModel.kt:100)，cookNow 因 pantryNames.isNotEmpty() 为假恒为空 (HomeViewModel.kt:90)；HomeScreen 据此显示 CookNowPrompt 引导添加食材。
- data_flow: pantry_items 表清空 → PantryDao.observeAll 发空 (PantryRepositoryImpl.kt:25-28) → HomeViewModel uiState → HomeScreen 重组。

## Entry · 清空后详情页缺失状态重新计算
- claim: 清空食材后，菜谱详情页的食材匹配状态、缺失数量与缺失列表立即按空食材库重新计算。
- layers:
  - code:     app/src/main/java/com/whaticancook/app/feature/detail/RecipeDetailViewModel.kt:47-63（combine observeRecipe + observePantry 重算 IngredientStatus.have 与 matchAgainst）
  - resource: N/A
  - manifest: N/A
- interaction: observePantry 发空 → pantryNames 为空 → 每个 RecipeIngredient 的 have=false（除非匹配逻辑恒真，此处为 false，RecipeDetailViewModel.kt:54-60），match.missing 重算为全部必需食材。
- data_flow: pantry_items 清空 → RecipeDetailViewModel combine → DetailUiState.Content 重发 → 详情页缺失状态刷新。

## Entry · 清空后搜索页与收藏页匹配重新计算
- claim: 清空食材后，搜索页菜谱匹配计数与"可做"筛选结果、收藏页匹配计数均按空食材库重新计算。
- layers:
  - code:     搜索: app/src/main/java/com/whaticancook/app/feature/search/SearchViewModel.kt:59-65（combine observePantry）；收藏: app/src/main/java/com/whaticancook/app/feature/favorites/FavoritesViewModel.kt:29-38（combine observePantry）
  - resource: N/A
  - manifest: N/A
- interaction: observePantry 发空 → SearchViewModel.build / FavoritesViewModel 中 pantryNames 为空 → 各菜谱 match.ratio 与 isCookable 重算（空食材库下 isCookable 恒假）。
- data_flow: pantry_items 清空 → SearchViewModel/FavoritesViewModel combine → 列表匹配刷新。

## Implicit triggers (non-UI state changes that activate this feature)
- None（清空动作的唯一触发是用户在设置页点击"Clear pantry"；无隐式触发。清空后各页面刷新是数据流响应，归各 Entry）

## Core business entities (data model / persistence key / state machine)
- 食材库表 pantry_items: PantryDao.kt:13/22 — 清空操作为 DELETE FROM pantry_items，删除全部行。
- PantryRepository.clear / PantryRepositoryImpl.clear: PantryRepository.kt:14 / PantryRepositoryImpl.kt:47-49 — 设置页清空与食材库页"Clear all"共用同一实现。
- observePantry() Flow: PantryRepository.kt:8 / PantryRepositoryImpl.kt:25 — 所有消费方（首页/详情/搜索/收藏/食材库）订阅同一流，清空后统一收到空列表。
- 依赖: 本 REQ 共享 `pantry-clear-SPEC.md`（REQ-012，食材库页 Clear all）的底层 PantryRepository.clear；二者入口不同但清空语义一致。

## Cross-entry shared declarations
- None（清空操作无 manifest/build 跨条目声明）

## Deviations from REQ_DESC
1. REQ_DESC 称"点击 Clear pantry"即可清空；代码实现为点击后立即清空，无确认弹窗、无成功 toast (SettingsScreen.kt:76-103)。属补充说明，与需求"点击即清空"一致。
2. REQ_DESC 称"pantry 数量归零，首页提示恢复，详情页缺失状态重新计算"。代码除这两处外，搜索页与收藏页的匹配计数也同步重新计算（Entry · 清空后搜索页与收藏页）。属补充覆盖，非冲突。

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 触发清空：Settings 页"Clear pantry"项（见 Entry · Settings 页面"Clear pantry"触发清空）
- 受影响消费方：首页空态提示 / 详情页缺失重算 / 搜索页匹配重算 / 收藏页匹配重算（见对应 Entry）/ 食材库页列表清空（PantryViewModel 订阅 observePantry，PantryViewModel.kt loading 字段，items 清空）

### Consumers (who reads this state / data)
- Consumer: HomeViewModel — app/src/main/java/com/whaticancook/app/feature/home/HomeViewModel.kt:71
- Consumer: RecipeDetailViewModel — app/src/main/java/com/whaticancook/app/feature/detail/RecipeDetailViewModel.kt:49
- Consumer: SearchViewModel — app/src/main/java/com/whaticancook/app/feature/search/SearchViewModel.kt:61
- Consumer: FavoritesViewModel — app/src/main/java/com/whaticancook/app/feature/favorites/FavoritesViewModel.kt:31
- Consumer: PantryViewModel — app/src/main/java/com/whaticancook/app/feature/pantry/PantryViewModel.kt

### Non-consumers (boundary counter-examples with evidence)
- claim: 清空食材不影响收藏关系数据（favorites 表）、菜谱种子数据（recipes 表）与主题/引导设置
  - closure_layers: [code, resource, manifest]
  - tools: [homegraph_impact "clear" depth 2 projectPath, Grep "DELETE FROM" over data/local/dao]
  - zero_hits: PantryDao.clear 仅 DELETE FROM pantry_items (PantryDao.kt:22)；FavoriteDao 的 DELETE 仅按 recipeId 删除单条 (FavoriteDao.kt:19)，无全清；Grep "pantry_items" 命中仅 PantryDao/PantryRepositoryImpl/PantryItemEntity，未涉及 favorites/recipes/onboarding/theme

## Same-source cross-reference (if applicable)
- 本 REQ 与 `pantry-clear-SPEC.md`（REQ-012）共享同一 PantryRepository.clear 与 pantry_items 表清空语义；区别仅在入口：本 SPEC 入口为"设置"页面数据区块的"Clear pantry"，`pantry-clear-SPEC.md` 入口为"食材库"页面的"Clear all"。两份 SPEC 独立生成，互相引用。
