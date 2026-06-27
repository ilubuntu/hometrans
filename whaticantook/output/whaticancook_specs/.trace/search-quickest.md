# Trace: search-quickest (REQ-028)

> Search Quickest 排序。追踪"最快"排序：按烹饪耗时（timeMinutes）从小到大。

## Status
status: ok
repo-id: whaticancook
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: Quickest chip — SearchScreen.kt:89-94 (SortOption.entries 渲染) — recalled by: both
- Entry 2: Quickest 排序逻辑 (build) — SearchViewModel.kt:104 — recalled by: path 2

## Entry · 最快排序
- claim: 选择"Quickest"后，结果按菜谱烹饪耗时（分钟）从小到大排列；耗时相同的菜谱保持原相对顺序（稳定排序）。
- layers:
  - code: SearchScreen.kt:89-94 (sort chips) / SearchViewModel.kt:21-25 (QUICKEST="Quickest") / 70 (onSortSelected) / 104 (排序) / Recipe.kt:27 (timeMinutes)
  - resource: N/A
  - manifest: N/A
- interaction: 排序选项存于 SearchViewModel.sort StateFlow。
- data_flow: chip onClick → onSortSelected(QUICKEST) → sort.value → filters → build → sortedBy{it.recipe.timeMinutes} → results

## 排序逻辑（SearchViewModel.kt:104）
```
SortOption.QUICKEST -> items.sortedBy { it.recipe.timeMinutes }
```
- sortedBy 为稳定升序；耗时相同者保持输入顺序（此时输入为过滤后列表，未做二级排序）。
- timeMinutes 为整数分钟，来自菜谱数据。

## 验证点
- 5 分钟菜谱靠前：chocolate-mug-cake timeMinutes=5、berry-yogurt-parfait timeMinutes=5（recipes.json:370）、mango-lassi timeMinutes=5（recipes.json:444）→ 排在更前。✅

## Implicit triggers
- Trigger: 点击 Quickest chip — onSortSelected(QUICKEST) — 行为: 结果按耗时升序重排。
- Trigger: 菜谱数据变化 — observeRecipes — 行为: 重新排序。

## Core business entities
- SortOption.QUICKEST: "Quickest"。
- Recipe.timeMinutes: 排序键（整数分钟，recipes.json）。

## Cross-entry shared declarations
- None。

## Deviations from REQ_DESC
- None。REQ 要求"按 timeMinutes 从小到大"，代码 sortedBy{timeMinutes} 一致。

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries
- 搜索页排序 chips SearchScreen.kt:89-94
- Quickest 排序 SearchViewModel.kt:104

### Consumers
- build: 排序在过滤之后应用。

### Non-consumers
- claim: Quickest 仅按耗时单键升序，无二级排序（耗时相同者保持稳定相对顺序，不按标题/比例二级排序）。
  closure_layers: [code]
  tools: [Read SearchViewModel.kt:104]
  zero_hits: sortedBy 单键 timeMinutes，无 thenBy。

## Same-source cross-reference
- 与 Best match（REQ-027）/ Fewest missing（REQ-029）互斥单选；耗时数据来自菜谱数据（offline-data-SPEC.md）。独立生成。
