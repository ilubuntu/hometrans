# Code trace · pantry-remove

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 已添加食材 chip + 关闭图标 (PantryChip) — PantryScreen.kt:192-214 — recalled by: both
- Entry 2: 删除落库与列表刷新 — PantryViewModel.kt:71-73; PantryRepositoryImpl.kt:43-45 — recalled by: both

## Entry · 已添加食材 chip + 关闭图标 (PantryChip)
- claim: 已添加食材以胶囊展示，点击该胶囊（含其上的关闭"x"图标）即删除该单个食材
- layers:
  - code:     PantryScreen.kt:192-214 PantryChip (item.display + Close 图标); PantryScreen.kt:197 整 chip bounceClick(onClick=onRemove); PantryScreen.kt:207-212 Close 图标 (contentDescription="Remove X"); PantryScreen.kt:99-101 每个 item 渲染 PantryChip(onRemove=viewModel.remove(item))
  - resource: N/A
  - manifest: N/A
- interaction: 点击 chip 任意位置（含 x 图标）→ onRemove → viewModel.remove(item)
- data_flow: 点击 (PantryScreen.kt:197) → onRemove (PantryScreen.kt:100) → viewModel.remove(item) (PantryScreen.kt:100) → pantryRepository.remove(item.name) (PantryViewModel.kt:72)

## Entry · 删除落库与列表刷新
- claim: 删除按归一化名从食材库表移除该行，已添加区与数量同步刷新；被删项消失
- layers:
  - code:     PantryViewModel.kt:71-73 remove(item)→pantryRepository.remove(item.name); PantryRepositoryImpl.kt:43-45 remove：pantryDao.remove(normalize(name)); PantryDao.kt:19-20 `DELETE FROM pantry_items WHERE name=:name`; 刷新经 observeAll (PantryDao.kt:13) → observePantry (PantryRepositoryImpl.kt:25) → items (PantryViewModel.kt:55)
  - resource: N/A
  - manifest: N/A
- interaction: 按归一化名删除（与添加时归一化名一致）；删除后该 chip 从"In your kitchen"消失，count-1；若删除后食材库为空，"In your kitchen"区与"Clear all"整体隐藏 (PantryScreen.kt:89)，副标题回空库文案
- data_flow: remove (PantryViewModel.kt:71) → repository.remove(item.name) (:72) → normalize (PantryRepositoryImpl.kt:44) → pantryDao.remove (PantryRepositoryImpl.kt:44) → observeAll (PantryDao.kt:13) → observePantry → items → "In your kitchen"区刷新 (PantryScreen.kt:99) + count (PantryViewModel.kt:33)

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 食材库变化 — PantryViewModel.kt:41 — behavior: 删除后已添加区与数量刷新；被删项消失
- Trigger: 删除后食材库变空 — PantryScreen.kt:89,108 — behavior: "In your kitchen"区与"Clear all"隐藏，"Quick add"标题改作"Add ingredients"，副标题回空库文案

## Core business entities (data model / persistence key / state machine)
- Entity: PantryItem(name,category,addedAt,display) — domain.model.PantryItem；chip 显示 display (PantryScreen.kt:202)
- Entity: pantry_items 表 — PantryItemEntity.kt:6-10，主键 name(归一化)；删除按 name 精确匹配
- 依赖来源: 已添加区位置见 `pantry-layout` (REQ-008)；归一化见 `ingredient-normalize` (REQ-014)

## Cross-entry shared declarations
- PantryRepository.remove(name) (PantryRepositoryImpl.kt:43): 单个删除入口；与"清空"(`pantry-clear`) 共用 pantry_items 表但操作不同（按名删一行 vs 删全部）
- PantryDao (PantryDao.kt): remove/clear/upsert 共用同一表

## Deviations from REQ_DESC
1. REQ_DESC 称"点击 x 删除单个食材"——代码 onRemove 绑定在整 chip 可点击区（含 x 与名称），点击 chip 任意位置即触发删除 (PantryScreen.kt:197)，与"点击 x"等价，无冲突
2. REQ_DESC 验收"Cucumber 从 In your kitchen 消失，食材数量减少"——代码删除后 items 减少、chip 消失 (PantryScreen.kt:99)、count-1 (PantryViewModel.kt:33)，一致
3. REQ_DESC 未提及删除按归一化名匹配——代码 remove 传 item.name，repository 再 normalize 后按名删除 (PantryRepositoryImpl.kt:44)，因添加时已归一化存储，名一致，无冲突

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 单个删除入口为全应用唯一的已添加食材 chip（含 x）(PantryScreen.kt:192-214)；无其他页面提供单个删除入口
  layers: code PantryScreen.kt:97-103,192-214; resource N/A; manifest N/A
  interaction/data_flow: 同 Entry · 已添加食材 chip + Entry · 删除落库与列表刷新

### Consumers (who reads this state / data)
- Consumer: 食材库页"In your kitchen"区与数量副标题读取 items — PantryScreen.kt:99,70
- Consumer: 首页/搜索页/详情页读取同一食材库做匹配 — HomeViewModel.kt:71（删除后跨页匹配同步刷新）

### Non-consumers (boundary counter-examples with evidence)
- claim: 单个删除不弹确认对话框，点击即立即删除
  closure_layers: [code]
  tools: [Read PantryScreen.kt:192-214, Read PantryViewModel.kt:71-73]
  zero_hits: PantryChip onRemove 直接 viewModel.remove，中间无 Dialog/确认；PantryViewModel.remove 直接 repository.remove，无确认分支
- claim: 首页"Your pantry"卡、搜索页、详情页均不提供单个食材删除入口；删除仅在食材库页进行
  closure_layers: [code]
  tools: [mcp__homegraph__callers "remove", Grep "viewModel.remove|onRemove" over app/src]
  zero_hits: homegraph__callers "remove"（PantryViewModel.remove）仅 PantryScreen.kt:100；其他页面未调用食材删除

## Same-source cross-reference (if applicable)
- 单个删除与"清空全部"(`pantry-clear-SPEC.md`, REQ-012) 共用 pantry_items 表；区别为单个删除按名删一行、清空删全部行。两规独立生成
- 删除后若食材库变空，会触发首页空食材提示（见 `empty-pantry-hint-SPEC.md`, REQ-005）与食材库页布局调整（见 `pantry-layout-SPEC.md` 场景三）
