# Trace: settings-clear-pantry (REQ-039)

## 需求原文
Settings 的 Clear pantry 应移除所有已添加食材，并影响首页、搜索页和详情页的匹配状态。清空后 Chicken Fried Rice 从 You're all set 恢复为缺食材状态。

## 代码追踪

### 1. Settings 页面触发入口
**文件**: `app/src/main/java/com/whaticancook/app/feature/settings/SettingsScreen.kt:82-103`
```kotlin
SettingsSectionLabel("Data")
SettingsCard {
    Row(
        modifier = Modifier.fillMaxWidth().clip(RoundedCornerShape(12.dp))
            .bounceClick(onClick = viewModel::clearPantry, pressedScale = 0.98f)
            .padding(vertical = 4.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Icon(Icons.Rounded.DeleteSweep, tint = error)
        Column(modifier = Modifier.weight(1f)) {
            Text("Clear pantry", titleMedium, onSurface)
            Text("Remove all ingredients you've added", bodySmall, onSurfaceVariant)
        }
    }
}
```
- "Clear pantry" 行点击 -> `viewModel::clearPantry`。
- 无确认对话框，直接执行。

### 2. ViewModel 处理
**文件**: `app/src/main/java/com/whaticancook/app/feature/settings/SettingsViewModel.kt:33-35`
```kotlin
fun clearPantry() {
    viewModelScope.launch { pantryRepository.clear() }
}
```
- 调用 `pantryRepository.clear()`。

### 3. Repository 实现
**文件**: `app/src/main/java/com/whaticancook/app/data/repository/PantryRepositoryImpl.kt:46-48`
```kotlin
override suspend fun clear() = withContext(io) {
    pantryDao.clear()
}
```
- 在 IO 线程执行。

### 4. DAO 层清空
**文件**: `app/src/main/java/com/whaticancook/app/data/local/dao/PantryDao.kt:21-22`
```kotlin
@Query("DELETE FROM pantry_items")
suspend fun clear()
```
- `DELETE FROM pantry_items` — 删除表中所有记录。

### 5. 响应式传播到所有页面
**文件**: `PantryDao.kt:12-13`
```kotlin
@Query("SELECT * FROM pantry_items ORDER BY addedAt DESC")
fun observeAll(): Flow<List<PantryItemEntity>>
```
- `clear()` 触发 `observeAll()` Flow 重新发射空列表。

#### 首页影响
**文件**: `HomeViewModel.kt:67-79`
```kotlin
val uiState = combine(seedState, recipeRepository.observeRecipes(),
    pantryRepository.observePantry(), selectedCategory) { ... }
```
- pantry 变空 -> `buildContent` 中 `pantryNames` 为空 -> `matchAgainst(emptyList())` -> 所有菜谱 `missing.size = essentialCount`。
- `cookNow` 列表变空（`pantryNames.isNotEmpty()` 为 false）。
- pantry 卡片显示 "Add what you have at home"。

#### 搜索页影响
**文件**: `SearchViewModel.kt:60-65`
- pantry 变空 -> `build()` 中 `pantryNames` 为空 -> 所有 `CookMatch` 重新计算 -> 排序/匹配更新。

#### 详情页影响
**文件**: `RecipeDetailViewModel.kt:45-55`
- pantry 变空 -> `IngredientStatus.have` 全部为 false -> `CookMatch.isCookable = false`。
- 之前 "You're all set!" 的菜谱变为 "You're missing N ingredients"。

### 6. matchAgainst 空 pantry
**文件**: `CookMatch.kt:92-105`
```kotlin
for (ing in ingredients) {
    val satisfied = pantryNames.any { IngredientMatching.matches(it, ing.name) }
    // pantryNames 为空 -> any{} 返回 false -> 所有必需食材进入 missing
}
```
- 空 pantry -> `haveCount=0`, `missing=all essential`, `ratio=0f`。

## 关键逻辑总结
1. Clear pantry 执行全表删除（DELETE FROM pantry_items）。
2. Room Flow 响应式传播到所有观察 pantry 的页面（首页/搜索/详情/食材库）。
3. 清空后所有菜谱匹配状态从 "已拥有" 回归为 "缺少全部必需食材"。
4. 无确认对话框，操作立即执行。
