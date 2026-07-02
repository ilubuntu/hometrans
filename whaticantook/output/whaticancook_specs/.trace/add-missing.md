# Code trace · add-missing

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 详情页"一键补齐缺少食材"按钮 (Add missing to pantry) — RecipeDetailScreen.kt:284-288 — recalled by: both
- Entry 2: 补齐写入动作 — RecipeDetailViewModel.addMissingToPantry (RecipeDetailViewModel.kt:71-75) + PantryRepositoryImpl.add (PantryRepositoryImpl.kt:30-41) — recalled by: path 2

## Entry · 详情页"一键补齐缺少食材"按钮
- claim: 当某菜谱存在缺少的必需食材时，详情页状态区底部提供"一键补齐"按钮，点击后把全部缺少的必需食材一次性加入食材库
- layers:
  - code:     RecipeDetailScreen.kt:252-289 非可做分支容器内；RecipeDetailScreen.kt:283-288 WccPrimaryButton(text="Add missing to pantry", onClick=onAddMissing, fillMaxWidth)；RecipeDetailScreen.kt:80 onAddMissing 绑定 viewModel.addMissingToPantry(s.match.missing)
  - resource: N/A: 按钮文案为代码内固定字符串
  - manifest: N/A
- interaction: 点击 → addMissingToPantry(match.missing) (RecipeDetailViewModel.kt:71)，待补集合 = match.missing（仅必需且未满足）；可做态下按钮不渲染(整个非可做分支不进入)
- data_flow: 按钮 onClick (RecipeDetailScreen.kt:286) → onAddMissing (RecipeDetailScreen.kt:90) → RecipeDetailViewModel.addMissingToPantry(missing) (RecipeDetailViewModel.kt:71) → missing.forEach{pantryRepository.add(name, OTHER)} (RecipeDetailViewModel.kt:73) → PantryRepositoryImpl.add (PantryRepositoryImpl.kt:30)

## Entry · 补齐写入动作
- claim: 补齐动作遍历每个缺少的必需食材，归一化名称后写入食材库持久化
- layers:
  - code:     RecipeDetailViewModel.kt:71-75 addMissingToPantry：missing.forEach{ pantryRepository.add(it.name, IngredientCategory.OTHER) }；PantryRepositoryImpl.kt:30-41 add：IngredientMatching.normalize(name) 后若非空 → pantryDao.upsert(PantryItemEntity(name=normalized, category="OTHER", addedAt))
  - resource: N/A
  - manifest: N/A
- interaction: 写入食材库表(pantry)；每项分类固定为 OTHER(IngredientCategory.OTHER, "Other")；名称先经 normalize(大小写/复数/同义词归一)；空名跳过
- data_flow: addMissingToPantry → pantryRepository.add → PantryRepositoryImpl.add (normalize→upsert) → pantryDao.upsert → observePantry 发射 → RecipeDetailViewModel.uiState combine 重算 matchAgainst → missing 空 → isCookable → 详情页转可做态

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 补齐写入完成触发食材库变化 — PantryRepositoryImpl.kt:33 upsert → pantryDao.observeAll 发射 — behavior: 详情页重算 match，缺少项清空，状态从"缺少 N"切换为"准备就绪"，缺少列表与补齐按钮消失
- Trigger: 按钮仅存在于非可做态 — RecipeDetailScreen.kt:252 — behavior: 可做态下不渲染按钮，无法再次触发

## Core business entities (data model / persistence key / state machine)
- Entity: match.missing — CookMatch.kt:69：补齐的目标集合（必需且未满足）
- Entity: PantryItemEntity(name, category, addedAt) — 补齐写入的持久化行；category 固定 "OTHER"
- Entity: IngredientCategory.OTHER — IngredientCategory.kt:12：补齐项的默认分类("Other")
- Entity: IngredientMatching.normalize — CookMatch.kt:43-49：写入前对名称归一(小写/去标点/同义词映射)
- 依赖来源: 待补集合来自 missing-ingredients(REQ-017) 的 match.missing；补齐后状态展示见 cookable-ready(REQ-016)

## Cross-entry shared declarations
- 补齐按钮与"缺少标题/缺少列表"同处 CookStatusSection 非可做分支 (RecipeDetailScreen.kt:252-290)，四者同源 match.missing
- 补齐写入复用 pantry 添加链路(pantryRepository.add)，与 pantry 手动添加/快速添加(REQ-009/010)同库同表

## Deviations from REQ_DESC
1. REQ_DESC 称"把缺少的必需食材加入 pantry，状态从缺少变为 You're all set"——代码链路完全一致：add(missing) → 重算 → isCookable → 可做提示框(RecipeDetailScreen.kt:80,228,241)，无偏差
2. REQ_DESC 未提及补齐项分类——代码将补齐项统一归类为 "Other"(IngredientCategory.OTHER)，而非按食材原始分类(如 Rice 归 Grains) (RecipeDetailViewModel.kt:73)，属实现细节，记为偏差：补齐项在食材库的分组为"Other"
3. REQ_DESC 未提及名称归一化——补齐写入前对名称做 normalize(小写/同义词)，与食材库其他添加入口一致(PantryRepositoryImpl.kt:31)，记为细节行为

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 详情页"一键补齐缺少食材"按钮 — RecipeDetailScreen.kt:284-288 — 本 REQ 唯一入口
- 补齐写入链路 — RecipeDetailViewModel.kt:71-75 → PantryRepositoryImpl.add:30-41 — 本 REQ 写入动作

### Consumers (who reads this state / data)
- Consumer: 按钮 onClick 读取 match.missing 作为待补集合 — RecipeDetailScreen.kt:80
- Consumer: pantryDao.observeAll 读取补齐写入后的最新食材库 — 重算 matchAgainst

### Non-consumers (boundary counter-examples with evidence)
- claim: 补齐按钮仅在详情页非可做态出现；首页/搜索/收藏页卡片无补齐按钮；可做态详情页也无补齐按钮
  closure_layers: [code]
  tools: [Grep "Add missing|addMissingToPantry" over app/src/main, Read RecipeDetailScreen.kt:226-291]
  zero_hits: "Add missing to pantry"/"addMissingToPantry" 在 RecipeDetailScreen.kt:284,286 与 RecipeDetailViewModel.kt:71 出现，全文仅详情页非可做分支(CookStatusSection else)引用；RecipeCard.kt/HomeScreen.kt/SearchScreen.kt/FavoritesScreen.kt 命中 0；RecipeDetailScreen.kt:228 cookable 分支内无按钮

## Same-source cross-reference (if applicable)
- 补齐目标集合来自 missing-ingredients(REQ-017) 的 match.missing；补齐后状态展示见 cookable-ready(REQ-016)；本规聚焦"一键补齐按钮与写入动作"
