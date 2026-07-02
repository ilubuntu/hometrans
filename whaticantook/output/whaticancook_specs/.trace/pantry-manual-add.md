# Code trace · pantry-manual-add

## Status
status: ok
project-path: /Users/bb/work/hometrans/whaticantook/whaticancook
backend: homegraph

## Recalled entry points (Path 1 + Path 2 union, deduplicated)
- Entry 1: 手动添加输入框 + 加号按钮 (AddIngredientField) — PantryScreen.kt:133-189 — recalled by: both
- Entry 2: 添加校验与落库 — PantryScreen.kt:136-141; PantryViewModel.kt:62-65; PantryRepositoryImpl.kt:30-41 — recalled by: both

## Entry · 手动添加输入框 + 加号按钮 (AddIngredientField)
- claim: 用户在输入框输入自定义食材后，点击右侧加号按钮（或键盘完成键）提交，把该食材加入"已添加食材"
- layers:
  - code:     PantryScreen.kt:133-189 AddIngredientField; PantryScreen.kt:152-163 BasicTextField (text 本地状态 :135); PantryScreen.kt:164-170 占位"Add your own ingredient…" (text 为空时显示); PantryScreen.kt:173-187 加号按钮 (onClick=submit :178); PantryScreen.kt:160-161 键盘 Done → submit; PantryScreen.kt:80 onAdd=viewModel.add(it)
  - resource: N/A
  - manifest: N/A
- interaction: 提交后清空输入框 (PantryScreen.kt:139)；两种提交入口：加号按钮点击、键盘完成键
- data_flow: 输入 text → submit (PantryScreen.kt:136) → 校验通过 → onAdd(text.trim()) (PantryScreen.kt:138) → viewModel.add (PantryScreen.kt:80) → repository.add (PantryViewModel.kt:64)

## Entry · 添加校验与落库
- claim: 仅当输入非空白时才添加；添加时去首尾空白、归一化名称后写入食材库表（默认分类 Other），已添加区与数量同步刷新
- layers:
  - code:     PantryScreen.kt:137 `if (text.isNotBlank())` 才提交; PantryScreen.kt:138 text.trim() 去空白; PantryViewModel.kt:62-65 add(name, category=OTHER)：`if(name.isBlank()) return` 二次校验; PantryViewModel.kt:64 repository.add(name, OTHER); PantryRepositoryImpl.kt:30-41 normalize→upsert(PantryItemEntity(normalized,"OTHER",now)); PantryDao.kt:16-17 upsert REPLACE; PantryDao.kt:13 observeAll ORDER BY addedAt DESC
  - resource: N/A
  - manifest: N/A
- interaction: 双重空白校验（UI 层 isNotBlank :137 + VM 层 isBlank :63）；默认分类 IngredientCategory.OTHER (PantryViewModel.kt:62)；主键 name=归一化名，同名覆盖不重复 (PantryDao.kt:16)
- data_flow: add (PantryViewModel.kt:62) → isBlank 校验 (:63) → repository.add(name,OTHER) (:64) → normalize (PantryRepositoryImpl.kt:31) → pantryDao.upsert (:33) → observeAll (PantryDao.kt:13) → observePantry (PantryRepositoryImpl.kt:25) → items (PantryViewModel.kt:55) → "In your kitchen"区 (PantryScreen.kt:99) + count (PantryViewModel.kt:33)

## Implicit triggers (non-UI state changes that activate this feature)
- Trigger: 食材库变化 — PantryViewModel.kt:41 — behavior: 已添加区与数量刷新；新加项排已添加区最前
- Trigger: 提交后输入框清空 — PantryScreen.kt:139 — behavior: text 置空，占位文案重新显示

## Core business entities (data model / persistence key / state machine)
- Entity: 输入框本地状态 text: MutableState<String> — PantryScreen.kt:135，提交后清空
- Entity: PantryItemEntity(name,category,addedAt) — PantryItemEntity.kt:6-10，表 "pantry_items"，主键 name(归一化)
- Entity: 默认分类 IngredientCategory.OTHER("Other","🧂") — IngredientCategory.kt:12；手动添加未指定分类时归此类
- Entity: 归一化 IngredientMatching.normalize — CookMatch.kt:43-49
- 依赖来源: 输入框位置见 `pantry-layout` (REQ-008)；归一化规则见 `ingredient-normalize` (REQ-014)；落库路径与 `pantry-quick-add` (REQ-009) 共用

## Cross-entry shared declarations
- PantryRepository.add(name,category) (PantryRepositoryImpl.kt:30): 手动添加与快速添加共用同一落库路径；区别为手动添加默认分类 OTHER、快速添加取目录项自带分类
- pantry_items 表主键 name(归一化) + upsert REPLACE (PantryDao.kt:16-17): 同一食材不重复

## Deviations from REQ_DESC
1. REQ_DESC 称"输入自定义食材并点击加号添加"——代码除加号按钮外，键盘完成键(Done)同样触发提交 (PantryScreen.kt:161)，属额外等价入口，无冲突
2. REQ_DESC 验收"apple 出现在 In your kitchen"——代码手动添加 apple 后归一化为"apple"、分类 OTHER，写入后在"In your kitchen"显示 (display 首字母大写为"Apple", PantryItem.kt:9-12)，一致
3. REQ_DESC 验收"空输入或仅空格不能新增食材"——代码双重空白校验：UI 层 isNotBlank (PantryScreen.kt:137) + VM 层 isBlank return (PantryViewModel.kt:63)，空白输入不触发 onAdd、不落库，一致
4. REQ_DESC 未提及默认分类——手动添加的食材默认归"Other"分类 (PantryViewModel.kt:62)，属实现补充

## Scope / Boundary — Exhaustive entry enumeration
### Touched entries (all UI paths, not limited to REQ_DESC mentions)
- 手动添加入口为全应用唯一的输入框+加号 (PantryScreen.kt:80,133-189)；"In your kitchen"区为结果唯一展示位置
  layers: code PantryScreen.kt:133-189; resource N/A; manifest N/A
  interaction/data_flow: 同 Entry · 手动添加输入框 + Entry · 添加校验与落库

### Consumers (who reads this state / data)
- Consumer: 食材库页"In your kitchen"区与数量副标题读取 items — PantryScreen.kt:99,70
- Consumer: 首页/搜索页/详情页读取同一食材库做匹配 — HomeViewModel.kt:71（跨页同步）

### Non-consumers (boundary counter-examples with evidence)
- claim: 手动添加不收集分类、数量、单位、备注；分类固定为 Other，用户不能在输入时指定
  closure_layers: [code]
  tools: [Read PantryScreen.kt:133-189, Read PantryViewModel.kt:62-65]
  zero_hits: AddIngredientField 仅单行文本输入 (BasicTextField singleLine :155)，无分类/数量选择器；viewModel.add 默认 category=OTHER 且 UI 未传分类参数 (PantryScreen.kt:80 仅传 name)
- claim: 空白输入（空或仅空格）不产生任何添加、不刷新列表、不清空已有输入外状态
  closure_layers: [code]
  tools: [Read PantryScreen.kt:136-141]
  zero_hits: submit 内 `if(text.isNotBlank())` 为假时整个 onAdd/text="" 块均不执行 (PantryScreen.kt:137-140)，仅什么都不发生

## Same-source cross-reference (if applicable)
- 手动添加与快速添加 (`pantry-quick-add-SPEC.md`, REQ-009) 共用同一落库路径 PantryRepository.add 与同一 pantry_items 表；区别为入口（输入框 vs 目录 chip）与分类来源（默认 Other vs 目录项自带分类）。两规独立生成，在落库契约处互指
- 归一化对自定义输入的影响（如输入"eggs"被归一化为"egg"）由 `ingredient-normalize-SPEC.md` (REQ-014) 描述
