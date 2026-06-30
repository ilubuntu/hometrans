# Code trace · search-page

## Status
status: ok
repo-id: AntennaPod
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 搜索页 (SearchFragment) — app/src/main/java/de/danoeh/antennapod/ui/screen/SearchFragment.java:67 — recalled by: both
- Entry 2: 各单集列表工具栏"搜索"入口 — EpisodesListFragment.onMenuItemClick action_search → loadChildFragment(SearchFragment.newInstance()) — recalled by: path 2
- Entry 3: 已下载页/节目详情等工具栏搜索 — CompletedDownloadsFragment.onMenuItemClick:180 action_search → SearchFragment.newInstance() — recalled by: path 2

## Entry · 搜索页容器 (SearchFragment，全库搜索)
- claim: 用户输入关键词，在全库中搜索单集（标题、描述）与节目（标题、作者、描述），结果分单集列表与节目横排展示，点击可进入详情
- layers:
  - code:     SearchFragment.java:67 (extends Fragment); newInstance():94（全库，feed=0，unfiltered）; onCreateView:147（SearchView + 单集列表 + 节目横排 + chip 过滤）; search():413
  - resource: R.layout.search_fragment; R.menu.search (action_search); R.string.search_label; R.drawable.ic_search; R.string.type_to_search / R.string.no_results_for_query 空状态; R.string.search_online
  - manifest: N/A: 由宿主 Activity 承载
- interaction: 内存 results（单集结果）、节目结果；ARG_QUERY/ARG_FEED/ARG_FILTER
- data_flow: onCreateView → search → searchItems/searchFeeds → 展示

## Entry · 单集搜索（按标题与描述）
- claim: 在全部节目中按关键词匹配单集的标题与描述，多词以"与"关系过滤，按发布时间倒序返回最多 300 条
- layers:
  - code:     SearchFragment.search:461 → DBReader.searchFeedItems(feed=0, query, filter) (storage/database/.../DBReader.java:790) → PodDBAdapter.searchItems:1429 — prepareSearchQuery 分词；匹配 KEY_DESCRIPTION LIKE 与 KEY_TITLE LIKE，多词 AND；ORDER BY KEY_PUBDATE DESC LIMIT 300；filter 经 FeedItemFilterQuery.generateFrom
  - resource: N/A: 查询由代码构造
  - manifest: N/A
- interaction: results 写入并刷新 EpisodeItemListAdapter
- data_flow: 搜索框输入 → search → searchFeedItems → PodDBAdapter.searchItems → 单集列表

## Entry · 节目搜索（按标题、作者、描述）
- claim: 在全部节目中按关键词匹配节目的标题/自定义标题/作者/描述，按标题升序返回最多 300 条（仅全库搜索且无单集级筛选时）
- layers:
  - code:     SearchFragment.search:452 → DBReader.searchFeeds(query, filter) (DBReader.java:803) → PodDBAdapter.searchFeeds:1475 — 匹配 KEY_TITLE / KEY_CUSTOM_TITLE / KEY_AUTHOR / KEY_DESCRIPTION LIKE，多词 AND；含订阅状态过滤；ORDER BY KEY_TITLE ASC LIMIT 300
  - resource: N/A
  - manifest: N/A
- interaction: 节目结果写入 HorizontalFeedListAdapter（横排）
- data_flow: 搜索框输入 → search → searchFeeds → PodDBAdapter.searchFeeds → 节目横排

## Entry · 搜索触发与防抖
- claim: 输入即触发搜索（带防抖）；提交搜索时显示进度；空查询提示"输入以搜索"
- layers:
  - code:     setupToolbar:246 SearchView.setOnQueryTextListener — onQueryTextChange:266 防抖（SEARCH_DEBOUNCE_INTERVAL=1500ms，空/结尾空格/超阈值立即搜，否则延迟 750ms）; onQueryTextSubmit:259 → searchWithProgressBar:374（显示进度条）; search:443 空 query → 显示 type_to_search
  - resource: R.id.progressBar; R.string.type_to_search
  - manifest: N/A
- interaction: lastQueryChange 时间戳、automaticSearchDebouncer
- data_flow: 输入变化 → (防抖) → search

## Entry · 点击结果进入详情
- claim: 点击单集结果进入单集详情（翻页浏览），点击节目结果进入节目页
- layers:
  - code:     EpisodeItemListAdapter onBindViewHolder 点击 :88 → MainActivity.loadChildFragment(ItemPagerFragment.newInstance(episodes, item))（单集详情翻页）; HorizontalFeedListAdapter.onClick:191 → 进入节目页; SearchFragment.onContextItemSelected:296 单项菜单
  - resource: N/A
  - manifest: N/A
- interaction: 进入详情页/节目页
- data_flow: 单集结果点击 → ItemPagerFragment；节目结果点击 → 节目页

## Entry · 在线搜索入口与筛选 chip
- claim: 提供"在线搜索"入口（搜索订阅源之外的网络节目）；筛选 chip 可移除（队列/归档/限定节目范围）
- layers:
  - code:     searchOnline:472 — URL→OnlineFeedviewActivity，否则 OnlineSearchFragment.newInstance(CombinedSearcher, query); adapterFeeds.setEndButton(search_online):440; updateChipVisibility:380（chip：QUEUED/INCLUDE_ARCHIVED/ARG_FEED，可关闭→searchWithProgressBar）
  - resource: R.string.search_online; R.layout.item_tag_chip; R.string.queue_label / R.string.archive_feed_label_noun
  - manifest: N/A
- interaction: 在线搜索切换页面；chip 移除更新 ARG_FILTER/ARG_FEED
- data_flow: 在线搜索按钮 → OnlineSearchFragment/OnlineFeedview；chip 关闭 → searchWithProgressBar → search

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: FeedListUpdateEvent（订阅变化）— SearchFragment.onFeedListChanged:315 — 行为：重新搜索
- Trigger: PlayerStatusEvent（播放状态变化）— onPlayerStatusChanged:370 — 行为：重新搜索以更新结果状态
- Trigger: FeedItemEvent（单集状态变化）— onEventMainThread:320 — 行为：增量更新结果项
- Trigger: EpisodeDownloadEvent（下载进度）— onEventMainThread:344 — 行为：刷新结果项下载状态

## Core business entities (data model / persistence key / state machine)
- 搜索词：prepareSearchQuery 分词；LIKE %word% 匹配
- 单集匹配字段：KEY_TITLE、KEY_DESCRIPTION；节目匹配字段：KEY_TITLE、KEY_CUSTOM_TITLE、KEY_AUTHOR、KEY_DESCRIPTION
- 结果上限：300 条；单集按 PUBDATE DESC，节目按 TITLE ASC
- ARG_FEED（0=全库）/ ARG_FILTER（QUEUED/INCLUDE_ARCHIVED 等）

## Cross-entry shared declarations
- 无独立清单声明；搜索为数据库查询，由宿主 Activity 承载页面；节目详情/在线搜索复用既有页面

## Deviations from REQ_DESC
1. REQ_DESC 提及"by title, podcast, description"，代码实现：单集按标题+描述匹配，节目按标题+自定义标题+作者+描述匹配；"podcast（节目）"作为独立结果区展示——与描述一致
2. 搜索结果上限 300 条——属实现细节，spec 注明
(empty → None)

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 各单集列表（总列表/收件箱/收藏/历史/已下载/节目详情/队列等）工具栏"搜索"→ SearchFragment（全库）
（均为同一 SearchFragment 全库搜索页）

### Consumers (who reads this state / data)
- EpisodeItemListAdapter / HorizontalFeedListAdapter: 渲染单集/节目结果
- ItemPagerFragment: 单集详情翻页

### Non-consumers (boundary counter-examples with evidence)
- claim: 订阅内搜索（限定单个节目）不在本页默认范围，属 search-in-podcast 特性
  closure_layers: [code]
  tools: [mcp__gitnexus__context SearchFragment]
  zero_hits: newInstance(feed, feedTitle) 为订阅内搜索专用构造；全库 newInstance() feed=0

## Same-source cross-reference (if applicable)
- 全库搜索（本页）与订阅内搜索（search-in-podcast）共用 SearchFragment，差别在 ARG_FEED 是否限定单个节目；两 spec 独立生成并互相引用
