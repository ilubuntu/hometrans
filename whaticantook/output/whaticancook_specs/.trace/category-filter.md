# Trace: category-filter (REQ-007)

> 首页分类筛选。追踪 Browse recipes 分类 chip 筛选逻辑。

## 关键源文件
- `app/src/main/java/com/whaticancook/app/feature/home/HomeScreen.kt` — 分类 chip 行渲染
- `app/src/main/java/com/whaticancook/app/feature/home/HomeViewModel.kt` — 选中状态与过滤
- `app/src/main/java/com/whaticancook/app/domain/model/RecipeCategory.kt` — 分类枚举
- `app/src/main/java/com/whaticancook/app/core/designsystem/component/Chips.kt` — WccChip 组件

## 分类枚举（RecipeCategory.kt:4-10）
```
BREAKFAST("Breakfast", 🍳)
LUNCH    ("Lunch",     🥗)
DINNER   ("Dinner",    🍝)
DESSERT  ("Dessert",   🍰)
SNACK    ("Snack",     🥨)
DRINK    ("Drinks",    🥤)   ← 注意 label 是复数 "Drinks"
```
- fromId 默认回退 DINNER。

## Chip 行渲染（HomeScreen.kt:125-143）
横向 LazyRow，顺序：
1. 固定 "All" chip（WccChip，无 emoji，selected = selectedCategory == null，点击 → onSelectCategory(null)）。
2. 各分类 chip：遍历 `state.categories`（= RecipeCategory.entries），每个 WccChip(label=category.label, leadingEmoji=category.emoji, selected = selectedCategory == category, 点击 → onSelectCategory(category))。

> chip 顺序：All, Breakfast, Lunch, Dinner, Dessert, Snack, Drinks。与 REQ 一致。

## 选中状态（WccChip, Chips.kt:31-41）
- 选中：主色背景 + 主色上文字，无边框。
- 未选中：表面背景 + outline 边框 + 中性文字。
- 切换有颜色过渡动画。

## 默认选中（HomeViewModel.kt:43）
`selectedCategory = MutableStateFlow<RecipeCategory?>(null)` → 默认 null → "All" chip 选中。✅ 符合"All 默认选中"。

## 过滤逻辑（HomeViewModel.kt:93）
```
filtered = if (category == null) withMatch
           else withMatch.filter { it.recipe.category == category }
```
- category == null（All）→ 显示全部。
- 选定分类 → 只保留 recipe.category == 选定分类 的菜谱。

## 验证点
- All 默认选中 ✅
- Dinner 筛选：Chicken Fried Rice、Spaghetti Aglio e Olio、Creamy Tomato Pasta、Classic Beef Tacos、Coconut Chickpea Curry、Garlic Butter Shrimp（recipes.json 中 category=DINNER 的菜谱）✅，包含 Chicken Fried Rice。

## 偏差/备注
- 分类 chip 单选（同时只能选一个分类或 All），非多选。
- "Drinks" 标签为复数，分类枚举名为 DRINK。
- 筛选作用于 Browse recipes 列表；不作用于 Ready to cook 横向列表（cookNow 独立计算，见 discover-layout）。
