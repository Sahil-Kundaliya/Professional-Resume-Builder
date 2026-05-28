# Tasks: Improve Resume Form Modern UX

**Input**: Design documents from `/specs/013-improve-resume-form-ux/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/resume-form-ui-contract.md, quickstart.md

**Tests**: Include widget and flow validation tasks because this feature explicitly requires validation of image preview, skill rating updates, responsive layout, and template-color application.

**Organization**: Tasks are grouped by user story to ensure each story remains independently implementable and testable.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare feature scaffolding and test files for execution.

- [X] T001 Create feature task baseline notes in specs/013-improve-resume-form-ux/tasks.md
- [X] T002 [P] Add form UX test suite scaffold in test/features/resume/presentation/resume_form_page_modern_ux_test.dart
- [X] T003 [P] Add style mapping test scaffold in test/features/resume/presentation/resume_template_style_mapping_test.dart
- [X] T004 [P] Add skill rating flow test scaffold in test/features/resume/presentation/skill_rating_interaction_test.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Build shared components and model updates required by all user stories.

**⚠️ CRITICAL**: No user story implementation begins until this phase is complete.

- [ ] T005 Create reusable section container widget in lib/features/resume/presentation/widgets/resume_form_section_card.dart
- [ ] T006 Create template-aware form style mapper in lib/features/resume/presentation/widgets/resume_template_form_style.dart
- [ ] T007 Create reusable profile image preview widget in lib/features/resume/presentation/widgets/profile_image_preview_tile.dart
- [ ] T008 Create reusable star rating input widget in lib/features/resume/presentation/widgets/skill_rating_input.dart
- [ ] T009 Update shared form section utilities to support grouped cards in lib/features/resume/presentation/widgets/resume_form_section_support.dart
- [ ] T010 Update shared form feedback utilities for UX-consistent messaging in lib/features/resume/presentation/widgets/resume_form_feedback.dart
- [ ] T011 Extend skill entry mapping to persist level (1-5) in lib/features/resume/presentation/widgets/resume_form_mappers.dart
- [ ] T012 Extend shared validators for skill level constraints in lib/features/resume/presentation/widgets/resume_form_validators.dart

**Checkpoint**: Shared UI and data prerequisites are ready.

---

## Phase 3: User Story 1 - Complete Resume Faster With Clear Sections (Priority: P1) 🎯 MVP

**Goal**: Deliver a modern, readable, sectioned ResumeFormPage that replaces a long plain field list.

**Independent Test**: Open ResumeFormPage with realistic sample data and verify all major groups render as distinct, readable sections with consistent spacing and hierarchy.

### Tests for User Story 1

- [ ] T013 [P] [US1] Add widget test for grouped section rendering in test/features/resume/presentation/resume_form_page_modern_ux_test.dart
- [ ] T014 [P] [US1] Add widget test for responsive spacing and hierarchy in test/features/resume/presentation/resume_form_page_modern_ux_test.dart

### Implementation for User Story 1

- [ ] T015 [US1] Refactor page layout composition to sectioned cards in lib/features/resume/presentation/pages/resume_form_page.dart
- [ ] T016 [P] [US1] Update profile/basic information section layout in lib/features/resume/presentation/widgets/resume_basic_info_section.dart
- [ ] T017 [P] [US1] Update education section layout for card-based grouping in lib/features/resume/presentation/widgets/resume_education_section.dart
- [ ] T018 [P] [US1] Update work experience section layout for card-based grouping in lib/features/resume/presentation/widgets/resume_work_experience_section.dart
- [ ] T019 [P] [US1] Update repeatable text section layout for hobbies and references in lib/features/resume/presentation/widgets/resume_repeatable_text_section.dart
- [ ] T020 [P] [US1] Update awards section layout for grouped readability in lib/features/resume/presentation/widgets/resume_awards_certifications_section.dart
- [ ] T021 [US1] Normalize add/edit/remove action affordances for dynamic records in lib/features/resume/presentation/widgets/resume_dynamic_record_tile.dart

**Checkpoint**: User Story 1 provides an independently usable modern grouped form experience.

---

## Phase 4: User Story 2 - See Template Style While Editing (Priority: P2)

**Goal**: Apply selected template colors consistently to form controls and visual accents.

**Independent Test**: Switch between at least two templates and verify button accents, section headers, focus states, and highlights update consistently without data loss.

### Tests for User Story 2

- [ ] T022 [P] [US2] Add widget test for template accent propagation on buttons and section headers in test/features/resume/presentation/resume_template_style_mapping_test.dart
- [ ] T023 [P] [US2] Add widget test for focused field and highlight color states in test/features/resume/presentation/resume_template_style_mapping_test.dart

### Implementation for User Story 2

- [ ] T024 [US2] Integrate template form style resolver into page state composition in lib/features/resume/presentation/pages/resume_form_page.dart
- [ ] T025 [P] [US2] Apply template accents to section headers and highlights in lib/features/resume/presentation/widgets/resume_form_section_card.dart
- [ ] T026 [P] [US2] Apply template accents to primary and secondary action controls in lib/features/resume/presentation/widgets/resume_form_section_support.dart
- [ ] T027 [P] [US2] Apply template-based focus styles to editable inputs in lib/features/resume/presentation/widgets/resume_basic_info_section.dart
- [ ] T028 [US2] Ensure template color safety and contrast fallbacks in lib/features/resume/presentation/widgets/resume_template_form_style.dart

**Checkpoint**: User Story 2 independently demonstrates template-aware editing continuity.

---

## Phase 5: User Story 3 - Edit Rich Content Elements Intuitively (Priority: P3)

**Goal**: Provide inline profile image preview and editable 1-5 star skill ratings with consistent dynamic editing UX.

**Independent Test**: Select an image and verify preview rendering/fallback, then add and edit skills with star ratings and verify persisted values after reopening.

### Tests for User Story 3

- [ ] T029 [P] [US3] Add widget test for profile image preview and fallback behavior in test/features/resume/presentation/resume_form_page_modern_ux_test.dart
- [ ] T030 [P] [US3] Add widget test for skill 1-5 star rating add/edit persistence in test/features/resume/presentation/skill_rating_interaction_test.dart
- [ ] T031 [P] [US3] Add responsive widget test for image and skills sections across screen sizes in test/features/resume/presentation/resume_form_page_modern_ux_test.dart

### Implementation for User Story 3

- [ ] T032 [US3] Replace path-first image output with inline preview container in lib/features/resume/presentation/widgets/resume_basic_info_section.dart
- [ ] T033 [US3] Wire image preview state transitions into page rendering in lib/features/resume/presentation/pages/resume_form_page.dart
- [ ] T034 [US3] Add skill level field (1-5) handling to skills editing flow in lib/features/resume/presentation/widgets/resume_repeatable_text_section.dart
- [ ] T035 [US3] Integrate reusable star rating input into skill add/edit interactions in lib/features/resume/presentation/widgets/skill_rating_input.dart
- [ ] T036 [US3] Persist and reload skill level values in form mapper and state sync in lib/features/resume/presentation/widgets/resume_form_mappers.dart
- [ ] T037 [US3] Ensure skill level validation and user feedback for invalid values in lib/features/resume/presentation/widgets/resume_form_validators.dart

**Checkpoint**: User Story 3 independently validates rich content editing for image and skills.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final hardening for production-grade, scalable, backward-compatible delivery.

- [ ] T038 [P] Add migration-safe fallback handling for skills without existing level values in lib/features/resume/presentation/widgets/resume_form_mappers.dart
- [ ] T039 [P] Final accessibility and interaction polish for focus visibility and tap targets in lib/features/resume/presentation/pages/resume_form_page.dart
- [ ] T040 Run quickstart verification scenarios and update acceptance notes in specs/013-improve-resume-form-ux/quickstart.md
- [ ] T041 Validate contract alignment and update finalized behavior notes in specs/013-improve-resume-form-ux/contracts/resume-form-ui-contract.md

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies.
- **Phase 2 (Foundational)**: Depends on Phase 1 and blocks all user stories.
- **Phase 3 (US1)**: Depends on Phase 2.
- **Phase 4 (US2)**: Depends on Phase 2 and can run in parallel with US1 once foundation is complete.
- **Phase 5 (US3)**: Depends on Phase 2 and can run in parallel with US1/US2 once foundation is complete.
- **Phase 6 (Polish)**: Depends on completion of selected user stories.

### User Story Dependencies

- **US1 (P1)**: No dependency on other user stories.
- **US2 (P2)**: No strict dependency on US1, but should reuse shared section container introduced in foundation.
- **US3 (P3)**: No strict dependency on US1/US2, but relies on foundational mapping/validation updates.

### Within Each User Story

- Write tests first where feasible, then implement layout/state changes, then validate independent story acceptance criteria.

### Dependency Graph

- Foundation -> US1
- Foundation -> US2
- Foundation -> US3
- US1 + US2 + US3 -> Polish

---

## Parallel Execution Examples

### User Story 1

```bash
Task: "T016 [US1] Update profile/basic information section layout in lib/features/resume/presentation/widgets/resume_basic_info_section.dart"
Task: "T017 [US1] Update education section layout for card-based grouping in lib/features/resume/presentation/widgets/resume_education_section.dart"
Task: "T018 [US1] Update work experience section layout for card-based grouping in lib/features/resume/presentation/widgets/resume_work_experience_section.dart"
Task: "T019 [US1] Update repeatable text section layout for hobbies and references in lib/features/resume/presentation/widgets/resume_repeatable_text_section.dart"
Task: "T020 [US1] Update awards section layout for grouped readability in lib/features/resume/presentation/widgets/resume_awards_certifications_section.dart"
```

### User Story 2

```bash
Task: "T025 [US2] Apply template accents to section headers and highlights in lib/features/resume/presentation/widgets/resume_form_section_card.dart"
Task: "T026 [US2] Apply template accents to primary and secondary action controls in lib/features/resume/presentation/widgets/resume_form_section_support.dart"
Task: "T027 [US2] Apply template-based focus styles to editable inputs in lib/features/resume/presentation/widgets/resume_basic_info_section.dart"
```

### User Story 3

```bash
Task: "T029 [US3] Add widget test for profile image preview and fallback behavior in test/features/resume/presentation/resume_form_page_modern_ux_test.dart"
Task: "T030 [US3] Add widget test for skill 1-5 star rating add/edit persistence in test/features/resume/presentation/skill_rating_interaction_test.dart"
Task: "T031 [US3] Add responsive widget test for image and skills sections across screen sizes in test/features/resume/presentation/resume_form_page_modern_ux_test.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Setup and Foundational phases.
2. Complete US1 layout modernization and grouping.
3. Validate US1 independent test criteria before expanding scope.

### Incremental Delivery

1. Foundation complete -> enable parallel workstreams.
2. Deliver US1 grouped layout first (core UX value).
3. Deliver US2 template-aware styling continuity.
4. Deliver US3 rich content editing (image preview + skill rating).
5. Execute polish and regression validation.

### Parallel Team Strategy

1. One engineer finalizes foundational widgets/mappers.
2. Engineer A executes US1 section redesign.
3. Engineer B executes US2 template styling propagation.
4. Engineer C executes US3 image/skills enhancements.
5. Merge and run shared polish/validation tasks.

---

## Notes

- All tasks use strict checklist format: `- [ ] T### [P] [US#] Description with file path` where applicable.
- Tasks marked `[P]` are parallelizable by file-level independence.
- Story labels are applied only to user story tasks (US1-US3).
- The plan preserves backward compatibility through mapper fallback handling for legacy skills data.
