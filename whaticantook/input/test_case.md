# WhatCanICook 验收测试用例

说明：以下用例面向 HomeTrans 迁移后的 HarmonyOS 应用自测和人工验收。HarmonyOS 自测固定 bundle name 为 `com.example.whaticancookharmony`，启动应用必须使用该 bundle name，不通过桌面图标或显示名猜测。

### Scenario: 首次启动并跳过引导进入首页
- 覆盖需求：REQ-001, REQ-002, REQ-004
- 前置条件：清除应用数据后首次启动。
- 动作：打开应用 -> 查看 Onboarding 首屏 -> 点击 Skip。
- 预期结果：首屏包含 Skip、Next、页码指示器、标题 Cook with what you have；点击 Skip 后进入 Discover 首页，显示 What can I cook?、Search recipes, ingredients...、Your pantry、Browse recipes 和底部导航。

### Scenario: 首页离线展示菜谱数据
- 覆盖需求：REQ-003, REQ-006, REQ-007, REQ-042
- 前置条件：已完成引导，无需登录和联网。
- 动作：打开 Discover 首页 -> 查看菜谱列表 -> 点击 Dinner 分类。
- 预期结果：首页不长期停留在加载态；菜谱列表至少展示 5-Minute Mug Cake、Banana Oat Pancakes 或 Chicken Fried Rice 中的一个；切到 Dinner 后可看到 Chicken Fried Rice。

### Scenario: 首页进入 Pantry 并快速添加食材
- 覆盖需求：REQ-005, REQ-008, REQ-009, REQ-013
- 前置条件：pantry 为空，处于 Discover 首页。
- 动作：点击 Your pantry -> 进入 My pantry -> 依次点击 Carrot、Garlic、Onion。
- 预期结果：进入 My pantry 页面；页面包含 Add your own ingredient...、In your kitchen、Quick add；In your kitchen 显示 Carrot、Garlic、Onion，食材数量为 3。

### Scenario: Pantry 手动添加和删除食材
- 覆盖需求：REQ-010, REQ-011, REQ-014
- 前置条件：处于 My pantry 页面。
- 动作：输入 eggs -> 点击加号 -> 点击 Eggs 或 Egg chip 上的 x。
- 预期结果：eggs 被归一化为 Egg 或以合理形式加入 pantry；点击 x 后该食材被删除，食材数量减少。

### Scenario: Pantry Clear all 清空并同步首页
- 覆盖需求：REQ-012, REQ-040
- 前置条件：pantry 中已有多个食材。
- 动作：点击 Clear all -> 切换到底部 Discover。
- 预期结果：pantry 被清空；首页显示 Tell us what's in your kitchen 提示；底部导航 Discover 高亮。

### Scenario: 打开 Chicken Fried Rice 详情并展示缺食材状态
- 覆盖需求：REQ-015, REQ-017, REQ-020, REQ-021
- 前置条件：Pantry 中已有 Carrot、Green onion、Garlic。
- 动作：进入 Discover -> 打开 Chicken Fried Rice 详情页。
- 预期结果：详情页显示 Dinner、Chicken Fried Rice、25 min、3 Serves、Medium、480 Kcal；显示 3/7 和 You're missing 4 ingredients；缺少 Rice、Chicken、Egg、Soy sauce，已有食材显示勾选。

### Scenario: 详情页一键补齐缺少食材
- 覆盖需求：REQ-016, REQ-018, REQ-019
- 前置条件：处于 Chicken Fried Rice 详情页，显示缺少 4 个食材。
- 动作：点击 Add missing to pantry -> 查看 Ingredients 区域。
- 预期结果：页面更新为 You're all set! You have everything to make this；必需食材全部勾选；Olive oil 显示 Optional 且不影响可做状态。

### Scenario: 详情页步骤进度和返回
- 覆盖需求：REQ-022, REQ-041
- 前置条件：处于 Chicken Fried Rice 详情页。
- 动作：滚动到 Steps -> 点击第 1 个步骤 -> 点击左上角返回。
- 预期结果：步骤进度从 0/5 变为 1/5；返回后进入上一级页面，底部导航恢复显示。

### Scenario: Search 搜索和分类筛选
- 覆盖需求：REQ-023, REQ-024, REQ-025
- 前置条件：已进入主界面。
- 动作：点击底部 Search -> 输入 rice -> 点击 Breakfast 分类。
- 预期结果：Search 页面显示搜索框、分类筛选、Cookable、Best match、Quickest、Fewest missing；输入 rice 后结果包含 Chicken Fried Rice；切到 Breakfast 后展示早餐菜谱，不展示 Chicken Fried Rice。

### Scenario: Search Cookable 和排序
- 覆盖需求：REQ-026, REQ-027, REQ-028, REQ-029
- 前置条件：Chicken Fried Rice 的必需食材已补齐。
- 动作：进入 Search -> 点击 Cookable -> 点击 Quickest -> 点击 Fewest missing。
- 预期结果：Cookable 结果包含 Chicken Fried Rice；排序切换后列表顺序刷新，卡片匹配计数与当前 pantry 状态一致。

### Scenario: Search 空结果
- 覆盖需求：REQ-030
- 前置条件：进入 Search 页面。
- 动作：在搜索框输入 zzznotfood。
- 预期结果：显示 No recipes found 或等价空态，不展示旧结果，不崩溃。

### Scenario: 收藏菜谱并在 Saved 查看
- 覆盖需求：REQ-031, REQ-032, REQ-033, REQ-035
- 前置条件：Saved 为空，处于 Discover 首页。
- 动作：收藏 5-Minute Mug Cake -> 收藏 Chicken Fried Rice -> 进入 Saved。
- 预期结果：Saved 显示收藏列表；Chicken Fried Rice 排在 5-Minute Mug Cake 前；点击收藏卡片可进入对应详情。

### Scenario: 取消收藏恢复 Saved 空态
- 覆盖需求：REQ-034
- 前置条件：Saved 中只有一个收藏菜谱。
- 动作：点击该菜谱心形按钮取消收藏。
- 预期结果：菜谱从 Saved 移除，页面恢复 No saved recipes 空态或等价空态。

### Scenario: Settings 主题切换和清空 pantry
- 覆盖需求：REQ-036, REQ-037, REQ-038, REQ-039
- 前置条件：pantry 中已有食材，处于 Discover 首页。
- 动作：点击右上角设置 -> 选择 Dark -> 选择 Light -> 点击 Clear pantry -> 返回 Discover。
- 预期结果：Settings 显示 Appearance、Light、Dark、Match system、Clear pantry、About、App WhatCanICook、Version 1.0.0；主题切换后页面颜色变化；Clear pantry 后首页恢复空 pantry 提示。
