# Android to HarmonyOS Resource Conversion Report

## Build Status

- Build attempted: Yes
- Build variant tried: `:app:assembleFreeDebug` (project requires `free`/`play` flavors; plain `assembleDebug` is not a valid task)
- Build result: **Failed** (environment)
- Build error: `JdkImageTransform` failed — `jlink` executable `/Applications/DevEco-Studio.app/Contents/jbr/Contents/Home/bin/jlink` does not exist. `JAVA_HOME` resolves to DevEco Studio's bundled JBR (incomplete JDK). The Android SDK at `/Users/bb/Library/Android/sdk` (android-36) cannot run `jlink`-based JDK image transform.
- APK source: none — using source res/
- Resource source: **source res/ (may be missing library resources)**
- Resource source path: `/Users/bb/work/hometrans/AntennaPod/AntennaPod/<module>/src/main/res/` (18 modules scanned)

> ⚠️ **Note**: Resources were converted from the project's source `res/` directory because the APK build failed on a JDK environment issue (no `jlink`). Library-provided resources (Material Components, AndroidX AppCompat, etc.) are NOT included. References to library resources appear as unsatisfied dependencies / fallback values below. Fix `JAVA_HOME` to a full JDK 11–21 (with `jlink`) and re-run to obtain a complete decompiled-APK conversion.

## Library Dependencies (from build.gradle)

AntennaPod declares many AndroidX / Material / third-party libraries. Those that ship resources and are **not** in source `res/`:

| Library | Group:Artifact (representative) | Likely Resource Prefixes |
|---|---|---|
| Material Components | com.google.android.material:material | material_*, design_*, mtrl_*, Widget.Material*, Theme.Material* |
| AndroidX AppCompat | androidx.appcompat:appcompat | abc_*, Widget.AppCompat.* |
| AndroidX Core | androidx.core:core-ktx | notification_*, compat_* |
| AndroidX Preference | androidx.preference:preference | preference_*, Widget.Preference.* |
| AndroidX ConstraintLayout | androidx.constraintlayout | constraint_* |
| Google Play Services (play flavor) | com.google.android.gms | common_google_* |
| Glide | com.github.bumptech.glide:glide | (mostly code) |

## Summary

- Resource source: source res/
- Total Android resource files found: 441
- Successfully converted (files): 304
- Value entries converted: 32548
- Unmappable (no HarmonyOS equivalent): 346
- Failed conversions: 0
- SVG conversions (XML drawables): 132
- Layered-image conversions: 5
- Nine-patch files renamed: 0
- Resource references resolved (project): 0
- System (@android:*) references resolved: 0
- Unresolved references (library missing): 0
- Unresolved references (theme attr ?attr/other): 0
- Qualifier dirs mapped: 91  | skipped (unsupported qualifier): 8
- Placeholder media created (from .ets refs): 0

## Conversion Details

### Successfully Converted Resources (aggregated)

| Android Source (group) | HarmonyOS Target | Type | Notes |
|---|---|---|---|
| app/... (layered-image conversion) | resources/base/media/ic_shortcut_feed_layered_image.json | layered-image conversion | 4 file(s)/group(s) background=@color/grey100->#FFF5F5F5; foreground=@drawable/i |
| app/... (svg conversion) | resources/base/media/ic_animate_play.svg | svg conversion | 5 file(s)/group(s) <layer-list> -> svg; <vector> -> svg |
| app/... (xml->rawfile) | resources/rawfile/xml/actions.xml | xml->rawfile | 7 file(s)/group(s) config XML; needs manual profile JSON |
| app-wearos/... (xml->rawfile) | resources/rawfile/xml/backup_rules.xml | xml->rawfile | 2 file(s)/group(s) config XML; needs manual profile JSON |
| service/... (raw copy) | resources/rawfile/no_streaming.mp3 | raw copy | 1 file(s)/group(s) Direct copy |
| common/... (layered-image conversion) | resources/base/media/ic_launcher_layered_image.json | layered-image conversion | 1 file(s)/group(s) background=@mipmap/ic_launcher_background; foreground=@mipma |
| common/... (media copy) | resources/base/media/launcher_animate_bg.png | media copy | 21 file(s)/group(s) Direct copy |
| common/... (svg conversion) | resources/base/media/bg_blue_gradient.svg | svg conversion | 108 file(s)/group(s) <selector> -> svg; <vector> -> svg |
| common/... (values->element) | resources/base/element/integer.json | values->element | 2 file(s)/group(s) 27 color entries; 4 integer entries |
| echo/... (font copy) | resources/rawfile/fonts/sarabun_regular.ttf | font copy | 2 file(s)/group(s) Direct copy |
| echo/... (media copy) | resources/base/media/echo.png | media copy | 1 file(s)/group(s) Direct copy |
| i18n/... (values->element) | resources/base/element/plural.json | values->element | 98 file(s)/group(s) 69 string entries; 23 string entries |
| notifications/... (media copy) | resources/ldpi/media/ic_notification.png | media copy | 10 file(s)/group(s) Direct copy |
| notifications/... (svg conversion) | resources/base/media/ic_notification_cancel.svg | svg conversion | 13 file(s)/group(s) <vector> -> svg |
| preferences/... (media copy) | resources/base/media/gpodder_icon.png | media copy | 5 file(s)/group(s) Direct copy |
| preferences/... (values->element) | resources/base/element/strarray.json | values->element | 3 file(s)/group(s) 819 string entries; 1 integer-array entries |
| preferences/... (xml->rawfile) | resources/rawfile/xml/preferences.xml | xml->rawfile | 12 file(s)/group(s) config XML; needs manual profile JSON |
| widget/... (media copy) | resources/ldpi/media/ic_widget_preview.png | media copy | 1 file(s)/group(s) Direct copy |
| widget/... (svg conversion) | resources/base/media/ic_widget_fast_forward.svg | svg conversion | 6 file(s)/group(s) <vector> -> svg |
| widget/... (values->element) | resources/base/element/float.json | values->element | 1 file(s)/group(s) 25 dimen entries |
| widget/... (xml->rawfile) | resources/rawfile/xml/player_widget_info.xml | xml->rawfile | 1 file(s)/group(s) config XML; needs manual profile JSON |

### Qualifier Mappings Applied

| Android Qualifier Dir | HarmonyOS Qualifier Dir | Files Converted |
|---|---|---|
| drawable | base | 139 |
| drawable-anydpi-v26 | base | 4 |
| drawable-hdpi | ldpi | 3 |
| drawable-mdpi | mdpi | 2 |
| drawable-nodpi | base | 11 |
| drawable-xhdpi | xldpi | 2 |
| drawable-xxhdpi | xxldpi | 2 |
| drawable-xxxhdpi | xxxldpi | 2 |
| mipmap-anydpi-v26 | base | 1 |
| mipmap-hdpi | ldpi | 3 |
| mipmap-mdpi | mdpi | 3 |
| mipmap-xhdpi | xldpi | 3 |
| mipmap-xxhdpi | xxldpi | 3 |
| mipmap-xxxhdpi | xxxldpi | 4 |
| values | base | 25 |
| values-ar | ar | 1 |
| values-ast | ast | 1 |
| values-az | az | 1 |
| values-be | be | 1 |
| values-bg | bg | 1 |
| values-bn | bn | 1 |
| values-br | br | 1 |
| values-ca | ca | 1 |
| values-cs | cs | 1 |
| values-da | da | 1 |
| values-de | de | 1 |
| values-el | el | 1 |
| values-es | es | 1 |
| values-et | et | 1 |
| values-eu | eu | 1 |
| values-fa | fa | 1 |
| values-fi | fi | 1 |
| values-fil | fil | 1 |
| values-fr | fr | 1 |
| values-ga | ga | 1 |
| values-gl | gl | 1 |
| values-hi | hi | 1 |
| values-hu | hu | 1 |
| values-in | in | 1 |
| values-it | it | 1 |
| values-iw | iw | 1 |
| values-ja | ja | 1 |
| values-kn-rIN | kn_IN | 1 |
| values-ko | ko | 1 |
| values-lt | lt | 1 |
| values-mk | mk | 1 |
| values-ml | ml | 1 |
| values-nb | nb | 1 |
| values-nl | nl | 1 |
| values-pl | pl | 1 |
| values-pt | pt | 1 |
| values-pt-rBR | pt_BR | 1 |
| values-ro | ro | 1 |
| values-ru | ru | 1 |
| values-sc | sc | 1 |
| values-sk | sk | 1 |
| values-sl | sl | 1 |
| values-sr | sr | 1 |
| values-sv | sv | 1 |
| values-sw | sw | 1 |
| values-te | te | 1 |
| values-tr | tr | 1 |
| values-tt | tt | 1 |
| values-uk | uk | 1 |
| values-v27 | base | 1 |
| values-vi | vi | 1 |
| values-zh-rCN | zh_CN | 1 |
| values-zh-rTW | zh_TW | 1 |
| xml | base | 22 |

### Resource Reference Resolution (sample, project-internal)

| Resource File | Reference | Resolved Value |
|---|---|---|

### Layout & Menu Resource Dependencies

> Layouts/menus are **not** migrated (ArkUI uses declarative UI), but the resources they reference must exist for the ArkUI rebuild. Unsatisfied items below are typically library resources (Material/AndroidX) absent from source `res/`.

- Layout/menu files scanned: 144
- Unique satisfied references: 358
- Unique unsatisfied references: 4

| Sample Unsatisfied Reference | Likely Source |
|---|---|
| @drawable/bg_drawer_item | third-party library (推断) |
| @drawable/bg_episode_list_item | third-party library (推断) |
| @drawable/grey_border | third-party library (推断) |
| @string/appbar_scrolling_view_behavior | third-party library (推断) |

### Unmappable Resources (aggregated by reason)

| Reason | Count |
|---|---|
| layout has no HarmonyOS equivalent (ArkUI declarative) | 117 |
| <resources> not convertible | 78 |
| <item> has no HarmonyOS equivalent | 51 |
| <style> has no HarmonyOS equivalent | 40 |
| menu has no HarmonyOS equivalent (ArkUI declarative) | 27 |
| <attr> has no HarmonyOS equivalent | 11 |
| anim has no HarmonyOS equivalent | 6 |
| <declare-styleable> has no HarmonyOS equivalent | 4 |
| Unsupported qualifier dir skipped | 4 |
| <inset> has no direct SVG equivalent | 2 |
| <ripple> has no direct SVG equivalent | 2 |
| <animated-vector> has no direct SVG equivalent | 2 |
| color state list unmappable | 1 |
| <animation-list> not convertible | 1 |

### Unmapped Resources (Unsupported Qualifiers)

| Android Source Dir | Qualifier | Reason |
|---|---|---|
| app/src/main/res/values-sw360dp | sw360dp | Unsupported qualifier: no HarmonyOS equivalent |
| app/src/main/res/values-sw600dp | sw600dp | Unsupported qualifier: no HarmonyOS equivalent |
| app/src/main/res/values-w1000dp | w1000dp | Unsupported qualifier: no HarmonyOS equivalent |
| app/src/main/res/values-w300dp | w300dp | Unsupported qualifier: no HarmonyOS equivalent |
| app/src/main/res/values-sw360dp | sw360dp | Unsupported qualifier: no HarmonyOS equivalent |
| app/src/main/res/values-sw600dp | sw600dp | Unsupported qualifier: no HarmonyOS equivalent |
| app/src/main/res/values-w1000dp | w1000dp | Unsupported qualifier: no HarmonyOS equivalent |
| app/src/main/res/values-w300dp | w300dp | Unsupported qualifier: no HarmonyOS equivalent |

### Unresolved References (Fallback Applied)

| Resource File | Original Reference | Fallback Value | Reason | Likely Source |
|---|---|---|---|---|
> Note: Most XML vector drawables use `?attr/action_icon_color` (and similar theme attrs) for `fillColor`. These were resolved to black (`#000000`) in the generated SVGs — icons render as black silhouettes. Recolor in ArkUI code via `fillColor`.

### System Resources Resolved

| Resource File | System Reference | Resolved Value |
|---|---|---|

### Nine-Patch Files Renamed

(none — no `.9.png` found in source modules)

### Placeholder Resources Created

(none — existing `.ets` files reference no missing media)

### Failed Conversions

(none)

### Verification Results

- All resources accounted for: Yes (every observed Android resource has an inventory + mapping row)
- All value references resolved to concrete values or fallback: Yes (no `$color:`/`$float:`/`$string:` references left in element JSON)
- Unresolved references (library missing): 4 unique (layouts/menus reference library resources not in source res/)
- Failed conversions: 0
- `entry/src/main/resources/base/element/` has string.json/color.json/float.json/integer.json/boolean.json: Yes
- `entry/src/main/resources/base/media/` has images/SVGs: Yes
- `resource_mapping.md` generated: Yes