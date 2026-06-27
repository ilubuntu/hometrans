# Trace: detail-info (REQ-020)

> Recipe Detail 基础信息。追踪详情页顶部基础信息区（返回/收藏、视觉头图、分类、标题、简介、标签、耗时/份数/难度/热量）。

## Status
status: ok
repo-id: whaticancook
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 详情页 (RecipeDetailScreen → DetailContent) — RecipeDetailScreen.kt:85-207 — recalled by: both

## Entry · 详情页基础信息区
- claim: 详情页顶部展示返回按钮、收藏按钮、菜谱视觉头图（视差）、分类、标题、简介、标签，以及耗时/份数/难度/热量四宫格统计。
- layers:
  - code: RecipeDetailScreen.kt:185-205 (顶部固定栏：返回 CircleIconButton + 收藏 FavoriteButton) / 99-115 (视差头图 RecipeImage) / 127-150 (分类/标题/简介/标签) / 152-158 (四宫格 StatTile)
  - resource: N/A: 纯 Compose 布局
  - manifest: N/A
- interaction: 无持久化（收藏切换除外）；数据来自 Recipe 域模型。
- data_flow: RecipeRepository.observeRecipe(recipeId) → Recipe → DetailContent → 各信息区渲染

## 各信息字段映射（RecipeDetailScreen.kt）
- 返回按钮：CircleIconButton(ArrowBack, "Back", onClick=onBack) — 193-198，固定在顶部状态栏内边距。
- 收藏按钮：FavoriteButton(isFavorite=recipe.isFavorite, onToggle) — 200-204，与返回按钮同行右侧。
- 视觉头图：RecipeImage(gradientIndex, emoji, 120sp) + 视差（scroll 位移/透明度） — 104-114，高 300dp。
- 分类：`"${category.emoji}  ${category.label}"`（primary 色） — 127-131。
- 标题：recipe.title（headlineMedium） — 133-137。
- 简介：recipe.shortDescription（bodyLarge，onSurfaceVariant） — 139-143。
- 标签：recipe.tags 非空时 FlowRow 渲染 Tag() — 145-150。
- 四宫格 StatTile（Row weight 等分，圆角卡片，primary 图标） — 152-158：
  - ⏱ 耗时：recipe.timeLabel（"25 min"）
  - 🍽 份数：recipe.servings，标签 "Serves"
  - 📶 难度：recipe.difficulty.label（"Medium"）
  - 🔥 热量：recipe.calories，标签 "Kcal"

## Recipe 域模型字段（Recipe.kt:20-46）
- title / category / shortDescription / emoji / gradientIndex / timeMinutes / servings / difficulty / calories / tags
- timeLabel：<60min→"N min"；≥60→"Nh"/"Nh Mm"。

## 验证点（Chicken Fried Rice）
recipes.json chicken-fried-rice（recipes.json:114-141）：
- category=DINNER → label "Dinner"
- tags=["High protein","Meal prep"]
- timeMinutes=25 → "25 min"
- servings=3 → "3 Serves"
- difficulty=MEDIUM → label "Medium"
- calories=480 → "480 Kcal"
- ✅ 与验收重点"Dinner、High protein、Meal prep、25 min、3 Serves、Medium、480 Kcal"一致。

## Implicit triggers
- Trigger: 进入详情页（导航传 recipeId）— observeRecipe — 行为: 首屏渲染基础信息区。
- Trigger: 收藏切换 — toggleFavorite — 行为: 收藏按钮视觉即时更新（见 REQ-031）。

## Core business entities
- Recipe: Recipe.kt:20-46 — 详情页数据源。
- RecipeCategory / Difficulty: 枚举，提供 emoji/label。

## Cross-entry shared declarations
- None。

## Deviations from REQ_DESC
- None。REQ 列举的字段与代码渲染一致。

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries
- 详情页 RecipeDetailScreen.kt:85-207 — 唯一展示基础信息的页面

### Consumers
- RecipeDetailViewModel.observeRecipe(recipeId): 提供 Recipe。

### Non-consumers
- claim: 详情页基础信息不含食材清单与步骤（分别在 REQ-021/REQ-022）；四宫格统计仅展示数值与单位，不展示食材。
  closure_layers: [code]
  tools: [Read RecipeDetailScreen.kt:152-158]
  zero_hits: StatTile 行仅 4 项（耗时/份数/难度/热量），无食材内容。

## Same-source cross-reference
- 详情页其它区段：食材清单（REQ-021 detail-ingredients）、步骤（REQ-022 detail-steps）、匹配状态区（REQ-015~019）。独立生成。
