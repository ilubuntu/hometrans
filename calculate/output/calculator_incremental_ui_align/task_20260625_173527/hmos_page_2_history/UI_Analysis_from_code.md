# HarmonyOS Page 2: History Page — UI Analysis (from Source Code)

**Status:** HistoryPage does NOT exist in the HarmonyOS project yet.

## Current State

The `Index.ets` file has a `navigateToHistory()` method that attempts `router.pushUrl({ url: 'pages/HistoryPage' })`, but:
1. No `pages/HistoryPage.ets` file exists
2. The route is not registered in `main_pages.json`
3. The try/catch silently swallows the error and stays on the calculator page

**Capture result:** Clicking the history icon stays on the Index page (confirmed by layout dump showing page = "Index").

## Required Implementation (based on Android HistoryScreen.kt)

The HistoryPage needs to be created to match the Android design. Here is the UI specification:

### 1. Page Structure
```
Column (full screen)
  ├── Top Bar (Row with Back + ClearAll icons)
  ├── History Items List (scrollable, reversed)
  │   ├── HistoryItem (per date group)
  │   │   ├── CalculationItem (expression + result, right-aligned)
  │   │   ├── CalculationItem ...
  │   │   └── Date label
  │   ├── Divider
  │   └── HistoryItem ...
  └── (Clear confirmation dialog/sheet)
```

### 2. Top Bar
| Attribute | Target Value |
|:----------|:------|
| **Layout** | Row, spacedBy 10vp, padding left=20vp |
| **Back button** | CorneredFlatIconButton, icon = back arrow, aspectRatio(1.25) |
| **Clear button** | CorneredFlatIconButton, icon = clear-all, aspectRatio(1.25) |
| **Position** | Top of page, ~10% of screen height |

### 3. History Items List
| Attribute | Target Value |
|:----------|:------|
| **Container** | Column/List, fill remaining space |
| **Empty state** | Text "Nothing to show", centered |
| **List** | Scrollable list showing calculations grouped by date |
| **Content padding** | top=8vp |

### 4. History Item / Calculation Item
| Attribute | Target Value |
|:----------|:------|
| **Expression** | fontSize 24vp (~h5), FontWeight.Light, opacity=0.6, right-aligned, padding horizontal=16vp |
| **Result** | fontSize 24vp (~h5), FontWeight.Normal, right-aligned, padding horizontal=16vp |
| **Date label** | subtitle1/16vp, FontWeight.Medium, padding vertical=12vp, horizontal=28vp |
| **Divider** | Between date groups, padding vertical=8vp, horizontal=16vp |

### 5. Clear History Confirmation
| Attribute | Target Value |
|:----------|:------|
| **Type** | Bottom sheet or dialog |
| **Title** | "Clear" |
| **Message** | "Clear history now?" |
| **Buttons** | Cancel (outlined) + Clear (filled), each aspectRatio(2.5) |
| **Background** | Semi-transparent overlay (black 32%) |

## Android Source Reference
- `HistoryScreen.kt` — main screen composable
- `HistoryItem.kt` — calculation item layout
- `HistoryViewModel.kt` — state management
- `HistoryUiState.kt` — UI state model
