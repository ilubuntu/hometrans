# Trace: empty-pantry-hint (REQ-005)

> 空食材库时的首页提示。追踪 pantry 为空时首页的引导文案与交互。

## 关键源文件
- `app/src/main/java/com/whaticancook/app/feature/home/HomeScreen.kt` — PantrySummaryCard、CookNowPrompt
- `app/src/main/java/com/whaticancook/app/feature/home/HomeViewModel.kt` — cookNow 计算

## PantrySummaryCard 副标题（HomeScreen.kt:252-258）
```
count == 0 → "Add what you have at home"
count == 1 → "1 ingredient ready"
count > 1 → "$count ingredients ready"
```
- 整张卡片可点击（bounceClick）→ onOpenPantry。

## Ready to cook 区不显示（空 pantry）
HomeViewModel.kt:89-92：
```
cookNow = withMatch.filter { it.match.isCookable && pantryNames.isNotEmpty() }
```
- pantry 为空 → `pantryNames.isNotEmpty()` 为 false → cookNow 必为空。
- HomeScreen.kt:100 `if (state.cookNow.isNotEmpty())` 不成立 → 不渲染 "Ready to cook" 横向列表。
- HomeScreen.kt:118 `else if (state.pantryCount == 0)` 成立 → 渲染 CookNowPrompt。

## CookNowPrompt（HomeScreen.kt:269-292）
- 图形：🧑‍🍳 表情（displaySmall）。
- 主文案："Tell us what's in your kitchen"（titleMedium）。
- 副文案："Add a few ingredients and we'll show the recipes you can make right now."（bodyMedium）。
- 整块可点击（bounceClick）→ onOpenPantry（进入 Pantry 页）。

## 与验收重点对照
- ✅ pantry 卡片显示 "Add what you have at home"（count==0 副标题）。
- ✅ 显示 "Tell us what's in your kitchen" 提示（CookNowPrompt）。
- ✅ 不显示 "Ready to cook" 横向列表（cookNow 为空且不渲染）。
- ✅ 点击提示或 pantry 卡片进入 Pantry（两者均 → onOpenPantry）。

## 偏差/备注
- 提示区使用 🧑‍🍳 表情图形，非图片资源。
- 空态触发条件严格为 `pantryCount == 0`；只要 pantry 非空，即使没有可做菜谱，也不再显示 CookNowPrompt（此时 cookNow 为空但 pantryCount≠0，两个分支都不进，仅显示 Browse recipes）。
