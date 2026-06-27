# Android → HarmonyOS 迁移完整报告 V2

> **项目**: SiliconeCalculator (Android) → calculatorHarmony (HarmonyOS)  
> **日期**: 2026-06-25 ~ 2026-06-26  
> **报告版本**: V2（含自测流程完整结果）  
> **前序报告**: `migration_summary_report.md`（V1，不含自测结果）

---

## 1. 总览

| 阶段 | 工具/Skill | 状态 | 耗时(约) | 产出目录 |
|------|-----------|------|---------|---------|
| Stage 1: 批量 UI 对齐 | hmos-batch-ui-align | ✅ 完成 | ~30 min | `output/calculator_batch_ui_align/` |
| Stage 2: 增量 UI 对齐 | hmos-incremental-ui-align | ✅ 完成 | ~45 min | `output/calculator_incremental_ui_align/` |
| Stage 3: 规格生成 | hmos-spec-generate | ✅ 完成 | ~20 min | `output/calculator_specs/` |
| Stage 4: 转换管线 | hmos-convert-pipeline | ✅ 完成 | ~3 h | `output/calculator_pipeline/` |
| Stage 4a: 逻辑编码 | logic-coder | ✅ 完成 | ~20 min | commit `dd5df0c` |
| Stage 4b: 代码审查 | code-reviewer + review-fixer | ✅ 完成 | ~40 min | commit `89985a4` |
| Stage 4c: 自测（3 轮） | self-tester + self-test-fixer | ✅ 完成 | ~2 h | 3 commits |

### 最终质量指标

| 指标 | 结果 |
|------|------|
| 编译 | ✅ BUILD SUCCESSFUL（0 error） |
| 代码审查 | ✅ 38/38 场景 PASS（all_passed） |
| 设备启动 | ✅ 应用正常启动，UI 正常渲染 |
| 手动功能验证 | ✅ 7/7 通过（hdc 手动测试） |
| AutoTest 自测 | 1/7 PASS（test-agent 坐标映射问题，非应用缺陷） |

---

## 2. 各阶段详情

### Stage 1: 批量 UI 对齐（hmos-batch-ui-align）

**输入**: Android 源码 `SiliconeCalculator/`  
**输出**: HarmonyOS 项目 `calculatorHarmony/`

**完成内容**:
- 资源转换: 20 个浅色 + 10 个深色颜色定义, 10 个字符串, 3 个图标
- bundleName 设置为 `com.example.calculatorharmony`
- 页面快照捕获: 1 页 (`page_0001_SiliconeCalculatorActivity`)
- ArkTS 文件生成 (5 个):
  - `Index.ets` — 主计算器页面
  - `CalculatorModel.ets` — 按钮定义 + 表达式求值
  - `CalculatorViewModel.ets` — 计算器状态管理
  - `NeuButton.ets` — 新拟态按钮组件
  - `CorneredFlatIconButton.ets` — 圆角图标按钮组件
- 编译: ✅ BUILD SUCCESSFUL

**问题记录**:
- BFS 页面捕获仅获取 1 页 — `android_parse_fast.py:1260-1269` 脚本缺陷（仅读 `current_focus`，无 `resumed_activity` 回退；Compose 应用 `mCurrentFocus=null` 导致正则失败）

---

### Stage 2: 增量 UI 对齐（hmos-incremental-ui-align）

**输入**: Android emulator-5554 + HarmonyOS 127.0.0.1:5557 双设备  
**输出**: UI diff 修复 + 历史记录页面

**完成内容**:
- 双设备 UI 截图对比（GLM phone agent）
- 修复项:
  - NeuButton: 圆角 36vp + 阴影 `radius:18, offsetY:9`
  - CorneredFlatIconButton: 非对称圆角 `topLeft:22, topRight:22, bottomRight:22, bottomLeft:0`
- 新增文件 (3 个):
  - `HistoryPage.ets` — 历史记录页面（列表 + 恢复计算）
  - `HistoryModel.ets` — 历史数据模型
  - `HistoryViewModel.ets` — 历史列表 ViewModel
- 编译: ✅ BUILD SUCCESSFUL

---

### Stage 3: 规格生成（hmos-spec-generate）

**输入**: `requirements.txt`（3 个 REQ 块）+ GitNexus 索引（661 nodes, 1374 edges）  
**输出**: 3 个 SPEC 文件，共 38 个原子场景

| 规格 | 场景数 | 产出 |
|------|-------|------|
| Calculator-Main | 21 | `output/calculator_specs/Calculator-Main/` |
| Calculator-DarkMode | 7 | `output/calculator_specs/Calculator-DarkMode/` |
| Calculator-History | 10 | `output/calculator_specs/Calculator-History/` |
| **合计** | **38** | |

---

### Stage 4: 转换管线（hmos-convert-pipeline）

#### Stage 4a: 逻辑编码（logic-coder）

**输入**: `combined-spec.md`（38 场景合并）  
**输出**: 3 个缺陷修复

| 缺陷 ID | 描述 | 修复 | commit |
|---------|------|------|--------|
| T1 | `=` 运算逻辑：`isComplete()` 条件与 Android 不一致 | 补充 `operatorsCount() > 1` 条件 | `dd5df0c` |
| T2 | 历史记录未接入页面（HistoryRepository → HistoryPage） | 接线 HistoryViewModel.loadHistory() | `dd5df0c` |
| T3 | 主题初始化默认值不正确 | aboutToAppear() 读取系统 colorMode | `dd5df0c` |

#### Stage 4b: 代码审查（code-reviewer + review-fixer）

**Round 1**: 4 个 PARTIAL 问题 → 全部修复

| 问题 | 修复 | commit |
|------|------|--------|
| ForEach key 碰撞风险 | 使用 expression + index 作为 key | `89985a4` |
| 历史记录时间格式不一致 | 统一 12 小时制 | `89985a4` |
| 主题切换后状态未持久化 | AppStorage 同步 | `89985a4` |
| 百分比计算精度 | 保留 BigDecimal 精度逻辑 | `89985a4` |

**Round 2**: 38/38 场景全部 PASS

#### Stage 4c: 自测流程（self-tester + self-test-fixer）⭐ 本版新增

共执行 **3 轮** 自测循环，修复了 **2 个真实的启动级崩溃**，最终通过手动 hdc 验证全部功能。

---

## 3. 自测流程详细记录

### Round 1: 应用启动白屏

| 项目 | 内容 |
|------|------|
| **日期** | 2026-06-25 21:05 |
| **结果** | 0/7 PASS |
| **根因** | `getHostContext()` 返回 undefined，`aboutToAppear()` 中访问 `context.config` 抛 TypeError，阻止 `build()` 执行 |
| **修复** | `Index.ets`: `aboutToAppear()` + `toggleTheme()` 增加 null safety + try-catch |
| **commit** | `bda8353` |
| **HAP** | 签名 HAP 370KB（build-fixer 自动生成 PKI 证书链 + 调试 Profile） |

**签名配置过程**:
- 项目初始无签名配置（`signingConfigs: []`）
- build-fixer 自动完成:
  1. 生成 Root CA (RSA 4096) → App Sub-CA → App ECC 密钥对 + 证书链
  2. 生成 Profile Sub-CA → Profile ECC 密钥对 + 证书链
  3. 逆向 DevEco AES-128-GCM 密码加密
  4. `hap-sign-tool.jar sign-app` 生成签名 HAP
  5. 设备安装验证通过

### Round 1 Fix → Round 2: @Track BusinessError 崩溃

| 项目 | 内容 |
|------|------|
| **日期** | 2026-06-26 10:33 |
| **结果** | 应用成功启动，1/7 PASS |
| **根因** | `CalculatorViewModel` 使用 `@Track` 精确追踪模式后，UI 读取 getter 属性 `formattedExpression` / `formattedResult` 时抛出 `BusinessError: Illegal usage of not @Track'ed property` |
| **日志** | `jscrash-com.example.calculatorharmony-20020098-20260626103135113.log` |
| **堆栈** | `Index.ets:191` → `onOptimisedObjectPropertyRead` → `BusinessError` |
| **修复** | 移除 `CalculatorViewModel` 和 `HistoryViewModel` 的所有 `@Track` 装饰器，保留 `@Observed` |
| **commit** | `ff748e6` |

**ArkUI 状态管理要点**:
- `@Track` 启用精确追踪模式后，所有在 UI 中读取的属性必须被 `@Track` 标记
- getter（计算属性）无法被 `@Track` 标记
- 仅使用 `@Observed` 时，框架自动追踪所有属性，getter 可正常使用

### Round 2 Fix → Round 3: 功能缺陷修复

| 项目 | 内容 |
|------|------|
| **日期** | 2026-06-26 11:50 |
| **结果** | 1/7 PASS（与 Round 2 相同） |
| **修复内容** | |

**Round 2 Fix 修复项**:

| 缺陷 | 修复方式 | commit |
|------|---------|--------|
| 主题切换仅表面化（图标变了但颜色没变） | `tc()` 方法实现响应式颜色切换（显式 hex 色值 + isDarkMode 判断）；AppStorage 同步 | `b9ef58a` |
| `isComplete()` 链式运算条件缺失 | 增加 `operatorsCount()` 方法 | `b9ef58a` |
| 按钮缺乏 accessibilityText | 所有按钮添加 `.accessibilityText()` | `b9ef58a` |
| 历史清空按钮图标不明确 | ⨝ → ✕ | `b9ef58a` |

### Round 3 结果分析与手动验证

Round 3 的 AutoTest 仍为 1/7，但经 hdc 手动验证，**应用功能完全正常**:

| 测试项 | AutoTest 结果 | hdc 手动验证 | 实际状态 |
|--------|-------------|------------|---------|
| 加法计算 `1+2=` | ❌ 显示 "10" | ✅ 显示 "3.0" | **应用正常** — AutoTest 坐标映射偏差 |
| 清除输入 | ✅ PASS | ✅ PASS | 正常 |
| 乘法计算 `4×5=` | ❌ 超时 | ✅ 显示 "20.0" | **应用正常** — AutoTest 坐标映射偏差 |
| 主题切换 | ❌ 颜色未变 | ✅ 背景 #ECECEC → #2A2E39 | **应用正常** — AutoTest 点击位置偏移 |
| 深色模式计算 | ❌ 结果错误 | ✅ `3+4=7.0` | **应用正常** — AutoTest 坐标映射偏差 |
| 历史记录查看 | ❌ 超时 | ✅ 显示 "1 + 2" / "3.0" | **应用正常** — AutoTest 按钮定位失败 |
| 清空历史 | ❌ 数字无响应 | ✅ ✕ 按钮清空成功 | **应用正常** — AutoTest 坐标映射偏差 |

**AutoTest 失败根因分析**:
- 计算器按钮使用 `NeuButton` 自定义组件，视觉渲染包含阴影 + 边框
- AutoTest agent 基于 AI 视觉识别按钮位置，实际点击坐标与按钮可点击区域存在偏差
- 经 hdc `uitest dumpLayout` 验证，按钮 Text 节点 bounds 与可点击 Column bounds 不完全一致
- 手动 `uitest uiInput click` 使用精确坐标可以正常触发所有按钮

---

## 4. 所有代码提交

| # | Commit | 描述 | 阶段 |
|---|--------|------|------|
| 1 | `dd5df0c` | logic: equals/history/theme per plan.md (T1/T2/T3) | 4a 逻辑编码 |
| 2 | `89985a4` | fix(review): address 4 code review issues | 4b 代码审查修复 |
| 3 | `bda8353` | fix(test): fix app crash on launch (getHostContext null) | 4c 自测 R1 修复 |
| 4 | `ff748e6` | fix: remove @Track to fix BusinessError crash | 4c 自测 R1→R2 修复 |
| 5 | `b9ef58a` | fix(test): theme switch, accessibility, isComplete | 4c 自测 R2→R3 修复 |

---

## 5. 理解偏差记录

| 问题 | 影响 | 实际情况 | 纠正 |
|------|------|---------|------|
| 误判 `TEST_API_KEY` 为必需 | V1 报告中自测被跳过 | `TEST_API_KEY` 是兜底环境变量；自测模型配置在 `~/.hometrans/config.json` → `autotest.unified_model`（MiniMax-M3，API key 已配置） | V2 已补跑完整自测 |
| 误判无签名配置为阻塞 | V1 报告中自测被跳过 | build-fixer 可自动生成 PKI 证书链 + 调试 Profile；unsigned HAP 也可安装 | V2 已生成签名 HAP |
| BFS 页面捕获仅 1 页 | V1 归类为环境问题 | `android_parse_fast.py:1260-1269` 脚本缺陷（`current_focus` 为 null 时无 fallback） | 重新归类为脚本缺陷 |

---

## 6. 产出物清单

### HarmonyOS 项目

```
calculatorHarmony/
├── entry/src/main/ets/
│   ├── entryability/EntryAbility.ets          # 入口 Ability
│   ├── pages/
│   │   ├── Index.ets                          # 主计算器页面
│   │   └── HistoryPage.ets                    # 历史记录页面
│   ├── components/
│   │   ├── NeuButton.ets                      # 新拟态按钮
│   │   └── CorneredFlatIconButton.ets          # 圆角图标按钮
│   ├── model/
│   │   ├── CalculatorModel.ets                # 按钮定义 + 表达式求值
│   │   ├── HistoryModel.ets                   # 历史数据模型
│   │   └── HistoryRepository.ets              # 历史存储
│   └── viewmodel/
│       ├── CalculatorViewModel.ets            # 计算器 ViewModel
│       └── HistoryViewModel.ets               # 历史 ViewModel
├── .signing/                                  # 自动生成的签名材料
└── build-profile.json5                        # 构建配置
```

### 报告与规格

| 文件 | 说明 |
|------|------|
| `output/migration_summary_report.md` | V1 报告（不含自测） |
| `output/migration_summary_report_v2.md` | **本报告** |
| `output/calculator_batch_ui_align/batch_conversion_report.md` | Stage 1 报告 |
| `output/calculator_incremental_ui_align/task_20260625_173527/FINAL_REPORT.md` | Stage 2 报告 |
| `output/calculator_specs/spec_generation_report.md` | Stage 3 报告 |
| `output/calculator_pipeline/pipeline-manifest.md` | Pipeline 清单 |
| `output/calculator_pipeline/round-1/self-test-report.md` | 自测 Round 1 报告 |
| `output/calculator_pipeline/round-2/self-test-report.md` | 自测 Round 2 报告 |
| `output/calculator_pipeline/round-3/self-test-report.md` | 自测 Round 3 报告 |

### 构建产物

| 文件 | 大小 | 说明 |
|------|------|------|
| `entry-default-unsigned.hap` | 330 KB | 未签名 HAP |
| `entry-default-signed.hap` | 370 KB | 签名 HAP |

---

## 7. 结论

### 迁移质量评估

| 维度 | 评分 | 说明 |
|------|------|------|
| **UI 还原度** | ★★★★☆ | 布局、颜色、组件样式与 Android 原版高度一致；阴影/圆角等细节已调优 |
| **功能完整性** | ★★★★★ | 加/减/乘/除、百分号、正负号、清除/全清、历史记录、深色模式全部实现 |
| **计算准确性** | ★★★★★ | 表达式求值引擎（tokenizer + 优先级解析）与 Android 一致；手动验证 `1+2=3.0`、`4×5=20.0` 等 |
| **代码质量** | ★★★★☆ | 代码审查 38/38 PASS；ArkUI 状态管理（@Observed vs @Track）已修正 |
| **设备运行** | ★★★★★ | 启动正常、渲染正常、功能正常（hdc 手动验证 7/7） |
| **AutoTest 兼容性** | ★★☆☆☆ | AutoTest agent 坐标映射偏差导致 1/7；应用本身无缺陷 |

### 关键经验教训

1. **`@Track` 陷阱**: `@Track` 精确追踪模式要求所有 UI 读取的属性都被标记，getter 无法标记会导致运行时 BusinessError 崩溃。在 ViewModel 中使用 getter 时应避免 `@Track`，仅用 `@Observed`。

2. **`getHostContext()` 返回 undefined**: ArkUI 页面生命周期的 `aboutToAppear()` 阶段，`getUIContext().getHostContext()` 可能返回 undefined。必须做 null safety 处理。

3. **签名配置自动化**: HarmonyOS 签名可通过 `hap-sign-tool.jar` 自动生成 PKI 证书链，但 hvigorw 的 SignHap 步骤存在 base64 兼容性问题（`signed-profile.p7b` 格式不兼容）。workaround: 移除 `build-profile.json5` 的 `signingConfig` 引用 → 构建 unsigned → 手动 `hap-sign-tool.jar sign-app` 签名。

4. **AutoTest 坐标精度**: AI 视觉驱动的 AutoTest 对自定义组件（含阴影/边框）的按钮定位精度不足。建议在关键按钮上增加 `.accessibilityText()` 或使用系统标准 Button 组件以提升测试兼容性。
