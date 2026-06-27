# UI Comparison: Search Page

**Android Snapshot**: `page_0006_MainActivity/view.xml`
**HarmonyOS Source**: `SearchPage.ets` + `SearchViewModel.ets`

## Page Header

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Title** | "Search" (large, y=183-281) | "Search" fontSize(28), Bold | Match | NO |

## Search Field

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Search field** | EditText with "Search recipes…" placeholder | TextInput with "Search recipes…" placeholder | Match | NO |
| **Search icon** | No visible icon in search field (EditText only) | 🔍 (Icons.search) icon before input | HarmonyOS adds search icon inside field | YES |
| **Field style** | Rounded pill, surface bg | borderRadius(50), surface bg | Match | NO |
| **Field height** | ~150px (~50dp) | height(52) | Match | NO |

## Category Chips

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **"All" chip** | "All" text, clickable | "All" text, clickable | Match | NO |
| **"🍳 Breakfast"** | Emoji + "Breakfast", clickable | Emoji + label, clickable | Match | NO |
| **"🥗 Lunch"** | Emoji + "Lunch", clickable | Emoji + label, clickable | Match | NO |
| **"🍝 Dinner"** | Emoji + "Dinner", clickable | Emoji + label, clickable | Match | NO |
| **Chip layout** | Horizontal scroll row | Horizontal Scroll() row | Match | NO |

## Filter Row (Cookable + Sort)

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Cookable toggle** | "✅" emoji + "Cookable" text, clickable | Chip("Cookable", "✅", cookableOnly) | Match | NO |
| **"Best match" sort** | "Best match" text chip, clickable, selected | Chip("Best match"), SortOption.RELEVANCE | Match | NO |
| **"Quickest" sort** | "Quickest" text chip, clickable | Chip("Quickest"), SortOption.QUICKEST | Match | NO |
| **"Fewest missing" sort** | "Fewest missing" text chip, clickable | Chip("Fewest missing"), SortOption.FEWEST_MISSING | Match | NO |
| **Row layout** | Cookable toggle left, sort options right, all in horizontal scroll | Scroll() with Row containing all chips | Match | NO |

## Results List

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Card structure** | Same RecipeCard as Discover page | Same RecipeCardComponent | Match | NO |
| **Card 1 - Emoji** | "🍚" | Same | Match | NO |
| **Card 1 - Status pill** | "Ready to cook" text only | ✓ icon + "Ready to cook" | HarmonyOS adds icon | YES |
| **Card 1 - Stats** | "25 min", "Medium", "480 kcal" text only | With 🕒 📊 🔥 icons | HarmonyOS adds icons | YES |
| **Card 2 - Status pill** | "2/5" text only | Icon + "2/5" | HarmonyOS adds icon | YES |
| **Card 2 - Stats** | "30 min", "Medium", "560 kcal" text only | With icons | HarmonyOS adds icons | YES |
| **Card 3** | Partial card visible at bottom | Same RecipeCardComponent | Match | NO |

## Bottom Navigation Bar

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Discover tab** | Icon only (unselected) | 🍽 icon only | Emoji vs vector icon | YES |
| **Search tab** | Icon + "Search" label (selected) | 🔍 icon + "Search" label (selected) | Emoji vs vector icon | YES |
| **Pantry tab** | Icon only | 🧺 icon only | Emoji vs vector icon | YES |
| **Saved tab** | Icon only | 🔖 icon only | Emoji vs vector icon | YES |

## Empty State

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Empty state** | Not shown (results present in snapshot) | "🔍" + "No recipes found" + "Try a different ingredient..." | Not triggered in this snapshot — verify it matches Android when triggered | NO |

## Summary of Key Differences

1. **Search icon in field**: HarmonyOS adds a 🔍 (Icons.search) emoji icon inside the search field before the text input. The Android search field is a plain EditText without a visible search icon in the view tree.

2. **Status pill icons**: Same as Discover page — HarmonyOS adds icons before status text; Android shows text only.

3. **Meta stat icons**: Same as Discover page — HarmonyOS adds 🕒 📊 🔥 icons; Android shows plain text.

4. **Bottom bar icons**: Emoji stand-ins (🍽, 🔍, 🧺, 🔖) instead of Android's Material vector icons.
