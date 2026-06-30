# Trace: REQ-036 同步设置

## 关联需求
REQ-036: 同步设置，支持 gpodder.net 或其他同步服务，未登录时的配置入口。

## 代码溯源

### 1. 同步设置页面
- **SynchronizationPreferencesFragment.java** (`ui/preferences/src/main/java/de/danoeh/antennapod/ui/preferences/screen/synchronization/SynchronizationPreferencesFragment.java:36`)
  - `onCreatePreferences()` (line 44): 加载 `preferences_synchronization.xml`。
  - `setupScreen()` (line 80): 配置同步设置项。
  - `updateScreen()` (line 113): 根据登录状态更新 UI。

#### a) 未登录状态：
  - 标题："选择同步服务" (line 124)。
  - 摘要："尚未选择同步服务" (line 125)。
  - 点击头部 → `chooseProviderAndLogin()` (line 152):
    - 弹出同步服务选择器，列出可选服务。
    - 选择后打开对应的认证对话框。

#### b) 已登录状态：
  - 显示当前服务的名称、图标和摘要 (line 117-122)。
  - 各操作按钮可用：同步、强制全量同步、登出。

#### 各设置项详情：
- **设置登录信息 (pref_gpodnet_setlogin_information)** (line 82-94):
  - `AuthenticationDialog`: 修改密码（用户名只读）。
  - `SynchronizationCredentials.setPassword()`: 保存密码。

- **立即同步 (pref_synchronization_sync)** (line 95-98):
  - `SynchronizationQueue.getInstance().syncImmediately()`: 触发增量同步。

- **强制全量同步 (pref_synchronization_force_full_sync)** (line 99-102):
  - `SynchronizationQueue.getInstance().fullSync()`: 强制全量同步。

- **登出 (pref_synchronization_logout)** (line 103-110):
  - 清除凭证：`SynchronizationCredentials.clear()`。
  - 清除同步队列：`SynchronizationQueue.getInstance().clear()`。
  - 显示登出提示。
  - 清除选中的同步服务。

### 2. 同步服务选择
- **chooseProviderAndLogin()** (line 152-201):
  - 弹出对话框，显示可选同步服务列表。
  - 每个服务显示名称和图标。
  - 可选服务：
    - **GPODDER_NET**: `GpodderAuthenticationFragment` (line 187-189)。
    - **NEXTCLOUD_GPODDER**: `NextcloudAuthenticationFragment` (line 190-192)。

### 3. gpodder.net 认证
- **GpodderAuthenticationFragment.java** (`ui/preferences/.../synchronization/GpodderAuthenticationFragment.java:40`)
  - `setupLoginView()` (line 94): 登录界面。
  - 用户输入服务器地址、用户名、密码。
  - 登录后保存凭证。

### 4. Nextcloud 认证
- **NextcloudAuthenticationFragment.java** (`ui/preferences/.../synchronization/NextcloudAuthenticationFragment.java:25`)
  - `onCreateDialog()` (line 33): Nextcloud Gpodder 登录对话框。
  - 输入服务器地址和 App 密码。

### 5. 同步服务接口
- **ISyncService.java** (`net/sync/service-interface/.../ISyncService.java`)
  - `login()`: 登录同步服务。
  - `logout()`: 登出同步服务。

### 6. 同步服务实现
- **SyncService.java** (`net/sync/service/src/main/java/de/danoeh/antennapod/net/sync/service/SyncService.java:53`)
  - `doWork()` (line 64): 执行同步任务。
  - 登录 → 同步订阅变化 → 同步剧集状态。

### 7. Gpodder.net 服务
- **GpodnetService.java** (`net/sync/gpoddernet/.../GpodnetService.java`)
  - `login()` (line 294): 登录 gpodder.net。

### 8. Nextcloud 同步服务
- **NextcloudSyncService.java** (`net/sync/gpoddernet/.../NextcloudSyncService.java`)
  - `login()` (line 44) / `logout()` (line 155)。

### 9. 同步状态监听
- `syncStatusChanged(SyncServiceEvent)` (line 66-78):
  - 监听同步状态变化事件。
  - 更新状态栏显示（同步中/成功/失败）。
  - 显示上次同步时间和结果。

### 10. 凭证存储
- **SynchronizationCredentials.java** (`storage/preferences/`)
  - `getUsername()` / `getHosturl()`: 获取登录信息。
  - `setPassword()` / `clear()`: 修改/清除凭证。

- **SynchronizationSettings.java**:
  - `isProviderConnected()`: 是否已连接同步服务。
  - `getSelectedSyncProviderKey()`: 获取当前服务标识。
  - `isLastSyncSuccessful()` / `getLastSyncAttempt()`: 上次同步结果。
