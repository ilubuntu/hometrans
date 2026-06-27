# WhatCanICook 迁移规格总览

## 应用概述
WhatCanICook 是一个离线菜谱应用。核心流程：首次引导 → Discover 浏览菜谱 → Pantry 添加食材 → 食材匹配 → Recipe Detail 查看详情 → Search 搜索 → Saved 收藏 → Settings 设置。

## 离线约束
- 所有数据离线可用，不引入远程API或必须联网的依赖
- 菜谱数据从 rawfile/recipes.json 加载
- 食材和收藏使用本地持久化存储

## 详细规格文件目录
/Users/bb/work/hometrans/whaticantook/output/whaticancook_specs

## 核心需求清单 (REQ-001 ~ REQ-042)

### 引导 (REQ-001~002)
- 首次启动展示3页引导，Skip/Start cooking 完成后持久化 onboardingComplete
- 详见: onboarding-flow-SPEC.md, onboarding-persist-SPEC.md

### 数据 (REQ-003)
- 从 recipes.json 初始化18个菜谱，完全离线
- 详见: offline-data-SPEC.md

### Discover首页 (REQ-004~007)
- 问候语、标题、搜索入口、Pantry卡片、分类筛选(Browse recipes)、菜谱列表
- 空pantry显示提示文案，不显示Ready to cook
- 菜谱卡片显示emoji、分类、标题、简介、耗时、难度、热量、匹配计数、收藏按钮
- 分类: All/Breakfast/Lunch/Dinner/Dessert/Snack/Drinks
- 详见: discover-layout-SPEC.md, empty-pantry-hint-SPEC.md, recipe-card-SPEC.md, category-filter-SPEC.md

### Pantry食材库 (REQ-008~013)
- 标题、食材数量、手动添加、已有食材区、清空、快速添加分类区
- 快速添加: Produce/Meat & Seafood/Dairy & Eggs/Grains & Bread/Pantry/Condiments/Spices
- 手动添加空字符串不添加
- 单个删除、清空全部
- 详见: pantry-layout-SPEC.md, pantry-quick-add-SPEC.md, pantry-manual-add-SPEC.md, pantry-remove-SPEC.md, pantry-clear-SPEC.md, ingredient-categories-SPEC.md

### 食材匹配 (REQ-014~019)
- 归一化匹配: 单复数、同义词(chicken breast→chicken, eggs→egg, scallions→green onion)
- 匹配计数 haveCount/essentialCount
- Ready状态(全部必需食材齐全)、Missing N状态(缺少N个必需食材)
- Add missing to pantry一键补齐
- 可选食材标记Optional，不影响Ready状态
- 详见: ingredient-matching-SPEC.md, match-count-SPEC.md, ready-status-SPEC.md, missing-status-SPEC.md, add-missing-SPEC.md, optional-ingredients-SPEC.md

### Recipe Detail (REQ-020~022)
- 返回、收藏、菜谱图、分类、标题、简介、标签、耗时、份数、难度、热量
- Ingredients清单(勾选/Missing/Optional)
- Steps步骤进度(可点击切换)
- 详见: detail-info-SPEC.md, detail-ingredients-SPEC.md, detail-steps-SPEC.md

### Search (REQ-023~030)
- 搜索框、分类筛选、Cookable开关、排序(Best match/Quickest/Fewest missing)
- 文本搜索匹配标题/分类/标签/食材
- 空结果显示No recipes found
- 详见: search-layout-SPEC.md, search-text-SPEC.md, search-category-SPEC.md, search-cookable-SPEC.md, search-best-match-SPEC.md, search-quickest-SPEC.md, search-fewest-missing-SPEC.md, search-empty-SPEC.md

### Saved收藏 (REQ-031~035)
- 收藏/取消收藏、空态(Browse recipes)、列表展示、倒序排列
- 详见: favorite-recipe-SPEC.md, saved-empty-SPEC.md, saved-list-SPEC.md, unfavorite-SPEC.md, saved-order-SPEC.md

### Settings (REQ-036~039)
- Appearance(Theme: Match system/Light/Dark)、Data(Clear pantry)、About(App/Version/Built with)
- 主题切换即时生效并持久化
- 详见: settings-about-SPEC.md, theme-switch-SPEC.md, theme-persist-SPEC.md, settings-clear-pantry-SPEC.md

### 导航 (REQ-040~041)
- 底部导航4个Tab(Discover/Search/Pantry/Saved)，详情页和设置页不显示
- 返回导航从详情/设置回到来源页
- 详见: bottom-nav-SPEC.md, back-navigation-SPEC.md

### 错误状态 (REQ-042)
- 首页加载骨架、错误重试
- 详见: loading-error-state-SPEC.md
