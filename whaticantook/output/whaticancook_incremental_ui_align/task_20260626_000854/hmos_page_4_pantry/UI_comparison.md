# UI Comparison: Pantry Page

**Android Snapshot**: `page_0007_MainActivity/view.xml`
**HarmonyOS Source**: `PantryPage.ets` + `PantryViewModel.ets` + `PantryModel.ets`

## Page Header

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Title** | "My pantry" (large) | "My pantry" fontSize(28), Bold | Match | NO |
| **Subtitle** | "9 ingredients on hand" | subtitleText(): "${count} ingredients on hand" | Match | NO |

## Add Ingredient Field

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Input field** | EditText with "Add your own ingredient…" placeholder | TextInput with same placeholder | Match | NO |
| **Add button** | Circle button with "Add ingredient" desc (content-desc) | "+" text button, primary bg circle | Android uses vector add icon; HarmonyOS uses "+" text | YES |
| **Field style** | Rounded pill, surface bg | borderRadius(50), surface bg | Match | NO |
| **Submit on enter** | (Implicit from EditText) | onSubmit → submitAdd() | Match | NO |

## "In your kitchen" Section

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Section header** | "In your kitchen" | SectionHeader("In your kitchen") | Match | NO |
| **Clear all button** | "Clear all" text, clickable, right-aligned | "Clear all" text, primary color, onClick → clear() | Match | NO |
| **Ingredient chips** | Filled chips with ingredient name + "Remove {name}" desc | PantryChip with display name + ✕ close icon | Match (Android uses content-desc "Remove X"; HarmonyOS uses visible ✕) | NO |
| **Chip count** | 9 items: Soy Sauce, Chicken, Egg, Rice, Cucumber, Avocado, Carrot, Garlic, Onion | SEED_NAMES: same 9 items | Match | NO |
| **Chip display names** | "Soy Sauce", "Chicken", "Egg", "Rice", "Cucumber", "Avocado", "Carrot", "Garlic", "Onion" | display getter title-cases names | Match | NO |
| **Chip layout** | Wrapping FlowRow | Flex({ wrap: FlexWrap.Wrap }) | Match | NO |
| **Chip bg color** | Secondary container color | AppColors.secondaryContainer | Match | NO |

## "Quick add" Section

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Section header** | "Quick add" | quickAddTitle() → "Quick add" | Match | NO |

## Quick Add - Produce Category

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Category header** | "🥦  Produce" | `${emoji}  ${label}` → "🥦  Produce" | Match | NO |
| **Produce items** | Tomato, Potato, Bell pepper, Spinach, Mushroom, Lemon, Lime, Broccoli, Ginger, Green onion, Zucchini | SuggestionChip for each (excluding already-added: cucumber, carrot, garlic, onion) | Match (11 items shown, 5 excluded as already added) | NO |
| **Chip style** | Outlined chip with name + "Add {name}" desc | SuggestionChip: name + "+" icon, outline border | Match (Android content-desc "Add X" vs HarmonyOS visible "+" text) | NO |

## Quick Add - Meat & Seafood Category

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Category header** | "🍗  Meat & Seafood" | Same emoji + label | Match | NO |
| **Items** | Beef, Pork, Bacon, Shrimp, Salmon, Tuna | Same items (chicken excluded as already added) | Match | NO |

## Quick Add - Dairy & Eggs Category

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Category header** | "🧀  Dairy & Eggs" | Same emoji + label | Match | NO |
| **Items** | Milk, Butter, Cheese, Yogurt, Cream, Parmesan, Mozzarella | Same items (egg excluded as already added) | Match | NO |

## Quick Add - Grains & Bread Category

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Category header** | "🍞  Grains & Bread" | Same emoji + label | Match | NO |
| **Items** | Pasta, Bread, Flour, Noodle, Tortilla, Oats, Quinoa | Same items (rice excluded as already added) | Match | NO |

## Missing Categories (Present in Android, NOT in HarmonyOS snapshot)

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Pantry Staples category** | Not visible in Android snapshot (scrolled off) | Defined in PANTRY_CATALOG (sugar, canned tomatoes, etc.) | Present in data but not visible in snapshot | NO |
| **Condiments & Oils category** | Not visible (scrolled off) | Defined (olive oil, soy sauce, etc.) | soy sauce excluded as added | NO |
| **Spices & Herbs category** | Not visible (scrolled off) | Defined (salt, pepper, etc.) | Present in data | NO |

## Bottom Navigation Bar

| Component | Android Value | HarmonyOS Value | Diff/Status | Fix Needed |
|---|---|---|---|---|
| **Discover tab** | Icon only (unselected) | 🍽 icon only | Emoji vs vector | YES |
| **Search tab** | Icon only | 🔍 icon only | Emoji vs vector | YES |
| **Pantry tab** | Icon + "Pantry" label (selected) | 🧺 icon + "Pantry" label (selected) | Emoji vs vector | YES |
| **Saved tab** | Icon only | 🔖 icon only | Emoji vs vector | YES |

## Summary of Key Differences

1. **Add button style**: Android uses a vector "+" add icon with content-desc "Add ingredient". HarmonyOS renders a "+" text character in a primary-colored circle. Functionally equivalent but visually different.

2. **Chip remove indicator**: Android pantry chips use content-desc "Remove {name}" for accessibility (the X icon is a vector drawable). HarmonyOS renders a visible ✕ (U+2715) text character next to each ingredient name.

3. **Suggestion chip add indicator**: Android uses content-desc "Add {name}" (vector + icon). HarmonyOS shows a visible "+" text character.

4. **Bottom bar icons**: Emoji stand-ins (🍽, 🔍, 🧺, 🔖) instead of Android's Material vector icons.

5. **Overall**: The Pantry page is the closest match of all pages. Structure, data, categories, ingredient names, and layout all match very well.
