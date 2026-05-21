# Tasks: Template Preview Profile Prefill Flow

**Input**: Design documents from `/specs/007-profile-prefill-flow/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Test tasks are not included because the specification does not explicitly require TDD or mandatory new test cases.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare reusable prefill contracts and mapping scaffolding used by all user stories.

- [X] T001 Create resume creation choice enum in lib/features/resume/domain/entities/resume_creation_choice.dart
- [X] T002 Create profile availability result model in lib/features/resume/domain/entities/profile_availability_result.dart
- [X] T003 [P] Create profile-to-resume prefill mapper skeleton in lib/features/resume/data/mappers/profile_to_resume_prefill_mapper.dart
- [X] T004 [P] Add prefill flow constants for dialog labels in lib/features/resume/presentation/constants/resume_prefill_flow_labels.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Build the shared prefill and availability infrastructure that all stories depend on.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

- [X] T005 Implement field-level non-empty guard helpers in lib/features/resume/domain/services/profile_value_guards.dart
- [X] T006 Implement profile availability evaluator using per-field checks in lib/features/resume/domain/services/profile_availability_evaluator.dart
- [X] T007 [P] Add profile loading gateway interface for template flow in lib/features/resume/domain/repositories/profile_prefill_repository.dart
- [X] T008 Implement profile loading gateway with existing profile repository in lib/features/resume/data/repositories/profile_prefill_repository_impl.dart
- [X] T009 Implement profile-to-resume mapping for scalar fields (image, full name, job position, birth date, contact fields) in lib/features/resume/data/mappers/profile_to_resume_prefill_mapper.dart
- [X] T010 Implement profile-to-resume mapping for collection fields (skills, hobbies, experience, education, awards, certifications) in lib/features/resume/data/mappers/profile_to_resume_prefill_mapper.dart
- [X] T011 Wire prefill repository and evaluator in dependency injection container in lib/config/di/injection_container.dart

**Checkpoint**: Foundation ready. User story implementation can now begin.

---

## Phase 3: User Story 1 - Continue Without Profile Data (Priority: P1) 🎯 MVP

**Goal**: When stored profile data is null/empty, tap on "Use this template" should skip dialog and continue normal resume creation and editor navigation.

**Independent Test**: Save no profile data (or placeholder-only profile), tap "Use this template", and verify no dialog appears and editor opens normally.

### Implementation for User Story 1

- [X] T012 [US1] Refactor template button tap into dedicated async flow in lib/features/resume/presentation/pages/template_preview_page.dart
- [X] T013 [US1] Integrate profile availability check before create action in lib/features/resume/presentation/pages/template_preview_page.dart
- [X] T014 [US1] Implement no-data branch to dispatch create-new flow without dialog in lib/features/resume/presentation/pages/template_preview_page.dart
- [X] T015 [US1] Ensure fallback-to-create-new behavior on profile load failure in lib/features/resume/presentation/pages/template_preview_page.dart
- [X] T016 [US1] Preserve existing navigation to editor route in no-data branch in lib/features/resume/presentation/pages/template_preview_page.dart

**Checkpoint**: User Story 1 is independently functional and testable.

---

## Phase 4: User Story 2 - Choose Create New vs Use Profile Data (Priority: P1)

**Goal**: When stored profile data exists, show dialog titled "Select contest to create CV" with actions "Create new" and "Use profile data" and execute the selected flow.

**Independent Test**: With valid stored profile data, tap "Use this template", verify dialog appears, choose each action in separate runs, and verify expected creation behavior.

### Implementation for User Story 2

- [X] T017 [US2] Implement conditional decision dialog with exact title and action labels in lib/features/resume/presentation/pages/template_preview_page.dart
- [X] T018 [US2] Implement dialog "Create new" action to dispatch normal create flow in lib/features/resume/presentation/pages/template_preview_page.dart
- [X] T019 [US2] Add create event variant supporting optional prefill profile snapshot in lib/features/resume/presentation/bloc/resume_event.dart
- [X] T020 [US2] Update resume create handler to accept create-new and prefill context paths in lib/features/resume/presentation/bloc/resume_bloc.dart
- [X] T021 [US2] Implement dialog "Use profile data" action to pass loaded profile context to resume creation in lib/features/resume/presentation/pages/template_preview_page.dart
- [X] T022 [US2] Apply mapper output during resume creation before emitting loaded state in lib/features/resume/presentation/bloc/resume_bloc.dart

**Checkpoint**: User Stories 1 and 2 are independently functional and testable.

---

## Phase 5: User Story 3 - Respect Explicit Choice on Every Attempt (Priority: P2)

**Goal**: Ensure explicit choice is respected for each template creation attempt, with no duplicate create/navigation actions and no stale choice reuse.

**Independent Test**: Repeat template creation multiple times with profile data present and verify dialog reappears each time, selected action is applied once, and navigation is consistent.

### Implementation for User Story 3

- [X] T023 [US3] Prevent duplicate tap processing and duplicate navigation in template flow state in lib/features/resume/presentation/pages/template_preview_page.dart
- [X] T024 [US3] Ensure dialog dismissal exits flow without resume creation in lib/features/resume/presentation/pages/template_preview_page.dart
- [X] T025 [US3] Reset per-attempt prefill decision state after navigation completion in lib/features/resume/presentation/pages/template_preview_page.dart
- [X] T026 [US3] Add idempotent guard in create-resume handler for a single resolved action per attempt in lib/features/resume/presentation/bloc/resume_bloc.dart

**Checkpoint**: All user stories are independently functional and testable.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final cleanup and validation across all stories.

- [X] T027 [P] Add inline documentation comments for mapping and availability rules in lib/features/resume/data/mappers/profile_to_resume_prefill_mapper.dart
- [X] T028 [P] Add inline documentation comments for flow guards in lib/features/resume/presentation/pages/template_preview_page.dart
- [X] T029 Validate quickstart scenarios and update expected outcomes in specs/007-profile-prefill-flow/quickstart.md
- [X] T030 Verify contract-language alignment with final behavior in specs/007-profile-prefill-flow/contracts/template-preview-prefill-flow.md

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies.
- **Phase 2 (Foundational)**: Depends on Phase 1 and blocks all user stories.
- **Phase 3 (US1)**: Depends on Phase 2.
- **Phase 4 (US2)**: Depends on Phase 2 and integrates with US1 template flow refactor.
- **Phase 5 (US3)**: Depends on US1 and US2 behavior paths.
- **Phase 6 (Polish)**: Depends on completion of targeted user stories.

### User Story Dependencies

- **US1 (P1)**: Can start immediately after Foundational completion.
- **US2 (P1)**: Can start after Foundational completion; depends on the shared tap-flow refactor from US1 for clean integration.
- **US3 (P2)**: Depends on US2 dialog and selection behavior being in place.

### Parallel Opportunities

- Setup tasks `T003` and `T004` can run in parallel.
- Foundational tasks `T007` can run in parallel with `T005`/`T006` before `T008` integration.
- Polish tasks `T027` and `T028` can run in parallel.

---

## Parallel Example: User Story 1

```bash
Task: "Refactor template button tap into dedicated async flow in lib/features/resume/presentation/pages/template_preview_page.dart"
Task: "Implement no-data branch to dispatch create-new flow without dialog in lib/features/resume/presentation/pages/template_preview_page.dart"
```

## Parallel Example: User Story 2

```bash
Task: "Add create event variant supporting optional prefill profile snapshot in lib/features/resume/presentation/bloc/resume_event.dart"
Task: "Implement conditional decision dialog with exact title and action labels in lib/features/resume/presentation/pages/template_preview_page.dart"
```

## Parallel Example: User Story 3

```bash
Task: "Ensure dialog dismissal exits flow without resume creation in lib/features/resume/presentation/pages/template_preview_page.dart"
Task: "Add idempotent guard in create-resume handler for a single resolved action per attempt in lib/features/resume/presentation/bloc/resume_bloc.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 and Phase 2.
2. Complete Phase 3 (US1).
3. Validate no-data flow from template preview to editor.
4. Demo/deploy MVP behavior.

### Incremental Delivery

1. Deliver US1 (no-data seamless flow).
2. Deliver US2 (dialog + explicit choice + prefill path).
3. Deliver US3 (repeatability and idempotent action handling).
4. Complete polish and documentation alignment.

### Suggested MVP Scope

- **MVP**: User Story 1 only (skip dialog and continue normal navigation when profile data is null/empty).
- **Post-MVP**: User Story 2 and User Story 3 for full explicit-choice and resilient prefill behavior.

---

## Notes

- All tasks follow strict checklist format: `- [ ] T### [P?] [US?] Description with file path`.
- Story labels are included only for user story phases.
- Tasks are written to be directly executable by an implementation agent.
