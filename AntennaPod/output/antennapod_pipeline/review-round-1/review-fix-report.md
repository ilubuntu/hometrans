# Review Fix Report

## Overview

- **Review Report**: `/Users/bb/work/hometrans/AntennaPod/output/antennapod_pipeline/review-round-1/code-review-report.md`
- **HarmonyOS Project**: `/Users/bb/work/hometrans/AntennaPod/input/antennapodHarmony`
- **Android Source**: `/Users/bb/work/hometrans/AntennaPod/AntennaPod`
- **Fix Date**: 2026-06-30
- **Total Issues in Report**: 12 priority issues (from 40 scenarios + cross-cutting)
- **Verified (CONFIRMED)**: 12
- **False Positives**: 0
- **Uncertain (skipped)**: 0
- **Successfully Fixed**: 12
- **Failed to Fix**: 0
- **Fix Success Rate**: 100%

## Verification Summary

| # | Issue | Report Priority | Verification | Evidence | Action |
|---|-------|----------------|--------------|----------|--------|
| 1 | Lifecycle typo `aboutToAboutToDisappear` | HIGH | CONFIRMED | All 6 pages use wrong name; framework never calls it → unsubscribe never fires | Fixed |
| 2 | RowMappers missing `isInQueue`/`isNew` | HIGH | CONFIRMED | `toFeedItem()` never sets either field; both stay false | Fixed |
| 3 | `EpisodeFilter.inQueue` unused in `buildWhere()` | HIGH | CONFIRMED | `buildWhere()` has no clause for `inQueue` | Fixed |
| 4 | Queue `add()` missing dedup/auto-sort/batch | MED | CONFIRMED | `add()` uses INSERT OR REPLACE without `contains()`; no sort pass; no `addBatch` | Fixed |
| 5 | Download error type lossy mapping | MED | CONFIRMED | `addDownloadLog` drops `errorType`; `getDownloadLog` maps all errors to `ERROR_UNKNOWN` | Fixed |
| 6 | Search missing podcast search + in-feed scope | MED | CONFIRMED | `search()` has no `feedId` param; no `searchFeeds` method | Fixed |
| 7 | Missing preference keys REQ-033/034/035 | MED | CONFIRMED | PrefKey enum + PreferencesRepository lack the keys | Fixed |
| 8 | Favorites `getFavorites(sort)` ignores sort | MED | CONFIRMED | Hard-codes `ORDER BY pub_date_ms DESC` | Fixed |
| 9 | Missing error types ERROR_CERTIFICATE/ERROR_BLOCKED | MED | CONFIRMED | Enum lacks both types (Scenario 39.10) | Fixed |
| 10 | OPML export missing htmlUrl + head date | MED | CONFIRMED | Query selects only title/download_url; no date in `<head>` | Fixed |
| 11 | History ordered by % not time; no completion timestamp | LOW | CONFIRMED | No `completed_date_ms` column; ordered by `played_completion` | Fixed |
| 12 | Queue missing moveToTop/moveToBottom/batch | MED | CONFIRMED | No convenience methods (Scenario 17) | Fixed |

---

## Scenario Fix Details

### HIGH-1: Lifecycle Typo — Event Subscription Leak

- **Report Verdict**: Cross-Cutting Issue #1 (HIGH)
- **Issues Found**: 1 confirmed out of 1 reported
- **Fix Status**: Fixed

#### Issue: `aboutToAboutToDisappear()` typo in all 6 pages
- **Verification**: CONFIRMED — grep found the typo in all 6 pages: `Index.ets:22`, `QueuePage.ets:21`, `InboxPage.ets:31`, `SubscriptionsPage.ets:24`, `AddPodcastPage.ets:21`, `MorePage.ets:16`. The ArkUI framework lifecycle callback is `aboutToDisappear()`, so the misspelled method is never invoked → `viewModel.onDisappear()` → `unsubscribeEvents()` never runs → EventBus subscriptions leak and accumulate on each page re-entry.
- **Fix Strategy**: Rename (mechanical)
- **Changes Applied**: Renamed `aboutToAboutToDisappear()` → `aboutToDisappear()` in all 6 pages.
- **Files Modified**:
  - `entry/src/main/ets/pages/Index.ets`
  - `entry/src/main/ets/pages/QueuePage.ets`
  - `entry/src/main/ets/pages/InboxPage.ets`
  - `entry/src/main/ets/pages/SubscriptionsPage.ets`
  - `entry/src/main/ets/pages/AddPodcastPage.ets`
  - `entry/src/main/ets/pages/MorePage.ets`

---

### HIGH-2: RowMappers Missing `isInQueue`/`isNew`

- **Report Verdict**: REQ-007 (PARTIAL), Cross-Cutting #4
- **Issues Found**: 1 confirmed out of 1 reported
- **Fix Status**: Fixed

#### Issue: `toFeedItem()` never sets `isInQueue` or `isNew`
- **Verification**: CONFIRMED — `RowMappers.ets:35-39` sets `isPlayed/isDownloaded/isFavorite/inHistory` but `isInQueue` and `isNew` are never assigned, so they stay `false` for every DB-read row. Queue/new badges cannot render.
- **Android Reference**: Android `FeedItem.isNew()` = `state == NEW (-1)`; `isInQueue` derived from `TAG_QUEUE`. In this HarmonyOS port, `read = 0` = unplayed/new (per the `EpisodeFilter.unplayed` comment "read = 0 (isNew inbox)"), so `isNew = (read == 0)`.
- **Fix Strategy**: State-mapping + SQL JOIN/subquery
- **Changes Applied**:
  - `RowMappers.toFeedItem()`: `isNew = (readState === 0)`; `isInQueue` read from an optional `in_queue` column (default false if absent, following the existing `feed_title` pattern).
  - All episode-reading queries (`getEpisodes`, `getRecentlyPublished`, `getEpisode`, `search`, plus `QueueRepository.getQueue`, `FavoritesRepository.getFavorites`, `HistoryRepository.getHistory`) now include `EXISTS (SELECT 1 FROM Queue WHERE feeditem_id = fi.id) AS in_queue` (or `1 AS in_queue` for the queue read).
- **Files Modified**:
  - `entry/src/main/ets/data/repository/RowMappers.ets`
  - `entry/src/main/ets/data/repository/EpisodeRepository.ets`
  - `entry/src/main/ets/data/repository/QueueRepository.ets`
  - `entry/src/main/ets/data/repository/FavoritesRepository.ets`
  - `entry/src/main/ets/data/repository/HistoryRepository.ets`

---

### HIGH-3: `EpisodeFilter.inQueue` Not Used in `buildWhere()`

- **Report Verdict**: REQ-019 (PARTIAL)
- **Issues Found**: 1 confirmed out of 1 reported
- **Fix Status**: Fixed

#### Issue: `buildWhere()` has no clause for `inQueue`
- **Verification**: CONFIRMED — `EpisodeRepository.ets:31-58` handles `unplayed/played/downloaded/notDownloaded/favorite/inHistory/feedId` but has no `inQueue` branch, so the "在队列/不在队列" filter dimension is broken.
- **Android Reference**: Android `FeedItemFilter` uses `showQueued`/`showNotQueued` to filter by `TAG_QUEUE` membership.
- **Fix Strategy**: SQL subquery filter
- **Changes Applied**: Added `if (filter.inQueue) { clauses.push('fi.id IN (SELECT feeditem_id FROM Queue)'); }` to `buildWhere()`. Also aliased the table in `getTotalCount` (`FROM FeedItem fi`) for consistent `fi.id` references.
- **Files Modified**:
  - `entry/src/main/ets/data/repository/EpisodeRepository.ets`

---

### MED-4: Queue `add()` Missing Duplicate-Skip, Auto-Sort, Batch

- **Report Verdict**: REQ-015 (PARTIAL)
- **Issues Found**: 4 confirmed out of 4 reported
- **Fix Status**: Fixed

#### Issue 4a: No duplicate-skip
- **Verification**: CONFIRMED — `add()` does `INSERT OR REPLACE` without calling `contains()` first, so re-adding an already-queued item silently moves it.
- **Android Reference**: `DBWriter.addQueueItem()` checks `itemListContains(queue, item.getId())` and skips.
- **Fix**: Guarded `add()` with `if (await this.contains(itemId)) return;` at the top.

#### Issue 4b: No auto-sort on add
- **Verification**: CONFIRMED — `add()` inserts without checking `keepQueueSorted`.
- **Android Reference**: `DBWriter.applySortOrder()` re-sorts the queue by `getQueueKeepSortedOrder()` when `isQueueKeepSorted()` is true.
- **Fix**: Added `applyKeepSorted(store)` after insert — reads `getKeepQueueSorted()` + `getQueueSortOrder()`, then rewrites positions 0..n-1 in sorted order.

#### Issue 4c: No batch add
- **Verification**: CONFIRMED — no `addBatch(ids[])` method exists.
- **Fix**: Added `addBatch(itemIds: number[])` that loops over `add()` (each item gets duplicate-skip).

#### Issue 4d: No "new → unplayed" marking
- **Verification**: N/A in this port's model — `isNew = (read == 0)` and `isPlayed = (read != 0)`. Since new items already have `read = 0`, the Android `NEW(-1) → UNPLAYED(0)` transition is a no-op here. No change needed.

- **Files Modified**:
  - `entry/src/main/ets/data/repository/QueueRepository.ets`

---

### MED-5: Download Error Type Lossy Mapping

- **Report Verdict**: REQ-023 (PARTIAL), REQ-039 (PARTIAL)
- **Issues Found**: 2 confirmed out of 2 reported
- **Fix Status**: Fixed

#### Issue 5a: Error type not persisted / lossy on read
- **Verification**: CONFIRMED — `addDownloadLog()` writes only numeric `reason`, dropping the `errorType` string. `getDownloadLog()` maps any non-zero reason to `ERROR_UNKNOWN`, collapsing forbidden/not-found/space errors to "unknown".
- **Fix Strategy**: Schema migration + faithful read/write
- **Changes Applied**:
  - Added `error_type TEXT NOT NULL DEFAULT 'none'` column to `DownloadResult` table (onCreate + onUpgrade v1→v2).
  - `addDownloadLog()` now persists `error_type` in the ValuesBucket.
  - `getDownloadLog()` reads the `error_type` column; falls back to `ERROR_UNKNOWN` only if the column is absent (backward compat).

#### Issue 5b: Missing `ERROR_CERTIFICATE` and `ERROR_BLOCKED` error types
- **Verification**: CONFIRMED — enum lacked both types.
- **Fix**: Added `ERROR_CERTIFICATE = 'error_certificate'` and `ERROR_BLOCKED = 'error_blocked'` to the `DownloadErrorType` enum. Also added `isUnrecoverableError()` classifier (Scenario 39.2 contract) mirroring Android's fail-fast set.

- **Files Modified**:
  - `entry/src/main/ets/data/db/PodcastDatabase.ets` (schema v1→v2 + migration)
  - `entry/src/main/ets/data/repository/DownloadRepository.ets`
  - `entry/src/main/ets/model/EpisodeModel.ets`

---

### MED-6: Search Missing Podcast Search and In-Feed Scope

- **Report Verdict**: REQ-027 (PARTIAL), REQ-028 (PARTIAL)
- **Issues Found**: 2 confirmed out of 2 reported
- **Fix Status**: Fixed

#### Issue 6a: No podcast/feed search
- **Verification**: CONFIRMED — `SearchRepository`/`FeedRepository` exposed no feed search method.
- **Android Reference**: Spec 场景 2.5 requires feeds matched by title/custom-title/author/description.
- **Fix**: Added `FeedRepository.searchFeeds(query, max)` — multi-word AND LIKE on title/custom_title/author/description, title-ascending, capped at 300, parameterised. Exposed via `SearchRepository.searchFeeds()`.

#### Issue 6b: No in-feed scoped search
- **Verification**: CONFIRMED — `search()` had no `feedId` scope parameter.
- **Android Reference**: Spec 场景 2.4 requires search limited to one feed.
- **Fix**: Added optional `feedId?: number` parameter to `EpisodeRepository.search()` — appends `AND fi.feed_id = ?` when > 0. Exposed via `SearchRepository.searchInFeed(feedId, query)`.

- **Files Modified**:
  - `entry/src/main/ets/data/repository/EpisodeRepository.ets`
  - `entry/src/main/ets/data/repository/FeedRepository.ets`
  - `entry/src/main/ets/data/repository/SearchRepository.ets`

---

### MED-7: Missing Preference Keys (REQ-033/034/035)

- **Report Verdict**: REQ-033, REQ-034, REQ-035 (all PARTIAL)
- **Issues Found**: 3 confirmed out of 3 reported
- **Fix Status**: Fixed

#### Issue 7a: REQ-033 missing keys
- **Verification**: CONFIRMED — PrefKey/PreferencesRepository lacked: show-remaining-time, default-episode-sort, prefer-streaming, notification-buttons, swipe-left/right-action. Also `setTheme()`/`setPureBlack()` did not publish a refresh event.
- **Fix**: Added `SHOW_REMAINING_TIME`, `DEFAULT_EPISODE_SORT`, `PREFER_STREAMING`, `NOTIFICATION_BUTTONS`, `SWIPE_LEFT_ACTION`, `SWIPE_RIGHT_ACTION` keys + typed getters/setters. `setTheme()` and `setPureBlack()` now publish `FEED_LIST_UPDATE` for immediate rebuild.

#### Issue 7b: REQ-034 missing keys
- **Verification**: CONFIRMED — no headset/Bluetooth auto-resume preference keys.
- **Fix**: Added `RESUME_AFTER_HEADSET_CONNECT`, `RESUME_AFTER_BLUETOOTH_CONNECT` keys + getters/setters.

#### Issue 7c: REQ-035 missing keys
- **Verification**: CONFIRMED — no update-interval, HTTP proxy, storage-dir preference keys.
- **Fix**: Added `UPDATE_INTERVAL`, `PROXY_HOST`, `PROXY_PORT`, `STORAGE_DIR` keys + getters/setters.

- **Files Modified**:
  - `entry/src/main/ets/data/prefs/PreferencesStore.ets`
  - `entry/src/main/ets/data/repository/PreferencesRepository.ets`

---

### MED-8: Favorites `getFavorites(sort)` Ignores Sort Parameter

- **Report Verdict**: REQ-024 (PARTIAL)
- **Fix Status**: Fixed

- **Verification**: CONFIRMED — hard-coded `ORDER BY pub_date_ms DESC` regardless of passed sort.
- **Fix**: Added private `buildOrderBy(sort)` matching the `SortOrder` enum, applied to the query.
- **Files Modified**: `entry/src/main/ets/data/repository/FavoritesRepository.ets`

---

### MED-9: OPML Export Missing `htmlUrl` + Head Date

- **Report Verdict**: REQ-032 (PARTIAL)
- **Fix Status**: Fixed

- **Verification**: CONFIRMED — query selected only `title, download_url`; `<head>` had no creation date; no `htmlUrl` attribute.
- **Fix**: Query now selects `link`; export emits `htmlUrl="<link>"` when non-empty. `<head>` now includes `<dateCreated>` with an RFC822-formatted date.
- **Files Modified**: `entry/src/main/ets/data/repository/OpmlRepository.ets`

---

### LOW-10: History Ordered by % Not Time; No Completion Timestamp

- **Report Verdict**: REQ-026 (PARTIAL)
- **Fix Status**: Fixed

- **Verification**: CONFIRMED — `getHistory()` ordered by `played_completion DESC` (a 0–100 percentage, not a time). No `completed_date_ms` column.
- **Fix**: Added `completed_date_ms INTEGER NOT NULL DEFAULT 0` column to FeedItem (onCreate + onUpgrade v1→v2). `HistoryRepository.addItem()` now sets it to `Date.now()`. `getHistory()` now orders by `completed_date_ms DESC, pub_date_ms DESC`.
- **Files Modified**:
  - `entry/src/main/ets/data/db/PodcastDatabase.ets`
  - `entry/src/main/ets/data/repository/HistoryRepository.ets`

---

### MED-11: Queue Missing moveToTop/moveToBottom/Batch

- **Report Verdict**: REQ-017 (PARTIAL)
- **Fix Status**: Fixed

- **Verification**: CONFIRMED — no `moveToTop`/`moveToBottom`/batch move methods.
- **Fix**: Added `moveToTop(itemId)`, `moveToBottom(itemId)`, `moveBatchToTop(ids[])`, `moveBatchToBottom(ids[])`, plus `positionOf(store, itemId)` helper.
- **Files Modified**: `entry/src/main/ets/data/repository/QueueRepository.ets`

---

## Cross-Cutting Fixes

### Permission Coverage
- No permission changes needed (current logic layer requires none; deferred transport-stage permissions flagged in report).

### Navigation Updates
- No new pages created (UI-stage work, explicitly out of scope for this logic-layer commit).

### Resource Additions
- No string/media resources needed.

### State Management Changes
- `RowMappers.toFeedItem()` now correctly populates `isInQueue` and `isNew` on every DB read.
- All list-rendering queries now include the queue-membership subquery.

### Schema Migrations
- DB version bumped 1 → 2.
- `onUpgrade` handles v1→v2: adds `error_type` to DownloadResult, adds `completed_date_ms` to FeedItem.

---

## Remaining Issues

| # | Issue | Reason | Recommendation |
|---|-------|--------|----------------|
| 1 | Sleep-timer service (REQ-014) | Entirely unaddressed — requires a timer service + prefs | Implement in a dedicated stage |
| 2 | Share service (REQ-038) | No share text-assembly or system-share integration | Implement in UI stage |
| 3 | Real download transport (REQ-022) | Stub only; real network/file IO deferred | Transport stage |
| 4 | Real playback transport (REQ-009/011/012/013) | AVPlayer transport deferred | Transport stage |
| 5 | Detail pages/VMs (REQ-006/008/010) | Not built in this commit | UI stage |
| 6 | DB backup/restore + corruption recovery (REQ-040) | OPML-only; no full DB export | Backup stage |
| 7 | Build not verified | Per task instructions, build commands were not run | Run `hvigor` build to confirm compilation |

---

## All Modified Files

| File | Issues Addressed | Change Summary |
|------|-----------------|----------------|
| `entry/src/main/ets/pages/Index.ets` | Lifecycle typo | `aboutToAboutToDisappear` → `aboutToDisappear` |
| `entry/src/main/ets/pages/QueuePage.ets` | Lifecycle typo | `aboutToAboutToDisappear` → `aboutToDisappear` |
| `entry/src/main/ets/pages/InboxPage.ets` | Lifecycle typo | `aboutToAboutToDisappear` → `aboutToDisappear` |
| `entry/src/main/ets/pages/SubscriptionsPage.ets` | Lifecycle typo | `aboutToAboutToDisappear` → `aboutToDisappear` |
| `entry/src/main/ets/pages/AddPodcastPage.ets` | Lifecycle typo | `aboutToAboutToDisappear` → `aboutToDisappear` |
| `entry/src/main/ets/pages/MorePage.ets` | Lifecycle typo | `aboutToAboutToDisappear` → `aboutToDisappear` |
| `entry/src/main/ets/data/repository/RowMappers.ets` | isInQueue/isNew mapping | Populate `isNew` from read state; read optional `in_queue` column |
| `entry/src/main/ets/data/repository/EpisodeRepository.ets` | inQueue filter, in_queue subquery, in-feed search | `buildWhere` inQueue clause; all queries include `in_queue`; `search()` accepts `feedId` |
| `entry/src/main/ets/data/repository/QueueRepository.ets` | dedup, auto-sort, batch, moveToTop/Bottom | Duplicate-skip guard; `applyKeepSorted`; `addBatch`; `moveToTop`/`moveToBottom`/batch |
| `entry/src/main/ets/data/repository/DownloadRepository.ets` | error type persistence | Persist + faithfully restore `error_type` |
| `entry/src/main/ets/data/repository/FavoritesRepository.ets` | sort ignored, in_queue subquery | `buildOrderBy(sort)` applied; `in_queue` subquery added |
| `entry/src/main/ets/data/repository/HistoryRepository.ets` | completion timestamp, in_queue subquery | Order by `completed_date_ms`; set timestamp on add; `in_queue` subquery |
| `entry/src/main/ets/data/repository/FeedRepository.ets` | feed search | `searchFeeds()` + tokenizer |
| `entry/src/main/ets/data/repository/SearchRepository.ets` | feed search + in-feed scope | `searchInFeed()` + `searchFeeds()` |
| `entry/src/main/ets/data/repository/OpmlRepository.ets` | htmlUrl + head date | `htmlUrl` attribute; RFC822 `<dateCreated>` |
| `entry/src/main/ets/data/repository/PreferencesRepository.ets` | missing pref keys + theme refresh | REQ-033/034/035 keys + setters; `setTheme`/`setPureBlack` publish event |
| `entry/src/main/ets/data/prefs/PreferencesStore.ets` | missing pref keys | Added 13 new PrefKey constants |
| `entry/src/main/ets/data/db/PodcastDatabase.ets` | schema v2 migration | DB version 2; `error_type` + `completed_date_ms` columns; onUpgrade |
| `entry/src/main/ets/model/EpisodeModel.ets` | missing error types + classifier | `ERROR_CERTIFICATE`/`ERROR_BLOCKED` + `isUnrecoverableError()` |

---

## Recommendations

1. **Run the build** — compilation was not verified per task instructions. Run `hvigor` to confirm all changes compile (especially the DB version bump and new query shapes).
2. **Re-run code review** — to verify fixes address the reported scenarios (REQ-007, 015, 019, 023, 026, 027, 028, 032, 039, etc.).
3. **Manual testing** — verify the DB v1→v2 migration works on an existing install (ALTER TABLE adds).
4. **Implement deferred scenarios** — sleep-timer (REQ-014), share (REQ-038), real transport (REQ-009/022) remain unaddressed.
5. **Build detail pages/VMs** — podcast/episode/playback detail (REQ-006/008/010) are still UI placeholders.
