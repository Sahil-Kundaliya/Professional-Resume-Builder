# Implementation Plan: Template Preview Profile Prefill

**Branch**: `007-create-feature-branch` | **Date**: 2026-05-21 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/007-profile-prefill-flow/spec.md`

## Summary

Update the template preview selection flow so tapping "Use this template" conditionally branches based on saved profile availability: skip dialog and continue directly when no usable profile data exists, or show a two-choice dialog when data exists so users can create from scratch or prefill from profile. The implementation stays additive inside existing resume/profile feature boundaries by introducing a profile-to-resume prefill mapping path and a guarded dialog decision step.

## Technical Context

**Language/Version**: Dart `>=3.3.0 <4.0.0`, Flutter SDK from project toolchain

**Primary Dependencies**:
- `flutter_bloc` for resume/profile state workflows
- `freezed_annotation` + generated immutable entities for resume/profile models
- Existing profile repository pipeline via `IProfileRepository` and `ProfileLocalDataSource`
- Existing resume creation flow in `ResumeBloc` (`CreateResume`) and template preview page UI

**Storage**: Local JSON profile persistence through `ProfileLocalDataSource` (`resume_profile.json`)

**Testing**: `flutter_test` for widget and bloc behavior verification (template preview branching + field-level prefill)

**Target Platform**: Flutter multi-platform app (Android/iOS priority)

**Project Type**: Single Flutter application with feature-based module organization

**Performance Goals**:
- No perceptible delay added to "Use this template" tap-to-editor transition when no profile data exists
- Dialog decision flow should complete and navigate in normal interaction time without duplicate event dispatch

**Constraints**:
- Dialog title and action labels must match spec exactly
- Null/empty profile detection must be robust and not block resume creation
- Prefill must be field-by-field and skip only missing fields
- Preserve current template selection and existing resume editor navigation behavior

**Scale/Scope**:
- 1 template preview action path (`TemplatePreviewPage`)
- 1 resume creation decision contract (create new vs prefill)
- 1 profile-to-resume mapping path covering identity, contact, and section collections

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

✅ **Constitution Availability**: PASS
- `.specify/memory/constitution.md` is still a placeholder template with no enforceable principles or gates.

✅ **Architecture Consistency**: PASS
- Planned changes remain inside existing `resume` and `profile` features, reusing current repository/entities.

✅ **Low-Risk Additive Change**: PASS
- Flow update is additive and focused on one button pathway without replacing broader navigation logic.

✅ **Post-Design Re-check**: PASS
- Phase 1 artifacts keep decisions implementation-agnostic, scoped, and aligned with existing module boundaries.

## Project Structure

### Documentation (this feature)

```text
specs/007-profile-prefill-flow/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── template-preview-prefill-flow.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/
├── core/
│   └── constants/
│       └── app_routes.dart
└── features/
    ├── profile/
    │   ├── data/
    │   │   └── datasources/
    │   ├── domain/
    │   │   ├── entities/
    │   │   ├── repositories/
    │   │   └── usecases/
    │   └── presentation/
    │       └── bloc/
    └── resume/
        ├── data/
        │   └── mappers/
        ├── domain/
        │   └── entities/
        └── presentation/
            ├── bloc/
            ├── pages/
            └── widgets/

test/
├── features/
│   ├── profile/
│   └── resume/
└── widget_test.dart
```

**Structure Decision**: Keep the single-project Flutter structure. Implement decision flow changes in `resume/presentation/pages/template_preview_page.dart`, add/extend resume creation and mapping hooks in resume/profile domain boundaries, and validate with targeted tests under `test/features/resume/` plus any required profile mapping coverage.

## Complexity Tracking

No constitution violations or additional complexity exceptions are required.

## Implementation Roadmap

### Phase 0: Research Complete
- Confirm current create flow and prefill touchpoints in `TemplatePreviewPage`, `ResumeBloc`, and profile storage/repository paths.
- Confirm field-level mapping expectations and handling for partial profile data.
- Confirm safe default behavior when profile load fails or returns placeholder-only data.

### Phase 1: Design Complete
- Define entities and validation semantics for profile availability, creation choice, and field-wise prefill result.
- Define UI interaction contract for decision dialog visibility and outcomes.
- Define quickstart execution path for create-new and prefill scenarios, including partial/null fields.
- Update Copilot plan reference to this feature's `plan.md`.

### Phase 2: Implementation Planning Boundary
- `/speckit-tasks` should decompose into: availability detection utility, dialog decision handling, prefill mapping service, resume creation event adjustments, and focused tests for all branching and field-level prefill scenarios.
