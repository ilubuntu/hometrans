# Code trace · search-cookable

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: "Cookable"切换项开关 — SearchScreen.kt:82-87 (Cookable chip) + SearchViewModel.kt:69 (onCookableToggle) — recalled by: both
- Entry 2: 可做判定逻辑 — CookMatch.kt:72-83 (status/isCookable) + CookMatch.kt:86-104 (matchAgainst) — recalled by: path 1

## Entry · "Cookable"切换项开关
- claim: 用户点击"Cookable"切换项，在选中/未选中间切换；选中时结果列表只展示当前食材库已满足全部必需食材的菜谱（即可做菜谱）
- layers:
  - code:     SearchScreen.kt:82-87 Cookable chip label="Cookable" leadingEmoji="✅" selected=state.cookableOnly onClick=onCookableToggle；SearchViewModel.kt:69 onCookableToggle = cookableOnly.value=!cookableOnly.value；SearchViewModel.kt:96-98 if(f.cookableOnly) items=items.filter{it.match.isCookable}
  - resource: N/A
  - manifest: N/A
- interaction: 读 state.cookableOnly 渲染选中态；写 cookableOnly 流取反（SearchViewModel.kt:52,69）；过滤结果写入 state.results（SearchViewModel.kt:116）
- data_flow: 点击 → onCookableToggle（SearchViewModel.kt:69）→ cookableOnly 取反 → combine → build → 文本过滤(84-92)→分类过滤(93-95)→可做过滤(96-98: match.isCookable)→排序→results → SearchScreen.kt:113 列表刷新

## Entry · 可做判定逻辑
- claim: 菜谱"可做"判定为：该菜谱的"必需"食材全部被当前食材库满足（缺少的必需食材列表为空）；无必需食材的菜谱也算可做
- layers:
  - code:     CookMatch.kt:78 isCookable = (status==READY)；CookMatch.kt:72-76 status：essentialCount==0 || missing.isEmpty() → READY；CookMatch.kt:86-104 matchAgainst 遍历 ingredients，essential 且未满足 → missing；CookMatch.kt:81-82 ratio=haveCount/essentialCount
  - resource: N/A
  - manifest: N/A
- interaction: 计算用 pantryNames（SearchViewModel.kt:79 pantry.map{name}）与 recipe.ingredients 比对（CookMatch.kt:91-98）
- data_flow: SearchViewModel.kt:82 recipe.matchAgainst(pantryNames) → CookMatch(haveCount,essentialCount,missing,...) → isCookable(SearchViewModel.kt:97 过滤用)

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 食材库增删/清空/补齐 — SearchViewModel.kt:61 (observePantry) — behavior: 重新 matchAgainst，各菜谱 isCookable 重新判定；开启 Cookable 时结果列表随之增减
- Trigger: 菜谱数据初始化完成 — RecipeRepositoryImpl.kt:47 — behavior: 首次加载后可做判定才生效

## Core business entities (data model / persistence key / state machine)
- Entity: SearchUiState.cookableOnly — SearchViewModel.kt:31：可做筛选开关，默认 false
- Entity: CookMatch.isCookable — CookMatch.kt:78：status==READY 即可做
- Entity: CookMatch.status 三态机 — CookMatch.kt:72-76：essentialCount==0 或 missing 空 → READY；missing.size≤2 → ALMOST；否则 EXPLORE
- Entity: CookMatch.missing — CookMatch.kt:69,94-95：必需且未满足的食材列表；missing 空 = 全部必需食材已满足
- Entity: RecipeIngredient.essential — Recipe.kt:8：true=必需，参与可做判定；false=可选，不参与
- 依赖来源: 食材库来自 pantry 系列 (REQ-008+)；菜谱数据来自 offline-recipes (REQ-003)

## Cross-entry shared declarations
- 可做过滤与文本过滤、分类过滤、排序在同一 build() 内串行叠加（SearchViewModel.kt:84-108）
- CookMatch.isCookable / matchAgainst 为首页"Ready to cook"、详情页可做态、可做过滤共用（CookMatch.kt:78,86）

## Deviations from REQ_DESC
1. REQ_DESC 称"Cookable 筛选只展示当前 pantry 已满足必需食材的菜谱"——代码 isCookable=READY=(essentialCount==0||missing.isEmpty())，即"无必需食材"也算可做（CookMatch.kt:73）。若存在无必需食材的菜谱，空食材库下开启 Cookable 仍会展示这类菜谱；当前内置菜谱均含必需食材，故空食材库时 Cookable 结果为空，与需求验收"空 pantry 时 Cookable 结果为空"一致
2. REQ_DESC 验收"补齐后展示可做菜谱"——补齐某菜谱全部必需食材后 missing 空 → isCookable → 展示，一致

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 搜索页"Cookable"切换项 — SearchScreen.kt:82-87 + SearchViewModel.kt:69,96-98 — 本 REQ 主体
- 搜索结果列表刷新 — SearchScreen.kt:108-122 — 可做过滤结果展示

### Consumers (who reads this state / data)
- Consumer: SearchScreen Cookable chip 读取 state.cookableOnly 渲染选中态 — SearchScreen.kt:85
- Consumer: SearchViewModel.build 读取 f.cookableOnly 执行过滤 — SearchViewModel.kt:96
- Consumer: 首页"Ready to cook"区复用 match.isCookable 选可做菜谱 — HomeViewModel

### Non-consumers (boundary counter-evidence)
- claim: "Cookable"开关不影响排序与分类——三者各自独立 state
  closure_layers: [code]
  tools: [Read SearchViewModel.kt:50-53]
  zero_hits: cookableOnly、category、sort 为独立流，互不读写
- claim: 收藏页无"Cookable"开关——收藏页不提供可做筛选
  closure_layers: [code]
  tools: [Read FavoritesScreen.kt]
  zero_hits: FavoritesScreen.kt 全文无 Cookable/cookableOnly 引用

## Same-source cross-reference (if applicable)
- 可做判定三态机（可做/接近可做/探索）与详情页可做(REQ-016)/缺少(REQ-017)状态、首页"Ready to cook"区共用同一 CookMatch 模型；可做态详情见 cookable-ready-SPEC.md
- 搜索页"Cookable"切换项位置见 search-layout-SPEC.md（REQ-023）
