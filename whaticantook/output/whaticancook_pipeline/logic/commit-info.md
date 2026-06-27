# Commit Info — Real data layer for WhatCanICook

## Status

- **Build:** `hvigorw ... assembleHap` → **BUILD SUCCESSFUL** (entry/default).
  Only outputs are pre-existing deprecation warnings (`router.pushUrl`/`getParams`/`back`/`getContext`,
  which existed before this change and are out of scope) and the documented signing note
  (`No signingConfigs profile is configured` — unsigned HAP, expected).
- **Commit:** NOT performed. `harmony_project_dir`
  (`…/input/whaticancookHarmony`) and the whole `whaticantook` tree are **not git repositories**
  (`git rev-parse` → fatal). Changes are applied on disk only; no `commit_id` exists because there
  is no repo to commit into. Initializing a repo is outside the plan scope, so no commit was fabricated.

## What changed (all plan-required, in scope)

### Group A — new persistence/data infrastructure (`entry/src/main/ets/data/`)
- `AppContext.ets` — module-level `UIAbilityContext` holder (`set`/`get`).
- `RecipeRepository.ets` — singleton. `load()` reads `rawfile/recipes.json` via
  `resourceManager.getRawFileContent` → `util.TextDecoder.create('utf-8').decodeToString` →
  `JSON.parse` (delegates to `parseRecipesJson`). Caches in memory (cache flag + mutex flag);
  `clearCache()` + VM `retry()` power the error/retry path. Exposes `all()`/`byId()`.
  Carries `LoadState` (LOADING/CONTENT/ERROR).
- `PantryRepository.ets` — singleton. `hydrate()` from Preferences `pantry_items` (JSON);
  `snapshot()`/`snapshotNames()`; `add`/`addCatalog`/`remove`/`clear` mutate the canonical list
  and re-persist (`put` + `flush`). Dedup via `normalizeIngredient`; category via
  `findCatalogIngredient`/`CATEGORY_OTHER`.
- `FavoritesRepository.ets` — singleton. `hydrate()` from Preferences `favorite_ids`;
  ordered ids newest-first; `toggle` inserts-at-front/removes and persists; `isFavorite`/`setFavorite`.
- `SettingsRepository.ets` — singleton. `hydrate()` from Preferences `theme_mode`/`onboarding_complete`;
  tolerant deserialize (invalid/blank theme → SYSTEM; missing onboarding → false);
  `getThemeMode`/`setThemeMode`, `getOnboardingComplete`/`setOnboardingComplete` (persist + flush).
  Owns the `ThemeMode` enum + `themeModeFromId`; exports `PREFERENCES_STORE = 'wcc_settings'`.

### Group B — model (`model/RecipeModel.ets`)
- Added `difficultyFromName`, `recipeCategoryFromName` resolvers.
- Added `parseRecipesJson(json)` + `parseRecipe` (typed JSON interfaces; no `any`).
- **Removed** `getSampleRecipes()` (mock, snake_case ids) — replaced by the parser.

### Group C — startup (`entryability/EntryAbility.ets`, `pages/Index.ets`)
- `EntryAbility.onCreate` → `AppContext.set(this.context)`.
- `Index.aboutToAppear` (async): `await Promise.all([Settings/Pantry/Favorites .hydrate()])`,
  applies persisted color mode, then `router.replaceUrl(Discover|Onboarding)`. Splash covers the gap.
  **Removed** `PersistentStorage.persistProp` and `AppStorage` usage.

### Group D — ViewModels (all 7 wired to repos, mock seeds dropped)
- `DiscoverViewModel`: `@Track loadState`; `load()`/`retry()`; `refresh()`; matches from
  `PantryRepository.snapshotNames()`; `toggleFavorite` via `FavoritesRepository`.
- `PantryViewModel`: items from `PantryRepository.snapshot()`; add/addCatalog/remove/clear delegate
  then re-snapshot; `refresh()`.
- `SearchViewModel`: recipes from `RecipeRepository`; pantry snapshot; `toggleFavorite` via repo;
  `load()`/`refresh()`.
- `SavedViewModel`: recipes + favorites (newest-first) from repos; `load()`/`refresh()`.
- `RecipeDetailViewModel`: lookup via `RecipeRepository.byId`; pantry snapshot; `toggleFavorite` +
  `addMissingToPantry` via repos; `refresh()`.
- `SettingsViewModel`: theme via `SettingsRepository` (persist); `clearPantry` via
  `PantryRepository.clear()`; re-exports `ThemeMode`/`themeModeFromId`; `refresh()`.
- `OnboardingViewModel.complete`: `SettingsRepository.setOnboardingComplete(true)`.

### Group E — pages
- `DiscoverPage`: skeleton branch (LOADING), error+retry branch ("Something went wrong" / "Try again",
  ERROR), content branch (CONTENT); `aboutToAppear`→load, `onPageShow`→refresh.
- `SearchPage`/`SavedPage`: `aboutToAppear`→load, `onPageShow`→refresh.
- `PantryPage`/`SettingsPage`: `onPageShow`→refresh. (`OnboardingPage` complete already routes through VM.)

## Verification mapped to plan completion evidence

1. `RecipeRepository.load` parses the bundled catalogue; cache flag skips re-parse; catch → ERROR;
   "Try again" calls `clearCache()` + `retry()` → reload. ✅
2. `PantryRepository` add/remove/clear do `put`+`flush`; `hydrate()` restores on cold start. ✅
3. `FavoritesRepository.orderedIds()` newest-first; `toggle` persists; `hydrate()` restores order. ✅
4. `SettingsRepository`: invalid/blank theme → `SYSTEM` (`themeModeFromId`); missing onboarding → `false`. ✅
5. `Index.ets`: no `PersistentStorage` import; `await` hydrate precedes `router.replaceUrl`. ✅
6. `DiscoverPage`: skeleton (LOADING) / error+retry (ERROR) / content (CONTENT) branches. ✅
7. Grep: no `getSampleRecipes`/`SEED_*` references in shipped `viewmodel/` + `pages/` (only an
   explanatory comment in `Index.ets` noting they are NOT used). ✅
8. `recipes.json` contains **18** recipes; `parseRecipesJson` iterates all 18. ✅

## Platform behavior (coder-verified)

Three platform assumptions were verified against `platform-context-{1,2,3}/platform-context-result.json`
(status `ok`, `verified`):
- rawfile read is async, needs `UIAbilityContext`, decoded via `util.TextDecoder.create('utf-8')`
  + `JSON.parse` — confirmed; implemented exactly this way in `RecipeRepository`.
- Preferences survive restart only after `flush()`; `AppStorage`/`PersistentStorage` are
  non-persisting / deprecated type-loss — confirmed; every repo write calls `put`+`flush`.
- `onPageShow` fires on `router.back()` re-entry (and `aboutToAppear` does NOT fire on back) —
  confirmed; this is exactly why `refresh()` is wired into each consuming page's `onPageShow`.

## Protected behavior (unchanged, verified)
Matching algorithm (`normalizeIngredient`, `ingredientMatches`, `matchRecipe`,
`CookMatch.status/isCookable`), `PantryModel` catalog + `findCatalogIngredient`, `RecipeCardComponent`,
`BottomBar`, `AppColors`, the `SettingsPage`/`setColorMode` apply path, and the recipe category enum
mapping were not modified.
