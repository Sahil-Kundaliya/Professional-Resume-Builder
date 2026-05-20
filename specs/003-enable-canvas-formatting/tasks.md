# Tasks: Enable Resume Canvas Formatting

**Input**: Design documents from `/specs/003-enable-canvas-formatting/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Tests are not explicitly requested in the specification, so this task list prioritizes implementation and focused manual validation for each user story.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- Flutter application code lives under `lib/`
- Resume feature code lives under `lib/features/resume/`
- Feature planning artifacts live under `specs/003-enable-canvas-formatting/`

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare shared editor inputs and reusable formatting definitions used across all stories

- [x] T001 Consolidate supported font and color option definitions in lib/features/resume/presentation/widgets/formatting_toolbar.dart
- [x] T002 [P] Add reusable header field identifiers and formatting helper scaffolding in lib/features/resume/presentation/widgets/resume_canvas.dart and lib/features/resume/presentation/pages/resume_editor_page.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core document, mapper, and bloc infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T003 Create persisted header style entities and snapshot models in lib/features/resume/domain/entities/resume_document.dart
- [x] T004 [P] Extend resume DTOs to carry header formatting properties in lib/features/resume/data/models/resume_document_model.dart
- [x] T005 [P] Map persisted header formatting between DTO and domain models in lib/features/resume/data/mappers/resume_document_mapper.dart
- [x] T006 Add selection-aware formatting events and loaded-state history support in lib/features/resume/presentation/bloc/resume_event.dart and lib/features/resume/presentation/bloc/resume_state.dart
- [x] T007 Implement header formatting mutations, undo/redo history, and guarded unsupported-selection handling in lib/features/resume/presentation/bloc/resume_bloc.dart
- [x] T008 Regenerate Freezed/JSON outputs for lib/features/resume/domain/entities/resume_document.dart, lib/features/resume/data/models/resume_document_model.dart, lib/features/resume/presentation/bloc/resume_event.dart, and lib/features/resume/presentation/bloc/resume_state.dart

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Format Selected Resume Text (Priority: P1) 🎯 MVP

**Goal**: Let users select full name, job title, or summary and immediately apply toolbar formatting on the resume canvas

**Independent Test**: Select each supported header field in the editor, apply bold, italic, underline, font family, and text color changes from the toolbar, and confirm the selected field updates immediately without affecting unsupported canvas items.

### Implementation for User Story 1

- [x] T009 [US1] Replace page-local toolbar state with bloc-driven toolbar bindings in lib/features/resume/presentation/pages/resume_editor_page.dart
- [x] T010 [US1] Update supported editable header fields to publish selection and text changes through the formatting-aware document flow in lib/features/resume/presentation/widgets/resume_canvas.dart
- [x] T011 [US1] Implement active toolbar actions for bold, italic, underline, font family, and text color in lib/features/resume/presentation/widgets/formatting_toolbar.dart
- [x] T012 [US1] Merge persisted formatting overrides with base header text styles and disable unsupported formatting targets in lib/features/resume/presentation/widgets/resume_canvas.dart

**Checkpoint**: User Story 1 should now provide immediate formatting feedback for the selected supported field

---

## Phase 4: User Story 2 - Preserve Element-Specific Formatting (Priority: P2)

**Goal**: Keep formatting isolated per supported header field and preserve styling in preview/export flows while leaving profile image uploads intact

**Independent Test**: Apply different styles to full name, job title, and summary, switch selection between them, confirm the toolbar reflects the selected field's stored state, verify profile image upload still works, and confirm preview/export use the saved styling values.

### Implementation for User Story 2

- [x] T013 [US2] Persist independent header style values when full name, job title, and summary are edited in lib/features/resume/presentation/bloc/resume_bloc.dart and lib/features/resume/domain/entities/resume_document.dart
- [x] T014 [P] [US2] Preserve and render stored header formatting through preview/export document flow in lib/features/resume/presentation/pages/template_preview_page.dart, lib/features/resume/presentation/pages/pdf_preview_page.dart, and lib/features/resume/presentation/widgets/resume_canvas.dart
- [ ] T015 [P] [US2] Keep local save/update behavior compatible with persisted formatting in lib/features/resume/data/repositories/resume_repository_impl.dart and lib/features/resume/data/datasources/resume_local_datasource_impl.dart
- [x] T016 [US2] Verify profile image gallery upload remains unaffected by formatting selection rules in lib/features/resume/presentation/widgets/resume_canvas.dart

**Checkpoint**: User Stories 1 and 2 should both work independently, with per-field persistence and unaffected image upload behavior

---

## Phase 5: User Story 3 - Reverse and Reapply Formatting Changes (Priority: P3)

**Goal**: Support predictable undo and redo for supported header text styling changes

**Independent Test**: Apply multiple supported formatting changes, use undo to step backward through prior states, use redo to reapply them, and confirm only supported header edits participate in history.

### Implementation for User Story 3

- [x] T017 [US3] Connect toolbar undo and redo controls to header edit history state in lib/features/resume/presentation/pages/resume_editor_page.dart and lib/features/resume/presentation/widgets/formatting_toolbar.dart
- [x] T018 [US3] Finalize reversible header snapshot transitions and redo-stack reset rules in lib/features/resume/presentation/bloc/resume_bloc.dart
- [x] T019 [US3] Reflect undo/redo availability and restored field styling in lib/features/resume/presentation/bloc/resume_state.dart and lib/features/resume/presentation/widgets/resume_canvas.dart

**Checkpoint**: All user stories should now be independently functional

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Harden the feature for maintainability, future template support, and release readiness

- [x] T020 [P] Document formatting behavior, supported fields, and validation flow in specs/003-enable-canvas-formatting/quickstart.md
- [x] T021 Refactor shared font/style resolution for future template reuse in lib/features/resume/presentation/widgets/resume_canvas.dart and lib/features/resume/presentation/widgets/formatting_toolbar.dart
- [ ] T022 Run manual quickstart validation for editor, preview, export, undo/redo, and profile image compatibility using specs/003-enable-canvas-formatting/quickstart.md

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Story 1 (Phase 3)**: Depends on Foundational completion
- **User Story 2 (Phase 4)**: Depends on Foundational completion and builds on the formatting pipeline from User Story 1
- **User Story 3 (Phase 5)**: Depends on Foundational completion and the header-edit mutation pipeline established in User Story 1
- **Polish (Phase 6)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational - establishes selectable formatting behavior and immediate canvas updates
- **User Story 2 (P2)**: Depends on User Story 1 interaction plumbing but remains independently testable as persistence and preview compatibility work
- **User Story 3 (P3)**: Depends on User Story 1 mutation flow and Foundational history structures, but remains independently testable once enabled

### Within Each User Story

- Shared document and bloc models must be complete before UI wiring
- Toolbar bindings should be connected before canvas rendering refinements are validated
- Persistence and preview compatibility should be validated after field-specific formatting is working in the editor
- Undo/redo availability should be validated after history transitions are finalized

### Parallel Opportunities

- `T002` can run in parallel with `T001` once supported toolbar options are known
- `T004` and `T005` can run in parallel after `T003`
- `T014` and `T015` can run in parallel once User Story 1 formatting data is flowing through the document
- `T020` can run in parallel with final code cleanup once behavior is stable

---

## Parallel Example: User Story 2

```bash
Task: "Persist and render stored header formatting through preview/export document flow in lib/features/resume/presentation/pages/template_preview_page.dart, lib/features/resume/presentation/pages/pdf_preview_page.dart, and lib/features/resume/presentation/widgets/resume_canvas.dart"
Task: "Keep local save/update behavior compatible with persisted formatting in lib/features/resume/data/repositories/resume_repository_impl.dart and lib/features/resume/data/datasources/resume_local_datasource_impl.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Confirm immediate selection-based formatting works for full name, job title, and summary inside the canvas

### Incremental Delivery

1. Finish Setup + Foundational to establish persisted formatting and history infrastructure
2. Deliver User Story 1 for immediate formatting behavior in the editor
3. Deliver User Story 2 for independent per-field persistence, preview/export compatibility, and profile image safety
4. Deliver User Story 3 for reversible editing with undo and redo
5. Complete Polish tasks for future template scalability and release confidence

### Parallel Team Strategy

1. One developer completes Setup + Foundational tasks
2. After the foundation is ready:
   - Developer A: User Story 1 UI wiring and canvas updates
   - Developer B: User Story 2 persistence and preview/export compatibility
   - Developer C: User Story 3 undo/redo behavior and final toolbar state polish

---

## Notes

- All tasks follow the required checklist format with task ID, optional parallel marker, optional story label, and exact file paths
- User stories remain traceable to the spec priorities `US1`, `US2`, and `US3`
- The task list keeps profile image upload support in scope only for regression protection, not for new formatting behavior
- Future template scalability is addressed through reusable style resolution and persisted field-specific formatting state