# Trace: add-missing (REQ-018)

> 可一键补齐缺少食材。追踪详情页"补齐缺少食材"操作：把缺少的必需食材批量加入食材库并实时刷新匹配状态。

## Status
status: ok
repo-id: whaticancook
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 详情页补齐按钮 (CookStatusSection 非 isCookable 分支) — RecipeDetailScreen.kt:283-288 — recalled by: both

## Entry · 一键补齐缺少食材
- claim: 缺少必需食材时，详情页提供"补齐缺少食材"操作；点击后把所缺的全部必需食材批量加入食材库（分类为"其他"），匹配状态实时刷新为"食材已齐"。
- layers:
  - code: RecipeDetailScreen.kt:284-288 (WccPrimaryButton "Add missing to pantry") / RecipeDetailViewModel.kt:71-75 (addMissingToPantry) / PantryRepositoryImpl.kt:30-39 (add)
  - resource: N/A: 纯 Compose，无独立资源
  - manifest: N/A
- interaction: 持久化写入 PantryItemEntity（name=归一化名, category=OTHER, addedAt=当前时间戳）至 pantryDao.upsert。
- data_flow: 按钮 onClick → onAddMissing → viewModel.addMissingToPantry(match.missing) → missing.forEach{ pantryRepository.add(it.name, OTHER) } → normalize(name) → pantryDao.upsert(PantryItemEntity) → observePantry 发新值 → matchAgainst 重新计算 → missing 变空 → isCookable=true → 详情页切换为完成态

## 关键实现细节
- addMissingToPantry 入参为 match.missing（未被满足的必需食材列表），逐项 add，name 取食材名（如 "rice"），category 硬编码为 OTHER（RecipeDetailViewModel.kt:73）。
- add 内部对 name 归一化（IngredientMatching.normalize），空白则跳过，否则 upsert（PantryRepositoryImpl.kt:31-38）。
- upsert 为新增或更新（同名覆盖），故重复点击不会产生重复条目。

## Implicit triggers
- Trigger: 补齐写入完成后 observePantry 下发新食材集合 — 行为: 详情页 match 重新计算，缺少集合清空，由缺少态切换为完成态（见 REQ-016）。

## Core business entities
- CookMatch.missing: 补齐操作的数据源（补齐范围）。
- PantryItemEntity: 写入目标实体（name/category/addedAt）。
- 依赖 match-count（REQ-015）/ missing-status（REQ-017）。

## Cross-entry shared declarations
- None。

## Deviations from REQ_DESC
- None。REQ 要求"点击后缺少食材加入食材库并刷新为可做"，代码 addMissingToPantry + 响应式流一致。

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries
- 详情页 RecipeDetailScreen.kt:283-288 — 唯一入口（仅在缺少态显示该按钮）

### Consumers
- RecipeDetailViewModel.addMissingToPantry: 调用 pantryRepository.add 批量写入。

### Non-consumers
- claim: "补齐"仅作用于必需食材（match.missing），不含缺少的可选食材（missingOptional）；可选食材不参与补齐。
  closure_layers: [code]
  tools: [Read RecipeDetailViewModel.kt:71-75]
  zero_hits: addMissingToPantry(missing) 入参为 match.missing，未传入 missingOptional。

## Same-source cross-reference
- 补齐操作仅在缺少态出现（REQ-017 missing-status）；补齐后切换为可做态（REQ-016 ready-status）。独立生成。
