# Trace: pantry-manual-add (REQ-010)

> Pantry 手动添加食材。追踪手动输入框的添加逻辑（加号按钮 / 键盘 Done）。

## 关键源文件
- `app/src/main/java/com/whaticancook/app/feature/pantry/PantryScreen.kt` — AddIngredientField
- `app/src/main/java/com/whaticancook/app/feature/pantry/PantryViewModel.kt` — add
- `app/src/main/java/com/whaticancook/app/data/repository/PantryRepositoryImpl.kt` — 持久化（normalize）
- `app/src/main/java/com/whaticancook/app/domain/model/CookMatch.kt` — IngredientMatching.normalize / canonical

## 输入框（PantryScreen.kt:133-189，AddIngredientField）
- 圆角输入条（高 54dp，surface 背景）。
- 内部状态 `text`（remember mutableStateOf）。
- `submit` 闭包（line 136-141）：
  ```
  if (text.isNotBlank()) { onAdd(text.trim()); text = "" }
  ```
  - **空字符串/纯空白不添加**（isNotBlank 判断）。✅
- BasicTextField：单行，键盘 action = ImeAction.Done，`keyboardActions(onDone = { submit() })`（line 160-161）→ **键盘 Done 触发提交**。
- 占位文案：text 为空时显示 "Add your own ingredient…"（line 164-170）。
- 加号按钮：右侧 42dp 圆形（primary 背景，Add 图标），`bounceClick(onClick = submit)`（line 173-187）→ **加号按钮触发提交**。
- onAdd = `viewModel.add(it)`（PantryScreen.kt:80）。

## 添加流程
1. submit → onAdd(text.trim()) → `viewModel.add(name)`。
2. PantryViewModel.add（line 62-65）：默认 category=OTHER；`if (name.isBlank()) return`；→ `pantryRepository.add(name, OTHER)`。
3. PantryRepositoryImpl.add（line 30-41）：`IngredientMatching.normalize(name)` 归一化 → upsert(name=normalized, category, addedAt=now)。

## 归一化与匹配（CookMatch.kt:9-49）
- normalize：lowercase、去标点、压缩空格、查 canonical 同义词表。
- canonical 包含 `"chicken breast" to "chicken"`、`"chicken breasts" to "chicken"` 等。
- **验证点**：输入 "chicken breast" → normalize → canonical 映射 → "chicken" → 存储为 "chicken"。菜谱 "Chicken Fried Rice" 的必需食材 "chicken" 经 matches 比对判定为已拥有。✅

## 偏差/备注
- 手动添加的食材默认归类为"其它"（OTHER）分类，不进入快速添加目录。
- 两种提交入口（加号、键盘 Done）行为一致，均走 submit。
- 空白不添加；提交成功后输入框清空。
- 提交后输入文本被归一化存储，展示时首字母大写（PantryItem.display）。
