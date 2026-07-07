# Android Resources ↔ HarmonyOS Resources Mapping

## 1. 元数据 (Metadata)

- Android 项目路径: `/Users/bb/work/hometrans/AntennaPod/AntennaPod`
- HarmonyOS 工程输出路径: `/Users/bb/work/hometrans/AntennaPod/input/antennapodHarmony`
- 资源源 (Resource source): `source res/` (源码 res/ 回退)
- 资源源路径: 各模块 `<module>/src/main/res/` (共 18 个模块)
- 构建结果: **失败** (环境问题: `jlink` 缺失，DevEco JBR 非完整 JDK)
- 生成时间: 2026-07-06

## 2. Android 资源清单 (Android Resource Inventory)

> 说明: 受 AntennaPod 体量限制 (ui:i18n 含 52 种语言翻译)，本清单按以下粒度记录：文件类资源 (drawable/mipmap/raw/font/xml) 与基础值资源 (values/ 下的 string/color/dimen/integer/bool) 按条目粒度；本地化翻译文件 (values-XX/strings.xml) 按文件粒度 (标注条目数)，因其键与基础英文键一一对应。

| Android Resource Path | Resource Name | Function | Screen(s) | Source Category | Type Category | Status | Notes |
|---|---|---|---|---|---|---|---|
| app/src/main/res/values/attrs.xml#declare-styleable/NestedScrollableHost | NestedScrollableHost | Android <declare-styleable> value | Unknown | 应用自身资源 | values | unmapped | <declare-styleable> not supported |
| app/src/main/res/values/ids.xml#item/select_all_item | select_all_item | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/deselect_all_item | deselect_all_item | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/clear_history_item | clear_history_item | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/open_in_browser_item | open_in_browser_item | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/copy_url_item | copy_url_item | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/share_url_item | share_url_item | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/go_to_position_item | go_to_position_item | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/drag_handle | drag_handle | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/skip_episode_item | skip_episode_item | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/move_to_top_item | move_to_top_item | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/move_to_bottom_item | move_to_bottom_item | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/view_type_episode_item | view_type_episode_item | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/view_type_subscription_grid_with_title | view_type_subscription_grid_with_title | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/view_type_subscription_grid_without_title | view_type_subscription_grid_without_title | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/view_type_subscription_list | view_type_subscription_list | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/bottom_navigation_home | bottom_navigation_home | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/bottom_navigation_queue | bottom_navigation_queue | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/bottom_navigation_inbox | bottom_navigation_inbox | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/bottom_navigation_episodes | bottom_navigation_episodes | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/bottom_navigation_downloads | bottom_navigation_downloads | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/bottom_navigation_history | bottom_navigation_history | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/bottom_navigation_favorites | bottom_navigation_favorites | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/bottom_navigation_addfeed | bottom_navigation_addfeed | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/bottom_navigation_subscriptions | bottom_navigation_subscriptions | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/bottom_navigation_statistics | bottom_navigation_statistics | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/bottom_navigation_more | bottom_navigation_more | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/bottom_navigation_customize | bottom_navigation_customize | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| app/src/main/res/values/ids.xml#item/bottom_navigation_settings | bottom_navigation_settings | Android <item> value | Unknown | 应用自身资源 | values | unmapped | <item> not supported |
| net/download/service/src/main/res/values/ids.xml#item/notification_downloading | notification_downloading | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| net/download/service/src/main/res/values/ids.xml#item/notification_updating_feeds | notification_updating_feeds | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| net/download/service/src/main/res/values/ids.xml#item/notification_download_report | notification_download_report | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| net/download/service/src/main/res/values/ids.xml#item/notification_auto_download_report | notification_auto_download_report | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| net/sync/service/src/main/res/values/ids.xml#item/notification_gpodnet_sync_error | notification_gpodnet_sync_error | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| net/sync/service/src/main/res/values/ids.xml#item/notification_gpodnet_sync_autherror | notification_gpodnet_sync_autherror | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| net/sync/service/src/main/res/values/ids.xml#item/pending_intent_sync_error | pending_intent_sync_error | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| playback/service/src/main/res/values/ids.xml#item/notification_playing | notification_playing | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| playback/service/src/main/res/values/ids.xml#item/notification_streaming_confirmation | notification_streaming_confirmation | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| storage/database-maintenance-service/src/main/res/values/ids.xml#item/notification_db_maintenance | notification_db_maintenance | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| storage/importexport/src/main/res/values/ids.xml#item/pending_intent_backup_error | pending_intent_backup_error | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| storage/importexport/src/main/res/values/ids.xml#item/notification_id_backup_error | notification_id_backup_error | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_download_service_notification | pending_intent_download_service_notification | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_download_service_retry | pending_intent_download_service_retry | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_download_cancel_all | pending_intent_download_cancel_all | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_download_service_auth | pending_intent_download_service_auth | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_download_service_report | pending_intent_download_service_report | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_download_service_autodownload_report | pending_intent_download_service_autodownload_report | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_allow_stream_always | pending_intent_allow_stream_always | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_allow_stream_this_time | pending_intent_allow_stream_this_time | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_playback_speed | pending_intent_playback_speed | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_player_activity | pending_intent_player_activity | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_video_player | pending_intent_video_player | Android <item> value | Unknown | 项目内模块资源 | values | unmapped | <item> not supported |
| ui/common/src/main/res/values/attrs.xml#attr/dragview_background | dragview_background | Android <attr> value | Unknown | 项目内模块资源 | values | unmapped | <attr> not supported |
| ui/common/src/main/res/values/attrs.xml#attr/action_icon_color | action_icon_color | Android <attr> value | Unknown | 项目内模块资源 | values | unmapped | <attr> not supported |
| ui/common/src/main/res/values/attrs.xml#attr/scrollbar_thumb | scrollbar_thumb | Android <attr> value | Unknown | 项目内模块资源 | values | unmapped | <attr> not supported |
| ui/common/src/main/res/values/attrs.xml#attr/background_color | background_color | Android <attr> value | Unknown | 项目内模块资源 | values | unmapped | <attr> not supported |
| ui/common/src/main/res/values/attrs.xml#attr/background_elevated | background_elevated | Android <attr> value | Unknown | 项目内模块资源 | values | unmapped | <attr> not supported |
| ui/common/src/main/res/values/attrs.xml#attr/seek_background | seek_background | Android <attr> value | Unknown | 项目内模块资源 | values | unmapped | <attr> not supported |
| ui/common/src/main/res/values/attrs.xml#attr/icon_red | icon_red | Android <attr> value | Unknown | 项目内模块资源 | values | unmapped | <attr> not supported |
| ui/common/src/main/res/values/attrs.xml#attr/icon_yellow | icon_yellow | Android <attr> value | Unknown | 项目内模块资源 | values | unmapped | <attr> not supported |
| ui/common/src/main/res/values/attrs.xml#attr/icon_green | icon_green | Android <attr> value | Unknown | 项目内模块资源 | values | unmapped | <attr> not supported |
| ui/common/src/main/res/values/attrs.xml#attr/icon_purple | icon_purple | Android <attr> value | Unknown | 项目内模块资源 | values | unmapped | <attr> not supported |
| ui/common/src/main/res/values/attrs.xml#attr/icon_gray | icon_gray | Android <attr> value | Unknown | 项目内模块资源 | values | unmapped | <attr> not supported |
| ui/common/src/main/res/values/styleable.xml#declare-styleable/SquareImageView | SquareImageView | Android <declare-styleable> value | Unknown | 项目内模块资源 | values | unmapped | <declare-styleable> not supported |
| ui/common/src/main/res/values/styleable.xml#declare-styleable/CircularProgressBar | CircularProgressBar | Android <declare-styleable> value | Unknown | 项目内模块资源 | values | unmapped | <declare-styleable> not supported |
| ui/common/src/main/res/values/styleable.xml#declare-styleable/PlaybackSpeedIndicatorView | PlaybackSpeedIndicatorView | Android <declare-styleable> value | Unknown | 项目内模块资源 | values | unmapped | <declare-styleable> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dynamic.Light | Theme.AntennaPod.Dynamic.Light | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.Base.AntennaPod.Dynamic.Light | Theme.Base.AntennaPod.Dynamic.Light | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Light | Theme.AntennaPod.Light | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dynamic.Dark | Theme.AntennaPod.Dynamic.Dark | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.Base.AntennaPod.Dynamic.Dark | Theme.Base.AntennaPod.Dynamic.Dark | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dark | Theme.AntennaPod.Dark | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dynamic.TrueBlack | Theme.AntennaPod.Dynamic.TrueBlack | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.TrueBlack | Theme.AntennaPod.TrueBlack | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dynamic.Light.NoTitle | Theme.AntennaPod.Dynamic.Light.NoTitle | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Light.NoTitle | Theme.AntennaPod.Light.NoTitle | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dynamic.Dark.NoTitle | Theme.AntennaPod.Dynamic.Dark.NoTitle | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dark.NoTitle | Theme.AntennaPod.Dark.NoTitle | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.TrueBlack.NoTitle | Theme.AntennaPod.TrueBlack.NoTitle | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dynamic.TrueBlack.NoTitle | Theme.AntennaPod.Dynamic.TrueBlack.NoTitle | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dynamic.Light.Translucent | Theme.AntennaPod.Dynamic.Light.Translucent | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Light.Translucent | Theme.AntennaPod.Light.Translucent | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dynamic.Dark.Translucent | Theme.AntennaPod.Dynamic.Dark.Translucent | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dark.Translucent | Theme.AntennaPod.Dark.Translucent | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dynamic.TrueBlack.Translucent | Theme.AntennaPod.Dynamic.TrueBlack.Translucent | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.TrueBlack.Translucent | Theme.AntennaPod.TrueBlack.Translucent | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/AnimationFade | AnimationFade | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Splash | Theme.AntennaPod.Splash | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Splash.Translucent | Theme.AntennaPod.Splash.Translucent | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Style.AntennaPod.Toolbar | Style.AntennaPod.Toolbar | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Toolbar | Theme.AntennaPod.Toolbar | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/AntennaPod.TextView.Heading | AntennaPod.TextView.Heading | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/AntennaPod.TextView.ListItemPrimaryTitle | AntennaPod.TextView.ListItemPrimaryTitle | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/AntennaPod.TextView.FeedListItemPrimaryTitle | AntennaPod.TextView.FeedListItemPrimaryTitle | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/AntennaPod.TextView.ListItemSecondaryTitle | AntennaPod.TextView.ListItemSecondaryTitle | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/AntennaPod.TextView.FeedListItemSecondaryTitle | AntennaPod.TextView.FeedListItemSecondaryTitle | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/OutlinedButtonBetterContrast | OutlinedButtonBetterContrast | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/FastScrollRecyclerView | FastScrollRecyclerView | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Widget.AntennaPod.LinearProgressIndicator | Widget.AntennaPod.LinearProgressIndicator | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/Widget.AntennaPod.ActionBar | Widget.AntennaPod.ActionBar | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/AddPodcastTextView | AddPodcastTextView | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/TextPill | TextPill | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/TextBottomNav | TextBottomNav | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/AppPreferenceThemeOverlay | AppPreferenceThemeOverlay | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values/styles.xml#style/AppSwitchPreference | AppSwitchPreference | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| ui/common/src/main/res/values-v27/styles.xml#style/Theme.AntennaPod.Dynamic.Light | Theme.AntennaPod.Dynamic.Light | Android <style> value | Unknown | 项目内模块资源 | values | unmapped | <style> not supported |
| app-wearos/src/main/res/values/wear.xml | wear | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| app-wearos/src/main/res/xml/backup_rules.xml | backup_rules | Configuration XML | Common | 项目内模块资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |
| app-wearos/src/main/res/xml/data_extraction_rules.xml | data_extraction_rules | Configuration XML | Common | 项目内模块资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |
| app/src/main/res/drawable/bg_episode_list_item.xml | bg_episode_list_item | Android <inset> drawable | Common | 应用自身资源 | drawable | unmapped | <inset> |
| app/src/main/res/drawable/grey_border.xml | grey_border | Android <ripple> drawable | Common | 应用自身资源 | drawable | unmapped | <ripple> |
| app/src/main/res/drawable/ic_animate_pause_play.xml | ic_animate_pause_play | Android <animated-vector> drawable | Common | 应用自身资源 | drawable | unmapped | <animated-vector> |
| app/src/main/res/drawable/ic_animate_play.xml | ic_animate_play | Android <vector> drawable | Common | 应用自身资源 | drawable | converted | vector |
| app/src/main/res/drawable/ic_animate_play_pause.xml | ic_animate_play_pause | Android <animated-vector> drawable | Common | 应用自身资源 | drawable | unmapped | <animated-vector> |
| app/src/main/res/drawable/ic_shortcut_feed.xml | ic_shortcut_feed | Android <layer-list> drawable | Common | 应用自身资源 | drawable | converted | layer-list |
| app/src/main/res/drawable/ic_shortcut_playlist.xml | ic_shortcut_playlist | Android <layer-list> drawable | Common | 应用自身资源 | drawable | converted | layer-list |
| app/src/main/res/drawable/ic_shortcut_refresh.xml | ic_shortcut_refresh | Android <layer-list> drawable | Common | 应用自身资源 | drawable | converted | layer-list |
| app/src/main/res/drawable/ic_shortcut_subscriptions.xml | ic_shortcut_subscriptions | Android <layer-list> drawable | Common | 应用自身资源 | drawable | converted | layer-list |
| app/src/main/res/drawable-anydpi-v26/ic_shortcut_feed.xml | ic_shortcut_feed | Adaptive launcher icon | Launcher | 应用自身资源 | drawable | converted | monochrome skipped in JSON |
| app/src/main/res/drawable-anydpi-v26/ic_shortcut_playlist.xml | ic_shortcut_playlist | Adaptive launcher icon | Launcher | 应用自身资源 | drawable | converted | monochrome skipped in JSON |
| app/src/main/res/drawable-anydpi-v26/ic_shortcut_refresh.xml | ic_shortcut_refresh | Adaptive launcher icon | Launcher | 应用自身资源 | drawable | converted | monochrome skipped in JSON |
| app/src/main/res/drawable-anydpi-v26/ic_shortcut_subscriptions.xml | ic_shortcut_subscriptions | Adaptive launcher icon | Launcher | 应用自身资源 | drawable | converted | monochrome skipped in JSON |
| app/src/main/res/layout/addfeed.xml | addfeed | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/audio_controls.xml | audio_controls | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/audioplayer_fragment.xml | audioplayer_fragment | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/bottom_navigation_more_listitem.xml | bottom_navigation_more_listitem | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/checkbox_do_not_show_again.xml | checkbox_do_not_show_again | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/cover_fragment.xml | cover_fragment | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/dialog_set_password.xml | dialog_set_password | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/download_log_details_dialog.xml | download_log_details_dialog | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/download_log_fragment.xml | download_log_fragment | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/downloadlog_item.xml | downloadlog_item | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/edit_tags_dialog.xml | edit_tags_dialog | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/edit_text_dialog.xml | edit_text_dialog | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/ellipsize_start_listitem.xml | ellipsize_start_listitem | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/empty_view_layout.xml | empty_view_layout | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/episode_filter_dialog.xml | episode_filter_dialog | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/episodes_list_fragment.xml | episodes_list_fragment | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/external_player_fragment.xml | external_player_fragment | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/feed_item_list_fragment.xml | feed_item_list_fragment | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/feed_pref_skip_dialog.xml | feed_pref_skip_dialog | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/feedinfo.xml | feedinfo | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/feeditem_fragment.xml | feeditem_fragment | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/feeditem_pager_fragment.xml | feeditem_pager_fragment | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/feeditemlist_header.xml | feeditemlist_header | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/feeditemlist_item.xml | feeditemlist_item | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/feedsettings.xml | feedsettings | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/filter_dialog.xml | filter_dialog | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/filter_dialog_row.xml | filter_dialog_row | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/floating_select_menu.xml | floating_select_menu | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/floating_select_menu_item.xml | floating_select_menu_item | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/fragment_subscriptions.xml | fragment_subscriptions | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/home_fragment.xml | home_fragment | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/home_section.xml | home_section | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/home_section_echo.xml | home_section_echo | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/horizontal_feed_item.xml | horizontal_feed_item | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/horizontal_itemlist_item.xml | horizontal_itemlist_item | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/item_description_fragment.xml | item_description_fragment | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/item_tag_chip.xml | item_tag_chip | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/main.xml | main | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/media3_video_player_activity.xml | media3_video_player_activity | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/more_content_list_footer.xml | more_content_list_footer | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/nav_list.xml | nav_list | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/nav_listitem.xml | nav_listitem | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/nav_section_item.xml | nav_section_item | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/onlinefeedview_activity.xml | onlinefeedview_activity | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/opml_selection.xml | opml_selection | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/playback_speed_feed_setting_dialog.xml | playback_speed_feed_setting_dialog | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/playback_speed_seek_bar.xml | playback_speed_seek_bar | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/popup_bubble_view.xml | popup_bubble_view | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/queue_fragment.xml | queue_fragment | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/rating_dialog.xml | rating_dialog | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/remove_feed_dialog.xml | remove_feed_dialog | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/reorder_dialog.xml | reorder_dialog | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/reorder_dialog_entry.xml | reorder_dialog_entry | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/reorder_dialog_header.xml | reorder_dialog_header | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/search_fragment.xml | search_fragment | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/secondary_action.xml | secondary_action | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/share_episode_dialog.xml | share_episode_dialog | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/simple_list_fragment.xml | simple_list_fragment | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/simple_list_item_multiple_choice_on_start.xml | simple_list_item_multiple_choice_on_start | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/simplechapter_item.xml | simplechapter_item | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/single_tag_text_view.xml | single_tag_text_view | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/sort_dialog.xml | sort_dialog | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/sort_dialog_item.xml | sort_dialog_item | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/sort_dialog_item_active.xml | sort_dialog_item_active | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/speed_select_dialog.xml | speed_select_dialog | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/subscription_grid_item.xml | subscription_grid_item | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/subscription_list_item.xml | subscription_list_item | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/subscription_selection_activity.xml | subscription_selection_activity | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/swipeactions_dialog.xml | swipeactions_dialog | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/swipeactions_picker.xml | swipeactions_picker | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/swipeactions_picker_item.xml | swipeactions_picker_item | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/swipeactions_row.xml | swipeactions_row | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/time_dialog.xml | time_dialog | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/transcript_dialog.xml | transcript_dialog | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/transcript_item.xml | transcript_item | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/video_player_controls.xml | video_player_controls | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout/videoplayer_activity.xml | videoplayer_activity | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/layout-sw720dp/main.xml | main | Android layout (rebuilt in ArkUI) | Common | 应用自身资源 | layout | unmapped | dependencies scanned |
| app/src/main/res/menu/download_log.xml | download_log | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/downloads_completed.xml | downloads_completed | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/episodes.xml | episodes | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/episodes_apply_action_speeddial.xml | episodes_apply_action_speeddial | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/favorites.xml | favorites | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/feedinfo.xml | feedinfo | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/feeditem_options.xml | feeditem_options | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/feeditemlist_context.xml | feeditemlist_context | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/feedlist.xml | feedlist | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/home.xml | home | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/inbox.xml | inbox | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/mediaplayer.xml | mediaplayer | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/multi_select_options.xml | multi_select_options | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/nav_feed_action_speeddial.xml | nav_feed_action_speeddial | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/nav_feed_context.xml | nav_feed_context | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/nav_folder_context.xml | nav_folder_context | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/opml_selection_options.xml | opml_selection_options | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/playback_history.xml | playback_history | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/queue.xml | queue | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/queue_context.xml | queue_context | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/search.xml | search | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/subscriptions.xml | subscriptions | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/menu/transcript.xml | transcript | Android menu (rebuilt in ArkUI) | Common | 应用自身资源 | menu | unmapped | dependencies scanned |
| app/src/main/res/values/attrs.xml | attrs | Android <resources> | Common | 应用自身资源 | values | unmapped | resources |
| app/src/main/res/values/design_time_attributes.xml | design_time_attributes | Android <resources> | Common | 应用自身资源 | values | unmapped | resources |
| app/src/main/res/values/dimens.xml | dimens | Android <resources> | Common | 应用自身资源 | values | unmapped | resources |
| app/src/main/res/values/ids.xml | ids | Android <resources> | Common | 应用自身资源 | values | unmapped | resources |
| app/src/main/res/values/integers.xml | integers | Android <resources> | Common | 应用自身资源 | values | unmapped | resources |
| app/src/main/res/values/svg.xml | svg | Android <resources> | Common | 应用自身资源 | values | unmapped | resources |
| app/src/main/res/values-sw360dp/resource-overrides.xml | resource-overrides | Resource in unsupported-qualifier dir | Unknown | 应用自身资源 | values | unmapped | qualifier sw360dp |
| app/src/main/res/values-sw600dp/integers.xml | integers | Resource in unsupported-qualifier dir | Unknown | 应用自身资源 | values | unmapped | qualifier sw600dp |
| app/src/main/res/values-w1000dp/dimens.xml | dimens | Resource in unsupported-qualifier dir | Unknown | 应用自身资源 | values | unmapped | qualifier w1000dp |
| app/src/main/res/values-w300dp/dimens.xml | dimens | Resource in unsupported-qualifier dir | Unknown | 应用自身资源 | values | unmapped | qualifier w300dp |
| app/src/main/res/xml/actions.xml | actions | Configuration XML | Common | 应用自身资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |
| app/src/main/res/xml/automotive_app_desc.xml | automotive_app_desc | Configuration XML | Common | 应用自身资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |
| app/src/main/res/xml/feed_settings.xml | feed_settings | Configuration XML | Common | 应用自身资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |
| app/src/main/res/xml/locale_config.xml | locale_config | Configuration XML | Common | 应用自身资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |
| app/src/main/res/xml/network_security_config.xml | network_security_config | Configuration XML | Common | 应用自身资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |
| app/src/main/res/xml/provider_paths.xml | provider_paths | Configuration XML | Common | 应用自身资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |
| app/src/main/res/xml/shortcuts.xml | shortcuts | Configuration XML | Common | 应用自身资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |
| net/download/service/src/main/res/values/ids.xml | ids | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| net/sync/service/src/main/res/values/ids.xml | ids | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| net/sync/wear-interface/src/main/res/values/wear.xml | wear | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| playback/service/src/main/res/raw/no_streaming.mp3 | no_streaming | Raw asset | Common | 项目内模块资源 | raw | converted | Original Android type: raw |
| playback/service/src/main/res/values/ids.xml | ids | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| storage/database-maintenance-service/src/main/res/values/ids.xml | ids | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| storage/importexport/src/main/res/values/ids.xml | ids | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| storage/preferences/src/main/res/values/arrays.xml | arrays | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/app-start-intent/src/main/res/values/pending_intent.xml | pending_intent | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/common/src/main/res/anim/fade_in.xml | fade_in | Tween animation | Common | 项目内模块资源 | anim | unmapped | Original Android type: anim |
| ui/common/src/main/res/anim/fade_out.xml | fade_out | Tween animation | Common | 项目内模块资源 | anim | unmapped | Original Android type: anim |
| ui/common/src/main/res/anim/slide_left_in.xml | slide_left_in | Tween animation | Common | 项目内模块资源 | anim | unmapped | Original Android type: anim |
| ui/common/src/main/res/anim/slide_left_out.xml | slide_left_out | Tween animation | Common | 项目内模块资源 | anim | unmapped | Original Android type: anim |
| ui/common/src/main/res/anim/slide_right_in.xml | slide_right_in | Tween animation | Common | 项目内模块资源 | anim | unmapped | Original Android type: anim |
| ui/common/src/main/res/anim/slide_right_out.xml | slide_right_out | Tween animation | Common | 项目内模块资源 | anim | unmapped | Original Android type: anim |
| ui/common/src/main/res/color/button_bg_selector.xml | button_bg_selector | Color state list | Common | 项目内模块资源 | color | unmapped | Original Android type: color |
| ui/common/src/main/res/drawable/bg_blue_gradient.xml | bg_blue_gradient | Android <shape> drawable | Common | 项目内模块资源 | drawable | converted | shape |
| ui/common/src/main/res/drawable/bg_circle.xml | bg_circle | Android <shape> drawable | Common | 项目内模块资源 | drawable | converted | shape |
| ui/common/src/main/res/drawable/bg_drawer_item.xml | bg_drawer_item | Android <ripple> drawable | Common | 项目内模块资源 | drawable | unmapped | <ripple> |
| ui/common/src/main/res/drawable/bg_gradient.xml | bg_gradient | Android <shape> drawable | Common | 项目内模块资源 | drawable | converted | shape |
| ui/common/src/main/res/drawable/bg_message_error.xml | bg_message_error | Android <shape> drawable | Common | 项目内模块资源 | drawable | converted | shape |
| ui/common/src/main/res/drawable/bg_message_info.xml | bg_message_info | Android <shape> drawable | Common | 项目内模块资源 | drawable | converted | shape |
| ui/common/src/main/res/drawable/bg_pill.xml | bg_pill | Android <shape> drawable | Common | 项目内模块资源 | drawable | converted | shape |
| ui/common/src/main/res/drawable/bg_pill_translucent.xml | bg_pill_translucent | Android <shape> drawable | Common | 项目内模块资源 | drawable | converted | shape |
| ui/common/src/main/res/drawable/circle_checked.xml | circle_checked | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/circle_unchecked.xml | circle_unchecked | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/dots_vertical.xml | dots_vertical | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_add.xml | ic_add | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_appearance.xml | ic_appearance | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_arrow_down.xml | ic_arrow_down | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_arrow_full_down.xml | ic_arrow_full_down | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_arrow_full_up.xml | ic_arrow_full_up | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_arrow_right_white.xml | ic_arrow_right_white | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_bug.xml | ic_bug | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_cancel.xml | ic_cancel | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_chapter_next.xml | ic_chapter_next | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_chapter_prev.xml | ic_chapter_prev | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_chart_box.xml | ic_chart_box | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_chat.xml | ic_chat | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_check.xml | ic_check | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_close.xml | ic_close | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_close_white.xml | ic_close_white | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_cloud.xml | ic_cloud | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_contribute.xml | ic_contribute | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_contributors.xml | ic_contributors | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_copy.xml | ic_copy | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_curved_arrow.xml | ic_curved_arrow | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_delete.xml | ic_delete | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_delete_auto.xml | ic_delete_auto | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_download.xml | ic_download | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_download_black.xml | ic_download_black | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_drag_darktheme.xml | ic_drag_darktheme | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_drag_lighttheme.xml | ic_drag_lighttheme | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_error.xml | ic_error | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_eye.xml | ic_eye | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_fast_forward.xml | ic_fast_forward | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_fast_forward_video_white.xml | ic_fast_forward_video_white | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_fast_rewind.xml | ic_fast_rewind | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_fast_rewind_video_white.xml | ic_fast_rewind_video_white | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_feed.xml | ic_feed | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_feed_black.xml | ic_feed_black | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_filter.xml | ic_filter | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_filter_white.xml | ic_filter_white | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_folder.xml | ic_folder | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_history.xml | ic_history | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_history_remove.xml | ic_history_remove | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_home.xml | ic_home | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_inbox.xml | ic_inbox | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_info.xml | ic_info | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_info_white.xml | ic_info_white | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_key.xml | ic_key | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_load_more.xml | ic_load_more | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_mark_played.xml | ic_mark_played | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_mark_unplayed.xml | ic_mark_unplayed | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_minus.xml | ic_minus | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_notifications.xml | ic_notifications | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_paperclip.xml | ic_paperclip | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_pause.xml | ic_pause | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_pause_black.xml | ic_pause_black | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_pause_video_white.xml | ic_pause_video_white | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_pencil.xml | ic_pencil | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_phone_black.xml | ic_phone_black | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_play_24dp.xml | ic_play_24dp | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_play_48dp.xml | ic_play_48dp | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_play_48dp_black.xml | ic_play_48dp_black | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_play_video_white.xml | ic_play_video_white | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_playback_speed.xml | ic_playback_speed | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_playlist_play.xml | ic_playlist_play | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_playlist_play_black.xml | ic_playlist_play_black | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_playlist_remove.xml | ic_playlist_remove | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_policy.xml | ic_policy | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_questionmark.xml | ic_questionmark | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_refresh.xml | ic_refresh | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_refresh_black.xml | ic_refresh_black | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_rename.xml | ic_rename | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_replay.xml | ic_replay | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_rounded_corner_left.xml | ic_rounded_corner_left | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_rounded_corner_right.xml | ic_rounded_corner_right | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_search.xml | ic_search | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_settings.xml | ic_settings | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_settings_white.xml | ic_settings_white | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_share.xml | ic_share | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_shortcut_background.xml | ic_shortcut_background | Android <inset> drawable | Common | 项目内模块资源 | drawable | unmapped | <inset> |
| ui/common/src/main/res/drawable/ic_shuffle.xml | ic_shuffle | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_skip_24dp.xml | ic_skip_24dp | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_skip_48dp.xml | ic_skip_48dp | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_sleep.xml | ic_sleep | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_sleep_off.xml | ic_sleep_off | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_star.xml | ic_star | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_star_border.xml | ic_star_border | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_storage.xml | ic_storage | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_stream.xml | ic_stream | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_subscriptions.xml | ic_subscriptions | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_subscriptions_black.xml | ic_subscriptions_black | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_supervisor_account.xml | ic_supervisor_account | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_tag.xml | ic_tag | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_videocam.xml | ic_videocam | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_volume_adaption.xml | ic_volume_adaption | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/ic_web.xml | ic_web | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable/launcher_animate.xml | launcher_animate | Android <animation-list> | Common | 项目内模块资源 | drawable | unmapped | animation-list |
| ui/common/src/main/res/drawable/scrollbar_thumb_dark.xml | scrollbar_thumb_dark | Android <selector> drawable | Common | 项目内模块资源 | drawable | converted | selector |
| ui/common/src/main/res/drawable/scrollbar_thumb_default.xml | scrollbar_thumb_default | Android <layer-list> drawable | Common | 项目内模块资源 | drawable | converted | layer-list |
| ui/common/src/main/res/drawable/scrollbar_thumb_light.xml | scrollbar_thumb_light | Android <selector> drawable | Common | 项目内模块资源 | drawable | converted | selector |
| ui/common/src/main/res/drawable/scrollbar_thumb_pressed_dark.xml | scrollbar_thumb_pressed_dark | Android <layer-list> drawable | Common | 项目内模块资源 | drawable | converted | layer-list |
| ui/common/src/main/res/drawable/scrollbar_thumb_pressed_light.xml | scrollbar_thumb_pressed_light | Android <layer-list> drawable | Common | 项目内模块资源 | drawable | converted | layer-list |
| ui/common/src/main/res/drawable/scrollbar_track.xml | scrollbar_track | Android <layer-list> drawable | Common | 项目内模块资源 | drawable | converted | layer-list |
| ui/common/src/main/res/drawable/transcript.xml | transcript | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/common/src/main/res/drawable-nodpi/launcher_animate_bg.png | launcher_animate_bg | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/common/src/main/res/drawable-nodpi/launcher_animate_wave1.png | launcher_animate_wave1 | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/common/src/main/res/drawable-nodpi/launcher_animate_wave2.png | launcher_animate_wave2 | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/common/src/main/res/drawable-nodpi/logo_monochrome.png | logo_monochrome | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/common/src/main/res/drawable-nodpi/teaser.webp | teaser | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/common/src/main/res/layout/pager_fragment.xml | pager_fragment | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/common/src/main/res/layout/preference_material_switch.xml | preference_material_switch | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/common/src/main/res/layout/toolbar_activity.xml | toolbar_activity | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/common/src/main/res/mipmap-anydpi-v26/ic_launcher.xml | ic_launcher | Adaptive launcher icon | Launcher | 项目内模块资源 | mipmap | converted | monochrome skipped in JSON |
| ui/common/src/main/res/mipmap-hdpi/ic_launcher.png | ic_launcher | Launcher icon | Launcher | 项目内模块资源 | mipmap | converted | Direct copy |
| ui/common/src/main/res/mipmap-hdpi/ic_launcher_background.png | ic_launcher_background | Launcher icon | Launcher | 项目内模块资源 | mipmap | converted | Direct copy |
| ui/common/src/main/res/mipmap-hdpi/ic_launcher_foreground.png | ic_launcher_foreground | Launcher icon | Launcher | 项目内模块资源 | mipmap | converted | Direct copy |
| ui/common/src/main/res/mipmap-mdpi/ic_launcher.png | ic_launcher | Launcher icon | Launcher | 项目内模块资源 | mipmap | converted | Direct copy |
| ui/common/src/main/res/mipmap-mdpi/ic_launcher_background.png | ic_launcher_background | Launcher icon | Launcher | 项目内模块资源 | mipmap | converted | Direct copy |
| ui/common/src/main/res/mipmap-mdpi/ic_launcher_foreground.png | ic_launcher_foreground | Launcher icon | Launcher | 项目内模块资源 | mipmap | converted | Direct copy |
| ui/common/src/main/res/mipmap-xhdpi/ic_launcher.png | ic_launcher | Launcher icon | Launcher | 项目内模块资源 | mipmap | converted | Direct copy |
| ui/common/src/main/res/mipmap-xhdpi/ic_launcher_background.png | ic_launcher_background | Launcher icon | Launcher | 项目内模块资源 | mipmap | converted | Direct copy |
| ui/common/src/main/res/mipmap-xhdpi/ic_launcher_foreground.png | ic_launcher_foreground | Launcher icon | Launcher | 项目内模块资源 | mipmap | converted | Direct copy |
| ui/common/src/main/res/mipmap-xxhdpi/ic_launcher.png | ic_launcher | Launcher icon | Launcher | 项目内模块资源 | mipmap | converted | Direct copy |
| ui/common/src/main/res/mipmap-xxhdpi/ic_launcher_background.png | ic_launcher_background | Launcher icon | Launcher | 项目内模块资源 | mipmap | converted | Direct copy |
| ui/common/src/main/res/mipmap-xxhdpi/ic_launcher_foreground.png | ic_launcher_foreground | Launcher icon | Launcher | 项目内模块资源 | mipmap | converted | Direct copy |
| ui/common/src/main/res/mipmap-xxxhdpi/ic_launcher.png | ic_launcher | Launcher icon | Launcher | 项目内模块资源 | mipmap | converted | Direct copy |
| ui/common/src/main/res/mipmap-xxxhdpi/ic_launcher_background.png | ic_launcher_background | Launcher icon | Launcher | 项目内模块资源 | mipmap | converted | Direct copy |
| ui/common/src/main/res/mipmap-xxxhdpi/ic_launcher_foreground.png | ic_launcher_foreground | Launcher icon | Launcher | 项目内模块资源 | mipmap | converted | Direct copy |
| ui/common/src/main/res/mipmap-xxxhdpi/ic_launcher_monochrome.png | ic_launcher_monochrome | Launcher icon | Launcher | 项目内模块资源 | mipmap | converted | Direct copy |
| ui/common/src/main/res/values/attrs.xml | attrs | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/common/src/main/res/values/colors.xml | colors | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/common/src/main/res/values/dimens.xml | dimens | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/common/src/main/res/values/integers.xml | integers | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/common/src/main/res/values/styleable.xml | styleable | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/common/src/main/res/values/styles.xml | styles | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/common/src/main/res/values-v27/styles.xml | styles | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/discovery/src/main/res/layout/fragment_online_search.xml | fragment_online_search | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/discovery/src/main/res/layout/online_search_listitem.xml | online_search_listitem | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/discovery/src/main/res/layout/quick_feed_discovery.xml | quick_feed_discovery | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/discovery/src/main/res/layout/quick_feed_discovery_item.xml | quick_feed_discovery_item | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/discovery/src/main/res/layout/select_country_dialog.xml | select_country_dialog | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/discovery/src/main/res/menu/countries_menu.xml | countries_menu | Android menu (rebuilt in ArkUI) | Common | 项目内模块资源 | menu | unmapped | dependencies scanned |
| ui/discovery/src/main/res/menu/online_search.xml | online_search | Android menu (rebuilt in ArkUI) | Common | 项目内模块资源 | menu | unmapped | dependencies scanned |
| ui/echo/src/main/res/drawable-nodpi/echo.png | echo | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/echo/src/main/res/font/sarabun_regular.ttf | sarabun_regular | Font asset | Common | 项目内模块资源 | font | converted |  |
| ui/echo/src/main/res/font/sarabun_semi_bold.ttf | sarabun_semi_bold | Font asset | Common | 项目内模块资源 | font | converted |  |
| ui/echo/src/main/res/layout/echo_activity.xml | echo_activity | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/echo/src/main/res/layout/simple_echo_screen.xml | simple_echo_screen | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/i18n/src/main/res/values/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-ar/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-ast/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-az/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-be/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-bg/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-bn/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-br/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-ca/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-cs/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-da/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-de/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-el/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-es/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-et/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-eu/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-fa/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-fi/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-fil/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-fr/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-ga/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-gl/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-hi/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-hu/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-in/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-it/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-iw/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-ja/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-kn-rIN/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-ko/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-lt/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-mk/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-ml/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-nb/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-nl/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-pl/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-pt/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-pt-rBR/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-ro/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-ru/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-sc/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-sk/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-sl/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-sr/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-sv/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-sw/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-te/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-tr/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-tt/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-uk/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-vi/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-zh-rCN/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/i18n/src/main/res/values-zh-rTW/strings.xml | strings | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/notifications/src/main/res/drawable/ic_notification_cancel.xml | ic_notification_cancel | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/notifications/src/main/res/drawable/ic_notification_fast_forward.xml | ic_notification_fast_forward | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/notifications/src/main/res/drawable/ic_notification_fast_rewind.xml | ic_notification_fast_rewind | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/notifications/src/main/res/drawable/ic_notification_next_chapter.xml | ic_notification_next_chapter | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/notifications/src/main/res/drawable/ic_notification_pause.xml | ic_notification_pause | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/notifications/src/main/res/drawable/ic_notification_play.xml | ic_notification_play | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/notifications/src/main/res/drawable/ic_notification_playback_speed.xml | ic_notification_playback_speed | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/notifications/src/main/res/drawable/ic_notification_skip.xml | ic_notification_skip | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/notifications/src/main/res/drawable/ic_notification_sleep.xml | ic_notification_sleep | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/notifications/src/main/res/drawable/ic_notification_sleep_off.xml | ic_notification_sleep_off | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/notifications/src/main/res/drawable/ic_notification_stream.xml | ic_notification_stream | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/notifications/src/main/res/drawable/ic_notification_sync.xml | ic_notification_sync | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/notifications/src/main/res/drawable/ic_notification_sync_error.xml | ic_notification_sync_error | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/notifications/src/main/res/drawable-hdpi/ic_notification.png | ic_notification | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/notifications/src/main/res/drawable-hdpi/ic_notification_new.png | ic_notification_new | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/notifications/src/main/res/drawable-mdpi/ic_notification.png | ic_notification | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/notifications/src/main/res/drawable-mdpi/ic_notification_new.png | ic_notification_new | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/notifications/src/main/res/drawable-xhdpi/ic_notification.png | ic_notification | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/notifications/src/main/res/drawable-xhdpi/ic_notification_new.png | ic_notification_new | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/notifications/src/main/res/drawable-xxhdpi/ic_notification.png | ic_notification | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/notifications/src/main/res/drawable-xxhdpi/ic_notification_new.png | ic_notification_new | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/notifications/src/main/res/drawable-xxxhdpi/ic_notification.png | ic_notification | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/notifications/src/main/res/drawable-xxxhdpi/ic_notification_new.png | ic_notification_new | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/preferences/src/main/res/drawable-nodpi/gpodder_icon.png | gpodder_icon | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/preferences/src/main/res/drawable-nodpi/nextcloud_logo.png | nextcloud_logo | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/preferences/src/main/res/drawable-nodpi/theme_preview_dark.png | theme_preview_dark | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/preferences/src/main/res/drawable-nodpi/theme_preview_light.png | theme_preview_light | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/preferences/src/main/res/drawable-nodpi/theme_preview_system.png | theme_preview_system | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/preferences/src/main/res/layout/about_teaser.xml | about_teaser | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/preferences/src/main/res/layout/alertdialog_sync_provider_chooser.xml | alertdialog_sync_provider_chooser | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/preferences/src/main/res/layout/authentication_dialog.xml | authentication_dialog | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/preferences/src/main/res/layout/bug_report_fragment.xml | bug_report_fragment | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/preferences/src/main/res/layout/choose_data_folder_dialog.xml | choose_data_folder_dialog | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/preferences/src/main/res/layout/choose_data_folder_dialog_entry.xml | choose_data_folder_dialog_entry | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/preferences/src/main/res/layout/dialog_switch_preference.xml | dialog_switch_preference | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/preferences/src/main/res/layout/gpodnetauth_credentials.xml | gpodnetauth_credentials | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/preferences/src/main/res/layout/gpodnetauth_device.xml | gpodnetauth_device | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/preferences/src/main/res/layout/gpodnetauth_device_row.xml | gpodnetauth_device_row | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/preferences/src/main/res/layout/gpodnetauth_dialog.xml | gpodnetauth_dialog | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/preferences/src/main/res/layout/gpodnetauth_finish.xml | gpodnetauth_finish | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/preferences/src/main/res/layout/gpodnetauth_host.xml | gpodnetauth_host | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/preferences/src/main/res/layout/nextcloud_auth_dialog.xml | nextcloud_auth_dialog | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/preferences/src/main/res/layout/proxy_settings.xml | proxy_settings | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/preferences/src/main/res/layout/settings_activity.xml | settings_activity | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/preferences/src/main/res/layout/simple_icon_list_item.xml | simple_icon_list_item | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/preferences/src/main/res/layout/theme_preference.xml | theme_preference | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/preferences/src/main/res/menu/bug_report_options.xml | bug_report_options | Android menu (rebuilt in ArkUI) | Common | 项目内模块资源 | menu | unmapped | dependencies scanned |
| ui/preferences/src/main/res/values/arrays.xml | arrays | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/preferences/src/main/res/values/keycodes.xml | keycodes | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/preferences/src/main/res/xml/preferences.xml | preferences | Configuration XML | Common | 项目内模块资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |
| ui/preferences/src/main/res/xml/preferences_about.xml | preferences_about | Configuration XML | Common | 项目内模块资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |
| ui/preferences/src/main/res/xml/preferences_auto_deletion.xml | preferences_auto_deletion | Configuration XML | Common | 项目内模块资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |
| ui/preferences/src/main/res/xml/preferences_autodownload.xml | preferences_autodownload | Configuration XML | Common | 项目内模块资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |
| ui/preferences/src/main/res/xml/preferences_downloads.xml | preferences_downloads | Configuration XML | Common | 项目内模块资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |
| ui/preferences/src/main/res/xml/preferences_import_export.xml | preferences_import_export | Configuration XML | Common | 项目内模块资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |
| ui/preferences/src/main/res/xml/preferences_notifications.xml | preferences_notifications | Configuration XML | Common | 项目内模块资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |
| ui/preferences/src/main/res/xml/preferences_parental_control.xml | preferences_parental_control | Configuration XML | Common | 项目内模块资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |
| ui/preferences/src/main/res/xml/preferences_playback.xml | preferences_playback | Configuration XML | Common | 项目内模块资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |
| ui/preferences/src/main/res/xml/preferences_swipe.xml | preferences_swipe | Configuration XML | Common | 项目内模块资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |
| ui/preferences/src/main/res/xml/preferences_synchronization.xml | preferences_synchronization | Configuration XML | Common | 项目内模块资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |
| ui/preferences/src/main/res/xml/preferences_user_interface.xml | preferences_user_interface | Configuration XML | Common | 项目内模块资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |
| ui/statistics/src/main/res/layout/feed_statistics.xml | feed_statistics | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/statistics/src/main/res/layout/feed_statistics_card.xml | feed_statistics_card | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/statistics/src/main/res/layout/feed_statistics_dialog.xml | feed_statistics_dialog | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/statistics/src/main/res/layout/statistics_filter_dialog.xml | statistics_filter_dialog | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/statistics/src/main/res/layout/statistics_fragment.xml | statistics_fragment | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/statistics/src/main/res/layout/statistics_listitem.xml | statistics_listitem | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/statistics/src/main/res/layout/statistics_listitem_barchart.xml | statistics_listitem_barchart | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/statistics/src/main/res/layout/statistics_listitem_total.xml | statistics_listitem_total | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/statistics/src/main/res/layout/statistics_year_listitem.xml | statistics_year_listitem | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/statistics/src/main/res/menu/statistics.xml | statistics | Android menu (rebuilt in ArkUI) | Common | 项目内模块资源 | menu | unmapped | dependencies scanned |
| ui/widget/src/main/res/drawable/ic_widget_fast_forward.xml | ic_widget_fast_forward | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/widget/src/main/res/drawable/ic_widget_fast_rewind.xml | ic_widget_fast_rewind | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/widget/src/main/res/drawable/ic_widget_pause.xml | ic_widget_pause | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/widget/src/main/res/drawable/ic_widget_play.xml | ic_widget_play | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/widget/src/main/res/drawable/ic_widget_playback_speed.xml | ic_widget_playback_speed | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/widget/src/main/res/drawable/ic_widget_skip.xml | ic_widget_skip | Android <vector> drawable | Common | 项目内模块资源 | drawable | converted | vector |
| ui/widget/src/main/res/drawable-hdpi/ic_widget_preview.png | ic_widget_preview | Image resource | Common | 项目内模块资源 | drawable | converted | Direct copy |
| ui/widget/src/main/res/layout/activity_widget_config.xml | activity_widget_config | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/widget/src/main/res/layout/player_widget.xml | player_widget | Android layout (rebuilt in ArkUI) | Common | 项目内模块资源 | layout | unmapped | dependencies scanned |
| ui/widget/src/main/res/values/dimens.xml | dimens | Android <resources> | Common | 项目内模块资源 | values | unmapped | resources |
| ui/widget/src/main/res/xml/player_widget_info.xml | player_widget_info | Configuration XML | Common | 项目内模块资源 | xml | converted | copied to rawfile; profile JSON needs manual authoring |

## 3. Android → HarmonyOS 映射详情 (Mapping Details)

| Android Resource Path | Android Screen(s) | Android Source Category | Android Type Category | HarmonyOS Target | Mapping Kind | Notes |
|---|---|---|---|---|---|---|
| app/src/main/res/values/attrs.xml#declare-styleable/NestedScrollableHost | Unknown | 应用自身资源 | values | N/A | unmappable | <declare-styleable> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/select_all_item | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/deselect_all_item | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/clear_history_item | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/open_in_browser_item | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/copy_url_item | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/share_url_item | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/go_to_position_item | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/drag_handle | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/skip_episode_item | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/move_to_top_item | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/move_to_bottom_item | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/view_type_episode_item | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/view_type_subscription_grid_with_title | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/view_type_subscription_grid_without_title | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/view_type_subscription_list | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/bottom_navigation_home | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/bottom_navigation_queue | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/bottom_navigation_inbox | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/bottom_navigation_episodes | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/bottom_navigation_downloads | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/bottom_navigation_history | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/bottom_navigation_favorites | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/bottom_navigation_addfeed | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/bottom_navigation_subscriptions | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/bottom_navigation_statistics | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/bottom_navigation_more | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/bottom_navigation_customize | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| app/src/main/res/values/ids.xml#item/bottom_navigation_settings | Unknown | 应用自身资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| net/download/service/src/main/res/values/ids.xml#item/notification_downloading | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| net/download/service/src/main/res/values/ids.xml#item/notification_updating_feeds | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| net/download/service/src/main/res/values/ids.xml#item/notification_download_report | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| net/download/service/src/main/res/values/ids.xml#item/notification_auto_download_report | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| net/sync/service/src/main/res/values/ids.xml#item/notification_gpodnet_sync_error | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| net/sync/service/src/main/res/values/ids.xml#item/notification_gpodnet_sync_autherror | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| net/sync/service/src/main/res/values/ids.xml#item/pending_intent_sync_error | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| playback/service/src/main/res/values/ids.xml#item/notification_playing | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| playback/service/src/main/res/values/ids.xml#item/notification_streaming_confirmation | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| storage/database-maintenance-service/src/main/res/values/ids.xml#item/notification_db_maintenance | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| storage/importexport/src/main/res/values/ids.xml#item/pending_intent_backup_error | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| storage/importexport/src/main/res/values/ids.xml#item/notification_id_backup_error | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_download_service_notification | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_download_service_retry | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_download_cancel_all | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_download_service_auth | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_download_service_report | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_download_service_autodownload_report | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_allow_stream_always | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_allow_stream_this_time | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_playback_speed | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_player_activity | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| ui/app-start-intent/src/main/res/values/pending_intent.xml#item/pending_intent_video_player | Unknown | 项目内模块资源 | values | N/A | unmappable | <item> no HarmonyOS equivalent |
| ui/common/src/main/res/values/attrs.xml#attr/dragview_background | Unknown | 项目内模块资源 | values | N/A | unmappable | <attr> no HarmonyOS equivalent |
| ui/common/src/main/res/values/attrs.xml#attr/action_icon_color | Unknown | 项目内模块资源 | values | N/A | unmappable | <attr> no HarmonyOS equivalent |
| ui/common/src/main/res/values/attrs.xml#attr/scrollbar_thumb | Unknown | 项目内模块资源 | values | N/A | unmappable | <attr> no HarmonyOS equivalent |
| ui/common/src/main/res/values/attrs.xml#attr/background_color | Unknown | 项目内模块资源 | values | N/A | unmappable | <attr> no HarmonyOS equivalent |
| ui/common/src/main/res/values/attrs.xml#attr/background_elevated | Unknown | 项目内模块资源 | values | N/A | unmappable | <attr> no HarmonyOS equivalent |
| ui/common/src/main/res/values/attrs.xml#attr/seek_background | Unknown | 项目内模块资源 | values | N/A | unmappable | <attr> no HarmonyOS equivalent |
| ui/common/src/main/res/values/attrs.xml#attr/icon_red | Unknown | 项目内模块资源 | values | N/A | unmappable | <attr> no HarmonyOS equivalent |
| ui/common/src/main/res/values/attrs.xml#attr/icon_yellow | Unknown | 项目内模块资源 | values | N/A | unmappable | <attr> no HarmonyOS equivalent |
| ui/common/src/main/res/values/attrs.xml#attr/icon_green | Unknown | 项目内模块资源 | values | N/A | unmappable | <attr> no HarmonyOS equivalent |
| ui/common/src/main/res/values/attrs.xml#attr/icon_purple | Unknown | 项目内模块资源 | values | N/A | unmappable | <attr> no HarmonyOS equivalent |
| ui/common/src/main/res/values/attrs.xml#attr/icon_gray | Unknown | 项目内模块资源 | values | N/A | unmappable | <attr> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styleable.xml#declare-styleable/SquareImageView | Unknown | 项目内模块资源 | values | N/A | unmappable | <declare-styleable> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styleable.xml#declare-styleable/CircularProgressBar | Unknown | 项目内模块资源 | values | N/A | unmappable | <declare-styleable> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styleable.xml#declare-styleable/PlaybackSpeedIndicatorView | Unknown | 项目内模块资源 | values | N/A | unmappable | <declare-styleable> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dynamic.Light | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.Base.AntennaPod.Dynamic.Light | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Light | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dynamic.Dark | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.Base.AntennaPod.Dynamic.Dark | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dark | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dynamic.TrueBlack | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.TrueBlack | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dynamic.Light.NoTitle | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Light.NoTitle | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dynamic.Dark.NoTitle | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dark.NoTitle | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.TrueBlack.NoTitle | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dynamic.TrueBlack.NoTitle | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dynamic.Light.Translucent | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Light.Translucent | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dynamic.Dark.Translucent | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dark.Translucent | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dynamic.TrueBlack.Translucent | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.TrueBlack.Translucent | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/AnimationFade | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Splash | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Splash.Translucent | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Style.AntennaPod.Toolbar | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Toolbar | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/AntennaPod.TextView.Heading | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/AntennaPod.TextView.ListItemPrimaryTitle | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/AntennaPod.TextView.FeedListItemPrimaryTitle | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/AntennaPod.TextView.ListItemSecondaryTitle | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/AntennaPod.TextView.FeedListItemSecondaryTitle | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/OutlinedButtonBetterContrast | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/FastScrollRecyclerView | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Widget.AntennaPod.LinearProgressIndicator | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/Widget.AntennaPod.ActionBar | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/AddPodcastTextView | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/TextPill | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/TextBottomNav | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/AppPreferenceThemeOverlay | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values/styles.xml#style/AppSwitchPreference | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| ui/common/src/main/res/values-v27/styles.xml#style/Theme.AntennaPod.Dynamic.Light | Unknown | 项目内模块资源 | values | N/A | unmappable | <style> no HarmonyOS equivalent |
| app-wearos/src/main/res/values/wear.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| app-wearos/src/main/res/xml/backup_rules.xml | Common | 项目内模块资源 | xml | resources/rawfile/xml/backup_rules.xml | direct copy | profile conversion deferred |
| app-wearos/src/main/res/xml/data_extraction_rules.xml | Common | 项目内模块资源 | xml | resources/rawfile/xml/data_extraction_rules.xml | direct copy | profile conversion deferred |
| app/src/main/res/drawable/bg_episode_list_item.xml | Common | 应用自身资源 | drawable | N/A | unmappable | <inset> runtime behavior |
| app/src/main/res/drawable/grey_border.xml | Common | 应用自身资源 | drawable | N/A | unmappable | <ripple> runtime behavior |
| app/src/main/res/drawable/ic_animate_pause_play.xml | Common | 应用自身资源 | drawable | N/A | unmappable | <animated-vector> runtime behavior |
| app/src/main/res/drawable/ic_animate_play.xml | Common | 应用自身资源 | drawable | resources/base/media/ic_animate_play.svg | svg conversion | vector |
| app/src/main/res/drawable/ic_animate_play_pause.xml | Common | 应用自身资源 | drawable | N/A | unmappable | <animated-vector> runtime behavior |
| app/src/main/res/drawable/ic_shortcut_feed.xml | Common | 应用自身资源 | drawable | resources/base/media/ic_shortcut_feed.svg | svg conversion | layer-list |
| app/src/main/res/drawable/ic_shortcut_playlist.xml | Common | 应用自身资源 | drawable | resources/base/media/ic_shortcut_playlist.svg | svg conversion | layer-list |
| app/src/main/res/drawable/ic_shortcut_refresh.xml | Common | 应用自身资源 | drawable | resources/base/media/ic_shortcut_refresh.svg | svg conversion | layer-list |
| app/src/main/res/drawable/ic_shortcut_subscriptions.xml | Common | 应用自身资源 | drawable | resources/base/media/ic_shortcut_subscriptions.svg | svg conversion | layer-list |
| app/src/main/res/drawable-anydpi-v26/ic_shortcut_feed.xml | Launcher | 应用自身资源 | drawable | resources/base/media/ic_shortcut_feed_layered_image.json | layered-image conversion | background=@color/grey100->#FFF5F5F5; foreground=@drawable/ic_feed_black |
| app/src/main/res/drawable-anydpi-v26/ic_shortcut_playlist.xml | Launcher | 应用自身资源 | drawable | resources/base/media/ic_shortcut_playlist_layered_image.json | layered-image conversion | background=@color/grey100->#FFF5F5F5; foreground=@drawable/ic_playlist_play_black |
| app/src/main/res/drawable-anydpi-v26/ic_shortcut_refresh.xml | Launcher | 应用自身资源 | drawable | resources/base/media/ic_shortcut_refresh_layered_image.json | layered-image conversion | background=@color/grey100->#FFF5F5F5; foreground=@drawable/ic_refresh_black |
| app/src/main/res/drawable-anydpi-v26/ic_shortcut_subscriptions.xml | Launcher | 应用自身资源 | drawable | resources/base/media/ic_shortcut_subscriptions_layered_image.json | layered-image conversion | background=@color/grey100->#FFF5F5F5; foreground=@drawable/ic_subscriptions_black |
| app/src/main/res/layout/addfeed.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/audio_controls.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/audioplayer_fragment.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/bottom_navigation_more_listitem.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/checkbox_do_not_show_again.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/cover_fragment.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/dialog_set_password.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/download_log_details_dialog.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/download_log_fragment.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/downloadlog_item.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/edit_tags_dialog.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/edit_text_dialog.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/ellipsize_start_listitem.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/empty_view_layout.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/episode_filter_dialog.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/episodes_list_fragment.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/external_player_fragment.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/feed_item_list_fragment.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/feed_pref_skip_dialog.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/feedinfo.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/feeditem_fragment.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/feeditem_pager_fragment.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/feeditemlist_header.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/feeditemlist_item.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/feedsettings.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/filter_dialog.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/filter_dialog_row.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/floating_select_menu.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/floating_select_menu_item.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/fragment_subscriptions.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/home_fragment.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/home_section.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/home_section_echo.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/horizontal_feed_item.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/horizontal_itemlist_item.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/item_description_fragment.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/item_tag_chip.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/main.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/media3_video_player_activity.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/more_content_list_footer.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/nav_list.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/nav_listitem.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/nav_section_item.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/onlinefeedview_activity.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/opml_selection.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/playback_speed_feed_setting_dialog.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/playback_speed_seek_bar.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/popup_bubble_view.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/queue_fragment.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/rating_dialog.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/remove_feed_dialog.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/reorder_dialog.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/reorder_dialog_entry.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/reorder_dialog_header.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/search_fragment.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/secondary_action.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/share_episode_dialog.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/simple_list_fragment.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/simple_list_item_multiple_choice_on_start.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/simplechapter_item.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/single_tag_text_view.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/sort_dialog.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/sort_dialog_item.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/sort_dialog_item_active.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/speed_select_dialog.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/subscription_grid_item.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/subscription_list_item.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/subscription_selection_activity.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/swipeactions_dialog.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/swipeactions_picker.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/swipeactions_picker_item.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/swipeactions_row.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/time_dialog.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/transcript_dialog.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/transcript_item.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/video_player_controls.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout/videoplayer_activity.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/layout-sw720dp/main.xml | Common | 应用自身资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/download_log.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/downloads_completed.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/episodes.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/episodes_apply_action_speeddial.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/favorites.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/feedinfo.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/feeditem_options.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/feeditemlist_context.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/feedlist.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/home.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/inbox.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/mediaplayer.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/multi_select_options.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/nav_feed_action_speeddial.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/nav_feed_context.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/nav_folder_context.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/opml_selection_options.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/playback_history.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/queue.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/queue_context.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/search.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/subscriptions.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/menu/transcript.xml | Common | 应用自身资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| app/src/main/res/values/attrs.xml | Common | 应用自身资源 | values | N/A | unmappable | resources |
| app/src/main/res/values/design_time_attributes.xml | Common | 应用自身资源 | values | N/A | unmappable | resources |
| app/src/main/res/values/dimens.xml | Common | 应用自身资源 | values | N/A | unmappable | resources |
| app/src/main/res/values/ids.xml | Common | 应用自身资源 | values | N/A | unmappable | resources |
| app/src/main/res/values/integers.xml | Common | 应用自身资源 | values | N/A | unmappable | resources |
| app/src/main/res/values/svg.xml | Common | 应用自身资源 | values | N/A | unmappable | resources |
| app/src/main/res/values-sw360dp/resource-overrides.xml | Unknown | 应用自身资源 | values | N/A | unmappable | qualifier sw360dp |
| app/src/main/res/values-sw600dp/integers.xml | Unknown | 应用自身资源 | values | N/A | unmappable | qualifier sw600dp |
| app/src/main/res/values-w1000dp/dimens.xml | Unknown | 应用自身资源 | values | N/A | unmappable | qualifier w1000dp |
| app/src/main/res/values-w300dp/dimens.xml | Unknown | 应用自身资源 | values | N/A | unmappable | qualifier w300dp |
| app/src/main/res/xml/actions.xml | Common | 应用自身资源 | xml | resources/rawfile/xml/actions.xml | direct copy | profile conversion deferred |
| app/src/main/res/xml/automotive_app_desc.xml | Common | 应用自身资源 | xml | resources/rawfile/xml/automotive_app_desc.xml | direct copy | profile conversion deferred |
| app/src/main/res/xml/feed_settings.xml | Common | 应用自身资源 | xml | resources/rawfile/xml/feed_settings.xml | direct copy | profile conversion deferred |
| app/src/main/res/xml/locale_config.xml | Common | 应用自身资源 | xml | resources/rawfile/xml/locale_config.xml | direct copy | profile conversion deferred |
| app/src/main/res/xml/network_security_config.xml | Common | 应用自身资源 | xml | resources/rawfile/xml/network_security_config.xml | direct copy | profile conversion deferred |
| app/src/main/res/xml/provider_paths.xml | Common | 应用自身资源 | xml | resources/rawfile/xml/provider_paths.xml | direct copy | profile conversion deferred |
| app/src/main/res/xml/shortcuts.xml | Common | 应用自身资源 | xml | resources/rawfile/xml/shortcuts.xml | direct copy | profile conversion deferred |
| net/download/service/src/main/res/values/ids.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| net/sync/service/src/main/res/values/ids.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| net/sync/wear-interface/src/main/res/values/wear.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| playback/service/src/main/res/raw/no_streaming.mp3 | Common | 项目内模块资源 | raw | resources/rawfile/no_streaming.mp3 | direct copy | Original Android type: raw |
| playback/service/src/main/res/values/ids.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| storage/database-maintenance-service/src/main/res/values/ids.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| storage/importexport/src/main/res/values/ids.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| storage/preferences/src/main/res/values/arrays.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/app-start-intent/src/main/res/values/pending_intent.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/common/src/main/res/anim/fade_in.xml | Common | 项目内模块资源 | anim | N/A | unmappable | anim |
| ui/common/src/main/res/anim/fade_out.xml | Common | 项目内模块资源 | anim | N/A | unmappable | anim |
| ui/common/src/main/res/anim/slide_left_in.xml | Common | 项目内模块资源 | anim | N/A | unmappable | anim |
| ui/common/src/main/res/anim/slide_left_out.xml | Common | 项目内模块资源 | anim | N/A | unmappable | anim |
| ui/common/src/main/res/anim/slide_right_in.xml | Common | 项目内模块资源 | anim | N/A | unmappable | anim |
| ui/common/src/main/res/anim/slide_right_out.xml | Common | 项目内模块资源 | anim | N/A | unmappable | anim |
| ui/common/src/main/res/color/button_bg_selector.xml | Common | 项目内模块资源 | color | N/A | unmappable | color state list |
| ui/common/src/main/res/drawable/bg_blue_gradient.xml | Common | 项目内模块资源 | drawable | resources/base/media/bg_blue_gradient.svg | svg conversion | shape |
| ui/common/src/main/res/drawable/bg_circle.xml | Common | 项目内模块资源 | drawable | resources/base/media/bg_circle.svg | svg conversion | shape |
| ui/common/src/main/res/drawable/bg_drawer_item.xml | Common | 项目内模块资源 | drawable | N/A | unmappable | <ripple> runtime behavior |
| ui/common/src/main/res/drawable/bg_gradient.xml | Common | 项目内模块资源 | drawable | resources/base/media/bg_gradient.svg | svg conversion | shape |
| ui/common/src/main/res/drawable/bg_message_error.xml | Common | 项目内模块资源 | drawable | resources/base/media/bg_message_error.svg | svg conversion | shape |
| ui/common/src/main/res/drawable/bg_message_info.xml | Common | 项目内模块资源 | drawable | resources/base/media/bg_message_info.svg | svg conversion | shape |
| ui/common/src/main/res/drawable/bg_pill.xml | Common | 项目内模块资源 | drawable | resources/base/media/bg_pill.svg | svg conversion | shape |
| ui/common/src/main/res/drawable/bg_pill_translucent.xml | Common | 项目内模块资源 | drawable | resources/base/media/bg_pill_translucent.svg | svg conversion | shape |
| ui/common/src/main/res/drawable/circle_checked.xml | Common | 项目内模块资源 | drawable | resources/base/media/circle_checked.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/circle_unchecked.xml | Common | 项目内模块资源 | drawable | resources/base/media/circle_unchecked.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/dots_vertical.xml | Common | 项目内模块资源 | drawable | resources/base/media/dots_vertical.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_add.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_add.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_appearance.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_appearance.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_arrow_down.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_arrow_down.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_arrow_full_down.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_arrow_full_down.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_arrow_full_up.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_arrow_full_up.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_arrow_right_white.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_arrow_right_white.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_bug.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_bug.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_cancel.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_cancel.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_chapter_next.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_chapter_next.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_chapter_prev.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_chapter_prev.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_chart_box.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_chart_box.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_chat.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_chat.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_check.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_check.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_close.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_close.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_close_white.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_close_white.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_cloud.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_cloud.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_contribute.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_contribute.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_contributors.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_contributors.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_copy.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_copy.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_curved_arrow.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_curved_arrow.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_delete.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_delete.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_delete_auto.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_delete_auto.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_download.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_download.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_download_black.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_download_black.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_drag_darktheme.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_drag_darktheme.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_drag_lighttheme.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_drag_lighttheme.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_error.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_error.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_eye.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_eye.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_fast_forward.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_fast_forward.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_fast_forward_video_white.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_fast_forward_video_white.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_fast_rewind.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_fast_rewind.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_fast_rewind_video_white.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_fast_rewind_video_white.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_feed.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_feed.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_feed_black.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_feed_black.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_filter.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_filter.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_filter_white.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_filter_white.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_folder.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_folder.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_history.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_history.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_history_remove.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_history_remove.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_home.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_home.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_inbox.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_inbox.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_info.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_info.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_info_white.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_info_white.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_key.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_key.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_load_more.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_load_more.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_mark_played.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_mark_played.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_mark_unplayed.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_mark_unplayed.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_minus.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_minus.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_notifications.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_notifications.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_paperclip.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_paperclip.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_pause.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_pause.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_pause_black.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_pause_black.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_pause_video_white.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_pause_video_white.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_pencil.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_pencil.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_phone_black.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_phone_black.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_play_24dp.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_play_24dp.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_play_48dp.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_play_48dp.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_play_48dp_black.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_play_48dp_black.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_play_video_white.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_play_video_white.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_playback_speed.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_playback_speed.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_playlist_play.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_playlist_play.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_playlist_play_black.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_playlist_play_black.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_playlist_remove.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_playlist_remove.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_policy.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_policy.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_questionmark.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_questionmark.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_refresh.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_refresh.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_refresh_black.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_refresh_black.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_rename.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_rename.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_replay.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_replay.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_rounded_corner_left.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_rounded_corner_left.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_rounded_corner_right.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_rounded_corner_right.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_search.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_search.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_settings.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_settings.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_settings_white.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_settings_white.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_share.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_share.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_shortcut_background.xml | Common | 项目内模块资源 | drawable | N/A | unmappable | <inset> runtime behavior |
| ui/common/src/main/res/drawable/ic_shuffle.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_shuffle.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_skip_24dp.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_skip_24dp.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_skip_48dp.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_skip_48dp.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_sleep.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_sleep.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_sleep_off.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_sleep_off.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_star.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_star.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_star_border.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_star_border.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_storage.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_storage.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_stream.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_stream.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_subscriptions.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_subscriptions.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_subscriptions_black.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_subscriptions_black.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_supervisor_account.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_supervisor_account.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_tag.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_tag.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_videocam.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_videocam.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_volume_adaption.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_volume_adaption.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/ic_web.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_web.svg | svg conversion | vector |
| ui/common/src/main/res/drawable/launcher_animate.xml | Common | 项目内模块资源 | drawable | N/A | unmappable | animation-list |
| ui/common/src/main/res/drawable/scrollbar_thumb_dark.xml | Common | 项目内模块资源 | drawable | resources/base/media/scrollbar_thumb_dark.svg | svg conversion | selector |
| ui/common/src/main/res/drawable/scrollbar_thumb_default.xml | Common | 项目内模块资源 | drawable | resources/base/media/scrollbar_thumb_default.svg | svg conversion | layer-list |
| ui/common/src/main/res/drawable/scrollbar_thumb_light.xml | Common | 项目内模块资源 | drawable | resources/base/media/scrollbar_thumb_light.svg | svg conversion | selector |
| ui/common/src/main/res/drawable/scrollbar_thumb_pressed_dark.xml | Common | 项目内模块资源 | drawable | resources/base/media/scrollbar_thumb_pressed_dark.svg | svg conversion | layer-list |
| ui/common/src/main/res/drawable/scrollbar_thumb_pressed_light.xml | Common | 项目内模块资源 | drawable | resources/base/media/scrollbar_thumb_pressed_light.svg | svg conversion | layer-list |
| ui/common/src/main/res/drawable/scrollbar_track.xml | Common | 项目内模块资源 | drawable | resources/base/media/scrollbar_track.svg | svg conversion | layer-list |
| ui/common/src/main/res/drawable/transcript.xml | Common | 项目内模块资源 | drawable | resources/base/media/transcript.svg | svg conversion | vector |
| ui/common/src/main/res/drawable-nodpi/launcher_animate_bg.png | Common | 项目内模块资源 | drawable | resources/base/media/launcher_animate_bg.png | direct copy | Direct copy |
| ui/common/src/main/res/drawable-nodpi/launcher_animate_wave1.png | Common | 项目内模块资源 | drawable | resources/base/media/launcher_animate_wave1.png | direct copy | Direct copy |
| ui/common/src/main/res/drawable-nodpi/launcher_animate_wave2.png | Common | 项目内模块资源 | drawable | resources/base/media/launcher_animate_wave2.png | direct copy | Direct copy |
| ui/common/src/main/res/drawable-nodpi/logo_monochrome.png | Common | 项目内模块资源 | drawable | resources/base/media/logo_monochrome.png | direct copy | Direct copy |
| ui/common/src/main/res/drawable-nodpi/teaser.webp | Common | 项目内模块资源 | drawable | resources/base/media/teaser.webp | direct copy | Direct copy |
| ui/common/src/main/res/layout/pager_fragment.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/common/src/main/res/layout/preference_material_switch.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/common/src/main/res/layout/toolbar_activity.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/common/src/main/res/mipmap-anydpi-v26/ic_launcher.xml | Launcher | 项目内模块资源 | mipmap | resources/base/media/ic_launcher_layered_image.json | layered-image conversion | background=@mipmap/ic_launcher_background; foreground=@mipmap/ic_launcher_foreground |
| ui/common/src/main/res/mipmap-hdpi/ic_launcher.png | Launcher | 项目内模块资源 | mipmap | resources/ldpi/media/ic_launcher.png | direct copy | Direct copy |
| ui/common/src/main/res/mipmap-hdpi/ic_launcher_background.png | Launcher | 项目内模块资源 | mipmap | resources/ldpi/media/ic_launcher_background.png | direct copy | Direct copy |
| ui/common/src/main/res/mipmap-hdpi/ic_launcher_foreground.png | Launcher | 项目内模块资源 | mipmap | resources/ldpi/media/ic_launcher_foreground.png | direct copy | Direct copy |
| ui/common/src/main/res/mipmap-mdpi/ic_launcher.png | Launcher | 项目内模块资源 | mipmap | resources/mdpi/media/ic_launcher.png | direct copy | Direct copy |
| ui/common/src/main/res/mipmap-mdpi/ic_launcher_background.png | Launcher | 项目内模块资源 | mipmap | resources/mdpi/media/ic_launcher_background.png | direct copy | Direct copy |
| ui/common/src/main/res/mipmap-mdpi/ic_launcher_foreground.png | Launcher | 项目内模块资源 | mipmap | resources/mdpi/media/ic_launcher_foreground.png | direct copy | Direct copy |
| ui/common/src/main/res/mipmap-xhdpi/ic_launcher.png | Launcher | 项目内模块资源 | mipmap | resources/xldpi/media/ic_launcher.png | direct copy | Direct copy |
| ui/common/src/main/res/mipmap-xhdpi/ic_launcher_background.png | Launcher | 项目内模块资源 | mipmap | resources/xldpi/media/ic_launcher_background.png | direct copy | Direct copy |
| ui/common/src/main/res/mipmap-xhdpi/ic_launcher_foreground.png | Launcher | 项目内模块资源 | mipmap | resources/xldpi/media/ic_launcher_foreground.png | direct copy | Direct copy |
| ui/common/src/main/res/mipmap-xxhdpi/ic_launcher.png | Launcher | 项目内模块资源 | mipmap | resources/xxldpi/media/ic_launcher.png | direct copy | Direct copy |
| ui/common/src/main/res/mipmap-xxhdpi/ic_launcher_background.png | Launcher | 项目内模块资源 | mipmap | resources/xxldpi/media/ic_launcher_background.png | direct copy | Direct copy |
| ui/common/src/main/res/mipmap-xxhdpi/ic_launcher_foreground.png | Launcher | 项目内模块资源 | mipmap | resources/xxldpi/media/ic_launcher_foreground.png | direct copy | Direct copy |
| ui/common/src/main/res/mipmap-xxxhdpi/ic_launcher.png | Launcher | 项目内模块资源 | mipmap | resources/xxxldpi/media/ic_launcher.png | direct copy | Direct copy |
| ui/common/src/main/res/mipmap-xxxhdpi/ic_launcher_background.png | Launcher | 项目内模块资源 | mipmap | resources/xxxldpi/media/ic_launcher_background.png | direct copy | Direct copy |
| ui/common/src/main/res/mipmap-xxxhdpi/ic_launcher_foreground.png | Launcher | 项目内模块资源 | mipmap | resources/xxxldpi/media/ic_launcher_foreground.png | direct copy | Direct copy |
| ui/common/src/main/res/mipmap-xxxhdpi/ic_launcher_monochrome.png | Launcher | 项目内模块资源 | mipmap | resources/xxxldpi/media/ic_launcher_monochrome.png | direct copy | Direct copy |
| ui/common/src/main/res/values/attrs.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/common/src/main/res/values/colors.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/common/src/main/res/values/dimens.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/common/src/main/res/values/integers.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/common/src/main/res/values/styleable.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/common/src/main/res/values/styles.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/common/src/main/res/values-v27/styles.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/discovery/src/main/res/layout/fragment_online_search.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/discovery/src/main/res/layout/online_search_listitem.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/discovery/src/main/res/layout/quick_feed_discovery.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/discovery/src/main/res/layout/quick_feed_discovery_item.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/discovery/src/main/res/layout/select_country_dialog.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/discovery/src/main/res/menu/countries_menu.xml | Common | 项目内模块资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/discovery/src/main/res/menu/online_search.xml | Common | 项目内模块资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/echo/src/main/res/drawable-nodpi/echo.png | Common | 项目内模块资源 | drawable | resources/base/media/echo.png | direct copy | Direct copy |
| ui/echo/src/main/res/font/sarabun_regular.ttf | Common | 项目内模块资源 | font | resources/rawfile/fonts/sarabun_regular.ttf | direct copy |  |
| ui/echo/src/main/res/font/sarabun_semi_bold.ttf | Common | 项目内模块资源 | font | resources/rawfile/fonts/sarabun_semi_bold.ttf | direct copy |  |
| ui/echo/src/main/res/layout/echo_activity.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/echo/src/main/res/layout/simple_echo_screen.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/i18n/src/main/res/values/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-ar/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-ast/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-az/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-be/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-bg/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-bn/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-br/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-ca/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-cs/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-da/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-de/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-el/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-es/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-et/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-eu/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-fa/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-fi/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-fil/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-fr/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-ga/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-gl/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-hi/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-hu/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-in/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-it/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-iw/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-ja/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-kn-rIN/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-ko/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-lt/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-mk/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-ml/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-nb/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-nl/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-pl/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-pt/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-pt-rBR/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-ro/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-ru/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-sc/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-sk/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-sl/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-sr/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-sv/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-sw/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-te/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-tr/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-tt/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-uk/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-vi/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-zh-rCN/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/i18n/src/main/res/values-zh-rTW/strings.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/notifications/src/main/res/drawable/ic_notification_cancel.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_notification_cancel.svg | svg conversion | vector |
| ui/notifications/src/main/res/drawable/ic_notification_fast_forward.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_notification_fast_forward.svg | svg conversion | vector |
| ui/notifications/src/main/res/drawable/ic_notification_fast_rewind.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_notification_fast_rewind.svg | svg conversion | vector |
| ui/notifications/src/main/res/drawable/ic_notification_next_chapter.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_notification_next_chapter.svg | svg conversion | vector |
| ui/notifications/src/main/res/drawable/ic_notification_pause.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_notification_pause.svg | svg conversion | vector |
| ui/notifications/src/main/res/drawable/ic_notification_play.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_notification_play.svg | svg conversion | vector |
| ui/notifications/src/main/res/drawable/ic_notification_playback_speed.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_notification_playback_speed.svg | svg conversion | vector |
| ui/notifications/src/main/res/drawable/ic_notification_skip.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_notification_skip.svg | svg conversion | vector |
| ui/notifications/src/main/res/drawable/ic_notification_sleep.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_notification_sleep.svg | svg conversion | vector |
| ui/notifications/src/main/res/drawable/ic_notification_sleep_off.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_notification_sleep_off.svg | svg conversion | vector |
| ui/notifications/src/main/res/drawable/ic_notification_stream.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_notification_stream.svg | svg conversion | vector |
| ui/notifications/src/main/res/drawable/ic_notification_sync.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_notification_sync.svg | svg conversion | vector |
| ui/notifications/src/main/res/drawable/ic_notification_sync_error.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_notification_sync_error.svg | svg conversion | vector |
| ui/notifications/src/main/res/drawable-hdpi/ic_notification.png | Common | 项目内模块资源 | drawable | resources/ldpi/media/ic_notification.png | direct copy | Direct copy |
| ui/notifications/src/main/res/drawable-hdpi/ic_notification_new.png | Common | 项目内模块资源 | drawable | resources/ldpi/media/ic_notification_new.png | direct copy | Direct copy |
| ui/notifications/src/main/res/drawable-mdpi/ic_notification.png | Common | 项目内模块资源 | drawable | resources/mdpi/media/ic_notification.png | direct copy | Direct copy |
| ui/notifications/src/main/res/drawable-mdpi/ic_notification_new.png | Common | 项目内模块资源 | drawable | resources/mdpi/media/ic_notification_new.png | direct copy | Direct copy |
| ui/notifications/src/main/res/drawable-xhdpi/ic_notification.png | Common | 项目内模块资源 | drawable | resources/xldpi/media/ic_notification.png | direct copy | Direct copy |
| ui/notifications/src/main/res/drawable-xhdpi/ic_notification_new.png | Common | 项目内模块资源 | drawable | resources/xldpi/media/ic_notification_new.png | direct copy | Direct copy |
| ui/notifications/src/main/res/drawable-xxhdpi/ic_notification.png | Common | 项目内模块资源 | drawable | resources/xxldpi/media/ic_notification.png | direct copy | Direct copy |
| ui/notifications/src/main/res/drawable-xxhdpi/ic_notification_new.png | Common | 项目内模块资源 | drawable | resources/xxldpi/media/ic_notification_new.png | direct copy | Direct copy |
| ui/notifications/src/main/res/drawable-xxxhdpi/ic_notification.png | Common | 项目内模块资源 | drawable | resources/xxxldpi/media/ic_notification.png | direct copy | Direct copy |
| ui/notifications/src/main/res/drawable-xxxhdpi/ic_notification_new.png | Common | 项目内模块资源 | drawable | resources/xxxldpi/media/ic_notification_new.png | direct copy | Direct copy |
| ui/preferences/src/main/res/drawable-nodpi/gpodder_icon.png | Common | 项目内模块资源 | drawable | resources/base/media/gpodder_icon.png | direct copy | Direct copy |
| ui/preferences/src/main/res/drawable-nodpi/nextcloud_logo.png | Common | 项目内模块资源 | drawable | resources/base/media/nextcloud_logo.png | direct copy | Direct copy |
| ui/preferences/src/main/res/drawable-nodpi/theme_preview_dark.png | Common | 项目内模块资源 | drawable | resources/base/media/theme_preview_dark.png | direct copy | Direct copy |
| ui/preferences/src/main/res/drawable-nodpi/theme_preview_light.png | Common | 项目内模块资源 | drawable | resources/base/media/theme_preview_light.png | direct copy | Direct copy |
| ui/preferences/src/main/res/drawable-nodpi/theme_preview_system.png | Common | 项目内模块资源 | drawable | resources/base/media/theme_preview_system.png | direct copy | Direct copy |
| ui/preferences/src/main/res/layout/about_teaser.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/preferences/src/main/res/layout/alertdialog_sync_provider_chooser.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/preferences/src/main/res/layout/authentication_dialog.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/preferences/src/main/res/layout/bug_report_fragment.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/preferences/src/main/res/layout/choose_data_folder_dialog.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/preferences/src/main/res/layout/choose_data_folder_dialog_entry.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/preferences/src/main/res/layout/dialog_switch_preference.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/preferences/src/main/res/layout/gpodnetauth_credentials.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/preferences/src/main/res/layout/gpodnetauth_device.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/preferences/src/main/res/layout/gpodnetauth_device_row.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/preferences/src/main/res/layout/gpodnetauth_dialog.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/preferences/src/main/res/layout/gpodnetauth_finish.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/preferences/src/main/res/layout/gpodnetauth_host.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/preferences/src/main/res/layout/nextcloud_auth_dialog.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/preferences/src/main/res/layout/proxy_settings.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/preferences/src/main/res/layout/settings_activity.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/preferences/src/main/res/layout/simple_icon_list_item.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/preferences/src/main/res/layout/theme_preference.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/preferences/src/main/res/menu/bug_report_options.xml | Common | 项目内模块资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/preferences/src/main/res/values/arrays.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/preferences/src/main/res/values/keycodes.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/preferences/src/main/res/xml/preferences.xml | Common | 项目内模块资源 | xml | resources/rawfile/xml/preferences.xml | direct copy | profile conversion deferred |
| ui/preferences/src/main/res/xml/preferences_about.xml | Common | 项目内模块资源 | xml | resources/rawfile/xml/preferences_about.xml | direct copy | profile conversion deferred |
| ui/preferences/src/main/res/xml/preferences_auto_deletion.xml | Common | 项目内模块资源 | xml | resources/rawfile/xml/preferences_auto_deletion.xml | direct copy | profile conversion deferred |
| ui/preferences/src/main/res/xml/preferences_autodownload.xml | Common | 项目内模块资源 | xml | resources/rawfile/xml/preferences_autodownload.xml | direct copy | profile conversion deferred |
| ui/preferences/src/main/res/xml/preferences_downloads.xml | Common | 项目内模块资源 | xml | resources/rawfile/xml/preferences_downloads.xml | direct copy | profile conversion deferred |
| ui/preferences/src/main/res/xml/preferences_import_export.xml | Common | 项目内模块资源 | xml | resources/rawfile/xml/preferences_import_export.xml | direct copy | profile conversion deferred |
| ui/preferences/src/main/res/xml/preferences_notifications.xml | Common | 项目内模块资源 | xml | resources/rawfile/xml/preferences_notifications.xml | direct copy | profile conversion deferred |
| ui/preferences/src/main/res/xml/preferences_parental_control.xml | Common | 项目内模块资源 | xml | resources/rawfile/xml/preferences_parental_control.xml | direct copy | profile conversion deferred |
| ui/preferences/src/main/res/xml/preferences_playback.xml | Common | 项目内模块资源 | xml | resources/rawfile/xml/preferences_playback.xml | direct copy | profile conversion deferred |
| ui/preferences/src/main/res/xml/preferences_swipe.xml | Common | 项目内模块资源 | xml | resources/rawfile/xml/preferences_swipe.xml | direct copy | profile conversion deferred |
| ui/preferences/src/main/res/xml/preferences_synchronization.xml | Common | 项目内模块资源 | xml | resources/rawfile/xml/preferences_synchronization.xml | direct copy | profile conversion deferred |
| ui/preferences/src/main/res/xml/preferences_user_interface.xml | Common | 项目内模块资源 | xml | resources/rawfile/xml/preferences_user_interface.xml | direct copy | profile conversion deferred |
| ui/statistics/src/main/res/layout/feed_statistics.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/statistics/src/main/res/layout/feed_statistics_card.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/statistics/src/main/res/layout/feed_statistics_dialog.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/statistics/src/main/res/layout/statistics_filter_dialog.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/statistics/src/main/res/layout/statistics_fragment.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/statistics/src/main/res/layout/statistics_listitem.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/statistics/src/main/res/layout/statistics_listitem_barchart.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/statistics/src/main/res/layout/statistics_listitem_total.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/statistics/src/main/res/layout/statistics_year_listitem.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/statistics/src/main/res/menu/statistics.xml | Common | 项目内模块资源 | menu | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/widget/src/main/res/drawable/ic_widget_fast_forward.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_widget_fast_forward.svg | svg conversion | vector |
| ui/widget/src/main/res/drawable/ic_widget_fast_rewind.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_widget_fast_rewind.svg | svg conversion | vector |
| ui/widget/src/main/res/drawable/ic_widget_pause.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_widget_pause.svg | svg conversion | vector |
| ui/widget/src/main/res/drawable/ic_widget_play.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_widget_play.svg | svg conversion | vector |
| ui/widget/src/main/res/drawable/ic_widget_playback_speed.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_widget_playback_speed.svg | svg conversion | vector |
| ui/widget/src/main/res/drawable/ic_widget_skip.xml | Common | 项目内模块资源 | drawable | resources/base/media/ic_widget_skip.svg | svg conversion | vector |
| ui/widget/src/main/res/drawable-hdpi/ic_widget_preview.png | Common | 项目内模块资源 | drawable | resources/ldpi/media/ic_widget_preview.png | direct copy | Direct copy |
| ui/widget/src/main/res/layout/activity_widget_config.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/widget/src/main/res/layout/player_widget.xml | Common | 项目内模块资源 | layout | N/A | unmappable | ArkUI declarative; deps scanned |
| ui/widget/src/main/res/values/dimens.xml | Common | 项目内模块资源 | values | N/A | unmappable | resources |
| ui/widget/src/main/res/xml/player_widget_info.xml | Common | 项目内模块资源 | xml | resources/rawfile/xml/player_widget_info.xml | direct copy | profile conversion deferred |

## 4. 未映射 / 不可映射 / 系统 / 远程资源汇总

### 4.1 不可映射 (无 HarmonyOS 等价物)

- **layout has no HarmonyOS equivalent (ArkUI declarative)** — 117 项。示例: app/src/main/res/layout/addfeed.xml, app/src/main/res/layout/audio_controls.xml, app/src/main/res/layout/audioplayer_fragment.xml
- **<resources> not convertible** — 78 项。示例: app-wearos/src/main/res/values/wear.xml, app/src/main/res/values/attrs.xml, app/src/main/res/values/design_time_attributes.xml
- **<item> has no HarmonyOS equivalent** — 51 项。示例: app/src/main/res/values/ids.xml#item/select_all_item, app/src/main/res/values/ids.xml#item/deselect_all_item, app/src/main/res/values/ids.xml#item/clear_history_item
- **<style> has no HarmonyOS equivalent** — 40 项。示例: ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Dynamic.Light, ui/common/src/main/res/values/styles.xml#style/Theme.Base.AntennaPod.Dynamic.Light, ui/common/src/main/res/values/styles.xml#style/Theme.AntennaPod.Light
- **menu has no HarmonyOS equivalent (ArkUI declarative)** — 27 项。示例: app/src/main/res/menu/download_log.xml, app/src/main/res/menu/downloads_completed.xml, app/src/main/res/menu/episodes.xml
- **<attr> has no HarmonyOS equivalent** — 11 项。示例: ui/common/src/main/res/values/attrs.xml#attr/dragview_background, ui/common/src/main/res/values/attrs.xml#attr/action_icon_color, ui/common/src/main/res/values/attrs.xml#attr/scrollbar_thumb
- **anim has no HarmonyOS equivalent** — 6 项。示例: ui/common/src/main/res/anim/fade_in.xml, ui/common/src/main/res/anim/fade_out.xml, ui/common/src/main/res/anim/slide_left_in.xml
- **<declare-styleable> has no HarmonyOS equivalent** — 4 项。示例: app/src/main/res/values/attrs.xml#declare-styleable/NestedScrollableHost, ui/common/src/main/res/values/styleable.xml#declare-styleable/SquareImageView, ui/common/src/main/res/values/styleable.xml#declare-styleable/CircularProgressBar
- **Unsupported qualifier dir skipped** — 4 项。示例: app/src/main/res/values-sw360dp/resource-overrides.xml, app/src/main/res/values-sw600dp/integers.xml, app/src/main/res/values-w1000dp/dimens.xml
- **<inset> has no direct SVG equivalent** — 2 项。示例: app/src/main/res/drawable/bg_episode_list_item.xml, ui/common/src/main/res/drawable/ic_shortcut_background.xml
- **<ripple> has no direct SVG equivalent** — 2 项。示例: app/src/main/res/drawable/grey_border.xml, ui/common/src/main/res/drawable/bg_drawer_item.xml
- **<animated-vector> has no direct SVG equivalent** — 2 项。示例: app/src/main/res/drawable/ic_animate_pause_play.xml, app/src/main/res/drawable/ic_animate_play_pause.xml
- **color state list unmappable** — 1 项。示例: ui/common/src/main/res/color/button_bg_selector.xml
- **<animation-list> not convertible** — 1 项。示例: ui/common/src/main/res/drawable/launcher_animate.xml

### 4.2 不支持的 qualifier 目录 (整目录跳过)

- `app/src/main/res/values-sw360dp` — qualifier `sw360dp` — Unsupported qualifier: no HarmonyOS equivalent
- `app/src/main/res/values-sw600dp` — qualifier `sw600dp` — Unsupported qualifier: no HarmonyOS equivalent
- `app/src/main/res/values-w1000dp` — qualifier `w1000dp` — Unsupported qualifier: no HarmonyOS equivalent
- `app/src/main/res/values-w300dp` — qualifier `w300dp` — Unsupported qualifier: no HarmonyOS equivalent
- `app/src/main/res/values-sw360dp` — qualifier `sw360dp` — Unsupported qualifier: no HarmonyOS equivalent
- `app/src/main/res/values-sw600dp` — qualifier `sw600dp` — Unsupported qualifier: no HarmonyOS equivalent
- `app/src/main/res/values-w1000dp` — qualifier `w1000dp` — Unsupported qualifier: no HarmonyOS equivalent
- `app/src/main/res/values-w300dp` — qualifier `w300dp` — Unsupported qualifier: no HarmonyOS equivalent

### 4.3 Android 系统资源 (@android:*)

- 所有 `@android:color/*`、`@android:dimen/*` 引用已在转换时解析为具体值 (见转换报告 "System Resources Resolved")，未在输出中保留任何 `@android:` 引用。
- 解析的系统资源引用数: 0

### 4.4 第三方库资源 (源码 res/ 回退，缺失)

- 由于 APK 构建失败，Material Components / AndroidX AppCompat / AndroidX Preference / ConstraintLayout 等库自带资源未包含。布局/菜单中引用这些库资源的依赖被标记为 unsatisfied。建议修复 `JAVA_HOME` 后重新构建 APK 获取完整资源。

### 4.5 运行时远程资源

- AntennaPod 节目封面、订阅图标等均为运行时从网络加载 (Glide/网络图片)，不属于 `res/` 静态资源，未参与转换。

## 5. 关键发现 (Quick Findings)

- 启动器图标来自 `ui/common/src/main/res/mipmap-anydpi-v26/ic_launcher.xml` (adaptive-icon)，background/foreground 均为 `@mipmap/*` PNG 引用 → 已转为 `ic_launcher_layered_image.json`；各密度的 `ic_launcher.png`/`ic_launcher_foreground.png`/`ic_launcher_background.png`/`ic_launcher_monochrome.png` 已按密度映射拷贝。注意: HarmonyOS 工程模板已自带 `layered_image.json`/`foreground.png`/`background.png` 并被 `AppScope/app.json5` 引用，本次转换**未覆盖**这些模板资源；如需使用 AntennaPod 真实图标，请把 `app.json5` 的 `$media:layered_image` 改为 `$media:ic_launcher_layered_image` 等并替换前景/背景。
- `app/src/main/res/drawable-anydpi-v26/ic_shortcut_*.xml` (4 个快捷方式 adaptive-icon) 的 background 为 `@color/grey100` (#f5f5f5) → 已生成 `grey100_bg.png` 实色 PNG 作为 layered-image 背景。
- `ui/common/src/main/res/drawable/` 共 111 个 XML drawable (大量 vector 图标)，多数 `fillColor` 使用主题属性 `?attr/action_icon_color` (运行时着色) → SVG 中解析为黑色 (`#000000`)，图标以黑色剪影呈现，需在 ArkUI 代码中按主题重新着色。
- 52 种语言的翻译 (`ui/i18n/src/main/res/values-XX/strings.xml`) 已按 HarmonyOS 语言 qualifier 全量转换 (如 `values-zh-rCN` → `zh_CN/element/string.json`)。
- 屏幕宽度 qualifier 目录 (`values-sw600dp`/`values-w1000dp`/`values-w300dp`/`values-sw360dp`、`layout-sw720dp`) 已按规则整目录跳过 (HarmonyOS 无对应能力)。
- `app/values/svg.xml`、`attrs.xml`、`ids.xml`、`design_time_attributes.xml` 与 `ui/common/values/styles.xml`、`attrs.xml`、`styleable.xml` 含 `<style>`/`<attr>`/`<declare-styleable>`/`<public>`/`<item>` 等条目，HarmonyOS 无等价物，记为不可映射。
- 本次为源码 res/ 回退转换: 布局/菜单中引用 Material/AndroidX 库资源的依赖 (如 `@style/Widget.Material*`、`@color/material_*`、`@dimen/m3_*`) 无法在源码中解析，已在报告中列出。