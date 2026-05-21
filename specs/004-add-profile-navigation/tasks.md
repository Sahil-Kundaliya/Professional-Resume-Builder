# Tasks: Add Profile Navigation

**Input**: Design documents from `/specs/004-add-profile-navigation/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Tests are not explicitly requested in the specification, so this task list prioritizes implementation plus focused manual validation for each user story.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- Flutter application code lives under `lib/`
- App wiring lives under `lib/app.dart`, `lib/main.dart`, and `lib/config/di/`
- Feature code lives under `lib/features/home/`, `lib/features/profile/`, and `lib/features/resume/`
- Feature planning artifacts live under `specs/004-add-profile-navigation/`

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare app-level navigation, shared route definitions, and feature registration for the new profile flow

- [x] T001 Reconcile route constants and add shell/profile route identifiers in lib/core/constants/app_routes.dart and lib/config/routes/route_names.dart
- [x] T002 [P] Create profile feature registration scaffolding in lib/features/profile/profile_injection.dart and lib/config/di/injection_container.dart
- [x] T003 [P] Add app-shell entry scaffolding for bottom navigation in lib/app.dart and lib/main.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core profile domain, persistence, and resume-prefill infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [ ] T004 Create reusable profile domain entities for profile data and repeated sections in lib/features/profile/domain/entities/resume_profile.dart
- [ ] T005 [P] Create local persistence DTOs for the reusable profile in lib/features/profile/data/models/resume_profile_model.dart
- [ ] T006 [P] Map profile DTOs and domain entities in lib/features/profile/data/mappers/resume_profile_mapper.dart
- [ ] T007 Implement file-backed local profile datasource interfaces and storage logic in lib/features/profile/data/datasources/profile_local_datasource.dart and lib/features/profile/data/datasources/profile_local_datasource_impl.dart
- [ ] T008 Implement profile repository interfaces and profile load/save use cases in lib/features/profile/domain/repositories/profile_repository.dart, lib/features/profile/domain/usecases/get_profile.dart, and lib/features/profile/domain/usecases/save_profile.dart
- [ ] T009 Implement profile presentation state, events, and save/load flows in lib/features/profile/presentation/bloc/profile_bloc.dart, lib/features/profile/presentation/bloc/profile_event.dart, and lib/features/profile/presentation/bloc/profile_state.dart
- [ ] T010 Add profile-to-resume prefill mapping for blank and saved-profile startup paths in lib/features/resume/data/mappers/profile_resume_prefill_mapper.dart and lib/features/resume/domain/entities/resume_document.dart
- [ ] T011 Regenerate Freezed/JSON outputs for lib/features/profile/domain/entities/resume_profile.dart, lib/features/profile/data/models/resume_profile_model.dart, and lib/features/profile/presentation/bloc/profile_event.dart plus lib/features/profile/presentation/bloc/profile_state.dart

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Switch Between Home And Profile (Priority: P1) 🎯 MVP

**Goal**: Let users move between Home and Profile from a persistent bottom navigation while preserving the current Home template journey

**Independent Test**: Launch the app, switch between Home and Profile, and confirm Home still shows templates and continues to open template preview and the resume editor through the same visible flow as before.

### Implementation for User Story 1

- [x] T012 [US1] Implement the bottom navigation shell and top-level tab state in lib/app.dart
- [x] T013 [US1] Keep the existing Home feature behavior intact within the shell in lib/features/home/presentation/pages/home_page.dart and lib/features/home/presentation/pages/home_page_view.dart
- [x] T014 [US1] Wire the Profile tab destination and first-load placeholder-safe entry page in lib/features/profile/presentation/pages/profile_page.dart

**Checkpoint**: User Story 1 should provide a functioning two-tab shell without changing the Home journey

---

## Phase 4: User Story 2 - Review A Reusable Resume Profile (Priority: P2)

**Goal**: Show a clean Profile page that loads locally saved profile data and falls back to placeholder identity data when no saved profile exists

**Independent Test**: Open Profile with no saved data and confirm placeholder image, full name, and job title appear; then save profile data and confirm the latest saved sections render when Profile is reopened.

### Implementation for User Story 2

- [ ] T015 [P] [US2] Create reusable profile summary widgets for identity, contact information, skills, hobbies, work experience, and education in lib/features/profile/presentation/widgets/profile_header_card.dart and lib/features/profile/presentation/widgets/profile_section_card.dart
- [ ] T016 [US2] Load placeholder and persisted profile states into the Profile tab in lib/features/profile/presentation/bloc/profile_bloc.dart and lib/features/profile/presentation/pages/profile_page.dart
- [ ] T017 [US2] Render saved profile values and empty optional sections safely in lib/features/profile/presentation/pages/profile_page.dart and lib/features/profile/presentation/widgets/profile_section_card.dart
- [ ] T018 [US2] Finalize profile feature dependency registration for summary loading in lib/features/profile/profile_injection.dart and lib/config/di/injection_container.dart

**Checkpoint**: User Stories 1 and 2 should now support navigation plus reusable profile viewing with placeholder fallback and local reloads

---

## Phase 5: User Story 3 - Start A Template With Or Without Saved Profile Data (Priority: P3)

**Goal**: Let users choose whether to open a blank editor or a profile-prefilled editor when they start from template preview

**Independent Test**: From template preview, tap Use this template, confirm the dialog appears with both actions, choose each action in separate runs, and verify the editor opens either blank or prefilled from saved profile data while remaining editable.

### Implementation for User Story 3

- [ ] T019 [US3] Add the template start confirmation dialog with title, description, and both actions in lib/features/resume/presentation/pages/template_preview_page.dart
- [ ] T020 [P] [US3] Extend resume startup events and state to support scratch and prefilled initialization in lib/features/resume/presentation/bloc/resume_event.dart, lib/features/resume/presentation/bloc/resume_state.dart, and lib/features/resume/presentation/bloc/resume_bloc.dart
- [ ] T021 [P] [US3] Implement saved-profile resume prefill creation in lib/features/resume/data/mappers/profile_resume_prefill_mapper.dart and lib/features/profile/domain/usecases/get_profile.dart
- [ ] T022 [US3] Route Start From Scratch and Use Your Data through template preview into the editor in lib/features/resume/presentation/pages/template_preview_page.dart and lib/features/resume/presentation/pages/resume_editor_page.dart
- [ ] T023 [US3] Preserve prefilled resume content through preview and PDF generation flows in lib/features/resume/presentation/pages/pdf_preview_page.dart and lib/core/utils/pdf_generator.dart

**Checkpoint**: User Stories 1 through 3 should now support tab navigation, reusable profile viewing, and branchable template startup

---

## Phase 6: User Story 4 - Edit Optional Profile Details (Priority: P4)

**Goal**: Let users edit all optional profile fields and manage repeated profile sections with local persistence

**Independent Test**: Open Edit Profile, update any subset of scalar fields, add multiple repeated items across hobbies, skills, work experience, and education, save, and confirm the Profile page reloads the latest saved values.

### Implementation for User Story 4

- [ ] T024 [US4] Add navigation from the Profile summary page into the edit flow in lib/features/profile/presentation/pages/profile_page.dart and lib/features/profile/presentation/pages/edit_profile_page.dart
- [ ] T025 [P] [US4] Create reusable profile form sections for scalar fields and image selection in lib/features/profile/presentation/widgets/profile_identity_form.dart and lib/features/profile/presentation/widgets/profile_contact_form.dart
- [ ] T026 [US4] Implement profile image picking and scalar field editing in lib/features/profile/presentation/pages/edit_profile_page.dart and lib/features/profile/presentation/bloc/profile_bloc.dart
- [ ] T027 [P] [US4] Implement dynamic hobbies and skills editors with add/remove actions and 1-5 ratings in lib/features/profile/presentation/widgets/profile_hobbies_form.dart and lib/features/profile/presentation/widgets/profile_skills_form.dart
- [ ] T028 [P] [US4] Implement dynamic work experience and education editors with optional date and description fields in lib/features/profile/presentation/widgets/profile_work_experience_form.dart and lib/features/profile/presentation/widgets/profile_education_form.dart
- [ ] T029 [US4] Persist partial and repeated profile edits, then reload the updated summary state in lib/features/profile/presentation/bloc/profile_bloc.dart, lib/features/profile/domain/usecases/save_profile.dart, and lib/features/profile/presentation/pages/profile_page.dart

**Checkpoint**: All user stories should now be independently functional, including local profile editing and reuse

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Harden navigation, persistence, and prefill behavior across the completed feature

- [ ] T030 [P] Update implementation and validation guidance in specs/004-add-profile-navigation/quickstart.md
- [ ] T031 Run manual quickstart validation for bottom navigation, profile persistence, template dialog branching, prefill behavior, and PDF preview compatibility using specs/004-add-profile-navigation/quickstart.md

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Story 1 (Phase 3)**: Depends on Foundational completion
- **User Story 2 (Phase 4)**: Depends on Foundational completion and uses the profile persistence pipeline
- **User Story 3 (Phase 5)**: Depends on Foundational completion and uses the profile repository plus resume prefill mapper
- **User Story 4 (Phase 6)**: Depends on Foundational completion and benefits from User Story 2 profile viewing flow
- **Polish (Phase 7)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational - delivers the MVP app shell and preserves the current Home flow
- **User Story 2 (P2)**: Can start after Foundational - uses the same profile data layer but remains independently testable as a view/load flow
- **User Story 3 (P3)**: Depends on the profile persistence foundation and integrates with the existing resume flow, but remains independently testable from template preview
- **User Story 4 (P4)**: Depends on the same profile data layer and completes the user-managed editing journey for the Profile tab

### Within Each User Story

- Shared models, repositories, and bloc scaffolding must exist before story-specific UI wiring
- Summary-page loading should be stable before edit-save loops are validated
- Template startup branching should be implemented before preview/PDF compatibility is validated
- Repeated section editors should be in place before final save/reload behavior is verified

### Parallel Opportunities

- `T002` and `T003` can run in parallel after route decisions from `T001`
- `T005` and `T006` can run in parallel after `T004`
- `T015` can run in parallel with `T016` once the profile bloc contract is defined
- `T020` and `T021` can run in parallel once the prefill mapper contract from the foundation is available
- `T025`, `T027`, and `T028` can run in parallel once the edit-page flow from `T024` is defined

---

## Parallel Example: User Story 4

```bash
Task: "Create reusable profile form sections for scalar fields and image selection in lib/features/profile/presentation/widgets/profile_identity_form.dart and lib/features/profile/presentation/widgets/profile_contact_form.dart"
Task: "Implement dynamic hobbies and skills editors with add/remove actions and 1-5 ratings in lib/features/profile/presentation/widgets/profile_hobbies_form.dart and lib/features/profile/presentation/widgets/profile_skills_form.dart"
Task: "Implement dynamic work experience and education editors with optional date and description fields in lib/features/profile/presentation/widgets/profile_work_experience_form.dart and lib/features/profile/presentation/widgets/profile_education_form.dart"
```

---

## Parallel Example: User Story 3

```bash
Task: "Extend resume startup events and state to support scratch and prefilled initialization in lib/features/resume/presentation/bloc/resume_event.dart, lib/features/resume/presentation/bloc/resume_state.dart, and lib/features/resume/presentation/bloc/resume_bloc.dart"
Task: "Implement saved-profile resume prefill creation in lib/features/resume/data/mappers/profile_resume_prefill_mapper.dart and lib/features/profile/domain/usecases/get_profile.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Confirm the app shell exposes Home and Profile while the Home template flow remains unchanged

### Incremental Delivery

1. Finish Setup + Foundational to establish routing, profile persistence, and prefill infrastructure
2. Deliver User Story 1 for navigation and Home preservation
3. Deliver User Story 2 for profile viewing with placeholder fallback and local reloads
4. Deliver User Story 3 for template dialog branching and resume prefill
5. Deliver User Story 4 for full profile editing and repeated-section persistence
6. Complete Polish validation for release confidence

### Parallel Team Strategy

1. One developer completes Setup + Foundational tasks
2. After the foundation is ready:
   - Developer A: User Story 1 app shell and Home preservation
   - Developer B: User Story 2 profile summary and load states
   - Developer C: User Story 3 template branching and prefill
   - Developer D: User Story 4 edit forms and save flow

---

## Notes

- All tasks follow the required checklist format with task ID, optional parallel marker, optional story label, and exact file paths
- User stories remain traceable to the spec priorities `US1`, `US2`, `US3`, and `US4`
- The task list keeps profile persistence as a single reusable local profile for this phase
- Manual validation in `quickstart.md` is the required acceptance path because automated tests were not explicitly requested in the specification