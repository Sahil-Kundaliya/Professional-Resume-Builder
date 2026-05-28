# Tasks: Refactor PDF Section Architecture

**Input**: Design documents from `/specs/014-refactor-pdf-sections/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/, quickstart.md

**Tests**: No explicit TDD requirement was requested in spec/user input; implementation tasks include manual/functional validation via quickstart scenarios.

**Organization**: Tasks are grouped by user story so each story can be implemented and validated independently.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create the file/module structure needed for reusable PDF section renderers.

- [X] T001 Create PDF section module barrel in lib/core/utils/pdf_sections/pdf_sections.dart
- [X] T002 Create shared PDF section build context model in lib/core/utils/pdf_sections/pdf_section_context.dart
- [X] T003 [P] Create shared PDF section style tokens/constants in lib/core/utils/pdf_sections/pdf_section_style.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Implement shared primitives and orchestration contracts required before story work.

**⚠️ CRITICAL**: No user story implementation should begin until this phase is complete.

- [X] T004 Implement reusable section shell (title, divider, spacing) in lib/core/utils/pdf_sections/pdf_section_shell.dart
- [X] T005 [P] Implement reusable section visibility/guard helpers in lib/core/utils/pdf_sections/pdf_section_visibility.dart
- [X] T006 Define deterministic section keys and render-order registry in lib/core/utils/pdf_sections/pdf_section_registry.dart
- [X] T007 [P] Extract shared PDF primitives (profile row, metadata text helpers) in lib/core/utils/pdf_sections/pdf_section_primitives.dart

**Checkpoint**: Shared primitives, guard rules, and deterministic orchestration foundation are ready.

---

## Phase 3: User Story 1 - Consistent Resume PDF Sections (Priority: P1) 🎯 MVP

**Goal**: Convert inline section rendering into reusable section builders while preserving current design and order.

**Independent Test**: Generate a PDF with all sections populated and verify section order, spacing, typography, and content structure match current behavior.

### Implementation for User Story 1

- [X] T008 [P] [US1] Create work experience section builder in lib/core/utils/pdf_sections/work_experience_section_builder.dart
- [X] T009 [P] [US1] Create education section builder in lib/core/utils/pdf_sections/education_section_builder.dart
- [X] T010 [P] [US1] Create references section builder in lib/core/utils/pdf_sections/references_section_builder.dart
- [X] T011 [P] [US1] Create profile section builder in lib/core/utils/pdf_sections/profile_section_builder.dart
- [X] T012 [P] [US1] Create hobbies section builder in lib/core/utils/pdf_sections/hobbies_section_builder.dart
- [X] T013 [P] [US1] Create skills section builder in lib/core/utils/pdf_sections/skills_section_builder.dart
- [X] T014 [P] [US1] Create awards section builder in lib/core/utils/pdf_sections/awards_section_builder.dart
- [X] T015 [P] [US1] Create certifications section builder in lib/core/utils/pdf_sections/certifications_section_builder.dart
- [X] T016 [US1] Create summary section builder in lib/core/utils/pdf_sections/summary_section_builder.dart
- [X] T017 [US1] Replace inline section composition with reusable builder composition in lib/core/utils/pdf_generator.dart

**Checkpoint**: All targeted sections render through reusable builders with baseline design preserved.

---

## Phase 4: User Story 2 - Automatic Empty Section Removal (Priority: P1)

**Goal**: Apply consistent null/empty/whitespace conditional rendering so hidden sections are fully removed without spacing artifacts.

**Independent Test**: Generate PDFs with each section emptied one-by-one and confirm removed sections do not render headings, body content, or blank gaps.

### Implementation for User Story 2

- [X] T018 [P] [US2] Add renderability guard for work experience entries in lib/core/utils/pdf_sections/work_experience_section_builder.dart
- [X] T019 [P] [US2] Add renderability guard for education entries in lib/core/utils/pdf_sections/education_section_builder.dart
- [X] T020 [P] [US2] Add renderability guard for skills list and ratings in lib/core/utils/pdf_sections/skills_section_builder.dart
- [X] T021 [P] [US2] Add renderability guard for hobbies values in lib/core/utils/pdf_sections/hobbies_section_builder.dart
- [X] T022 [P] [US2] Add renderability guard for references values in lib/core/utils/pdf_sections/references_section_builder.dart
- [X] T023 [P] [US2] Add renderability guard for awards entries in lib/core/utils/pdf_sections/awards_section_builder.dart
- [X] T024 [P] [US2] Add renderability guard for certifications entries in lib/core/utils/pdf_sections/certifications_section_builder.dart
- [X] T025 [P] [US2] Add renderability guard for summary values in lib/core/utils/pdf_sections/summary_section_builder.dart
- [X] T026 [P] [US2] Add optional profile value guard behavior in lib/core/utils/pdf_sections/profile_section_builder.dart
- [X] T027 [US2] Update PDF composition flow to omit hidden sections and collapse spacing in lib/core/utils/pdf_generator.dart

**Checkpoint**: Empty/null/whitespace section data is fully omitted across all targeted sections with no layout gaps.

---

## Phase 5: User Story 3 - Extendable Section Composition (Priority: P2)

**Goal**: Make section composition easy to extend so future section additions are localized and low risk.

**Independent Test**: Add or modify one section through the registry pipeline and verify unrelated sections require no behavior changes.

### Implementation for User Story 3

- [X] T028 [US3] Introduce reusable section builder interface contract in lib/core/utils/pdf_sections/pdf_section_builder.dart
- [X] T029 [US3] Implement registry-driven left/right column section assembly in lib/core/utils/pdf_sections/pdf_section_registry.dart
- [X] T030 [US3] Simplify PdfGenerator entrypoint to execute context + registry pipeline in lib/core/utils/pdf_generator.dart
- [X] T031 [US3] Document add-a-section extension workflow in specs/014-refactor-pdf-sections/contracts/pdf-section-rendering-contract.md

**Checkpoint**: Section orchestration is modular, registry-driven, and easy to extend.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final cleanup and acceptance validation across stories.

- [X] T032 [P] Remove obsolete inline rendering helpers/imports in lib/core/utils/pdf_generator.dart
- [ ] T033 [P] Run quickstart validation matrix and record outcomes in specs/014-refactor-pdf-sections/quickstart.md
- [X] T034 Validate PDF preview integration after refactor in lib/features/resume/presentation/pages/pdf_preview_page.dart

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: Starts immediately
- **Phase 2 (Foundational)**: Depends on Phase 1 and blocks all user stories
- **Phase 3 (US1)**: Depends on Phase 2
- **Phase 4 (US2)**: Depends on Phase 3 section builders being in place
- **Phase 5 (US3)**: Depends on Phase 3 and Phase 4 stabilization
- **Phase 6 (Polish)**: Depends on all user stories being complete

### User Story Dependencies

- **US1 (P1)**: Starts after Foundational phase; no dependency on other stories
- **US2 (P1)**: Depends on US1 modular section builders
- **US3 (P2)**: Depends on US1/US2 composition and guard patterns

### Parallel Opportunities

- Setup: T003 can run in parallel with T001-T002 after module path decision
- Foundational: T005 and T007 can run in parallel after T004 starts
- US1: T008-T015 can run in parallel because each task targets a different section file
- US2: T018-T026 can run in parallel after section files exist
- Polish: T032 and T033 can run in parallel

---

## Parallel Example: User Story 1

```bash
Task: "Create work experience section builder in lib/core/utils/pdf_sections/work_experience_section_builder.dart"
Task: "Create education section builder in lib/core/utils/pdf_sections/education_section_builder.dart"
Task: "Create skills section builder in lib/core/utils/pdf_sections/skills_section_builder.dart"
Task: "Create certifications section builder in lib/core/utils/pdf_sections/certifications_section_builder.dart"
```

---

## Parallel Example: User Story 2

```bash
Task: "Add renderability guard for work experience entries in lib/core/utils/pdf_sections/work_experience_section_builder.dart"
Task: "Add renderability guard for skills list and ratings in lib/core/utils/pdf_sections/skills_section_builder.dart"
Task: "Add renderability guard for summary and optional profile values in lib/core/utils/pdf_sections/summary_section_builder.dart"
Task: "Add optional profile value guard behavior in lib/core/utils/pdf_sections/profile_section_builder.dart"
```

---

## Implementation Strategy

### MVP First (US1)

1. Complete Phase 1 (Setup)
2. Complete Phase 2 (Foundational)
3. Complete Phase 3 (US1)
4. Validate full-data PDF design parity before continuing

### Incremental Delivery

1. Deliver US1 reusable section architecture
2. Deliver US2 conditional visibility behavior
3. Deliver US3 scalability and extension workflow
4. Finish with Phase 6 cleanup and acceptance validation

### Team Parallelization Strategy

1. One developer owns shared foundation (`pdf_section_shell`, `pdf_section_visibility`, `pdf_section_registry`)
2. Section builders are split by file across contributors in US1
3. Guard logic hardening is split by section file in US2
4. One contributor finalizes registry orchestration and polish validation

---

## Notes

- All tasks follow required checklist format: `- [ ] T### [P] [US#] Description with file path`
- Story labels appear only in user story phases
- [P] markers are used only for tasks that can run independently in different files
- Hidden-section behavior must remove both section content and spacing artifacts
- Preserve existing layout/typography/spacing and template appearance throughout implementation
