# Android Home Page — UI Analysis

**Source:** `view.xml` + `meta.json` + `screenshot.png`
**Device:** Android emulator, 1344×2992px, density 3.0x (1dp = 3px) → 448×997.3dp
**Activity:** `de.danoeh.antennapod.activity.MainActivity`
**Active tab:** Queue (selected in bottom nav)
**Note:** Despite the task name "home", the captured Android screen is on the **Queue** tab showing an empty-queue state.

---

## 1. App Bar

### 1.1 App Bar Container
| Property | Value |
|---|---|
| **Component** | LinearLayout (`#appbar`) |
| **Bounds** | `[0,0][1344,388]` → 1344×388px = **448×129.3dp** |
| **Background** | App surface color (light, Material3) |
| **Layout** | Vertical LinearLayout at top of screen, full width |

### 1.2 Toolbar
| Property | Value |
|---|---|
| **Component** | ViewGroup (`#toolbar`) — Material Toolbar |
| **Text** | (container) |
| **Bounds** | `[0,159][1344,351]` → 1344×192px = **448×64dp** |
| **Margin/Position** | top=159px=53dp (below status bar area) |
| **Background** | App surface color (light, `?attr/colorSurface`) |
| **State/Interaction** | clickable=true, long-clickable=true |

### 1.3 Toolbar Title — "Queue"
| Property | Value |
|---|---|
| **Component** | TextView |
| **Text** | `Queue` |
| **Bounds** | `[48,211][235,299]` → 187×88px = **62.3×29.3dp** |
| **Margin** | left=48px=**16dp** |
| **Typography** | fontSize ≈ 20sp, fontWeight=Medium, color=OnSurface (near-black) |
| **Alignment** | left/center-vertical within toolbar |

### 1.4 Toolbar Action Buttons Container
| Property | Value |
|---|---|
| **Component** | LinearLayoutCompat |
| **Bounds** | `[1080,171][1344,339]` → 264×168px = **88×56dp** |
| **Layout** | horizontal, right-aligned in toolbar |

### 1.5 Search Button
| Property | Value |
|---|---|
| **Component** | Button (`#action_search`) — ImageButton |
| **Text/Desc** | content-desc=`Search` (icon only, no text) |
| **Bounds** | `[1080,183][1224,327]` → 144×144px = **48×48dp** |
| **Icon** | magnifier/search icon, tinted OnSurface |
| **State/Interaction** | clickable=true, opens search |

### 1.6 Overflow / More Options Button
| Property | Value |
|---|---|
| **Component** | ImageView — overflow popup |
| **Text/Desc** | content-desc=`More options` |
| **Bounds** | `[1224,183][1344,327]` → 120×144px = **40×48dp** |
| **Icon** | vertical 3-dot overflow icon |
| **State/Interaction** | clickable=true, long-clickable=true, opens popup menu |

### 1.7 Info Bar — "0 episodes • 0 minutes left"
| Property | Value |
|---|---|
| **Component** | TextView (`#info_bar`) |
| **Text** | `0 episodes • 0 minutes left` |
| **Bounds** | `[0,315][1344,364]` → 1344×49px = **448×16.3dp** |
| **Layout** | full-width, below toolbar, left-aligned with default padding |
| **Typography** | fontSize ≈ 12sp, color=OnSurfaceVariant (grey) |

---

## 2. Content Area — Empty Queue State

### 2.1 SwipeRefreshLayout
| Property | Value |
|---|---|
| **Component** | ViewGroup (`#swipeRefresh`) |
| **Bounds** | `[0,388][1344,2728]` → 1344×2340px = **448×780dp** |
| **Interaction** | swipe-to-refresh supported |

### 2.2 Empty State Container
| Property | Value |
|---|---|
| **Component** | LinearLayout (centered empty view) |
| **Bounds** | `[0,1230][1344,1497]` → 1344×267px = **448×89dp** |
| **Layout** | vertical, centered horizontally in content area |

### 2.3 Empty State Icon
| Property | Value |
|---|---|
| **Component** | ImageView (`#emptyViewIcon`) |
| **Text/Desc** | (icon only) |
| **Bounds** | `[624,1230][720,1326]` → 96×96px = **32×32dp** |
| **Icon** | queue/playlist empty icon, tinted OnSurfaceVariant |
| **Layout** | horizontally centered (x-center = 672 = screen center) |

### 2.4 Empty State Title — "No queued episodes"
| Property | Value |
|---|---|
| **Component** | TextView (`#emptyViewTitle`) |
| **Text** | `No queued episodes` |
| **Bounds** | `[455,1326][889,1391]` → 434×65px = **144.7×21.7dp** |
| **Typography** | fontSize ≈ 16sp, fontWeight=Medium, color=OnSurface |
| **Alignment** | center |

### 2.5 Empty State Message
| Property | Value |
|---|---|
| **Component** | TextView (`#emptyViewMessage`) |
| **Text** | `Add an episode by downloading it, or long press an episode and select "Add to queue".` |
| **Bounds** | `[120,1391][1224,1497]` → 1104×106px = **368×35.3dp** |
| **Margin** | left/right=120px≈**40dp** symmetric |
| **Typography** | fontSize ≈ 14sp, color=OnSurfaceVariant (grey) |
| **Alignment** | center |

---

## 3. Bottom Navigation Bar

### 3.1 Bottom Navigation Container
| Property | Value |
|---|---|
| **Component** | FrameLayout (`#bottomNavigationView`) — Material BottomNavigationView |
| **Bounds** | `[0,2728][1344,2920]` → 1344×192px = **448×64dp** |
| **Background** | surface-elevated color |
| **Layout** | 5 equal-width tabs, fixed mode |

### 3.2 Home Tab (inactive)
| Property | Value |
|---|---|
| **Component** | FrameLayout (`#bottom_navigation_home`) |
| **Text/Desc** | `Home` |
| **Bounds** | `[0,2728][269,2920]` → 269×192px = **89.7×64dp** |
| **Icon** | ImageView [98,2758][170,2830] = 72×72px = **24×24dp**, home icon, unselected tint |
| **Label** | TextView small_label "Home" [89,2849][179,2893], fontSize≈11sp, unselected tint |
| **Active Indicator** | none |
| **State/Interaction** | clickable=true, selected=false |

### 3.3 Queue Tab (SELECTED / active)
| Property | Value |
|---|---|
| **Component** | FrameLayout (`#bottom_navigation_queue`) |
| **Text/Desc** | `Queue` |
| **Bounds** | `[269,2728][538,2920]` → 269×192px = **89.7×64dp** |
| **Active Indicator** | View pill [307,2746][499,2842] = 192×96px = **64×32dp** (rounded rectangle behind icon) |
| **Icon** | ImageView [367,2758][439,2830] = 72×72px = **24×24dp**, queue icon, selected tint (accent color) |
| **Label** | TextView large_label "Queue" [354,2849][452,2893], fontSize≈14sp, selected tint (bold/larger) |
| **State/Interaction** | clickable=false (active), selected=true |

### 3.4 Inbox Tab (inactive)
| Property | Value |
|---|---|
| **Component** | FrameLayout (`#bottom_navigation_inbox`) |
| **Text/Desc** | `Inbox` |
| **Bounds** | `[538,2728][807,2920]` → 269×192px = **89.7×64dp** |
| **Icon** | ImageView [636,2758][708,2830] = 72×72px = **24×24dp**, inbox icon, unselected tint |
| **Label** | TextView small_label "Inbox" [631,2849][714,2893], fontSize≈11sp |
| **Active Indicator** | none |
| **State/Interaction** | clickable=true, selected=false |

### 3.5 Subscriptions Tab (inactive)
| Property | Value |
|---|---|
| **Component** | FrameLayout (`#bottom_navigation_subscriptions`) |
| **Text/Desc** | `Subscriptions` |
| **Bounds** | `[807,2728][1076,2920]` → 269×192px = **89.7×64dp** |
| **Icon** | ImageView [905,2758][977,2830] = 72×72px = **24×24dp**, subscriptions/grid icon, unselected tint |
| **Label** | TextView small_label "Subscriptions" [838,2849][1044,2893], fontSize≈11sp |
| **Active Indicator** | none |
| **State/Interaction** | clickable=true, selected=false |

### 3.6 More Tab (inactive)
| Property | Value |
|---|---|
| **Component** | FrameLayout (`#bottom_navigation_more`) |
| **Text/Desc** | `More` |
| **Bounds** | `[1076,2728][1344,2920]` → 268×192px = **89.3×64dp** |
| **Icon** | ImageView [1174,2758][1246,2830] = 72×72px = **24×24dp**, hamburger/overflow icon, unselected tint |
| **Label** | TextView small_label "More" [1170,2849][1249,2893], fontSize≈11sp |
| **Active Indicator** | none |
| **State/Interaction** | clickable=true, selected=false |

---

## 4. System Areas

### 4.1 Status Bar (top)
| Property | Value |
|---|---|
| **Area** | y=0 to y=159px (approx **53dp**) — not captured in view tree but occupied |

### 4.2 Navigation Bar / Bottom Padding
| Property | Value |
|---|---|
| **Component** | View (`#bottom-padding`) |
| **Bounds** | `[0,2920][1344,2992]` → 1344×72px = **448×24dp** |
| **Purpose** | System gesture/navigation bar inset |

---

## Summary of Visible Screen Regions

| Region | Y range (px) | Y range (dp) | Height (dp) |
|---|---|---|---|
| Status bar | 0–159 | 0–53 | 53 |
| App bar (toolbar + info) | 0–388 | 0–129 | 129 |
| Content (empty state) | 388–2728 | 129–909 | 780 |
| Bottom navigation | 2728–2920 | 909–973 | 64 |
| System nav inset | 2920–2992 | 973–997 | 24 |
