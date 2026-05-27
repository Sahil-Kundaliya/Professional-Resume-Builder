# Implementation Plan: Improve Resume Form Validation and Preview Reliability

**Branch**: `012-create-speckit-spec` | **Date**: 2026-05-27 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/012-improve-resume-form-flow/spec.md`

## Summary

Implement production-grade fixes and UX improvements in the Resume Form module by correcting preview validation gating, adding reusable and user-friendly Snackbar error feedback, modernizing `resume_form_page.dart` layout and accessibility, and introducing reusable conditional rendering rules so empty optional sections are removed from preview/PDF output without affecting existing architecture.

## Technical Context

**Language/Version**: Dart `>=3.3.0 <4.0.0` with current Flutter SDK

**Primary Dependencies**:
- `flutter_bloc` for form state, validation state, and preview eligibility
- `google_fonts` for current typography and visual hierarchy
- `image_picker` for profile image selection
- `pdf` and `printing` for preview output generation
- `freezed`/`freezed_annotation` for immutable state/entity modeling

**Storage**: Existing local repository/data source path through `IResumeRepository` (no new storage introduced)

**Testing**: `flutter_test` for widget/bloc/regression tests in resume feature scope

**Target Platform**: Flutter multi-platform app with mobile-first form interaction expectations

**Project Type**: Single Flutter application with feature-based architecture

**Performance Goals**:
- Preview button interaction remains responsive with no duplicate navigation on rapid taps
- Validation feedback appears immediately after preview attempt when invalid
- Preview generation failures surface user feedback without app crash

**Constraints**:
- Preserve existing architecture boundaries and DI setup
- Limit changes to Resume Form module and dependent rendering behavior
- Keep behavior reusable and scalable for optional section rendering rules
- Avoid unrelated changes outside requested scope

**Scale/Scope**:
- 1 primary page redesign: `lib/features/resume/presentation/pages/resume_form_page.dart`
- 1 validation flow hardening path in `resume_bloc.dart` and related state/event handling
- 1 reusable user feedback path for validation/system errors
- 1 reusable conditional rendering rule path for optional sections in preview/PDF rendering
- Focused tests under resume feature

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

✅ **Constitution Status**: PASS
- `.specify/memory/constitution.md` currently contains placeholder template content with no enforceable ratified principles.

✅ **Architecture Preservation Gate**: PASS
- Plan keeps feature-layer boundaries under `lib/features/resume/` and reuses existing repository/service flows.

✅ **Scope Isolation Gate**: PASS
- Work is constrained to resume form validation, feedback UX, and optional section rendering behavior.

✅ **Post-Design Re-check**: PASS
- Phase 1 artifacts keep contracts internal to resume module and avoid cross-feature coupling.

## Project Structure

### Documentation (this feature)

```text
specs/012-improve-resume-form-flow/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── resume-form-preview-contract.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/
├── app.dart
├── core/
│   ├── constants/
│   └── services/
│       └── pdf_service.dart
└── features/
    └── resume/
        ├── data/
        ├── domain/
        │   └── entities/
        │       ├── resume_document.dart
        │       └── template_field_configuration.dart
        └── presentation/
            ├── bloc/
            │   ├── resume_bloc.dart
            │   ├── resume_event.dart
            │   └── resume_state.dart
            ├── pages/
            │   ├── resume_form_page.dart
            │   └── pdf_preview_page.dart
            └── widgets/
                ├── resume_form_section_support.dart
                └── resume_form_validators.dart

test/
├── features/
│   └── resume/
└── widget_test.dart
```

**Structure Decision**: Keep the current single-project Flutter structure and implement all behavior/UI updates inside existing resume presentation and rendering seams.

## Complexity Tracking

No constitution violations or exceptional complexity waivers are required.

## Implementation Roadmap

### Phase 0: Research Complete
- Confirmed navigation must be state-driven: preview route transition only after validation pass.
- Confirmed error feedback should separate validation failures from system failures, each with user-action guidance.
- Confirmed conditional rendering should use reusable meaningful-content predicates and atomic section rendering to prevent empty headers and spacing.

### Phase 1: Design Complete
- Defined data/state model for validation result, feedback message payload, preview eligibility, and preview attempt lifecycle.
- Defined internal behavioral contract for form-to-bloc preview action, failure messaging, and optional section visibility.
- Defined quickstart verification scenarios for validation gating, Snackbar messaging, UI refresh, and empty-section omission.
- Updated agent context marker in `.github/copilot-instructions.md` to this plan file.

### Phase 2: Implementation Planning Boundary
- `/speckit-tasks` should break down work into:
  1. Validation gating fix in form preview action flow
  2. Reusable Snackbar feedback integration for validation and system errors
  3. Resume form UI modernization in target page and supporting widgets
  4. Reusable conditional rendering filters for optional sections (including work experience, education, skills, hobbies, awards, certifications, references)
  5. Regression and acceptance test coverage for preview reliability and hidden-section behavior
