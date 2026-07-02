# Code trace · saved-list

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 收藏页列表区 — FavoritesScreen.kt:46-69 (LazyColumn 列表) — recalled by: both
- Entry 2: 收藏页标题区 — FavoritesScreen.kt:53-58 (ScreenTitle) — recalled by: path 1
- Entry 3: 点击卡片进入详情 — FavoritesScreen.kt:64 (onClick=onRecipeClick) + WccApp.kt:112 — recalled by: both

## Entry · 收藏页列表区
- claim: 当有收藏菜谱时，收藏页以可滚动菜谱卡片列表展示全部收藏；每张卡片与首页/搜索卡片同源，含分类、标题、描述、时间、难度、热量、匹配计数与心形按钮
- layers:
  - code:     FavoritesScreen.kt:46-69 LazyColumn；FavoritesScreen.kt:60-68 items(state.items, key=recipe.id)，每项 RecipeCard(recipe, match, onClick, onToggleFavorite)；卡片复用 RecipeCard.kt:32-100（含状态胶囊、心形按钮、元信息）；空列表走空态分支（见 saved-empty）
  - resource: N/A
  - manifest: N/A
- interaction: 读 state.items 渲染列表（FavoritesViewModel.kt:20）；点击卡片 → onRecipeClick；点击心形 → toggleFavorite
- data_flow: FavoritesViewModel.kt:29-38 combine(observeFavorites, observePantry) → favorites.map{RecipeWithMatch(it, matchAgainst)} → items → FavoritesScreen.kt:60 列表

## Entry · 收藏页标题区
- claim: 列表顶部展示标题"Saved"与副标题，副标题按收藏数量显示"N recipe/recipes in your cookbook"
- layers:
  - code:     FavoritesScreen.kt:53-58 ScreenTitle(title="Saved", subtitle = items.isEmpty()?null:"${items.size} recipe${if(items.size==1)""else"s"} in your cookbook")；单数"recipe"复数"recipes"
  - resource: N/A: 文案为代码内字面量
  - manifest: N/A
- interaction: 读 state.items.size 拼副标题
- data_flow: FavoritesViewModel items.size → ScreenTitle subtitle

## Entry · 点击卡片进入详情
- claim: 用户点击收藏列表中某菜谱卡片，跳转到该菜谱的详情页
- layers:
  - code:     FavoritesScreen.kt:64 onClick={onRecipeClick(item.recipe.id)}；FavoritesScreen 的 onRecipeClick 由 WccApp.kt:112 传入 onRecipeClick={navController.navigate(Routes.recipeDetail(it))}；WccApp.kt:121-131 详情路由
  - resource: N/A
  - manifest: N/A
- interaction: 跳转到详情页（Routes.recipeDetail(id)）
- data_flow: 点击卡片 → onRecipeClick(id)（FavoritesScreen.kt:64）→ WccApp.kt:112 navigate(recipeDetail(id)) → 详情页

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 收藏集合变化 — FavoritesViewModel.kt:30 (observeFavorites) — behavior: 新增收藏→列表增加该项；取消收藏→该项从列表移除
- Trigger: 食材库增删 — FavoritesViewModel.kt:31 (observePantry) — behavior: 列表成员不变，但各卡片匹配计数/可做状态刷新
- Trigger: 菜谱数据初始化完成 — RecipeRepositoryImpl.kt:47 — behavior: 首次加载后列表才有内容

## Core business entities (data model / persistence key / state machine)
- Entity: FavoritesUiState.items — FavoritesViewModel.kt:20：收藏列表（List<RecipeWithMatch>）
- Entity: RecipeWithMatch(recipe, match) — RecipeWithMatch.kt:4-7：菜谱+匹配结果，列表项数据模型
- Entity: observeFavorites — RecipeRepository.kt:14 / RecipeRepositoryImpl.kt:58-63：返回按收藏时间倒序的收藏菜谱（顺序见 favorite-order）
- 依赖来源: 收藏数据来自 favorite-recipe（REQ-031）；菜谱数据来自 offline-recipes（REQ-003）；匹配计数来自 pantry 系列（REQ-015）

## Cross-entry shared declarations
- 收藏列表与首页/搜索列表复用同一 RecipeCard 组件（RecipeCard.kt:32-100），卡片内容同源
- observeFavorites 为收藏列表与收藏顺序共用数据源（RecipeRepositoryImpl.kt:58-63）

## Deviations from REQ_DESC
1. REQ_DESC 称"展示所有收藏菜谱，并支持点击进入详情"——代码 LazyColumn 展示 items 全部，点击卡片 navigate 详情，一致
2. REQ_DESC 验收"Saved 列表显示该菜谱，点击进入对应详情页"——一致
3. 副标题"N recipe/recipes in your cookbook"与卡片匹配计数为代码增强，需求未要求但与"展示收藏菜谱"一致

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 收藏页列表区（卡片列表） — FavoritesScreen.kt:46-69 — 本 REQ 主体
- 收藏页标题区（"Saved"+数量副标题） — FavoritesScreen.kt:53-58 — 列表附属
- 点击卡片进入详情 — FavoritesScreen.kt:64 + WccApp.kt:112 — 列表项点击行为
- 收藏页进入入口（底部导航"Saved"tab） — TopLevelTab.FAVORITES (Destinations.kt:34) — 到达列表的前置导航

### Consumers (who reads this state / data)
- Consumer: FavoritesScreen LazyColumn 读取 state.items 渲染 — FavoritesScreen.kt:60
- Consumer: ScreenTitle 读取 items.size 拼副标题 — FavoritesScreen.kt:56

### Non-consumers (boundary counter-evidence)
- claim: 收藏列表仅展示已收藏菜谱——未收藏菜谱不出现（observeFavorites 只返回收藏集合）
  closure_layers: [code]
  tools: [Read RecipeRepositoryImpl.kt:58-63]
  zero_hits: observeFavorites 由 favoriteDao.observeIdsOrdered 过滤，仅收藏菜谱经 mapNotNull 进入列表
- claim: 收藏列表不经文本/分类/排序过滤——收藏页无搜索框/分类条/排序条
  closure_layers: [code]
  tools: [Read FavoritesScreen.kt]
  zero_hits: FavoritesScreen.kt 全文无 query/category/sort 过滤逻辑，items 直接来自 observeFavorites

## Same-source cross-reference (if applicable)
- 收藏列表顺序（最近收藏优先）见 favorite-order-SPEC.md（REQ-035）；收藏页空态（列表为空时）见 saved-empty-SPEC.md（REQ-032）；取消收藏见 unfavorite-SPEC.md（REQ-034）
- 收藏列表卡片复用 RecipeCard，卡片内容规约见 recipe-card-SPEC.md（REQ-006）
