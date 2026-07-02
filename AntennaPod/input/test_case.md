# AntennaPod 验收测试用例

说明：以下用例面向 HomeTrans 迁移后的 HarmonyOS 应用自测和人工验收。HarmonyOS 自测固定 bundle name 为 `com.example.antennapodharmony`，启动应用必须使用该 bundle name，不通过桌面图标或显示名猜测。AntennaPod 是播客应用，核心数据来自 podcast RSS feed；测试前应准备一个稳定可访问的 podcast RSS feed，或准备固定 OPML 文件。

测试数据建议：
- 稳定 podcast RSS feed：使用一个公开、长期可访问、单集数量充足的 feed。
- 至少保证 feed 中有 3 个以上单集，且单集标题、描述、音频地址可解析。
- 如果网络不稳定，优先使用本地可访问的测试 RSS/OPML 服务。

### Scenario: 首次启动和底部导航
- 覆盖需求：REQ-001, REQ-002
- 前置条件：清除应用数据后首次启动。
- 动作：打开应用 -> 依次点击 Home、Queue、Inbox、Subscriptions -> 点击 More。
- 预期结果：应用正常进入主界面；Home、Queue、Inbox、Subscriptions 可切换且选中状态正确；点击 More 时在当前页面弹出菜单，不进入独立 More 空页面。

### Scenario: More 菜单进入 Settings
- 覆盖需求：REQ-003, REQ-004, REQ-036
- 前置条件：处于任意主页面。
- 动作：点击底部 More -> 点击 Settings。
- 预期结果：More 菜单包含 Episodes、Downloads、Playback history、Favorites、Statistics、Add podcast、Customize navigation、Settings；点击 Settings 后进入设置页，显示 User interface、Playback、Downloads、Synchronization、Backup & restore、Notifications 等分类。

### Scenario: 打开 Add podcast 页面
- 覆盖需求：REQ-005, REQ-006
- 前置条件：应用已启动。
- 动作：进入 Subscriptions -> 点击右下角加号。
- 预期结果：进入 Add podcast 页面；页面包含搜索框、推荐播客网格，以及 Add podcast by RSS address、Add local folder、Search Apple Podcasts、Search fyyd、Search Podcast Index、Import podcast list (OPML) 等入口。

### Scenario: 推荐播客预览并订阅
- 覆盖需求：REQ-007, REQ-008, REQ-009
- 前置条件：处于 Add podcast 页面。
- 动作：点击一个推荐播客 -> 查看预览页或弹层 -> 点击 Subscribe -> 返回 Subscriptions 和 Home。
- 预期结果：预览页展示封面、标题、作者、描述、Subscribe 按钮和 Episodes preview；订阅成功后 Subscriptions 显示该播客；Home 出现与订阅相关的数据，不再只有空库提示。

### Scenario: RSS feed 添加播客
- 覆盖需求：REQ-005, REQ-007, REQ-039
- 前置条件：准备一个稳定可访问的 podcast RSS feed。
- 动作：进入 Add podcast -> 选择 Add podcast by RSS address -> 输入 RSS feed -> 确认订阅。
- 预期结果：feed 可被解析并展示播客信息；订阅成功后进入订阅列表；如果 feed 无效，显示错误和重试入口，不崩溃。

### Scenario: Subscriptions 进入播客详情
- 覆盖需求：REQ-010, REQ-011, REQ-029
- 前置条件：至少已订阅 1 个播客。
- 动作：进入 Subscriptions -> 点击已订阅播客 -> 查看详情页 -> 打开播客设置入口。
- 预期结果：Subscriptions 以网格或列表展示播客封面和标题；播客详情展示封面、标题、描述、单集列表；播客设置页可打开并展示自动下载、新单集处理、标签或播放相关设置。

### Scenario: 单集详情和播放页
- 覆盖需求：REQ-012, REQ-013, REQ-021, REQ-038
- 前置条件：处于某个播客详情页，列表中有单集。
- 动作：点击一个单集 -> 点击播放 -> 打开完整播放页 -> 点击星标和分享。
- 预期结果：单集详情展示标题、播客名、日期、时长、描述、播放/下载/队列等操作；播放页显示封面、标题、进度条、播放/暂停、快进、后退、播放速度、睡眠定时器；星标可收藏；分享能打开系统分享面板或等效弹窗。

### Scenario: 下载或加入队列后 Queue 有数据
- 覆盖需求：REQ-014, REQ-015, REQ-016
- 前置条件：已订阅播客并进入某个单集详情。
- 动作：点击 Download 或 Add to queue -> 点击底部 Queue -> 点击某个队列项的移除按钮。
- 预期结果：Queue 中出现被操作的单集；顶部显示数量和剩余时长；队列项包含封面、标题、日期/大小、时长和移除按钮；移除后列表和统计更新。

### Scenario: Queue 多单集排序和清空
- 覆盖需求：REQ-017, REQ-018
- 前置条件：Queue 中至少有 2 个单集。
- 动作：拖拽或使用菜单调整一个单集顺序 -> 打开 Queue 菜单 -> 清空 Queue。
- 预期结果：单集顺序发生变化；清空后 Queue 显示空态；订阅和单集元数据不被删除。

### Scenario: Episodes 和 Inbox
- 覆盖需求：REQ-019, REQ-020
- 前置条件：至少已订阅 1 个播客，feed 中存在单集。
- 动作：点击 More -> Episodes -> 返回后进入 Inbox。
- 预期结果：Episodes 展示订阅来源的单集列表并可进入详情；Inbox 在有新单集时展示新单集列表，没有新单集时显示合理空态，不误显示 Queue、Downloads 或 Favorites 数据。

### Scenario: 收藏和播放历史
- 覆盖需求：REQ-021, REQ-022
- 前置条件：处于单集详情页。
- 动作：点击星标收藏 -> 点击 More -> Favorites -> 播放该单集一小段 -> 点击 More -> Playback history。
- 预期结果：Favorites 显示收藏单集；播放后 Playback history 显示刚播放过的单集。

### Scenario: Downloads 和 Download Log
- 覆盖需求：REQ-023, REQ-024, REQ-025, REQ-026
- 前置条件：处于单集详情页，网络可用。
- 动作：点击 Download -> 点击 More -> Downloads -> 删除已下载单集 -> 打开 Download Log。
- 预期结果：下载中或已下载单集出现在 Downloads；删除下载后单集仍保留在播客列表；Download Log 显示下载记录或失败记录。

### Scenario: 搜索和播客内搜索
- 覆盖需求：REQ-027, REQ-028
- 前置条件：至少已订阅 1 个播客。
- 动作：使用全局搜索输入一个单集关键词 -> 进入播客详情使用播客内搜索输入同一关键词。
- 预期结果：全局搜索返回匹配播客或单集；播客内搜索只返回当前播客内的匹配单集；点击结果可进入单集详情。

### Scenario: 设置、OPML 和数据持久化
- 覆盖需求：REQ-030, REQ-031, REQ-032, REQ-033, REQ-034, REQ-035, REQ-037, REQ-040
- 前置条件：已订阅播客、收藏单集、加入 Queue，并准备固定 OPML 文件。
- 动作：进入 Settings -> 修改外观、播放或下载设置 -> 导入或导出 OPML -> 打开 Statistics -> 关闭并重新打开应用。
- 预期结果：设置项可打开并保存；OPML 导入/导出流程可进入；Statistics 展示统计或合理空态；重启后订阅、Queue、Favorites、History 和设置仍然保持。
