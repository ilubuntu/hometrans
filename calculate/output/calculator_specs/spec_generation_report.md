# Spec Generation Report

## 概述

本报告总结了从 Android 项目 **SiliconeCalculator**（Jetpack Compose 计算器应用）中提取的 3 个需求规格说明（SPEC）的生成过程与结果。

- **输入需求文件**: `calculate/input/requirements.txt`（3 个 REQ 块）
- **Android 项目**: `calculate/SiliconeCalculator`（GitNexus 索引：661 节点，1374 边，29 执行流）
- **输出目录**: `calculate/output/calculator_specs/`

## 生成文件清单

| 文件 | 类型 | 场景数 |
|---|---|---|
| `.trace/Calculator-Main.md` | 追踪文件 | 12 个 Entry Block |
| `.trace/Calculator-DarkMode.md` | 追踪文件 | 6 个 Entry Block |
| `.trace/Calculator-History.md` | 追踪文件 | 7 个 Entry Block |
| `Calculator-Main-SPEC.md` | 需求规格 | 21 个场景 |
| `Calculator-DarkMode-SPEC.md` | 需求规格 | 7 个场景 |
| `Calculator-History-SPEC.md` | 需求规格 | 10 个场景 |

## 各 REQ 处理摘要

### 1. Calculator-Main（基础计算器）

- **追踪**: 12 个 Entry Block，覆盖应用启动初始化、显示区、数字输入（含前导零处理）、四则运算符（含初始态/连续运算符替换）、等号求值（完整/不完整/重复）、小数点（含重复防护）、C 删除（含回退操作数）、AC 全清、按键守卫（无效结果锁定/求值后锁定）、按键布局动态切换（C↔AC）、正负号/百分号（代码存在但 REQ 未提及）。
- **SPEC**: 21 个原子场景，涵盖正常路径与边界条件。
- **偏差**: 代码额外实现了正负号（±）、百分号（%）、长按 C 触发 AC、千分位逗号格式化、结果默认带小数等，REQ 未提及，已在 trace 偏差中标注。

### 2. Calculator-DarkMode（深色/浅色模式切换）

- **追踪**: 6 个 Entry Block，覆盖主题状态持有与初始值（跟随系统）、切换入口按钮 UI、切换逻辑（翻转 + 配色）、圆形揭示动画、计算状态保持（解耦验证）、系统状态栏跟随。
- **SPEC**: 7 个原子场景，涵盖初始跟随系统、切换动画、切换时数据保持（输入/表达式/结果/历史记录）、反复切换、作用范围。
- **偏差**: 无显著偏差。代码额外实现了圆形揭示动画和状态栏适配（视觉增强），主题不持久化（REQ 未要求）。

### 3. Calculator-History（计算历史记录）

- **追踪**: 7 个 Entry Block，覆盖保存计算（含守卫条件）、历史入口跳转、列表展示（分组/空状态/滚动定位）、日期格式化、恢复计算（导航参数传递）、清空确认弹窗、返回操作。
- **SPEC**: 10 个原子场景，涵盖有效保存、无效/不完整不保存、查看列表、空状态、恢复记录、返回不恢复、清空确认、取消清空、作用范围。
- **偏差**: **关键偏差** — REQ 描述"清空后历史记录页面展示空状态"，但代码实际在点击确认清空后同时返回计算器主页面（`onHistoryClear() + onBackPress()`）。SPEC 以 REQ 为准描述，并在场景八中标注偏差。

## 方法论遵循情况

- **多层级声明**: 每个 Entry Block 均覆盖 UI 层 / 状态层 / 数据层 / 格式化层等多个代码层级，附 file:line 锚点。
- **可复现事实**: 所有行为描述均有对应源码 file:line 或测试用例佐证，无臆造。
- **平台令牌剥离**: 所有 SPEC 文件均已剥离 Android 平台令牌（Activity、ViewModel、Room、Compose 等），替换为行为级中文词汇（页面、状态、数据库、弹窗等）。
- **REQ 优先**: 当 REQ 与代码不一致时，SPEC 以 REQ 描述为准，偏差在 SPEC 和 trace 中标注。
- **UI 入口全覆盖**: 不仅覆盖 REQ 明确提及的入口，还覆盖代码中发现的所有相关 UI 入口（如长按 C、正负号、百分号等）。

## 核心偏差汇总

| # | REQ | 偏差描述 | 影响程度 |
|---|---|---|---|
| 1 | Calculator-History | 清空后代码直接返回主页面，非停留在历史页展示空状态 | 中 — 影响清空后用户所见页面 |
| 2 | Calculator-Main | 代码有正负号(±)、百分号(%)按键，REQ 未提及 | 低 — 附加功能 |
| 3 | Calculator-Main | 长按 C 触发 AC，REQ 未提及 | 低 — 快捷操作 |
| 4 | Calculator-Main | 结果默认带小数（如 3.0），千分位逗号格式化 | 低 — 显示细节 |
| 5 | Calculator-DarkMode | 主题切换有圆形揭示动画，REQ 未提及 | 低 — 视觉增强 |
| 6 | Calculator-DarkMode | 主题偏好不持久化，重启后重新跟随系统 | 低 — REQ 未要求持久化 |
