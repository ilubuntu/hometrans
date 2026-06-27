# Android Page 1: Calculator Main Page — UI Analysis

**Device:** emulator-5554 | **Screen:** 1344x2992px | **Density:** 480dpi (3.0x) | **dp:** 448 x 997.3

## View Tree Summary (from view.xml)

```
FrameLayout [0,0][1344,2992]
  ComposeView [0,0][1344,2992]
    ConstraintLayout
      TopBar (Row, layoutId="top_bar")
        CorneredFlatIconButton — "Theme changer" [clickable] [60,187][335,407]
          Icon view [115,231][280,363]
        CorneredFlatIconButton — "Calculations history" [clickable] [365,187][640,407]
          Icon view [420,231][585,363]
      Display (Column, layoutId="display")
        HorizontalScrollView text="0" (result) [1143,1046][1344,1215]
      KeyLayout (BoxWithConstraints, layoutId="key_layout")
        Grid(4 cols, 5 rows)
          Row 1: C [44,1276][338,1570] | ± [364,1276][658,1570] | % [684,1276][978,1570] | ÷ [1004,1276][1298,1570]
          Row 2: 7 [44,1596][338,1890] | 8 [364,1596][658,1890] | 9 [684,1596][978,1890] | × [1004,1596][1298,1890]
          Row 3: 4 [44,1916][338,2210] | 5 [364,1916][658,2210] | 6 [684,1916][978,2210] | - [1004,1916][1298,2210]
          Row 4: 1 [44,2236][338,2530] | 2 [364,2236][658,2530] | 3 [684,2236][978,2530] | + [1004,2236][1298,2530]
          Row 5: 0(span2) [44,2556][658,2850] | . [684,2556][978,2850] | = [1004,2556][1298,2850]
```

## Component Analysis

### 1. Top Bar (CalculatorTopBar)
| Attribute | Value |
|:----------|:------|
| **Layout** | Row, horizontalArrangement = spacedBy(10.dp, Alignment.Start) |
| **Position** | ConstraintLayout guidelines: top 1% → bottom 9%, startMargin = 20.dp |
| **Top bar height** | 220px (3.0x → 73.3dp) — from y=187 to y=407 |
| **Width** | fillToConstraints (full width minus startMargin) |

### 2. Top Bar Icons (CorneredFlatIconButton)
| Attribute | Value |
|:----------|:------|
| **Shape** | `MaterialTheme.shapes.small.copy(bottomStart = CornerSize(percent = 0))` = `RoundedCornerShape(50%).copy(bottomStart = 0%)` — 3 corners rounded at 50%, bottom-left sharp |
| **Icon bounds** | [115,231][280,363] → 165x132px (3.0x → 55x44dp), aspectRatio = 1.25 |
| **Click area** | [60,187][335,407] → 275x220px (3.0x → 91.7x73.3dp) |
| **Spacing** | Gap between icons: 30px (3.0x → 10dp) |
| **Background** | `primary.copy(alpha = 0.7f).compositeOver(BlueGrey100)` = #CFD3DE at 70% over #ECECEC |
| **Elevation** | null (flat, no shadow) |
| **Icons** | Material Design vector icons: `Icons.Outlined.DarkMode` (☀/moon), `Icons.Outlined.History` (clock) |
| **Icon fill** | `Modifier.fillMaxSize(0.60f)` — icon fills 60% of button |
| **Content padding** | PaddingValues(0.dp) |

### 3. Display Area
| Attribute | Value |
|:----------|:------|
| **Expression** | `MaterialTheme.typography.h5` = 24sp, `FontWeight.Light`, `alpha = ContentAlpha.medium` (0.6) |
| **Result** | `MaterialTheme.typography.h3` = 48sp, `FontWeight.Normal` |
| **Alignment** | Column horizontalAlignment = Alignment.End (right-aligned) |
| **Padding** | horizontal = 20.dp |
| **Scroll** | horizontalScroll with reverseScrolling = true |
| **Selection** | SelectionContainer wraps result text (text selectable) |
| **Position** | Bottom-linked to keyLayout.top with margin = 16.dp; top guideline 9% to 40% |
| **Result text bounds** | [1143,1046][1344,1215] → 201x169px (3.0x → 67x56.3dp) |

### 4. Key Layout (Number Pad)
| Attribute | Value |
|:----------|:------|
| **Container** | BoxWithConstraints, horizontal padding = 8.dp, aspectRatio(4/5 = 0.8) |
| **Grid** | 4 columns × 5 rows |
| **Position** | top guideline 40%, bottom guideline 2% (98%), verticalBias = 1.0 |
| **Grid area** | [44,1276][1298,2850] → 1254x1574px (3.0x → 418x524.7dp) |
| **Button size** | ~294x294px (3.0x → 98x98dp) |
| **Button spacing** | buttonWidth * 0.04 ≈ 3.92dp → ~12px gap between buttons |
| **"0" button** | spans 2 columns → 614px (3.0x → 204.7dp) |

### 5. Calculator Buttons (NeuButton)
| Attribute | Value |
|:----------|:------|
| **Shape** | `RoundedCornerShape(36)` — 36dp corner radius |
| **Elevation** | default = 18.dp, pressed = 8.dp |
| **Background** | `Brush.linearGradient(lightColor → darkColor)` where `darkColor = lightColor + 0.125 per channel` |
| **Border** | borderWidthPercent = 12% of min dimension, with `BlurMaskFilter` for soft edge |
| **Border gradient** | `LinearGradientShader(darkColor → lightColor)` |
| **Text style** | `MaterialTheme.typography.button`, fontSize = `maxHeight * 0.33f` ≈ 32.3sp, `FontWeight.Light` |
| **Text alignment** | TextAlign.Center |

### 6. Color Scheme (Light Theme)
| Color Name | Hex | Usage |
|:-----------|:----|:------|
| background | #FFECECEC | App background |
| primary | #FFCFD3DE | Digit buttons, top bar icons |
| primaryVariant | #FFA0A8BB | C/AC, ±, % buttons |
| secondary | #FFC05F1C | ÷, ×, -, +, = buttons |
| onPrimary | #FF333D49 | Text on primary buttons |
| onSecondary | #FFECECEC | Text on secondary buttons |
| onBackground | #FF333D49 | Display text |
| surface | #FFCFD3DE | NeuButton surface color |
