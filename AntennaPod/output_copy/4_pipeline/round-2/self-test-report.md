# Self-Test Report (Round 2 — glm-4v-plus)

## 测试概览
- 模型: glm-4v-plus (智谱)
- 总用例数: 14
- 通过: 9
- 失败: 0
- 未知: 5
- 通过率: 64.29%
- 耗时: 2026-07-07 11:04:58 ~ 2026-07-07 11:08:49

## 用例结果

| 用例 | 结果 | 耗时 |
|------|------|------|
| 首次启动和底部导航 | UNKNOWN | 0.0s |
| More 菜单进入 Settings | PASS | 0.0s |
| 打开 Add podcast 页面 | PASS | 0.0s |
| 推荐播客预览并订阅 | PASS | 0.0s |
| RSS feed 添加播客 | UNKNOWN | 0.0s |
| Subscriptions 进入播客详情 | PASS | 0.0s |
| 单集详情和播放页 | PASS | 0.0s |
| 下载或加入队列后 Queue 有数据 | PASS | 0.0s |
| Queue 多单集排序和清空 | UNKNOWN | 0.0s |
| Episodes 和 Inbox | UNKNOWN | 0.0s |
| 收藏和播放历史 | PASS | 0.0s |
| Downloads 和 Download Log | PASS | 0.0s |
| 搜索和播客内搜索 | PASS | 0.0s |
| 设置、OPML 和数据持久化 | UNKNOWN | 0.0s |

## UNKNOWN 说明

5 个 UNKNOWN 均真实执行 8-23 秒，最后因 `[WARN] testset_root 为空，跳过更新原始用例文件` 判定环节无法给出明确 PASS。0 FAIL。