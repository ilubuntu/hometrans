# Code trace · pantry-layout

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 食材库页入口 (Your pantry 卡 / 底部 Pantry) — HomeScreen.kt:98,227; WccApp.kt:95,51-57 — recalled by: both
- Entry 2: 页面标题与数量副标题 — PantryScreen.kt:63-78 — recalled by: both
- Entry 3: 手动添加输入框 — PantryScreen.kt:80,133-189 — recalled by: both
- Entry 4: "In your kitchen"已添加区 + Clear all — PantryScreen.kt:89-105 — recalled by: both
- Entry 5: "Quick add"分类建议区 — PantryScreen.kt:107-128 — recalled by: both

## Entry · 食材库页入口
- claim: 用户可从首页"Your pantry"卡或底部"Pantry"导航进入食材库页
- layers:
  - code:     HomeScreen.kt:98,227 PantrySummaryCard 点击 → onOpenPantry; WccApp.kt:95 onOpenPantry→navigateToTab(PANTRY); WccApp.kt:51-57 底部 Pantry 项 onSelect→navigate(PANTRY); WccApp.kt:106-108 composable(PANTRY){PantryScreen()}
  - resource: N/A
  - manifest: N/A
- interaction: 两个入口均路由到 PANTRY 路由 (Destinations.kt:15)
- data_flow: 入口点击 → navigateToTab(PANTRY)/navigate(PANTRY) (WccApp.kt:95,52) → PantryScreen (WccApp.kt:107)

## Entry · 页面标题与数量副标题
- claim: 页面顶部展示固定标题"My pantry"，下方副标题随食材数量变化
- layers:
  - code:     PantryScreen.kt:63-68 标题"My pantry"; PantryScreen.kt:69-78 副标题 (count==0 → "Add what you have — we'll find the recipes"; 否则 "N ingredient(s) on hand"); count=items.size (PantryViewModel.kt:33)
  - resource: N/A: 文案为字面量
  - manifest: N/A
- interaction: count 来自 PantryUiState.items.size (PantryViewModel.kt:33,55)
- data_flow: pantryRepository.observePantry() (PantryViewModel.kt:41) → items → count (PantryViewModel.kt:33) → 副标题 (PantryScreen.kt:70-73)

## Entry · 手动添加输入框
- claim: 标题区下方展示一个圆角输入框，占位文案"Add your own ingredient…"，右侧带加号按钮
- layers:
  - code:     PantryScreen.kt:80 AddIngredientField; PantryScreen.kt:133-189 实现; PantryScreen.kt:166 占位"Add your own ingredient…"; PantryScreen.kt:173-187 加号按钮; PantryScreen.kt:136-141 submit 校验 isNotBlank 后 onAdd(text.trim())
  - resource: N/A
  - manifest: N/A
- interaction: 输入框为本地可变状态 text (PantryScreen.kt:135)；提交触发 viewModel.add (PantryScreen.kt:80)。完整添加/校验行为见 `pantry-manual-add` (REQ-010)
- data_flow: 提交 → onAdd → viewModel.add(name) (PantryScreen.kt:80) → pantryRepository.add (PantryViewModel.kt:64)

## Entry · "In your kitchen"已添加区 + Clear all
- claim: 当已有食材时，展示"In your kitchen"区标题与右侧"Clear all"操作，下方以 chip 列出已添加食材
- layers:
  - code:     PantryScreen.kt:89 `if (state.items.isNotEmpty())`; PantryScreen.kt:91-96 SectionHeader(title="In your kitchen", actionText="Clear all", onActionClick=viewModel::clear); PantryScreen.kt:97-103 FlowRow 内 PantryChip 列表; PantryScreen.kt:192-214 PantryChip (名称 + Close 删除图标)
  - resource: N/A
  - manifest: N/A
- interaction: "Clear all"→viewModel.clear (PantryScreen.kt:94)；chip 点击 → viewModel.remove(item) (PantryScreen.kt:100)。完整删除/清空行为见 `pantry-remove`/`pantry-clear` (REQ-011/012)
- data_flow: items (PantryViewModel.kt:55) → PantryChip 列表 (PantryScreen.kt:99)；clear/remove → pantryRepository (PantryViewModel.kt:72,76)

## Entry · "Quick add"分类建议区
- claim: 下方展示"Quick add"区（食材库为空时标题改作"Add ingredients"），按分类分组列出常用食材建议 chip，每个 chip 带加号可添加
- layers:
  - code:     PantryScreen.kt:107-109 SectionHeader(title= if(items.isEmpty()) "Add ingredients" else "Quick add"); PantryScreen.kt:110-128 按 suggestionGroups 分组渲染 (分类 emoji+label + SuggestionChip 列表); PantryScreen.kt:216-239 SuggestionChip (名称 + Add 加号); 分组来源 PantryViewModel.kt:48-52 (PantryCatalog.all 按分类 groupBy，过滤已存在食材)
  - resource: N/A
  - manifest: N/A
- interaction: chip 加号 → viewModel.addCatalog(suggestion) (PantryScreen.kt:123)；建议区会过滤掉已在食材库中的食材 (PantryViewModel.kt:49)。完整添加行为见 `pantry-quick-add` (REQ-009)，分类集合见 `ingredient-categories` (REQ-013)
- data_flow: PantryCatalog.all (PantryCatalog.kt:19) → 过滤已存在 (PantryViewModel.kt:49) → groupBy category (PantryViewModel.kt:50) → suggestionGroups → 渲染 (PantryScreen.kt:110-128)

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 食材库变化 — PantryViewModel.kt:41 — behavior: 数量副标题、"In your kitchen"区显隐、"Quick add"建议区过滤同步刷新
- Trigger: 食材库为空 — PantryScreen.kt:89,108 — behavior: "In your kitchen"区与"Clear all"隐藏；"Quick add"标题改作"Add ingredients"
- Trigger: 进入食材库页 (PantryViewModel 构造) — PantryViewModel.kt:41 — behavior: 订阅食材库并组装建议区

## Core business entities (data model / persistence key / state machine)
- Entity: PantryUiState(loading,items,sections,suggestionGroups,count) — PantryViewModel.kt:27-34；count=items.size
- Entity: PantryItem(name,category,display) — 见 domain.model.PantryItem；chip 显示 item.display (PantryScreen.kt:202)
- Entity: CatalogGroup(category,suggestions) / CatalogIngredient(name,category) — PantryViewModel.kt:22-25, PantryCatalog.kt:12
- Entity: IngredientCategory(label,emoji) — IngredientCategory.kt:4-12，八分类 Produce/Meat&Seafood/Dairy&Eggs/Grains&Bread/Pantry Staples/Spices&Herbs/Condiments&Oils/Other
- 依赖来源: 食材库数据通过 PantryRepository 持久化（写入/删除/清空见 REQ-009~012）；PantryCatalog 为内置常用食材目录 (PantryCatalog.kt:18)

## Cross-entry shared declarations
- PantryViewModel.uiState (PantryViewModel.kt:41): 标题副标题/输入框/In your kitchen/Quick add 四区共用的单一状态源
- PantryRepository.observePantry(): 食材库页与首页(pantryCount)、搜索页、详情页共用的食材数据契约

## Deviations from REQ_DESC
1. REQ_DESC 验收点数量副标题"N ingredients on hand"——代码在 count==0 时副标题改作"Add what you have — we'll find the recipes"，仅 count>=1 时为"N ingredient(s) on hand" (PantryScreen.kt:70-73)；即空库副标题与需求字面"N ingredients on hand"不同（属引导文案），需求为简写
2. REQ_DESC 验收点"Quick add"——代码在食材库为空时该区标题改作"Add ingredients"，非空时才为"Quick add" (PantryScreen.kt:108)；属状态相关标题，需求描述非空态
3. REQ_DESC 验收点输入框占位"Add your own ingredient..."——代码为"Add your own ingredient…"(省略号字符) (PantryScreen.kt:166)，语义一致
4. REQ_DESC 列出布局含"手动输入框、已添加食材、Clear all 和 Quick add 分类区"——四者均在代码中存在 (PantryScreen.kt:80,89-105,107-128)，其完整交互分别由 REQ-009/010/011/012 描述，本规覆盖"存在于食材库页布局中"

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 食材库页布局全部区段已在上文 Entry 1–5 枚举（入口、标题副标题、手动输入框、In your kitchen+Clear all、Quick add 分类区）。食材库页无其他区段
- 食材库页有标题"My pantry"但无独立返回按钮——作为底部导航顶级页，靠底部导航切换离开，不提供返回键
  layers: code WccApp.kt:106-108; resource N/A; manifest N/A
  interaction: 顶级页，无 onBack

### Consumers (who reads this state / data)
- Consumer: PantryScreen 各区读取 PantryUiState — PantryScreen.kt:55
- Consumer: 首页读取同一食材库计算 pantryCount/cookNow — HomeViewModel.kt:71,86

### Non-consumers (boundary counter-examples with evidence)
- claim: 食材库页布局元素不被其他页面复用承载；"My pantry"标题、"In your kitchen"区、Quick add 建议区为食材库页专属
  closure_layers: [code]
  tools: [mcp__homegraph__callers "PantryScreen", Grep "My pantry|In your kitchen|Quick add" over app/src]
  zero_hits: homegraph__callers "PantryScreen" 仅 WccApp.kt:107；Grep "In your kitchen" 命中仅 PantryScreen.kt:92；Grep "Quick add" 命中仅 PantryScreen.kt:108，其他页面零命中

## Same-source cross-reference (if applicable)
- 食材库页的添加(手动/快速)、删除、清空交互分别由 `pantry-manual-add-SPEC.md`/`pantry-quick-add-SPEC.md`/`pantry-remove-SPEC.md`/`pantry-clear-SPEC.md` 描述；Quick add 分类集合由 `ingredient-categories-SPEC.md` (REQ-013) 描述。本规聚焦食材库页"包含哪些布局区段及其静态结构"，与上述各规互补不重叠
