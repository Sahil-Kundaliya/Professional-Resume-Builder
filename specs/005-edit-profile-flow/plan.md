# Implementation Plan: Edit Profile Flow

**Branch**: `005-edit-profile-flow` | **Date**: 2026-05-21 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/005-edit-profile-flow/spec.md`

**Note**: This plan turns the current placeholder Profile tab into a data-backed summary plus full edit flow, while keeping the profile aggregate reusable for later resume-prefill and other profile consumers.

## Summary

Implement a complete Profile editing flow by replacing the placeholder Profile page with saved-profile rendering, adding an Edit Profile route with validated basic details and dynamic sections, persisting the reusable profile locally, and structuring the profile aggregate so it can scale into future resume-prefill and profile-driven features without reshaping the domain again.

## Technical Context

**Language/Version**: Dart `>=3.3.0 <4.0.0`, Flutter SDK from the project toolchain

**Primary Dependencies**:
- `flutter_bloc` for profile summary and edit state management consistent with the existing resume flow
- `get_it` for feature dependency registration in the current DI container
- `freezed_annotation`, `freezed`, and `json_serializable` for immutable profile entities and storage models
- `image_picker` for gallery-based profile image selection
- `path_provider` for locating app-local storage paths for persisted profile data and copied images
- `google_fonts` for visual consistency with the current app UI

**Storage**: Local file-backed persistence for one reusable profile record, including app-local image path storage and ordered repeated sections

**Testing**: `flutter_test` for widget tests, validation coverage, mapper/repository tests, and focused page-flow verification around profile summary, edit forms, and bottom-sheet entry flows

**Target Platform**: Flutter mobile-first application targeting Android, iOS, web, macOS, Linux, and Windows; the primary UX expectations for this feature are mobile form entry and bottom-sheet interactions

**Project Type**: Single Flutter application with feature-based organization under `lib/features/`

**Performance Goals**: Opening the Edit Profile page, launching experience or education bottom sheets, and saving or reloading a single local profile should complete within normal page-transition expectations and feel immediate during manual testing

**Constraints**:
- Preserve the existing Home, template preview, and resume editor flows while expanding only the Profile module in this phase
- Keep the reusable profile aggregate isolated inside the `profile` feature and expose cross-feature reuse through explicit mapping or repository boundaries
- Allow partial profile completion overall, while enforcing complete required fields inside work experience and education records before those records can be saved
- Prevent future birth dates, validate email and phone input, and preserve user-entered values when validation fails
- Support ordered, repeatable sections for skills, hobbies, experience, education, awards, and certifications without hard-coding a fixed maximum count

**Scale/Scope**:
- 1 profile summary page upgrade from placeholder to data-backed rendering
- 1 new Edit Profile page with full-form save behavior
- 2 structured bottom-sheet editors for experience and education
- 6 repeatable profile section types in the reusable profile aggregate
- 1 local persistence path for a single reusable profile and associated image asset reference

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

✅ **Project Constitution Availability**: PASS
- `.specify/memory/constitution.md` remains an unfilled template, so there are no ratified project-specific gates to violate.

✅ **Feature Boundary Alignment**: PASS
- The design keeps the new work within the existing `profile` feature and app-level routing/DI surfaces, rather than leaking profile editing logic into unrelated features.

✅ **Scalable Reuse Path**: PASS
- The plan keeps the profile aggregate distinct from the resume document so profile data can be reused later without coupling summary/edit UX to the editor internals.

✅ **Post-Design Re-check**: PASS
- Phase 1 artifacts preserve feature boundaries, document reusable entities, and avoid introducing new infrastructure beyond local profile persistence and explicit mapping seams.

## Project Structure

### Documentation (this feature)

```text
specs/005-edit-profile-flow/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── profile-edit-flow.md
├── checklists/
│   └── requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/
├── app.dart
├── main.dart
├── config/
│   └── di/
│       └── injection_container.dart
├── core/
│   └── constants/
│       └── app_routes.dart
└── features/
    ├── home/
    │   └── presentation/
    ├── profile/
    │   ├── data/
    │   │   ├── datasources/
    │   │   ├── mappers/
    │   │   ├── models/
    │   │   └── repositories/
    │   ├── domain/
    │   │   ├── entities/
    │   │   ├── repositories/
    │   │   └── usecases/
    │   ├── presentation/
    │   │   ├── bloc/
    │   │   ├── pages/
    │   │   └── widgets/
    │   └── profile_injection.dart
    └── resume/
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

**Structure Decision**: This is a single Flutter app using feature-based slices. The implementation should deepen `lib/features/profile/` into a full data/domain/presentation feature, keep routing and DI changes narrow in `lib/app.dart`, `lib/core/constants/app_routes.dart`, and `lib/config/di/injection_container.dart`, and touch the `resume` feature only if a future-friendly mapping seam is needed for profile reuse.

## Complexity Tracking

No constitution violations or justified exceptions are required for this feature.

## Implementation Roadmap

### Phase 0: Research Complete
- Keep reusable profile data as a dedicated aggregate instead of mutating the existing resume document to own profile editing state
- Persist one reusable profile locally as a serialized record plus copied image path to avoid introducing heavier storage infrastructure
- Use inline repeatable controls for simple sections and bottom sheets for structured experience and education entry to match the requested UX
- Apply layered validation so overall profile saving stays resilient while structured records enforce completion and entered values are preserved on error

### Phase 1: Design Complete
- Model the editable profile aggregate and each repeatable section, including awards and certifications that are now part of reusable profile data
- Define the profile summary, edit form, and bottom-sheet interaction contract for saving, validation, and removal behavior
- Document quickstart validation for navigation, editing, repeated-item persistence, and invalid-input handling
- Update the Copilot agent context to point to this plan for downstream task generation

### Phase 2: Implementation Planning Boundary
- `/speckit-tasks` should break the work into profile domain/data foundations, local persistence, summary-page rendering, edit-page form state and validation, work/education bottom-sheet flows, repeated-section widgets, DI/routing wiring, and focused regression coverage
