# REQ-018 清空队列 - 代码追踪

## 需求
清空队列：空状态，移除队列标记

## 核心代码路径

### 1. 清空队列触发入口
- `QueueFragment.onMenuItemClick()` (QueueFragment.java:288)
  - `clear_queue` (L299):
    - 创建确认对话框 `ConfirmationDialog`
    - 标题：R.string.clear_queue_label
    - 消息：R.string.clear_queue_confirmation_msg
    - `onConfirmButtonPressed()` (L306):
      - `dialog.dismiss()`
      - `DBWriter.clearQueue()`

### 2. DBWriter.clearQueue 数据库操作
- `DBWriter.clearQueue()` (DBWriter.java:455)
  - `runOnDbThread()`:
    - `adapter.open()` 打开数据库
    - `adapter.clearQueue()` 清空队列表中的所有记录
    - `adapter.close()` 关闭数据库
    - 发送 `QueueEvent.cleared()` 事件

### 3. QueueEvent.cleared 事件处理
- `QueueFragment.onEventMainThread(QueueEvent)` (QueueFragment.java:137)
  - `CLEARED` case (L162):
    - `queue.clear()` 清空内存列表
    - `recyclerAdapter.updateItems(queue)` 更新适配器（空列表）
    - `recyclerAdapter.updateDragDropEnabled()` 更新拖拽状态
    - `refreshToolbarState()` 刷新工具栏
    - `refreshInfoBar()` 刷新信息栏

### 4. 清空后的空状态
- `EmptyViewHandler` (在 onCreateView 中初始化, L471):
  - 图标：ic_playlist_play
  - 标题：R.string.no_items_header_label
  - 消息：R.string.no_items_label
  - 若有新剧集：消息变为"收件箱有新剧集" + 显示按钮

### 5. 清空后信息栏更新
- `refreshInfoBar()` (L499):
  - 队列为空时：集数为 0，剩余时长为 0
  - 显示："0 集 • 剩余 0m"

### 6. 队列标记的移除
- `adapter.clearQueue()` 在数据库层清空队列
- 注意：clearQueue 仅清空队列表，不修改 FeedItem 的 TAG_QUEUE 标签
- FeedItemEvent 未在 clearQueue 中发送
- FeedItem 的队列状态通过查询队列表动态判断（而非持久化标签缓存）
  - 实际上 TAG_QUEUE 是内存中的标签，DBWriter.removeQueueItemSynchronous 会移除标签
  - clearQueue 不触发 FeedItemEvent，但队列页 UI 会刷新
  - 剧集列表中的队列标记在下次加载时刷新

### 7. 清空后的播放服务行为
- 清空队列后，当前正在播放的媒体不受影响
- 播放完当前剧集后不会自动播放下一集（队列已空）
- PlaybackService 根据 queue 状态决定后续行为

### 8. 清空队列与自动下载
- clearQueue 不直接触发自动下载
- 但队列清空后，相关的自动下载逻辑会根据新的队列状态调整

## 关键交互流
1. 用户点击"清空队列" → 确认对话框
2. 确认 → DBWriter.clearQueue() → 清空数据库队列
3. QueueEvent.cleared → QueueFragment 清空列表 → 显示空状态
4. 信息栏更新为 0 集
5. 剧集列表中的队列标记在下次刷新时移除
