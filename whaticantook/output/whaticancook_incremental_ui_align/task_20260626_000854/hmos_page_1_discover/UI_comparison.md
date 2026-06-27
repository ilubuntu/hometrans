# UI Comparison: Discover Page

**Android Snapshot**: `page_0001_MainActivity/view.xml`
**HarmonyOS Source**: `DiscoverPage.ets` + `DiscoverViewModel.ets` + `RecipeCardComponent.ets` + `BottomBar.ets`

## Page Structure Comparison

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Page header** | "Browse recipes" title only (no greeting, no app name) | Greeting ("Good morning/afternoon/evening") + "What can I cook?" app title + settings gear (⚙) button | HarmonyOS adds greeting + app title + settings icon not present in Android snapshot | YES |
| **Search bar** | Not present on Discover page | Search bar with 🔍 icon + "Search recipes, ingredients..." placeholder | HarmonyOS has extra search bar not in Android Discover | YES |
| **Pantry summary card** | Not present on Discover page | "Your pantry" card with 🧺 icon, ingredient count subtitle, › chevron | HarmonyOS has extra pantry card not in Android Discover | YES |
| **Section header "Browse recipes"** | Present as main page title at top | Present as a section header below search bar and pantry card | Present in both but positioned differently | YES |
| **Scrollable area** | Starts at y=159, content: title → chips → cards | Starts from top, content: header → search → pantry card → section header → chips → cards | HarmonyOS has extra sections pushing cards down | YES |

## Category Chips

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **"All" chip** | Text "All", clickable, selected state | Text "All", clickable, border + background toggle | Match | NO |
| **"🍳 Breakfast" chip** | Emoji + "Breakfast" text, clickable | Emoji + label, clickable | Match | NO |
| **"🥗 Lunch" chip** | Emoji + "Lunch" text, clickable | Emoji + label, clickable | Match | NO |
| **"🍝 Dinner" chip** | Emoji + "Dinner" text, clickable | Emoji + label, clickable | Match | NO |
| **Chip horizontal scroll** | Horizontal scrollable row | Horizontal Scroll() container | Match | NO |

## Recipe Cards

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Card 1 - Emoji** | "🍚" centered on gradient | Emoji on gradient via RecipeImageComponent | Match | NO |
| **Card 1 - Status pill** | "Ready to cook" text only, no icon | "✓ Ready to cook" with check icon (Icons.check) | HarmonyOS adds icon before label | YES |
| **Card 1 - Favorite** | "Remove from favorites" (filled heart) | ♥ heart filled, clickable toggle | Match (icon style differs: Android vector vs HarmonyOS ♥) | NO |
| **Card 1 - Category** | "🍝  Dinner" | `${emoji}  ${label}` in primary color | Match | NO |
| **Card 1 - Title** | "Chicken Fried Rice" | recipe.title, bold | Match | NO |
| **Card 1 - Description** | "Wok-style fried rice with juicy chicken and crisp veg." | recipe.shortDescription, muted | Match | NO |
| **Card 1 - Time stat** | "25 min" text only | Icons.clock (🕒) + "25 min" | HarmonyOS adds clock icon | YES |
| **Card 1 - Difficulty stat** | "Medium" text only | Icons.difficulty (📊) + "Medium" | HarmonyOS adds difficulty icon | YES |
| **Card 1 - Calories stat** | "480 kcal" text only | Icons.fire (🔥) + "480 kcal" | HarmonyOS adds fire icon | YES |
| **Card 2 - Status pill** | "2/5" text only, no icon | "🧺 2/5" or similar with kitchen icon | HarmonyOS adds icon before label | YES |
| **Card 2 - Favorite** | "Add to favorites" (outline heart) | ♡ heart outline, clickable toggle | Match | NO |
| **Card 2 - Category** | "🍝  Dinner" | Same format | Match | NO |
| **Card 2 - Title** | "Creamy Tomato Pasta" | recipe.title | Match | NO |
| **Card 2 - Stats** | "30 min", "Medium", "560 kcal" text only | With icons 🕒 📊 🔥 | Icons added | YES |
| **Card 3** | "🥗" emoji, "2/5", "Remove from favorites" | Same structure | Match (partial visible in snapshot) | NO |
| **Card border radius** | Rounded corners (~24dp) | borderRadius(24) | Match | NO |
| **Card shadow** | Card elevation/shadow | shadow({ radius: 12, color: '#1A000000', offsetY: 4 }) | Match | NO |

## Bottom Navigation Bar

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Bar style** | Floating rounded pill, white bg | Floating rounded pill, surface bg | Match | NO |
| **Discover tab** | Icon + "Discover" label (selected) | 🍽 icon + "Discover" label (selected, primary color) | Android uses vector icon; HarmonyOS uses emoji 🍽 | YES |
| **Search tab** | Icon only (unselected) | 🔍 icon only | Icon style: emoji vs vector | YES |
| **Pantry tab** | Icon only (unselected) | 🧺 icon only | Icon style: emoji vs vector | YES |
| **Saved tab** | Icon only (unselected) | 🔖 icon only | Icon style: emoji vs vector | YES |
| **Tab labels** | Selected tab shows label | Selected tab shows label | Match | NO |

## Summary of Key Differences

1. **Extra header elements**: HarmonyOS Discover page includes a greeting ("Good morning/afternoon/evening"), app title "What can I cook?", and a settings gear button (⚙). The Android snapshot shows only "Browse recipes" as the page title — no greeting, no app name, no settings button.

2. **Extra search bar**: HarmonyOS has a search bar on the Discover page that doesn't exist in the Android Discover snapshot (search is accessed via the bottom bar Search tab in Android).

3. **Extra pantry summary card**: HarmonyOS shows a "Your pantry" card with ingredient count and navigation. This is not present in the Android Discover page.

4. **Status pill icons**: HarmonyOS CookStatusPillComponent adds icons (✓, 🛒, 🧺) before the status text. Android pills show only text ("Ready to cook", "2/5").

5. **Meta stat icons**: HarmonyOS recipe card MetaStat adds icons (🕒, 📊, 🔥) before each stat. Android shows plain text ("25 min", "Medium", "480 kcal").

6. **Bottom bar icons**: HarmonyOS uses emoji stand-ins (🍽, 🔍, 🧺, 🔖) instead of Android's Material vector icons.
