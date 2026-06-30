## Decision Contract

**Goal.** Build the logic (data + domain) layer that turns the 6 TODO-stub ViewModels into live read/write paths backed by a single persistent truth owner, so every scenario's data operation (queue, inbox, episodes, downloads, favorites, history, search, settings, statistics, tags, OPML, persistence) resolves against one coordinated store with cross-page real-time propagation.

**Target surface.** New `entry/src/main/ets/data/` package (DB, preferences, repositories, event bus, transport interfaces) + expanded `model/EpisodeModel.ets` + rewired 6 `viewmodel/*.ets` + `EntryAbility.onCreate` DB bootstrap. This stage makes ViewModels live (real data) so pages can bind; UI layout/page rendering is a separate stage and is NOT touched except where a placeholder page must read a ViewModel it already owns.

**Truth owner / source.**
- **Structured app data** (feeds, episodes/feeditems, queue order, favorites, history, downloads, download log, per-feed preferences, tags): ONE HarmonyOS relational store DB (`@kit.ArkData` relationalStore). This is the single live fact for all writers and readers — the Android `DBReader`/`DBWriter` equivalent. Current ViewModel code sets `episodes=[]`, `queue=[]`, `feeds=[]` literals — that is forbidden masking and is replaced by repository reads.
- **Global settings** (theme/nav/playback/download/sync prefs, REQ-033/034/035/036): HarmonyOS preferences store (`@kit.ArkData` dataPreferences) — Android `UserPreferences` equivalent. One preferences instance, never duplicated in ViewModels.
- ViewModels are readers/consumers ONLY. They never own truth, never persist directly, never cache a derived value as if authoritative.

**Access path.** Repository pattern: one repository class per domain owns all DB access and returns `Promise`s; ViewModels call repositories and hold results in ArkUI `@State`-bound fields; pages render from `@State`.
- Repositories: `FeedRepository`, `EpisodeRepository`, `QueueRepository`, `FavoritesRepository`, `HistoryRepository`, `DownloadRepository` (downloads state + `DownloadResult` log), `FeedPreferencesRepository`, `TagRepository`, `StatisticsRepository`, `SearchRepository`, `PreferencesRepository` (global settings), `OpmlRepository` (import/export XML), `SyncRepository` (interface).
- Write flow: `ViewModel → Repository → RDB/preferences write → repository publishes event → affected ViewModels re-query`. Read flow: `ViewModel → Repository → RDB → @State`.

**Reactive propagation (spec's pervasive "real-time refresh").** Use `@ohos.events` emitter as the global EventBus. Repository publishes a typed event (`QueueChangedEvent`, `EpisodeUpdatedEvent`, `FeedListUpdateEvent`, `DownloadEvent`, `MessageEvent`, `PlaybackPositionEvent`) after every write; each ViewModel subscribes in `aboutToAppear` and unsubscribes in `aboutToAboutToDisappear`, re-querying its repository on receipt. This satisfies every 列表自动刷新/状态实时同步 scenario (queue-page #6, episodes-list 7.15, episode-detail 8.17, subscription-list 5.14, clear-queue 18, favorites, inbox, downloads #7, search 2.7/2.11).

**Schema decisions (concrete, code-locatable).** Tables mirror AntennaPod:
- `Feed`(id PK, title, custom_title, author, link, description, download_url, image_url, last_update, state [0 subscribed/1 archived/2 unsubscribed], is_local, has_last_update_failed)
- `FeedItem`(id PK, feed_id FK, title, description, link, pub_date ms, image_url, media_duration, media_position, media_size, mime_type, media_download_url, read BOOL[played], downloaded BOOL, auto_download BOOL, is_favorite BOOL, in_history BOOL, played_completion)
- `Queue`(feeditem_id PK FK, position INT) — reorder = transactional rewrite of `position`
- `FeedPreferences`(feed_id PK FK, auto_download, auto_delete, new_episode_action, playback_speed, skip_intro, skip_outro, username, password, volume_reduction)
- `DownloadResult`(id PK, completed_date ms, title, reason INT, source_type, feeditem_id) — download log + error codes (REQ-039)
- `Tag`(id, name) + `FeedTag`(feed_id, tag_id)
- Counters/badges (inbox, queue, per-feed new-count) are derived `COUNT(*)` with filter — NOT stored.
- Pagination = `LIMIT 150 OFFSET (page-1)*150`. Filter/sort = `WHERE`/`ORDER BY` on columns. Search = `title LIKE '%kw%' OR description LIKE '%kw%'`, multi-word AND-combined, `pub_date DESC`, max 300 — no FTS required for correctness.

**State / fallback / protection contract.**
- Missing vs empty: empty DB → lists empty + empty-state text, no crash. `isNew`/`read`/`downloaded`/`is_favorite` default false at insert (persisted, not masking).
- Restore (REQ-040): `EntryAbility.onCreate` opens/creates RDB with a version + `onCreate`/`onUpgrade` migration path; preferences restore on read. Async, non-blocking UI (1.7 robustness).
- App DB export/import (40.9/40.10) + OPML backup in `EntryBackupAbility` (40.11) write real file via `@kit.CoreFileKit`.
- Protected non-target: `LayoutPolicy`, `BottomNavigation` tab switching, existing resource (`$r`) bindings, `Index` 5-tab structure must remain intact.
- Error path (REQ-039): repository returns structured `{ok, errorType}`; ViewModel maps to localized toast; download log always written; no crash on transport failure.

**Platform Decision.**
| Behavior | Local evidence / assumption | Correctness dims | Verdict |
|---|---|---|---|
| relationalStore async CRUD + `LIMIT/OFFSET` + transactions | @kit.ArkData, SQLite-backed, standard | pagination(150/page), queue reorder atomicity, counter queries, filter/sort | proven (standard API) |
| dataPreferences key-value get/set | @kit.ArkData | global settings restore, theme/nav/playback prefs | proven |
| emitter publish/subscribe | @ohos.events, context-free | cross-page real-time refresh, decoupled notify | decision sound; coder must verify kit import path at SDK 22 (@kit.BasicServicesKit vs @ohos.events) — non-blocking |
| Search via SQL LIKE | supported by relationalStore | title/desc AND match, ≤300, pubDate desc | proven; FTS5 only an optimization, not required |
| File IO (export/import/backup) | @kit.CoreFileKit (already used by EntryBackupAbility) | DB export, OPML, auto-export | proven |

**Edit Plan.**
1. **NEW `data/db/PodcastDatabase.ets`** — single RDB helper: open/create on `relationalStore.getRdbStore`, `SECURITY_LEVEL S1`, version constant, `onCreate` builds all tables above, `onUpgrade` migration switch. Exported singleton `PodcastDatabase.getInstance(context)`.
2. **NEW `data/prefs/PreferencesStore.ets`** — single dataPreferences helper (`getPreferences`), typed getters/setters for all global settings keys (theme, pureBlack, dynamicColor, navMode, fastForward/rewindSec, globalSpeed, enqueueLocation, smartMarkThreshold, feedOrder, feedCounter, columnCount, inboxSortOrder, keepSorted, queueLocked, autoDownload…). Singleton.
3. **NEW `data/event/EventBus.ets`** — emitter wrapper + event-type constants + typed payload interfaces (QueueChanged, EpisodeUpdated, FeedListUpdate, DownloadResult, Message, PlaybackPosition). `subscribe(type, cb)` / `publish(type, payload)`.
4. **NEW `data/repository/*.ets`** — the 13 repositories above. Each owns its DB tables/preferences keys, exposes async read/write, publishes events on write. `QueueRepository.add(item, positionPolicy)` computes insert index from `PreferencesRepository.enqueueLocation` (back/top/after-current), writes `Queue.position`, honors keep-sorted re-sort, publishes `QueueChanged`.
5. **EXPAND `model/EpisodeModel.ets`** — extend `FeedItem` (add `isFavorite`, `inHistory`, `autoDownload`, `mediaDownloadUrl`, `playedCompletion`, `video` flag, download progress/transient fields), `Feed` (add `state`, `customTitle`, `link`, `description`); add value-object interfaces (`FeedPreferences`, `DownloadResult`, `Tag`, `EpisodeFilter`, `SortOrder` enums) consumed by repositories/ViewModels.
6. **REWIRE `viewmodel/*.ets`** — replace every TODO with repository calls: `HomeViewModel`/`QueueViewModel`/`InboxViewModel`/`SubscriptionsViewModel` read via repositories, subscribe to events; `AddPodcastViewModel` URL-detection (`/^https?:\/\//`) already present → route to `FeedRepository`/`OpmlRepository`; `MoreViewModel` nav tags stay. Add `aboutToAppear`/`aboutToAboutToDisappear` subscribe/unsubscribe; `@State` arrays populated from async `await repo.getX()`.
7. **EDIT `entryability/EntryAbility.ets`** — in `onCreate`, initialize `PodcastDatabase.getInstance(context)` + `PreferencesStore.getInstance(context)` (fire-and-forget Promise, log errors per 1.7); pass context into ViewModel access path (repositories obtain context via a set app-context, or pages pass `getContext()` on load).
8. **TRANSPORT INTERFACES (deferred real wiring)** — define `FeedUpdateService`, `DownloadService`, `PlaybackService`, `SyncService`, `OnlineSearchService` as interfaces in `data/service/` with stub/in-memory implementations that satisfy the data + error-handling logic (write download log, emit events, map REQ-039 error codes) but defer real `@kit.NetworkKit`/`AVPlayer`/gpodder transport to a later stage. Download progress is emitted as events; repositories record final state.

**Forbidden.**
- ViewModels owning truth, persisting directly, or holding a derived/mirrored array as authoritative (current `queue=[]`/`feeds=[]` literal assignment).
- Duplicating preferences keys across files; second RDB or second preferences instance; a second event bus.
- Using FTS as if required (only LIKE is the correctness path); storing counters/badges as persisted columns instead of derived queries.
- Masking missing/unset with a default/fallback literal (e.g. presetting `isFavorite=true`); `isNew` must reflect DB read, not a UI constant.
- Mutating `LayoutPolicy`, `BottomNavigation`, the 5-tab `Index` structure, or existing `$r` resource keys.
- Touching page `.ets` rendering/layout beyond binding a ViewModel the page already owns.
- Real network/media/sync transport in this stage (must stay behind the service interfaces to avoid unbounded platform scope).

**Completion Evidence (code-level).**
- `PodcastDatabase.onCreate` contains `CREATE TABLE` for Feed/FeedItem/Queue/FeedPreferences/DownloadResult/Tag/FeedTag — verifiable DDL.
- `PreferencesStore` exposes a getter for every REQ-033/034/035/036 key with a real `getPreferences` read.
- Each repository write method ends with `EventBus.publish(<typed event>)` — verifiable call.
- `QueueRepository.add` branch on `enqueueLocation` (BACK/TOP/AFTER_CURRENT) with a `position` write — verifiable insert-index logic.
- No `viewmodel` file remains with a `// TODO: Replace with actual database read` / `DBReader.` / `DBWriter.` / `UserPreferences.` literal that is un-routed (all routed through repositories).
- `EntryAbility.onCreate` calls `PodcastDatabase.getInstance` + `PreferencesStore.getInstance` — verifiable bootstrap.
- Empty DB path: `QueueViewModel.loadItems` on empty store yields `infoBarText='0 episodes • 0 minutes left'` + empty-state (clear-queue 18.5, queue-page 16.2).
- Each ViewModel has a matching `subscribe` in `aboutToAppear` and `off`/unsubscribe in `aboutToAboutToDisappear` for its domain event.

**Unknown.**
- Transport real-wiring (HTTP feed fetch+RSS parse, media download worker, AVPlayer playback service, gpodder/Nextcloud sync, iTunes/Fyyd/PodcastIndex online search) is deferred behind service interfaces with stub implementations. This is the **safe partial boundary**: the data path, persistence, error mapping (REQ-039), download-log, events, and all ViewModel logic are complete; only the live network/media/sync transport is stubbed. Scenes that assert live bytes-on-wire/downloaded-file actually exist (download-episode happy-path file completion, play-episode audio actually sounding) are NOT provable until the transport stage — these must not be claimed done. No blocking platform fact prevents the logic-layer work above.
