# Code Review Report

## Overview

- **Project**: whaticancookHarmony (`/Users/bb/work/hometrans/whaticantook/input/whaticancookHarmony`)
- **Commit ID**: `d7d17e4c5061bcfd413d12483997d6e84945c87e`
  - *Commit scope*: focused logic refinement — "pantry-count owner + nav/persist/re-show refresh". It (a) made `PantryState` the single app-wide pantry owner via `getSharedPantry()`/AppStorage, (b) added `onPageShow()` → `vm.refresh()` on Home/Search/Favorites so derived views recompute after pantry edits on other screens, (c) wired `PersistentStorage.persistProp('onboardingComplete')` in `Index` so onboarding completion survives restart, (d) removed the redundant `pantryCount` field in favor of the shared pantry's `count`.
  - *Review scope*: the full project as it stands at this commit, validated against all 42 user scenarios. The commit materially strengthens cross-screen state consistency (scenarios 5, 11, 12, 15, 21, 27, 35), so those are given close attention.
- **Scenario Doc**: `/Users/bb/work/hometrans/whaticantook/output/whaticancook_pipeline/all-specs.md` (42 merged atomic specs)
- **Code Context**: `extract_commit_context` MCP tool (call-graph + diff context) — succeeded; supplemented by direct reads of all 39 `.ets` files, `main_pages.json`, `module.json5`, and `color.json`.
- **Review Date**: 2026-07-02
- **Total Scenarios**: 42
- **Results**: **36 PASS | 6 PARTIAL | 0 FAIL | 0 UNABLE TO VERIFY**

---

## Scenario Coverage Summary

| # | Scenario (spec id) | Verdict | Key Gaps |
|---|--------------------|---------|----------|
| 1 | add-missing | PASS | — |
| 2 | back-navigation | PASS | — (secondary-page round-trip works; cross-tab state see #3) |
| 3 | bottom-nav | PARTIAL | Tab switches use `router.pushUrl` → each switch pushes a **new** page instance; page-local browse state (selected category, search query, scroll position) is **not preserved** across tab switches (scenario 4). Shared pantry/favorites/theme do survive. |
| 4 | category-filter | PASS | — |
| 5 | cookable-ready | PASS | — |
| 6 | detail-ingredients | PASS | — |
| 7 | detail-overview | PASS | — |
| 8 | detail-steps | PASS | — |
| 9 | discover-layout | PASS | — |
| 10 | empty-pantry-hint | PASS | — |
| 11 | favorite-order | PASS | — |
| 12 | favorite-recipe | PARTIAL | On Home/Search **list cards**, tapping the heart likely also triggers the parent card's `onClick` (event bubbling) and opens the detail page — the heart toggles, but with unwanted navigation. Detail-page heart (scenario 3) is unaffected. |
| 13 | ingredient-categories | PARTIAL | All 7 categories + items present, but **Spices & Herbs and Condiments & Oils are displayed in reversed order** vs the spec (spec requires Spices & Herbs before Condiments & Oils; code shows Condiments & Oils first). |
| 14 | ingredient-normalize | PASS | — |
| 15 | loading-error-state | PARTIAL | **Home skeleton placeholder (scenario 2) and Home error/retry state (scenario 3) are not implemented.** Detail/Search/Favorites/Pantry loading + empty states present. |
| 16 | missing-ingredients | PASS | — |
| 17 | offline-recipes | PASS | — |
| 18 | onboard-persist | PASS | — |
| 19 | onboarding | PASS | — |
| 20 | optional-ingredient | PASS | — |
| 21 | pantry-clear | PASS | — |
| 22 | pantry-layout | PASS | — |
| 23 | pantry-manual-add | PASS | — |
| 24 | pantry-quick-add | PASS | — |
| 25 | pantry-remove | PASS | — |
| 26 | recipe-card | PARTIAL | Heart button sits inside a card whose root has `.onClick(onCardTap)`; without `hitTestBehavior` the tap **bubbles** to the card, so scenarios 3 (tap heart) and 4 (tap card) are not independent — tapping the heart also navigates to detail. |
| 27 | recipe-match-count | PASS | — |
| 28 | saved-empty | PASS | — |
| 29 | saved-list | PASS | — |
| 30 | search-category | PASS | — |
| 31 | search-cookable | PASS | — |
| 32 | search-empty | PASS | — |
| 33 | search-layout | PASS | — |
| 34 | search-text | PASS | — |
| 35 | settings-clear-pantry | PASS | — |
| 36 | settings-overview | PASS | — |
| 37 | sort-best-match | PASS | — |
| 38 | sort-fewest-missing | PASS | — |
| 39 | sort-quickest | PASS | — |
| 40 | theme-persist | PASS | — |
| 41 | theme-switch | PASS | — |
| 42 | unfavorite | PARTIAL | Same heart-bubbling issue as #12/#26 on the Saved list card; detail-page unfavorite (scenario 2) unaffected. |

---

## Detailed Scenario Reviews

### Scenario 1: add-missing (可一键补齐缺少食材)

**Description**: When a recipe has missing essential ingredients, the detail page offers a one-tap "Add missing to pantry" button that adds all missing essentials and flips status to cookable.

**Verdict**: PASS

**Evidence**:
- `viewmodel/RecipeDetailViewModel.ets:117-139` — `addMissingToPantry()` iterates `match.missing` (essentials only), dedups against the pantry via `normalizeEq`/`ingredientIsAvailable`, and reassigns `pantry.items = pantry.items.concat(additions)` so the `@Track items` dependency fires app-wide.
- `pages/RecipeDetailPage.ets:226-304` — `cookStatusSection()` renders the full-width `WccPrimaryButton("Add missing to pantry")` *only* in the `else` (missing) branch; the "You're all set!" branch omits it.
- `model/RecipeModel.ets:339-366` — `matchRecipeAgainst` populates `missing` with essential+unsatisfied only; optionals go to `missingOptional` and are excluded.
- After add → `rebuild()` → `match.missing` empty → `status = READY` → banner switches to "You're all set!" and the button/missing list disappear.

**Gaps**: none material. (Minor: added items are stored under their original seed name rather than re-normalized; because seed names are already canonical and matching/dedup both re-normalize, this has no functional effect.)

---

### Scenario 2: back-navigation (返回导航)

**Description**: Detail/Settings secondary pages provide a top back button (and honor system back) returning to the prior page, preserving the prior page's data state.

**Verdict**: PASS

**Evidence**:
- `pages/RecipeDetailPage.ets:90-92, 130-162` — pinned back circle → `router.back()`.
- `pages/SettingsPage.ets:64-66, 238` — `WccTopBar` back → `router.back()`.
- State preservation on secondary round-trips: Home/Search/Favorites each hold their `@State vm`; `router.pushUrl(Detail)` keeps the source instance on the stack, so `router.back()` reveals the **same** instance with its `selectedCategory`/`query` intact, and `onPageShow()` (`HomePage.ets:56-58`, `SearchPage.ets:53-55`, `FavoritesPage.ets:54-56`) recomputes derived views without touching the inputs.
- System back is satisfied implicitly: HarmonyOS routes the system back gesture/key through the router back stack, equivalent to `router.back()`.

**Gaps**: none for secondary-page navigation. (Cross-*tab* state preservation is assessed under Scenario 3.)

---

### Scenario 3: bottom-nav (底部导航)

**Description**: A bottom bar with Discover/Search/Pantry/Saved; the current tab is highlighted; tapping switches pages; each page's browse state is independently preserved.

**Verdict**: PARTIAL

**Evidence**:
- `components/WccBottomBar.ets:47-52, 76-103` — four tabs in the correct order (Discover🍽, Search🔍, Pantry🍳, Saved🔖); selected item gets `WCC_PRIMARY_CONTAINER` bg + expanded label, idle items show icon only — matches highlight semantics.
- `pages/HomePage.ets:83-102`, `SearchPage.ets:78-95`, `PantryPage.ets:78-95`, `FavoritesPage.ets:79-96` — each page passes its `currentTab` and routes taps through `goToTab`.
- Display/order/highlight/switch (scenarios 1–3): fully correct. Hidden on Detail/Settings/Onboarding (those pages don't render `WccBottomBar`).

**Gaps**:
- **Scenario 4 (independent state preservation across tabs) is not satisfied.** Every `goToTab` uses `router.pushUrl` (e.g. `HomePage.ets:91 this.goToSearch()` → `router.pushUrl('pages/SearchPage')`). `pushUrl` pushes a **new** page instance onto the stack rather than switching to an existing tab. Consequences:
  1. Switching Discover→Search→Discover creates a *fresh* `HomePage` whose `HomeViewModel` constructor resets `selectedCategory = null` — the previously chosen category filter is **lost**, not restored (spec scenario 4 requires it restored).
  2. The same applies to the Search query and to list scroll positions — a new instance starts at the top with default filters.
  3. The back stack grows with each tab hop; system-back walks through prior (stale) tab instances.
- Shared, AppStorage-backed state (pantry, favorites, theme, onboarding) **does** survive, so match counts / heart states / pantry edits remain consistent after this commit's changes.

**Suggestions**:
- Adopt a single `Tabs` host (or `router.replaceUrl` + a retained page-cache) for the four top-level pages so tab switching reuses live instances and preserves each page's `@State` (category, query, scroll). This is the canonical HarmonyOS pattern for a bottom-nav shell and directly satisfies scenario 4.

---

### Scenario 4: category-filter (首页分类筛选)

**Verdict**: PASS
**Evidence**: `HomeViewModel.ets:113-116` (`selectCategory`), `:93-106` (filter by `category.value` then sort by ratio desc/title asc); `HomePage.ets:248-279` (All + 6 category chips, single-select via `isCategorySelected`). Default `selectedCategory = null` = "All" selected. `cookNow` is computed independently of the category filter (satisfies scenario 4 step 2).

---

### Scenario 5: cookable-ready (可做状态Ready)

**Verdict**: PASS
**Evidence**: `RecipeModel.ets:293-304` (`status = READY` when `essentialCount === 0 || missing.length === 0`); `RecipeDetailPage.ets:230-253` ("🎉 You're all set! / You have everything to make this."); `MetaStat.ets:35-46` (CookStatusPill "Ready to cook"); `HomeViewModel.ets:88-91` (`cookNow` includes cookable recipes → home carousel). Real-time refresh via shared pantry + `onPageShow` refresh (this commit).

---

### Scenario 6: detail-ingredients (Recipe Detail 食材清单)

**Verdict**: PASS
**Evidence**: `RecipeDetailPage.ets:446` (`SectionHeader("Ingredients", actionText=ingredients.length)` — count includes essential + optional); `:306-347` `ingredientRow` — circle check when `have`, "Missing" when essential+!have, "Optional" when `!essential`; `RecipeDetailViewModel.ets:157-160` builds `IngredientStatus` via `ingredientIsAvailable`. `RecipeIngredient.display` (`RecipeModel.ets:29-41`) renders "qty unit Name".

---

### Scenario 7: detail-overview (Recipe Detail 基础信息)

**Verdict**: PASS
**Evidence**: `RecipeDetailPage.ets:165-180` (hero), `:392-511` (category/title/description/tags/4-stat row: Time·Serves·Level·Kcal), `:129-162` (pinned back + favorite), `:513-527` (not-found empty state). `Recipe.computeTimeLabel` (`RecipeModel.ets:184-191`) handles `<60min`→"N min", `≥60`→"Nh"/"Nh Mm".

---

### Scenario 8: detail-steps (Recipe Detail 步骤进度)

**Verdict**: PASS
**Evidence**: `RecipeDetailPage.ets:459-498` ("Steps" + `completed/total` + progress bar + `stepRow`); `:112-125` `toggleStep` reassigns `completedSteps` so `@State` observes the change; `:78-86` resets `completedSteps = []` on entry (not persisted — scenario 5). Done rows show ✓ + strikethrough (`:351-389`).

---

### Scenario 9: discover-layout (Discover 首页基础布局)

**Verdict**: PASS
**Evidence**: `HomePage.ets:300-369` renders the full stack: header (greeting + "What can I cook?" + settings gear), search pill, pantry summary card, Ready-to-cook carousel / empty-pantry prompt, "Browse recipes" + category chips, recipe list, bottom bar. Greeting computed by hour (`HomeViewModel.ets:127-139`) incl. afternoon/evening/late variants.

---

### Scenario 10: empty-pantry-hint (空食材库首页提示)

**Verdict**: PASS
**Evidence**: `HomePage.ets:317-328` — `cookNowPrompt` shown when `cookNow.length === 0 && pantry.count === 0`, with the exact title/body copy and `onClick → goToPantry`; disappears once the pantry is non-empty (condition guarded on `pantry.count === 0`).

---

### Scenario 11: favorite-order (收藏顺序)

**Verdict**: PASS
**Evidence**: `FavoritesModel.ets:45-57` — `setFavorite(true)` prepends (`unshift`) after removing any prior entry, so newest-first ordering holds; re-saving bubbles to top (scenario 4). `FavoritesViewModel.ets:92-98` renders in `favorites.ids` order. This commit's shared-state ownership makes the ordering consistent across screens.

---

### Scenario 12: favorite-recipe (收藏菜谱)

**Description**: Tap the heart on a card (Home/Search/Saved) or detail header to favorite; state syncs app-wide.

**Verdict**: PARTIAL

**Evidence**:
- Heart toggle + app-wide sync are correct: `RecipeCard` → `onToggleFavorite` → `vm.toggleFavorite` → `getSharedFavorites().setFavorite(...)` (`HomeViewModel.ets:119-124`, `SearchViewModel.ets:130-135`, `FavoritesViewModel.ets:64-69`, `RecipeDetailViewModel.ets:99-109`).
- Detail-page heart (`RecipeDetailPage.ets:152-157`) sits in the `topControls` overlay with no card-tap ancestor, so scenario 3 (favorite from detail) works cleanly.

**Gaps**:
- On **Home and Search list cards**, `RecipeCard` root Column carries `.onClick(() => this.onCardTap())` (`RecipeCard.ets:124`) and the `FavoriteButton` is a child Stack with its own `.onClick(onToggle)` (`FavoriteButton.ets:33`). ArkUI click events bubble through the component tree unless blocked; nothing here calls `hitTestBehavior(HitTestMode.Block)`. So tapping the heart on a list card both toggles the favorite **and** fires the card tap → navigates to detail. Scenario 1 (Home card) and scenario 2 (Search card) thus show the heart change *after* an unexpected detail-page push rather than in place.

**Suggestions**:
- On `FavoriteButton` (or its overlay `Row` in `RecipeCard.ets:54-65`), add `.hitTestBehavior(HitTestMode.Block)` so the tap is consumed by the heart and does not propagate to the card. (See Cross-Cutting §Event Propagation.)

---

### Scenario 13: ingredient-categories (食材分类展示)

**Verdict**: PARTIAL

**Evidence**:
- `model/PantryCatalog.ets:96-114` defines all 7 categories with the correct items (Produce…Condiments…Spices contents match the spec 1:1); `PantryViewModel.ets:133-150` groups by category in `INGREDIENT_CATEGORIES` order and drops empty groups; `PantryPage.ets:244-290` renders "{emoji} {label}" + suggestion chips; already-added items are filtered out (`PantryViewModel.ets:140-144`).

**Gaps**:
- **Category display order is wrong for the last two groups.** `INGREDIENT_CATEGORIES` (`PantryCatalog.ets:40-48`) orders them …Pantry Staples, **Condiments & Oils, Spices & Herbs**. The spec (scenario 1 steps 2.6/2.7 and its deviation note "Spices & Herbs 排在 Condiments & Oils 之前") requires **Spices & Herbs before Condiments & Oils**. The code reverses these two.

**Suggestions**:
- Swap the two entries in `INGREDIENT_CATEGORIES` so `SPICES` precedes `CONDIMENTS`.

---

### Scenario 14: ingredient-normalize (食材归一化与同义词匹配)

**Verdict**: PASS
**Evidence**: `RecipeModel.ets:236-243` `normalizeName` (lowercase/trim/strip-punct/collapse-spaces + CANONICAL map incl. eggs→egg, scallion/spring onion→green onion, chicken breast→chicken, ground beef→beef); `:246-268` `namesMatch` uses whole-word `Set` containment so `rice` satisfies `basmati rice` but `egg` does **not** satisfy `eggplant`. Dedup-on-write in `PantryViewModel.addRaw` (`:112-125`).

---

### Scenario 15: loading-error-state (错误与加载状态)

**Verdict**: PARTIAL

**Evidence**:
- Detail not-found: `RecipeDetailViewModel.ets:145-153` sets `notFound`; `RecipeDetailPage.ets:513-527, 531` renders `EmptyState("Recipe not found"…)`. ✓ (scenario 4)
- Favorites empty + loading guard: `FavoritesPage.ets:165` (`!loading && empty`). ✓
- Search empty result: `SearchPage.ets:236-239`. ✓
- Pantry empty subtitle/catalogue switch: `PantryPage.ets:100-111`. ✓
- Startup: `module.json5` declares `startWindowIcon`/`startWindowBackground`; `Index` routes immediately. ✓ (scenario 1, minimal)

**Gaps**:
- **Home skeleton placeholder (scenario 2) is absent.** `HomeViewModel` builds seed data synchronously in its constructor (`HomeViewModel.ets:56-68`); `HomePage` has no loading/skeleton branch — it renders content directly. The spec requires a shimmer skeleton until data is ready.
- **Home error + retry state (scenario 3) is absent.** There is no "Something went wrong / Try again" path on Home. (Practical risk is low because bundled seed loading cannot throw, but the spec explicitly requires the state.)

**Suggestions**:
- Add a transient `loading` flag to `HomeViewModel` and a skeleton `RecipeCard` placeholder in `HomePage.build`, plus an `error` branch with an EmptyState + "Try again" `WccPrimaryButton` that re-invokes the build — even if today's seed path is infallible, this satisfies the spec and future-proofs a real data layer.

---

### Scenario 16: missing-ingredients (缺少食材状态 Missing N)

**Verdict**: PASS
**Evidence**: `RecipeDetailPage.ets:254-303` renders `CookStatusPill` + "You're missing N ingredient(s)" (singular/plural at `:267`) + missing-name pills (capitalized, in recipe order via `match.missing`) + the Add-missing CTA. Pill form switches by status: ALMOST→"Missing N", EXPLORE→"X/Y" (`MetaStat.ets:47-71`, `RecipeModel.ets:293-299`). Hidden when cookable.

---

### Scenario 17: offline-recipes (离线菜谱数据初始化)

**Verdict**: PASS
**Evidence**: `model/RecipeSeedData.ets:45-361` bundles 19 recipes (incl. 5-Minute Mug Cake, Banana Oat Pancakes, Chicken Fried Rice) constructed synchronously via `buildSeedRecipes()`; no network/account/import. All pages read the same seed data; fully offline per REQ-003.

---

### Scenario 18: onboard-persist (引导完成状态持久化)

**Verdict**: PASS
**Evidence**: This commit's `pages/Index.ets:11` adds `PersistentStorage.persistProp('onboardingComplete', false)` before the read; `OnboardingViewModel.ets:49-54` `complete()` writes `AppStorage.setOrCreate + PersistentStorage.persistProp(..., true)`. Cold start reads the persisted flag and routes to Home vs Onboarding accordingly. Default false → onboarding shows on first install.

---

### Scenario 19: onboarding (引导页)

**Verdict**: PASS
**Evidence**: `pages/OnboardingPage.ets` — Skip pill (`:120-128`), 3-page `Swiper` (`:134-146`) with dot indicators (`:149-156`, selected 24vp / idle 8vp), CTA label switches Next→"Start cooking" on last page (`:160-163`). Skip/Start both call `complete → goToHome` (`:46-57`). Page titles match ("Cook with what you have", "Instant recipe matches", "Build your cookbook").

---

### Scenario 20: optional-ingredient (可选食材不影响可做状态)

**Verdict**: PASS
**Evidence**: `RecipeModel.ets:352-358, 293` — optionals never enter `missing`; `isCookable` true once `missing` (essentials) is empty. Match denominator = `essentialIngredients.length` (`:363`). Detail row shows "Optional" regardless of have/not-have, with a check only when owned (`RecipeDetailPage.ets:335-343`). Verified against `chicken-fried-rice` (olive oil optional) in `RecipeSeedData.ets:121`.

---

### Scenario 21: pantry-clear (Pantry 清空)

**Verdict**: PASS
**Evidence**: `PantryViewModel.clearAll()` (`:99-105`) reassigns `pantry.items = []`; `PantryPage.ets:191-195` wires "Clear all" (only rendered when `count > 0` via `:301`). Cross-page refresh via shared pantry + `onPageShow` (this commit). Catalogue title flips to "Add ingredients" when empty (`:109-111`).

---

### Scenario 22: pantry-layout (Pantry 页面基础布局)

**Verdict**: PASS
**Evidence**: `PantryPage.ets:292-334` — "My pantry" title, count-driven subtitle (`:100-106`), manual-add pill, "In your kitchen" + Clear all (hidden when empty), quick-add groups, bottom bar. Empty-state adjustments match scenario 3.

---

### Scenario 23: pantry-manual-add (Pantry 手动添加食材)

**Verdict**: PASS
**Evidence**: `PantryViewModel.addManual()` (`:73-80`) trims, guards blank, delegates to `addRaw` which normalizes + dedups (`:112-125`) and clears input; bound to both the "+" button and `onSubmit` (`PantryPage.ets:157-158, 177`). Whitespace-only input is rejected (scenario 3).

---

### Scenario 24: pantry-quick-add (Pantry 快速添加食材)

**Verdict**: PASS
**Evidence**: `PantryViewModel.addCatalog → addRaw` (`:83-85`); `PantryPage.ets:268-290` suggestion chip `onClick → addCatalog`; after add, `rebuild()` filters the now-present normalized name out of `suggestionGroups` (`:140-144`) so it disappears and cannot be re-added (dedup).

---

### Scenario 25: pantry-remove (Pantry 移除单个食材)

**Verdict**: PASS
**Evidence**: `PantryViewModel.remove()` (`:88-96`); `PantryPage.ets:215-235` pantry chip `onClick → remove` (whole chip clickable). Removed item reappears in suggestions (no longer in `present`). Empty-pantry layout adjustments apply when the last item is removed.

---

### Scenario 26: recipe-card (首页菜谱卡片)

**Verdict**: PARTIAL

**Evidence**:
- Full card content present: `RecipeCard.ets:40-125` — gradient+emoji image, `CookStatusPill`, `FavoriteButton`, category line, title, description, time/difficulty/kcal meta. Three-state pill (`MetaStat.ets:29-72`). Compact carousel variant (`CompactRecipeCard.ets`). Card tap → `onCardTap` → detail.

**Gaps**:
- **Heart and card taps are not independent (scenarios 3 vs 4).** The card's root Column has `.onClick(onCardTap)` (`RecipeCard.ets:124`) and the `FavoriteButton` child has its own `.onClick(onToggle)` (`FavoriteButton.ets:33`) with no `hitTestBehavior` to stop propagation. In ArkUI the click bubbles to the parent, so tapping the heart also opens detail — contradicting scenario 4 step 2 ("不含收藏按钮") and scenario 3 (heart should toggle without navigating).

**Suggestions**:
- Add `.hitTestBehavior(HitTestMode.Block)` to the `FavoriteButton` root (or the overlay `Row` at `RecipeCard.ets:54`) so the heart consumes its own tap.

---

### Scenario 27: recipe-match-count (菜谱匹配计数)

**Verdict**: PASS
**Evidence**: `CookMatch.haveCount/essentialCount` (`RecipeModel.ets:276-309`); pill shows `X/Y` only in EXPLORE, "Missing N" in ALMOST, "Ready to cook" in READY (`MetaStat.ets:35-71`); denominator excludes optionals; refreshes via shared pantry + `onPageShow`.

---

### Scenario 28: saved-empty (收藏页空态)

**Verdict**: PASS
**Evidence**: `FavoritesPage.ets:100-116` — `EmptyState(🔖, "No saved recipes yet", message, actionLabel="Browse recipes", onAction→goToDiscover)`; shown only when `!loading && empty` (`:165`), so not flashed during load (scenario 4).

---

### Scenario 29: saved-list (收藏列表)

**Verdict**: PASS
**Evidence**: `FavoritesPage.ets:118-160` — "Saved" title + "N recipe(s) in your cookbook" subtitle (`FavoritesViewModel.ets:103-104`), scrollable card list, card→detail, no filters/sort. Live add/remove + match-count refresh via shared state + `onPageShow`.

---

### Scenario 30: search-category (搜索页分类筛选)

**Verdict**: PASS
**Evidence**: `SearchViewModel.onCategorySelected` (`:112-115`) + filter at `:171-177`; combines with text/cookable/sort (independent pipeline). `SearchPage.ets:108-134` chips, single-select, default All. Independent from Home's category state.

---

### Scenario 31: search-cookable (搜索页可做筛选)

**Verdict**: PASS
**Evidence**: `SearchViewModel.onCookableToggle` (`:118-121`) + filter `match.isCookable` (`:180-182`); empty pantry ⇒ no cookables ⇒ empty result set ⇒ search empty state. Real-time via shared pantry.

---

### Scenario 32: search-empty (搜索页空结果)

**Verdict**: PASS
**Evidence**: `SearchPage.ets:172-185, 236-239` — `EmptyState(🔍, "No recipes found", "Try a different ingredient or clear your filters.")`; no action button (distinct from Favorites); disappears when results non-empty. Synchronous build means no false empty state during load.

---

### Scenario 33: search-layout (搜索页布局)

**Verdict**: PASS
**Evidence**: `SearchPage.ets:208-255` — "Search" title, `WccSearchField`, category chips, Cookable toggle + sort row (Best match/Quickest/Fewest missing, default Best match, Cookable off — `SearchViewModel.ets:97-102`), result list. All five sections present in order.

---

### Scenario 34: search-text (搜索页文本搜索)

**Verdict**: PASS
**Evidence**: `SearchViewModel.onQueryChange → rebuild` (`:106-109`); text filter lowercases+trims query and matches title | category.label | tags | ingredient names (`:156-169`); empty/whitespace query ⇒ no text filter; clear button (`WccSearchField.ets:71-87`) calls `onValueChange('')`.

---

### Scenario 35: settings-clear-pantry (Settings 清空食材库)

**Verdict**: PASS
**Evidence**: `SettingsPage.onClearPantry` (`:89-92`) → `vm.clearPantry()` (`SettingsViewModel.ets:66-68`, resets shared pantry) → `router.back()`; no confirm dialog. Home/Search/Favorites/Detail recompute on their next `onPageShow` (this commit). Favorites/theme/seed data untouched.

---

### Scenario 36: settings-overview (Settings 页面基础信息)

**Verdict**: PASS
**Evidence**: `SettingsPage.ets:235-274` — `WccTopBar("Settings")` + back; APPEARANCE (Theme + 3 chips: Match system/Light/Dark), DATA (Clear pantry + subtitle), ABOUT (App=WhatCanICook, Version=1.0.0, Built with=Jetpack Compose). Selected theme reflects current (`SettingsViewModel.isThemeSelected`, `:47-49`).

---

### Scenario 37: sort-best-match (搜索页 Best match 排序)

**Verdict**: PASS
**Evidence**: `SearchViewModel.ets:200-205` — RELEVANCE ⇒ ratio desc, then title asc (`localeCompare`); applied after text/category/cookable filtering (`:184-207`).

---

### Scenario 38: sort-fewest-missing (搜索页 Fewest missing 排序)

**Verdict**: PASS
**Evidence**: `SearchViewModel.ets:191-198` — FEWEST_MISSING ⇒ `missing.length` asc, then ratio desc; essentials-only count.

---

### Scenario 39: sort-quickest (搜索页 Quickest 排序)

**Verdict**: PASS
**Evidence**: `SearchViewModel.ets:188-189` — QUICKEST ⇒ `timeMinutes` asc; applied after filtering; selection switches immediately (`onSortSelected`).

---

### Scenario 40: theme-persist (主题持久化)

**Verdict**: PASS
**Evidence**: `SettingsViewModel.setThemeMode` writes `AppStorage.setOrCreate('themeMode', id)` (`:56-59`); `EntryAbility.ets:35` `persistProp('themeMode','SYSTEM')` + `:41-53` `applyPersistedTheme` on launch; `themeModeFromId` falls back to SYSTEM on null/unrecognized (`ThemeMode.ets:43-48`). Overwrite on re-select.

---

### Scenario 41: theme-switch (主题切换)

**Verdict**: PASS
**Evidence**: `SettingsPage.onThemeSelected` (`:69-72`) ⇒ `setThemeMode` + `applyColorMode` via `getApplicationContext().setColorMode(...)` (`:75-86`); Light/Dark/Match-system map to `COLOR_MODE_LIGHT/DARK/NOT_SET`. Live recolor without page rebuild; selection state preserved.

---

### Scenario 42: unfavorite (取消收藏)

**Verdict**: PARTIAL

**Evidence**:
- Toggle + sync correct everywhere (same shared-store path as Scenario 12); last unfavorite ⇒ Favorites empty state (`FavoritesPage.ets:165`). Detail-page unfavorite (scenario 2) works in place.

**Gaps**:
- On the **Saved list card**, the same heart-bubbling issue as #12/#26: tapping the heart also fires the card tap → opens detail (scenario 1). The unfavorite still takes effect (visible after returning), but the immediate in-place heart revert is masked by the navigation.

**Suggestions**: same `hitTestBehavior(HitTestMode.Block)` fix on `FavoriteButton`.

---

## Cross-Cutting Issues

### Event Propagation (heart vs. card tap) — **highest impact**
`FavoriteButton` (`FavoriteButton.ets:33`) registers `.onClick(onToggle)`, but it is embedded inside `RecipeCard` whose root has `.onClick(onCardTap)` (`RecipeCard.ets:124`) and inside `CompactRecipeCard` similarly. ArkUI click events bubble unless blocked, and no `hitTestBehavior` is set. **Net effect**: on Home/Search/Saved list cards, a heart tap both toggles favorite *and* navigates to detail. This single defect touches scenarios 12, 26, and 42. **Fix**: add `.hitTestBehavior(HitTestMode.Block)` to the `FavoriteButton` root Stack (and/or the overlay `Row`). Low-risk, one-line per site.

### Navigation Completeness
All 8 pages are registered in `main_pages.json` and reachable: Index→(Onboarding|Home); Home/Search/Pantry/Favorites via `WccBottomBar`; Detail via any card; Settings via Home gear; back via `router.back()`/system back. No dead links. **Caveat**: tab switching uses `router.pushUrl` (new instance each hop) rather than a `Tabs` host — see Scenario 3.

### State Management Correctness
- Shared app state (pantry, favorites, theme, onboarding) is correctly centralized in AppStorage (`getSharedPantry`, `getSharedFavorites`) with `PersistentStorage` mirroring for theme/onboarding — this commit solidified that. Cross-screen consistency for match counts, hearts, and pantry edits works.
- All `@Observed`/`@Track` mutations reassign arrays (never in-place `push`/`splice` without reassign) so observers fire — verified in `PantryViewModel`, `RecipeDetailViewModel.addMissingToPantry`, `RecipeDetailPage.toggleStep`.
- **Gap**: page-*local* browse state (Home category, Search query, scroll) is not retained across tab switches because each tab hop creates a fresh page instance (Scenario 3). Within a page's own lifecycle (secondary round-trips) it is retained.

### API / Version Compatibility
Only stable, broadly-available APIs are used: `@ohos.router` (`pushUrl`/`replaceUrl`/`back`/`getParams`), `Swiper`/`SwiperController`, `TextInput`, `List`/`Scroll`/`Flex`, `linearGradient`, `PersistentStorage`/`AppStorage`, `ConfigurationConstant.setColorMode`. No deprecated or version-gated calls observed. No `requestPermissions` needed (offline-only; AppStorage/PersistentStorage are app-private).

### Resource Completeness
- Colors `$r('app.color.brand_primary' #fff2622e)`, `brand_surface (#fffffbf6)`, `white (#ffffffff)` are all defined in `entry/src/main/resources/base/element/color.json`. ✓
- All UI copy is inline string literals (mirroring the Android Compose source which used Kotlin literals, not `@StringRes`) — consistent and complete; no dangling `$r` string references for screen copy.
- Emoji glyphs stand in for Material vector icons (hearts, search, back chevron, category/food icons) — intentional per the offline port notes; visually consistent app-wide.
- `module.json5` startWindow resources and ability strings resolve. ✓

### Permission Coverage
No scenarios require restricted permissions (no network, no location, no storage beyond app-private). `module.json5` declares none, which is correct.

---

## Final Assessment

**Overall Verdict**: **PASS WITH ISSUES**

The implementation is substantially complete and faithful to the Android source. 36 of 42 scenarios fully pass, including all core flows: offline recipe data, the cook-match engine (normalize/synonym/whole-word), detail page (status banner, ingredients, steps, add-missing), pantry CRUD, search (text/category/cookable/sort), favorites ordering & sync, onboarding + persistence, theme switch + persistence, and settings. This commit specifically hardens cross-screen consistency (shared pantry owner + `onPageShow` refresh + onboarding persistence), which is correctly implemented.

**Fully covered scenarios (36)**: add-missing, back-navigation, category-filter, cookable-ready, detail-ingredients, detail-overview, detail-steps, discover-layout, empty-pantry-hint, favorite-order, ingredient-normalize, missing-ingredients, offline-recipes, onboard-persist, onboarding, optional-ingredient, pantry-clear, pantry-layout, pantry-manual-add, pantry-quick-add, pantry-remove, recipe-match-count, saved-empty, saved-list, search-category, search-cookable, search-empty, search-layout, search-text, settings-clear-pantry, settings-overview, sort-best-match, sort-fewest-missing, sort-quickest, theme-persist, theme-switch.

**Partially covered scenarios (6)** — ranked by user impact:

1. **recipe-card / favorite-recipe / unfavorite (one root cause)** — heart tap on list cards bubbles to the card and opens detail unexpectedly. Affects the most-used interaction (tapping hearts while browsing). **Fix is trivial** (`hitTestBehavior`).
2. **bottom-nav** — tab switches create fresh page instances, so per-tab browse state (category/query/scroll) is lost on every tab hop; only AppStorage-backed state survives. Noticeable for users who filter then switch tabs.
3. **loading-error-state** — Home skeleton + error/retry states missing (low practical risk today since seed load can't fail, but spec-required).
4. **ingredient-categories** — last two category groups (Spices & Herbs vs Condiments & Oils) displayed in reversed order; cosmetic.

**Not covered scenarios (0)**: none.

**Recommended Priority Fixes**:
1. Add `.hitTestBehavior(HitTestMode.Block)` to `FavoriteButton` (fixes scenarios 12, 26, 42 in one change).
2. Replace the `router.pushUrl`-based bottom-nav with a `Tabs` host (or retained-page pattern) so tab switching preserves each page's `@State` (fixes scenario 3.4).
3. Swap `SPICES`/`CONDIMENTS` order in `INGREDIENT_CATEGORIES` (fixes scenario 13).
4. Add Home `loading`/`error` UI branches with skeleton + retry (fixes scenario 15.2/15.3).
