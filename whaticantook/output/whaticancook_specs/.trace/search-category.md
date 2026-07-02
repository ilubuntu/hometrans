# Code trace · search-category

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 分类筛选条选择分类 — SearchScreen.kt:66-73 (分类 chip onClick) + SearchViewModel.kt:68 (onCategorySelected) — recalled by: both
- Entry 2: "All"项恢复全部 — SearchScreen.kt:59-65 ("All" chip onClick onCategorySelected(null)) — recalled by: both

## Entry · 分类筛选条选择分类
- claim: 用户选择某一具体分类，结果列表即时过滤为该分类菜谱；分类筛选与搜索词同时生效
- layers:
  - code:     SearchScreen.kt:66-73 分类 chip selected=(selectedCategory==category) onClick=onCategorySelected(category)；SearchViewModel.kt:68 onCategorySelected 写入 category 流；SearchViewModel.kt:93-95 当 f.category!=null 时过滤 it.recipe.category==f.category；分类过滤在文本过滤之后串行（SearchViewModel.kt:84-95）
  - resource: N/A
  - manifest: N/A
- interaction: 读 state.selectedCategory 渲染选中态；写 category 流（SearchViewModel.kt:51,68）；过滤结果写入 state.results（SearchViewModel.kt:116）
- data_flow: 点击分类 → onCategorySelected（SearchViewModel.kt:68）→ category 流 → combine → build（SearchViewModel.kt:78）→ 文本过滤（84-92）→ 分类过滤（93-95）→ results → SearchScreen.kt:113 列表刷新

## Entry · "All"项恢复全部
- claim: 用户选择"All"，取消分类过滤，结果列表恢复为全部菜谱（仍受搜索词等其他条件影响）
- layers:
  - code:     SearchScreen.kt:59-65 "All" chip selected=(selectedCategory==null) onClick=onCategorySelected(null)；SearchViewModel.kt:68 写 category=null；SearchViewModel.kt:93 if(f.category!=null) 为假 → 跳过分类过滤
  - resource: N/A
  - manifest: N/A
- interaction: 写 category 流为 null；null 时跳过分类过滤（SearchViewModel.kt:93）
- data_flow: 点击"All" → onCategorySelected(null) → category=null → build 跳过分类过滤 → results 恢复

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 食材库增删 — SearchViewModel.kt:61 — behavior: 分类过滤结果不变，但结果内匹配计数/排序刷新
- Trigger: 菜谱数据初始化完成 — RecipeRepositoryImpl.kt:47 — behavior: 首次加载后分类过滤才可在非空菜谱集合上生效

## Core business entities (data model / persistence key / state machine)
- Entity: SearchUiState.selectedCategory — SearchViewModel.kt:30：当前分类，RecipeCategory? 类型，null 表示"All"
- Entity: RecipeCategory 枚举 — RecipeCategory.kt:4-10：Breakfast/Lunch/Dinner/Dessert/Snack/Drink
- Entity: Recipe.category — Recipe.kt:23：菜谱归属分类，与 selectedCategory 比较判等（SearchViewModel.kt:94）
- 依赖来源: 菜谱数据来自 offline-recipes (REQ-003)

## Cross-entry shared declarations
- 分类过滤与文本过滤、可做过滤、排序在同一 build() 内串行叠加（SearchViewModel.kt:84-108）

## Deviations from REQ_DESC
1. REQ_DESC 称"分类筛选与搜索词共同生效"——代码确实串行叠加：先文本过滤（84-92）再分类过滤（93-95），两者 AND 关系，与需求一致
2. REQ_DESC 验收"点击 Breakfast 再输入 banana，只展示早餐分类中匹配 banana 的菜谱"——Breakfast 分类过滤 + "banana"文本过滤叠加，banana 经 IngredientMatching 归一化匹配 Banana/bananas，与验收一致

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 搜索页分类筛选条（"All"+ 各分类项） — SearchScreen.kt:55-74 + SearchViewModel.kt:68 — 本 REQ 主体
- 搜索结果列表刷新 — SearchScreen.kt:108-122 — 分类过滤结果展示

### Consumers (who reads this state / data)
- Consumer: SearchScreen 分类条读取 state.selectedCategory/categories 渲染选中态 — SearchScreen.kt:62,70
- Consumer: SearchViewModel.build 读取 f.category 执行过滤 — SearchViewModel.kt:93

### Non-consumers (boundary counter-evidence)
- claim: 搜索页分类筛选与首页分类筛选相互独立——不共享 selectedCategory
  closure_layers: [code]
  tools: [homegraph_explore "HomeViewModel selectCategory"]
  zero_hits: HomeViewModel 持有独立的 selectedCategory，未引用 SearchViewModel；首页分类筛选见 category-filter-SPEC.md
- claim: 分类筛选不影响"可做"开关与排序项——三者各自独立 state（query/category/cookableOnly/sort）
  closure_layers: [code]
  tools: [Read SearchViewModel.kt:50-53]
  zero_hits: category、cookableOnly、sort 为三个独立 MutableStateFlow，互不读写

## Same-source cross-reference (if applicable)
- 搜索页布局（分类条位置）见 search-layout-SPEC.md（REQ-023）；文本搜索叠加见 search-text-SPEC.md（REQ-024）
- 首页分类筛选为独立实现，见 category-filter-SPEC.md（REQ-007）
