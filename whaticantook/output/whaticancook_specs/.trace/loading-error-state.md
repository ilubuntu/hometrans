# Code trace · loading-error-state

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 应用启动时启动屏占位（避免白屏） — app/src/main/java/com/whaticancook/app/MainActivity.kt:24-25 — recalled by: path 1 (explore "isReady splash")
- Entry 2: 首页加载骨架屏与错误重试 — app/src/main/java/com/whaticancook/app/feature/home/HomeScreen.kt:57-74 — recalled by: path 1 (explore "HomeUiState Loading Error")
- Entry 3: 菜谱详情页加载占位与"找不到菜谱"空态 — app/src/main/java/com/whaticancook/app/feature/detail/RecipeDetailScreen.kt:71-83 — recalled by: path 1 (explore "DetailUiState Loading NotFound")
- Entry 4: 搜索页 / 收藏页 / 食材库页 加载态与空结果态 — recalled by: path 1 (explore "SearchUiState FavoritesUiState PantryUiState loading")

## Entry · 应用启动启动屏占位
- claim: 应用启动时，在首屏数据就绪前展示系统启动屏占位，避免长时间白屏；就绪后才进入主界面。
- layers:
  - code:     app/src/main/java/com/whaticancook/app/MainActivity.kt:24-25 (installSplashScreen + setKeepOnScreenCondition { !appViewModel.uiState.value.isReady })；isReady 在 AppViewModel.combine 完成首次发射后置 true (AppViewModel.kt:25-31)
  - resource: N/A: 启动屏为系统启动屏组件，配置于主题（非本 REQ 核心数据流）
  - manifest: N/A: 启动屏经代码 installSplashScreen 启用，无额外 manifest 组件声明属于本 REQ 范围
- interaction: isReady 为假时启动屏保持可见；combine 首次发射后 isReady=true，启动屏消失，WccApp 内容渲染 (MainActivity.kt:37-39)。
- data_flow: 进程启动 → AppViewModel.uiState.stateIn(SharingStarted.Eagerly) 初始 isReady=false → 启动屏保持 → observeThemeMode/observeOnboardingComplete 首次发射 → isReady=true → 启动屏释放。

## Entry · 首页加载骨架屏
- claim: 首页在内置菜谱数据初始化完成前，展示菜谱卡片骨架占位（带 shimmer 微光效果），而非空白。
- layers:
  - code:     app/src/main/java/com/whaticancook/app/feature/home/HomeScreen.kt:58 (HomeUiState.Loading → HomeLoading())；HomeLoading 渲染 RecipeCardSkeleton (HomeScreen.kt:310) — 骨架组件见 app/src/main/java/com/whaticancook/app/core/designsystem/component/StateViews.kt:113-142 (含 shimmer)
  - resource: N/A: 骨架为 Compose 组件
  - manifest: N/A
- interaction: HomeViewModel.seedState 初始 Loading (HomeViewModel.kt:42) → HomeUiState.Loading → HomeLoading 骨架；seed 成功 → Ready → Content。
- data_flow: HomeViewModel init → seed() (HomeViewModel.kt:46,49-56) → runCatching{recipeRepository.ensureSeeded()} → onSuccess{Ready} → 首页内容。

## Entry · 首页错误态与重试
- claim: 当内置菜谱数据初始化失败时，首页展示居中错误态（错误图标 + 标题 + 说明 + "重试"按钮），用户可点击重试重新加载，不会崩溃或长期空白。
- layers:
  - code:     app/src/main/java/com/whaticancook/app/feature/home/HomeScreen.kt:59-64 (HomeUiState.Error → ErrorState(onRetry=viewModel::seed))；ErrorState 组件见 app/src/main/java/com/whaticancook/app/core/designsystem/component/StateViews.kt:71-109（标题"Something went wrong"、说明"We couldn't load your recipes. Please try again."、"Try again"按钮）
  - resource: N/A
  - manifest: N/A
- interaction: seed 失败 → seedState=Error (HomeViewModel.kt:54) → HomeUiState.Error → ErrorState；点击"Try again" → viewModel.seed() (HomeScreen.kt:63) 重新初始化。
- data_flow: ensureSeeded 抛错 → onFailure{Error} (HomeViewModel.kt:54) → ErrorState → onRetry→seed 重新执行。

## Entry · 菜谱详情页加载占位与"找不到菜谱"空态
- claim: 菜谱详情页在加载时展示空白占位（不崩溃）；若菜谱不存在，展示"菜谱找不到"空态提示。
- layers:
  - code:     app/src/main/java/com/whaticancook/app/feature/detail/RecipeDetailScreen.kt:71-83 (Loading → 空占位 Box；NotFound → EmptyState emoji/title/message；Content → 详情内容)；DetailUiState 三态见 app/src/main/java/com/whaticancook/app/feature/detail/RecipeDetailViewModel.kt:28-36 (初始 Loading，line 63；recipe==null → NotFound，line 51)
  - resource: N/A
  - manifest: N/A
- interaction: combine(recipe, pantry) 首次发射前为 Loading (空白占位)；若 observeRecipe 返回 null → NotFound → EmptyState("🍽️","Recipe not found","This recipe is no longer available.") (RecipeDetailScreen.kt:74)。
- data_flow: 进入详情 → RecipeDetailViewModel combine (RecipeDetailViewModel.kt:47) → Loading/NotFound/Content → 对应占位或内容。

## Entry · 搜索页 / 收藏页 / 食材库页 加载态与空结果态
- claim: 搜索页、收藏页、食材库页在数据首次加载完成前处于加载态；加载完成后若无匹配/无数据，展示对应的空结果态，不长期空白。
- layers:
  - code:     搜索: SearchViewModel.kt:27-35,59-65 (loading 默认 true，build 后 false)；SearchScreen.kt:99 (!loading && results.isEmpty() → 空结果态)。收藏: FavoritesViewModel.kt:18-38 (loading 默认 true，combine 后 false)；FavoritesScreen.kt:30 (!loading && items.isEmpty() → 空态)。食材库: PantryViewModel.kt:27-34 (loading 默认 true，加载后 false)。
  - resource: N/A
  - manifest: N/A
- interaction: 三页状态对象均有 loading 标志，首次 combine 发射前为 true（加载态），发射后置 false 并按结果展示内容或空态。
- data_flow: 各页 ViewModel combine → loading 由 true 转 false → 内容或空结果态。

## Implicit triggers (non-UI state changes that activate this feature)
- 触发: 数据初始化完成 / 数据源首次发射 — 各页 loading/error 状态由数据流首次发射驱动翻转 (HomeViewModel.kt:52-54；RecipeDetailViewModel.kt:63；SearchViewModel/FavoritesViewModel stateIn 初始值)。
- 触发: 菜谱被删除或 id 无效 — 详情页 observeRecipe 返回 null → NotFound (RecipeDetailViewModel.kt:51)。

## Core business entities (data model / persistence key / state machine)
- HomeUiState 三态: HomeViewModel.kt:21-32 (Loading / Error / Content)；SeedState 三态: HomeViewModel.kt:34 (Loading/Ready/Error)。
- DetailUiState 三态: RecipeDetailViewModel.kt:28-36 (Loading / NotFound / Content)。
- 各页 loading 标志: SearchUiState.loading (SearchViewModel.kt:28)、FavoritesUiState.loading (FavoritesViewModel.kt:19)、PantryUiState.loading (PantryViewModel.kt:28)。
- 通用状态组件: ErrorState (StateViews.kt:71)、EmptyState (StateViews.kt:25)、RecipeCardSkeleton (StateViews.kt:113)。
- AppUiState.isReady: AppViewModel.kt:14-18 — 启动屏占位控制。

## Cross-entry shared declarations
- None（加载/错误状态均为各页面内部数据流驱动，无 manifest/build 跨条目声明）

## Deviations from REQ_DESC
1. REQ_DESC 要求"加载离线数据或出现异常时应有明确状态，不应长时间白屏或崩溃"。代码在应用启动用启动屏占位 (MainActivity.kt:24-25)、首页用骨架屏与错误重试 (HomeScreen.kt:58-64)、详情页用占位与空态 (RecipeDetailScreen.kt:71-83)，均避免长期白屏。无冲突。
2. REQ_DESC 称"异常时显示可理解的提示"。首页异常显示"Something went wrong / We couldn't load your recipes. Please try again."并附"Try again"重试 (StateViews.kt:74-75,107)；详情页菜谱不存在显示"Recipe not found / This recipe is no longer available." (RecipeDetailScreen.kt:74)。属实现确认，与需求一致。
3. REQ_DESC 未明确各页加载态的具体呈现；搜索/收藏/食材库页用 loading 标志控制加载态，加载完成后转内容或空结果态 (SearchScreen.kt:99 / FavoritesScreen.kt:30 / PantryViewModel.kt:28)。详情页加载态为空白占位（RecipeDetailScreen.kt:72），非骨架，属实现选择，与需求"不应长期白屏"一致（占位是短暂过渡）。

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 启动屏占位：见 Entry · 应用启动启动屏占位
- 首页加载骨架：见 Entry · 首页加载骨架屏
- 首页错误重试：见 Entry · 首页错误态与重试
- 详情页加载/空态：见 Entry · 菜谱详情页加载占位与"找不到菜谱"空态
- 搜索/收藏/食材库加载与空态：见 Entry · 搜索页 / 收藏页 / 食材库页 加载态与空结果态

### Consumers (who reads this state / data)
- Consumer: HomeScreen（读 HomeUiState 决定骨架/错误/内容） — HomeScreen.kt:57
- Consumer: RecipeDetailScreen（读 DetailUiState 决定占位/空态/内容） — RecipeDetailScreen.kt:71
- Consumer: SearchScreen / FavoritesScreen / PantryScreen（读各自 loading 决定加载/空态/内容） — SearchScreen.kt:99 / FavoritesScreen.kt:30 / PantryScreen

### Non-consumers (boundary counter-examples with evidence)
- claim: 设置页与引导页不实现独立的加载/错误数据态（设置页为静态信息；引导页为固定内容），无 ErrorState/骨架/NotFound 占位
  - closure_layers: [code, resource, manifest]
  - tools: [homegraph_search "ErrorState" projectPath, Grep "UiState\|ErrorState\|Skeleton" over feature/{settings,onboarding}]
  - zero_hits: Grep "ErrorState|Skeleton|NotFound|Loading" over feature/settings 与 feature/onboarding 命中 0；ErrorState 的调用方仅 HomeScreen (StateViews impact 结果)

## Same-source cross-reference (if applicable)
- None（本 REQ 覆盖全局加载/错误状态，与其他功能 SPEC 无同一状态源共享关系；各页空结果态的细节由各自页面 SPEC 描述，如搜索空结果见 `search-empty-SPEC.md`、收藏空态见 `saved-empty-SPEC.md`）。
