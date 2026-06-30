# REQ-016 队列页面 - 代码追踪

## 需求
队列页面：列表、剩余集数/时长、排序、清空、锁定

## 核心代码路径

### 1. QueueFragment 队列页面主体
- `QueueFragment` (app/.../QueueFragment.java:79)
  - 实现 `MaterialToolbar.OnMenuItemClickListener` 和 `EpisodeItemListAdapter.OnSelectModeListener`

  - `onCreateView()` (L404):
    - 初始化工具栏 (toolbar) 并 inflate `R.menu.queue` 菜单
    - 菜单项：queue_lock（锁定）、queue_sort（排序）、refresh_item（刷新）、clear_queue（清空）、action_search（搜索）
    - 初始化信息栏 (infoBar)
    - 初始化 RecyclerView + QueueRecyclerAdapter
    - 初始化 SwipeActions（滑动操作）
    - 初始化 SwipeRefreshLayout（下拉刷新）
    - 初始化 EmptyViewHandler（空状态视图）

### 2. 信息栏（剩余集数/时长）
- `refreshInfoBar()` (L499):
  - 遍历队列中所有剧集
  - 若启用 `timeRespectsSpeed`：按播放速度计算实际时间
  - 计算总剩余时长：`duration - position` 的累加
  - 显示格式："N 集 • 剩余 Xh Ym"

### 3. 队列数据加载
- `loadItems()` (L522):
  - 异步从 `DBReader.getQueue()` 加载队列数据
  - 同时查询是否有新剧集可加入队列
  - 加载完成后更新适配器并刷新信息栏
  - 支持恢复滚动位置

### 4. 排序功能
- `onMenuItemClick()` → `queue_sort` (L293):
  - 弹出 `QueueSortDialog`（内部类继承 ItemSortDialog）
- `QueueSortDialog` (L579):
  - 支持的排序方式：日期（新/旧）、标题（A-Z/Z-A）、时长（长/短）、随机、智能随机
  - "保持排序"复选框：启用后新加入的剧集自动排序
  - `onSelectionChanged()` (L609):
    - 更新 UserPreferences 中的排序偏好
    - 调用 `DBWriter.reorderQueue(sortOrder, true)` 重新排序
- `DBWriter.reorderQueue()` (DBWriter.java:894):
  - 使用 `FeedItemPermutors.getPermutor(sortOrder)` 获取排序器
  - 对队列执行排序
  - 保存到数据库
  - 发送 QueueEvent.sorted 事件

### 5. 清空队列
- `onMenuItemClick()` → `clear_queue` (L299):
  - 弹出确认对话框（`ConfirmationDialog`）
  - 确认后 → `DBWriter.clearQueue()`
- `DBWriter.clearQueue()` (DBWriter.java:455):
  - `adapter.clearQueue()` 清空数据库队列表
  - 发送 `QueueEvent.cleared()` 事件

### 6. 队列锁定
- `onMenuItemClick()` → `queue_lock` (L290):
  - `toggleQueueLock()` (L323):
    - 当前锁定 → 解锁
    - 当前未锁定 → 显示锁定警告对话框（首次）→ 锁定
  - `setQueueLocked()` (L350):
    - `UserPreferences.setQueueLocked(locked)` 保存状态
    - `recyclerAdapter.updateDragDropEnabled()` 更新拖拽可用性
    - 队列为空时发送锁定/解锁消息提示
  - `refreshToolbarState()` (L271):
    - 更新锁定按钮选中状态
    - "保持排序"时隐藏锁定按钮

### 7. 事件更新
- `onEventMainThread(QueueEvent)` (L137):
  - ADDED → 添加到列表并通知适配器
  - SET_QUEUE/SORTED → 更新整个列表
  - REMOVED → 从列表移除
  - CLEARED → 清空列表
  - MOVED → 移动位置
- `onEventMainThread(PlaybackPositionEvent)` (L221):
  - 更新当前播放项的进度
- `onPlayerStatusChanged()` (L236):
  - 重新加载列表

### 8. 空状态
- `EmptyViewHandler` (L471):
  - 图标、标题、消息
  - 若收件箱有新剧集：显示"前往收件箱"按钮

### 9. 搜索
- `action_search` (L314):
  - 加载 SearchFragment，过滤条件为 QUEUED

## 关键交互流
1. 进入队列页 → loadItems() 加载数据 → 显示列表和信息栏
2. 队列事件 → 实时更新列表（增/删/改/移/排序/清空）
3. 排序 → QueueSortDialog → DBWriter.reorderQueue() → 列表刷新
4. 清空 → 确认对话框 → DBWriter.clearQueue() → 显示空状态
5. 锁定 → 警告对话框 → 禁用拖拽和滑动
