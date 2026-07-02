# Code trace · ingredient-categories

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: Quick add 分类分组渲染 — PantryScreen.kt:107-128 — recalled by: both
- Entry 2: 分类建议数据装配 — PantryViewModel.kt:48-52; PantryCatalog.kt:19-43 — recalled by: both

## Entry · Quick add 分类分组渲染
- claim: Quick add 区按食材分类分组展示，每组先显示分类图标与分类名标题，再以胶囊列出该分类下的常用食材建议；整区可滚动，滚动后胶囊仍可点击添加
- layers:
  - code:     PantryScreen.kt:107-109 区标题("Quick add"/空库时"Add ingredients"); PantryScreen.kt:110-128 按 suggestionGroups 分组渲染; PantryScreen.kt:113-118 分类标题 "${category.emoji}  ${category.label}"; PantryScreen.kt:119-126 FlowRow 内 SuggestionChip 列表; PantryScreen.kt:84-88 整个内容区为 LazyColumn 可滚动; PantryScreen.kt:223 chip bounceClick 滚动后仍可点击
  - resource: N/A: 分类名与图标为枚举字面量
  - manifest: N/A
- interaction: 分组顺序按 category.ordinal 升序 (PantryViewModel.kt:52)；每组内胶囊顺序按目录定义顺序
- data_flow: suggestionGroups (PantryViewModel.kt:57) → items(index) 渲染分组 (PantryScreen.kt:110-111) → 分类标题 + SuggestionChip 列表

## Entry · 分类建议数据装配
- claim: Quick add 的分类与食材来自内置常用食材目录，按分类分组、过滤已添加项、按分类序排序
- layers:
  - code:     PantryViewModel.kt:48-52 `PantryCatalog.all.filter{normalize(name) !in present}.groupBy{category}.map{CatalogGroup}.sortedBy{category.ordinal}`; PantryCatalog.kt:19-43 目录定义（7 个分类）；IngredientCategory.kt:4-12 分类枚举（8 项，含 Other）
  - resource: N/A
  - manifest: N/A
- interaction: 过滤掉已在食材库中的食材 (PantryViewModel.kt:49)；分组按 category.ordinal 排序 (PantryViewModel.kt:52)
- data_flow: PantryCatalog.all (PantryCatalog.kt:19) → filter 已存在 (PantryViewModel.kt:49) → groupBy category (PantryViewModel.kt:50) → sortedBy ordinal (PantryViewModel.kt:52) → suggestionGroups → 渲染

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 食材库变化 — PantryViewModel.kt:41 — behavior: 已添加项从建议区对应分类中移除；若某分类下全部食材均已添加，该分类组整体不再显示
- Trigger: 进入食材库页 — PantryViewModel.kt:41 — behavior: 装配全量分类建议

## Core business entities (data model / persistence key / state machine)
- Entity: IngredientCategory(label,emoji) — IngredientCategory.kt:4-12，八分类（序号顺序）：Produce🥦/Meat&Seafood🍗/Dairy&Eggs🧀/Grains&Bread🍞/Pantry Staples🫙/Spices&Herbs🌿/Condiments&Oils🫒/Other🧂
- Entity: PantryCatalog.all — PantryCatalog.kt:19-43，内置常用食材目录，覆盖 7 个分类（不含 Other）：Produce(16 项)/Meat&Seafood(7)/Dairy&Eggs(8)/Grains&Bread(8)/Pantry Staples(7)/Condiments&Oils(5)/Spices&Herbs(9)
- Entity: CatalogGroup(category,suggestions) — PantryViewModel.kt:22-25
- 依赖来源: Quick add 区位置与添加交互见 `pantry-layout`/`pantry-quick-add` (REQ-008/009)

## Cross-entry shared declarations
- PantryCatalog.all (PantryCatalog.kt:19): Quick add 分类展示的唯一数据源
- IngredientCategory 枚举 (IngredientCategory.kt): 分类标签与图标的单一来源，亦用于已添加食材的分类归属

## Deviations from REQ_DESC
1. REQ_DESC 分类列举"Produce、Meat & Seafood、Dairy & Eggs、Grains & Bread 等"——代码 Quick add 实际覆盖 7 个分类，另含 Pantry Staples、Condiments & Oils、Spices & Herbs (PantryCatalog.kt:19-43)；REQ 用"等"表举例，无冲突
2. REQ_DESC 验收"各分类标题和食材 chip 正确展示，滚动后仍可添加食材"——代码分类标题为"${emoji}  ${label}" (PantryScreen.kt:114)、chip 为 SuggestionChip (PantryScreen.kt:121-124)、整区在 LazyColumn 内可滚动 (PantryScreen.kt:84) 且 chip 用 bounceClick 滚动后仍响应 (PantryScreen.kt:223)，一致
3. REQ_DESC 未提及分组顺序——代码按 category.ordinal 升序排序 (PantryViewModel.kt:52)，显示顺序为 Produce→Meat&Seafood→Dairy&Eggs→Grains&Bread→Pantry Staples→Spices&Herbs→Condiments&Oils（注：Spices&Herbs 因 enum 序号在 Condiments&Oils 前，故虽目录定义中 Condiments 在前，显示时 Spices&Herbs 排前）

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- Quick add 分类分组展示为全应用唯一的分类化食材建议区 (PantryScreen.kt:107-128)
  layers: code PantryScreen.kt:107-128; resource N/A; manifest N/A
  interaction/data_flow: 同 Entry · Quick add 分类分组渲染 + Entry · 分类建议数据装配

### Consumers (who reads this state / data)
- Consumer: 食材库页 Quick add 区读取 suggestionGroups 渲染 — PantryScreen.kt:110

### Non-consumers (boundary counter-examples with evidence)
- claim: "Other"分类不出现在 Quick add 建议区——目录未收录 Other 分类食材，Other 仅作为手动添加的默认分类
  closure_layers: [code]
  tools: [Read PantryCatalog.kt:19-43, Grep "IngredientCategory.OTHER|, OTHER" over PantryCatalog.kt]
  zero_hits: PantryCatalog.kt:19-43 仅用 PRODUCE/MEAT_SEAFOOD/DAIRY_EGGS/GRAINS_BREAD/PANTRY/CONDIMENTS/SPICES 七类，无 OTHER；Grep "OTHER" 在 PantryCatalog.kt 命中 0
- claim: 已添加食材的分类归属（sections，PantryViewModel.kt:44-47）不在 Quick add 区展示；Quick add 仅展示目录建议分组
  closure_layers: [code]
  tools: [Grep "state.sections" over PantryScreen.kt]
  zero_hits: Grep "state.sections" 在 PantryScreen.kt 命中 0；PantryScreen 仅用 items（已添加区不按分类分组，平铺为 FlowRow）与 suggestionGroups（Quick add 按分类分组）

## Same-source cross-reference (if applicable)
- Quick add 分类展示与"快速添加食材"(`pantry-quick-add-SPEC.md`, REQ-009) 共用同一 suggestionGroups 数据与 SuggestionChip；本规聚焦"按哪些分类分组展示、分组顺序、滚动可添加"，添加落库行为由 `pantry-quick-add` 描述
- 分类枚举 IngredientCategory 亦用于已添加食材的分类字段与手动添加默认分类（见 `pantry-manual-add-SPEC.md`），但已添加区展示为平铺不分组
