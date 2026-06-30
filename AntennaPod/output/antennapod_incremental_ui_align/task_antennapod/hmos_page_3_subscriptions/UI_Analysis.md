# HarmonyOS Subscriptions Page — UI Analysis

**Source:** `view.json` (ArkUI layout dump)
**Device resolution:** 1280 × 2832 px @ 3× density → ~427 × 944 vp
**Bundle:** `com.example.antennapodharmony` · **Page:** `pages/Index` → `SubscriptionsPage`
**Source code:** `entry/src/main/ets/pages/SubscriptionsPage.ets`

---

## All Components (app UI — status bar excluded)

| Component | Text content | Size & Layout (px → vp) | Color & Background | Typography | State & Interaction |
|---|---|---|---|---|---|
| **Root** (root) aid=0 | — | [0,137][1280,2832] → full app area below status bar | `#00000000` transparent | — | Not clickable; hostWindowId=33 |
| **Main Column** aid=4 | — | [0,137][1280,2734] → w1280 h2597 (w427 h865vp) | `#00000000` transparent | — | Not clickable |
| **Toolbar Row** aid=5 | — | [0,137][1280,332] → w1280 h195 (w427 h65vp) | `#FFF9FCFF` (light surface) | — | Not clickable; container |
| **Title Text** aid=6 | "Subscriptions" | [56,193][1028,275] → x19 y19, w972 h82 (w324 h27vp) | `#00000000` (text color from black) | 20fp Medium, maxLines=1, ellipsis | Not clickable; long-press → scrollToIndex(0) |
| **Search Image** aid=7 | — (icon) | [1028,192][1112,276] → x343 y18, w84 h84 (w28 h28vp) | `ic_feed_black` placeholder, fillColor=black | — | clickable=true; onClick → search() |
| **More Image** aid=8 | — (icon) | [1168,192][1252,276] → x389 y18, w84 h84 (w28 h28vp) | `ic_refresh_black` placeholder, fillColor=black | — | clickable=true; bindMenu (overflow) |
| **Filtered bar** (Row, hidden) | (visibility=None) | — | `#FFF9FCFF` | — | Visibility.None (not rendered) |
| **Content Column** aid=9 | — | [0,332][1280,2510] → y65 to y837, w427 h772vp | `#FFF9FCFF` (background_light) | — | Not clickable |
| **Inner Column** aid=37 | — | [0,332][1280,2510] | `#00000000` | — | — |
| **Empty Text** aid=38 | "Subscriptions" ⚠ | [467,1388][813,1454] → centered, w346 h66 (w115 h22vp) | text color black | 16fp | Not clickable |
| **(missing)** FAB | — | — | — | — | **Not present in dump** (source defines FabButton but it is not rendered) |
| **Bottom Navigation Row** aid=19 | — | [0,2510][1280,2734] → y837 to y911, w427 h75vp | `#FFEFEEEE` (light grey) | — | Not clickable; container |
| **Nav Item: Home** aid=20 (Column) | — | [0,2510][256,2734] → w85 h75vp | `#00000000` | — | clickable=true |
| ↳ Home icon (Image) aid=21 | — | [86,2549][170,2633] → x29 w28 h28vp | icon | — | — |
| ↳ Home label (Text) aid=22 | "Home" | [71,2647][186,2696] → w38 h16vp | — | ~12fp | — |
| **Nav Item: Queue** aid=23 (Column) | — | [256,2510][512,2734] → w85 h75vp | `#00000000` | — | clickable=true |
| ↳ Queue icon (Image) aid=24 | — | [342,2549][426,2633] → w28 h28vp | icon | — | — |
| ↳ Queue label (Text) aid=25 | "Queue" | [321,2647][448,2696] → w42 h16vp | — | ~12fp | — |
| **Nav Item: Inbox** aid=26 (Column) | — | [512,2510][768,2734] → w85 h75vp | `#00000000` | — | clickable=true |
| ↳ Inbox icon (Image) aid=27 | — | [598,2549][682,2633] → w28 h28vp | icon | — | — |
| ↳ Inbox label (Text) aid=28 | "Inbox" | [587,2647][693,2696] → w35 h16vp | — | ~12fp | — |
| **Nav Item: Subscriptions** aid=29 (Column) | — | [768,2510][1024,2734] → w85 h75vp | `#00000000` | — | clickable=true; **selected state NOT reflected** (sel=false) |
| ↳ Subscriptions icon (Image) aid=30 | — | [854,2524][938,2608] → w28 h28vp (offset y+8) | icon | — | — |
| ↳ Subscriptions label (Text) aid=31 | "Subscriptions" | [776,2622][1016,2720] → w80 h33vp (larger) | — | ~14fp | — |
| **Nav Item: More** aid=32 (Column) | — | [1024,2510][1280,2734] → w85 h75vp | `#00000000` | — | clickable=true |
| ↳ More icon (Image) aid=33 | — | [1110,2549][1194,2633] → w28 h28vp | icon | — | — |
| ↳ More label (Text) aid=34 | "More" | [1103,2647][1202,2696] → w33 h16vp | — | ~12fp | — |

---

## Status Bar (system, not app UI)
- **StatusBarBox** [0,0][1280,136] → h45vp, `#00000000`. Contains clock (12:47), ethernet/signal/battery icons. Not part of app layout.

---

## Notes
- Page renders in an **incomplete empty state**: the content area shows only a single centered Text "Subscriptions" — the empty-view icon and the descriptive message are **not rendered**.
- **FAB ("Add podcast") is missing** from the rendered output despite being defined in source (`FabButton` builder). It is not present in the layout dump.
- Bottom nav has **5 items** (Home, Queue, Inbox, Subscriptions, More) matching Android, but:
  - The **active/selected Subscriptions tab shows no visual selected state** (no accent tint, no active-indicator pill; `selected=false` in dump).
  - Bottom nav background is `#FFEFEEEE` (grey) vs Android surface white.
- Toolbar icons are **placeholder images** (`ic_feed_black` for search, `ic_refresh_black` for overflow) — not the correct Material icons (`ic_search`, `ic_more_vert`).
