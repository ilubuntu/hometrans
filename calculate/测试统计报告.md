# Calculator 迁移统计报告

## 总体评价

本次迁移的功能还原完善度为 100%，加减乘除、百分号、正负号、清除/全清、历史记录、深色模式等全部功能均已实现且手动验证通过。表达式求值引擎与 Android 原版逻辑一致，计算结果准确。

主要不足集中在 UI 视觉还原度：顶部图标用 emoji 替代了 Google 标准图标，按钮丢失了渐变和立体阴影效果，字符按钮间距与原版有偏差。原因是这些图标和效果在 Android 端是 Compose 库代码生成的，不是图片文件，转换工具无法直接搬过来。

自测阶段 AutoTest 只通过了 1/7，但实际功能没有问题。原因是 AutoTest 靠 AI 截图识别按钮位置来点击，计算器的自定义按钮带阴影和边框，AI 定位不准导致点错位置。后续通过 hdc 命令获取按钮精确坐标后逐个点击验证，7/7 全部通过，功能无缺陷。

## 一、转换结果对比

### 1.1 Android 项目概况

SiliconeCalculator 是一个新拟态风格计算器应用，使用 Kotlin + Jetpack Compose 实现。支持加减乘除四则运算、百分号、正负号切换、清除/全清、历史记录、深色模式切换。采用 Room 数据库存储历史记录，Hilt 依赖注入，Navigation-Compose 页面导航，MVVM + Repository 分层架构。

项目规模较小：主源码约 3.5k 行 Kotlin，包含 CalculatorScreen、HistoryScreen 两个主要页面，NeuButton（新拟态按钮）、CorneredFlatButton（非对称圆角按钮）两个自定义组件，以及完整的表达式求值引擎（tokenizer + 优先级解析）。

### 1.2 转换结果对比

完整迁移输出见 [migration_summary_report_v2.md](/Users/bb/work/hometrans/calculate/output/migration_summary_report_v2.md)。

Android 原应用录屏：[Screen_recording_20260625_210010.webm](android_video/Screen_recording_20260625_210010.webm)。

HarmonyOS 迁移结果截图：

<table>
<tr>
<td><img src="harmony_screenshots/Screenshot_2026-06-29T150125.png" width="250"/></td>
<td><img src="harmony_screenshots/Screenshot_2026-06-29T150138.png" width="250"/></td>
<td><img src="harmony_screenshots/Screenshot_2026-06-29T150146.png" width="250"/></td>
<td><img src="harmony_screenshots/Screenshot_2026-06-29T150201.png" width="250"/></td>
</tr>
</table>

| 维度 | 评价内容 | 本次结果 |
|------|----------|----------|
| 功能 | 加减乘除、百分号、正负号、清除/全清、历史记录、深色模式 | ✅ 全部实现，手动验证 7/7 通过，功能完成度 100% |
| UI | 新拟态风格、Material 图标、渐变按钮、高程阴影 | ⚠️ 布局结构基本一致，但顶部图标使用 emoji 替代矢量图标，按钮背景为纯色而非渐变，新拟态阴影效果未还原 |
| 数据和状态 | 历史记录存储、深色模式状态保持 | ✅ 历史记录持久化、深色模式切换后状态保持正常 |
| 工程质量 | 构建运行、代码结构 | ✅ 可构建运行；代码按 View、ViewModel、Model、Component 分类；使用废弃 API 和 router 导航，工程质量一般 |
| 测试结果 | AutoTest 自测和人工验收 | AutoTest 1/7 PASS（坐标映射问题，非应用缺陷）；hdc 手动验证 7/7 通过 |
| 时间 | 完整迁移流程耗时 | 总耗时约 5h 13m，其中三轮自测约 2h 20m |
| Token | opencode 与 AutoTest 总消耗 | 总计约 56.86M Token；自测相关约 8.23M，占 14.5% |

---

## 二、时间统计

| 阶段 | 子步骤 | 开始 | 结束 | 耗时 |
|------|--------|------|------|------|
| **阶段 1: UI 对齐** | | 06-25 17:01 | 17:27 | **~26m** |
| | 资源转换 + 页面/组件转换 | 17:01 | 17:27 | ~26m |
| **阶段 2: 增量对齐** | | 06-25 17:31 | 17:48 | **~17m** |
| | 双设备截图 + UI diff + 修复 | 17:31 | 17:48 | ~17m |
| **阶段 3: 规格生成** | | 06-25 17:50 | 18:00 | **~10m** |
| | GitNexus 索引 + 3 SPEC (38 场景) | 17:50 | 18:00 | ~10m |
| **阶段 4: 转换流水线** | | 06-25 18:02 | 06-26 12:28 | **~4h 20m** |
| | logic-context-builder | 18:02 | 18:14 | ~12m |
| | logic-coder (逻辑实现) | 18:14 | 19:29 | ~75m |
| | build-fixer | 19:30 | 19:32 | ~2m |
| | code-review round 1 (34 PASS / 4 PARTIAL) | 19:33 | 19:43 | ~10m |
| | review-fixer round 1 | 19:43 | 19:53 | ~10m |
| | code-review round 2 (38/38 PASS) | 19:54 | 20:02 | ~8m |
| | build signed HAP | 20:20 | 20:55 | ~35m |
| | self-test round 1 (0/7) | 20:56 | 21:23 | ~27m |
| | self-test fix round 1 | 21:23 | 21:33 | ~10m |
| | rebuild HAP | 21:33 | 21:45 | ~12m |
| | self-test round 2 (1/7) | 10:34 | 11:27 | ~53m |
| | self-test fix round 2 | 11:28 | 11:47 | ~19m |
| | self-test round 3 (1/7) | 11:47 | 12:28 | ~41m |
| | | | **合计** | **~5h 13m** |

> 阶段 4 中自测占 ~2h 20m，纯开发+审查+构建约 ~2h。

---

## 三、Token 统计

> opencode 使用 GLM-5.1，AutoTest 使用 MiniMax，两者独立计费。

### 3.1 总览

| 来源 | 模型 | Token | 说明 |
|------|------|-------|------|
| opencode 主 Agent | GLM-5.1 | 15.07M | 全程编排 |
| opencode 子 Agent | GLM-5.1 | 39.44M | UI 对齐、规格生成、代码迁移、自测编排 |
| AutoTest Round 1 | MiniMax | 0.78M | 69 次 LLM 调用 |
| AutoTest Round 2 | MiniMax | 0.65M | 50 次 LLM 调用 |
| AutoTest Round 3 | MiniMax | 0.92M | 57 次 LLM 调用 |
| **合计** | | **~56.86M** | |

### 3.2 opencode 子 Agent

| 类型 | 会话数 | Token | 说明 |
|------|--------|-------|------|
| general | 3 | **12.24M** | UI 对齐 + 增量对齐 + 规格生成 |
| build-fixer | 3 | **8.84M** | 构建 + 签名 HAP（含 7.59M 签名构建） |
| self-tester | 3 | **5.88M** | 3 轮自测编排 |
| self-test-fixer | 2 | **4.85M** | 2 轮自测修复 |
| logic-coder | 1 | **3.74M** | 逻辑层实现 |
| logic-context-builder | 1 | **1.90M** | 架构计划 |
| review-fixer | 1 | **1.11M** | 审查修复 |
| code-reviewer | 2 | **0.89M** | 2 轮审查（38/38 PASS） |
| 主 Agent | 1 | **15.07M** | 全程编排 |
| **合计** | **17** | **54.51M** | |

> 缓存读取占总 Token 的 ~93%，实际网络传输约 4M Token。

### 3.3 阶段 Token 明细

| 阶段 | Token | 主要消耗 |
|------|-------|----------|
| UI 对齐 | 3.86M | 1 个页面转换 |
| 增量 UI 对齐 | 6.65M | 双设备截图 + UI diff + 历史记录页新增 |
| 规格生成 | 1.73M | 3 个 SPEC (38 场景) |
| 逻辑迁移 + 构建 + 审查 | 18.71M | 逻辑编码、构建签名 HAP、代码审查、修复 |
| self-tester 编排 | 5.88M | 3 轮自测调度和轮询 |
| AutoTest 执行 | 2.35M | MiniMax 多模态执行用例 |

> 自测相关 Token 约 8.23M，占全部 Token（56.86M）的 14.5%。

### 3.4 AutoTest 统计

| 轮次 | LLM 调用 | Token | 用例数 | 结果 |
|------|---------|-------|--------|------|
| Round 1 | 69 | 0.78M | 7 | 0/7 PASS |
| Round 2 | 50 | 0.65M | 7 | 1/7 PASS |
| Round 3 | 57 | 0.92M | 7 | 1/7 PASS |
| **合计** | **176** | **2.35M** | | |

> AutoTest 平均每用例 ~0.11M，远低于 WhatCanICook 的 ~0.21M（7 用例 vs 48 用例，规模效应）。

---

## 四、发现的问题

| 分类 | 发现的问题 | 典型现象 | 影响范围 |
|------|------------|----------|----------|
| UI 还原 | 顶部图标用 emoji 替代了 Google 标准图标；按钮丢失渐变背景和立体阴影效果；字符按钮间距与原版有偏差 | 整体视觉风格从新拟态变为扁平化，图标跨设备渲染不一致 | 顶部图标 + 全部字符按钮（约 16 个）+ 按钮网格 |
| AutoTest 坐标映射 | AI 视觉对含阴影/边框的自定义组件定位精度不足 | 按钮点击坐标偏差导致操作失败 | 6/7 用例受影响；hdc 获取精确坐标后验证 7/7 通过 |
| 签名 HAP 白费 7.59M Token + 35 分钟 | pipeline Skill 硬编码 `--signed`，假设设备测试必须签名；但模拟器上 unsigned HAP 就能装。build-fixer Skill 本该在签名配置为空时停下来让用户处理，但 Agent 没停，自己折腾了 29 次 hap-sign-tool 命令手动签名 | 签名构建花 35 分钟、7.59M Token、113 次工具调用；如果一开始就构建 unsigned，1 条命令搞定 | 额外消耗占全部 Token 的 13.3% |
| `@Track` 陷阱 | `@Observed` + `@Track` getter 导致运行时崩溃 | getter 无法标记 @Track，BusinessError | Round 1 首次自测启动崩溃，修复后恢复 |

> UI 还原问题的根本原因：这些图标和效果在 Android 端是 Compose 库代码生成的，不是图片文件，转换工具无法直接搬过来，增量对齐阶段识别到了差异但跳过了。

---

*数据来源: opencode SQLite 数据库 + AutoTest batch_stdout.log*
