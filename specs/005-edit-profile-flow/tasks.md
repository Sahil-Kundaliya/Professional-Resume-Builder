# Tasks: Edit Profile Flow

**Input**: Design documents from `/specs/005-edit-profile-flow/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: No explicit TDD or test-first requirement was requested in the specification, so this task list focuses on implementation work plus manual and analyzer validation.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Add the route and file scaffolding needed to turn the existing placeholder Profile tab into a full edit flow.

- [x] T001 Add the edit-profile route constants in `lib/core/constants/app_routes.dart` and `lib/config/routes/route_names.dart`
- [x] T002 Create the edit-flow page and shared section shell files in `lib/features/profile/presentation/pages/edit_profile_page.dart`, `lib/features/profile/presentation/widgets/profile_section_card.dart`, and `lib/features/profile/presentation/widgets/profile_empty_state.dart`
- [x] T003 [P] Create profile feature layer entry files in `lib/features/profile/domain/entities/resume_profile.dart`, `lib/features/profile/domain/repositories/profile_repository.dart`, `lib/features/profile/data/datasources/profile_local_data_source.dart`, `lib/features/profile/data/repositories/profile_repository_impl.dart`, and `lib/features/profile/presentation/bloc/profile_bloc.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core profile domain, persistence, and state infrastructure that MUST be complete before any user story work can begin.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

- [x] T004 Create the reusable profile entities and draft types in `lib/features/profile/domain/entities/resume_profile.dart`
- [x] T005 [P] Create serializable storage models and mappers in `lib/features/profile/data/models/resume_profile_model.dart` and `lib/features/profile/data/mappers/resume_profile_mapper.dart`
- [x] T006 [P] Implement local profile persistence and copied-image file handling in `lib/features/profile/data/datasources/profile_local_data_source.dart`
- [x] T007 Implement the profile repository and load/save use cases in `lib/features/profile/data/repositories/profile_repository_impl.dart`, `lib/features/profile/domain/repositories/profile_repository.dart`, `lib/features/profile/domain/usecases/load_resume_profile.dart`, and `lib/features/profile/domain/usecases/save_resume_profile.dart`
- [x] T008 Implement summary, draft, and save orchestration state in `lib/features/profile/presentation/bloc/profile_bloc.dart`, `lib/features/profile/presentation/bloc/profile_event.dart`, and `lib/features/profile/presentation/bloc/profile_state.dart`
- [x] T009 Register profile dependencies in `lib/features/profile/profile_injection.dart` and `lib/config/di/injection_container.dart`

**Checkpoint**: Foundation ready; user story implementation can now begin.

---

## Phase 3: User Story 1 - Open And Complete Edit Profile (Priority: P1) 🎯 MVP

**Goal**: Let the user open the Edit Profile page from Profile, update basic details and image, save, and return to a Profile page that reflects the latest saved values.

**Independent Test**: Open the Profile tab, tap Edit, update profile image plus basic/contact fields, save, and confirm the Profile page reloads with the saved values.

### Implementation for User Story 1

- [x] T010 [P] [US1] Build read-only summary widgets for identity, summary, and contact sections in `lib/features/profile/presentation/widgets/profile_identity_card.dart`, `lib/features/profile/presentation/widgets/profile_summary_section.dart`, and `lib/features/profile/presentation/widgets/profile_contact_section.dart`
- [x] T011 [US1] Replace the placeholder Profile screen with bloc-driven summary rendering and an Edit action in `lib/features/profile/presentation/pages/profile_page.dart`
- [x] T012 [P] [US1] Build the Edit Profile page basic-details form and save bar in `lib/features/profile/presentation/pages/edit_profile_page.dart` and `lib/features/profile/presentation/widgets/basic_details_section.dart`
- [x] T013 [P] [US1] Implement gallery image selection and country-code selection widgets in `lib/features/profile/presentation/widgets/profile_image_picker_field.dart` and `lib/features/profile/presentation/widgets/country_code_dropdown.dart`
- [x] T014 [US1] Register the Edit Profile route and navigation wiring in `lib/app.dart` and `lib/features/profile/presentation/pages/profile_page.dart`
- [x] T015 [US1] Connect basic-field draft updates, save submission, and post-save summary refresh in `lib/features/profile/presentation/pages/edit_profile_page.dart` and `lib/features/profile/presentation/bloc/profile_bloc.dart`

**Checkpoint**: User Story 1 should now be fully functional and independently testable.

---

## Phase 4: User Story 2 - Manage Dynamic Profile Sections (Priority: P2)

**Goal**: Let the user add, edit, and remove dynamic skills, hobbies, experience, education, awards, and certifications from the Edit Profile flow and see the saved results on the Profile page.

**Independent Test**: Add multiple entries across each dynamic section, edit one item, remove another, save, and confirm the saved Profile page shows the updated ordered lists.

### Implementation for User Story 2

- [ ] T016 [P] [US2] Build inline dynamic-section widgets for skills, hobbies, awards, and certifications in `lib/features/profile/presentation/widgets/skills_section.dart`, `lib/features/profile/presentation/widgets/hobbies_section.dart`, `lib/features/profile/presentation/widgets/awards_section.dart`, and `lib/features/profile/presentation/widgets/certifications_section.dart`
- [ ] T017 [US2] Implement add, edit, remove, and reorder-safe draft operations for inline sections in `lib/features/profile/presentation/bloc/profile_bloc.dart` and `lib/features/profile/presentation/bloc/profile_state.dart`
- [ ] T018 [P] [US2] Implement the experience list and bottom-sheet editor in `lib/features/profile/presentation/widgets/experience_section.dart` and `lib/features/profile/presentation/widgets/experience_bottom_sheet.dart`
- [ ] T019 [P] [US2] Implement the education list and bottom-sheet editor in `lib/features/profile/presentation/widgets/education_section.dart` and `lib/features/profile/presentation/widgets/education_bottom_sheet.dart`
- [ ] T020 [US2] Persist ordered dynamic sections through the storage mapper and repository in `lib/features/profile/data/models/resume_profile_model.dart`, `lib/features/profile/data/mappers/resume_profile_mapper.dart`, and `lib/features/profile/data/repositories/profile_repository_impl.dart`
- [ ] T021 [US2] Render saved dynamic sections on the Profile summary screen in `lib/features/profile/presentation/pages/profile_page.dart`, `lib/features/profile/presentation/widgets/profile_experience_section.dart`, `lib/features/profile/presentation/widgets/profile_education_section.dart`, `lib/features/profile/presentation/widgets/profile_awards_section.dart`, and `lib/features/profile/presentation/widgets/profile_certifications_section.dart`

**Checkpoint**: User Stories 1 and 2 should both work independently, with saved dynamic sections reloading correctly.

---

## Phase 5: User Story 3 - Prevent Invalid Profile Data (Priority: P3)

**Goal**: Enforce clear validation for invalid dates, invalid email and phone data, and incomplete experience or education entries without losing entered form state.

**Independent Test**: Attempt to save invalid basic fields and incomplete bottom-sheet records, then confirm the flow blocks invalid saves, shows clear field messages, and preserves the rest of the entered data.

### Implementation for User Story 3

- [ ] T022 [P] [US3] Create reusable validation helpers for email, phone, birth date, and date ranges in `lib/features/profile/domain/usecases/validate_profile_field.dart` and `lib/features/profile/domain/usecases/validate_profile_record.dart`
- [ ] T023 [US3] Enforce basic-field validation with preserved draft state in `lib/features/profile/presentation/pages/edit_profile_page.dart`, `lib/features/profile/presentation/widgets/basic_details_section.dart`, and `lib/features/profile/presentation/bloc/profile_bloc.dart`
- [ ] T024 [US3] Enforce required work-experience validation, date ordering, and detail-line validation in `lib/features/profile/presentation/widgets/experience_bottom_sheet.dart` and `lib/features/profile/presentation/bloc/profile_bloc.dart`
- [ ] T025 [US3] Enforce required education validation and invalid-date blocking in `lib/features/profile/presentation/widgets/education_bottom_sheet.dart` and `lib/features/profile/presentation/bloc/profile_bloc.dart`
- [ ] T026 [US3] Surface clear field-level error messages and prevent future birth-date selection in `lib/features/profile/presentation/widgets/basic_details_section.dart`, `lib/features/profile/presentation/widgets/country_code_dropdown.dart`, and `lib/features/profile/presentation/pages/edit_profile_page.dart`

**Checkpoint**: All user stories should now be independently functional, with validation guarding bad profile data.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories.

- [ ] T027 [P] Extract shared repeatable-input and section-wrapper widgets for scalable reuse in `lib/features/profile/presentation/widgets/dynamic_field_list.dart` and `lib/features/profile/presentation/widgets/profile_section_card.dart`
- [ ] T028 [P] Run the manual quickstart validation flow and update implementation notes in `specs/005-edit-profile-flow/quickstart.md`
- [ ] T029 Resolve analyzer follow-up issues across `lib/features/profile/` and `lib/app.dart`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; can start immediately.
- **Foundational (Phase 2)**: Depends on Setup completion and blocks all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational completion.
- **User Story 2 (Phase 4)**: Depends on Foundational completion and can proceed after the profile draft/persistence foundation is in place.
- **User Story 3 (Phase 5)**: Depends on Foundational completion and should be applied after the US1 and US2 editing surfaces exist.
- **Polish (Phase 6)**: Depends on the desired user stories being complete.

### User Story Dependencies

- **US1 (P1)**: Starts immediately after Foundational; no dependency on later stories.
- **US2 (P2)**: Starts after Foundational and builds on the shared edit-profile draft and persistence path created for US1.
- **US3 (P3)**: Starts after Foundational but relies on the US1 and US2 form surfaces to apply the full validation rules.

### Parallel Opportunities

- `T003` can run in parallel with `T001` and `T002` after route planning is clear.
- `T005` and `T006` can run in parallel after `T004` defines the domain entity shape.
- `T010`, `T012`, and `T013` can run in parallel within US1.
- `T016`, `T018`, and `T019` can run in parallel within US2.
- `T022` can run in parallel with visual work that depends on the validation contracts.
- `T027` and `T028` can run in parallel during polish.

---

## Parallel Example: User Story 1

```text
Task: "Build read-only summary widgets in lib/features/profile/presentation/widgets/profile_identity_card.dart, lib/features/profile/presentation/widgets/profile_summary_section.dart, and lib/features/profile/presentation/widgets/profile_contact_section.dart"
Task: "Build the Edit Profile page basic-details form in lib/features/profile/presentation/pages/edit_profile_page.dart and lib/features/profile/presentation/widgets/basic_details_section.dart"
Task: "Implement gallery image selection and country-code selection widgets in lib/features/profile/presentation/widgets/profile_image_picker_field.dart and lib/features/profile/presentation/widgets/country_code_dropdown.dart"
```

## Parallel Example: User Story 2

```text
Task: "Build inline dynamic-section widgets in lib/features/profile/presentation/widgets/skills_section.dart, lib/features/profile/presentation/widgets/hobbies_section.dart, lib/features/profile/presentation/widgets/awards_section.dart, and lib/features/profile/presentation/widgets/certifications_section.dart"
Task: "Implement the experience list and bottom-sheet editor in lib/features/profile/presentation/widgets/experience_section.dart and lib/features/profile/presentation/widgets/experience_bottom_sheet.dart"
Task: "Implement the education list and bottom-sheet editor in lib/features/profile/presentation/widgets/education_section.dart and lib/features/profile/presentation/widgets/education_bottom_sheet.dart"
```

## Parallel Example: User Story 3

```text
Task: "Create reusable validation helpers in lib/features/profile/domain/usecases/validate_profile_field.dart and lib/features/profile/domain/usecases/validate_profile_record.dart"
Task: "Enforce required work-experience validation in lib/features/profile/presentation/widgets/experience_bottom_sheet.dart and lib/features/profile/presentation/bloc/profile_bloc.dart"
Task: "Enforce required education validation in lib/features/profile/presentation/widgets/education_bottom_sheet.dart and lib/features/profile/presentation/bloc/profile_bloc.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup.
2. Complete Phase 2: Foundational.
3. Complete Phase 3: User Story 1.
4. Stop and validate the Profile-to-Edit-to-Save journey independently before expanding scope.

### Incremental Delivery

1. Finish Setup and Foundational work to establish the reusable profile stack.
2. Deliver US1 so users can edit and save basic profile information.
3. Deliver US2 so repeated sections become fully manageable.
4. Deliver US3 so the entire edit flow enforces validation rules without data loss.
5. Finish with polish and analyzer/manual validation.

### Parallel Team Strategy

1. One developer completes the domain, persistence, and bloc foundation in Phase 2.
2. After foundation is stable:
   - Developer A: US1 summary page, edit page, and navigation.
   - Developer B: US2 dynamic sections and bottom sheets.
   - Developer C: US3 validation helpers and validation wiring.

---

## Notes

- All tasks follow the required checklist format: checkbox, sequential ID, optional `[P]`, required story label for story tasks, and exact file paths.
- User story tasks are grouped so each phase maps to a demonstrable increment.
- Avoid starting US2 or US3 before the shared profile domain, persistence, and bloc layers are in place.