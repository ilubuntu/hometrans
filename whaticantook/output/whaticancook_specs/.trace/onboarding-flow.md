# Trace: onboarding-flow (REQ-001)

> 首次启动与引导页。追踪 Android 端 Onboarding 引导流程的代码实现，用于撰写平台无关的规格文档。

## 关键源文件
- `app/src/main/java/com/whaticancook/app/feature/onboarding/OnboardingScreen.kt` — 引导页 UI 主体
- `app/src/main/java/com/whaticancook/app/feature/onboarding/OnboardingViewModel.kt` — 完成/跳过逻辑
- `app/src/main/java/com/whaticancook/app/navigation/WccApp.kt` — 路由控制
- `app/src/main/java/com/whaticancook/app/MainActivity.kt` — 启动入口、决定是否进入引导
- `app/src/main/java/com/whaticancook/app/feature/app/AppViewModel.kt` — 提供 onboardingComplete 状态

## 引导页内容（3 页，固定顺序）
OnboardingScreen.kt:45-49 定义 `pages`，每页包含 emoji、渐变背景索引、标题、正文：

| # | emoji | 渐变索引 | 标题 | 正文 |
|---|-------|---------|------|------|
| 1 | 🥘 | 0 | Cook with what you have | Tell WhatCanICook the ingredients in your kitchen and skip the extra grocery run. |
| 2 | ✨ | 1 | Instant recipe matches | We surface meals you can make right now — and show exactly what you're missing for the rest. |
| 3 | ❤️ | 3 | Build your cookbook | Save the dishes you love so your favorites are always one tap away. |

> 首页标题 "Cook with what you have" 与验收重点一致。第 3 页使用渐变索引 3（跳过 2）。

## UI 结构（OnboardingScreen.kt:51-127）
- 容器：全屏列布局，应用背景色，顶部状态栏安全间距、底部导航栏安全间距 (line 60-66)。
- 顶部 Skip 文字按钮 (line 67-82)：右对齐，圆角可点击，点击调用 `viewModel.complete(onFinish)`。
- 中间可滑动翻页区域 `HorizontalPager` (line 84-89)：`pageCount = pages.size = 3`，支持左右滑动；每页渲染 `OnboardPageContent`。
- 页码指示器圆点 (line 91-112)：3 个圆点，当前页圆点宽 24dp、主色；其余宽 8dp、outline 色；宽度/颜色做过渡动画。
- 底部主操作按钮 `WccPrimaryButton` (line 114-126)：
  - 非末页 → 文案 "Next"，点击 `pagerState.animateScrollToPage(currentPage + 1)` 滚到下一页。
  - 末页 (isLast，即第 3 页) → 文案 "Start cooking"，点击 `viewModel.complete(onFinish)` 完成引导。

## 单页内容（OnboardPageContent, line 130-163）
- 居中 180dp 圆形渐变背景区域，内含大号 emoji 文本。
- 标题（displaySmall）居中，正文（bodyLarge，onSurfaceVariant）居中。

## 完成流程（OnboardingViewModel.kt:14-19）
```
complete(onDone):
  settings.setOnboardingComplete(true)   // 持久化（见 onboarding-persist trace）
  onDone()                               // 回调：导航到首页并出栈引导页
```

## 跳过流程
Skip 与 Start cooking 走同一个 `complete` 逻辑（差别仅在交互入口）。

## 导航衔接（WccApp.kt:81-89）
```
onFinish:
  navController.navigate(HOME) {
    popUpTo(ONBOARDING) { inclusive = true }   // 引导页出栈，无法返回
  }
```

## 是否进入引导的判断（见 onboarding-persist）
- `MainActivity:38`: `WccApp(startOnboarding = !state.onboardingComplete)`
- `WccApp:64`: `startDestination = if (startOnboarding) ONBOARDING else HOME`

## 偏差/备注
- REQ 描述中提到"插画"，实现使用 emoji + 渐变圆形背景，没有外部图片资源。规格中应表述为"图形/视觉元素"，不绑定具体技术。
- REQ-001 验收重点"首屏文案为 Cook with what you have"与代码一致。
- Skip 与 Start cooking 行为相同（都调用 complete），符合"可直接进入主界面"。
