# Code trace · pantry-clear

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 食材库页"Clear all"操作 — PantryScreen.kt:91-96 — recalled by: both
- Entry 2: 清空落库与跨页刷新 — PantryViewModel.kt:75-77; PantryRepositoryImpl.kt:47-49 — recalled by: both
- Entry 3（同源另一入口，超出本 REQ 主体范围）: 设置页"Clear pantry" — SettingsScreen.kt:80,92; SettingsViewModel.kt:34-36 — recalled by: path 2（反查 repository.clear 调用者）

## Entry · 食材库页"Clear all"操作
- claim: 食材库页"In your kitchen"区标题右侧提供"Clear all"操作，点击后一次性清空全部食材
- layers:
  - code:     PantryScreen.kt:91-96 SectionHeader(title="In your kitchen", actionText="Clear all", onActionClick=viewModel::clear); 显示条件 items 非空 (PantryScreen.kt:89); SectionHeader 操作文本点击 → onActionClick (Headers.kt:32-39)
  - resource: N/A
  - manifest: N/A
- interaction: "Clear all"仅在已有食材时显示；点击 → viewModel.clear
- data_flow: 点击"Clear all" (Headers.kt:37) → onActionClick → viewModel.clear (PantryScreen.kt:94) → pantryRepository.clear() (PantryViewModel.kt:76)

## Entry · 清空落库与跨页刷新
- claim: 清空删除食材库表全部行，已添加区与数量归零，首页与详情页等匹配状态同步刷新
- layers:
  - code:     PantryViewModel.kt:75-77 clear()→pantryRepository.clear(); PantryRepositoryImpl.kt:47-49 clear()→pantryDao.clear(); PantryDao.kt:22-23 `DELETE FROM pantry_items`；刷新经 observeAll (PantryDao.kt:13) → observePantry (PantryRepositoryImpl.kt:25)；跨页消费者 HomeViewModel.kt:71,86 (pantryCount=0、cookNow 空) / RecipeDetailViewModel 经 observePantry 重算匹配
  - resource: N/A
  - manifest: N/A
- interaction: 删除全部行；清空后 items 为空 → "In your kitchen"区与"Clear all"隐藏 (PantryScreen.kt:89)、count=0 (PantryViewModel.kt:33)、副标题回空库文案 (PantryScreen.kt:70-71)、"Quick add"标题改"Add ingredients" (PantryScreen.kt:108)
- data_flow: clear (PantryViewModel.kt:75) → repository.clear (:76) → pantryDao.clear (PantryRepositoryImpl.kt:48) → DELETE FROM pantry_items (PantryDao.kt:22) → observeAll → observePantry → 各消费者刷新：食材库页 (PantryScreen.kt:55)、首页 pantryCount/cookNow/空食材提示 (HomeViewModel.kt:71,86,89-91,118)、详情页匹配重算、搜索页 (SearchViewModel.kt:61)

## Entry · 设置页"Clear pantry"（同源另一入口）
- claim: 设置页也提供"Clear pantry"操作，点击后同样清空全部食材，与食材库页"Clear all"效果一致
- layers:
  - code:     SettingsScreen.kt:80,92 "Clear pantry"点击 → viewModel::clearPantry; SettingsViewModel.kt:34-36 clearPantry()→pantryRepository.clear()
  - resource: N/A
  - manifest: N/A
- interaction: 与食材库页"Clear all"共用同一 repository.clear() → pantryDao.clear()；属同一清空行为的另一入口
- data_flow: 点击"Clear pantry" (SettingsScreen.kt:80) → clearPantry (SettingsViewModel.kt:34) → pantryRepository.clear() (:35) → 同 Entry · 清空落库

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 食材库变化（清空） — PantryViewModel.kt:41 — behavior: 已添加区隐藏、数量归零、副标题与"Quick add"标题切换、建议区恢复全量
- Trigger: 清空后跨页订阅者收到空食材库 — HomeViewModel.kt:71 / SearchViewModel.kt:61 / RecipeDetailViewModel — behavior: 首页 pantryCount=0 与空食材提示出现、cookNow 清空；详情页匹配重算为全缺；搜索页可做筛选结果清空

## Core business entities (data model / persistence key / state machine)
- Entity: pantry_items 表 — PantryItemEntity.kt:6-10；clear 删除全部行 (PantryDao.kt:22-23)
- Entity: PantryRepository.clear() — PantryRepository.kt:14；清空契约，两入口共用
- 依赖来源: 清空后首页空食材提示见 `empty-pantry-hint` (REQ-005)；食材库页布局调整见 `pantry-layout` (REQ-008)

## Cross-entry shared declarations
- PantryRepository.clear() / PantryDao.clear() (PantryRepositoryImpl.kt:47 / PantryDao.kt:22): 食材库页"Clear all"与设置页"Clear pantry"共用的同一清空落库路径
- observePantry() (PantryRepositoryImpl.kt:25): 食材库页/首页/搜索页/详情页共用的食材数据流，清空后各页同步收到空列表

## Deviations from REQ_DESC
1. REQ_DESC 称"通过 Clear all 一次性清空"——代码"Clear all"→pantryDao.clear() 删除全部行 (PantryDao.kt:22-23)，一致
2. REQ_DESC 验收"In your kitchen 变为空，食材数量变为 0，首页和详情页匹配状态同步刷新"——代码清空后 items 空 (PantryViewModel.kt:55)、count=0 (PantryViewModel.kt:33)、首页 pantryCount=0+空食材提示 (HomeViewModel.kt:86,118)、详情页匹配重算，一致
3. REQ_DESC 仅提"Clear all"入口——代码另有设置页"Clear pantry"同源入口 (SettingsScreen.kt:92)，属同行为的另一入口（REQ-039 范畴），本规主体为食材库页"Clear all"

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 食材库页"Clear all" (PantryScreen.kt:93) — 本 REQ 主体
  layers: code PantryScreen.kt:89-96; resource N/A; manifest N/A
  interaction/data_flow: 同 Entry · 食材库页"Clear all"操作
- 设置页"Clear pantry" (SettingsScreen.kt:92) — 同源另一入口，行为等价
  layers: code SettingsScreen.kt:80,92 + SettingsViewModel.kt:34-36; resource N/A; manifest N/A
  interaction/data_flow: 同 Entry · 设置页"Clear pantry"

### Consumers (who reads this state / data)
- Consumer: 食材库页"In your kitchen"区与数量副标题 — PantryScreen.kt:99,70
- Consumer: 首页 pantryCount/cookNow/空食材提示 — HomeViewModel.kt:71,86,89-91,118
- Consumer: 详情页匹配计算 — RecipeDetailViewModel（经 observePantry）
- Consumer: 搜索页可做筛选/匹配 — SearchViewModel.kt:61

### Non-consumers (boundary counter-examples with evidence)
- claim: "Clear all"不弹确认对话框，点击即立即清空全部
  closure_layers: [code]
  tools: [Read PantryScreen.kt:91-96, Read PantryViewModel.kt:75-77]
  zero_hits: onActionClick 直接 viewModel.clear，无 Dialog/确认；clear 直接 repository.clear，无确认分支
- claim: "Clear all"仅在已有食材时显示，空食材库时不显示该操作
  closure_layers: [code]
  tools: [Read PantryScreen.kt:89]
  zero_hits: PantryScreen.kt:89 `if(state.items.isNotEmpty())` 包裹整个"In your kitchen"区含"Clear all"，空库时不渲染

## Same-source cross-reference (if applicable)
- 食材库页"Clear all"与设置页"Clear pantry"为同一清空行为的两个入口，共用 PantryRepository.clear()。设置页"Clear pantry"的完整描述属 REQ-039（超出本批次范围），本规仅在作用范围与同源入口处提示；二者行为等价（均一次性清空全部食材并跨页刷新）。本规聚焦食材库页"Clear all"入口
- 清空后触发的首页空食材提示见 `empty-pantry-hint-SPEC.md` (REQ-005)，食材库页布局调整见 `pantry-layout-SPEC.md` 场景三
