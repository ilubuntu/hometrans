# Trace: REQ-030 标签与分组

## 关联需求
REQ-030: 为订阅设置标签，按标签过滤和分组显示。

## 代码溯源

### 1. 标签设置对话框
- **TagSettingsDialog.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/feed/preferences/TagSettingsDialog.java:37`)
  - `newInstance(List<FeedPreferences>)`: 支持为单个或多个播客设置标签。
  - `onCreateDialog()` (line 54):
    - 计算选中播客的公共标签（交集）。
    - 移除 `TAG_ROOT` 后显示在芯片列表中。
    - 显示根文件夹复选框（仅在非底部导航模式）。
    - 支持自动补全：从已有标签列表中选择或输入新标签。
  - `loadTags()` (line 114): 从 `DBReader.getNavDrawerData()` 加载已有标签列表。
  - `addTag(name)` (line 140): 添加新标签，去重验证。
  - `updatePreferencesTags()` (line 151):
    - 更新所有选中播客的标签集合。
    - 移除原有公共标签，添加新标签。
    - 调用 `DBWriter.setFeedPreferences()` 持久化。

### 2. 标签数据模型
- **FeedPreferences.java** (`model/src/main/java/de/danoeh/antennapod/model/feed/FeedPreferences.java:13`)
  - `tags` 字段: `Set<String>` 存储标签集合 (line 125)。
  - `TAG_ROOT = "#root"`: 根标签，表示显示在导航根目录 (line 16)。
  - `TAG_UNTAGGED = "#untagged"`: 未分类标签 (line 17)。
  - `TAG_SEPARATOR = "\u001e"`: 标签分隔符 (line 18)。
  - `getTagsAsString()`: 标签序列化为字符串 (line 309)。

### 3. 导航抽屉中的标签分组
- **NavDrawerFragment.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/drawer/NavDrawerFragment.java`)
  - `onTagContextMenuClicked()` (line 226): 标签上下文菜单（重命名/删除）。
  - 加载 `NavDrawerData` 包含标签列表和订阅列表。

### 4. 标签数据读取
- **DBReader.getNavDrawerData()**: 读取导航数据，包含标签分组 (`NavDrawerData.TagItem`)。
  - `TagItem`: 标题、计数、关联的 Feed 列表。
  - 按 `FeedOrder` 排序。

### 5. 标签选择芯片适配器
- **SimpleChipAdapter**: 显示标签芯片列表，支持删除。

### 6. 入口点
- 播客设置页 `FeedSettingsPreferenceFragment`: 点击"标签"设置项打开 `TagSettingsDialog` (line 263-267)。
- 导航抽屉批量选择后设置标签。

### 7. 标签过滤
- 订阅列表支持按标签过滤显示。
- `FeedItemFilterQuery` 支持基于标签的查询过滤。
