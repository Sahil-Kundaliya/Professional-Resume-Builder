# Implementation Plan: Add Profile Navigation

**Branch**: `004-add-profile-navigation` | **Date**: 2026-05-20 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/004-add-profile-navigation/spec.md`

**Note**: This plan introduces an app-level two-tab shell, a new reusable profile feature with local persistence, and a template start decision that can open the editor from scratch or prefill it from saved profile data while leaving the current Home flow behavior intact.

## Summary

Implement a bottom navigation shell with Home and Profile tabs, keep the existing Home template journey unchanged inside that shell, add a new feature-based Profile slice for viewing and editing reusable resume profile data, persist the saved profile locally for later reuse, and update template preview so Use this template first presents a Start From Scratch versus Use Your Data dialog before opening the resume editor.

## Technical Context

**Language/Version**: Dart `>=3.3.0 <4.0.0`, Flutter SDK from the project toolchain

**Primary Dependencies**:
- `flutter_bloc` for existing editor and feature state management
- `freezed_annotation` and `freezed` for immutable entities, events, and states
- `get_it` for feature dependency registration
- `image_picker` for profile image selection
- `path_provider` for locating app-local storage paths
- `google_fonts` for the app's current typography and screen styling

**Storage**: Local file-backed persistence for a single reusable profile plus copied profile image path stored inside the app documents directory; existing resume draft storage remains the in-memory repository already used by the resume feature

**Testing**: `flutter_test` for widget tests, bloc tests, and mapper/use-case coverage around profile persistence, template start choices, and prefill behavior

**Target Platform**: Flutter mobile-first application with Android, iOS, web, macOS, Linux, and Windows targets; this feature primarily affects shared app navigation and presentation logic

**Project Type**: Single Flutter application with feature-based organization under `lib/features/`

**Performance Goals**: Tab switching and dialog presentation should feel immediate during normal app use, and loading saved profile data for prefill should complete within the normal page-transition budget without a perceptible delay for a single local profile

**Constraints**:
- Preserve current Home tab behavior and template browsing flow without changing its user-visible steps
- Keep the new work inside feature-based boundaries and reuse existing DI patterns
- Treat every profile field as optional, including repeated sections and dates
- Store only one reusable local profile for this phase
- Allow Start From Scratch and Use Your Data to produce clearly different editor initialization behavior

**Scale/Scope**:
- 1 app shell / entry route update
- 1 new profile feature slice (`data`, `domain`, `presentation`)
- 1 template preview flow update with confirmation dialog
- 1 resume prefill mapping path from saved profile to editable resume document
- local persistence for one profile and its image asset reference

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

✅ **Project Constitution Availability**: PASS
- `.specify/memory/constitution.md` is still an unfilled template, so there are no ratified project-specific gates to violate.

✅ **Repository Architecture Conventions**: PASS
- The design keeps work inside `lib/features/home/`, `lib/features/resume/`, and a new `lib/features/profile/` slice, with app wiring remaining in `lib/app.dart` and `lib/config/di/`.

✅ **Scope Preservation**: PASS
- The Home flow remains behaviorally unchanged, while the new scope is isolated to app shell navigation, reusable profile management, and template start branching.

✅ **Post-Design Re-check**: PASS
- Phase 1 artifacts maintain feature boundaries, keep persistence local, and avoid cross-feature leakage beyond explicit profile-to-resume prefill mapping.

## Project Structure

### Documentation (this feature)

```text
specs/004-add-profile-navigation/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── profile-navigation-and-prefill.md
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
    │   ├── data/
    │   ├── domain/
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
    │   └── presentation/
    │       ├── bloc/
    │       ├── pages/
    │       └── widgets/
    └── resume/
        ├── data/
        ├── domain/
        └── presentation/

test/
├── features/
│   ├── profile/
│   └── resume/
└── widget_test.dart
```

**Structure Decision**: This is a single Flutter app with existing feature-based slices. The change will introduce a new `profile` feature for local profile management, keep Home intact inside a new app shell, and extend the `resume` feature only where template preview and editor initialization need to branch on the saved profile.

## Complexity Tracking

No constitution violations or justified exceptions are required for this feature.

## Implementation Roadmap

### Phase 0: Research Complete
- Choose a dedicated `profile` feature slice instead of folding reusable profile state into the existing resume aggregate
- Persist the single reusable profile as a local JSON document plus copied image file path in the app documents directory
- Keep Home behavior unchanged by wrapping current feature entry pages in a navigation shell rather than rewriting the Home internals
- Introduce an explicit profile-to-resume prefill mapper so template startup behavior stays isolated and testable

### Phase 1: Design Complete
- Model the reusable profile aggregate and repeated profile items separately from `ResumeDocument`
- Define the navigation, profile editing, and template start interaction contract
- Document quickstart steps for app shell wiring, local persistence, and prefill validation
- Update the Copilot agent context to point at this plan for downstream task generation

### Phase 2: Implementation Planning Boundary
- `/speckit-tasks` should break the work into app shell/navigation setup, profile domain/data/presentation creation, local persistence wiring, template preview dialog branching, prefill mapping, and focused regression coverage for Home preservation and resume startup paths
