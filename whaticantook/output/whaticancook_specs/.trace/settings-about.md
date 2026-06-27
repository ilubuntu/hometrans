# Trace: settings-about (REQ-036)

## 需求原文
Settings 页面应展示 Appearance、Data、About 三组内容，包括 Theme、Clear pantry、App、Version、Built with 和离线说明。About 显示 App WhatCanICook、Version 1.0.0、Built with Jetpack Compose。

## 代码追踪

### 1. Settings 页面整体布局
**文件**: `app/src/main/java/com/whaticancook/app/feature/settings/SettingsScreen.kt:35-122`
```kotlin
@Composable
fun SettingsScreen(onBack: () -> Unit, viewModel: SettingsViewModel = hiltViewModel()) {
    val state by viewModel.uiState.collectAsStateWithLifecycle()
    Column(modifier = Modifier.fillMaxSize()) {
        WccTopBar(title = "Settings", onBack = onBack)
        Column(
            modifier = Modifier.fillMaxSize().verticalScroll(rememberScrollState())
                .padding(horizontal = 20.dp).navigationBarsPadding(),
            verticalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            // Appearance section
            // Data section
            // About section
        }
    }
}
```
- 顶部导航栏含返回按钮。
- 三组内容按顺序纵向排列，间距 12dp，整体可滚动。

### 2. Appearance 分组
**文件**: `SettingsScreen.kt:62-79`
```kotlin
SettingsSectionLabel("Appearance")
SettingsCard {
    Text("Theme", titleMedium, onSurface)
    Spacer(Modifier.height(12.dp))
    Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
        ThemeMode.entries.forEach { mode ->
            WccChip(label = mode.label, selected = state.themeMode == mode,
                onClick = { viewModel.setThemeMode(mode) }, modifier = Modifier.weight(1f))
        }
    }
}
```
- 标签 "APPEARANCE"（大写，主色调，SemiBold）。
- 内容卡片含 "Theme" 标题 + 三个主题 Chip。

### 3. Data 分组
**文件**: `SettingsScreen.kt:81-104`
```kotlin
SettingsSectionLabel("Data")
SettingsCard {
    Row(
        modifier = Modifier.fillMaxWidth().clip(RoundedCornerShape(12.dp))
            .bounceClick(onClick = viewModel::clearPantry, pressedScale = 0.98f)
            .padding(vertical = 4.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Icon(Icons.Rounded.DeleteSweep, tint = error)
        Spacer(Modifier.width(12.dp))
        Column(modifier = Modifier.weight(1f)) {
            Text("Clear pantry", titleMedium, onSurface)
            Text("Remove all ingredients you've added", bodySmall, onSurfaceVariant)
        }
    }
}
```
- 标签 "DATA"。
- "Clear pantry" 操作行，含删除图标（error 红色）、标题和说明文案。

### 4. About 分组
**文件**: `SettingsScreen.kt:106-118`
```kotlin
SettingsSectionLabel("About")
SettingsCard {
    AboutRow("App", "WhatCanICook")
    Spacer(Modifier.height(8.dp))
    AboutRow("Version", "1.0.0")
    Spacer(Modifier.height(8.dp))
    AboutRow("Built with", "Jetpack Compose")
    Spacer(Modifier.height(12.dp))
    Text(
        "Recipe data is bundled on-device, so the whole app works fully offline. " +
            "Typeface: Plus Jakarta Sans (SIL Open Font License).",
        bodySmall, onSurfaceVariant,
    )
}
```
- 标签 "ABOUT"。
- 三行键值对：App=WhatCanICook, Version=1.0.0, Built with=Jetpack Compose。
- 离线说明文案。

### 5. AboutRow 组件
**文件**: `SettingsScreen.kt:137-141`
```kotlin
private fun AboutRow(label: String, value: String) {
    Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
        Text(label, bodyMedium, onSurfaceVariant)
        Text(value, bodyMedium, onSurface)
    }
}
```
- 左标签右值，SpaceBetween 两端对齐。

### 6. SettingsCard 组件
**文件**: `SettingsScreen.kt:129-135`
```kotlin
private fun SettingsCard(content: ...) {
    Column(
        modifier = Modifier.fillMaxWidth().clip(RoundedCornerShape(20.dp))
            .background(MaterialTheme.colorScheme.surface).padding(16.dp),
        content = content,
    )
}
```
- 圆角卡片容器，surface 背景。

## 关键逻辑总结
1. 三组内容（Appearance/Data/About）通过 SettingsSectionLabel + SettingsCard 结构化展示。
2. About 显示固定的应用元信息。
3. 离线说明确认数据完全本地化。
