# Trace: optional-ingredients (REQ-019)

> 可选食材不影响可做状态。追踪 optional 食材在匹配判定与详情页标记中的处理。

## Status
status: ok
repo-id: whaticancook
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 匹配判定 (matchAgainst) — 可选食材不入 missing — CookMatch.kt:91-97 — recalled by: both
- Entry 2: 详情页食材行 (IngredientRow) — 非必需标记 "Optional" — RecipeDetailScreen.kt:321-326 — recalled by: both

## Entry · 可选食材不阻塞可做状态
- claim: 菜谱中的可选（非必需）食材无论是否被满足，都不影响可做判定；当全部必需食材满足时即判为可做，即便仍有缺少的可选食材。
- layers:
  - code: CookMatch.kt:91-97 (matchAgainst 分支：!essential && !satisfied → missingOptional，不进 missing) / CookMatch.kt:72-73 (status 仅看 essentialCount/missing)
  - resource: N/A
  - manifest: N/A
- interaction: 可选未满足项仅记录在 CookMatch.missingOptional，供展示用，不计入 essentialCount/missing。
- data_flow: 遍历 ingredients：essential&&satisfied→have；essential&&!satisfied→missing；!essential&&!satisfied→missingOptional。status=isCookable 仅由 essentialCount==0||missing.isEmpty 决定 → 可选食材不参与。

## Entry · 详情页标记可选食材
- claim: 详情页食材清单中，每个非必需食材行右侧显示"Optional"标记；必需且未拥有显示"Missing"；必需且已拥有显示勾选。
- layers:
  - code: RecipeDetailScreen.kt:294-334 (IngredientRow) / 321-326 (非必需→"Optional")
  - resource: N/A: 标签为代码字面量
  - manifest: N/A
- interaction: 无持久化；由 ingredient.essential 与 status.have 派生展示。
- data_flow: RecipeDetailViewModel.ingredient statuses (have=pantry 命中) → IngredientRow → 非必需显示 "Optional"

## 关键判定（CookMatch.kt:91-97）
```
for ing in ingredients:
  satisfied = pantryNames.any { matches(it, ing.name) }
  ing.essential && satisfied    -> have
  ing.essential && !satisfied   -> missing      // 仅必需缺失计入
  !ing.essential && !satisfied  -> missingOptional
```
- essentialCount = essentialIngredients.size（仅必需）；status/isCookable 不读 missingOptional。

## Implicit triggers
- Trigger: 食材库变更 — 行为: 必需满足情况刷新；可选食材缺失与否不影响可做态。
- Trigger: 进入详情页含可选食材 — 行为: 可选项标记 Optional。

## Core business entities
- RecipeIngredient.essential: 布尔，决定是否阻塞可做（recipes.json per-ingredient）。
- CookMatch.missingOptional: 仅供展示的可选缺失集合。
- 依赖 match-count（REQ-015）/ ingredient-matching（REQ-014）。

## Cross-entry shared declarations
- None。

## Deviations from REQ_DESC
- None。REQ 要求"可选食材不阻塞 Ready、详情页标记 Optional"，代码 matchAgainst + IngredientRow 一致。

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries
- 详情页食材清单 RecipeDetailScreen.kt:294-334 — Optional/Missing/勾选 三态标记
- 匹配判定 CookMatch.kt:91-97 — 可选不进 missing

### Consumers
- RecipeDetailViewModel: statuses 含 ingredient.essential 与 have，供 IngredientRow 标记。

### Non-consumers
- claim: 卡片状态胶囊与可做列表不单独展示 missingOptional（仅看 isCookable/missing.size）。
  closure_layers: [code]
  tools: [Grep "missingOptional"]
  zero_hits: missingOptional 仅在 matchAgainst 收集，无 UI 直接消费 missingOptional 渲染（详情页未展示可选缺失清单）。

## Same-source cross-reference
- 可选食材处理与可做态（REQ-016 ready-status）/ 食材清单三态（REQ-021 detail-ingredients）相关。独立生成。
