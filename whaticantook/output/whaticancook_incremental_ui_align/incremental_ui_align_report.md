# Incremental UI Alignment — 报告

> Skill: `hmos-incremental-ui-align`
> 项目: WhatCanICook (Android → HarmonyOS)
> 采集任务目录: `output/whaticancook_incremental_ui_align/task_20260702_132332/`
> 生成时间: 2026-07-02

## 概览
对 7 个页面对在 Android 真机/模拟器与 HarmonyOS 真机上分别采集视图树 + 截图，逐页产出 `UI_Analysis.md`（双端各一份）与 `UI_comparison.md` 差异表，并修复了真实差异。最终构建通过。

## 输入解析 (Step 0/0.1)
- android.app_name="WhatCanICook", android.package="com.whaticancook.app"
- harmony.app_name="WhatCanICook" ($string:app_name), harmony.package="com.example.whaticancookharmony"
- 模型: MiniMax-M3 (config.json)；OHOS/HMS SDK 已配置。

## 设备/签名说明
- **签名**: 工程 `signingConfigs` 为空，无 `.p12/.cer/.p7b`。但 HarmonyOS 开发者设备接受 unsigned/debug HAP，`hdc install` 直接成功并启动，**签名不构成阻塞**。
- Android 端复用 batch-ui-align 阶段的快照（同设备同 App）；HarmonyOS 端用 `uitest dumpLayout` + `uitest screenCap` 手动导航采集（页面遍历 agent 与 `page_capture.py` 的 hdc 解析在该设备版本报错，改用直接 uitest 命令）。

## 页面对（均已完成双端分析 + 对比）
| i | 名称 | android_page | hmos_page |
|---|---|---|---|
| 1 | onboarding | ✓ | ✓ |
| 2 | home (Discover) | ✓ | ✓ |
| 3 | settings | ✓ | ✓ |
| 4 | pantry | ✓ | ✓ |
| 5 | search | ✓ | ✓ |
| 6 | favorites (Saved) | ✓ | ✓ |
| 7 | detail | ✓ | ✓ |

产出文件：7 × `android_page_*/UI_Analysis.md`、7 × `hmos_page_*/UI_Analysis.md`、7 × `hmos_page_*/UI_comparison.md`、`fix_checklist.md`。

## 修复的关键缺陷（Step 3，均已构建+真机验证）

### 运行级缺陷（阻塞页面渲染/导航）
1. **Recipe @Observed 读取未追踪 getter 崩溃**：`RecipeCard` 在渲染期读取 `recipe.timeLabel` / `essentialIngredients`（getter），违反 ArkUI `@Track` 规则导致 `jscrash`。修复：将二者改为构造期计算的 `@Track` 存储属性（`RecipeModel.ets`）。
2. **Onboarding 完成不导航**：`OnboardingPage.goToHome()` 为 mock。修复为真实 `router.replaceUrl('pages/HomePage')`；并给 `complete()` 加 `PersistentStorage.persistProp('onboardingComplete')`（满足 REQ-002 重启不再展示引导）。
3. **首页 Pantry / Saved 底部导航为 mock**：`HomePage.goToPantry()` 与 `goToTab(FAVORITES)` 未跳转。修复为真实 `router.pushUrl`。

### 视觉差异（trace 到 Android 源码后修复）
4. **Recipe 详情标题字号 28 → 22**：Android `headlineMedium` = 22sp/700（`Type.kt:54`）。`RecipeDetailPage.ets` 改为 22 + lineHeight 28。
5. **详情 stat tile 过高（~101vp vs 57dp）**：emoji 图标行高撑高。约束 tile `.height(57).clip(true)`、图标 `.lineHeight(20)`、内边距 14→8。
6. **Search 页标题居中 → 左对齐**：Android `ScreenTitle` 起始对齐。加 `.width('100%').textAlign(TextAlign.Start)`。
7. **字重漂移 Medium(500) → 600**：Android `labelLarge/titleSmall/titleMedium/labelMedium` 均为 600。修正 `WccChip` / `MetaStat` / `SectionHeader` / `SearchPage` / `RecipeDetailPage` 中标签类字重为 600（正文 400、display/headline 标题 700 保持不变）。

## 已知保真 TODO（文档化，本轮不修，无对应转换资源/动画能力）
- Material 矢量图标以 emoji 字形代替（转换后 media 资源无 Material vectors）：⚙️🔍🍳🔖❤️›‹⏱📶🔥 等。
- 详情页 hero 视差/淡出动画、`bounceClick` 按压缩放（ArkUI 无等价声明式单行实现）。
- Search 第 3 个排序 chip “Fewest missing” 位于横向 Scroll 内（需滑动可见，结构正确，与 Android LazyRow 行为一致）。

## 最终构建
- `hvigorw assembleHap` → BUILD SUCCESSFUL（unsigned HAP）。
- 真机重装后 7 个页面均可正常渲染与导航（崩溃已消除）。

## fix_checklist 状态
全部条目 `[x]`（详见 `task_20260702_132332/fix_checklist.md`）；RecipeCard 文本缺失经核实为采图仅取首屏（卡片在折叠线以下），非缺陷。
