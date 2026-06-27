# Trace: saved-list (REQ-033)

## 需求原文
收藏菜谱后，Saved 页应显示收藏列表、收藏数量文案，并可点击进入详情。收藏 Chicken Fried Rice 后 Saved 显示 1 recipe in your cookbook。

## 代码追踪

### 1. 收藏列表渲染
**文件**: `app/src/main/java/com/whaticancook/app/feature/favorites/FavoritesScreen.kt:50-68`
```kotlin
LazyColumn(
    modifier = Modifier.fillMaxSize().statusBarsPadding(),
    contentPadding = PaddingValues(start=20.dp, end=20.dp, top=8.dp, bottom=28.dp),
    verticalArrangement = Arrangement.spacedBy(16.dp),
) {
    item {
        ScreenTitle(
            title = "Saved",
            subtitle = if (state.items.isEmpty()) null
                else "${state.items.size} recipe${if (state.items.size == 1) "" else "s"} in your cookbook",
            modifier = Modifier.padding(bottom = 4.dp),
        )
    }
    items(state.items, key = { it.recipe.id }) { item ->
        RecipeCard(
            recipe = item.recipe,
            match = item.match,
            onClick = { onRecipeClick(item.recipe.id) },
            onToggleFavorite = { viewModel.toggleFavorite(item.recipe) },
            modifier = Modifier.animateItem(),
        )
    }
}
```
- **标题**: "Saved"
- **副标题**: "N recipe(s) in your cookbook"（单数 "recipe"，复数 "recipes"）。
- **列表项**: RecipeCard，含菜谱信息 + 匹配状态 + 收藏按钮。
- **点击**: `onRecipeClick(item.recipe.id)` -> 导航到详情页。

### 2. 数据来源
**文件**: `FavoritesViewModel.kt:26-32`
```kotlin
val uiState: StateFlow<FavoritesUiState> = combine(
    recipeRepository.observeFavorites(),
    pantryRepository.observePantry(),
) { favorites, pantry ->
    val pantryNames = pantry.map { it.name }
    FavoritesUiState(
        loading = false,
        items = favorites.map { RecipeWithMatch(it, it.matchAgainst(pantryNames)) },
    )
}
```
- `observeFavorites()` 返回收藏菜谱列表（按收藏时间降序）。
- 每个菜谱附加 `matchAgainst(pantry)` 匹配结果。

### 3. observeFavorites 实现
**文件**: `RecipeRepositoryImpl.kt:57-63`
```kotlin
override fun observeFavorites(): Flow<List<Recipe>> =
    combine(recipeDao.observeAll(), favoriteDao.observeIdsOrdered()) { recipes, favIds ->
        val byId = recipes.associateBy { it.id }
        favIds.mapNotNull { id -> byId[id]?.toDomain(json, isFavorite = true) }
    }.flowOn(io)
```
- 按 `favIds`（savedAt DESC）顺序映射出 Recipe。
- 所有返回的 Recipe 的 `isFavorite` 均为 true。

### 4. 数量文案逻辑
- `state.items.size == 1` -> "1 recipe in your cookbook"
- `state.items.size > 1` -> "N recipes in your cookbook"
- `state.items.isEmpty()` -> subtitle=null（但此时渲染空态而非列表）。

### 5. 点击导航
**文件**: `WccApp.kt:103`
```kotlin
onRecipeClick = { navController.navigate(Routes.recipeDetail(it)) },
```
- 点击菜谱卡片 -> 路由到详情页 `recipe/{recipeId}`。

## 关键逻辑总结
1. 收藏列表数据来自 Room FavoriteDao，响应式更新。
2. 每项含匹配状态（pantry 对比），与首页/搜索页一致。
3. 列表按收藏时间降序排列（REQ-035 详述）。
