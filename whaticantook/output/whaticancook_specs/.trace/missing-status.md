# Trace: missing-status (REQ-017)

> 缺少食材状态 Missing N。追踪"仍缺少必需食材"时详情页的缺少数量提示、缺少食材清单展示。

## Status
status: ok
repo-id: whaticancook
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 详情页缺少态区 (CookStatusSection 非 isCookable 分支) — RecipeDetailScreen.kt:252-291 — recalled by: both
- Entry 2: 卡片接近态胶囊 "Missing N" — Pills.kt:38-43 — recalled by: both

## Entry · 详情页缺少数量与清单
- claim: 仍缺少必需食材时，详情页顶部显示"你缺少 N 个食材"（N=缺少数，单复数随 N 变化），并列出每个缺少的必需食材名称胶囊；下方提供"补齐缺少食材"操作。
- layers:
  - code: RecipeDetailScreen.kt:264-268 ("You're missing N ingredient(s)", 单复数) / 270-282 (缺少食材胶囊清单) / 283-288 (Add missing to pantry 按钮)
  - resource: N/A: 纯 Compose
  - manifest: N/A
- interaction: 无持久化；由 match.missing 实时派生。
- data_flow: matchAgainst → CookMatch(missing) → CookStatusSection(!isCookable) → 渲染 "You're missing ${missing.size} ingredient(s)" + missing.forEach chip + Add missing 按钮

## Entry · 卡片接近态"Missing N"
- claim: 卡片角标在缺少 1–2 个必需食材时显示"Missing N"（N=缺少数）。
- layers:
  - code: Pills.kt:38-43 (ALMOST → "Missing ${missing.size}", 警告色容器)
  - resource: N/A
  - manifest: N/A
- interaction: 无持久化。
- data_flow: CookMatch(status=ALMOST) → cookStatusVisual → "Missing N"

## 单复数处理（RecipeDetailScreen.kt:265）
`"You're missing ${match.missing.size} ingredient${if (match.missing.size == 1) "" else "s"}"`
- N=1 → "ingredient"；N≠1 → "ingredients"。

## 缺少食材胶囊渲染（RecipeDetailScreen.kt:270-282）
缺少的每个必需食材：首字母大写显示（`ingredient.name.replaceFirstChar{uppercase}`），三级容器内文案色，圆角胶囊背景。

## Implicit triggers
- Trigger: 食材库增删导致缺少集合变化 — observePantry — 行为: 缺少数量与胶囊清单实时增减。
- Trigger: 进入详情页且缺少必需食材 — 行为: 首屏即展示缺少态区与补齐操作。

## Core business entities
- CookMatch.missing: List<RecipeIngredient>，CookMatch.kt:69/95 — 未被满足的必需食材。
- 依赖 match-count（REQ-015）/ ingredient-matching（REQ-014）。

## Cross-entry shared declarations
- None。

## Deviations from REQ_DESC
- None。REQ 要求"显示缺少 N 个食材并列出缺少食材、提供补齐操作"，代码 CookStatusSection 非 isCookable 分支一致。

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries
- 详情页 RecipeDetailScreen.kt:252-291 — 缺少数 + 清单 + 补齐按钮
- 卡片 RecipeCard.kt:57/128 — ALMOST 态 "Missing N"（仅 1–2 个缺少时）

### Consumers
- RecipeDetailViewModel: 提供 match.missing 供详情页；addMissingToPantry 用 missing 列表（见 REQ-018）。
- HomeViewModel: missing.size 决定 ALMOST/EXPLORE 态文案。

### Non-consumers
- claim: 缺少态详情卡片文案为英文硬编码（"You're missing …"），无独立资源 key。
  closure_layers: [resource]
  tools: [Grep "You're missing"]
  zero_hits: 命中仅在 RecipeDetailScreen.kt:265 代码字面量，res/values/strings 无对应条目。

## Same-source cross-reference
- 缺少态与可做态（REQ-016 ready-status）互斥切换；补齐操作（REQ-018 add-missing）作用于 missing 集合。独立生成。
