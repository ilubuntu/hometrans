# Code trace · pantry-quick-add

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: Quick add 建议 chip 加号 (SuggestionChip) — PantryScreen.kt:216-239 — recalled by: both
- Entry 2: 添加落库与列表刷新 — PantryViewModel.kt:67-69; PantryRepositoryImpl.kt:30-41 — recalled by: both

## Entry · Quick add 建议 chip 加号 (SuggestionChip)
- claim: 用户点击 Quick add 区某食材建议 chip 上的加号，该食材被加入"已添加食材"，已添加数量同步增加，该建议 chip 从建议区消失
- layers:
  - code:     PantryScreen.kt:216-239 SuggestionChip (label + Add 图标); PantryScreen.kt:223 点击 → onAdd; PantryScreen.kt:120-125 每个 suggestion 渲染 SuggestionChip(onAdd=viewModel.addCatalog(suggestion)); 建议集合来自 PantryCatalog.all (PantryCatalog.kt:19)
  - resource: N/A
  - manifest: N/A
- interaction: 点击加号 → viewModel.addCatalog(suggestion) (PantryScreen.kt:123)
- data_flow: 点击 (PantryScreen.kt:223) → onAdd → viewModel.addCatalog (PantryScreen.kt:123) → pantryRepository.add(item.name, item.category) (PantryViewModel.kt:68)

## Entry · 添加落库与列表刷新
- claim: 食材按其目录分类归一化后写入食材库表（主键为归一化名），写入后"已添加食材"区与数量、建议区过滤同步刷新
- layers:
  - code:     PantryViewModel.kt:67-69 addCatalog(item)→pantryRepository.add(item.name,item.category); PantryRepositoryImpl.kt:30-41 add：normalize(name)→pantryDao.upsert(PantryItemEntity(name=normalized, category.name, addedAt=now)); PantryDao.kt:16-17 upsert REPLACE；PantryDao.kt:13 observeAll ORDER BY addedAt DESC；PantryViewModel.kt:49 建议区过滤已存在 (normalize(name) in present)
  - resource: N/A
  - manifest: N/A
- interaction: 持久化表 "pantry_items"，主键 name=归一化名 (PantryItemEntity.kt:6-8)；分类取目录项的 category（如 Tomato→Produce、Rice→Grains & Bread、Chicken→Meat & Seafood）；addedAt=当前时间，新加者排已添加区最前
- data_flow: addCatalog (PantryViewModel.kt:67) → repository.add (PantryViewModel.kt:68) → normalize (PantryRepositoryImpl.kt:31) → pantryDao.upsert (PantryRepositoryImpl.kt:33) → observeAll (PantryDao.kt:13) → observePantry (PantryRepositoryImpl.kt:25) → uiState items (PantryViewModel.kt:55) → "In your kitchen"区 (PantryScreen.kt:99) + count (PantryViewModel.kt:33)；建议区重组过滤掉已存在 (PantryViewModel.kt:48-49)

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 食材库变化 — PantryViewModel.kt:41 — behavior: 建议区重新过滤（已添加的从建议区移除），已添加区与数量刷新
- Trigger: 进入食材库页 — PantryViewModel.kt:41 — behavior: 装配建议区供快速添加

## Core business entities (data model / persistence key / state machine)
- Entity: CatalogIngredient(name,category) — PantryCatalog.kt:12；Quick add 目录项，name 为规范名
- Entity: PantryCatalog.all — PantryCatalog.kt:19-43，内置常用食材目录，按 7 个分类组织（Produce/Meat&Seafood/Dairy&Eggs/Grains&Bread/Pantry Staples/Condiments&Oils/Spices&Herbs）
- Entity: PantryItemEntity(name,category,addedAt) — PantryItemEntity.kt:6-10，表 "pantry_items"，主键 name(归一化)
- Entity: 归一化 IngredientMatching.normalize — CookMatch.kt:43-49；添加时对 name 归一化（小写/去标点/同义词映射）
- 依赖来源: 食材库页布局与建议区位置见 `pantry-layout` (REQ-008)；分类集合见 `ingredient-categories` (REQ-013)；归一化规则见 `ingredient-normalize` (REQ-014)

## Cross-entry shared declarations
- PantryRepository.add(name,category) (PantryRepositoryImpl.kt:30): 快速添加与手动添加共用同一落库路径（手动添加经 viewModel.add，快速添加经 viewModel.addCatalog，二者最终都调 repository.add）
- pantry_items 表主键 name(归一化) + upsert REPLACE (PantryDao.kt:16-17): 保证同一食材不重复（归一化名相同即覆盖）

## Deviations from REQ_DESC
1. REQ_DESC 称"点击食材 chip 的加号，将食材加入 In your kitchen"——代码 onAdd 绑定在整 chip 可点击区（含加号与文字），点击 chip 任意位置即触发添加 (PantryScreen.kt:223 bounceClick 包裹整 chip)，与"点击加号"等价，无冲突
2. REQ_DESC 验收"被点击的食材出现在 In your kitchen，食材数量同步增加"——代码添加后 items 增加并在"In your kitchen"区显示 (PantryScreen.kt:99)、count+1 (PantryViewModel.kt:33)，一致；额外行为：该建议 chip 从建议区消失 (PantryViewModel.kt:49)，需求未述但不冲突
3. REQ_DESC 列举"Tomato、Rice、Chicken"——均在 PantryCatalog 中 (PantryCatalog.kt:21 Tomato(PRODUCE)、:32 Rice(GRAINS_BREAD)、:26 Chicken(MEAT_SEAFOOD))，分类各自归属，无冲突

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- Quick add 建议 chip 加号为全应用唯一的快速添加入口；"In your kitchen"区为添加结果的唯一展示位置 (PantryScreen.kt:97-103)
  layers: code PantryScreen.kt:120-125,216-239; resource N/A; manifest N/A
  interaction/data_flow: 同 Entry · Quick add 建议 chip 加号 + Entry · 添加落库与列表刷新

### Consumers (who reads this state / data)
- Consumer: 食材库页"In your kitchen"区与数量副标题读取 items — PantryScreen.kt:99,70
- Consumer: 首页 pantryCount/cookNow、搜索页、详情页匹配计算读取同一食材库 — HomeViewModel.kt:71（跨页同步刷新）

### Non-consumers (boundary counter-examples with evidence)
- claim: 快速添加不展示数量选择、单位、备注等附加输入，单击即整份加入
  closure_layers: [code]
  tools: [Read PantryScreen.kt:216-239, Read PantryViewModel.kt:67-69]
  zero_hits: SuggestionChip 仅 label+Add，onClick 直接触发 addCatalog 无中间弹窗/输入；addCatalog 直接 repository.add，无数量/单位参数
- claim: 已在食材库中的食材不出现在 Quick add 建议区（无法被重复快速添加）
  closure_layers: [code]
  tools: [Read PantryViewModel.kt:48-49]
  zero_hits: PantryViewModel.kt:49 `.filter{IngredientMatching.normalize(it.name) !in present}` 过滤已存在，已添加项不在建议区

## Same-source cross-reference (if applicable)
- 快速添加与手动添加 (`pantry-manual-add-SPEC.md`, REQ-010) 共用同一落库路径 PantryRepository.add 与同一 pantry_items 表；区别仅在入口（目录 chip vs 输入框）与分类来源（目录项自带分类 vs 默认 Other）。两规独立生成，在落库契约处互指
- 添加后的归一化匹配效果由 `ingredient-normalize-SPEC.md` (REQ-014) 描述；建议区分类展示由 `ingredient-categories-SPEC.md` (REQ-013) 描述
