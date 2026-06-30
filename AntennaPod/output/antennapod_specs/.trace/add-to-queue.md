# REQ-015 加入播放队列 - 代码追踪

## 需求
加入播放队列：从剧集列表/详情加入，队列页面显示

## 核心代码路径

### 1. 从剧集菜单加入队列
- `FeedItemMenuHandler.onMenuItemClicked()` (app/.../FeedItemMenuHandler.java:198)
  - `add_to_queue_item` → `DBWriter.addQueueItem(context, selectedItem)`
- `FeedItemMenuHandler.onPrepareMenu()` (L109):
  - `canAddToQueue`: 判断是否可加入队列（未标记 TAG_QUEUE 且有媒体）
  - `setItemVisibility(menu, R.id.add_to_queue_item, canAddToQueue)`

### 2. 从滑动操作加入队列
- `AddToQueueSwipeAction` (app/.../AddToQueueSwipeAction.java:14)
  - `performAction()` (L37):
    - 已在队列中 → 执行 RemoveFromQueueSwipeAction（切换移除）
    - 无媒体 → 显示"无媒体"提示
    - 否则 → `DBWriter.addQueueItem(context, item)`
  - `willRemove()` (L48): 在 showNotQueued 或 showNew 的列表中触发移除行为

### 3. 多选批量加入队列
- `EpisodeMultiSelectActionHandler.queueChecked()` (L74):
  - 过滤出有媒体且未在队列中的剧集
  - `DBWriter.addQueueItem(activity, toQueue.toArray())`
  - 显示消息："已添加 N 集到队列"

### 4. DBWriter.addQueueItem 数据库操作
- `DBWriter.addQueueItem()` (storage/database/.../DBWriter.java:378)
  - 获取当前队列
  - 使用 `ItemEnqueuePositionCalculator.calcPosition()` 计算插入位置
    - 根据 `UserPreferences.getEnqueueLocation()` 决定（顶部/底部/当前播放后）
  - 遍历要添加的剧集：
    - 跳过已在队列中的
    - 跳过无媒体的
    - 添加到计算的位置
    - 标记 `TAG_QUEUE`
    - 若是 NEW 状态 → 标记为 UNPLAYED
  - 若开启了"保持排序"：自动排序队列
  - 保存队列到数据库
  - 发送 QueueEvent.added 事件
  - 发送 FeedItemEvent 更新剧集标签
  - 触发自动下载

- `DBWriter.addQueueItemAt()` (L346):
  - 在指定索引插入（用于精确位置插入）

### 5. QueueEvent 事件通知
- QueueEvent.added(item, position):
  - QueueFragment.onEventMainThread() (QueueFragment.java:147):
    - `queue.add(event.position, event.item)` 添加到内存列表
    - `recyclerAdapter.notifyItemInserted(event.position)` 通知适配器
    - `refreshInfoBar()` 更新信息栏（集数、剩余时长）
    - `refreshToolbarState()` 更新工具栏

### 6. EpisodeItemListAdapter 队列标记显示
- 剧集列表中的每个 item 通过 `isInQueue` 标签显示队列状态
- QueueRecyclerAdapter.afterBindViewHolder() (L73): `holder.isInQueue.setVisibility(View.GONE)` （队列页内不显示队列标记）

## 关键交互流
1. 用户从剧集列表/详情选择"加入队列" → DBWriter.addQueueItem()
2. 计算插入位置 → 添加到队列 → 标记 TAG_QUEUE
3. 发送 QueueEvent.added → QueueFragment 更新列表
4. 队列页显示新添加的剧集
5. 剧集列表中的队列标记更新
