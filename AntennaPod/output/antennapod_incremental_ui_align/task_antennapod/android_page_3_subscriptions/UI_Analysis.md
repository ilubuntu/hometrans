# Android Subscriptions Page — UI Analysis

**Source:** `view.xml` (Uiautomator dump)
**Device resolution:** 1344 × 2992 px @ 3× density → 448 × 997 vp
**Package:** `de.danoeh.antennapod.debug`
**Activity:** `MainActivity` (Subscriptions fragment)

---

## All Components

| Component | Text content | Size & Layout (px → vp) | Color & Background | Typography | State & Interaction |
|---|---|---|---|---|---|
| **Root FrameLayout** (window) | — | [0,0][1344,2992] → full screen | System background | — | Not clickable |
| **DrawerLayout** `drawer_layout` | — | [0,0][1344,2728] → full screen minus bottom-padding | Transparent | — | Not clickable |
| **App bar** `appbar` (LinearLayout) | — | [0,0][1344,351] → w1344 h192 (w448 h64vp) | Material app-bar surface (white/light) | — | Container |
| **Toolbar** `toolbar` (ViewGroup) | "Subscriptions" (container) | [0,159][1344,351] → w1344 h192 (w448 h64vp) | Toolbar surface | — | long-clickable=true (scrolls to top on long-press) |
| **Title TextView** | "Subscriptions" | [48,211][450,299] → x16 y70, w402 h88 (w134 h29vp) | Default text color (black/dark) | ~20sp Medium | Not clickable; ellipsized |
| **Search Button** `action_search` | — (icon only) desc="Search" | [1080,183][1224,327] → x360 y61, w144 h144 (w48 h48vp) | Tinted icon (colorControlNormal) | — | clickable=true |
| **Overflow ImageView** | — desc="More options" | [1224,183][1344,327] → x408 y61, w120 h144 (w40 h48vp) | Tinted icon (colorControlNormal) | — | clickable=true, long-clickable=true |
| **Content ScrollView** | — | [0,351][1344,2728] → y117 to y909, w448 h793vp | Page background | — | Scrollable container |
| **Collapsing container** `collapsing_container` | — | [0,351][1344,354] → h3 (1vp) | — | — | Empty/collapsed |
| **SwipeRefresh** `swipeRefresh` | — | [0,354][1344,2728] | Transparent | — | Swipe-to-refresh container |
| **Empty-view container** (LinearLayout) | — | [60,1430][1283,1648] → centered, w1223 h218 | Transparent | — | Not clickable |
| **Empty icon** `emptyViewIcon` (ImageView) | — | [623,1430][719,1526] → centered x208, w96 h96 (w32 h32vp) | `ic_subscriptions`, tinted grey600 | — | Not clickable |
| **Empty title** `emptyViewTitle` (TextView) | "No subscriptions" | [490,1526][853,1591] → centered, w363 h65 (w121 h22vp) | Black/dark text | ~16sp | Not clickable |
| **Empty message** `emptyViewMessage` (TextView) | "To subscribe to a podcast, press the plus icon below." | [180,1591][1163,1648] → centered, w983 h57 (w328 h19vp) | Grey600 text | ~14sp | Not clickable |
| **FAB** `subscriptions_add` (ImageButton) | — desc="Add podcast" | [1128,2512][1296,2680] → x376 y837, w168 h168 (w56 h56vp) | `accent_light` background, `ic_add` icon white | — | clickable=true; bottom-end anchored |
| **Bottom Navigation** `bottomNavigationView` (FrameLayout) | — | [0,2728][1344,2920] → w448 h64vp | Surface/white background | — | Container |
| **Nav Item: Home** `bottom_navigation_home` | desc="Home" | [0,2728][269,2920] → w90 h64vp | — | — | clickable=true; icon + small label |
| ↳ Home icon (ImageView) | — | [98,2758][170,2830] → w72 h72 (w24 h24vp) | Tinted icon | — | — |
| ↳ Home label (TextView) | "Home" | [89,2849][179,2893] → small label | Tinted text | ~12sp | — |
| **Nav Item: Queue** `bottom_navigation_queue` | desc="Queue" | [269,2728][538,2920] → w90 h64vp | — | — | clickable=true |
| ↳ Queue icon (ImageView) | — | [367,2758][439,2830] → w24 h24vp | Tinted icon | — | — |
| ↳ Queue label (TextView) | "Queue" | [355,2849][451,2893] | Tinted text | ~12sp | — |
| **Nav Item: Inbox** `bottom_navigation_inbox` | desc="Inbox" | [538,2728][807,2920] → w90 h64vp | — | — | clickable=true |
| ↳ Inbox icon (ImageView) | — | [636,2758][708,2830] → w24 h24vp | Tinted icon | — | — |
| ↳ Inbox label (TextView) | "Inbox" | [631,2849][714,2893] | Tinted text | ~12sp | — |
| **Nav Item: Subscriptions** `bottom_navigation_subscriptions` | desc="Subscriptions" | [807,2728][1076,2920] → w90 h64vp | **selected=true** (active indicator pill) | — | clickable=false (current); **selected state** |
| ↳ Active indicator (View) | — | [845,2746][1037,2842] → w64 h32vp | Active indicator background (accent tint) | — | selected=true |
| ↳ Subscriptions icon (ImageView) | — | [905,2758][977,2830] → w24 h24vp | Accent-colored icon | — | selected=true |
| ↳ Subscriptions label (TextView) **large** | "Subscriptions" | [836,2849][1046,2893] → **large label** (expanded) | Accent-colored text | ~14sp Bold | selected=true |
| **Nav Item: More** `bottom_navigation_more` | desc="More" | [1076,2728][1344,2920] → w90 h64vp | — | — | clickable=true |
| ↳ More icon (ImageView) | — | [1174,2758][1246,2830] → w24 h24vp | Tinted icon | — | — |
| ↳ More label (TextView) | "More" | [1170,2849][1249,2893] | Tinted text | ~12sp | — |
| **Bottom padding** `bottom-padding` (View) | — | [0,2920][1344,2992] → h72 (h24vp) | Navigation bar gesture inset | — | — |

---

## Notes
- Screen is in **empty state** (no subscriptions loaded): shows centered icon + title + message.
- FAB ("Add podcast") is visible, anchored bottom-end above the bottom nav.
- Bottom nav has **5 items**: Home, Queue, Inbox, Subscriptions, More. Subscriptions tab is the **active/selected** item (shows active-indicator pill, large bold label, accent tint).
- Active nav item uses **large label**; inactive items use **small label** (Material 3 behavior).
