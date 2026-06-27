# Trace: saved-order (REQ-035)

## 需求原文
Saved 页应按收藏时间倒序展示，最近收藏的菜谱排在前面。先收藏 A 再收藏 B，Saved 首项为 B。

## 代码追踪

### 1. DAO 查询排序
**文件**: `app/src/main/java/com/whaticancook/app/data/local/dao/FavoriteDao.kt:12-13`
```kotlin
@Query("SELECT recipeId FROM favorites ORDER BY savedAt DESC")
fun observeIdsOrdered(): Flow<List<String>>
```
- 查询返回 recipeId 列表，按 `savedAt` **降序**（DESC）排列。
- `savedAt` = 收藏时的时间戳，最新收藏的 savedAt 最大。

### 2. FavoriteEntity 结构
**文件**: `app/src/main/java/com/whaticancook/app/data/local/entity/FavoriteEntity.kt:5-9`
```kotlin
@Entity(tableName = "favorites")
data class FavoriteEntity(
    @PrimaryKey val recipeId: String,
    val savedAt: Long,
)
```
- 主键 = recipeId（一个菜谱只能有一条收藏记录）。
- `savedAt: Long` — 收藏时间戳。

### 3. 收藏时记录时间戳
**文件**: `RecipeRepositoryImpl.kt:65-66`
```kotlin
if (favorite) {
    favoriteDao.add(FavoriteEntity(recipeId, System.currentTimeMillis()))
}
```
- 每次收藏操作使用当前 `System.currentTimeMillis()` 作为 savedAt。

### 4. DAO 冲突策略
**文件**: `FavoriteDao.kt:15-16`
```kotlin
@Insert(onConflict = OnConflictStrategy.REPLACE)
suspend fun add(favorite: FavoriteEntity)
```
- `REPLACE` 策略：重复收藏同一菜谱时，旧记录被替换，savedAt 更新为新时间戳。
- 这意味着重新收藏会把菜谱移到列表顶部。

### 5. observeFavorites 保持顺序
**文件**: `RecipeRepositoryImpl.kt:57-63`
```kotlin
override fun observeFavorites(): Flow<List<Recipe>> =
    combine(recipeDao.observeAll(), favoriteDao.observeIdsOrdered()) { recipes, favIds ->
        val byId = recipes.associateBy { it.id }
        // Preserve the savedAt-descending order encoded in favIds.
        favIds.mapNotNull { id -> byId[id]?.toDomain(json, isFavorite = true) }
    }.flowOn(io)
```
- `favIds` 已是 savedAt DESC 顺序。
- `mapNotNull` 按此顺序映射出 Recipe，保持排列不变。
- 注释明确说明保留了 savedAt 降序。

### 6. 收藏页渲染顺序
**文件**: `FavoritesScreen.kt:61-68`
```kotlin
items(state.items, key = { it.recipe.id }) { item ->
    RecipeCard(...)
}
```
- `state.items` 直接来自 `observeFavorites()`，顺序已是 savedAt DESC。
- 列表首项 = savedAt 最大的 = 最近收藏的菜谱。

## 关键逻辑总结
1. 排序完全由数据库查询 `ORDER BY savedAt DESC` 保证。
2. 时间戳在收藏时写入，重复收藏更新时间戳（REPLACE）。
3. observeFavorites 不做额外排序，直接保持 DAO 返回的顺序。
