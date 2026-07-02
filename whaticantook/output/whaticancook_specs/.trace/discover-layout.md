# Code trace · discover-layout

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 首页顶部区 (问候语 + 主标题 + 设置入口) — HomeScreen.kt:94,157-191 — recalled by: both
- Entry 2: 搜索入口条 — HomeScreen.kt:96,193-218 — recalled by: both
- Entry 3: Your pantry 入口卡 — HomeScreen.kt:98,220-266 — recalled by: both
- Entry 4: 空食材提示卡 — HomeScreen.kt:118-120,268-292 — recalled by: both
- Entry 5: 分类筛选区 (Browse recipes + 分类 chips) — HomeScreen.kt:122-143 — recalled by: both
- Entry 6: 菜谱列表区 — HomeScreen.kt:145-153 — recalled by: both
- Entry 7: 底部导航栏 — WccBottomBar.kt:34-59; WccApp.kt:39,43-60 — recalled by: both

## Entry · 首页顶部区 (问候语 + 主标题 + 设置入口)
- claim: 首页顶部展示随时间变化的问候语、主标题"What can I cook?"，以及右上角设置入口
- layers:
  - code:     HomeScreen.kt:94 HomeHeader; HomeScreen.kt:164-168 问候语文本; HomeScreen.kt:169-173 主标题"What can I cook?"; HomeScreen.kt:175-189 设置图标按钮 (点击 onOpenSettings); 问候语来源 HomeViewModel.kt:108-113 greeting()
  - resource: N/A: 文案为代码内字面量
  - manifest: N/A
- interaction: 问候语按当前小时段返回 (HomeViewModel.kt:108-113)：5-11 "Good morning" / 12-16 "Good afternoon" / 17-21 "Good evening" / 其他 "Hungry tonight?"
- data_flow: HomeViewModel.greeting() (HomeViewModel.kt:108) → buildContent greeting (HomeViewModel.kt:99) → HomeUiState.Content.greeting → HomeHeader (HomeScreen.kt:94,165)

## Entry · 搜索入口条
- claim: 顶部下方展示一个搜索样式入口条，文案"Search recipes, ingredients…"，点击进入搜索页
- layers:
  - code:     HomeScreen.kt:96 SearchBarButton(onClick=onOpenSearch); HomeScreen.kt:212-216 文案"Search recipes, ingredients…"; HomeScreen.kt:201 点击 → onOpenSearch
  - resource: N/A
  - manifest: N/A
- interaction: 点击入口条 → onOpenSearch → 路由跳搜索页 (WccApp.kt:94 onOpenSearch={navigateToTab(SEARCH)})
- data_flow: 点击 (HomeScreen.kt:201) → onOpenSearch (HomeScreen.kt:68) → WccApp navigateToTab(SEARCH) (WccApp.kt:94)

## Entry · Your pantry 入口卡
- claim: 中部展示"Your pantry"卡片，副标题随食材数量变化，点击进入食材库页
- layers:
  - code:     HomeScreen.kt:98 PantrySummaryCard(count,onClick); HomeScreen.kt:248 标题"Your pantry"; HomeScreen.kt:252-258 副标题 (count==0 → "Add what you have at home"; 否则 "N ingredient(s) ready"); HomeScreen.kt:227 点击 → onOpenPantry
  - resource: N/A
  - manifest: N/A
- interaction: count 来自 HomeUiState.Content.pantryCount (HomeViewModel.kt:100,86 pantry.size)
- data_flow: pantryRepository.observePantry() (HomeViewModel.kt:71) → pantry.size (HomeViewModel.kt:86) → pantryCount → PantrySummaryCard (HomeScreen.kt:98)；点击 → onOpenPantry (HomeScreen.kt:69) → WccApp navigateToTab(PANTRY) (WccApp.kt:95)

## Entry · 空食材提示卡
- claim: 当无可做菜谱且食材数为 0 时，首页中部展示空食材提示卡，引导用户添加食材
- layers:
  - code:     HomeScreen.kt:118-120 显示条件 (cookNow.isEmpty() && pantryCount==0); HomeScreen.kt:268-292 CookNowPrompt; HomeScreen.kt:281 标题"Tell us what's in your kitchen"; HomeScreen.kt:287 说明"Add a few ingredients and we'll show the recipes you can make right now."; HomeScreen.kt:275 点击 → onOpenPantry
  - resource: N/A
  - manifest: N/A
- interaction: cookNow 为空且 pantryCount==0 才显示；其完整判定逻辑与边界由 `empty-pantry-hint` (REQ-005) 描述
- data_flow: cookNow (HomeViewModel.kt:89-91) 与 pantryCount (HomeViewModel.kt:86) 共同决定显隐 → CookNowPrompt

## Entry · 分类筛选区
- claim: "Browse recipes"标题下方展示"All"加各分类 chip，点击切换分类并刷新列表
- layers:
  - code:     HomeScreen.kt:123 标题"Browse recipes"; HomeScreen.kt:127-133 "All" chip; HomeScreen.kt:134-141 各分类 chip (label+emoji); 点击 onSelectCategory (HomeScreen.kt:131,139)
  - resource: N/A
  - manifest: N/A
- interaction: 分类集合来自 RecipeCategory.entries (HomeViewModel.kt:102)；选中态 selectedCategory (HomeViewModel.kt:43)；筛选交互与结果刷新由 `category-filter` (REQ-007) 描述
- data_flow: onSelectCategory → HomeViewModel.selectCategory (HomeViewModel.kt:58) → selectedCategory → buildContent 筛选 (HomeViewModel.kt:93)

## Entry · 菜谱列表区
- claim: "Browse recipes"区下方以列表展示菜谱卡片，按分类筛选与匹配度排序
- layers:
  - code:     HomeScreen.kt:145-153 items(state.recipes){ RecipeCard(...) }; HomeScreen.kt:149 点击 → onRecipeClick
  - resource: N/A
  - manifest: N/A
- interaction: recipes 来自 HomeViewModel buildContent (HomeViewModel.kt:94-96 筛选+排序)；卡片内容样式由 `recipe-card` (REQ-006) 描述
- data_flow: observeRecipes (HomeViewModel.kt:70) → buildContent 排序 (HomeViewModel.kt:94-96) → state.recipes → RecipeCard 列表

## Entry · 底部导航栏
- claim: 首页（及其他顶级页）底部展示四个导航入口，当前页对应入口高亮并显示文字标签
- layers:
  - code:     WccBottomBar.kt:34-59 WccBottomBar; WccBottomBar.kt:51-57 遍历 TopLevelTab.entries 渲染四项; WccBottomBar.kt:67-78 选中态配色; WccBottomBar.kt:88-97 选中项展开文字标签; 显隐 WccApp.kt:39,43-60 showBottomBar (currentRoute in tabRoutes)
  - resource: N/A
  - manifest: N/A
- interaction: 四个入口 (Destinations.kt:31-34)：DISCOVER"Discover"/SEARCH"Search"/PANTRY"Pantry"/FAVORITES"Saved"；点击 onSelect(tab) → navigate(tab.route) (WccApp.kt:51-57)
- data_flow: currentRoute (WccApp.kt:37) → WccBottomBar currentRoute (WccApp.kt:50) → BottomBarItem selected (WccBottomBar.kt:54) → 高亮+标签展开

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 当前时间变化导致问候语分段切换 — HomeViewModel.kt:108-113 — behavior: 问候语按小时段在"Good morning/afternoon/evening/Hungry tonight?"间取值（取值时机为构建首页内容时读取系统时间）
- Trigger: 食材数量变化 — HomeViewModel.kt:71,86 — behavior: Your pantry 卡副标题与空食材提示卡显隐随之刷新
- Trigger: 菜谱数据装载完成 (seedState=Ready) — HomeViewModel.kt:74-78 — behavior: 由加载态切换为内容态，展示完整布局

## Core business entities (data model / persistence key / state machine)
- Entity: HomeUiState (Loading/Error/Content) — HomeViewModel.kt:21-32；Content 含 greeting/pantryCount/cookNow/categories/selectedCategory/recipes
- Entity: 问候语文案集合 — HomeViewModel.kt:108-113 四段
- Entity: 顶级导航项 TopLevelTab(route,label,icon) — Destinations.kt:26-34，四项
- 依赖来源: recipes 数据源自身特性 `offline-recipes` (REQ-003)；cookNow/匹配计算依赖 CookMatch (见 recipe-card/REQ-006)

## Cross-entry shared declarations
- WccApp.kt:39,43-60 底部导航栏的显隐与挂载，被首页及其他三个顶级页共享
- HomeViewModel.uiState (HomeViewModel.kt:68-79) 为顶部区/pantry 卡/分类区/列表区共用的单一状态源

## Deviations from REQ_DESC
1. REQ_DESC 验收点问候语列为"Good morning/evening"——代码问候语实际有四段：另含"Good afternoon"(12-16 时)与"Hungry tonight?"(夜间) (HomeViewModel.kt:108-113)，需求为简写举例，无冲突
2. REQ_DESC 验收点主标题"What can I cook?"——代码主标题为"What can I cook?"(带问号) (HomeScreen.kt:170)，一致；与引导页无关
3. REQ_DESC 验收点搜索文案"Search recipes, ingredients..."——代码为"Search recipes, ingredients…"(使用省略号字符…) (HomeScreen.kt:213)，语义一致
4. REQ_DESC 列举布局含"空食材提示""分类筛选""菜谱列表"——这些元素在本页确实存在，但其交互/内容的完整行为分别由 REQ-005/REQ-007/REQ-006 独立描述，本规仅覆盖其"存在于首页布局中"

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 首页布局的全部区段已在上文 Entry 1–7 枚举完毕（顶部区、搜索入口、Your pantry 卡、空食材提示卡、分类筛选区、菜谱列表区、底部导航栏）。首页无其他区段
- 额外存在但 REQ-004 未列：首页"Ready to cook"可做菜谱横向卡片区 (HomeScreen.kt:100-117)，仅在 cookNow 非空时显示——属首页布局组成部分，列出以保完整
  layers: code HomeScreen.kt:100-117; resource N/A; manifest N/A
  interaction: cookNow 非空才显示，CompactRecipeCard 横向列表，点击 onRecipeClick

### Consumers (who reads this state / data)
- Consumer: HomeContent 各区段读取 HomeUiState.Content — HomeScreen.kt:78-86
- Consumer: WccBottomBar 读取 currentRoute 决定高亮 — WccApp.kt:37,50

### Non-consumers (boundary counter-examples with evidence)
- claim: 首页布局元素不被其他页面复用承载；问候语、Your pantry 卡、Browse recipes 区等为首页专属
  closure_layers: [code]
  tools: [mcp__homegraph__callers "HomeContent", mcp__homegraph__callers "HomeHeader", Grep "What can I cook" over app/src]
  zero_hits: homegraph__callers "HomeContent" 仅 HomeScreen.kt:65；Grep "What can I cook" 命中 HomeScreen.kt:170 与 :305(加载态) 两处，均在 HomeScreen 内；其他页面零命中

## Same-source cross-reference (if applicable)
- 首页空食材提示卡的完整显隐判定与文案见 `empty-pantry-hint-SPEC.md` (REQ-005)；首页分类筛选交互见 `category-filter-SPEC.md` (REQ-007)；首页菜谱卡片内容见 `recipe-card-SPEC.md` (REQ-006)。本规聚焦首页"包含哪些布局区段及其静态结构"，与上述三规互补不重叠
