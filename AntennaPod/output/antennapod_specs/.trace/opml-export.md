# Trace: REQ-032 OPML导出

## 关联需求
REQ-032: 将订阅列表导出为 OPML 文件。

## 代码溯源

### 1. OPML 导出入口
- **ImportExportPreferencesFragment.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/preferences/ImportExportPreferencesFragment.java`)
  - `setupStorageScreen()` (line 124):
    - `PREF_OPML_EXPORT` 点击事件 → `openExportPathPicker(Export.OPML, chooseOpmlExportPathLauncher)` (line 125-130)。
    - 用户通过系统文件选择器选择导出目标路径。

### 2. 导出路径选择
- `chooseOpmlExportPathLauncher`: ActivityResultLauncher，接收用户选择的目标文件 URI。
- 导出回调中：
  - 获取所有已订阅的 Feed 列表。
  - 调用 `OpmlWriter.writeDocument(feeds, writer)` 写入 OPML。

### 3. OPML 写入器
- **OpmlWriter.java** (`storage/importexport/src/main/java/de/danoeh/antennapod/storage/importexport/OpmlWriter.java:18`)
  - `writeDocument(List<Feed> feeds, Writer writer)` (line 29):
    - 创建 XML 序列化器，启用缩进输出。
    - 写入 OPML 文档头：
      - `<?xml version="1.0" encoding="UTF-8"?>`
      - `<opml version="2.0">`
    - 写入 `<head>` 部分：
      - `<title>AntennaPod Subscriptions</title>`
      - `<dateCreated>` RFC822 格式日期。
    - 写入 `<body>` 部分：
      - 遍历所有已订阅 Feed（`state == STATE_SUBSCRIBED`）。
      - 每个 Feed 写为 `<outline>` 元素。
      - 属性：`text`（标题）、`title`（标题）、`type`（Feed 类型）、`xmlUrl`（下载 URL）、`htmlUrl`（网页链接，可选）。
    - 关闭文档。

### 4. OPML 符号常量
- **OpmlSymbols**: OPML XML 标签和属性名常量。
  - `OPML`、`OUTLINE`、`HEAD`、`BODY`、`TITLE`、`TEXT`、`XMLURL`、`HTMLURL`、`TYPE`、`VERSION`、`DATE_CREATED`。
  - `XML_FEATURE_INDENT_OUTPUT`: 缩进特性。

### 5. 导出数据来源
- **DBReader.getFeedList()**: 获取所有 Feed 列表。
- 仅导出 `state == Feed.STATE_SUBSCRIBED` 的 Feed。

### 6. 额外导出格式
- **HTML 导出**: `PREF_HTML_EXPORT` → 导出为 HTML 格式订阅列表。
- **收藏导出**: `PREF_FAVORITE_EXPORT` → 导出收藏列表。
- **数据库导出**: `PREF_DATABASE_EXPORT` → 导出完整数据库备份。
