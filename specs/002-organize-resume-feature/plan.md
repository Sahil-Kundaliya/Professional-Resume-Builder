# Implementation Plan: Organize Resume Feature into Feature-First Architecture

**Branch**: `002-organize-resume-feature` | **Date**: 2026-05-19 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/002-organize-resume-feature/spec.md`

**Note**: This plan consolidates resume-related files into a feature-first structure and implements Bloc-based state management in accordance with the project constitution.

## Summary

Consolidate all resume-related screens, models, and state management from scattered `lib/screens/`, `lib/models/`, and `lib/providers/` directories into a unified `lib/features/resume/` feature module. Convert the existing Provider-based state management to Flutter Bloc with proper event/state separation using Freezed. Reorganize resume data models as Freezed entities and DTOs following Clean Architecture, ensuring all imports are updated and no legacy directories remain.

## Technical Context

**Language/Version**: Dart 3.x, Flutter 3.x

**Primary Dependencies**: 
- `flutter_bloc` (state management)
- `freezed_annotation` + `json_serializable` (models/entities)
- `provider` (legacy, being replaced)
- `auto_route` (navigation)
- `get_it` + `injectable` (dependency injection)
- `google_fonts` (typography)

**Storage**: Local state management only (no persistence layer changes required)

**Testing**: Flutter widget and Bloc testing via `flutter_test`

**Target Platform**: iOS 11.0+, Android API 21+

**Project Type**: Mobile app (iOS/Android)

**Performance Goals**: 60 fps UI rendering, state updates within 16ms frame budget

**Constraints**: Maintain backward compatibility with existing routes and functionality during migration

**Scale/Scope**: 
- 5 main screens to migrate (editor, preview, template selection, home)
- 3 model classes to convert to Freezed entities
- 1 provider to convert to Bloc
- ~15 widget files to relocate and update

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

✅ **Principle I (Production-Grade Flutter)**: PASS
- All migrated code will use meaningful names and Clean Architecture patterns
- Code will be reviewable and maintainable under team ownership

✅ **Principle II (Clean Architecture + Feature-First)**: PASS
- Feature-first structure is core goal of this work
- Data, domain, and presentation layers will be properly separated
- Business logic moves to Bloc, not retained in widgets

✅ **Principle III (Mandatory Toolchain)**: PASS
- Using flutter_bloc (required)
- Using freezed + json_serializable for models/entities
- Using injectable + get_it for DI
- No manual model creation

✅ **Principle IV (Bloc-Driven Presentation)**: PASS
- Presentation layer will be thin (rendering only)
- Auto_route will be used for navigation (already in place)
- Bloc handles all business logic and side effects

✅ **Principle V (Performance & Maintainability)**: PASS
- Bloc will use proper selectors to minimize rebuilds
- Code will be organized for clarity and performance
- No hardcoded values (uses theme, constants)

## Project Structure

### Documentation (this feature)

```text
specs/002-organize-resume-feature/
├── plan.md              # This file
├── spec.md              # Feature specification
├── research.md          # Phase 0 research (if needed)
├── data-model.md        # Phase 1 data model design
├── quickstart.md        # Phase 1 quickstart reference
├── contracts/           # Phase 1 interface contracts (if applicable)
└── checklists/
    └── requirements.md  # Specification quality checklist
```

### Source Code (repository root)

```text
lib/
├── core/                # Unchanged (shared utilities, theme, constants)
├── config/              # Unchanged (DI, routes)
├── features/
│   ├── home/            # Existing feature (unchanged)
│   └── resume/          # TARGET: Organized resume feature
│       ├── data/
│       │   ├── datasources/       # API/local data access (stub for now)
│       │   ├── models/            # DTOs (Freezed)
│       │   ├── repositories/      # Repository implementations
│       │   └── mappers/           # DTO ↔ Entity mapping
│       ├── domain/
│       │   ├── entities/          # Domain entities (Freezed)
│       │   ├── repositories/      # Repository interfaces
│       │   └── usecases/          # Business logic
│       ├── presentation/
│       │   ├── bloc/              # Bloc, events, states (Freezed)
│       │   ├── pages/             # Screen widgets
│       │   └── widgets/           # Reusable UI components
│       └── resume_injection.dart  # Feature DI wiring
├── shared/              # Unchanged
├── app.dart             # Updated imports
└── main.dart            # Updated imports

FILES TO DELETE:
└── lib/
    ├── screens/         # REMOVE: All files moved to features
    ├── models/          # REMOVE: All files moved to features
    └── providers/       # REMOVE: Replaced by Bloc
```

**Structure Decision**: 
- All resume functionality consolidates under `lib/features/resume/`
- Follows existing home feature as template for Clean Architecture
- Data, domain, and presentation layers strictly separated
- Bloc replaces Provider for state management
- All imports updated in app.dart, main.dart, and affected files

## Complexity Tracking

No Constitution violations. The work aligns fully with required architecture.

---

## Implementation Roadmap

### Phase 0: Research & Design
**Output**: research.md, data-model.md, quickstart.md

1. **Audit existing code**:
   - Map all files to be migrated (screens, models, providers, widgets)
   - Identify dependencies between files
   - List all import locations that need updates

2. **Design Bloc structure**:
   - Define ResumeBloc events (LoadResume, SaveResume, EditField, etc.)
   - Define ResumeState variants (Loading, Loaded, Error, etc.)
   - Design state transitions and side effects

3. **Design data models**:
   - Convert ResumeDocument to Freezed entity
   - Convert sub-models (WorkExperienceEntry, etc.) to Freezed
   - Define DTOs for data layer
   - Create mappers for DTO ↔ Entity conversion

4. **Document quickstart**:
   - Show how to access ResumeBloc in widgets
   - Show example Bloc event dispatch
   - Show example state listening

### Phase 1: Code Generation & Contracts
**Output**: Code generation config, interface contracts

1. **Update pubspec.yaml** (if needed):
   - Ensure freezed_annotation and json_serializable are present
   - Verify flutter_bloc version is compatible

2. **Generate Freezed entities**:
   - Add @freezed annotations to entity classes
   - Add @freezed annotations to Bloc events and states
   - Run `flutter pub run build_runner build`

3. **Create interface contracts** (in /specs/002-organize-resume-feature/contracts/):
   - Bloc interface: ResumeBloc events and state shape
   - Repository interface: Methods and error contracts

### Phase 2: File Migration & Updates
**Handled by `/speckit-tasks` command — NOT in this plan document**

Files will be:
1. **Moved** to new feature structure
2. **Refactored** to use Bloc instead of Provider
3. **Updated** imports throughout codebase
4. **Tested** to verify functionality preserved
