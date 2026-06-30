# Code Review Report

## Overview

- **Project**: AntennaPod HarmonyOS port (`AntennaPod/input/antennapodHarmony`)
- **Commit ID**: `47270b630d57ce491d407015f78eec89b7fdb181` — *logic(coder): build data+domain layer for AntennaPod HarmonyOS*
- **Scenario Doc**: `AntennaPod/output/antennapod_pipeline/combined-spec.md` (40 atomic scenario specs)
- **Code Context**: `extract_commit_context` MCP tool returned an empty payload; fell back to `git show --stat` + direct reading of all 38 changed/added files (38 files, +4613 lines).
- **Review Date**: 2026-06-30
- **Review Scope**: This commit is the **data + domain (logic) layer**. Per the commit message the "data path + REQ-039 error mapping [is] complete; real network/media transport [is] deferred behind the interfaces." Verdicts below judge whether the **logic layer** supports each scenario; UI/page completeness is noted where a page is still a placeholder but does not by itself force a FAIL when the data path is sound.
- **Total Scenarios**: 40
- **Results**: **5 PASS | 33 PARTIAL | 2 FAIL | 0 UNABLE TO VERIFY**

> Scenarios are identified by their SPEC filename + the REQ number stated in the spec header. REQ numbers for specs without an explicit header number are best-effort assignments consistent with the task brief (search = REQ-027/028) and are labeled with the SPEC name to avoid ambiguity.

---

## Scenario Coverage Summary

| # | Scenario (SPEC) | REQ | Verdict | Key Gaps |
|---|-----------------|-----|---------|----------|
| 1 | first-launch-home | REQ-001 | **PASS** | — |
| 2 | main-navigation | REQ-002 | PARTIAL | Last-nav-position not persisted; badge counts not bound to nav |
| 3 | add-podcast-entry | REQ-003 | PARTIAL | OPML/local-folder pickers are UI placeholders |
| 4 | subscribe-rss | REQ-004 | PARTIAL | Real RSS fetch/parse, dedup, feed-discovery, network errors deferred |
| 5 | subscription-list | REQ-005 | **PASS** | — |
| 6 | podcast-detail | REQ-006 | PARTIAL | No PodcastDetailViewModel/page; data reads exist |
| 7 | episode-list-item | REQ-007 | PARTIAL | `isInQueue`/`isNew` never populated by RowMappers |
| 8 | episode-detail | REQ-008 | PARTIAL | No EpisodeDetailViewModel/page |
| 9 | play-episode | REQ-009 | PARTIAL | AVPlayer transport deferred (stub emits position event) |
| 10 | playback-detail | REQ-010 | PARTIAL | No playback-detail page; position persist present |
| 11 | play-pause-state | REQ-011 | PARTIAL | No play/pause state machine; `pause()` is a no-op |
| 12 | fast-forward-rewind | REQ-012 | PARTIAL | Seek logic deferred; FF/rewind prefs present |
| 13 | playback-speed | REQ-013 | PARTIAL | No speed-preset list / skip-silence pref |
| 14 | sleep-timer | REQ-014 | **FAIL** | No sleep-timer service or prefs at all |
| 15 | add-to-queue | REQ-015 | PARTIAL | No duplicate-skip, new→unplayed, auto-sort-on-add, batch add |
| 16 | queue-page | REQ-016 | **PASS** | — |
| 17 | queue-reorder | REQ-017 | PARTIAL | No move-to-top/bottom, no batch move, no canMove checks |
| 18 | clear-queue | REQ-018 | **PASS** | — |
| 19 | episodes-list (单集总列表) | REQ-019 | PARTIAL | `inQueue`/media/paused filter dimensions not implemented in SQL |
| 20 | completed-downloads | REQ-020 | PARTIAL | No in-progress list, no "delete played" bulk, no sort-by-size |
| 21 | delete-download | REQ-021 | PARTIAL | Real file deletion + batch deferred (flag reset present) |
| 22 | download-episode | REQ-022 | PARTIAL | Real transport, mobile-confirm, batch, live progress deferred |
| 23 | download-log | REQ-023 | PARTIAL | Lossy error-type mapping on read; no retry-from-log |
| 24 | favorites | REQ-024 | PARTIAL | No batch fav/unfav; `sort` param ignored; no auto-clean protection |
| 25 | inbox-new | REQ-025 | **PASS** | — |
| 26 | playback-history | REQ-026 | PARTIAL | No completion-timestamp column; ordered by `%` not time; no pagination |
| 27 | search-page | REQ-027 | PARTIAL | No podcast/feed search (episodes only); no scoped search |
| 28 | search-in-podcast | REQ-028 | PARTIAL | `search()` has no feedId scope param |
| 29 | podcast-settings | REQ-029 | PARTIAL | No feed rename / edit-URL / local-reconnect in FeedRepository |
| 30 | tags-groups | REQ-030 | PARTIAL | No batch/common-tags, no root tag, no "未分类" grouping |
| 31 | opml-import | REQ-031 | PARTIAL | No title fallback, no BOM/encoding, file IO deferred |
| 32 | opml-export | REQ-032 | PARTIAL | Missing `htmlUrl` + head date; no file write |
| 33 | theme-appearance | REQ-033 | PARTIAL | Missing remaining-time, notif-buttons, swipe, default-sort, prefer-streaming keys |
| 34 | playback-settings | REQ-034 | PARTIAL | Missing headset/Bluetooth auto-resume keys |
| 35 | download-settings | REQ-035 | PARTIAL | Missing update-interval, HTTP proxy, storage-dir, cache rules |
| 36 | sync-settings | REQ-036 | PARTIAL | Missing server/password/service-type/status; transport deferred |
| 37 | statistics | REQ-037 | PARTIAL | No by-year / download-space / filters / reset; time-played approximate |
| 38 | share | REQ-038 | **FAIL** | No share text-assembly or share service in logic layer |
| 39 | error-retry | REQ-039 | PARTIAL | No retry loop / unrecoverable classification / HTTP-416; error enum missing certificate/blocked |
| 40 | data-persistence | REQ-040 | PARTIAL | Core DB+prefs solid; full DB backup/restore, periodic export, corruption recovery missing |

---

## Detailed Scenario Reviews (Focus Areas)

### Scenario 15 — add-to-queue (REQ-015) — PARTIAL

**Description**: Enqueue an episode honouring the configured insert position; skip duplicates; auto-sort if keep-sorted; batch add.

**Evidence**:
- `data/repository/QueueRepository.ets:69-97` — `add(itemId)` reads `enqueueLocation` (BACK/FRONT/AFTER_CURRENT) and computes the insert index, then **transactionally** shifts positions and inserts (`beginTransaction`/`commit`/`rollBack`). The three-way branching is correct.
- `QueueRepository.ets:162-174` — `firstPosition()` correctly degrades to BACK when the queue is empty.

**Gaps**:
- **No duplicate-skip** (spec scenario 5): `add()` performs `INSERT OR REPLACE` without first calling `contains()`, so re-adding an item already in the queue silently moves it instead of being skipped.
- **No "new → unplayed" marking** (scenario 1.e): adding does not flip `read=0` for new episodes.
- **No auto-sort on add** (scenario 4): when `keepQueueSorted` is on, `add()` does not re-sort the queue after insertion.
- **No batch add** (scenario 3): there is no `addBatch(ids[])` repository method; the multi-select path is unimplemented.

**Suggestions**:
- Guard `add()` with `if (await this.contains(itemId)) return;`.
- After insert, when keep-sorted is enabled, invoke a sort pass and rewrite positions.
- Add `setRead(itemId, false)` when the episode is new during enqueue.
- Add `addBatch(itemIds, location)` that wraps `add()` in a single transaction.

---

### Scenario 16 — queue-page (REQ-016) — PASS

**Evidence**:
- `viewmodel/QueueViewModel.ets:29-45` — `loadItems()` reads the queue, lock + keep-sorted prefs in one pass with try/catch fallback.
- `QueueViewModel.ets:47-60` — `refreshInfoBar()` computes "N episodes • X left" by summing `max(duration - position, 0)` — matches the spec's remaining-time accumulation.
- `QueueViewModel.ets:18-22` — subscribes to `QUEUE_CHANGED` and re-queries (real-time refresh).
- `QueueRepository.ets:108-112` — `clearQueue()` deletes all rows and publishes the event.
- `QueueRepository.ets:52-63` — `totalRemainingDurationMs()` SQL aggregate available as the canonical source.

**Gaps**: None at the logic-layer level (UI lock-warning dialog, drag handle, empty-state "go to inbox" button are UI-stage).

---

### Scenario 17 — queue-reorder (REQ-017) — PARTIAL

**Evidence**:
- `QueueRepository.ets:115-138` — `reorder(from, to)` is a correct transactional rewrite using a sentinel (`position = -1`) then shift, matching drag-to-anywhere semantics.

**Gaps**:
- No `moveToTop(itemId)` / `moveToBottom(itemId)` convenience methods (scenarios 3 & 4).
- No batch move-to-top/bottom (scenarios 5 & 6), no `canMove` selection checks.
- Lock/keep-sorted disables are enforced only in the VM's `canReorder()` (`QueueViewModel.ets:102-104`), not at the repository guard level.

**Suggestions**: Add `moveToTop`/`moveToBottom`/`moveBatchToTop`/`moveBatchToBottom` to `QueueRepository`.

---

### Scenario 18 — clear-queue (REQ-018) — PASS

**Evidence**:
- `QueueRepository.ets:108-112` — `clearQueue()` issues `DELETE FROM Queue` and publishes `QUEUE_CHANGED`.
- `QueueViewModel.ets:79-85` — `clearQueue()` calls the repo and optimistically clears state; the event then re-loads.
- Current-playback isolation (scenario 4) is the playback service's responsibility; the clear path does not touch playback state.

---

### Scenario 24 — favorites (REQ-024) — PARTIAL

**Evidence**:
- `data/repository/FavoritesRepository.ets` — `getFavorites`, `add`, `remove`, `toggle` all publish `EPISODE_UPDATED`. Favorites correctly modelled as a derived view (`is_favorite` flag), not a separate table.

**Gaps**:
- **`getFavorites(sort)` ignores its `sort` parameter** (`FavoritesRepository.ets:26-35`) — the query hard-codes `ORDER BY pub_date_ms DESC` regardless of the passed sort order.
- No batch add/remove (scenario 5).
- No auto-clean protection (scenario 6): there is no download-cleanup algorithm that exempts favorites — no cleanup code exists at all yet.

**Suggestions**: Apply the `sort` argument via the shared `EpisodeRepository.buildOrderBy` logic; add `addBatch`/`removeBatch`.

---

### Scenario 25 — inbox-new (REQ-025) — PASS

**Evidence**:
- `viewmodel/InboxViewModel.ets:54-73` — reads `unplayed` (read=0) episodes with pagination (150/page) + persisted sort + total count + hasMore.
- `EpisodeRepository.ets:223-228` — `removeAllNewFlags()` sets `read=1` for all unread (clear-inbox) and publishes event + message.
- Single swipe-remove maps to `EpisodeRepository.setRead(id, true)`.

---

### Scenario 26 — playback-history (REQ-026) — PARTIAL

**Evidence**:
- `data/repository/HistoryRepository.ets` — `getHistory`, `addItem`, `clearHistory` publish `EPISODE_UPDATED`; clear also publishes a user message.

**Gaps**:
- **No completion-timestamp column.** `getHistory()` orders by `played_completion DESC, pub_date_ms DESC` (`HistoryRepository.ets:30`). `played_completion` is a 0–100 percentage, not a time, so the spec's "按完成时间倒序" (by completion time descending) cannot be honoured. A `completed_date_ms` column is missing from the `FeedItem` schema.
- No pagination (`getHistory()` returns the full set; other list repos paginate at 150).

**Suggestions**: Add `completed_date_ms` to `FeedItem` (bump DB version + `onUpgrade`), set it in `markCompleted`, and order history by it; paginate history reads.

---

### Scenario 19 — episodes-list / 单集总列表 (REQ-019) — PARTIAL

**Evidence**:
- `EpisodeRepository.ets:102-127` — `getEpisodes(filter, sort, page)` with `LIMIT 150 OFFSET`, plus `getTotalCount(filter)` for hasMore/total.
- `markAllRead()` (`EpisodeRepository.ets:230-234`) available.

**Gaps**:
- **`EpisodeFilter.inQueue` is declared but never applied.** `buildWhere()` (`EpisodeRepository.ets:31-58`) handles `unplayed/played/downloaded/notDownloaded/favorite/inHistory/feedId` but has **no clause for `inQueue`**. The "在队列/不在队列" filter group (spec 场景四) is therefore broken.
- Missing filter dimensions entirely: **有媒体/无媒体** (has/no media), **暂停/未暂停** (paused) — not modelled.

**Suggestions**: Implement `inQueue` via a `feeditem_id IN (SELECT feeditem_id FROM Queue)` / `NOT IN` subquery; add a media-presence dimension.

---

### Scenario 27 — search-page (REQ-027) — PARTIAL

**Evidence**:
- `EpisodeRepository.ets:160-186` — `search()` is spec-correct for episodes: manual whitespace tokeniser, multi-word **AND**, `LOWER(title) LIKE ? OR LOWER(description) LIKE ?`, newest-first, **capped at 300**, **parameterised bind args** (SQL-injection safe).
- `SearchRepository.ets` — thin facade delegating to `episodes.search(query, 300)`.

**Gaps**:
- **No podcast/feed search.** The spec requires a second result region: feeds matched by title/custom-title/author/description (场景 2.5). `SearchRepository`/`FeedRepository` expose no feed search method.
- No filter-tag support (queue/archive) on the search path.

**Suggestions**: Add `FeedRepository.searchFeeds(query)` (title/customTitle/author/description LIKE, AND, title-ascending, cap 300) and expose via `SearchRepository`.

---

### Scenario 28 — search-in-podcast (REQ-028) — PARTIAL

**Evidence**:
- Episode-level LIKE search exists (as above).

**Gaps**:
- **`search()` has no `feedId` scope parameter**, so in-podcast search (spec 场景 2.4: search limited to one feed, including archived) cannot be expressed. There is no `searchInFeed(feedId, query)`.

**Suggestions**: Add an optional `feedId` to `search()` (append `AND feed_id = ?` when > 0) or a dedicated `searchInFeed`.

---

### Scenario 39 — error-retry (REQ-039) — PARTIAL

**Evidence**:
- `model/EpisodeModel.ets:63-79` — `DownloadErrorType` enum covers most categories (parser, forbidden, not-found, not-enough-space, authentication, io, etc.).
- `RepositoryResult` (`EpisodeModel.ets:228-235`) is the structured fail type; `OnlineSearchService.ets:27-34` builds a `no_connection` result; `SyncRepository` returns a structured `sync_disabled` result.
- `DownloadRepository.addDownloadLog()` always writes a row (success or failure) — matches "all results recorded".

**Gaps**:
- **Error enum incomplete:** no `ERROR_CERTIFICATE` (spec 场景 39.10) and no `ERROR_BLOCKED` (被拦截).
- **No retry mechanism at all.** `StubDownloadService.download()` succeeds immediately; there is no max-3-retry loop (场景 39.1), no unrecoverable-error classification (场景 39.2), no HTTP-416 partial-file delete + restart (场景 39.3), no "重试 from log" (场景 39.5).
- **Lossy error mapping on read** — see Scenario 23.

**Suggestions**: Add the missing error types; introduce an error classifier (`isUnrecoverable(errorType)`); wire a bounded retry loop into the real download worker (deferred stage) but define the contract now.

---

### Scenario 23 — download-log (REQ-023) — PARTIAL

**Evidence**:
- `DownloadRepository.ets:39-60` — `getDownloadLog()` reads `DownloadResult` ordered by `completed_date_ms DESC LIMIT 200`; `deleteDownloadLog()` clears all.

**Gaps**:
- **Error type is not faithfully persisted.** `addDownloadLog()` writes only the numeric `reason` (`DownloadRepository.ets:63-80`); the structured `errorType` string is dropped. On read, `getDownloadLog()` maps any non-zero reason to `ERROR_UNKNOWN` (`DownloadRepository.ets:54`). So a forbidden/not-found/space error collapses to "unknown" — the spec's per-error user-readable description (场景三) is lost.
- No retry-from-log method (场景五).

**Suggestions**: Persist `errorType` (or a numeric reason→enum map) and reconstruct the exact type on read; add `retryDownloadLogEntry(id)`.

---

### Scenario 40 — data-persistence (REQ-040) — PARTIAL

**Evidence**:
- `PodcastDatabase.ets` — single relationalStore (`Antennapod.db`, S1) with version-gated `onCreate`/`onUpgrade`. All structured data (Feed/FeedItem/Queue/FeedPreferences/DownloadResult/Tag/FeedTag) lives here.
- `PreferencesStore.ets` — single `dataPreferences` helper for global prefs; every write `flush()`es.
- `EntryAbility.ets:22-39` — bootstraps `AppContext` + DB + prefs fire-and-forget with logged errors (robustness 场景 1.7 / 40.x).
- Restart recovery (scenarios 40.1–40.8) is sound by design: subscriptions/queue/favorites/history/downloads/per-feed-prefs/global-prefs/position all live in persisted stores.

**Gaps**:
- **No full database export/import** (scenarios 40.9/40.10). `OpmlRepository` only handles OPML (subscriptions), not a complete DB backup/restore.
- **System auto-backup is a no-op** (scenario 40.11): `EntryBackupAbility.onBackup()/onRestore()` (`entrybackupability/EntryBackupAbility.ets:7-15`) just log and resolve — no OPML export is produced for the backup.
- **No periodic auto-export** (scenario 40.12) and **no corruption-recovery handler** (scenario 40.14).
- `onUpgrade` is a reserved no-op scaffold (acceptable for DB version 1; scenario 40.13).

**Suggestions**: Implement DB file export/import behind a `BackupRepository`; have `EntryBackupAbility` export OPML on backup; add a corruption-detection + rebuild path in `openAndMigrate`.

---

### Scenario 33 — theme-appearance (REQ-033) — PARTIAL

**Evidence**:
- `PreferencesRepository.ets:34-98` — typed getters/setters for theme, pureBlack, dynamicColor, navMode, feedOrder, feedCounter, numColumns, showSubscriptionTitle. List-affecting setters re-publish `FEED_LIST_UPDATE`.

**Gaps (missing preference keys in `PrefKey`/`PreferencesStore`)**:
- "显示剩余时间" toggle (场景 33.4) — no `SHOW_REMAINING_TIME` key.
- Custom notification quick-buttons (场景 33.6, exactly-2 constraint).
- Swipe-gesture left/right action config (场景 33.10).
- Global default episode sort (场景 33.7).
- "优先流式播放/下载" toggle (场景 33.9).
- Nav-drawer item show/hide set (场景 33.5).
- `setTheme()` does not publish a refresh event, so an "immediate rebuild" (场景 33.1) is not event-driven.

**Suggestions**: Add the missing `PrefKey`s + getters/setters; have appearance setters that affect rendering publish a theme/refresh event.

---

### Scenario 34 — playback-settings (REQ-034) — PARTIAL

**Evidence**: `PreferencesRepository.ets:100-158` — fast-forward secs (30), rewind secs (10), global speed, enqueue location, smart-mark threshold, queue locked, keep-sorted, queue sort order all present.

**Gaps**: No headset-insert auto-resume (场景 34.6) or Bluetooth-connect auto-resume (场景 34.7) preference keys; no version-gating helper.

---

### Scenario 35 — download-settings (REQ-035) — PARTIAL

**Evidence**: `PreferencesRepository.ets:164-183` — autoDownload, mobileAutoDownload, downloadWifiOnly, automaticDelete, mobileFeedRefresh present.

**Gaps**: No Feed-update **interval** (场景 35.1), no HTTP **proxy** host/port (场景 35.5), no download **storage directory** (场景 35.6), no auto-download count/interval limits, no cache-cleanup rule prefs (场景 35.7). No timer restart on interval change.

---

### Scenario 36 — sync-settings (REQ-036) — PARTIAL

**Evidence**: `SyncRepository` interface + `StubSyncService` (disabled, structured result) + pref keys `SYNC_ENABLED/SYNC_USERNAME/SYNC_LAST_SYNC_ATTEMPT`.

**Gaps**: No server URL, password, service-type (gpodder vs Nextcloud), last-sync-result/status, or force-full-sync flag. Real transport deferred (acknowledged). Settings page itself is not built.

---

## Detailed Scenario Reviews (Remaining)

### Scenario 1 — first-launch-home (REQ-001) — PASS
`HomeViewModel.loadData()` (`HomeViewModel.ets:32-48`) reads `getRecentlyPublished(20)`, inbox count, and `getFeedCount()>0` with full try/catch. `Index.ets:46-51` renders `WelcomeContent` when `!hasSubscriptions`. Async + error-safe (场景 1.7). (Minor: empty state keys off subscription count rather than episode count per 场景 1.1, but the effect is equivalent for an empty library.)

### Scenario 2 — main-navigation (REQ-002) — PARTIAL
`MoreViewModel.loadItems()` defines the overflow nav entries (episodes, downloads, history, favorites, statistics, add-feed, drawer, settings). Badge-count *data* exists (`FeedRepository.getFeedCounters`), but **last-visited nav position is not persisted** (场景 2.6) and badge counts are not bound into the nav component. Bottom/side mode pref (`NAV_MODE`) exists.

### Scenario 3 — add-podcast-entry (REQ-003) — PARTIAL
`AddPodcastViewModel` (`AddPodcastViewModel.ets`): URL detection (`indexOf('http')===0`) routes to `addByUrl` → `parseFeed` + `addFeed` (data path complete); discovery uses the stub and deterministically surfaces the offline error path. OPML import and local-folder add are UI-stage `console.info` placeholders (file/folder pickers not wired).

### Scenario 4 — subscribe-rss (REQ-004) — PARTIAL
`FeedRepository.subscribeByUrl`/`addFeed` + `StubFeedUpdateService.parseFeed` complete the subscription data row path. Real RSS fetch/parse, already-subscribed dedup (场景 4.6), multi-feed discovery (场景 4.4), web-page→feed lookup, and network/parse error handling (场景 4.8/4.9) are all deferred behind the stub.

### Scenario 5 — subscription-list (REQ-005) — PASS
`SubscriptionsViewModel` loads feeds + per-feed counters, reflects column/order/counter prefs, and re-queries on `FEED_LIST_UPDATE`. Counter map (`FeedRepository.getFeedCounters`) supports NONE/INBOX/UNPLAYED/DOWNLOADED/DOWNLOADED_UNPLAYED. (Minor: COUNTER feed-order falls back to alphabetical since counter-based ordering isn't computed.)

### Scenario 6 — podcast-detail (REQ-006) — PARTIAL
Data reads exist (`FeedRepository.getFeed(id)`, `EpisodeRepository.getEpisodes` with `feedId` filter, mark-all-read). **No `PodcastDetailViewModel` or detail page** in this commit.

### Scenario 7 — episode-list-item (REQ-007) — PARTIAL
`FeedItem` model carries all status flags. **Bug:** `RowMappers.toFeedItem` (`RowMappers.ets:25-58`) sets `isPlayed/isDownloaded/isFavorite/inHistory/autoDownload/video` but **never sets `isInQueue` or `isNew`** — both stay `false` for every row, so queue/new badges (场景 7.8/7.2) cannot render from DB reads. `isInQueue` should be derived (e.g. queue reads flag it, or a JOIN).

### Scenario 8 — episode-detail (REQ-008) — PARTIAL
`EpisodeRepository.getEpisode(id)`, `setMediaPosition`, `setRead`, `setFavorite`, `setDownloaded` cover the writes. **No `EpisodeDetailViewModel`/page.**

### Scenario 9 — play-episode (REQ-009) — PARTIAL
`PlaybackService.play(itemId)` (stub) emits a `PLAYBACK_POSITION` event (`PlaybackService.ets:22-27`); real AVPlayer transport deferred.

### Scenario 10 — playback-detail (REQ-010) — PARTIAL
`PlaybackService.setPosition`/`markCompleted` persist position + history (`PlaybackService.ets:33-41`). No playback-detail page/VM.

### Scenario 11 — play-pause-state (REQ-011) — PARTIAL
`play()` emits an event; `pause()` is a literal no-op (`PlaybackService.ets:29-31`). No play/pause state machine or global state sync in the logic layer.

### Scenario 12 — fast-forward-rewind (REQ-012) — PARTIAL
FF/rewind second prefs present (`PreferencesRepository.getFastForwardSecs/getRewindSecs`). Seek computation is playback-transport (deferred).

### Scenario 13 — playback-speed (REQ-013) — PARTIAL
Global speed pref + per-feed `FeedPreferences.playbackSpeed` present. No speed-preset list persistence, no skip-silence pref key.

### Scenario 14 — sleep-timer (REQ-014) — FAIL
**No sleep-timer service, no sleep-timer prefs, no countdown/episode-count logic exists anywhere in the logic layer.** Entirely unaddressed by this commit.

### Scenario 20 — completed-downloads (REQ-020) — PARTIAL
`DownloadRepository.getDownloads()` returns `downloaded=1` rows. No in-progress ("正在下载") section (no download-state tracking beyond the boolean flag), no "delete played downloads" bulk op (场景四), no sort-by-size/duration/title, no download-log panel integration.

### Scenario 21 — delete-download (REQ-021) — PARTIAL
`DownloadRepository.remove(itemId)` flips `downloaded=0` and publishes `DOWNLOAD_EVENT`. Real local-file deletion (incl. subtitles) and batch delete are deferred (transport stage).

### Scenario 22 — download-episode (REQ-022) — PARTIAL
`StubDownloadService.download()` exercises the full data path (progress event → log row → `setDownloaded(true)`). Mobile-network confirmation (场景二), batch download, real per-second progress, and network-condition resume are all deferred.

### Scenario 29 — podcast-settings (REQ-029) — PARTIAL
`FeedPreferencesRepository.get/set` cover autoDownload/autoDelete/newEpisodeAction/playbackSpeed/skipIntro/skipOutro/credentials/volumeReduction (all persisted, REPLACE-upsert). **Missing in `FeedRepository`:** rename feed, edit source URL, local-folder reconnect (场景 29.9/29.10/29.11). Auto-download→lock-new-action logic (场景 29.3) absent.

### Scenario 30 — tags-groups (REQ-030) — PARTIAL
`TagRepository` CRUD is correct and complete (create/rename/delete/assign/remove/getForFeed) with `ON_CONFLICT_IGNORE` on assignment. Missing: batch common-tags intersection (场景 30.3), root-tag concept (no schema column) (场景 30.5), "未分类" auto-grouping (场景 30.7).

### Scenario 31 — opml-import (REQ-031) — PARTIAL
`OpmlRepository.importOpml()` scans `xmlUrl="..."` via `indexOf` (regex-free, per contract) and subscribes each, publishing `FEED_LIST_UPDATE`. Missing: title/text fallback (场景 31.7 — uses URL as title), BOM/encoding detection (场景 31.9), file picker + read (UI stage), parent-control gate (场景 31.8).

### Scenario 32 — opml-export (REQ-032) — PARTIAL
`OpmlRepository.exportOpml()` emits valid OPML 2.0 (`<opml version="2.0">`, `<head>`, `<body>`) for subscribed feeds only, with full XML escaping. **Missing:** `htmlUrl` attribute (the `Feed.link` column exists but isn't written) (场景 32.5), RFC822 creation date in `<head>` (场景 32.2), and file output (UI stage).

### Scenario 37 — statistics (REQ-037) — PARTIAL
`StatisticsRepository.getStatistics()` returns per-feed aggregates (total/started/downloaded/time_played) ordered by time-played desc. Missing: by-year tab, download-space tab, time-range filter, include/exclude-manual-marked, reset (场景 37.2/37.3/37.4/37.5). `time_played` uses `media_position` of read episodes — an approximation, not true played-duration tracking.

### Scenario 38 — share (REQ-038) — FAIL
**No share text-assembly, no share service, no system-share integration exists in the logic layer.** None of scenarios 38.1–38.8 have any logic-layer support. (Likely intended for a later UI stage, but currently zero coverage.)

---

## Cross-Cutting Issues

### 1. Page lifecycle typo → event-subscription leak (HIGH)
Every page implements `aboutToAboutToDisappear()` instead of the correct ArkUI custom-component lifecycle callback **`aboutToDisappear()`**:

- `pages/Index.ets:22`, `pages/QueuePage.ets:21`, `pages/InboxPage.ets:31`, `pages/SubscriptionsPage.ets:24`, `pages/AddPodcastPage.ets:21`, `pages/MorePage.ets:16`.

Because the framework never invokes `aboutToAboutToDisappear`, **`viewModel.onDisappear()` (which calls `unsubscribeEvents()`) never runs.** Consequence: every `aboutToAppear` adds new `EventBus` subscriptions that are never removed → duplicate event handling and listener accumulation across page re-entries. This directly undermines the "ViewModel … unsubscribing in onDisappear" design stated in the commit message and the real-time-refresh scenarios (REQ-016 场景 6, REQ-007 场景 7.15, etc.). Fix: rename to `aboutToDisappear()` in all six pages.

### 2. Permission Coverage
`module.json5` declares no `requestPermissions`. Current logic-layer reads/writes (RDB, dataPreferences, EventBus) need none, so this is consistent *for this commit*. However the deferred transport scenarios (network downloads REQ-022, file import/export REQ-031/032, local folder REQ-003 场景 3.8) will require `ohos.permission.INTERNET`, `ohos.permission.FILE_ACCESS_*` / picker APIs, and media-file access — none declared yet. Flag for the transport stage.

### 3. Navigation Completeness
`main_pages.json` registers only `pages/Index`, `pages/QueuePage`, `pages/MorePage`. `InboxPage`, `SubscriptionsPage`, `AddPodcastPage` exist as `@Entry` components but are **not registered routes** — and `Index.ets` renders the non-Home tabs as in-place placeholders (`QueuePlaceholder`/`InboxPlaceholder`/…), so the dedicated pages are currently unreachable. Detail pages (podcast detail, episode detail, playback detail, search, statistics, settings) do not exist yet.

### 4. State Management Correctness
- `ViewModelBase` provides a clean refresh-callback + handle-tracked subscribe/unsubscribe pattern; `@State` fields are pushed from the VM via the registered callback (e.g. `QueuePage.syncFromViewModel`). Pattern is sound **subject to issue #1** (unsubscribe never fires).
- `RowMappers` does not populate `isInQueue`/`isNew` (see REQ-007) — state flags that lists depend on are stale.

### 5. API Version Compatibility
`build-profile.json5` targets/compat `6.0.2(22)`. APIs used (`@kit.ArkData` relationalStore/preferences, `@ohos.events.emitter`, `@kit.AbilityKit`, `@kit.CoreFileKit` BackupExtensionAbility, `@kit.PerformanceAnalysisKit` hilog) are all available at this SDK. `emitter` is imported from `@ohos.events.emitter` (re-exported by `@kit.BasicServicesKit`) — consistent with the commit's verified-platform note. No incompatible API usage found.

### 6. Resource Completeness
Pages reference many `$r('app.string.…')` / `$r('app.media.…')` resources (e.g. `queue_label`, `no_items_header_label`, `ic_playlist_play_black`, `logo_monochrome`). These were not added/modified in this commit; assuming the prior UI commit supplied them. Not verifiable from this diff alone — recommend a resource-reference sweep during build (the commit reports BUILD SUCCESSFUL, so references currently resolve).

### 7. SQL construction style (LOW)
Several repositories build SQL via numeric string concatenation (e.g. `'... WHERE id = ' + id.toString()`). Because the values are always typed numbers, this is not an injection risk, but it is inconsistent with the parameterised style used in `EpisodeRepository.search()`. Standardising on bind args would reduce future risk.

---

## Final Assessment

**Overall Verdict**: **PASS WITH ISSUES (logic layer)** — the data/domain foundation is well-architected and the data-path contract is largely honoured, but there are concrete correctness defects and noticeable spec-coverage gaps that must be closed before the affected scenarios can be considered complete.

**Strengths**
- Clean single-truth-owner design: one relationalStore + one dataPreferences behind a repository pattern; ViewModels are pure readers/consumers.
- `EventBus` with per-subscription handles (correct unsubscribe semantics at the bus level).
- Transactional queue enqueue/reorder; parameterised, injection-safe episode search; version-gated DB `onCreate`/`onUpgrade` scaffold.
- Robust ViewModel error handling (try/catch → empty fallback).
- Build verified (unsigned HAP).

**Fully covered scenarios (5)**: REQ-001 first-launch-home, REQ-005 subscription-list, REQ-016 queue-page, REQ-018 clear-queue, REQ-025 inbox-new.

**Partially covered scenarios (33)** — grouped by dominant gap:
- *Filter/state correctness*: REQ-007 (isInQueue/isNew unmapped), REQ-019 (inQueue/media/paused filters), REQ-024 (sort ignored), REQ-026 (no completion timestamp).
- *Queue semantics*: REQ-015 (dedup/new-mark/auto-sort/batch), REQ-017 (move-to-top/bottom/batch).
- *Search scope*: REQ-027 (no feed search), REQ-028 (no in-feed scope).
- *Error/download*: REQ-022/021/020 (transport deferred), REQ-023 (lossy error mapping), REQ-039 (no retry loop; missing error types).
- *Settings coverage*: REQ-033/034/035/036 (multiple pref keys missing), REQ-029/030/031/032/037 (per-feature gaps).
- *Persistence*: REQ-040 (core solid; backup/restore/corruption missing).
- *Pages pending*: REQ-006/008/010 detail VMs/pages not built; REQ-009/011/012/013 playback transport deferred; REQ-002/003/004 nav/subscribe UI gaps.

**Not covered scenarios (2)**: REQ-014 sleep-timer (no logic at all), REQ-038 share (no logic at all).

**Recommended Priority Fixes**
1. **(HIGH) Fix the `aboutToAboutToDisappear` → `aboutToDisappear` typo** in all 6 pages. Without this, event subscriptions leak and real-time refresh degrades — the single highest-impact, lowest-effort fix.
2. **(HIGH) Populate `isInQueue`/`isNew` in `RowMappers`** (or derive via JOIN) so list-item badges reflect reality (REQ-007/016/024).
3. **(HIGH) Implement the `inQueue` filter dimension** in `EpisodeRepository.buildWhere` (REQ-019/027 filters).
4. **(MED) Queue `add()`**: add duplicate-skip, new→unplayed, auto-sort-when-keep-sorted, and a batch method (REQ-015).
5. **(MED) Persist + faithfully restore download `errorType`** in `DownloadRepository`, and add `ERROR_CERTIFICATE`/`ERROR_BLOCKED` (REQ-023/039).
6. **(MED) Add feed/podcast search + in-feed scoped search** to satisfy REQ-027/028.
7. **(MED) Add missing preference keys** for REQ-033 (remaining-time, notif-buttons, swipe, default-sort, prefer-streaming), REQ-034 (headset/Bluetooth resume), REQ-035 (update-interval, proxy, storage-dir).
8. **(MED) OPML export**: write `htmlUrl` (from `Feed.link`) and an RFC822 head date (REQ-032).
9. **(LOW) History**: add `completed_date_ms` column + pagination; order by it (REQ-026).
10. **(LOW) Data-persistence**: implement DB export/import + have `EntryBackupAbility` emit OPML + add corruption-recovery (REQ-040).
11. **(Stage) Build the missing pages/VMs** (podcast/episode/playback detail, search, statistics, settings) and register routes in `main_pages.json`; wire OPML/local-folder pickers (REQ-006/008/010/031/003).
12. **(Stage) Implement sleep-timer (REQ-014) and share (REQ-038)** logic — currently zero coverage.
