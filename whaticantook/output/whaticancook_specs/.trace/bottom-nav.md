# Trace: bottom-nav (REQ-040)

## 需求原文
应用底部导航包含 Discover、Search、Pantry、Saved 四个主入口。切换主入口时应保留各 Tab 基本状态，详情页和设置页不显示底部导航。主 Tab 高亮正确；进入详情页时底部导航消失。

## 代码追踪

### 1. 导航目的地定义
**文件**: `app/src/main/java/com/whaticancook/app/navigation/Destinations.kt:10-34`
```kotlin
object Routes {
    const val ONBOARDING = "onboarding"
    const val HOME = "home"
    const val SEARCH = "search"
    const val PANTRY = "pantry"
    const val FAVORITES = "favorites"
    const val SETTINGS = "settings"
    const val RECIPE_DETAIL = "recipe"
    const val RECIPE_DETAIL_PATTERN = "recipe/{recipeId}"
}

enum class TopLevelTab(val route: String, val label: String, val icon: ImageVector) {
    DISCOVER(Routes.HOME, "Discover", Icons.Rounded.Restaurant),
    SEARCH(Routes.SEARCH, "Search", Icons.Rounded.Search),
    PANTRY(Routes.PANTRY, "Pantry", Icons.Rounded.Kitchen),
    FAVORITES(Routes.FAVORITES, "Saved", Icons.Rounded.BookmarkBorder),
}
```
- 四个顶级 Tab：Discover、Search、Pantry、Saved。
- SETTINGS 和 RECIPE_DETAIL 不是顶级 Tab。

### 2. 底部导航栏显隐控制
**文件**: `app/src/main/java/com/whaticancook/app/navigation/WccApp.kt:22-37`
```kotlin
val backStackEntry by navController.currentBackStackEntryAsState()
val currentRoute = backStackEntry?.destination?.route
val tabRoutes = remember { TopLevelTab.entries.map { it.route }.toSet() }
val showBottomBar = currentRoute in tabRoutes

Scaffold(
    bottomBar = {
        AnimatedVisibility(
            visible = showBottomBar,
            enter = slideInVertically { it } + fadeIn(),
            exit = slideOutVertically { it } + fadeOut(),
        ) {
            WccBottomBar(currentRoute = currentRoute, onSelect = { tab -> ... })
        }
    },
)
```
- `showBottomBar = currentRoute in tabRoutes` — 仅当前路由在四个 Tab 中时显示。
- SETTINGS/RECIPE_DETAIL 不在 tabRoutes -> **底部导航隐藏**。
- 带 AnimatedVisibility 进出动画。

### 3. Tab 切换与状态保留
**文件**: `WccApp.kt:32-37` 和 `WccApp.kt:135-141`
```kotlin
onSelect = { tab ->
    navController.navigate(tab.route) {
        popUpTo(Routes.HOME) { saveState = true }
        launchSingleTop = true
        restoreState = true
    }
}

private fun NavController.navigateToTab(route: String) {
    navigate(route) {
        popUpTo(Routes.HOME) { saveState = true }
        launchSingleTop = true
        restoreState = true
    }
}
```
- `popUpTo(HOME) { saveState = true }` — 弹出到首页，保存各 Tab 状态。
- `launchSingleTop = true` — 避免重复创建同一 Tab。
- `restoreState = true` — 恢复之前保存的 Tab 状态。

### 4. 底部导航栏 UI
**文件**: `app/src/main/java/com/whaticancook/app/navigation/WccBottomBar.kt:32-58`
```kotlin
@Composable
fun WccBottomBar(currentRoute: String?, onSelect: (TopLevelTab) -> Unit, modifier: Modifier = Modifier) {
    Row(
        modifier = modifier.fillMaxWidth().navigationBarsPadding()
            .padding(horizontal = 20.dp, vertical = 12.dp)
            .shadow(16.dp, RoundedCornerShape(50), clip = false)
            .clip(RoundedCornerShape(50))
            .background(MaterialTheme.colorScheme.surface)
            .padding(horizontal = 8.dp, vertical = 8.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
    ) {
        TopLevelTab.entries.forEach { tab ->
            BottomBarItem(tab = tab, selected = currentRoute == tab.route, onClick = { onSelect(tab) })
        }
    }
}
```
- 浮动式药丸形底部栏（RoundedCornerShape(50) + shadow）。

### 5. 底部导航项高亮
**文件**: `WccBottomBar.kt:60-98`
```kotlin
@Composable
private fun BottomBarItem(tab: TopLevelTab, selected: Boolean, onClick: () -> Unit) {
    val bg by animateColorAsState(
        if (selected) colorScheme.primaryContainer else Color.Transparent)
    val fg by animateColorAsState(
        if (selected) colorScheme.onPrimaryContainer else colorScheme.onSurfaceVariant)
    Row(
        modifier = Modifier.clip(RoundedCornerShape(50)).background(bg)
            .bounceClick(onClick = onClick, pressedScale = 0.9f)
            .padding(horizontal = 16.dp, vertical = 11.dp),
    ) {
        Icon(tab.icon, tint = fg, modifier = Modifier.size(22.dp))
        AnimatedVisibility(visible = selected, enter = expandHorizontally() + fadeIn(),
            exit = shrinkHorizontally() + fadeOut()) {
            Row {
                Spacer(Modifier.width(8.dp))
                Text(tab.label, labelLarge, color = fg)
            }
        }
    }
}
```
- **选中项**: primaryContainer 背景 + onPrimaryContainer 前景 + 展开显示文字标签。
- **未选中项**: 透明背景 + onSurfaceVariant 前景 + 仅图标。
- 颜色和展开动画过渡平滑。

## 关键逻辑总结
1. 四个顶级 Tab，非 Tab 页面（详情/设置）隐藏底部导航。
2. Tab 切换通过 saveState/restoreState 保留状态。
3. 当前 Tab 高亮显示，含文字标签展开动画。
