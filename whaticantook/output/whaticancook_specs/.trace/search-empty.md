# Code trace · search-empty

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 搜索结果为空时空态区 — SearchScreen.kt:99-106 (EmptyState 分支) — recalled by: both
- Entry 2: 空态组件 — StateViews.kt:24-67 (EmptyState) — recalled by: path 1

## Entry · 搜索结果为空时空态区
- claim: 当结果列表为空且非加载中时，结果区展示空态：居中的图标、"No recipes found"标题与提示文案；空态不提供操作按钮
- layers:
  - code:     SearchScreen.kt:99 条件 !state.loading && state.results.isEmpty()；SearchScreen.kt:100-105 Box 居中 + EmptyState(emoji="🔍", title="No recipes found", message="Try a different ingredient or clear your filters.")；EmptyState 未传 actionLabel/onAction（StateViews.kt:29,62-65 因 actionLabel=null 不渲染按钮）；StateViews.kt:33-67 EmptyState 布局：圆形背景+emoji+标题+提示文案
  - resource: N/A: 文案为代码内字面量
  - manifest: N/A
- interaction: 读 state.loading、state.results 判定（SearchViewModel.kt:28,34）；空态本身无写操作
- data_flow: SearchViewModel.build 计算 results（SearchViewModel.kt:78-118）→ state.results 为空且 loading=false → SearchScreen.kt:99 命中 → EmptyState 渲染

## Entry · 空态组件
- claim: 空态组件居中展示：圆形背景内放大图标，下方"无结果"标题，再下为提示文案；搜索页空态不含可操作按钮
- layers:
  - code:     StateViews.kt:24-67 EmptyState(emoji,title,message,actionLabel?=null,onAction?=null)；StateViews.kt:40-47 圆形背景+emoji；StateViews.kt:49-54 标题；StateViews.kt:56-61 提示文案；StateViews.kt:62-65 仅当 actionLabel 与 onAction 均非空才渲染按钮（搜索页调用未传，故无按钮）
  - resource: N/A
  - manifest: N/A
- interaction: 纯展示
- data_flow: SearchScreen.kt:101-105 传入固定 emoji/title/message

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 任意筛选条件使结果集变为空 — SearchViewModel.kt:84-98（文本/分类/可做过滤） — behavior: results 变空 → 空态显示
- Trigger: 任意筛选条件放宽使结果集非空 — behavior: results 非空 → 空态消失，列表显示
- Trigger: 菜谱数据初始化完成 — RecipeRepositoryImpl.kt:47 — behavior: loading 由 true 转 false 后空态判定才生效（避免加载中误显空态）

## Core business entities (data model / persistence key / state machine)
- Entity: SearchUiState.loading — SearchViewModel.kt:28：加载中标志，初始 true，build 后 false（SearchViewModel.kt:111）；空态判定前置条件 !loading
- Entity: SearchUiState.results — SearchViewModel.kt:34：过滤排序后列表；为空触发空态
- 依赖来源: 菜谱数据来自 offline-recipes (REQ-003)；筛选条件来自 search-text/search-category/search-cookable

## Cross-entry shared declarations
- EmptyState 组件（StateViews.kt:24-67）为搜索页空态与收藏页空态共用；收藏页调用额外传 actionLabel="Browse recipes"+onAction（FavoritesScreen.kt:39-40），搜索页调用未传（无按钮）
- 空态判定 loading 标志与加载/错误状态（REQ-042）相关

## Deviations from REQ_DESC
1. REQ_DESC 称"页面不崩溃，显示无结果提示或空列表状态"——代码显示居中空态（图标+标题"No recipes found"+提示文案"Try a different ingredient or clear your filters."），优于"空列表"，一致
2. 搜索页空态未提供操作按钮（与收藏页空态不同），需求未要求按钮，无冲突

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 搜索页结果区空态 — SearchScreen.kt:99-106 + StateViews.kt:24-67 — 本 REQ 主体

### Consumers (who reads this state / data)
- Consumer: SearchScreen.kt:99 读取 state.loading、state.results 判定空态分支 — SearchScreen.kt:99

### Non-consumers (boundary counter-evidence)
- claim: 加载中（loading=true）时不显示空态——SearchScreen.kt:99 条件含 !loading，loading 期间走 else 分支但 results 也为空初始值；实际 loading 时 results 默认空但 !loading 为假，故空态不显示，避免误显
  closure_layers: [code]
  tools: [Read SearchScreen.kt:99]
  zero_hits: 条件 !state.loading && state.results.isEmpty()，loading=true 时不命中
- claim: 收藏页空态文案/按钮与搜索页不同——收藏页为"No saved recipes yet"+"Browse recipes"按钮，不经搜索页空态
  closure_layers: [code]
  tools: [Read FavoritesScreen.kt:35-41]
  zero_hits: FavoritesScreen.kt:35-41 调用 EmptyState 传不同 title/message/actionLabel

## Same-source cross-reference (if applicable)
- 空态触发条件之一"可做筛选无结果"见 search-cookable-SPEC.md（REQ-026）场景三
- 收藏页空态见 saved-empty-SPEC.md（REQ-032），二者共用 EmptyState 组件但文案与按钮不同
