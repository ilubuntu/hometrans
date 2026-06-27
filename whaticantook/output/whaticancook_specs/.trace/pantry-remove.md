# Trace: pantry-remove (REQ-011)

> Pantry 移除单个食材。追踪 "In your kitchen" 食材 chip 关闭按钮的移除逻辑及联动。

## 关键源文件
- `app/src/main/java/com/whaticancook/app/feature/pantry/PantryScreen.kt` — PantryChip
- `app/src/main/java/com/whaticancook/app/feature/pantry/PantryViewModel.kt` — remove
- `app/src/main/java/com/whaticancook/app/data/repository/PantryRepositoryImpl.kt` — 持久化移除
- `app/src/main/java/com/whaticancook/app/data/local/dao/PantryDao.kt` — remove 查询
- `app/src/main/java/com/whaticancook/app/domain/model/CookMatch.kt` — normalize（移除按归一名）

## PantryChip（PantryScreen.kt:192-214）
- 圆角标签（primaryContainer 背景），文本 item.display + Close 图标。
- 整 chip 可点击（bounceClick(onClick = onRemove)，pressedScale=0.9）。
- onRemove 来源（line 100）：`{ viewModel.remove(item) }`。

## 移除流程
1. 点击 chip（含关闭按钮）→ `viewModel.remove(item)`（PantryViewModel.kt:71-73）。
2. → `pantryRepository.remove(item.name)`。
3. PantryRepositoryImpl.remove（line 43-45）：`pantryDao.remove(IngredientMatching.normalize(name))`。
   - **按归一化名删除**（与添加时存储的归一名一致），保证删除准确。

## 联动更新（响应式，跨页面）
- 食材库变化通过 `observePantry()` 流广播。
- Pantry 页 uiState 重算（PantryViewModel.kt:41-59）：items 少一项 → "In your kitchen" 少一 chip、count -1；present 集合少该项 → suggestionGroups 重新包含该食材（**回到 Quick add 可选状态**）。
- 首页/搜索页/详情页均 observe 同一 pantry 流 → 匹配状态（CookMatch）重算 → 菜谱匹配计数/可做状态同步变化。

## 验证点
- 删除 Garlic（PRODUCE 目录项）：
  - count 减少（如 5→4）。
  - Garlic 从 "In your kitchen" 消失，重新出现在 Quick add 的 Produce 组。
  - 需要 garlic 的菜谱（如 Chicken Fried Rice 含 garlic 必需食材）匹配状态同步变化（haveCount 减少，可能从可做降级为缺少）。✅

## 偏差/备注
- 整个 chip（含关闭图标）都是点击移除区域；无单独选中态。
- 移除与添加共用归一化键，确保幂等。
- 跨页面同步依赖响应式数据流，无需手动刷新。
