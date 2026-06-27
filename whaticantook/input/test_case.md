# WhatCanICook 验收测试用例

说明：以下用例面向 HomeTrans 迁移后的 HarmonyOS 应用自测和人工验收。用例基于 Android 源码、离线数据 `assets/recipes.json`、用户截图和 README 主流程整理。默认 bundle name 以后续 Harmony 工程实际配置为准。

### Scenario: 首次启动展示引导页
- 覆盖需求：REQ-001
- 前置条件：清除应用数据后首次启动。
- 动作：打开应用。
- 预期结果：展示 Onboarding 首屏，包含 Skip、Next、页码指示器、标题 Cook with what you have，以及说明 Tell WhatCanICook the ingredients in your kitchen and skip the extra grocery run。

### Scenario: 引导页 Next 切换到下一页
- 覆盖需求：REQ-001
- 前置条件：处于 Onboarding 首屏。
- 动作：点击 Next。
- 预期结果：页码指示器切换到第二页，页面标题变为 Instant recipe matches。

### Scenario: 跳过引导进入首页
- 覆盖需求：REQ-001, REQ-002
- 前置条件：处于 Onboarding 任意页面。
- 动作：点击 Skip。
- 预期结果：进入 Discover 首页，显示 What can I cook?、搜索入口、Your pantry、Browse recipes 和底部导航。

### Scenario: 引导完成后重启不再出现
- 覆盖需求：REQ-002
- 前置条件：已点击 Skip 或 Start cooking 完成引导。
- 动作：关闭并重新打开应用。
- 预期结果：直接进入 Discover 首页，不再展示 Onboarding。

### Scenario: 首页离线展示菜谱数据
- 覆盖需求：REQ-003, REQ-004
- 前置条件：应用无网络或忽略网络状态，已完成引导。
- 动作：打开 Discover 首页。
- 预期结果：菜谱列表正常显示，至少能看到 5-Minute Mug Cake、Banana Oat Pancakes 或 Chicken Fried Rice 中的一个。

### Scenario: 空 pantry 首页提示
- 覆盖需求：REQ-005
- 前置条件：清空 pantry。
- 动作：进入 Discover 首页。
- 预期结果：Your pantry 显示 Add what you have at home；页面显示 Tell us what's in your kitchen 提示；不显示 Ready to cook 区域。

### Scenario: 首页进入 Pantry
- 覆盖需求：REQ-004, REQ-008
- 前置条件：处于 Discover 首页。
- 动作：点击 Your pantry 卡片。
- 预期结果：进入 My pantry 页面，底部导航 Pantry 高亮。

### Scenario: 首页进入 Search
- 覆盖需求：REQ-004, REQ-023
- 前置条件：处于 Discover 首页。
- 动作：点击搜索框 Search recipes, ingredients...
- 预期结果：进入 Search 页面，显示搜索输入框、分类筛选、Cookable、Best match、Quickest、Fewest missing。

### Scenario: 首页进入 Settings
- 覆盖需求：REQ-036, REQ-041
- 前置条件：处于 Discover 首页。
- 动作：点击右上角设置按钮。
- 预期结果：进入 Settings 页面，显示 Appearance、Data、About；底部导航不显示。

### Scenario: 首页分类筛选 Dinner
- 覆盖需求：REQ-007
- 前置条件：处于 Discover 首页。
- 动作：点击 Browse recipes 中的 Dinner 分类。
- 预期结果：菜谱列表展示晚餐类菜谱，可看到 Chicken Fried Rice；非 Dinner 菜谱不应出现在当前筛选结果中。

### Scenario: 首页菜谱卡片进入详情
- 覆盖需求：REQ-006, REQ-020
- 前置条件：处于 Discover 首页。
- 动作：点击 Chicken Fried Rice 菜谱卡片。
- 预期结果：进入 Chicken Fried Rice 详情页，展示 Dinner、标题、简介、标签、25 min、3 Serves、Medium、480 Kcal。

### Scenario: Pantry 快速添加 5 个食材
- 覆盖需求：REQ-008, REQ-009, REQ-013
- 前置条件：进入 My pantry 页面，pantry 为空。
- 动作：依次点击 Cucumber、Avocado、Carrot、Garlic、Onion。
- 预期结果：页面显示 5 ingredients on hand；In your kitchen 区域显示 Cucumber、Avocado、Carrot、Garlic、Onion。

### Scenario: Pantry 已添加食材从 Quick add 移除
- 覆盖需求：REQ-009
- 前置条件：已在 Pantry 添加 Garlic。
- 动作：查看 Quick add 的 Produce 分类。
- 预期结果：Garlic 不再出现在 Quick add 建议中，显示在 In your kitchen 区域。

### Scenario: Pantry 手动添加自定义食材
- 覆盖需求：REQ-010
- 前置条件：进入 My pantry 页面。
- 动作：在输入框输入 chicken breast，点击加号。
- 预期结果：In your kitchen 中出现 Chicken breast 或归一化后的 Chicken；食材数量增加。

### Scenario: Pantry 空输入不添加
- 覆盖需求：REQ-010
- 前置条件：进入 My pantry 页面，记录当前食材数量。
- 动作：输入框保持为空，点击加号。
- 预期结果：食材数量不变，In your kitchen 未新增空白食材。

### Scenario: Pantry 删除单个食材
- 覆盖需求：REQ-011
- 前置条件：Pantry 中已有 Garlic。
- 动作：点击 Garlic chip 上的关闭按钮。
- 预期结果：Garlic 从 In your kitchen 移除，食材数量减少，并可在 Quick add 中重新添加。

### Scenario: Pantry Clear all 清空
- 覆盖需求：REQ-012
- 前置条件：Pantry 中已有多个食材。
- 动作：点击 Clear all。
- 预期结果：In your kitchen 区域消失或为空；页面显示 Add ingredients/Quick add；食材数量恢复为空。

### Scenario: 首页 pantry 数量同步
- 覆盖需求：REQ-008, REQ-012
- 前置条件：Pantry 中已有 5 个食材。
- 动作：切换到底部 Discover。
- 预期结果：Your pantry 卡片显示 5 ingredients ready。

### Scenario: Chicken Fried Rice 缺 4 个食材
- 覆盖需求：REQ-015, REQ-017, REQ-021
- 前置条件：Pantry 中已有 Carrot、Green onion、Garlic。
- 动作：打开 Chicken Fried Rice 详情页。
- 预期结果：详情页显示 3/7；提示 You're missing 4 ingredients；缺少 Rice、Chicken、Egg、Soy sauce；Carrot、Green onion、Garlic 显示勾选。

### Scenario: 详情页一键补齐缺少食材
- 覆盖需求：REQ-018
- 前置条件：处于 Chicken Fried Rice 详情页，显示缺少 4 个食材。
- 动作：点击 Add missing to pantry。
- 预期结果：详情页立即更新为 You're all set! You have everything to make this；必需食材全部显示勾选。

### Scenario: 可选食材不影响可做状态
- 覆盖需求：REQ-019, REQ-021
- 前置条件：Chicken Fried Rice 的必需食材已齐全，但未添加 Olive oil。
- 动作：查看 Chicken Fried Rice 详情页 Ingredients 区域。
- 预期结果：页面显示 You're all set；Olive oil 行显示 Optional，不显示 Missing。

### Scenario: 详情页步骤进度递增
- 覆盖需求：REQ-022
- 前置条件：进入 Chicken Fried Rice 详情页并滚动到 Steps 区域。
- 动作：点击第 1 个步骤。
- 预期结果：步骤进度从 0/5 变为 1/5，第 1 个步骤显示完成状态。

### Scenario: 详情页步骤进度可取消
- 覆盖需求：REQ-022
- 前置条件：Chicken Fried Rice 第 1 个步骤已完成，进度为 1/5。
- 动作：再次点击第 1 个步骤。
- 预期结果：步骤恢复未完成，进度变为 0/5。

### Scenario: 详情页返回上一页
- 覆盖需求：REQ-041
- 前置条件：从 Discover 打开 Chicken Fried Rice 详情页。
- 动作：点击左上角返回按钮。
- 预期结果：返回 Discover 首页，底部导航重新显示且 Discover 高亮。

### Scenario: Search 默认状态
- 覆盖需求：REQ-023
- 前置条件：切换到底部 Search。
- 动作：观察页面。
- 预期结果：标题为 Search；All、Best match 默认选中；显示搜索框、Cookable、Quickest、Fewest missing 和菜谱列表。

### Scenario: Search 搜索 rice
- 覆盖需求：REQ-024
- 前置条件：进入 Search 页面。
- 动作：在搜索框输入 rice。
- 预期结果：结果列表包含 Chicken Fried Rice。

### Scenario: Search 搜索 yogurt
- 覆盖需求：REQ-024
- 前置条件：进入 Search 页面。
- 动作：在搜索框输入 yogurt。
- 预期结果：结果列表包含 Honey Yogurt Parfait 或 Mango Lassi。

### Scenario: Search 分类筛选 Breakfast
- 覆盖需求：REQ-025
- 前置条件：进入 Search 页面。
- 动作：点击 Breakfast 分类。
- 预期结果：结果列表显示早餐菜谱，如 Banana Oat Pancakes；不显示 Chicken Fried Rice。

### Scenario: Search Cookable 空 pantry 无结果
- 覆盖需求：REQ-026, REQ-030
- 前置条件：清空 pantry，进入 Search 页面。
- 动作：点击 Cookable。
- 预期结果：结果为空，显示 No recipes found 和 Try a different ingredient or clear your filters。

### Scenario: Search Cookable 显示可做菜谱
- 覆盖需求：REQ-026
- 前置条件：已通过详情页或 Pantry 补齐 Chicken Fried Rice 的必需食材。
- 动作：进入 Search 页面，点击 Cookable。
- 预期结果：结果列表包含 Chicken Fried Rice，并显示匹配已满足。

### Scenario: Search Quickest 排序
- 覆盖需求：REQ-028
- 前置条件：进入 Search 页面。
- 动作：点击 Quickest。
- 预期结果：5 分钟菜谱靠前展示，如 5-Minute Mug Cake、Honey Yogurt Parfait 或 Mango Lassi。

### Scenario: Search Fewest missing 排序
- 覆盖需求：REQ-029
- 前置条件：Pantry 中已有 Carrot、Green onion、Garlic。
- 动作：进入 Search 页面，点击 Fewest missing。
- 预期结果：缺少食材更少的菜谱排在更前，匹配计数随 pantry 状态展示。

### Scenario: Search 无匹配搜索词
- 覆盖需求：REQ-030
- 前置条件：进入 Search 页面。
- 动作：输入 zzznotfood。
- 预期结果：显示 No recipes found，不展示旧结果，不崩溃。

### Scenario: 首页收藏菜谱
- 覆盖需求：REQ-031, REQ-033
- 前置条件：处于 Discover 首页，Saved 页为空。
- 动作：点击 5-Minute Mug Cake 卡片上的心形按钮，然后切换到 Saved。
- 预期结果：Saved 页显示 5-Minute Mug Cake，标题下显示 1 recipe in your cookbook。

### Scenario: 详情页收藏同步
- 覆盖需求：REQ-031
- 前置条件：打开 Chicken Fried Rice 详情页。
- 动作：点击右上角心形按钮收藏，返回首页或 Search 查看同一菜谱。
- 预期结果：同一菜谱卡片显示已收藏状态。

### Scenario: Saved 空态跳转浏览
- 覆盖需求：REQ-032
- 前置条件：取消所有收藏，进入 Saved。
- 动作：点击 Browse recipes。
- 预期结果：返回 Discover 首页，底部导航 Discover 高亮。

### Scenario: Saved 点击菜谱进入详情
- 覆盖需求：REQ-033
- 前置条件：Saved 中已有 Chicken Fried Rice。
- 动作：点击 Chicken Fried Rice 卡片。
- 预期结果：进入 Chicken Fried Rice 详情页。

### Scenario: Saved 取消唯一收藏
- 覆盖需求：REQ-034
- 前置条件：Saved 中只有一个收藏菜谱。
- 动作：点击该菜谱卡片上的心形按钮取消收藏。
- 预期结果：该菜谱从列表移除，页面恢复 No saved recipes yet 空态。

### Scenario: Saved 收藏倒序
- 覆盖需求：REQ-035
- 前置条件：清空收藏。
- 动作：先收藏 5-Minute Mug Cake，再收藏 Chicken Fried Rice，进入 Saved。
- 预期结果：Chicken Fried Rice 排在 5-Minute Mug Cake 前面。

### Scenario: Settings 展示 About 信息
- 覆盖需求：REQ-036
- 前置条件：从 Discover 点击设置进入 Settings。
- 动作：滚动查看 About 区域。
- 预期结果：显示 App WhatCanICook、Version 1.0.0、Built with Jetpack Compose，以及离线数据说明。

### Scenario: Settings 切换 Dark 主题
- 覆盖需求：REQ-037, REQ-038
- 前置条件：进入 Settings 页面。
- 动作：在 Theme 中点击 Dark。
- 预期结果：应用切换为深色主题，Dark chip 选中。

### Scenario: Settings 切换 Light 主题
- 覆盖需求：REQ-037
- 前置条件：Settings 当前为 Dark。
- 动作：点击 Light。
- 预期结果：应用切换为浅色主题，Light chip 选中。

### Scenario: Settings 主题重启保持
- 覆盖需求：REQ-038
- 前置条件：Settings 中选择 Dark。
- 动作：关闭并重新打开应用，再进入 Settings。
- 预期结果：应用仍为深色主题，Dark 仍处于选中状态。

### Scenario: Settings Clear pantry 同步影响详情
- 覆盖需求：REQ-039
- 前置条件：Chicken Fried Rice 已显示 You're all set。
- 动作：进入 Settings，点击 Clear pantry，再打开 Chicken Fried Rice 详情页。
- 预期结果：Chicken Fried Rice 不再显示 You're all set，恢复为缺少必需食材状态。

### Scenario: 底部导航四个主入口
- 覆盖需求：REQ-040
- 前置条件：已进入主界面。
- 动作：依次点击 Discover、Search、Pantry、Saved。
- 预期结果：每个页面都能打开，对应导航项高亮，页面标题分别为 What can I cook?、Search、My pantry、Saved 或收藏空态。

### Scenario: 二级页隐藏底部导航
- 覆盖需求：REQ-040
- 前置条件：处于 Discover 首页。
- 动作：进入 Settings，再返回；进入某个 Recipe Detail。
- 预期结果：Settings 和 Recipe Detail 页面均不显示底部导航；返回主 Tab 后底部导航恢复。

### Scenario: 首页加载状态不长期停留
- 覆盖需求：REQ-042
- 前置条件：首次完成引导后进入首页。
- 动作：等待首页数据初始化。
- 预期结果：短暂加载后展示菜谱列表，不应长期停留在骨架屏。

### Scenario: 应用离线主流程
- 覆盖需求：REQ-003, REQ-008, REQ-018, REQ-031
- 前置条件：关闭网络或不依赖网络，应用已启动。
- 动作：添加 pantry 食材，打开 Chicken Fried Rice 详情，点击 Add missing to pantry，收藏该菜谱，进入 Saved。
- 预期结果：全部操作可离线完成；Saved 中能看到收藏的 Chicken Fried Rice。
