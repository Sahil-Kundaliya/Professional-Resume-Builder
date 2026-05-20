# Implementation Plan: Refactor Flutter Project Structure

**Branch**: `001-refactor-flutter-structure` | **Date**: 2026-05-19 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/001-refactor-flutter-structure/spec.md`

## Summary

Refactor the Professional Resume Builder Flutter project from a mixed folder structure into a scalable, production-grade clean architecture following the Constitution principles. The refactoring will:

1. **Establish feature-based architecture** with two primary features (home template browsing, resume editor/preview)
2. **Implement proper layer separation** (presentation/domain/data) to enforce dependency direction
3. **Centralize shared concerns** (themes, constants, utilities, reusable widgets) in core and shared modules
4. **Migrate state management** into feature-specific bloc/provider modules
5. **Improve developer experience** through clear structure, consistent naming, and reduced coupling
6. **Ensure team scalability** by establishing patterns that support rapid feature addition without architectural drift

The refactoring maintains backward compatibility—all features continue to work identically post-migration.

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.x (latest stable)

**Primary Dependencies**: 
- State Management: Provider (current), migrating toward Flutter Bloc per Constitution
- Networking: Dio (foundation for data layer)
- Code Generation: freezed, json_serializable, build_runner
- Navigation: GoRouter (to be integrated per Constitution's auto_route requirement)
- DI: get_it + injectable (per Constitution mandate)

**Storage**: Local (currently in-memory), potential SQLite for persistence (future)

**Testing**: flutter_test, mockito, bloc_test

**Target Platform**: iOS 12+, Android 21+ (mobile-first, web as secondary)

**Project Type**: Mobile application (multi-page resume builder with editing/preview flows)

**Performance Goals**: 
- Template thumbnail load: <500ms
- Editor canvas interaction: 60fps with 50+ editable fields
- PDF generation: <2s for typical resume

**Constraints**: 
- Maintain all current UI/UX behaviors during refactor
- No breaking changes to provider API during migration
- Support hot reload during development

**Scale/Scope**: 
- 2 major features (home, resume)
- ~8 screens currently (consolidate to feature organization)
- ~3 data models (ResumeDocument, ResumeTemplate, ResumeElement)
- ~15 providers/blocs (consolidate to feature scope)

## Constitution Check

**GATE**: ✅ PASSES (with Phase 1 validation required)

| Principle | Status | Note |
|-----------|--------|------|
| I. Production-Grade Code | ✅ PASS | Refactoring improves code quality; all code remains production-safe during migration |
| II. Clean Architecture | ⚠️ CONDITIONAL | Current state violates clean architecture (models in lib/models, providers at root). Plan enforces separation. Requires Phase 1 confirmation. |
| III. Mandatory Toolchain | ✅ PASS | Project uses Provider; migration plan includes flutter_bloc/injectable/freezed setup per Constitution |
| IV. Bloc-Driven Navigation | ⚠️ CONDITIONAL | Currently using basic MaterialApp routing. Plan includes GoRouter/auto_route integration in Phase 1+ |
| V. Performance Gates | ✅ PASS | Refactoring improves rebuild efficiency through layer separation and BlocSelector usage |

**Phase 1 validation required**: Confirm freezed model generation and injectable DI setup are properly configured before proceeding to implementation.

## Project Structure

### Documentation (this feature)

```text
specs/001-refactor-flutter-structure/
├── spec.md              # Feature specification
├── plan.md              # This file
├── research.md          # Phase 0: Technology stack decisions
├── data-model.md        # Phase 1: Entity definitions
├── quickstart.md        # Phase 1: Migration quickstart guide
├── contracts/           # Phase 1: Architecture contracts
│   ├── layer-contracts.md
│   └── feature-structure.md
├── checklists/
│   └── requirements.md   # Specification validation
└── tasks.md             # Phase 2: Actionable tasks (/speckit-tasks output)
```

### Source Code (target architecture)

```text
lib/
├── main.dart                          # App entry point (minimal, only DI setup)
├── app.dart                           # App widget configuration
│
├── core/                              # Cross-cutting concerns
│   ├── config/                        # App-level configuration
│   │   ├── app_routes.dart           # Route definitions
│   │   ├── app_constants.dart        # Global constants
│   │   └── app_theme.dart            # Theme data
│   │
│   ├── network/                       # API & data transport
│   │   ├── dio_client.dart           # Dio configuration
│   │   └── interceptors/
│   │
│   ├── error/                         # Error handling (domain-safe)
│   │   ├── app_exception.dart        # Exception hierarchy
│   │   └── error_handler.dart        # Error conversion
│   │
│   ├── services/                      # Non-feature services
│   │   └── pdf_service.dart          # PDF generation
│   │
│   ├── utils/                         # Utilities (extensions, helpers)
│   │   ├── extensions.dart
│   │   └── helpers.dart
│   │
│   ├── widgets/                       # Reusable base widgets
│   │   ├── app_button.dart
│   │   └── app_scaffold.dart
│   │
│   └── theme/
│       ├── app_colors.dart           # Centralized color tokens
│       └── app_text_styles.dart      # Typography system
│
├── shared/                            # Feature-independent reusables
│   ├── widgets/                       # Reusable UI components
│   │   ├── custom_app_bar.dart
│   │   └── empty_state.dart
│   │
│   ├── models/                        # Shared domain models
│   │   └── (empty initially; populated if cross-feature entities exist)
│   │
│   └── utils/                         # Shared utilities
│       └── (extension methods, common helpers)
│
├── config/                            # Dependency injection & routing
│   ├── di/
│   │   ├── injection_container.dart  # Global DI setup
│   │   └── feature_di.dart           # Aggregates all feature DI
│   │
│   └── routes/
│       ├── app_router.dart           # GoRouter/auto_route config
│       └── route_names.dart          # Route constants
│
└── features/
    ├── home/                          # Home/Template Discovery Feature
    │   ├── presentation/
    │   │   ├── pages/
    │   │   │   ├── home_page.dart
    │   │   │   └── home_page_view.dart
    │   │   ├── widgets/
    │   │   │   ├── template_thumbnail.dart
    │   │   │   └── template_grid.dart
    │   │   ├── bloc/
    │   │   │   ├── home_bloc.dart
    │   │   │   ├── home_event.dart
    │   │   │   └── home_state.dart
    │   │   ├── provider/                # Alternative if Provider used
    │   │   │   └── home_provider.dart
    │   │   └── controller/
    │   │
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── template_local_datasource.dart
    │   │   ├── models/
    │   │   │   └── resume_template_model.dart
    │   │   ├── repositories/
    │   │   │   └── template_repository_impl.dart
    │   │   └── mappers/
    │   │       └── template_mapper.dart
    │   │
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── resume_template.dart
    │   │   ├── repositories/
    │   │   │   └── template_repository.dart
    │   │   └── usecases/
    │   │       ├── get_templates.dart
    │   │       └── toggle_favorite.dart
    │   │
    │   └── home_injection.dart        # Feature-scoped DI
    │
    └── resume/                         # Resume Editor/Preview/PDF Feature
        ├── presentation/
        │   ├── pages/
        │   │   ├── template_preview_page.dart
        │   │   ├── editor_page.dart
        │   │   └── pdf_preview_page.dart
        │   ├── widgets/
        │   │   ├── resume_canvas.dart
        │   │   ├── formatting_toolbar.dart
        │   │   ├── field_editor_card.dart
        │   │   ├── work_experience_editor.dart
        │   │   ├── education_editor.dart
        │   │   ├── skills_editor.dart
        │   │   └── awards_certifications_editor.dart
        │   ├── bloc/
        │   │   ├── resume_bloc.dart
        │   │   ├── resume_event.dart
        │   │   └── resume_state.dart
        │   ├── provider/
        │   │   └── resume_provider.dart  # Existing provider, migrated here
        │   └── controller/
        │
        ├── data/
        │   ├── datasources/
        │   │   ├── resume_local_datasource.dart
        │   │   └── resume_remote_datasource.dart
        │   ├── models/
        │   │   ├── resume_document_model.dart
        │   │   ├── resume_element_model.dart
        │   │   ├── work_experience_model.dart
        │   │   ├── education_model.dart
        │   │   ├── skill_entry_model.dart
        │   │   ├── award_entry_model.dart
        │   │   └── cert_entry_model.dart
        │   ├── repositories/
        │   │   └── resume_repository_impl.dart
        │   └── mappers/
        │       └── resume_mapper.dart
        │
        ├── domain/
        │   ├── entities/
        │   │   ├── resume_document.dart
        │   │   ├── resume_element.dart
        │   │   ├── work_experience.dart
        │   │   ├── education.dart
        │   │   ├── skill_entry.dart
        │   │   ├── award_entry.dart
        │   │   └── cert_entry.dart
        │   ├── repositories/
        │   │   └── resume_repository.dart
        │   └── usecases/
        │       ├── load_resume.dart
        │       ├── update_resume_field.dart
        │       ├── add_work_experience.dart
        │       ├── remove_work_experience.dart
        │       └── generate_pdf.dart
        │
        └── resume_injection.dart      # Feature-scoped DI

```

**Structure Decision**: This is **Option 1: Single Mobile Project** with feature-first architecture. The entire lib/ structure follows clean architecture principles with strict layer separation (presentation/domain/data). Each feature (home, resume) is self-contained with its own DI entry point. Core and shared modules provide cross-cutting utilities and reusable components.

## Complexity Tracking

| Issue | Resolution | Status |
|-------|-----------|--------|
| Existing Provider at root level | Migrate to feature-scoped provider or bloc per Constitution Phase 1 | Phase 1 design |
| MaterialApp routing vs GoRouter | Introduce GoRouter incrementally; initially keep compatibility layer | Phase 1 design |
| Freezed code generation setup | Validate build_runner configuration and ensure reproducibility | Phase 1 research |
| Large ResumeProvider (154 lines) | Split into smaller cubits/providers following single-responsibility | Phase 2 implementation |

---

## Phase 0: Research Tasks

The following unknowns require resolution before Phase 1 design:

1. **Freezed & Code Generation Setup**
   - Current project status: freezed may not be configured
   - Task: Validate build_runner, freezed, and json_serializable integration
   - Deliverable: research.md with confirmed toolchain setup

2. **Provider Migration Path**
   - Current state: Provider at root level
   - Task: Research flutter_bloc vs Provider tradeoff for feature-scoped state
   - Deliverable: Recommendation for state management per Constitutional requirement

3. **Navigation Migration Strategy**
   - Current state: Basic MaterialApp routes
   - Task: Research GoRouter and auto_route integration without breaking changes
   - Deliverable: Phased adoption plan

**Output Location**: `specs/001-refactor-flutter-structure/research.md`

---

## Phase 1: Design & Contracts

### 1. Data Model Definition
Generate `data-model.md` defining all entities:
- ResumeDocument (header, experience, education, profile, skills, awards, certs, references, hobbies)
- ResumeTemplate (id, name, layout, isFavorite, previewImage)
- ResumeElement (id, type, bounds, content)
- Nested models: WorkExperienceEntry, EducationEntry, SkillEntry, etc.

### 2. Architecture Contracts
Define in `contracts/`:
- **Layer Boundaries Contract**: Specifies what each layer (presentation/domain/data) may import
- **Feature Structure Contract**: Defines folder layout and DI entry points for each feature
- **Bloc/Provider Contract**: State, event, action shapes for resume and home features

### 3. Quickstart Guide
Create `quickstart.md`:
- How to add a new field to the resume editor
- How to add a new feature
- How to run code generation
- How to test state changes
- Key import patterns (to avoid breaking layer boundaries)

### 4. Agent Context Update
Update `.github/copilot-instructions.md` with plan reference so implementation follows architecture.

**Output Location**: 
- `specs/001-refactor-flutter-structure/data-model.md`
- `specs/001-refactor-flutter-structure/contracts/`
- `specs/001-refactor-flutter-structure/quickstart.md`
- Updated `.github/copilot-instructions.md`

---

## Implementation Readiness

✅ **Ready for Phase 0 Research** - Constitution check passed with conditions.  
⏭️ **Next Step**: Run `/speckit-plan` Phase 0 to generate research.md and resolve unknowns.  
📋 **Phase 1** will finalize data models, architecture contracts, and quickstart guide.  
🚀 **Phase 2** (`/speckit-tasks`) will generate actionable migration tasks.
