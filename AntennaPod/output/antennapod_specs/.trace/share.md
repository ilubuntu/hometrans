# Trace: REQ-038 分享

## 关联需求
REQ-038: 分享播客/单集链接，通过系统分享面板。

## 代码溯源

### 1. 分享工具类
- **ShareUtils.java** (`app/src/main/java/de/danoeh/antennapod/ui/share/ShareUtils.java:22`)
  - 所有分享功能的入口。

#### a) 分享纯文本链接
  - `shareLink(Context, String text)` (line 29):
    - 使用 `ShareCompat.IntentBuilder` 构建分享 Intent。
    - 类型：`text/plain`。
    - 标题：`share_url_label`。
    - 启动系统分享选择器。

#### b) 分享播客订阅链接
  - `shareFeedLink(Context, Feed feed)` (line 38):
    - 生成 AntennaPod 深度链接：`https://antennapod.org/deeplink/subscribe/?url=...&title=...`。
    - 编码 Feed 的下载 URL 和标题。
    - 调用 `shareLink()` 分享。

#### c) 获取单集分享文本
  - `getSocialFeedItemShareText(Context, FeedItem item, boolean withPosition, boolean abbreviate)` (line 51):
    - 构建 Episode 分享文本，包含：
      - 播客名称 + 单集标题。
      - 可选：播放起始位置（"起始位置: HH:MM:SS"）。
      - 可选：单集网页链接。
      - 可选：媒体文件链接（带播放位置锚点 `#t=秒数`）。
    - 支持缩写（超过 50 字符截断加省略号）。

#### d) 判断是否有可分享链接
  - `hasLinkToShare(FeedItem item)` (line 47):
    - 检查单集是否有网页链接（`getLinkWithFallback()`）。

#### e) 分享媒体文件
  - `shareFeedItemFile(Context, FeedMedia media)` (line 95):
    - 使用 `FileProvider` 获取文件 URI。
    - 通过 `ShareCompat.IntentBuilder` 分享文件。
    - 类型：媒体 MIME 类型。
    - 分享已下载的音频/视频文件。

### 2. 分享对话框
- **ShareDialog** (episode detail):
  - 在单集详情页提供分享选项。
  - 可选分享方式：
    - 分享单集网页链接。
    - 分享媒体文件 URL（带/不带播放位置）。
    - 分享已下载的媒体文件。
  - 支持带播放位置的分享（`withPosition`）。
  - 支持缩写模式（`abbreviate`）。

### 3. 单集详情页分享入口
- **ItemFragment** / **EpisodeDetailFragment**:
  - 菜单中提供分享按钮。
  - 调用 ShareUtils 相关方法。

### 4. 播客详情页分享入口
- **FeedItemlistFragment**:
  - 菜单或上下文中提供分享播客选项。
  - 调用 `shareFeedLink()`。

### 5. 分享测试
- **ShareDialogTest.java** (`app/src/androidTest/java/de/test/antennapod/dialogs/ShareDialogTest.java:35`)
  - `testShareDialogDisplayed()` (line 62): 验证分享对话框正常显示。

### 6. 播放位置格式化
- **Converter.java** (`ui/common/`):
  - `getDurationStringLong()`: 格式化时长为 `HH:MM:SS`。
  - 用于分享文本中的播放位置。

### 7. 文件 URI 权限
- **FileProvider**: 为分享文件授予临时读取权限。
- `provider_authority`: 文件提供者权限标识。
