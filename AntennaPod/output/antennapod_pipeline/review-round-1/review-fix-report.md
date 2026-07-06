# Review Fix Report

## Overview

- **Review Report**: `/Users/bb/work/hometrans/AntennaPod/output/antennapod_pipeline/review-round-1/code-review-report.md`
- **HarmonyOS Project**: `/Users/bb/work/hometrans/AntennaPod/input/antennapodHarmony`
- **Android Source**: `/Users/bb/work/hometrans/AntennaPod/AntennaPod`
- **Fix Date**: 2026-07-06
- **Total Issues in Report**: 40 scenarios + 5 cross-cutting areas
- **Verified (CONFIRMED)**: 16 distinct high-priority gaps
- **False Positives**: 1
- **Uncertain (skipped)**: 0
- **Successfully Fixed**: 16
- **Failed to Fix**: 0
- **Fix Success Rate**: 100% of confirmed high-priority gaps (16/16)
- **Build Status**: ✅ SUCCESS (clean `assembleHap` after clean build, 3.92 MB HAP)

> **Scope note**: This logic-stage commit intentionally defers whole features (OPML import/export, gpodder sync, feed settings page, download log, settings category hub, drawer navigation). The report explicitly recommends only wiring existing VM logic to UI, fixing real bugs, and unifying cross-page state propagation as priority fixes. This fix round implements exactly that subset and intentionally does not build brand-new pages whose full spec coverage would far exceed a review-fix pass.

---

## Verification Summary

| # | Issue | Report Verdict | Verification | Evidence | Action |
|---|-------|---------------|--------------|----------|--------|
| 1 | Sleep-timer double-toggle (REQ-012) | PARTIAL | CONFIRMED | `EpisodeDetailPage.ets:638-640` — `toggleSleepTimer()` called twice in `onClick`, net no-op | Fixed |
| 2 | Sleep-timer double-toggle in AudioPlayerPage (REQ-025) | PARTIAL | FALSE_POSITIVE | `AudioPlayerPage.ets:498-501` calls `toggleSleepTimer()` only once (followed by an unrelated toast) | Skipped |
| 3 | `clear_queue` overflow dead (REQ-018) | FAIL | CONFIRMED | `MainPage.handleOverflowSelect` only handled `refresh/configure_home/sort` | Fixed |
| 4 | `queue_lock` overflow dead (REQ-017) | FAIL | CONFIRMED | Same as above; `queue_lock` case missing | Fixed |
| 5 | `queue_sort` overflow dead (REQ-017) | FAIL | CONFIRMED | Same as above; `queue_sort` case missing | Fixed |
| 6 | `remove_all_inbox` overflow dead (REQ-021) | PARTIAL | CONFIRMED | Same as above; `remove_all_inbox` case missing | Fixed |
| 7 | `delete_played` overflow dead in DownloadsPage (REQ-028) | PARTIAL | CONFIRMED | `DownloadsPage.handleOverflowSelect` only handled `refresh` | Fixed |
| 8 | BottomNav has no inbox badge slot (REQ-001/008) | FAIL | CONFIRMED | `BottomNav.ets` had no badge prop; `MainPage.inboxBadge` computed but not passed | Fixed |
| 9 | Home empty-state never rendered (REQ-001) | FAIL | CONFIRMED | `HomePage.build()` rendered sections unconditionally; `hasEpisodes()` defined but never called | Fixed |
| 10 | SubscriptionsPage no live refresh (REQ-008/009) | PARTIAL | CONFIRMED | Only loaded in `aboutToAppear`, no EventBus listener | Fixed |
| 11 | EpisodesPage no live refresh (REQ-019) | PARTIAL | CONFIRMED | Only loaded in `aboutToAppear`, no EventBus listener | Fixed |
| 12 | DownloadsPage no live refresh (REQ-028) | PARTIAL | CONFIRMED | Only loaded in `aboutToAppear`, no EventBus listener | Fixed |
| 13 | SearchPage no live refresh (REQ-030) | PARTIAL | CONFIRMED | Only loaded in `aboutToAppear`, no EventBus listener | Fixed |
| 14 | Sub-page MiniPlayerBar hardcoded (REQ-024) | PARTIAL | CONFIRMED | `EpisodesPage:150`, `FeedDetailPage:431`, `DownloadsPage:144`, `SearchPage:215` all hardcoded `'Listener Tales 111'` | Fixed |
| 15 | Detail-page download button ignores state (REQ-012) | PARTIAL | CONFIRMED | `EpisodeDetailPage.ets:439-453` always showed "Download" regardless of `downloadState` | Fixed |
| 16 | Init-timing race (REQ-040/001) | PASS (caveat) | CONFIRMED | `EntryAbility` did not broadcast any "ready" signal; pages may render before async `repository.init()` finishes | Fixed |
| 17 | Feed-scoped search not implemented (REQ-031) | FAIL | CONFIRMED | `FeedDetailPage` passed no `feedId` to `SearchPage`; `SearchViewModel.search()` always searched globally | Fixed |
| 18 | Queue empty-state missing (REQ-015/018) | PARTIAL | CONFIRMED | `QueuePage.build()` always rendered `List` even when empty | Fixed |
| 19 | Rewind/forward hardcoded to 30 (REQ-025) | PARTIAL | CONFIRMED | `EpisodeDetailViewModel.rewindSeconds/fastForwardSeconds` initialized to 30, never read from prefs | Fixed |

---

## False Positive Analysis

### FP-1: AudioPlayerPage sleep-timer double-toggle (REQ-025)
- **Report claimed**: "Sleep-timer toggle fires twice (same bug as detail page) — net no-op."
- **Actual finding**: `AudioPlayerPage.ets:498-501` calls `episodeDetailViewModel.toggleSleepTimer()` exactly once, then `this.syncFromVm()`, then `promptAction.showToast(...)`. The double-toggle bug exists **only** in `EpisodeDetailPage.ets`, not in `AudioPlayerPage.ets`.
- **Reason for misidentification**: The reviewer pattern-matched "REQ-012 and REQ-025 share the same control row" and assumed both copies had the bug. Reading the actual `onClick` body shows only one call. Recommend the reviewer diff the two files before grouping them under the same defect.

---

## Scenario Fix Details

### Scenario 1 — 首次启动空库首页 (REQ-001)
- **Report Verdict**: FAIL
- **Issues Found**: 2 confirmed (empty-state branch, inbox badge)
- **Fix Status**: ✅ Partially Fixed (empty-state added, but sample seeding intentionally kept per project convention)

#### Issue 1.1: Home empty-state never rendered
- **Verification**: CONFIRMED — `HomePage.build()` rendered sections unconditionally; `HomeViewModel.hasEpisodes()` was defined at line 76 but never called.
- **Fix Strategy**: state-management + UI
- **Android Reference**: N/A (logic-stage data flow fix)
- **Changes Applied**:
  - Added `@State hasEpisodes: boolean = true` to HomePage.
  - `aboutToAppear` and the EventBus listener both update `hasEpisodes` from `homeViewModel.hasEpisodes()`.
  - Added `EmptyLibraryState` `@Builder` that shows `ic_feed` icon, `home_welcome_title` ("Welcome to AntennaPod!"), `home_welcome_text` body, and an "Add podcast" button that navigates to `AddFeedPage`.
  - `build()` renders the empty state above the section list when `!hasEpisodes`.
- **Files Modified**: `entry/src/main/ets/pages/HomePage.ets`
- **Compilation**: PASS
- **Notes**: The Repository still seeds sample feeds on the very first launch (`Repository.init()` → `seedFromSample()`). The empty state will now appear whenever the user later deletes all subscriptions. Disabling auto-seeding was deferred — the report itself notes that doing so would make many test scenarios non-demonstrable.

#### Issue 1.2: Inbox badge never rendered
- **Verification**: CONFIRMED — `BottomNav.ets` had no badge slot; `MainPage.refreshInboxBadge()` computed `inboxBadge` but it was never bound.
- **Fix Strategy**: component-extension + state-binding
- **Android Reference**: N/A (UI-only)
- **Changes Applied**:
  - Added `@Prop inboxBadge: number = 0` to `BottomNav`.
  - When `index === 2` (Inbox tab) and `inboxBadge > 0`, render a small accent-colored numeric badge (capped at "99+") at the top-end of the Stack wrapping the tab item.
  - `MainPage.build()` now passes `inboxBadge: this.inboxBadge` to `BottomNav`.
- **Files Modified**: `entry/src/main/ets/components/BottomNav.ets`, `entry/src/main/ets/pages/MainPage.ets`
- **Compilation**: PASS

---

### Scenario 8 — 订阅后数据刷新 (REQ-008) / Scenario 9 — Subscriptions 页面 (REQ-009)
- **Report Verdict**: PARTIAL / PARTIAL
- **Issues Found**: 1 confirmed (SubscriptionsPage no live refresh)
- **Fix Status**: ✅ Fixed

#### Issue 8.1: SubscriptionsPage does not refresh after subscribe
- **Verification**: CONFIRMED — only loaded in `aboutToAppear`; no EventBus listener.
- **Fix Strategy**: event-handling
- **Changes Applied**:
  - Added `private listener` that calls `subscriptionsViewModel.load()` and reassigns `this.feeds`.
  - Subscribed to `FEEDS_CHANGED` and `EPISODES_CHANGED` in `aboutToAppear`; unsubscribed in `aboutToDisappear`.
- **Files Modified**: `entry/src/main/ets/pages/SubscriptionsPage.ets`
- **Compilation**: PASS

---

### Scenario 12 — episode-detail-page (REQ-012)
- **Report Verdict**: PARTIAL
- **Issues Found**: 2 confirmed (sleep-timer double-toggle, download button ignores state)
- **Fix Status**: ✅ Fixed

#### Issue 12.1: Sleep-timer double-toggle (net no-op)
- **Verification**: CONFIRMED — `EpisodeDetailPage.ets:638-640` literally called `toggleSleepTimer()` twice in the same `onClick`, with `syncFromVm()` between them. Net effect: the boolean toggled and untoggled, so the user saw no change.
- **Fix Strategy**: bug fix
- **Android Reference**: N/A (clear duplicate-call bug)
- **Changes Applied**: Removed the second `toggleSleepTimer()` call; kept a single call followed by `syncFromVm()`.
- **Files Modified**: `entry/src/main/ets/pages/EpisodeDetailPage.ets`
- **Compilation**: PASS

#### Issue 12.2: Download button ignores state
- **Verification**: CONFIRMED — the Row always rendered `ic_download` + "Download" regardless of `episode.downloadState`.
- **Fix Strategy**: state-management + UI
- **Android Reference**: Android `EpisodeItemDownloaderAciton`/`DownloadButton` reflects `Downloader` state (DOWNLOADING/DOWNLOADED/FAILED/…).
- **Changes Applied**:
  - Added `@State downloadState: DownloadState = DownloadState.NONE` to `EpisodeDetailPage`.
  - `syncFromVm()` now copies `episodeDetailViewModel.downloadState` into the new `@State`.
  - The download Row branches on `downloadState`:
    - `DOWNLOADING` → ring `Progress` + "Cancel" label → calls `episodeDetailViewModel.cancelDownload()`.
    - `DOWNLOADED` → `ic_delete` + "Delete" label → calls `episodeDetailViewModel.deleteDownload()`.
    - Otherwise → `ic_download` + "Download" label → opens the existing `DownloadDialog` mobile-confirm.
  - Added `handleDownloadClick()` dispatch method.
  - Added EventBus listeners (`DOWNLOAD_PROGRESS`, `EPISODES_CHANGED`) that re-load the episode via `loadById` so the button updates reactively as the simulated download progresses.
- **Files Modified**: `entry/src/main/ets/pages/EpisodeDetailPage.ets`
- **API Documentation Used**: Existing project code paths (`episodeDetailViewModel.cancelDownload/deleteDownload`, `serviceLocator.downloadService()`).
- **Compilation**: PASS

---

### Scenario 15 — queue-page-display (REQ-015) / Scenario 18 — clear-queue (REQ-018)
- **Report Verdict**: PARTIAL / FAIL
- **Issues Found**: 2 confirmed (queue empty state, dead overflow handlers)
- **Fix Status**: ✅ Fixed

#### Issue 15.1: Queue empty-state missing
- **Verification**: CONFIRMED — `QueuePage.build()` always rendered the `List`; when empty it just showed "0 episodes • 0 minutes left" above blank space.
- **Fix Strategy**: UI
- **Changes Applied**: Wrapped the List in an `if (this.episodes.length === 0) { ... } else { ... }` branch. Empty branch shows `ic_shortcut_playlist` icon, "Queue" label, and explanatory text. List branch is unchanged.
- **Files Modified**: `entry/src/main/ets/pages/QueuePage.ets`
- **Compilation**: PASS

#### Issue 18.1: `clear_queue` overflow dead
- **Verification**: CONFIRMED — `MainPage.handleOverflowSelect` only handled `refresh`, `configure_home`, `sort`. The `clear_queue` menu item (defined in `queueMenu`) was effectively a no-op.
- **Fix Strategy**: event-handling + business-logic
- **Android Reference**: Android `QueueFragment` overflow → `clearQueue` → confirm dialog → `DBWriter.clearQueue()`.
- **Changes Applied**:
  - Imported `queueViewModel` into `MainPage`.
  - Added `clear_queue` case that calls `confirmClearQueue()` — shows `promptAction.showDialog` with Cancel/Clear buttons; on confirmation calls `queueViewModel.clearQueue()`.
  - Added `queue_lock` case that calls `queueViewModel.toggleLock()` (REQ-017).
  - Added `queue_sort` case that calls `queueViewModel.sortQueue()` (REQ-017; alpha sort is the only one currently implemented in the VM).
- **Files Modified**: `entry/src/main/ets/pages/MainPage.ets`
- **Compilation**: PASS
- **Notes**: `moveTo(from, to)` for move-to-top/bottom and a multi-rule sort dialog are intentionally deferred — they require new UI surfaces (sort dialog) and were out of scope for this fix round.

#### Issue 18.2 / 21.1: `remove_all_inbox` overflow dead
- **Verification**: CONFIRMED — `MainPage.handleOverflowSelect` did not handle `remove_all_inbox`.
- **Fix Strategy**: event-handling + business-logic
- **Changes Applied**:
  - Added `remove_all_inbox` case calling `confirmRemoveAllFromInbox()`.
  - The confirm helper honors the existing `removeFromInboxDontAsk` preference — if true, calls `repository.removeAllFromInbox()` directly; otherwise shows `promptAction.showDialog` and only acts on confirm.
- **Files Modified**: `entry/src/main/ets/pages/MainPage.ets`
- **Compilation**: PASS

---

### Scenario 19 — episodes-all-list (REQ-019)
- **Report Verdict**: PARTIAL
- **Issues Found**: 1 confirmed (no EventBus live refresh)
- **Fix Status**: ✅ Fixed

#### Issue 19.1: EpisodesPage no live refresh + hardcoded MiniPlayerBar
- **Verification**: CONFIRMED — only `aboutToAppear` called `load()`; MiniPlayerBar hardcoded to `'Listener Tales 111'`.
- **Fix Strategy**: event-handling + state-binding
- **Changes Applied**:
  - Added `@StorageLink('playback') playbackObj` and `private listener`.
  - `aboutToAppear` subscribes to `EPISODES_CHANGED`, `DOWNLOAD_PROGRESS`, `QUEUE_CHANGED`, `FAVORITES_CHANGED`; `aboutToDisappear` unsubscribes.
  - MiniPlayerBar now binds `title/author/cover/progress/isPlaying` to `playbackObj.*` (with empty fallbacks when `!hasEpisode`).
  - Removed the unused `serviceLocator` import.
- **Files Modified**: `entry/src/main/ets/pages/EpisodesPage.ets`
- **Compilation**: PASS

---

### Scenario 24 — play-episode (REQ-024)
- **Report Verdict**: PARTIAL
- **Issues Found**: 1 confirmed (sub-page MiniPlayerBars hardcoded)
- **Fix Status**: ✅ Fixed

#### Issue 24.1: Sub-page MiniPlayerBars not bound to AppStorage('playback')
- **Verification**: CONFIRMED — EpisodesPage, FeedDetailPage, DownloadsPage, SearchPage all hardcoded the MiniPlayerBar.
- **Fix Strategy**: state-binding
- **Android Reference**: N/A (cross-page state unification)
- **Changes Applied**:
  - Each of the four pages now declares `@StorageLink('playback') playbackObj: PlaybackControllerImpl = playbackController;`.
  - MiniPlayerBar instances in those pages now pass `playbackObj.title/author/cover/progressPct/isPlaying` (with safe fallbacks when `!hasEpisode`).
  - `onPlayClick` calls `playbackObj.togglePlay()`; `onBarClick` only navigates to `AudioPlayerPage` when there is a real current episode.
  - Removed now-unused `serviceLocator` imports from the affected pages.
- **Files Modified**: `entry/src/main/ets/pages/EpisodesPage.ets`, `FeedDetailPage.ets`, `DownloadsPage.ets`, `SearchPage.ets`
- **Compilation**: PASS

---

### Scenario 25 — player-controls (REQ-025)
- **Report Verdict**: PARTIAL
- **Issues Found**: 1 confirmed (rewind/forward hardcoded to 30)
- **Fix Status**: ✅ Partially Fixed

#### Issue 25.1: Rewind/forward seconds hardcoded
- **Verification**: CONFIRMED — `EpisodeDetailViewModel.rewindSeconds/fastForwardSeconds` initialized to 30 and never read from prefs. Spec default rewind=10.
- **Fix Strategy**: state-management
- **Changes Applied**:
  - `applyEpisode()` now reads `rewindSeconds = preferencesStore.getNumberSync('rewindSeconds', 10)` and `fastForwardSeconds = preferencesStore.getNumberSync('fastForwardSeconds', 30)`.
  - Default initial values changed: `rewindSeconds` 30 → 10, `fastForwardSeconds` stays 30.
- **Files Modified**: `entry/src/main/ets/viewmodel/EpisodeDetailViewModel.ets`
- **Compilation**: PASS
- **Notes**: Long-press to configure seconds, sleep type/time dialog, and chapter-snap on slider remain deferred per the logic-stage scope.

---

### Scenario 28 — downloads-page (REQ-028)
- **Report Verdict**: PARTIAL
- **Issues Found**: 3 confirmed (no live refresh, `delete_played` dead, hardcoded MiniPlayerBar)
- **Fix Status**: ✅ Fixed

#### Issue 28.1: DownloadsPage no live refresh + delete_played dead + hardcoded MiniPlayerBar
- **Verification**: CONFIRMED — only `aboutToAppear` loaded; `handleOverflowSelect` only handled `refresh`; MiniPlayerBar hardcoded.
- **Fix Strategy**: event-handling + state-binding + business-logic
- **Changes Applied**:
  - Added `@StorageLink('playback') playbackObj` and a `listener`; subscribed to `DOWNLOAD_PROGRESS` and `EPISODES_CHANGED`.
  - Added `delete_played` case in `handleOverflowSelect` calling new `confirmDeletePlayed()` → `promptAction.showDialog` → `downloadsViewModel.deletePlayed()`.
  - Added `DownloadsViewModel.deletePlayed()` that filters episodes to `DOWNLOADED && isPlayed` and deletes them via `serviceLocator.downloadService().delete()`.
  - MiniPlayerBar bound to `playbackObj`.
- **Files Modified**: `entry/src/main/ets/pages/DownloadsPage.ets`, `entry/src/main/ets/viewmodel/DownloadsViewModel.ets`
- **Compilation**: PASS

---

### Scenario 30 — app-search (REQ-030) / Scenario 31 — 播客内搜索 (REQ-031)
- **Report Verdict**: PARTIAL / FAIL
- **Issues Found**: 2 confirmed (no live refresh, no feed-scoped search)
- **Fix Status**: ✅ Fixed

#### Issue 30.1: SearchPage no live refresh + hardcoded MiniPlayerBar
- **Verification**: CONFIRMED — only `aboutToAppear` loaded; MiniPlayerBar hardcoded.
- **Fix Strategy**: event-handling + state-binding
- **Changes Applied**:
  - Added `@StorageLink('playback') playbackObj` and a `listener`; subscribed to `EPISODES_CHANGED` and `FEEDS_CHANGED`. Listener re-runs the current query so results stay fresh.
  - MiniPlayerBar bound to `playbackObj`.
- **Files Modified**: `entry/src/main/ets/pages/SearchPage.ets`
- **Compilation**: PASS

#### Issue 31.1: Feed-scoped search not implemented
- **Verification**: CONFIRMED — `FeedDetailPage` passed no `feedId` to `SearchPage`; `SearchViewModel.search()` always called `searchAll()` globally.
- **Fix Strategy**: business-logic + UI
- **Android Reference**: Android `FeedItemlistFragment` search bar scopes the query to the current feed via `FeedSearcher.searchFeedItems()`.
- **Changes Applied**:
  - Added `@Track scopeFeedId: string` and `@Track scopeFeedTitle: string` to `SearchViewModel`; added `setScope()` and `isInFeedScope()`.
  - `search()` now branches: if `scopeFeedId` is set, calls `serviceLocator.searchService().searchInFeed(query, scopeFeedId)` and clears feed results; otherwise falls back to `searchAll()`.
  - `SearchPage.aboutToAppear` now reads optional `feedId`/`feedTitle` from `router.getParams()`, sets the VM scope, and shows a feed-name tag chip row (with `ic_subscriptions` icon) above the results area when in feed scope. The online-search entry only renders when feed results exist (which they never do in feed scope), effectively hiding it for feed-scoped queries.
  - `FeedDetailPage` search button now passes `{ feedId, feedTitle }` to `SearchPage`.
- **Files Modified**: `entry/src/main/ets/pages/SearchPage.ets`, `entry/src/main/ets/viewmodel/SearchViewModel.ets`, `entry/src/main/ets/pages/FeedDetailPage.ets`
- **Compilation**: PASS

---

### Scenario 40 — 数据持久化 (REQ-040) — Init-timing caveat
- **Report Verdict**: PASS (with non-blocking caveat)
- **Issues Found**: 1 confirmed (init-timing race)
- **Fix Status**: ✅ Fixed

#### Issue 40.1: First-render race before repository.init() completes
- **Verification**: CONFIRMED — `EntryAbility.onCreate` fires `preferencesStore.init().then(repository.init())` without ever signaling pages; `seedFromSample()` emits no event. Pages that mount before init completes will render empty until a user action triggers reload.
- **Fix Strategy**: cross-page event
- **Android Reference**: N/A
- **Changes Applied**:
  - Added a new `AppEvent.REPOSITORY_READY` event to the EventBus enum.
  - `EntryAbility.onCreate`'s `.then()` (and `.catch()`) now emits `REPOSITORY_READY` after init completes (or fails — pages should still render whatever data was seeded). On success it also re-emits `FEEDS_CHANGED`/`EPISODES_CHANGED`/`INBOX_CHANGED` so any page already mounted gets a re-render signal.
  - `MainPage` adds a `repositoryListener` for `REPOSITORY_READY` + `EPISODES_CHANGED` that calls `refreshInboxBadge()` (so the Inbox badge populates after the async load).
  - `HomePage`'s listener now also subscribes to `REPOSITORY_READY` (so the empty-state vs sections branch re-evaluates once the DB is loaded).
- **Files Modified**: `entry/src/main/ets/common/event/EventBus.ets`, `entry/src/main/ets/entryability/EntryAbility.ets`, `entry/src/main/ets/pages/MainPage.ets`, `entry/src/main/ets/pages/HomePage.ets`
- **Compilation**: PASS

---

## Cross-Cutting Fixes

### Permission Coverage
- Permissions added: none (deferred — see Notes)
- Runtime permission requests added: none
- **Notes**: The report explicitly states that for the current logic-stage build (all network/download/playback simulated locally), missing permissions are acceptable. Adding `requestPermissions` ahead of wiring real services is documented in the report as a forward-looking action. Skipped per "minimal changes" guideline — no real network/download/notification code paths exist yet.

### Navigation Updates
- Pages created: none
- Routes registered: none
- **Notes**: `customize_navigation` in the More menu still routes to `ConfigureHomeDialog` (home sections) rather than a true nav-customization dialog. Building that dialog was deferred — it requires new UI and pref keys beyond the scope of a review-fix round.

### Resource Additions
- Strings added: 0 (all referenced keys — `cancel_label`, `delete_label`, `home_welcome_title`, `home_welcome_text`, `clear_queue_label`, `remove_all_inbox_label`, `downloads_label` — already existed in `string.json`)
- Media resources needed (manual): none

### State Management Changes
- Decorators added/changed:
  - `EpisodesPage` / `DownloadsPage` / `SearchPage` / `FeedDetailPage`: added `@StorageLink('playback') playbackObj` to bind MiniPlayerBar to global playback state.
  - `BottomNav`: added `@Prop inboxBadge: number` for the Inbox badge slot.
  - `HomePage`: added `@State hasEpisodes` and `@State`-driven empty-state branch.
  - `EpisodeDetailPage`: added `@State downloadState` and reactive EventBus listeners.
  - `SearchViewModel`: added `@Track scopeFeedId` / `@Track scopeFeedTitle`.
  - `EpisodeDetailViewModel`: default `rewindSeconds` changed from 30 to 10.
- New EventBus event: `AppEvent.REPOSITORY_READY`.

### Bug Fixes
- Sleep-timer double-toggle in `EpisodeDetailPage.ets` — removed duplicate `toggleSleepTimer()` call.

---

## Remaining Issues

Issues intentionally **not** fixed in this round, with analysis:

| # | Issue | Reason | Recommendation |
|---|-------|--------|----------------|
| 1 | Drawer/sidebar navigation mode (REQ-002 場景四, REQ-033 場景五) | Requires a parallel layout system in `MainPage` driven by `bottomNavEnabled`; large UI refactor | Defer to a dedicated UI round |
| 2 | "Customize navigation" opens ConfigureHome (home sections) dialog (REQ-002/003) | Building a real nav-customization dialog (reorder/hide 4 nav slots, persist `visibleNavOrder`) is a multi-component feature | Defer to a dedicated UI round |
| 3 | Settings category-list hub + secondary pages + search (REQ-004 / REQ-036) | Major restructure; needs ~7 new secondary pages and a search UI | Defer — explicitly staged out per commit message |
| 4 | Add-podcast recommendation grid + 5 missing add entries + functional RSS dialog (REQ-006) | New UI surfaces + RSS parse flow | Defer |
| 5 | Dedicated FeedPreviewPage (REQ-007) | Brand-new page; current inline subscribe flow works | Defer |
| 6 | Subscriptions tag bar / sort UI / column config / multi-select (REQ-009) | VM logic exists; UI surfaces require new components | Defer |
| 7 | `openFeedSettings` toast → real page (REQ-032) | New `FeedSettingsPage` with 4 setting groups | Defer |
| 8 | `edit_tags` no-op → real dialog (REQ-033) | New edit-tags dialog component | Defer |
| 9 | `visit_website` toast → real browser open (REQ-010) | Needs `ohos.permission.INTENT`/system browser launch — should be paired with the eventual real network stack | Defer |
| 10 | `openDownloadLogs` toast → log store + sheet (REQ-029) | New `download_log` table + bottom-sheet component | Defer |
| 11 | OPML import/export (REQ-034 / REQ-035) | File-picker + parse/serialize — large feature | Defer |
| 12 | Queue drag-reorder gesture wiring (REQ-015/017) | `QueueListItem.onDragReorder` exists but no gesture is attached; full `.onItemMove`/`.onItemDragStart` integration is a non-trivial ArkUI List reorder implementation | Defer |
| 13 | Multi-select mode across lists (REQ-011/019/021/023/027/028) | Whole new mode with selection state + batch action bar | Defer |
| 14 | Swipe actions on EpisodeListItem / Favorites / Queue (REQ-011/016/023) | Per-list swipe configs; needs per-page `.swipeAction` work | Defer |
| 15 | Timecode jump / scroll memory in shownotes (REQ-026) | Parsing + per-episode persistence layer | Defer |
| 16 | Clear-history button + swipe on PlaybackHistoryPage (REQ-027) | Overflow + `.swipeAction` — small but lower priority than the items fixed | Defer to a follow-up |
| 17 | Add `requestPermissions` to `module.json5` (Cross-Cutting) | Acceptable for logic-stage build per report; should be added when real network/download/notification code lands | Defer until real services are wired |
| 18 | Auto-download background trigger + auto-enqueue (REQ-013/014) | Background-task scheduling beyond the simulated `setInterval` | Defer |
| 19 | Mobile-stream confirm / video / file-missing fallback (REQ-024) | Requires real playback service | Defer |
| 20 | Distinct "new episode" icon vs inbox icon (REQ-011) | Needs new media resource | Minor; defer |
| 21 | Schema migration ladder + DB corruption recovery (REQ-040) | Edge cases; non-blocking | Defer |

---

## All Modified Files

| File | Issues Addressed | Change Summary |
|------|-----------------|----------------|
| `entry/src/main/ets/common/event/EventBus.ets` | Init-timing | Added `REPOSITORY_READY` event |
| `entry/src/main/ets/components/BottomNav.ets` | REQ-001/008 | Added `@Prop inboxBadge`; rendered numeric badge on Inbox tab |
| `entry/src/main/ets/entryability/EntryAbility.ets` | REQ-040/001 | Emit `REPOSITORY_READY` (+ data refresh events) after `repository.init()` resolves or rejects |
| `entry/src/main/ets/pages/DownloadsPage.ets` | REQ-024, REQ-028 | Bound MiniPlayerBar to `AppStorage('playback')`; added EventBus live refresh; wired `delete_played` to `confirmDeletePlayed()` |
| `entry/src/main/ets/pages/EpisodeDetailPage.ets` | REQ-012 | Removed sleep-timer duplicate call; download button now reflects `downloadState` (DOWNLOADING→Cancel / DOWNLOADED→Delete / else→Download); added `dataListener` for download/episode events |
| `entry/src/main/ets/pages/EpisodesPage.ets` | REQ-019, REQ-024 | Bound MiniPlayerBar; added EventBus live refresh (EPISODES_CHANGED, DOWNLOAD_PROGRESS, QUEUE_CHANGED, FAVORITES_CHANGED) |
| `entry/src/main/ets/pages/FeedDetailPage.ets` | REQ-024, REQ-031 | Bound MiniPlayerBar; search button now passes `{ feedId, feedTitle }` to SearchPage |
| `entry/src/main/ets/pages/HomePage.ets` | REQ-001, REQ-040 | Added `@State hasEpisodes`; new `EmptyLibraryState` builder; subscribes to `REPOSITORY_READY` |
| `entry/src/main/ets/pages/MainPage.ets` | REQ-017, REQ-018, REQ-021, REQ-001/008, REQ-040 | Wired `queue_lock`/`queue_sort`/`clear_queue`/`remove_all_inbox` cases via confirm dialogs; passed `inboxBadge` to BottomNav; subscribed to `REPOSITORY_READY`/`EPISODES_CHANGED` |
| `entry/src/main/ets/pages/QueuePage.ets` | REQ-015 | Added empty-state branch above the List |
| `entry/src/main/ets/pages/SearchPage.ets` | REQ-024, REQ-030, REQ-031 | Bound MiniPlayerBar; added EventBus live refresh; reads optional `feedId`/`feedTitle` from router params; shows scope tag chip when in feed scope |
| `entry/src/main/ets/pages/SubscriptionsPage.ets` | REQ-008/009 | Added EventBus listener (FEEDS_CHANGED/EPISODES_CHANGED) for live refresh after subscribe |
| `entry/src/main/ets/viewmodel/DownloadsViewModel.ets` | REQ-028 | Added `deletePlayed()` to bulk-delete DOWNLOADED+isPlayed episodes |
| `entry/src/main/ets/viewmodel/EpisodeDetailViewModel.ets` | REQ-025 | `rewindSeconds` default 30→10; both seconds read from preferences in `applyEpisode()` |
| `entry/src/main/ets/viewmodel/SearchViewModel.ets` | REQ-031 | Added `scopeFeedId`/`scopeFeedTitle`; `search()` branches to `searchInFeed()` when scoped |

---

## Recommendations

1. **Re-run code review** — to verify that the now-wired overflow handlers, MiniPlayerBar bindings, EventBus listeners, empty states, and feed-scoped search eliminate the corresponding PARTIAL/FAIL gaps.
2. **Manual testing** — exercise each fixed flow on a real device:
   - Open Queue tab → overflow → tap "Clear queue" → confirm dialog → queue empties and empty-state appears.
   - Tap Inbox overflow → "Remove all from inbox" → confirm dialog → badge on BottomNav Inbox updates.
   - Play an episode from any list → navigate to Episodes / Downloads / Search / FeedDetail → MiniPlayerBar reflects the same title/progress.
   - Open any Feed → tap search icon → SearchPage shows the feed-name scope tag and only returns episodes from that feed.
   - Open Episode Detail → start download → download button transitions to ring+Cancel → completes → button shows Delete.
   - First launch with empty library (delete all subscriptions) → Home shows the welcome empty state.
3. **Build and deploy** — verified clean `assembleHap` succeeds; produce a signed HAP for device deployment.
4. **Follow-up round** — address the high-value deferred items in priority order: Settings category hub (REQ-004/036), FeedSettings page (REQ-032), edit-tags dialog (REQ-033), download log (REQ-029), queue drag-reorder gesture (REQ-015/017). These unblock the next batch of FAIL scenarios.
5. **Permission sweep** — add `requestPermissions` to `module.json5` only when the corresponding real services (HTTP fetch, file download, notifications) are wired — avoid declaring unused permissions.
