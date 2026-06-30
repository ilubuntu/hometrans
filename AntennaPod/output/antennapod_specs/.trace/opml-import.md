# Trace: REQ-031 OPML导入

## 关联需求
REQ-031: 从 OPML 文件批量导入订阅列表。

## 代码溯源

### 1. OPML 导入入口
- **ImportExportPreferencesFragment.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/preferences/ImportExportPreferencesFragment.java`)
  - `setupStorageScreen()` (line 124):
    - `PREF_OPML_IMPORT` 点击事件 → 调用 `chooseOpmlImportPathLauncher.launch("*/*")` (line 136-145)。
    - 使用系统文件选择器选择 OPML 文件。

### 2. OPML 导入页面
- **OpmlImportActivity.java** (`app/src/main/java/de/danoeh/antennapod/activity/OpmlImportActivity.java:55`)
  - 接收文件 URI，解析 OPML 并展示可选列表。

#### a) 初始化与 URI 处理
  - `onCreate()` (line 65):
    - 从 Intent 获取文件 URI。
    - 支持 `file://` 协议和 `Intent.EXTRA_TEXT`（分享文本）。
    - 调用 `importUri(uri)`。
  - `importUri()` (line 145):
    - 若 URI 为空，显示错误提示"未选择文件"。
    - 否则启动导入流程。

#### b) OPML 解析
  - `startImport()` (line 223):
    - 显示进度条。
    - 打开文件输入流，处理 BOM 编码（支持 UTF-8 等多种编码）。
    - 使用 `OpmlReader.readDocument(reader)` 解析 OPML XML。
    - 解析完成后展示可选列表。

#### c) 元素选择界面
  - `ListView` 多选模式 (`CHOICE_MODE_MULTIPLE`)。
  - 每个条目显示播客名称。
  - 支持"全选"和"取消全选"操作 (line 168-201)。
  - 用户勾选/取消勾选时更新菜单按钮可见性。

#### d) 导入确认
  - `doImport()` (line 113):
    - 检查家长控制（若设置密码需先验证）。
    - 遍历选中的元素，为每个创建 `Feed` 对象。
    - 调用 `FeedDatabaseWriter.updateFeed()` 保存到数据库。
    - 调用 `FeedUpdateManager.runOnce()` 刷新所有新订阅。
    - 完成后导航到主页面。

#### e) 错误处理
  - 解析失败：显示错误对话框，包含用户可读的错误描述和详细技术信息 (line 248-271)。
  - 权限不足：请求读取权限。

### 3. OPML 读取器
- **OpmlReader.java** (`storage/importexport/src/main/java/de/danoeh/antennapod/storage/importexport/OpmlReader.java:18`)
  - `readDocument(Reader)` (line 27): XML 拉解析 OPML 文档。
  - 解析逻辑：
    - 查找 `<opml>` 根元素。
    - 遍历 `<outline>` 元素。
    - 提取属性：`title`、`text`、`xmlUrl`、`htmlUrl`、`type`。
    - 若 title 为空则使用 text，若 text 也为空则使用 xmlUrl。
    - 仅保留有 `xmlUrl` 的元素（有效的 Feed URL）。
  - 返回 `ArrayList<OpmlElement>`。

### 4. OPML 元素数据结构
- **OpmlElement** (`storage/importexport/`): 包含 text、xmlUrl、htmlUrl、type 属性。

### 5. OPML 符号常量
- **OpmlSymbols**: OPML XML 标签和属性名常量。

### 6. 权限处理
- `requestPermission()`: 请求外部存储读取权限。
- `requestPermissionLauncher`: 处理权限请求结果。

### 7. 家长控制
- `ParentalControlDialog.show()`: 若设置了家长控制密码，导入前需验证。
