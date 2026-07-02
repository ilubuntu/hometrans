# Code trace · search-layout

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 搜索页页面壳体（标题） — SearchScreen.kt:42-47 (Text "Search") — recalled by: both
- Entry 2: 搜索输入框 — SearchScreen.kt:49-52 (WccSearchField) + Inputs.kt:29-89 — recalled by: both
- Entry 3: 分类筛选条 — SearchScreen.kt:55-74 (LazyRow, "All" + RecipeCategory.entries) — recalled by: both
- Entry 4: 可做筛选 + 排序条 — SearchScreen.kt:77-97 (Cookable chip + SortOption.entries) — recalled by: both
- Entry 5: 搜索结果列表/空态区 — SearchScreen.kt:99-123 (EmptyState 或 LazyColumn) — recalled by: path 1

## Entry · 搜索页标题
- claim: 搜索页顶部展示大标题"Search"
- layers:
  - code:     SearchScreen.kt:42-47 Text(text="Search", displaySmall)
  - resource: N/A: 文案为代码内字面量，无资源引用
  - manifest: N/A
- interaction: 纯展示，无状态读写
- data_flow: 无（静态标题）

## Entry · 搜索输入框
- claim: 标题下方为搜索输入框；未输入时显示占位文案"Search recipes…"；输入框支持单行输入，键盘动作键为"搜索"；输入非空时右侧出现清除按钮，点击清空当前输入
- layers:
  - code:     SearchScreen.kt:49-52 调用 WccSearchField(value=state.query, onValueChange=viewModel::onQueryChange)；Inputs.kt:29-89 WccSearchField 实现；Inputs.kt:34 placeholder="Search recipes…"；Inputs.kt:56 singleLine=true；Inputs.kt:61 imeAction=ImeAction.Search；Inputs.kt:64-70 占位文案在 value 为空时显示；Inputs.kt:72-88 value 非空时显示清除按钮，Inputs.kt:35 onClear 默认 onValueChange("")
  - resource: N/A: 占位文案为代码内字面量
  - manifest: N/A
- interaction: 读 state.query（SearchViewModel.kt:29）；写：onQueryChange → query MutableStateFlow（SearchViewModel.kt:67）；清除按钮写空串
- data_flow: SearchScreen.kt:34 collect uiState → state.query 渲染 → 用户输入 → onQueryChange（SearchViewModel.kt:67）写入 query 流

## Entry · 分类筛选条
- claim: 输入框下方为横排可滚动的分类筛选条，依次包含"All"项与各菜谱分类项（Breakfast、Lunch、Dinner、Dessert、Snack、Drinks，每项前带分类图标）；任意时刻最多一项选中，选中项高亮（背景高亮、文字反色、去边框）
- layers:
  - code:     SearchScreen.kt:55-74 LazyRow；SearchScreen.kt:59-65 "All"项 selected = (selectedCategory==null)，onClick onCategorySelected(null)；SearchScreen.kt:66-73 items(state.categories=RecipeCategory.entries)，每项 label=category.label、leadingEmoji=category.emoji、selected=(selectedCategory==category)、onClick onCategorySelected(category)；RecipeCategory.kt:4-10 枚举 Breakfast/Lunch/Dinner/Dessert/Snack/Drink 及其 label/emoji；选中态样式见 Chips.kt:31-50
  - resource: N/A
  - manifest: N/A
- interaction: 读 state.selectedCategory、state.categories（SearchViewModel.kt:30,33）；写：onCategorySelected → category 流（SearchViewModel.kt:68）
- data_flow: SearchScreen.kt:34 collect → state.categories/selectedCategory 渲染 → 点击 → onCategorySelected（SearchViewModel.kt:68）写入 category 流

## Entry · 可做筛选 + 排序条
- claim: 分类条下方为一行控件：左侧为"可做(Cookable)"切换项（带勾选图标），其后为横排可滚动的排序项，依次为"Best match""Quickest""Fewest missing"；"Cookable"为开关（点击在选中/未选中间切换），排序项为单选（任意时刻最多一项选中高亮）
- layers:
  - code:     SearchScreen.kt:77-97 Row；SearchScreen.kt:82-87 Cookable chip label="Cookable" leadingEmoji="✅" selected=state.cookableOnly onClick=onCookableToggle；SearchScreen.kt:88-95 LazyRow items(SortOption.entries)，每项 label=option.label selected=(sort==option) onClick=onSortSelected(option)；SearchViewModel.kt:21-25 SortOption 枚举 RELEVANCE→"Best match"、QUICKEST→"Quickest"、FEWEST_MISSING→"Fewest missing"；选中态样式见 Chips.kt:31-50
  - resource: N/A
  - manifest: N/A
- interaction: 读 state.cookableOnly、state.sort（SearchViewModel.kt:31,32）；写：onCookableToggle 取反 cookableOnly（SearchViewModel.kt:69）；onSortSelected 写 sort 流（SearchViewModel.kt:70）
- data_flow: SearchScreen.kt:34 collect → state.cookableOnly/sort 渲染 → 点击 → onCookableToggle/onSortSelected（SearchViewModel.kt:69-70）

## Entry · 搜索结果列表/空态区
- claim: 筛选控件下方为结果区：有结果时为可滚动菜谱卡片列表，每张卡片可点击进入详情、可点击心形收藏按钮；无结果且非加载中时为空态区（详见 search-empty）
- layers:
  - code:     SearchScreen.kt:99-123；SearchScreen.kt:99-106 空态分支；SearchScreen.kt:108-122 LazyColumn 结果分支，items(state.results, key=recipe.id)，每项 RecipeCard(onClick=onRecipeClick, onToggleFavorite=viewModel::toggleFavorite)
  - resource: N/A
  - manifest: N/A
- interaction: 读 state.loading、state.results（SearchViewModel.kt:28,34）；点击卡片 → onRecipeClick(id)（WccApp.kt:102 跳转详情）；点击心形 → toggleFavorite（SearchViewModel.kt:72-76）
- data_flow: state.results 由 SearchViewModel.build 计算（SearchViewModel.kt:78-118）

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 食材库增删 — SearchViewModel.kt:61 (observePantry) — behavior: 重新构建结果列表（匹配计数与可做/排序随之刷新），但布局控件本身（标题/输入框/筛选条/排序条）始终常驻
- Trigger: 菜谱数据初始化完成 — RecipeRepositoryImpl.kt:47 (observeRecipes) — behavior: 首次加载完成后 loading 由 true 转 false，结果列表从空填充为菜谱
- Trigger: 收藏集合变化 — RecipeRepositoryImpl.kt:48 (observeFavorites 经 observeRecipes 注入 isFavorite) — behavior: 卡片心形状态刷新，不影响布局控件

## Core business entities (data model / persistence key / state machine)
- Entity: SearchUiState(loading, query, selectedCategory, cookableOnly, sort, categories, results) — SearchViewModel.kt:27-35
  - loading: 初始 true，build 后 false（SearchViewModel.kt:28,111）
  - query: 搜索词，默认""（SearchViewModel.kt:29,50）
  - selectedCategory: 当前分类，默认 null（=All）（SearchViewModel.kt:30,51）
  - cookableOnly: 可做筛选开关，默认 false（SearchViewModel.kt:31,52）
  - sort: 排序项，默认 RELEVANCE（SearchViewModel.kt:32,53）
  - categories: RecipeCategory.entries 固定集（SearchViewModel.kt:33）
  - results: 过滤排序后列表（SearchViewModel.kt:34）
- Entity: RecipeCategory 枚举 — RecipeCategory.kt:4-10：Breakfast🍳/Lunch🥗/Dinner🍝/Dessert🍰/Snack🥨/Drink🥤(label="Drinks")
- Entity: SortOption 枚举 — SearchViewModel.kt:21-25：RELEVANCE/QUICKEST/FEWEST_MISSING 及其 label
- 依赖来源: 菜谱数据来自 offline-recipes (REQ-003)；食材库来自 pantry 系列 (REQ-008+)

## Cross-entry shared declarations
- WccChip 选中态样式（Chips.kt:31-50）为分类条、"All"项、Cookable 项、排序项共用
- SearchScreen.kt:34 单一 uiState 收集驱动全页布局

## Deviations from REQ_DESC
1. REQ_DESC 验收列出分类"All、Breakfast、Lunch、Dinner"——实际分类项另含 Dessert、Snack、Drinks（RecipeCategory.kt:5-10），共 6 个具体分类 + All（REQ 用列举未穷尽，无冲突，补全）
2. REQ_DESC 称搜索框，验收写"Search recipes..."——实际占位文案为"Search recipes…"（Inputs.kt:34），语义一致

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 搜索页全部布局控件（标题/输入框/分类条/可做+排序条/结果区） — SearchScreen.kt:29-124 — 本 REQ 主体
- 底部导航"Search"入口 — TopLevelTab.SEARCH (Destinations.kt:32) → WccApp.kt:100-104 — 进入搜索页的唯一导航入口
- 首页搜索入口条（"Search recipes, ingredients…"按钮） — HomeScreen.kt:96 (SearchBarButton) → onOpenSearch → WccApp.kt:94 跳转到 Search — 跳转到本搜索页

### Consumers (who reads this state / data)
- Consumer: SearchScreen 各控件读取 SearchUiState 各字段渲染 — SearchScreen.kt:34,49-123
- Consumer: 结果列表 RecipeCard 读取 recipe/match — SearchScreen.kt:115-116

### Non-consumers (boundary counter-examples with evidence)
- claim: 首页分类筛选与搜索页分类筛选相互独立——首页有自己的 selectedCategory（HomeViewModel），不读取搜索页 SearchUiState
  closure_layers: [code]
  tools: [homegraph_explore "HomeViewModel selectCategory"]
  zero_hits: HomeViewModel.kt 选分类逻辑独立，未引用 SearchViewModel/SearchUiState；首页分类筛选见 category-filter-SPEC.md
- claim: 收藏页无搜索框/分类条/排序条——FavoritesScreen 仅展示收藏列表
  closure_layers: [code]
  tools: [Read FavoritesScreen.kt:1-69]
  zero_hits: FavoritesScreen.kt 全文无 WccSearchField/分类 LazyRow/SortOption 引用

## Same-source cross-reference (if applicable)
- 分类筛选的交互语义见 search-category-SPEC.md（REQ-025）；排序项运行语义分别见 sort-best-match/ sort-quickest/ sort-fewest-missing-SPEC.md；文本搜索见 search-text-SPEC.md（REQ-024）；可做筛选见 search-cookable-SPEC.md（REQ-026）；空态见 search-empty-SPEC.md（REQ-030）
- 首页分类筛选为独立实现（见 category-filter-SPEC.md），二者各自独立不共享状态
