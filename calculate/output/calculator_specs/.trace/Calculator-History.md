# Trace — Calculator-History

## Status

DONE — 所有 entry 块均已通过源码 file:line 核实，无臆造。

## REQ 原文摘要

> 应用支持计算历史记录。用户完成一次有效计算后，该计算的表达式、结果和日期被保存到历史记录。用户点击历史记录入口后进入历史记录页面，可以查看最近计算记录；点击某条历史记录后回到主计算页面，并恢复该记录的表达式和结果。用户可以清空历史记录，清空后历史记录页面展示空状态。

## Recalled Entry Points (通过 GitNexus query + context 定位)

- `CalculatorViewModel.saveCalculationInHistory` — 保存计算到历史, `CalculatorViewModel.kt:114`
- `CalculatorViewModel.performCalculatorButton` — Equals 触发保存, `CalculatorViewModel.kt:100-112`
- `CalculatorTopBar` — 历史记录入口按钮, `CalculatorScreen.kt:142-147`
- `AppNavigationActions.navigateToHistory` — 跳转历史页, `AppNavigationActions.kt:57`
- `AppNavigationActions.navigateToCalculator` — 从历史恢复并返回计算器, `AppNavigationActions.kt:45`
- `CalculatorViewModel.updateCalculatorDisplay` — 从导航参数恢复计算, `CalculatorViewModel.kt:90`
- `HistoryScreen` — 历史记录页面 UI, `HistoryScreen.kt:86`
- `HistoryViewModel` — 历史记录页面状态, `HistoryViewModel.kt:30`
- `HistoryViewModel.onHistoryClear` — 清空历史, `HistoryViewModel.kt:42`
- `HistoryRepositoryImpl` — 数据层实现, `HistoryRepositoryImpl.kt:27`
- `HistoryDao` — 数据库操作, `HistoryDao.kt:24`
- `HistoryEntity` / `History` — 数据模型, `HistoryEntity.kt:32` / `History.kt:22`
- `LocalDate.format` — 日期格式化, `DateFormatter.kt:30`

---

## Entry Block 1: 保存计算到历史记录

### Claim

用户完成一次有效计算（点击等号）后，该计算的表达式和结果被保存到历史记录，并自动记录保存日期。无效结果（Infinity/NaN）、未完成计算、重复求值不保存。

### Layers

- **触发点**: `CalculatorViewModel.kt:104-109` —
  ```
  _calculation.update {
      calculatorButton.perform(it).also { result ->
          if (calculatorButton == Equals) saveCalculationInHistory(result)
      }
  }
  ```
  仅当按钮为 Equals 时调用 saveCalculationInHistory。
- **保存守卫**: `CalculatorViewModel.kt:114-120` — `saveCalculationInHistory`：
  ```
  if (calculation.expression == previousExpression || calculation.isNotEvaluated || calculation.resultIsInvalid) return
  historyRepository.saveCalculation(calculation)
  previousExpression = calculation.expression
  ```
  - 跳过条件 1: expression == previousExpression（重复求值不重复保存）。
  - 跳过条件 2: isNotEvaluated（表达式未完成，`CalculatorViewModel.kt:122-123` — expression 以运算符结尾或为空）。
  - 跳过条件 3: resultIsInvalid（结果为 Infinity/NaN）。
- **数据层**: `HistoryRepositoryImpl.kt:40-42` — `saveCalculation`: `historyDao.insertHistoryEntity(calculation.asHistoryEntity())`。
- **数据库**: `HistoryDao.kt:25-26` — `@Insert suspend fun insertHistoryEntity(historyEntity)`。
- **日期记录**: `HistoryEntity.kt:34` — `date: LocalDate = Clock.System.todayIn(TimeZone.currentSystemDefault())`，保存时自动取当天日期。
- **previousExpression 初始化**: `CalculatorViewModel.kt:58` — `previousExpression = currentCalculation.expression`（初始为 ""）。

### Interaction

- 用户完成 "1 + 2 = 3.0" → saveCalculationInHistory → 检查通过 → 插入数据库（expression="1 + 2", result="3.0", date=当天）。
- 再次按 "=" → expression == previousExpression → 跳过（测试：`CalculatorViewModelTest.kt:326-336`，coVerify exactly=1）。
- "1 ÷ 0.0 = Infinity" → resultIsInvalid → 跳过（测试：`CalculatorViewModelTest.kt:339-349`，coVerify exactly=0）。

### Data Flow

Equals.perform → Calculation(expression, result) → saveCalculationInHistory(守卫检查) → historyRepository.saveCalculation → historyDao.insertHistoryEntity → HistoryEntity(id, date=今天, expression, result) → 数据库。

---

## Entry Block 2: 历史记录入口 — 从计算器跳转

### Claim

计算器主页面顶部栏有历史记录入口按钮，点击后进入历史记录页面。

### Layers

- **UI 层**: `CalculatorScreen.kt:142-147` — `CalculatorTopBar` 中的 `CorneredFlatIconButton`：
  ```
  onClick = onHistoryNav,
  icon = Icons.Outlined.History,
  contentDescription = stringResource(R.string.calculations_history)
  ```
- **导航**: `SiliconeCalculatorNavHost.kt:77` — `onHistoryNav = { navActions.navigateToHistory() }`。
- **导航实现**: `AppNavigationActions.kt:57-59` — `navigateToHistory`: `navController.navigate(HISTORY)`。

### Interaction

- 点击历史记录按钮 → navigateToHistory → 导航到 HISTORY 路由 → 渲染 HistoryScreen。

---

## Entry Block 3: 历史记录页面 — 列表展示

### Claim

历史记录页面展示所有计算记录，按日期分组显示；每条记录显示表达式和结果；列表默认滚动到最近记录（底部对齐）；空列表时显示空状态提示。

### Layers

- **状态加载**: `HistoryViewModel.kt:34-40` — `uiState = historyRepository.historyItemsStream.map(::HistoryUiState).stateIn(...)`，初始值 `HistoryUiState()`（空列表）。
- **数据流**: `HistoryRepositoryImpl.kt:31-34` — `historyItemsStream = historyDao.getHistoryEntitiesStream().map { it.map(HistoryEntity::asHistory) }`。实时监听数据库变化。
- **页面 UI**: `HistoryScreen.kt:86-144` — HistoryScreen：
  - HistoryTopBar（返回按钮 + 清空按钮）。
  - HistoryItemsList（历史列表）。
- **分组**: `HistoryScreen.kt:240-245` —
  ```
  val historyItemsByDate = remember(historyItems) {
      historyItems.groupBy(keySelector = History::date, valueTransform = History::calculation)
  }
  ```
  按日期分组，每组下显示该日期的多条计算。
- **空状态**: `HistoryScreen.kt:252-256` —
  ```
  if (historyItemsByDate.isEmpty()) {
      Text(text = stringResource(R.string.nothing_to_show))  // "Nothing to show!"
  }
  ```
- **列表渲染**: `HistoryScreen.kt:258-288` — LazyColumn：遍历 historyItemsByDate，每组渲染 HistoryItem（含多条 CalculationItem）+ 分隔线。
- **滚动初始位置**: `HistoryScreen.kt:262-264` — `rememberLazyListState(initialFirstVisibleItemIndex = historyItemsByDate.size * 2)`，初始定位到最后（最近记录在底部可见）。
- **列表项 UI**: `HistoryItem.kt:42-101` — HistoryItem 显示日期标签和该日期下所有计算；CalculationItem 显示表达式（上方、半透明、可水平滚动）和结果（下方、可水平滚动）。
- **数字格式化**: `HistoryItem.kt:88,97` — 表达式和结果均经 `formatNumbers()` 千分位格式化。

### Interaction

- 进入历史页 → 从数据库加载所有记录 → 按日期分组 → 渲染列表 → 默认滚动到底部（最近记录）。
- 无记录 → 显示 "Nothing to show!" 空状态（测试：`HistoryScreenTest.kt:58-69`）。
- 有记录 → 显示列表（测试：`HistoryScreenTest.kt:72-90`）。

### Data Flow

数据库 History 表 → historyDao.getHistoryEntitiesStream() → List<HistoryEntity> → asHistory() → List<History> → HistoryUiState → HistoryScreen → groupBy(date) → HistoryItem/CalculationItem。

---

## Entry Block 4: 日期格式化

### Claim

历史记录的日期以相对格式显示：今天显示 "Today"，昨天显示 "Yesterday"，更早的日期显示 "月 日" 格式（如 "Apr 12"）。

### Layers

- **格式化**: `DateFormatter.kt:30-37` —
  ```
  fun LocalDate.format(pattern: String = "MMM d"): String =
      when (daysUntil(today)) {
          0 -> "Today"
          1 -> "Yesterday"
          else -> DateTimeFormatter.ofPattern(pattern, Locale.ENGLISH).format(...)
      }
  ```
- **实体转换**: `HistoryEntity.kt:39-46` — `asHistory()`: `date = date.format()`，将 LocalDate 转为格式化字符串。
- **显示**: `HistoryItem.kt:58-67` — 日期标签 Text 显示 date 字符串。

### Interaction

- 保存时 date=今天 → 显示 "Today"。
- 保存时 date=昨天 → 显示 "Yesterday"。
- 更早 → 显示 "Apr 12" 等。

---

## Entry Block 5: 从历史记录恢复计算

### Claim

用户点击历史记录页面中的某条计算记录后，返回计算器主页面，该记录的表达式和结果被恢复到计算器显示区。

### Layers

- **点击入口**: `HistoryItem.kt:79` — `CalculationItem` 的 `clickable(onClick = dropUnlessResumed { onCalculationClick(calculation) })`。
- **导航回调**: `SiliconeCalculatorNavHost.kt:90` — `onCalculationClick = { navActions.navigateToCalculator(it) }`。
- **导航实现**: `AppNavigationActions.kt:45-55` — `navigateToCalculator(calculation)`：
  ```
  navController.navigate("$CALCULATOR?expression=${expression.encodeReservedChars}&result=${result}") {
      popUpTo(CALCULATOR) { inclusive = true }
  }
  ```
  - 将 expression 和 result 作为导航参数传递（URL 编码特殊字符）。
  - popUpTo(CALCULATOR) inclusive=true：移除当前计算器页面并创建新实例。
- **恢复逻辑**: `CalculatorViewModel.kt:71-76` — init 块：
  ```
  updateCalculatorDisplay(
      expression = savedStateHandle[EXPRESSION_ARG],
      result = savedStateHandle[RESULT_ARG]
  )
  ```
- **更新显示**: `CalculatorViewModel.kt:90-98` — `updateCalculatorDisplay`：
  ```
  if (expression == null || result == null) return
  _calculation.update { it.copy(expression = expression, result = result) }
  previousExpression = expression  // 防止恢复的计算被重新保存
  ```
  - 设置 previousExpression = expression，确保恢复后按等号不会重复保存该计算（测试：`CalculatorViewModelTest.kt:352-360`）。
- **URL 解码**: 导航参数自动 URL 解码（encodeReservedChars 编码的字符恢复原样）。

### Interaction

- 点击历史记录中的 "1 + 2 = 3.0" → navigateToCalculator(expression="1 + 2", result="3.0") → 新 CalculatorViewModel init → updateCalculatorDisplay → 显示 expression="1 + 2", result="3.0"。
- 集成测试验证：`SiliconeCalculatorTest.kt:40-76` — 从历史恢复后 calculator:expression 显示 "12 + 34"，calculator:result 显示 "46.0"。

### Data Flow

History CalculationItem 点击 → onCalculationClick(calculation) → navigateToCalculator → URL 编码 expression/result → 新 CalculatorViewModel init → savedStateHandle 读取 → updateCalculatorDisplay → _calculation 更新 → Display 显示。

---

## Entry Block 6: 清空历史记录 — 确认弹窗

### Claim

用户在历史记录页面点击清空按钮后，弹出确认弹窗；用户需点击"清空"确认才会清空全部历史记录并返回计算器主页面；点击"取消"则关闭弹窗不清空。

### Layers

- **清空入口**: `HistoryScreen.kt:224-229` — HistoryTopBar 中的清空按钮：
  ```
  CorneredFlatIconButton(
      onClick = onHistoryClear,
      icon = Icons.Outlined.ClearAll,
      contentDescription = stringResource(R.string.clear_history)
  )
  ```
  onClick → `{ coroutineScope.launch { clearHistoryBottomSheetState.show() } }`（打开底部弹窗）。
- **底部弹窗**: `HistoryScreen.kt:105-127` — `ModalBottomSheetLayout`：
  - sheetContent = `ClearHistoryBottomSheetContent`。
  - 显示标题 "Clear" 和提示 "Clear history now?"。
  - "Cancel" 按钮 → `clearHistoryBottomSheetState.hide()`（关闭弹窗，不清空）。
  - "Clear" 按钮（testTag="history:clear"）→ `dropUnlessResumed { onHistoryClear(); onBackPress() }`（清空 + 返回计算器）。
- **清空逻辑**: `HistoryViewModel.kt:42-46` — `onHistoryClear`: `historyRepository.clearAllHistory()`。
- **数据层**: `HistoryRepositoryImpl.kt:36-38` — `clearAllHistory`: `historyDao.deleteAllHistoryEntities()`。
- **数据库**: `HistoryDao.kt:30-32` — `@Query("DELETE FROM History") suspend fun deleteAllHistoryEntities()`。
- **返回**: `SiliconeCalculatorNavHost.kt:89` — `onBackPress = { navActions.onBackPress() }` → `navController.popBackStack()`。

### Interaction

- 点击清空按钮 → 弹出确认弹窗 →
  - 点击"清空" → clearAllHistory（删除全部记录）+ onBackPress（返回计算器主页面）。
  - 点击"取消" → 关闭弹窗，历史记录不变。
- 测试验证：`HistoryScreenTest.kt:93-117` — 点击 clear → 点击 history:clear → 列表消失 → 显示 "Nothing to show!"。

### Data Flow

点击清空按钮 → 弹窗显示 → 点击"清空" → onHistoryClear → historyRepository.clearAllHistory → historyDao.deleteAllHistoryEntities → 数据库 DELETE → historyItemsStream 更新（空列表）+ onBackPress → 返回计算器。

---

## Entry Block 7: 从历史记录页面返回（不恢复）

### Claim

用户点击历史记录页面顶部栏的返回按钮，直接返回计算器主页面，不恢复任何计算。

### Layers

- **返回按钮**: `HistoryScreen.kt:218-223` — HistoryTopBar 中的返回按钮：
  ```
  CorneredFlatIconButton(
      onClick = onBackPress,
      icon = Icons.Outlined.ArrowBack,
      contentDescription = stringResource(R.string.back_to_calculator)
  )
  ```
- **导航**: `SiliconeCalculatorNavHost.kt:89` — `onBackPress = { navActions.onBackPress() }` → popBackStack。

### Interaction

- 点击返回按钮 → popBackStack → 返回计算器主页面（计算器状态保持离开时的值）。

---

## Implicit Triggers (隐式触发)

- **完成有效计算（按等号）** → 自动保存到历史记录（无需用户额外操作）。
- **数据库变化** → historyItemsStream 自动推送更新 → 历史列表实时刷新（保存或清空后立即反映）。

## Core Business Entities (核心业务实体)

| 实体 | 定义位置 | 说明 |
|---|---|---|
| History | `History.kt:22-26` | 历史记录：id + date(格式化字符串) + calculation |
| Calculation | `History.kt:28-43` | 表达式 + 结果（与计算器共享） |
| HistoryEntity | `HistoryEntity.kt:32-37` | 数据库实体：id + epoch_day + expression + result |
| HistoryRepository | `HistoryRepository.kt:23-26` | 数据接口：historyItemsStream / clearAllHistory / saveCalculation |
| HistoryDao | `HistoryDao.kt:24-32` | 数据库操作：insert / query all / delete all |
| previousExpression | `CalculatorViewModel.kt:58` | 防重复保存标记 |

## Cross-Entry Shared Declarations (跨入口共享)

- `Calculation`（`History.kt:28`）— 被计算器和历史记录共享，通过导航参数传递 expression/result。
- `formatNumbers()`（`MathExpressionFormatter.kt:24`）— 历史记录列表项的数字也使用千分位格式化。
- `EXPRESSION_ARG` / `RESULT_ARG`（`AppNavigationActions.kt:33-34`）— 导航参数键，被 navigateToCalculator 和 CalculatorViewModel init 共享。
- `encodeReservedChars`（`SafeUri.kt:19`）— URL 编码，传递含特殊字符的表达式。

## Deviations (偏差)

1. **清空后返回计算器主页面**: REQ 描述"清空后历史记录页面展示空状态"，但代码实际行为是点击确认"清空"后同时执行 `onHistoryClear()` + `onBackPress()`，即清空后直接返回计算器主页面而非停留在历史页面。历史页面下次进入时才会显示空状态（因为数据已被清空）。这是一个需要关注的偏差——按 REQ 文字"清空后历史记录页面展示空状态"，期望清空后仍在历史页面看到空状态；但代码实现是清空后立即返回。
   - **Spec 处理**: 以 REQ 为准描述行为（清空后展示空状态），在偏差中标注代码实际行为。实际上代码的测试 `HistoryScreenTest.kt:93-117` 验证的是清空后列表消失并显示空状态（测试中 onBackPress 为空操作），但实际集成中 onBackPress 会返回计算器。

2. **历史记录日期格式**: REQ 描述保存"日期"，代码使用相对日期（Today/Yesterday）和 "月 日" 格式（如 "Apr 12"），为英文格式。属于实现细节，spec 以行为描述。

3. **重复计算不重复保存**: REQ 未明确说明重复按等号是否重复保存，代码通过 previousExpression 去重，同一表达式仅保存一次。

4. **恢复的计算不再保存**: REQ 描述"点击某条历史记录后恢复该记录的表达式和结果"，代码额外确保恢复后按等号不会再次保存到历史。属于合理行为，spec 保留。

## Scope / Boundary (作用范围)

- **仅作用于**:
  - 计算器主页面的历史记录入口按钮。
  - 历史记录页面（HistoryScreen）的记录展示、点击恢复、清空操作。
  - 有效计算完成后自动保存到数据库。
- **不作用于**:
  - 计算器主页面的数字输入和运算逻辑（见 Calculator-Main）。
  - 主题切换（见 Calculator-DarkMode）。
- **入口唯一性**:
  - 保存触发：仅等号键且结果有效时。
  - 查看入口：仅计算器顶部栏历史按钮。
  - 恢复入口：仅历史记录页面点击列表项。
  - 清空入口：仅历史记录页面清空按钮（经确认弹窗）。

## Same-source Cross-reference (同源交叉引用)

- 计算完成后触发历史保存 → 见 Calculator-Main trace Entry Block 5（Equals 求值）。
- 计算器顶部栏历史入口按钮 → 见 Calculator-Main trace Entry Block（CalculatorTopBar）。
- 恢复后返回的计算器主页面 → 见 Calculator-Main trace Entry Block 1。
- 历史记录也受主题影响 → 见 Calculator-DarkMode trace Entry Block 3（SiliconeCalculatorTheme 包裹全局）。
