# Code Review Report

## Overview

- **Project**: calculatorHarmony (`/Users/bb/work/hometrans/calculate/input/calculatorHarmony`)
- **Commit ID**: `dd5df0c59e3860aac529efee294d322048df01d9`
- **Scenario Doc**: `/Users/bb/work/hometrans/calculate/output/calculator_pipeline/combined-spec.md`
- **Code Context**: git-diff fallback (root commit — `extract_commit_context` MCP tool failed because `dd5df0c` is the repo's first commit with no parent; the 5 files are all new additions totalling 757 insertions. Full file contents were read directly.)
- **Review Date**: 2026-06-25
- **Total Scenarios**: 38 (Basic Calculator: 21, Theme: 7, History: 10)
- **Results**: 34 PASS | 4 PARTIAL | 0 FAIL | 0 UNABLE TO VERIFY

## Scenario Coverage Summary

| # | Scenario | Verdict | Key Gaps |
|---|----------|---------|----------|
| C1 | Open app → main page, expression empty, result 0 | PASS | — |
| C2 | Digit input appends / replaces 0, thousand separators | PASS | — |
| C3 | Repeated `0` stays `0`, no leading zero | PASS | — |
| C4 | Decimal appends `0.` then digits | PASS | — |
| C5 | Repeated decimal keeps single dot | PASS | — |
| C6 | Operator at initial state → no reaction | PASS | — |
| C7 | Number + operator → expression shown, result 0 | PASS | — |
| C8 | Consecutive operators → keep last | PASS | — |
| C9 | Complete expression + `=` → full expr + result + save | PARTIAL | Integer result shows `3`, spec expects `3.0` |
| C10 | Incomplete expression + `=` → no change | PASS | — |
| C11 | Repeat `=` after result → no recompute | PASS | — |
| C12 | `C` deletes last digit one at a time | PASS | — |
| C13 | `C` on single char / `-1` → `0` | PASS | — |
| C14 | `C` in expression → last operand rolls back | PASS | — |
| C15 | Long-press `C` → AC effect | PASS | — |
| C16 | `AC` clears all | PASS | — |
| C17 | After calc, digit/decimal/±/% blocked | PASS | — |
| C18 | After calc, operator → result as new operand | PARTIAL | Shows `3 -`, spec expects `3.0 -` |
| C19 | Invalid result (Infinity/NaN) → only `AC` works | PASS | — |
| C20 | First key shows `C` / `AC` per state | PASS | — |
| C21 | Feature scope (informational) | PASS | consistent with impl |
| T1 | Open app → theme follows system | PASS | — |
| T2 | Toggle theme → circular reveal animation | PASS | — |
| T3 | Toggle during input → input preserved | PASS | — |
| T4 | Toggle after calc → result preserved | PASS | — |
| T5 | Toggle → history unaffected | PASS | — |
| T6 | Multiple toggles → each works, data preserved | PASS | — |
| T7 | Theme scope (informational) | PASS | consistent with impl |
| H1 | Valid calc → auto-save expr/result/date | PASS | — |
| H2 | Invalid result → not saved | PASS | — |
| H3 | Incomplete expr + `=` → no history | PASS | — |
| H4 | Enter history page → grouped list, scrollable rows | PARTIAL | Rows ellipsis-truncate, not horizontally scrollable; scroll-to-latest approximate |
| H5 | No history → empty state | PASS | — |
| H6 | Click record → return, restore expr/result, no re-save | PASS | — |
| H7 | Back button → return, no restore | PARTIAL | Stale `getParams()` risk after a prior restore may re-restore |
| H8 | Clear → confirm dialog → confirm clears + returns | PASS | accepted deviation (spec-acknowledged) |
| H9 | Cancel in dialog → close, no clear | PASS | — |
| H10 | History scope (informational) | PASS | consistent with impl |

## Detailed Scenario Reviews

### Basic Calculator

---

### Scenario C1: Open app → main page, expression empty, result 0
**Description**: User opens the app, lands on the calculator main page; expression area empty, result shows 0.
**Verdict**: PASS

**Evidence**:
- `Index.ets:30-33` — `@Entry struct Index`, the default entry page; `main_pages.json:3` lists `pages/Index` first.
- `CalculatorViewModel.ets:6-7` — `expression = ''`, `result = '0'` defaults.
- `Index.ets:173-192` — display binds `formattedExpression` (empty) and `formattedResult`; `formatNumbers('0')` returns `'0'` (`CalculatorModel.ets:172-173`).

**Gaps**: none.

---

### Scenario C2: Digit input appends / replaces 0, with thousand separators
**Description**: First digit replaces the leading 0; subsequent digits append; result shown with thousand separators (e.g. 4900 → 4,900).
**Verdict**: PASS

**Evidence**:
- `CalculatorViewModel.ets:88-91` — `performDigit`: `amendedResult = result === '0' ? '' : result`, so the first digit replaces 0 and later digits append.
- `CalculatorModel.ets:181-201` — `addCommas` inserts commas every 3 digits; verified `4900` → `4,900`.
- `CalculatorViewModel.ets:16-18` — `formattedResult` getter applies `formatNumbers`.

**Gaps**: none.

---

### Scenario C3: Repeated `0` stays `0`, no leading zero
**Verdict**: PASS

**Evidence**: `CalculatorViewModel.ets:88-91` — when `result === '0'`, `performDigit('0')` sets `result = '' + '0' = '0'`; stays `0`, never `00`.

---

### Scenario C4: Decimal appends `0.` then digits
**Verdict**: PASS

**Evidence**: `CalculatorViewModel.ets:93-96` — `performDecimal`: `result.indexOf('.') < 0` → `result = '0' + '.' = '0.'`; subsequent digit appends → `0.00`.

---

### Scenario C5: Repeated decimal keeps single dot
**Verdict**: PASS

**Evidence**: `CalculatorViewModel.ets:94` — `if (this.result.indexOf('.') >= 0) return;` blocks a second dot.

---

### Scenario C6: Operator at initial state → no reaction
**Verdict**: PASS

**Evidence**: `CalculatorViewModel.ets:99` — `performOperator` early-returns when `expression.length === 0 && result === '0'`.

---

### Scenario C7: Number + operator → expression shown, result 0
**Verdict**: PASS

**Evidence**: `CalculatorViewModel.ets:98-112` — with a non-zero result and no trailing operator, `amendedExpression = result`, then `expression = result + ' op '`, `result = '0'`. Display `formatNumbers('12 + ')` → `12 +`.

---

### Scenario C8: Consecutive operators → keep last
**Verdict**: PASS

**Evidence**: `CalculatorViewModel.ets:102-103` — when `result === '0'` and an operator is pressed, the expression's trailing operator (`lastOperator`) is stripped before appending the new one.

---

### Scenario C9: Complete expression + `=` → full expression + result + save to history
**Description**: Enter number, operator, number; press `=` → expression shows full form, result shows computed value, and the record is saved.
**Verdict**: PARTIAL

**Evidence**:
- `CalculatorViewModel.ets:114-129` — `performEquals` builds `amendedExpression = expression + result` (e.g. `1 + 2`), sets `expression`, evaluates, and **saves on valid result** (`HistoryRepository...add` guarded by `!resultIsInvalid`, lines 126-128). The core equals + save logic is correct.
- `CalculatorModel.ets:74-77` — `formatResult`: `Math.round(value*1e10)/1e10` then `.toString()`.

**Gaps**:
- **Result format**: `1 + 2` yields `"3"`, but the spec (C9 step 4, and again in C11/C18) explicitly shows the result as `"3.0"`. `(3).toString()` produces `"3"`. The math is correct; only the trailing-zero display differs.

**Suggestions**:
- If the spec's `3.0` is authoritative (matching the Android source), format integer results with one decimal place, e.g. ensure at least `.0` suffix. Confirm against the Android original whether integer results should carry a decimal.

---

### Scenario C10: Incomplete expression + `=` → no change
**Verdict**: PASS

**Evidence**: `CalculatorViewModel.ets:131-133` — `isComplete()` requires `result !== '0'`. With a trailing operator and `result === '0'`, `isComplete` is false → `performEquals` early-returns (line 115). No expression/result mutation, no save.

---

### Scenario C11: Repeat `=` after result → no recompute
**Verdict**: PASS

**Evidence** (core T1 fix): `CalculatorViewModel.ets:131-133` — after a successful evaluate, `expression` no longer ends with an operator (e.g. `1 + 2`), so `expression.endsWith(lastOperator)` is false → `isComplete()` is false → repeat `=` is a no-op. No duplicate computation and no duplicate save (H1 step 4).

---

### Scenario C12: `C` deletes last digit one at a time
**Verdict**: PASS

**Evidence**: `CalculatorViewModel.ets:135-153` — `performClear` with empty expression keeps the expression and trims result via `clearLastChar` (lines 155-162), removing one trailing char per press (`1234` → `123` → `12`).

---

### Scenario C13: `C` on single char / `-1` → `0`
**Verdict**: PASS

**Evidence**: `CalculatorViewModel.ets:155-162` — `clearLastChar('-1')` → reduced `'-'` → returns `'0'`; `clearLastChar('5')` → length ≤ 1 → `'0'`. Never empty.

---

### Scenario C14: `C` in expression → last operand rolls back to result
**Description**: e.g. expression `12 + -23 -`, result `-1`; pressing `C` until result hits 0 rolls the last operand (`-23`) into the result and trims the expression to `12 +`.
**Verdict**: PASS

**Evidence**:
- `CalculatorViewModel.ets:141-149` — once `clearLastChar` yields `'0'` while the expression is non-empty, `extractLastNumber` (line 164-170, regex `/-?\d+\.?\d*/g`) pulls the last operand `-23`, restores it to `result`, and truncates the expression at its index → `12 + `.
- Verified regex returns `["12","-23"]`; `lastIndexOf("-23")` → index 5; `substring(0,5)` = `12 + `.

---

### Scenario C15: Long-press `C` → AC effect
**Verdict**: PASS

**Evidence**: `Index.ets:111-113` — `ClearButtonCell` `onLongClickAction` calls `onButtonClick(BTN_ALL_CLEAR)`; `NeuButton.ets:27-32` wires `LongPressGesture`.

---

### Scenario C16: `AC` clears all
**Verdict**: PASS

**Evidence**: `CalculatorViewModel.ets:172-175` — `performAllClear` sets `expression=''`, `result='0'`.

---

### Scenario C17: After calculation, digit/decimal/±/% blocked
**Verdict**: PASS

**Evidence**: `CalculatorViewModel.ets:54-60` — post-evaluate the VM is "evaluated" (`isNotEvaluated` false), so the guard returns false for Digit/Decimal/`±`/`%`. Operator, `=`, and Clear are not in the guard → still allowed.

---

### Scenario C18: After calculation, operator → result as new operand
**Verdict**: PARTIAL

**Evidence**: `CalculatorViewModel.ets:98-112` — in evaluated state, pressing an operator takes the `else` branch (`amendedExpression = result`) producing `3 - `, then `result = '0'`. Logic correct.

**Gaps**: Spec C18 step 3 expects the new expression to read `3.0 -`; the code produces `3 -` (same integer-format issue as C9).

---

### Scenario C19: Invalid result (Infinity/NaN) → only `AC` works
**Verdict**: PASS

**Evidence**:
- `CalculatorViewModel.ets:50-53` — `performButton` returns false for any button except `AllClear` when `resultIsInvalid`.
- `CalculatorModel.ets:62-67` — `evaluateExpression` returns `'Infinity'`/`'-Infinity'`/`'NaN'`; `resultIsInvalid` (`CalculatorViewModel.ets:20-22`) matches all three.
- `performAllClear` (line 172) restores `0`.

---

### Scenario C20: First key shows `C` / `AC` per state
**Verdict**: PASS

**Evidence**: `CalculatorViewModel.ets:42-48` — `displaySymbol = showAllClear ? 'AC' : 'C'`; `showAllClear = !isNotEvaluated || resultIsInvalid`. During input `isNotEvaluated` is true → `C`; after calc or on invalid → `AC`. `Index.ets:101,105-109` renders `displaySymbol` and routes C vs AC accordingly.

---

### Scenario C21: Basic calculator scope (informational)
**Verdict**: PASS (scope description; implementation boundaries match — history/theme have separate entries).

---

### Theme

---

### Scenario T1: Open app → theme follows system
**Verdict**: PASS

**Evidence**: `Index.ets:40-43` — `aboutToAppear` reads `context.config.colorMode` and sets `isDarkMode`. The `$r` colors resolve from `resources/base` (light) or `resources/dark` based on the effective color mode; `setColorMode` is not called at startup, so the system setting governs the initial palette. Light + dark color sets both exist (`color.json` base and dark).

---

### Scenario T2: Toggle theme → circular reveal animation
**Verdict**: PASS

**Evidence**:
- `Index.ets:61-88` — `toggleTheme` snapshots `calcRoot` via `getComponentSnapshot().get('calcRoot')`, flips `isDarkMode`, calls `setColorMode`, then `animateTo({duration:500})` scales the old-snapshot overlay from `1` → `0` anchored at the touch point (`touchX/touchY`), revealing the new theme.
- `Index.ets:150-155` captures the touch anchor; `Index.ets:260-271` renders the overlay `Image` with `.scale({centerX: touchX, centerY: touchY})`.
- `Index.ets:142` icon: dark → ☀ (switch to light), light → ☾ (switch to dark) — matches spec.
- The commit notes `.clip(Circle)` is deprecated at API 22; the scale-anchored reveal is a documented platform adaptation producing an equivalent circular wipe.

**Gaps**: The reveal is implemented as the old snapshot *shrinking* to reveal the new theme (inverse direction of "new expands to cover old"), but both yield a circular transition centered on the touch point — visually equivalent and explicitly an accepted platform drift.

---

### Scenario T3: Toggle during input → input preserved
**Verdict**: PASS

**Evidence**: `Index.ets:61-88` `toggleTheme` mutates only `isDarkMode`, `setColorMode`, and the reveal overlay — it never touches `viewModel.expression`/`viewModel.result`.

---

### Scenario T4: Toggle after calc → result preserved
**Verdict**: PASS — same as T3; calculation state untouched by `toggleTheme`.

---

### Scenario T5: Toggle → history unaffected
**Verdict**: PASS

**Evidence**: History lives in the `HistoryRepository` singleton (`HistoryRepository.ets:3-14`); `toggleTheme` never references it.

---

### Scenario T6: Multiple toggles → each works, data preserved
**Verdict**: PASS — each click re-runs `toggleTheme`; state is idempotently flipped each time with no data mutation.

---

### Scenario T7: Theme scope (informational)
**Verdict**: PASS (scope matches: toggle only on main page top bar; `HistoryPage` has only back + clear buttons, no theme control; no persisted preference — restart re-reads system mode in `aboutToAppear`).

---

### History

---

### Scenario H1: Valid calc → auto-save expression/result/date
**Verdict**: PASS

**Evidence**:
- `CalculatorViewModel.ets:126-128` — on a valid evaluate (`!resultIsInvalid`), `HistoryRepository.getInstance().add({expression, result})`.
- `HistoryRepository.ets:16-19` — `add` appends `{calculation, date: dateLabelFromNow()}`; `dateLabelFromNow` (lines 33-44) returns `Today`/`Yesterday`/formatted date.
- Repeat `=` does not re-save because `isComplete()` is false after the first evaluate (C11).

---

### Scenario H2: Invalid result → not saved
**Verdict**: PASS

**Evidence**: `CalculatorViewModel.ets:126` — save is guarded by `if (!this.resultIsInvalid)`; Infinity/NaN results skip the save.

---

### Scenario H3: Incomplete expr + `=` → no history
**Verdict**: PASS

**Evidence**: `CalculatorViewModel.ets:115` — incomplete `=` early-returns before reaching the save statement.

---

### Scenario H4: Enter history page → grouped list, scrollable rows, date labels, scroll to latest
**Verdict**: PARTIAL

**Evidence**:
- `HistoryPage.ets:13-15` — `aboutToAppear` calls `loadHistory()`; `HistoryViewModel.ets:36-38` loads from the repository.
- `HistoryViewModel.ets:13-30` — `groups` getter buckets by date label preserving chronological order.
- `HistoryPage.ets:24-43` — each row shows expression (top, opacity 0.6) and result (bottom), both with `formatNumbers` (thousand separators).
- `HistoryPage.ets:150-169` — `Scroll` with `.align(Alignment.Bottom)` approximates "scroll to latest".
- `HistoryPage.ets:157` — date label rendered below each group.

**Gaps**:
- **Horizontal scroll**: spec H4 step 4 requires each expression and result to be *horizontally scrollable*. The implementation uses `Text` with `maxLines(1)` + `TextOverflow.Ellipsis` (lines 29-30, 39-40), i.e. long values are **truncated with "…"**, not scrollable. Minor for short results, but a stated requirement deviation.
- **Scroll-to-latest**: `.align(Alignment.Bottom)` is an approximation; exact initial scroll position cannot be confirmed statically.

**Suggestions**: Wrap each expression/result `Text` in a horizontal `Scroll` (or set `.maxLines(1)` with a `Text` inside a `Scroll({scrollable: ScrollDirection.Horizontal})`) to satisfy the scroll requirement.

---

### Scenario H5: No history → empty state
**Verdict**: PASS

**Evidence**: `HistoryViewModel.ets:32-34` `isEmpty`; `HistoryPage.ets:144-148` shows `nothing_to_show` string when empty (string present at `string.json:31-34`).

---

### Scenario H6: Click record → return, restore expression/result, no re-save
**Verdict**: PASS

**Evidence** (core T2 fix):
- `HistoryPage.ets:48-50` — `CalculationItem.onClick` calls `router.back({url:'pages/Index', params:{expression, result}})`.
- `Index.ets:45-55` — `onPageShow` reads `router.getParams()` and restores `viewModel.expression`/`viewModel.result`.
- No re-save: restored VM is in evaluated state (expression ends with a digit, not an operator) → `isComplete()` false → any subsequent `=` is a no-op, and there is no save on restore itself.

---

### Scenario H7: Back button → return to main, no restore
**Verdict**: PARTIAL

**Evidence**:
- `HistoryPage.ets:17-19` — `navigateBack()` calls plain `router.back()` (no params).
- `Index.ets:46-55` — `onPageShow` restores only if `params` is non-null/non-undefined and `expression`/`result` are defined.

**Gaps**:
- **Stale-params risk**: HarmonyOS `router.getParams()` returns the params associated with the most recent navigation that targeted the page. A plain `router.back()` does **not** clear previously-passed params. Consequence: once the user has restored a record via H6 (which set Index's params to `{expression, result}`), every *subsequent* plain back-button return will still see those stale params and **re-restore the same record**, violating spec H7 step 3 ("keep the state the user left it in; do not restore any record"). The happy path (back with no prior restore) works because params are initially `undefined`. The exact behavior depends on runtime `getParams()` semantics, hence PARTIAL rather than FAIL.

**Suggestions**: Make the no-restore path explicit by passing empty params from the back button, e.g. `router.back({url:'pages/Index', params: {}})`. The restore guard (`restore.expression !== undefined && restore.result !== undefined`) will then correctly skip restoration for `{}`. Alternatively, consume/clear the restore params once applied (e.g. a one-shot flag) to avoid re-application on later `onPageShow` calls.

---

### Scenario H8: Clear → confirm dialog → confirm clears + returns
**Verdict**: PASS

**Evidence**:
- `HistoryPage.ets:54-113` — `ClearConfirmDialog`: title "Clear" (`app.string.clear`), prompt "Clear history now?" (`app.string.clear_history_now`), Cancel + Clear buttons.
- `HistoryPage.ets:89-95` — confirm calls `clearHistory()` (`HistoryViewModel.ets:40-43`: `HistoryRepository.clear()` + `items=[]`), closes the dialog, then `router.back()` after 100 ms.
- All dialog strings present (`string.json:35-46`).

**Note**: This is the documented `[偏差]` in the spec (clear also returns to the main page instead of staying to show the empty state). The spec explicitly acknowledges this deviation, so it is accepted.

---

### Scenario H9: Cancel in dialog → close, no clear
**Verdict**: PASS

**Evidence**: `HistoryPage.ets:78-80` — Cancel sets `showClearDialog=false` with no call to `clearHistory()`; records remain intact.

---

### Scenario H10: History scope (informational)
**Verdict**: PASS (scope matches: save only on valid `=`; view via top-bar history button; restore via list-item click; clear via history-page clear button + confirm dialog).

---

## Cross-Cutting Issues

### Permission Coverage
**Status: OK.** `module.json5` declares no runtime permissions. The calculator needs none; history is in-memory (no DB/file I/O); theme uses `setColorMode`/snapshots (no permission). No scenario requires an undeclared permission.

### Navigation Completeness
**Status: OK.** `main_pages.json` registers `pages/Index` and `pages/HistoryPage`. `Index.navigateToHistory` (`Index.ets:90-96`) pushes HistoryPage; both HistoryPage back paths (record click and back button) return to Index. Navigation is complete. (See H7 for the stale-params restore concern, which is a data-flow issue, not a missing-route issue.)

### State Management
**Status: OK.** Both pages use `@State viewModel`. The cross-page history sharing is correctly modeled through the `HistoryRepository` singleton rather than through VM instances — the calculator VM writes via `HistoryRepository.getInstance().add(...)` and the history VM reads via `getAll()`. Theme state (`isDarkMode`) lives on the calculator VM and is not needed on the history page. State boundaries are sound.

### API Compatibility
**Status: OK with one noted adaptation.** `setColorMode`, `getComponentSnapshot().get()`, `LongPressGesture`, `router`, `animateTo` are all standard and current. The commit explicitly replaces the deprecated `.clip(Circle)` (API 22) with a touch-anchored `.scale` reveal — an accepted, documented platform drift (commit message + referenced `issues.md`).

### Resource Completeness
**Status: OK.** All referenced strings exist (`theme_changer`, `calculations_history`, `back_to_calculator`, `clear_history`, `nothing_to_show`, `clear`, `clear_history_now`, `cancel`). All referenced colors exist in **both** the base (light) and `dark` qualifier sets (`primary`, `primary_variant`, `secondary`, `background`, `surface`, `on_primary`, `on_secondary`, `on_background`, `on_surface`, `transparent`). No missing resources.

---

## Final Assessment

**Overall Verdict**: PASS WITH ISSUES

The commit's three focus areas are all correctly implemented:

- **Equals logic fix (T1)** — `isComplete()` (`CalculatorViewModel.ets:131-133`) now correctly gates computation: an incomplete expression (trailing operator, `result==='0'`) and a repeat `=` after a result both become no-ops, while a genuinely complete expression computes exactly once. ✓
- **Save on valid equals (T2)** — `performEquals` saves `{expression, result}` only when the result is finite/numeric (`CalculatorViewModel.ets:126-128`), wired through a new `HistoryRepository` singleton; `HistoryViewModel` loads/clears via the repository; restore flows through `HistoryPage` item onClick → `router.back` params → `Index.onPageShow`. ✓
- **Theme toggle (T3)** — `aboutToAppear` reads the effective `colorMode`; `toggleTheme` performs a touch-anchored circular reveal and flips the app color mode. ✓

- **Fully covered scenarios** (34): all basic input/operator/decimal logic, clear/AC variants (incl. long-press and operand rollback), invalid-result lockout, C/AC switching, all theme scenarios, history save/no-save rules, empty state, record restore, clear-with-confirm (accepted deviation), and the three informational scope scenarios.
- **Partially covered scenarios** (4):
  - **C9 / C18** — equals/operator-after-calc logic is correct, but integer results display as `3` rather than the spec's `3.0`. (One underlying issue: integer result formatting.)
  - **H4** — history rows ellipsis-truncate instead of being horizontally scrollable.
  - **H7** — plain back-button return risks re-restoring a stale record after a prior H6 restore, because `router.getParams()` is not cleared on plain `router.back()`.

**Recommended Priority Fixes** (ranked by user impact):

1. **H7 — stale restore params (highest impact)**: After restoring one record, every later back-button press would re-restore that same record, visibly contradicting "back returns me to where I was". Fix by passing empty params from the back button (`router.back({url:'pages/Index', params: {}})`) or by consuming the restore params once. Verify the runtime `getParams()` behavior on a device.
2. **C9/C18 — result formatting**: Confirm whether the Android original shows `3.0` for integer results; if so, adjust `formatResult` (`CalculatorModel.ets:74-77`) to emit at least one decimal digit for integer values. Affects C9, C11 display, C18, and history row display.
3. **H4 — horizontal scroll**: Wrap history row `Text`s in a horizontal `Scroll` to match the spec's "可水平滚动" requirement instead of ellipsis truncation.
