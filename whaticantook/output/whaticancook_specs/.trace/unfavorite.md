# Code trace · unfavorite

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 收藏页菜谱卡片心形按钮（取消收藏主入口） — FavoritesScreen.kt:60-68 (RecipeCard onToggleFavorite) + FavoritesViewModel.toggleFavorite — recalled by: both
- Entry 2: 菜谱详情页心形按钮 — RecipeDetailScreen.kt:200-204 (FavoriteButton) + RecipeDetailViewModel.toggleFavorite — recalled by: both
- Entry 3: 首页菜谱卡片心形按钮 — HomeScreen.kt:146-152 + HomeViewModel.toggleFavorite — recalled by: path 2
- Entry 4: 搜索页菜谱卡片心形按钮 — SearchScreen.kt:113-120 + SearchViewModel.toggleFavorite — recalled by: path 2
- Entry 5: 取消收藏持久化 — RecipeRepositoryImpl.kt:65-71 (setFavorite false→remove) + FavoriteDao.kt:19-20 (remove) — recalled by: path 1

## Entry · 收藏页菜谱卡片心形按钮（取消收藏主入口）
- claim: 收藏页菜谱卡片心形按钮，点击将已收藏菜谱切换为未收藏（取消收藏）
- layers:
  - code:     FavoritesScreen.kt:60-68 RecipeCard(onToggleFavorite={viewModel.toggleFavorite(item.recipe)})；FavoritesViewModel.kt:40-44 toggleFavorite → setFavorite(recipe.id, !recipe.isFavorite)；已收藏菜谱 isFavorite=true → 传 false
  - resource: N/A
  - manifest: N/A
- interaction: 读 recipe.isFavorite；写 setFavorite(recipeId, false)
- data_flow: FavoritesScreen.kt:65 → FavoritesViewModel.toggleFavorite → setFavorite（RecipeRepositoryImpl.kt:65）→ favorite=false → favoriteDao.remove（RecipeRepositoryImpl.kt:69，FavoriteDao.kt:19）

## Entry · 菜谱详情页心形按钮
- claim: 详情页顶部心形按钮，点击将已收藏菜谱切换为未收藏
- layers:
  - code:     RecipeDetailScreen.kt:200-204 FavoriteButton(onToggle=onToggleFavorite)；RecipeDetailScreen.kt:79 → RecipeDetailViewModel.kt:65-69 toggleFavorite → setFavorite(recipe.id, !recipe.isFavorite)
  - resource: N/A
  - manifest: N/A
- interaction: 同收藏页
- data_flow: RecipeDetailScreen.kt:202 → RecipeDetailViewModel.toggleFavorite → setFavorite false → remove

## Entry · 首页菜谱卡片心形按钮
- claim: 首页菜谱卡片心形按钮，点击将已收藏菜谱切换为未收藏
- layers:
  - code:     HomeScreen.kt:146-152 RecipeCard(onToggleFavorite)；HomeScreen.kt:72 → HomeViewModel.toggleFavorite → setFavorite(recipe.id, !recipe.isFavorite)
  - resource: N/A
  - manifest: N/A
- interaction: 同收藏页
- data_flow: HomeScreen.kt:72 → HomeViewModel.toggleFavorite → setFavorite false → remove

## Entry · 搜索页菜谱卡片心形按钮
- claim: 搜索页菜谱卡片心形按钮，点击将已收藏菜谱切换为未收藏
- layers:
  - code:     SearchScreen.kt:113-120 RecipeCard(onToggleFavorite={viewModel.toggleFavorite(item.recipe)})；SearchViewModel.kt:72-76 → setFavorite(recipe.id, !recipe.isFavorite)
  - resource: N/A
  - manifest: N/A
- interaction: 同收藏页
- data_flow: SearchScreen.kt:118 → SearchViewModel.toggleFavorite → setFavorite false → remove

## Entry · 取消收藏持久化
- claim: 取消收藏即从本地收藏表中删除该菜谱记录；删除后收藏列表不再包含该菜谱，若为最后一项则收藏页改显示空态
- layers:
  - code:     RecipeRepositoryImpl.kt:65-71 setFavorite：favorite=false 分支 → favoriteDao.remove(recipeId)；FavoriteDao.kt:19-20 @Query("DELETE FROM favorites WHERE recipeId=:recipeId")；删除后 observeFavorites（RecipeRepositoryImpl.kt:58-63）经响应式流不再返回该 recipeId → 收藏列表移除
  - resource: N/A
  - manifest: N/A
- interaction: DELETE favorites WHERE recipeId；响应式 observeFavorites/observeRecipes 刷新
- data_flow: remove → favorites 表删除 → observeIdsOrdered（FavoriteDao.kt:13）发射新列表 → observeFavorites（RecipeRepositoryImpl.kt:58）→ FavoritesViewModel items → 收藏列表移除该菜谱；若 items 变空 → 收藏页空态（FavoritesScreen.kt:30）

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 收藏集合变化 — RecipeRepositoryImpl.kt:48,58 — behavior: 取消一处后，首页/搜索/收藏/详情所有页面心形状态经响应式流同步刷新为未收藏
- Trigger: 收藏列表变空 — FavoritesViewModel.kt:30 — behavior: 取消最后一项收藏后，收藏页改显示空态

## Core business entities (data model / persistence key / state machine)
- Entity: Recipe.isFavorite — Recipe.kt:34：取消后注入为 false
- Entity: RecipeRepository.setFavorite(recipeId, false) — 取消收藏入口
- Entity: FavoriteDao.remove — FavoriteDao.kt:19-20：DELETE 收藏记录
- 依赖来源: 收藏数据来自 favorite-recipe（REQ-031）；空态来自 saved-empty（REQ-032）

## Cross-entry shared declarations
- toggleFavorite 机制为四处入口共用（同 favorite-recipe），均调用 setFavorite(recipe.id, !recipe.isFavorite)；取消收藏为该机制的 false 方向
- 取消收藏后心形渲染复用 FavoriteButton（FavoriteButton.kt:107-138），未收藏=空心心形+中性色

## Deviations from REQ_DESC
1. REQ_DESC 称"从 Saved 或详情页取消收藏"（2 处入口）——实际首页卡片、搜索页卡片心形按钮亦可取消收藏（共 4 处入口）。需求为列举，代码入口更全，无冲突（覆盖规则补全）
2. REQ_DESC 验收"菜谱从 Saved 列表移除；若无收藏，显示空态"——remove 后经响应式流移除；items 变空触发空态（FavoritesScreen.kt:30），一致
3. 取消收藏为"切换"语义（toggle，!recipe.isFavorite）：对已收藏菜谱点击=取消；对未收藏菜谱点击=加入收藏（加入见 favorite-recipe-SPEC.md）

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 收藏页菜谱卡片心形按钮 — FavoritesScreen.kt:60-68 — 取消收藏主入口（需求列举）
- 菜谱详情页心形按钮 — RecipeDetailScreen.kt:200-204 — 取消收藏入口（需求列举）
- 首页菜谱卡片心形按钮 — HomeScreen.kt:146-152 — 取消收藏入口（需求未列举，覆盖规则补全）
- 搜索页菜谱卡片心形按钮 — SearchScreen.kt:113-120 — 取消收藏入口（需求未列举，覆盖规则补全）

### Consumers (who reads this state / data)
- Consumer: 收藏页 FavoritesViewModel 读取 observeFavorites — 取消后该菜谱从列表移除 — FavoritesViewModel.kt:30
- Consumer: 各页面 FavoriteButton 读取 recipe.isFavorite 渲染心形 — 取消后变未收藏态

### Non-consumers (boundary counter-evidence)
- claim: 取消收藏不删除菜谱本身——仅删除收藏记录，菜谱数据仍保留可再次收藏
  closure_layers: [code]
  tools: [Read FavoriteDao.kt:19-20, RecipeRepositoryImpl.kt:65-71]
  zero_hits: remove 仅 DELETE FROM favorites WHERE recipeId，不触及 recipes 表；菜谱仍在首页/搜索可浏览、可重新收藏
- claim: 引导页/设置页/食材库页无取消收藏入口
  closure_layers: [code]
  tools: [homegraph_explore "OnboardingScreen SettingsScreen PantryScreen"]
  zero_hits: 这些页面全文无 FavoriteButton/onToggleFavorite/toggleFavorite 引用

## Same-source cross-reference (if applicable)
- 收藏（同一 toggle 的正向）见 favorite-recipe-SPEC.md（REQ-031）；取消后收藏页空态见 saved-empty-SPEC.md（REQ-032）；收藏列表展示见 saved-list-SPEC.md（REQ-033）
- toggle 机制为收藏/取消收藏共用（setFavorite(recipe.id, !recipe.isFavorite)）
