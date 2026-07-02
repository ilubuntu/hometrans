# Code trace · recipe-card

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 首页菜谱卡片 (RecipeCard) — RecipeCard.kt:32-101 — recalled by: both
- Entry 2: 卡片上的烹饪状态胶囊 (CookStatusPill，含匹配数) — Pills.kt:53-73 — recalled by: both
- Entry 3: 卡片上的收藏按钮 (FavoriteButton) — Buttons.kt:107-138 — recalled by: both

## Entry · 首页菜谱卡片 (RecipeCard)
- claim: 首页菜谱列表中以全宽卡片展示单个菜谱，含图形、分类、标题、描述、时间、难度、热量、烹饪状态与收藏按钮
- layers:
  - code:     RecipeCard.kt:32-101 RecipeCard; RecipeCard.kt:49-56 图形 (RecipeImage 渐变+emoji); RecipeCard.kt:72-76 分类 (category.emoji + category.label); RecipeCard.kt:78-84 标题 (recipe.title); RecipeCard.kt:86-92 描述 (recipe.shortDescription); RecipeCard.kt:94-98 时间/难度/热量三连 (MetaStat: timeLabel / difficulty.label / "${calories} kcal"); RecipeCard.kt:57-62 烹饪状态胶囊; RecipeCard.kt:63-69 收藏按钮; RecipeCard.kt:46 整卡点击 → onClick
  - resource: N/A: 卡片文案取自菜谱数据字段，无静态资源
  - manifest: N/A
- interaction: 卡片无自身持久化；点击卡片 → onRecipeClick(recipe.id) 进入详情；点收藏 → onToggleFavorite
- data_flow: HomeViewModel.recipes (HomeViewModel.kt:104) → RecipeCard(recipe,match) (HomeScreen.kt:146) → 各字段渲染；点击 → onRecipeClick (HomeScreen.kt:149) → WccApp.kt:93 navigate(recipeDetail(id))

## Entry · 卡片上的烹饪状态胶囊 (CookStatusPill)
- claim: 卡片左上角展示烹饪状态胶囊，文案随匹配状态三态变化；"探索态"显示"已有数/必需数"
- layers:
  - code:     Pills.kt:53-73 CookStatusPill; Pills.kt:31-50 cookStatusVisual 三态; Pills.kt:48 EXPLORE 态 label="${haveCount}/${essentialCount}"; Pills.kt:42 ALMOST 态 label="Missing ${missing.size}"; Pills.kt:36 READY 态 label="Ready to cook"
  - resource: N/A
  - manifest: N/A
- interaction: 状态由 CookMatch.status 决定 (CookMatch.kt:72-76)：missing 空 或 essentialCount==0 → READY；missing.size<=2 → ALMOST；否则 EXPLORE；haveCount/essentialCount 来自 CookMatch (CookMatch.kt:67-68,99-101)
- data_flow: recipe.matchAgainst(pantryNames) (CookMatch.kt:86) → CookMatch → cookStatusVisual (Pills.kt:31) → CookStatusPill label

## Entry · 卡片上的收藏按钮 (FavoriteButton)
- claim: 卡片右上角展示心形收藏按钮，已收藏为实心、未收藏为空心；点击切换收藏态
- layers:
  - code:     Buttons.kt:107-138 FavoriteButton; Buttons.kt:131 图标 (已收藏 Icons.Rounded.Favorite 实心 / 未收藏 FavoriteBorder 空心); Buttons.kt:133 颜色 (已收藏 primary / 未收藏 onSurfaceVariant); Buttons.kt:119 点击 → onToggle; RecipeCard.kt:63-69 调用处 (isFavorite=recipe.isFavorite, onToggle=onToggleFavorite)
  - resource: N/A
  - manifest: N/A
- interaction: isFavorite 来自 recipe.isFavorite；点击 → onToggleFavorite → HomeViewModel.toggleFavorite (HomeViewModel.kt:62-66) → recipeRepository.setFavorite(id, !isFavorite)
- data_flow: observeRecipes 中 isFavorite 由 favSet 决定 (RecipeRepositoryImpl.kt:48-51) → recipe.isFavorite → FavoriteButton (RecipeCard.kt:64)；点击 → toggleFavorite (HomeViewModel.kt:62) → setFavorite (RecipeRepositoryImpl.kt:65)

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 食材库变化 — HomeViewModel.kt:71 — behavior: 重新计算 matchAgainst，卡片状态胶囊与匹配数随之刷新
- Trigger: 收藏集合变化 — RecipeRepositoryImpl.kt:48 — behavior: recipe.isFavorite 刷新，卡片收藏按钮实心/空心态切换
- Trigger: 菜谱数据装载完成 — HomeViewModel.kt:74-78 — behavior: 卡片列表出现

## Core business entities (data model / persistence key / state machine)
- Entity: Recipe (id/title/category/shortDescription/emoji/gradientIndex/timeMinutes/servings/difficulty/calories/ingredients/steps/tags/isFavorite) — Recipe.kt:20-34
- Entity: timeLabel — Recipe.kt:39-46：<60min 显示"N min"，≥60min 显示"Nh"/"Nh Mm"
- Entity: Difficulty(label) — Difficulty.kt:3-6：Easy/Medium/Hard
- Entity: RecipeCategory(label,emoji) — RecipeCategory.kt:4-10：Breakfast/Lunch/Dinner/Dessert/Snack/Drinks
- Entity: CookMatch(haveCount,essentialCount,missing,missingOptional,status,isCookable,ratio) — CookMatch.kt:66-83；status 三态 READY/ALMOST/EXPLORE (CookMatch.kt:63,72-76)
- 依赖来源: recipes 数据来自 `offline-recipes` (REQ-003)；匹配计算依赖食材库 (见 pantry 系列 REQ-008+)

## Cross-entry shared declarations
- RecipeCard/CookStatusPill/FavoriteButton 为首页、可做菜谱区(CompactRecipeCard 同源)、搜索页、收藏页共用的卡片组件族
- HomeViewModel.uiState 为卡片列表数据源

## Deviations from REQ_DESC
1. REQ_DESC 称卡片展示"图片或图标"——代码无真实图片，图形由"品牌渐变背景 + 居中食物 emoji"过程式生成 (RecipeVisuals.kt:36-64 RecipeImage)，属"图标式"展示，与"图片或图标"一致
2. REQ_DESC 称卡片展示"食材匹配数"，并以"0/4"为验收样例——代码状态胶囊文案随状态三态变化：仅"探索态"显示"已有数/必需数"（如 0/4）；"几乎可做态"显示"Missing N"；"可做态"显示"Ready to cook" (Pills.kt:36,42,48)。即匹配数并非始终以"X/Y"形式出现，仅在探索态以该形式展示；5-Minute Mug Cake 空食材库时为探索态，确显示"0/4"，与验收一致
3. REQ_DESC 验收"5-Minute Mug Cake 显示 Dessert、5 min、Easy、400 kcal、0/4"——对应字段：category=DESSERT"🍰 Dessert"、timeMinutes=5→"5 min"、difficulty=EASY"Easy"、calories=400→"400 kcal"、空库 match→EXPLORE"0/4"，均一致（菜谱数据见 assets/recipes.json 行389 起）

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 首页菜谱列表卡片 (RecipeCard) — RecipeCard.kt:32；本 REQ 主体
- 首页"Ready to cook"区横向卡片 (CompactRecipeCard) — RecipeCard.kt:104-147；同族紧凑卡片，仅展示标题+时间+状态胶囊，无分类/描述/难度/热量/收藏按钮。属"菜谱卡片"族但内容更少，列出以保完整
  layers: code RecipeCard.kt:104-147; resource N/A; manifest N/A
  interaction: 横向卡，点击 onRecipeClick
- 搜索页、收藏页也复用 RecipeCard 展示菜谱（同源卡片，内容一致），其页面级交互由各自需求描述

### Consumers (who reads this state / data)
- Consumer: RecipeCard 读取 Recipe 各字段与 CookMatch 渲染 — RecipeCard.kt:33-39
- Consumer: CookStatusPill 读取 CookMatch 决定状态文案 — Pills.kt:54
- Consumer: FavoriteButton 读取 recipe.isFavorite 决定图标 — Buttons.kt:129

### Non-consumers (boundary counter-examples with evidence)
- claim: 卡片不展示份数(servings)、标签(tags)、做菜步骤(steps)、食材明细——这些字段虽存在于 Recipe，但仅详情页使用
  closure_layers: [code]
  tools: [Read RecipeCard.kt:32-101, Grep "servings|\.tags|\.steps" over RecipeCard.kt]
  zero_hits: RecipeCard.kt:32-101 全文未引用 servings/tags/steps/ingredients 明细；Grep 在 RecipeCard.kt 命中 0

## Same-source cross-reference (if applicable)
- 卡片状态胶囊的可做/几乎可做/探索判定与匹配计数同源于 CookMatch，详情页的可做状态/缺失展示 (REQ-016/017) 共用同一匹配模型；本规聚焦"首页卡片展示哪些字段"。卡片所用的菜谱数据初始化见 `offline-recipes-SPEC.md`，卡片在首页布局中的位置见 `discover-layout-SPEC.md`
