# UI Comparison — Subscriptions Page (Android vs HarmonyOS)

**Android:** 1344×2992 px @3× → 448×997 vp
**HarmonyOS:** 1280×2832 px @3× → ~427×944 vp

---

| UI Component | 文本内容 | 尺寸与布局 | 颜色与背景 | 边框与轮廓 | 文本样式 | 变换与效果 | 状态与交互反馈 | Diff |
|---|---|---|---|---|---|---|---|---|
| **Toolbar / App bar** | A: container "Subscriptions" / H: container | A: h64vp, full width / H: h65vp, full width | A: Material surface (white) / H: `#FFF9FCFF` (near-white, slight blue tint) | 无 | — | — | A: long-click scroll-to-top / H: long-press scrollToIndex(0) | 高度基本一致 (64↔65vp)。HarmonyOS 背景色为 `#F9FCFF` 带轻微蓝调,与 Android 纯白略有差异。功能一致。 ✅ Minor |
| **Toolbar Title** | A: "Subscriptions" / H: "Subscriptions" | A: x16 w134vp / H: x19 w324vp (layoutWeight 撑满) | A: 黑色 / H: 黑色 (`app.color.black`) | 无 | A: ~20sp Medium / H: 20fp Medium, maxLines=1, ellipsis | — | 均不可点击 | 文本与字号一致。HarmonyOS 用 layoutWeight(1) 占据剩余宽度导致文字区域更宽。✅ Match |
| **Search icon/button** | A: desc="Search" (icon) / H: 无 desc (icon) | A: 48×48vp at x360 / H: 28×28vp at x343 | A: `ic_search` tinted colorControlNormal / H: **`ic_feed_black`** placeholder, fillColor=black | 无 | — | — | A: clickable (Button) / H: clickable (Image) | **图标错误**: HarmonyOS 使用 `ic_feed_black` 占位图而非 `ic_search`。图标尺寸偏小 (28vp vs 48vp)。点击区域更小。⚠ Icon mismatch |
| **Overflow / More** | A: desc="More options" (icon) / H: 无 desc (icon) | A: 40×48vp at x408 / H: 28×28vp at x389 | A: `ic_more_vert` tinted / H: **`ic_refresh_black`** placeholder, fillColor=black | 无 | — | — | A: clickable + long-clickable / H: clickable + bindMenu | **图标错误**: HarmonyOS 使用 `ic_refresh_black` 占位图而非 `ic_more_vert`。尺寸偏小。菜单功能存在。⚠ Icon mismatch |
| **Content area** | A: ScrollView (swipeRefresh) / H: Column | A: y117–909 h793vp / H: y65–837 h772vp | A: 页面背景 / H: `#FFF9FCFF` (background_light) | 无 | — | — | A: 可滚动 / H: 应可滚动 (Grid scrollBar Auto) | 区域大小接近。✅ Match |
| **Empty-view Icon** | A: `ic_subscriptions` icon / H: **缺失** | A: 32×32vp 居中 (y477) / H: 不存在 | A: grey600 tint / H: — | 无 | — | — | A: 不可点击 / H: — | **缺失**: HarmonyOS 空状态未渲染图标。源码 `EmptyContent` 中定义了 `ic_subscriptions_black` 但未出现在布局中。❌ Missing |
| **Empty-view Title** | A: "No subscriptions" / H: **"Subscriptions"** ⚠ | A: 居中 w121vp / H: 居中 w115vp | A: 黑色 / H: 黑色 | 无 | A: ~16sp / H: 16fp | — | 均不可点击 | **文本错误**: HarmonyOS 显示 "Subscriptions" 而非 "No subscriptions"。源码引用 `no_subscriptions_head_label`,但实际渲染为 subscriptions 标签,疑似字符串资源映射错误或加载了错误分支。❌ Wrong text |
| **Empty-view Message** | A: "To subscribe to a podcast, press the plus icon below." / H: **缺失** | A: 居中 w328vp / H: 不存在 | A: grey600 / H: — | 无 | A: ~14sp / H: — | — | A: 不可点击 / H: — | **缺失**: HarmonyOS 空状态未渲染说明文字。源码 `EmptyContent` 中定义了 `no_subscriptions_label` Text 但未出现。❌ Missing |
| **FAB (Add podcast)** | A: desc="Add podcast" / H: **缺失** | A: 56×56vp, 圆形, bottom-end (x376 y837) / H: 不存在 | A: accent_light 背景, 白色 `+` 图标 / H: — | A: borderRadius=28 (圆形) | A: '+' 30sp white | A: shadow (radius 4, #66000000, offsetY 2) | A: clickable / H: — | **缺失**: HarmonyOS 未渲染 FAB。源码 `FabButton` 定义存在 (`if (!this.selectMode)`),但布局 dump 中完全缺失。❌ Missing |
| **Bottom Nav container** | A: FrameLayout / H: Row | A: h64vp / H: h75vp (更高) | A: surface 白色 / H: `#FFEFEEEE` (浅灰) | 无 | — | — | 均不可点击(容器) | **高度不一致** (64vp vs 75vp)。**背景色不一致**: HarmonyOS 为浅灰 `#EFEEEE`,Android 为白色。⚠ Mismatch |
| **Nav: Home** | A: "Home" / H: "Home" | A: w90vp / H: w85vp | A: 未选中 tint / H: 默认 | 无 | A: small label ~12sp / H: ~12fp | — | A: clickable / H: clickable | 基本一致。✅ Match |
| **Nav: Queue** | A: "Queue" / H: "Queue" | A: w90vp / H: w85vp | 同上 | 无 | 同上 | — | A: clickable / H: clickable | ✅ Match |
| **Nav: Inbox** | A: "Inbox" / H: "Inbox" | A: w90vp / H: w85vp | 同上 | 无 | 同上 | — | A: clickable / H: clickable | ✅ Match |
| **Nav: Subscriptions (active)** | A: "Subscriptions" (selected) / H: "Subscriptions" | A: w90vp, 大标签 / H: w85vp, 大标签 | A: **selected=true**, accent 色高亮, 激活指示药丸 / H: **selected=false**, 无高亮 | A: 激活指示背景 (accent tint) | A: large label 14sp Bold / H: 14fp (大标签) | — | A: clickable=false (当前页) / H: clickable=true | **选中态缺失**: HarmonyOS 当前页 Subscriptions 没有视觉选中反馈——无 accent 色图标、无激活指示药丸、`selected=false`。Android 当前页应高亮显示。❌ Selected state missing |
| **Nav: More** | A: "More" / H: "More" | A: w90vp / H: w85vp | A: 未选中 / H: 默认 | 无 | A: small ~12sp / H: ~12fp | — | A: clickable / H: clickable | ✅ Match |

---

## Summary of Diffs

### ❌ Critical (Missing / Wrong)
1. **FAB "Add podcast" 缺失** — HarmonyOS 布局中完全没有 FAB 按钮,用户无法从此页添加播客。(源码已定义 `FabButton`,需排查为何未渲染)
2. **空状态图标缺失** — Android 显示 `ic_subscriptions` (32vp),HarmonyOS 未渲染。
3. **空状态说明文字缺失** — Android 显示 "To subscribe to a podcast, press the plus icon below.",HarmonyOS 未渲染。
4. **空状态标题文本错误** — HarmonyOS 显示 "Subscriptions",应为 "No subscriptions"。
5. **底部导航选中态缺失** — Subscriptions 作为当前页,HarmonyOS 无 accent 高亮 / 激活指示药丸,`selected=false`。

### ⚠️ Minor (Icon / Style mismatch)
6. **搜索图标错误** — 使用 `ic_feed_black` 占位,应为 `ic_search`。
7. **溢出菜单图标错误** — 使用 `ic_refresh_black` 占位,应为 `ic_more_vert`。
8. **底部导航背景色** — HarmonyOS `#EFEEEE` (浅灰) vs Android 白色。
9. **底部导航高度** — HarmonyOS 75vp vs Android 64vp (略高)。
10. **工具栏背景微蓝调** — `#F9FCFF` vs 纯白。

### ✅ Match
- 标题 "Subscriptions" 文本、字号、字重一致。
- 5 项底部导航结构一致 (Home / Queue / Inbox / Subscriptions / More)。
- 内容区域布局结构基本一致。
