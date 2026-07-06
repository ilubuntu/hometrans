# Android to HarmonyOS Resource Conversion Report

## Build Status
- Build attempted: No (APK provided directly)
- Build result: Skipped (using provided APK)
- APK source: freshly provided `app/build/outputs/apk/debug/app-debug.apk`
- APK decompiled with apktool 3.0.1: Success
- Resource source: decompiled APK (complete merged resource set incl. library dependencies)
- Resource source path: `decompiled APK -> res/`

## Summary
- Resource source: decompiled APK (complete)
- Total Android resource files found: 157
- Successfully converted: 126
- Unmappable (no HarmonyOS equivalent): 31
- Failed: 0
- Resource references resolved: 1
- Unresolved references (theme attributes): 1
- Unresolved references (library missing): 0 (decompiled APK is complete)

## Library Dependencies (from APK)
| Library | Likely Resource Prefixes |
|---|---|
| Material Components (com.google.android.material) | m3c_*, mc2_*, design_*, material_*, mtrl_* |
| AndroidX Core (androidx.core) | notification_*, call_notification_*, androidx_core_*, status_bar_notification_* |
| AndroidX AppCompat (androidx.appcompat) | abc_* |
| AndroidX SplashScreen (androidx.core:splashscreen) | splashscreen_*, compat_splash_* |
| AndroidX Navigation / Fragment | fragment_* (anim/animator) |

## Conversion Details

### Successfully Converted Resources (categories)
| Android Source | HarmonyOS Target | Type | Notes |
|---|---|---|---|
| values/strings.xml + 90 locale variants | resources/{base,<locale>}/element/string.json | values→element | 98 base strings + ~90 locale files (library + app_name) |
| values/colors.xml | resources/base/element/color.json | values→element | 9 colors (brand_*, white, black, notification_*, androidx_core_*) |
| values/dimens.xml | resources/base/element/float.json | values→element | 29 dimens (dp→vp, sp→fp) |
| values/integers.xml + values-v30 | resources/base/element/integer.json | values→element | 3 integers (JSON numbers) |
| values/drawables.xml | resources/base/element/color.json | values→element | 2 color drawables merged into color.json |
| drawable/*.xml (vectors/shapes) | resources/base/media/*.svg | svg conversion | ic_launcher_background (gradient), ic_launcher_foreground, ic_splash_logo, ic_call_*, notification_*, icon_background, compat_splash_* |
| drawable-{hdpi,mdpi,xhdpi}/*.9.png | resources/{ldpi,mdpi,xldpi}/media/*_9.png | rename | 12 nine-patch files (stretch behavior lost) |
| drawable-{hdpi,mdpi,xhdpi}/*.png | resources/{ldpi,mdpi,xldpi}/media/*.png | direct copy | notification_oversize_large_icon_bg.png, notify_panel_notification_icon_bg.png |
| mipmap-anydpi/ic_launcher*.xml | resources/base/media/ic_launcher*_layered_image.json | layered-image | adaptive-icon → layered-image JSON |
| font/plus_jakarta_sans.ttf | resources/rawfile/fonts/plus_jakarta_sans.ttf | direct copy | app font |

### Qualifier Mappings Applied
| Android Qualifier Dir | HarmonyOS Qualifier Dir | Files Converted |
|---|---|---|
| values (default) | base/element | 5 XML files (strings/colors/dimens/integers/drawables) |
| values-<lang> (~70 locales) | <lang>/element | strings.json each |
| values-<lang>-r<REGION> (~20 locales) | <lang>_<REGION>/element | strings.json each |
| values-b+sr+Latn | sr_Latn/element | strings.json |
| values-night, values-v27..v31 | (stripped; only styles → unmappable) | — |
| values-watch | (stripped → base; only dimens, merged) | dimens merged into base/float.json |
| drawable-hdpi / mdpi / xhdpi | ldpi / mdpi / xldpi (media) | 16 files |
| mipmap-anydpi | base/media | 2 adaptive-icon XML |

### Resource Reference Resolution
| Resource File | Reference | Resolved Value | Resolution Chain |
|---|---|---|---|
| base/element/color.json#notification_action_color_filter | @color/androidx_core_secondary_text_default_material_light | #8a000000 | @color/... → #8a000000 |

### Layout & Menu Resource Dependencies
| Source File (not converted) | Dependencies | All Satisfied? |
|---|---|---|
| layout/notification_*.xml (8 files) | @dimen/notification_* ✅ (converted), @id/* (n/a), @style/* (unmappable), @layout/* (not converted) | Yes (convertible deps satisfied) |
| layout/custom_dialog.xml, ime_*.xml, splash_screen_view.xml | @id/* only | Yes (no convertible deps) |
| (no menu/ directory present) | — | — |

### Unmappable Resources
| Android Source | Reason |
|---|---|
| layout/*.xml (10 files) | Layout XML has no HarmonyOS equivalent (use ArkUI) |
| values*/styles.xml (7 files) | Styles/themes have no HarmonyOS JSON equivalent |
| values/attrs.xml, values/public.xml, values/ids.xml | Attribute/ID declarations, no equivalent |
| anim/fragment_fast_out_extra_slow_in.xml | Tween animation, no SVG equivalent |
| animator/fragment_*.xml (6 files) | Property animation, no equivalent |
| color/vector_tint_*.xml (2 files) | Color state list (selector), no equivalent |
| mipmap-anydpi/ic_launcher*.xml#monochrome | monochrome layer has no layered-image equivalent |
| drawable/$ic_launcher_background__0.xml | apktool-extracted gradient fragment (inlined into parent SVG) |

### Nine-Patch Files Renamed
| Original Name | Renamed To | Source Directory |
|---|---|---|
| notification_bg_low_normal.9.png | notification_bg_low_normal_9.png | res/drawable-hdpi |
| notification_bg_low_pressed.9.png | notification_bg_low_pressed_9.png | res/drawable-hdpi |
| notification_bg_normal.9.png | notification_bg_normal_9.png | res/drawable-hdpi |
| notification_bg_normal_pressed.9.png | notification_bg_normal_pressed_9.png | res/drawable-hdpi |
| notification_bg_low_normal.9.png | notification_bg_low_normal_9.png | res/drawable-mdpi |
| notification_bg_low_pressed.9.png | notification_bg_low_pressed_9.png | res/drawable-mdpi |
| notification_bg_normal.9.png | notification_bg_normal_9.png | res/drawable-mdpi |
| notification_bg_normal_pressed.9.png | notification_bg_normal_pressed_9.png | res/drawable-mdpi |
| notification_bg_low_normal.9.png | notification_bg_low_normal_9.png | res/drawable-xhdpi |
| notification_bg_low_pressed.9.png | notification_bg_low_pressed_9.png | res/drawable-xhdpi |
| notification_bg_normal.9.png | notification_bg_normal_9.png | res/drawable-xhdpi |
| notification_bg_normal_pressed.9.png | notification_bg_normal_pressed_9.png | res/drawable-xhdpi |

### System Resources Resolved
| Resource File | System Reference | Resolved Value |
|---|---|---|
| base/element/color.json#notification_action_color_filter | @color/androidx_core_secondary_text_default_material_light | #8a000000 |

### Unresolved References (Fallback / Kept)
| Resource File | Original Reference | Fallback Value | Reason | Likely Source |
|---|---|---|---|---|
| base/element/float.json#splashscreen_icon_size | ?splashScreenIconSize | (kept) | theme attribute | androidx.core:splashscreen |

### Placeholder Resources Created
None required — no `$r('app.media.*')` / `$r('app.string.*')` references in existing `.ets` files were missing. All `module.json5` / `app.json5` references (`$string:app_name`, `$media:layered_image`, `$media:startIcon`, `$color:start_window_background`, `$string:EntryAbility_*`, `$string:module_desc`, `$profile:*`) resolve to existing resources.

### Failed Conversions
None.

### Verification Results
- All resources accounted for: Yes (157 files: 126 converted, 31 unmappable, 0 failed)
- Missing resources: None
- All convertible references resolved: Yes (1 value-ref resolved; 1 theme-attr kept)
- Existing HarmonyOS config references (`module.json5`, `app.json5`) all satisfied
- AppScope `app_name` preserved (not overwritten)

> Full per-resource audit: see `resource_mapping.md` in the HarmonyOS project root.