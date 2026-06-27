# Trace: detail-steps (REQ-022)

> Recipe Detail 步骤进度。追踪详情页 Steps 列表与完成进度的切换（点击步骤切换完成态，进度计数增减）。

## Status
status: ok
repo-id: whaticancook
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 详情页步骤区 (StepsSection) — RecipeDetailScreen.kt:171-178, 337-419 — recalled by: both

## Entry · 步骤列表与完成进度
- claim: 详情页底部展示 Steps 列表，标题右侧显示完成进度"已完成/总数"，下方进度条；点击任一步骤切换其完成态，进度计数与进度条随之增减。
- layers:
  - code: RecipeDetailScreen.kt:337-419 (StepsSection) / 94 (completedSteps = remember(recipe.id){mutableStateListOf<Int>()}) / 171-178 (调用)
  - resource: N/A: 纯 Compose
  - manifest: N/A
- interaction: 完成态为内存状态（mutableStateListOf，按 recipe.id 记忆），不持久化；离开页面/重建后重置。
- data_flow: recipe.steps → StepsSection(steps, completed, onToggle) → forEachIndexed 渲染步骤行；onToggle(index): completed.contains(index) ? remove : add

## 进度计算与展示（RecipeDetailScreen.kt:339-355）
- progress = animateFloatAsState(completed.size / steps.size)（steps 为空时 0f）。
- 标题行："Steps" + 右侧 "${completed.size}/${steps.size}"（primary 色）。
- 进度条：背景 track + 前景按 progress 填充（primary 色，圆角，高 6dp），带动画。

## 步骤行展示与切换（RecipeDetailScreen.kt:373-419）
- forEachIndexed { index, step }：
  - done = completed.contains(index)。
  - 指示器：done → primary 背景 + Check 图标；!done → surface 背景 + 序号 "${index+1}"。
  - 步骤文本：done → 次要色 + 删除线；!done → 正常色。
  - 整行 bounceClick(onToggle(index))。
- onToggle（175-177）：done 则 remove，否则 add（集合去重，重复点击来回切换）。

## Implicit triggers
- Trigger: 点击步骤行 — onToggle — 行为: 该步骤完成态切换，进度计数±1，进度条动画更新。
- Trigger: 进入/重建详情页 — completedSteps 重置为空 — 行为: 进度归零（0/N）。

## Core business entities
- recipe.steps: List<String>，步骤文本（recipes.json）。
- completedSteps: mutableStateListOf<Int>，内存完成索引集合（按 recipe.id 记忆，不持久化）。

## Cross-entry shared declarations
- None。

## Deviations from REQ_DESC
- 完成态为内存状态，不持久化：离开详情页或重建后进度重置为 0/N。REQ 未要求持久化，故按"会话内可切换、重置后归零"描述，并在偏差说明中注明。

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries
- 详情页步骤区 RecipeDetailScreen.kt:337-419 — 唯一展示步骤进度的页面

### Consumers
- DetailContent: 持有 completedSteps 并传给 StepsSection。

### Non-consumers
- claim: 步骤完成态无任何持久化（不写入数据库/偏好）；仅会话内有效。
  closure_layers: [code]
  tools: [Read RecipeDetailScreen.kt:94, Grep "completedSteps"]
  zero_hits: completedSteps = remember(recipe.id){mutableStateListOf<Int>()}，无 DAO/偏好写入。

## Same-source cross-reference
- 步骤区与详情页基础信息（REQ-020 detail-info）/ 食材清单（REQ-021 detail-ingredients）同属详情页。独立生成。
