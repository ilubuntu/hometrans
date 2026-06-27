# Trace: onboarding-persist (REQ-002)

> 引导完成状态持久化。追踪 onboarding_complete 标记的写入、读取及启动决策逻辑。

## 关键源文件
- `app/src/main/java/com/whaticancook/app/feature/onboarding/OnboardingViewModel.kt` — 触发写入
- `app/src/main/java/com/whaticancook/app/data/repository/SettingsRepositoryImpl.kt` — 持久化实现
- `app/src/main/java/com/whaticancook/app/domain/repository/SettingsRepository.kt` — 仓库接口
- `app/src/main/java/com/whaticancook/app/feature/app/AppViewModel.kt` — 启动时观察状态
- `app/src/main/java/com/whaticancook/app/MainActivity.kt` — 决定是否进入引导
- `app/src/main/java/com/whaticancook/app/navigation/WccApp.kt` — 路由起点

## 写入流程
`OnboardingViewModel.complete()` (OnboardingViewModel.kt:14-19) → `settings.setOnboardingComplete(true)`。

`SettingsRepositoryImpl.setOnboardingComplete(complete: Boolean)` (SettingsRepositoryImpl.kt:37-40):
```
prefs.edit { putBoolean("onboarding_complete", complete) }   // 持久化
onboardingFlow.value = complete                              // 更新内存流
```
- 存储载体：SharedPreferences，文件名 `wcc_settings`，键 `onboarding_complete`，布尔值。
- 内存中维护 `MutableStateFlow<Boolean>`（默认值取自已存储值）。

## 读取流程
`SettingsRepositoryImpl.observeOnboardingComplete()` (line 35) → 暴露只读 `Flow<Boolean>`。

`AppViewModel` (AppViewModel.kt:25-31):
```
uiState = combine(themeMode, onboardingComplete) { ... }
  → AppUiState(isReady=true, themeMode, onboardingComplete)
```
启动后通过 `stateIn(Eagerly)` 订阅，isReady 立即变 true。

## 启动决策
`MainActivity.onCreate` (MainActivity.kt:23-42):
- 闪屏保持显示直到 `uiState.isReady` 为 true (line 25)。
- `WccApp(startOnboarding = !state.onboardingComplete)` (line 38)。

`WccApp` (WccApp.kt:34, 64):
- `startDestination = if (startOnboarding) Routes.ONBOARDING else Routes.HOME`。

## 完成后导航
`WccApp` onFinish 回调 (WccApp.kt:83-87): 跳到 HOME 并 `popUpTo(ONBOARDING){inclusive=true}`，引导页出栈，无法返回。

## 重置方式
代码中没有运行时重置 onboarding_complete 的入口。唯一恢复引导的方式是清除应用数据（删除 `wcc_settings` 偏好），符合验收重点"清除应用数据后才重新出现引导"。

## 偏差/备注
- 持久化采用 SharedPreferences（键值存储）。规格应表述为"本地持久化的布尔标记"，迁移到 HarmonyOS 可用 Preferences/DataStore 等价实现。
- 默认值 false（首次未完成），与"首次安装进入引导"一致。
