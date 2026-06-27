# Trace: ingredient-categories (REQ-013)

> 食材分类展示。追踪 Quick add 按分类组织常用食材的分类定义与目录内容。

## 关键源文件
- `app/src/main/java/com/whaticancook/app/domain/model/IngredientCategory.kt` — 分类枚举
- `app/src/main/java/com/whaticancook/app/feature/pantry/PantryCatalog.kt` — 各分类常用食材目录
- `app/src/main/java/com/whaticancook/app/feature/pantry/PantryViewModel.kt` — 分组与排序
- `app/src/main/java/com/whaticancook/app/feature/pantry/PantryScreen.kt` — 分类标题渲染

## 分类枚举（IngredientCategory.kt:4-12）
```
PRODUCE      ("Produce",          🥦)
MEAT_SEAFOOD ("Meat & Seafood",   🍗)
DAIRY_EGGS   ("Dairy & Eggs",     🧀)
GRAINS_BREAD ("Grains & Bread",   🍞)
PANTRY       ("Pantry Staples",   🫙)
SPICES       ("Spices & Herbs",   🌿)
CONDIMENTS   ("Condiments & Oils",🫒)
OTHER        ("Other",            🧂)   ← 仅用于手动添加，目录中无项
```
- 显示顺序按 enum ordinal：Produce → Meat & Seafood → Dairy & Eggs → Grains & Bread → Pantry Staples → Spices & Herbs → Condiments & Oils。

## 目录内容（PantryCatalog.kt，PantryCatalog.all）
- **PRODUCE**：tomato, onion, garlic, potato, carrot, bell pepper, spinach, mushroom, lemon, lime, avocado, broccoli, ginger, green onion, cucumber, zucchini
- **MEAT_SEAFOOD**：chicken, beef, pork, bacon, shrimp, salmon, tuna
- **DAIRY_EGGS**：egg, milk, butter, cheese, yogurt, cream, parmesan, mozzarella
- **GRAINS_BREAD**：rice, pasta, bread, flour, noodle, tortilla, oats, quinoa
- **PANTRY (Pantry Staples)**：sugar, canned tomatoes, black beans, chickpeas, honey, stock, coconut milk
- **CONDIMENTS (Condiments & Oils)**：olive oil, soy sauce, vinegar, mayonnaise, mustard
- **SPICES (Spices & Herbs)**：salt, pepper, cumin, paprika, oregano, basil, chili, cinnamon, curry powder

## 分组渲染（PantryViewModel.kt:48-52 + PantryScreen.kt:110-128）
- suggestionGroups = PantryCatalog.all 去掉已拥有项，按 category 分组，**sortedBy category.ordinal**（即 enum 顺序）。
- 每组渲染分类标题 `"${category.emoji}  ${category.label}"` + FlowRow 的 SuggestionChip。

## 验证点
- Produce 含 Tomato、Potato、Bell pepper ✅。
- Dairy & Eggs 含 Egg、Milk、Butter、Cheese ✅。

## 偏差（重要：与 REQ 文案不一致）
1. **分类名称**：REQ 描述为 "Pantry、Condiments、Spices"，代码实际 label 为：
   - "Pantry Staples"（非 "Pantry"）
   - "Condiments & Oils"（非 "Condiments"）
   - "Spices & Herbs"（非 "Spices"）
2. **分类顺序**：REQ 列举顺序末尾为 "Pantry、Condiments、Spices"，代码显示顺序末尾为 "Pantry Staples、Spices & Herbs、Condiments & Oils"（SPICES 在 CONDIMENTS 之前）。
3. 分类数量一致（均为 7 个有目录项的分类）。
> 迁移规格应以代码实际 label 与顺序为准（见偏差说明）。

## 偏差/备注
- 名称使用与菜谱数据相同的规范名，匹配可靠。
- OTHER 分类仅用于手动添加的食材，不出现在 Quick add 目录。
- 去除已拥有项后，某分类组可能整组消失（组内全部已添加时）。
