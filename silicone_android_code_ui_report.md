# SiliconeCalculator Android 代码量与页面数报告

## 统计范围

- 工程路径：`/Users/bb/work/hometrans/SiliconeCalculator`
- 代码量只统计 Kotlin/Java 文件：`*.kt`、`*.java`
- 排除目录：`build/`、`.gradle/`
- UI 页面数按 Android 主应用中 `NavHost` 注册的可导航页面统计

## Kotlin/Java 代码量

| 范围 | 文件数 | 行数 |
|---|---:|---:|
| 主应用源码：`app/src/main/java` | 44 | 3512 |
| 测试源码：`app/src/test` + `app/src/androidTest` | 11 | 1119 |
| benchmark 模块 | 4 | 211 |
| buildSrc | 1 | 22 |
| 全工程 Kotlin/Java 合计 | 60 | 4844 |

## UI 页面个数

Android 主应用共有 2 个可导航 UI 页面：

| 页面 | 对应文件 | 说明 |
|---|---|---|
| 主计算页面 | `app/src/main/java/ir/erfansn/siliconecalculator/calculator/CalculatorScreen.kt` | 计算器主界面，包含数字、运算符、结果展示、主题切换入口、历史入口 |
| 历史记录页面 | `app/src/main/java/ir/erfansn/siliconecalculator/history/HistoryScreen.kt` | 展示计算历史，支持查看历史记录 |

页面路由定义在：

- `app/src/main/java/ir/erfansn/siliconecalculator/navigation/SiliconeCalculatorNavHost.kt`
- `app/src/main/java/ir/erfansn/siliconecalculator/navigation/AppNavigationActions.kt`

## 结论

- 主应用 Kotlin/Java 代码量：3512 行
- 全工程 Kotlin/Java 代码量：4844 行
- Android UI 页面数：2 个
