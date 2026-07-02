# Code trace · detail-steps

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 步骤进度计数与进度条 — RecipeDetailScreen.kt:343-371 (StepsSection 标题计数 + 进度条) — recalled by: both
- Entry 2: 步骤行勾选切换 — RecipeDetailScreen.kt:373-419 (步骤行) + RecipeDetailScreen.kt:175-177 (onToggle) + RecipeDetailScreen.kt:94 (completedSteps 本地状态) — recalled by: both

## Entry · 步骤进度计数与进度条
- claim: 详情页步骤区标题右侧显示"已完成数/总步骤数"计数，下方进度条按比例填充
- layers:
  - code:     RecipeDetailScreen.kt:337-342 StepsSection 入参(steps, completed, onToggle)；RecipeDetailScreen.kt:339-342 progress=animateFloatAsState(steps.isEmpty()?0f:completed.size/steps.size)；RecipeDetailScreen.kt:344-354 标题"Steps"+计数"${completed.size}/${steps.size}"(primary 色)；RecipeDetailScreen.kt:357-371 进度条：底轨道(surfaceVariant)+填充(fillMaxWidth(progress), primary)
  - resource: N/A
  - manifest: N/A
- interaction: 计数与进度条读 completed.size 与 steps.size；completed 为本地可变列表
- data_flow: DetailContent.completedSteps (RecipeDetailScreen.kt:94) → StepsSection(completed) → 计数/进度条渲染

## Entry · 步骤行勾选切换
- claim: 每个步骤可逐个点击勾选/取消，勾选后该行显示已完成样式（勾选图标+删除线），计数与进度条随之变化
- layers:
  - code:     RecipeDetailScreen.kt:94 completedSteps=remember(recipe.id){mutableStateListOf<Int>()}（按 recipe.id 记忆的本地状态）；RecipeDetailScreen.kt:172-178 StepsSection 调用，onToggle=若 contains 则 remove 否则 add；RecipeDetailScreen.kt:373-419 步骤行：bounceClick→onToggle(index)；RecipeDetailScreen.kt:383-407 左侧圆圈 done→primary+Check 图标 / 否则 surface+序号(index+1)；RecipeDetailScreen.kt:409-417 文本 done→LineThrough+onSurfaceVariant / 否则正常
  - resource: N/A
  - manifest: N/A
- interaction: 点击步骤行切换 completed 列表成员；completed 仅存于内存，未持久化；recipe.id 变化(切换菜谱/重进详情)时 completedSteps 重建为空
- data_flow: 步骤行 onClick → onToggle(index) (RecipeDetailScreen.kt:379) → completedSteps.add/remove (RecipeDetailScreen.kt:176) → 计数与进度条重算

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 切换菜谱/重进详情页 — RecipeDetailScreen.kt:94 remember(recipe.id) — behavior: completedSteps 随 recipe.id 变化重建为空，进度归零（步骤进度不跨页面保留）
- Trigger: None（步骤勾选纯本地交互，不依赖食材库或网络）

## Core business entities (data model / persistence key / state machine)
- Entity: completedSteps — RecipeDetailScreen.kt:94：mutableStateListOf<Int>，按 recipe.id 记忆的本地已完成步骤索引集合；非持久化
- Entity: Recipe.steps — Recipe.kt:32：List<String>，做菜步骤文案
- 依赖来源: 步骤文案来自菜谱数据(offline-recipes, REQ-003)

## Cross-entry shared declarations
- StepsSection (RecipeDetailScreen.kt:337-420) 为详情页步骤区独立区块，与基础信息区(REQ-020)/食材清单区(REQ-021)/状态区(REQ-016/017)并列，无跨区共享状态

## Deviations from REQ_DESC
1. REQ_DESC 验收"步骤计数从 0/N 变为 1/N，取消后恢复"——代码 onToggle 增删 completed 索引 (RecipeDetailScreen.kt:176)，计数 "${completed.size}/${steps.size}" 随之在 0/N↔1/N 间切换，进度条同步，与验收完全一致，无偏差
2. REQ_DESC 未提及步骤进度持久化——代码 completedSteps 为本地内存状态(remember(recipe.id){mutableStateListOf})，离开详情页或切换菜谱后进度归零，不跨次保留。记为偏差/限制：步骤勾选进度不持久化
3. REQ_DESC 未提及空步骤边界——steps.isEmpty() 时进度 target=0f(RecipeDetailScreen.kt:340)，计数显示"0/0"，无步骤行，属边界行为，已记入 Entry 1

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 步骤进度计数与进度条 — RecipeDetailScreen.kt:343-371 — 本 REQ 主体
- 步骤行勾选切换 — RecipeDetailScreen.kt:373-419 — 本 REQ 主体

### Consumers (who reads this state / data)
- Consumer: 计数 Text 读取 completed.size/steps.size — RecipeDetailScreen.kt:351
- Consumer: 进度条读取 progress(由 completed.size 派生) — RecipeDetailScreen.kt:366
- Consumer: 步骤行读取 completed.contains(index) 决定 done 样式 — RecipeDetailScreen.kt:374

### Non-consumers (boundary counter-evidence with evidence)
- claim: 步骤勾选进度不持久化、不上传、不影响其他页面；离开详情页即丢失
  closure_layers: [code]
  tools: [Grep "completedSteps|stepProgress" over app/src/main, Read RecipeDetailScreen.kt:94,172-178]
  zero_hits: "completedSteps" 仅在 RecipeDetailScreen.kt:94(声明)/176(add/remove) 出现；无任何持久化(数据库/配置存储)写入；RecipeDetailViewModel.kt 无 steps 相关字段；其他页面(Home/Search/Pantry)命中 0

## Same-source cross-reference (if applicable)
- None：步骤区为详情页独立交互区块，与其他匹配/食材需求无共享状态
