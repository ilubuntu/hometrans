# Trace: pantry-quick-add (REQ-009)

> Pantry 快速添加食材。追踪点击 Quick add 食材 chip 加入 pantry 的逻辑。

## 关键源文件
- `app/src/main/java/com/whaticancook/app/feature/pantry/PantryScreen.kt` — SuggestionChip 渲染与点击
- `app/src/main/java/com/whaticancook/app/feature/pantry/PantryViewModel.kt` — addCatalog、suggestionGroups 去重
- `app/src/main/java/com/whaticancook/app/feature/pantry/PantryCatalog.kt` — 目录数据源
- `app/src/main/java/com/whaticancook/app/data/repository/PantryRepositoryImpl.kt` — 持久化添加

## 渲染（PantryScreen.kt:110-128）
遍历 `state.suggestionGroups`（按分类分组），每组：
- 分类标题：`"${category.emoji}  ${category.label}"`
- FlowRow：每个 suggestion 渲染 `SuggestionChip(label=suggestion.name, onAdd={viewModel.addCatalog(suggestion)})`。

SuggestionChip（line 217-239）：圆角标签，表面背景 + outline 边框，文本（首字母大写）+ Add 图标，整 chip 可点击（bounceClick）→ onAdd。

## 添加流程
1. 点击 chip → `viewModel.addCatalog(suggestion)`（PantryViewModel.kt:67-69）。
2. → `pantryRepository.add(item.name, item.category)`。
3. `PantryRepositoryImpl.add`（line 30-41）：
   - `IngredientMatching.normalize(name)` 归一化（如大小写、去标点、同义词映射）。
   - 归一化非空 → upsert PantryItemEntity(name=normalized, category, addedAt=now)。

## 添加后自动更新（响应式）
`uiState` 来自 `observePantry()` 流映射（PantryViewModel.kt:41-59）：
- items：来自持久化 pantry（含新加入项）。
- present = items.map{normalize(it.name)}.toSet()。
- suggestionGroups = PantryCatalog.all.filter{ normalize(name) !in present } 分组 → **已加入的食材从 Quick add 中移除**。
- 新加入食材出现在 items → 渲染为 "In your kitchen" 的 PantryChip。

## 验证点
- 点击 Cucumber、Avocado、Carrot、Garlic、Onion（均属 PRODUCE 分类目录项）→ 各自 addCatalog。
- 添加后：这 5 项从 Quick add 的 Produce 组消失，并出现在 "In your kitchen" 为对应 chip。✅

## 去重键
以 `normalize(name)` 为去重依据（非原始字符串）。目录名已是规范名，故去重可靠。

## 偏差/备注
- Quick add 目录是固定精选集（PantryCatalog），非动态生成；用户手动添加的食材不会反向加入 Quick add 目录。
- chip 文本显示时首字母大写（"cucumber" → "Cucumber"），但存储为目录规范名（小写）。
