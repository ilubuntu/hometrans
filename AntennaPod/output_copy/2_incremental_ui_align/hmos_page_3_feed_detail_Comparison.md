# Page 3 (Feed Detail) — UI Comparison (Android ground truth vs HarmonyOS)

| UI Component | 文本内容 | 尺寸与布局 | 颜色与背景 | 边框与轮廓 | 文本样式 | 变换与效果 | 状态与交互反馈 | Diff |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| Toolbar | A=无独立标题(collapsing) / H=feed.title | 一致 56vp | 一致 | — | A=— / H=20fp | — | 一致 | **H toolbar 显示 feed.title (Android 展开态无标题); 可接受, 低优先** |
| Toolbar Overflow | 一致 | A=48×48 Button / H=28×28 Image | A=透明 / H=无背景 | — | 一致 | — | 一致 | **尺寸 28→目标 48×48 透明 Button** |
| Header 高度 | — | A=156dp / H=156vp | — | — | — | — | — | ✅ |
| Header 封面 | 一致 | A=124×124 r16 m16/24 / H=124×124 r16 m16/24 ✓ | 一致 non_square | A=无border / H=**border width1** | — | 一致 | — | **移除封面 border width1 (Android elevation0 无边框)** (feeditemlist_header.xml coverHolder) |
| Header 标题/作者 | 一致 | 一致 | 一致 white+shadow | — | A=Heading22+shadow / H=22 **无shadow** | A=shadow / H: 缺失 | 一致 | **标题/作者缺 textShadow (shadowColor black radius2) (次要)** (feeditemlist_header.xml txtvTitle/txtvAuthor) |
| 按钮条 spacer | — | A=**148dp** / H=**140vp** | — | — | — | — | — | **spacer 140→目标 148vp** (feeditemlist_header.xml buttonContainer View 148dp) |
| Info/Filter/Settings 按钮 | 一致 | A=48×48 padding12 / H=48×48 icon24 ✓ | 一致 透明 | — | 一致 | 一致 | 一致 | ✅ |
| 单集列表 padding/divider | — | A=paddingStart12 / H=left12 ✓; divider 一致 | — | A=divider / H=divider ✓ | — | — | — | ✅ |
| 单集项封面 | — | A=**56vp** r8 marginV11 marginEnd**16** / H=**64vp** r8 marginV12 marginEnd**12** | 一致 | 一致 r8 | — | — | — | **① 封寸 64→目标 56vp; ② marginEnd 12→16vp; ③ marginV 12→11vp** (feeditemlist_item.xml coverHolder thumbnail_length_queue_item=56vp) |
| 单集项标题 | 一致 | 一致 左对齐 | 一致 | — | A≈16sp / H=16fp ✓ | — | — | ✅ |
| 单集项 secondaryAction | 一致 | A=48 圆形 / H=48 Stack ✓ | 一致 | — | 一致 | — | 一致 | ✅ |
| 单集项 status 图标 | 一致 | A=12sp / H=12 ✓ | 一致 | — | 一致 | — | — | ✅ |
| 描述区 | 一致 | 一致 padding16 | 一致 | — | A=TitleMedium16/BodyMedium14 / H=16/14 ✓ | — | 一致 | ✅ |
| 统计/支持/URL 区 | A=有 / H=**缺失** | A=infoContainer / H: 缺失 | — | — | — | — | — | **缺失统计/支持/URL 信息区 (属 FeedInfoFragment 详情页, 当前页为单集列表模式; 低优先 标记 [~])** (feedinfo.xml infoContainer) |
