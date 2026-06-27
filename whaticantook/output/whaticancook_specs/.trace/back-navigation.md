# Trace: back-navigation (REQ-041)

## 需求原文
详情页和设置页应提供返回按钮，点击后回到进入前页面。从 Search 进入详情后返回 Search；从 Discover 进入 Settings 后返回 Discover。

## 代码追踪

### 1. 详情页返回按钮
**文件**: `app/src/main/java/com/whaticancook/app/feature/detail/RecipeDetailScreen.kt:195-206`
```kotlin
// Pinned top controls
Row(
    modifier = Modifier.fillMaxWidth().statusBarsPadding()
        .padding(horizontal = 16.dp, vertical = 8.dp),
    verticalAlignment = Alignment.CenterVertically,
) {
    CircleIconButton(
        icon = Icons.AutoMirrored.Rounded.ArrowBack,
        contentDescription = "Back",
        onClick = onBack,
        containerColor = MaterialTheme.colorScheme.surface.copy(alpha = 0.92f),
    )
    Spacer(Modifier.weight(1f))
    FavoriteButton(isFavorite = recipe.isFavorite, onToggle = onToggleFavorite, size = 44.dp)
}
```
- 返回按钮固定在顶部，半透明圆形按钮。
- `onBack` 回调 -> 导航返回。

### 2. 详情页 onBack 绑定
**文件**: `app/src/main/java/com/whaticancook/app/navigation/WccApp.kt:126-130`
```kotlin
composable(
    route = Routes.RECIPE_DETAIL_PATTERN,
    arguments = listOf(navArgument(Routes.RECIPE_DETAIL_ARG) { type = NavType.StringType }),
    enterTransition = { slideInVertically(tween(320)) { it / 5 } + fadeIn(tween(280)) },
    popExitTransition = { slideOutVertically(tween(300)) { it / 5 } + fadeOut(tween(220)) },
) {
    RecipeDetailScreen(
        onBack = { navController.popBackStack() },
        onRecipeClick = { navController.navigate(Routes.recipeDetail(it)) },
    )
}
```
- `onBack = { navController.popBackStack() }` — 弹出返回栈，回到来源页面。
- 详情页有自定义垂直滑入/滑出过渡动画。

### 3. 设置页返回按钮
**文件**: `app/src/main/java/com/whaticancook/app/feature/settings/SettingsScreen.kt:43`
```kotlin
Column(modifier = Modifier.fillMaxSize()) {
    WccTopBar(title = "Settings", onBack = onBack)
    ...
}
```
- 使用 WccTopBar 组件，内置返回按钮。

### 4. WccTopBar 组件
**文件**: `app/src/main/java/com/whaticancook/app/core/designsystem/component/TopBar.kt:51-80`
```kotlin
@Composable
fun WccTopBar(title: String, onBack: () -> Unit, modifier: Modifier = Modifier, actions: ...) {
    Row(
        modifier = modifier.fillMaxWidth().statusBarsPadding()
            .padding(horizontal = 16.dp, vertical = 8.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        CircleIconButton(
            icon = Icons.AutoMirrored.Rounded.ArrowBack,
            contentDescription = "Back",
            onClick = onBack,
            tint = MaterialTheme.colorScheme.onSurface,
        )
        Spacer(Modifier.width(12.dp))
        Text(title, titleLarge, onBackground, modifier = Modifier.weight(1f))
        actions()
    }
}
```
- 标准返回导航栏：圆形返回按钮 + 标题 + 可选尾部操作。

### 5. 设置页 onBack 绑定
**文件**: `WccApp.kt:116-118`
```kotlin
composable(Routes.SETTINGS) {
    SettingsScreen(onBack = { navController.popBackStack() })
}
```
- `onBack = { navController.popBackStack() }` — 弹出返回栈。

### 6. CircleIconButton 组件
**文件**: `TopBar.kt:28-48`
```kotlin
@Composable
fun CircleIconButton(icon, contentDescription, onClick, modifier, size = 44.dp,
    containerColor = surface, tint = onSurface) {
    Box(
        modifier = modifier.size(size).clip(CircleShape).background(containerColor)
            .bounceClick(onClick = onClick, pressedScale = 0.85f),
        contentAlignment = Alignment.Center,
    ) {
        Icon(icon, contentDescription = contentDescription, tint = tint, modifier = Modifier.size(size * 0.5f))
    }
}
```
- 圆形按钮，弹性按压反馈。

### 7. 返回栈行为
- `popBackStack()` 从 NavController 返回栈弹出当前目的地。
- 返回到压入详情/设置之前的页面（即来源 Tab 页面）。
- 从 Search 进入详情 -> 返回栈: [HOME, SEARCH, DETAIL] -> pop -> [HOME, SEARCH] -> 显示 SEARCH。
- 从 Discover 进入 Settings -> 返回栈: [HOME, SETTINGS] -> pop -> [HOME] -> 显示 HOME。

### 8. 系统返回键
- Navigation-Compose 默认拦截系统返回键，行为等同于 `popBackStack()`。
- 确保系统返回键和按钮返回行为一致。

## 关键逻辑总结
1. 详情页和设置页均通过 CircleIconButton 提供返回操作。
2. 返回使用 `navController.popBackStack()`，弹出当前页面回到来源。
3. 导航栈由 NavController 管理，保持来源页面上下文。
