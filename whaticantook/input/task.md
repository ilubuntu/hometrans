# opencode HomeTrans 完整迁移任务

## 目标

将 Android 菜谱应用 WhatCanICook 迁移到 HarmonyOS 工程，按 HomeTrans README 的 Android 到 HarmonyOS 迁移流程执行，产出可构建的 HarmonyOS 工程、UI 对齐产物、需求规格、pipeline 报告和自测报告。

## 输入路径

- Android 项目路径：`/Users/bb/work/hometrans/whaticantook/whaticancook`
- HarmonyOS 目标工程路径：`/Users/bb/work/hometrans/whaticantook/input/whaticancookHarmony`
- 需求描述文件：`/Users/bb/work/hometrans/whaticantook/input/requirements.txt`
- 自测用例文件：`/Users/bb/work/hometrans/whaticantook/input/test_case.md`

## 输出路径

- Batch UI 对齐输出目录：`/Users/bb/work/hometrans/whaticantook/output/whaticancook_batch_ui_align`
- Incremental UI 对齐输出目录：`/Users/bb/work/hometrans/whaticantook/output/whaticancook_incremental_ui_align`
- SPEC 输出目录：`/Users/bb/work/hometrans/whaticantook/output/whaticancook_specs`
- Pipeline 输出目录：`/Users/bb/work/hometrans/whaticantook/output/whaticancook_pipeline`

## 执行流程

1. 先读取 HomeTrans README，再读取本文件，严格按 README 中 Android 到 HarmonyOS 迁移流程执行。
2. 执行 `hmos-batch-ui-align`，输入 Android 项目和 HarmonyOS 目标工程，输出写入 `whaticancook_batch_ui_align`。
3. 执行 `hmos-incremental-ui-align`，对 Android 与 HarmonyOS 双端页面做截图、视图树采集和 UI 修正，输出写入 `whaticancook_incremental_ui_align`。
4. 执行 `hmos-spec-generate`，使用 `requirements.txt` 和 Android 源码生成规格文档，输出写入 `whaticancook_specs`。
5. 执行 `hmos-convert-pipeline`，输入 Android 项目、HarmonyOS 目标工程、生成的 SPEC、`test_case.md` 和 Pipeline 输出目录。

## 应用主线

WhatCanICook 是一个离线菜谱应用，核心流程是：首次引导 -> Discover 浏览菜谱 -> Pantry 添加已有食材 -> 根据食材匹配可做/缺少食材 -> Recipe Detail 查看详情并一键补齐缺失食材 -> Search 搜索筛选排序 -> Saved 收藏菜谱 -> Settings 切换主题和清空 pantry。

迁移时优先保证这些主线闭环：

- 首次引导和跳过/完成状态持久化。
- Discover 首页、分类筛选、菜谱卡片和底部导航。
- Pantry 快速添加、手动添加、删除和清空食材。
- 食材匹配规则，包括单复数、同义词和可选食材不阻塞可做状态。
- Recipe Detail 的缺食材状态、Add missing to pantry、Ingredients、Steps。
- Search 的文本搜索、分类、Cookable、Best match、Quickest、Fewest missing。
- Saved 收藏、取消收藏、空态和倒序展示。
- Settings 的 Light/Dark/Match system、Clear pantry、About。

## 执行约束

- 不修改 Android 源工程。
- HarmonyOS 迁移代码只写入 `whaticancookHarmony`。
- 阶段产物按上面的输出目录分开保存，不要把 batch 和 incremental 结果混到同一个目录。
- `requirements.txt` 和 `test_case.md` 是本次任务的人工输入材料，应直接使用，不要重写为更少的版本。
- 如果模型、设备、签名或环境配置不可用，在对应阶段报告中标记为环境问题，并继续完成可执行的后续检查。
- 迁移后应用应保持离线可用，不引入 Firebase、登录、远程 API 或必须联网的数据依赖。

## 自测输入

- 自测用例文件：`/Users/bb/work/hometrans/whaticantook/input/test_case.md`
- 应用包名：`com.example.whaticancookharmony`
- 自测阶段按 `hmos-convert-pipeline` / `hmos-integration-test` 的默认机制执行。

## Android 基线

- Android 工程是 Kotlin + Jetpack Compose 应用。
- 本地离线数据在 `app/src/main/assets/recipes.json`。
- Android Debug APK 构建命令可参考：`JAVA_HOME='/Applications/Android Studio.app/Contents/jbr/Contents/Home' ./gradlew :app:assembleDebug --stacktrace`
- 已知 Android 工程主要功能可运行，截图覆盖 Onboarding、Discover、Search、Pantry、Recipe Detail 缺食材和已满足状态。
