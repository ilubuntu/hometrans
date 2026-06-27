# opencode HomeTrans 完整迁移任务

## 目标

将 Android 计算器工程迁移到 HarmonyOS 工程，按 HomeTrans README 的迁移流程执行，产出可构建的 HarmonyOS 工程、UI 对齐产物、需求规格、pipeline 报告和自测报告。

## 输入路径

- Android 项目路径：`/Users/bb/work/hometrans/calculate/SiliconeCalculator`
- HarmonyOS 目标工程路径：`/Users/bb/work/hometrans/calculate/input/calculatorHarmony`
- 需求描述文件：`/Users/bb/work/hometrans/calculate/input/requirements.txt`
- 自测用例文件：`/Users/bb/work/hometrans/calculate/input/test_case.md`

## 输出路径

- Batch UI 对齐输出目录：`/Users/bb/work/hometrans/calculate/output/calculator_batch_ui_align`
- Incremental UI 对齐输出目录：`/Users/bb/work/hometrans/calculate/output/calculator_incremental_ui_align`
- SPEC 输出目录：`/Users/bb/work/hometrans/calculate/output/calculator_specs`
- Pipeline 输出目录：`/Users/bb/work/hometrans/calculate/output/calculator_pipeline`

## 执行流程

1. 读取 HomeTrans README，按 README 中 Android 到 HarmonyOS 迁移流程执行。
2. 执行 `hmos-batch-ui-align`，输入 Android 项目和 HarmonyOS 目标工程，输出写入 `calculator_batch_ui_align`。
3. 执行 `hmos-incremental-ui-align`，对 Android 与 HarmonyOS 双端页面做截图、视图树采集和 UI 修正，输出写入 `calculator_incremental_ui_align`。
4. 执行 `hmos-spec-generate`，使用 `requirements.txt` 和 Android 源码生成规格文档，输出写入 `calculator_specs`。
5. 执行 `hmos-convert-pipeline`，输入 Android 项目、HarmonyOS 目标工程、生成的 SPEC、`test_case.md` 和 Pipeline 输出目录。

## 执行约束

- 不修改 Android 源工程。
- HarmonyOS 迁移代码只写入 `calculatorHarmony`。
- 阶段产物按上面的输出目录分开保存。
- 如果模型、设备、签名或环境配置不可用，在对应阶段报告中标记为环境问题，并继续完成可执行的后续检查。

## 自测输入

- 自测用例文件：`/Users/bb/work/hometrans/calculate/input/test_case.md`
- 应用包名：`com.example.calculatorharmony`
- 自测阶段按 `hmos-convert-pipeline` / `hmos-integration-test` 的默认机制执行。
