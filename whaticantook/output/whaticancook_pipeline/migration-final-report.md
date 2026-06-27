# WhatCanICook Android → HarmonyOS Migration — Final Report

## 项目概述

| 项目 | 值 |
|------|-----|
| Android 源码 | `/Users/bb/work/hometrans/whaticantook/whaticancook` (Kotlin + Jetpack Compose) |
| HarmonyOS 产物 | `/Users/bb/work/hometrans/whaticantook/input/whaticancookHarmony` (ArkTS + ArkUI) |
| Android 包名 | `com.whaticancook.app.debug` |
| HarmonyOS 包名 | `com.example.whaticancookharmony` |
| 需求文件 | `requirements.txt` — 42 个 REQ |
| 测试用例 | `test_case.md` — 48 个场景 |

---

## 四阶段执行结果

### 阶段 1: 批量 UI 对齐 (hmos-batch-ui-align)

| 指标 | 结果 |
|------|------|
| 状态 | ✅ 完成 |
| 报告 | `whaticancook_batch_ui_align/batch_conversion_report.md` |

**完成内容:**
- Android 爬虫抓取 59 个页面快照 (emulator-5554)
- 资源转换: 23 个浅色颜色 + 11 个深色颜色, 3 个 SVG drawable, recipes.json → rawfile
- 创建 7 个页面: DiscoverPage, RecipeDetailPage, SearchPage, PantryPage, SettingsPage, SavedPage, OnboardingPage
- 创建 2 个组件: BottomBar, RecipeCardComponent
- 创建 2 个 Model: RecipeModel (含成分匹配引擎), PantryModel
- 创建 7 个 ViewModel: Discover, RecipeDetail, Search, Pantry, Settings, Saved, Onboarding
- 公共模块: AppColors, LayoutPolicy
- 4 处构建修复后 BUILD SUCCESSFUL

### 阶段 2: 增量 UI 对齐 (hmos-incremental-ui-align)

| 指标 | 结果 |
|------|------|
| 状态 | ✅ 完成 |
| 报告 | `whaticancook_incremental_ui_align/incremental_ui_align_report.md` |

**完成内容:**
- 抓取 Android (Discover + Settings) 和 HarmonyOS (Discover) 页面截图
- 生成 6 个 UI_comparison.md 对比文件
- 修复项: 移除 CookStatusPill/MetaStat/StatTile 的 emoji 图标, 放大 hero emoji (90→130vp)
- BUILD SUCCESSFUL

### 阶段 3: 规格生成 (hmos-spec-generate)

| 指标 | 结果 |
|------|------|
| 状态 | ✅ 完成 |
| 报告 | `whaticancook_specs/spec_generation_report.md` |

**完成内容:**
- GitNexus 索引 Android 项目 (818 节点, 1606 边)
- 生成 42 个 SPEC 文件 + 42 个 trace 文件
- 创建 combined-spec.md 供管线使用

### 阶段 4: 转换流水线 (hmos-convert-pipeline)

| 子阶段 | 状态 | 说明 |
|--------|------|------|
| logic-context-builder | ✅ 完成 | 生成 5 文件架构计划 (AppContext, 4 Repositories) |
| logic-coder | ✅ 完成 | 实现完整数据层, 替换所有 mock 数据, BUILD SUCCESSFUL |
| build-fixer | ✅ 完成 | 构建通过, HAP 安装成功 |
| code-review (round 1) | ✅ 完成 | 43 PASS / 3 PARTIAL / 0 FAIL |
| review-fixer (round 1) | ✅ 完成 | 修复 CookNowPrompt, BUILD SUCCESSFUL |
| self-test (round 1) | ⚠️ 0/48 PASS | App 启动即崩溃 (@Track 严格模式) |
| crash-fix | ✅ 完成 | 移除所有 @Track 装饰器, App 成功启动 |
| self-test (round 2) | ⚠️ 6/48 PASS (12.5%) | App 可启动, 部分场景通过 |

---

## 构建结果

| 项目 | 结果 |
|------|------|
| 构建工具 | hvigorw (HarmonyOS 6.0.2 SDK) |
| 最终构建 | ✅ BUILD SUCCESSFUL |
| HAP 路径 | `entry/build/default/outputs/default/entry-default-unsigned.hap` |
| 签名 | ❌ 未配置 (signingConfigs 为空, 使用 unsigned HAP) |
| 设备安装 | ✅ 成功 (127.0.0.1:5557) |

---

## 自测结果

### Round 1: 0/48 PASS (0.00%)

**根因:** `@Observed` ViewModel 中的 `@Track` 装饰器启用了严格模式。Getters (如 `count`, `pages`) 在 UI 渲染期间被访问时，因未被 `@Track` 标注而触发 `Illegal usage of not @Track'ed property` 异常，导致应用启动即崩溃。

**修复:** 移除全部 7 个 ViewModel + RecipeModel 中的所有 `@Track` 装饰器（共 28 处），使 `@Observed` 类回到默认的全属性跟踪模式。

### Round 2: 6/48 PASS (12.50%)

**通过的 6 个用例:**
- Case 2: 引导页 Next 切换到下一页
- Case 4: 引导完成后重启不再出现
- Case 36, Case 40, Case 42, Case 47

**未通过的 42 个用例主要原因:**

| 原因类别 | 影响用例数 | 说明 |
|----------|-----------|------|
| AutoTest 无法正确识别应用 | ~25 | start_app 工具使用应用名而非 bundle name, 多数用例无法启动应用 |
| 测试用例期望值不匹配 | ~8 | onboarding 文本包含 "WhatCanICook" (可读名) 而非 "com.example.whaticancookharmony" (bundle name) |
| 页面导航/交互问题 | ~6 | 部分页面间跳转、列表滚动、筛选交互未完全对齐 |
| 执行超时 | ~3 | 少量用例超过 600 秒限制 |

**环境限制:**
- AutoTest 框架的 `start_app` 使用应用显示名匹配，与 `bundle name` 不一致导致启动失败
- 测试用例中的 app-name → bundle-name 替换规则导致显示文本期望值不匹配

---

## 关键技术决策

### 1. 数据层架构
- 使用 `@kit.ArkData` dataPreferences 替代 Android SharedPreferences
- 4 个单例 Repository: RecipeRepository (rawfile JSON), PantryRepository, FavoritesRepository, SettingsRepository
- recipes.json (18 个菜谱) 从 rawfile 加载, 内存缓存
- 主题/引导/食材/收藏 持久化到 Preferences store `wcc_settings`

### 2. 状态管理
- 使用 `@Observed` + `@State` MVVM 模式
- 移除 `@Track` 后所有属性自动跟踪 (简化但可工作)
- 跨页面状态同步通过 `onPageShow → refresh()` 实现

### 3. 成分匹配引擎
- 完整移植 Android 的成分归一化/同义词/复数处理逻辑
- `normalizeIngredient` + `ingredientMatches` + `matchRecipe` 函数链

### 4. 启动路由
- `EntryAbility.onCreate` 发布 context 到 `AppContext`
- `Index.aboutToAppear` 异步 hydrate 所有 Repository → 应用主题 → 路由到 Onboarding 或 Discover

---

## 已知遗留问题

| 编号 | 类别 | 描述 | 严重程度 |
|------|------|------|----------|
| 1 | 构建 | 未配置签名 (signingConfigs 为空), 无法生成签名 HAP | 中 |
| 2 | 测试 | AutoTest start_app 使用应用名匹配, 与 bundle name 不一致导致大量用例无法启动 | 高 |
| 3 | 测试 | onboarding 文本显示 "WhatCanICook" 而非 bundle name, 导致 Case 1 等用例期望不匹配 | 低 |
| 4 | UI | 所有图标为 Unicode emoji 占位符, 无矢量图标资源 | 低 |
| 5 | 功能 | 搜索功能 (SearchPage) 的交互可能不完全对齐 Android 行为 | 中 |
| 6 | 性能 | recipes.json 加载和解析在主线程, 可能影响启动速度 | 低 |

---

## 文件清单

### 输出目录

| 目录 | 内容 |
|------|------|
| `whaticancook_batch_ui_align/` | 阶段 1 批量 UI 对齐输出 |
| `whaticancook_incremental_ui_align/` | 阶段 2 增量 UI 对齐输出 |
| `whaticancook_specs/` | 阶段 3 规格文件 (42 SPEC + 42 trace + combined-spec.md) |
| `whaticancook_pipeline/` | 阶段 4 管线输出 (plan, commit-info, review, self-test reports, HAP) |

### HarmonyOS 源码结构

```
entry/src/main/ets/
├── data/                         # 数据层 (新增)
│   ├── AppContext.ets            # UIAbilityContext 持有者
│   ├── RecipeRepository.ets      # 菜谱仓库 (rawfile JSON)
│   ├── PantryRepository.ets      # 食材仓库 (Preferences)
│   ├── FavoritesRepository.ets   # 收藏仓库 (Preferences)
│   └── SettingsRepository.ets    # 设置仓库 (Preferences)
├── model/
│   ├── RecipeModel.ets           # 菜谱模型 + 成分匹配引擎
│   └── PantryModel.ets           # 食材目录模型
├── viewmodel/
│   ├── DiscoverViewModel.ets
│   ├── RecipeDetailViewModel.ets
│   ├── SearchViewModel.ets
│   ├── PantryViewModel.ets
│   ├── SettingsViewModel.ets
│   ├── SavedViewModel.ets
│   └── OnboardingViewModel.ets
├── pages/
│   ├── Index.ets                 # 入口路由
│   ├── OnboardingPage.ets
│   ├── DiscoverPage.ets
│   ├── SearchPage.ets
│   ├── PantryPage.ets
│   ├── RecipeDetailPage.ets
│   ├── SettingsPage.ets
│   └── SavedPage.ets
├── components/
│   ├── BottomBar.ets
│   └── RecipeCardComponent.ets
├── common/
│   ├── AppColors.ets
│   └── LayoutPolicy.ets
└── entryability/
    └── EntryAbility.ets
```

---

## 人工后续处理建议

1. **配置签名** — 在 build-profile.json5 中添加 signingConfigs 以支持发布构建
2. **修复 AutoTest 兼容性** — 确保 start_app 能正确使用 bundle name 启动应用
3. **矢量图标替换** — 将 emoji 占位符替换为实际的 SVG/PNG 图标资源
4. **搜索交互对齐** — 验证 SearchPage 的筛选/排序交互与 Android 行为一致
5. **性能优化** — 将 recipes.json 解析移到 worker 线程
6. **测试用例校准** — 修正 onboarding 文本的期望值 (应使用可读名而非 bundle name)
