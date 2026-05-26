# Implementation Plan: Resume Editor Interaction Improvements

**Branch**: `008-run-before-specify` | **Date**: 2026-05-25 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/008-resume-editor-interactions/spec.md`

## Summary

Implement focused usability and formatting upgrades inside the Resume Editor module only: keyboard dismissal on outside tap, bounded text size controls, action cleanup (remove green expand and make delete clear text only), editable skills rating within 0-5 with five-star display, AppBar save button removal, and expansion of existing formatting behavior (bold/italic/underline/font family/current style options) from header-only fields to all editable resume text fields while preserving current architecture, save flow, undo/redo behavior, template rendering, and profile prefill compatibility.

## Technical Context

**Language/Version**: Dart `>=3.3.0 <4.0.0`, Flutter (project toolchain)

**Primary Dependencies**:
- `flutter_bloc` for editor state and field selection events
- `freezed_annotation` + generated entities/events/state
- `google_fonts` for font-family rendering in formatting behavior
- Existing resume module widgets: `ResumeEditorPage`, `ResumeCanvas`, `FormattingToolbar`

**Storage**: Existing local resume persistence through `IResumeRepository` (no storage model changes)

**Testing**: `flutter_test` widget/bloc tests plus targeted regression checks in resume feature tests

**Target Platform**: Flutter multi-platform app (Android/iOS priority, shared behavior)

**Project Type**: Single Flutter mobile application using feature-based module boundaries

**Performance Goals**:
- No noticeable slowdown in typing, selection, and toolbar interaction latency
- No additional navigation or render regressions in editor preview/canvas interactions

**Constraints**:
- Limit all code changes to resume editor module paths under `lib/features/resume/`
- Preserve existing data schema, save/autosave behavior, and current navigation/storage/template flows
- Maintain backward compatibility with existing document and style data

**Scale/Scope**:
- 1 editor page (`resume_editor_page.dart`)
- 1 canvas/editor widget (`resume_canvas.dart`) with all editable field families
- 1 toolbar widget (`formatting_toolbar.dart`) and corresponding resume bloc style handling
- Focused regression checks for undo/redo, template rendering, preview generation, and profile prefill compatibility

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

✅ **Constitution Availability**: PASS
- `.specify/memory/constitution.md` remains a placeholder template with no enforceable hard gates.

✅ **Scope Isolation**: PASS
- Spec explicitly bounds changes to Resume Editor module; no cross-module refactor required.

✅ **Backward Compatibility**: PASS
- Plan keeps current architecture and event flow, extending behavior without replacing persistence/navigation contracts.

✅ **Post-Design Re-check**: PASS
- Phase 1 artifacts keep compatibility and module isolation explicit (no unresolved clarifications).

## Project Structure

### Documentation (this feature)

```text
specs/008-resume-editor-interactions/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── resume-editor-interaction-contract.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/
├── app/
├── core/
└── features/
    ├── profile/
    └── resume/
        ├── data/
        ├── domain/
        │   └── entities/
        └── presentation/
            ├── bloc/
            ├── pages/
            └── widgets/

test/
└── features/
    └── resume/
```

**Structure Decision**: Keep the existing Flutter feature architecture. Implement interaction and formatting expansions only in Resume Editor presentation/domain touchpoints under `lib/features/resume/` and verify with targeted resume feature tests under `test/features/resume/`.

## Complexity Tracking

No constitution violations or complexity exceptions are required.

## Implementation Roadmap

### Phase 0: Research Complete
- Validate current editor selection model: `selectedFieldId` is toolbar-enablement gate and currently header-only formatting support.
- Confirm current behavior gaps:
  - AppBar currently includes Save button.
  - Outside tap clears selection but does not explicitly dismiss keyboard focus.
  - Editable field selected actions include green expand icon and delete deselect behavior.
  - Skills rating currently renders 7 dots with no direct editing controls.
- Identify safe extension strategy that keeps existing undo/redo and document update events backward compatible.

### Phase 1: Design Complete
- Define editor interaction contract for keyboard dismissal, field delete semantics, and selection behavior.
- Define style-state extension model to support all editable fields while preserving existing header style compatibility.
- Define skill rating constraints and rendering contract (0-5 inclusive, five-star visualization/editing).
- Define quickstart validation path covering unaffected flows: canvas editing, template rendering, preview generation, undo/redo, profile prefill.
- Update Copilot context pointer to this feature plan.

### Phase 2: Implementation Planning Boundary
- `/speckit-tasks` should decompose into:
  - editor page interaction shell updates (outside-tap keyboard dismissal + AppBar action cleanup)
  - canvas action cleanup (remove expand; delete clears text only)
  - generic formatting capability expansion for all editable field IDs
  - text size controls with bounded updates and invalid-value blocking
  - skill rating UI/control correction (editable 0-5, five stars)
  - focused regression and compatibility tests scoped to Resume Editor module only
