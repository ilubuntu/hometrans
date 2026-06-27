# Trace: pantry-clear (REQ-012)

> Pantry 清空。追踪 "Clear all" 清空全部食材的逻辑与联动恢复。

## 关键源文件
- `app/src/main/java/com/whaticancook/app/feature/pantry/PantryScreen.kt` — Clear all 入口
- `app/src/main/java/com/whaticancook/app/feature/pantry/PantryViewModel.kt` — clear
- `app/src/main/java/com/whaticancook/app/data/repository/PantryRepositoryImpl.kt` — 持久化清空
- `app/src/main/java/com/whaticancook/app/data/local/dao/PantryDao.kt` — clear 查询
- `app/src/main/java/com/whaticancook/app/feature/home/HomeScreen.kt` — 首页 pantry 卡片空态（联动验证）

## Clear all 入口（PantryScreen.kt:91-95）
仅当 items 非空时，"In your kitchen" 区的 SectionHeader 提供：
```
SectionHeader(title="In your kitchen", actionText="Clear all", onActionClick=viewModel::clear)
```

## 清空流程
1. 点击 "Clear all" → `viewModel.clear()`（PantryViewModel.kt:75-77）。
2. → `pantryRepository.clear()`。
3. PantryRepositoryImpl.clear（line 47-49）→ `pantryDao.clear()`。
4. PantryDao.clear（PantryDao.kt:22-23）：`DELETE FROM pantry_items` —— 删除全部食材行。

## 联动恢复（响应式）
食材库变为空后，通过 `observePantry()` 流广播：
- **Pantry 页**：items 空 → "In your kitchen" 区隐藏；Quick add 标题变 "Add ingredients"；全部目录项回到可选；副标题变 "Add what you have — we'll find the recipes"；count=0。
- **首页**：PantrySummaryCard 副标题变 "Add what you have at home"（HomeScreen.kt:253 count==0 分支）；cookNow 空（pantryNames 空）→ 不显示 "Ready to cook"，改显示 CookNowPrompt 空态提示。
- **搜索/详情**：所有菜谱匹配重算为空 pantry 状态（haveCount=0 → EXPLORE，胶囊 "0/N"；Cookable 筛选无结果）。

## 验证点
- 清空后 My pantry 副标题显示空态文案 ✅。
- 首页 pantry 卡片显示 "Add what you have at home" ✅。
- 无二次确认弹窗（代码直接 clear，无 confirm dialog）。

## 偏差/备注
- REQ 来源提及 SettingsScreen.kt：设置页另有 "Clear pantry" 入口（见 REQ-039，不在本批范围）。本规格聚焦 Pantry 页 "Clear all"。
- 清空无确认对话框（点击即清空）。规格中可建议迁移时评估是否需二次确认，但功能行为以代码为准（直接清空）。
- 清空后所有页面匹配状态恢复为空 pantry，依赖响应式流。
