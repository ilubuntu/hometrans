# Trace: discover-layout (REQ-004)

> Discover 首页基础布局。追踪首页（HomeScreen）整体结构与各组成区块。

## 关键源文件
- `app/src/main/java/com/whaticancook/app/feature/home/HomeScreen.kt` — 首页 UI 主体
- `app/src/main/java/com/whaticancook/app/feature/home/HomeViewModel.kt` — 状态与数据
- `app/src/main/java/com/whaticancook/app/navigation/WccApp.kt` — 底部导航高亮
- `app/src/main/java/com/whaticancook/app/core/designsystem/component/Headers.kt` — SectionHeader

## 首页状态分支（HomeScreen.kt:57-74）
```
Loading  → HomeLoading()（骨架屏，见 REQ-042）
Error    → ErrorState(onRetry = seed)（见 REQ-042）
Content  → HomeContent(...)
```

## HomeContent 布局（line 87-155）
垂直滚动列表（LazyColumn），从上到下依次：

1. **HomeHeader**（line 158-191）
   - 左：问候语（titleMedium）+ 标题 "What can I cook?"（displaySmall）
   - 右：设置图标按钮（44dp 圆形，Settings 图标），点击 → onOpenSettings。

2. **SearchBarButton**（line 194-218）
   - 样式：搜索框外观（圆角 52dp 高，Search 图标 + 占位文案 "Search recipes, ingredients…"）。
   - 实为可点击区域（非真实输入框），点击 → onOpenSearch 进入搜索页。

3. **PantrySummaryCard**（line 221-266）
   - "Your pantry" 标题 + 副标题（依据食材数量，见 REQ-005）+ Kitchen 图标 + 右箭头。
   - 点击 → onOpenPantry 进入 Pantry 页。

4. **条件区块：Ready to cook 横向列表**（line 100-117）
   - 仅当 `cookNow.isNotEmpty()` 时显示：SectionHeader("Ready to cook", actionText=数量) + 横向列表（LazyRow）的 CompactRecipeCard。
   - cookNow = 满足全部必需食材且 pantry 非空的菜谱，按耗时升序（HomeViewModel.kt:89-92）。

5. **"Browse recipes" SectionHeader**（line 122-124）

6. **分类筛选 Chips 行**（line 125-143）：横向 LazyRow，"All" + 各分类 chip（见 REQ-007）。

7. **菜谱列表**（line 145-153）：每个 RecipeCard（见 REQ-006）。

## 问候语（HomeViewModel.kt:108-113）
```
hour 5-11   → "Good morning"
hour 12-16  → "Good afternoon"
hour 17-21  → "Good evening"
else        → "Hungry tonight?"
```

## 底部导航高亮
- WccApp.kt:38-39：`tabRoutes = TopLevelTab.entries.map{route}.toSet()`；`showBottomBar = currentRoute in tabRoutes`。
- 首页路由 Routes.HOME 属于 tab，进入首页时 Discover 对应 tab 高亮（WccBottomBar）。

## 可点击交互入口
- 设置图标 → onOpenSettings
- 搜索条 → onOpenSearch
- pantry 卡片 → onOpenPantry
- Ready to cook 卡片 / Browse 菜谱卡片 → onRecipeClick(id)
- 分类 chip → onSelectCategory

## 偏差/备注
- 搜索栏在首页是"伪输入框"（点击跳转搜索页），非真实输入控件。规格表述为"搜索入口（点击进入搜索）"。
- 布局为 Jetpack Compose LazyColumn/LazyRow。规格按"垂直滚动列表 + 横向滚动区"描述。
