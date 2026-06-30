# Trace: REQ-035 下载设置

## 关联需求
REQ-035: 下载相关全局设置，包括自动下载、移动数据使用、缓存、自动删除等。

## 代码溯源

### 1. 下载设置页面
- **DownloadsPreferencesFragment.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/preferences/DownloadsPreferencesFragment.java:15`)
  - `onCreatePreferences()` (line 23): 加载 `preferences_downloads.xml`。
  - `setupNetworkScreen()` (line 47): 配置下载设置项。
  - 实现 `OnSharedPreferenceChangeListener` 监听变更。

#### 各设置项详情：
- **自动下载子页 (prefAutoDownloadSettings)** (line 48-51):
  - 打开自动下载设置子页面 (`preferences_autodownload.xml`)。
  - 包含：全局自动下载开关、自动下载间隔、下载数量限制等。

- **自动删除子页 (prefAutoDeleteScreen)** (line 52-55):
  - 打开自动删除设置子页面 (`preferences_auto_deletion.xml`)。

- **代理设置 (prefProxy)** (line 57-61):
  - `ProxyDialog`: 设置 HTTP 代理（主机、端口）。

- **数据目录选择 (prefChooseDataDir)** (line 62-68):
  - `ChooseDataFolderDialog.showDialog()`: 选择下载文件存储目录。
  - `UserPreferences.setDataFolder()`: 保存路径。
  - `setDataFolderText()`: 显示当前数据目录路径。

- **Feed 更新间隔 (PREF_UPDATE_INTERVAL_MINUTES)**:
  - 监听变更，重启 Feed 更新定时任务。
  - `FeedUpdateManager.restartUpdateAlarm()` (line 83)。

- **移动数据更新 (PREF_MOBILE_UPDATE)**:
  - 监听变更，重启更新任务。
  - 控制是否允许在移动网络下更新 Feed。

### 2. 自动删除设置子页
- **AutomaticDeletionPreferencesFragment.java** (`app/src/main/java/de/danoeh/antennapod/ui/screen/preferences/AutomaticDeletionPreferencesFragment.java:12`)
  - `onCreatePreferences()` (line 16): 加载 `preferences_auto_deletion.xml`。
  - `setupScreen()` (line 35): 配置自动删除选项。
  - 包含：自动删除开关、播放后自动删除、收藏项不删除等。

### 3. 自动下载偏好存储
- **UserPreferences.java** (`storage/preferences/`)
  - `isAutoDelete()` (line 438): 全局自动删除开关。
  - `isAutoDeleteLocal()`: 本地 Feed 自动删除开关。
  - `PREF_UPDATE_INTERVAL_MINUTES`: Feed 更新间隔。
  - `PREF_MOBILE_UPDATE`: 允许移动数据更新。
  - `isEnableAutodownloadGlobal()`: 全局自动下载开关。

### 4. 缓存清理算法
- **EpisodeCleanupAlgorithm.java** (`net/download/service/src/main/java/de/danoeh/antennapod/net/download/service/episode/autodownload/EpisodeCleanupAlgorithm.java:8`)
  - `getNumEpisodesToCleanup()`: 计算需要清理的剧集数量。
  
- **APCleanupAlgorithm.java** (`net/download/service/.../autodownload/APCleanupAlgorithm.java:44`)
  - `performCleanup()`: 执行缓存清理，基于队列状态和播放历史。

- **ExceptFavoriteCleanupAlgorithm.java** (`net/download/service/.../autodownload/ExceptFavoriteCleanupAlgorithm.java:24`)
  - `performCleanup()`: 清理时排除收藏项。

### 5. Feed 更新定时管理
- **FeedUpdateManager.java** (`net/download/service-interface/`)
  - `restartUpdateAlarm()`: 重启 Feed 更新定时器。
  - `runOnce()`: 立即执行一次更新。

### 6. 移动数据检测
- **NetworkUtils**: 检测当前网络类型（WiFi/移动数据/计量）。
  - `isNetworkCellular()`: 是否移动网络。
  - `isNetworkMetered()`: 是否计量网络。
  - `isAllowMobileFor()`: 是否允许移动网络（基于设置）。

### 7. 数据目录管理
- `UserPreferences.getDataFolder()`: 获取下载目录。
- 支持 SD 卡和内部存储。
