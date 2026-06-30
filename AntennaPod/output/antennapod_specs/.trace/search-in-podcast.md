# Code trace · search-in-podcast

## Status
status: ok
repo-id: AntennaPod
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 订阅内搜索页 (SearchFragment, feed-scoped) — app/src/main/java/de/danoeh/antennapod/ui/screen/SearchFragment.java:67 — recalled by: both
- Entry 2: 节目单集列表工具栏搜索入口 — FeedItemlistFragment.onMenuItemClick:329 action_search → loadChildFragment(SearchFragment.newInstance(feed.getId(), feed.getTitle())) — recalled by: path 2

## Entry · 订阅内搜索页容器 (SearchFragment, ARG_FEED != 0)
- claim: 用户在某个已订阅节目的单集列表页点击搜索，进入仅限该节目范围的搜索页，按标题与描述搜索单集，结果只含单集（不含节目/订阅结果），顶部显示节目范围标签可移除以切换为全库搜索
- layers:
  - code:     SearchFragment.java:67 (extends Fragment); newInstance(feed, feedTitle):115（ARG_FEED=feedId, ARG_FEED_NAME=title）; onCreateView:147; search():413 — feed=getLong(ARG_FEED)≠0
  - resource: R.layout.search_fragment; R.menu.search (action_search); R.string.search_label; R.drawable.ic_search; R.string.type_to_search / R.string.no_results_for_query; R.layout.item_tag_chip
  - manifest: N/A: 由宿主 Activity 承载
- interaction: ARG_FEED（节目 id）/ ARG_FEED_NAME（节目标题）/ ARG_FILTER
- data_flow: FeedItemlistFragment 搜索 → SearchFragment(feed) → search → searchFeedItems(feed) → 单集列表

## Entry · 订阅内单集搜索（按标题与描述，限定单个节目）
- claim: 在指定节目范围内按关键词匹配单集的标题与描述，多词以"与"关系过滤，按发布时间倒序返回最多 300 条；该节目下所有状态的单集（含归档）均可被搜索
- layers:
  - code:     SearchFragment.search:461 → DBReader.searchFeedItems(feed, query, filter) (DBReader.java:790) → PodDBAdapter.searchItems:1429 — feedID≠0 → queryFeedId = KEY_FEED = feedID；effectiveFilter = INCLUDE_ALL_FEED_STATES（含归档等所有状态）；匹配 KEY_DESCRIPTION LIKE 与 KEY_TITLE LIKE，多词 AND；ORDER BY KEY_PUBDATE DESC LIMIT 300
  - resource: N/A: 查询由代码构造
  - manifest: N/A
- interaction: results 写入 EpisodeItemListAdapter
- data_flow: 搜索框输入 → search → searchFeedItems(feed) → PodDBAdapter.searchItems(feedID) → 单集列表

## Entry · 订阅内搜索不展示节目结果
- claim: 当 ARG_FEED≠0（订阅内搜索）时，不执行节目搜索，节目结果区置空；在线搜索入口也被禁用
- layers:
  - code:     SearchFragment.search:438 isSearchingFeed=true → :448 if (feed != 0 || hasEpisodeFilter) → adapterFeeds.updateData(Collections.emptyList()); :441 adapterFeeds.setEndButton(..., (isSearchingFeed || hasEpisodeFilter) ? null : this::searchOnline)
  - resource: N/A
  - manifest: N/A
- interaction: 节目横排为空；在线搜索按钮隐藏
- data_flow: search → 跳过 searchFeeds → 节目区空

## Entry · 节目范围标签与切换全库
- claim: 订阅内搜索时顶部显示节目名称标签（可关闭），关闭后 ARG_FEED 置 0，切换为全库搜索并重新执行
- layers:
  - code:     SearchFragment.updateChipVisibility:395 — if (ARG_FEED≠0) addChip(ARG_FEED_NAME, closeListener → putLong(ARG_FEED,0); searchWithProgressBar())
  - resource: R.layout.item_tag_chip
  - manifest: N/A
- interaction: 关闭标签 → ARG_FEED=0 → 全库搜索
- data_flow: 标签关闭 → searchWithProgressBar → search（feed=0）

## Entry · 搜索触发与防抖（与全库搜索一致）
- claim: 输入即触发搜索（带防抖）；提交搜索时显示进度；空查询提示"输入以搜索"
- layers:
  - code:     setupToolbar:246 SearchView.setOnQueryTextListener — onQueryTextChange:266 防抖（SEARCH_DEBOUNCE_INTERVAL=1500ms）；onQueryTextSubmit:259 → searchWithProgressBar:374
  - resource: R.id.progressBar; R.string.type_to_search
  - manifest: N/A
- interaction: lastQueryChange、automaticSearchDebouncer
- data_flow: 输入变化 → (防抖) → search

## Entry · 点击结果进入详情（与全库搜索一致）
- claim: 点击单集结果进入单集详情翻页
- layers:
  - code:     EpisodeItemListAdapter onBindViewHolder 点击 :88 → MainActivity.loadChildFragment(ItemPagerFragment.newInstance(episodes, item))
  - resource: N/A
  - manifest: N/A
- interaction: 进入单集详情页
- data_flow: 单集结果点击 → ItemPagerFragment

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: FeedListUpdateEvent — onFeedListChanged:315 — 行为：重新搜索
- Trigger: PlayerStatusEvent — onPlayerStatusChanged:370 — 行为：重新搜索
- Trigger: FeedItemEvent — onEventMainThread:320 — 行为：增量更新结果项
- Trigger: EpisodeDownloadEvent — onEventMainThread:344 — 行为：刷新下载状态

## Core business entities (data model / persistence key / state machine)
- 搜索范围：ARG_FEED（节目 id，≠0 表示订阅内）
- 单集匹配字段：KEY_TITLE、KEY_DESCRIPTION；LIKE %word% 匹配；多词 AND
- 状态范围：INCLUDE_ALL_FEED_STATES（订阅内搜索包含归档等所有状态单集）
- 结果上限：300 条；按 KEY_PUBDATE DESC

## Cross-entry shared declarations
- 无独立清单声明；与全库搜索共用 SearchFragment 与 EpisodeItemListAdapter

## Deviations from REQ_DESC
(empty → None)

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 节目单集列表页（FeedItemlistFragment）工具栏"搜索"→ SearchFragment(feed)
（唯一入口；其他入口 newInstance() 均为全库搜索，属 search-page 特性）

### Consumers (who reads this state / data)
- EpisodeItemListAdapter: 渲染单集结果
- ItemPagerFragment: 单集详情翻页

### Non-consumers (boundary counter-examples with evidence)
- claim: 全库搜索不属本特性
  closure_layers: [code]
  tools: [mcp__gitnexus__context SearchFragment]
  zero_hits: newInstance() feed=0 为全库搜索，属 search-page 特性

## Same-source cross-reference (if applicable)
- 订阅内搜索（本页）与全库搜索（search-page）共用 SearchFragment，差别仅在 ARG_FEED 是否限定单个节目；关闭节目范围标签即切换为全库搜索。两 spec 独立生成并互相引用。
