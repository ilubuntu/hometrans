# Trace: ready-status (REQ-016)

> 可做状态 Ready。追踪"必需食材全部满足"时的状态判定与详情页绿色完成态展示。

## Status
status: ok
repo-id: whaticancook
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 菜谱卡片状态胶囊 — READY → "Ready to cook" — Pills.kt:32-37 — recalled by: both
- Entry 2: 详情页完成态区 (CookStatusSection isCookable 分支) — RecipeDetailScreen.kt:228-251 — recalled by: both

## Entry · 卡片"可做"胶囊
- claim: 必需食材全部满足时卡片角标显示绿色"Ready to cook"。
- layers:
  - code: CookMatch.kt:72-78 (status/isCookable) / Pills.kt:31-37 (cookStatusVisual READY)
  - resource: N/A: Compose 内布局
  - manifest: N/A
- interaction: 状态由 CookMatch.status 派生，无单独持久化。
- data_flow: pantryNames → matchAgainst → CookMatch(status=READY) → RecipeCard(match) → CookStatusPill → cookStatusVisual(READY)="Ready to cook"（成功色容器）

## Entry · 详情页绿色完成态
- claim: 全部必需食材满足时，详情页顶部显示完成态卡片：🎉 "You're all set!" + "You have everything to make this."（次级容器色，非缺少态的三级容器色）。
- layers:
  - code: RecipeDetailScreen.kt:226-251 (CookStatusSection, match.isCookable 分支)
  - resource: N/A
  - manifest: N/A
- interaction: 无持久化；由 ViewModel 实时 match.isCookable 决定。
- data_flow: matchAgainst → CookMatch(isCookable=true) → CookStatusSection(match.isCookable==true) → 渲染 secondaryContainer 完成态卡片

## 判定逻辑（CookMatch.kt:72-78）
```
status = when {
  essentialCount == 0 || missing.isEmpty() -> READY
  missing.size <= 2 -> ALMOST
  else -> EXPLORE
}
isCookable = (status == READY)
```
- 即"必需食材全部满足"包含两种：菜谱本身无必需食材，或所有必需食材都已在食材库中。

## Implicit triggers
- Trigger: 食材库补齐最后缺的必需食材（如"一键补齐"或手动添加）— observePantry 发新值 — 行为: match.isCookable 变 true，详情页由缺少态切换为绿色完成态。
- Trigger: 食材库删除某必需食材 — 行为: 由完成态退回缺少/接近态。
- Trigger: 进入详情页且该菜谱已可做 — 行为: 首屏即展示完成态。

## Core business entities
- CookMatch.status / isCookable: CookMatch.kt:72-78。
- 依赖 match-count（REQ-015）: haveCount/essentialCount/missing 计算在前，READY 判定在后。

## Cross-entry shared declarations
- None。

## Deviations from REQ_DESC
- None。REQ 要求"必需食材齐全时详情页展示绿色完成态"，代码 CookStatusSection isCookable 分支与验收重点一致。

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries
- 菜谱卡片 RecipeCard.kt:57 / CompactRecipeCard RecipeCard.kt:128 — READY 显示 "Ready to cook"
- 详情页 RecipeDetailScreen.kt:228-251 — isCookable 显示完成态
- 首页可做菜谱横向列表（READY 菜谱聚合）— 依赖 isCookable 筛选（见 empty-pantry-hint/recipe-card 规格）

### Consumers
- HomeViewModel: 用 isCookable 聚合"可做菜谱"横向列表。
- SearchViewModel: isCookable 供 Cookable 筛选（REQ-026）。
- RecipeDetailViewModel: match.isCookable 决定详情页状态区。

### Non-consumers
- claim: 收藏页不单独依据 isCookable 渲染（仅展示收藏菜谱，状态胶囊仍由 RecipeCard 同源渲染）。
  closure_layers: [code]
  tools: [gitnexus_context "FavoritesViewModel", Grep "isCookable"]
  zero_hits: isCookable 直接消费者为 Home/Search/Detail ViewModel；收藏页无独立判定逻辑。

## Same-source cross-reference
- READY 判定依赖匹配计数（REQ-015 match-count）；可做菜谱列表与 Cookable 筛选分别见 recipe-card-SPEC.md / search-cookable-SPEC.md。独立生成。
