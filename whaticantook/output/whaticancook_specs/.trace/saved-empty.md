# Code trace · saved-empty

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 收藏页空态区 — FavoritesScreen.kt:30-44 (空态分支) — recalled by: both
- Entry 2: 空态组件（含操作按钮） — StateViews.kt:24-67 (EmptyState) — recalled by: path 1
- Entry 3: "Browse recipes"浏览入口跳转 — WccApp.kt:113 (onBrowse → navigateToTab(HOME)) — recalled by: path 2

## Entry · 收藏页空态区
- claim: 当没有收藏菜谱且非加载中时，收藏页展示居中空态：书签图标、"No saved recipes yet"标题、提示文案与"Browse recipes"操作按钮
- layers:
  - code:     FavoritesScreen.kt:30 条件 !state.loading && state.items.isEmpty()；FavoritesScreen.kt:31-42 Box 居中 + EmptyState(emoji="🔖", title="No saved recipes yet", message="Tap the heart on any recipe to keep it here for later.", actionLabel="Browse recipes", onAction=onBrowse)
  - resource: N/A: 文案为代码内字面量
  - manifest: N/A
- interaction: 读 state.loading、state.items 判定（FavoritesViewModel.kt:19,20）；点击"Browse recipes" → onBrowse（FavoritesScreen.kt:40）
- data_flow: FavoritesViewModel.kt:29-38 combine(observeFavorites, observePantry) → items 为空且 loading=false → FavoritesScreen.kt:30 命中 → EmptyState 渲染

## Entry · 空态组件（含操作按钮）
- claim: 空态组件居中展示：圆形背景内书签图标、空态标题、提示文案，下方"Browse recipes"主操作按钮
- layers:
  - code:     StateViews.kt:24-67 EmptyState(emoji,title,message,actionLabel?,onAction?)；StateViews.kt:40-47 圆形背景+emoji；StateViews.kt:49-54 标题；StateViews.kt:56-61 提示文案；StateViews.kt:62-65 actionLabel 与 onAction 均非空时渲染 WccPrimaryButton（收藏页调用传 actionLabel="Browse recipes"+onAction，故有按钮）
  - resource: N/A
  - manifest: N/A
- interaction: 点击按钮 → onAction → onBrowse
- data_flow: FavoritesScreen.kt:39-40 传入 actionLabel/onAction

## Entry · "Browse recipes"浏览入口跳转
- claim: 空态"Browse recipes"按钮点击后跳转到首页（Discover），便于用户去浏览菜谱并收藏
- layers:
  - code:     FavoritesScreen.kt:40 onAction=onBrowse；FavoritesScreen 的 onBrowse 由 WccApp.kt:113 传入 onBrowse={navController.navigateToTab(Routes.HOME)}；WccApp.kt:136-141 navigateToTab 跳转 HOME 并保留状态
  - resource: N/A
  - manifest: N/A
- interaction: 跳转到首页 tab（Destinations.kt:31 DISCOVER=HOME）
- data_flow: 点击按钮 → onBrowse（FavoritesScreen.kt:40）→ WccApp.kt:113 navigateToTab(HOME) → 首页

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 收藏集合变为空（取消最后一项收藏） — FavoritesViewModel.kt:30 (observeFavorites) — behavior: items 变空 → 空态显示
- Trigger: 收藏集合由空变非空（新增收藏） — behavior: items 非空 → 空态消失，列表显示
- Trigger: 菜谱数据初始化完成 — RecipeRepositoryImpl.kt:47 — behavior: loading 由 true 转 false 后空态判定才生效（避免加载中误显空态）

## Core business entities (data model / persistence key / state machine)
- Entity: FavoritesUiState.loading — FavoritesViewModel.kt:19：加载中标志，初始 true，combine 后 false（FavoritesViewModel.kt:35）
- Entity: FavoritesUiState.items — FavoritesViewModel.kt:20：收藏列表；为空触发空态
- Entity: onBrowse 回调 — FavoritesScreen.kt:25,40：空态浏览入口，跳转首页
- 依赖来源: 收藏数据来自 favorite-recipe（REQ-031）

## Cross-entry shared declarations
- EmptyState 组件（StateViews.kt:24-67）为收藏页空态与搜索页空态共用；收藏页调用传 actionLabel+onAction（有按钮），搜索页调用未传（无按钮）
- onBrowse 跳转目标 HOME 与底部导航 DISCOVER tab 同路由（Destinations.kt:31）

## Deviations from REQ_DESC
1. REQ_DESC 称"展示 No saved recipes，并提供 Browse recipes 或类似入口"——代码 title="No saved recipes yet"、actionLabel="Browse recipes"，文案略有出入但语义一致（"yet"为代码措辞）
2. "Browse recipes"跳转目标为首页（Discover），与需求"浏览入口"一致

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 收藏页空态区（图标+标题+提示+按钮） — FavoritesScreen.kt:30-44 + StateViews.kt:24-67 — 本 REQ 主体
- "Browse recipes"按钮跳转首页 — WccApp.kt:113 — 空态浏览入口
- 收藏页进入入口（底部导航"Saved"tab） — TopLevelTab.FAVORITES (Destinations.kt:34) → WccApp.kt:110-115 — 到达空态的前置导航

### Consumers (who reads this state / data)
- Consumer: FavoritesScreen.kt:30 读取 state.loading、state.items 判定空态分支 — FavoritesScreen.kt:30

### Non-consumers (boundary counter-evidence)
- claim: 加载中（loading=true）时不显示空态——条件含 !loading，避免误显
  closure_layers: [code]
  tools: [Read FavoritesScreen.kt:30]
  zero_hits: 条件 !state.loading && state.items.isEmpty()，loading=true 时不命中
- claim: 搜索页空态无"Browse recipes"按钮——搜索页 EmptyState 调用未传 actionLabel/onAction
  closure_layers: [code]
  tools: [Read SearchScreen.kt:101-105]
  zero_hits: SearchScreen.kt:101-105 调用 EmptyState 无 actionLabel/onAction 参数

## Same-source cross-reference (if applicable)
- 空态触发条件"收藏集合为空"与取消收藏（unfavorite/REQ-034）相关；收藏列表非空展示见 saved-list-SPEC.md（REQ-033）
- 搜索页空态见 search-empty-SPEC.md（REQ-030），二者共用 EmptyState 组件但文案与按钮不同
