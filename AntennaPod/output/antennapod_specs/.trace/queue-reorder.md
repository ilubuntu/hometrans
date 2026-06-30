# REQ-017 队列排序与移动 - 代码追踪

## 需求
队列排序与移动：拖拽或菜单，移动到顶部/底部

## 核心代码路径

### 1. 拖拽排序
- `QueueFragment.QueueSwipeActions` (QueueFragment.java:662)
  - 继承 SwipeActions，支持 UP | DOWN 方向拖拽
  - `isLongPressDragEnabled()` (L706): 返回 false（仅通过拖拽手柄触发）
  
  - `onMove()` (L673):
    - 记录拖拽起始位置 (dragFrom) 和目标位置 (dragTo)
    - 在内存列表中实时移动：`queue.add(to, queue.remove(from))`
    - `recyclerAdapter.notifyItemMoved(from, to)` 通知适配器
  
  - `clearView()` (L711):
    - 拖拽结束时检查是否有实际移动
    - `reallyMoved(dragFrom, dragTo)` (L721):
      - `DBWriter.moveQueueItem(from, to, true)` 持久化到数据库

### 2. 拖拽手柄
- `QueueRecyclerAdapter.afterBindViewHolder()` (QueueRecyclerAdapter.java:40)
  - `dragDropEnabled` 标志：`!isQueueKeepSorted() && !isQueueLocked()`
  - 若启用拖拽：
    - 拖拽手柄 (dragHandle) 可见
    - 封面左半区域也可触发拖拽
    - ACTION_DOWN → `swipeActions.startDrag(holder)`
  - 若禁用拖拽：隐藏拖拽手柄
  - 多选模式下禁用拖拽

### 3. 上下文菜单移动到顶部/底部
- `QueueFragment.onContextItemSelected()` (QueueFragment.java:366)
  - `move_to_top_item` (L388):
    - 内存中移动：`queue.add(0, queue.remove(position))`
    - 通知适配器
    - `DBWriter.moveQueueItemsToTop(singletonList(selectedItem))`
  - `move_to_bottom_item` (L393):
    - 内存中移动：`queue.add(queue.remove(position))`
    - 通知适配器
    - `DBWriter.moveQueueItemsToBottom(singletonList(selectedItem))`

### 4. 多选批量移动
- `QueueFragment.onCreateView()` 中的 recyclerAdapter (L442):
  - `onSelectedItemsUpdated()` (L450):
    - `canMove(queue, selectedItems)` 计算是否可移动到顶部/底部
    - `menu.findItem(R.id.move_to_top_item).setVisible(canMove.first)`
    - `menu.findItem(R.id.move_to_bottom_item).setVisible(canMove.second)`
  - floatingSelectMenu 的菜单点击 → EpisodeMultiSelectActionHandler

### 5. canMove 移动可行性检查
- `QueueFragment.canMove()` (L636):
  - 返回 Pair<canMoveToTop, canMoveToBottom>
  - 不可移动条件：
    - 选中为空、队列为空、队列已锁定、保持排序模式、选中数=队列总数
  - 单项选中：
    - 已在顶部 → 不可移到顶部
    - 已在底部 → 不可移到底部
  - 多项选中：
    - 连续在顶部 → 不可移到顶部
    - 连续在底部 → 不可移到底部
  - 其他情况均可移动

### 6. QueueRecyclerAdapter 上下文菜单
- `onCreateContextMenu()` (QueueRecyclerAdapter.java:77):
  - 非 ActionMode：
    - move_to_top_item 可见性：若已在顶部或保持排序 → 隐藏
    - move_to_bottom_item 可见性：若已在底部或保持排序 → 隐藏
  - ActionMode：隐藏移动选项

### 7. DBWriter 数据库操作
- `DBWriter.moveQueueItem()` (DBWriter.java:569):
  - 获取队列，移动元素，保存，发送 QueueEvent.moved

- `DBWriter.moveQueueItemsToTop()` (DBWriter.java:588):
  - `moveQueueItemsSynchronous(true, items)`
  - 反转选中项顺序 → 从队列移除 → 依次插入到索引 0

- `DBWriter.moveQueueItemsToBottom()` (DBWriter.java:592):
  - `moveQueueItemsSynchronous(false, items)`
  - 从队列移除选中项 → 依次追加到末尾

- `moveQueueItemsSynchronous()` (L596):
  - 先发送 QueueEvent.setQueue（移除后）
  - 再逐个发送 QueueEvent.moved（添加后）

## 关键交互流
1. 拖拽手柄/封面 → onMove 实时移动 → clearView → DBWriter.moveQueueItem 持久化
2. 右键菜单 → 移到顶部/底部 → DBWriter.moveQueueItemsToTop/Bottom
3. 多选 → floatingSelectMenu → 批量移到顶部/底部
4. canMove 检查 → 控制菜单项可见性
