# Trace: saved-empty (REQ-032)

## 需求原文
当没有收藏时，Saved 页应显示 No saved recipes yet、说明文案和 Browse recipes 操作。点击 Browse recipes 返回 Discover。

## 代码追踪

### 1. 空态判断与渲染
**文件**: `app/src/main/java/com/whaticancook/app/feature/favorites/FavoritesScreen.kt:31-48`
```kotlin
if (!state.loading && state.items.isEmpty()) {
    Box(modifier = Modifier.fillMaxSize().statusBarsPadding(), contentAlignment = Alignment.Center) {
        EmptyState(
            emoji = "",
            title = "No saved recipes yet",
            message = "Tap the heart on any recipe to keep it here for later.",
            actionLabel = "Browse recipes",
            onAction = onBrowse,
        )
    }
    return
}
```
- **条件**: `!state.loading && state.items.isEmpty()` — 加载完成且无收藏。
- **标题**: "No saved recipes yet"
- **消息**: "Tap the heart on any recipe to keep it here for later."
- **操作按钮**: "Browse recipes" -> `onBrowse` 回调。

### 2. loading 初始状态
**文件**: `FavoritesViewModel.kt:14-17`
```kotlin
data class FavoritesUiState(
    val loading: Boolean = true,
    val items: List<RecipeWithMatch> = emptyList(),
)
```
- 初始 `loading=true`，首次数据加载完成后 `build()` 返回 `loading=false`。

### 3. Browse recipes 导航
**文件**: `app/src/main/java/com/whaticancook/app/navigation/WccApp.kt:101-104`
```kotlin
composable(Routes.FAVORITES) {
    FavoritesScreen(
        onRecipeClick = { navController.navigate(Routes.recipeDetail(it)) },
        onBrowse = { navController.navigateToTab(Routes.HOME) },
    )
}
```
- `onBrowse` -> `navigateToTab(Routes.HOME)` -> 跳转到 Discover（首页）Tab。

### 4. navigateToTab 逻辑
**文件**: `WccApp.kt:135-141`
```kotlin
private fun NavController.navigateToTab(route: String) {
    navigate(route) {
        popUpTo(Routes.HOME) { saveState = true }
        launchSingleTop = true
        restoreState = true
    }
}
```
- 跳转后保留各 Tab 状态。

### 5. EmptyState 组件操作按钮
**文件**: `app/src/main/java/com/whaticancook/app/core/designsystem/component/StateViews.kt:57-64`
```kotlin
if (actionLabel != null && onAction != null) {
    Spacer(Modifier.height(24.dp))
    WccPrimaryButton(text = actionLabel, onClick = onAction)
}
```
- 当提供 actionLabel 和 onAction 时，渲染主色调操作按钮。

## 关键逻辑总结
1. 空态仅在加载完成且无收藏时出现。
2. 提供明确的引导操作（Browse recipes）跳转首页。
3. 与搜索空态不同：收藏空态有操作按钮，搜索空态没有。
