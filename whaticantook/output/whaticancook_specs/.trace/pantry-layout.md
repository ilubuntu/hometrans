# Trace: pantry-layout (REQ-008)

> Pantry 页面基础布局。追踪食材库页面的整体结构。

## 关键源文件
- `app/src/main/java/com/whaticancook/app/feature/pantry/PantryScreen.kt` — 页面 UI 主体
- `app/src/main/java/com/whaticancook/app/feature/pantry/PantryViewModel.kt` — 状态与数据
- `app/src/main/java/com/whaticancook/app/feature/pantry/PantryCatalog.kt` — 快速添加目录
- `app/src/main/java/com/whaticancook/app/domain/model/PantryItem.kt` — PantryItem.display
- `app/src/main/java/com/whaticancook/app/navigation/WccApp.kt` — 底部导航高亮

## 页面结构（PantryScreen.kt:51-131）
Column（statusBarsPadding，左右 20dp 内边距），从上到下：

1. **标题** "My pantry"（displaySmall，onBackground）（line 63-68）。
2. **副标题**（line 69-78）按数量：
   - count == 0 → "Add what you have — we'll find the recipes"
   - count == 1 → "1 ingredient on hand"
   - count > 1 → "$count ingredients on hand"
   - ✅ 5 个食材 → "5 ingredients on hand"。
3. **AddIngredientField**（line 80）— 手动添加输入框（见 pantry-manual-add trace）。
4. **LazyColumn**（line 84-129）：
   - **In your kitchen 区**（仅当 items 非空，line 89-105）：
     - SectionHeader(title="In your kitchen", actionText="Clear all", onActionClick=viewModel::clear)
     - FlowRow：每个食材 PantryChip（display 文本 + Close 关闭按钮，点击 remove）。
   - **Quick add / Add ingredients 区**：
     - SectionHeader(title = if(items.isEmpty()) "Add ingredients" else "Quick add")
     - 遍历 suggestionGroups（按分类分组）：每组渲染分类标题（emoji+label）+ FlowRow 的 SuggestionChip（见 pantry-quick-add / ingredient-categories trace）。

## PantryItem.display（PantryItem.kt:9-12）
每个单词首字母大写，如 "green onion" → "Green Onion"。

## 底部导航
PANTRY 为顶层 Tab，进入 Pantry 页时该 Tab 高亮（WccApp.kt:38-39）。

## 状态（PantryViewModel.kt:27-60）
```
PantryUiState(loading, items, sections, suggestionGroups)
count = items.size
```
- suggestionGroups = PantryCatalog.all 去掉已拥有（normalize 后去重），按 IngredientCategory 分组，按 ordinal 排序。

## 偏差/备注
- 手动添加框、Clear all、In your kitchen、Quick add 分类区四要素齐全，符合 REQ。
- 空态：无 In your kitchen 区，Quick add 区标题变为 "Add ingredients"。
- 技术栈 Jetpack Compose（Column/LazyColumn/FlowRow）；规格按"页面分区/流式标签布局"描述。
