# Trace: search-best-match (REQ-027)

> Search Best match 排序。追踪"最佳匹配"排序：按匹配比例降序，再按标题升序。

## Status
status: ok
repo-id: whaticancook
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: Best match chip — SearchScreen.kt:89-94 (SortOption.entries 渲染) — recalled by: both
- Entry 2: Best match 排序逻辑 (build) — SearchViewModel.kt:100-103 — recalled by: path 2

## Entry · 最佳匹配排序
- claim: 选择"Best match"后，结果按匹配比例（已拥有/必需）降序排列；比例相同者按菜谱标题升序排列。该排序为默认排序。
- layers:
  - code: SearchScreen.kt:89-94 (sort chips, selected=state.sort==option) / SearchViewModel.kt:21-25 (RELEVANCE="Best match") / 53 (默认 RELEVANCE) / 100-103 (排序) / CookMatch.kt:81-82 (ratio)
  - resource: N/A
  - manifest: N/A
- interaction: 排序选项存于 SearchViewModel.sort StateFlow，默认 RELEVANCE。
- data_flow: chip onClick → onSortSelected(RELEVANCE) → sort.value → filters → build → sortedWith(compareByDescending{ratio}.thenBy{title}) → results

## 排序逻辑（SearchViewModel.kt:100-103）
```
SortOption.RELEVANCE ->
  items.sortedWith(compareByDescending<RecipeWithMatch>{ it.match.ratio }
                   .thenBy{ it.recipe.title })
```
## ratio 定义（CookMatch.kt:81-82）
```
ratio = if (essentialCount == 0) 1f else haveCount.toFloat() / essentialCount
```
- 即"已拥有/必需"比例；无必需食材的菜谱比例为 1（最高）。

## 验证点
- pantry 含 carrot、green onion、garlic：Chicken Fried Rice 命中 3 个必需 → ratio=3/7≈0.43；其它菜谱命中更少 → ratio 更低 → Chicken Fried Rice 等高比例菜谱排在更前。✅

## Implicit triggers
- Trigger: 点击 Best match chip — onSortSelected(RELEVANCE) — 行为: 结果按比例降序+标题升序重排。
- Trigger: 食材库变化 — observePantry — 行为: ratio 重新计算，Best match 顺序随之变化。

## Core business entities
- SortOption.RELEVANCE: "Best match"，默认排序。
- CookMatch.ratio: 排序键（依赖 match-count）。

## Cross-entry shared declarations
- None。

## Deviations from REQ_DESC
- None。REQ 要求"按匹配比例降序，再按标题排序"，代码 compareByDescending{ratio}.thenBy{title} 一致。

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries
- 搜索页排序 chips SearchScreen.kt:89-94
- Best match 排序 SearchViewModel.kt:100-103

### Consumers
- build: 排序在所有过滤之后应用。

### Non-consumers
- claim: Best match 二级排序为标题升序（thenBy title），非耗时或缺少数；标题比较为默认字符串序（区分大小写的字典序由 Kotlin String 比较）。
  closure_layers: [code]
  tools: [Read SearchViewModel.kt:101-103]
  zero_hits: thenBy{recipe.title} 为标题比较，无其它字段。

## Same-source cross-reference
- ratio 依赖 match-count（REQ-015）；与其它排序（Quickest/Fewest missing）互斥单选。独立生成。
