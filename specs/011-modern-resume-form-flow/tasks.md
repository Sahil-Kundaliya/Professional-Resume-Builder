# Tasks: Modern Resume Form and Template-Aware Preview

**Input**: Design documents from `/specs/011-modern-resume-form-flow/`

**Prerequisites**: `plan.md` (required), `spec.md` (required), `research.md`, `data-model.md`, `contracts/resume-form-preview-contract.md`, `quickstart.md`

**Tests**: Included because validation behavior is explicitly required (preview blocking, field validation, conditional section rendering, template compatibility, and preview interactions).

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (`US1`, `US2`, `US3`)
- Each task includes a concrete file path

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare reusable task scaffolding and test skeletons for this feature.

- [X] T001 Create feature task baseline document in specs/011-modern-resume-form-flow/tasks.md
- [X] T002 [P] Create resume feature test harness scaffold in test/features/resume/resume_form_flow_test.dart
- [X] T003 [P] Add common test fixtures for template field rules in test/features/resume/fixtures/template_field_configuration_fixture.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure required before user story delivery.

**⚠️ CRITICAL**: Complete this phase before any user-story phase.

- [X] T004 [P] Add template field configuration entity for visible and required fields in lib/features/resume/domain/entities/template_field_configuration.dart
- [X] T005 [P] Add template field configuration model and serialization in lib/features/resume/data/models/template_field_configuration_model.dart
- [X] T006 [P] Implement template field configuration mapper in lib/features/resume/data/mappers/template_field_configuration_mapper.dart
- [X] T007 [P] Extend resume template model to include field rule configuration in lib/features/resume/data/models/resume_template_model.dart
- [X] T008 [P] Extend resume template domain entity to expose field rule configuration in lib/features/resume/domain/entities/resume_template.dart
- [X] T009 Implement reusable required and format validators for form fields in lib/features/resume/presentation/widgets/resume_form_validators.dart
- [X] T010 Add preview eligibility and field-error state to resume state in lib/features/resume/presentation/bloc/resume_state.dart
- [X] T011 Implement resume bloc events for field validation and preview gating in lib/features/resume/presentation/bloc/resume_event.dart
- [X] T012 Update resume bloc reducer logic for template-aware validation state in lib/features/resume/presentation/bloc/resume_bloc.dart
- [X] T013 Add reusable section visibility helpers for empty optional modules in lib/features/resume/presentation/widgets/resume_form_section_support.dart

**Checkpoint**: Foundation ready for independent user-story implementation.

---

## Phase 3: User Story 1 - Complete Resume Faster Through Guided Form Sections (Priority: P1) 🎯 MVP

**Goal**: Deliver a modern and guided `ResumeFormPage` with improved layout, grouped sections, and redesigned bottom-sheet interactions.

**Independent Test**: Open the resume form, complete multiple sections, add/edit/remove dynamic records via bottom sheets, and verify stable section state and readability.

### Tests for User Story 1

- [ ] T014 [P] [US1] Add widget test for grouped section layout and scanability in test/features/resume/resume_form_layout_test.dart
- [ ] T015 [P] [US1] Add widget test for dynamic record add/edit/remove behavior in test/features/resume/resume_dynamic_sections_test.dart
- [ ] T016 [P] [US1] Add widget test for bottom-sheet cancel and save state handling in test/features/resume/resume_bottom_sheet_interaction_test.dart

### Implementation for User Story 1

- [ ] T017 [US1] Redesign page structure, spacing, and hierarchy in lib/features/resume/presentation/pages/resume_form_page.dart
- [ ] T018 [P] [US1] Refactor basic info section UI for clearer field grouping in lib/features/resume/presentation/widgets/resume_basic_info_section.dart
- [ ] T019 [P] [US1] Modernize dynamic record tile presentation and actions in lib/features/resume/presentation/widgets/resume_dynamic_record_tile.dart
- [ ] T020 [P] [US1] Improve repeatable text section interactions for optional modules in lib/features/resume/presentation/widgets/resume_repeatable_text_section.dart
- [ ] T021 [US1] Redesign work experience section list composition in lib/features/resume/presentation/widgets/resume_work_experience_section.dart
- [ ] T022 [US1] Redesign education section list composition in lib/features/resume/presentation/widgets/resume_education_section.dart
- [ ] T023 [US1] Redesign work experience bottom sheet for add and edit flows in lib/features/resume/presentation/widgets/resume_work_experience_bottom_sheet.dart
- [ ] T024 [US1] Redesign education bottom sheet for add and edit flows in lib/features/resume/presentation/widgets/resume_education_bottom_sheet.dart
- [ ] T025 [US1] Add reusable dynamic section editor style utilities in lib/features/resume/presentation/widgets/resume_form_section_support.dart

**Checkpoint**: User Story 1 is independently testable and delivers guided form completion improvements.

---

## Phase 4: User Story 2 - Validate Required Data Per Template Before Preview (Priority: P1)

**Goal**: Make required and visible fields template-driven and enforce preview blocking with field-level validation feedback.

**Independent Test**: Switch between templates with different required field rules and verify preview remains blocked until all required values are valid.

### Tests for User Story 2

- [ ] T026 [P] [US2] Add bloc test for template-specific required rule evaluation in test/features/resume/resume_validation_bloc_test.dart
- [ ] T027 [P] [US2] Add widget test for required indicators and field-level validation feedback in test/features/resume/resume_required_field_feedback_test.dart
- [ ] T028 [P] [US2] Add integration-style flow test for preview blocking and unblock after valid data entry in test/features/resume/resume_preview_gate_test.dart

### Implementation for User Story 2

- [ ] T029 [P] [US2] Add template-field rule parsing and mapping from data models in lib/features/resume/data/mappers/template_field_configuration_mapper.dart
- [ ] T030 [US2] Apply template-visible and required field filtering in form mapping logic in lib/features/resume/presentation/widgets/resume_form_mappers.dart
- [ ] T031 [US2] Implement required-indicator rendering and validation state display in lib/features/resume/presentation/widgets/resume_basic_info_section.dart
- [ ] T032 [US2] Wire preview button enabled and blocked states to validation state in lib/features/resume/presentation/pages/resume_form_page.dart
- [ ] T033 [P] [US2] Add field-format validation for email and phone plus empty-value handling in lib/features/resume/presentation/widgets/resume_form_validators.dart
- [ ] T034 [US2] Enforce preview navigation guard with validation feedback dispatch in lib/features/resume/presentation/bloc/resume_bloc.dart
- [ ] T035 [US2] Ensure template-rule-aware state updates for dynamic required fields in lib/features/resume/presentation/bloc/resume_state.dart

**Checkpoint**: User Story 2 is independently testable and enforces template-based requiredness before preview.

---

## Phase 5: User Story 3 - Inspect a Cleaner Preview with Template-Aligned Branding (Priority: P2)

**Goal**: Improve preview entry and preview-page inspection, including template-aligned preview button styling, zoom controls, and empty-section omission.

**Independent Test**: Trigger preview from the redesigned form, confirm template-aligned preview action style, use zoom in/out, and verify empty optional sections are not rendered.

### Tests for User Story 3

- [ ] T036 [P] [US3] Add widget test for preview button template-aligned style states in test/features/resume/resume_preview_button_style_test.dart
- [ ] T037 [P] [US3] Add widget test for preview zoom in and zoom out interactions in test/features/resume/pdf_preview_zoom_test.dart
- [ ] T038 [P] [US3] Add rendering test for empty optional section omission in test/features/resume/resume_conditional_section_rendering_test.dart

### Implementation for User Story 3

- [ ] T039 [US3] Redesign preview button visuals and placement in lib/features/resume/presentation/pages/resume_form_page.dart
- [ ] T040 [US3] Implement template-aligned preview action theming in lib/features/resume/presentation/widgets/resume_form_section_support.dart
- [ ] T041 [US3] Add conditional empty-section filtering before preview mapping in lib/features/resume/presentation/widgets/resume_form_mappers.dart
- [ ] T042 [US3] Apply optional-section omission rules in preview renderer input preparation in lib/features/resume/presentation/pages/pdf_preview_page.dart
- [ ] T043 [P] [US3] Add preview zoom in and zoom out controls with smooth interaction state in lib/features/resume/presentation/pages/pdf_preview_page.dart
- [ ] T044 [P] [US3] Preserve template rendering compatibility after preview enhancements in lib/features/resume/presentation/widgets/resume_canvas.dart

**Checkpoint**: User Story 3 is independently testable with improved preview confidence and document inspection.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final hardening, compatibility checks, and release-level validation across stories.

- [ ] T045 [P] Run full resume feature regression test suite and update assertions in test/features/resume/resume_form_flow_test.dart
- [ ] T046 Verify app route and dependency compatibility for backward-compatible navigation in lib/core/constants/app_routes.dart
- [ ] T047 Verify dependency wiring and backward-compatible registration in lib/config/di/injection_container.dart
- [ ] T048 [P] Add architecture and behavior notes for maintenance in specs/011-modern-resume-form-flow/quickstart.md
- [ ] T049 Validate end-to-end flow against quickstart scenarios and capture result notes in specs/011-modern-resume-form-flow/research.md

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies
- **Phase 2 (Foundational)**: Depends on Setup; blocks all user stories
- **Phase 3 (US1)**: Depends on Foundational completion
- **Phase 4 (US2)**: Depends on Foundational completion; can run after US1 or in parallel if conflicts are managed
- **Phase 5 (US3)**: Depends on Foundational completion and benefits from US2 validation state readiness
- **Phase 6 (Polish)**: Depends on completion of all selected user stories

### User Story Dependencies

- **US1 (P1)**: Independent after Foundational and provides MVP form UX value
- **US2 (P1)**: Independent after Foundational, but integrated with US1 form surfaces
- **US3 (P2)**: Depends on form and validation paths, integrates with US1 and US2 outcomes

### Within Each User Story

- Write tests first, verify expected failing state
- Implement UI/model/state changes in dependency order
- Run focused tests for the story before moving forward

### Parallel Opportunities

- Setup tasks `T002` and `T003`
- Foundational tasks `T004` to `T008` can be split by model/entity layers
- US1 tests `T014` to `T016`
- US1 widget refactors `T018` to `T020`
- US2 tests `T026` to `T028`
- US3 tests `T036` to `T038`
- Polish tasks `T045` and `T048`

---

## Parallel Example: User Story 1

```bash
Task: "T014 [US1] Add widget test for grouped section layout in test/features/resume/resume_form_layout_test.dart"
Task: "T015 [US1] Add widget test for dynamic section interactions in test/features/resume/resume_dynamic_sections_test.dart"
Task: "T016 [US1] Add widget test for bottom-sheet interaction state in test/features/resume/resume_bottom_sheet_interaction_test.dart"

Task: "T018 [US1] Refactor basic info section UI in lib/features/resume/presentation/widgets/resume_basic_info_section.dart"
Task: "T019 [US1] Modernize dynamic record tile UI in lib/features/resume/presentation/widgets/resume_dynamic_record_tile.dart"
Task: "T020 [US1] Improve repeatable text section interactions in lib/features/resume/presentation/widgets/resume_repeatable_text_section.dart"
```

---

## Parallel Example: User Story 2

```bash
Task: "T026 [US2] Add bloc validation test in test/features/resume/resume_validation_bloc_test.dart"
Task: "T027 [US2] Add required-field feedback widget test in test/features/resume/resume_required_field_feedback_test.dart"
Task: "T028 [US2] Add preview-gate integration-style test in test/features/resume/resume_preview_gate_test.dart"

Task: "T029 [US2] Add template rule parsing in lib/features/resume/data/mappers/template_field_configuration_mapper.dart"
Task: "T033 [US2] Add format validators in lib/features/resume/presentation/widgets/resume_form_validators.dart"
```

---

## Parallel Example: User Story 3

```bash
Task: "T036 [US3] Add preview button style test in test/features/resume/resume_preview_button_style_test.dart"
Task: "T037 [US3] Add preview zoom interaction test in test/features/resume/pdf_preview_zoom_test.dart"
Task: "T038 [US3] Add optional-section omission test in test/features/resume/resume_conditional_section_rendering_test.dart"

Task: "T043 [US3] Add preview zoom controls in lib/features/resume/presentation/pages/pdf_preview_page.dart"
Task: "T044 [US3] Preserve renderer compatibility in lib/features/resume/presentation/widgets/resume_canvas.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1)

1. Complete Phase 1 and Phase 2.
2. Deliver Phase 3 (US1) for modern guided form and bottom-sheet UX.
3. Validate US1 independently with `T014` to `T016`.
4. Demo MVP with improved completion experience.

### Incremental Delivery

1. Ship US1 for immediate usability gains.
2. Add US2 to enforce template-based requiredness and preview gating.
3. Add US3 to improve preview confidence, zoom inspection, and conditional rendering quality.
4. Finish with cross-cutting polish and compatibility checks.

### Parallel Team Strategy

1. One stream on data/model foundational tasks (`T004` to `T008`).
2. One stream on bloc/validation foundation (`T009` to `T013`).
3. After foundation, split by user story owners across US1, US2, and US3 test-first tracks.

---

## Notes

- All tasks follow the required checklist format.
- `[P]` tasks indicate no conflicting dependency on incomplete tasks.
- User-story labels are applied only to user-story phases.
- Each user story includes independent test criteria and validation tasks.
- Keep changes scoped to resume form and preview flow while preserving architecture and template rendering compatibility.
