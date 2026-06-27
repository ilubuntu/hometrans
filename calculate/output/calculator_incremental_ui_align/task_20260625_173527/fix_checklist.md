# Fix Checklist — Calculator Incremental UI Alignment

## Page 1: Calculator Main Page

### Critical Fixes (🔴)

- [x] **FIX-1**: NeuButton corner radius 28vp → 36vp (match Android RoundedCornerShape(36dp))
  - File: `components/NeuButton.ets`
  
- [x] **FIX-2**: NeuButton font weight Lighter → Light (match Android FontWeight.Light)
  - File: `components/NeuButton.ets`

- [x] **FIX-3**: NeuButton shadow enhanced to mimic neuomorphic elevation (increase radius/offset)
  - File: `components/NeuButton.ets`

- [x] **FIX-4**: CorneredFlatIconButton shape: uniform borderRadius(12) → asymmetric cornered shape (topLeft/topRight/bottomRight = 50%, bottomLeft = 0)
  - File: `components/CorneredFlatIconButton.ets`

- [x] **FIX-5**: CorneredFlatIconButton background opacity: add 0.7 alpha to match Android
  - File: `components/CorneredFlatIconButton.ets`

### Moderate Fixes (🟡)

- [x] **FIX-6**: Expression text fontWeight Lighter → Light (match Android FontWeight.Light)
  - File: `pages/Index.ets`

- [x] **FIX-7**: Top bar icon font weight: add FontWeight.Normal for consistent rendering
  - File: `components/CorneredFlatIconButton.ets`

## Page 2: History Page (New Feature)

- [x] **FIX-8**: Create HistoryPage.ets with full UI matching Android design
  - File: `pages/HistoryPage.ets` (new)
  - Includes: top bar (back + clear buttons), history list, calculation items, date labels, empty state

- [x] **FIX-9**: Create History data model
  - File: `model/HistoryModel.ets` (new)

- [x] **FIX-10**: Create HistoryViewModel
  - File: `viewmodel/HistoryViewModel.ets` (new)

- [x] **FIX-11**: Register HistoryPage route in main_pages.json
  - File: `resources/base/profile/main_pages.json`

- [x] **FIX-12**: Wire up navigation from Index.ets to HistoryPage (already has router.pushUrl)
  - File: `pages/Index.ets`

## Notes
- Unicode emoji icons (☀/☾/⏱) are kept as-is since ArkUI doesn't have built-in Material Design vector icons. Replacing them would require adding image resources.
- Display horizontal scroll vs ellipsis: Kept as ellipsis for simplicity (scroll adds complexity in ArkUI).
- Color scheme already matches Android exactly.
