## Decision Contract

**Goal.** Replace the in-memory mock data layer with a real, fully-offline data layer: recipes loaded from `rawfile/recipes.json` (18); pantry, favorites, theme, and onboarding persisted across restart; ingredient match counts computed from the real pantry; first-launch loading skeleton + error/retry on Discover.

**Target surface.**
- Recipes: `rawfile/recipes.json` (already present, 18 recipes, kebab-case ids `chicken-fried-rice`).
- Persistence: `@kit.ArkData` dataPreferences store `wcc_settings`; keys `theme_mode`, `onboarding_complete`, `pantry_items`(JSON), `favorite_ids`(JSON ordered).

**Truth owner / source.**
- Recipes → `RecipeRepository` (module singleton). Immutable seed data reloaded from rawfile each launch; cached in-memory so repeat page-entries skip the load. **Not persisted** (clear-data re-seeds automatically on next launch).
- Pantry → `PantryRepository` (singleton). Canonical in-memory `PantryItem[]` hydrated from Preferences at startup; every add/remove/clear mutates the canonical list **and** persists (JSON) + `flush()`.
- Favorites → `FavoritesRepository` (singleton). Canonical ordered `string[]` of recipe ids, **newest-first**; toggle inserts-at-front / removes.
- Theme + Onboarding → `SettingsRepository` (singleton, Preferences-backed): `getThemeMode()/setThemeMode()` (default `SYSTEM`), `getOnboardingComplete()/setOnboardingComplete()` (default `false`).
- Singletons are the single live owner for each domain; hydrated once before first content frame.

**Access path.**
1. `EntryAbility.onCreate` → `AppContext.set(this.context)` (module holder; Preferences/rawfile both need `UIAbilityContext`).
2. `Index.aboutToAppear` → `await` SettingsRepository hydrate (onboarding + theme from Preferences) → apply colorMode → `router.replaceUrl(Discover | Onboarding)`. Splash covers the async gap (spec: splash held until theme/onboarding ready).
3. `DiscoverPage.aboutToAppear` → `RecipeRepository.load(context)`: state `LOADING → CONTENT | ERROR`; on CONTENT snapshot pantry/favorites from repos and recompute matches.
4. Every consuming page `onPageShow` → `viewModel.refresh()` re-snapshots current pantry/favorites from the singletons and recomputes match counts. (Specs require updates "when user returns/enters a page", e.g. pantry-clear / settings-clear-pantry; same-page favorite heart stays ViewModel `@Track`.)
5. Mutations (PantryPage add/remove/clear; Settings clearPantry; card/detail toggleFavorite; Settings setTheme; Onboarding complete) → call the owning repo (updates canonical state + persists); favorite/pantry flags on `Recipe` are **derived** from repos on each recompute (single owner — never written independently).

**Platform Decision (triggered — unproven platform dependency on main path).** Evidence verified, consistent, decision-relevant:
- rawfile read: `context.resourceManager.getRawFileContent('recipes.json')` → `Promise<Uint8Array>` (async); decode via `util.TextDecoder.create('utf-8').decodeToString(bytes)` then `JSON.parse()`. Callable from a non-UI repository given a `UIAbilityContext`.
- Persistence: `dataPreferences.getPreferences(context,'wcc_settings')` (async) + `put`/`flush`/`get`; requires explicit `flush()` to survive restart.

**Platform Assumptions.**
| Assumed behavior | Local/platform evidence | Correctness dims this task depends on | Status |
|---|---|---|---|
| rawfile read async, needs context, TextDecoder+JSON.parse | platform evidence (getRawFileContent Promise<Uint8Array>; loadTasks pattern) | 18 recipes parsed offline; bytes→string→objects | proven |
| Preferences survive restart only after flush; async getPreferences | platform evidence (explicit flush) | pantry/fav/theme/onboarding durable | proven |
| AppStorage as sole persistence is non-persisting | platform evidence (forbidden) | theme/onboarding would not survive restart | proven-forbidden |
| PersistentStorage.persistProp deprecated, type-loss on object arrays | platform evidence (forbidden) | onboarding currently uses it; pantry objects unfit | proven-forbidden |
| `onPageShow` fires on router back to re-snapshot singletons | standard ArkUI page lifecycle | cross-page match recompute (pantry-clear etc.) | coder must verify the hook fires on back-nav for each consuming page |

**State / fallback / protection contract.**
- Defaults (missing/unset on first install): theme `SYSTEM`, onboarding `false`, pantry `[]`, favorites `[]`. Invalid theme string → `SYSTEM` (tolerant deserialize, case-insensitive).
- Error path: rawfile parse/IO throw → Discover state `ERROR` with "Try again" → re-run load (reset cache flag). No crash.
- Protected (must not change): matching logic (`normalizeIngredient`, `ingredientMatches`, `matchRecipe`, `CookMatch.status/isCookable`) — already spec-correct; `PantryModel` catalog + `findCatalogIngredient`; UI components (`RecipeCardComponent`, `BottomBar`), `AppColors`; SettingsPage `setColorMode` apply path; category enum mapping.

## Edit Plan

**Group A — Data infrastructure (new files under `data/`).**
- `data/AppContext.ets`: module-level `UIAbilityContext` holder (`set`/`get`).
- `data/RecipeRepository.ets`: singleton. `load(context)`: if cached return; else `getRawFileContent('recipes.json')` → TextDecoder → `JSON.parse` → map to `Recipe[]` (category via `categoryFromName`/`RECIPE_CATEGORIES`, essential bool, Difficulty enum). Cache + mutex flag. Exposes `all(): Recipe[]`, `byId(id)`. State for loading/error.
- `data/PantryRepository.ets`: singleton. `hydrate()` from Preferences `pantry_items`; `snapshot(): PantryItem[]`; `add(name,category)` (normalize+dedup), `remove(name)`, `clear()` — each mutates canonical list, `JSON.stringify`, `put`+`flush`.
- `data/FavoritesRepository.ets`: singleton. `hydrate()`; `orderedIds()` (newest-first); `toggle(id)` (insert-front / remove), persist `favorite_ids`; `isFavorite(id)`; `setFavorite(id,bool)`.
- `data/SettingsRepository.ets`: singleton. `hydrate()`; theme get/set (persist `theme_mode`); onboarding get/set (persist `onboarding_complete`). Tolerant deserialize.

**Group B — Model (`model/RecipeModel.ets`).**
- Add `parseRecipesJson(json: string): Recipe[]` + Recipe factory (no @Observed churn). Keep matching functions intact. Remove `getSampleRecipes()` from shipped import path (or gate as test-only).

**Group C — EntryAbility / Index (startup).**
- `EntryAbility.ets`: `AppContext.set(this.context)` in onCreate.
- `Index.ets`: **remove** `PersistentStorage.persistProp`; `await SettingsRepository.hydrate()`; read onboarding → route; read theme → apply colorMode (move apply here or keep in page).

**Group D — ViewModels (wire to repos, drop seeds).**
- `DiscoverViewModel`: add `@Track loadState` (LOADING/CONTENT/ERROR); `load(context)` via RecipeRepository; `pantryCount`/matches from PantryRepository snapshot; `toggleFavorite` via FavoritesRepository.
- `PantryViewModel`: items = `PantryRepository.snapshot()`; add/addCatalog/remove/clear delegate to repo then re-snapshot.
- `SearchViewModel`: recipes from RecipeRepository; pantry snapshot; toggleFavorite via FavoritesRepository.
- `SavedViewModel`: recipes from RecipeRepository; favorites from FavoritesRepository (newest-first already); pantry snapshot.
- `RecipeDetailViewModel`: lookup via RecipeRepository; pantry snapshot; toggleFavorite + `addMissingToPantry` via repos.
- `SettingsViewModel`: theme via SettingsRepository (persist + apply); `clearPantry` via PantryRepository.clear().
- `OnboardingViewModel.complete`: `SettingsRepository.setOnboardingComplete(true)`.

**Group E — Pages.**
- `DiscoverPage.ets`: render skeleton when LOADING, error view ("Something went wrong" + "Try again") when ERROR; `aboutToAppear` triggers load; `onPageShow` → refresh.
- Consuming pages (Discover/Pantry/Search/Saved/RecipeDetail/Settings): `onPageShow` → `viewModel.refresh()` to re-snapshot from singletons.
- `OnboardingPage`: complete() → repo (already calls VM.complete).

## Forbidden
- `PersistentStorage.persistProp` (deprecated, type-loss) — remove from Index.
- `AppStorage.setOrCreate`/`AppStorage.get` as the **sole** store for theme/onboarding (non-persisting) — replace with SettingsRepository.
- Shipped use of `getSampleRecipes()`, `SEED_PANTRY`, `SEED_FAVORITE_ORDER`, `SEED_NAMES`, `pantryCount=3` (mock; wrong snake_case ids vs JSON kebab-case — breaks detail navigation / favorites if kept).
- Relational DB / Room equivalent (unnecessary; rawfile + Preferences suffice; adds complexity).
- Any remote/network API.
- Editing the matching algorithm or PantryModel catalog (already correct).

## Completion Evidence
- `RecipeRepository.load` reads `rawfile/recipes.json`, parses **18** `Recipe`; cache flag prevents re-parse on repeat entry; `catch` sets ERROR; "Try again" resets flag and reloads.
- `PantryRepository`: `add/remove/clear` call `dataPreferences.put` + `flush`; `hydrate()` on cold start restores the same list.
- `FavoritesRepository`: `orderedIds()` newest-first; `toggle` persists; `hydrate()` restores order.
- `SettingsRepository`: invalid theme string → `SYSTEM`; missing onboarding → `false`.
- `Index.ets`: no `PersistentStorage` import; `await` hydrate precedes `router.replaceUrl`.
- `DiscoverPage`: skeleton branch on LOADING, error+retry branch on ERROR, content branch on CONTENT.
- Grep: no `getSampleRecipes`/`SEED_*` references remain in shipped `viewmodel/` and `pages/`.
- Restart test: add pantry item + favorite a recipe + set Dark theme → kill app → reopen → pantry item, favorite, Dark theme, and skipped-onboarding all restored; Discover shows 18 recipes.

## Unknown
None blocking. Single open item (non-blocking, coder-must-verify): confirm `onPageShow` reliably fires on `router` back-navigation for each consuming page so the singleton re-snapshot refreshes match counts; if any page does not fire it, use `aboutToAppear`/`onPageShow` fallback for that page.
