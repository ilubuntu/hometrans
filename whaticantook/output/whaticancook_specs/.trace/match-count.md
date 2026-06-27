# Trace: match-count (REQ-015)

> 菜谱匹配计数。追踪 haveCount/essentialCount 的计算与在卡片、详情页的展示。

## Status
status: ok
repo-id: whaticancook
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 首页菜谱卡片 (RecipeCard) — CookStatusPill — Pills.kt:54 / RecipeCard.kt:57 — recalled by: both
- Entry 2: 首页可做菜谱横向卡片 (CompactRecipeCard) — CookStatusPill — RecipeCard.kt:128 — recalled by: both
- Entry 3: 详情页顶部状态区 (CookStatusSection) — CookStatusPill — RecipeDetailScreen.kt:226/261 — recalled by: both

## Entry · 首页菜谱卡片状态胶囊
- claim: 卡片左上角胶囊根据匹配状态展示 "已拥有/必需"（如 3/7、0/4）或其它状态文案。
- layers:
  - code: RecipeCard.kt:57 (CookStatusPill) / CookMatch.kt:66-82 (CookMatch)
  - resource: N/A: 无 layout/menu XML，Compose 代码内布局
  - manifest: N/A: 普通页面组件，无 manifest 声明
- interaction: 计算结果存于 CookMatch.haveCount/essentialCount，仅作内存状态传给 Composable，无单独持久化。
- data_flow: PantryRepository.observePantry → HomeViewModel (pantryNames) → recipe.matchAgainst(pantryNames) → CookMatch → RecipeCard(match) → CookStatusPill → cookStatusVisual(match).label

## Entry · 详情页状态胶囊
- claim: 详情页顶部状态区展示匹配计数胶囊（非全满足时），与卡片同源。
- layers:
  - code: RecipeDetailScreen.kt:261 (CookStatusPill) / 264-268 (You're missing N) / CookMatch.kt:66-82
  - resource: N/A: 纯 Compose
  - manifest: N/A
- interaction: 无单独持久化；CookMatch 由 ViewModel 实时计算。
- data_flow: RecipeRepository.observeRecipe + PantryRepository.observePantry → RecipeDetailViewModel.combine → recipe.matchAgainst(pantryNames) → CookMatch → CookStatusSection(content.match) → CookStatusPill(match)

## CookMatch 计算（CookMatch.kt:85-104 matchAgainst）
```
matchAgainst(pantryNames):
  for ing in recipe.ingredients:
    satisfied = pantryNames.any { matches(it, ing.name) }   // 见 ingredient-matching 规格
    ing.essential && satisfied   -> have += ing
    ing.essential && !satisfied  -> missing += ing
    !ing.essential && !satisfied -> missingOptional += ing
  return CookMatch(
    haveCount = have.size,
    essentialCount = essentialIngredients.size,   // = ingredients.filter{essential}.size
    missing, missingOptional
  )
```
- haveCount = 已拥有的"必需"食材数；essentialCount = 必需食材总数。

## 状态与展示文案（CookMatch.kt:66-82 / Pills.kt:31-50 cookStatusVisual）
CookMatch.status 由 essentialCount / missing.size 决定：
- essentialCount == 0 || missing 为空 → READY → 胶囊 "Ready to cook"
- missing.size ≤ 2 → ALMOST → 胶囊 "Missing N"
- 否则（missing.size > 2）→ EXPLORE → 胶囊 "${haveCount}/${essentialCount}"（如 "3/7"、"0/4"）

> "匹配计数如 3/7、0/4" 即 EXPLORE 态的 haveCount/essentialCount。卡片与详情页共用同一 cookStatusVisual 逻辑。

## 衍生量（CookMatch.kt:78-82）
- isCookable = (status == READY)
- ratio = haveCount / essentialCount（essentialCount==0 时为 1f），用于搜索排序（见 search-best-match 规格）

## 验证点（Chicken Fried Rice 显示 3/7）
recipes.json chicken-fried-rice 必需食材（essential=true）共 7 个：rice、chicken、egg、carrot、green onion、soy sauce、garlic；optional: olive oil（recipes.json:125-132）。
pantry = {carrot, green onion, garlic} → haveCount=3, essentialCount=7, missing.size=4 → EXPLORE → 胶囊 "3/7"。✅ 与验收重点一致。

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 食材库变更（添加/删除/清空） — PantryRepository.observePantry 流发新值 — 行为: 各 ViewModel 重新 matchAgainst，卡片与详情页匹配计数实时更新。
- Trigger: 进入详情页 — observeRecipe+observePantry combine — 行为: 详情页首次计算并展示匹配计数。

## Core business entities
- CookMatch: CookMatch.kt:66-82 — 字段 haveCount / essentialCount / missing / missingOptional；派生 status / isCookable / ratio。
- RecipeIngredient.essential: recipes.json 中 per-ingredient 布尔，决定是否计入 essentialCount。
- 依赖 ingredient-matching（REQ-014）: matches() 用于判定 satisfied，CookMatch.kt:92。

## Cross-entry shared declarations
- None（普通页面组件，无 manifest/gradle 特殊声明）。

## Deviations from REQ_DESC
- None。REQ 描述的 "haveCount/essentialCount、卡片和详情页展示 3/7、0/4" 与代码一致。

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths)
- 首页菜谱卡片 RecipeCard.kt:57 — EXPLORE 态显示 haveCount/essentialCount
- 首页可做菜谱横向卡片 CompactRecipeCard RecipeCard.kt:128 — 同一胶囊
- 详情页状态区 RecipeDetailScreen.kt:261 — 同一胶囊

### Consumers (who reads this state / data)
- HomeViewModel: 对每个菜谱 matchAgainst 计算 CookMatch 供卡片渲染。
- SearchViewModel: 用 CookMatch.ratio / isCookable 做排序与 Cookable 筛选（见 search-* 规格）。
- RecipeDetailViewModel: 详情页 matchAgainst + 逐食材 have 判定。

### Non-consumers (boundary counter-examples with evidence)
- claim: 搜索页结果卡片不直接展示 haveCount/essentialCount 计数胶囊（搜索页展示菜谱但状态胶囊复用同一组件，匹配计数逻辑同源；搜索页特有的是排序与筛选）。
  closure_layers: [code]
  tools: [Grep "CookStatusPill"]
  zero_hits: CookStatusPill 仅出现在 RecipeCard.kt:57,128 与 RecipeDetailScreen.kt:261；搜索页结果复用 RecipeCard，故匹配计数展示同源。

## Same-source cross-reference
- 匹配计数依赖食材匹配算法（REQ-014 ingredient-matching）；匹配比例 ratio 供搜索排序使用（REQ-027 search-best-match）。三份规格独立生成。
