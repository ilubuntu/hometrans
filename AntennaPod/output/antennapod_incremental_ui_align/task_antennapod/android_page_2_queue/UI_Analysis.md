# Android Queue Page — UI Analysis

**Source:** `view.xml` (Uiautomator dump)
**Device screen:** 1344 × 2992 px (density 3× → **448 × 997.3 vp**)
**Package:** `de.danoeh.antennapod.debug`
**Conversion:** px ÷ 3 = vp/dp

---

## Component Inventory

| # | Component | Text content | Size & Layout (px → vp) | Color & Background | Typography | State & Interaction |
|---|-----------|-------------|------------------------|--------------------|------------|---------------------|
| 1 | **Root FrameLayout** | — | 1344×2992 px → 448×997.3 vp, full screen `[0,0]` | System default | — | — |
| 2 | **Appbar (LinearLayout)** `#appbar` | — | 1344×388 px → 448×129.3 vp `[0,0][1344,388]` | App background (`background_light`) | — | — |
| 3 | **Toolbar (ViewGroup)** `#toolbar` | — | 1344×192 px → 448×64 vp `[0,159][1344,351]` | App background | — | `long-clickable=true` (scrolls list to top) |
| 4 | **Toolbar Title (TextView)** | `Queue` | 187×88 px → 62.3×29.3 vp `[48,211][235,299]`; left padding 48 px (16 vp) | `black`/`text_primary` | Bold-ish title, ~20 sp | Static |
| 5 | **Search Button** `#action_search` | — (desc: `Search`) | 144×144 px → 48×48 vp `[1080,183][1224,327]` | Transparent, icon tint `grey600`/icon | Icon 24 dp | `clickable=true`; launches search |
| 6 | **Overflow Menu (ImageView)** | — (desc: `More options`) | 120×144 px → 40×48 vp `[1224,183][1344,327]` | Transparent, icon tint | Icon 24 dp | `clickable=true`, `long-clickable=true`; opens popup menu (Refresh, Lock queue, Sort, Clear queue) |
| 7 | **Info Bar (TextView)** `#info_bar` | `0 episodes • 0 minutes left` | 1344×49 px → 448×16.3 vp `[0,315][1344,364]`; full width | App background | ~12 sp, `grey600` color | Static; updates with queue state |
| 8 | **Content area / SwipeRefresh** `#swipeRefresh` | — | 1344×2340 px → 448×780 vp `[0,388][1344,2728]` | App background | — | Scrollable container (empty state shown) |
| 9 | **Empty View Icon (ImageView)** `#emptyViewIcon` | — | 96×96 px → 32×32 vp `[624,1230][720,1326]`; centered horizontally | Tint `grey600` (`ic_playlist_play`) | — | Static |
| 10 | **Empty View Title (TextView)** `#emptyViewTitle` | `No queued episodes` | 434×65 px → 144.7×21.7 vp `[455,1326][889,1391]`; centered | `black`/`text_primary` | ~20 sp, bold | Static |
| 11 | **Empty View Message (TextView)** `#emptyViewMessage` | `Add an episode by downloading it, or long press an episode and select "Add to queue".` | 1104×106 px → 368×35.3 vp `[120,1391][1224,1497]`; centered with side padding | `grey600` | ~14 sp, regular | Static |
| 12 | **Bottom Navigation** `#bottomNavigationView` | — | 1344×192 px → 448×64 vp `[0,2728][1344,2920]` | `background_elevated_light` (`#EFEEEE`) | — | — |
| 13 | **Nav: Home** `#bottom_navigation_home` | `Home` | 269×192 px → 89.7×64 vp `[0,2728][269,2920]` | Icon `grey600`, label 12 sp small | Icon 72 px (24 vp) + label | `clickable=true`; inactive |
| 14 | **Nav: Queue** `#bottom_navigation_queue` | `Queue` | 269×192 px → 89.7×64 vp `[269,2728][538,2920]` | **Active** — icon+label tinted `accent_light` (`#0078C2`); has `active_indicator_view` pill background `[307,2746][499,2842]` | Icon 24 dp + label 12 sp large | Selected/current tab |
| 15 | **Nav: Inbox** `#bottom_navigation_inbox` | `Inbox` | 269×192 px → 89.7×64 vp `[538,2728][807,2920]` | Icon `grey600`, label 12 sp small | Icon 24 dp | `clickable=true`; inactive |
| 16 | **Nav: Subscriptions** `#bottom_navigation_subscriptions` | `Subscriptions` | 269×192 px → 89.7×64 vp `[807,2728][1076,2920]` | Icon `grey600`, label 12 sp small | Icon 24 dp | `clickable=true`; inactive |
| 17 | **Nav: More** `#bottom_navigation_more` | `More` | 268×192 px → 89.3×64 vp `[1076,2728][1344,2920]` | Icon `grey600`, label 12 sp small | Icon 24 dp | `clickable=true`; inactive |

---

## Layout Summary

```
┌─────────────────────────────────────┐
│ Appbar (toolbar + info bar)          │  0–388 px (0–129 vp)
│   Queue          [🔍] [⋮]            │
│   0 episodes • 0 minutes left        │
├─────────────────────────────────────┤
│                                      │
│         [empty icon]                 │  Content (SwipeRefresh)
│      No queued episodes             │  388–2728 px
│   Add an episode by downloading...   │
│                                      │
├─────────────────────────────────────┤
│ Home  Queue  Inbox  Subs  More       │  Bottom nav 2728–2920 px
└─────────────────────────────────────┘
```
