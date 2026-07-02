# Code trace · bottom-nav

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 底部导航栏整体（四个一级入口） — app/src/main/java/com/whaticancook/app/navigation/WccBottomBar.kt:33 — recalled by: path 1 (search "BottomBar")
- Entry 2: 单个导航项（高亮 + 点击切换） — app/src/main/java/com/whaticancook/app/navigation/WccBottomBar.kt:62 (BottomBarItem) — recalled by: path 1
- Entry 3: 导航切换逻辑（切换 tab、保留各 tab 状态） — app/src/main/java/com/whaticancook/app/navigation/WccApp.kt:49-58 — recalled by: path 2 (callees of onSelect)

## Entry · 底部导航栏展示四个一级入口
- claim: 应用在四个一级页面（首页/搜索/食材库/收藏）上展示一条底部导航栏，按顺序包含 Discover、Search、Pantry、Saved 四个入口。
- layers:
  - code:     app/src/main/java/com/whaticancook/app/navigation/WccBottomBar.kt:33-59 (WccBottomBar 遍历 TopLevelTab.entries 渲染 BottomBarItem)；TopLevelTab 四个成员定义于 app/src/main/java/com/whaticancook/app/navigation/Destinations.kt:31-34：DISCOVER(route=HOME,label="Discover")、SEARCH(route=SEARCH,label="Search")、PANTRY(route=PANTRY,label="Pantry")、FAVORITES(route=FAVORITES,label="Saved")
  - resource: N/A: 图标为代码内 Icons.Rounded.Restaurant/Search/Kitchen/BookmarkBorder (Destinations.kt:31-34)，无 res/menu 或 res/drawable
  - manifest: N/A: 底部导航为应用内组合 UI，无 manifest 声明
- interaction: 仅当当前路由属于四个一级 tab 路由集合时才展示导航栏 (WccApp.kt:38-39 showBottomBar = currentRoute in tabRoutes)；展示/隐藏带纵向滑入滑出与淡入淡出过渡 (WccApp.kt:44-48)。
- data_flow: 当前路由来自 currentBackStackEntryAsState (WccApp.kt:36-37) → 判定 showBottomBar → AnimatedVisibility → WccBottomBar。

## Entry · 当前入口高亮
- claim: 底部导航栏中与当前所在页面对应的入口处于选中高亮状态（高亮底色 + 高亮图标颜色 + 展开显示入口文字），其余三个为未选中状态（透明底 + 弱化色 + 不显示文字）。
- layers:
  - code:     app/src/main/java/com/whaticancook/app/navigation/WccBottomBar.kt:62-98 (BottomBarItem)；selected = currentRoute == tab.route (WccBottomBar.kt:54)；选中时 bg=primaryContainer、fg=onPrimaryContainer、文字经 AnimatedVisibility(expandHorizontally+fadeIn) 展开 (WccBottomBar.kt:67-97)
  - resource: N/A
  - manifest: N/A
- interaction: 颜色经 animateColorAsState 过渡 (WccBottomBar.kt:67-78)；选中项文字展开/未选中项文字收起均带过渡动画。
- data_flow: currentRoute (WccApp.kt:50) → 各 BottomBarItem selected 判定 → 颜色与文字显隐刷新。

## Entry · 点击入口切换到对应页面（保留各 tab 状态）
- claim: 点击底部任一入口，切换到该入口对应的页面；各一级页面之间的浏览状态（如已选分类、搜索词、列表位置）相互独立保留，重新切回时恢复。
- layers:
  - code:     app/src/main/java/com/whaticancook/app/navigation/WccApp.kt:49-58 (onSelect → navController.navigate(tab.route) { popUpTo(HOME){saveState=true}; launchSingleTop=true; restoreState=true })
  - resource: N/A
  - manifest: N/A
- interaction: 切换时 saveState=true 保留原 tab 栈状态、restoreState=true 恢复目标 tab 栈状态、launchSingleTop=true 避免重复创建同一 tab 实例 (WccApp.kt:52-56)；这是"切回时恢复浏览状态"的实现点。
- data_flow: 点击 BottomBarItem.bounceClick (WccBottomBar.kt:83) → onSelect(tab) (WccBottomBar.kt:55) → WccApp navigate(tab.route) (WccApp.kt:52) → 目标 tab composable 渲染（HOME→HomeScreen，SEARCH→SearchScreen，PANTRY→PantryScreen，FAVORITES→FavoritesScreen，WccApp.kt:91-115）。

## Implicit triggers (non-UI state changes that activate this feature)
- 触发: 当前路由变化（如从二级页面返回到一级 tab） — currentRoute 改变会重新判定 showBottomBar 与选中高亮 (WccApp.kt:36-39, 50)，无需用户点击导航栏。这是"从详情页/设置页返回后底部导航栏重新出现且正确高亮"的隐式触发。

## Core business entities (data model / persistence key / state machine)
- TopLevelTab 枚举: app/src/main/java/com/whaticancook/app/navigation/Destinations.kt:26-35 — 四个一级 tab，每个含 route/label/icon。
- 路由常量: Destinations.kt:11-23 (HOME/SEARCH/PANTRY/FAVORITES/SETTINGS/RECIPE_DETAIL 等)。
- 一级 tab 路由集合 tabRoutes: WccApp.kt:38 (TopLevelTab.entries.map{it.route}.toSet()) — 用于判定底部栏显隐。

## Cross-entry shared declarations
- None（底部导航栏无 manifest/build 跨条目声明；nav 目的地 Routes.* 定义于 Destinations.kt:11-23，已在各 Entry manifest 字段以 N/A 注明原因）

## Deviations from REQ_DESC
1. REQ_DESC 要求"四个底部导航入口 Discover、Search、Pantry、Saved"。代码四个入口标签与路由完全一致 (Destinations.kt:31-34)。无冲突。
2. REQ_DESC 称"返回后保持上一页状态"。底部导航层面，代码通过 saveState/restoreState 保留各 tab 之间状态 (WccApp.kt:53-56)。属实现确认，与需求一致。（详情页/设置页的返回行为归 REQ-041）
3. REQ_DESC 未提及底部导航栏在二级页面（详情页/设置页/引导页）的显隐；代码在非一级 tab 路由上自动隐藏导航栏 (WccApp.kt:38-39)。属补充说明，非冲突。

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 底部导航栏展示四入口：见 Entry · 底部导航栏展示四个一级入口
- 当前入口高亮：见 Entry · 当前入口高亮
- 点击切换并保留状态：见 Entry · 点击入口切换到对应页面（保留各 tab 状态）

### Consumers (who reads this state / data)
- Consumer: WccBottomBar（读 currentRoute 决定高亮） — app/src/main/java/com/whaticancook/app/navigation/WccApp.kt:50
- Consumer: WccApp（读 currentRoute 决定导航栏显隐） — app/src/main/java/com/whaticancook/app/navigation/WccApp.kt:39

### Non-consumers (boundary counter-examples with evidence)
- claim: 底部导航仅切换四个一级页面；不提供进入"菜谱详情页""设置页""引导页"的入口
  - closure_layers: [code, resource, manifest]
  - tools: [homegraph_node "TopLevelTab" projectPath, Grep "TopLevelTab" over app/src]
  - zero_hits: TopLevelTab.entries 仅 4 个成员 DISCOVER/SEARCH/PANTRY/FAVORITES (Destinations.kt:31-34)；Grep "TopLevelTab" 命中仅 Destinations.kt 与 WccApp.kt/WccBottomBar.kt；详情路由 RECIPE_DETAIL、SETTINGS、ONBOARDING 均不在 tabRoutes 集合，故底部栏在这些页面隐藏且无对应入口

## Same-source cross-reference (if applicable)
- 底部导航的"返回后恢复状态"与 `back-navigation-SPEC.md`（REQ-041，二级页面返回）互补：本 SPEC 覆盖一级 tab 之间的切换与状态保留，`back-navigation-SPEC.md` 覆盖从二级页面返回上一级。
