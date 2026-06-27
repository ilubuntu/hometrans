# UI Comparison: Settings Page

**Android Snapshot**: `page_0004_MainActivity/view.xml`
**HarmonyOS Source**: `SettingsPage.ets` + `SettingsViewModel.ets`

## Top Bar

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Back button** | Circle with "Back" desc, top-left | "←" text, circle, surface bg | Match (glyph vs vector) | NO |
| **Title** | "Settings" (next to back button) | "Settings" fontSize(20), Bold | Match | NO |
| **Bottom nav** | Not present (full screen) | Not present | Match | NO |

## APPEARANCE Section

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Section label** | "APPEARANCE" (uppercase, primary color) | SectionLabel("APPEARANCE"), primary color | Match | NO |
| **Theme card** | Surface card with "Theme" label | ThemeCard: surface card with "Theme" label | Match | NO |
| **Theme option - Match system** | "Match system" (selected, wider) | ThemeChip: "Match system", selected state | Match | NO |
| **Theme option - Light** | "Light" | "Light" | Match | NO |
| **Theme option - Dark** | "Dark" | "Dark" | Match | NO |
| **Theme chip layout** | 3 chips in a row, "Match system" wider | Row with layoutWeight(1) per chip (equal width) | Android: "Match system" is wider; HarmonyOS: equal width | YES |
| **Selected chip style** | Filled with primary color, white text | Primary bg, onPrimary text, bold | Match | NO |
| **Unselected chip style** | Surface variant bg, muted text | surfaceVariant bg, inkMuted text, outline border | Match | NO |

## DATA Section

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Section label** | "DATA" (uppercase, primary color) | SectionLabel("DATA") | Match | NO |
| **Clear pantry card** | Surface card with "Clear pantry" title + description | ClearPantryCard with same text | Match | NO |
| **Clear pantry icon** | Not visible in Android view tree (may be vector icon) | "🗑" trash emoji icon | HarmonyOS uses emoji; Android may use vector icon | YES |
| **Clear pantry title** | "Clear pantry" | "Clear pantry" | Match | NO |
| **Clear pantry desc** | "Remove all ingredients you've added" | Same text | Match | NO |
| **Card clickable** | Entire card clickable | onClick → clearPantry() | Match | NO |

## ABOUT Section

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Section label** | "ABOUT" (uppercase, primary color) | SectionLabel("ABOUT") | Match | NO |
| **App name row** | "App" → "WhatCanICook" | AboutRow("App", "WhatCanICook") | Match | NO |
| **Version row** | "Version" → "1.0.0" | AboutRow("Version", "1.0.0") | Match | NO |
| **Built with row** | "Built with" → "Jetpack Compose" | AboutRow("Built with", "Jetpack Compose") | Match | NO |
| **Footer text** | "Recipe data is bundled on-device..." | Same full text | Match | NO |
| **About card style** | Surface card, rounded | surface bg, borderRadius(20) | Match | NO |

## Summary of Key Differences

1. **Theme chip widths**: In the Android layout, the "Match system" chip is noticeably wider than "Light" and "Dark" (it spans about 360px vs ~360px each, but visually "Match system" has more text and takes more space). HarmonyOS uses layoutWeight(1) for all three chips, making them equal width. This changes the visual proportion — Android chips size to content, HarmonyOS chips are equal thirds.

2. **Clear pantry icon**: HarmonyOS uses a "🗑" (trash emoji) as the clear pantry icon. The Android snapshot may use a Material vector delete/trash icon that's not visible as text in the view tree. Minor visual difference.

3. **Overall**: The Settings page is a very close match. All text content, section structure, and data values match exactly.
