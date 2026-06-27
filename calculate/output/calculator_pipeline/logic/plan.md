## Decision Contract

**Goal.** Bring the HarmonyOS calculator code up to the combined SPEC across three features: basic calculator equals/clear semantics, history save/view/restore, and theme initial-follow + circular-reveal toggle.

**Targets (3, independent).**
- T1 Calculator equals: incomplete expression (trailing operator, no second operand) + `=` must be a no-op (基础场景十); complete expression + `=` computes once; repeat `=` after a result is a no-op (场景十一). Currently `isComplete()` is inverted, so "1 ÷ =" wrongly computes → expression collapses to "1", result "1".
- T2 History: auto-save only on a valid completed `=` (历史场景一/二/三); click a record to restore its expression+result on the main page without re-saving (场景六); empty/clear/return paths unchanged.
- T3 Theme: initial `isDarkMode` must reflect the effective system/app color mode, not a hardcoded `false` (深色场景一); toggling must play a circular reveal from the touch point (场景二).

**Truth owner / source.**
- Calculator `expression`/`result`: `CalculatorViewModel` (live, already the single owner; `@Track expression/result`).
- History list: a new **`HistoryRepository`** singleton module = single session owner of `History[]`. `HistoryViewModel.historyItems` becomes a display snapshot reloaded from the owner on each `aboutToAppear` (not a competing owner). Restore payload travels via `router.back` params (transport, not truth) and is applied into `CalculatorViewModel`.
- Theme effect: `ApplicationContext.setColorMode(...)` is the producer/effect (resources `base/`+`dark/` auto-swap); `isDarkMode` is the 1:1 derived boolean driving the icon and the reveal anchor. Every writer of the real mode also writes `isDarkMode` (init read + `toggleTheme`), so no mirror drift.

**Access path.**
- Save: `CalculatorViewModel.performEquals` → (only when it actually evaluates AND `!resultIsInvalid`) → `HistoryRepository.add({expression: amendedExpression, result})`.
- Load: `HistoryPage.aboutToAppear` → `HistoryViewModel.loadHistory` → `HistoryRepository.getAll()`.
- Clear: `HistoryPage` dialog confirm → `HistoryViewModel.clearHistory` → `HistoryRepository.clear()`.
- Restore: `HistoryPage` item `.onClick` → `router.back({url:'pages/Index', params:{expression,result}})` → `Index.onPageShow` reads `router.getParams()` → sets `viewModel.expression/result` (puts VM in evaluated state).
- Theme init: `Index.aboutToAppear` reads `getUIContext().getHostContext().config.colorMode`.

**Platform Evidence / Decision.**
- `ConfigurationConstant.ColorMode` = NOT_SET(-1)/DARK(0)/LIGHT(1) — proven in SDK; matches the `COLOR_MODE_DARK/LIGHT` literals already in `Index.ets` and `EntryAbility`'s `COLOR_MODE_NOT_SET` follow-system call. Resources `base/element/color.json` + `dark/element/color.json` provide both palettes, and all UI binds via `$r(...)`, so `setColorMode` already swaps every element — proven by existing wiring.
- `ApplicationContext.setColorMode(ColorMode)` exists (SDK `application/ApplicationContext.d.ts:539`); there is **no** `getColorMode`. Effective mode is read from `UIAbilityContext.config.colorMode: ConfigurationConstant.ColorMode` ("current colorMode of the application", `application/UIAbilityContext.d.ts:150` + `Configuration.colorMode`). → Decision: set initial `isDarkMode = (context.config.colorMode === COLOR_MODE_DARK)`; system-follow is already in place via `EntryAbility` NOT_SET.
- `router.back(options?: RouterOptions)` with `RouterOptions{url,params}` (`@ohos.router.d.ts:766,210`) and `router.getParams()` (`:995`) — proven; project already uses `router.pushUrl/back` from `@kit.ArkUI`, so staying on this API keeps the paradigm consistent.
- Circular reveal primitives exist: `@ohos.arkui.componentSnapshot` (snapshot old theme) + `component/circle.d.ts` + `animateTo` + `.clip(Shape)`. → Decision (T3 reveal): on toggle, capture touch point via `.onTouch`, snapshot the root via `componentSnapshot.get`, flip `isDarkMode`+`setColorMode` underneath, then `animateTo(~500ms)` an overlay `Image` of the old snapshot clipped by a `Circle` whose radius shrinks from `maxDistance(corner)` → 0, anchored at the touch point.

**Platform Assumptions.**
| Assumed behavior | Local evidence | Correctness dims | Status |
|---|---|---|---|
| `setColorMode` flips `$r` colors app-wide instantly | base/dark color.json + all UI uses `$r` | resource variant selection | proven |
| `context.config.colorMode` returns effective DARK/LIGHT at appear | SDK doc lines above | initial icon correctness | coder must verify runtime value when system-follow (NOT_SET) |
| `componentSnapshot.get` returns a usable PixelMap and `.clip(Circle)` re-evaluates under `animateTo` | API present in SDK | reveal fidelity/timing | coder must verify snapshot timing + animated-clip redraw |
| System color-mode change while app runs updates UI | resources auto-swap on config change | live follow | coder must verify; spec does not require runtime system-switch (场景一=open only, 场景七=session) |

**State / fallback / protection contract.**
- Calculator non-target behavior protected: `performButton` invalid-result gate (场景十九) and post-evaluate digit/decimal/±/% lock (场景十七) must stay; only `isComplete()` semantics change. `showAllClear`/`displaySymbol` (场景二十), `performClear` rollback (场景十二–十四), long-press C → AC (场景十五) unchanged.
- History protection: no save on incomplete/invalid `=`; restore must NOT re-save (guaranteed because restored VM is in evaluated state → `isComplete` false → `=` no-ops). The accepted deviation (历史场景八 `[偏差]`) — clear-then-return-to-main — is the implemented/accepted contract; keep `router.back` after clear, do not attempt to stay-and-show-empty.
- Theme protection: toggling must not mutate `expression/result/history` (separate state owners) — already isolated; verify no regression. Theme preference is session-only (no persistence) — keep.

## Edit Plan

**Group A — Calculator equals fix (`viewmodel/CalculatorViewModel.ets`).**
- Rewrite `isComplete()`: `return this.expression.length>0 && this.expression.endsWith(this.lastOperator) && this.result!=='0';` (was: returned true for any trailing operator → inverted). Only caller is `performEquals`, so blast radius is `=` only.

**Group B — History wiring.**
- New `model/HistoryRepository.ets`: singleton holding `private items: History[]`; `add(c: Calculation)` (computes date label from now: today→'Today', yesterday→'Yesterday', else date string, matching 历史场景四); `getAll(): History[]` (returns copy, newest-last so HistoryPage bottom = most recent); `clear()`. No persistence (session-only per theme 场景七 parity).
- `viewmodel/CalculatorViewModel.ets` `performEquals()`: after `this.result = evaluateExpression(...)` and only inside the branch that evaluated, add `if (!this.resultIsInvalid) HistoryRepository.getInstance().add({expression: amendedExpression, result: this.result});` (saves full "1 + 2" + result).
- `viewmodel/HistoryViewModel.ets`: `loadHistory()` → `this.historyItems = HistoryRepository.getInstance().getAll();` (delete the 3 hardcoded mock items). `clearHistory()` → call repo `.clear()` then `this.historyItems = []`.
- `pages/HistoryPage.ets`: give `CalculationItem` an `.onClick` → `router.back({ url:'pages/Index', params:{ expression: calc.expression, result: calc.result } })` (场景六). Back button (场景七) and clear dialog (场景八) unchanged.
- `pages/Index.ets`: add `onPageShow()` — read `router.getParams()`; if it has `expression`+`result`, set `this.viewModel.expression`/`this.viewModel.result`. No history write here (no re-save).

**Group C — Theme (`pages/Index.ets`).**
- `aboutToAppear()`: replace `this.viewModel.isDarkMode = false;` with read of `getUIContext().getHostContext() as common.UIAbilityContext` → `this.viewModel.isDarkMode = (ctx.config.colorMode === COLOR_MODE_DARK);` (场景一).
- Theme button: add `.onTouch` to record window-relative (x,y) into a `@State touchX/touchY`.
- `toggleTheme()`: snapshot root via `componentSnapshot.get`; flip `isDarkMode` + `setColorMode(...)` (existing call kept); set `@State reveal` overlay old-snapshot Image on, then `animateTo({duration:500})` shrink a `Circle({center:[touchX,touchY]})` clip radius from `maxCornerDistance` → 0; on finish hide overlay. Icon already bound to `isDarkMode` (sun/moon) — no extra change.

## Forbidden
- Do NOT change `formatResult`/force ".0" — SPEC's "3.0" is example notation; history mock and real calculators use plain integers, so keep numeric `.toString()` results.
- Do NOT add persistence (preferences/relational store) — SPEC scope is session-only.
- Do NOT invert/remove the post-evaluate lock or the invalid-result lock in `performButton`.
- Do NOT make `HistoryViewModel.historyItems` a second owner (no cross-writer mutation); it only reloads from the repository.
- Do NOT switch router to Navigation/UIContext.Router — project already uses `@kit.ArkUI` router; mixing breaks parity.
- Do NOT block clear on the deviation note (场景八) — clear+return is the accepted contract.
- Do NOT alter `evaluateExpression`/`formatNumbers`/`performClear`/`extractLastNumber` (scenes 2,12–14 rely on them).

## Completion Evidence
- T1: trace "1 ÷ " (result "0") + `=` → `isComplete()` false → `performEquals` returns early → `expression` stays "1 ÷ ", `result` "0" (场景十 ✓). Trace "1 + 2"(="1 + ",result"2") + `=` → evaluates → result set, `expression`="1 + 2"; second `=` → `isComplete()` false (no trailing op) → no-op (场景九/十一 ✓). `performButton` invalid/evaluated guards untouched.
- T2: valid `=` → repo gains one item, expression=result of full expr; invalid `=`/incomplete `=` → no add (场景一/二/三 ✓). `HistoryPage` opens → `loadHistory` shows repo items grouped by date, newest at bottom (场景四); empty repo → `isEmpty` → "Nothing to show!" (场景五). Item click → `router.back` params; `Index.onPageShow` applies → expression+result shown; subsequent `=` no-ops so no re-save (场景六 ✓). Clear confirm → `repo.clear()` + `router.back` (场景八 accepted deviation).
- T3: cold open with system dark → `aboutToAppear` sets `isDarkMode=true` and icon shows sun; system light → moon (场景一 ✓). Toggle → snapshot taken, `setColorMode` flips `$r` palette, overlay Circle clip shrinks from touch point over ~500ms (场景二 ✓); expression/result/history unchanged (场景三/四/五 ✓).
- Build: `hmos-fix-build-errors`/hvigor compile clean (ArkTS strict) — repo singleton typing, `onPageShow`/`getParams` cast, `componentSnapshot` import all resolve.

## Unknown
- **(T3, non-blocking) live system color-mode switch while app is foreground.** SPEC 场景一 scopes follow-system to app open and 场景七 to session-only; no runtime system-toggle requirement. If desired later, add `onConfigurationUpdate` in `EntryAbility` to refresh `isDarkMode` — out of current scope. Safe partial boundary: initial-read + toggle-reveal fully satisfy the SPEC; nothing blocks implementation.
