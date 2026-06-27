# Trace: recipe-card (REQ-006)

> 首页菜谱卡片。追踪首页菜谱卡片（RecipeCard）展示的字段与匹配计数逻辑。

## 关键源文件
- `app/src/main/java/com/whaticancook/app/core/designsystem/component/RecipeCard.kt` — RecipeCard（全宽）/ CompactRecipeCard（横向列表用）
- `app/src/main/java/com/whaticancook/app/core/designsystem/component/RecipeVisuals.kt` — RecipeImage（渐变+emoji）、gradientBrushFor
- `app/src/main/java/com/whaticancook/app/core/designsystem/component/Pills.kt` — CookStatusPill、cookStatusVisual、MetaStat
- `app/src/main/java/com/whaticancook/app/domain/model/Recipe.kt` — Recipe 字段、timeLabel、essentialIngredients
- `app/src/main/java/com/whaticancook/app/domain/model/CookMatch.kt` — 匹配计数与状态
- `app/src/main/assets/recipes.json` — 数据来源

## RecipeCard 结构（RecipeCard.kt:33-101）
全宽卡片（圆角 24dp + 阴影 + 点击进入详情），从上到下：
1. **图片区**（RecipeImage，高 150dp）：品牌渐变背景（gradientBrushFor(recipe.gradientIndex)）+ 居中食物 emoji（58sp）。无外部图片，纯程序生成、每菜谱确定性一致。
   - 左上角 **CookStatusPill**（状态胶囊）。
   - 右上角 **FavoriteButton**（收藏按钮）。
2. **信息区**（padding 16dp）：
   - 分类文案：`"${recipe.category.emoji}  ${recipe.category.label}"`（primary 色）。
   - 标题：`recipe.title`（titleLarge，最多 2 行，省略号）。
   - 简介：`recipe.shortDescription`（bodyMedium，最多 2 行，省略号）。
   - 元信息行（MetaStat，间距 16dp）：
     - ⏱ `recipe.timeLabel`（如 "5 min"，Schedule 图标）
     - 📶 `recipe.difficulty.label`（如 "Easy"，SignalCellularAlt 图标）
     - 🔥 `"${recipe.calories} kcal"`（如 "400 kcal"，LocalFireDepartment 图标）

## 匹配计数与状态胶囊（CookStatusPill → cookStatusVisual）
根据 CookMatch.status 显示（Pills.kt:31-50）：
- **READY**（必需食材全有）→ 绿色胶囊 "Ready to cook"（CheckCircle 图标）。
- **ALMOST**（缺少 1–2 个必需食材）→ 警告色胶囊 "Missing N"（N=缺少数量，ShoppingBasket 图标）。
- **EXPLORE**（缺少 >2 个必需食材）→ 中性色胶囊 `"${haveCount}/${essentialCount}"`（如 "0/4"，Kitchen 图标）。

> REQ 验收重点的 "0/4" 即 EXPLORE 态的 haveCount/essentialCount。

## Recipe 字段（Recipe.kt）
- timeLabel：`<60min` → "N min"；`≥60` → "Nh"/"Nh Mm"（line 39-46）。
- essentialIngredients = ingredients.filter{essential}（line 36-37）。

## CookMatch 计算（CookMatch.kt:66-83, 86-105）
- haveCount / essentialCount = 已拥有 / 必需食材数。
- status 判定：essentialCount==0 或 missing 空 → READY；missing.size ≤ 2 → ALMOST；否则 EXPLORE。
- 缺少计数来自 pantry 与必需食材比对（见 ingredient-matching 规格）。

## 验证点（5-Minute Mug Cake）
recipes.json 中 `chocolate-mug-cake`：
- category=DESSERT（emoji+label → Dessert）
- timeMinutes=5 → "5 min"
- difficulty=EASY → "Easy"
- calories=400 → "400 kcal"
- 4 个必需食材（flour/sugar/milk/butter）→ 空 pantry 时 haveCount=0, essentialCount=4 → EXPLORE 胶囊 "0/4"。
- ✅ 与验收重点 "Dessert、5 min、Easy、400 kcal、0/4" 完全一致。

## 偏差/备注
- "图片"实为渐变背景 + 食物 emoji（RecipeImage），无外部图片资源。规格按"图形/视觉元素（emoji + 渐变）"描述。
- 匹配计数仅在 EXPLORE 态以 "have/essential" 显示；READY 态显示 "Ready to cook"，ALMOST 态显示 "Missing N"。REQ 中"匹配计数如 0/4"指 EXPLORE 态。
