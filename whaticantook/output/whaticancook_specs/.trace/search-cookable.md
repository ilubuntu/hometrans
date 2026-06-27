# Trace: search-cookable (REQ-026)

> Search Cookable 筛选。追踪"仅看可做"开关：只展示食材库已满足全部必需食材的菜谱。

## Status
status: ok
repo-id: whaticancook
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: Cookable 开关 chip — SearchScreen.kt:82-87 — recalled by: both
- Entry 2: 可做过滤逻辑 (build) — SearchViewModel.kt:96-98 — recalled by: path 2

## Entry · 仅看可做筛选
- claim: 开启"仅看可做"后，结果只展示食材库已满足全部必需食材（isCookable）的菜谱；关闭则不按可做过滤。
- layers:
  - code: SearchScreen.kt:82-87 (WccChip "Cookable", selected=cookableOnly, onClick=onCookableToggle) / SearchViewModel.kt:69 (onCookableToggle 翻转) / 96-98 (过滤) / CookMatch.kt:78 (isCookable=READY)
  - resource: N/A
  - manifest: N/A
- interaction: 开关状态存于 SearchViewModel.cookableOnly StateFlow；默认 false。
- data_flow: chip onClick → onCookableToggle → cookableOnly 翻转 → filters → build → cookableOnly 时 filter{it.match.isCookable} → results

## 过滤逻辑（SearchViewModel.kt:96-98）
```
if (f.cookableOnly):
  items = items.filter { it.match.isCookable }
```
- isCookable = (status == READY) = essentialCount==0 || missing 为空（CookMatch.kt:72-78）。

## 验证点
- pantry 为空：所有菜谱 missing 非空（除无必需食材者）→ isCookable 多为 false → Cookable 结果基本为空。✅
- 补齐 Chicken Fried Rice 全部必需食材后：该菜谱 isCookable=true → Cookable 显示它。✅

## Implicit triggers
- Trigger: 点击 Cookable chip — onCookableToggle — 行为: 开/关切换，结果即时过滤。
- Trigger: 食材库增删 — observePantry — 行为: isCookable 重新计算，Cookable 结果随食材库变化（补齐后出现、删除必需后消失）。

## Core business entities
- SearchUiState.cookableOnly: 开关布尔，默认 false。
- CookMatch.isCookable: 过滤依据（依赖 match-count/ready-status）。

## Cross-entry shared declarations
- None。

## Deviations from REQ_DESC
- None。REQ 要求"开启后只展示 pantry 已满足全部必需食材的菜谱"，代码 filter{isCookable} 一致。

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries
- 搜索页 Cookable chip SearchScreen.kt:82-87
- 可做过滤 SearchViewModel.kt:96-98

### Consumers
- build: Cookable 过滤与文本/分类/排序叠加。

### Non-consumers
- claim: Cookable 仅作为"隐藏不可做菜谱"的筛选，不改变菜谱本身排序；与排序独立。
  closure_layers: [code]
  tools: [Read SearchViewModel.kt:96-108]
  zero_hits: cookableOnly 过滤在排序之前，二者独立。

## Same-source cross-reference
- 可做判定依赖 match-count（REQ-015）/ ready-status（REQ-016）。独立生成。
