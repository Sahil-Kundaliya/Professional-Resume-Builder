# Tasks: Improve Home Page UI Design

**Input**: Design documents from `/specs/017-home-ui-redesign/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Organization**: Tasks are grouped by user story (US1-US4) to enable independent implementation and testing.

**Format**: `- [ ] [ID] [P?] [Story] Description with file path`

---

## Phase 1: Setup & Analysis

**Purpose**: Project initialization and design review

- [ ] T001 Review current implementation and design reference image (5.png) to understand requirements
- [ ] T002 Analyze home_page_view.dart structure and widget composition for the redesign
- [ ] T003 Review template_grid.dart and template_thumbnail.dart current implementation details

## Phase 2: Foundational Tasks

**Purpose**: Prepare widgets for modern design implementation

- [ ] T004 Create responsive breakpoint configuration for grid layout in template_grid.dart
- [ ] T005 [P] Document spacing constants (8px scale) to use across template widgets
- [ ] T006 [P] Prepare Material 3 shadow constants for card styling

## Phase 3: User Story 1 - Browse Templates with Improved Visual Clarity (P1)

**Goal**: Users experience a cleaner, more modern interface with improved spacing and visual hierarchy

**Independent Test**: Load home page and verify template list displays with improved spacing, modern card styling, and clear visual hierarchy

**Test Criteria**:
- ✓ Grid displays templates with consistent spacing
- ✓ Modern card styling applied uniformly
- ✓ Typography hierarchy is clear
- ✓ No visual regressions

**Implementation**:

- [ ] T007 [P] [US1] Implement responsive grid columns in template_grid.dart (2 cols mobile, 3 tablet, 4 desktop)
- [ ] T008 [P] [US1] Increase grid padding from 16px to 24px in template_grid.dart
- [ ] T009 [US1] Adjust grid spacing (crossAxisSpacing: 16, mainAxisSpacing: 20) in template_grid.dart
- [ ] T010 [US1] Test responsive grid behavior across mobile, tablet, and desktop sizes

## Phase 4: User Story 2 - Quickly Identify Favorite Templates with Overlaid Icon (P1)

**Goal**: Users can immediately see which templates are marked as favorites through an overlaid heart icon

**Independent Test**: Mark templates as favorites and verify heart icon appears overlaid on thumbnail in correct position

**Test Criteria**:
- ✓ Heart icon overlays on template thumbnail using Stack
- ✓ Icon positioned in top-right area per reference design
- ✓ Icon updates instantly when favorite status toggles
- ✓ Icon is clearly visible against background

**Implementation**:

- [ ] T011 [P] [US2] Enhance Stack layout for favorite icon in template_thumbnail.dart (Layer structure: background → content → overlay)
- [ ] T012 [P] [US2] Create favorite icon container with 40x40px size and 12px border radius in template_thumbnail.dart
- [ ] T013 [US2] Position favorite icon at top-right (top: 12, right: 12) using Positioned widget in template_thumbnail.dart
- [ ] T014 [US2] Add subtle shadow to favorite icon container in template_thumbnail.dart (blurRadius: 4, opacity: 0.1)
- [ ] T015 [US2] Test favorite icon visibility and contrast against all template accent colors
- [ ] T016 [US2] Test favorite toggle updates icon state instantly

## Phase 5: User Story 3 - Experience Modern Card Design with Enhanced Visual Polish (P1)

**Goal**: Users see template cards with modern design elements (shadows, border radius, premium appearance)

**Independent Test**: Inspect individual template cards and verify they display with modern shadows, appropriate border radius, and professional appearance

**Test Criteria**:
- ✓ Card elevation increased to 4dp
- ✓ Border radius is 16px (smooth corners)
- ✓ Material 3 shadow system applied (two-layer shadows)
- ✓ Card padding improved to 24px
- ✓ Shadows provide appropriate depth

**Implementation**:

- [ ] T017 [P] [US3] Update Card elevation from 2dp to 4dp in template_thumbnail.dart
- [ ] T018 [P] [US3] Increase border radius from 12px to 16px in template_thumbnail.dart
- [ ] T019 [P] [US3] Add Material 3 shadow system to cards in template_thumbnail.dart (primary shadow: blur 8, offset 0,4, opacity 0.12; secondary: blur 4, offset 0,2, opacity 0.08)
- [ ] T020 [US3] Improve card padding from default to 24px in template_thumbnail.dart
- [ ] T021 [US3] Test card shadows render correctly on different device brightness levels
- [ ] T022 [US3] Verify border radius renders smoothly on all corners

## Phase 6: User Story 4 - Maintain All Existing Functionality During Redesign (P1)

**Goal**: Users can continue using all existing features without disruption or behavior changes

**Independent Test**: Perform all existing workflows (selecting templates, toggling favorites, filtering) and verify each works identically

**Test Criteria**:
- ✓ Template selection navigation works exactly as before
- ✓ Favorite toggle updates state correctly and persists
- ✓ Filter behavior unchanged (favorites-only filter works)
- ✓ No console errors or exceptions
- ✓ Performance remains at 60fps

**Implementation**:

- [ ] T023 [P] [US4] Test template selection/tap navigates to template preview in home_page_view.dart
- [ ] T024 [P] [US4] Test favorite toggle updates HomeBloc correctly in template_thumbnail.dart
- [ ] T025 [P] [US4] Test favorite state persists across page refreshes
- [ ] T026 [US4] Test favorites-only filter functionality in home_page_view.dart
- [ ] T027 [US4] Test no console errors or exceptions during all interactions
- [ ] T028 [US4] Performance test: Verify 60fps rendering with 20+ templates

## Phase 7: Typography & Visual Hierarchy Enhancement

**Purpose**: Improve text presentation and overall visual hierarchy

- [ ] T029 [P] [US1] Ensure template name text is bold (700 weight) and 16-18px in template_thumbnail.dart
- [ ] T030 [US1] Verify template name color uses template accent color for visual identity
- [ ] T031 [US1] Test typography renders correctly with long template names (text wrapping)

## Phase 8: Cross-Platform & Responsive Testing

**Purpose**: Validate design works across all supported devices and screen sizes

- [ ] T032 [P] Test on iPhone SE (375px width) - verify 2-column grid
- [ ] T033 [P] Test on iPhone 14 Pro (390px width) - verify 2-column grid  
- [ ] T034 [P] Test on iPad (600px width) - verify 3-column grid
- [ ] T035 [P] Test on iPad Pro (1000px width) - verify 4-column grid
- [ ] T036 Test portrait and landscape orientations
- [ ] T037 Test on actual Android devices
- [ ] T038 Test with system font scaling enabled

## Phase 9: Edge Cases & Error Handling

**Purpose**: Ensure robustness across edge cases mentioned in spec

- [ ] T039 Test behavior when template thumbnail image fails to load
- [ ] T040 Test with extremely long template names (text overflow)
- [ ] T041 Test rapid favorite toggle clicks (verify state consistency)
- [ ] T042 Test with empty template list
- [ ] T043 Test with single template in list

## Phase 10: Polish & Visual Refinement

**Purpose**: Final polish and visual consistency

- [ ] T044 [P] Visual regression testing: Compare screenshots before/after
- [ ] T045 [P] Verify no visual artifacts or glitches in card rendering
- [ ] T046 [P] Check spacing consistency across all cards
- [ ] T047 Verify icon contrast meets WCAG AA standards (4.5:1 minimum)
- [ ] T048 Fine-tune shadows if needed based on visual feedback
- [ ] T049 Verify overall premium look and feel matches reference design
- [ ] T050 Final QA pass: All requirements from spec met

---

## Dependencies & Task Map

### Dependency Chain

```
T001-T003 (Analysis)
    ↓
T004-T006 (Setup)
    ├─→ T007-T010 (US1: Grid Responsiveness)
    │   └─→ T023-T028 (US4: Functionality Testing)
    ├─→ T011-T016 (US2: Favorite Icon Overlay)
    │   └─→ T023-T028 (US4: Functionality Testing)
    └─→ T017-T022 (US3: Modern Card Design)
        └─→ T023-T028 (US4: Functionality Testing)
            ↓
        T029-T031 (Typography)
        T032-T038 (Cross-platform Testing)
        T039-T043 (Edge Cases)
        T044-T050 (Polish)
```

### Parallel Execution Opportunities

**Can Run in Parallel**:
- T004, T005, T006 (setup/config)
- T007, T011, T017 (independent file changes)
- T008, T012, T018 (independent property updates)
- T023-T026 (testing different functionalities)
- T032-T035 (device size testing)

**Must Run Sequentially**:
- T001 → T002 → T003 (analysis)
- T004 → T007 (responsive setup depends on this)
- T010 → T032-T035 (functional testing before platform testing)

---

## Implementation Strategy

### MVP Scope (Recommended for v1)

**Minimum Viable Product**: US1 + US3 + US4 Testing

Core deliverable: Modern card design with responsive grid

```
Phase 1: Setup & Analysis (T001-T003)
Phase 2: Foundational (T004-T006)
Phase 3: US1 - Grid Responsiveness (T007-T010)
Phase 5: US3 - Modern Card Design (T017-T022)
Phase 6: US4 - Testing (T023-T028)
Phase 8: Cross-Platform Testing (T032-T038)
Phase 10: Polish (T044-T050)
```

**Estimated Time**: ~4-5 hours

### Full Scope (v1.1)

Add US2 (Favorite Icon Enhancement):

```
+ Phase 4: US2 - Favorite Icon Overlay (T011-T016)
+ Phase 7: Typography (T029-T031)
+ Phase 9: Edge Cases (T039-T043)
```

**Estimated Time**: ~6-7 hours total

---

## Testing Plan

### Unit/Widget Tests

- TemplateThumbnail renders with updated styling
- TemplateGrid shows correct column count per screen size
- Favorite icon appears overlaid on thumbnail
- BLoC events still trigger correctly

### Integration Tests

- Full home page workflow: load → select → navigate
- Favorite toggle: click → update → persist → display
- Filter: toggle → filter list → display results

### Manual/Visual Tests

- Cross-device rendering (T032-T038)
- Visual consistency (T044-T046)
- Performance/responsiveness (T028, T037)
- Edge cases (T039-T043)

---

## Success Criteria Validation

After completing all phases, verify:

✓ All 4 user stories implemented and independently testable
✓ 50 tasks completed with 0 regressions
✓ Template cards display with modern shadows and 16px border radius
✓ Favorite icon overlays on thumbnail in top-right position
✓ Grid shows 2 cols (mobile) → 3 cols (tablet) → 4 cols (desktop)
✓ All spacing follows 8px scale (24px padding, 16/20px gaps)
✓ All existing functionality preserved (navigation, favorites, filtering)
✓ No console errors or performance degradation
✓ Responsive design tested on 4+ device sizes
✓ Visual design matches reference image (5.png)

---

## Files Modified

| File | Changes | Lines |
|------|---------|-------|
| `lib/features/home/presentation/widgets/template_thumbnail.dart` | Card elevation, border radius, shadows, icon styling, padding | ~40-50 |
| `lib/features/home/presentation/widgets/template_grid.dart` | Responsive columns, adaptive spacing, LayoutBuilder | ~20-30 |
| `lib/features/home/presentation/pages/home_page_view.dart` | Optional: AppBar consistency | ~5-10 |
| **Total** | **Design-only changes** | **~65-90 lines** |

---

## Summary

**Total Tasks**: 50

**Tasks by User Story**:
- US1 (Browse with Clarity): 4 tasks + 3 typography tasks
- US2 (Favorite Icon): 6 tasks
- US3 (Modern Design): 6 tasks  
- US4 (Maintain Functionality): 6 tasks + 11 testing/validation tasks
- Setup/Analysis: 3 tasks
- Foundation: 3 tasks
- Cross-platform: 7 tasks
- Edge cases: 5 tasks
- Polish: 7 tasks

**Estimated Total Time**: 6-7 hours (including testing)

**Parallel Opportunities**: 18+ tasks can run in parallel (labeled with [P])

**MVP Scope**: ~4-5 hours for core UI redesign + testing

---

## Next Steps

1. ✓ Review this task list
2. Run tasks in order of dependencies
3. Mark tasks complete as you go
4. Run widget tests after each phase
5. Perform manual testing on real devices
6. Submit PR with before/after screenshots
7. Deploy after review and approval
