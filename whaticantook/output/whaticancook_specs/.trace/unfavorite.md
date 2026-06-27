# Trace: unfavorite (REQ-034)

## 需求原文
用户在 Saved 页或详情页取消收藏后，该菜谱应从 Saved 列表移除；当列表为空时恢复空态。取消唯一收藏后显示 No saved recipes yet。

## 代码追踪

### 1. 取消收藏操作入口
**文件**: `app/src/main/java/com/whaticancook/app/feature/favorites/FavoritesViewModel.kt:39-43`
```kotlin
fun toggleFavorite(recipe: Recipe) {
    viewModelScope.launch {
        recipeRepository.setFavorite(recipe.id, !recipe.isFavorite)
    }
}
```
**文件**: `RecipeDetailViewModel.kt:64-68` — 同上

- Saved 页和详情页均有 `toggleFavorite`。
- 因列表中 Recipe 的 `isFavorite=true`，toggle 后传 `false` 给 `setFavorite`。

### 2. 数据层移除
**文件**: `app/src/main/java/com/whaticancook/app/data/repository/RecipeRepositoryImpl.kt:66-69`
```kotlin
if (favorite) {
    favoriteDao.add(FavoriteEntity(recipeId, System.currentTimeMillis()))
} else {
    favoriteDao.remove(recipeId)
}
```
**文件**: `FavoriteDao.kt:18-19`
```kotlin
@Query("DELETE FROM favorites WHERE recipeId = :recipeId")
suspend fun remove(recipeId: String)
```
- `setFavorite(id, false)` -> `favoriteDao.remove(id)` -> 物理删除 favorites 表记录。

### 3. 响应式列表更新
**文件**: `RecipeRepositoryImpl.kt:57-63` (observeFavorites)
- `favoriteDao.observeIdsOrdered()` 是 Room Flow，删除操作触发 Flow 重新发射。
- 新的 `favIds` 不再包含被移除的 recipeId -> `mapNotNull` 跳过该项 -> 列表减少。

**文件**: `FavoritesViewModel.kt:26-32`
- `combine(observeFavorites(), observePantry())` 自动重新构建 `FavoritesUiState`。
- `items` 列表更新 -> FavoritesScreen 重新渲染。

### 4. 空态恢复
**文件**: `FavoritesScreen.kt:31-48`
```kotlin
if (!state.loading && state.items.isEmpty()) {
    EmptyState(
        title = "No saved recipes yet",
        message = "Tap the heart on any recipe to keep it here for later.",
        actionLabel = "Browse recipes",
        onAction = onBrowse,
    )
    return
}
```
- 当最后一个收藏被移除后，`items` 变空 -> 条件 `!loading && items.isEmpty()` 为 true -> 渲染空态。

### 5. 详情页同步
**文件**: `RecipeDetailViewModel.kt:45-55`
```kotlin
val uiState: StateFlow<DetailUiState> = combine(
    recipeRepository.observeRecipe(recipeId),
    pantryRepository.observePantry(),
) { recipe, pantry -> ... }
```
- `observeRecipe(id)` 内部 combine `favoriteDao.observeIdsOrdered()`。
- 取消收藏后，该菜谱的 `isFavorite` 更新为 false -> 详情页心形变为空心。
- `RecipeDetailScreen` -> `FavoriteButton(isFavorite = recipe.isFavorite, ...)`。

## 关键逻辑总结
1. 取消收藏 = 删除 favorites 表记录。
2. Room Flow 响应式传播：删除 -> 列表自动移除该项。
3. 列表清空 -> 自动切换到空态视图。
4. 详情页心形同步更新为未收藏状态。
