# Tasks: Extend Profile Sections

**Input**: Design documents from `/specs/006-extend-profile-sections/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: No explicit TDD or test-first requirement was requested in the specification, so implementation tasks are prioritized. Validation is captured in quickstart and polish tasks.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare additive profile-section scaffolding without changing existing basic-details behavior.

- [x] T001 Create reusable section header with plus-action control in lib/features/profile/presentation/widgets/profile_section_header.dart
- [x] T002 Create shared empty/add state widget for profile list sections in lib/features/profile/presentation/widgets/profile_list_empty_state.dart
- [x] T003 [P] Create shared section date formatting helper in lib/features/profile/presentation/widgets/profile_section_date_formatter.dart
- [x] T004 [P] Create shared bottom-sheet action row widget in lib/features/profile/presentation/widgets/profile_bottom_sheet_actions.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Build core section flow plumbing required before any user story can be completed.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

- [x] T005 Add section draft mutation helpers for list append/update operations in lib/features/profile/presentation/pages/edit_profile_page.dart
- [x] T006 [P] Add section-specific validation helpers for experience, education, awards, and certifications in lib/features/profile/presentation/widgets/profile_section_validators.dart
- [x] T007 [P] Add reusable list item display tiles for edit/profile pages in lib/features/profile/presentation/widgets/profile_section_list_tiles.dart
- [x] T008 Wire list-section draft updates through existing ProfileEvent.updateDraft flow in lib/features/profile/presentation/pages/edit_profile_page.dart
- [x] T009 Ensure list-section normalization remains compatible with existing profile load/save behavior in lib/features/profile/presentation/bloc/profile_bloc.dart

**Checkpoint**: Foundation ready. User story implementation can now proceed.

---

## Phase 3: User Story 1 - Preserve Existing Profile Editing (Priority: P1) 🎯 MVP

**Goal**: Keep all existing profile fields and behavior unchanged while integrating extension points for new sections.

**Independent Test**: Open Edit Profile, confirm image/full-name/job-title/summary/email/address/country-code/phone/portfolio/birth-date behaviors are unchanged, save legacy field edits, and verify Profile view values persist without requiring new-section data.

### Implementation for User Story 1

- [x] T010 [US1] Keep BasicDetailsSection usage unchanged and append extension section anchor below it in lib/features/profile/presentation/pages/edit_profile_page.dart
- [x] T011 [P] [US1] Preserve existing basic-field save mapping while merging new section lists into draft profile in lib/features/profile/presentation/pages/edit_profile_page.dart
- [x] T012 [P] [US1] Preserve existing identity and contact rendering behavior while allowing additional section blocks in lib/features/profile/presentation/pages/profile_page.dart
- [x] T013 [US1] Verify no-regression defaults for existing fields during profile initialization in lib/features/profile/domain/entities/resume_profile.dart

**Checkpoint**: User Story 1 is independently functional and regression-safe.

---

## Phase 4: User Story 2 - Add Structured Profile Items (Priority: P2)

**Goal**: Add section-level plus buttons and bottom-sheet creation flows for experience, education, awards, and certifications, with support for multiple items.

**Independent Test**: From Edit Profile, use each section plus button to open its bottom sheet, submit valid records, save profile, and verify each section contains newly added entries.

### Implementation for User Story 2

- [x] T014 [P] [US2] Create experience bottom-sheet form with company name, job position, start date, end date, and topic-based details in lib/features/profile/presentation/widgets/experience_bottom_sheet.dart
- [x] T015 [P] [US2] Create education bottom-sheet form with school name, degree, start date, and end date in lib/features/profile/presentation/widgets/education_bottom_sheet.dart
- [x] T016 [P] [US2] Create awards bottom-sheet form with title and date in lib/features/profile/presentation/widgets/award_bottom_sheet.dart
- [x] T017 [P] [US2] Create certifications bottom-sheet form with title and date in lib/features/profile/presentation/widgets/certification_bottom_sheet.dart
- [ ] T018 [US2] Add section plus-button blocks and bottom-sheet launch handlers in lib/features/profile/presentation/pages/edit_profile_page.dart
- [ ] T019 [US2] Implement experience section add flow and multi-item append behavior in lib/features/profile/presentation/pages/edit_profile_page.dart
- [ ] T020 [US2] Implement education section add flow and multi-item append behavior in lib/features/profile/presentation/pages/edit_profile_page.dart
- [ ] T021 [US2] Implement awards and certifications add flows with required-field validation in lib/features/profile/presentation/pages/edit_profile_page.dart
- [ ] T022 [US2] Implement hobbies list add/edit flow with multiple item support in lib/features/profile/presentation/pages/edit_profile_page.dart
- [ ] T023 [US2] Ensure new section lists are persisted through existing model/mapper pipeline in lib/features/profile/data/mappers/resume_profile_mapper.dart

**Checkpoint**: User Story 2 is independently functional for all add flows.

---

## Phase 5: User Story 3 - Show Added Sections Conditionally (Priority: P3)

**Goal**: Display experience, hobbies, education, awards, and certifications as lists when populated, and show clear empty/add states when no data exists.

**Independent Test**: With no section data, verify each section shows clear empty/add state; after adding items, verify sections render populated lists in Profile view and still provide add-more affordances in Edit Profile.

### Implementation for User Story 3

- [ ] T024 [P] [US3] Create profile experience list section widget with conditional empty/add state in lib/features/profile/presentation/widgets/profile_experience_section.dart
- [ ] T025 [P] [US3] Create profile hobbies list section widget with conditional empty/add state in lib/features/profile/presentation/widgets/profile_hobbies_section.dart
- [ ] T026 [P] [US3] Create profile education list section widget with conditional empty/add state in lib/features/profile/presentation/widgets/profile_education_section.dart
- [ ] T027 [P] [US3] Create profile awards list section widget with conditional empty/add state in lib/features/profile/presentation/widgets/profile_awards_section.dart
- [ ] T028 [P] [US3] Create profile certifications list section widget with conditional empty/add state in lib/features/profile/presentation/widgets/profile_certifications_section.dart
- [ ] T029 [US3] Integrate conditional list sections into Profile page layout in lib/features/profile/presentation/pages/profile_page.dart
- [ ] T030 [US3] Add edit-page section list previews and add-more affordances for populated sections in lib/features/profile/presentation/pages/edit_profile_page.dart

**Checkpoint**: User Story 3 is independently functional with conditional rendering and add affordances.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final alignment, consistency checks, and implementation hygiene across stories.

- [ ] T031 Update feature quickstart validation steps with final implementation-specific checks in specs/006-extend-profile-sections/quickstart.md
- [ ] T032 Run end-to-end manual validation scenarios and capture outcomes in specs/006-extend-profile-sections/tasks.md
- [ ] T033 Perform cross-section UI consistency cleanup in lib/features/profile/presentation/widgets/profile_section_card.dart
- [ ] T034 Verify dependency registration remains minimal and unchanged for existing profile flow in lib/features/profile/profile_injection.dart

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies; starts immediately.
- **Phase 2 (Foundational)**: Depends on Phase 1; blocks all user stories.
- **Phase 3 (US1)**: Depends on Phase 2 completion.
- **Phase 4 (US2)**: Depends on Phase 2 completion and can proceed after US1 baseline checks.
- **Phase 5 (US3)**: Depends on Phase 2 and section-add flows from US2.
- **Phase 6 (Polish)**: Depends on completion of desired user stories.

### User Story Dependencies

- **US1 (P1)**: Independent after Foundational and defines MVP safety baseline.
- **US2 (P2)**: Independent add-flow implementation after Foundational; integrates with preserved US1 behavior.
- **US3 (P3)**: Relies on persisted section data flows from US2 to validate conditional rendering.

### Within Each User Story

- Shared/reusable widgets before page integration.
- Bottom-sheet forms before plus-button wiring.
- Draft mutation logic before final save validation.
- Profile view integration after edit and persistence wiring.

---

## Parallel Opportunities

- **Setup**: T003 and T004 can run in parallel after T001/T002 scaffolding.
- **Foundational**: T006 and T007 can run in parallel while T005 is in progress.
- **US1**: T011 and T012 can run in parallel after T010.
- **US2**: T014, T015, T016, and T017 can run in parallel.
- **US3**: T024, T025, T026, T027, and T028 can run in parallel.

---

## Parallel Example: User Story 2

```bash
Task: "Create experience bottom-sheet form in lib/features/profile/presentation/widgets/experience_bottom_sheet.dart"
Task: "Create education bottom-sheet form in lib/features/profile/presentation/widgets/education_bottom_sheet.dart"
Task: "Create awards bottom-sheet form in lib/features/profile/presentation/widgets/award_bottom_sheet.dart"
Task: "Create certifications bottom-sheet form in lib/features/profile/presentation/widgets/certification_bottom_sheet.dart"
```

## Parallel Example: User Story 3

```bash
Task: "Create profile experience section in lib/features/profile/presentation/widgets/profile_experience_section.dart"
Task: "Create profile hobbies section in lib/features/profile/presentation/widgets/profile_hobbies_section.dart"
Task: "Create profile education section in lib/features/profile/presentation/widgets/profile_education_section.dart"
Task: "Create profile awards section in lib/features/profile/presentation/widgets/profile_awards_section.dart"
Task: "Create profile certifications section in lib/features/profile/presentation/widgets/profile_certifications_section.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 and Phase 2.
2. Complete Phase 3 (US1).
3. Validate non-regression of existing profile fields and save behavior.
4. Demo MVP safety milestone.

### Incremental Delivery

1. Deliver US1 to lock regression safety.
2. Deliver US2 to enable structured add flows.
3. Deliver US3 to complete conditional profile-view rendering.
4. Complete Polish phase for consistency and rollout readiness.

### Parallel Team Strategy

1. Team completes Setup and Foundational phases together.
2. One stream owns US2 bottom-sheet widgets while another stream prepares US3 view-section widgets.
3. Integrate streams in edit/profile pages after shared helpers are merged.

---

## Notes

- All tasks use additive, minimal-change integration aligned to existing profile architecture.
- Existing basic details fields and logic are explicitly preserved by US1 tasks and dependency order.
- Story labels are only used in user-story phases, per required checklist format.