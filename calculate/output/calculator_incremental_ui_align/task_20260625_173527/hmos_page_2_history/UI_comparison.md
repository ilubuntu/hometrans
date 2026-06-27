# Page 2: History Page — UI Comparison (Android vs HarmonyOS)

**Android:** Full history page implemented and functional
**HarmonyOS:** HistoryPage does NOT exist — page not yet created

## Comparison Table

| UI Component | Android | HarmonyOS | Diff |
|:-------------|:------|:------|:--------|
| **Page Existence** | ✅ HistoryScreen.kt fully implemented | ❌ HistoryPage.ets does not exist | 🔴 **MISSING** — Page needs to be created |
| **Route Registration** | ✅ Navigation route registered | ❌ 'pages/HistoryPage' not in main_pages.json | 🔴 **MISSING** |
| **Top Bar — Back Button** | CorneredFlatIconButton with ArrowBack icon | — | 🔴 **MISSING** |
| **Top Bar — Clear Button** | CorneredFlatIconButton with ClearAll icon | — | 🔴 **MISSING** |
| **History List** | LazyColumn, reversed scroll, grouped by date | — | 🔴 **MISSING** |
| **Calculation Item** | Expression + Result, right-aligned, horizontally scrollable | — | 🔴 **MISSING** |
| **Date Label** | Text below calculations, subtitle1/Medium | — | 🔴 **MISSING** |
| **Empty State** | "Nothing to show" centered text | — | 🔴 **MISSING** |
| **Clear Confirmation** | ModalBottomSheet with Cancel/Clear buttons | — | 🔴 **MISSING** |
| **Divider** | Between date groups | — | 🔴 **MISSING** |

## Summary

The entire History page is missing from the HarmonyOS project. It needs to be created from scratch, implementing:
1. `HistoryPage.ets` — the page component
2. Registration in `main_pages.json`
3. History data model (History, Calculation)
4. HistoryViewModel for state management
5. Optional: History item component, clear confirmation dialog

## Priority
This is a **feature gap** rather than a visual diff. The page needs to be implemented as a new feature.
