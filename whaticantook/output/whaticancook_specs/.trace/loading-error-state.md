# Trace: loading-error-state (REQ-042)

## 需求原文
首页首次初始化时应显示加载骨架；若菜谱初始化失败，应显示错误状态和 Retry。正常路径不长时间停留加载；错误路径可重试。

## 代码追踪

### 1. 首页状态模型
**文件**: `app/src/main/java/com/whaticancook/app/feature/home/HomeViewModel.kt:18-30`
```kotlin
sealed interface HomeUiState {
    data object Loading : HomeUiState
    data object Error : HomeUiState
    data class Content(...) : HomeUiState
}

private enum class SeedState { Loading, Ready, Error }
```
- 三态：Loading（加载中）、Error（初始化失败）、Content（正常内容）。

### 2. 种子数据初始化
**文件**: `HomeViewModel.kt:43-52`
```kotlin
init { seed() }

fun seed() {
    viewModelScope.launch {
        seedState.value = SeedState.Loading
        runCatching { recipeRepository.ensureSeeded() }
            .onSuccess { seedState.value = SeedState.Ready }
            .onFailure { seedState.value = SeedState.Error }
    }
}
```
- ViewModel 创建时自动调用 `seed()`。
- `runCatching` 捕获异常：成功 -> Ready，失败 -> Error。
- Loading 状态在 `ensureSeeded()` 执行期间持续。

### 3. ensureSeeded 实现（延迟设计）
**文件**: `app/src/main/java/com/whaticancook/app/data/repository/RecipeRepositoryImpl.kt:34-44`
```kotlin
override suspend fun ensureSeeded() = withContext(io) {
    seedMutex.withLock {
        if (recipeDao.count() == 0) {
            // A short, deliberate pause so the first-launch loading state is perceptible
            delay(550)
            val dtos = seedSource.load()
            recipeDao.upsertAll(dtos.map { it.toEntity(json) })
        }
    }
}
```
- 仅在数据库为空时执行（幂等）。
- `delay(550)` — 故意延迟 550ms 使加载状态可感知。
- `seedSource.load()` 读取 assets/recipes.json。
- `upsertAll` 写入数据库。
- Mutex 保护防止并发重复种子。

### 4. 状态组合
**文件**: `HomeViewModel.kt:67-72`
```kotlin
val uiState: StateFlow<HomeUiState> = combine(
    seedState, recipeRepository.observeRecipes(),
    pantryRepository.observePantry(), selectedCategory,
) { seed, recipes, pantry, category ->
    when (seed) {
        SeedState.Loading -> HomeUiState.Loading
        SeedState.Error -> HomeUiState.Error
        SeedState.Ready -> buildContent(recipes, pantry, category)
    }
}.stateIn(viewModelScope, SharingStarted.WhileSubscribed(5_000), HomeUiState.Loading)
```
- seedState 驱动三态切换。
- 初始值为 Loading。

### 5. 首页 UI 状态渲染
**文件**: `app/src/main/java/com/whaticancook/app/feature/home/HomeScreen.kt:46-74`
```kotlin
when (val s = state) {
    HomeUiState.Loading -> HomeLoading()
    HomeUiState.Error -> Box(
        Modifier.fillMaxSize().statusBarsPadding(),
        contentAlignment = Alignment.Center,
    ) {
        ErrorState(onRetry = viewModel::seed)
    }
    is HomeUiState.Content -> HomeContent(...)
}
```
- Loading -> 骨架屏。
- Error -> 错误状态 + Retry 按钮（`onRetry = viewModel::seed`，重新执行初始化）。
- Content -> 正常内容。

### 6. ErrorState 组件
**文件**: `app/src/main/java/com/whaticancook/app/core/designsystem/component/StateViews.kt:69-108`
```kotlin
@Composable
fun ErrorState(onRetry: () -> Unit, modifier: Modifier = Modifier,
    title: String = "Something went wrong",
    message: String = "We couldn't load your recipes. Please try again.",
) {
    Column(modifier.fillMaxWidth().padding(32.dp), CenterHorizontally, CenterVertically) {
        Box(Modifier.size(96.dp).background(errorContainer, RoundedCornerShape(50))) {
            Text("", displayMedium)
        }
        Text(title, titleLarge, onBackground, Center)
        Text(message, bodyMedium, onSurfaceVariant, Center)
        Spacer(Modifier.height(24.dp))
        WccTonalButton(text = "Try again", onClick = onRetry)
    }
}
```
- 红色圆形 emoji + 标题 "Something went wrong" + 消息 + "Try again" 按钮。
- "Try again" -> `onRetry` -> `viewModel::seed()` -> 重新初始化。

### 7. 加载骨架屏
**文件**: `HomeScreen.kt` — `HomeLoading()` 函数
- 使用 `RecipeCardSkeleton` 占位组件。
**文件**: `StateViews.kt:111-138` — RecipeCardSkeleton
```kotlin
@Composable
fun RecipeCardSkeleton(modifier: Modifier = Modifier) {
    Column(modifier.fillMaxWidth().background(surface, RoundedCornerShape(24.dp)).padding(12.dp)) {
        Box(Modifier.fillMaxWidth().height(140.dp).shimmer(RoundedCornerShape(16.dp)))
        Spacer(Modifier.height(14.dp))
        Box(Modifier.fillMaxWidth(0.7f).height(18.dp).shimmer(RoundedCornerShape(6.dp)))
        Spacer(Modifier.height(10.dp))
        Box(Modifier.fillMaxWidth(0.45f).height(14.dp).shimmer(RoundedCornerShape(6.dp)))
    }
}
```
- shimmer 闪烁动画骨架，模拟菜谱卡片布局。

## 关键逻辑总结
1. 首次启动 -> seed() -> Loading 骨架屏 -> ensureSeeded(550ms延迟) -> Ready/Error。
2. 错误状态提供 "Try again" 重试，重试调用 seed()。
3. 种子操作幂等（count==0 检查 + Mutex），重试不会重复写入。
4. 正常路径延迟仅约 550ms，不长时间停留。
