# Tasks: Resume Editor Interaction Improvements

**Input**: Design documents from `/specs/008-resume-editor-interactions/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/, quickstart.md

**Tests**: Include targeted widget/bloc regression tests because the feature explicitly requires compatibility validation and no regressions.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Every task includes exact file path(s) in the description

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare editor-focused test harness and constraints scaffolding inside the resume module.

- [X] T001 Create editor interaction test helpers for field selection and toolbar actions in test/features/resume/helpers/resume_editor_test_helpers.dart
- [X] T002 [P] Create baseline widget test shell for Resume Editor interactions in test/features/resume/presentation/resume_editor_interactions_smoke_test.dart
- [X] T003 [P] Define shared editor constraint constants (text size and skills rating bounds) in lib/features/resume/presentation/widgets/resume_editor_constraints.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Add shared style/rating infrastructure required before implementing user-story behavior.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

- [X] T004 Extend style model to support per-editable-field formatting state and font size metadata in lib/features/resume/domain/entities/resume_document.dart
- [X] T005 Add generic selected-field formatting events (including text size increase/decrease) in lib/features/resume/presentation/bloc/resume_event.dart
- [X] T006 Implement generic style update handlers with min/max guards and backward-compatible defaults in lib/features/resume/presentation/bloc/resume_bloc.dart
- [X] T007 [P] Extend toolbar API to expose text size controls and all-field formatting enablement in lib/features/resume/presentation/widgets/formatting_toolbar.dart
- [X] T008 [P] Add field-style resolver utilities for all editable field IDs in lib/features/resume/presentation/widgets/resume_canvas.dart

**Checkpoint**: Foundation ready; user stories can proceed.

---

## Phase 3: User Story 1 - Edit Text Without Interaction Friction (Priority: P1) 🎯 MVP

**Goal**: Dismiss keyboard on outside tap and make formatting behavior work consistently for every editable field.

**Independent Test**: Focus any editable field, tap outside to dismiss keyboard, then select representative fields across each section and verify toolbar formatting works consistently.

### Tests for User Story 1

- [ ] T009 [P] [US1] Add widget test for outside-tap keyboard dismissal in test/features/resume/presentation/resume_editor_keyboard_dismiss_test.dart
- [ ] T010 [P] [US1] Add widget test for toolbar availability across field categories in test/features/resume/presentation/resume_editor_formatting_coverage_test.dart

### Implementation for User Story 1

- [X] T011 [US1] Update outside-tap behavior to unfocus active input and clear selection in lib/features/resume/presentation/pages/resume_editor_page.dart
- [X] T012 [US1] Enable formatting toolbar for any selected editable field in lib/features/resume/presentation/pages/resume_editor_page.dart
- [X] T013 [US1] Apply resolved formatting styles to contact/work/education/reference fields in lib/features/resume/presentation/widgets/resume_canvas.dart
- [X] T014 [US1] Apply resolved formatting styles to skills/hobbies/awards/certification and remaining editable text fields in lib/features/resume/presentation/widgets/resume_canvas.dart
- [X] T015 [US1] Update toolbar guidance text and state behavior for all editable fields in lib/features/resume/presentation/widgets/formatting_toolbar.dart

**Checkpoint**: User Story 1 is independently functional and testable.

---

## Phase 4: User Story 2 - Control Text Size Safely (Priority: P1)

**Goal**: Add bounded text-size increase/decrease controls that block invalid values and preserve existing formatting behavior.

**Independent Test**: Select fields across multiple sections, increase and decrease text size, and verify values remain within 8-13 with consistent rendering.

### Tests for User Story 2

- [ ] T016 [P] [US2] Add bloc test for text-size bound enforcement and invalid-value blocking in test/features/resume/presentation/bloc/resume_bloc_text_size_test.dart
- [ ] T017 [P] [US2] Add widget test for text-size control interactions in test/features/resume/presentation/resume_editor_text_size_controls_test.dart

### Implementation for User Story 2

- [X] T018 [US2] Add text-size increase/decrease controls to formatting toolbar UI in lib/features/resume/presentation/widgets/formatting_toolbar.dart
- [X] T019 [US2] Wire text-size events from editor page toolbar callbacks in lib/features/resume/presentation/pages/resume_editor_page.dart
- [X] T020 [US2] Implement bounded text-size update logic for selected editable field in lib/features/resume/presentation/bloc/resume_bloc.dart
- [X] T021 [US2] Render per-field text size from style state for all editable fields in lib/features/resume/presentation/widgets/resume_canvas.dart

**Checkpoint**: User Story 2 is independently functional and testable.

---

## Phase 5: User Story 3 - Clean Up Editing Actions and Skill Ratings (Priority: P2)

**Goal**: Remove confusing actions, keep delete behavior non-destructive, fix skill ratings to editable 0-5 with five stars, and remove AppBar Save button.

**Independent Test**: Confirm no green expand action exists, delete clears text only, skills ratings edit in 0-5 range with exactly five stars, and AppBar Save button is absent.

### Tests for User Story 3

- [ ] T022 [P] [US3] Add widget test verifying AppBar Save button removal in test/features/resume/presentation/resume_editor_appbar_actions_test.dart
- [ ] T023 [P] [US3] Add widget test for delete-clear-only behavior and no expand action in test/features/resume/presentation/resume_editor_field_actions_test.dart
- [ ] T024 [P] [US3] Add widget test for editable skill ratings constrained to 0-5 with five-star render in test/features/resume/presentation/resume_editor_skills_rating_test.dart

### Implementation for User Story 3

- [X] T025 [US3] Remove AppBar Save action while keeping existing page actions intact in lib/features/resume/presentation/pages/resume_editor_page.dart
- [X] T026 [US3] Remove green expand action from editable text field action chips in lib/features/resume/presentation/widgets/resume_canvas.dart
- [X] T027 [US3] Change delete action to clear selected field value without removing field/widget structure in lib/features/resume/presentation/widgets/resume_canvas.dart
- [X] T028 [US3] Add direct skill rating edit controls with 0-5 enforcement in lib/features/resume/presentation/widgets/resume_canvas.dart
- [X] T029 [US3] Replace current skills indicator rendering with exactly five stars tied to rating value in lib/features/resume/presentation/widgets/resume_canvas.dart

**Checkpoint**: User Story 3 is independently functional and testable.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Verify compatibility constraints and finalize production-grade quality checks.

- [ ] T030 [P] Add regression test coverage for undo/redo, preview generation, template rendering, and profile prefill compatibility in test/features/resume/presentation/resume_editor_compatibility_test.dart
- [ ] T031 Run end-to-end validation scenarios from specs/008-resume-editor-interactions/quickstart.md and record pass/fail notes in specs/008-resume-editor-interactions/quickstart.md
- [ ] T032 Verify changed file scope is limited to Resume Editor module and feature docs using specs/008-resume-editor-interactions/tasks.md as release checklist

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: Starts immediately.
- **Phase 2 (Foundational)**: Depends on Phase 1 and blocks all user stories.
- **Phase 3 (US1)**: Depends on Phase 2 completion.
- **Phase 4 (US2)**: Depends on Phase 2 completion.
- **Phase 5 (US3)**: Depends on Phase 2 completion.
- **Phase 6 (Polish)**: Depends on completion of the user stories selected for release.

### User Story Dependencies

- **US1 (P1)**: No dependency on other stories after Foundation.
- **US2 (P1)**: No dependency on other stories after Foundation.
- **US3 (P2)**: No dependency on US1/US2 after Foundation; can run in parallel once foundational work is complete.

### Within Each User Story

- Tests first where listed.
- Page-level wiring before widget-level refinements when both touch the same behavior.
- Style/state logic before broad rendering rollout.
- Complete story validation before moving to release.

### Parallel Opportunities

- Phase 1: T002 and T003 can run in parallel after T001 starts.
- Phase 2: T007 and T008 can run in parallel after T004-T006 define shared model/events.
- US1: T009 and T010 can run in parallel; T013 and T014 can run in parallel after T012.
- US2: T016 and T017 can run in parallel; implementation tasks can split between toolbar/page and bloc/canvas updates.
- US3: T022, T023, and T024 can run in parallel; T026 and T029 can run in parallel after delete/rating behavior contracts are settled.

---

## Parallel Example: User Story 1

```bash
# Run US1 tests in parallel:
Task: "T009 Add widget test for outside-tap keyboard dismissal in test/features/resume/presentation/resume_editor_keyboard_dismiss_test.dart"
Task: "T010 Add widget test for toolbar availability across field categories in test/features/resume/presentation/resume_editor_formatting_coverage_test.dart"

# Implement style rollout in parallel after page wiring:
Task: "T013 Apply resolved formatting styles to contact/work/education/reference fields in lib/features/resume/presentation/widgets/resume_canvas.dart"
Task: "T014 Apply resolved formatting styles to skills/hobbies/awards/certification and remaining editable text fields in lib/features/resume/presentation/widgets/resume_canvas.dart"
```

---

## Parallel Example: User Story 3

```bash
# Run US3 behavior tests in parallel:
Task: "T022 Add widget test verifying AppBar Save button removal in test/features/resume/presentation/resume_editor_appbar_actions_test.dart"
Task: "T023 Add widget test for delete-clear-only behavior and no expand action in test/features/resume/presentation/resume_editor_field_actions_test.dart"
Task: "T024 Add widget test for editable skill ratings constrained to 0-5 with five-star render in test/features/resume/presentation/resume_editor_skills_rating_test.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 and Phase 2.
2. Deliver Phase 3 (US1): keyboard dismissal + all-field formatting availability.
3. Validate US1 independently before expanding scope.

### Incremental Delivery

1. Foundation complete (Phases 1-2).
2. Deliver US1 (editing friction removal and full formatting coverage).
3. Deliver US2 (bounded text-size controls).
4. Deliver US3 (action cleanup, ratings fix, AppBar cleanup).
5. Run Phase 6 compatibility checks before release.

### Parallel Team Strategy

1. Team completes Phases 1-2 together.
2. Then parallelize by story:
   - Dev A: US1
   - Dev B: US2
   - Dev C: US3
3. Merge after story-level tests pass independently.

---

## Notes

- [P] tasks are parallel-safe by file separation/dependency.
- User-story labels provide direct traceability to spec acceptance criteria.
- Keep implementation isolated to `lib/features/resume/` and `test/features/resume/` plus this feature's `specs/008-resume-editor-interactions/` docs.
- Avoid unrelated refactors and preserve backward compatibility throughout implementation.
