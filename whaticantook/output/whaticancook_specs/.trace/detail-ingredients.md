# Trace: detail-ingredients (REQ-021)

> Recipe Detail 食材清单。追踪详情页 Ingredients 列表的三态展示（已拥有勾选 / Missing / Optional）与随食材库变化切换。

## Status
status: ok
repo-id: whaticancook
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 详情页食材清单区 (SectionHeader "Ingredients" + IngredientRow) — RecipeDetailScreen.kt:163-169 / 294-334 — recalled by: both

## Entry · 食材清单三态展示
- claim: 详情页展示 Ingredients 列表（标题 + 食材总数），每行食材根据拥有状态与必需性显示三态：已拥有（勾选）、必需未拥有（Missing）、可选（Optional）。
- layers:
  - code: RecipeDetailScreen.kt:164 (SectionHeader "Ingredients", actionText=ingredients.size) / 166-169 (forEach IngredientRow) / 294-334 (IngredientRow)
  - resource: N/A: 纯 Compose
  - manifest: N/A
- interaction: 无持久化；状态由 ingredient.essential 与 have 实时派生。
- data_flow: observeRecipe+observePantry → combine → recipe.ingredients.map{ IngredientStatus(ingredient, have=pantry matches) } → IngredientRow(status)

## 三态判定（RecipeDetailScreen.kt:294-334 IngredientRow）
- 圆形指示器：have → 主题色背景 + 勾选图标；!have → 次要面背景（空心）。
- 食材文本：ingredient.display（"{quantity} {unit}  {Name}"，Recipe.kt:11-16）。
- 右侧标记（321-326，优先级）：
  - !essential → "Optional"（可选属性优先）。
  - essential && !have → "Missing"。
  - essential && have → 无额外标记（左侧已勾选）。

## IngredientStatus（RecipeDetailViewModel.kt:23-26, 55-60）
```
IngredientStatus(ingredient, have)
have = pantryNames.any { IngredientMatching.matches(it, ingredient.name) }
```
- have 为食材库是否命中该食材（匹配规则见 ingredient-matching 规格）。

## Implicit triggers
- Trigger: 食材库增删（含一键补齐） — observePantry — 行为: have 重新计算，对应食材在 Missing↔勾选 间切换。
- Trigger: 进入详情页 — 行为: 首屏按当前食材库渲染三态。

## Core business entities
- IngredientStatus: ingredient + have，详情页食材行的数据源。
- RecipeIngredient.display / essential: Recipe.kt:4-17。
- 依赖 ingredient-matching（REQ-014）/ optional-ingredients（REQ-019）。

## Cross-entry shared declarations
- None。

## Deviations from REQ_DESC
- None。REQ 要求"已拥有勾选 / Missing / Optional"三态，代码 IngredientRow 一致。

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries
- 详情页食材清单 RecipeDetailScreen.kt:163-169, 294-334 — 唯一展示食材三态的页面

### Consumers
- RecipeDetailViewModel: 提供 IngredientStatus 列表。

### Non-consumers
- claim: 食材清单总数（ingredients.size）展示全部食材（必需+可选），非仅必需数。
  closure_layers: [code]
  tools: [Read RecipeDetailScreen.kt:164]
  zero_hits: actionText = ingredients.size（全部食材），非 essentialIngredients.size。

## Same-source cross-reference
- 三态标记逻辑与可选食材（REQ-019 optional-ingredients）共享；食材库变化触发与匹配计数（REQ-015）同源。独立生成。
