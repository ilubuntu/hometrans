# HarmonyOS Queue Page — UI Analysis

**Source:** `view.json` (ArkUI layout dump)
**Device screen:** 1280 × 2832 px (density 3× → **426.7 × 944 vp**)
**Page:** `pages/QueuePage.ets`
**Conversion:** px ÷ 3 = vp

---

## Component Inventory

| # | Component | Text content | Size & Layout (px → vp) | Color & Background | Typography | State & Interaction |
|---|-----------|-------------|------------------------|--------------------|------------|---------------------|
| 1 | **System Status Bar** (WindowScene) | `12:46` (clock) | 1280×136 px → 426.7×45.3 vp `[0,0][1280,136]` | System status-bar styling; bg `#00FFFFFF` | System clock | System-managed |
| 2 | **Root Container** `aid=0` | — | 1280×2695 px → 426.7×898.3 vp `[0,137][1280,2832]` | Transparent (`#00000000`) | — | `focused=true` |
| 3 | **Page Column** `aid=4` | — | 1280×2597 px → 426.7×865.7 vp `[0,137][1280,2734]` | `#00000000` | — | — |
| 4 | **Toolbar Row** `aid=5` | — | 1280×195 px → 426.7×65 vp `[0,137][1280,332]` | `#FFF9FCFF` (`background_light`) | — | — |
| 5 | **Toolbar Title (Text)** `aid=6` | `Queue` | 972×82 px → 324×27.3 vp `[56,193][1028,275]`; left padding ~56 px (18.7 vp) | `app.color.black` (`#ff000000`) | 20 fp, `FontWeight.Medium`, single line ellipsis | Static |
| 6 | **Search Icon (Image)** `aid=7` | — (accessibility: `Search`) | 84×84 px → 28×28 vp `[1028,192][1112,276]`; margin-right 16 vp | `fillColor=app.color.black`; placeholder `ic_feed_black` | — | `clickable=true`; calls `viewModel.search()` |
| 7 | **Overflow Icon (Image)** `aid=8` | — (accessibility: `More`) | 84×84 px → 28×28 vp `[1168,192][1252,276]`; margin-right 8 vp | `fillColor=app.color.black`; placeholder `ic_refresh_black` | — | `clickable=true`; `bindMenu()` opens overflow (Refresh, Lock queue, Sort, Clear queue) |
| 8 | **Content Column** `aid=9` | — | 1280×2178 px → 426.7×726 vp `[0,332][1280,2510]`; `layoutWeight(1)` | `#FFF9FCFF` (`background_light`) | — | — |
| 9 | **Empty Placeholder Text** `aid=36` | `Queue` | 170×66 px → 56.7×22 vp `[555,1388][725,1454]`; centered | (default text color) | ~20 fp | **Placeholder** — full empty view (icon + title + message) not rendered |
| 10 | **Bottom Navigation Row** `aid=19` | — | 1280×224 px → 426.7×74.7 vp `[0,2510][1280,2734]`; height 64 vp | `#FFEFEEEE` (`background_elevated_light`) | — | — |
| 11 | **Nav: Home** `aid=20` | `Home` | 256×224 px → 85.3×74.7 vp `[0,2510][256,2734]` | Icon `grey600` (`ic_feed_black` placeholder), label `grey600`; 12 fp | Icon 28 vp (24 vp target) + label 12 fp | `clickable=true`; `currentTab===0` → active tint `accent_light` |
| 12 | **Nav: Queue** `aid=23` | `Queue` | 256×224 px → 85.3×74.7 vp `[256,2510][512,2734]` | Icon+label tinted `accent_light` (`#0078C2`); **no active indicator pill** | Icon 24 vp + label 12 fp | `clickable=true`; **currently active** (`currentTab===1`) |
| 13 | **Nav: Inbox** `aid=26` | `Inbox` | 256×224 px → 85.3×74.7 vp `[512,2510][768,2734]` | Icon `grey600` (placeholder `ic_feed_black`), label `grey600`; 12 fp | Icon 24 vp + label 12 fp | `clickable=true`; inactive |
| 14 | **Nav: Subscriptions** `aid=29` | `Subscriptions` | 256×224 px → 85.3×74.7 vp `[768,2510][1024,2734]` | Icon `grey600` (`ic_subscriptions_black`), label `grey600`; 12 fp | Icon 24 vp + label 12 fp | `clickable=true`; inactive |
| 15 | **Nav: More** `aid=32` | `More` | 256×224 px → 85.3×74.7 vp `[1024,2510][1280,2734]` | Icon `grey600` (placeholder `ic_refresh_black`), label `grey600`; 12 fp | Icon 24 vp + label 12 fp | `clickable=true`; inactive |

---

## Notable Issues (from view dump)

1. **Missing Info Bar** — Android shows `#info_bar` with `"0 episodes • 0 minutes left"`. HarmonyOS renders the `InfoBarBuilder()` but `viewModel.infoBarText` appears to be empty/placeholder and the Row is not visible in the dump.
2. **Incomplete Empty State** — Android renders full empty view (icon `ic_playlist_play` + title `"No queued episodes"` + descriptive message). HarmonyOS shows only a bare `Text("Queue")` centered — the `EmptyContent()` builder is **not** being invoked; the content area shows a fallback label instead.
3. **Placeholder Icons** — Toolbar search uses `ic_feed_black` instead of `ic_search`; toolbar overflow uses `ic_refresh_black` instead of `ic_more_vert`. Bottom nav Home and Inbox use `ic_feed_black` placeholders; More uses `ic_refresh_black`.
4. **No active indicator pill** — Android's active tab has a `navigation_bar_item_active_indicator_view` rounded pill. HarmonyOS has no equivalent indicator background.
5. **Status bar present** — HarmonyOS includes the system status bar (clock `12:46`) in the layout; Android captures from below it.

---

## Layout Summary

```
┌─────────────────────────────────────┐
│ Status bar (12:46)                   │  0–136 px
├─────────────────────────────────────┤
│ Queue               [feed] [refresh] │  Toolbar 137–332 px
├─────────────────────────────────────┤
│                                      │
│           Queue  ← placeholder       │  Content 332–2510 px
│                                      │
├─────────────────────────────────────┤
│ Home  Queue  Inbox  Subs  More       │  Bottom nav 2510–2734 px
└─────────────────────────────────────┘
```
