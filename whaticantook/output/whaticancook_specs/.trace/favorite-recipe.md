# Code trace · favorite-recipe

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 首页菜谱卡片心形按钮 — HomeScreen.kt:146-152 (RecipeCard onToggleFavorite) + HomeViewModel.toggleFavorite — recalled by: both
- Entry 2: 搜索页菜谱卡片心形按钮 — SearchScreen.kt:113-120 (RecipeCard onToggleFavorite) + SearchViewModel.toggleFavorite — recalled by: both
- Entry 3: 收藏页菜谱卡片心形按钮 — FavoritesScreen.kt:60-68 (RecipeCard onToggleFavorite) + FavoritesViewModel.toggleFavorite — recalled by: path 2
- Entry 4: 菜谱详情页心形按钮 — RecipeDetailScreen.kt:200-204 (FavoriteButton) + RecipeDetailViewModel.toggleFavorite — recalled by: both
- Entry 5: 心形按钮渲染 — FavoriteButton.kt:107-138 — recalled by: path 1

## Entry · 首页菜谱卡片心形按钮
- claim: 首页菜谱卡片右上角心形按钮，点击将未收藏菜谱加入收藏（已收藏则取消，见 unfavorite）；收藏后心形变为已收藏态
- layers:
  - code:     HomeScreen.kt:146-152 RecipeCard(onToggleFavorite={onToggleFavorite(item)})；HomeScreen.kt:72 onToggleFavorite={viewModel.toggleFavorite(it.recipe)}；HomeViewModel.toggleFavorite → recipeRepository.setFavorite(recipe.id, !recipe.isFavorite)
  - resource: N/A
  - manifest: N/A
- interaction: 读 recipe.isFavorite 渲染心形；写：setFavorite(recipeId, !isFavorite)（RecipeRepositoryImpl.kt:65-71）
- data_flow: HomeScreen.kt:72 → HomeViewModel.toggleFavorite → RecipeRepository.setFavorite（RecipeRepository.kt:16）→ RecipeRepositoryImpl.setFavorite（RecipeRepositoryImpl.kt:65）→ favoriteDao.add/remove（FavoriteDao.kt:16/19）

## Entry · 搜索页菜谱卡片心形按钮
- claim: 搜索页菜谱卡片右上角心形按钮，点击切换收藏状态
- layers:
  - code:     SearchScreen.kt:113-120 RecipeCard(onToggleFavorite={viewModel.toggleFavorite(item.recipe)})；SearchViewModel.kt:72-76 toggleFavorite → setFavorite(recipe.id, !recipe.isFavorite)
  - resource: N/A
  - manifest: N/A
- interaction: 同首页
- data_flow: SearchScreen.kt:118 → SearchViewModel.toggleFavorite → setFavorite → favoriteDao.add/remove

## Entry · 收藏页菜谱卡片心形按钮
- claim: 收藏页菜谱卡片右上角心形按钮，点击切换收藏状态
- layers:
  - code:     FavoritesScreen.kt:60-68 RecipeCard(onToggleFavorite={viewModel.toggleFavorite(item.recipe)})；FavoritesViewModel.kt:40-44 toggleFavorite → setFavorite(recipe.id, !recipe.isFavorite)
  - resource: N/A
  - manifest: N/A
- interaction: 同首页
- data_flow: FavoritesScreen.kt:65 → FavoritesViewModel.toggleFavorite → setFavorite → favoriteDao.add/remove

## Entry · 菜谱详情页心形按钮
- claim: 菜谱详情页顶部右侧心形按钮，点击切换收藏状态
- layers:
  - code:     RecipeDetailScreen.kt:200-204 FavoriteButton(isFavorite=recipe.isFavorite, onToggle=onToggleFavorite)；RecipeDetailScreen.kt:79 onToggleFavorite={viewModel.toggleFavorite(s.recipe)}；RecipeDetailViewModel.kt:65-69 toggleFavorite → setFavorite(recipe.id, !recipe.isFavorite)
  - resource: N/A
  - manifest: N/A
- interaction: 同首页
- data_flow: RecipeDetailScreen.kt:202 → RecipeDetailViewModel.toggleFavorite → setFavorite → favoriteDao.add/remove

## Entry · 心形按钮渲染
- claim: 心形按钮按收藏状态显示不同图标与颜色：已收藏=实心心形+主题强调色；未收藏=空心心形+中性色；切换时有缩放淡入淡出过渡
- layers:
  - code:     FavoriteButton.kt:107-138；FavoriteButton.kt:131 imageVector = if(fav) Favorite else FavoriteBorder；FavoriteButton.kt:133 tint = if(fav) primary else onSurfaceVariant；FavoriteButton.kt:122-128 AnimatedContent 缩放+淡入淡出过渡
  - resource: N/A
  - manifest: N/A
- interaction: 读 isFavorite 决定图标/颜色
- data_flow: 各页面 recipe.isFavorite（由 observeRecipes/observeRecipe 注入，RecipeRepositoryImpl.kt:48-56）→ FavoriteButton 渲染

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 收藏集合变化 — RecipeRepositoryImpl.kt:48,58 (observeFavorites 经 observeRecipes/observeRecipe 注入 isFavorite) — behavior: 收藏一处后，首页/搜索/收藏/详情所有页面心形状态经响应式流同步刷新
- Trigger: 菜谱数据初始化完成 — RecipeRepositoryImpl.kt:47 — behavior: 首次加载后 isFavorite 才有值

## Core business entities (data model / persistence key / state machine)
- Entity: Recipe.isFavorite — Recipe.kt:34：菜谱收藏标志，默认 false；由 observeRecipes/observeRecipe 注入（RecipeRepositoryImpl.kt:48-56）
- Entity: FavoriteEntity(recipeId, savedAt) — FavoriteEntity.kt:6-9：收藏表实体，@PrimaryKey recipeId，savedAt=收藏时间戳
- Entity: RecipeRepository.setFavorite(recipeId, favorite) — RecipeRepository.kt:16：收藏/取消收藏统一入口；favorite=true → add，false → remove
- Entity: FavoriteDao.add — FavoriteDao.kt:16-17：INSERT OnConflictStrategy.REPLACE（同 recipeId 覆盖，savedAt 更新）
- 依赖来源: 菜谱数据来自 offline-recipes (REQ-003)

## Cross-entry shared declarations
- toggleFavorite 机制为四处入口（首页/搜索/收藏卡片 + 详情页）共用，均调用 recipeRepository.setFavorite(recipe.id, !recipe.isFavorite)
- RecipeRepositoryImpl.setFavorite（RecipeRepositoryImpl.kt:65-71）为收藏写入唯一落点；FavoriteDao（FavoriteDao.kt:10-20）为持久化层
- isFavorite 注入由 observeRecipes/observeRecipe 统一完成（RecipeRepositoryImpl.kt:48-56），四处入口渲染同源

## Deviations from REQ_DESC
1. REQ_DESC 称"从首页、搜索页或详情页收藏菜谱"（3 处入口）——实际收藏页卡片心形按钮亦可切换收藏（FavoritesScreen.kt:65，第 4 处入口）。需求为列举，代码入口更全，无冲突（覆盖规则补全）
2. REQ_DESC 验收"心形变为已收藏状态，详情页同步已收藏"——toggleFavorite 经响应式流注入 isFavorite，各页面同步刷新，一致
3. 收藏为"切换"语义（toggle，!recipe.isFavorite）：对未收藏菜谱点击=加入收藏；对已收藏菜谱点击=取消收藏（取消见 unfavorite-SPEC.md）

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 首页菜谱卡片心形按钮 — HomeScreen.kt:146-152 — 收藏入口
- 搜索页菜谱卡片心形按钮 — SearchScreen.kt:113-120 — 收藏入口
- 收藏页菜谱卡片心形按钮 — FavoritesScreen.kt:60-68 — 收藏入口（需求未列举，覆盖规则补全）
- 菜谱详情页心形按钮 — RecipeDetailScreen.kt:200-204 — 收藏入口

### Consumers (who reads this state / data)
- Consumer: 各页面 FavoriteButton 读取 recipe.isFavorite 渲染心形 — FavoriteButton.kt:131,133
- Consumer: 收藏页 FavoritesViewModel 读取 observeFavorites 展示收藏列表 — FavoritesViewModel.kt:30
- Consumer: 首页 HomeViewModel 读取 observeRecipes（含 isFavorite）— HomeViewModel

### Non-consumers (boundary counter-evidence)
- claim: 引导页/设置页/食材库页无心形收藏按钮——这些页面不提供收藏入口
  closure_layers: [code]
  tools: [homegraph_explore "OnboardingScreen SettingsScreen PantryScreen"]
  zero_hits: OnboardingScreen.kt / SettingsScreen.kt / PantryScreen.kt 全文无 FavoriteButton/onToggleFavorite/toggleFavorite 引用

## Same-source cross-reference (if applicable)
- 取消收藏（同一 toggle 的反向）见 unfavorite-SPEC.md（REQ-034）；收藏列表展示见 saved-list-SPEC.md（REQ-033）；收藏顺序见 favorite-order-SPEC.md（REQ-035）；收藏页空态见 saved-empty-SPEC.md（REQ-032）
- 心形按钮复用同一 FavoriteButton 组件（FavoriteButton.kt:107），四处入口渲染同源
