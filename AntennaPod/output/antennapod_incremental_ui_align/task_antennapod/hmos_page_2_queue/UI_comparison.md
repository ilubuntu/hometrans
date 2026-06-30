# UI Comparison — AntennaPod Queue Page (Android vs HarmonyOS)

**Android:** 1344 × 2992 px @ 3× density (448 × 997 vp) — `de.danoeh.antennapod.debug`
**HarmonyOS:** 1280 × 2832 px @ 3× density (426.7 × 944 vp) — `com.example.antennapodharmony`

---

## Component-by-Component Comparison

| UI Component | 文本内容 (Text) | 尺寸与布局 (Size & Layout) | 颜色与背景 (Color & Background) | 边框与轮廓 (Border & Outline) | 文本样式 (Typography) | 变换与效果 (Transform & Effect) | 状态与交互反馈 (State & Interaction) | Diff |
|---|---|---|---|---|---|---|---|---|
| **Status Bar** | A: — (not captured) / H: `12:46` | A: N/A / H: 1280×136 px (426.7×45.3 vp) `[0,0]` | A: — / H: bg `#00FFFFFF` | — | A: — / H: system clock | — | A: system-managed / H: system-managed | ⚠️ HarmonyOS includes system status bar in layout; Android dump starts below it. Not a functional diff. |
| **Appbar / Toolbar Container** | — | A: 1344×192 px (448×64 vp) `[0,159][1344,351]` / H: 1280×195 px (426.7×65 vp) `[0,137][1280,332]` | A: `background_light` / H: `#FFF9FCFF` (`background_light`) — **match** | — | — | — | A: `long-clickable` (scroll to top) / H: `LongPressGesture` (TODO stub) | ✅ Layout matches (~64 vp). ⚠️ Long-press handler is a TODO in HarmonyOS. |
| **Toolbar Title** | A: `Queue` / H: `Queue` | A: 187×88 px (62.3×29.3 vp) `[48,211]` / H: 972×82 px (324×27.3 vp) `[56,193]` | A: `black` / H: `app.color.black` (`#000000`) — **match** | — | A: ~20 sp title / H: 20 fp `FontWeight.Medium`, single-line ellipsis — **match** | — | A: static / H: static | ⚠️ H text node is much wider (972 px vs 187 px) — it uses `layoutWeight(1)` to fill remaining toolbar space, so the visible text is the same but the tap/hit area differs. Functionally equivalent. |
| **Search Action Icon** | A: (icon) / H: (icon) | A: 144×144 px (48×48 vp) `[1080,183]` / H: 84×84 px (28×28 vp) `[1028,192]` | A: icon tint `grey600` / H: `fillColor=app.color.black` | — | — | — | A: `clickable` Button with `Search` desc / H: `clickable` Image, accessibilityText `Search` | 🔴 **Icon mismatch**: H uses placeholder `ic_feed_black` instead of `ic_search`. ⚠️ H fillColor is `black` vs A `grey600`; H icon size 28 vp rendered (24 vp target) vs A 48 vp touch target. |
| **Overflow / More Icon** | A: (icon) / H: (icon) | A: 120×144 px (40×48 vp) `[1224,183]` / H: 84×84 px (28×28 vp) `[1168,192]` | A: icon tint / H: `fillColor=app.color.black` | — | — | — | A: `clickable`+`long-clickable`, desc `More options`, opens popup menu / H: `clickable`+`bindMenu()`, opens overflow menu | 🔴 **Icon mismatch**: H uses `ic_refresh_black` instead of `ic_more_vert`. Menu items match (Refresh, Lock, Sort, Clear). ⚠️ H missing `long-clickable`. |
| **Info Bar** | A: `0 episodes • 0 minutes left` / H: *(empty/missing)* | A: 1344×49 px (448×16.3 vp) `[0,315][1344,364]` / H: **not rendered** | A: `grey600` text on `background_light` / H: — | — | A: ~12 sp / H: — | — | A: static, updates with queue / H: `InfoBarBuilder` exists but `viewModel.infoBarText` empty | 🔴 **Missing in rendered output.** The `InfoBarBuilder` is in code but produces no visible node. Should display episode count + time remaining. |
| **Content / Empty View Icon** | A: (icon) / H: *(missing)* | A: 96×96 px (32×32 vp) `[624,1230]`, centered / H: not present | A: `ic_playlist_play` tinted `grey600` / H: — | — | — | — | A: static / H: — | 🔴 **Missing.** HarmonyOS `EmptyContent()` defines this icon but it is not rendered — only a bare `Text("Queue")` appears. |
| **Content / Empty View Title** | A: `No queued episodes` / H: `Queue` *(wrong text)* | A: 434×65 px (144.7×21.7 vp), centered / H: 170×66 px (56.7×22 vp), centered | A: `black` / H: default | — | A: ~20 sp bold / H: ~20 fp | — | A: static / H: static | 🔴 **Wrong text.** H shows `Queue` instead of `No queued episodes`. The `EmptyContent()` builder is not being invoked. |
| **Content / Empty View Message** | A: `Add an episode by downloading it, or long press an episode and select "Add to queue".` / H: *(missing)* | A: 1104×106 px (368×35.3 vp), centered w/ padding / H: not present | A: `grey600` / H: — | — | A: ~14 sp / H: — | — | A: static / H: — | 🔴 **Missing.** The descriptive message text is not rendered. |
| **Bottom Nav Container** | — | A: 1344×192 px (448×64 vp) `[0,2728]` / H: 1280×224 px (426.7×74.7 vp) `[0,2510]` | A: `background_elevated_light` (`#EFEEEE`) / H: `#FFEFEEEE` — **match** | — | — | — | — | ⚠️ H nav height 74.7 vp vs A 64 vp — H is ~10 vp taller. Minor. |
| **Nav: Home** | A: `Home` / H: `Home` | A: 269×192 px (89.7×64 vp) / H: 256×224 px (85.3×74.7 vp) | A: icon `grey600`, label small 12 sp / H: icon+label `grey600` (inactive) | — | A: label 12 sp small / H: label 12 fp | — | A: `clickable` / H: `clickable` | 🔴 **Icon mismatch**: H uses `ic_feed_black` placeholder instead of `ic_home`. |
| **Nav: Queue (active)** | A: `Queue` / H: `Queue` | A: 269×192 px (89.7×64 vp) / H: 256×224 px (85.3×74.7 vp) | A: icon+label `accent_light` (`#0078C2`) **+ active indicator pill** / H: icon+label `accent_light` — **no pill** | A: rounded pill indicator `[307,2746][499,2842]` / H: **none** | A: label 12 sp **large** (active) / H: label 12 fp (same size) | — | A: selected / H: `currentTab===1` active | ⚠️ **Missing active indicator pill** in HarmonyOS. ⚠️ Active label not enlarged (A uses large vs small label). |
| **Nav: Inbox** | A: `Inbox` / H: `Inbox` | A: 269×192 px / H: 256×224 px | A: icon `grey600` / H: icon `grey600` (inactive) | — | A: 12 sp small / H: 12 fp | — | A: `clickable` / H: `clickable` | 🔴 **Icon mismatch**: H uses `ic_feed_black` placeholder instead of `ic_inbox`. |
| **Nav: Subscriptions** | A: `Subscriptions` / H: `Subscriptions` | A: 269×192 px / H: 256×224 px | A: icon `grey600` / H: icon `grey600` (inactive) | — | A: 12 sp small / H: 12 fp | — | A: `clickable` / H: `clickable` | ✅ Icon `ic_subscriptions_black` matches. Minor size diff. |
| **Nav: More** | A: `More` / H: `More` | A: 268×192 px / H: 256×224 px | A: icon `grey600` / H: icon `grey600` (inactive) | — | A: 12 sp small / H: 12 fp | — | A: `clickable` / H: `clickable` | 🔴 **Icon mismatch**: H uses `ic_refresh_black` placeholder instead of overflow dots icon. |

---

## Summary of Diffs

### 🔴 Critical (functional/visual mismatch)

| # | Issue | Android | HarmonyOS | Fix |
|---|-------|---------|-----------|-----|
| 1 | **Empty state not rendered** | Full empty view: icon + "No queued episodes" + message | Only bare `Text("Queue")` placeholder | `QueuePage.ets` — verify `isLoading`/`queue.length` state; ensure `EmptyContent()` is invoked. The placeholder text "Queue" at `aid=36` suggests a fallback label leaked into the content area. |
| 2 | **Info Bar missing** | `"0 episodes • 0 minutes left"` below toolbar | Not rendered | `QueuePage.ets:97` `InfoBarBuilder` — `viewModel.infoBarText` is empty. Implement `infoBarText` in `QueueViewModel` to compute episode count + time. |
| 3 | **Toolbar search icon wrong** | `ic_search` | `ic_feed_black` placeholder | `QueuePage.ets:70` — replace `app.media.ic_feed_black` with search icon resource. |
| 4 | **Toolbar overflow icon wrong** | `ic_more_vert` (3-dot vertical) | `ic_refresh_black` placeholder | `QueuePage.ets:82` — replace `app.media.ic_refresh_black` with overflow/more-vert icon. |
| 5 | **Bottom nav Home icon wrong** | `ic_home` | `ic_feed_black` placeholder | `BottomNavigation.ets:10` — replace with home icon. |
| 6 | **Bottom nav Inbox icon wrong** | `ic_inbox` | `ic_feed_black` placeholder | `BottomNavigation.ets:51` — replace with inbox icon. |
| 7 | **Bottom nav More icon wrong** | overflow dots | `ic_refresh_black` placeholder | `BottomNavigation.ets:92` — replace with more/dots icon. |

### ⚠️ Moderate (minor visual/cosmetic)

| # | Issue | Detail |
|---|-------|--------|
| 8 | **Active tab indicator pill missing** | Android active tab has rounded pill background (`active_indicator_view`); HarmonyOS active tab only changes icon+label color. Add a pill background behind the active nav item. |
| 9 | **Active label size** | Android enlarges active label (large vs small); HarmonyOS keeps 12 fp for all. |
| 10 | **Bottom nav height** | H 74.7 vp vs A 64 vp (~10 vp taller). |
| 11 | **Toolbar long-press** | H implements `LongPressGesture` but handler is a TODO stub (no scroll-to-top). |
| 12 | **Search icon tint** | A uses `grey600`; H uses `black`. |

### ✅ Matches

- Toolbar layout, title text `"Queue"`, title typography (20 fp Medium)
- Background colors (`background_light` = `#FFF9FCFF`, `background_elevated_light` = `#EFEEEE`)
- Bottom nav tab labels and order (Home, Queue, Inbox, Subscriptions, More)
- Queue tab active state coloring (`accent_light` = `#0078C2`)
- Subscriptions icon (`ic_subscriptions_black`) correct
- Overflow menu items (Refresh, Lock queue, Sort, Clear queue)
