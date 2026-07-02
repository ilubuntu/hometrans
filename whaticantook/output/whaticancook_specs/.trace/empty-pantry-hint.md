# Code trace · empty-pantry-hint

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 首页空食材提示卡 (CookNowPrompt) — HomeScreen.kt:268-292 — recalled by: both
- Entry 2: 提示卡显示判定 (cookNow 空 && pantryCount==0) — HomeScreen.kt:118-120; HomeViewModel.kt:86-91 — recalled by: both

## Entry · 首页空食材提示卡 (CookNowPrompt)
- claim: 当无可做菜谱且食材库为空时，首页中部展示空食材提示卡，含标题与说明文案，点击进入食材库页
- layers:
  - code:     HomeScreen.kt:268-292 CookNowPrompt; HomeScreen.kt:281 标题"Tell us what's in your kitchen"; HomeScreen.kt:287 说明"Add a few ingredients and we'll show the recipes you can make right now."; HomeScreen.kt:278 引导图标🧑‍🍳; HomeScreen.kt:275 整卡点击 → onOpenPantry
  - resource: N/A: 文案为代码内字面量
  - manifest: N/A
- interaction: 无持久化写入；点击仅触发路由跳转
- data_flow: 点击卡片 (HomeScreen.kt:275) → onOpenPantry (HomeScreen.kt:69) → WccApp.kt:95 navigateToTab(PANTRY)

## Entry · 提示卡显示判定
- claim: 提示卡仅在"无可做菜谱且食材数为 0"时显示；食材库非空时（即使无可做菜谱）不显示该提示卡
- layers:
  - code:     HomeScreen.kt:118-120 `if (cookNow.isNotEmpty()) {...} else if (pantryCount==0) { CookNowPrompt }`; HomeViewModel.kt:89-91 cookNow 计算 (`filter{isCookable && pantryNames.isNotEmpty()}`); HomeViewModel.kt:86 pantryCount=pantry.size
  - resource: N/A
  - manifest: N/A
- interaction: cookNow 为空是必要条件；pantryCount==0 是另一必要条件，二者均满足才显示
- data_flow: pantryRepository.observePantry() (HomeViewModel.kt:71) → pantry → pantryNames (HomeViewModel.kt:86) → cookNow 过滤 (HomeViewModel.kt:89-91) → cookNow.isEmpty() && pantryCount==0 (HomeScreen.kt:118) → 显示 CookNowPrompt

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 食材库变为空 (pantry.size==0) — HomeViewModel.kt:86 — behavior: pantryCount 归 0，且 cookNow 因 pantryNames 空而为空，触发提示卡显示
- Trigger: 食材库由空变为非空 — HomeViewModel.kt:86 — behavior: pantryCount>0，提示卡消失（即使暂无可做菜谱也不再显示该提示卡）
- Trigger: 菜谱数据装载完成进入内容态 — HomeViewModel.kt:74-78 — behavior: 才开始计算 cookNow 并据判定显示/隐藏提示卡

## Core business entities (data model / persistence key / state machine)
- Entity: cookNow: List<RecipeWithMatch> — HomeViewModel.kt:89-91，仅含 isCookable 且 pantryNames 非空的菜谱；空食材库时恒为空
- Entity: pantryCount: Int — HomeViewModel.kt:86，pantry.size
- 依赖来源: 食材库数据源自身特性 `pantry-layout` 等 (REQ-008 起)；cookNow 的可做判定依赖 CookMatch.isCookable

## Cross-entry shared declarations
- HomeViewModel.uiState (HomeViewModel.kt:68-79): cookNow 与 pantryCount 同源于此状态，提示卡显示判定消费这两个字段
- HomeScreen.kt:118-120: 提示卡显示分支与"Ready to cook"分支互斥（同一 if-else if 链）

## Deviations from REQ_DESC
1. REQ_DESC 称"当 pantry 没有食材时... 提示"——代码判定为"cookNow 空 && pantryCount==0"两个条件；因空食材库必然导致 cookNow 空，二者对"空食材库"情形等价，无冲突
2. REQ_DESC 未提及"食材库非空但无可做菜谱"的情形——代码此时既不显示"Ready to cook"也不显示空食材提示卡（HomeScreen.kt:118 仅 else if pantryCount==0），属边界补充：该情形下首页中部不出现任何提示
3. REQ_DESC 验收文案两条与代码完全一致 (HomeScreen.kt:281,287)，无冲突

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- Entry 重复: 空食材提示卡在全应用中仅首页一处承载 (HomeScreen.kt:119)；无其他页面/弹窗展示该提示
  layers: code HomeScreen.kt:118-120,268-292; resource N/A; manifest N/A
  interaction/data_flow: 同 Entry · 提示卡显示判定 + Entry · 首页空食材提示卡

### Consumers (who reads this state / data)
- Consumer: HomeContent 读取 cookNow 与 pantryCount 决定提示卡显隐 — HomeScreen.kt:118

### Non-consumers (boundary counter-examples with evidence)
- claim: 搜索页/食材库页/收藏页/详情页/设置页均不展示也不响应首页空食材提示
  closure_layers: [code]
  tools: [mcp__homegraph__callers "CookNowPrompt", Grep "Tell us what" over app/src]
  zero_hits: homegraph__callers "CookNowPrompt" 仅 HomeScreen.kt:119；Grep "Tell us what" 命中仅 HomeScreen.kt:281，其他页面零命中
- claim: 该提示卡无"食材库非空但无可做菜谱"情形的兜底文案
  closure_layers: [code]
  tools: [Read HomeScreen.kt:118-120]
  zero_hits: HomeScreen.kt:118-120 仅 `if(cookNow.isNotEmpty())...else if(pantryCount==0){CookNowPrompt}`，无第三个分支

## Same-source cross-reference (if applicable)
- 本 REQ 的空食材提示卡是首页布局的一个区段，其"存在于首页"由 `discover-layout-SPEC.md` (REQ-004) 描述；本规聚焦"何时显示、显示什么文案、点击去向"。两规互补不重叠
