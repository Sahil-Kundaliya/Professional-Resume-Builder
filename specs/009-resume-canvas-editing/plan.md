# Implementation Plan: Improve Resume Canvas Editing

**Branch**: `009-create-new-spec` | **Date**: 2026-05-26 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/009-resume-canvas-editing/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

Implement production-grade Resume Canvas editing controls in the existing editor architecture by adding protected conditional deletion, section visibility toggles, editable section titles, and profile image editing (crop, reposition, centering, preview). The approach extends canvas-local editing contracts and `ResumeDocument` editing state while keeping all behavior scoped to the Resume feature and avoiding changes to template creation flow or unrelated modules.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Dart 3.3+ with Flutter (project SDK `>=3.3.0 <4.0.0`)

**Primary Dependencies**: `flutter`, `flutter_bloc`, `freezed_annotation`, `google_fonts`, `image_picker` (existing), image editing dependency to be introduced for crop/reposition/preview flow

**Storage**: In-memory `ResumeDocument` during editing, persisted through existing `IResumeRepository` save flow

**Testing**: `flutter_test` widget/unit tests for canvas deletion rules, visibility rendering, title override behavior, and image edit apply/cancel behavior

**Target Platform**: Flutter mobile platforms (Android/iOS) and existing project-supported desktop/web preview targets

**Project Type**: Mobile app feature module within a single Flutter application

**Performance Goals**: Canvas interactions remain responsive with near-instant feedback for select/delete/hide/title-edit and no visible stutter during image preview operations

**Constraints**: Changes isolated to Resume Canvas and resume feature internals; no template flow changes; protected mandatory fields remain undeletable and always visible; hidden module restore must preserve prior content

**Scale/Scope**: Single resume editor screen and related resume feature entities/widgets/events supporting 8 section modules and list-based item deletion semantics

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Constitution file at `.specify/memory/constitution.md` is currently a placeholder template with no enforceable named principles.
- Gate status (pre-research): PASS with documented fallback checks.
- Fallback Gate 1: Scope isolation to Resume Canvas and resume feature modules only. PASS.
- Fallback Gate 2: No unrelated architectural flow changes (especially template flow). PASS.
- Fallback Gate 3: Data integrity protection for mandatory header fields and recoverable hidden modules. PASS.
- Post-design re-check: PASS. Planned data model and contracts preserve existing editor architecture and keep all new behavior inside resume feature boundaries.

## Project Structure

### Documentation (this feature)

```text
specs/009-resume-canvas-editing/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
lib/
├── features/
│   └── resume/
│       ├── domain/
│       │   └── entities/
│       │       └── resume_document.dart
│       ├── presentation/
│       │   ├── bloc/
│       │   │   ├── resume_bloc.dart
│       │   │   ├── resume_event.dart
│       │   │   └── resume_state.dart
│       │   ├── pages/
│       │   │   └── resume_editor_page.dart
│       │   └── widgets/
│       │       └── resume_canvas.dart
│       └── data/
│           └── repositories/
└── shared/

test/
├── widget_test.dart
└── features/
  └── resume/
    └── presentation/
      └── (new canvas behavior tests)
```

**Structure Decision**: Use the existing single Flutter app feature architecture. All implementation work remains in `lib/features/resume/**` with focus on `presentation/widgets/resume_canvas.dart` and minimal required resume feature data/state extensions to persist visibility/title/image edit state.

## Complexity Tracking

No constitution violations requiring exception tracking.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
