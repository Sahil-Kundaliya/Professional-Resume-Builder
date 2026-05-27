# Tasks: Replace Resume Canvas with Form Flow

**Input**: Design documents from `/specs/010-resume-form-flow/`

**Prerequisites**: `plan.md` (required), `spec.md` (required), `research.md`, `data-model.md`, `contracts/resume-form-flow.md`, `quickstart.md`

**Tests**: No explicit TDD/test-first requirement in the specification. Validation is covered with implementation verification and quickstart flow checks.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., `US1`, `US2`, `US3`)
- Every task includes an exact file path

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare routing and form entry scaffolding for the new creation flow.

- [x] T001 Add a dedicated resume form route constant in `lib/core/constants/app_routes.dart`
- [x] T002 Register the resume form route and page entry in `lib/app.dart`
- [x] T003 [P] Create the resume form page scaffold in `lib/features/resume/presentation/pages/resume_form_page.dart`
- [x] T004 [P] Create a shared section-support resolver for template-driven form visibility in `lib/features/resume/presentation/widgets/resume_form_section_support.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish form-driven resume state management before story implementation.

**CRITICAL**: No user story work should begin until these tasks are complete.

- [x] T005 Refactor template preview submit flow to target the form route in `lib/features/resume/presentation/pages/template_preview_page.dart`
- [x] T006 Simplify resume state away from canvas selection and undo/redo fields in `lib/features/resume/presentation/bloc/resume_state.dart`
- [x] T007 Define explicit form-driven update events in `lib/features/resume/presentation/bloc/resume_event.dart`
- [x] T008 Implement the foundational form update handlers and state transitions in `lib/features/resume/presentation/bloc/resume_bloc.dart`
- [x] T009 [P] Add reusable form value validation helpers in `lib/features/resume/presentation/widgets/resume_form_validators.dart`
- [x] T010 [P] Add mapping helpers for date-range and list-entry transformations in `lib/features/resume/presentation/widgets/resume_form_mappers.dart`
- [x] T011 Align resume feature DI registration with the form-driven bloc contract in `lib/features/resume/resume_injection.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin.

---

## Phase 3: User Story 1 - Start a Resume Through Structured Entry (Priority: P1) 🎯 MVP

**Goal**: Replace direct canvas editing entry with a structured resume form while keeping template list and preview intact.

**Independent Test**: Select a template from list, open template preview, tap "Use this template," and confirm navigation to a structured form showing supported sections for that template.

### Implementation for User Story 1

- [x] T012 [US1] Build the resume form page layout, app bar actions, and bloc binding in `lib/features/resume/presentation/pages/resume_form_page.dart`
- [x] T013 [P] [US1] Implement the basic profile information section (image, name, job position, summary, birth date, email, phone, address, portfolio) in `lib/features/resume/presentation/widgets/resume_basic_info_section.dart`
- [x] T014 [P] [US1] Implement reusable text-list section editors for skills, hobbies, and references in `lib/features/resume/presentation/widgets/resume_repeatable_text_section.dart`
- [x] T015 [P] [US1] Implement awards and certifications section editors in `lib/features/resume/presentation/widgets/resume_awards_certifications_section.dart`
- [x] T016 [US1] Compose all profile and lightweight resume sections with template support gating in `lib/features/resume/presentation/pages/resume_form_page.dart`
- [x] T017 [US1] Wire all US1 form field updates to resume bloc events in `lib/features/resume/presentation/pages/resume_form_page.dart`
- [x] T018 [US1] Keep template list behavior unchanged while validating preview-to-form-only transition in `lib/features/home/presentation/pages/home_page_view.dart`

**Checkpoint**: User Story 1 should be independently functional and demoable as MVP.

---

## Phase 4: User Story 2 - Manage Resume Content in Dynamic Form Sections (Priority: P1)

**Goal**: Support full CRUD for work experience and education through bottom-sheet editors.

**Independent Test**: Add multiple work/education entries, edit one entry, remove one entry, and confirm only the targeted items change while the rest of the draft remains intact.

### Implementation for User Story 2

- [x] T019 [P] [US2] Create work experience add/edit bottom sheet with company, position, start date, end date, and description fields in `lib/features/resume/presentation/widgets/resume_work_experience_bottom_sheet.dart`
- [x] T020 [P] [US2] Create education add/edit bottom sheet with title, school, description, and date fields in `lib/features/resume/presentation/widgets/resume_education_bottom_sheet.dart`
- [x] T021 [P] [US2] Create reusable dynamic record tile/actions widget for list rows in `lib/features/resume/presentation/widgets/resume_dynamic_record_tile.dart`
- [x] T022 [US2] Implement work experience list section with add/edit/remove handlers in `lib/features/resume/presentation/widgets/resume_work_experience_section.dart`
- [x] T023 [US2] Implement education list section with add/edit/remove handlers in `lib/features/resume/presentation/widgets/resume_education_section.dart`
- [x] T024 [US2] Add work experience and education add/edit/remove events in `lib/features/resume/presentation/bloc/resume_event.dart`
- [x] T025 [US2] Implement immutable list mutation handlers that preserve non-target entries in `lib/features/resume/presentation/bloc/resume_bloc.dart`
- [x] T026 [US2] Integrate dynamic work and education sections into the main form flow in `lib/features/resume/presentation/pages/resume_form_page.dart`

**Checkpoint**: User Stories 1 and 2 both work independently, with stable dynamic list behavior.

---

## Phase 5: User Story 3 - Preview the Resume Before Finalizing (Priority: P2)

**Goal**: Allow users to preview rendered template output from the latest entered form data.

**Independent Test**: Enter form data, tap Preview, confirm rendered template shows latest values, return to form, edit values, and confirm preview refreshes correctly.

### Implementation for User Story 3

- [x] T027 [US3] Add Preview CTA and form-to-preview navigation in `lib/features/resume/presentation/pages/resume_form_page.dart`
- [x] T028 [US3] Ensure preview source always uses latest draft state before navigation in `lib/features/resume/presentation/bloc/resume_bloc.dart`
- [x] T029 [US3] Update PDF preview page compatibility with the form-driven loaded state contract in `lib/features/resume/presentation/pages/pdf_preview_page.dart`
- [x] T030 [US3] Preserve form draft values when navigating back from preview in `lib/features/resume/presentation/pages/resume_form_page.dart`

**Checkpoint**: All user stories are independently functional, including preview roundtrip.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Remove obsolete canvas-editing logic and complete production-readiness validation.

- [ ] T031 [P] Remove obsolete editor-only actions and image edit hooks in `lib/features/resume/presentation/widgets/resume_canvas_edit_actions.dart`
- [ ] T032 [P] Remove obsolete formatting toolbar dependencies from the creation flow in `lib/features/resume/presentation/widgets/formatting_toolbar.dart`
- [ ] T033 [P] Remove unreachable canvas selection/edit helpers in `lib/features/resume/presentation/widgets/resume_canvas_selection_parser.dart`
- [x] T034 Remove or repurpose the old editor page so creation no longer depends on inline canvas editing in `lib/features/resume/presentation/pages/resume_editor_page.dart`
- [ ] T035 Clean `ResumeCanvas` to stay focused on rendering use-cases needed by template preview and output generation in `lib/features/resume/presentation/widgets/resume_canvas.dart`
- [ ] T036 Remove obsolete canvas section/title utilities no longer required by the new flow in `lib/features/resume/presentation/widgets/resume_canvas_section_keys.dart`
- [ ] T037 Validate end-to-end flow scenarios and document pass criteria updates in `specs/010-resume-form-flow/quickstart.md`
- [x] T038 Run static checks and resolve any resume-flow regressions in `lib/features/resume/presentation/` and `lib/app.dart`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies
- **Phase 2 (Foundational)**: Depends on Phase 1 completion; blocks all user stories
- **Phase 3 (US1)**: Depends on Phase 2
- **Phase 4 (US2)**: Depends on Phase 2 and can proceed after US1 route/form shell exists
- **Phase 5 (US3)**: Depends on Phase 2 and on US1 form entry flow
- **Phase 6 (Polish)**: Depends on completion of all selected user stories

### User Story Dependencies

- **US1 (P1)**: Can start immediately after Foundational; defines MVP navigation and structured input surface
- **US2 (P1)**: Builds on US1 form shell; dynamic sections should remain independently testable
- **US3 (P2)**: Depends on form draft plumbing from US1/US2 to validate preview roundtrip

### Within Each User Story

- Build section/state plumbing before page integration
- Complete add/edit/remove behavior before final story validation
- Keep each story independently testable before moving to next phase

### Parallel Opportunities

- Setup tasks `T003-T004` can run in parallel
- Foundational tasks `T009-T010` can run in parallel after state contract changes begin
- In US1, `T013-T015` can run in parallel
- In US2, `T019-T021` can run in parallel
- In Polish, `T031-T033` can run in parallel

---

## Parallel Example: User Story 1

```text
Task: "Implement the basic profile information section in lib/features/resume/presentation/widgets/resume_basic_info_section.dart"
Task: "Implement reusable text-list section editors in lib/features/resume/presentation/widgets/resume_repeatable_text_section.dart"
Task: "Implement awards/certifications section editors in lib/features/resume/presentation/widgets/resume_awards_certifications_section.dart"
```

## Parallel Example: User Story 2

```text
Task: "Create work experience add/edit bottom sheet in lib/features/resume/presentation/widgets/resume_work_experience_bottom_sheet.dart"
Task: "Create education add/edit bottom sheet in lib/features/resume/presentation/widgets/resume_education_bottom_sheet.dart"
Task: "Create reusable dynamic record tile/actions widget in lib/features/resume/presentation/widgets/resume_dynamic_record_tile.dart"
```

## Parallel Example: Polish Phase

```text
Task: "Remove obsolete editor-only actions in lib/features/resume/presentation/widgets/resume_canvas_edit_actions.dart"
Task: "Remove formatting toolbar dependencies in lib/features/resume/presentation/widgets/formatting_toolbar.dart"
Task: "Remove unreachable selection helpers in lib/features/resume/presentation/widgets/resume_canvas_selection_parser.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 (Setup)
2. Complete Phase 2 (Foundational)
3. Complete Phase 3 (US1)
4. Validate Template Preview -> Resume Form routing and structured input rendering
5. Demo MVP before adding dynamic sections

### Incremental Delivery

1. Deliver US1 for route and base form migration
2. Deliver US2 for work/education dynamic CRUD via bottom sheets
3. Deliver US3 for preview roundtrip and rendered output confirmation
4. Finish with Phase 6 cleanup and stability validation

### Parallel Team Strategy

1. One developer handles route and bloc contract migration (`T001-T012`)
2. One developer handles form sections (`T013-T018`)
3. One developer handles dynamic section bottom sheets and list plumbing (`T019-T026`)
4. Rejoin for preview integration and cleanup (`T027-T038`)

---

## Notes

- All tasks follow required checklist format with IDs and file paths.
- `[P]` markers are only used for tasks that can run independently.
- User story labels are applied only to user-story phases.
- Template list and template preview behavior remain intentionally unchanged except for the "Use this template" destination.
- Cleanup tasks intentionally preserve renderer responsibilities needed for preview and generation.