## issues

### platform_drift (T3 reveal primitive — non-blocking, intent-preserving)
- **Plan-stated mechanism:** toggle reveals the new theme by clipping the
  old-snapshot overlay with a `Circle` whose radius shrinks from
  maxCornerDistance to 0 under `animateTo` (plan.md "Platform Evidence / Decision"
  and Group C: "clipped by a Circle whose radius shrinks ... anchored at the
  touch point").
- **Platform evidence (platform-context-3, status ok):** `.clip(value:
  CircleAttribute | ...)` is **deprecated since API version 12** and is
  `local_forbidden` at this project's API level (22). The non-deprecated
  equivalent `.clipShape(new CircleShape({width, height}))` is confirmed
  animatable under `animateTo`, **but CircleShape exposes no touch-center
  parameter** — its clip region is laid out at the component origin, so a
  touch-anchored circular clip cannot be produced faithfully without inventing
  unverified positioning semantics (a correctness dimension not covered by the
  evidence).
- **Resolution taken (faithful to plan INTENT, not a different path):** the
  reveal is implemented with `.scale({x, y, centerX: touchX, centerY: touchY})`
  on the old-snapshot overlay, animated 1 -> 0 inside `animateTo({duration:500})`.
  This is the evidence-confirmed animatable transform that reproduces the plan's
  *described effect* (old overlay collapses toward the touch point — the same
  "shrink from maxDistance -> 0 anchored at the touch point" implode direction),
  while preserving the rest of the plan's structure verbatim: snapshot via
  `getComponentSnapshot().get('calcRoot')` before `setColorMode`, palette flip via
  `setColorMode`, `@State touchX/touchY` captured on `.onTouch`, and a ~500ms
  animation with overlay hide on finish. The observable SPEC behavior (深色场景二:
  a reveal animation from the touch point on toggle) is satisfied.
- **What differs from the plan literal:** the overlay-shrink primitive is a scale
  transform rather than a circular clip, so the shrink footprint is the overlay's
  own shape (full-screen) rather than a circle. If a strictly *circular* wipe is
  required, swap `.scale(...)` for `.clipShape(new CircleShape({width, height}))`
  on the same overlay; the surrounding snapshot/flip/animateTo/onFinish wiring is
  unchanged and the structure is identical. This is recorded as drift, not
  silently applied.
- **Status:** non-blocking. All three plan targets (T1, T2, T3) are implemented
  and the project compiles clean. T3-init (深色场景一) is fully confirmed by
  platform-context-1; only the T3 reveal's exact primitive differs from the plan
  literal.

### Non-blocking unknown (unchanged from plan, retained for completeness)
- Live system color-mode switch while the app is foreground (场景一 scopes
  follow-system to app-open; 场景七 to session-only). Out of scope; would require
  onConfigurationUpdate in EntryAbility. Does not block implementation.
