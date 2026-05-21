# Implementation Plan: Extend Profile Sections

**Branch**: `006-pre-spec-branch` | **Date**: 2026-05-21 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/006-extend-profile-sections/spec.md`

## Summary

Extend the existing Profile module by adding scalable list-based profile sections for experience, hobbies, education, awards, and certifications while preserving the existing basic-details fields and their behavior. The implementation approach is additive: reuse current profile entities, repository, and edit-page flow; add section widgets and section-specific bottom sheets on top of the current UI with minimal integration changes.

## Technical Context

**Language/Version**: Dart `>=3.3.0 <4.0.0`, Flutter SDK from project toolchain

**Primary Dependencies**:
- `flutter_bloc` for profile loading/edit state and add-item workflow events
- `get_it` for wiring profile feature dependencies
- `freezed_annotation` + generated models for immutable profile/value records
- `image_picker` and `path_provider` already used in current basic details flow
- `intl` for date presentation and entry consistency

**Storage**: Existing local JSON file persistence through `ProfileLocalDataSource`

**Testing**: `flutter_test` for widget tests and profile feature behavior checks

**Target Platform**: Flutter mobile-first app (Android and iOS primary), with existing multi-platform support retained

**Project Type**: Single Flutter application with feature-based organization

**Performance Goals**:
- Opening Edit Profile and each section bottom sheet should feel immediate during manual interaction
- Saving profile updates including multiple list entries should complete within normal navigation latency expectations

**Constraints**:
- Do not modify existing behavior for image, full name, job title, summary, email, address, country code, phone number, portfolio link, or birth date
- Keep existing Profile and Edit Profile UI/logic unchanged unless a minimal integration update is required
- Additive changes only: no rewrites of current profile architecture
- Support multiple entries for each new list-based section

**Scale/Scope**:
- 1 existing profile summary page enhanced with additional list sections
- 1 existing edit page enhanced with section-level add flows
- 4 section-specific bottom sheets (experience, education, awards, certifications)
- 5 repeatable sections rendered in profile summary and edit views

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

✅ **Constitution Availability**: PASS
- `.specify/memory/constitution.md` remains a template with no ratified mandatory gates, so no enforceable violations are present.

✅ **Minimal-Change Constraint Alignment**: PASS
- Plan scope is additive over existing profile flow and explicitly avoids changing current basic fields/logic.

✅ **Feature Boundary Alignment**: PASS
- All work stays under `lib/features/profile/` with narrow touchpoints in routing/DI if required.

✅ **Post-Design Re-check**: PASS
- Phase 1 artifacts preserve additive behavior, keep storage/repository boundaries intact, and avoid introducing new infrastructure.

## Project Structure

### Documentation (this feature)

```text
specs/006-extend-profile-sections/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── profile-sections-flow.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/
├── app.dart
├── config/
│   └── di/
│       └── injection_container.dart
├── core/
│   └── constants/
│       └── app_routes.dart
└── features/
    └── profile/
        ├── profile_injection.dart
        ├── data/
        │   ├── datasources/
        │   ├── mappers/
        │   ├── models/
        │   └── repositories/
        ├── domain/
        │   ├── entities/
        │   ├── repositories/
        │   └── usecases/
        └── presentation/
            ├── bloc/
            ├── pages/
            └── widgets/

test/
├── features/
│   └── profile/
└── widget_test.dart
```

**Structure Decision**: Keep a single-project Flutter structure and implement this feature entirely within the existing `profile` feature layers. Preserve current repository/entity patterns and extend presentation widgets/pages with section list rendering and bottom-sheet add flows, minimizing changes to app-wide routing and DI.

## Complexity Tracking

No constitution violations or justified exceptions are required.

## Implementation Roadmap

### Phase 0: Research Complete
- Confirm additive extension strategy over the existing profile architecture.
- Confirm bottom sheet usage for structured records and inline list rendering for section visibility.
- Confirm persistence strategy reuses current local profile storage and mapper layers.
- Confirm validation boundaries that protect existing fields while enforcing new item completeness.

### Phase 1: Design Complete
- Define domain and UI data model boundaries for each new section.
- Define user-facing interaction contract for list visibility, add actions, and bottom-sheet behavior.
- Document implementation quickstart and validation flow for regression-safe rollout.
- Update Copilot agent context pointer to this plan.

### Phase 2: Implementation Planning Boundary
- `/speckit-tasks` should break implementation into profile summary section widgets, edit-page section integrations, bottom-sheet forms, validation and draft updates, persistence coverage, and targeted tests for regression and new flows.
