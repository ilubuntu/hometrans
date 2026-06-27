# HarmonyOS Page 1: Calculator Main Page — UI Analysis

**Device:** 127.0.0.1:5557 (hdc) | **Screen:** 1280x2832px | **Density:** ~3.0x (vp) | **vp:** ~426 x 944

## View Tree Summary (from view.xml)

```
root [0,0][1280,2832]
  Stack [0,137][1280,2832] (app window, status bar = 137px)
    Column [0,137][1280,2832]
      Row (top bar) [0,137][1280,294]
      Column (display) [0,294][1280,1232]
        Scroll > Text "0" [70,979][1210,1176]
      Grid (key layout) [0,1232][1280,2832]
        GridItem [28,1232][334,1552]   GridItem [334,1232][640,1552]   GridItem [640,1232][946,1552]   GridItem [946,1232][1252,1552]
        GridItem [28,1552][334,1872]   GridItem [334,1552][640,1872]   GridItem [640,1552][946,1872]   GridItem [946,1552][1252,1872]
        GridItem [28,1872][334,2192]   GridItem [334,1872][640,2192]   GridItem [640,1872][946,2192]   GridItem [946,1872][1252,2192]
        GridItem [28,2192][334,2512]   GridItem [334,2192][640,2512]   GridItem [640,2192][946,2512]   GridItem [946,2192][1252,2512]
        GridItem(span2) [28,2512][640,2832]  GridItem [640,2512][946,2832]  GridItem [946,2512][1252,2832]
```

Note: HarmonyOS uitest dumpLayout does not expose text content or accessibility labels in the same detail as Android uiautomator. Analysis below combines source code review with layout measurements.

## Component Analysis (from source code + layout dump)

### 1. Top Bar
| Attribute | Value |
|:----------|:------|
| **Layout** | `Row({ space: 10 })`, `.width('100%').padding({ left: 20, top: 16 })` |
| **Position** | First element in Column, starts at y=137px (after status bar) |
| **Top bar height** | 157px (~3.0x → 52.3vp) — from y=137 to y=294 |
| **Width** | 100% (1280px) |

### 2. Top Bar Icons (CorneredFlatIconButton)
| Attribute | Value |
|:----------|:------|
| **Shape** | `borderRadius(12)` — 12vp uniform corner radius (all 4 corners) |
| **aspectRatio** | 1.25 ✓ |
| **Background** | `$r('app.color.primary')` = #FFCFD3DE (solid, no alpha blending) |
| **Elevation** | None (completely flat, no shadow) |
| **Icons** | Unicode text characters: `'\u2600'` (☀) / `'\u263E'` (☾) for theme, `'\u23F1'` (⏱) for history |
| **Icon fontSize** | 24vp |
| **Icon text** | `Text(this.iconText).fontSize(24).fontColor(iconColor).textAlign(TextAlign.Center)` |
| **Accessibility** | `.accessibilityText($r('app.string.theme_changer'))`, `.accessibilityText($r('app.string.calculations_history'))` |

### 3. Display Area
| Attribute | Value |
|:----------|:------|
| **Expression** | `fontSize(24)`, `fontWeight(FontWeight.Lighter)`, `fontColor($r('app.color.on_background'))`, `opacity(0.6)` |
| **Result** | `fontSize(48)`, `fontWeight(FontWeight.Normal)`, `fontColor($r('app.color.on_background'))` |
| **Alignment** | `.textAlign(TextAlign.End)`, Column `.alignItems(HorizontalAlign.End)` |
| **Padding** | `.padding({ left: 20, right: 20 })` |
| **Overflow** | `.maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })` — NO horizontal scroll |
| **Container** | `Column().width('100%').layoutWeight(1).justifyContent(FlexAlign.End).padding({ bottom: 16 })` |
| **Result text bounds** | [70,979][1210,1176] → 1140x197px (~3.0x → 380x65.7vp) |

### 4. Key Layout (Number Pad)
| Attribute | Value |
|:----------|:------|
| **Container** | `Column().width('100%').height('56%').padding({ left: 8, right: 8, bottom: 16, top: 4 })` |
| **Layout** | Manual Row/Column — 5 Rows, each `.layoutWeight(1).width('100%')` |
| **Grid area** | [0,1232][1280,2832] → 1280x1600px (~3.0x → 426.7x533.3vp) |
| **Button cell size** | ~306x320px (~3.0x → 102x106.7vp) |
| **Button margin** | `.margin(4)` per NeuButton |
| **"0" button** | `.layoutWeight(2)` (spans 2 columns) → 612px (~3.0x → 204vp) |

### 5. Calculator Buttons (NeuButton)
| Attribute | Value |
|:----------|:------|
| **Shape** | `borderRadius(28)` — 28vp corner radius |
| **Elevation** | `.shadow({ radius: 12, color: '#30000000', offsetX: 0, offsetY: 6 })` — simple drop shadow |
| **Background** | `this.bgColor` — solid color, no gradient |
| **Border** | None |
| **Text style** | `fontSize(32)`, `fontWeight(FontWeight.Lighter)`, `textAlign(TextAlign.Center)` |
| **LayoutWeight** | `button.widthRatio` (1 or 2), `.height('100%').margin(4)` |

### 6. Color Scheme (Light Theme — base/element/color.json)
| Color Name | Hex | Usage |
|:-----------|:----|:------|
| background | #FFECECEC | App background ✓ matches Android |
| primary | #FFCFD3DE | Digit buttons, top bar icons ✓ matches Android |
| primary_variant | #FFA0A8BB | C/AC, ±, % buttons ✓ matches Android |
| secondary | #FFC05F1C | ÷, ×, -, +, = buttons ✓ matches Android |
| on_primary | #FF333D49 | Text on primary buttons ✓ matches Android |
| on_secondary | #FFECECEC | Text on secondary buttons ✓ matches Android |
| on_background | #FF333D49 | Display text ✓ matches Android |
| surface | #FFCFD3DE | (defined but unused by NeuButton) |

## Source Files
- `entry/src/main/ets/pages/Index.ets` — main page layout
- `entry/src/main/ets/components/NeuButton.ets` — calculator button component
- `entry/src/main/ets/components/CorneredFlatIconButton.ets` — top bar icon component
- `entry/src/main/ets/viewmodel/CalculatorViewModel.ets` — state management
- `entry/src/main/ets/model/CalculatorModel.ets` — data model
