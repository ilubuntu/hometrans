commit_id: dd5df0c59e3860aac529efee294d322048df01d9

Decision contract: /Users/bb/work/hometrans/calculate/output/calculator_pipeline/logic/plan.md
Project: /Users/bb/work/hometrans/calculate/input/calculatorHarmony
Build: hvigor assembleHap (unsigned) — BUILD SUCCESSFUL, CompileArkTS clean
       (only deprecation WARNs on router.getParams/back/pushUrl, which the plan
       mandates and forbids replacing with Navigation/UIContext.Router).

## Files changed (all plan-required)
- entry/src/main/ets/viewmodel/CalculatorViewModel.ets  (T1 isComplete; T2 save)
- entry/src/main/ets/model/HistoryRepository.ets         (T2 new singleton owner)
- entry/src/main/ets/viewmodel/HistoryViewModel.ets      (T2 load/clear via repo)
- entry/src/main/ets/pages/HistoryPage.ets               (T2 restore onClick)
- entry/src/main/ets/pages/Index.ets                     (T2 onPageShow; T3 init+reveal)

## Completion evidence mapped to plan
- T1 isComplete() = `length>0 && endsWith(lastOperator) && result!=='0'`.
  - "1 ÷ " (result "0") + `=` -> isComplete false -> performEquals returns early;
    expression stays "1 ÷ ", result "0" (基础场景十 ✓).
  - "1 + 2" (expr "1 + ", result "2") + `=` -> evaluates; expression="1 + 2",
    result="3"; repo.add({expression:"1 + 2", result:"3"}) (场景九 ✓).
  - second `=` after result -> expression "1 + 2" no longer ends with operator ->
    isComplete false -> no-op (场景十一 ✓).
  - performButton invalid-result gate and post-evaluate digit/decimal/±/% lock
    depend on isNotEvaluated (unchanged) -> intact (场景十七/十九 ✓).
- T2: valid `=` -> repo gains one item with full expression + result; incomplete
  `=` returns before evaluate -> no add; invalid result gated by `!resultIsInvalid`.
  loadHistory = repo.getAll() (newest-last -> HistoryPage bottom = most recent);
  empty -> isEmpty -> "Nothing to show!". Item onClick router.back(params);
  Index.onPageShow applies expression/result -> restored VM is evaluated -> next
  `=` no-ops -> no re-save (场景六 ✓). Clear confirm -> repo.clear()+router.back
  (场景八 accepted deviation ✓).
- T3: aboutToAppear sets isDarkMode = (ctx.config.colorMode === COLOR_MODE_DARK);
  icon bound to isDarkMode (sun in dark). Toggle snapshots root (getComponentSnapshot,
  before setColorMode), flips isDarkMode+setColorMode, plays touch-anchored reveal
  over ~500ms; expression/result/history untouched (separate owners).

## Platform-context results (cited per "coder must verify")
- platform-context-1 (colorMode init): status ok. CONFIRMED local fact —
  UIAbilityContext.config.colorMode returns the RESOLVED COLOR_MODE_DARK(0) /
  COLOR_MODE_LIGHT(1) at aboutToAppear even when EntryAbility set COLOR_MODE_NOT_SET
  (never returns -1); getUIContext().getHostContext() is a valid UIAbilityContext
  for this read. Plan's `(=== COLOR_MODE_DARK)` check is valid — no change needed.
- platform-context-2 (snapshot + animatable clip): status ok. CONFIRMED —
  use `this.getUIContext().getComponentSnapshot().get(id): Promise<image.PixelMap>`;
  Image accepts a PixelMap src held in @State; snapshot must be taken BEFORE
  setColorMode to capture the old theme; import `image` from '@kit.ImageKit'.
- platform-context-3 (clip re-evaluation under animateTo): status ok. CHANGED the
  plan's literal primitive — `.clip(CircleAttribute)` is DEPRECATED since API 12
  (local_forbidden at API 22). Implemented the reveal via `.scale({centerX,centerY})`
  on the old-snapshot overlay (evidence-confirmed animatable, touch-anchored),
  matching the plan's described effect (old overlay collapses toward the touch
  point, "shrink from maxDistance -> 0 anchored at touch point"). See issues.md.

## Notes
- The harmony project was not a git repo; a repo was initialized in place and only
  the 5 plan-required .ets files were staged/committed (local.properties is
  gitignored and excluded; the rest of the project remains untracked).
- ArkTS-strict: all new state typed (image.PixelMap | undefined, number, boolean);
  RestoreParams interface + `as RestoreParams` cast for router.getParams(); inline
  object literals used only as typed attribute/param objects (matches existing
  code style).
