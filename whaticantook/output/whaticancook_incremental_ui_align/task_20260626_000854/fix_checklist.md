# Fix Checklist

Combined list of all meaningful UI differences between the Android snapshots and HarmonyOS source code across all 6 pages. Items are grouped by page and tagged with severity (HIGH/MEDIUM/LOW).

> **Session note (task_20260626_000854):** Items marked `[x]` were fixed in this
> pass. Items left `[ ]` with a `— skipped:` note were intentionally **not**
> changed, per task instructions (either confirmed as false-positive diffs or
> explicitly out of scope). Do **not** re-open skipped items without new evidence.

---

## Page 1: Discover

### HIGH - Extra header elements not in Android
- [ ] **Remove greeting text** ("Good morning/afternoon/evening") from DiscoverPage HomeHeader — Android Discover page starts directly with "Browse recipes" title
  — skipped: confirmed correct; Android `HomeScreen.kt` includes the greeting. The diff came from a scrolled snapshot.
- [ ] **Remove "What can I cook?" app title** from DiscoverPage HomeHeader — not present in Android Discover snapshot
  — skipped: confirmed correct; present in Android source.
- [ ] **Remove settings gear button** (⚙) from DiscoverPage HomeHeader — not present in Android Discover snapshot (settings accessed elsewhere)
  — skipped: confirmed correct; present in Android source.

### HIGH - Extra search bar not in Android
- [ ] **Remove SearchBarButton** from DiscoverPage — Android Discover page has no search bar; search is accessed via bottom bar Search tab
  — skipped: confirmed correct; Android `HomeScreen.kt` includes the search bar.

### HIGH - Extra pantry summary card not in Android
- [ ] **Remove PantrySummaryCard** from DiscoverPage — Android Discover page has no "Your pantry" card; pantry is accessed via bottom bar Pantry tab
  — skipped: confirmed correct; present in Android source.

### MEDIUM - Status pill icons
- [x] **Remove icon from CookStatusPillComponent** — Android shows text only ("Ready to cook", "2/5") without leading icons (✓, 🛒, 🧺)
  — fixed: removed `Text(this.icon())` + unused `icon()` method in `RecipeCardComponent.ets`; colors preserved.

### MEDIUM - Meta stat icons
- [x] **Remove icons from recipe card MetaStat** — Android shows plain text stats ("25 min", "Medium", "480 kcal") without 🕒 📊 🔥 icons
  — fixed: `MetaStat` builder now takes `(text)` only; compact-card time row also de-iconed for consistency.

### LOW - Bottom bar icon style
- [ ] **Replace emoji icons with Material-style vector icons** in BottomBar — currently uses 🍽 🔍 🧺 🔖 emoji stand-ins (affects all pages with bottom bar)
  — skipped: out of scope (requires new vector icon assets; not requested in this task).

---

## Page 2: Recipe Detail

### MEDIUM - Hero emoji size
- [x] **Increase hero emoji size** in RecipeDetailPage HeroSection — Android renders emoji at ~154dp (dominates hero); HarmonyOS uses emojiSize: 90 (appears small in 300vp hero)
  — fixed: `emojiSize` 90 → 130 in `HeroSection`.

### MEDIUM - Stat tile icons
- [x] **Remove icons from StatTile** — Android stat tiles show value + label only (no 🕒 🍽 📊 🔥 icons); HarmonyOS adds leading icons to each tile
  — fixed: `StatTile(icon, value, label)` → `StatTile(value, label)`; dropped the `Text(icon)` line and the now-unused `ICON_*` consts.

### LOW - Status pill icon in missing banner
- [x] **Remove icon from CookStatusPillComponent** in MissingBanner — Android shows "2/5" text only without leading icon
  — fixed via the shared `CookStatusPillComponent` change in `RecipeCardComponent.ets`.

### LOW - Ingredients count in header
- [ ] **Verify ingredients header** — Android Ready screenshot (0005) shows "Ingredients" without a count number; HarmonyOS SectionHeader shows count as action text
  — skipped: needs further confirmation; left unchanged to avoid guessing.

---

## Page 3: Search

### MEDIUM - Search icon inside field
- [ ] **Remove 🔍 icon from SearchField** — Android search field is a plain EditText without a visible search icon; HarmonyOS adds Icons.search (🔍) inside the field
  — skipped: per task, the 🔍 is fine to keep (Android's search hint includes a magnifying-glass concept).

### MEDIUM - Status pill icons
- [x] **Remove icon from CookStatusPillComponent** — same issue as all pages with recipe cards
  — fixed via the shared `CookStatusPillComponent` change.

### MEDIUM - Meta stat icons
- [x] **Remove icons from recipe card MetaStat** — same issue as all pages with recipe cards
  — fixed via the shared `MetaStat` builder change.

### LOW - Bottom bar icon style
- [ ] **Replace emoji icons with vector icons** in BottomBar — same issue as all pages
  — skipped: out of scope (requires new vector icon assets).

---

## Page 4: Pantry

### LOW - Add button style
- [ ] **Replace "+" text with vector add icon** in AddIngredientField — Android uses a Material vector add icon (content-desc "Add ingredient"); HarmonyOS uses "+" text character
  — skipped: out of scope (requires new vector icon assets).

### LOW - Chip remove indicator
- [ ] **Replace ✕ text with vector close icon** in PantryChip — Android uses vector drawable with content-desc "Remove {name}"; HarmonyOS uses ✕ (U+2715) text
  — skipped: out of scope (requires new vector icon assets).

### LOW - Suggestion chip add indicator
- [ ] **Replace "+" text with vector add icon** in SuggestionChip — Android uses vector drawable with content-desc "Add {name}"; HarmonyOS uses "+" text character
  — skipped: out of scope (requires new vector icon assets).

### LOW - Bottom bar icon style
- [ ] **Replace emoji icons with vector icons** in BottomBar — same issue as all pages
  — skipped: out of scope (requires new vector icon assets).

---

## Page 5: Settings

### MEDIUM - Theme chip width
- [ ] **Make "Match system" chip wider than others** — Android chips are sized to content ("Match system" is wider); HarmonyOS uses layoutWeight(1) making all 3 chips equal width. Remove layoutWeight and use content-based sizing or give "Match system" more weight.
  — skipped: per task, equal-width chips are fine and consistent with the Android WccChip design.

### LOW - Clear pantry icon
- [ ] **Replace "🗑" emoji with Material vector trash/delete icon** — Android likely uses a vector icon; HarmonyOS uses trash emoji
  — skipped: out of scope (requires new vector icon assets).

---

## Page 6: Saved

### MEDIUM - Status pill icons
- [x] **Remove icon from CookStatusPillComponent** — same issue as all pages with recipe cards
  — fixed via the shared `CookStatusPillComponent` change.

### MEDIUM - Meta stat icons
- [x] **Remove icons from recipe card MetaStat** — same issue as all pages with recipe cards
  — fixed via the shared `MetaStat` builder change.

### LOW - Bottom bar icon style
- [ ] **Replace emoji icons with vector icons** in BottomBar — same issue as all pages
  — skipped: out of scope (requires new vector icon assets).

---

## Cross-Page Issues (affect multiple pages)

### 1. CookStatusPill icons (affects: Discover, Search, Saved, Recipe Detail) — DONE
- [x] **Files**: `RecipeCardComponent.ets` (CookStatusPillComponent), `RecipeDetailPage.ets` (MissingBanner)
- **Fix**: Removed the `Text(this.icon())` line from the pill's build method, keeping only the label text. Also removed the now-unused `icon()` method. Status background/foreground colors are preserved.

### 2. MetaStat icons (affects: Discover, Search, Saved) — DONE
- [x] **Files**: `RecipeCardComponent.ets` (RecipeCardComponent → MetaStat builder)
- **Fix**: Removed the `Text(icon)` from the MetaStat builder; signature is now `MetaStat(text: string)`. Call sites updated. Compact-card time row de-iconed for consistency.

### 3. StatTile icons (affects: Recipe Detail) — DONE
- [x] **Files**: `RecipeDetailPage.ets` (StatTile builder)
- **Fix**: Removed the `Text(icon)` line from the StatTile builder; signature is now `StatTile(value, label)`. `StatTiles` call sites updated; unused `ICON_*` consts removed. Hero emoji `emojiSize` 90 → 130 in the same file.

### 4. Bottom bar emoji icons (affects: Discover, Search, Pantry, Saved) — SKIPPED
- [ ] **Files**: `AppColors.ets` (Icons class, TOP_LEVEL_TABS)
- **Fix**: Replace emoji strings with `$r('app.media.*')` vector icon resources once icon assets are added to the project.
  — skipped: out of scope (requires new vector icon assets).

### 5. Unicode icon stand-ins throughout (affects: all pages) — SKIPPED
- [ ] **Files**: `AppColors.ets` (Icons class)
- **Fix**: Replace all unicode glyph stand-ins (⚙, 🔍, 🧺, ♥, ♡, 🕒, 🔥, 📊, ✓, 🛒, 🗑, etc.) with proper vector icon resources for pixel parity with Android Material icons.
  — skipped: out of scope (requires new vector icon assets).
