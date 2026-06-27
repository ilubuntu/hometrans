# Trace: search-category (REQ-025)

> Search 分类筛选。追踪搜索页分类筛选条与按分类过滤逻辑。

## Status
status: ok
repo-id: whaticancook
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 分类筛选条 (LazyRow) — SearchScreen.kt:54-74 — recalled by: both
- Entry 2: 分类过滤逻辑 (build) — SearchViewModel.kt:93-95 — recalled by: path 2

## Entry · 分类筛选
- claim: 搜索页分类筛选与首页一致，含"All"+6 分类；选择某分类后结果只展示对应分类菜谱，"All"展示全部。
- layers:
  - code: SearchScreen.kt:59-65 ("All" chip, selected=selectedCategory==null) / 66-73 (categories chips) / SearchViewModel.kt:68 (onCategorySelected) / 93-95 (过滤)
  - resource: N/A
  - manifest: N/A
- interaction: 选中分类存于 SearchViewModel.category StateFlow（null=All）；无持久化。
- data_flow: chip onClick → onCategorySelected(category?) → category.value → filters → build → category!=null 时 filter{recipe.category==category} → results

## 过滤逻辑（SearchViewModel.kt:93-95）
```
if (f.category != null):
  items = items.filter { it.recipe.category == f.category }
```
- null（All）→ 不过滤。

## 分类集合（RecipeCategory.kt:4-10）
与首页一致：BREAKFAST/LUNCH/DINNER/DESSERT/SNACK/DRINK；"All" 为额外项对应 null。

## 验证点
- 选 Breakfast：Banana Oat Pancakes（category=BREAKFAST，recipes.json:89）→ 命中；Chicken Fried Rice（category=DINNER，recipes.json:116）→ 被过滤。✅

## Implicit triggers
- Trigger: 点击分类 chip — onCategorySelected — 行为: 结果按新分类过滤。
- Trigger: 食材库变化 — 行为: 分类过滤不变，卡片匹配胶囊刷新。

## Core business entities
- SearchUiState.selectedCategory: 当前分类（null=All）。
- RecipeCategory: 枚举分类。

## Cross-entry shared declarations
- None。

## Deviations from REQ_DESC
- None。REQ 要求"与首页一致，选择分类后只展示对应分类"，代码与首页共用 RecipeCategory 枚举、过滤为精确分类相等。

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries
- 搜索页分类筛选条 SearchScreen.kt:54-74
- 分类过滤 SearchViewModel.kt:93-95

### Consumers
- build: 分类过滤与文本/Cookable/排序叠加。

### Non-consumers
- claim: 分类筛选为精确相等（recipe.category == 选中枚举），非子串/模糊；分类集合固定 6 项 + All。
  closure_layers: [code]
  tools: [Read SearchViewModel.kt:93-95]
  zero_hits: 过滤条件为 == 枚举相等，无 contains/模糊逻辑。

## Same-source cross-reference
- 分类筛选与首页分类筛选（REQ-007 category-filter-SPEC.md）行为一致、共用 RecipeCategory 枚举；搜索页分类可与文本/Cookable/排序叠加。独立生成。
