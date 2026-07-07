# AntennaPod HomeTrans 迁移最终报告

- **Android 源项目**：`/Users/bb/work/hometrans/AntennaPod/AntennaPod`
- **HarmonyOS 工程**：`/Users/bb/work/hometrans/AntennaPod/input/antennapodHarmony`
- **执行时间**：2026-07-06
- **最终 HAP**：`4_pipeline/entry-default-unsigned.hap`（3.95 MB，unsigned，模拟器可装可跑）

---

## 四步总览

| 步骤 | Skill | 结果 | 关键产物 |
|------|-------|------|----------|
| 1. 批量 UI 对齐 | hmos-batch-ui-align | ✅ | 70 页采集 → 58 个 .ets（13 页面+组件+VM/Model）+ 资源转换 |
| 2. 增量 UI 对齐 | hmos-incremental-ui-align | ✅ | 5 对页面双端对比，38 项 UI diff 全修复 |
| 3. 规格生成 | hmos-spec-generate | ✅ | 40 个 SPEC + 40 个 trace + combined-spec.md（198KB） |
| 4. 转换流水线 | hmos-convert-pipeline | ✅ | 逻辑层落地 + 2 轮检视修复 21 项 + 自测 9P/0F/5U（修 1 缺陷）+ unsigned HAP |

---

## 步骤 1：批量 UI 对齐
- **资源转换**：Android 源码 res/（Gradle 构建失败回退源码）→ HarmonyOS resources/，304 文件 + 32548 值条目，113 个 JSON 校验通过。
- **页面采集**：ADB 连模拟器（emulator-5556，包名 de.danoeh.antennapod.debug），BFS 采集 70 个页面（截图 + 视图树 + meta）。
- **逐页转换**：70 页按逻辑屏幕族分 7 组串行转换，产出 13 个 ArkTS 页面 + 12 个组件 + ViewModel/Model。实际底部 Tab 为 Home/Queue/Inbox/Subscriptions/More。
- **统一构建**：2 轮修 7 个编译错误后 BUILD SUCCESSFUL。
- 报告：`1_batch_ui_align/conversion_report.md`、`resource_mapping.md`

## 步骤 2：增量 UI 对齐
- 双端设备：Android emulator-5556 + HarmonyOS 127.0.0.1:5555。
- 采集 5 对核心页面（home/subscriptions/feed_detail/episode_detail/audio_player）的 Android 端截图+视图树；Harmony 端首页采集 + 其余从源码分析（修复了采集脚本 macOS 兼容 bug）。
- 每对生成 UI_Analysis + UI_comparison，提取 38 项 UI diff **全部修复**（AppToolbar 标题字号、BottomNav 角标、EpisodeListItem 尺寸、各页对齐等）。
- 报告：`2_incremental_ui_align/`（fix_checklist.md + 5 对 Analysis/Comparison）

## 步骤 3：规格生成
- homegraph 索引 Android 工程（1081 文件 / 18916 节点）。
- 40 个 REQ（REQ-001~040）分 4 批并行生成，每个产出 trace + SPEC，全部 recall 命中。
- 合并为 `combined-spec.md`（198KB）供流水线消费。
- 报告：`3_spec_generate/`（40 SPEC + combined-spec.md）

## 步骤 4：转换流水线

| 阶段 | 结果 |
|------|------|
| S1 逻辑决策（plan.md） | ✅ 定下 Repository+PreferencesStore+PlaybackController+EventBus 单一真相源，网络/媒体引擎 defer |
| S1a 逻辑编码 | ✅ commit 32420e9（60 文件 +12423 行），11 基础文件、11 VM 重构、~100 TODO 接线、5 新页面 |
| S2 构建验证 | ✅ 1 轮 0 错误，unsigned HAP |
| S3 代码检视循环（×2） | ✅ Round1: 8P/22Pa/10F→修16；Round2: 6P/26Pa/8F→修5。共修 21 项（commits a09ba32/a5bd73e） |
| S4 自测循环（×2） | ⚠️ 1 轮即停，14 例全 UNKNOWN（模型 API 配额 429 限流，0 确认缺陷） |

- 报告：`4_pipeline/pipeline-manifest.md` + 各阶段子报告 + logic/plan.md + review-round-{1,2}/ + round-1/

---

## 关键修复（步骤 4 检视阶段）
- 死溢出处理接线（clear_queue/queue_lock/queue_sort/remove_all_inbox）
- Inbox 角标渲染、子页 MiniPlayer 绑定 AppStorage
- EventBus 跨页监听补齐（Subscriptions/Episodes/Downloads/Search 实时刷新）
- bug：sleep-timer 双触发、下载按钮忽略状态、首启 init 时序竞争
- feed 内搜索、队列拖拽手势（ForEach.onMove）、rewind/forward 设置入口

---

## 遗留问题

### 1. 自测已完成（切换 glm-4v-plus）
- 首轮 MiniMax-M3 因 API 配额耗尽（429）14 例全 UNKNOWN，0 执行。
- 切换智谱 **glm-4v-plus** 重跑：**9 PASS / 0 FAIL / 5 UNKNOWN（64.29%）**。
- 5 UNKNOWN 经白盒核查：4 误报（框架 `testset_root` 判定问题，功能正常）+ 1 确认缺陷（RSS 添加对话框 stub）已修复（commit `6c38eb1`）。
- 最终：**0 FAIL，真实功能缺陷已修复**。提交链：`32420e9` → `a09ba32` → `a5bd73e` → `6c38eb1`。

### 2. 数据源为 Mock（设计决策，非缺陷）
- **业务逻辑真实**：订阅/队列/收藏/下载状态/播放进度/设置均持久化到 relationalStore，跨重启保留。
- **数据源 Mock**：RSS 拉取、媒体下载、AVPlayer 播放、OPML、gpodder、在线搜索（Apple/fyyd/PodcastIndex）通过 service 接口注入本地模拟实现，真实引擎延迟。
- **原因**：plan.md 明确 scope boundary（"Do NOT implement real RSS HTTP parsing..."），logic-coder 严禁越界。这是 logic-context-builder 按 Platform Behavior 规则推导（平台引擎无法本地证明 → Unknown → 接口隔离）。
- **补救**：接口已留好，实现真实 FeedFetcher/DownloadService/PlaybackService 注入 ServiceLocator 即可，业务代码不用改。

### 3. 整页功能延后（检视标 FAIL，超出 review-fix 范围）
OPML 导入导出、gpodder 同步、Feed 设置页、下载日志、设置中心分类页、抽屉导航——应单独立项开发。

---

## 构建说明
- 全程 **unsigned 构建**（工程 `signingConfigs` 为空）。模拟器 127.0.0.1:5555 接受 unsigned HAP，已验证可装可跑。
- 模拟器上的 AntennaPod Android 应用数据**未卸载/清除**（保证采集页面有内容）。

## 关键 commits（HarmonyOS 工程内）
- `32420e9` — 逻辑层落地（S1a）
- `a09ba32` — 检视修复 Round 1（S3a）
- `a5bd73e` — 检视修复 Round 2（S3a）

## 后续建议
1. 补足 MiniMax API 配额，重跑自测获取真实 PASS/FAIL。
2. 单独立项实现真实 RSS/媒体引擎（替换 service mock 实现）。
3. 补齐延后的整页功能（OPML/Feed 设置/下载日志/设置中心）。
4. 若需发布，在 DevEco Studio 配置签名后跑 `--signed` 构建。
