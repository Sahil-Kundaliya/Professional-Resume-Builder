# Tasks: Improve Resume Form Validation and Preview Reliability

**Input**: Design documents from `/specs/012-improve-resume-form-flow/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/resume-form-preview-contract.md, quickstart.md

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Add shared, reusable building blocks used by all stories.

- [x] T001 Create reusable feedback message catalog in lib/features/resume/presentation/constants/resume_form_messages.dart
- [x] T002 Create reusable Resume Form Snackbar presenter in lib/features/resume/presentation/widgets/resume_form_feedback.dart
- [x] T003 [P] Create reusable meaningful-content predicates for optional modules in lib/features/resume/presentation/widgets/resume_form_content_predicates.dart

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish validation and rendering infrastructure required before story implementation.

**⚠️ CRITICAL**: No user story work begins until this phase is complete.

- [x] T004 Extend resume preview flow state for feedback and preview-attempt stability in lib/features/resume/presentation/bloc/resume_state.dart
- [x] T005 Add/adjust preview-flow events for validation result and feedback lifecycle in lib/features/resume/presentation/bloc/resume_event.dart
- [x] T006 Refactor preview validation orchestration to emit structured feedback state in lib/features/resume/presentation/bloc/resume_bloc.dart
- [x] T007 [P] Integrate list/text sanitization helpers for render and validation decisions in lib/features/resume/presentation/widgets/resume_form_validators.dart
- [x] T008 [P] Add section render decision adapter using predicates and template visibility in lib/features/resume/presentation/widgets/resume_form_section_support.dart

**Checkpoint**: Shared foundation complete. User stories can proceed.

---

## Phase 3: User Story 1 - Reliable Preview Gate (Priority: P1) 🎯 MVP

**Goal**: Ensure Preview navigation occurs only when form validation passes.

**Independent Test**: Try invalid and valid form states; invalid blocks preview, valid opens preview exactly once.

- [x] T009 [US1] Replace direct Preview navigation with validation-triggered action in lib/features/resume/presentation/pages/resume_form_page.dart
- [x] T010 [US1] Add bloc-listener navigation gate that routes to preview only when validation succeeds in lib/features/resume/presentation/pages/resume_form_page.dart
- [x] T011 [US1] Add duplicate preview tap protection during validation/preview request handling in lib/features/resume/presentation/bloc/resume_bloc.dart
- [x] T012 [US1] Harden required-field checks for placeholders and whitespace-only values in lib/features/resume/presentation/bloc/resume_bloc.dart
- [x] T013 [US1] Align preview-page entry guard with validated form state in lib/features/resume/presentation/pages/pdf_preview_page.dart

**Checkpoint**: Preview flow is reliably gated and independently testable.

---

## Phase 4: User Story 2 - Actionable Error Feedback (Priority: P1)

**Goal**: Provide clear, user-friendly, and actionable Snackbar feedback for all required error paths.

**Independent Test**: Trigger each failure type (missing required, invalid value, preview failure, unexpected error) and verify distinct actionable message.

- [ ] T014 [US2] Map missing-required field set to readable, guided feedback messages in lib/features/resume/presentation/bloc/resume_bloc.dart
- [ ] T015 [US2] Map validation field errors (including invalid email/phone) to guided feedback messages in lib/features/resume/presentation/bloc/resume_bloc.dart
- [ ] T016 [US2] Surface preview-generation failure feedback with retry guidance in lib/features/resume/presentation/pages/pdf_preview_page.dart
- [ ] T017 [US2] Surface unexpected runtime failures through reusable Snackbar presenter in lib/features/resume/presentation/pages/resume_form_page.dart
- [ ] T018 [P] [US2] Wire standardized message catalog into feedback pathways in lib/features/resume/presentation/constants/resume_form_messages.dart

**Checkpoint**: Error feedback is consistent, user-friendly, and independently testable.

---

## Phase 5: User Story 4 - Conditional Resume Sections (Priority: P1)

**Goal**: Remove empty optional sections from preview/PDF output with reusable render logic.

**Independent Test**: Generate preview/PDF with empty optional modules and verify headings/content/spacers are absent.

- [ ] T019 [US4] Apply meaningful-content predicates to section visibility decisions in lib/features/resume/presentation/widgets/resume_form_section_support.dart
- [ ] T020 [US4] Update canvas rendering to omit empty optional modules (skills, education, work experience, hobbies, awards, certifications, references, optional profile blocks) in lib/features/resume/presentation/widgets/resume_canvas.dart
- [ ] T021 [US4] Update PDF rendering to omit empty optional modules and avoid empty spacing artifacts in lib/core/services/pdf_service.dart
- [ ] T022 [US4] Normalize optional module lists before render decisions in lib/features/resume/presentation/widgets/resume_form_validators.dart
- [ ] T023 [US4] Ensure section heading/content/spacing are emitted atomically for optional modules in lib/features/resume/presentation/widgets/resume_canvas.dart

**Checkpoint**: Empty optional content is fully suppressed in render outputs and independently testable.

---

## Phase 6: User Story 3 - Modernized Form Experience (Priority: P2)

**Goal**: Deliver a more modern, readable, and accessible Resume Form UI.

**Independent Test**: Visual/interaction review confirms improved hierarchy, spacing, grouping, readability, and usability.

- [ ] T024 [US3] Redesign Resume Form scaffold, top hierarchy, and preview action placement in lib/features/resume/presentation/pages/resume_form_page.dart
- [ ] T025 [US3] Implement modern spacing scale and section-card grouping on form page in lib/features/resume/presentation/pages/resume_form_page.dart
- [ ] T026 [P] [US3] Improve field accessibility affordances and interaction clarity in lib/features/resume/presentation/pages/resume_form_page.dart
- [ ] T027 [P] [US3] Align basic info section visual rhythm with updated form design in lib/features/resume/presentation/widgets/resume_basic_info_section.dart
- [ ] T028 [P] [US3] Align repeatable list section readability and spacing with updated UX in lib/features/resume/presentation/widgets/resume_repeatable_text_section.dart

**Checkpoint**: UI modernization is complete and independently testable.

---

## Final Phase: Polish & Cross-Cutting Concerns

**Purpose**: Validate regressions and finalize production quality.

- [ ] T029 [P] Add regression tests for preview gating and Snackbar feedback in test/features/resume/resume_form_preview_flow_test.dart
- [ ] T030 [P] Add regression tests for optional section omission in preview/PDF rendering in test/features/resume/resume_optional_section_rendering_test.dart
- [ ] T031 Execute quickstart validation scenarios and record verification notes in specs/012-improve-resume-form-flow/quickstart.md
- [ ] T032 Finalize backward-compatibility cleanup for preview flow state transitions in lib/features/resume/presentation/bloc/resume_bloc.dart

---

## Dependencies & Execution Order

### Phase Dependencies

- Setup (Phase 1): Starts immediately.
- Foundational (Phase 2): Depends on Setup and blocks all user stories.
- User Stories (Phase 3 onward): Start only after Foundational.
- Final Phase: Depends on completion of all targeted user stories.

### User Story Dependencies

- US1 (Reliable Preview Gate): Depends on Phase 2 only.
- US2 (Actionable Error Feedback): Depends on US1 preview gating event flow plus Phase 2 foundation.
- US4 (Conditional Resume Sections): Depends on Phase 2 only; can run in parallel with US2 after US1 kickoff.
- US3 (Modernized Form Experience): Depends on Phase 2 only; scheduled after P1 stories for priority-first delivery.

### Suggested Story Completion Order

1. US1 (P1) - MVP critical path
2. US2 (P1)
3. US4 (P1)
4. US3 (P2)

---

## Parallel Opportunities

- Phase 1: T003 can run in parallel with T001-T002.
- Phase 2: T007 and T008 can run in parallel after T004-T006 interface shape is agreed.
- US2: T018 can run in parallel with T014-T017.
- US3: T026-T028 can run in parallel once T024-T025 establishes base layout.
- Final Phase: T029 and T030 can run in parallel.

---

## Parallel Example: User Story 2

```bash
Task: "T014 [US2] Map missing-required field set to readable, guided feedback messages in lib/features/resume/presentation/bloc/resume_bloc.dart"
Task: "T018 [P] [US2] Wire standardized message catalog into feedback pathways in lib/features/resume/presentation/constants/resume_form_messages.dart"
```

## Parallel Example: User Story 3

```bash
Task: "T026 [P] [US3] Improve field accessibility affordances and interaction clarity in lib/features/resume/presentation/pages/resume_form_page.dart"
Task: "T027 [P] [US3] Align basic info section visual rhythm with updated form design in lib/features/resume/presentation/widgets/resume_basic_info_section.dart"
Task: "T028 [P] [US3] Align repeatable list section readability and spacing with updated UX in lib/features/resume/presentation/widgets/resume_repeatable_text_section.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1)

1. Complete Phase 1 and Phase 2.
2. Complete Phase 3 (US1).
3. Validate preview gate behavior before expanding scope.

### Incremental Delivery

1. Deliver US1 for reliable preview gating.
2. Add US2 for robust feedback messaging.
3. Add US4 for conditional section rendering.
4. Add US3 for UX modernization.
5. Run final regression and quickstart validation.

### Quality Guardrails

- Keep all changes isolated to Resume Form and Preview flow.
- Preserve architecture and backward compatibility.
- Reuse predicates and feedback helpers across canvas/PDF/form paths.
