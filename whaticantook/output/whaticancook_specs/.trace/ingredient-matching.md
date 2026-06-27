# Trace: ingredient-matching (REQ-014)

> 食材归一化与同义词匹配。追踪食材匹配算法（单复数、同义词、包含关系）。

## 关键源文件
- `app/src/main/java/com/whaticancook/app/domain/model/CookMatch.kt` — IngredientMatching（normalize、matches）、matchAgainst
- （REQ 来源提及单元测试，算法以 CookMatch.kt 为准）

## IngredientMatching.normalize（CookMatch.kt:43-49）
```
normalize(raw):
  cleaned = raw.lowercase().trim()
             .replace(Regex("[^a-z0-9 ]"), " ")   // 去除标点等非字母数字
             .replace(Regex("\\s+"), " ")          // 压缩多空格为单空格
             .trim()
  return canonical[cleaned] ?: cleaned             // 查同义词表，命中返回规范名
```

## 同义词/规范名表 canonical（CookMatch.kt:11-41）
单复数与常见变体映射到规范名（节选）：
- `eggs → egg`, `tomatoes → tomato`, `potatoes → potato`, `onions → onion`, `carrots → carrot`
- `scallion/scallions/spring onion → green onion`
- `garlic clove/garlic cloves/clove garlic → garlic`
- `chilli/chillies/chilies → chili`；`bell peppers → bell pepper`
- `chicken breast/chicken breasts/chicken thigh/chicken thighs → chicken`
- `ground beef/minced beef → beef`
- `noodles → noodle`；`tortillas → tortilla`；`mushrooms → mushroom`
- `bananas → banana`；`apples → apple`；`lemons → lemon`；`limes → lime`；`oranges → orange`

## IngredientMatching.matches（CookMatch.kt:52-60）
```
matches(pantryName, ingredientName):
  a = normalize(pantryName); b = normalize(ingredientName)
  if a.empty || b.empty: return false
  if a == b: return true                                  // 精确（归一后）相等
  ta = a.split(" ").toSet(); tb = b.split(" ").toSet()
  return tb.containsAll(ta) || ta.containsAll(tb)         // 整词包含关系（双向子集）
```
- 即：归一后精确相等，或一方词集是另一方词集的子集（整词级别）。

## 典型匹配示例（验证点）
| pantry 项 | 菜谱食材 | normalize pantry | normalize 食材 | 命中方式 |
|-----------|---------|------------------|---------------|---------|
| eggs | egg | egg（canonical） | egg | 精确相等 ✓ |
| scallions | green onion | green onion（canonical） | green onion | 精确相等 ✓ |
| chicken breast | chicken | chicken（canonical） | chicken | 精确相等 ✓ |
| garlic cloves | garlic | garlic（canonical） | garlic | 精确相等 ✓ |

> 手动添加 "chicken breast" → 归一化为 "chicken" → 与菜谱必需食材 "chicken" 精确匹配。Chicken Fried Rice 的 Chicken 判定已拥有。✅

## 整词包含关系额外效果
非 canonical 表内时由词集包含判定，例如：
- pantry "green onion" vs 食材 "onion"：{green,onion} ⊇ {onion} → 匹配（onion 食材被 green onion 满足）。
- pantry "bell pepper" vs 食材 "pepper"：{bell,pepper} ⊇ {pepper} → 匹配。

## matchAgainst（CookMatch.kt:86-105）
对菜谱每个食材，用 `pantryNames.any { matches(it, ing.name) }` 判定是否满足，分 essential 已拥有 / essential 缺少 / optional 缺少，得到 CookMatch（haveCount/essentialCount/missing/missingOptional）。

## 偏差/备注
- 匹配为大小写不敏感、忽略标点、支持单复数与同义词、支持整词包含（双向）。
- 不做部分子串匹配（如 "chi" 不会匹配 "chicken"），避免误匹配。
- 规范名表与菜谱/目录使用的规范名一致，故精确匹配占主导。
