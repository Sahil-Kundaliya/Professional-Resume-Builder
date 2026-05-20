# Implementation Plan: Enable Resume Canvas Formatting

**Branch**: `003-enable-canvas-formatting` | **Date**: 2026-05-20 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/003-enable-canvas-formatting/spec.md`

**Note**: This plan grounds the existing resume editor toolbar in `ResumeBloc` so header text styling is selectable, immediately visible on the canvas, preserved in preview rendering, and reversible through undo and redo.

## Summary

Implement end-to-end formatting behavior for the resume canvas header fields: full name, job position, and summary. The work will move toolbar state out of `ResumeEditorPage` local variables and into `ResumeBloc`, persist per-field formatting on `ResumeDocument`, update `ResumeCanvas` to render merged text styles for the selected fields, and add a header-scoped undo/redo history so changes remain immediate, isolated, and preview-safe while profile image upload continues unchanged.

## Technical Context

**Language/Version**: Dart `>=3.3.0 <4.0.0`, Flutter SDK from the project toolchain

**Primary Dependencies**:
- `flutter_bloc` for editor state and toolbar synchronization
- `freezed_annotation` and `freezed` for immutable entities, events, and states
- `google_fonts` for resolving selectable font families into renderable text styles
- `image_picker` for existing profile image selection, which remains in scope only for compatibility
- `printing` and `pdf` for resume preview/export paths that must preserve selected styling

**Storage**: In-memory local datasource and repository flow already present for resume documents; no new external persistence layer is required in this feature

**Testing**: `flutter_test` for widget and bloc-oriented editor interaction coverage; targeted regression checks for preview rendering and editor state transitions

**Target Platform**: Flutter application with existing Android, iOS, web, macOS, Linux, and Windows targets; this feature primarily affects shared presentation logic in the resume editor and preview flow

**Project Type**: Single Flutter application with feature-first architecture under `lib/features/`

**Performance Goals**: Selected formatting changes should repaint the targeted header field within the normal interaction frame budget and remain visually reflected in preview rendering without perceptible delay

**Constraints**:
- Preserve the current template preview to editor navigation flow
- Keep profile image gallery upload behavior unchanged
- Apply toolbar actions only to `fullName`, `jobPosition`, and `careerGoals`
- Keep field-specific formatting independent so switching selection does not overwrite another field's style
- Ensure undo and redo affect only supported header editing changes, not unrelated resume actions

**Scale/Scope**:
- 1 editor page (`resume_editor_page.dart`)
- 1 toolbar widget (`formatting_toolbar.dart`)
- 1 canvas renderer with editable header fields (`resume_canvas.dart`)
- 1 bloc/event/state slice (`resume_bloc.dart`, `resume_event.dart`, `resume_state.dart`)
- 1 domain document plus mapper/dto chain that must carry new style metadata through preview and save paths

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

✅ **Project Constitution Availability**: PASS
- `.specify/memory/constitution.md` is still an unfilled template, so there are no ratified project-specific gates to violate.

✅ **Repository Architecture Conventions**: PASS
- Planned changes stay inside `lib/features/resume/` and align with the repository memory guidance for feature-first Flutter structure.

✅ **Design Scope Control**: PASS
- The plan limits behavioral changes to toolbar-driven styling for three existing header fields and preserves unrelated editor capabilities.

✅ **Post-Design Re-check**: PASS
- Phase 1 artifacts keep the same scope boundaries, avoid new cross-feature coupling, and require no constitution exceptions.

## Project Structure

### Documentation (this feature)

```text
specs/003-enable-canvas-formatting/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── resume-canvas-formatting.md
├── checklists/
│   └── requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/
├── app.dart
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── home/
│   └── resume/
│       ├── data/
│       │   ├── datasources/
│       │   ├── mappers/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   └── repositories/
│       └── presentation/
│           ├── bloc/
│           ├── pages/
│           └── widgets/
└── main.dart

test/
└── widget_test.dart
```

**Structure Decision**: This is a single Flutter application. The implementation will remain inside the existing `resume` feature boundaries, with domain styling models added to `lib/features/resume/domain/entities/`, editor behavior coordinated in `lib/features/resume/presentation/bloc/`, and rendering updates applied in `lib/features/resume/presentation/pages/` and `lib/features/resume/presentation/widgets/`.

## Complexity Tracking

No constitution violations or justified exceptions are required for this feature.

## Implementation Roadmap

### Phase 0: Research Complete
- Choose a typed per-field style model instead of page-local booleans
- Scope undo/redo to supported header fields only
- Keep toolbar state derived from bloc selection rather than duplicated in the page

### Phase 1: Design Complete
- Extend the resume document model to carry persisted styling for `fullName`, `jobPosition`, and `careerGoals`
- Define bloc events for style mutations, selection-aware toolbar state, and reversible history actions
- Document the editor interaction contract and implementation quickstart for the next task-generation step

### Phase 2: Implementation Planning Boundary
- `/speckit-tasks` should break the work into entity/model updates, bloc wiring, canvas rendering changes, toolbar interaction updates, and focused test coverage
