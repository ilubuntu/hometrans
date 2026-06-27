# UI Comparison: Recipe Detail Page

**Android Snapshots**: `page_0005_MainActivity/view.xml` (Ready to cook) + `page_0009_MainActivity/view.xml` (Missing ingredients)
**HarmonyOS Source**: `RecipeDetailPage.ets` + `RecipeDetailViewModel.ets`

## Top Controls / Overlay

| Component | Android Value (0005) | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Back button** | Circle with "Back" desc, top-left | CircleButton "←", top-left, surface bg | Match (text glyph vs vector icon) | NO |
| **Favorite button** | Circle with "Remove from favorites" / "Add to favorites", top-right | CircleButton with ♡/♥ heart glyph, top-right | Match (heart glyph vs vector icon) | NO |
| **Button position** | Overlaid on hero, pinned | Overlaid on hero via Stack(Top), pinned | Match | NO |

## Hero Section

| Component | Android Value (0005) | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Hero emoji** | "🍚" large (447-897px wide, ~462px tall) | RecipeImageComponent emojiSize: 90 | Android emoji is much larger (~462px vs 90vp) | YES |
| **Hero height** | ~900px (~300dp) | height(300) | Match | NO |
| **Hero gradient** | Gradient background behind emoji | linearGradient with brand colors | Match | NO |

## Content Sheet

| Component | Android Value (0005) | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Sheet overlap** | Content overlaps hero by ~12px (starts at y=888, hero ends at y=900) | margin({ top: -28 }) overlap | Match | NO |
| **Sheet corners** | Rounded top corners | borderRadius({ topLeft: 30, topRight: 30 }) | Match | NO |

## Recipe Info

| Component | Android Value (0005) | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Category badge** | "🍝  Dinner" | `${emoji}  ${label}` in primary color | Match | NO |
| **Title** | "Chicken Fried Rice" (large) | fontSize(24), Bold | Match | NO |
| **Description** | "Wok-style fried rice with juicy chicken and crisp veg." | fontSize(15), muted | Match | NO |
| **Tags** | "High protein", "Meal prep" (pill style) | TagsRow: surfaceVariant bg pills | Match | NO |

## Stat Tiles

| Component | Android Value (0005) | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Time tile** | "25 min" value + "Time" label | Icons.clock + "25 min" + "Time" label | HarmonyOS adds clock icon | YES |
| **Serves tile** | "3" value + "Serves" label | 🍽 icon + "3" + "Serves" label | HarmonyOS adds plate emoji icon | YES |
| **Level tile** | "Medium" value + "Level" label | Icons.difficulty + "Medium" + "Level" | HarmonyOS adds difficulty icon | YES |
| **Kcal tile** | "480" value + "Kcal" label | Icons.fire + "480" + "Kcal" | HarmonyOS adds fire icon | YES |
| **Tile layout** | 4 equal columns, surface bg | Row with layoutWeight(1) per tile | Match | NO |

## Cook Status - Ready (page_0005)

| Component | Android Value (0005) | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Banner** | 🎉 + "You're all set!" + "You have everything to make this." | ReadyBanner: 🎉 + same text | Match | NO |
| **Banner color** | Green/success container bg | AppColors.successContainer bg | Match | NO |

## Cook Status - Missing (page_0009)

| Component | Android Value (0009) | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Status pill** | "2/5" pill (in banner area) | CookStatusPillComponent with icon + "2/5" | HarmonyOS adds icon (🛒 or 🧺) | YES |
| **Headline** | "You're missing 3 ingredients" | missingHeadline() returns same text | Match | NO |
| **Missing ingredients** | Chips: "Pasta", "Canned tomatoes", "Cream" | Chips with capitalised names, surface bg | Match | NO |
| **Action button** | "Add missing to pantry" button | PrimaryButton with same text, primary bg | Match | NO |
| **Banner color** | Warning/golden container bg | AppColors.warningContainer bg | Match | NO |

## Ingredients List

| Component | Android Value (0005 - Ready) | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Section header** | "Ingredients" with count on right | SectionHeader("Ingredients", count) | Match | NO |
| **Ingredient row - in pantry** | "In pantry" checkmark icon (ImageView) | ✓ in filled circle (AppColors.primary bg) | Android uses checkmark image; HarmonyOS uses ✓ text in circle | NO |
| **Ingredient row - format** | "3 cups  Rice", "1 breast  Chicken" etc. | status.ingredient.display text | Match | NO |
| **Ingredient row - optional** | "Optional" label at right (e.g. "2 tbsp  Olive oil") | "Optional" text in inkMuted | Match | NO |
| **Ingredient count display** | No count shown in header (0005) | Shows count as actionText | Wait - Android 0005 has no count; 0009 has "Missing" labels | MINOR |

| Component | Android Value (0009 - Missing) | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Missing ingredient label** | "Missing" in red/error text at right | "Missing" in AppColors.error | Match | NO |
| **In-pantry marker** | Checkmark ImageView "In pantry" | ✓ in filled circle | Match (style differs) | NO |
| **Ingredient format** | "300 g  Pasta", "1 can  Canned tomatoes" etc. | ingredient.display | Match | NO |

## Steps Section

| Component | Android Value (0005 scroll) | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Section header** | "Steps" with "0/5" counter | SectionHeader "Steps" + "0/5" counter | Match | NO |
| **Progress bar** | Thin track at top of steps | Progress track + fill bar (6px height) | Match | NO |
| **Step number** | Circle with number "1"-"5" | Circle with index+1, surface bg | Match | NO |
| **Step text** | Full step description | step text in ink color | Match | NO |
| **Step clickable** | Each step row is clickable | StepRow has onClick → toggleStep | Match | NO |
| **Step completion** | (Not completed in snapshot) | Completed shows ✓ circle + strikethrough | Match (feature present) | NO |

## Summary of Key Differences

1. **Hero emoji size**: Android renders the hero emoji much larger (~462px / ~154dp) while HarmonyOS uses emojiSize: 90. The Android emoji dominates the hero area; HarmonyOS emoji appears smaller relative to the 300vp hero height.

2. **Stat tile icons**: HarmonyOS adds icons (🕒, 🍽, 📊, 🔥) to each stat tile. Android stat tiles show value + label only, no icon. This makes the tiles look busier in HarmonyOS.

3. **Status pill icon in missing banner**: HarmonyOS CookStatusPillComponent in the MissingBanner adds an icon before the "2/5" text. Android shows just "2/5" in the banner area.

4. **Ingredients count in header**: The SectionHeader shows a count number as the action text. In the Android Ready screenshot (0005), the ingredients section header doesn't show a count; it's just "Ingredients". Minor difference.
