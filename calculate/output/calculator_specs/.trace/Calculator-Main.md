# Trace — Calculator-Main

## Status

DONE — 所有 entry 块均已通过源码 file:line 核实，无臆造。

## REQ 原文摘要

> 主计算页面用于完成基础计算器操作。用户打开应用后默认进入计算器主页面，页面展示当前输入或计算结果，初始结果为 0。用户可以点击数字键 0-9、四则运算符 +、-、×、÷ 和等号完成表达式计算；点击小数点输入小数；点击 C 删除当前输入，点击 AC 清空表达式和结果。完成有效计算后，表达式和结果需要在页面上正确展示。

## Recalled Entry Points (通过 GitNexus query + context 定位)

- `CalculatorScreen` — UI 宿主, `CalculatorScreen.kt:97`
- `CalculatorTopBar` — 顶部栏 (主题切换 + 历史入口), `CalculatorScreen.kt:123`
- `CalculatorContent` — 显示区 + 按键区, `CalculatorScreen.kt:151`
- `Display` — 表达式与结果显示, `CalculatorScreen.kt:186`
- `KeyLayout` — 按键网格, `CalculatorScreen.kt:239`
- `CalculatorViewModel.performCalculatorButton` — 按键分发入口, `CalculatorViewModel.kt:100`
- `CalculatorButton.perform` 抽象方法及其各子类实现
- `Evaluator.eval` — 表达式求值, `Evaluator.kt:35`
- `formatNumbers` — 数字千分位格式化, `MathExpressionFormatter.kt:24`
- `SiliconeCalculatorNavHost` — 默认起始页为 calculator, `SiliconeCalculatorNavHost.kt:48` (startDestination = CALCULATOR_ROUTE)

---

## Entry Block 1: 应用启动 / 进入计算器主页面

### Claim

用户打开应用后默认进入计算器主页面；初始状态表达式为空、结果为 0。

### Layers

- **UI 层**: `SiliconeCalculatorNavHost.kt:48` — startDestination = CALCULATOR_ROUTE，应用启动后默认显示计算器页面。
- **状态层**: `CalculatorViewModel.kt:55` — `_calculation = MutableStateFlow(Calculation())`；`History.kt:28-30` — `Calculation(expression = "", result = "0")` 为默认值。
- **状态映射**: `CalculatorViewModel.kt:63-69` — `uiState` 由 `_calculation` 映射为 `CalculatorUiState`，初始值 `CalculatorUiState()`（即 expression=""、result="0"）。

### Interaction

- 启动 → NavHost 以 CALCULATOR_ROUTE 为起始目的地 → 渲染 `CalculatorScreen`。
- `CalculatorScreen.kt:114-119` — `CalculatorContent` 接收 `uiState.calculation.expression`（""）和 `uiState.calculation.result`（"0"）。

### Data Flow

初始 Calculation(expression="", result="0") → MutableStateFlow → uiState(CalculatorUiState) → Display 显示。

---

## Entry Block 2: 显示区 — 表达式与结果展示

### Claim

页面展示当前表达式（上方，较小字号、半透明）和当前结果（下方，较大字号、可选中），数字自动添加千分位逗号。

### Layers

- **UI 层**: `CalculatorScreen.kt:186-237` — `Display`：上方表达式 Text（testTag="calculator:expression"），下方结果 Text（testTag="calculator:result"，外包 SelectionContainer 可选中复制）。
- **格式化**: `CalculatorScreen.kt:208` — 表达式文本经 `mathExpression.formatNumbers()`；`CalculatorScreen.kt:229` — 结果文本经 `evaluationResult.formatNumbers()`。
- **格式化逻辑**: `MathExpressionFormatter.kt:24-31` — `formatNumbers()` 对整数部分每三位用逗号分隔（如 "4900" → "4,900"）。

### Interaction

- 表达式区水平可滚动（`horizontalScroll`, reverseScrolling=true），按钮点击后自动滚动定位（`CalculatorScreen.kt:167-183`）。
- 结果区水平可滚动、可文本选中。

### Data Flow

uiState.calculation.expression/result → formatNumbers() → 显示文本。

---

## Entry Block 3: 数字键 0-9 输入

### Claim

点击数字键追加数字到当前结果；当结果为 "0" 时输入新数字替换 "0"（不产生前导零）；重复输入 0 时结果保持 "0"。

### Layers

- **UI 层**: `CalculatorScreen.kt:260-292` — 遍历 `calculatorButtons`，每个按钮渲染为 NeuButton，onClick 调用 `onButtonClick(button)` → `onCalculatorButtonClick(button)`。
- **分发层**: `CalculatorViewModel.kt:100-112` — `performCalculatorButton` 先执行守卫判断（见 Entry Block 10），通过后异步执行 `calculatorButton.perform(it)`。
- **按钮逻辑**: `Digit.kt:22-30` — `Digit(digit: Char)`：
  - `applier = { n -> "$n$digit" }`（追加）
  - `perform`: `val amendedResult = calculation.result.takeUnless { it == "0" }.orEmpty()` — 若 result 为 "0" 则清空后再追加（替换前导零），否则直接追加。
- **布局**: `CalculatorButton.kt:86` — `Digit('0')` 在网格中占两列宽（`NumberPadState.widthRatio`, `CalculatorScreen.kt:351-352`）。

### Interaction

- 点击数字 0-9 → performCalculatorButton → Digit.perform → 更新 result。

### Data Flow

result="0" → 输入 '1' → amendedResult="" + "1" = "1" → result="1"。
result="12" → 输入 '0' → amendedResult="12" + "0" = "120" → result="120"。
result="0" → 输入 '0' → amendedResult="" + "0" = "0" → result="0"（测试确认：`CalculatorViewModelTest.kt:72-82`）。

---

## Entry Block 4: 四则运算符 + - × ÷

### Claim

点击运算符将当前结果追加到表达式并附加运算符，结果区清零；初始状态下（表达式空且结果为0）点击运算符无反应；连续点击运算符时替换最后一个运算符。

### Layers

- **UI 层**: `CalculatorScreen.kt:260-292` — 同数字键，按钮 onClick 分发。
- **分发层**: `CalculatorViewModel.kt:100-112` — 守卫 + 异步执行 perform。
- **按钮逻辑**: `CalculatorButton.kt:51-67` — `OperatorButton.perform`：
  - 守卫: `if (calculation.expression.isEmpty() && calculation.result == "0") return calculation`（初始状态不响应）。
  - 若 result=="0"：`amendedExpression = expression.substringBeforeLast(lastOperator)`（替换末尾运算符）。
  - 若 expression 已以 lastOperator 结尾：`amendedExpression = expression.plus(result)`。
  - 否则：`amendedExpression = result`。
  - 返回 `expression = applier(amendedExpression)`（即 "$n $symbol "，如 "1 + "），`result = "0"`。
- **运算符符号**: Add="+", Sub="-", Mul="×", Div="÷"。

### Interaction

- result="12" → 点击 "+" → expression="12 + ", result="0"（测试：`CalculatorViewModelTest.kt:169-178`）。
- result="0", expression="1 + " → 点击 "×" → amendedExpression="1", expression="1 × "（替换运算符，测试：`CalculatorViewModelTest.kt:181-193`）。
- 初始状态 result="0", expression="" → 点击任意运算符 → 无变化（测试：`CalculatorViewModelTest.kt:153-166`）。

### Data Flow

result + operator → OperatorButton.perform → expression 追加运算符、result 归零。

---

## Entry Block 5: 等号 = — 表达式求值

### Claim

点击等号对完整表达式求值，显示最终表达式和计算结果；表达式不完整时不求值；重复点击等号不会重复求值。

### Layers

- **UI 层**: `CalculatorScreen.kt:260-292` — 同上。
- **分发层**: `CalculatorViewModel.kt:100-112` — perform + 若为 Equals 则调用 `saveCalculationInHistory`（见 Calculator-History trace）。
- **按钮逻辑**: `Equals.kt:22-37` — `Equals.perform`：
  - 守卫: `if (!calculation.isComplete) return calculation`（表达式不完整不求值）。
  - 若 result=="0"：`amendedExpression = expression.substringBeforeLast(lastOperator)`（去掉末尾悬空运算符）。
  - 否则：`amendedExpression = expression.plus(result)`（拼上当前操作数）。
  - `evaluator.expression = applier(amendedExpression)`（applier 为恒等 `{ it }`）。
  - 返回 `expression = evaluator.expression, result = evaluator.eval()`。
- **完整判断**: `History.kt:32-33` — `isComplete = expression.isNotEmpty() && ((result != "0" || operators.count() > 1) && expression.endsWith(lastOperator))`。
- **求值**: `Evaluator.kt:35-41` — `eval()`: 调用 mxparser Expression.calculate()；有限值转为 BigDecimal.toPlainString()；无限值返回 toString()（"Infinity"/"NaN"）。

### Interaction

- "1 + 2" → "=" → expression="1 + 2", result="3.0"（测试：`CalculatorViewModelTest.kt:211-224`）。
- "1 ÷ "（不完整）→ "=" → 无变化（测试：`CalculatorViewModelTest.kt:196-208`）。
- 求值后再次按 "=" → 无变化（测试：`CalculatorViewModelTest.kt:227-241`）。

### Data Flow

expression + result → Equals.perform → evaluator → expression=完整表达式, result=计算结果。

---

## Entry Block 6: 小数点 .

### Claim

点击小数点在结果末尾追加小数点；若结果中已含小数点则不再追加。

### Layers

- **分发层**: `CalculatorViewModel.kt:100-112` — 守卫 + perform。
- **按钮逻辑**: `Decimal.kt:22-30` — `Decimal.perform`：
  - 守卫: `if (symbol in calculation.result) return calculation`（已有小数点则忽略）。
  - 否则 `result = applier(calculation.result)` 即 `"$n$symbol"`（追加 "."）。
- **注意**: 当 result="0" 时，Decimal.perform 不受 Digit 的前导零替换影响，直接追加 → result="0."（测试：`CalculatorViewModelTest.kt:99-109`）。

### Interaction

- result="0" → "." → result="0." → "0" → "0." → result="0.0"。
- result="0." → "." → 无变化（已有小数点）。

---

## Entry Block 7: Clear（C）— 删除当前输入

### Claim

点击 C 删除结果末尾一位；删除至空或仅剩负号时归零为 "0"；当结果删至 "0" 但表达式仍有内容时，将表达式最后一个操作数移到结果区。

### Layers

- **分发层**: `CalculatorViewModel.kt:100-112`。
- **按钮逻辑**: `Clear.kt:23-46` — `Clear.perform`：
  - `applier`：截掉末尾一位，若结果为空或仅 "-" 则归零 "0"（`Clear.kt:25-32`）。
  - `perform`：若 expression 为空 或 applier(result) != "0"，则 `expression 不变, result = applier(result)`（正常删一位）。
  - 否则（applier(result) == "0" 且 expression 非空）：`expression = expression.substringBeforeLast(lastNumber)`, `result = lastNumber`（把表达式最后一个操作数回退到结果）。
  - `lastNumber` = 表达式中最后一个匹配 DECIMAL_REGEX 的数字（`Clear.kt:48-49`）。

### Interaction

- result="1234" → "C" → result="123"（测试：`ClearTest.kt:26-34`）。
- result="-1" → "C" → result="0"（归零，测试：`ClearTest.kt:37-45`）。
- expression="12 + -23 -", result="-1" → "C" → expression="12 + ", result="-23"（回退操作数，测试：`ClearTest.kt:48-57`）。

### 额外入口: 长按 C 触发 AllClear

- `CalculatorScreen.kt:274-279` — `onLongClick`: 若 `button == Clear`，执行 `onButtonClick(AllClear)` 并触发触觉反馈。

---

## Entry Block 8: AllClear（AC）— 清空全部

### Claim

点击 AC 清空表达式（置空）并将结果归零为 "0"。

### Layers

- **分发层**: `CalculatorViewModel.kt:100-112`。
- **按钮逻辑**: `AllClear.kt:22-31` — `AllClear.perform`：
  - `expression = ""`, `result = "0"`。

### Interaction

- 任意状态 → "AC" → expression="", result="0"。

---

## Entry Block 9: 按键布局动态切换（Clear ↔ AllClear）

### Claim

计算完成（表达式已求值）或结果无效时，按键区第一个键从 C 切换为 AC；否则为 C。

### Layers

- **状态监听**: `CalculatorViewModel.kt:77-87` — 监听 `_calculation` 变化：
  - `if (!calculation.isNotEvaluated || calculation.resultIsInvalid)` → `calculatorButtonsInOrderAllClear`（首键为 AllClear）。
  - 否则 → `calculatorButtonsInOrderClear`（首键为 Clear）。
- **判断逻辑**: `CalculatorViewModel.kt:122-123` — `isNotEvaluated = expression.endsWith(lastOperator) || expression.isEmpty()`。
- **无效判断**: `History.kt:35-36` — `resultIsInvalid = result.matches("-?Infinity|NaN")`。
- **布局定义**: `CalculatorButton.kt:69-94` — `calculatorButtonsInOrderClear`（首元素 Clear）；`calculatorButtonsInOrderAllClear`（将首元素替换为 AllClear）。

### Interaction

- 未求值时 → 按键含 C（测试：`CalculatorViewModelTest.kt:378-388`）。
- 求值后 → 按键含 AC（测试：`CalculatorViewModelTest.kt:363-374`）。

---

## Entry Block 10: 按键守卫逻辑 — 无效结果锁定

### Claim

当计算结果为 Infinity 或 NaN（无效）时，除 AC 外所有按键均不响应；求值完成后，数字键、小数点、正负号、百分号不响应（需先按运算符或 AC 继续）。

### Layers

- **守卫 1**: `CalculatorViewModel.kt:101` — `if (currentCalculation.resultIsInvalid && calculatorButton != AllClear) return false`（无效结果锁定，仅 AC 可用）。
- **守卫 2**: `CalculatorViewModel.kt:102` — `if (!currentCalculation.isNotEvaluated && (calculatorButton is Digit || calculatorButton in listOf(Decimal, NumSign, Percent))) return false`（求值后锁定数字/小数点/正负号/百分号）。
- **返回值**: `performCalculatorButton` 返回 Boolean，UI 层据此决定是否执行滚动动画（`CalculatorScreen.kt:169-170`）。

### Interaction

- 无效结果（如 999...9 + 1 = Infinity）→ 按任意键（除 AC）无反应 → 按 AC → 归零（测试：`CalculatorViewModelTest.kt:303-323`）。
- 求值后 "1 + 2 = 3.0" → 按数字/小数点/正负号/百分号 → 无变化（测试：`CalculatorViewModelTest.kt:244-262`）。

---

## Entry Block 11: 求值后按运算符 — 结果带入新表达式

### Claim

求值完成后点击运算符，将上次结果作为新表达式的起始操作数。

### Layers

- **按钮逻辑**: `CalculatorButton.kt:51-67` — OperatorButton.perform：`else -> amendedExpression = calculation.result`（求值后 expression 不以运算符结尾且 result != "0"，走 else 分支，将 result 作为新表达式起点）。

### Interaction

- "1 + 2 = 3.0" → "-" → expression="3.0 - ", result="0"（测试：`CalculatorViewModelTest.kt:286-300`）。

---

## Entry Block 12: 正负号 ± 与百分号 %（代码中存在但 REQ 未提及）

### Claim

代码中还存在正负号切换（±）和百分号（%）功能，REQ 未提及但 UI 中有对应按键。

### Layers

- **NumSign**: `NumSign.kt:21-23` — FunctionButton("±")，`applier = { n -> "-$n" }`；继承 `FunctionButton.perform`（`CalculatorButton.kt:41-47`）：若 result=="0" 不变；否则 `evaluator.expression = "-$result"`，`result = evaluator.eval()`（取负）。
- **Percent**: `Percent.kt:21-23` — FunctionButton("%")，`applier = { n -> "$n%" }`；继承 `FunctionButton.perform`：`evaluator.expression = "$result%"`，`result = evaluator.eval()`（即 result/100）。

### Deviation

REQ 仅提及数字 0-9、四则运算符、等号、小数点、C、AC。代码中额外有正负号（±）和百分号（%）按键。本 spec 覆盖 REQ 要求项；± 和 % 属于代码存在但 REQ 未要求的功能，在偏差中标注。

---

## Implicit Triggers (隐式触发)

- **应用启动** → 默认进入计算器主页（NavHost startDestination）。
- **长按 C** → 触发 AllClear（非 REQ 明确要求，但代码实现，归入 C 的扩展行为）。

## Core Business Entities (核心业务实体)

| 实体 | 定义位置 | 说明 |
|---|---|---|
| Calculation | `History.kt:28-43` | 表达式 + 结果，含 isComplete/resultIsInvalid/lastOperator 计算属性 |
| CalculatorButton (抽象) | `CalculatorButton.kt:33-36` | 按键基类，symbol + perform |
| Digit | `Digit.kt:22` | 数字键，0-9 |
| Decimal | `Decimal.kt:22` | 小数点 |
| Clear | `Clear.kt:23` | 删除一位 |
| AllClear | `AllClear.kt:22` | 全部清空 |
| Add/Sub/Mul/Div | `operator/*.kt` | 四则运算符 |
| Equals | `Equals.kt:22` | 等号求值 |
| Evaluator | `Evaluator.kt:22` | 表达式求值引擎（mxparser） |

## Cross-Entry Shared Declarations (跨入口共享)

- `calculatorButtonsInOrderClear` / `calculatorButtonsInOrderAllClear`（`CalculatorButton.kt:69-94`）— 按键顺序定义，被 ViewModel 动态切换。
- `OPERATORS_REGEX` / `DECIMAL_REGEX`（`MathExpressionFormatter.kt:19-20`）— 运算符与数字正则，被 Calculation/Clear 共享。
- `formatNumbers()`（`MathExpressionFormatter.kt:24`）— 千分位格式化，被 Display 和 History 共享。

## Deviations (偏差)

1. **正负号 ± 与百分号 %**: REQ 未提及，代码中存在按键与逻辑。Spec 以 REQ 为准覆盖基础运算；± 和 % 作为代码附加功能标注。
2. **长按 C 触发 AC**: REQ 仅描述 "点击 C 删除当前输入，点击 AC 清空"，代码额外实现了长按 C 触发 AC 的快捷操作。
3. **千分位逗号格式化**: REQ 未明确要求，代码对显示数字自动添加千分位逗号（如 4,900）。属于显示增强，spec 保留为展示行为。
4. **结果为小数**: 求值结果默认带小数（如 "3.0"），REQ 未明确，以代码实际行为为准。

## Scope / Boundary (作用范围)

- **仅作用于**: 计算器主页面（CalculatorScreen）的按键交互与显示区。
- **不作用于**: 历史记录页面（HistoryScreen）、主题切换（Theme toggle）— 这些有独立入口。
- **入口唯一性**: 计算器主页是应用启动默认页，也是从历史记录恢复后返回的目标页。

## Same-source Cross-reference (同源交叉引用)

- 求值后触发历史保存 → 见 Calculator-History trace Entry Block 1（saveCalculationInHistory）。
- 计算器顶部栏含历史入口按钮 → 见 Calculator-History trace Entry Block 2。
- 计算器顶部栏含主题切换按钮 → 见 Calculator-DarkMode trace。
