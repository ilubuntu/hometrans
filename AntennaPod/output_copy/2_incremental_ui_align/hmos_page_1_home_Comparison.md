# Page 1 (Home) — UI Comparison (Android ground truth vs HarmonyOS)

| UI Component | 文本内容 | 尺寸与布局 | 颜色与背景 | 边框与轮廓 | 文本样式 | 变换与效果 | 状态与交互反馈 | Diff |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| Toolbar title | A="Home"(home_label) / H="首页"(home_label) | A=56vp actionBarSize / H=56vp | 一致 #F9FCFF | 一致 | A=TitleMedium 16sp Medium / H=**20fp** Medium → 字号偏大 | — | — | **字号: H 20fp → 目标 16fp** (home_fragment.xml MaterialToolbar title) |
| Toolbar Search | 一致 | A=48×48 / H=48×48 | 一致 | 一致 | icon 24 一致 | — | 一致 | ✅ |
| Toolbar Overflow | 一致 | A=48×48 (Button) / H=**28×28 (Image, 非按钮)** | A=transparent Button / H=无背景 Image | — | A=ic_more_vert / H=dots_vertical 28 | — | A=Button ripple / H=Image click | **尺寸: 28→目标 48×48; 应为 Button 透明背景** |
| Section 标题 | 一致 | A=TitleMedium 16sp marginStart16 marginV4 / H=18fp padding16/12/4 | 一致 textColorPrimary | — | **字号 18→目标 16fp** | — | 一致 | **字号: H 18fp → 目标 16fp** (TextAppearance.Material3.TitleMedium) |
| Section moreButton | A=TextButton+尾部箭头 / H=纯文本无箭头 | A=paddingH12 paddingV8 marginEnd8 / H=Button 无内边距 | 一致 accent_light | — | A=14sp TextButton / H=**13fp** | — | 一致 | **① 缺尾部 ic_arrow_right_white 图标(iconGravity=end,iconPadding=4dp); ② 字号 13→目标 14fp** (home_section.xml moreButton) |
| Section shuffleButton | A="Get surprised"段可见 ic_shuffle / H=**缺失** | A=wrap marginStart8 marginV4 | A=透明 / H: 缺失 → 目标: 透明 selectableItemBackgroundBorderless | — | A=ic_shuffle / H: 缺失 → 目标: ic_shuffle | — | A=visibility toggle | **缺失 shuffle 按钮 → 目标: 在"Get surprised"段渲染 ImageButton(ic_shuffle) 24vp marginStart8 marginVertical4** (home_section.xml shuffleButton) |
| 横向卡片列表 | — | A=paddingHorizontal16 / H=padding right12 无左padding | 一致 | — | — | — | 一致 | **列表左 padding 缺失: H 无 left padding → 目标: 左右各 16vp** (home_section.xml recyclerView paddingHorizontal=16dp) |
| 卡片项容器 | A=CardView margin4 cornerRadius12 surfaceContainer / H=无 CardView 包裹 | A=Card margin4 / H=width140 margin-left12 无卡片背景 | A=colorSurfaceContainer 卡片背景 / H: 缺失 → 目标: colorSurfaceContainer 浅灰卡片背景 | A=cornerRadius12dp elevation0 / H: 缺失 → 目标: borderRadius12 | — | A=clipToOutline / H: 无 | — | **缺失卡片容器: 需用带 borderRadius12 + colorSurfaceContainer 背景的容器包裹, 卡片 margin 4vp** (horizontal_itemlist_item.xml CardView) |
| 卡片封面 | 一致(cover) | A=**128×128dp** / H=**140×140vp** | A=frame bg image_readability_tint #80000000 / H=bg non_square_icon_background #22777777 (差异) | A=cornerRadius12 / H=**borderRadius8** | — | 一致 Cover | — | **① 尺寸 140→目标 128vp; ② 圆角 8→目标 12vp; ③ 背景 tint #22777777→目标 #80000000 (image_readability_tint)** (horizontal_itemlist_item.xml) |
| 卡片 secondaryActionIcon (Play/Download 圆形叠加) | A="Play"/"Download" / H=**缺失** | A=48×48dp bottom-end margin4 padding12 → 图标24dp | A=tint colorOnPrimary(白) 叠 bg_circle 半透明 / H: 缺失 → 目标: 白色图标+半透明圆底 | A=圆形 bg_circle / H: 缺失 → 目标: 圆形 | — | — | A=clickable | **缺失卡片右下角圆形 play/download 叠加按钮 → 目标: 48vp 圆形容器 bottom-end, bg_circle 半透明背景, 内嵌 24vp ic_play_24dp/ic_download tint 白** (horizontal_itemlist_item.xml secondaryActionIcon) |
| 卡片标题 | 一致 | A=width128 marginTop4 paddingH4 lines2 / H=width140 无marginTop | 一致 #000000 | — | A=**14sp** / H=**13fp** | — | 一致 | **① 字号 13→目标 14fp; ② 宽度 140→128vp (随封面); ③ 缺 marginTop4vp, paddingH4vp** (horizontal_itemlist_item.xml titleLabel) |
| 卡片日期 | 一致 | A=paddingH4 marginBottom4 左对齐 / H=margin top2 居中显示 | A=textColorSecondary grey600 / H=grey600 | — | A=**14sp** / H=**12fp** | — | — | **① 字号 12→目标 14fp; ② 对齐: 居中→目标 左对齐(textStart); ③ paddingH4vp** (horizontal_itemlist_item.xml dateLabel) |
| Mini Player 整体 | 一致 | A=64dp(external_player_height) / H=**72vp** | 一致 background_light | — | — | — | 一致 | **高度 72→目标 64vp** (external_player_fragment.xml external_player_height=64dp; float.json external_player_height=64vp) |
| Mini 封面 | 一致 | A=height match_parent(~60dp) maxWidth96 / H=56×56 | bg 差异: A=non_square_icon_background / H=non_square_icon_background ✓ | — | — | 一致 | — | **尺寸 56×56→目标 height~60vp maxWidth96** (次要, 可保留56) |
| Mini 标题/作者 | 一致 | 一致 | 一致 | — | A=Body1 14sp / H=14fp ✓ | — | — | ✅ |
| Mini 播放按钮 | A="Pause" / H="Pause" | A=**52×64dp** padding8 ic_play_48dp / H=**28×28** | 一致 透明 | — | A=ic_play_48dp / H=ic_pause 28 | — | 一致 | **尺寸 28×28→目标 52vp宽×64vp高, icon ic_play_48dp/ic_pause, padding8vp** (external_player_fragment.xml butPlay) |
| Mini 进度条 | 一致 | 一致 4dp | 一致 accent | — | 一致 | — | — | ✅ |
| BottomNav 高度 | — | A=64dp / H=64vp | 一致 | — | — | — | — | ✅ |
| BottomNav 项 padding | — | A=itemPaddingTop6 itemPaddingBottom12 / H=无 padding, 仅 margin top4 | 一致 | — | 一致 12 | — | 一致 | **项 padding: 缺 top6vp/bottom12vp** (main.xml BottomNavigationView itemPaddingTop6/itemPaddingBottom12) |
| 卡片列表高度 | — | A=wrap (随卡片) / H=固定 200vp | — | — | — | — | — | **固定 200→目标 wrap (随封面128+标题+日期, 约 196vp); 可保留但应自适应** |
| Downloads 区段图标 | A=EpisodeListItem 复用 / H=EpisodeListItem 复用 | — | — | — | — | — | — | ✅ (复用一致) |
