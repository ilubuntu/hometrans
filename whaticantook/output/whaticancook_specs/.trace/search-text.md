# Trace: search-text (REQ-024)

> Search 文本搜索。追踪搜索词输入后按标题/分类/标签/食材进行子串过滤。

## Status
status: ok
repo-id: whaticancook
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 搜索框输入 (WccSearchField) — SearchScreen.kt:49-52 — recalled by: both
- Entry 2: 文本过滤逻辑 (build) — SearchViewModel.kt:80-92 — recalled by: path 2

## Entry · 文本搜索过滤
- claim: 用户在搜索框输入词后，结果按菜谱标题、分类名、标签、食材名做子串（包含）匹配过滤，大小写不敏感、自动去首尾空格。
- layers:
  - code: SearchScreen.kt:49-52 (WccSearchField value=state.query, onValueChange=onQueryChange) / SearchViewModel.kt:67 (onQueryChange) / 80-92 (过滤)
  - resource: N/A
  - manifest: N/A
- interaction: 查询词存于 SearchViewModel.query StateFlow；无持久化。
- data_flow: WccSearchField 输入 → onQueryChange → query.value → filters combine → build → q=query.trim().lowercase() → 非空时 filter(title/category/tags/ingredients contains q) → results

## 过滤逻辑（SearchViewModel.kt:80-92）
```
q = query.trim().lowercase()
if (q.isNotEmpty()):
  items = items.filter {
    recipe.title.lowercase().contains(q) ||
    recipe.category.label.lowercase().contains(q) ||
    recipe.tags.any { it.lowercase().contains(q) } ||
    recipe.ingredients.any { it.name.lowercase().contains(q) }
  }
```
- 空查询（含纯空格）→ 不过滤，展示全部。
- 子串包含（contains），非精确/前缀匹配。

## 验证点
- 搜索 "rice"：Chicken Fried Rice 标题含 "rice" → 命中。✅
- 搜索 "yogurt"：Honey Yogurt Parfait（berry-yogurt-parfait，食材含 yogurt，recipes.json:375）+ Mango Lassi（mango-lassi，食材含 yogurt，recipes.json:449）→ 命中两个。✅

## Implicit triggers
- Trigger: 搜索框文本变化 — onQueryChange — 行为: 实时重新过滤（响应式）。
- Trigger: 食材库/菜谱变化 — observeRecipes/observePantry — 行为: 在当前查询词下重新过滤。

## Core business entities
- SearchUiState.query: 当前查询词。
- 依赖 Recipe 字段（title/category/tags/ingredients）。

## Cross-entry shared declarations
- None。

## Deviations from REQ_DESC
- None。REQ 要求"按标题、分类、标签、食材匹配过滤"，代码四个维度 contains 过滤一致。

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries
- 搜索框 SearchScreen.kt:49-52 — 唯一文本输入入口
- 过滤逻辑 SearchViewModel.kt:80-92

### Consumers
- build: 文本过滤后接分类/Cookable/排序（组合生效）。

### Non-consumers
- claim: 文本匹配为子串包含，不做分词/模糊/语音匹配；匹配域为标题/分类名/标签/食材名四项，不含简介(description)与步骤(steps)。
  closure_layers: [code]
  tools: [Read SearchViewModel.kt:84-91]
  zero_hits: 过滤条件仅 title/category.label/tags/ingredients.name 四项 contains；description/steps 未参与。

## Same-source cross-reference
- 文本搜索与分类筛选/Cookable/排序可叠加（均在 build 内顺序应用）。分别见 search-category/search-cookable/search-* 规格。独立生成。
