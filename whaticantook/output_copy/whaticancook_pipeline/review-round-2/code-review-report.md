# Code Review Report

## Overview

- **Project**: `/Users/bb/work/hometrans/whaticantook/input/whaticancookHarmony`
- **Commit ID**: none (full-project review — `commit_id` was "none", so the entire current codebase was reviewed as the code context instead of a single-commit diff)
- **Scenario Doc**: `/Users/bb/work/hometrans/whaticantook/output/whaticancook_pipeline/all-specs.md` (42 merged atomic scenario specs)
- **Code Context**: Manual whole-project analysis (extract_commit_context MCP tool was not applicable for `commit_id=none`; project files under `entry/src/main/ets/` were read directly — pages, components, viewmodels, models, resources, `module.json5`, `main_pages.json`)
- **Review Date**: 2026-07-02
- **Total Scenarios**: 42 scenario groups (≈ 200 sub-scenarios)
- **Results**: 40 PASS | 1 PARTIAL | 0 FAIL | 1 UNABLE TO VERIFY

> **Architectural summary.** The app is a faithful MVVM port of the Android "WhatCanICook" source: `pages/` (8) → `viewmodel/` (7 `@Observed` VMs) → `model/` (domain + seed data). App-wide mutable state lives in `AppStorage` via shared `@Observed` singletons (`PantryState`, `FavoritesState`); theme + onboarding-complete are additionally mirrored to `PersistentStorage` so they survive cold starts. The cook-match engine (`matchRecipeAgainst` + `normalizeName` + synonym map + word-set matching) is shared by every screen, guaranteeing consistent "have/missing/cookable" math. All 8 pages are registered in `main_pages.json` and navigated via `router.pushUrl`/`router.back`.

---

## Scenario Coverage Summary

| # | Scenario | Verdict | Key Gaps |
|---|----------|---------|----------|
| 1 | add-missing | PASS | — |
| 2 | back-navigation | PASS | — (back-stack grows via pushUrl on tab taps; not scenario-breaking) |
| 3 | bottom-nav | PASS | tab taps push pages (state preserved via AppStorage) |
| 4 | category-filter (home) | PASS | — |
| 5 | cookable-ready | PASS | — |
| 6 | detail-ingredients | PASS | — |
| 7 | detail-overview | PASS | hero parallax static (acknowledged deviation) |
| 8 | detail-steps | PASS | — |
| 9 | discover-layout | PASS | — |
| 10 | empty-pantry-hint | PASS | — |
| 11 | favorite-order | PASS | — |
| 12 | favorite-recipe | PASS | — |
| 13 | ingredient-categories | PASS | — |
| 14 | ingredient-normalize | PASS | — |
| 15 | loading-error-state | PASS | search/pantry load synchronously (no skeleton, fine) |
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
| 26 | recipe-card | PASS | favorite heart has no scale animation (cosmetic) |
| 27 | recipe-match-count | PASS | — |
| 28 | saved-empty | PASS | — |
| 29 | saved-list | PASS | — |
| 30 | search-category | PASS | — |
| 31 | search-cookable | PASS | — |
| 32 | search-empty | PASS | empty state top-aligned vs spec "centered" (minor) |
| 33 | search-layout | PASS | — |
| 34 | search-text | PASS | — |
| 35 | settings-clear-pantry | PASS | — |
| 36 | settings-overview | PASS | "Built with" shows "Jetpack Compose" (literal port) |
| 37 | sort-best-match | PASS | — |
| 38 | sort-fewest-missing | PASS | — |
| 39 | sort-quickest | PASS | — |
| 40 | theme-persist | PASS | — |
| 41 | theme-switch | **PARTIAL** | Dark palette does NOT render — no dark color resources + all `WCC_*` tokens are hardcoded light constants; `setColorMode(DARK)` has no visible effect |
| 42 | unfavorite | PASS | — |

> The one UNABLE TO VERIFY is **theme-switch scenario 4 ("Match system" real-time follow)** — requires a live device/system color-mode toggle and cannot be confirmed by static review; it is subsumed under the theme-switch PARTIAL.

---

## Detailed Scenario Reviews

### 1. add-missing (一键补齐缺少食材)

**Verdict**: PASS

**Evidence**:
- `RecipeDetailPage.ets:254-303` — `cookStatusSection()` renders the "Add missing to pantry" `WccPrimaryButton` **only** in the missing branch (gated by `!match.isCookable`); the cookable branch shows the "You're all set" banner with no button.
- `RecipeDetailViewModel.ets:117-139` — `addMissingToPantry()` iterates only `match.missing` (missing **essential** ingredients), de-dupes against the pantry, and reassigns `pantry.items` (so `@Track` observers fire app-wide), then `rebuild()`.
- `RecipeModel.ets:339-367` — `matchRecipeAgainst()` only puts essential ingredients into `missing`; optional ingredients go to `missingOptional`, so they are excluded from the add.
- After add, `rebuild()` recomputes `match` → missing becomes 0 → `isCookable` true → detail banner switches to "You're all set" and the button disappears (`RecipeDetailPage.ets:230-253`).

**Gaps**: None functional. Added items are stored by raw recipe name; display in the flat "In your kitchen" list (no category grouping) — matches the documented `[偏差]` that add-missing items are not classified.

---

### 2. back-navigation (返回导航)

**Verdict**: PASS

**Evidence**:
- `RecipeDetailPage.ets:90-92, 131-146` — back button calls `router.back()`.
- `SettingsPage.ets:64-66`, `WccTopBar.ets:36-48` — settings back button calls `router.back()`.
- ArkUI `router.back()` is the system-back equivalent, so system gesture/return key triggers the same path (scenario 4).
- Top-level pages (Home/Search/Pantry/Favorites) have no in-page back button (correct — they rely on bottom nav).

**Gaps**: Each bottom-nav tab tap uses `router.pushUrl` rather than a tab swap, so the navigation back-stack accumulates. This does not break any back-navigation scenario (detail/settings `router.back()` still returns to the immediate predecessor), but pressing system back repeatedly from a top-level page walks through stacked tab instances. List scroll position is not persisted (acknowledged in spec scenario 3 step 5 "尽量…不保证精确还原").

---

### 3. bottom-nav (底部导航)

**Verdict**: PASS

**Evidence**:
- `WccBottomBar.ets:47-52` — four entries in fixed order: Discover 🍽 / Search 🔍 / Pantry 🍳 / Saved 🔖.
- `WccBottomBar.ets:76-99` — selected item gets `WCC_PRIMARY_CONTAINER` bg + expanded label with animation; idle items show icon only (scenario 2 highlight).
- Each page renders `WccBottomBar({ currentTab: ... })` and routes taps via `goToTab` → `router.pushUrl` (e.g. `HomePage.ets:84-103`).
- Detail/Settings/Onboarding pages do **not** render `WccBottomBar` (auto-hide, scenario 1 step 3).
- Per-tab browse state survives a tab switch: Home category via `homeCategoryFilter` (`HomeViewModel.ets:78,152-173`); Search query/category/cookable/sort via `searchQuery/searchCategory/searchCookable/searchSort` (`SearchViewModel.ets:100-159`).

**Gaps**: Navigation model is page-push, not a true tab host (see back-navigation note). Functionally all scenarios pass.

---

### 4. category-filter (首页分类筛选)

**Verdict**: PASS

**Evidence**:
- `HomePage.ets:250-280` — "All" chip + 6 category chips (Breakfast/Lunch/Dinner/Dessert/Snack/Drinks) with emoji.
- `HomeViewModel.ets:152-162` — `selectCategory()` sets single selected category (`null`=All), persists it, rebuilds.
- `HomeViewModel.ets:133-145` — rebuild filters by category then sorts by match-ratio desc, title asc (scenarios 1, 2, 6).
- "Ready to cook" carousel is computed independently and is NOT affected by category filter (`HomeViewModel.ets:127-130`) — matches scenario 4 step 2.

**Gaps**: None.

---

### 5. cookable-ready (可做状态Ready)

**Verdict**: PASS

**Evidence**:
- `RecipeModel.ets:293-300` — `CookMatch` status = READY when `essentialCount===0 || missing.length===0` (scenarios 1 & 2).
- `RecipeDetailPage.ets:230-253` — "You're all set! / You have everything to make this." banner on cookable.
- `MetaStat.ets:35-46` — `CookStatusPill` shows "Ready to cook" (✅) on cookable cards across Home/Search/Favorites.
- `HomeViewModel.ets:127-130` — cookable recipes enter the "Ready to cook" carousel.
- Pantry mutations reassign `pantry.items` → all VMs `rebuild()` on `onPageShow` → status flips live (scenario 4).

**Gaps**: None.

---

### 6. detail-ingredients (Recipe Detail食材清单)

**Verdict**: PASS

**Evidence**:
- `RecipeDetailPage.ets:446` — Ingredients header shows total count (`ingredients.length` = essential + optional), matching scenario 1 step 2 / scenario 6 step 3.
- `RecipeDetailViewModel.ets:155-160` — `IngredientStatus.have` via `ingredientIsAvailable`.
- `RecipeDetailPage.ets:306-347` — `ingredientRow()`: left circle ✓ when `have`; right "Optional" when non-essential, "Missing" when essential & absent (scenarios 2/3/4). Optional always shows "Optional" regardless of `have` (scenario 4 step 1.1).
- `RecipeIngredient.display` (`RecipeModel.ets:30-41`) → "quantity unit  CapitalizedName".

**Gaps**: None.

---

### 7. detail-overview (Recipe Detail基础信息)

**Verdict**: PASS

**Evidence**:
- `RecipeDetailPage.ets:166-180` hero; `393-511` content sheet: category emoji+label, title, description, tags FlowRow (only if `tags.length>0`), 4 stat tiles (Time/Serves/Level/Kcal).
- `RecipeModel.ets:184-191` `computeTimeLabel` → "25 min" / "1h" / "1h 30m" (scenario 3).
- `RecipeDetailPage.ets:513-527` `notFoundState()` "Recipe not found / This recipe is no longer available." (scenario 4).
- Back + favorite pinned overlay (`RecipeDetailPage.ets:130-162`).

**Gaps**: Hero parallax is static (TODO at `:178-179`); the spec's own `[偏差]` acknowledges the gradient/emoji "icon-style" hero and parallax as acceptable. No functional break.

---

### 8. detail-steps (Recipe Detail步骤进度)

**Verdict**: PASS

**Evidence**:
- `RecipeDetailPage.ets:459-498` — "Steps" header + `completedSteps.length/total` count + progress bar (`stepProgressPercent()` `:102-109`) + per-step `stepRow()`.
- `RecipeDetailPage.ets:111-125` — `toggleStep` adds/removes index and reassigns `completedSteps` so `@State` re-renders (scenarios 2/3/4).
- `RecipeDetailPage.ets:78-86` — `aboutToAppear` resets `completedSteps = []` on (re)entry → progress not persisted across navigation (scenario 5).

**Gaps**: None.

---

### 9. discover-layout (Discover首页基础布局)

**Verdict**: PASS

**Evidence**:
- `HomePage.ets:371-445` build: greeting + "What can I cook?" + settings gear (`homeHeader`), search pill (`searchBarButton`), pantry card (`pantrySummaryCard`), Ready-to-cook carousel / empty-pantry prompt, "Browse recipes" + category chips + recipe list, bottom bar.
- `HomeViewModel.ets:184-196` `computeGreeting` → morning/afternoon/evening/"Hungry tonight?" (scenario 1 step 2.1).
- `HomePage.ets:195-197` pantry card subtitle: 0 → "Add what you have at home", 1 → "1 ingredient ready", N → "N ingredients ready" (scenario 2).

**Gaps**: None.

---

### 10. empty-pantry-hint (空食材库首页提示)

**Verdict**: PASS

**Evidence**:
- `HomePage.ets:393-404` — `cookNowPrompt()` shown only when `cookNow.length===0 && pantry.count===0` (scenarios 1, 3, 4).
- `HomePage.ets:223-247` — prompt content: 🧑‍🍳 + "Tell us what's in your kitchen" + body text; tap → pantry page (scenario 2).

**Gaps**: None.

---

### 11. favorite-order (收藏顺序)

**Verdict**: PASS

**Evidence**:
- `FavoritesModel.ets:45-57` — `setFavorite(true)` always `unshift`s (newest first), removing any prior occurrence first → re-favorite bubbles to top (scenarios 1, 2, 4).
- `FavoritesViewModel.ets:91-98` — list built by iterating `favorites.ids` in stored order (newest→oldest).
- `FavoritesModel.ese:52-55` — unfavorite `splice`s without reordering others (scenario 3).

**Gaps**: None. (Favorites are in-memory only, not persisted across cold start — see Cross-Cutting; no scenario requires cross-restart favorite persistence.)

---

### 12. favorite-recipe (收藏菜谱)

**Verdict**: PASS

**Evidence**:
- Heart toggles on Home/Search/Favorites call `vm.toggleFavorite` → `recipe.isFavorite` flip + `getSharedFavorites().setFavorite(id, ...)` → app-wide sync (`HomeViewModel.ets:176-181`, `SearchViewModel.ets:162-167`, `FavoritesViewModel.ets:64-69`).
- Detail page heart: `RecipeDetailViewModel.toggleFavorite` (`:99-109`).
- `FavoriteButton.ets:37` — `HitTestBehavior(HitTestMode.Block)` stops tap bubbling to the card's detail-navigation onClick (scenarios 1-3).
- `Recipe` is `@Observed` with `@Track isFavorite`; cards hold it via `@ObjectLink` (`RecipeCard.ets:34`) → heart re-renders live.

**Gaps**: Heart uses emoji swap (❤️/🤍) with no scale/fade animation (spec mentions "缩放淡入过渡") — cosmetic only.

---

### 13. ingredient-categories (食材分类展示)

**Verdict**: PASS

**Evidence**:
- `PantryCatalog.ets:40-48` — 7 categories in fixed order (Produce, Meat & Seafood, Dairy & Eggs, Grains & Bread, Pantry Staples, Spices & Herbs, Condiments & Oils) — matches spec including the Spices-before-Condiments order.
- `PantryViewModel.ets:133-150` — `rebuild()` builds groups per category, dropping empty groups and excluding on-hand items (scenarios 3, 4).
- `PantryPage.ets:244-290` — group header "{emoji}  {label}" + suggestion chips; "Other" never appears (scenario 4 step 3).

**Gaps**: None.

---

### 14. ingredient-normalize (食材归一化与同义词匹配)

**Verdict**: PASS

**Evidence**:
- `RecipeModel.ets:236-243` `normalizeName` — lowercase, strip non-alphanumerics, collapse spaces, apply synonym map.
- `RecipeModel.ets:199-229` — synonym map covers eggs→egg, tomatoes→tomato, scallion/spring onion→green onion, chicken breast→chicken, ground beef→beef, etc. (scenarios 1-3).
- `RecipeModel.ets:246-268` `namesMatch` + `containsAll` — **word-set** containment (rice ⊆ basmati rice, chicken thigh ⊇ chicken) but NOT substring (egg ✗ eggplant) (scenario 4).
- `PantryViewModel.ets:112-125` `addRaw` — stores `normalizeName(raw)` and dedupes (scenario 5).

**Gaps**: None.

---

### 15. loading-error-state (错误与加载状态)

**Verdict**: PASS

**Evidence**:
- Home skeleton + error/retry: `HomeViewModel.ets:94-107` (`loading`/`error` with 500ms async window + try/catch); `HomePage.ets:300-369` `homeSkeleton` / `homeError` ("Something went wrong" + "Try again") (scenarios 2, 3).
- Detail loading placeholder + not-found: `RecipeDetailViewModel.ets:93-96, 142-153`; `RecipeDetailPage.ets:513-527` (scenario 4).
- Search empty result: `SearchPage.ets:172-185, 236-240` (scenario 5.1).
- Favorites empty: `FavoritesPage.ets:100-116, 165` (loading flag guards against premature empty display — scenario "no empty while loading").
- Launch routing avoids white screen: `Index.ets:6-18` synchronously routes; start window uses `start_window_background` resource.

**Gaps**: Search and Pantry build data synchronously in their constructors, so they have no explicit skeleton — acceptable since there is no blank period (results populate immediately).

---

### 16. missing-ingredients (缺少食材状态MissingN)

**Verdict**: PASS

**Evidence**:
- `RecipeDetailPage.ets:254-303` — missing branch shows `CookStatusPill` (top capsule, which is "Missing N" for ALMOST or "have/total" for EXPLORE) + "You're missing N ingredient(s)" (singular/plural) + missing-name pills (capitalized, in recipe order).
- `MetaStat.ets:47-71` — pill form switches by `MatchStatus` (≤2 missing → "Missing N"; >2 → "X/Y") (scenarios 2, 3).
- Optional ingredients excluded from `missing` (`RecipeModel.ets:354-358`), so they never enter the count/list.

**Gaps**: None.

---

### 17. offline-recipes (离线菜谱数据初始化)

**Verdict**: PASS

**Evidence**:
- `RecipeSeedData.ets` — 18 bundled recipes (incl. 5-Minute Mug Cake, Banana Oat Pancakes, Chicken Fried Rice) across all 6 categories; no network/import calls anywhere.
- `HomeViewModel.ets:94-107` `load()` → `buildSeedRecipes()` (entry point for seeding).
- Search/Detail/Favorites read the same in-memory seed via `buildSeedRecipes()`; no remote APIs, no login/account code (scenarios 1, 2).
- `module.json5` declares **no `requestPermissions`** and no network — fully offline.

**Gaps**: Recipes are rebuilt in-memory on each page construction (not "load once into a DB then read") — functionally identical to the user (offline recipes always present); a fresh Home construction re-runs the synchronous build. No scenario break.

---

### 18. onboard-persist (引导完成状态持久化)

**Verdict**: PASS

**Evidence**:
- `OnboardingViewModel.ets:49-54` — `complete()` writes `AppStorage.setOrCreate('onboardingComplete', true)` + `PersistentStorage.persistProp(...)`.
- `Index.ets:11-17` — on launch, `persistProp('onboardingComplete', false)` then read → route to Home (complete) or Onboarding (incomplete) (scenarios 1-3).

**Gaps**: None.

---

### 19. onboarding (引导页)

**Verdict**: PASS

**Evidence**:
- `OnboardingPage.ets:117-171` — Skip (top-right), Swiper (3 pages), indicator dots (selected 24vp / idle 8vp, animated), CTA "Next"/"Start cooking".
- `OnboardingViewModel.ets:22-29` — 3 pages: "Cook with what you have", "Instant recipe matches", "Build your cookbook".
- `OnboardingPage.ets:50-57` — CTA label switches on `isLast()`; Start cooking → `complete()` → Home (scenarios 2-4).

**Gaps**: None.

---

### 20. optional-ingredient (可选食材不影响可做状态)

**Verdict**: PASS

**Evidence**:
- `RecipeModel.ets:293` — `essentialCount===0 || missing.length===0` → READY; optional ingredients only ever enter `missingOptional`, never `missing`, so an unmet optional never blocks cookable (scenarios 1, 4).
- `RecipeModel.ets:180` — `essentialIngredients` filters essential only → match denominator excludes optional (scenario 3).
- `RecipeDetailPage.esh:335-337` — optional row shows "Optional" regardless of `have` (scenario 2).

**Gaps**: None.

---

### 21. pantry-clear (Pantry清空)

**Verdict**: PASS

**Evidence**:
- `PantryPage.ets:188-212` — "In your kitchen" header has `actionText:'Clear all'` + `onActionTap: vm.clearAll()`; hidden when pantry empty (`PantryPage.ets:301-304`).
- `PantryViewModel.ets:99-105` `clearAll` — reassigns `pantry.items=[]` (no confirmation dialog) → cross-page refresh on next `onPageShow`.
- Subtitle + catalog title adjust to empty state (`PantryPage.ets:100-111`).

**Gaps**: None.

---

### 22. pantry-layout (Pantry页面基础布局)

**Verdict**: PASS

**Evidence**:
- `PantryPage.ets:292-334` — "My pantry" title, dynamic subtitle, manual-add field (placeholder "Add your own ingredient…" + "+" button), "In your kitchen" chips + Clear all, "Quick add"/"Add ingredients" catalog.
- `PantryPage.ets:100-111` — subtitle: 0 → "Add what you have — we'll find the recipes", 1 → "1 ingredient on hand", N → "N ingredients on hand"; catalog title flips to "Add ingredients" when empty (scenario 3).

**Gaps**: None.

---

### 23. pantry-manual-add (Pantry手动添加食材)

**Verdict**: PASS

**Evidence**:
- `PantryPage.ets:142-185` — TextInput bound to `vm.inputText`, "+" button + `onSubmit` (keyboard Done) both call `addManual`.
- `PantryViewModel.ets:73-80` `addManual` — trims; blank → no-op (scenarios 2, 3); else `addRaw`.
- `PantryViewModel.ets:112-125` `addRaw` — normalize + dedupe (scenario 4 step 4).

**Gaps**: None.

---

### 24. pantry-quick-add (Pantry快速添加食材)

**Verdict**: PASS

**Evidence**:
- `PantryPage.ets:269-290` — suggestion chip, whole-chip `onClick → vm.addCatalog(suggestion)`.
- `PantryViewModel.ets:83-85` `addCatalog` → `addRaw` (normalize + dedupe).
- `PantryViewModel.ets:133-150` — on-hand items removed from suggestions (scenario 2).

**Gaps**: None.

---

### 25. pantry-remove (Pantry移除单个食材)

**Verdict**: PASS

**Evidence**:
- `PantryPage.ets:216-235` — `pantryChip` whole-chip `onClick → vm.remove(item)` (no confirmation).
- `PantryViewModel.ets:88-96` `remove` — filter reassign + rebuild (item returns to suggestions).
- Empty-after-remove layout adjust handled by `count>0` guard (`PantryPage.ets:301`).

**Gaps**: None.

---

### 26. recipe-card (首页菜谱卡片)

**Verdict**: PASS

**Evidence**:
- `RecipeCard.ets:40-125` — image area (gradient+emoji), `CookStatusPill` (top-left), `FavoriteButton` (top-right), category label, title, description, meta row (time/difficulty/kcal).
- `MetaStat.ets:35-71` — pill 3-state (Ready to cook / Missing N / X-Y) (scenario 2).
- Card onClick → detail; heart stops propagation (scenarios 3, 4).
- Compact variant (`CompactRecipeCard.ets`) shows image+title+time+pill only (scenario 5 step 2).

**Gaps**: None functional.

---

### 27. recipe-match-count (菜谱匹配计数)

**Verdict**: PASS

**Evidence**:
- `CookMatch.ratio` / `haveCount` / `essentialCount` (`RecipeModel.ets:276-310`).
- `CookStatusPill` 3-state by `MatchStatus` (EXPLORE→"X/Y", ALMOST→"Missing N", READY→"Ready to cook") — `MetaStat.ets:35-71` (scenario 4).
- Recomputed on every VM `rebuild()` after pantry change (scenario 2).

**Gaps**: None.

---

### 28. saved-empty (收藏页空态)

**Verdict**: PASS

**Evidence**:
- `FavoritesPage.ets:162-169` — empty state shown only when `!loading && items.length===0` (guards against premature display, scenario 4).
- `FavoritesPage.ets:100-116` — 🔖 + "No saved recipes yet" + hint + "Browse recipes" CTA → Discover (scenarios 1, 2).
- Adding a favorite flips `loading`/items → list restores (scenario 3).

**Gaps**: None.

---

### 29. saved-list (收藏列表)

**Verdict**: PASS

**Evidence**:
- `FavoritesPage.ets:118-160` — "Saved" title + subtitle "N recipe(s) in your cookbook" + scrollable card list, newest-first.
- Card tap → detail; heart → unfavorite (scenarios 2, 3).
- `onPageShow → vm.refresh()` recomputes CookMatch against latest pantry (scenario 4).

**Gaps**: None.

---

### 30. search-category (搜索页分类筛选)

**Verdict**: PASS

**Evidence**:
- `SearchPage.ets:108-134` — All + 6 category chips, single-select.
- `SearchViewModel.ets:116-123, 203-209` — `onCategorySelected` persists + rebuild; filter stacks with text/cookable/sort (scenario 3, 5). Independent from Home category (separate AppStorage keys).

**Gaps**: None.

---

### 31. search-cookable (搜索页可做筛选)

**Verdict**: PASS

**Evidence**:
- `SearchPage.ets:140-145` — "Cookable" toggle chip; `SearchViewModel.ets:126-130, 212-214` — `onCookableToggle` persists + filters `match.isCookable`.
- Empty pantry + cookable → empty results (scenario 3). Recipes with zero essentials also count as cookable (spec `[偏差]`).

**Gaps**: None.

---

### 32. search-empty (搜索页空结果)

**Verdict**: PASS

**Evidence**:
- `SearchPage.ets:172-185, 236-240` — when `results.length===0` shows 🔍 + "No recipes found" + "Try a different ingredient or clear your filters." (no action button, scenario 5 step 2). No loading flag, but results are non-empty on first entry (all recipes), so empty only appears after filtering.

**Gaps**: The empty-state container uses `justifyContent(FlexAlign.Start)` (top-aligned) whereas the spec says "居中" (centered). Cosmetic — content is fully present.

---

### 33. search-layout (搜索页布局)

**Verdict**: PASS

**Evidence**:
- `SearchPage.ets:208-255` — "Search" title, `WccSearchField` (placeholder "Search recipes…"), category chips row, Cookable + sort row (Best match/Quickest/Fewest missing), results list.

**Gaps**: None.

---

### 34. search-text (搜索页文本搜索)

**Verdict**: PASS

**Evidence**:
- `SearchViewModel.ets:108-113, 188-201` — `onQueryChange` trims+lowercases, matches title | category.label | tags | ingredient names; empty query → no text filter (scenarios 1, 2, 4).
- `WccSearchField.ets:70-87` — clear button sets value to '' (scenario 3).

**Gaps**: None.

---

### 35. settings-clear-pantry (Settings 清空食材库)

**Verdict**: PASS

**Evidence**:
- `SettingsPage.ets:88-92, 152-188` — "Clear pantry" row → `vm.clearPantry()` (resets shared `PantryState.items=[]`) then `router.back()`, no confirmation (scenario 1).
- Shared pantry reset is visible on Home/Search/Detail/Favorites via their `onPageShow → refresh()` (scenarios 2-4). Favorites & recipes unaffected (scenario 5 step 3).

**Gaps**: None.

---

### 36. settings-overview (Settings 页面基础信息)

**Verdict**: PASS

**Evidence**:
- `SettingsPage.ets:235-269` — APPEARANCE (Theme: Light/Dark/Match system chips), DATA (Clear pantry + subtitle "Remove all ingredients you've added"), ABOUT (App=WhatCanICook, Version=1.0.0, Built with=Jetpack Compose, offline note).
- `SettingsViewModel.ets:36-49` — theme chips reflect current `themeMode` (scenario 2).

**Gaps**: "Built with" still reads "Jetpack Compose" (literal Android-source port) rather than a HarmonyOS technology — content-accuracy nit, not a functional break; spec explicitly lists this value.

---

### 37. sort-best-match (搜索页Best match排序)

**Verdict**: PASS

**Evidence**:
- `SearchViewModel.ets:232-238` — RELEVANCE: ratio desc, then title asc (`localeCompare`). Default selected (`:103, 158`). Applies after filtering (`:218`). Recomputes on pantry change via `refresh()`.

**Gaps**: None.

---

### 38. sort-fewest-missing (搜索页Fewest missing排序)

**Verdict**: PASS

**Evidence**:
- `SearchViewModel.ets:223-231` — FEWEST_MISSING: `missing.length` asc, then ratio desc. Essential-only count (optional excluded). Stacks with filters.

**Gaps**: None.

---

### 39. sort-quickest (搜索页Quickest排序)

**Verdict**: PASS

**Evidence**:
- `SearchViewModel.ets:220-222` — QUICKEST: `timeMinutes` asc (stable). Stacks with filters.

**Gaps**: None.

---

### 40. theme-persist (主题持久化)

**Verdict**: PASS

**Evidence**:
- `SettingsViewModel.ets:56-59` `setThemeMode` — writes id to AppStorage key `themeMode`.
- `EntryAbility.ets:35-53` — `persistProp('themeMode','SYSTEM')` + `applyPersistedTheme()` reads on launch and applies `setColorMode` (scenarios 2, 3).
- `ThemeMode.themeModeFromId` (`ThemeMode.ets:43-48`) — unknown/null → SYSTEM fallback (scenario 3).
- Re-selecting overwrites the stored value (scenario 4).

**Gaps**: None (persistence of the *value* is correct; see theme-switch for the *visual* caveat).

---

### 41. theme-switch (主题切换)

**Verdict**: **PARTIAL**

**Evidence (what works)**:
- `SettingsPage.ets:114-148, 69-86` — three chips (Match system/Light/Dark), single-select highlight; selecting calls `vm.setThemeMode` + `applyColorMode` (live `setColorMode`) without leaving the page (scenarios 1, 5).
- `SettingsViewModel.ets:47-59` — selection + persistence.
- `EntryAbility.ets` — restored on cold start.

**Gaps (why PARTIAL)**:
- **Dark palette does not actually render.** Selecting "Dark" calls `getContext().getApplicationContext().setColorMode(COLOR_MODE_DARK)`, but:
  - `resources/dark/element/color.json` only defines `start_window_background` — **`brand_surface` and `brand_primary` have no dark overrides**, so `$r('app.color.brand_surface')` (the app background used by every page) stays the light cream `#fffbf6` in dark mode.
  - Every other color in the app comes from hardcoded light-mode constants in `common/WccTheme.ets` (`WCC_INK`, `WCC_SURFACE`, `WCC_INK_MUTED`, containers, etc. — all `#FF...` light values, with an explicit TODO to promote them to resources). These are pure JS strings, fully theme-unaware.
- **Net effect**: choosing "Dark" changes the system color mode but the app UI remains light. Scenario 2 (Light → light palette) is fine; **scenarios 3 (Dark → dark palette) and 4 (Match system → follows system into dark) do not produce a dark UI**.
- Scenario 4's real-time system-follow also cannot be statically verified (UNABLE TO VERIFY), but given the missing dark resources it would not darken even if the system-toggle callback fired.

**Suggestions**:
1. Add dark-qualified overrides for `brand_surface`, `brand_primary`, `white` (and any other `$r` colors) in `entry/src/main/resources/dark/element/color.json`.
2. Promote the `WCC_*` tokens in `WccTheme.ets` into `base/element/color.json` + `dark/element/color.json` and reference them via `$r('app.color.*')` so they swap with `setColorMode`. (The file's own TODO already calls this out.)
3. For "Match system" real-time follow, optionally listen to `ConfigurationConstant` color-mode changes in `EntryAbility.onConfigurationUpdate` and re-apply.

---

### 42. unfavorite (取消收藏)

**Verdict**: PASS

**Evidence**:
- Same toggle path as favorite (`vm.toggleFavorite` → `setFavorite(id,false)` removes from `FavoritesState`); last unfavorite → Favorites page empty state (scenario 3).
- Recipe data itself is untouched (scenario 5 step 3) — only the favorites id list changes.

**Gaps**: None.

---

## Cross-Cutting Issues

### Permission Coverage
- **No permissions required and none declared** — correct. `module.json5` declares no `requestPermissions`. The app is fully offline (no network, no sensors, no storage-scoped permissions needed because state is in-memory/AppStorage/PersistentStorage app sandbox). Matches every scenario.

### Navigation Completeness
- All 8 pages are registered in `main_pages.json` and reachable. Detail is reached from Home/Search/Favorites cards; Settings from Home gear; Pantry from Home card or bottom nav; bottom nav connects the 4 top-level pages.
- **Observation (not a break)**: bottom-nav tab switches use `router.pushUrl` (stack push) rather than `router.replaceUrl`/clearUrl, so the back-stack grows with tab hopping. State is preserved via AppStorage, so no scenario fails, but the navigation model is heavier than a true tab host. Consider `router.clear()` / `replaceUrl` for tab destinations to keep the back-stack shallow.

### State Management Correctness
- Shared mutable state (`PantryState`, `FavoritesState`) is held as `@Observed`/`@Track` singletons in `AppStorage`; mutations always **reassign** `items`/`ids` (never in-place `push`/`splice`) so `@Track` dependencies fire reliably — verified in `PantryViewModel`, `RecipeDetailViewModel.addMissingToPantry`, `SettingsViewModel.clearPantry`.
- Cards hold `Recipe` via `@ObjectLink` so the `@Track isFavorite` heart re-renders live; detail page mirrors `isFavorite` onto the VM for the same reason.
- Per-tab filter/query state persisted to AppStorage survives tab switches (bottom-nav scenario 4).
- **Observation**: `Pantry` and `Favorites` are **not** wrapped in `PersistentStorage` (only `onboardingComplete` and `themeMode` are). They reset on cold start. No reviewed scenario requires pantry/favorites to survive a restart (the documented fresh-install behavior starts both empty), so this is not a scenario failure — but it is a data-retention limitation worth flagging if future scenarios expect persistence.

### API / API-Version Compatibility
- APIs used (`router` from `@kit.ArkUI`/`@ohos.router`, `PersistentStorage`, `AppStorage`, `Swiper`, `TextInput`, `ConfigurationConstant.setColorMode`, `hilog`, `UIAbility`) are standard ArkUI/Ability APIs. No exotic/deprecated calls spotted. The `@Track`/`@Observed`/`@ObjectLink` V1 state model is used consistently and correctly.

### Resource Completeness
- Screen copy is inline string literals (mirroring the Android source's inline Kotlin strings) — consistent and complete; no missing-string crashes.
- `brand_surface`/`brand_primary`/`white` exist in `base/element/color.json`. **Dark variants are missing** (see theme-switch) — the single material resource gap.
- Icons are emoji glyphs (no vector media) — intentional and consistent; no missing-media breaks.

---

## Final Assessment

**Overall Verdict**: **PASS WITH ISSUES**

The implementation is a thorough, scenario-faithful port. **40 of 42 scenario groups fully PASS**, with complete page coverage, correct shared-state MVVM, a robust shared cook-match/normalize engine, and proper loading/error/empty handling. Cross-page sync for pantry, favorites, match counts, and cookable status all work through the shared `AppStorage` singletons. Onboarding and theme *values* persist correctly across cold starts.

- **Fully covered scenarios (40)**: add-missing, back-navigation, bottom-nav, category-filter, cookable-ready, detail-ingredients, detail-overview, detail-steps, discover-layout, empty-pantry-hint, favorite-order, favorite-recipe, ingredient-categories, ingredient-normalize, loading-error-state, missing-ingredients, offline-recipes, onboard-persist, onboarding, optional-ingredient, pantry-clear, pantry-layout, pantry-manual-add, pantry-quick-add, pantry-remove, recipe-card, recipe-match-count, saved-empty, saved-list, search-category, search-cookable, search-empty, search-layout, search-text, settings-clear-pantry, settings-overview, sort-best-match, sort-fewest-missing, sort-quickest, theme-persist, unfavorite.

- **Partially covered scenario (1)**: **theme-switch** — selection, persistence, and the `setColorMode` mechanism all work, but selecting **"Dark" does not visibly darken the app** because `brand_*` resources lack dark overrides and all `WCC_*` color tokens are hardcoded light constants. "Light" and "Match system (light side)" render correctly; only the dark visual is absent.

- **Not covered scenarios (0)**: none.

**Recommended Priority Fixes** (ranked by user impact):
1. **(theme-switch — high impact, blocks dark mode)** Add dark-qualified color overrides in `entry/src/main/resources/dark/element/color.json` for `brand_surface`, `brand_primary`, `white`, and promote the `WCC_*` tokens from `WccTheme.ets` into `base`+`dark` `color.json` resources so the whole palette swaps with `setColorMode(DARK)`. This is the only functional gap; it directly fails theme-switch scenarios 3 & 4.
2. **(bottom-nav / back-navigation — medium impact, UX)** Switch bottom-nav tab destinations from `router.pushUrl` to `router.replaceUrl` (or `router.clear()` the stack) so tab-hopping does not accumulate a deep back-stack and system-back behaves predictably on top-level pages.
3. **(data retention — low scenario impact)** If future scenarios expect pantry/favorites to survive a cold restart, wrap `pantryState`/`favoritesState` in `PersistentStorage` (the model files' own TODOs already anticipate this). No current scenario is blocked.
4. **(cosmetic — low impact)** Center the search empty state (`FlexAlign.Center`) per spec; optionally add the favorite-heart scale/fade animation; these are purely visual.
