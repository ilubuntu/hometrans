## Decision Contract

**Goal.** Convert the AntennaPod HarmonyOS app from a UI shell with scattered, in-memory, hardcoded mock arrays (lost on restart, never cross-synced, ~100 unwired `console.info('TODO')` actions) into a persistent, single-truth, cross-page-synchronized application that satisfies REQ-001..040. Every page action mutates one owner; every affected page refreshes.

**Target surface.** (a) A new `common/data` persistence+repository layer; (b) a new `common/event` bus; (c) new `common/service` injectable engines with local implementations; (d) refactor of all 11 ViewModels to delegate to the repository (mock arrays removed); (e) wiring of every page TODO to a real action or navigation; (f) the missing pages the More-menu/overflow TODOs reference. UI layout, resources, and component structure are NOT targets — they are preserved as the frozen render surface.

**Truth owner / source (the core decision).**
- `PodcastRepository` (singleton, `common/data/Repository.ets`) is the single live owner of all entity state, backed by `relationalStore` (SQLite, `@kit.ArkData`). Tables: `feeds`, `episodes`, `queue` (ordered, `position` column), `downloads` (state+percent+completedAt), `favorites`, `playback_history`, `feed_tags`. Every read/mutate goes through it; no ViewModel may hold a sourced dataset of its own.
- `PreferencesStore` (singleton, `common/data/PreferencesStore.ets`) backed by `preferences` (`@kit.ArkData`) owns all KV settings: visible nav order + default/last page, per-page sort+filter, queue `lock`/`keepSort`/`sortRule`, `enqueuePosition`, `bottomNavEnabled`, `firstLaunchDone`, `counterDisplay`, `showRemainingTime`, `playbackSpeed`, `mobileDownloadPolicy`, `autoDownload`/`autoQueue`/`newEpisodeAction` per feed, `removeFromInboxDontAsk`.
- `PlaybackController` (singleton, `common/playback/PlaybackController.ets`, `@Observed`, mirrored into `AppStorage`) owns the ONE live playback fact (currentEpisodeId, positionSec, durationSec, isPlaying, speed). Read by MiniPlayerBar, AudioPlayerPage, EpisodeDetailPage, and every list item's "now-playing" highlight.
- This collapses today's fragmented mock specs (EpisodeDetailViewModel.EPISODE_SPECS, FeedDetailViewModel.FEED_SPECS + its `feed0`→`feed_megyn` id-hack, Home/Queue/Inbox/Episodes/Downloads/Subscriptions hardcoded arrays) into one durable owner.

**Access path (writer→owner→reader).**
`User gesture in Page → ViewModel.actionX(id) → PodcastRepository.mutate(id) → relationalStore write → repository constructs/refreshes @Observed model objects → repository emits EventBus event → every subscribed ViewModel.reload() reassigns its @State/@Observed array → @Track re-renders the bound item/section.` ViewModels become thin query+action projections over the repository; they no longer source data. Pages call `viewModel.load()` in `aboutToAppear` and subscribe to the relevant events; reload re-reads from the repository (single live fact per query).

**Event / refresh contract.** `EventBus` singleton (`common/event/EventBus.ets`), in-process typed pub/sub layered on the repository (platform-validated pattern; `EventHub` is the platform equivalent but repository-internal pub/sub gives explicit control and avoids UIAbility coupling). Events: `FEEDS_CHANGED`, `EPISODES_CHANGED{feedId?}`, `QUEUE_CHANGED`, `DOWNLOAD_PROGRESS{episodeId,percent,state}`, `INBOX_CHANGED`, `FAVORITES_CHANGED`, `PLAYBACK_STATE_CHANGED`, `PREFERENCES_CHANGED`. Repository mutators are the ONLY emitters. This is what makes REQ-008 (subscribe → Subscriptions list + Home sections + Home empty-switch + Inbox badge all refresh), REQ-014/015/016 queue live-refresh, and REQ-011 item-level local refresh work.

**Persistence / first-render / restore / missing semantics.**
- First launch: `PreferencesStore.firstLaunchDone === false` → `Repository.seed(SampleData)` writes the consolidated sample feeds+episodes into relationalStore, then sets the flag. This preserves the currently-aligned screenshots while making data real. Subsequent launches read purely from DB (restore path).
- "Missing vs empty" rule (Semantic Closure): Home empty-state reads `Repository.countEpisodes()` (all episodes, unfiltered) — NOT subscription count. A subscribed feed with zero episodes keeps Home empty until a refresh produces episodes (REQ-001 sc.2, REQ-008 sc.3). Inbox empty = zero `isNew` episodes (distinct from "no subscriptions"). Queue empty = zero rows.
- Queue order, per-page sort/filter, favorites, download state, history, playback position all persist across restart via their tables/preferences.

**Service interfaces (injectable; local impls this stage, real engines deferred).** Registered in `common/service/ServiceLocator.ets`.
- `FeedFetcher` → `SampleFeedFetcher`: returns sample feeds/episodes by URL/title from `SampleData` (enables REQ-006/007/008 preview+subscribe+refresh against local data). Real RSS HTTP parse = deferred (Unknown).
- `DownloadService` → `LocalDownloadService`: simulates `QUEUED→DOWNLOADING(percent via interval)→DOWNLOADED|CANCELED`, writes `downloads` table, emits `DOWNLOAD_PROGRESS`. Real media HTTP fetch = deferred (Unknown).
- `PlaybackService` → `LocalPlaybackService`: drives `PlaybackController` position tick + persists position/history; real `AVPlayer` decode/render = deferred (Unknown). UI play/pause/seek/speed work end-to-end against the controller.
- `SearchService`: real local search over `episodes`/`feeds` tables (REQ-030 app search, REQ-031 in-feed search) — fully in scope.
- OPML import/export, gpodder sync, online-provider search (Apple/fyyd/PodcastIndex), parental controls: stubbed to a "not available in this build" prompt; their data model + entry wiring are in scope, the network engine is deferred (Unknown).

**Platform Evidence / Decision.** Queried (api_level 22, both evidences `verified`):
- `relationalStore` supports ordered-list/`position`, filter, count, sort; async Promise returning JS rows mappable to `@Observed`. → Decision: it is the durable truth owner.
- `preferences` suits KV settings and persists across restart. → Decision: it owns all settings.
- Custom in-process singleton pub/sub on the repository is a valid cross-page refresh pattern. → Decision: `EventBus`.
- FORBIDDEN: `PersistenceV2` / `AppStorage`-as-truth for entity datasets — 8KB/key, no Array/Set/Map, frame-freeze risk, UI-coupled. `AppStorage` is used ONLY to mirror `PlaybackController` for global binding, never as the entity owner.

**Platform Assumptions.**

| Assumed behavior | Local evidence | Correctness dims this task depends on | Coverage |
|---|---|---|---|
| `@Observed`+`@Track` field mutation + array reassignment re-renders bound `@State`/`ForEach` | FeedData/EpisodeData/HomeSection already `@Observed`+`@Track`; pages bind `@State` arrays from `viewModel.load()` | item-level refresh, section refresh, list refresh | proven |
| `router.pushUrl`/`replaceUrl` for page nav; params via `params:{};` read in target `aboutToAppear` | Index→MainPage `replaceUrl`; FeedDetail/EpisodeDetail/AudioPlayer already `pushUrl` with params | all secondary-page nav + back-stack | proven |
| `relationalStore` Promise API, result-set row mapping | platform evidence (verified); not yet used locally | all queries/mutates | coder must verify exact API names/signatures (non-blocking, standard `@kit.ArkData`) |
| `preferences` get/put/flush | platform evidence (verified) | settings persistence | coder must verify exact API |
| `setInterval` tick for playback/download progress simulation | EpisodeDetailViewModel already uses `setInterval` for playback tick | progress UI | proven |
| `@ohos.router` back-stack preserves source scroll context on return | existing pushUrl pages already rely on it | REQ-010/011/012 return-to-source | coder must verify multi-level back behavior |

**State / fallback / protection contract.**
- Protection (frozen, must not change): page `.build()` layout, component composition (`EpisodeListItem`, `QueueListItem`, `AppToolbar`, `BottomNav`, `OverflowMenu`, dialogs), resource ids (`$r('app.string.*')`, `$r('app.media.*')`, `$r('app.color.*')`), `main_pages.json` existing 8 routes remain valid. The logic stage replaces data sourcing and TODO bodies only.
- Fallback: unknown feedId/episodeId resolves to a stable canonical id via `Repository`, never the `feed0→feed_megyn` ad-hoc map (deleted). Missing episode → repository returns `undefined` → page shows its existing loading/empty fallback (FeedDetailPage/EpisodeDetailPage/AudioPlayerPage already have try/catch fallbacks).
- Any action whose required engine is deferred (OPML/gpodder/online providers/parental) emits the "not available" prompt and does NOT mutate state.

## Edit Plan

**New layer files (create):**
- `common/data/SampleData.ets` — consolidated seed (canonical ids `feed_morbid`, `feed_crimejunkie`, …; episodes `feed_morbid_ep2`, …) replacing every ViewModel-local mock spec.
- `common/data/Db.ets` — relationalStore open + schema (CREATE TABLE feeds/episodes/queue/downloads/favorites/playback_history/feed_tags) + versioned migrations.
- `common/data/Repository.ets` — singleton; queries (`countEpisodes`, `queryFeeds`, `queryEpisodes(filter,sort,feedId?)`, `queryQueue`, `queryInbox`, `queryFavorites`, `queryDownloads`, `queryHistory`, `getFeed(id)`, `getEpisode(id)`, `search(q, feedId?)`, `newEpisodeCount`) and mutates (`subscribe/unsubscribe`, `setFavorite`, `enqueue/dequeue/moveTo/moveAll/sortQueue/clearQueue`, `removeFromInbox/removeAllFromInbox`, `markPlayed/resetPosition`, `setDownloadState`, `recordHistory`, `setFeedTags`). Every mutate writes DB then emits the matching EventBus event.
- `common/data/PreferencesStore.ets` — singleton over `preferences` for the KV list above; emits `PREFERENCES_CHANGED`.
- `common/event/EventBus.ets` — typed `on(event,cb)/off/emit`; events enum above.
- `common/playback/PlaybackController.ets` — `@Observed` singleton mirrored to `AppStorage('playback')`; play/pause/seek/speed/setEpisode; persists position+history via Repository; emits `PLAYBACK_STATE_CHANGED`.
- `common/service/ServiceLocator.ets`, `common/service/FeedFetcher.ets`(+SampleFeedFetcher), `common/service/DownloadService.ets`(+LocalDownloadService), `common/service/PlaybackService.ets`(+LocalPlaybackService), `common/service/SearchService.ets`.
- Missing pages (REQ-003/004/022/027/005/036): `pages/FavoritesPage.ets`, `pages/PlaybackHistoryPage.ets`, `pages/StatisticsPage.ets`, `pages/AddFeedPage.ets`, `pages/SettingsPage.ets`, `pages/AddFeedPage` children (RSS dialog, local-folder via `@ohos.file.picker`, OPML picker) per REQ-005/006.

**Model extensions (edit `model/EpisodeData.ets`, `model/FeedData.ets`):** add persisted fields the spec needs and the mock specs already carried ad-hoc: `feedId`, `downloadState`(`NONE|QUEUED|DOWNLOADING|DOWNLOADED|CANCELED`), `isPlayed`, `positionSec`, `durationSec`, `isNew`, `mediaUrl`, `websiteUrl`, `downloadedAt`, `tags:string[]`; FeedData: `lastUpdateFailed`, `downloadCount`, `playState`. Keep existing `@Track` fields the UI already binds.

**ViewModel refactor (edit all 11 in `viewmodel/`):** delete every local mock spec array and builder; each `load()` becomes a repository query; each action (`toggleFavorite`, `toggleQueue`, `markPlayed`, `toggleSecondaryAction`, `reorder`, `removeAt`, `removeAll`, …) delegates to the repository mutator. Make all ViewModels `@Observed`. Subscribe to relevant EventBus events in a new `bind()` called from page `aboutToAppear`; reload on event. `EpisodeDetailViewModel`/`FeedDetailViewModel` load by id from repository (delete `EPISODE_SPECS`/`FEED_SPECS`/`resolveFeedId`).

**Page wiring (edit every page under `pages/`):** replace each `console.info('TODO: …')` with the real call:
- nav TODOs → `router.pushUrl` to the now-existing target (REQ-004 settings, REQ-005 add-feed, REQ-022 favorites, REQ-027 history, statistics, REQ-010 feed-settings/feed-info, download-log).
- episode open TODOs → `router.pushUrl('pages/EpisodeDetailPage',{episodeId})`.
- favorite/queue/played/download/share/website TODOs → `repository.toggleFavorite/enqueue/...`, `downloadService.start/cancel`, `PlaybackController`.
- MainPage: `lastContentTab`/`currentTab` restored from `PreferencesStore` (default/last page, REQ-002 sc.3); bottom-nav vs drawer gated by `bottomNavEnabled` (REQ-002 sc.4); More-menu dynamic item set = nav items NOT in the 4 slots + fixed Customize/Settings (REQ-003); Inbox badge = `repository.newEpisodeCount()` (REQ-001 sc.3, REQ-008 sc.5); refresh/configure overflow → repository+preferences.
- HomePage: empty-state switch on `countEpisodes()===0` with the welcome block + curved-arrow direction by nav mode (REQ-001); sections read queue/inbox/random/subscriptions/downloads from repository and re-render on `FEEDS_CHANGED`/`EPISODES_CHANGED`/`QUEUE_CHANGED`/`DOWNLOAD_PROGRESS` (REQ-008 sc.4).
- QueuePage: drag-handle visibility = `!lock && !keepSort` (REQ-015 sc.3, REQ-017); info-bar `count + remainingTime` computed from repository with `showRemainingTime`+`speedFactor` (REQ-015 sc.1); swipe-remove + undo (REQ-016 sc.1); lock/sort/clear (REQ-017/018).
- InboxPage: `isNew` filter; swipe-remove + ~2s undo (swipe-only) vs menu/bulk/all (no undo) + "don't ask again" (REQ-020/021).
- SubscriptionsPage: counter badge by `counterDisplay`; tags filter; multi-select bulk tag/unsubscribe; column count persisted (REQ-009).
- EpisodesPage/FeedDetailPage: sort+filter dialogs persist; multi-select bulk with confirm threshold; swipe actions; paged load (REQ-010/019).
- EpisodeDetailPage/AudioPlayerPage: primary button play/pause/stream/local by state; secondary download/cancel/delete with mobile-confirm dialog (REQ-012/013/024/025); shownotes timecode seek via PlaybackController (REQ-026); context menu per-state visibility.

**Registration (edit):** `resources/base/profile/main_pages.json` add new routes; `module.json5` add `ohos.permission.READ_MEDIA`/file-picker usage if local-folder/OPML wired (else leave picker-only, no permission). `oh-package.json5` needs no new dep (`@kit.ArkData`/`@kit.AbilityKit` are system kits).

## Forbidden
- Do NOT keep any ViewModel-local mock/spec array, builder, or id-mapping hack after refactor — one source only (`Repository`+`SampleData`).
- Do NOT use `PersistenceV2` or `AppStorage` as the entity truth owner (8KB/key, no Array, UI-coupled, frame-freeze). `AppStorage` mirrors `PlaybackController` only.
- Do NOT let two paths mutate the same field (e.g., download state written by both a page and a service) — all mutates flow through `Repository`/the owning service, which alone emit events.
- Do NOT change page `.build()` layout, component structure, or resource ids — logic stage only.
- Do NOT implement real RSS HTTP parsing, media HTTP download, or AVPlayer decode in this stage — go through the service interfaces with local impls (scope boundary).
- Do NOT mask "missing" as empty/first-item: Home empty keyed on `countEpisodes()===0`; Inbox empty on `isNew` count 0; distinct from "no subscriptions".
- Do NOT break the 8 existing `main_pages.json` routes; only append.
- Do NOT emit EventBus events from ViewModels or pages — repository/services own emission.

## Completion Evidence
- `grep -r "TODO\|console.info('TODO" entry/src/main/ets` returns zero `TODO` markers (all ~100 wired).
- No `EPISODE_SPECS`/`FEED_SPECS`/`buildMockData`/`resolveFeedId`/per-VM `COVER_RES` mock arrays remain; `viewmodel/*.ets` contain only repository delegation.
- `Repository.ets` defines every query+mutate listed; each mutate ends with an `EventBus.emit` of the matching event; `Db.ets` defines all 7 tables.
- Cold start with empty DB → `firstLaunchDone` seeds → Home/Queue/Inbox/Subscriptions/Episodes render the sample set; kill+relaunch → same data restored from relationalStore (no re-seed).
- Toggle favorite on EpisodeDetailPage → Favorites list, Episodes list item star, and (if present) player star all update without re-entering pages (EventBus proof of REQ-008/022).
- Subscribe via AddFeed preview → Subscriptions grows, Home switches off empty-state when episodes>0, Inbox badge updates (REQ-008 all four surfaces).
- Queue drag/lock/sort/clear persist across restart; per-page sort/filter persist.
- `hvigorw assembleHap` compiles (no new layout/resource changes → no UI regressions).
- `main_pages.json` lists all new pages; every More-menu/overflow item navigates to a real page.

## Unknown
- **Deferred engines (stubbed, non-blocking):** real RSS feed HTTP fetch+parse (REQ-006 online providers, REQ-007/008 live refresh) — `SampleFeedFetcher` returns local sample; real media-file HTTP download (REQ-013 engine) — `LocalDownloadService` simulates progress; real `AVPlayer` audio/video decode+render (REQ-024/025 playback output) — `LocalPlaybackService` drives state only; OPML import/export file+network (REQ-034/035); gpodder sync (REQ-039). These are wired through service interfaces so logic+UI are fully exercised; replacing the impls later requires no page/VM changes. Safe partial boundary: all entity state, persistence, events, navigation, local search, and state machines are complete; only the network/media engines are simulated.
- **coder must verify (non-blocking):** exact `relationalStore`/`preferences` API signatures and `@ohos.router` multi-level back-stack behavior preserving source scroll context.
