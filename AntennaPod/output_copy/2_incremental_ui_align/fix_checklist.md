# Fix Checklist
# 源: 5 份 UI_comparison.md。值均已追溯至 Android layout XML (见各条引用)。

## Page 1: home (HomePage.ets + shared components)
- [x] 1.1 AppToolbar 标题字号 20→16fp (home_fragment.xml MaterialToolbar TitleMedium) [共享, 影响所有页]
- [x] 1.2 AppToolbar Overflow 由 28×28 Image 改 48×48 透明 Button (home_fragment.xml action item 48dp) [共享]
- [x] 1.3 Section 标题字号 18→16fp (TextAppearance.Material3.TitleMedium) — HomePage SectionHeader
- [x] 1.4 Section moreButton 字号 13→14fp 且加尾部 ic_arrow_right_white 图标 (home_section.xml moreButton iconGravity=end iconPadding=4dp)
- [x] 1.5 "Get surprised" 段补 shuffle ImageButton ic_shuffle 24vp marginStart8 marginV4 (home_section.xml shuffleButton)
- [x] 1.6 横向卡片列表补左 padding 16vp (home_section.xml recyclerView paddingHorizontal=16dp)
- [x] 1.7 卡片容器包 CardView: borderRadius12vp + backgroundColor colorSurfaceContainer + margin 4vp (horizontal_itemlist_item.xml CardView)
- [x] 1.8 卡片封面 140→128vp; 圆角 8→12vp; 背景 #22777777→image_readability_tint(#80000000) (horizontal_itemlist_item.xml cover frame)
- [x] 1.9 卡片补 secondaryActionIcon: 48vp 圆形 bg_circle + 24vp ic_play_24dp/ic_download tint 白, bottom-end (horizontal_itemlist_item.xml secondaryActionIcon)
- [x] 1.10 卡片标题 13→14fp; 宽 140→128vp; marginTop4vp; paddingH4vp (horizontal_itemlist_item.xml titleLabel 14sp)
- [x] 1.11 卡片日期 12→14fp; 对齐 居中→左对齐(TextAlign.Start); paddingH4vp (horizontal_itemlist_item.xml dateLabel 14sp textStart)
- [x] 1.12 MiniPlayerBar 高度 72→64vp (external_player_fragment.xml external_player_height=64dp)
- [x] 1.13 MiniPlayerBar 播放按钮 28×28→52vp宽×64vp高, ic_play_48dp/ic_pause, padding8 (external_player_fragment.xml butPlay 52dp)
- [x] 1.14 BottomNav 项补 padding top6vp/bottom12vp (main.xml BottomNavigationView itemPaddingTop6/itemPaddingBottom12)

## Page 2: subscriptions (SubscriptionsPage.ets)
- [x] 2.1 (共享 1.1/1.2 已修)
- [x] 2.2 Grid 减小 padding/gap: padding l/r 12→贴边小padding(项padding4); gap 8→保留小gap (subscription_grid_item.xml padding=4dp)
- [x] 2.3 网格项包 CardView: borderRadius12vp + elevation + colorSurface 背景 (subscription_grid_item.xml outerContainer cornerRadius12 elevation1)
- [x] 2.4 封面圆角 8→12vp (subscription_grid_item.xml cardCornerRadius12)
- [x] 2.5 数量角标位置 底部→右上角(top-end) (subscription_grid_item.xml countViewPill alignParentEnd)
- [x] 2.6 数量角标样式: 字号12→14fp; 文字白→accent_light(colorPrimary); 背景 #80000000→bg_pill (subscription_grid_item.xml countViewPill TextPill 14sp)
- [x] 2.7 网格项封面下补 titleLabel: feed.title 14fp lines2 左对齐 textColorPrimary (subscription_grid_item.xml titleLabel)
- [x] 2.8 FAB 图标 28→24vp (FloatingActionButton ic_add; 次要)

## Page 3: feed_detail (FeedDetailPage.ets)
- [x] 3.1 (共享 1.1/1.2 已修)
- [x] 3.2 FeedHeaderView 封面移除 border width1 (feeditemlist_header.xml coverHolder elevation0 无边框)
- [x] 3.3 按钮条 spacer 140→148vp (feeditemlist_header.xml buttonContainer View 148dp)
- [x] 3.4 EpisodeListItem 封面 64→56vp; marginEnd 12→16vp; marginV 12→11vp (feeditemlist_item.xml coverHolder thumbnail_length_queue_item=56vp)

## Page 4: episode_detail (EpisodeDetailPage.ets)
- [x] 4.1 (共享 1.1/1.2 已修)
- [x] 4.2 EpisodeCoverHeader 封面 300→56vp, 改为左对齐 (feeditem_fragment.xml imgvCover 56dp center_vertical)
- [x] 4.3 Header 结构 纵向居中→横向(cover56 左 + 文本列 右), padding 24→16vp (feeditem_fragment.xml header padding16)
- [x] 4.4 播客名 居中→左对齐; 字号 14→13fp (feeditem_fragment.xml txtvPodcast ListItemSecondaryTitle)
- [x] 4.5 单集标题 居中→左对齐; 字号 20→16fp; maxLines 2→5 (feeditem_fragment.xml txtvTitle 16sp maxLines5)
- [x] 4.6 补 duration · pubDate 行 (13fp sec 左对齐) (feeditem_fragment.xml txtvDuration/txtvPublished)
- [x] 4.7 补 Stream/Download 双大按钮行(各weight1, icon24+文本) (feeditem_fragment.xml butAction1/butAction2)
- [x] 4.8 补 1vp grey100 分隔线 (header 与 shownotes 间) (feeditem_fragment.xml divider)

## Page 5: audio_player (AudioPlayerPage.ets)
- [x] 5.1 (共享 1.1/1.2 已修)
- [x] 5.2 播客标题拼接 "podcastTitle ・ pubDate" (audioplayer_fragment.xml txtvPodcastTitle)
- [x] 5.3 补 Shownotes 居中药丸按钮 (audioplayer_fragment.xml openDescription)
- [x] 5.4 速度/rewind/ff/skip 图标 32→48vp (audioplayer_fragment.xml butPlaybackSpeed/butRev/butFF/butSkip; float audioplayer_playercontrols_length=48vp)
- [x] 5.5 播放按钮 72→64vp (audioplayer_fragment.xml butPlay; float audioplayer_playercontrols_length_big=64vp)
- [x] 5.6 控制行高度 96→自适应 (次要)
