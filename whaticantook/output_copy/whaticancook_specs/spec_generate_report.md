# Spec Generate — 汇总报告

> Skill: `hmos-spec-generate`
> 项目: WhatCanICook (Android → HarmonyOS)
> 生成时间: 2026-07-02

## 输入
- requirement_description_file: `input/requirements.txt`（42 个 REQ 块，空行分隔）
- android_project_dir: `whaticantook/whaticancook`（git 仓库内）
- spec_output_dir: `output/whaticancook_specs`

## 执行
1. **Step 0/1**：校验输入，确认 Android 工程在 git 仓库内。
2. **Step 2**：homegraph 为 Android 工程构建索引（`homegraph init -i`，80 文件 / 1246 节点 / 2319 边）。
3. **Step 3**：按功能区分组并行处理 42 个 REQ 块，每块走完 3.1 读取 → 3.2 召回(homegraph MCP) → 3.3 写 trace → 3.4 复核 → 3.5 综合 spec。所有 `file:line` 锚点均来自 homegraph 工具结果，无回退捏造。

## 产出
- **42 份** `<feature>-SPEC.md`（原子场景规格，中文、零 Android 平台词）
- **42 份** `.trace/<feature>.md`（代码 trace）

## REQ → feature 映射（42）
| REQ | feature | | REQ | feature | | REQ | feature |
|---|---|---|---|---|---|---|---|
| 001 | onboarding | | 015 | recipe-match-count | | 029 | sort-fewest-missing |
| 002 | onboard-persist | | 016 | cookable-ready | | 030 | search-empty |
| 003 | offline-recipes | | 017 | missing-ingredients | | 031 | favorite-recipe |
| 004 | discover-layout | | 018 | add-missing | | 032 | saved-empty |
| 005 | empty-pantry-hint | | 019 | optional-ingredient | | 033 | saved-list |
| 006 | recipe-card | | 020 | detail-overview | | 034 | unfavorite |
| 007 | category-filter | | 021 | detail-ingredients | | 035 | favorite-order |
| 008 | pantry-layout | | 022 | detail-steps | | 036 | settings-overview |
| 009 | pantry-quick-add | | 023 | search-layout | | 037 | theme-switch |
| 010 | pantry-manual-add | | 024 | search-text | | 038 | theme-persist |
| 011 | pantry-remove | | 025 | search-category | | 039 | settings-clear-pantry |
| 012 | pantry-clear | | 026 | search-cookable | | 040 | bottom-nav |
| 013 | ingredient-categories | | 027 | sort-best-match | | 041 | back-navigation |
| 014 | ingredient-normalize | | 028 | sort-quickest | | 042 | loading-error-state |

## 跳过 / no_recall
无。全部 42 个 REQ 成功处理。

## 主要 REQ 与代码偏差（已记入各 spec 末尾，spec 以 REQ_DESC 为准）
- REQ-006/020：头图为渐变+emoji 过程式生成（非真实图片资源）。
- REQ-014：代码额外支持整词包含匹配（rice↔basmati rice）且拒绝子串（egg↛eggplant）。
- REQ-022：步骤勾选进度不持久化（离页归零）。
- REQ-024：搜索匹配范围 = 标题+分类+标签+食材名（REQ 仅述菜谱名/食材）。
- REQ-041：滚动位置不保留（仅数据状态保留）。
- 主题默认值、Clear pantry 刷新范围、底部栏在二级页隐藏等补充行为均已记录。

## 备注
- 所有 spec 已剥离 Android 平台词（Activity/Compose/ViewModel/Manifest 等），可直接用于后续 HarmonyOS 逻辑代码转换（convert-pipeline）。
