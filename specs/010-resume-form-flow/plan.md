# Implementation Plan: Replace Resume Canvas with Form Flow

**Branch**: `010-resume-form-flow` | **Date**: 2026-05-27 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/010-resume-form-flow/spec.md`

**Note**: This plan replaces the current inline canvas-editing creation path with a dedicated resume form flow while preserving template discovery, template preview, render output, and the existing local resume persistence seam.

## Summary

Implement a production-grade resume creation workflow that changes the current navigation from Template -> Preview -> Canvas Edit into Template -> Preview -> Resume Form -> Preview -> Generate. The implementation keeps `ResumeDocument` as the canonical render payload for template preview and PDF generation, introduces a dedicated form page with reusable section widgets and structured bottom-sheet editors, simplifies `ResumeBloc` away from canvas-selection concerns, and removes obsolete canvas-editing behavior that is no longer part of the creation experience.

## Technical Context

**Language/Version**: Dart `>=3.3.0 <4.0.0`, Flutter SDK from the project toolchain

**Primary Dependencies**:
- `flutter_bloc` for resume creation state and preview handoff
- `get_it` for feature dependency registration and cross-feature services
- `freezed_annotation`/`freezed` for immutable resume entities and bloc state/events
- `google_fonts` for consistent page and section typography
- `image_picker` for profile image selection inside the resume form
- `printing` plus the existing PDF generator for preview/generate behavior

**Storage**: Existing local resume persistence through `IResumeRepository` and the resume local datasource, with optional profile-prefill input through `IProfilePrefillRepository`

**Testing**: `flutter_test` widget, bloc, and mapper coverage focused on route flow, form updates, dynamic list handling, bottom-sheet validation, preview rendering, and cleanup regressions

**Target Platform**: Flutter mobile-first application targeting Android, iOS, web, macOS, Linux, and Windows; the primary UX expectation for this feature is mobile form entry with bottom-sheet record editors

**Project Type**: Single Flutter application with feature-based organization under `lib/features/`

**Performance Goals**: Template preview should continue to open within standard page-transition expectations; resume form updates should feel immediate while typing; bottom-sheet open/save actions should complete without visible lag; preview generation should continue to render the latest draft on first attempt during normal manual testing

**Constraints**:
- Preserve the current template list and template preview entry points
- Keep template-specific rendering based on the existing `ResumeCanvas` and PDF generation path
- Reuse current local resume persistence and profile-prefill seams instead of introducing new storage infrastructure
- Remove or retire canvas-only editing state, actions, and formatting controls when they are no longer used by the creation flow
- Keep feature ownership inside `lib/features/resume/`, with reuse from `lib/features/profile/` limited to existing shared interaction patterns or explicit mapping boundaries

**Scale/Scope**:
- 1 navigation-flow replacement from editor route to form route
- 1 dedicated resume form page with reusable section components
- 2 structured bottom-sheet record editors for work experience and education
- 5 lightweight repeatable section editors for skills, hobbies, awards, certifications, and references
- 1 preview handoff path that maps current form state into template rendering and generation
- 1 cleanup pass over canvas-specific presentation logic, selection state, and obsolete editor helpers

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

✅ **Project Constitution Availability**: PASS
- `.specify/memory/constitution.md` remains an unfilled template, so there are no ratified project-specific gates to enforce beyond local repository standards.

✅ **Feature Boundary Alignment**: PASS
- The work stays inside the `resume` feature plus narrow route registration updates in app-level composition files. Reuse from the `profile` feature is limited to proven widget patterns and existing prefill services.

✅ **Template Rendering Preservation**: PASS
- The design preserves template registry, non-editable template preview, `ResumeCanvas` rendering, and PDF generation as downstream consumers of resume data instead of rewriting rendering logic.

✅ **Cleanup Scope Control**: PASS
- The cleanup target is limited to obsolete editor-only behavior such as selected-field state, formatting toolbar dependencies, and inline canvas mutation paths that conflict with the new form-driven workflow.

✅ **Post-Design Re-check**: PASS
- Phase 1 artifacts keep the canonical resume render model intact, isolate form-specific state in the presentation layer, and document removal boundaries for canvas-editing behavior without expanding scope into unrelated features.

## Project Structure

### Documentation (this feature)

```text
specs/010-resume-form-flow/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── resume-form-flow.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/
├── app.dart
├── core/
│   └── constants/
│       └── app_routes.dart
├── config/
│   └── di/
│       └── injection_container.dart
└── features/
    ├── profile/
    │   ├── domain/
    │   │   └── entities/
    │   └── presentation/
    │       ├── pages/
    │       │   └── edit_profile_page.dart
    │       └── widgets/
    │           ├── education_bottom_sheet.dart
    │           ├── experience_bottom_sheet.dart
    │           ├── skill_bottom_sheet.dart
    │           └── profile_section_*.dart
    └── resume/
        ├── data/
        │   ├── datasources/
        │   ├── mappers/
        │   └── repositories/
        ├── domain/
        │   ├── entities/
        │   │   ├── resume_document.dart
        │   │   └── resume_template.dart
        │   ├── repositories/
        │   └── services/
        ├── presentation/
        │   ├── bloc/
        │   │   ├── resume_bloc.dart
        │   │   ├── resume_event.dart
        │   │   └── resume_state.dart
        │   ├── pages/
        │   │   ├── pdf_preview_page.dart
        │   │   ├── resume_editor_page.dart
        │   │   └── template_preview_page.dart
        │   └── widgets/
        │       ├── formatting_toolbar.dart
        │       ├── resume_canvas.dart
        │       ├── resume_canvas_edit_actions.dart
        │       └── resume_canvas_section_keys.dart
        └── resume_injection.dart

test/
├── features/
│   └── resume/
└── widget_test.dart
```

**Structure Decision**: This remains a single Flutter app with feature-local data/domain/presentation layers. The implementation should add the new form flow inside `lib/features/resume/presentation/`, preserve current repository and mapper seams in `lib/features/resume/data/` and `lib/features/resume/domain/`, reuse proven profile-form interaction patterns without moving ownership out of the resume feature, and keep app-level changes narrowly scoped to routing and dependency registration.

## Complexity Tracking

No constitution violations or justified exceptions are required for this feature.

## Implementation Roadmap

### Phase 0: Research Complete
- Keep `ResumeDocument` as the canonical resume rendering payload so template preview and PDF generation continue to work without a renderer rewrite.
- Introduce a dedicated form-driven resume creation page instead of mutating the existing inline canvas editor.
- Reuse proven bottom-sheet and repeatable-section interaction patterns from the `profile` feature to accelerate implementation and reduce UX inconsistency.
- Simplify `ResumeBloc` by prioritizing field- and section-level updates over whole-document canvas replacement and selected-field formatting behavior.
- Remove or retire obsolete canvas-editing code only after the new form and preview path fully cover the creation flow.

### Phase 1: Design Complete
- Model the form draft, repeatable section entries, validation rules, and mapping path into `ResumeDocument`.
- Define the user-facing flow contract for template selection, form editing, preview, and cleanup boundaries.
- Document quickstart validation for route replacement, dynamic section management, preview accuracy, and non-regression of template rendering.
- Update the Copilot agent context to point to this plan for downstream task generation.

### Phase 2: Implementation Planning Boundary
- `/speckit-tasks` should break the work into route and page replacement, bloc/state simplification, form section components, structured bottom-sheet editors, preview integration, canvas cleanup, and focused regression coverage.
