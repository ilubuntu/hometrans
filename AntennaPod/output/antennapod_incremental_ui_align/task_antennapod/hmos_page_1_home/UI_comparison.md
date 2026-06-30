# UI Comparison — Android vs HarmonyOS (Home Page)

**Android:** 1344×2992px @ 3.0x → 448×997dp | Active tab: **Queue** (empty state)
**HarmonyOS:** 1280×2832px @ 3.5x → 366×809vp | Active tab: **Home** (welcome state)

> **Critical mismatch:** The two captures show **different tabs and content**. Android landed on the Queue tab (empty queue), while HarmonyOS landed on the Home tab (no-subscriptions welcome). This is the root cause of most content-level differences below.

---

## Component-by-Component Comparison

| UI Component | 文本内容 (Android / HarmonyOS) | 尺寸与布局 | 颜色与背景 | 边框与轮廓 | 文本样式 | 变换与效果 | 状态与交互反馈 | Diff |
|---|---|---|---|---|---|---|---|---|
| **Status Bar** | Android: not in view tree / HarmonyOS: "12:45", signal, wifi, battery "100" | Android: ~53dp top inset / HarmonyOS: `[0,0][1280,136]` = 366×39vp | HarmonyOS: transparent `#00000000` | — | HarmonyOS: system status bar font | — | System-managed | **Diff:** HarmonyOS includes visible status bar with clock/icons; Android view tree starts below status bar |
| **Toolbar Container** | — | Android: `[0,159][1344,351]` = 448×64dp / HarmonyOS: `[0,137][1280,332]` = 366×56vp | Android: surface color / HarmonyOS: `#FFF9FCFF` (background_light) | — | — | — | Both: non-interactive container | **Diff:** Android toolbar is 64dp (taller); HarmonyOS is 56vp. Background colors nearly identical (`#F9FCFF` vs Material surface) |
| **Toolbar Title** | Android: `Queue` / HarmonyOS: `Home` | Android: `[48,211][235,299]` left=16dp / HarmonyOS: `[56,193][1028,275]` left=16vp | Both: black / near-black | — | Android: ~20sp Medium / HarmonyOS: 20vp Medium | — | — | **Diff:** Title text is different (`Queue` vs `Home`) — reflects different active tabs. Font size matches. |
| **Toolbar Search Icon** | Android: desc=`Search` / HarmonyOS: `search_label` | Android: 48×48dp (`[1080,183][1224,327]`) / HarmonyOS: 24×24vp (`[1028,192][1112,276]`) | Android: search icon, OnSurface tint / HarmonyOS: `ic_feed_black`, fill=black | — | — | — | Android: opens search / HarmonyOS: logs "TODO: Navigate to SearchPage" | **Diff:** Android uses actual search (magnifier) icon; HarmonyOS uses `ic_feed_black` placeholder icon. Android icon is 48dp touch target, HarmonyOS icon is 24vp (no expanded touch target). |
| **Toolbar Overflow Icon** | Android: desc=`More options` / HarmonyOS: `overflow_more` | Android: 40×48dp (`[1224,183][1344,327]`) / HarmonyOS: 24×24vp (`[1168,192][1252,276]`) | Android: 3-dot vertical icon, OnSurface tint / HarmonyOS: `ic_refresh_black`, fill=black | — | — | — | Android: popup menu / HarmonyOS: bindMenu [Refresh, Configure home screen] | **Diff:** Android uses 3-dot overflow icon; HarmonyOS uses `ic_refresh_black` (circular arrows) placeholder. Menu items differ. |
| **Info Bar** | Android: `0 episodes • 0 minutes left` / HarmonyOS: **MISSING** | Android: `[0,315][1344,364]` = 448×16dp / HarmonyOS: absent | Android: grey (OnSurfaceVariant) | — | Android: ~12sp | — | Android: static info text | **Diff:** Info bar exists on Android below toolbar but is completely absent on HarmonyOS |
| **Content — State** | Android: Empty Queue state / HarmonyOS: Welcome (no subscriptions) state | — | — | — | — | — | — | **Diff:** Fundamentally different content states. Android shows queue empty; HarmonyOS shows subscription welcome. |
| **Content — Icon/Logo** | Android: empty queue icon / HarmonyOS: AntennaPod monochrome logo | Android: 32×32dp centered (`[624,1230][720,1326]`) / HarmonyOS: 64×64vp centered (`[528,500][752,724]`) | Android: OnSurfaceVariant tint / HarmonyOS: logo_monochrome, natural | — | — | — | Both: decorative | **Diff:** Different icons (queue-empty vs app logo), different sizes (32dp vs 64vp). HarmonyOS logo is 2× larger. |
| **Content — Title** | Android: `No queued episodes` / HarmonyOS: `Welcome to AntennaPod!` | Android: `[455,1326][889,1391]` centered / HarmonyOS: `[112,780][1168,862]` centered, padding 32vp | Both: black | — | Android: ~16sp / HarmonyOS: 20vp | — | Both: static | **Diff:** Different text content and font size (16sp vs 20vp). |
| **Content — Message** | Android: `Add an episode by downloading it...` / HarmonyOS: `You are not subscribed to any podcasts yet...` | Android: `[120,1391][1224,1497]` margin 40dp / HarmonyOS: `[112,890][1168,1004]` padding 32vp | Both: black/grey | — | Android: ~14sp / HarmonyOS: 14vp | — | Both: static | **Diff:** Different message text. Android uses grey (OnSurfaceVariant); HarmonyOS uses black. |
| **Floating Action Button** | Android: **absent** / HarmonyOS: present | HarmonyOS: `[944,2174][1224,2454]` = 80×80vp, bottom-right of content | HarmonyOS: `ic_refresh_black` fill=`grey600` (`#757575`) | — | — | HarmonyOS: rotate 180° | HarmonyOS: positioned in Stack(BottomEnd) | **Diff:** HarmonyOS has a FAB (placeholder rotated refresh icon) that does not exist in the Android Queue capture. The Android Home tab does have an FAB, but it was not captured since Queue was active. |
| **Bottom Nav Container** | — | Android: `[0,2728][1344,2920]` = 448×64dp / HarmonyOS: `[0,2510][1280,2734]` = 366×64vp | Android: surface-elevated / HarmonyOS: `#FFEFEEEE` (background_elevated_light) | — | — | — | Both: container | **Match:** Both 64dp/vp height, 5 equal tabs. Background color slightly different (Android surface vs HarmonyOS `#EFEEEE` greyish-green). |
| **Nav — Home Tab** | Android: `Home` (inactive) / HarmonyOS: `Home` (**active/selected**) | Android: 89.7×64dp / HarmonyOS: 73×64vp | Android: unselected grey tint / HarmonyOS: `accent_light` (`#0078C2`) selected | — | Android: small 11sp / HarmonyOS: 12vp | — | Both: clickable | **Diff:** Android Home is inactive; HarmonyOS Home is active (selected). No active indicator pill on HarmonyOS. |
| **Nav — Queue Tab** | Android: `Queue` (**active/selected**) / HarmonyOS: `Queue` (inactive) | Android: 89.7×64dp / HarmonyOS: 73×64vp | Android: selected accent tint / HarmonyOS: `grey600` unselected | — | Android: large 14sp (active) / HarmonyOS: 12vp | — | Android: non-clickable (active) / HarmonyOS: clickable | **Diff:** Android Queue is active (with pill indicator + large label); HarmonyOS Queue is inactive. |
| **Nav — Active Indicator (pill)** | Android: present on Queue (`[307,2746][499,2842]` = 64×32dp) / HarmonyOS: **absent** | — | Android: rounded pill behind active icon | — | — | — | — | **Diff:** Android shows Material3 active indicator pill behind selected tab icon; HarmonyOS has none. |
| **Nav — Inbox Tab** | Android: `Inbox` (inactive) / HarmonyOS: `Inbox` (inactive) | Android: 89.7×64dp / HarmonyOS: 73×64vp | Both: grey/unselected | — | Android: 11sp / HarmonyOS: 12vp | — | Both: clickable | **Diff:** Label font size slightly different (11sp vs 12vp). Icon is `ic_feed_black` placeholder on HarmonyOS. |
| **Nav — Subscriptions Tab** | Android: `Subscriptions` (inactive) / HarmonyOS: `Subscriptions` (inactive) | Android: label fits 1 line `[838,2849][1044,2893]` / HarmonyOS: label wraps 2 lines `[776,2622][1016,2720]` | Both: grey/unselected | — | Android: 11sp, 1 line / HarmonyOS: 12vp, wraps | — | Both: clickable | **Diff:** Android "Subscriptions" label fits in one line; HarmonyOS label wraps to 2 lines due to narrower tab width (73vp vs 90dp) and lack of maxLines constraint. |
| **Nav — More Tab** | Android: `More` (inactive) / HarmonyOS: `More` (inactive) | Android: 89.3×64dp / HarmonyOS: 73×64vp | Both: grey/unselected | — | Android: 11sp / HarmonyOS: 12vp | — | Both: clickable | **Diff:** Label font slightly different. Icon is `ic_refresh_black` placeholder on HarmonyOS (should be 3-dot vertical). |
| **Nav — Icon Assets** | Android: distinct icons per tab (home, playlist, inbox, grid, dots) / HarmonyOS: reuses `ic_feed_black` for Home & Inbox, `ic_refresh_black` for More | Both: 24×24 dp/vp | — | — | — | — | — | **Diff:** Android uses unique Material icons per tab; HarmonyOS reuses placeholder icons (ic_feed_black, ic_refresh_black) for 3 of 5 tabs. |
| **Bottom System Area** | Android: nav bar inset `[0,2920][1344,2992]` = 24dp / HarmonyOS: safe area `[2734,2832]` = 28vp | — | — | — | — | — | System-managed | **Diff:** Minor height difference in bottom system inset. |

---

## Summary of Key Differences

### Critical (functional/structural)
| # | Issue | Impact |
|---|---|---|
| 1 | **Different active tab**: Android=Queue, HarmonyOS=Home | Apps default to different screens. Content, title, and nav state all differ. |
| 2 | **Missing Info Bar** on HarmonyOS | "0 episodes • 0 minutes left" not replicated. |
| 3 | **Placeholder icons** in toolbar (search=`ic_feed_black`, overflow=`ic_refresh_black`) and bottom nav (Home, Inbox, More) | Icons don't match Android semantics. |
| 4 | **Missing active indicator pill** on HarmonyOS bottom nav | Material3 pill background behind selected tab icon is absent. |

### Moderate (visual/styling)
| # | Issue | Impact |
|---|---|---|
| 5 | **Uniform label font** on HarmonyOS (12vp for all) vs Android (11sp inactive / 14sp active) | Active tab doesn't visually emphasize via larger label. |
| 6 | **Subscriptions label wraps to 2 lines** on HarmonyOS | Due to narrower tab width (73vp) and no maxLines constraint. |
| 7 | **Toolbar height** 56vp (HarmonyOS) vs 64dp (Android) | Slight height difference. |
| 8 | **Bottom nav background** `#EFEEEE` (HarmonyOS) vs Material surface (Android) | Slightly different shade. |
| 9 | **FAB present on HarmonyOS** | Rotated refresh icon as FAB in content bottom-right. Not present in Android Queue capture (but may exist on Android Home tab). |

### Minor
| # | Issue | Impact |
|---|---|---|
| 10 | **Content message color** grey (Android) vs black (HarmonyOS) | HarmonyOS welcome text is darker than Android's secondary text. |
| 11 | **Status bar** visible on HarmonyOS capture, not on Android | Capture artifact, not a code difference. |

---

## Recommended Fixes (HarmonyOS → match Android)

1. **Default tab**: Set `currentTab` initial value to match Android's default (Queue).
2. **Add Info Bar**: Add a subtitle/info bar below the toolbar showing episode count and time remaining.
3. **Replace placeholder icons**: Use proper search, home, inbox, and 3-dot overflow icons.
4. **Add active indicator**: Implement Material-style pill indicator behind the selected bottom nav tab icon.
5. **Active label sizing**: Increase label fontSize for the selected tab (14vp) vs unselected (12vp).
6. **Fix Subscriptions label**: Add `maxLines(1)` + `textOverflow(Ellipsis)` or reduce fontSize to prevent wrapping.
7. **Match toolbar height**: Consider 64vp to match Android's 64dp.
8. **Content state**: Ensure the correct empty/welcome state is shown for the active tab.
