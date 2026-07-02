# Code trace · detail-ingredients

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 食材清单区标题与数量 — RecipeDetailScreen.kt:164-165 (SectionHeader "Ingredients" + actionText=count) — recalled by: both
- Entry 2: 食材行 (IngredientRow) 已满足/缺少/可选三态展示 — RecipeDetailScreen.kt:166-169 (forEach) + RecipeDetailScreen.kt:294-335 (IngredientRow) — recalled by: both

## Entry · 食材清单区标题与数量
- claim: 详情页食材区以"Ingredients"为标题，并在标题右侧展示食材总数
- layers:
  - code:     RecipeDetailScreen.kt:164 SectionHeader(title="Ingredients", actionText="${content.ingredients.size}")；content.ingredients = recipe.ingredients.map{IngredientStatus} (RecipeDetailViewModel.kt:55-60)，含全部食材(必需+可选)；RecipeDetailScreen.kt:165 间距；RecipeDetailScreen.kt:166-169 forEach 渲染每行
  - resource: N/A
  - manifest: N/A
- interaction: 数量=全部食材数(必需+可选)；读 content.ingredients.size
- data_flow: RecipeDetailViewModel.uiState → Content.ingredients → SectionHeader actionText + forEach

## Entry · 食材行 (IngredientRow) 已满足/缺少/可选三态展示
- claim: 每个食材逐行展示：左侧圆圈标记已满足态，中间展示"数量 单位 名称"，右侧按必需/拥有情况标记 Missing 或 Optional
- layers:
  - code:     RecipeDetailScreen.kt:294-335 IngredientRow；RecipeDetailScreen.kt:296-313 左侧圆圈：have→primary 底+Check 图标，!have→surfaceVariant 底+无图标；RecipeDetailScreen.kt:315-320 中间 status.ingredient.display(Recipe.kt:10-16 = "qty unit  Name"，首字母大写)；RecipeDetailScreen.kt:321-326 !essential→Text("Optional")；RecipeDetailScreen.kt:327-333 essential && !have→Text("Missing")；essential && have→无右侧标记
  - resource: N/A
  - manifest: N/A
- interaction: 读 status.have(食材库是否匹配) 与 status.ingredient.essential；四态组合：必需+拥有(勾选,无标记) / 必需+缺少(无勾选,Missing) / 可选+拥有(勾选,Optional) / 可选+缺少(无勾选,Optional)
- data_flow: IngredientStatus (RecipeDetailViewModel.kt:55-60, have=pantryNames.any{matches(it,name)}) → IngredientRow 三态渲染

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 食材库变化 — RecipeDetailViewModel.kt:49 (observePantry) — behavior: 各食材 have 标记刷新，勾选与 Missing/Optional 标记随之更新
- Trigger: 进入详情页 — RecipeDetailViewModel.kt:45 recipeId — behavior: 加载食材清单渲染

## Core business entities (data model / persistence key / state machine)
- Entity: IngredientStatus(ingredient, have) — RecipeDetailViewModel.kt:23-26；have 由 IngredientMatching.matches(pantry, ingredient.name) 决定
- Entity: RecipeIngredient.display — Recipe.kt:10-16："qty unit  Name"（数量单位与名称拼接，名称首字母大写）
- Entity: RecipeIngredient.essential — Recipe.kt:8：决定右侧标 Optional 还是 Missing
- 依赖来源: 食材清单来自菜谱数据(offline-recipes, REQ-003)；have 判定依赖食材库(pantry 系列)；可选食材语义见 optional-ingredient(REQ-019)

## Cross-entry shared declarations
- IngredientRow 同时承载本规(食材清单三态)与 optional-ingredient(REQ-019) 的 Optional 标记，同组件
- content.ingredients 同时被食材清单区(本规)与 match 计算(REQ-015/016/017)消费，但 have 标记独立计算(RecipeDetailViewModel.kt:55-60)

## Deviations from REQ_DESC
1. REQ_DESC 验收"已有食材显示选中状态，缺少食材显示 Missing，可选食材显示 Optional"——代码三态完全一致：have→左侧勾选(RecipeDetailScreen.kt:305-313)；essential && !have→"Missing"(RecipeDetailScreen.kt:329)；!essential→"Optional"(RecipeDetailScreen.kt:323)，无偏差
2. REQ_DESC 称展示"食材数量"——代码标题右侧数量=全部食材数(必需+可选)，如 Chicken Fried Rice 为 8(7 必需+1 可选 olive oil)，非"必需食材数"。记为细节：食材总数含可选
3. REQ_DESC 未提及食材行展示"数量+单位"——代码中间展示 ingredient.display="数量 单位 名称"(如"3 cups  Rice")(Recipe.kt:10-16)，属隐含展示，已记入 Entry 2
4. REQ_DESC 未提及可选食材"已拥有"时勾选——代码可选+拥有时左侧显示勾选且右侧标 Optional(RecipeDetailScreen.kt:305,323)，记为隐含行为

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 食材清单区标题与数量 — RecipeDetailScreen.kt:164-165 — 本 REQ 主体
- 食材行三态展示 (IngredientRow) — RecipeDetailScreen.kt:166-169,294-335 — 本 REQ 主体

### Consumers (who reads this state / data)
- Consumer: SectionHeader 读取 content.ingredients.size — RecipeDetailScreen.kt:164
- Consumer: IngredientRow 读取 status.have 与 status.ingredient — RecipeDetailScreen.kt:294-335

### Non-consumers (boundary counter-examples with evidence)
- claim: 食材清单数量为全部食材数(含可选)，与"匹配计数分母(仅必需)"不同源；食材行的 have 勾选与卡片状态胶囊计数虽都来自匹配，但本区不展示"X/Y"计数
  closure_layers: [code]
  tools: [Read RecipeDetailScreen.kt:164-335]
  zero_hits: 食材清单区(RecipeDetailScreen.kt:164-335)未引用 CookMatch.haveCount/essentialCount/"X/Y"拼接；数量 actionText 仅取 content.ingredients.size(全部食材)

## Same-source cross-reference (if applicable)
- 食材行三态与 optional-ingredient(REQ-019) 的 Optional 标记同组件同源；本规聚焦"详情页食材清单的数量与已满足/缺少/可选三态展示"
- have 判定逻辑与 recipe-match-count(REQ-015)/ingredient-normalize(REQ-014) 共用 IngredientMatching.matches
