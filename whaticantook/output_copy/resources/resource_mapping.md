# Android Resources ↔ HarmonyOS Resources Mapping

## 1. 元数据 (Metadata)

- **Android 项目路径**: `/Users/bb/work/hometrans/whaticantook/whaticancook`
- **HarmonyOS 项目输出路径**: `/Users/bb/work/hometrans/whaticantook/input/whaticancookHarmony`
- **资源来源 (Resource Source)**: decompiled APK (完整合并资源集，含第三方库依赖)
- **资源来源路径**: `decompiled APK -> res/` (由 apktool 3.0.1 反编译自 `app-debug.apk`)
- **构建结果 (Build Result)**: 跳过 Gradle 构建 (直接使用提供的 APK); APK 反编译成功
- **生成时间 (Generation Timestamp)**: 2026-07-02 11:29:50
- **Android 包名**: `com.whaticancook.app`

> 说明：本项目为 Jetpack Compose 应用，自身资源极少 (`app_name`、品牌色、启动器矢量图标、字体)。反编译 APK 中绝大多数资源 (通知图标、`m3c_*`/`call_notification_*`/`splashscreen_*` 等) 来自 AndroidX / Material / SplashScreen 等第三方库，本映射按来源类别完整记录。

## 2. Android 资源清单 (Android Resource Inventory)

### 2.1 应用自身资源 (应用模块 `app/src/main/res/` 定义)

| Android Resource Path | Resource Name | Function | Screen(s) | Source Category | Type Category | Status | Notes |
|---|---|---|---|---|---|---|---|
| res/drawable/ic_launcher_background.xml | ic_launcher_background | 启动器图标背景层 | Launcher | 应用自身资源 | drawable | converted | XML drawable vector -> SVG |
| res/drawable/ic_launcher_foreground.xml | ic_launcher_foreground | 启动器图标前景层 | Launcher | 应用自身资源 | drawable | converted | XML drawable vector -> SVG |
| res/drawable/ic_splash_logo.xml | ic_splash_logo | 闪屏 Logo | Unknown | 应用自身资源 | drawable | converted | XML drawable vector -> SVG |
| res/font/plus_jakarta_sans.ttf | plus_jakarta_sans | 应用字体 Plus Jakarta Sans | Global | 应用自身资源 | font | converted | font -> rawfile/fonts |
| res/mipmap-anydpi/ic_launcher.xml | ic_launcher | 启动器图标 (adaptive icon) | Launcher | 应用自身资源 | mipmap | converted | background=@drawable/ic_launcher_background foreground=@drawable/ic_launcher_foreground (monochrome omitted from JSON) |
| res/mipmap-anydpi/ic_launcher_round.xml | ic_launcher_round | 启动器图标 (adaptive icon) | Launcher | 应用自身资源 | mipmap | converted | background=@drawable/ic_launcher_background foreground=@drawable/ic_launcher_foreground (monochrome omitted from JSON) |
| res/values/colors.xml | black | 颜色资源 | Global | 应用自身资源 | values | converted | color entry |
| res/values/colors.xml | brand_primary | 品牌色brand_primary | Global | 应用自身资源 | values | converted | color entry |
| res/values/colors.xml | brand_surface | 品牌色brand_surface | Global | 应用自身资源 | values | converted | color entry |
| res/values/colors.xml | white | 颜色资源 | Global | 应用自身资源 | values | converted | color entry |
| res/values/strings.xml | app_name | 应用名称 | Launcher | 应用自身资源 | values | converted | string entry |

### 2.2 基础 values 资源 (默认 `res/values/`，含第三方库条目，按条目粒度)

| Android Resource Path | Resource Name | Function | Screen(s) | Source Category | Type Category | Status | Notes |
|---|---|---|---|---|---|---|---|
| res/values/attrs.xml | attrs.xml | 资源 (依名称推断) | Unknown | 第三方库资源（推断） | values | unmappable | attrs.xml has no HarmonyOS element equivalent |
| res/values/colors.xml | androidx_core_ripple_material_light | 颜色资源 | Common | 第三方库资源 | values | converted | color entry |
| res/values/colors.xml | androidx_core_secondary_text_default_material_light | 颜色资源 | Common | 第三方库资源 | values | converted | color entry |
| res/values/colors.xml | call_notification_answer_color | 颜色资源 | Notification | 第三方库资源 | values | converted | color entry |
| res/values/colors.xml | call_notification_decline_color | 颜色资源 | Notification | 第三方库资源 | values | converted | color entry |
| res/values/colors.xml | notification_action_color_filter | 颜色资源 | Notification | 第三方库资源 | values | converted | color entry |
| res/values/colors.xml | notification_icon_bg_color | 颜色资源 | Notification | 第三方库资源 | values | converted | color entry |
| res/values/dimens.xml | compat_button_inset_horizontal_material | 尺寸资源 | Common | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | compat_button_inset_vertical_material | 尺寸资源 | Common | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | compat_button_padding_horizontal_material | 尺寸资源 | Common | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | compat_button_padding_vertical_material | 尺寸资源 | Common | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | compat_control_corner_material | 尺寸资源 | Common | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | compat_notification_large_icon_max_height | 尺寸资源 | Common | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | compat_notification_large_icon_max_width | 尺寸资源 | Common | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | notification_action_icon_size | 尺寸资源 | Notification | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | notification_action_text_size | 尺寸资源 | Notification | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | notification_big_circle_margin | 尺寸资源 | Notification | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | notification_content_margin_start | 尺寸资源 | Notification | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | notification_large_icon_height | 尺寸资源 | Notification | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | notification_large_icon_width | 尺寸资源 | Notification | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | notification_main_column_padding_top | 尺寸资源 | Notification | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | notification_media_narrow_margin | 尺寸资源 | Notification | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | notification_right_icon_size | 尺寸资源 | Notification | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | notification_right_side_padding_top | 尺寸资源 | Notification | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | notification_small_icon_background_padding | 尺寸资源 | Notification | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | notification_small_icon_size_as_large | 尺寸资源 | Notification | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | notification_subtext_size | 尺寸资源 | Notification | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | notification_top_pad | 尺寸资源 | Notification | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | notification_top_pad_large_text | 尺寸资源 | Notification | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | splashscreen_icon_mask_size_no_background | 尺寸资源 | SplashScreen | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | splashscreen_icon_mask_size_with_background | 尺寸资源 | SplashScreen | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | splashscreen_icon_mask_stroke_no_background | 尺寸资源 | SplashScreen | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | splashscreen_icon_mask_stroke_with_background | 尺寸资源 | SplashScreen | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | splashscreen_icon_size | 尺寸资源 | SplashScreen | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | splashscreen_icon_size_no_background | 尺寸资源 | SplashScreen | 第三方库资源 | values | converted | dimen entry |
| res/values/dimens.xml | splashscreen_icon_size_with_background | 尺寸资源 | SplashScreen | 第三方库资源 | values | converted | dimen entry |
| res/values/drawables.xml | notification_template_icon_bg | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | values | converted | color drawable from drawables.xml |
| res/values/drawables.xml | notification_template_icon_low_bg | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | values | converted | color drawable from drawables.xml |
| res/values/ids.xml | ids.xml | 资源 (依名称推断) | Unknown | 第三方库资源（推断） | values | unmappable | ids.xml has no HarmonyOS element equivalent |
| res/values/integers.xml | default_icon_animation_duration | integer 资源 | Unknown | 第三方库资源（推断） | values | converted | integer entry (JSON number) |
| res/values/integers.xml | m3c_window_layout_in_display_cutout_mode | integer 资源 | Common | 第三方库资源 | values | converted | integer entry (JSON number) |
| res/values/integers.xml | status_bar_notification_info_maxnum | integer 资源 | Common | 第三方库资源 | values | converted | integer entry (JSON number) |
| res/values/public.xml | public.xml | 资源 (依名称推断) | Unknown | 第三方库资源（推断） | values | unmappable | public.xml has no HarmonyOS element equivalent |
| res/values/strings.xml | androidx_startup | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | autofill | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | call_notification_answer_action | 字符串资源 | Notification | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | call_notification_answer_video_action | 字符串资源 | Notification | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | call_notification_decline_action | 字符串资源 | Notification | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | call_notification_hang_up_action | 字符串资源 | Notification | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | call_notification_incoming_text | 字符串资源 | Notification | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | call_notification_ongoing_text | 字符串资源 | Notification | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | call_notification_screening_text | 字符串资源 | Notification | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | close_drawer | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | close_sheet | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | default_error_message | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | default_popup_window_title | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | dropdown_menu | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | in_progress | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | indeterminate | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | m3c_bottom_sheet_collapse_description | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_bottom_sheet_dismiss_description | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_bottom_sheet_drag_handle_description | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_bottom_sheet_expand_description | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_bottom_sheet_pane_title | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_input_headline | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_input_headline_description | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_input_invalid_for_pattern | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_input_invalid_not_allowed | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_input_invalid_year_range | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_input_label | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_input_no_input_description | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_input_title | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_picker_headline | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_picker_headline_description | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_picker_navigate_to_year_description | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_picker_no_selection_description | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_picker_scroll_to_earlier_years | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_picker_scroll_to_later_years | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_picker_switch_to_calendar_mode | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_picker_switch_to_day_selection | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_picker_switch_to_input_mode | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_picker_switch_to_next_month | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_picker_switch_to_previous_month | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_picker_switch_to_year_selection | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_picker_title | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_picker_today_description | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_picker_year_picker_pane_title | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_range_input_invalid_range_input | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_range_input_title | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_range_picker_day_in_range | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_range_picker_end_headline | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_range_picker_scroll_to_next_month | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_range_picker_scroll_to_previous_month | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_range_picker_start_headline | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_date_range_picker_title | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_dialog | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_dropdown_menu_collapsed | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_dropdown_menu_expanded | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_dropdown_menu_toggle | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_floating_toolbar_collapse | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_floating_toolbar_expand | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_search_bar_search | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_snackbar_dismiss | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_snackbar_pane_title | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_suggestions_available | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_time_input_dialog_title | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_time_picker_am | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_time_picker_dialog_title | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_time_picker_hour | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_time_picker_hour_24h_suffix | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_time_picker_hour_selection | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_time_picker_hour_suffix | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_time_picker_hour_text_field | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_time_picker_minute | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_time_picker_minute_selection | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_time_picker_minute_suffix | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_time_picker_minute_text_field | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_time_picker_period_toggle_description | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_time_picker_pm | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_time_picker_toggle_keyboard | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_time_picker_toggle_touch | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_tooltip_long_press_label | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_tooltip_pane_description | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_wide_navigation_rail_close_rail | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | m3c_wide_navigation_rail_pane_title | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | mc2_snackbar_pane_title | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | navigation_menu | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | not_selected | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | range_end | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | range_start | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | selected | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | snackbar_pane_title | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | state_empty | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | state_off | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | state_on | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | status_bar_notification_info_overflow | 字符串资源 | Common | 第三方库资源 | values | converted | string entry |
| res/values/strings.xml | switch_role | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | tab | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | template_percent | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | tooltip_description | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/strings.xml | tooltip_label | 字符串资源 | Unknown | 第三方库资源（推断） | values | converted | string entry |
| res/values/styles.xml | styles.xml | 资源 (依名称推断) | Unknown | 第三方库资源（推断） | values | unmappable | styles.xml has no HarmonyOS element equivalent |

### 2.3 媒体 / 字体 / raw 资源 (drawable / mipmap / font / raw)

| Android Resource Path | Resource Name | Function | Screen(s) | Source Category | Type Category | Status | Notes |
|---|---|---|---|---|---|---|---|
| res/drawable/$ic_launcher_background__0.xml | $ic_launcher_background__0 | 资源 (依名称推断) | Unknown | 第三方库资源（推断） | drawable | unmappable | unrecognized XML drawable |
| res/drawable/compat_splash_screen.xml | compat_splash_screen | Drawable 资源 (layer-list) | SplashScreen | 第三方库资源 | drawable | converted | XML drawable layer-list -> SVG |
| res/drawable/compat_splash_screen_no_icon_background.xml | compat_splash_screen_no_icon_background | Drawable 资源 (layer-list) | SplashScreen | 第三方库资源 | drawable | converted | XML drawable layer-list -> SVG |
| res/drawable/ic_call_answer.xml | ic_call_answer | Drawable 资源 (vector) | Unknown | 第三方库资源（推断） | drawable | converted | XML drawable vector -> SVG |
| res/drawable/ic_call_answer_low.xml | ic_call_answer_low | Drawable 资源 (vector) | Unknown | 第三方库资源（推断） | drawable | converted | XML drawable vector -> SVG |
| res/drawable/ic_call_answer_video.xml | ic_call_answer_video | Drawable 资源 (vector) | Unknown | 第三方库资源（推断） | drawable | converted | XML drawable vector -> SVG |
| res/drawable/ic_call_answer_video_low.xml | ic_call_answer_video_low | Drawable 资源 (vector) | Unknown | 第三方库资源（推断） | drawable | converted | XML drawable vector -> SVG |
| res/drawable/ic_call_decline.xml | ic_call_decline | Drawable 资源 (vector) | Unknown | 第三方库资源（推断） | drawable | converted | XML drawable vector -> SVG |
| res/drawable/ic_call_decline_low.xml | ic_call_decline_low | Drawable 资源 (vector) | Unknown | 第三方库资源（推断） | drawable | converted | XML drawable vector -> SVG |
| res/drawable/ic_launcher_background.xml | ic_launcher_background | 启动器图标背景层 | Launcher | 应用自身资源 | drawable | converted | XML drawable vector -> SVG |
| res/drawable/ic_launcher_foreground.xml | ic_launcher_foreground | 启动器图标前景层 | Launcher | 应用自身资源 | drawable | converted | XML drawable vector -> SVG |
| res/drawable/ic_splash_logo.xml | ic_splash_logo | 闪屏 Logo | Unknown | 应用自身资源 | drawable | converted | XML drawable vector -> SVG |
| res/drawable/icon_background.xml | icon_background | Drawable 资源 (shape) | Launcher | 第三方库资源（推断） | drawable | converted | XML drawable shape -> SVG |
| res/drawable/notification_action_background.xml | notification_action_background | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | drawable | unmappable | ripple has no SVG equivalent (runtime behavior) |
| res/drawable/notification_bg.xml | notification_bg | Drawable 资源 (selector) | Notification | 第三方库资源 | drawable | converted | XML drawable selector -> SVG |
| res/drawable/notification_bg_low.xml | notification_bg_low | Drawable 资源 (selector) | Notification | 第三方库资源 | drawable | converted | XML drawable selector -> SVG |
| res/drawable/notification_icon_background.xml | notification_icon_background | Drawable 资源 (shape) | Notification | 第三方库资源 | drawable | converted | XML drawable shape -> SVG |
| res/drawable/notification_tile_bg.xml | notification_tile_bg | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | drawable | unmappable | unrecognized XML drawable |
| res/drawable-hdpi/notification_bg_low_normal.9.png | notification_bg_low_normal | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | drawable | converted | 9-patch renamed; stretching behavior lost |
| res/drawable-hdpi/notification_bg_low_pressed.9.png | notification_bg_low_pressed | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | drawable | converted | 9-patch renamed; stretching behavior lost |
| res/drawable-hdpi/notification_bg_normal.9.png | notification_bg_normal | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | drawable | converted | 9-patch renamed; stretching behavior lost |
| res/drawable-hdpi/notification_bg_normal_pressed.9.png | notification_bg_normal_pressed | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | drawable | converted | 9-patch renamed; stretching behavior lost |
| res/drawable-hdpi/notification_oversize_large_icon_bg.png | notification_oversize_large_icon_bg | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | drawable | converted | image copy |
| res/drawable-hdpi/notify_panel_notification_icon_bg.png | notify_panel_notification_icon_bg | 资源 (依名称推断) | Unknown | 第三方库资源（推断） | drawable | converted | image copy |
| res/drawable-mdpi/notification_bg_low_normal.9.png | notification_bg_low_normal | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | drawable | converted | 9-patch renamed; stretching behavior lost |
| res/drawable-mdpi/notification_bg_low_pressed.9.png | notification_bg_low_pressed | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | drawable | converted | 9-patch renamed; stretching behavior lost |
| res/drawable-mdpi/notification_bg_normal.9.png | notification_bg_normal | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | drawable | converted | 9-patch renamed; stretching behavior lost |
| res/drawable-mdpi/notification_bg_normal_pressed.9.png | notification_bg_normal_pressed | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | drawable | converted | 9-patch renamed; stretching behavior lost |
| res/drawable-mdpi/notify_panel_notification_icon_bg.png | notify_panel_notification_icon_bg | 资源 (依名称推断) | Unknown | 第三方库资源（推断） | drawable | converted | image copy |
| res/drawable-xhdpi/notification_bg_low_normal.9.png | notification_bg_low_normal | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | drawable | converted | 9-patch renamed; stretching behavior lost |
| res/drawable-xhdpi/notification_bg_low_pressed.9.png | notification_bg_low_pressed | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | drawable | converted | 9-patch renamed; stretching behavior lost |
| res/drawable-xhdpi/notification_bg_normal.9.png | notification_bg_normal | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | drawable | converted | 9-patch renamed; stretching behavior lost |
| res/drawable-xhdpi/notification_bg_normal_pressed.9.png | notification_bg_normal_pressed | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | drawable | converted | 9-patch renamed; stretching behavior lost |
| res/drawable-xhdpi/notify_panel_notification_icon_bg.png | notify_panel_notification_icon_bg | 资源 (依名称推断) | Unknown | 第三方库资源（推断） | drawable | converted | image copy |
| res/font/plus_jakarta_sans.ttf | plus_jakarta_sans | 应用字体 Plus Jakarta Sans | Global | 应用自身资源 | font | converted | font -> rawfile/fonts |
| res/mipmap-anydpi/ic_launcher.xml | ic_launcher | 启动器图标 (adaptive icon) | Launcher | 应用自身资源 | mipmap | converted | background=@drawable/ic_launcher_background foreground=@drawable/ic_launcher_foreground (monochrome omitted from JSON) |
| res/mipmap-anydpi/ic_launcher.xml | ic_launcher#monochrome | 资源 (依名称推断) | Unknown | 第三方库资源（推断） | mipmap | unmappable | monochrome references @drawable/ic_launcher_foreground; no layered-image equivalent |
| res/mipmap-anydpi/ic_launcher_round.xml | ic_launcher_round | 启动器图标 (adaptive icon) | Launcher | 应用自身资源 | mipmap | converted | background=@drawable/ic_launcher_background foreground=@drawable/ic_launcher_foreground (monochrome omitted from JSON) |
| res/mipmap-anydpi/ic_launcher_round.xml | ic_launcher_round#monochrome | 资源 (依名称推断) | Unknown | 第三方库资源（推断） | mipmap | unmappable | monochrome references @drawable/ic_launcher_foreground; no layered-image equivalent |

### 2.4 不可映射资源 (layout / menu / anim / animator / styles / attrs 等)

| Android Resource Path | Resource Name | Function | Screen(s) | Source Category | Type Category | Status | Notes |
|---|---|---|---|---|---|---|---|
| res/anim/fragment_fast_out_extra_slow_in.xml | fragment_fast_out_extra_slow_in | 资源 (依名称推断) | Unknown | 第三方库资源（推断） | anim | unmappable | anim has no direct HarmonyOS equivalent |
| res/animator/fragment_close_enter.xml | fragment_close_enter | 资源 (依名称推断) | Unknown | 第三方库资源（推断） | animator | unmappable | animator has no direct HarmonyOS equivalent |
| res/animator/fragment_close_exit.xml | fragment_close_exit | 资源 (依名称推断) | Unknown | 第三方库资源（推断） | animator | unmappable | animator has no direct HarmonyOS equivalent |
| res/animator/fragment_fade_enter.xml | fragment_fade_enter | 资源 (依名称推断) | Unknown | 第三方库资源（推断） | animator | unmappable | animator has no direct HarmonyOS equivalent |
| res/animator/fragment_fade_exit.xml | fragment_fade_exit | 资源 (依名称推断) | Unknown | 第三方库资源（推断） | animator | unmappable | animator has no direct HarmonyOS equivalent |
| res/animator/fragment_open_enter.xml | fragment_open_enter | 资源 (依名称推断) | Unknown | 第三方库资源（推断） | animator | unmappable | animator has no direct HarmonyOS equivalent |
| res/animator/fragment_open_exit.xml | fragment_open_exit | 资源 (依名称推断) | Unknown | 第三方库资源（推断） | animator | unmappable | animator has no direct HarmonyOS equivalent |
| res/color/vector_tint_color.xml | vector_tint_color | 颜色资源 | Unknown | 第三方库资源（推断） | color | unmappable | color has no direct HarmonyOS equivalent |
| res/color/vector_tint_theme_color.xml | vector_tint_theme_color | 颜色资源 | Unknown | 第三方库资源（推断） | color | unmappable | color has no direct HarmonyOS equivalent |
| res/layout/custom_dialog.xml | custom_dialog | 资源 (依名称推断) | Unknown | 第三方库资源（推断） | layout | unmappable | layout has no direct HarmonyOS equivalent |
| res/layout/ime_base_split_test_activity.xml | ime_base_split_test_activity | 资源 (依名称推断) | Unknown | 第三方库资源（推断） | layout | unmappable | layout has no direct HarmonyOS equivalent |
| res/layout/ime_secondary_split_test_activity.xml | ime_secondary_split_test_activity | 资源 (依名称推断) | Unknown | 第三方库资源（推断） | layout | unmappable | layout has no direct HarmonyOS equivalent |
| res/layout/notification_action.xml | notification_action | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | layout | unmappable | layout has no direct HarmonyOS equivalent |
| res/layout/notification_action_tombstone.xml | notification_action_tombstone | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | layout | unmappable | layout has no direct HarmonyOS equivalent |
| res/layout/notification_template_custom_big.xml | notification_template_custom_big | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | layout | unmappable | layout has no direct HarmonyOS equivalent |
| res/layout/notification_template_icon_group.xml | notification_template_icon_group | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | layout | unmappable | layout has no direct HarmonyOS equivalent |
| res/layout/notification_template_part_chronometer.xml | notification_template_part_chronometer | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | layout | unmappable | layout has no direct HarmonyOS equivalent |
| res/layout/notification_template_part_time.xml | notification_template_part_time | 第三方库 androidx.core:core 资源 | Notification | 第三方库资源 | layout | unmappable | layout has no direct HarmonyOS equivalent |
| res/layout/splash_screen_view.xml | splash_screen_view | 资源 (依名称推断) | Unknown | 第三方库资源（推断） | layout | unmappable | layout has no direct HarmonyOS equivalent |

### 2.5 各语言/限定符 values 变体 (第三方库字符串翻译，按文件汇总)

Android 端 `values-<locale>/strings.xml` 为第三方库 (Material `m3c_*`、AndroidX 通知/通话字符串等) 的本地化翻译，与 2.2 节基础条目同名一一对应。每个 locale 文件汇总为一行，避免重复罗列数千条同名翻译。

| Android Resource File | 条目数 | Source Category | Type Category | Status | Notes |
|---|---|---|---|---|---|
| res/values-af/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-am/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-ar/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-as/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-az/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-b+sr+Latn/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-be/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-bg/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-bn/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-bs/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-ca/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-cs/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-da/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-de/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-el/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-en-rAU/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-en-rCA/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-en-rGB/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-en-rIN/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-en-rXC/strings.xml | 90 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-es-rUS/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-es/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-et/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-eu/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-fa/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-fi/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-fr-rCA/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-fr/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-gl/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-gu/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-hi/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-hr/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-hu/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-hy/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-in/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-is/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-it/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-iw/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-ja/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-ka/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-kk/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-km/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-kn/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-ko/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-ky/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-lo/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-lt/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-lv/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-mk/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-ml/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-mn/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-mr/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-ms/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-my/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-nb/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-ne/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-night/styles.xml | 1 | 第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-nl/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-or/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-pa/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-pl/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-pt-rBR/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-pt-rPT/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-pt/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-ro/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-ru/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-si/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-sk/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-sl/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-sq/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-sr/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-sv/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-sw/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-ta/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-te/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-th/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-tl/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-tr/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-uk/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-ur/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-uz/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-v27/styles.xml | 1 | 第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-v28/styles.xml | 1 | 第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-v29/styles.xml | 1 | 第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-v30/integers.xml | 1 | 第三方库资源 | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-v31/styles.xml | 1 | 第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-vi/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-watch/dimens.xml | 6 | 第三方库资源 | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-zh-rCN/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-zh-rHK/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-zh-rTW/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |
| res/values-zu/strings.xml | 97 | 第三方库资源/第三方库资源（推断） | values | converted | 库字符串本地化翻译，已写入对应 `<locale>/element/string.json` |

## 3. Android → HarmonyOS 映射详情 (Mapping Details)

### 3.1 应用自身资源映射

| Android Resource Path | Android Screen(s) | Android Source Category | Android Type Category | HarmonyOS Target | Mapping Kind | Notes |
|---|---|---|---|---|---|---|
| res/drawable/ic_launcher_background.xml | Launcher | 应用自身资源 | drawable | resources/base/media/ic_launcher_background.svg | svg conversion | XML drawable vector -> SVG |
| res/drawable/ic_launcher_foreground.xml | Launcher | 应用自身资源 | drawable | resources/base/media/ic_launcher_foreground.svg | svg conversion | XML drawable vector -> SVG |
| res/drawable/ic_splash_logo.xml | Unknown | 应用自身资源 | drawable | resources/base/media/ic_splash_logo.svg | svg conversion | XML drawable vector -> SVG |
| res/font/plus_jakarta_sans.ttf | Global | 应用自身资源 | font | resources/rawfile/fonts/plus_jakarta_sans.ttf | direct copy | font -> rawfile/fonts |
| res/mipmap-anydpi/ic_launcher.xml | Launcher | 应用自身资源 | mipmap | resources/base/media/ic_launcher_layered_image.json | layered-image conversion | background=@drawable/ic_launcher_background foreground=@drawable/ic_launcher_foreground (monochrome omitted from JSON) |
| res/mipmap-anydpi/ic_launcher_round.xml | Launcher | 应用自身资源 | mipmap | resources/base/media/ic_launcher_round_layered_image.json | layered-image conversion | background=@drawable/ic_launcher_background foreground=@drawable/ic_launcher_foreground (monochrome omitted from JSON) |
| res/values/colors.xml | Global | 应用自身资源 | values | resources/base/element/color.json#black | merged into json | color entry |
| res/values/colors.xml | Global | 应用自身资源 | values | resources/base/element/color.json#brand_primary | merged into json | color entry |
| res/values/colors.xml | Global | 应用自身资源 | values | resources/base/element/color.json#brand_surface | merged into json | color entry |
| res/values/colors.xml | Global | 应用自身资源 | values | resources/base/element/color.json#white | merged into json | color entry |
| res/values/strings.xml | Launcher | 应用自身资源 | values | resources/base/element/string.json#app_name | merged into json | string entry |

### 3.2 基础 values / 媒体资源映射

| Android Resource Path | Android Screen(s) | Android Source Category | Android Type Category | HarmonyOS Target | Mapping Kind | Notes |
|---|---|---|---|---|---|---|
| res/drawable/$ic_launcher_background__0.xml | Unknown | 第三方库资源（推断） | drawable | N/A | unmappable | unrecognized XML drawable |
| res/drawable/compat_splash_screen.xml | SplashScreen | 第三方库资源 | drawable | resources/base/media/compat_splash_screen.svg | svg conversion | XML drawable layer-list -> SVG |
| res/drawable/compat_splash_screen_no_icon_background.xml | SplashScreen | 第三方库资源 | drawable | resources/base/media/compat_splash_screen_no_icon_background.svg | svg conversion | XML drawable layer-list -> SVG |
| res/drawable/ic_call_answer.xml | Unknown | 第三方库资源（推断） | drawable | resources/base/media/ic_call_answer.svg | svg conversion | XML drawable vector -> SVG |
| res/drawable/ic_call_answer_low.xml | Unknown | 第三方库资源（推断） | drawable | resources/base/media/ic_call_answer_low.svg | svg conversion | XML drawable vector -> SVG |
| res/drawable/ic_call_answer_video.xml | Unknown | 第三方库资源（推断） | drawable | resources/base/media/ic_call_answer_video.svg | svg conversion | XML drawable vector -> SVG |
| res/drawable/ic_call_answer_video_low.xml | Unknown | 第三方库资源（推断） | drawable | resources/base/media/ic_call_answer_video_low.svg | svg conversion | XML drawable vector -> SVG |
| res/drawable/ic_call_decline.xml | Unknown | 第三方库资源（推断） | drawable | resources/base/media/ic_call_decline.svg | svg conversion | XML drawable vector -> SVG |
| res/drawable/ic_call_decline_low.xml | Unknown | 第三方库资源（推断） | drawable | resources/base/media/ic_call_decline_low.svg | svg conversion | XML drawable vector -> SVG |
| res/drawable/icon_background.xml | Launcher | 第三方库资源（推断） | drawable | resources/base/media/icon_background.svg | svg conversion | XML drawable shape -> SVG |
| res/drawable/notification_action_background.xml | Notification | 第三方库资源 | drawable | N/A | unmappable | ripple has no SVG equivalent (runtime behavior) |
| res/drawable/notification_bg.xml | Notification | 第三方库资源 | drawable | resources/base/media/notification_bg.svg | svg conversion | XML drawable selector -> SVG |
| res/drawable/notification_bg_low.xml | Notification | 第三方库资源 | drawable | resources/base/media/notification_bg_low.svg | svg conversion | XML drawable selector -> SVG |
| res/drawable/notification_icon_background.xml | Notification | 第三方库资源 | drawable | resources/base/media/notification_icon_background.svg | svg conversion | XML drawable shape -> SVG |
| res/drawable/notification_tile_bg.xml | Notification | 第三方库资源 | drawable | N/A | unmappable | unrecognized XML drawable |
| res/drawable-hdpi/notification_bg_low_normal.9.png | Notification | 第三方库资源 | drawable | resources/ldpi/media/notification_bg_low_normal_9.png | rename | 9-patch renamed; stretching behavior lost |
| res/drawable-hdpi/notification_bg_low_pressed.9.png | Notification | 第三方库资源 | drawable | resources/ldpi/media/notification_bg_low_pressed_9.png | rename | 9-patch renamed; stretching behavior lost |
| res/drawable-hdpi/notification_bg_normal.9.png | Notification | 第三方库资源 | drawable | resources/ldpi/media/notification_bg_normal_9.png | rename | 9-patch renamed; stretching behavior lost |
| res/drawable-hdpi/notification_bg_normal_pressed.9.png | Notification | 第三方库资源 | drawable | resources/ldpi/media/notification_bg_normal_pressed_9.png | rename | 9-patch renamed; stretching behavior lost |
| res/drawable-hdpi/notification_oversize_large_icon_bg.png | Notification | 第三方库资源 | drawable | resources/ldpi/media/notification_oversize_large_icon_bg.png | direct copy | image copy |
| res/drawable-hdpi/notify_panel_notification_icon_bg.png | Unknown | 第三方库资源（推断） | drawable | resources/ldpi/media/notify_panel_notification_icon_bg.png | direct copy | image copy |
| res/drawable-mdpi/notification_bg_low_normal.9.png | Notification | 第三方库资源 | drawable | resources/mdpi/media/notification_bg_low_normal_9.png | rename | 9-patch renamed; stretching behavior lost |
| res/drawable-mdpi/notification_bg_low_pressed.9.png | Notification | 第三方库资源 | drawable | resources/mdpi/media/notification_bg_low_pressed_9.png | rename | 9-patch renamed; stretching behavior lost |
| res/drawable-mdpi/notification_bg_normal.9.png | Notification | 第三方库资源 | drawable | resources/mdpi/media/notification_bg_normal_9.png | rename | 9-patch renamed; stretching behavior lost |
| res/drawable-mdpi/notification_bg_normal_pressed.9.png | Notification | 第三方库资源 | drawable | resources/mdpi/media/notification_bg_normal_pressed_9.png | rename | 9-patch renamed; stretching behavior lost |
| res/drawable-mdpi/notify_panel_notification_icon_bg.png | Unknown | 第三方库资源（推断） | drawable | resources/mdpi/media/notify_panel_notification_icon_bg.png | direct copy | image copy |
| res/drawable-xhdpi/notification_bg_low_normal.9.png | Notification | 第三方库资源 | drawable | resources/xldpi/media/notification_bg_low_normal_9.png | rename | 9-patch renamed; stretching behavior lost |
| res/drawable-xhdpi/notification_bg_low_pressed.9.png | Notification | 第三方库资源 | drawable | resources/xldpi/media/notification_bg_low_pressed_9.png | rename | 9-patch renamed; stretching behavior lost |
| res/drawable-xhdpi/notification_bg_normal.9.png | Notification | 第三方库资源 | drawable | resources/xldpi/media/notification_bg_normal_9.png | rename | 9-patch renamed; stretching behavior lost |
| res/drawable-xhdpi/notification_bg_normal_pressed.9.png | Notification | 第三方库资源 | drawable | resources/xldpi/media/notification_bg_normal_pressed_9.png | rename | 9-patch renamed; stretching behavior lost |
| res/drawable-xhdpi/notify_panel_notification_icon_bg.png | Unknown | 第三方库资源（推断） | drawable | resources/xldpi/media/notify_panel_notification_icon_bg.png | direct copy | image copy |
| res/mipmap-anydpi/ic_launcher.xml | Unknown | 第三方库资源（推断） | mipmap | N/A | unmappable | monochrome references @drawable/ic_launcher_foreground; no layered-image equivalent |
| res/mipmap-anydpi/ic_launcher_round.xml | Unknown | 第三方库资源（推断） | mipmap | N/A | unmappable | monochrome references @drawable/ic_launcher_foreground; no layered-image equivalent |
| res/values/attrs.xml | Unknown | 第三方库资源（推断） | values | N/A | unmappable | attrs.xml has no HarmonyOS element equivalent |
| res/values/colors.xml | Common | 第三方库资源 | values | resources/base/element/color.json#androidx_core_ripple_material_light | merged into json | color entry |
| res/values/colors.xml | Common | 第三方库资源 | values | resources/base/element/color.json#androidx_core_secondary_text_default_material_light | merged into json | color entry |
| res/values/colors.xml | Notification | 第三方库资源 | values | resources/base/element/color.json#call_notification_answer_color | merged into json | color entry |
| res/values/colors.xml | Notification | 第三方库资源 | values | resources/base/element/color.json#call_notification_decline_color | merged into json | color entry |
| res/values/colors.xml | Notification | 第三方库资源 | values | resources/base/element/color.json#notification_action_color_filter | merged into json | color entry |
| res/values/colors.xml | Notification | 第三方库资源 | values | resources/base/element/color.json#notification_icon_bg_color | merged into json | color entry |
| res/values/dimens.xml | Common | 第三方库资源 | values | resources/base/element/float.json#compat_button_inset_horizontal_material | merged into json | dimen entry |
| res/values/dimens.xml | Common | 第三方库资源 | values | resources/base/element/float.json#compat_button_inset_vertical_material | merged into json | dimen entry |
| res/values/dimens.xml | Common | 第三方库资源 | values | resources/base/element/float.json#compat_button_padding_horizontal_material | merged into json | dimen entry |
| res/values/dimens.xml | Common | 第三方库资源 | values | resources/base/element/float.json#compat_button_padding_vertical_material | merged into json | dimen entry |
| res/values/dimens.xml | Common | 第三方库资源 | values | resources/base/element/float.json#compat_control_corner_material | merged into json | dimen entry |
| res/values/dimens.xml | Common | 第三方库资源 | values | resources/base/element/float.json#compat_notification_large_icon_max_height | merged into json | dimen entry |
| res/values/dimens.xml | Common | 第三方库资源 | values | resources/base/element/float.json#compat_notification_large_icon_max_width | merged into json | dimen entry |
| res/values/dimens.xml | Notification | 第三方库资源 | values | resources/base/element/float.json#notification_action_icon_size | merged into json | dimen entry |
| res/values/dimens.xml | Notification | 第三方库资源 | values | resources/base/element/float.json#notification_action_text_size | merged into json | dimen entry |
| res/values/dimens.xml | Notification | 第三方库资源 | values | resources/base/element/float.json#notification_big_circle_margin | merged into json | dimen entry |
| res/values/dimens.xml | Notification | 第三方库资源 | values | resources/base/element/float.json#notification_content_margin_start | merged into json | dimen entry |
| res/values/dimens.xml | Notification | 第三方库资源 | values | resources/base/element/float.json#notification_large_icon_height | merged into json | dimen entry |
| res/values/dimens.xml | Notification | 第三方库资源 | values | resources/base/element/float.json#notification_large_icon_width | merged into json | dimen entry |
| res/values/dimens.xml | Notification | 第三方库资源 | values | resources/base/element/float.json#notification_main_column_padding_top | merged into json | dimen entry |
| res/values/dimens.xml | Notification | 第三方库资源 | values | resources/base/element/float.json#notification_media_narrow_margin | merged into json | dimen entry |
| res/values/dimens.xml | Notification | 第三方库资源 | values | resources/base/element/float.json#notification_right_icon_size | merged into json | dimen entry |
| res/values/dimens.xml | Notification | 第三方库资源 | values | resources/base/element/float.json#notification_right_side_padding_top | merged into json | dimen entry |
| res/values/dimens.xml | Notification | 第三方库资源 | values | resources/base/element/float.json#notification_small_icon_background_padding | merged into json | dimen entry |
| res/values/dimens.xml | Notification | 第三方库资源 | values | resources/base/element/float.json#notification_small_icon_size_as_large | merged into json | dimen entry |
| res/values/dimens.xml | Notification | 第三方库资源 | values | resources/base/element/float.json#notification_subtext_size | merged into json | dimen entry |
| res/values/dimens.xml | Notification | 第三方库资源 | values | resources/base/element/float.json#notification_top_pad | merged into json | dimen entry |
| res/values/dimens.xml | Notification | 第三方库资源 | values | resources/base/element/float.json#notification_top_pad_large_text | merged into json | dimen entry |
| res/values/dimens.xml | SplashScreen | 第三方库资源 | values | resources/base/element/float.json#splashscreen_icon_mask_size_no_background | merged into json | dimen entry |
| res/values/dimens.xml | SplashScreen | 第三方库资源 | values | resources/base/element/float.json#splashscreen_icon_mask_size_with_background | merged into json | dimen entry |
| res/values/dimens.xml | SplashScreen | 第三方库资源 | values | resources/base/element/float.json#splashscreen_icon_mask_stroke_no_background | merged into json | dimen entry |
| res/values/dimens.xml | SplashScreen | 第三方库资源 | values | resources/base/element/float.json#splashscreen_icon_mask_stroke_with_background | merged into json | dimen entry |
| res/values/dimens.xml | SplashScreen | 第三方库资源 | values | resources/base/element/float.json#splashscreen_icon_size | merged into json | dimen entry |
| res/values/dimens.xml | SplashScreen | 第三方库资源 | values | resources/base/element/float.json#splashscreen_icon_size_no_background | merged into json | dimen entry |
| res/values/dimens.xml | SplashScreen | 第三方库资源 | values | resources/base/element/float.json#splashscreen_icon_size_with_background | merged into json | dimen entry |
| res/values/drawables.xml | Notification | 第三方库资源 | values | resources/base/element/color.json#notification_template_icon_bg | merged into json | color drawable from drawables.xml |
| res/values/drawables.xml | Notification | 第三方库资源 | values | resources/base/element/color.json#notification_template_icon_low_bg | merged into json | color drawable from drawables.xml |
| res/values/ids.xml | Unknown | 第三方库资源（推断） | values | N/A | unmappable | ids.xml has no HarmonyOS element equivalent |
| res/values/integers.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/integer.json#default_icon_animation_duration | merged into json | integer entry (JSON number) |
| res/values/integers.xml | Common | 第三方库资源 | values | resources/base/element/integer.json#m3c_window_layout_in_display_cutout_mode | merged into json | integer entry (JSON number) |
| res/values/integers.xml | Common | 第三方库资源 | values | resources/base/element/integer.json#status_bar_notification_info_maxnum | merged into json | integer entry (JSON number) |
| res/values/public.xml | Unknown | 第三方库资源（推断） | values | N/A | unmappable | public.xml has no HarmonyOS element equivalent |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#androidx_startup | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#autofill | merged into json | string entry |
| res/values/strings.xml | Notification | 第三方库资源 | values | resources/base/element/string.json#call_notification_answer_action | merged into json | string entry |
| res/values/strings.xml | Notification | 第三方库资源 | values | resources/base/element/string.json#call_notification_answer_video_action | merged into json | string entry |
| res/values/strings.xml | Notification | 第三方库资源 | values | resources/base/element/string.json#call_notification_decline_action | merged into json | string entry |
| res/values/strings.xml | Notification | 第三方库资源 | values | resources/base/element/string.json#call_notification_hang_up_action | merged into json | string entry |
| res/values/strings.xml | Notification | 第三方库资源 | values | resources/base/element/string.json#call_notification_incoming_text | merged into json | string entry |
| res/values/strings.xml | Notification | 第三方库资源 | values | resources/base/element/string.json#call_notification_ongoing_text | merged into json | string entry |
| res/values/strings.xml | Notification | 第三方库资源 | values | resources/base/element/string.json#call_notification_screening_text | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#close_drawer | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#close_sheet | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#default_error_message | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#default_popup_window_title | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#dropdown_menu | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#in_progress | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#indeterminate | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_bottom_sheet_collapse_description | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_bottom_sheet_dismiss_description | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_bottom_sheet_drag_handle_description | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_bottom_sheet_expand_description | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_bottom_sheet_pane_title | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_input_headline | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_input_headline_description | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_input_invalid_for_pattern | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_input_invalid_not_allowed | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_input_invalid_year_range | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_input_label | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_input_no_input_description | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_input_title | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_picker_headline | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_picker_headline_description | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_picker_navigate_to_year_description | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_picker_no_selection_description | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_picker_scroll_to_earlier_years | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_picker_scroll_to_later_years | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_picker_switch_to_calendar_mode | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_picker_switch_to_day_selection | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_picker_switch_to_input_mode | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_picker_switch_to_next_month | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_picker_switch_to_previous_month | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_picker_switch_to_year_selection | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_picker_title | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_picker_today_description | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_picker_year_picker_pane_title | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_range_input_invalid_range_input | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_range_input_title | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_range_picker_day_in_range | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_range_picker_end_headline | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_range_picker_scroll_to_next_month | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_range_picker_scroll_to_previous_month | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_range_picker_start_headline | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_date_range_picker_title | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_dialog | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_dropdown_menu_collapsed | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_dropdown_menu_expanded | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_dropdown_menu_toggle | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_floating_toolbar_collapse | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_floating_toolbar_expand | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_search_bar_search | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_snackbar_dismiss | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_snackbar_pane_title | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_suggestions_available | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_time_input_dialog_title | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_time_picker_am | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_time_picker_dialog_title | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_time_picker_hour | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_time_picker_hour_24h_suffix | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_time_picker_hour_selection | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_time_picker_hour_suffix | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_time_picker_hour_text_field | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_time_picker_minute | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_time_picker_minute_selection | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_time_picker_minute_suffix | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_time_picker_minute_text_field | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_time_picker_period_toggle_description | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_time_picker_pm | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_time_picker_toggle_keyboard | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_time_picker_toggle_touch | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_tooltip_long_press_label | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_tooltip_pane_description | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_wide_navigation_rail_close_rail | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#m3c_wide_navigation_rail_pane_title | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#mc2_snackbar_pane_title | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#navigation_menu | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#not_selected | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#range_end | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#range_start | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#selected | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#snackbar_pane_title | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#state_empty | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#state_off | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#state_on | merged into json | string entry |
| res/values/strings.xml | Common | 第三方库资源 | values | resources/base/element/string.json#status_bar_notification_info_overflow | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#switch_role | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#tab | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#template_percent | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#tooltip_description | merged into json | string entry |
| res/values/strings.xml | Unknown | 第三方库资源（推断） | values | resources/base/element/string.json#tooltip_label | merged into json | string entry |
| res/values/styles.xml | Unknown | 第三方库资源（推断） | values | N/A | unmappable | styles.xml has no HarmonyOS element equivalent |

### 3.3 不可映射资源映射 (HarmonyOS Target = N/A)

| Android Resource Path | Android Screen(s) | Android Source Category | Android Type Category | HarmonyOS Target | Mapping Kind | Notes |
|---|---|---|---|---|---|---|
| res/anim/fragment_fast_out_extra_slow_in.xml | Unknown | 第三方库资源（推断） | anim | N/A | unmappable | anim has no direct HarmonyOS equivalent |
| res/animator/fragment_close_enter.xml | Unknown | 第三方库资源（推断） | animator | N/A | unmappable | animator has no direct HarmonyOS equivalent |
| res/animator/fragment_close_exit.xml | Unknown | 第三方库资源（推断） | animator | N/A | unmappable | animator has no direct HarmonyOS equivalent |
| res/animator/fragment_fade_enter.xml | Unknown | 第三方库资源（推断） | animator | N/A | unmappable | animator has no direct HarmonyOS equivalent |
| res/animator/fragment_fade_exit.xml | Unknown | 第三方库资源（推断） | animator | N/A | unmappable | animator has no direct HarmonyOS equivalent |
| res/animator/fragment_open_enter.xml | Unknown | 第三方库资源（推断） | animator | N/A | unmappable | animator has no direct HarmonyOS equivalent |
| res/animator/fragment_open_exit.xml | Unknown | 第三方库资源（推断） | animator | N/A | unmappable | animator has no direct HarmonyOS equivalent |
| res/color/vector_tint_color.xml | Unknown | 第三方库资源（推断） | color | N/A | unmappable | color has no direct HarmonyOS equivalent |
| res/color/vector_tint_theme_color.xml | Unknown | 第三方库资源（推断） | color | N/A | unmappable | color has no direct HarmonyOS equivalent |
| res/layout/custom_dialog.xml | Unknown | 第三方库资源（推断） | layout | N/A | unmappable | layout has no direct HarmonyOS equivalent |
| res/layout/ime_base_split_test_activity.xml | Unknown | 第三方库资源（推断） | layout | N/A | unmappable | layout has no direct HarmonyOS equivalent |
| res/layout/ime_secondary_split_test_activity.xml | Unknown | 第三方库资源（推断） | layout | N/A | unmappable | layout has no direct HarmonyOS equivalent |
| res/layout/notification_action.xml | Notification | 第三方库资源 | layout | N/A | unmappable | layout has no direct HarmonyOS equivalent |
| res/layout/notification_action_tombstone.xml | Notification | 第三方库资源 | layout | N/A | unmappable | layout has no direct HarmonyOS equivalent |
| res/layout/notification_template_custom_big.xml | Notification | 第三方库资源 | layout | N/A | unmappable | layout has no direct HarmonyOS equivalent |
| res/layout/notification_template_icon_group.xml | Notification | 第三方库资源 | layout | N/A | unmappable | layout has no direct HarmonyOS equivalent |
| res/layout/notification_template_part_chronometer.xml | Notification | 第三方库资源 | layout | N/A | unmappable | layout has no direct HarmonyOS equivalent |
| res/layout/notification_template_part_time.xml | Notification | 第三方库资源 | layout | N/A | unmappable | layout has no direct HarmonyOS equivalent |
| res/layout/splash_screen_view.xml | Unknown | 第三方库资源（推断） | layout | N/A | unmappable | layout has no direct HarmonyOS equivalent |

### 3.4 各语言 values 变体映射 (按文件汇总)

| Android Resource File | Android Source Category | Android Type Category | HarmonyOS Target 目录 | Mapping Kind | Notes |
|---|---|---|---|---|---|
| res/values-af/strings.xml | 第三方库资源 | values | `resources/af/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-am/strings.xml | 第三方库资源 | values | `resources/am/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-ar/strings.xml | 第三方库资源 | values | `resources/ar/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-as/strings.xml | 第三方库资源 | values | `resources/as/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-az/strings.xml | 第三方库资源 | values | `resources/az/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-b+sr+Latn/strings.xml | 第三方库资源 | values | `resources/sr_Latn/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-be/strings.xml | 第三方库资源 | values | `resources/be/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-bg/strings.xml | 第三方库资源 | values | `resources/bg/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-bn/strings.xml | 第三方库资源 | values | `resources/bn/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-bs/strings.xml | 第三方库资源 | values | `resources/bs/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-ca/strings.xml | 第三方库资源 | values | `resources/ca/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-cs/strings.xml | 第三方库资源 | values | `resources/cs/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-da/strings.xml | 第三方库资源 | values | `resources/da/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-de/strings.xml | 第三方库资源 | values | `resources/de/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-el/strings.xml | 第三方库资源 | values | `resources/el/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-en-rAU/strings.xml | 第三方库资源 | values | `resources/en_AU/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-en-rCA/strings.xml | 第三方库资源 | values | `resources/en_CA/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-en-rGB/strings.xml | 第三方库资源 | values | `resources/en_GB/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-en-rIN/strings.xml | 第三方库资源 | values | `resources/en_IN/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-en-rXC/strings.xml | 第三方库资源 | values | `resources/en_XC/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-es-rUS/strings.xml | 第三方库资源 | values | `resources/es_US/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-es/strings.xml | 第三方库资源 | values | `resources/es/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-et/strings.xml | 第三方库资源 | values | `resources/et/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-eu/strings.xml | 第三方库资源 | values | `resources/eu/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-fa/strings.xml | 第三方库资源 | values | `resources/fa/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-fi/strings.xml | 第三方库资源 | values | `resources/fi/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-fr-rCA/strings.xml | 第三方库资源 | values | `resources/fr_CA/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-fr/strings.xml | 第三方库资源 | values | `resources/fr/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-gl/strings.xml | 第三方库资源 | values | `resources/gl/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-gu/strings.xml | 第三方库资源 | values | `resources/gu/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-hi/strings.xml | 第三方库资源 | values | `resources/hi/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-hr/strings.xml | 第三方库资源 | values | `resources/hr/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-hu/strings.xml | 第三方库资源 | values | `resources/hu/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-hy/strings.xml | 第三方库资源 | values | `resources/hy/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-in/strings.xml | 第三方库资源 | values | `resources/in/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-is/strings.xml | 第三方库资源 | values | `resources/is/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-it/strings.xml | 第三方库资源 | values | `resources/it/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-iw/strings.xml | 第三方库资源 | values | `resources/iw/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-ja/strings.xml | 第三方库资源 | values | `resources/ja/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-ka/strings.xml | 第三方库资源 | values | `resources/ka/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-kk/strings.xml | 第三方库资源 | values | `resources/kk/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-km/strings.xml | 第三方库资源 | values | `resources/km/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-kn/strings.xml | 第三方库资源 | values | `resources/kn/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-ko/strings.xml | 第三方库资源 | values | `resources/ko/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-ky/strings.xml | 第三方库资源 | values | `resources/ky/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-lo/strings.xml | 第三方库资源 | values | `resources/lo/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-lt/strings.xml | 第三方库资源 | values | `resources/lt/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-lv/strings.xml | 第三方库资源 | values | `resources/lv/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-mk/strings.xml | 第三方库资源 | values | `resources/mk/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-ml/strings.xml | 第三方库资源 | values | `resources/ml/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-mn/strings.xml | 第三方库资源 | values | `resources/mn/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-mr/strings.xml | 第三方库资源 | values | `resources/mr/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-ms/strings.xml | 第三方库资源 | values | `resources/ms/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-my/strings.xml | 第三方库资源 | values | `resources/my/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-nb/strings.xml | 第三方库资源 | values | `resources/nb/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-ne/strings.xml | 第三方库资源 | values | `resources/ne/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-night/styles.xml | 第三方库资源 | values | `resources/N/A/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-nl/strings.xml | 第三方库资源 | values | `resources/nl/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-or/strings.xml | 第三方库资源 | values | `resources/or/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-pa/strings.xml | 第三方库资源 | values | `resources/pa/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-pl/strings.xml | 第三方库资源 | values | `resources/pl/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-pt-rBR/strings.xml | 第三方库资源 | values | `resources/pt_BR/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-pt-rPT/strings.xml | 第三方库资源 | values | `resources/pt_PT/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-pt/strings.xml | 第三方库资源 | values | `resources/pt/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-ro/strings.xml | 第三方库资源 | values | `resources/ro/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-ru/strings.xml | 第三方库资源 | values | `resources/ru/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-si/strings.xml | 第三方库资源 | values | `resources/si/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-sk/strings.xml | 第三方库资源 | values | `resources/sk/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-sl/strings.xml | 第三方库资源 | values | `resources/sl/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-sq/strings.xml | 第三方库资源 | values | `resources/sq/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-sr/strings.xml | 第三方库资源 | values | `resources/sr/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-sv/strings.xml | 第三方库资源 | values | `resources/sv/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-sw/strings.xml | 第三方库资源 | values | `resources/sw/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-ta/strings.xml | 第三方库资源 | values | `resources/ta/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-te/strings.xml | 第三方库资源 | values | `resources/te/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-th/strings.xml | 第三方库资源 | values | `resources/th/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-tl/strings.xml | 第三方库资源 | values | `resources/tl/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-tr/strings.xml | 第三方库资源 | values | `resources/tr/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-uk/strings.xml | 第三方库资源 | values | `resources/uk/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-ur/strings.xml | 第三方库资源 | values | `resources/ur/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-uz/strings.xml | 第三方库资源 | values | `resources/uz/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-v27/styles.xml | 第三方库资源 | values | `resources/N/A/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-v28/styles.xml | 第三方库资源 | values | `resources/N/A/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-v29/styles.xml | 第三方库资源 | values | `resources/N/A/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-v30/integers.xml | 第三方库资源 | values | `resources/base/element/integer.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-v31/styles.xml | 第三方库资源 | values | `resources/N/A/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-vi/strings.xml | 第三方库资源 | values | `resources/vi/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-watch/dimens.xml | 第三方库资源 | values | `resources/base/element/float.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-zh-rCN/strings.xml | 第三方库资源 | values | `resources/zh_CN/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-zh-rHK/strings.xml | 第三方库资源 | values | `resources/zh_HK/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-zh-rTW/strings.xml | 第三方库资源 | values | `resources/zh_TW/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |
| res/values-zu/strings.xml | 第三方库资源 | values | `resources/zu/element/string.json/element/string.json` | merged into json | 整文件本地化翻译 |

## 4. 未映射 / 不可映射 / 系统 / 远程资源汇总

### 4.1 不可映射类型 (无 HarmonyOS 等价物)
- **layout/*.xml** (10 个): ArkUI 使用声明式 UI，Android 布局 XML 不直接迁移。包括 `custom_dialog.xml`、`notification_template_*.xml`、`splash_screen_view.xml`、`ime_*` 等 (均为库布局)。
- **values/styles.xml** + **values-{night,v27,v28,v29,v30,v31}/styles.xml**: 主题/样式 (Theme、SplashScreen) 无 HarmonyOS JSON 等价物。
- **values/attrs.xml**, **values/public.xml**, **values/ids.xml**: 属性声明 / 公共资源 ID，无等价物。
- **anim/fragment_fast_out_extra_slow_in.xml**, **animator/fragment_*.xml** (6 个): 动画 XML 无 SVG 等价物 (需在 ArkUI 中用 animateTo 实现)。
- **color/vector_tint_color.xml**, **color/vector_tint_theme_color.xml**: 颜色状态列表 (selector) 无等价物。
- **mipmap-anydpi/ic_launcher*.xml#monochrome**: adaptive-icon 的 `monochrome` 层无 layered-image 等价物 (其引用的 `@drawable/ic_launcher_foreground` 仍作为普通 drawable 转换)。
- **drawable/$ic_launcher_background__0.xml**: apktool 从内联 `aapt:attr` 渐变抽取出的独立 `<gradient>` 文件，已合并入父 vector SVG (见 3.1)。

### 4.2 Android 系统资源 (已解析为具体值)

| 引用位置 | 系统引用 | 解析值 |
|---|---|---|
| base/element/color.json#notification_action_color_filter | @color/androidx_core_secondary_text_default_material_light | #8a000000 |
- 项目中 `values/styles.xml` 引用 `@android:style/Theme.DeviceDefault.*`、`@android:color/transparent` 等系统样式/颜色，因 styles 整体未迁移，未单独输出。

### 4.3 未解析引用 (主题属性，保留原样)

| 资源文件 | 原始引用 | 处理 | 原因 |
|---|---|---|---|
| base/element/float.json#splashscreen_icon_size | ?splashScreenIconSize | (kept) | theme attribute |
- `splashscreen_icon_size = ?splashScreenIconSize` 为主题属性引用，无法静态解析，保留原样 (属 SplashScreen 库资源，HarmonyOS 闪屏需单独实现)。

### 4.4 运行时远程资源
- 未在 `res/` 中发现运行时远程 (URL) 资源声明。本应用图片主要来自网络 (Compose AsyncImage 等)，不在静态资源范围内。

## 5. 关键发现 (Quick Findings)

- **启动器图标**: `ic_launcher` / `ic_launcher_round` 为 adaptive-icon，已转换为 `base/media/ic_launcher_layered_image.json` 与 `ic_launcher_round_layered_image.json`；背景层 `@drawable/ic_launcher_background` (含线性渐变，已正确转为 SVG `<linearGradient>`)，前景层 `@drawable/ic_launcher_foreground` (锅具矢量图)。HarmonyOS 项目现有 `layered_image.json` (供 `module.json5` 的 `$media:layered_image`) 保留不变。
- **应用自身资源极少**: 仅 `app_name`、4 个颜色 (`brand_primary=#fff2622e` 等)、3 个启动器/闪屏矢量图、1 个字体 (`plus_jakarta_sans.ttf` → `rawfile/fonts/`)。UI 主体为 Jetpack Compose，不依赖 Android `res/`。
- **第三方库资源占绝大多数**: 反编译资源中 `m3c_*`(Material3)、`call_notification_*`/`notification_*`(AndroidX Core)、`splashscreen_*`(SplashScreen)、`abc_*`(AppCompat) 等均为库资源，~90 个语言变体为这些库字符串的本地化翻译。
- **9-patch 重命名**: 通知背景 9-patch (drawable-hdpi/mdpi/xhdpi) 已按规则重命名 `*.9.png` → `*_9.png` 并分别落入 `ldpi/mdpi/xldpi/media/`，但 Android 九宫格拉伸行为丢失，需在 ArkUI 中另行实现。
- **整型数值类型**: `integer.json` 中数值均为 JSON number (如 `default_icon_animation_duration=10000`)；`m3c_window_layout_in_display_cutout_mode` 取 API30 覆盖值 `3` (基础值为 1)。
- **颜色引用解析**: `notification_action_color_filter` → `@color/androidx_core_secondary_text_default_material_light` → `#8a000000` 已解析为具体值。
- **字体**: `plus_jakarta_sans.ttf` 复制到 `entry/src/main/resources/rawfile/fonts/` (HarmonyOS 字体需通过 rawfile 按路径加载)。
- **AppScope 保留**: `AppScope/resources/base/element/string.json` 的 `app_name` (被 `app.json5` 的 `$string:app_name` 引用) 保持不变，未覆盖。

## 6. 转换统计

| 指标 | 数值 |
|---|---|
| Android 资源文件总数 | 157 |
| 成功转换文件 | 126 |
| 不可映射 (无等价物) | 31 |
| 转换失败 | 0 |
| 资源清单行 (含按文件汇总的 locale) | 211 基础行 + 92 locale 文件 |
| 引用已解析 | 1 |
| 引用未解析 (主题属性) | 1 |
