# AntennaPod HomeTrans 迁移任务

## 项目路径

- Android 项目路径：`/Users/bb/work/hometrans/AntennaPod/AntennaPod`
- HarmonyOS 目标工程路径：`/Users/bb/work/hometrans/AntennaPod/input/antennapodHarmony`
- 需求文档：`/Users/bb/work/hometrans/AntennaPod/input/requirements.txt`
- 测试用例：`/Users/bb/work/hometrans/AntennaPod/input/test_case.md`
- UI 批量对齐输出：`/Users/bb/work/hometrans/AntennaPod/output/antennapod_batch_ui_align`
- UI 增量对齐输出：`/Users/bb/work/hometrans/AntennaPod/output/antennapod_incremental_ui_align`
- SPEC 输出：`/Users/bb/work/hometrans/AntennaPod/output/antennapod_specs`
- Pipeline 输出：`/Users/bb/work/hometrans/AntennaPod/output/antennapod_pipeline`

## 应用说明

AntennaPod 是开源 Android 播客客户端，主要能力包括订阅 podcast RSS feed、播客列表、单集列表、单集详情、播放、队列、下载、收藏、播放历史、OPML 导入导出、设置和统计。

该项目不是 Compose UI 主导，主要是传统 Android Fragment/XML 页面。迁移时需要保留核心播客管理和播放流程。

## 测试数据

为避免首次启动空库导致测试无法闭环，请在执行测试前准备稳定 podcast RSS feed 或 OPML 文件。测试 feed 至少包含 3 个以上单集，并保证标题、描述、音频 URL 可解析。

## 推荐执行流程

1. 读取 HomeTrans README，确认当前工程迁移流程和参数格式。
2. 执行 `hmos-batch-ui-align`，采集并批量迁移主要 Android 页面。
3. 执行 `hmos-incremental-ui-align`，对关键页面进行 Android/HarmonyOS 双端对齐。
4. 执行 `hmos-spec-generate`，从 `requirements.txt` 生成逐项 SPEC。
5. 执行 `hmos-convert-pipeline`，完成逻辑迁移、构建修复、评审修复和自测试。
6. 自测试阶段使用 `test_case.md`，优先覆盖订阅、列表、详情、播放、队列、收藏、下载、设置这些主线流程。

## 迁移边界

- 必须实现本地播客订阅、单集管理、队列、播放、收藏、下载和设置主线。
- 可选同步服务可以保留入口，不要求真实登录第三方服务。
- Android Auto、Wear OS、Cast、高级同步等平台扩展能力可以降级处理，但不能影响手机端主流程。
- 如果网络不稳定，可以使用本地测试 RSS/OPML 替代线上 feed。

