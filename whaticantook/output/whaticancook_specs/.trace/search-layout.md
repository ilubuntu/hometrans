# Trace: search-layout (REQ-023)

> Search 页面基础布局。追踪搜索页整体结构：标题、搜索框、分类筛选、Cookable 开关、排序选项、结果列表，及默认选中态。

## Status
status: ok
repo-id: whaticancook
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 搜索页 (SearchScreen) — SearchScreen.kt:29-124 — recalled by: both
- Entry 2: 底部导航 Search 高亮 — WccBottomBar（导航容器，见 REQ-040）— recalled by: path 1

## Entry · 搜索页整体布局
- claim: 搜索页自上而下展示标题"Search"、搜索输入框、分类筛选（All + 6 分类）、Cookable 开关 + 排序选项（Best match/Quickest/Fewest missing）、结果列表；默认分类 All、排序 Best match 选中。
- layers:
  - code: SearchScreen.kt:42-47 (标题) / 49-52 (WccSearchField) / 54-74 (分类筛选 LazyRow) / 76-97 (Cookable + 排序 Row) / 99-123 (结果列表/空态)
  - resource: N/A: 纯 Compose
  - manifest: N/A: 普通页面，导航在 WccBottomBar（见 REQ-040）
- interaction: 控件状态存于 SearchViewModel 的 StateFlow（query/category/cookableOnly/sort），无单独持久化。
- data_flow: observeRecipes+observePantry+filters → build → SearchUiState → SearchScreen 渲染各控件选中态与结果

## 默认选中态（SearchViewModel.kt:27-35, 50-53）
- selectedCategory = null → "All" 选中（SearchScreen.kt:62 selected = state.selectedCategory == null）
- cookableOnly = false
- sort = SortOption.RELEVANCE → "Best match" 选中（label 见 SearchViewModel.kt:21-25）
- categories = RecipeCategory.entries（6 项）

## 分类集合（RecipeCategory.kt:4-10）
BREAKFAST/LUNCH/DINNER/DESSERT/SNACK/DRINK（label "Drinks"），与首页一致。加 "All" 共 7 个筛选项。

## 排序选项（SearchViewModel.kt:21-25 SortOption）
- RELEVANCE("Best match") / QUICKEST("Quickest") / FEWEST_MISSING("Fewest missing")
- 三者均为单选 chip，默认 RELEVANCE 选中。

## 结果列表（SearchScreen.kt:107-123）
LazyColumn 渲染 RecipeCard（复用首页卡片组件，含匹配胶囊与收藏）；无结果时显示空态（见 REQ-030）。

## Implicit triggers
- Trigger: 进入搜索页 — 行为: 首屏按默认筛选（All + Best match）渲染全部菜谱。
- Trigger: 食材库变更 — observePantry — 行为: 卡片匹配胶囊刷新（排序可能变化）。

## Core business entities
- SearchUiState: SearchViewModel.kt:27-35 — query/selectedCategory/cookableOnly/sort/categories/results/loading。
- SortOption: 排序枚举。
- 依赖 match-count（REQ-015）。

## Cross-entry shared declarations
- None。

## Deviations from REQ_DESC
- None。REQ 列举的布局元素与默认选中态与代码一致。

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries
- 搜索页 SearchScreen.kt:29-124 — 唯一搜索界面

### Consumers
- SearchViewModel.build: 聚合筛选与排序产出结果。

### Non-consumers
- claim: 搜索页结果卡片复用首页 RecipeCard 组件，无独立卡片实现。
  closure_layers: [code]
  tools: [Read SearchScreen.kt:114]
  zero_hits: RecipeCard 来自 core.designsystem.component，搜索页无自定义卡片。

## Same-source cross-reference
- 搜索页交互（文本/分类/Cookable/排序）分别见 search-text/search-category/search-cookable/search-best-match/search-quickest/search-fewest-missing 规格。本规格聚焦布局与默认态。独立生成。
