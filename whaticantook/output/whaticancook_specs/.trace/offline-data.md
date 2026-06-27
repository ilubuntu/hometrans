# Trace: offline-data (REQ-003)

> 离线菜谱数据初始化。追踪菜谱数据如何随应用打包、首次进入主界面时从本地资产写入本地数据库，实现离线可用。

## 关键源文件
- `app/src/main/assets/recipes.json` — 打包的菜谱种子数据
- `app/src/main/java/com/whaticancook/app/data/seed/RecipeSeedSource.kt` — 读取资产并解析
- `app/src/main/java/com/whaticancook/app/data/repository/RecipeRepositoryImpl.kt` — 种子写入与读取
- `app/src/main/java/com/whaticancook/app/data/local/dao/RecipeDao.kt` — 本地菜谱数据访问
- `app/src/main/java/com/whaticancook/app/feature/home/HomeViewModel.kt` — 首页触发初始化
- `app/src/main/java/com/whaticancook/app/data/seed/dto/RecipeDto.kt` — 数据传输对象

## 种子数据（recipes.json）
- 位置：`app/src/main/assets/recipes.json`，随应用打包发布。
- 结构：顶层 `{"recipes": [...]}`，共 **18** 个菜谱。
- 每条菜谱含：标题、分类、耗时等字段，全部为静态离线数据。

18 个菜谱清单（标题 | 分类 | 耗时）：
```
Cheese Scrambled Eggs | BREAKFAST | 10
Smashed Avocado Toast | BREAKFAST | 8
Garden Veggie Omelette | BREAKFAST | 15
Banana Oat Pancakes | BREAKFAST | 20
Chicken Fried Rice | DINNER | 25
Spaghetti Aglio e Olio | DINNER | 20
Creamy Tomato Pasta | DINNER | 30
Classic Beef Tacos | DINNER | 25
Coconut Chickpea Curry | DINNER | 30
Garlic Butter Shrimp | DINNER | 15
Margherita Flatbread | LUNCH | 20
Greek Salad Bowl | LUNCH | 12
Black Bean Quesadilla | SNACK | 15
Honey Yogurt Parfait | SNACK | 5
5-Minute Mug Cake | DESSERT | 5
Cinnamon Apple Bites | DESSERT | 18
Mango Lassi | DRINK | 5
Lemon Mint Cooler | DRINK | 8
```
> 验收重点提到的 Chicken Fried Rice、5-Minute Mug Cake、Banana Oat Pancakes 均包含在内。

## 初始化触发与执行
1. `HomeViewModel.init { seed() }`（HomeViewModel.kt:45-47）——首页创建时自动触发。
2. `HomeViewModel.seed()`（line 49-56）：`seedState = Loading` → `runCatching { recipeRepository.ensureSeeded() }` → 成功置 Ready / 失败置 Error。
3. `RecipeRepositoryImpl.ensureSeeded()`（RecipeRepositoryImpl.kt:35-45）：
   - 在 IO 线程、`seedMutex` 互斥锁保护下执行（防止并发重复写入）。
   - **判空条件**：`recipeDao.count() == 0` 时才写入（即仅在本地库为空/首次时初始化）。
   - 写入前有 550ms 的有意延迟（让首次加载态可感知；解析本身仅需几毫秒）。
   - `seedSource.load()` 读资产 → 解析为 DTO 列表。
   - `recipeDao.upsertAll(dtos.map { it.toEntity(json) })` 写入本地库（REPLACE 策略）。

## 数据读取（离线）
- `RecipeSeedSource.load()`（RecipeSeedSource.kt:15-20）：`context.assets.open("recipes.json")` → 读文本 → `json.decodeFromString<RecipeCatalogDto>`。
- `RecipeDao.observeAll()`（RecipeDao.kt:19-20）：`SELECT * FROM recipes`，返回本地库菜谱流。
- 全程无网络请求，纯本地资产 + 本地数据库。

## 状态机（HomeViewModel）
```
SeedState.Loading → (ensureSeeded 成功) → Ready
                → (ensureSeeded 失败) → Error
```
首页 UI 据此显示加载/错误/内容（与 REQ-042 错误与加载状态关联）。

## 偏差/备注
- 技术栈：资产文件（JSON）+ Room 本地数据库 + kotlinx.serialization。规格按"应用打包的静态数据文件 + 本地数据存储"描述，迁移到 HarmonyOS 可用 rawfile + 关系型数据库/偏好等价实现。
- `ensureSeeded` 的 550ms 人为延迟仅为体验，非功能必需；规格中表述为"初始化过程可显示加载态"。
- 写入采用"判空后整批写入"，非增量同步，无服务端。
