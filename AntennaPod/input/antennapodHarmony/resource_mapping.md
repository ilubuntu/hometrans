# Android Resources ↔ HarmonyOS Resources Mapping

## Metadata

- **Android project path:** `/Users/bb/work/hometrans/AntennaPod/AntennaPod`
- **HarmonyOS project output path:** `/Users/bb/work/hometrans/AntennaPod/input/antennapodHarmony`
- **Resource source:** Project source `res/` directory (app module)
- **Resource source path:** `/Users/bb/work/hometrans/AntennaPod/AntennaPod/app/src/main/res/`
- **Build result:** N/A (source res/ used directly, no APK build/decompile)
- **Generation timestamp:** 2026-06-30

### Notes

- AntennaPod uses a highly modularized Gradle architecture. The `app/src/main/res/` directory contains only app-module-specific resources. Strings are defined in `:ui:i18n`, colors in `:ui:common`. Only `app/src/main/res/` was converted as specified.
- Dependency resources referenced by app-module drawables (from `:ui:common`) were resolved and included where needed for adaptive-icon and layer-list conversions.

---

## Android Resource Inventory

### Values Resources

| Android Resource Path | Resource Name | Function | Screen(s) | Source Category | Type Category | Status | Notes |
|---|---|---|---|---|---|---|---|
| `app/src/main/res/values/dimens.xml#dimen/additional_horizontal_spacing` | additional_horizontal_spacing | Horizontal spacing dimension | Common | 应用自身资源 | values | Converted | 0dp → 0vp |
| `app/src/main/res/values/dimens.xml#dimen/drawer_corner_size` | drawer_corner_size | Navigation drawer corner radius | Common | 应用自身资源 | values | Converted | 16dp → 16vp |
| `app/src/main/res/values/dimens.xml#dimen/floating_select_menu_height` | floating_select_menu_height | Floating select menu height | Common | 应用自身资源 | values | Converted | 112dp → 112vp |
| `app/src/main/res/values/integers.xml#integer/subscriptions_default_num_of_columns` | subscriptions_default_num_of_columns | Default grid column count | Common | 应用自身资源 | values | Converted | Value: 3 |
| `app/src/main/res/values/integers.xml#integer/nav_drawer_screen_size_percent` | nav_drawer_screen_size_percent | Nav drawer width percentage | Common | 应用自身资源 | values | Converted | Value: 80 |
| `app/src/main/res/values/integers.xml#integer/swipe_refresh_distance` | swipe_refresh_distance | Swipe refresh distance | Common | 应用自身资源 | values | Converted | Value: 300 |
| `app/src/main/res/values/svg.xml#string/svg_animatable_play` | svg_animatable_play | SVG path data for animated play icon | Common | 应用自身资源 | values | Converted | translatable=false; path data string |
| `app/src/main/res/values/svg.xml#string/svg_animatable_pause` | svg_animatable_pause | SVG path data for animated pause icon | Common | 应用自身资源 | values | Converted | translatable=false; path data string |
| `app/src/main/res/values/design_time_attributes.xml#string/design_time_lorem_ipsum` | design_time_lorem_ipsum | Lorem ipsum placeholder for design-time preview | Common | 应用自身资源 | values | Converted | Design-time only; not shown at runtime |
| `app/src/main/res/values/design_time_attributes.xml#string/design_time_downloaded_log_failure_reason` | design_time_downloaded_log_failure_reason | Sample error text for design-time preview | Common | 应用自身资源 | values | Converted | Design-time only |
| `app/src/main/res/values/attrs.xml#declare-styleable/NestedScrollableHost` | NestedScrollableHost | Custom styleable attributes for NestedScrollableHost | Common | 应用自身资源 | values | Unmapped | declare-styleable has no HarmonyOS equivalent |
| `app/src/main/res/values/ids.xml#id/select_all_item` | select_all_item | Menu item ID | Common | 应用自身资源 | values | Unmapped | ID resources are code-level concerns in HarmonyOS |
| `app/src/main/res/values/ids.xml#id/deselect_all_item` | deselect_all_item | Menu item ID | Common | 应用自身资源 | values | Unmapped | ID resources are code-level concerns |
| `app/src/main/res/values/ids.xml#id/clear_history_item` | clear_history_item | Menu item ID | Common | 应用自身资源 | values | Unmapped | ID resources are code-level concerns |
| `app/src/main/res/values/ids.xml#id/open_in_browser_item` | open_in_browser_item | Menu item ID | Common | 应用自身资源 | values | Unmapped | ID resources are code-level concerns |
| `app/src/main/res/values/ids.xml#id/copy_url_item` | copy_url_item | Menu item ID | Common | 应用自身资源 | values | Unmapped | ID resources are code-level concerns |
| `app/src/main/res/values/ids.xml#id/share_url_item` | share_url_item | Menu item ID | Common | 应用自身资源 | values | Unmapped | ID resources are code-level concerns |
| `app/src/main/res/values/ids.xml#id/go_to_position_item` | go_to_position_item | Menu item ID | Common | 应用自身资源 | values | Unmapped | ID resources are code-level concerns |
| `app/src/main/res/values/ids.xml#id/drag_handle` | drag_handle | View ID | Common | 应用自身资源 | values | Unmapped | ID resources are code-level concerns |
| `app/src/main/res/values/ids.xml#id/skip_episode_item` | skip_episode_item | Menu item ID | Common | 应用自身资源 | values | Unmapped | ID resources are code-level concerns |
| `app/src/main/res/values/ids.xml#id/move_to_top_item` | move_to_top_item | Menu item ID | Common | 应用自身资源 | values | Unmapped | ID resources are code-level concerns |
| `app/src/main/res/values/ids.xml#id/move_to_bottom_item` | move_to_bottom_item | Menu item ID | Common | 应用自身资源 | values | Unmapped | ID resources are code-level concerns |
| `app/src/main/res/values/ids.xml#id/view_type_episode_item` | view_type_episode_item | View type ID | Common | 应用自身资源 | values | Unmapped | ID resources are code-level concerns |
| `app/src/main/res/values/ids.xml#id/view_type_subscription_grid_with_title` | view_type_subscription_grid_with_title | View type ID | Common | 应用自身资源 | values | Unmapped | ID resources are code-level concerns |
| `app/src/main/res/values/ids.xml#id/view_type_subscription_grid_without_title` | view_type_subscription_grid_without_title | View type ID | Common | 应用自身资源 | values | Unmapped | ID resources are code-level concerns |
| `app/src/main/res/values/ids.xml#id/view_type_subscription_list` | view_type_subscription_list | View type ID | Common | 应用自身资源 | values | Unmapped | ID resources are code-level concerns |
| `app/src/main/res/values/ids.xml#id/bottom_navigation_*` (14 items) | bottom_navigation_* | Bottom navigation tab IDs | Common | 应用自身资源 | values | Unmapped | ID resources are code-level concerns |

### Drawable Resources

| Android Resource Path | Resource Name | Function | Screen(s) | Source Category | Type Category | Status | Notes |
|---|---|---|---|---|---|---|---|
| `app/src/main/res/drawable/ic_animate_play.xml` | ic_animate_play | Play icon vector (animated base) | Common | 应用自身资源 | drawable | Converted | Vector → SVG; fillColor resolved from ?attr (defaulted to #000000); pathData resolved from @string/svg_animatable_play |
| `app/src/main/res/drawable/ic_animate_pause_play.xml` | ic_animate_pause_play | Animated play→pause morph | Common | 应用自身资源 | drawable | Unmapped | animated-vector type; requires animation timing; no SVG equivalent |
| `app/src/main/res/drawable/ic_animate_play_pause.xml` | ic_animate_play_pause | Animated pause→play morph | Common | 应用自身资源 | drawable | Unmapped | animated-vector type; requires animation timing; no SVG equivalent |
| `app/src/main/res/drawable/bg_episode_list_item.xml` | bg_episode_list_item | Episode list item background | Common | 应用自身资源 | drawable | Partial | Inset+ripple+selector; ripple unconvertible; extracted transparent default state to SVG |
| `app/src/main/res/drawable/grey_border.xml` | grey_border | Rounded border background | Common | 应用自身资源 | drawable | Partial | Ripple wrapper; extracted border shape to SVG; stroke color from ?android:attr/textColorSecondary defaulted to #757575 |
| `app/src/main/res/drawable/ic_shortcut_feed.xml` | ic_shortcut_feed | Feed shortcut icon (layer-list) | Launcher | 应用自身资源 | drawable | Converted | Layer-list → SVG; inlined ic_shortcut_background (oval grey100) + ic_feed_black |
| `app/src/main/res/drawable/ic_shortcut_playlist.xml` | ic_shortcut_playlist | Playlist shortcut icon (layer-list) | Launcher | 应用自身资源 | drawable | Converted | Layer-list → SVG; inlined ic_shortcut_background + ic_playlist_play_black |
| `app/src/main/res/drawable/ic_shortcut_refresh.xml` | ic_shortcut_refresh | Refresh shortcut icon (layer-list) | Launcher | 应用自身资源 | drawable | Converted | Layer-list → SVG; inlined ic_shortcut_background + ic_refresh_black |
| `app/src/main/res/drawable/ic_shortcut_subscriptions.xml` | ic_shortcut_subscriptions | Subscriptions shortcut icon (layer-list) | Launcher | 应用自身资源 | drawable | Converted | Layer-list → SVG; inlined ic_shortcut_background + ic_subscriptions_black |

### Drawable (anydpi-v26) Resources — Adaptive Icons

| Android Resource Path | Resource Name | Function | Screen(s) | Source Category | Type Category | Status | Notes |
|---|---|---|---|---|---|---|---|
| `app/src/main/res/drawable-anydpi-v26/ic_shortcut_feed.xml` | ic_shortcut_feed | Adaptive icon for feed shortcut | Launcher | 应用自身资源 | drawable | Converted | adaptive-icon → layered-image JSON; bg: @color/grey100 → grey100_bg.png; fg: @drawable/ic_feed_black |
| `app/src/main/res/drawable-anydpi-v26/ic_shortcut_playlist.xml` | ic_shortcut_playlist | Adaptive icon for playlist shortcut | Launcher | 应用自身资源 | drawable | Converted | adaptive-icon → layered-image JSON |
| `app/src/main/res/drawable-anydpi-v26/ic_shortcut_refresh.xml` | ic_shortcut_refresh | Adaptive icon for refresh shortcut | Launcher | 应用自身资源 | drawable | Converted | adaptive-icon → layered-image JSON |
| `app/src/main/res/drawable-anydpi-v26/ic_shortcut_subscriptions.xml` | ic_shortcut_subscriptions | Adaptive icon for subscriptions shortcut | Launcher | 应用自身资源 | drawable | Converted | adaptive-icon → layered-image JSON |

### Dependency Resources (from :ui:common module)

These resources are not in `app/src/main/res/` but were referenced by app-module drawables and included for conversion completeness.

| Android Resource Path | Resource Name | Function | Screen(s) | Source Category | Type Category | Status | Notes |
|---|---|---|---|---|---|---|---|
| `ui/common/src/main/res/drawable/ic_feed_black.xml` | ic_feed_black | RSS feed icon vector | Launcher | 项目内模块资源 | drawable | Converted | Vector → SVG; used as adaptive-icon foreground |
| `ui/common/src/main/res/drawable/ic_playlist_play_black.xml` | ic_playlist_play_black | Playlist play icon vector | Launcher | 项目内模块资源 | drawable | Converted | Vector → SVG |
| `ui/common/src/main/res/drawable/ic_refresh_black.xml` | ic_refresh_black | Refresh icon vector | Launcher | 项目内模块资源 | drawable | Converted | Vector → SVG |
| `ui/common/src/main/res/drawable/ic_subscriptions_black.xml` | ic_subscriptions_black | Subscriptions grid icon vector | Launcher | 项目内模块资源 | drawable | Converted | Vector → SVG |
| `ui/common/src/main/res/drawable/ic_shortcut_background.xml` | ic_shortcut_background | Oval background for shortcut icons | Launcher | 项目内模块资源 | drawable | Inlined | Inset+oval shape; inlined into layer-list SVGs, not emitted as separate file |
| `ui/common/src/main/res/values/colors.xml#color/grey100` | grey100 | Light grey color (#f5f5f5) | Launcher | 项目内模块资源 | values | Converted | Used as adaptive-icon background; resolved to solid PNG |

### Skipped Directories — Unsupported Qualifiers

| Android Directory | Reason | File Count |
|---|---|---|
| `values-sw360dp/` | Unsupported qualifier: sw360dp (smallest width) | 1 |
| `values-sw600dp/` | Unsupported qualifier: sw600dp (smallest width) | 1 |
| `values-w1000dp/` | Unsupported qualifier: w1000dp (available width) | 1 |
| `values-w300dp/` | Unsupported qualifier: w300dp (available width) | 1 |
| `layout-sw720dp/` | Unsupported qualifier: sw720dp (smallest width) | 1 |

### Skipped Directories — No HarmonyOS Equivalent

| Android Directory | Reason | File Count |
|---|---|---|
| `layout/` | Layout XML has no direct ArkUI equivalent | 77 |
| `menu/` | Menu XML has no HarmonyOS equivalent | 23 |
| `xml/` | Configuration XML (preferences, provider paths, etc.) | 7 |

---

## Android → HarmonyOS Mapping Details

### Values → Element JSON

| Android Resource Path | Android Screen(s) | Android Source Category | Android Type Category | HarmonyOS Target | Mapping Kind | Notes |
|---|---|---|---|---|---|---|
| `app/src/main/res/values/dimens.xml#dimen/additional_horizontal_spacing` | Common | 应用自身资源 | values | `resources/base/element/float.json#additional_horizontal_spacing` | merged into json | 0dp → 0vp |
| `app/src/main/res/values/dimens.xml#dimen/drawer_corner_size` | Common | 应用自身资源 | values | `resources/base/element/float.json#drawer_corner_size` | merged into json | 16dp → 16vp |
| `app/src/main/res/values/dimens.xml#dimen/floating_select_menu_height` | Common | 应用自身资源 | values | `resources/base/element/float.json#floating_select_menu_height` | merged into json | 112dp → 112vp |
| `app/src/main/res/values/integers.xml#integer/subscriptions_default_num_of_columns` | Common | 应用自身资源 | values | `resources/base/element/integer.json#subscriptions_default_num_of_columns` | merged into json | Value: 3 |
| `app/src/main/res/values/integers.xml#integer/nav_drawer_screen_size_percent` | Common | 应用自身资源 | values | `resources/base/element/integer.json#nav_drawer_screen_size_percent` | merged into json | Value: 80 |
| `app/src/main/res/values/integers.xml#integer/swipe_refresh_distance` | Common | 应用自身资源 | values | `resources/base/element/integer.json#swipe_refresh_distance` | merged into json | Value: 300 |
| `app/src/main/res/values/svg.xml#string/svg_animatable_play` | Common | 应用自身资源 | values | `resources/base/element/string.json#svg_animatable_play` | merged into json | Path data string (translatable=false) |
| `app/src/main/res/values/svg.xml#string/svg_animatable_pause` | Common | 应用自身资源 | values | `resources/base/element/string.json#svg_animatable_pause` | merged into json | Path data string (translatable=false) |
| `app/src/main/res/values/design_time_attributes.xml#string/design_time_lorem_ipsum` | Common | 应用自身资源 | values | `resources/base/element/string.json#design_time_lorem_ipsum` | merged into json | Design-time placeholder |
| `app/src/main/res/values/design_time_attributes.xml#string/design_time_downloaded_log_failure_reason` | Common | 应用自身资源 | values | `resources/base/element/string.json#design_time_downloaded_log_failure_reason` | merged into json | Design-time placeholder |
| `app/src/main/res/values/attrs.xml#declare-styleable/NestedScrollableHost` | Common | 应用自身资源 | values | N/A | unmappable | declare-styleable has no HarmonyOS equivalent; handle as component props |
| `app/src/main/res/values/ids.xml#id/*` (25 items) | Common | 应用自身资源 | values | N/A | unmappable | IDs are code-level concerns in HarmonyOS |

### Drawable → Media

| Android Resource Path | Android Screen(s) | Android Source Category | Android Type Category | HarmonyOS Target | Mapping Kind | Notes |
|---|---|---|---|---|---|---|
| `app/src/main/res/drawable/ic_animate_play.xml` | Common | 应用自身资源 | drawable | `resources/base/media/ic_animate_play.svg` | svg conversion | Vector → SVG; ?attr fillColor → #000000; @string pathData resolved |
| `app/src/main/res/drawable/ic_animate_pause_play.xml` | Common | 应用自身资源 | drawable | N/A | unmappable | animated-vector; requires animation timing |
| `app/src/main/res/drawable/ic_animate_play_pause.xml` | Common | 应用自身资源 | drawable | N/A | unmappable | animated-vector; requires animation timing |
| `app/src/main/res/drawable/bg_episode_list_item.xml` | Common | 应用自身资源 | drawable | `resources/base/media/bg_episode_list_item.svg` | fallback applied | Ripple unconvertible; extracted transparent default state; state handling needs ArkUI code |
| `app/src/main/res/drawable/grey_border.xml` | Common | 应用自身资源 | drawable | `resources/base/media/grey_border.svg` | fallback applied | Ripple unconvertible; extracted border shape; stroke color defaulted to #757575 |
| `app/src/main/res/drawable/ic_shortcut_feed.xml` | Launcher | 应用自身资源 | drawable | `resources/base/media/ic_shortcut_feed.svg` | svg conversion | Layer-list → SVG; inlined background oval + foreground icon |
| `app/src/main/res/drawable/ic_shortcut_playlist.xml` | Launcher | 应用自身资源 | drawable | `resources/base/media/ic_shortcut_playlist.svg` | svg conversion | Layer-list → SVG |
| `app/src/main/res/drawable/ic_shortcut_refresh.xml` | Launcher | 应用自身资源 | drawable | `resources/base/media/ic_shortcut_refresh.svg` | svg conversion | Layer-list → SVG |
| `app/src/main/res/drawable/ic_shortcut_subscriptions.xml` | Launcher | 应用自身资源 | drawable | `resources/base/media/ic_shortcut_subscriptions.svg` | svg conversion | Layer-list → SVG |

### Adaptive Icons → Layered-Image

| Android Resource Path | Android Screen(s) | Android Source Category | Android Type Category | HarmonyOS Target | Mapping Kind | Notes |
|---|---|---|---|---|---|---|
| `app/src/main/res/drawable-anydpi-v26/ic_shortcut_feed.xml` | Launcher | 应用自身资源 | drawable | `resources/base/media/ic_shortcut_feed_layered_image.json` | layered-image conversion | bg: $media:grey100_bg; fg: $media:ic_feed_black |
| `app/src/main/res/drawable-anydpi-v26/ic_shortcut_feed.xml` | Launcher | 应用自身资源 | drawable | `resources/base/media/grey100_bg.png` | generated media | Solid #f5f5f5 PNG for color background |
| `app/src/main/res/drawable-anydpi-v26/ic_shortcut_playlist.xml` | Launcher | 应用自身资源 | drawable | `resources/base/media/ic_shortcut_playlist_layered_image.json` | layered-image conversion | bg: $media:grey100_bg; fg: $media:ic_playlist_play_black |
| `app/src/main/res/drawable-anydpi-v26/ic_shortcut_playlist.xml` | Launcher | 应用自身资源 | drawable | `resources/base/media/grey100_bg.png` | generated media | Shared solid #f5f5f5 PNG |
| `app/src/main/res/drawable-anydpi-v26/ic_shortcut_refresh.xml` | Launcher | 应用自身资源 | drawable | `resources/base/media/ic_shortcut_refresh_layered_image.json` | layered-image conversion | bg: $media:grey100_bg; fg: $media:ic_refresh_black |
| `app/src/main/res/drawable-anydpi-v26/ic_shortcut_refresh.xml` | Launcher | 应用自身资源 | drawable | `resources/base/media/grey100_bg.png` | generated media | Shared solid #f5f5f5 PNG |
| `app/src/main/res/drawable-anydpi-v26/ic_shortcut_subscriptions.xml` | Launcher | 应用自身资源 | drawable | `resources/base/media/ic_shortcut_subscriptions_layered_image.json` | layered-image conversion | bg: $media:grey100_bg; fg: $media:ic_subscriptions_black |
| `app/src/main/res/drawable-anydpi-v26/ic_shortcut_subscriptions.xml` | Launcher | 应用自身资源 | drawable | `resources/base/media/grey100_bg.png` | generated media | Shared solid #f5f5f5 PNG |

### Dependency Resources → Media (from :ui:common)

| Android Resource Path | Android Screen(s) | Android Source Category | Android Type Category | HarmonyOS Target | Mapping Kind | Notes |
|---|---|---|---|---|---|---|
| `ui/common/src/main/res/drawable/ic_feed_black.xml` | Launcher | 项目内模块资源 | drawable | `resources/base/media/ic_feed_black.svg` | svg conversion | Vector → SVG; referenced by adaptive icons and layer-lists |
| `ui/common/src/main/res/drawable/ic_playlist_play_black.xml` | Launcher | 项目内模块资源 | drawable | `resources/base/media/ic_playlist_play_black.svg` | svg conversion | Vector → SVG |
| `ui/common/src/main/res/drawable/ic_refresh_black.xml` | Launcher | 项目内模块资源 | drawable | `resources/base/media/ic_refresh_black.svg` | svg conversion | Vector → SVG |
| `ui/common/src/main/res/drawable/ic_subscriptions_black.xml` | Launcher | 项目内模块资源 | drawable | `resources/base/media/ic_subscriptions_black.svg` | svg conversion | Vector → SVG |
| `ui/common/src/main/res/values/colors.xml#color/grey100` | Launcher | 项目内模块资源 | values | `resources/base/media/grey100_bg.png` | generated media | #f5f5f5 → solid 108×108 PNG |

### Layout / Menu / XML → N/A

| Android Resource Path | Android Screen(s) | Android Source Category | Android Type Category | HarmonyOS Target | Mapping Kind | Notes |
|---|---|---|---|---|---|---|
| `app/src/main/res/layout/*.xml` (77 files) | Various | 应用自身资源 | layout | N/A | unmappable | Layout XML has no direct ArkUI equivalent; rebuild with ArkUI components |
| `app/src/main/res/menu/*.xml` (23 files) | Various | 应用自身资源 | menu | N/A | unmappable | Original Android type: menu; rebuild with ArkUI menu components |
| `app/src/main/res/xml/*.xml` (7 files) | Various | 应用自身资源 | xml | N/A | unmappable | Configuration XML; handle case-by-case in HarmonyOS |
| `app/src/main/res/layout-sw720dp/main.xml` | Various | 应用自身资源 | layout | N/A | unmappable | Unsupported qualifier sw720dp + layout type |

### Unsupported Qualifier Directories

| Android Resource Path | Android Screen(s) | Android Source Category | Android Type Category | HarmonyOS Target | Mapping Kind | Notes |
|---|---|---|---|---|---|---|
| `app/src/main/res/values-sw360dp/resource-overrides.xml#bool/config_materialPreferenceIconSpaceReserved` | Unknown | 应用自身资源 | values | N/A | unmappable | Unsupported qualifier: sw360dp |
| `app/src/main/res/values-sw600dp/integers.xml#integer/subscriptions_default_num_of_columns` | Unknown | 应用自身资源 | values | N/A | unmappable | Unsupported qualifier: sw600dp |
| `app/src/main/res/values-w1000dp/dimens.xml#dimen/additional_horizontal_spacing` | Unknown | 应用自身资源 | values | N/A | unmappable | Unsupported qualifier: w1000dp |
| `app/src/main/res/values-w300dp/dimens.xml#dimen/additional_horizontal_spacing` | Unknown | 应用自身资源 | values | N/A | unmappable | Unsupported qualifier: w300dp |
| `app/src/main/res/values-w300dp/dimens.xml#dimen/sd_label_max_width` | Unknown | 应用自身资源 | values | N/A | unmappable | Unsupported qualifier: w300dp |

---

## Unmapped / Unmappable / System / Remote Summary

### Unmappable Drawable Types

| Resource | Type | Reason |
|---|---|---|
| `ic_animate_pause_play.xml` | animated-vector | Requires animation timing/interpolation; no SVG equivalent |
| `ic_animate_play_pause.xml` | animated-vector | Requires animation timing/interpolation; no SVG equivalent |
| `bg_episode_list_item.xml` | inset+ripple | Ripple touch feedback is runtime behavior; only transparent default state extracted |
| `grey_border.xml` | ripple | Ripple touch feedback is runtime behavior; border shape extracted as fallback |

### Unresolved Theme Attribute References

| Reference | Found In | Resolution |
|---|---|---|
| `?attr/action_icon_color` | `drawable/ic_animate_play.xml` | Defaulted to `#000000` (black) |
| `?attr/colorControlHighlight` | `drawable/bg_episode_list_item.xml`, `drawable/grey_border.xml` | Ripple color — unresolvable, not included in SVG |
| `?attr/colorSecondaryContainer` | `drawable/bg_episode_list_item.xml` | State-dependent shape fill — unresolvable, not included in SVG |
| `?android:attr/textColorSecondary` | `drawable/grey_border.xml` | Defaulted to `#757575` (Material grey 600) |

### Resolved System Resource References

| Reference | Found In | Resolved Value |
|---|---|---|
| `@android:color/black` | `drawable/bg_episode_list_item.xml` (mask) | `#ff000000` — not included (mask only) |
| `@android:color/white` | `drawable/grey_border.xml` (mask) | `#ffffffff` — not included (mask only) |
| `@android:color/transparent` | `drawable/bg_episode_list_item.xml` (default state) | `#00000000` — transparent default state |

### Skipped Resource Counts

| Category | Count | Reason |
|---|---|---|
| Layout XML | 77 | No ArkUI equivalent |
| Menu XML | 23 | No HarmonyOS equivalent |
| Configuration XML | 7 | No direct equivalent |
| Unsupported qualifier dirs | 5 | sw/w qualifiers have no HarmonyOS mapping |
| ID resources | 25 | Code-level concerns |
| Styleable attributes | 1 | No HarmonyOS equivalent |

---

## Quick Findings

- **Modular architecture**: The `app/src/main/res/` directory is lean — most strings live in `:ui:i18n` and colors in `:ui:common`. Only app-module-specific resources were in scope.
- **Shortcut icons**: 4 launcher shortcut icons exist as both layer-list (drawable/) and adaptive-icon (drawable-anydpi-v26/) variants. Both were converted — layer-lists to composed SVGs, adaptive-icons to layered-image JSONs.
- **Animated vectors**: 2 animated-vector drawables (`ic_animate_pause_play`, `ic_animate_play_pause`) are unmappable — they require path morph animations that need ArkUI code.
- **Ripple drawables**: 2 drawables use ripple touch feedback (`bg_episode_list_item`, `grey_border`). Only static fallback states were extracted; interactive states need ArkUI implementation.
- **Color background workaround**: `@color/grey100` (#f5f5f5) referenced as adaptive-icon background was resolved to a generated 108×108 solid-color PNG (`grey100_bg.png`) since HarmonyOS layered-image only accepts `$media:` references.
- **Theme attributes**: Multiple `?attr/*` references could not be statically resolved and were defaulted — developer should verify these defaults match the intended theme.
