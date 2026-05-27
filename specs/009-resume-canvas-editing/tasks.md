# Tasks: Improve Resume Canvas Editing

**Input**: Design documents from `/specs/009-resume-canvas-editing/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/resume-canvas-editing-contract.md

**Tests**: Validation was explicitly requested for protected-field behavior, section isolation, hidden-module rendering, and title persistence, so story-focused widget tests are included.

**Organization**: Tasks are grouped by user story so each story can be implemented and validated independently.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare dependencies and reusable canvas editing scaffolding.

- [X] T001 Add profile image editing dependency configuration in pubspec.yaml
- [X] T002 [P] Create section key constants for canvas modules in lib/features/resume/presentation/widgets/resume_canvas_section_keys.dart
- [X] T003 [P] Create selection parsing helpers for list-item targeting in lib/features/resume/presentation/widgets/resume_canvas_selection_parser.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Add shared domain state and reusable editing contracts required by all stories.

**⚠️ CRITICAL**: No user story implementation should start before these are complete.

- [X] T004 Extend section visibility and title override fields in lib/features/resume/domain/entities/resume_document.dart
- [X] T005 Regenerate freezed models for updated resume document in lib/features/resume/domain/entities/resume_document.freezed.dart
- [X] T006 [P] Add reusable canvas edit action payload types in lib/features/resume/presentation/widgets/resume_canvas_edit_actions.dart
- [X] T007 Wire canvas action feedback surface for blocked operations in lib/features/resume/presentation/pages/resume_editor_page.dart
- [X] T008 [P] Add default visibility/title state initialization in lib/features/resume/domain/entities/resume_document.dart
- [X] T009 Add shared section title resolver utility in lib/features/resume/presentation/widgets/resume_canvas_title_resolver.dart

**Checkpoint**: Foundation complete. User stories can now be implemented independently.

---

## Phase 3: User Story 1 - Delete Resume Items Safely (Priority: P1) 🎯 MVP

**Goal**: Enable existing delete controls to remove only selected repeatable items while protecting mandatory header fields.

**Independent Test**: Select protected fields and repeatable items in canvas, invoke delete, confirm protected fields remain and only selected item is removed.

### Tests for User Story 1

- [ ] T010 [P] [US1] Add protected-field delete prevention widget tests in test/features/resume/presentation/widgets/resume_canvas_delete_test.dart
- [ ] T011 [P] [US1] Add selected-item-only deletion tests for repeatable sections in test/features/resume/presentation/widgets/resume_canvas_delete_test.dart

### Implementation for User Story 1

- [X] T012 [US1] Implement protected delete rules for fullName/jobPosition/careerGoals in lib/features/resume/presentation/widgets/resume_canvas.dart
- [X] T013 [US1] Implement repeatable-section delete routing by selected field id in lib/features/resume/presentation/widgets/resume_canvas.dart
- [X] T014 [US1] Wire existing delete button callback to conditional delete handler in lib/features/resume/presentation/widgets/resume_canvas.dart
- [X] T015 [US1] Add no-selection and blocked-delete user feedback handling in lib/features/resume/presentation/widgets/resume_canvas.dart
- [X] T016 [US1] Ensure deletion updates only target list in work/education/skills/hobbies/awards/certifications/references in lib/features/resume/presentation/widgets/resume_canvas.dart

**Checkpoint**: User Story 1 is fully functional and independently testable.

---

## Phase 4: User Story 2 - Control Optional Section Visibility (Priority: P1)

**Goal**: Allow hiding/restoring supported modules so hidden sections disappear with no empty spacing and data is preserved.

**Independent Test**: Toggle each module visibility and verify hidden module is removed from layout without gaps and restored with existing content.

### Tests for User Story 2

- [ ] T017 [P] [US2] Add hide/show rendering tests for all supported modules in test/features/resume/presentation/widgets/resume_canvas_visibility_test.dart
- [ ] T018 [P] [US2] Add hidden-module no-empty-spacing layout tests in test/features/resume/presentation/widgets/resume_canvas_visibility_test.dart

### Implementation for User Story 2

- [ ] T019 [US2] Add visibility toggle controls for profile/work/education/skills/hobbies/awards/certifications/references in lib/features/resume/presentation/widgets/resume_canvas.dart
- [ ] T020 [US2] Apply sectionVisibility state to conditional section rendering in lib/features/resume/presentation/widgets/resume_canvas.dart
- [ ] T021 [US2] Ensure hidden sections preserve underlying content state in lib/features/resume/domain/entities/resume_document.dart
- [ ] T022 [US2] Remove hidden-section spacer artifacts from canvas layout flow in lib/features/resume/presentation/widgets/resume_canvas.dart
- [ ] T023 [US2] Block visibility toggling of protected mandatory header fields in lib/features/resume/presentation/widgets/resume_canvas.dart

**Checkpoint**: User Stories 1 and 2 work independently and together.

---

## Phase 5: User Story 3 - Rename Section Titles (Priority: P2)

**Goal**: Make section headers editable and persist user-defined title overrides for all supported modules.

**Independent Test**: Rename each supported section title, reload/editor-rerender, and verify custom titles persist and display correctly.

### Tests for User Story 3

- [ ] T024 [P] [US3] Add title-edit persistence tests for section overrides in test/features/resume/presentation/widgets/resume_canvas_titles_test.dart
- [ ] T025 [P] [US3] Add invalid/empty title fallback validation tests in test/features/resume/presentation/widgets/resume_canvas_titles_test.dart

### Implementation for User Story 3

- [ ] T026 [US3] Convert section title widgets to editable title components in lib/features/resume/presentation/widgets/resume_canvas.dart
- [ ] T027 [US3] Persist section title overrides in resume document state in lib/features/resume/domain/entities/resume_document.dart
- [ ] T028 [US3] Use title resolver fallback (override -> default) for all section headers in lib/features/resume/presentation/widgets/resume_canvas.dart
- [ ] T029 [US3] Add reusable section title editor widget for scalability in lib/features/resume/presentation/widgets/resume_canvas_section_title_editor.dart

**Checkpoint**: User Stories 1-3 are independently functional and testable.

---

## Phase 6: User Story 4 - Edit Profile Image Presentation (Priority: P2)

**Goal**: Provide crop/reposition/center/preview flow for profile image with explicit apply/cancel behavior.

**Independent Test**: Open image editor, crop/reposition/center image, preview result, cancel to keep original, then apply to commit edited result.

### Tests for User Story 4

- [ ] T030 [P] [US4] Add image edit preview/apply/cancel behavior tests in test/features/resume/presentation/widgets/resume_canvas_image_edit_test.dart
- [ ] T031 [P] [US4] Add center-image action and persisted-result tests in test/features/resume/presentation/widgets/resume_canvas_image_edit_test.dart

### Implementation for User Story 4

- [ ] T032 [US4] Create reusable profile image editor sheet/dialog with crop and reposition controls in lib/features/resume/presentation/widgets/resume_canvas_image_editor.dart
- [ ] T033 [US4] Add image centering action and preview state management in lib/features/resume/presentation/widgets/resume_canvas_image_editor.dart
- [ ] T034 [US4] Integrate image editor launch from editable photo widget in lib/features/resume/presentation/widgets/resume_canvas.dart
- [ ] T035 [US4] Commit edited image output only on explicit apply in lib/features/resume/presentation/widgets/resume_canvas.dart
- [ ] T036 [US4] Preserve prior profile image on edit cancel in lib/features/resume/presentation/widgets/resume_canvas.dart

**Checkpoint**: All user stories are independently functional.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Final production hardening across all stories.

- [ ] T037 [P] Add regression tests for cross-section isolation after delete/hide/title/image actions in test/features/resume/presentation/widgets/resume_canvas_regression_test.dart
- [ ] T038 Add reusable inline documentation comments for canvas edit rule helpers in lib/features/resume/presentation/widgets/resume_canvas_selection_parser.dart
- [ ] T039 Validate quickstart scenarios and update verification notes in specs/009-resume-canvas-editing/quickstart.md
- [ ] T040 Run Flutter test suite for resume canvas behavior coverage in test/features/resume/presentation/widgets/resume_canvas_delete_test.dart

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies.
- **Phase 2 (Foundational)**: Depends on Phase 1; blocks all user stories.
- **Phase 3 (US1)**: Depends on Phase 2.
- **Phase 4 (US2)**: Depends on Phase 2; can run after US1 or in parallel once foundational work is complete.
- **Phase 5 (US3)**: Depends on Phase 2 and section-title foundational support from T009.
- **Phase 6 (US4)**: Depends on Phase 2.
- **Phase 7 (Polish)**: Depends on completion of targeted user stories.

### User Story Dependencies

- **US1 (P1)**: Independent after foundational phase.
- **US2 (P1)**: Independent after foundational phase; should not depend on US1 internals.
- **US3 (P2)**: Independent after foundational phase and title resolver support.
- **US4 (P2)**: Independent after foundational phase.

### Within Each User Story

- Add tests before implementation for requested validation behaviors.
- Implement core state/model updates before wiring UI controls.
- Complete story validation before moving to the next story.

### Parallel Opportunities

- Setup: T002 and T003 can run in parallel.
- Foundational: T006 and T008 can run in parallel after T004.
- US1: T010 and T011 can run in parallel.
- US2: T017 and T018 can run in parallel.
- US3: T024 and T025 can run in parallel.
- US4: T030 and T031 can run in parallel.
- Polish: T037 can run in parallel with T038.

---

## Parallel Example: User Story 1

```bash
# Run US1 validation tests in parallel:
Task: "Add protected-field delete prevention widget tests in test/features/resume/presentation/widgets/resume_canvas_delete_test.dart"
Task: "Add selected-item-only deletion tests for repeatable sections in test/features/resume/presentation/widgets/resume_canvas_delete_test.dart"
```

## Parallel Example: User Story 2

```bash
# Run US2 visibility tests in parallel:
Task: "Add hide/show rendering tests for all supported modules in test/features/resume/presentation/widgets/resume_canvas_visibility_test.dart"
Task: "Add hidden-module no-empty-spacing layout tests in test/features/resume/presentation/widgets/resume_canvas_visibility_test.dart"
```

## Parallel Example: User Story 3

```bash
# Run US3 title tests in parallel:
Task: "Add title-edit persistence tests for section overrides in test/features/resume/presentation/widgets/resume_canvas_titles_test.dart"
Task: "Add invalid/empty title fallback validation tests in test/features/resume/presentation/widgets/resume_canvas_titles_test.dart"
```

## Parallel Example: User Story 4

```bash
# Run US4 image edit tests in parallel:
Task: "Add image edit preview/apply/cancel behavior tests in test/features/resume/presentation/widgets/resume_canvas_image_edit_test.dart"
Task: "Add center-image action and persisted-result tests in test/features/resume/presentation/widgets/resume_canvas_image_edit_test.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 and Phase 2.
2. Complete Phase 3 (US1).
3. Validate protected-field safety and selected-item deletion behavior.
4. Demo/deploy MVP safely.

### Incremental Delivery

1. Deliver US1 (safe delete behavior).
2. Deliver US2 (visibility controls) and validate hidden-layout behavior.
3. Deliver US3 (editable, persistent section titles).
4. Deliver US4 (profile image editing workflow).
5. Finish with Phase 7 polish and regression verification.

### Parallel Team Strategy

1. Team aligns on Phase 1 and Phase 2.
2. After foundational completion:
- Engineer A: US1 delete behavior.
- Engineer B: US2 visibility controls.
- Engineer C: US3 title customization.
- Engineer D: US4 image editing flow.
3. Merge at story checkpoints with regression tests.

---

## Notes

- All tasks follow the required checklist format: `- [ ] T### [P?] [US?] Description with file path`.
- User story labels are included only in user story phases.
- Tasks are scoped to Resume Canvas and resume feature internals per constraints.
