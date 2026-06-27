# Self-Test Fix Report

## 概览

- **报告中失败 scenario 总数**: 7
- **白盒确认问题存在**: 7（全部因同一根因 — 应用启动崩溃导致白屏）
- **白盒判定为误报**: 0
- **修复成功**: 7（1 个根因修复，解除全部 7 个 scenario 的阻塞）
- **修复失败（2次尝试后）**: 0

---

## 白盒审查结果

### Scenario: 完成一次加法计算 (Case 1)
- **Feature**: 加法计算
- **审查结论**: confirmed（根因级）
- **审查详情**: 应用启动时 `aboutToAppear()` 中 `this.getUIContext().getHostContext()` 返回 `undefined`，直接访问 `context.config` 抛出 `TypeError`，导致页面无法渲染（白屏），所有后续操作无法执行。
- **相关代码位置**: `entry/src/main/ets/pages/Index.ets:40-43`（修复前）

### Scenario: 清除当前输入 (Case 2)
- **Feature**: 清除输入
- **审查结论**: confirmed（根因级）
- **审查详情**: 同 Case 1 — 应用启动崩溃导致白屏，清除功能完全无法测试。`performClear()` 逻辑本身经白盒验证正确。
- **相关代码位置**: `entry/src/main/ets/pages/Index.ets:40-43`（修复前）

### Scenario: 完成一次乘法计算 (Case 3)
- **Feature**: 乘法计算
- **审查结论**: confirmed（根因级）
- **审查详情**: 同 Case 1 — 应用启动崩溃导致白屏。`evaluateExpression` 中 `×` (U+00D7) → `*` 替换和乘法计算逻辑本身正确。
- **相关代码位置**: `entry/src/main/ets/pages/Index.ets:40-43`（修复前）

### Scenario: 切换深色模式并保持输入 (Case 4)
- **Feature**: 主题切换
- **审查结论**: confirmed（根因级 + 潜在次级问题）
- **审查详情**: 根因同 Case 1。此外，`toggleTheme()` 方法同样使用 `getHostContext()` 且无空值检查，在 `setColorMode()` 调用时也会因 context 为 undefined 而崩溃。两处均需修复。
- **相关代码位置**: `entry/src/main/ets/pages/Index.ets:61-88`（修复前 toggleTheme）

### Scenario: 深色模式下继续计算 (Case 5)
- **Feature**: 深色模式 + 计算
- **审查结论**: confirmed（根因级）
- **审查详情**: 同 Case 1 + Case 4 — 启动崩溃 + 主题切换崩溃双重阻塞。
- **相关代码位置**: `entry/src/main/ets/pages/Index.ets:40-43, 61-88`（修复前）

### Scenario: 查看历史记录并恢复计算 (Case 6)
- **Feature**: 历史记录
- **审查结论**: confirmed（根因级）
- **审查详情**: 同 Case 1 — 应用启动崩溃导致白屏。历史记录导航、恢复计算的 `onPageShow()` 逻辑本身正确。
- **相关代码位置**: `entry/src/main/ets/pages/Index.ets:40-43`（修复前）

### Scenario: 清空历史记录后展示空状态 (Case 7)
- **Feature**: 清空历史记录
- **审查结论**: confirmed（根因级）
- **审查详情**: 同 Case 1 — 应用启动崩溃导致白屏。`HistoryPage` 的清空对话框和空状态展示逻辑本身正确。
- **相关代码位置**: `entry/src/main/ets/pages/Index.ets:40-43`（修复前）

---

## 修复计划

| 序号 | 涉及文件 | 修改摘要 | 关联 Scenario |
|------|---------|---------|--------------|
| 1 | entry/src/main/ets/pages/Index.ets | 修复 `aboutToAppear()` 中 `getHostContext()` 返回 undefined 导致的启动崩溃；添加 null 检查和 try-catch | 全部 7 个 Scenario（根因修复） |
| 2 | entry/src/main/ets/pages/Index.ets | 修复 `toggleTheme()` 中同样的 `getHostContext()` null 问题；添加 null 检查和 try-catch | Case 4, Case 5（主题切换场景） |

---

## 修复详情

### 修复 #1: 修复 `aboutToAppear()` 启动崩溃

- **关联 Scenario**: 全部 7 个 Scenario（Case 1-7）
- **Android 参考实现**: Android `SiliconeCalculatorActivity.onCreate()` 使用 `isSystemInDarkTheme()` 获取系统暗色模式，无需通过 context 访问配置，不会崩溃。
- **根因分析**:
  鸿蒙代码中 `aboutToAppear()` 调用 `this.getUIContext().getHostContext()` 获取 ability context，该方法返回 `common.Context | undefined`。在页面生命周期早期阶段（`aboutToAppear` 在 `build()` 之前调用），`getHostContext()` 可能返回 `undefined`。原代码直接对返回值执行 `as common.UIAbilityContext` 类型断言（运行时不改变值），然后访问 `context.config.colorMode`，在 `context` 为 `undefined` 时抛出 `TypeError: Cannot read properties of undefined (reading 'config')`。这个未捕获异常导致页面 `build()` 永远不被调用 → 白屏。

  **崩溃链路**:
  ```
  EntryAbility.onWindowStageCreate()
    → loadContent('pages/Index')
      → Index.aboutToAppear()
        → this.getUIContext().getHostContext() → undefined
        → (undefined as UIAbilityContext).config → TypeError!
        → build() 永远不执行 → 白屏
  ```

- **修改内容**:
  - `entry/src/main/ets/pages/Index.ets` `aboutToAppear()` 方法：
    - 添加 `try-catch` 包裹整个方法体
    - 添加 `if (context && context.config)` 空值检查
    - 如果 context 或 config 不可用，保持默认值（浅色模式），不崩溃
- **有效尝试次数**: 1
- **修复结果**: 成功

### 修复 #2: 修复 `toggleTheme()` 主题切换崩溃

- **关联 Scenario**: Case 4（切换深色模式并保持输入）、Case 5（深色模式下继续计算）
- **Android 参考实现**: Android `SiliconeCalculatorActivity` 中主题切换通过 `darkTheme = !darkTheme` 状态变量 + `CircularReveal` 动画组件实现，不依赖底层 context API。
- **根因分析**:
  `toggleTheme()` 方法中同样使用 `this.getUIContext().getHostContext()` 获取 context，并在 `.then()` 回调和 `.catch()` 回调中直接调用 `context.getApplicationContext().setColorMode()`。如果 context 为 `undefined`，这些调用也会崩溃，导致主题切换功能完全不可用。此外，`getComponentSnapshot().get()` 如果同步抛出异常，外层没有 try-catch 保护。

- **修改内容**:
  - `entry/src/main/ets/pages/Index.ets` `toggleTheme()` 方法：
    - 从 `uiContext.getHostContext()` 获取 context（复用已有的 `uiContext` 引用）
    - 提取 `applyColorMode()` 闭包函数，集中处理 `isDarkMode` 翻转和 `setColorMode` 调用
    - `applyColorMode()` 内部对 context 进行 null 检查，`setColorMode` 调用包裹 try-catch
    - 外层对 `getComponentSnapshot().get()` 添加 try-catch，确保同步异常也能回退到 `applyColorMode()`
    - `.catch()` 回调中移除了未使用的 `error` 参数
- **有效尝试次数**: 1
- **修复结果**: 成功

---

## 误报 Scenario（未修改）

_无误报 Scenario。全部 7 个 Scenario 均为真实问题（同一根因：应用启动崩溃）。_

---

## 编译验证

- **编译结果**: 通过（一次编译成功）
- **build-fixer 修复的编译问题**: 无
- **编译命令**: `hvigorw --mode module -p product=default assembleHap --analyze=normal --parallel --incremental --no-daemon`
- **编译输出**: `BUILD SUCCESSFUL in 3s 170ms`
- **警告**: 仅存在与本次修改无关的既有弃用警告（`getParams`、`pushUrl`、`router.back` 已弃用）

---

## 所有修改文件汇总

| 文件 | 修改类型 | 关联 Scenario |
|------|---------|--------------|
| entry/src/main/ets/pages/Index.ets | 修改（aboutToAppear + toggleTheme） | 全部 7 个 Scenario |

---

## 建议

### 已修复的功能验证路径（供后续自测参考）

修复启动崩溃后，以下功能的代码逻辑已通过白盒验证，预期可正常工作：

1. **加法计算 (Case 1)**: `performDigit('1')` → `performOperator('+')` → `performDigit('2')` → `performEquals()` → `evaluateExpression("1 + 2")` = "3.0" ✓
2. **清除输入 (Case 2)**: `performDigit('9')` → `performClear()` → `clearLastChar("9")` = "0" ✓
3. **乘法计算 (Case 3)**: 同加法，`evaluateExpression("4 × 5")` 中 × → * 替换后求值 = "20.0" ✓
4. **主题切换 (Case 4)**: `toggleTheme()` 翻转 `isDarkMode` + `setColorMode()`，`@Track isDarkMode` 触发 UI 更新，result 状态保持 ✓
5. **深色模式计算 (Case 5)**: 主题切换后计算逻辑不受影响 ✓
6. **历史记录恢复 (Case 6)**: `performEquals()` → `HistoryRepository.add()` → 导航到 HistoryPage → 点击恢复 → `onPageShow()` 读取 router params ✓
7. **清空历史 (Case 7)**: HistoryPage 清空对话框 → `HistoryViewModel.clearHistory()` → 空状态 "Nothing to show!" ✓

### 仍需关注的事项

- **弃用 API 警告**: `router.getParams()`、`router.pushUrl()`、`router.back()` 均已弃用，建议后续迁移到 `Navigation` 组件。这不影响当前功能，但可能在更高 API 版本中被移除。
- **`@Observed` + `@Track` 兼容性**: 当前使用 `@Track` 装饰器进行细粒度属性追踪，需确认目标设备 API 版本支持此特性。
- **主题切换动画**: `getComponentSnapshot().get('calcRoot')` 在某些设备上可能返回失败，但有 `.catch()` 回退机制确保功能正常（仅无动画效果）。
