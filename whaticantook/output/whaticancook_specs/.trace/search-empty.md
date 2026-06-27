# Trace: search-empty (REQ-030)

## 需求原文
当搜索词和筛选组合无匹配结果时，应显示 No recipes found，并提示 Try a different ingredient or clear your filters。搜索不存在的字符串显示空态，不应崩溃或展示旧结果。

## 代码追踪

### 1. 空态判断与展示
**文件**: `app/src/main/java/com/whaticancook/app/feature/search/SearchScreen.kt:113-123`
```kotlin
if (!state.loading && state.results.isEmpty()) {
    Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.TopCenter) {
        EmptyState(
            emoji = "",
            title = "No recipes found",
            message = "Try a different ingredient or clear your filters.",
        )
    }
} else {
    LazyColumn(...) { items(state.results) { ... } }
}
```
- **条件**: `!state.loading && state.results.isEmpty()` — 加载完成且结果列表为空。
- **标题**: "No recipes found"
- **副标题**: "Try a different ingredient or clear your filters."
- **行为**: 不展示旧结果（互斥渲染），无操作按钮（actionLabel=null，不提供快捷操作）。

### 2. loading 状态默认值
**文件**: `SearchViewModel.kt:26-33`
```kotlin
data class SearchUiState(
    val loading: Boolean = true,
    ...
    val results: List<RecipeWithMatch> = emptyList(),
)
```
- 初始状态 `loading=true`，`results=emptyList()`。
- `build()` 返回 `loading=false` 的状态。
- 因此首次加载时不会显示空态（loading 为 true 时跳过）。

### 3. 空态触发场景
**文件**: `SearchViewModel.kt:build()` (行 76-100)
- 文本搜索过滤: `items.filter { r.title.contains(q) || r.category.contains(q) || tags || ingredients }`
- 分类过滤: `items.filter { it.recipe.category == f.category }`
- Cookable 过滤: `items.filter { it.match.isCookable }`
- 任一过滤后 `items` 为空 -> `results=emptyList()` -> 触发空态。

### 4. EmptyState 组件
**文件**: `app/src/main/java/com/whaticancook/app/core/designsystem/component/StateViews.kt:23-65`
```kotlin
fun EmptyState(emoji, title, message, modifier, actionLabel=null, onAction=null) {
    Column(modifier.fillMaxWidth().padding(32.dp), CenterHorizontally, CenterVertically) {
        Box(Modifier.size(96.dp).background(surfaceVariant, RoundedCornerShape(50))) { Text(emoji) }
        Text(title, titleLarge, onBackground, Center)
        Text(message, bodyMedium, onSurfaceVariant, Center)
        if (actionLabel != null && onAction != null) {
            WccPrimaryButton(actionLabel, onAction)
        }
    }
}
```
- 居中展示 emoji 圆形背景 + 标题 + 消息 + 可选操作按钮。
- 搜索空态不传 actionLabel/onAction。

## 关键逻辑总结
1. 空态仅在加载完成且无结果时出现。
2. 不展示旧结果（互斥渲染）。
3. 不崩溃：空列表是合法状态，LazyColumn 不渲染任何 item。
4. 可由文本/分类/Cookable 任一筛选导致。
