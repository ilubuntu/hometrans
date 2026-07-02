# Code trace · category-filter

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: "All"全部分类项 — HomeScreen.kt:127-133 — recalled by: both
- Entry 2: 各具体分类项 (Breakfast/Lunch/Dinner/Dessert/Snack/Drinks) — HomeScreen.kt:134-141 — recalled by: both
- Entry 3: 筛选与列表刷新逻辑 — HomeViewModel.kt:58,93 — recalled by: both

## Entry · "All"全部分类项
- claim: 分类区首个项为"All"，选中时菜谱列表展示全部菜谱（不按分类过滤）
- layers:
  - code:     HomeScreen.kt:128-133 WccChip(label="All", selected=selectedCategory==null, onClick=onSelectCategory(null)); 选中态由 WccChip 渲染 (Chips.kt:31-41：选中 primary 底/onPrimary 字/无边框)
  - resource: N/A: 文案"All"为字面量
  - manifest: N/A
- interaction: 选中"All"等价于 selectedCategory=null
- data_flow: 点击 (HomeScreen.kt:131) → onSelectCategory(null) (HomeScreen.kt:71) → HomeViewModel.selectCategory(null) (HomeViewModel.kt:58) → selectedCategory=null → buildContent 不过滤 (HomeViewModel.kt:93)

## Entry · 各具体分类项
- claim: "All"之后依次列出各分类项，每项含分类图标与名称，选中时列表只展示该分类菜谱
- layers:
  - code:     HomeScreen.kt:134-141 items(state.categories){ WccChip(label=category.label, leadingEmoji=category.emoji, selected=selectedCategory==category, onClick=onSelectCategory(category)) }; 分类集合 state.categories=RecipeCategory.entries (HomeViewModel.kt:102); RecipeCategory.kt:4-10 六分类 Breakfast🍳/Lunch🥗/Dinner🍝/Dessert🍰/Snack🥨/Drinks🥤
  - resource: N/A
  - manifest: N/A
- interaction: 选中某分类设 selectedCategory=该分类；同时仅一项可处于选中态（含"All"在内互斥）
- data_flow: 点击 (HomeScreen.kt:139) → onSelectCategory(category) (HomeScreen.kt:71) → HomeViewModel.selectCategory(category) (HomeViewModel.kt:58) → selectedCategory=category → buildContent 过滤 recipe.category==category (HomeViewModel.kt:93)

## Entry · 筛选与列表刷新逻辑
- claim: 选中分类后菜谱列表即时过滤为该分类，并在过滤结果内按匹配度降序、标题升序排序；选"All"恢复全部
- layers:
  - code:     HomeViewModel.kt:93 `val filtered = if (category==null) withMatch else withMatch.filter{it.recipe.category==category}`; HomeViewModel.kt:94-96 排序 (compareByDescending ratio thenBy title); HomeViewModel.kt:68-79 uiState 订阅 selectedCategory 自动重组
  - resource: N/A
  - manifest: N/A
- interaction: 单选互斥：selectedCategory 为单一可空值，任意时刻最多一项选中（含 All）
- data_flow: selectedCategory 变化 (HomeViewModel.kt:43) → combine 重组 (HomeViewModel.kt:68) → buildContent 过滤+排序 (HomeViewModel.kt:93-96) → state.recipes → 列表刷新 (HomeScreen.kt:145)

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 食材库变化 — HomeViewModel.kt:71 — behavior: 重新计算匹配度，过滤结果内的排序（按 ratio）随之变化，但分类过滤本身不变
- Trigger: 菜谱数据装载完成 — HomeViewModel.kt:74-78 — behavior: 分类项与可过滤的菜谱列表才出现

## Core business entities (data model / persistence key / state machine)
- Entity: selectedCategory: RecipeCategory? — HomeViewModel.kt:43，单选可空；null 表示"All"
- Entity: RecipeCategory(label,emoji) — RecipeCategory.kt:4-10，六分类
- Entity: 过滤结果 recipes — HomeViewModel.kt:93-96，按分类过滤后按 ratio 降序+标题升序排序
- 依赖来源: 菜谱数据来自 `offline-recipes` (REQ-003)；分类项所在布局位置见 `discover-layout` (REQ-004)

## Cross-entry shared declarations
- HomeViewModel.selectedCategory (HomeViewModel.kt:43): "All"项与各分类项共用的单一选中状态，互斥
- RecipeCategory.entries (RecipeCategory.kt): 分类项集合的单一来源

## Deviations from REQ_DESC
1. REQ_DESC 分类列举"All、Breakfast、Lunch、Dinner、Snack、Dessert 等"——代码分类集合为 Breakfast/Lunch/Dinner/Dessert/Snack/Drinks 六项加"All" (RecipeCategory.kt:4-10, HomeScreen.kt:128)；REQ 用"等"表示举例，代码另含"Drinks"项，无冲突
2. REQ_DESC 称"Snack"——代码 SNACK label="Snack" (RecipeCategory.kt:9)，一致
3. REQ_DESC 验收"Dinner 只展示晚餐类菜谱，All 恢复全部菜谱"——代码 HomeViewModel.kt:93 选 Dinner 时 filter category==DINNER，选 All(null) 时不过滤，一致

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 首页分类筛选区为全应用唯一的该交互入口；搜索页虽有分类筛选但为独立状态机（SearchViewModel.selectedCategory，SearchViewModel.kt:51），与本规不共用 selectedCategory
  layers: code HomeScreen.kt:125-143; resource N/A; manifest N/A
  interaction/data_flow: 同 Entry · 各具体分类项 + Entry · 筛选与列表刷新逻辑

### Consumers (who reads this state / data)
- Consumer: HomeContent 分类区读取 selectedCategory 决定选中态 — HomeScreen.kt:130,138
- Consumer: buildContent 读取 selectedCategory 决定过滤 — HomeViewModel.kt:93

### Non-consumers (boundary counter-examples with evidence)
- claim: 搜索页的分类筛选不与首页共用选中状态，二者独立
  closure_layers: [code]
  tools: [Read SearchViewModel.kt:50-53, Grep "selectedCategory" over app/src]
  zero_hits: SearchViewModel.kt:51 category=MutableStateFlow<RecipeCategory?>(null) 为独立状态；Grep "selectCategory" 命中 HomeViewModel.kt:58 与 HomeScreen.kt:131/139，SearchViewModel 用 onCategorySelected (SearchViewModel.kt:68)，两套独立
- claim: 分类筛选不影响"Ready to cook"可做区——可做区由 cookNow 独立计算，不受 selectedCategory 影响
  closure_layers: [code]
  tools: [Read HomeViewModel.kt:89-93]
  zero_hits: HomeViewModel.kt:89-91 cookNow 计算不引用 selectedCategory；selectedCategory 仅用于 :93 的 filtered

## Same-source cross-reference (if applicable)
- 搜索页也提供分类筛选，但与首页是两套独立的状态机与交互（搜索页筛选还与搜索词、可做筛选、排序联动）；搜索页分类筛选由相关搜索需求（REQ-025）描述，本规仅覆盖首页分类筛选。两规独立生成
- 分类筛选区在首页布局中的位置由 `discover-layout-SPEC.md` (REQ-004) 描述
