# Trace — Calculator-DarkMode

## Status

DONE — 所有 entry 块均已通过源码 file:line 核实，无臆造。

## REQ 原文摘要

> 应用支持深色模式和浅色模式切换。用户在主计算页面点击主题切换入口后，页面在深色和浅色视觉样式之间切换。切换主题时，不应丢失当前正在输入的数字、已有表达式、计算结果或历史记录。

## Recalled Entry Points (通过 GitNexus query + context 定位)

- `SiliconeCalculatorActivity.onCreate` — 应用入口，持有 darkTheme 状态, `SiliconeCalculatorActivity.kt:49`
- `CalculatorTopBar` — 主题切换按钮 UI 宿主, `CalculatorScreen.kt:123`
- `SiliconeCalculatorNavHost` — 接收 `onThemeToggle` 回调并传递给 CalculatorScreen, `SiliconeCalculatorNavHost.kt:41`
- `SiliconeCalculatorTheme` — 主题切换实现（深色/浅色配色）, `Theme.kt:50`
- `CircularReveal` — 主题切换圆形揭示动画, `CircularRevealAnimation.kt:68`
- `DarkColorPalette` / `LightColorPalette` — 深色/浅色配色定义, `Theme.kt:25-47`

---

## Entry Block 1: 主题状态持有与初始值

### Claim

主题状态（深色/浅色）在应用入口持有，初始值跟随系统当前深浅色设置；状态不持久化（仅内存）。

### Layers

- **状态层**: `SiliconeCalculatorActivity.kt:53-54` —
  ```
  val isSystemDark = isSystemInDarkTheme()
  var darkTheme by remember { mutableStateOf(isSystemDark) }
  ```
  初始值 = 系统当前深色模式状态。
- **无持久化**: darkTheme 使用 `remember { mutableStateOf(...) }`，未写入任何持久化存储（无 SharedPreferences/DataStore）。应用重启后重新跟随系统设置。

### Interaction

- 应用启动 → 读取系统深色模式 → darkTheme 初始值 = 系统值。
- 后续用户手动切换覆盖该初始值（见 Entry Block 3）。

### Data Flow

系统深色模式 → isSystemInDarkTheme() → darkTheme(初始) → SiliconeCalculatorTheme → 配色。

---

## Entry Block 2: 主题切换入口 — 按钮 UI

### Claim

计算器主页面顶部栏左侧有主题切换按钮；按钮图标随当前主题变化（深色模式显示"切换到浅色"图标，浅色模式显示"切换到深色"图标）。

### Layers

- **UI 层**: `CalculatorScreen.kt:136-141` — `CalculatorTopBar` 中的 `CorneredFlatIconButton`：
  ```
  onClick = onThemeToggle,
  icon = if (!MaterialTheme.colors.isLight) Icons.Outlined.LightMode else Icons.Outlined.DarkMode,
  contentDescription = stringResource(R.string.theme_changer)
  ```
  - 当前为深色（!isLight）→ 显示 LightMode 图标（提示可切到浅色）。
  - 当前为浅色（isLight）→ 显示 DarkMode 图标（提示可切到深色）。
- **回调链**: `onThemeToggle` 由 `SiliconeCalculatorNavHost` 参数传入（`SiliconeCalculatorNavHost.kt:46`），最终指向 `SiliconeCalculatorActivity.kt:83-85`：
  ```
  onThemeToggle = { darkTheme = !darkTheme }
  ```

### Interaction

- 点击主题切换按钮 → `darkTheme = !darkTheme`（取反切换）。

### Data Flow

按钮点击 → onThemeToggle() → darkTheme 翻转 → 触发重组 → CircularReveal 动画 + 配色切换。

---

## Entry Block 3: 主题切换逻辑 — 翻转与配色应用

### Claim

点击切换按钮后，darkTheme 翻转；整页配色在深色配色（DarkColorPalette）和浅色配色（LightColorPalette）之间切换；切换过程伴随圆形揭示动画。

### Layers

- **切换**: `SiliconeCalculatorActivity.kt:83-85` — `darkTheme = !darkTheme`。
- **配色切换**: `Theme.kt:49-64` — `SiliconeCalculatorTheme(darkTheme)`:
  ```
  val colors = if (darkTheme) DarkColorPalette else LightColorPalette
  MaterialTheme(colors = colors, ...)
  ```
- **深色配色**: `Theme.kt:25-35` — DarkColorPalette：background=BlueGrey900（深灰蓝）, surface=BlueGrey600, secondary=DeepOrange800（深橙）。
- **浅色配色**: `Theme.kt:37-47` — LightColorPalette：background=BlueGrey50（浅灰蓝）, surface=BlueGrey100, secondary=DeepOrange900（深橙）。

### Interaction

- darkTheme=true → DarkColorPalette → 页面深色背景 + 深橙运算符按钮。
- darkTheme=false → LightColorPalette → 页面浅色背景 + 深橙运算符按钮。

---

## Entry Block 4: 切换动画 — 圆形揭示（CircularReveal）

### Claim

主题切换时，新主题以圆形揭示动画从点击位置展开覆盖旧主题，动画持续约 0.5 秒。

### Layers

- **动画宿主**: `SiliconeCalculatorActivity.kt:72-89` —
  ```
  CircularReveal(
      expanded = darkTheme,
      animationSpec = tween(500)
  ) { isDark ->
      SiliconeCalculatorTheme(darkTheme = isDark) { ... }
  }
  ```
  - `expanded = darkTheme`：true 时揭示深色主题，false 时揭示浅色主题。
  - `animationSpec = tween(500)`：动画持续 500 毫秒。
- **揭示原点**: `CircularRevealAnimation.kt:133-138` — 记录最后一次触摸位置（MotionEvent.ACTION_DOWN 时的 offset），动画从该点展开。若无触摸记录则从屏幕中心展开（`CircularRevealAnimation.kt:167`）。
- **揭示形状**: `CircularRevealAnimation.kt:156-187` — CircularRevealShape：以 offset 为圆心，半径从 0 扩展到最远角落距离 × progress。

### Interaction

- 用户点击主题按钮 → 记录触摸坐标 → darkTheme 翻转 → CircularReveal 从触摸点展开新主题配色 → 动画结束 → 新主题完全覆盖。

### Data Flow

点击坐标(offset) → CircularReveal(progress 0→1) → 新主题配色逐渐揭示。

---

## Entry Block 5: 切换主题时计算状态保持

### Claim

切换主题不会丢失当前正在输入的数字、已有表达式、计算结果或历史记录，因为主题状态（darkTheme）与计算状态（Calculation）完全解耦。

### Layers

- **解耦证据 1**: darkTheme 在 `SiliconeCalculatorActivity.onCreate` 中持有（`SiliconeCalculatorActivity.kt:54`），使用 `remember`。
- **解耦证据 2**: 计算状态在 `CalculatorViewModel` 中持有（`CalculatorViewModel.kt:55` — `_calculation = MutableStateFlow(Calculation())`），生命周期独立于主题状态。
- **解耦证据 3**: 历史记录在 `HistoryRepository` → 数据库中持久化（`HistoryRepositoryImpl.kt:31` — `historyDao.getHistoryEntitiesStream()`），与主题完全无关。
- **重组行为**: 主题切换仅触发配色重组，不触发 CalculatorViewModel 重建（ViewModel 绑定到 NavBackStackEntry，主题切换不改变导航栈）。

### Interaction

- 用户正在输入表达式 "12 + 3" → 点击主题切换 → 动画播放 → 深浅配色切换 → 表达式 "12 + 3" 和结果保持不变。
- 用户有历史记录 → 点击主题切换 → 历史记录不丢失。

### Data Flow

darkTheme 翻转 → 仅 MaterialTheme.colors 变化 → 页面重组渲染新配色；_calculation MutableStateFlow 不受影响 → 计算/历史数据保持。

---

## Entry Block 6: 系统状态栏样式跟随主题

### Claim

切换主题时，系统状态栏和导航栏的样式也跟随主题切换（透明背景，但深色/浅色图标自动适配）。

### Layers

- **状态栏**: `SiliconeCalculatorActivity.kt:55-69` — `DisposableEffect(darkTheme)`：
  ```
  val transparentStyle = SystemBarStyle.auto(
      lightScrim = Color.TRANSPARENT,
      darkScrim = Color.TRANSPARENT,
      detectDarkMode = { darkTheme }
  )
  enableEdgeToEdge(navigationBarStyle = transparentStyle, statusBarStyle = transparentStyle)
  ```
  `detectDarkMode = { darkTheme }`：状态栏根据 darkTheme 选择深色/浅色图标。`DisposableEffect(darkTheme)` 确保主题变化时重新应用。

---

## Implicit Triggers (隐式触发)

- **应用首次启动** → 主题初始值跟随系统深浅色设置（非用户手动选择）。
- **主题切换按钮点击** → darkTheme 翻转 + 圆形揭示动画 + 状态栏更新。

## Core Business Entities (核心业务实体)

| 实体 | 定义位置 | 说明 |
|---|---|---|
| darkTheme (Boolean) | `SiliconeCalculatorActivity.kt:54` | 主题状态：true=深色，false=浅色 |
| DarkColorPalette | `Theme.kt:25-35` | 深色配色方案 |
| LightColorPalette | `Theme.kt:37-47` | 浅色配色方案 |
| CircularReveal | `CircularRevealAnimation.kt:68` | 圆形揭示动画组件 |

## Cross-Entry Shared Declarations (跨入口共享)

- `SiliconeCalculatorTheme`（`Theme.kt:50`）— 被所有页面（CalculatorScreen、HistoryScreen）共享使用，主题切换影响所有页面配色。
- `MaterialTheme.colors` — 各 UI 组件（NeuButton、Text、Surface 等）均引用当前主题配色。

## Deviations (偏差)

无显著偏差。REQ 要求"切换主题时不应丢失当前输入、表达式、计算结果或历史记录"，代码实现中主题状态与数据状态完全解耦，满足要求。

补充说明（非偏差）：
1. **主题不持久化**: 代码中 darkTheme 仅存在于内存（remember），应用重启后重新跟随系统设置。REQ 未要求持久化主题偏好，以代码行为为准。
2. **圆形揭示动画**: REQ 未提及切换动画效果，代码实现了从点击位置展开的圆形揭示动画，属于视觉增强。
3. **历史记录页面也跟随主题**: REQ 仅提及"主计算页面"切换，但 SiliconeCalculatorTheme 包裹整个导航，历史记录页面也受主题影响。

## Scope / Boundary (作用范围)

- **仅作用于**: 主题切换按钮（计算器主页面顶部栏），以及由此触发的全局配色切换。
- **不作用于**: 计算逻辑、历史记录数据、数字输入 — 这些在主题切换时保持不变。
- **入口唯一性**: 主题切换入口仅在计算器主页面顶部栏，历史记录页面无主题切换按钮。

## Same-source Cross-reference (同源交叉引用)

- 主题切换按钮与历史入口按钮并列于 `CalculatorTopBar`（`CalculatorScreen.kt:123-148`）→ 见 Calculator-Main trace / Calculator-History trace。
- 切换主题时 CalculatorViewModel 不受影响 → 见 Calculator-Main trace Entry Block 1。
- 切换主题时历史记录不受影响 → 见 Calculator-History trace。
