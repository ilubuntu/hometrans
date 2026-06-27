# Trace: search-fewest-missing (REQ-029)

## 需求原文
Fewest missing 排序应按缺少必需食材数量升序，再按匹配比例排序。当前 pantry 更接近完成的菜谱优先展示。

## 代码追踪

### 1. 排序选项枚举
**文件**: `app/src/main/java/com/whaticancook/app/feature/search/SearchViewModel.kt:20-24`
```kotlin
enum class SortOption(val label: String) {
    RELEVANCE("Best match"),
    QUICKEST("Quickest"),
    FEWEST_MISSING("Fewest missing"),
}
```
- 三种排序选项，`FEWEST_MISSING` 对应 "Fewest missing" 标签。

### 2. Fewest Missing 排序逻辑
**文件**: `app/src/main/java/com/whaticancook/app/feature/search/SearchViewModel.kt:build()` (行 108-110)
```kotlin
SortOption.FEWEST_MISSING -> items.sortedWith(
    compareBy<RecipeWithMatch> { it.match.missing.size }
        .thenByDescending { it.match.ratio },
)
```
- **主排序**: `match.missing.size`（缺少必需食材数量）升序。
- **次排序**: `match.ratio`（匹配比例）降序作为 tiebreaker。
- `missing.size` 越小排越前，表示越接近可做。

### 3. missing 列表计算
**文件**: `app/src/main/java/com/whaticancook/app/domain/model/CookMatch.kt:matchAgainst()` (行 92-105)
```kotlin
for (ing in ingredients) {
    val satisfied = pantryNames.any { IngredientMatching.matches(it, ing.name) }
    when {
        ing.essential && satisfied -> have += ing
        ing.essential && !satisfied -> missing += ing
        !ing.essential && !satisfied -> missingOptional += ing
    }
}
```
- `missing` 仅包含必需食材中 pantry 不满足的部分。
- 可选食材缺失不计入 `missing.size`。

### 4. ratio 计算
**文件**: `app/src/main/java/com/whaticancook/app/domain/model/CookMatch.kt:78-79`
```kotlin
val ratio: Float
    get() = if (essentialCount == 0) 1f else haveCount.toFloat() / essentialCount
```
- ratio = haveCount / essentialCount（0.0~1.0）。

### 5. 排序触发链
**文件**: `SearchViewModel.kt:60-65`
- `onSortSelected(value: SortOption)` -> `sort.value = value`
- `sort` 是 `MutableStateFlow(SortOption.RELEVANCE)`，组合进 `filters`
- `filters` 与 `observeRecipes()`、`observePantry()` 三路 combine 后调用 `build()` 重新计算

### 6. UI 排序选择器
**文件**: `app/src/main/java/com/whaticancook/app/feature/search/SearchScreen.kt:104-111`
```kotlin
LazyRow(...) {
    items(SortOption.entries, key = { it.name }) { option ->
        WccChip(
            label = option.label,
            selected = state.sort == option,
            onClick = { viewModel.onSortSelected(option) },
        )
    }
}
```
- 排序选项渲染为横向滚动的 Chip 列表，点击切换。

### 7. CookMatch 单元测试
**文件**: `app/src/test/java/com/whaticancook/app/domain/CookMatchTest.kt`
- 测试验证 `missing.size` 在不同 pantry 组合下的正确性。

## 关键逻辑总结
1. 每个 `RecipeWithMatch` 携带 `CookMatch`，含 `missing.size` 和 `ratio`。
2. Fewest missing 主键 = 缺失必需食材数升序，次键 = 匹配比例降序。
3. 排序结果是纯函数计算，每次 pantry 或 filters 变化自动重新推导。
