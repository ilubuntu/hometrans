commit_id: 47270b630d57ce491d407015f78eec89b7fdb181

# Logic layer (data + domain) — decision contract closure

Build: `hvigorw --mode module -p product=default assembleHap` → **BUILD
SUCCESSFUL** (unsigned HAP `entry-default-unsigned.hap` produced, 819 KB).

## Completion evidence (code-level proof)

1. **DDL** — `data/db/PodcastDatabase.ets` `onCreate()` runs `CREATE TABLE`
   for `Feed`, `FeedItem`, `Queue`, `FeedPreferences`, `DownloadResult`, `Tag`,
   `FeedTag` (+ 3 indexes). `onUpgrade()` migration switch reserved via
   `store.version`.
2. **Preferences getters** — `data/prefs/PreferencesStore.ets` exposes
   `getString/getBoolean/getNumber`, each backed by `getPreferences()`;
   `data/repository/PreferencesRepository.ets` exposes a domain getter/setter
   for every REQ-033/034/035/036 key (theme, nav, feedOrder/counter/columns,
   playback, enqueueLocation, queueLocked/keepSorted, inbox sort, downloads,
   sync).
3. **EventBus.publish on every write** — every repository write ends with
   `EventBus.publish(<typed event>)` (Episode/Feed/Queue/Favorites/History/
   Download/FeedPreferences/Tag/Opml). Verified by grep: no write method lacks a
   publish call.
4. **QueueRepository.add enqueue-location branch** — reads
   `PreferencesRepository.getEnqueueLocation()` and branches
   `BACK` (max+1) / `FRONT` (0) / `AFTER_CURRENT` (first+1), shifting
   `Queue.position` inside `beginTransaction/commit` with `rollBack` on error.
5. **No un-routed DB literals** — grep of `viewmodel/` for
   `DBReader|DBWriter|UserPreferences|Replace with actual database read|
   FeedUpdateManager` → 0 matches. The masking `queue=[]`/`episodes=[]`/
   `feeds=[]` literal assignments in load methods are gone; `[]` now appears
   only as initial field state or inside `catch` (genuine error degradation,
   not masking).
6. **Bootstrap** — `entryability/EntryAbility.ets` `onCreate` calls
   `AppContext.init(context)` then `bootData()` which awaits
   `PodcastDatabase.getInstance().getStore()` + `PreferencesStore.getInstance()
   .getPreferences()`; errors logged per 1.7, UI non-blocking.
7. **Empty-DB path** — `QueueViewModel.loadItems()` catches errors to `[]`;
   `refreshInfoBar()` returns the exact string `0 episodes • 0 minutes left`
   when `queue.length === 0` → page renders the empty-state.
8. **Subscribe/unsubscribe** — `viewmodel/ViewModelBase` tracks per-subscription
   handles; each page calls `viewModel.onAppear()` (→ `subscribeEvents`) in
   `aboutToAppear` and `viewModel.onDisappear()` (→ `EventBus.unsubscribe` per
   handle) in `aboutToAboutToDisappear`. Domain events:
   Queue→QUEUE_CHANGED, Inbox→EPISODE_UPDATED+FEED_LIST_UPDATE,
   Subscriptions→FEED_LIST_UPDATE, Home→EPISODE_UPDATED+FEED_LIST_UPDATE+
   QUEUE_CHANGED, AddPodcast→FEED_LIST_UPDATE, More→none (static nav, hooks
   present for uniformity).

## Platform facts verified (SDK 6.0.2 / API 22)

- **emitter import** (plan flagged "coder must verify"): confirmed
  `import emitter from '@ohos.events.emitter'` is the correct path at this SDK
  (re-exported via `@kit.BasicServicesKit`). `on/off/emit` with numeric
  `InnerEvent.eventId`; `EventData.data` is the payload carrier. Compiled clean.
- **relationalStore**: `getRdbStore(context, StoreConfig{S1})` returns a cached
  `RdbStore`; schema migration via `store.version` get/set (no open-callback
  overload in stage model). `executeSql` for DDL/writes, `querySql` for SELECT
  (with `LIMIT/OFFSET`, `LIKE`, `CASE`, aggregate `COUNT/SUM`), `insert(table,
  values, ConflictResolution)` for PK upserts (`ON_CONFLICT_REPLACE` /
  `ON_CONFLICT_IGNORE`). `ResultSet` via `goToFirstRow/goToNextRow/getLong/
  getString/getDouble/getColumnIndex`.
- **dataPreferences**: `getPreferences(context, name)`; `get/put/flush`.
- No `platform_drift` against the plan; no blocking platform fact.

## Forbidden — verified absent

- No ViewModel owns truth / persists directly / holds a derived array as
  authoritative (all reads go through repositories).
- No second RDB, second preferences instance, or second event bus (singletons).
- No FTS; counters are derived `COUNT(*)`, not stored columns.
- No `LayoutPolicy` / `BottomNavigation` / 5-tab `Index` / `$r` resource
  mutations; page `.ets` changes are lifecycle-only (refresh callback +
  `aboutToAppear`/`aboutToAboutToDisappear`).
- No real network/media/sync transport: all four transport services are stubs
  behind interfaces (no `@kit.NetworkKit` / AVPlayer imports).

## Safe partial boundary (by design, not a blocker)

Per the plan's "Unknown" section, **real transport wiring** (HTTP feed fetch +
RSS parse, media download worker, AVPlayer playback, gpodder/Nextcloud sync,
iTunes/fyyd/PodcastIndex directory search) is deferred behind the service
interfaces with stub implementations. The data path, persistence, REQ-039 error
mapping, download log, events, and all ViewModel logic are complete; only live
bytes-on-wire / downloaded-media-file / sounding-playback are not provable
until the transport stage (and are not claimed done).

One item the plan mentions in its State contract but is **not in the numbered
Edit Plan (steps 1–8)** and was therefore intentionally not wired in this stage:
the `EntryBackupAbility` OPML/DB **file** write (40.11). The data path exists
(`OpmlRepository.exportOpml()` produces OPML XML; `FeedRepository`/DB are the
truth source), but the `@kit.CoreFileKit` file write inside the backup
extension is left to the backup/settings stage to avoid expanding platform
scope beyond the edit plan.

## Files

37 plan-required files staged (new `data/` package [23 files], `model/
EpisodeModel.ets`, 7 `viewmodel/*.ets`, `entryability/EntryAbility.ets`, 6
`pages/*.ets` lifecycle edits). No build artifacts, components, LayoutPolicy,
BottomNavigation, or EntryBackupAbility staged (untouched).
