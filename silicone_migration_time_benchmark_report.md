# SiliconeCalculator 迁移耗时与 Benchmark 建议

## 工程规模

| 指标 | 数值 |
|---|---:|
| 主应用 Kotlin/Java 代码量 | 3512 行 |
| 全工程 Kotlin/Java 代码量 | 4844 行 |
| Android UI 页面数 | 2 个 |

页面：

1. 主计算页面
2. 历史记录页面

## 各阶段耗时

| 阶段 | 耗时 | 主要做了什么 |
|---|---:|---|
| 输入准备 | 约 8 分钟 | 准备 Harmony 模板、需求文档、测试用例、任务说明 |
| `hmos-batch-ui-align` | 约 49 分钟 | 资源转换、Android 页面快照、初版 ArkTS UI、构建修复 |
| `hmos-incremental-ui-align` | 约 10 分钟 | 双端截图、view tree、UI 差异分析 |
| `hmos-spec-generate` | 约 9 分钟 | 根据 3 个需求生成 SPEC |
| `hmos-convert-pipeline` | 约 77 分钟 | 逻辑迁移、构建、代码评审、修复、自测准备 |
| 完整 self-test 重跑 | 约 28.4 分钟 | 跑 7 条 AutoTest 验收用例 |

主流程从输入准备到首轮 pipeline 报告，大约 3 小时。

## 主要耗时原因

1. **UI 迁移最慢**
   - `hmos-batch-ui-align` 花了约 49 分钟。
   - 主要时间在资源转换、页面生成、ArkTS 代码调整和构建修复。

2. **pipeline 也比较重**
   - `hmos-convert-pipeline` 花了约 77 分钟。
   - 里面包括逻辑计划、写 ArkTS、构建、代码评审、修复、再次评审。

3. **self-test 很慢**
   - 7 条用例跑了 28.4 分钟。
   - 不是因为计算器操作复杂，而是 HAP 安装后应用没有成功进入前台。
   - AutoTest 每条用例都反复尝试启动应用、截图、问模型、再判断，所以耗时被放大。

## Self-Test 结果

| 用例 | 耗时 | 结果 |
|---|---:|---|
| 完成一次加法计算 | 161.34 秒 | FAIL |
| 清除当前输入 | 273.28 秒 | FAIL |
| 完成一次乘法计算 | 164.66 秒 | FAIL |
| 切换深色模式并保持输入 | 269.34 秒 | FAIL |
| 深色模式下继续计算 | 600.02 秒 | FAIL，超时 |
| 查看历史记录并恢复计算 | 98.20 秒 | FAIL |
| 清空历史记录后展示空状态 | 137.16 秒 | FAIL |

汇总：

```text
总用例数：7
通过数：0
失败数：7
总耗时：28.4 分钟
平均每条：243 秒
```

主要失败原因：

```text
应用 com.example.calculatorharmony 无法启动。
start_app 返回 successfully，但应用没有进入前台；
点击桌面图标也没有响应。
```

## Benchmark 应该怎么测

如果把这个工程作为 benchmark case，建议不要只看最终 self-test 通过率，而是分阶段测。

### 1. 基础完成度

检查是否按流程产出这些文件：

| 检查项 | 期望 |
|---|---|
| UI 迁移产物 | 有 ArkTS 页面和资源映射 |
| UI 对齐产物 | 有截图、view tree、UI comparison |
| SPEC | 有 3 个需求规格文档 |
| Pipeline 报告 | 有 build/review/self-test 报告 |
| HAP | 能生成 `entry-default-unsigned.hap` |

### 2. 构建能力

检查 Harmony 工程是否能重新构建成功。

这是最基本的硬指标：

```text
能构建 HAP：通过
不能构建 HAP：失败
```

### 3. 启动健康检查

这次最大问题是应用无法启动，所以 benchmark 必须先加一个启动检查：

```text
安装 HAP
→ 启动 com.example.calculatorharmony
→ 等待 3-5 秒
→ 检查是否进入应用前台
```

如果启动失败，后面的 7 条 UI 用例不要继续跑，直接标记为：

```text
launch_failed
```

这样可以避免每条用例都重复浪费几分钟。

### 4. 功能验收

启动成功后再跑 7 条验收用例：

1. `1 + 2 = 3.0`
2. 输入后点击 `C` 清除
3. `4 × 5 = 20.0`
4. 切换深色模式并保持输入
5. 深色模式下继续计算
6. 查看并恢复历史记录
7. 清空历史记录后展示空状态

### 5. 耗时指标

benchmark 应记录：

| 指标 | 说明 |
|---|---|
| 总迁移耗时 | 从开始到最终报告产出 |
| 各阶段耗时 | UI 迁移、SPEC、pipeline、self-test |
| 构建耗时 | Harmony 构建时间 |
| self-test 总耗时 | 所有用例执行时间 |
| 单用例平均耗时 | 判断 AutoTest 效率 |
| 超时次数 | 判断流程稳定性 |

## 简单结论

这个 case 适合做小型迁移 benchmark：

- 代码量不大。
- 页面只有 2 个。
- 功能简单清晰。
- 但覆盖 UI、主题、历史记录、构建、自测等关键迁移环节。

需要注意的是：benchmark 必须先做“应用能否启动”的健康检查。否则像这次一样，应用启动失败会导致所有用例失败，并把 self-test 时间拉长到接近半小时。
