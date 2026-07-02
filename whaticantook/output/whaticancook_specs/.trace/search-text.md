# Code trace · search-text

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 搜索输入框输入触发过滤 — SearchScreen.kt:49-52 (WccSearchField onValueChange) + SearchViewModel.kt:67 (onQueryChange) — recalled by: both
- Entry 2: 清除按钮清空输入 — Inputs.kt:72-88 (清除按钮) + Inputs.kt:35 (onClear=onValueChange("")) — recalled by: path 2

## Entry · 搜索输入框输入触发过滤
- claim: 用户在搜索输入框输入文本，结果列表即时按文本过滤；匹配范围覆盖菜谱标题、分类标签文案、菜谱标签与食材名称
- layers:
  - code:     SearchScreen.kt:49-52 WccSearchField(value=state.query, onValueChange=viewModel::onQueryChange)；SearchViewModel.kt:67 onQueryChange 写入 query 流；SearchViewModel.kt:80 q=f.query.trim().lowercase()；SearchViewModel.kt:84-92 当 q 非空时过滤：r.title.lowercase().contains(q) || r.category.label.lowercase().contains(q) || r.tags.any{it.lowercase().contains(q)} || r.ingredients.any{it.name.lowercase().contains(q)}
  - resource: N/A
  - manifest: N/A
- interaction: 读 state.query 渲染输入框；写 query 流（SearchViewModel.kt:67,50）；过滤结果写入 state.results（SearchViewModel.kt:116）
- data_flow: 用户输入 → onQueryChange（SearchViewModel.kt:67）→ query 流 → combine（SearchViewModel.kt:55-65）→ build（SearchViewModel.kt:78-118）→ 过滤（84-92）→ SearchUiState.results → SearchScreen.kt:113 列表刷新

## Entry · 清除按钮清空输入
- claim: 当输入框有文本时，右侧出现清除按钮；点击清除按钮立即清空输入，结果列表恢复为无文本过滤的全部结果
- layers:
  - code:     Inputs.kt:72-88 value 非空时显示清除按钮（圆形、关闭图标）；Inputs.kt:35 onClear 默认 onValueChange("")；SearchViewModel.kt:80 q="" → SearchViewModel.kt:84 if(q.isNotEmpty()) 为假 → 跳过文本过滤，保留全部菜谱
  - resource: N/A
  - manifest: N/A
- interaction: 写 query 流为空串（经 onQueryChange）；空 query 不应用文本过滤（SearchViewModel.kt:84）
- data_flow: 点击清除 → onClear → onValueChange("")（Inputs.kt:35）→ onQueryChange（SearchViewModel.kt:67）→ query="" → build 跳过文本过滤 → results 恢复全部

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 食材库增删 — SearchViewModel.kt:61 (observePantry) — behavior: 文本过滤本身不变，但过滤后结果的匹配计数/排序随之刷新
- Trigger: 菜谱数据初始化完成 — RecipeRepositoryImpl.kt:47 — behavior: 首次加载后文本过滤才可在非空菜谱集合上生效

## Core business entities (data model / persistence key / state machine)
- Entity: SearchUiState.query — SearchViewModel.kt:29：搜索词原始文本（含首尾空白与大小写）
- Entity: 过滤用 q — SearchViewModel.kt:80：query.trim().lowercase()，即去首尾空白并转小写后用于匹配
- Entity: 匹配字段集 — SearchViewModel.kt:87-90：title / category.label / tags / ingredients.name，四者任一包含 q 即命中
- Entity: Recipe.title / Recipe.category / Recipe.tags / Recipe.ingredients — Recipe.kt:22-31
- 依赖来源: 菜谱数据来自 offline-recipes (REQ-003)

## Cross-entry shared declarations
- 文本过滤与分类过滤、可做过滤、排序在同一 build() 内串行叠加（SearchViewModel.kt:84-108），共同决定 results

## Deviations from REQ_DESC
1. REQ_DESC 称"输入菜谱名或食材关键词后即时过滤"——实际匹配范围更广：除菜谱标题与食材名称外，还匹配分类标签文案（category.label，如"Breakfast"）与菜谱标签（tags，如"High protein"）（SearchViewModel.kt:88-89）。需求为概括描述，行为是需求的超集
2. REQ_DESC 验收"rice 能找到 Chicken Fried Rice"——title.contains("rice") 命中（"Chicken Fried Rice".lowercase() 含 "rice"）；"yogurt 能找到包含 Yogurt 的相关菜谱"——ingredients.name.contains("yogurt") 命中，与验收一致

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 搜索输入框输入 — SearchScreen.kt:49-52 + SearchViewModel.kt:67 — 本 REQ 主体
- 输入框清除按钮 — Inputs.kt:72-88 — 清空搜索词的同族入口
- 搜索结果列表刷新 — SearchScreen.kt:108-122 — 文本过滤结果展示

### Consumers (who reads this state / data)
- Consumer: SearchScreen 结果列表读取 state.results 渲染 — SearchScreen.kt:113
- Consumer: 输入框读取 state.query 渲染当前文本 — SearchScreen.kt:50

### Non-consumers (boundary counter-examples with evidence)
- claim: 文本搜索仅作用于搜索页，不影响首页菜谱列表——首页列表不经 query 过滤
  closure_layers: [code]
  tools: [homegraph_explore "HomeViewModel buildContent"]
  zero_hits: HomeViewModel 无 query/search 文本过滤逻辑；首页菜谱列表仅按 selectedCategory 过滤（见 category-filter-SPEC.md）
- claim: 收藏页不经文本搜索过滤——收藏页仅展示全部收藏
  closure_layers: [code]
  tools: [Read FavoritesScreen.kt, FavoritesViewModel.kt]
  zero_hits: FavoritesViewModel.kt 无 query 字段/过滤逻辑，items 直接来自 observeFavorites

## Same-source cross-reference (if applicable)
- 文本过滤与分类筛选叠加生效的语义见 search-category-SPEC.md（REQ-025）；空文本时的全列表展示与空结果态见 search-empty-SPEC.md（REQ-030）
- 搜索页整体布局见 search-layout-SPEC.md（REQ-023）
