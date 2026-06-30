# Code trace · favorites

## Status
status: ok
repo-id: AntennaPod
backend: gitnexus

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 收藏页 (FavoritesFragment) — app/src/main/java/de/danoeh/antennapod/ui/screen/FavoritesFragment.java:20 — recalled by: both
- Entry 2: 单集长按菜单"加入/取消收藏" — FeedItemMenuHandler.add_to_favorites_item/remove_from_favorites_item (app/.../episodeslist/FeedItemMenuHandler.java:202,204) — recalled by: path 2
- Entry 3: 列表项滑动收藏 (MarkFavoriteSwipeAction) — app/.../swipeactions/MarkFavoriteSwipeAction.java:12 — recalled by: path 2
- Entry 4: 多选批量"加入/取消收藏" — EpisodeMultiSelectActionHandler.addToFavoritesChecked:169 / removeFromFavoritesChecked:180 — recalled by: path 2

## Entry · 收藏页容器 (FavoritesFragment)
- claim: 展示所有被标记为收藏的单集（含已退订节目的收藏），按总列表排序分页加载
- layers:
  - code:     FavoritesFragment.java:20 (extends EpisodesListFragment); FILTER_FAVORITES = IS_FAVORITE + INCLUDE_ALL_FEED_STATES (:22-23); loadData:58 → DBReader.getEpisodes(0, page*150, FILTER_FAVORITES, getAllEpisodesSortOrder()); loadMoreData:65; loadTotalItemCount:71
  - resource: app/src/main/res/menu/favorites.xml (仅 search/refresh，无排序/筛选菜单，沿用总列表排序); R.string.favorite_episodes_label 标题; R.drawable.ic_star 空状态图标; R.string.no_fav_episodes_head_label / R.string.no_fav_episodes_label 空状态文案
  - manifest: N/A: 由宿主 Activity 承载
- interaction: 内存 episodes 列表、page、hasMoreItems
- data_flow: onStart → loadItems → loadData → DBReader.getEpisodes(IS_FAVORITE filter) → PodDBAdapter

## Entry · 单集收藏切换（长按菜单）
- claim: 在任意单集列表长按菜单中，根据是否已收藏显示"加入收藏"或"取消收藏"，点击后切换收藏状态
- layers:
  - code:     FeedItemMenuHandler:71-128 (canAddFavorite/canRemoveFavorite 可见性判断 by isTagged(TAG_FAVORITE)); onMenuItemClicked:202 (add→DBWriter.addFavoriteItems) / :204 (remove→DBWriter.removeFavoriteItems); 菜单可见性 :127-128
  - resource: R.id.add_to_favorites_item / R.id.remove_from_favorites_item (feeditem_menu); R.string.add_to_favorite_label / R.string.remove_from_favorite_label
  - manifest: N/A
- interaction: DBWriter.addFavoriteItems → item.addTag(TAG_FAVORITE) + 数据库写入 + EventBus FeedItemEvent (DBWriter.java:536-545); removeFavoriteItems → removeTag + DB + event (:548); toggleFavoriteItem:528
- data_flow: 单集长按菜单 → 加入/取消收藏 → DBWriter → PodDBAdapter.addFavoriteItems/removeFavoriteItems → FeedItemEvent → 各列表刷新

## Entry · 列表项滑动收藏切换 (MarkFavoriteSwipeAction)
- claim: 在单集列表项上滑动可切换其收藏状态（已收藏则取消，未收藏则加入）
- layers:
  - code:     MarkFavoriteSwipeAction.performAction:35 → DBWriter.toggleFavoriteItem(item); willRemove:40 (在收藏页/筛选收藏时移除该项); SwipeActions 绑定于 EpisodesListFragment.onCreateView
  - resource: R.drawable.ic_star; R.attr.icon_yellow; R.string.add_to_favorite_label
  - manifest: N/A
- interaction: 同 toggleFavoriteItem
- data_flow: 列表项滑动 → MarkFavoriteSwipeAction.performAction → toggleFavoriteItem → add/removeFavoriteItems

## Entry · 批量收藏切换（多选）
- claim: 多选模式下可批量将所选单集加入或取消收藏，并提示操作数量
- layers:
  - code:     EpisodeMultiSelectActionHandler.addToFavoritesChecked:169 (统计未收藏数 → DBWriter.addFavoriteItems → showMessage added_to_favorites_message); removeFromFavoritesChecked:180 (统计已收藏数 → removeFavoriteItems → removed_from_favorites_message); 触发于 performMultiSelectAction:240 (悬浮菜单 add_to_favorites_item/remove_from_favorites_item)
  - resource: app/src/main/res/menu/episodes_apply_action_speeddial.xml:50 add_to_favorites_item; :55 remove_from_favorites_item; R.plurals.added_to_favorites_message / R.plurals.removed_from_favorites_message
  - manifest: N/A
- interaction: 数据库批量写入 TAG_FAVORITE
- data_flow: 多选菜单 → 加入/取消收藏 → addToFavoritesChecked/removeFromFavoritesChecked → DBWriter → 各列表刷新

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: FeedItemEvent（单集收藏状态变化）— EpisodesListFragment.onEventMainThread:329 — 行为：增量更新收藏列表（新收藏项加入、取消项移除）
- Trigger: 收藏操作后 EventBus FeedItemEvent(items,false) — DBWriter.java:544 — 行为：收藏页与其他列表同步刷新收藏星标

## Core business entities (data model / persistence key / state machine)
- FeedItem.TAG_FAVORITE: 收藏标记（model 模块），单集的收藏状态位
- FeedItemFilter.IS_FAVORITE / INCLUDE_ALL_FEED_STATES: 收藏页固定筛选（含退订节目的收藏）
- EPISODES_PER_PAGE=150: 分页大小
- 排序沿用 UserPreferences.getAllEpisodesSortOrder()

## Cross-entry shared declarations
- MainActivity（清单声明的宿主 Activity）承载收藏页；收藏切换入口（长按菜单/滑动/多选）由各 EpisodeListFragment 列表页共享；无针对收藏的独立清单组件声明

## Deviations from REQ_DESC
1. REQ_DESC 提及"Favorites page shows them"，代码实现为按 IS_FAVORITE 筛选且 INCLUDE_ALL_FEED_STATES（含已退订节目），与描述一致
2. 收藏页菜单仅有 search/refresh，未提供排序/筛选入口（沿用总列表排序）——属实现细节，spec 以实际入口为准
(empty → None)

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 抽屉导航"收藏"入口 → MainActivity.createFragmentInstance → FavoritesFragment
- 任意单集列表（总列表/收件箱/下载/节目详情等）的单集长按菜单 → 加入/取消收藏
- 任意单集列表项的滑动收藏（若用户配置了滑动动作）
- 多选模式下悬浮菜单的批量加入/取消收藏

### Consumers (who reads this state / data)
- EpisodeItemViewHolder.isFavorite:105: 列表项渲染收藏星标（isTagged TAG_FAVORITE 时显示）
- FavoritesFragment: 按 IS_FAVORITE 筛选展示
- ExceptFavoriteCleanupAlgorithm: 收藏项不参与自动清理（保护已收藏单集的下载）

### Non-consumers (boundary counter-examples with evidence)
- claim: 单集总列表页本身不限定为收藏项，仅当用户在筛选面板选中"收藏"时才显示收藏项
  closure_layers: [code, resource]
  tools: [Read episodes.xml, mcp__gitnexus__context AllEpisodesFragment]
  zero_hits: AllEpisodesFragment.getFilter 读取用户偏好筛选值，默认不限定收藏；FavoritesFragment 才固定 IS_FAVORITE

## Same-source cross-reference (if applicable)
- 收藏页与总列表页共用 EpisodesListFragment 基类机制；两 spec 独立生成
