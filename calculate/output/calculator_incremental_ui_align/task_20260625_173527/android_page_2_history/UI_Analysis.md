# Android Page 2: History Page — UI Analysis

**Device:** emulator-5554 | **Screen:** 1344x2992px | **Density:** 480dpi (3.0x) | **dp:** 448 x 997.3

## View Tree Summary (from view.xml)

```
FrameLayout [0,0][1344,2992]
  ConstraintLayout
    TopBar (Box, layoutId="top_bar")
      Row [60,187][642,408]
        CorneredFlatIconButton — "Back to calculator" [clickable] [60,187][336,408]
          Icon view [115,231][281,364]
        CorneredFlatIconButton — "Clear history" [clickable] [366,187][642,408]
          Icon view [421,231][587,364]
    Spacer (layoutId="spacer") — guideline 10%-11%
    HistoryItemsList (Box, layoutId="history_list")
      LazyColumn (reverse list, starts at bottom)
        HistoryItem (date: "Jun 23")
          CalculationItem — "1 + 1" / "2.0" [clickable] [0,1921][1344,2141]
          CalculationItem — "10 + 9" / "19.0" [clickable] [0,2141][1344,2361]
          Text "Jun 23" [84,2397][235,2469]
        Divider
        HistoryItem (date: "Yesterday")
          CalculationItem — "4 - 5" / "-1.0" [clickable] [0,2556][1344,2776]
          Text "Yesterday" [84,2812][303,2884]
```

## Component Analysis

### 1. Top Bar (HistoryTopBar)
| Attribute | Value |
|:----------|:------|
| **Layout** | Box(contentAlignment = CenterStart) > Row(fillMaxWidth, fillMaxHeight(0.8f), padding start=20dp, spacedBy=10dp) |
| **Position** | ConstraintLayout guideline top → 10% |
| **Icons** | Same CorneredFlatIconButton as calculator page: ArrowBack, ClearAll |
| **Icon bounds** | Back: [115,231][281,364] → 166x133px (3.0x → 55.3x44.3dp) |
| **Icon aspectRatio** | 1.25 ✓ |

### 2. History Items List
| Attribute | Value |
|:----------|:------|
| **Container** | Box, background = MaterialTheme.colors.background |
| **List** | LazyColumn, align(BottomCenter), initialFirstVisibleItemIndex = size * 2 (reversed) |
| **Content padding** | PaddingValues(top = 8.dp) |
| **Empty state** | Text "Nothing to show" centered |
| **List area** | Full width, from guideline 11% to bottom |

### 3. History Item (per date group)
| Attribute | Value |
|:----------|:------|
| **Container** | Column |
| **Calculations** | Multiple CalculationItem per date |
| **Date label** | Text, padding(vertical=12dp, horizontal=28dp), subtitle1/Medium style |
| **Divider** | Between groups, padding(vertical=8dp, horizontal=16dp) |

### 4. Calculation Item
| Attribute | Value |
|:----------|:------|
| **Container** | Column(fillMaxWidth, clickable, padding vertical=8dp, horizontalAlignment=End) |
| **Expression** | h5/Light, alpha=ContentAlpha.medium(0.6), horizontalScroll(reverse), padding horizontal=16dp |
| **Result** | h5/Normal, horizontalScroll(reverse), padding horizontal=16dp |
| **Expression example** | "1 + 1" at [1091,1945][1344,2031] → right-aligned |
| **Result example** | "2.0" at [1149,2031][1344,2117] → right-aligned |
| **Item height** | ~220px (3.0x → 73.3dp) per calculation |

### 5. Modal Bottom Sheet (Clear History Confirmation)
| Attribute | Value |
|:----------|:------|
| **Sheet background** | MaterialTheme.colors.background |
| **Sheet shape** | MaterialTheme.shapes.large.copy(bottomEnd=0, bottomStart=0) = RoundedCornerShape(12dp) top corners only |
| **Scrim** | Color.Black.copy(0.32f) |
| **Title** | "Clear", h6 style |
| **Subtitle** | "Clear history now?", body1 style |
| **Buttons** | OutlinedCorneredFlatButton("Cancel") + CorneredFlatButton("Clear"), aspectRatio(2.5), height 48dp, spacedBy 8dp |
