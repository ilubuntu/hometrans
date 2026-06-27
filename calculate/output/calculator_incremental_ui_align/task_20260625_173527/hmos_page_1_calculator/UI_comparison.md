# Page 1: Calculator Main Page — UI Comparison (Android vs HarmonyOS)

**Android:** 1344x2992px, density 3.0x (480dpi), 448x997.3dp
**HarmonyOS:** 1280x2832px, density ~3.0x, ~426.7x944vp

## Comparison Table

| UI Component | 文本内容 | 尺寸与布局 | 颜色与背景 | 边框与轮廓 | 文本样式 | 变换与效果 | 状态与交互反馈 | Diff |
|:-------------|:------|:------|:------|:------|:-----|:------|:--------|:--------|
| **Top Bar Container** | — | **A:** Row, top 1%-9% guideline, startMargin=20dp<br>**H:** Row, padding left=20vp top=16vp, height auto | — | — | — | — | — | ⚠️ Android uses ConstraintLayout guidelines (1%-9%); HarmonyOS uses simple padding. Minor vertical position difference. |
| **Top Bar Icon Shape** | — | **A:** RoundedCornerShape(50%).copy(bottomStart=0%) — 3 corners 50% rounded, bottom-left sharp | **A:** primary.copy(alpha=0.7).compositeOver(BlueGrey100) = blended semi-transparent | **A:** shape with asymmetric corners (bottomStart cut) | — | **A:** flat, no elevation | normal/pressed via ripple | 🔴 **DIFF:** Android has asymmetric "cornered" shape (3 rounded + 1 sharp corner); HarmonyOS uses uniform borderRadius(12vp). |
| **Top Bar Icon Content** | **A:** Material vector icons (DarkMode, History)<br>**H:** Unicode chars (☀/☾, ⏱) | **A:** Icon fills 60% of button<br>**H:** Text centered, fontSize 24vp | **A:** iconColor = onPrimary<br>**H:** iconColor = onPrimary ✓ | — | **A:** vector drawable<br>**H:** text/emoji glyph | — | — | 🔴 **DIFF:** Android uses crisp Material Design vector icons; HarmonyOS uses Unicode emoji that render differently across devices. |
| **Top Bar Icon Background Alpha** | — | — | **A:** alpha=0.7 blended<br>**H:** solid #FFCFD3DE (alpha=1.0) | — | — | — | — | 🟡 **DIFF:** Android applies 70% opacity; HarmonyOS uses fully opaque background. |
| **Display — Expression** | **A:** formatNumbers(expression)<br>**H:** formattedExpression (same logic) | **A:** horizontalScroll(reverse), padding 20dp<br>**H:** maxLines(1), ellipsis, padding 20vp | **A:** onBackground, alpha=0.6 ✓<br>**H:** onBackground, opacity=0.6 ✓ | — | **A:** h5=24sp, FontWeight.Light<br>**H:** fontSize(24), FontWeight.Lighter | — | — | 🟡 **DIFF:** Android uses horizontal scroll; HarmonyOS uses ellipsis. FontWeight: Light vs Lighter. |
| **Display — Result** | **A:** formatNumbers(result)<br>**H:** formattedResult (same) | **A:** horizontalScroll(reverse), Selectable, padding 20dp<br>**H:** maxLines(1), ellipsis, NOT selectable, padding 20vp | **A:** onBackground ✓<br>**H:** onBackground ✓ | — | **A:** h3=48sp, FontWeight.Normal ✓<br>**H:** fontSize(48), FontWeight.Normal ✓ | — | **A:** SelectionContainer (text selectable)<br>**H:** not selectable | 🟡 **DIFF:** Android result is horizontally scrollable and text-selectable; HarmonyOS uses ellipsis truncation. |
| **Display Area Container** | — | **A:** between guideline 9% and 40%, bottom margin 16dp from keys<br>**H:** layoutWeight(1), justifyContent(End), padding bottom=16vp | — | — | — | — | — | ⚠️ Minor: proportional spacing differs slightly. |
| **Key Layout Container** | — | **A:** horizontal padding 8dp, aspectRatio(4/5), guidelines 40%-98%<br>**H:** height('56%'), padding left/right=8vp, bottom=16vp, top=4vp | — | — | — | — | — | ⚠️ Android uses aspect ratio for key area sizing; HarmonyOS uses fixed 56% height. Close but not identical proportions. |
| **NeuButton Shape** | — | **A:** RoundedCornerShape(36dp)<br>**H:** borderRadius(28vp) | — | — | — | — | — | 🔴 **DIFF:** Android radius 36dp; HarmonyOS radius 28vp. Buttons appear less rounded. |
| **NeuButton Background** | — | — | **A:** linearGradient(lightColor → darkColor), darkColor=lightColor+0.125/chan<br>**H:** solid bgColor | — | — | — | **A:** elevation 18dp default / 8dp pressed<br>**H:** shadow radius=12, offsetY=6 | 🔴 **DIFF:** Android has gradient fill + elevation shadow; HarmonyOS has flat solid color + simple shadow. |
| **NeuButton Border** | — | — | — | **A:** 12% strokeWidth gradient border with BlurMaskFilter<br>**H:** none | — | — | — | 🔴 **DIFF:** Android has decorative gradient border; HarmonyOS has none. |
| **NeuButton Text** | **A:** button.symbol ✓<br>**H:** button.symbol ✓ | — | **A:** contentColorFor(bg)<br>**H:** textColor ✓ | — | **A:** fontSize=maxHeight*0.33≈32sp, FontWeight.Light<br>**H:** fontSize(32), FontWeight.Lighter | — | — | 🟡 **DIFF:** Font weight: Light vs Lighter. Dynamic vs fixed font size. |
| **NeuButton Elevation** | — | — | — | — | — | **A:** Surface elevation 18dp→8dp (pressed). Complex shadow rendering.<br>**H:** Simple shadow offsetY=6, radius=12 | **A:** pressed state reduces elevation<br>**H:** no pressed visual feedback | 🔴 **DIFF:** Android has neuomorphic elevation with press animation; HarmonyOS has basic static shadow, no press feedback. |
| **Button Grid Spacing** | — | **A:** buttonWidth * 0.04 ≈ 3.92dp, Grid auto-layout<br>**H:** margin(4vp) per button | — | — | — | — | — | ✅ Close: ~4vp in both. |

## Summary of Differences

### Critical (🔴) — 5 items
1. **Top bar icon shape**: Asymmetric "cornered" shape (3 rounded + 1 sharp) vs uniform borderRadius
2. **Top bar icon content**: Material vector icons vs Unicode emoji characters
3. **NeuButton corner radius**: 36dp vs 28vp
4. **NeuButton background**: Gradient + border vs flat solid
5. **NeuButton elevation/shadow**: Neuomorphic 18dp elevation vs simple static shadow

### Moderate (🟡) — 3 items
1. **Display scroll**: Horizontal scroll vs ellipsis truncation
2. **Font weight**: Light vs Lighter (expression and button text)
3. **Top bar icon background alpha**: 0.7 vs 1.0

### Minor (⚠️) — 3 items
1. **Layout proportions**: ConstraintLayout guidelines vs fixed percentages
2. **Display container**: Different proportional spacing
3. **Key layout sizing**: Aspect ratio vs fixed height percentage
