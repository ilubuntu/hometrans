# WhatCanICook HomeTrans 完整迁移任务

## 目标

按 HomeTrans README 的标准流程，将 WhatCanICook Android 应用迁移到 HarmonyOS 工程。

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

1. 读取 HomeTrans README，按 README 的 Android 到 HarmonyOS 迁移流程执行。
2. 执行 `hmos-batch-ui-align`。
3. 执行 `hmos-incremental-ui-align`。
4. 执行 `hmos-spec-generate`。
5. 执行 `hmos-convert-pipeline`。

## 要求

- 完整跑完上述 4 个 skill。
- 阶段输出分别写入对应输出目录，不要混到同一个目录。
- HarmonyOS 迁移代码只写入 `whaticancookHarmony`。
- 自测应用包名使用：`com.example.whaticancookharmony`。
- 如果遇到环境、模型、设备或签名问题，在对应报告中记录，并继续完成可执行的后续步骤。
