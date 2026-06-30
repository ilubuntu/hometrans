# HarmonyOS Home Page — UI Analysis

**Source:** `view.json` + `screenshot.png`
**Device:** HarmonyOS, 1280×2832px, density **3.5x** (verified from code-to-pixel ratios: 56vp→195px, 64vp→224px, 24vp→84px) → **~366×809vp**
**Page:** `pages/Index` (EntryAbility)
**Active tab:** Home (currentTab=0, selected in bottom nav)
**Source code:** `Index.ets` + `BottomNavigation.ets`

---

## 1. Status Bar (System)

### 1.1 Status Bar Container
| Property | Value |
|---|---|
| **Component** | WindowScene / __Common__ / Stack |
| **Bounds** | `[0,0][1280,136]` → 1280×136px = **366×39vp** |
| **Background** | `#00000000` (transparent) |
| **Content** | Clock "12:45" at left, system icons (signal/wifi/battery) at right |

### 1.2 Clock
| Property | Value |
|---|---|
| **Component** | TextClock / Flex |
| **Bounds** | `[53,49][192,111]` → 139×62px = **40×18vp** |
| **Text** | `12:45` (Text "12", ":", "45") |
| **Typography** | system status bar font, white |

### 1.3 System Icons (right side)
| Property | Value |
|---|---|
| **Component** | Stack with SymbolGlyphs |
| **Bounds** | `[952,38][1228,122]` → 276×84px = **79×24vp** |
| **Content** | signal SymbolGlyph, wifi SymbolGlyphs, battery SymbolGlyph + "100" text |

---

## 2. App Bar / Toolbar

### 2.1 Toolbar Row
| Property | Value |
|---|---|
| **Component** | Row (`aid=5`) |
| **Text** | (container) |
| **Bounds** | `[0,137][1280,332]` → 1280×195px = **366×56vp** |
| **Background** | `#FFF9FCFF` (`background_light`) |
| **Source** | `Index.ets` → `ToolbarBuilder()`: Row width 100%, height 56vp |

### 2.2 Toolbar Title — "Home"
| Property | Value |
|---|---|
| **Component** | Text (`aid=6`) |
| **Text** | `Home` |
| **Bounds** | `[56,193][1028,275]` → 972×82px = **278×23vp** |
| **Margin** | left=56px=**16vp** (matches `margin({ left: 16 })`) |
| **Layout** | layoutWeight(1), maxLines(1), ellipsis overflow |
| **Typography** | fontSize=**20vp**, fontWeight=Medium, fontColor=`black` (`#ff000000`) |
| **Alignment** | left-aligned, vertical center |

### 2.3 Search Icon (Toolbar)
| Property | Value |
|---|---|
| **Component** | Image (`aid=7`) |
| **Bounds** | `[1028,192][1112,276]` → 84×84px = **24×24vp** |
| **Icon** | `ic_feed_black` (placeholder — should be search icon) |
| **Fill** | `black` (`#ff000000`) |
| **Margin** | right=56px=**16vp** |
| **State/Interaction** | onClick → logs "TODO: Navigate to SearchPage" |
| **Accessibility** | `search_label` |

### 2.4 Overflow / More Icon (Toolbar)
| Property | Value |
|---|---|
| **Component** | Image (`aid=8`) |
| **Bounds** | `[1168,192][1252,276]` → 84×84px = **24×24vp** |
| **Icon** | `ic_refresh_black` (placeholder — should be 3-dot overflow) |
| **Fill** | `black` |
| **Margin** | right=32px=**~9vp** (matches `margin({ right: 8 })`) |
| **State/Interaction** | bindMenu → [Refresh, Configure home screen] |
| **Accessibility** | `overflow_more` |

### 2.5 Info Bar
| Property | Value |
|---|---|
| **Component** | — |
| **Status** | **MISSING** — no info bar below toolbar (Android has "0 episodes • 0 minutes left") |

---

## 3. Content Area — Welcome / No Subscriptions State

### 3.1 Content Column
| Property | Value |
|---|---|
| **Component** | Column (`aid=9`) |
| **Bounds** | `[0,332][1280,2510]` → 1280×2178px = **366×622vp** |
| **Background** | `#FFF9FCFF` (`background_light`) |
| **Layout** | layoutWeight(1), width 100% |

### 3.2 Welcome Stack
| Property | Value |
|---|---|
| **Component** | Stack (`aid=12`) — alignContent BottomEnd |
| **Bounds** | `[0,332][1280,2510]` → 1280×2178px = **366×622vp** |
| **Background** | `#00000000` (transparent) |

### 3.3 Welcome Column
| Property | Value |
|---|---|
| **Component** | Column (`aid=13`) |
| **Bounds** | `[0,332][1280,2510]` → 1280×2178px = **366×622vp** |
| **Layout** | alignItems=Center, padding left/right=32vp (112px) |

### 3.4 Logo / Monochrome Icon
| Property | Value |
|---|---|
| **Component** | Image (`aid=14`) |
| **Bounds** | `[528,500][752,724]` → 224×224px = **64×64vp** |
| **Icon** | `logo_monochrome`, objectFit=Contain |
| **Margin** | top=168px=**48vp** (matches `margin({ top: 48 })`) |
| **Layout** | horizontally centered (x-center = 640 ≈ screen center 640) |

### 3.5 Welcome Title — "Welcome to AntennaPod!"
| Property | Value |
|---|---|
| **Component** | Text (`aid=15`) |
| **Text** | `Welcome to AntennaPod!` |
| **Bounds** | `[112,780][1168,862]` → 1056×82px = **302×23vp** |
| **Margin** | top=56px=**16vp** (after logo), left/right padding=112px=**32vp** |
| **Typography** | fontSize=**20vp**, fontColor=`black` |
| **Alignment** | TextAlign.Center, width 100% |

### 3.6 Welcome Message
| Property | Value |
|---|---|
| **Component** | Text (`aid=16`) |
| **Text** | `You are not subscribed to any podcasts yet. Open the menu to add a podcast.` |
| **Bounds** | `[112,890][1168,1004]` → 1056×114px = **302×33vp** |
| **Margin** | top=28px=**8vp** (after title), left/right padding=112px=**32vp** |
| **Typography** | fontSize=**14vp**, fontColor=`black` |
| **Alignment** | TextAlign.Center, width 100% |

### 3.7 Floating Action Button (FAB)
| Property | Value |
|---|---|
| **Component** | Image (`aid=17`) — positioned in Stack BottomEnd |
| **Bounds** | `[944,2174][1224,2454]` → 280×280px = **80×80vp** |
| **Icon** | `ic_refresh_black` rotated 180° (placeholder FAB) |
| **Fill** | `grey600` (`#ff757575`) |
| **Margin** | bottom=56px=**16vp**, right=56px=**16vp** |
| **Layout** | Stack alignContent=BottomEnd |
| **Note** | This FAB does not exist in the Android Queue screen capture |

---

## 4. Bottom Navigation Bar

### 4.1 Bottom Navigation Container
| Property | Value |
|---|---|
| **Component** | Row (`aid=19`) |
| **Bounds** | `[0,2510][1280,2734]` → 1280×224px = **366×64vp** |
| **Background** | `#FFEFEEEE` (`background_elevated_light`) |
| **Source** | `BottomNavigation.ets`: Row width 100%, height 64vp |
| **Layout** | 5 equal-weight Columns (layoutWeight 1 each = ~73vp per tab) |

### 4.2 Home Tab (SELECTED / active)
| Property | Value |
|---|---|
| **Component** | Column (`aid=20`) |
| **Bounds** | `[0,2510][256,2734]` → 256×224px = **73×64vp** |
| **Icon** | Image (`aid=21`) [86,2549][170,2633] = 84×84px = **24×24vp** — `ic_feed_black` (placeholder, should be home icon) |
| **Icon Fill** | `accent_light` (`#ff0078C2`) — selected color |
| **Label** | Text (`aid=22`) "Home" [71,2647][186,2696], fontSize=**12vp**, margin-top=4vp, fontColor=`accent_light` |
| **Active Indicator** | **NONE** (no pill/background behind icon) |
| **State/Interaction** | onClick → currentTab=0 |

### 4.3 Queue Tab (inactive)
| Property | Value |
|---|---|
| **Component** | Column (`aid=23`) |
| **Bounds** | `[256,2510][512,2734]` → 256×224px = **73×64vp** |
| **Icon** | Image (`aid=24`) [342,2549][426,2633] = 84×84px = **24×24vp** — `ic_playlist_play_black` |
| **Icon Fill** | `grey600` (`#ff757575`) — unselected color |
| **Label** | Text (`aid=25`) "Queue" [321,2647][448,2696], fontSize=12vp, fontColor=`grey600` |
| **State/Interaction** | onClick → currentTab=1 |

### 4.4 Inbox Tab (inactive)
| Property | Value |
|---|---|
| **Component** | Column (`aid=26`) |
| **Bounds** | `[512,2510][768,2734]` → 256×224px = **73×64vp** |
| **Icon** | Image (`aid=27`) [598,2549][682,2633] = 84×84px = **24×24vp** — `ic_feed_black` (placeholder, should be inbox icon) |
| **Icon Fill** | `grey600` |
| **Label** | Text (`aid=28`) "Inbox" [587,2647][693,2696], fontSize=12vp, fontColor=`grey600` |
| **State/Interaction** | onClick → currentTab=2 |

### 4.5 Subscriptions Tab (inactive)
| Property | Value |
|---|---|
| **Component** | Column (`aid=29`) |
| **Bounds** | `[768,2510][1024,2734]` → 256×224px = **73×64vp** |
| **Icon** | Image (`aid=30`) [854,2524][938,2608] = 84×84px = **24×24vp** — `ic_subscriptions_black` |
| **Icon Fill** | `grey600` |
| **Label** | Text (`aid=31`) "Subscriptions" [776,2622][1016,2720], fontSize=12vp, fontColor=`grey600` — wraps to 2 lines (label taller than others) |
| **State/Interaction** | onClick → currentTab=3 |

### 4.6 More Tab (inactive)
| Property | Value |
|---|---|
| **Component** | Column (`aid=32`) |
| **Bounds** | `[1024,2510][1280,2734]` → 256×224px = **73×64vp** |
| **Icon** | Image (`aid=33`) [1110,2549][1194,2633] = 84×84px = **24×24vp** — `ic_refresh_black` (placeholder, should be 3-dot vertical) |
| **Icon Fill** | `grey600` |
| **Label** | Text (`aid=34`) "More" [1103,2647][1202,2696], fontSize=12vp, fontColor=`grey600` |
| **State/Interaction** | onClick → currentTab=4 |

---

## 5. System Areas

### 5.1 Bottom Safe Area
| Property | Value |
|---|---|
| **Area** | y=2734 to y=2832 → 98px = **28vp** — bottom system gesture/home indicator area |

---

## Summary of Visible Screen Regions

| Region | Y range (px) | Y range (vp) | Height (vp) |
|---|---|---|---|
| Status bar | 0–136 | 0–39 | 39 |
| Toolbar | 137–332 | 39–95 | 56 |
| Content (welcome) | 332–2510 | 95–717 | 622 |
| Bottom navigation | 2510–2734 | 717–781 | 64 |
| Bottom safe area | 2734–2832 | 781–809 | 28 |
