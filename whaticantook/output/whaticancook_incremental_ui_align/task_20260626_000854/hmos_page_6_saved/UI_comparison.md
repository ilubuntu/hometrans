# UI Comparison: Saved Page

**Android Snapshot**: `page_0008_MainActivity/view.xml`
**HarmonyOS Source**: `SavedPage.ets` + `SavedViewModel.ets`

## Page Header

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Title** | "Saved" (large) | "Saved" fontSize(28), Bold | Match | NO |
| **Subtitle** | "2 recipes in your cookbook" | subtitle(): "${count} recipes in your cookbook" → "2 recipes in your cookbook" | Match | NO |

## Recipe Cards

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Card 1 - Emoji** | "🥗" on gradient | RecipeImageComponent with emoji | Match | NO |
| **Card 1 - Status pill** | "2/5" text only | Icon + "2/5" (CookStatusPillComponent) | HarmonyOS adds icon | YES |
| **Card 1 - Favorite** | "Remove from favorites" (filled heart) | ♥ heart filled | Match | NO |
| **Card 1 - Category** | "🥗  Lunch" | `${emoji}  ${label}` | Match | NO |
| **Card 1 - Title** | "Greek Salad Bowl" | recipe.title | Match | NO |
| **Card 1 - Description** | "Crunchy cucumber, tomato and feta with oregano." | recipe.shortDescription | Match | NO |
| **Card 1 - Stats** | "12 min", "Easy", "260 kcal" text only | With 🕒 📊 🔥 icons | HarmonyOS adds icons | YES |
| **Card 2 - Emoji** | "🍚" on gradient | RecipeImageComponent | Match | NO |
| **Card 2 - Status pill** | "Ready to cook" text only | ✓ icon + "Ready to cook" | HarmonyOS adds icon | YES |
| **Card 2 - Favorite** | "Remove from favorites" (filled heart) | ♥ heart filled | Match | NO |
| **Card 2 - Category** | "🍝  Dinner" | Same | Match | NO |
| **Card 2 - Title** | "Chicken Fried Rice" | recipe.title | Match | NO |
| **Card 2 - Stats** | "25 min", "Medium", "480 kcal" text only | With icons | HarmonyOS adds icons | YES |

## Card Order

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Card 1** | Greek Salad Bowl (most recent) | SEED_FAVORITE_ORDER reversed: garden_green_salad first | Match | NO |
| **Card 2** | Chicken Fried Rice (older) | chicken_fried_rice second | Match | NO |

## Bottom Navigation Bar

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Discover tab** | Icon only (unselected) | 🍽 icon only | Emoji vs vector | YES |
| **Search tab** | Icon only | 🔍 icon only | Emoji vs vector | YES |
| **Pantry tab** | Icon only | 🧺 icon only | Emoji vs vector | YES |
| **Saved tab** | Icon + "Saved" label (selected) | 🔖 icon + "Saved" label (selected) | Emoji vs vector | YES |

## Empty State

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Empty state** | Not shown (2 recipes present) | "🔖" emoji + "No saved recipes yet" + "Tap the heart..." + "Browse recipes" CTA button | Not triggered — verify alignment when empty | NO |

## Summary of Key Differences

1. **Status pill icons**: Same recurring issue — HarmonyOS CookStatusPillComponent adds icons (✓ for ready, 🛒/🧺 for partial) before the status text. Android pills show text only ("Ready to cook", "2/5").

2. **Meta stat icons**: Same recurring issue — HarmonyOS adds 🕒 📊 🔥 icons before each stat. Android shows plain text.

3. **Bottom bar icons**: Emoji stand-ins (🍽, 🔍, 🧺, 🔖) instead of Android's Material vector icons.

4. **Overall**: The Saved page structure matches well. Card data, order, and text content all match. The differences are the same icon-related issues found across all pages with recipe cards.
