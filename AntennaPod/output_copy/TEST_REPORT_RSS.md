# AntennaPod HarmonyOS 测试统计报告（含 RSS 数据拉取问题分析）

- 测试时间：2026-07-07
- 测试模型：glm-4v-plus（智谱视觉模型，走 AutoTest single 模式）
- 测试设备：HarmonyOS 模拟器 127.0.0.1:5555
- 被测 HAP：entry-default-unsigned.hap（commit 6c38eb1）

---

## 一、总体统计

| 指标 | 值 |
|------|----|
| 总用例数 | 14 |
| ✅ 通过 (PASS) | 9 |
| ❌ 失败 (FAIL) | 0 |
| ❓ 未知 (UNKNOWN) | 5 |
| 通过率 | 64.29% |

**关键结论：0 FAIL**——没有用例判定应用存在真实功能错误。但部分 PASS 是"假通过"（见下文 RSS 专项），UNKNOWN 中有因数据源 mock 导致的（RSS feed 添加）。

---

## 二、用例结果明细

| # | 用例 | 结果 | RSS 相关 | 说明 |
|---|------|------|----------|------|
| 1 | 首次启动和底部导航 | ❓ UNKNOWN | | 模型输出随机性，单跑曾 PASS |
| 2 | More 菜单进入 Settings | ✅ PASS | | |
| 3 | 打开 Add podcast 页面 | ✅ PASS | ⚠️ | 仅验证页面打开，不涉及拉取 |
| 4 | 推荐播客预览并订阅 | ✅ PASS | ⚠️ **假 PASS** | 订阅的是 mock 预置播客，非真实 RSS（见专项） |
| 5 | RSS feed 添加播客 | ❓ UNKNOWN | 🚨 **数据源问题** | 输入真实 RSS URL → mock 返回 undefined → 订阅失败 |
| 6 | Subscriptions 进入播客详情 | ✅ PASS | | |
| 7 | 单集详情和播放页 | ✅ PASS | | 播放为模拟（无真实音频） |
| 8 | 下载或加入队列后 Queue 有数据 | ✅ PASS | | 下载为模拟（无真实文件） |
| 9 | Queue 多单集排序和清空 | ❓ UNKNOWN | | 模型多步操作判定不到 |
| 10 | Episodes 和 Inbox | ❓ UNKNOWN | | 同上 |
| 11 | 收藏和播放历史 | ✅ PASS | | |
| 12 | Downloads 和 Download Log | ✅ PASS | | 下载状态机正常，无真实下载 |
| 13 | 搜索和播客内搜索 | ✅ PASS | | 本地 DB 搜索，真实 |
| 14 | 设置、OPML 和数据持久化 | ❓ UNKNOWN | 🚨 | OPML 为延后 stub |

---

## 三、🚨 RSS 数据拉取问题专项分析

### 3.1 问题现象

播客订阅功能表面能用，但**数据来源是假的**——没有任何真实 RSS 网络拉取：

| 场景 | 表现 | 真相 |
|------|------|------|
| 订阅推荐播客 | ✅ 能订阅，单集列表显示 | 返回的是硬编码 mock 数据，不是从 RSS 拉取 |
| 输入预置 RSS URL 订阅 | ✅ 能订阅（如 `morbid.libsyn.com/rss`） | URL 命中预置白名单，返回对应 mock 数据 |
| **输入任意真实 RSS URL 订阅** | ❌ **订阅失败** | URL 不在预置白名单 → 返回 undefined |

### 3.2 根因：FeedFetcher 是 mock 实现

**代码证据**（`common/service/SampleFeedFetcher.ets`）：

```typescript
async fetchByUrl(url: string): Promise<FetchResult | undefined> {
    const feeds: SampleFeed[] = SampleData.feeds();   // ← 读硬编码预置列表
    for (let i = 0; i < feeds.length; i++) {
      if (f.feedUrl === url) {                         // ← 仅字符串精确匹配
        return this.toFetchResult(f);                  // ← 返回 mock 数据
      }
    }
    return undefined;                                   // ← 未知 URL 直接失败
}
```

**问题点**：
- ❌ **不发起任何 HTTP 请求**（全工程 0 处 `@kit.NetworkKit` / `http` 调用）
- ❌ **不解析 RSS XML**（无 XML parser）
- ❌ 只在 6 个预置 feedUrl 里精确匹配（`morbid.libsyn.com/rss`、`crimejunkie`、`goodhang`、`thisamericanlife`、`megynkelly`、`daily` 等）
- ❌ 任意其它真实播客 RSS URL → `undefined` → 订阅失败

### 3.3 预置白名单（仅这些 URL 能"订阅成功"）

```
https://morbid.libsyn.com/rss
https://feeds.megaphone.fm/crimejunkie
https://feeds.example.com/goodhang      ← 假 URL
https://www.thisamericanlife.org/rss
...
```
共约 6-10 个，均来自 `SampleData`。白名单外的真实播客（如 NPR、Bloomberg 等虽在 SampleData 有条目，但 URL 必须精确匹配）一律无法订阅。

### 3.4 对测试结果的影响

| 用例 | 结果 | 是否真实反映 RSS 能力 |
|------|------|----------------------|
| 打开 Add podcast 页面 | PASS | 否（只开了页面） |
| 推荐播客预览并订阅 | PASS | **否**——订阅的是 mock 预置播客，**没验证真实 RSS 拉取** |
| RSS feed 添加播客 | UNKNOWN | **是**——输入真实 URL 时 mock 返回 undefined，订阅流程异常 |

**结论**：当前测试**无法验证真实 RSS 订阅能力**，因为应用根本没实现 RSS 拉取。9 个 PASS 里至少 1 个（推荐订阅）是依赖 mock 数据的"假通过"。

---

## 四、同类问题：其它 mock 引擎

RSS 不是个例，以下引擎同样是 mock（plan.md 明确 defer）：

| 引擎 | mock 实现 | 真实缺失 | 影响用例 |
|------|-----------|----------|----------|
| **RSS 拉取** | SampleFeedFetcher | 真实 HTTP + XML 解析 | 订阅/RSS 添加（🚨） |
| **媒体下载** | LocalDownloadService | 真实 HTTP 文件下载 | 下载用例（状态机 PASS，无真实文件） |
| **音频播放** | LocalPlaybackService | 真实 AVPlayer 解码 | 播放用例（进度模拟，无真实音频） |
| **OPML 导入导出** | stub 弹窗 | 真实文件读写 + 解析 | OPML 用例（UNKNOWN） |
| **在线搜索** | 本地 SampleData 过滤 | Apple/fyyd/PodcastIndex API | 搜索用例（仅本地，非在线） |

**共同特征**：业务状态机（订阅/下载/播放的状态流转、持久化、UI 刷新）是**真实实现**的；但"数据从哪来/媒体怎么播"是**模拟**的。

---

## 五、根因追溯

### 5.1 为什么没实现真实 RSS

这是逻辑转换阶段（pipeline Stage 1）的**有意决策**，记录在 `logic/plan.md`：

> `plan.md:87`：**Do NOT implement real RSS HTTP parsing, media HTTP download, or AVPlayer decode in this stage — go through the service interfaces with local impls (scope boundary).**

logic-context-builder 按 Platform Behavior 规则，把"无法在当前阶段用本地证据证明的平台依赖（HTTP/RSS/AVPlayer）"归为 `blocked Unknown` → 用 service 接口隔离 → 注入 mock 实现。

### 5.2 为什么重跑流程不会改变

只要 spec（基于 requirements.txt 的行为级描述）没有"必须实时联网拉取"的硬约束，重跑 pipeline 会得到同样的 plan 决策 → 同样的 defer → 同样的 mock。

---

## 六、结论与改善建议

### 当前状态
- **0 FAIL**：应用在 mock 数据范围内，业务流转正确，无真实功能错误
- **RSS 真实拉取能力 = 未实现**：这是设计决策（defer），不是 bug
- 测试通过率 64% 受限于：① mock 导致 RSS/OPML 用例无法真实验证；② 模型输出随机性导致部分用例判定不到

### 让 RSS 闭环的改善路径（推荐优先级）

1. **实现真实 RSS FeedFetcher**（最核心）
   - 用 `@kit.NetworkKit` 发 HTTP 请求拉取 RSS XML
   - 实现 XML → FeedData/EpisodeData 解析
   - 替换 `ServiceLocator` 里的 `sampleFeedFetcher` 注入
   - **业务代码（page/VM/Repository）无需改动**——接口已留好
   - 工作量：中等（HTTP + XML 解析 + 测试）

2. **同步实现真实下载 + AVPlayer 播放**（让播放/下载闭环）

3. **OPML 导入导出**（文件读写 + XML 解析）

### 验证标准
实现真实 RSS 后，重跑自测：
- "RSS feed 添加播客"应从 UNKNOWN → PASS（输入真实 URL 能订阅）
- "推荐播客预览并订阅"应变为真实 PASS（而非 mock 假通过）
- 可新增真实播客订阅测试用例（如订阅一个公开 RSS feed，验证单集列表实时拉取）
