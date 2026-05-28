# Implementation Plan: Favorite Template Support

**Branch**: `[016-favorite-template-support]` | **Date**: 2026-05-28 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/016-favorite-template-support/spec.md`

## Summary

Implement production-grade favorite template management by persisting favorite template IDs in local storage, merging persisted favorites into template state on load, supporting immediate toggle updates from Home and preview surfaces, and adding a Home-level Favorites Only filter while preserving the existing template browsing and selection flow.

## Technical Context

**Language/Version**: Dart `>=3.3.0 <4.0.0` with current Flutter SDK

**Primary Dependencies**:
- `flutter_bloc` for Home state and filter/toggle coordination
- `get_it` for dependency wiring
- `freezed`/`freezed_annotation` for immutable event/state/model structures
- Local key-value persistence dependency for favorite IDs (selected in research as lightweight and replaceable behind datasource abstraction)

**Storage**: Local on-device key-value persistence for favorite template IDs plus in-memory presentation state

**Testing**: `flutter_test` with repository/data-source unit tests and Home/preview widget or bloc interaction tests

**Target Platform**: Flutter app targets already supported in repository (Android, iOS, macOS, Linux, Windows, web)

**Project Type**: Single Flutter application with feature-based modular structure

**Performance Goals**:
- Favorite icon feedback should be immediate on user tap
- Favorite-filter toggling should update visible list without noticeable lag
- App startup should restore favorite state without degrading template-flow usability

**Constraints**:
- Keep changes isolated to favorite persistence, toggle behavior, filtering, and sync concerns
- Maintain existing template browsing, preview, and "Use this template" flow
- Keep favorite business logic reusable across multiple template surfaces
- Handle stale or invalid persisted IDs without breaking UI

**Scale/Scope**:
- Home template listing flow under `lib/features/home/`
- Template preview flow under `lib/features/resume/presentation/pages/template_preview_page.dart`
- Shared template entities/mappers touched only as needed for synchronization
- Feature documentation in `specs/016-favorite-template-support/`

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

✅ **Constitution Status**: PASS
- `.specify/memory/constitution.md` is currently a placeholder template with no enforceable project-specific principles or hard gates.

✅ **Scope Gate**: PASS
- Planned changes remain bounded to favorite persistence/synchronization/filtering and do not broaden into unrelated template flow redesign.

✅ **Architecture Gate**: PASS
- The plan keeps logic inside existing feature boundaries (`home` + template preview flow) and reinforces reusable state handling instead of screen-local duplication.

✅ **Post-Design Re-check**: PASS
- Phase 1 artifacts define a stable internal interaction contract and data model with no unresolved clarifications.

## Project Structure

### Documentation (this feature)

```text
specs/016-favorite-template-support/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── favorite-template-ui-contract.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/
├── features/
│   ├── home/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── mappers/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   └── resume/
│       └── presentation/
│           └── pages/
│               └── template_preview_page.dart
└── app/

test/
├── features/
│   ├── home/
│   └── resume/
└── widget_test.dart
```

**Structure Decision**: Use the existing single-app Flutter feature structure, with favorite persistence and state synchronization centered in the Home data/domain/presentation pipeline and consumed by both Home thumbnails and preview page to ensure one consistent favorite state model.

## Complexity Tracking

No constitution violations or complexity waivers are required.

## Implementation Roadmap

### Phase 0: Research Complete
- Chosen persistence strategy: local storage of unique template IDs only.
- Chosen synchronization strategy: merge persisted favorite IDs into template catalog state and reuse across screens.
- Chosen filter strategy: keep a single loaded catalog and apply `favoritesOnly` as view state.
- Chosen resilience strategy: ignore stale IDs and normalize duplicates.

### Phase 1: Design Complete
- Defined data model for catalog templates, persisted favorite set, and filter/view state.
- Authored interaction contract for load/toggle/filter events and expected cross-surface behavior.
- Captured manual validation quickstart for persistence, filtering, and synchronization.
- Updated agent context reference in `.github/copilot-instructions.md` to this plan.

### Phase 2: Implementation Planning Boundary
- `/speckit-tasks` should decompose into:
  1. Add reusable persistence-backed favorite datasource/service abstraction
  2. Update repository/use cases to merge persisted favorites into template state
  3. Extend Home state/events for Favorites Only filtering and empty-result UX
  4. Wire preview page favorite actions through shared favorite state flow
  5. Add focused tests for persistence, filter behavior, and cross-surface consistency
