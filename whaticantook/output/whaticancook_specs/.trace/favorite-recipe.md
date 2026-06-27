# Trace: favorite-recipe (REQ-031)

## 需求原文
用户可在首页、搜索页或详情页点击心形按钮收藏菜谱。收藏状态应实时反映在对应卡片和详情页。收藏 5-Minute Mug Cake 后心形变为已选状态。

## 代码追踪

### 1. 收藏切换入口（四处 ViewModel）
所有入口统一调用 `recipeRepository.setFavorite(recipe.id, !recipe.isFavorite)`：

**HomeViewModel.kt:61-65**
```kotlin
fun toggleFavorite(recipe: Recipe) {
    viewModelScope.launch { recipeRepository.setFavorite(recipe.id, !recipe.isFavorite) }
}
```

**SearchViewModel.kt:67-71** — 同上
**RecipeDetailViewModel.kt:64-68** — 同上
**FavoritesViewModel.kt:39-43** — 同上

### 2. 收藏持久化逻辑
**文件**: `app/src/main/java/com/whaticancook/app/data/repository/RecipeRepositoryImpl.kt:64-70`
```kotlin
override suspend fun setFavorite(recipeId: String, favorite: Boolean) = withContext(io) {
    if (favorite) {
        favoriteDao.add(FavoriteEntity(recipeId, System.currentTimeMillis()))
    } else {
        favoriteDao.remove(recipeId)
    }
}
```
- `favorite=true`: 插入 `FavoriteEntity(recipeId, savedAt=当前时间戳)`，冲突策略 REPLACE。
- `favorite=false`: 删除对应记录。

### 3. DAO 层
**文件**: `app/src/main/java/com/whaticancook/app/data/local/dao/FavoriteDao.kt:10-19`
```kotlin
@Query("SELECT recipeId FROM favorites ORDER BY savedAt DESC")
fun observeIdsOrdered(): Flow<List<String>>

@Insert(onConflict = OnConflictStrategy.REPLACE)
suspend fun add(favorite: FavoriteEntity)

@Query("DELETE FROM favorites WHERE recipeId = :recipeId")
suspend fun remove(recipeId: String)
```

### 4. 实时状态同步（响应式）
**文件**: `RecipeRepositoryImpl.kt:48-52` (observeRecipes)
```kotlin
override fun observeRecipes(): Flow<List<Recipe>> =
    combine(recipeDao.observeAll(), favoriteDao.observeIdsOrdered()) { recipes, favIds ->
        val favSet = favIds.toSet()
        recipes.map { it.toDomain(json, isFavorite = it.id in favSet) }
    }.flowOn(io)
```
- 所有页面观察 `observeRecipes()` 或 `observeRecipe(id)`。
- `favoriteDao.observeIdsOrdered()` 是 Room Flow，数据变更自动推送。
- `Recipe.isFavorite` 字段在每次发射时由 `favSet` 重新计算。
- 首页/搜索页/收藏页/详情页均通过此机制实时获得最新收藏状态。

### 5. UI 收藏按钮
**文件**: `app/src/main/java/com/whaticancook/app/core/designsystem/component/Buttons.kt:106-137` (FavoriteButton)
```kotlin
fun FavoriteButton(isFavorite: Boolean, onToggle: () -> Unit, ...) {
    AnimatedContent(targetState = isFavorite, ...) { fav ->
        Icon(
            imageVector = if (fav) Icons.Rounded.Favorite else Icons.Rounded.FavoriteBorder,
            tint = if (fav) colorScheme.primary else colorScheme.onSurfaceVariant,
            ...
        )
    }
}
```
- `isFavorite=true`: 实心心形，主色调。
- `isFavorite=false`: 空心心形，灰色。
- 弹性按压动画 `pressedScale = 0.82f` + 缩放/淡入淡出转场。

### 6. RecipeCard 中的收藏按钮
**文件**: RecipeCard（设计系统组件）
- 接收 `recipe: Recipe` 和 `onToggleFavorite` 回调。
- 渲染 `FavoriteButton(isFavorite = recipe.isFavorite, onToggle = onToggleFavorite)`。

### 7. 各页面调用链
- **首页**: `HomeContent` -> `RecipeCard(onToggleFavorite = { viewModel.toggleFavorite(it.recipe) })`
- **搜索页**: `SearchScreen` -> `RecipeCard(onToggleFavorite = { viewModel.toggleFavorite(item.recipe) })`
- **详情页**: `DetailContent` -> `FavoriteButton(isFavorite = recipe.isFavorite, onToggle = onToggleFavorite)`
- **收藏页**: `FavoritesScreen` -> `RecipeCard(onToggleFavorite = { viewModel.toggleFavorite(item.recipe) })`

## 关键逻辑总结
1. 收藏操作为 toggle（取反当前状态），幂等写入。
2. 状态通过 Room Flow 响应式传播到所有页面，无需手动刷新。
3. 四个页面共享同一份收藏数据源（FavoriteDao），确保一致性。
