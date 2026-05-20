# Tasks: Refactor Flutter Project Structure

**Input**: Design documents from `/specs/001-refactor-flutter-structure/`

**Branch**: `001-refactor-flutter-structure`

**Prerequisites**: 
- ✅ plan.md (technical architecture, phase breakdown)
- ✅ spec.md (4 user stories with priorities P1-P3)
- ✅ data-model.md (entities, relationships, validation)
- ✅ contracts.md (layer boundaries, feature structure, DI patterns)
- ✅ research.md (freezed, Provider/Bloc, routing decisions)
- ✅ quickstart.md (developer how-to guide)

**Status**: Ready for implementation

---

## Format: `[ID] [P?] [Story] Description`

- **[ID]**: Task identifier (T001, T002, etc.)
- **[P]**: Can run in parallel (different files, no blocking dependencies)
- **[Story]**: Which user story (US1, US2, US3, US4) - omitted for Setup/Foundational phases
- **[file paths]**: Always include exact file paths to modify or create

---

## Phase 1: Setup (Project Structure & Dependencies)

**Purpose**: Create directory structure and add required dependencies

**Duration**: 30-45 minutes

### Structure Creation

- [ ] T001 Create feature directories at lib/features/{home,resume}/{presentation,domain,data}
- [ ] T002 [P] Create core directories at lib/core/{config,network,error,services,utils,theme}
- [ ] T003 [P] Create shared directories at lib/shared/{widgets,utils,models}
- [ ] T004 [P] Create config directories at lib/config/{di,routes}
- [ ] T005 Create feature injection entry points: lib/features/home/home_injection.dart and lib/features/resume/resume_injection.dart

### Dependency Management

- [ ] T006 Add freezed, json_serializable, build_runner via `flutter pub add freezed_annotation json_serializable && flutter pub add -d build_runner freezed`
- [ ] T007 Add injectable and get_it via `flutter pub add get_it && flutter pub add -d injectable_generator`
- [ ] T008 Add GoRouter via `flutter pub add go_router`
- [ ] T009 Create build.yaml for code generation configuration at project root

**Checkpoint**: Directory structure ready and dependencies installed

---

## Phase 2: Foundational (Code Generation & Infrastructure)

**Purpose**: Setup core infrastructure that BLOCKS all user story work

**⚠️ CRITICAL**: No user story implementation can begin until this phase completes

**Duration**: 1-1.5 hours

### Code Generation Configuration

- [ ] T010 Configure build.yaml for freezed and build_runner in project root
- [ ] T011 [P] Create base exception class at lib/core/error/app_exception.dart with domain-safe error types
- [ ] T012 [P] Create error mapper at lib/core/error/error_handler.dart to convert data exceptions to domain failures
- [ ] T013 Run initial code generation: `flutter pub run build_runner build --delete-conflicting-outputs`

### Dependency Injection Setup

- [ ] T014 Create main DI container at lib/config/di/injection_container.dart (aggregates all feature DI)
- [ ] T015 [P] Create feature DI utils/helpers at lib/config/di/feature_di_utils.dart
- [ ] T016 Setup core service registration at lib/config/di/injection_container.dart (PDF service, network, error handling)
- [ ] T017 Update main.dart to initialize DI: `void main() { setupDependencies(); runApp(...); }`

### Routing Infrastructure

- [ ] T018 Create route constants at lib/config/routes/route_names.dart (home, templatePreview, editor, pdfPreview)
- [ ] T019 [P] Create GoRouter configuration skeleton at lib/config/routes/app_router.dart (non-functional, for Phase 2+)
- [ ] T020 Update lib/app.dart to reference route_names constants instead of inline strings

### Core Organization

- [ ] T021 [P] Move app_colors.dart from lib/core/constants/ to lib/core/theme/app_colors.dart
- [ ] T022 [P] Move app_text_styles.dart from lib/core/constants/ to lib/core/theme/app_text_styles.dart
- [ ] T023 Create app_constants.dart at lib/core/config/ for non-theme constants
- [ ] T024 Create app_theme.dart at lib/core/theme/ that exports theme configuration
- [ ] T025 [P] Move pdf_generator.dart from lib/core/utils/ to lib/core/services/pdf_service.dart and refactor as injectable service

### Shared Components Organization

- [ ] T026 Move app_button.dart from lib/core/widgets/ to lib/shared/widgets/app_button.dart
- [ ] T027 [P] Create reusable base widgets at lib/shared/widgets/app_scaffold.dart (future use)

**Checkpoint**: Code generation working, DI container ready, routing structure defined, core/shared organized

**Verification**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs  # Should complete successfully
grep -r "setupDependencies" lib/main.dart  # Should find DI call
flutter analyze  # Should have no errors
```

---

## Phase 3: User Story 1 - Developer Adding New Features (Priority: P1) 🎯 MVP

**Goal**: Establish the working example feature (Home) that demonstrates the new architecture pattern

**Independent Test**: Home feature compiles, shows template list, toggle favorite works, developer can follow exact same pattern for new features

**Duration**: 1.5-2 hours

### Domain Layer (Home Feature)

- [ ] T028 [P] Create ResumeTemplate entity at lib/features/home/domain/entities/resume_template.dart with @freezed
- [ ] T029 [P] Create ITemplateRepository abstract class at lib/features/home/domain/repositories/template_repository.dart
- [ ] T030 [P] Create GetTemplates usecase at lib/features/home/domain/usecases/get_templates.dart
- [ ] T031 [P] Create ToggleFavoriteusecase at lib/features/home/domain/usecases/toggle_favorite.dart

### Data Layer (Home Feature)

- [ ] T032 [P] Create ResumeTemplateModel at lib/features/home/data/models/resume_template_model.dart with @freezed and @JsonSerializable
- [ ] T033 Create TemplateMapper at lib/features/home/data/mappers/template_mapper.dart (entity ↔ model conversion)
- [ ] T034 [P] Create ITemplateLocalDatasource abstract class at lib/features/home/data/datasources/template_local_datasource.dart
- [ ] T035 Create TemplateLocalDatasource implementation at lib/features/home/data/datasources/template_local_datasource.dart using hardcoded templates from existing code
- [ ] T036 Create ITemplateRepository implementation (TemplateRepositoryImpl) at lib/features/home/data/repositories/template_repository_impl.dart

### Presentation Layer (Home Feature)

- [ ] T037 [P] Create HomeBloc at lib/features/home/presentation/bloc/home_bloc.dart with events/states (freezed)
- [ ] T038 [P] Create home_event.dart at lib/features/home/presentation/bloc/home_event.dart (@freezed events)
- [ ] T039 [P] Create home_state.dart at lib/features/home/presentation/bloc/home_state.dart (@freezed states: initial, loading, loaded, error)
- [ ] T040 Create HomePage at lib/features/home/presentation/pages/home_page.dart (BlocProvider wrapper)
- [ ] T041 [P] Create HomeView at lib/features/home/presentation/pages/home_page_view.dart (actual UI, BlocBuilder)
- [ ] T042 [P] Create TemplateThumbnail widget at lib/features/home/presentation/widgets/template_thumbnail.dart
- [ ] T043 Create TemplateGrid widget at lib/features/home/presentation/widgets/template_grid.dart (displays template list)

### DI Registration (Home Feature)

- [ ] T044 Create home_injection.dart at lib/features/home/home_injection.dart with setupHomeFeature() function
- [ ] T045 Update lib/config/di/injection_container.dart to call setupHomeFeature() in setupDependencies()

### Integration

- [ ] T046 Update lib/app.dart home route to use HomePage from new location
- [ ] T047 Run code generation: `flutter pub run build_runner build --delete-conflicting-outputs`

**Checkpoint**: Home feature fully functional, developer can review code and understand the pattern

**Verification**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
flutter run  # App starts, home shows templates, favorite toggle works
# Code review checklist:
# - All models use @freezed
# - All states use @freezed  
# - Bloc only calls usecases (never datasources)
# - Data layer has mappers converting Model → Entity
# - Presentation only imports domain entities (not models)
```

---

## Phase 4: User Story 2 - Team Lead Consistency & Resume Feature (Priority: P2)

**Goal**: Implement resume editor feature and establish patterns for enforcing consistency

**Independent Test**: Resume feature works independently; developer can verify code follows established patterns; architecture violations are caught in PR review

**Duration**: 3-4 hours

### Domain Layer (Resume Feature)

- [ ] T048 [P] Create ResumeDocument entity at lib/features/resume/domain/entities/resume_document.dart (@freezed)
- [ ] T049 [P] Create nested entities (WorkExperience, Education, SkillEntry, Award, Certification) at lib/features/resume/domain/entities/resume_*.dart
- [ ] T050 Create IResumeRepository abstract at lib/features/resume/domain/repositories/resume_repository.dart
- [ ] T051 [P] Create usecases: LoadResume, SaveResume, AddWorkExperience, RemoveWorkExperience at lib/features/resume/domain/usecases/

### Data Layer (Resume Feature)

- [ ] T052 [P] Create data models: ResumeDocumentModel, WorkExperienceModel, etc. at lib/features/resume/data/models/ (@freezed + @JsonSerializable)
- [ ] T053 Create ResumeMapper at lib/features/resume/data/mappers/resume_mapper.dart (converts between Model and Entity)
- [ ] T054 [P] Create datasource abstractions at lib/features/resume/data/datasources/resume_local_datasource.dart
- [ ] T055 Create datasource implementations (use SharedPreferences or in-memory for now)
- [ ] T056 Create ResumeRepositoryImpl at lib/features/resume/data/repositories/resume_repository_impl.dart

### Presentation Layer (Resume Feature) - Part A: State Management

- [ ] T057 Create ResumeBloc at lib/features/resume/presentation/bloc/resume_bloc.dart
- [ ] T058 [P] Create resume_event.dart with all events (LoadResume, UpdateField, SaveResume, AddWorkExperience, etc.)
- [ ] T059 [P] Create resume_state.dart with states (initial, loading, editing, saving, saved, error)
- [ ] T060 Migrate existing ResumeProvider from lib/providers/resume_provider.dart to lib/features/resume/presentation/provider/resume_provider.dart (keep for now; will be phased out)

### Presentation Layer (Resume Feature) - Part B: Pages & Widgets

- [ ] T061 Create TemplatePreviewPage at lib/features/resume/presentation/pages/template_preview_page.dart
- [ ] T062 Create EditorPage (resume editor) at lib/features/resume/presentation/pages/editor_page.dart
- [ ] T063 Create PdfPreviewPage at lib/features/resume/presentation/pages/pdf_preview_page.dart
- [ ] T064 [P] Create ResumeCanvas widget at lib/features/resume/presentation/widgets/resume_canvas.dart (displays editable resume)
- [ ] T065 [P] Create FormattingToolbar widget at lib/features/resume/presentation/widgets/formatting_toolbar.dart
- [ ] T066 [P] Create field editor widgets (FieldEditorCard, WorkExperienceEditor, SkillsEditor, etc.) at lib/features/resume/presentation/widgets/

### DI Registration (Resume Feature)

- [ ] T067 Create resume_injection.dart at lib/features/resume/resume_injection.dart
- [ ] T068 Update lib/config/di/injection_container.dart to call setupResumeFeature()

### Architecture Consistency Documentation

- [ ] T069 Create ARCHITECTURE_GUIDELINES.md at project root documenting:
  - Layer boundary rules (what each layer can import)
  - Naming conventions (PascalCase classes, snake_case files)
  - Folder organization requirements
  - Common violations and how to avoid them
  - Code review checklist for maintainers

### Integration

- [ ] T070 Update routes in lib/app.dart to use new resume feature pages
- [ ] T071 Run code generation: `flutter pub run build_runner build --delete-conflicting-outputs`

**Checkpoint**: Resume feature working; architecture guidelines defined; team can use PR review checklist

**Verification**:
```bash
flutter run  # App works, home → editor → preview flows functional
# Code structure validation:
find lib/features -name "*.dart" | xargs grep -l "import.*data.*models"  # Should only find data layer
find lib/features -name "*.dart" | xargs grep -l "import.*presentation.*bloc"  # Should NOT be in domain
# Run team checklist on resume feature code
```

---

## Phase 5: User Story 3 - Cross-Feature Dependencies & Tracing (Priority: P2)

**Goal**: Establish patterns for cross-feature communication and verify dependency structure

**Independent Test**: Developer can trace service usage across features; no circular dependencies; common patterns documented

**Duration**: 1-1.5 hours

### Cross-Feature Communication Patterns

- [ ] T072 Create lib/shared/services/ directory for cross-feature services (if needed)
- [ ] T073 Document cross-feature communication patterns in ARCHITECTURE_GUIDELINES.md:
  - How to safely share domain entities across features
  - When to use shared services vs feature-specific services
  - Avoiding circular dependencies
  - Example: Home → selects template → Resume uses template

### Dependency Verification Tools

- [ ] T074 Create scripts/check_dependencies.dart script to detect:
  - Circular dependencies between features
  - Presentation importing data models
  - Bypass of repository pattern (direct datasource access)
  - Cross-feature imports outside domain layer

- [ ] T075 Add dependency check to CI/CD pipeline (update .github/workflows if exists, or document manual check)

### Integration & Testing

- [ ] T076 Test cross-feature flow: Home selects template → passes to Resume feature → Resume renders with template
- [ ] T077 Run dependency check script: `dart scripts/check_dependencies.dart` (should pass with zero violations)
- [ ] T078 Add test scenario to ARCHITECTURE_GUIDELINES.md showing how to test cross-feature integration

**Checkpoint**: Cross-feature patterns defined, dependency structure verified, no circular references

**Verification**:
```bash
dart scripts/check_dependencies.dart  # No violations reported
# Manual verification:
find lib/features -name "*.dart" | xargs grep -l "features/.*data/"  # Should be empty or only cross-feature services
flutter run  # Template selection flows through to resume feature correctly
```

---

## Phase 6: User Story 4 - Onboarding & Documentation (Priority: P3)

**Goal**: Make it easy for new developers to understand and contribute to the project

**Independent Test**: New developer can read docs and create a small feature independently within 2-3 hours

**Duration**: 2-2.5 hours

### Documentation Creation

- [ ] T079 Create ONBOARDING.md at project root with sections:
  - Project structure overview (5 min read)
  - Layer separation explanation (how domain/data/presentation differ)
  - Where different types of code belong (decision tree)
  - How to add a new field to existing feature (step-by-step)
  - How to create a new feature from scratch (step-by-step)

- [ ] T080 Create STRUCTURE_REFERENCE.md with visual diagrams:
  - Folder hierarchy with descriptions
  - Layer dependency diagram (presentation → domain ← data)
  - Feature structure template (copy/paste reference)
  - Import rules cheat sheet

- [ ] T081 Create DEVELOPER_WORKFLOWS.md with common tasks:
  - "I want to add a new screen to home feature" (use quickstart.md Task 1)
  - "I want to create a new feature" (use quickstart.md Task 2)
  - "I want to understand where a bug is" (trace through layers)
  - "How do I run tests?" (flutter test commands)
  - "How do I run code generation?" (build_runner commands)

### Example Feature

- [ ] T082 Ensure quickstart.md is present in specs/ and linked from DEVELOPER_WORKFLOWS.md
- [ ] T083 Create example feature template at lib/features/.example_feature/ showing:
  - Correct folder structure
  - Example domain entity with @freezed
  - Example repository pattern
  - Example bloc with states/events
  - Example page and widgets
  - Example DI setup

### Validation

- [ ] T084 Test onboarding flow:
  - New developer reads ONBOARDING.md
  - Looks at example feature structure
  - Attempts to add a field to resume editor following quickstart.md
  - Code follows established patterns (can be validated with script from T074)

**Checkpoint**: Documentation complete; new developer can orient themselves within 1-2 hours

**Verification**:
```bash
# Documentation exists and is readable
ls -la docs/*ONBOARDING.md STRUCTURE_REFERENCE.md DEVELOPER_WORKFLOWS.md
# Example feature is properly structured
find lib/features/.example_feature -type f | wc -l  # Should have 10+ files
# New developer can follow example
# (Simulate by reading ONBOARDING.md and following steps)
```

---

## Phase 7: Import Cleanup & Migration

**Purpose**: Update all imports to reference new locations; remove duplicate code

**Duration**: 1-2 hours

### Import Updates (Critical Path)

- [ ] T085 Update all imports in resume feature pages that reference old lib/models/ to use lib/features/resume/domain/entities/
- [ ] T086 Update all imports in resume feature that reference old lib/providers/resume_provider.dart to use new location
- [ ] T087 [P] Find and update all screen imports from lib/screens/{home,editor,preview}/ to lib/features/{home,resume}/presentation/pages/
- [ ] T088 Update app.dart route imports to use new feature page paths
- [ ] T089 Update main.dart to import from new DI location
- [ ] T090 Find and replace any remaining references to old core/constants with new core/config or core/theme paths

### Unused Code Removal

- [ ] T091 Remove old lib/models/ directory (after verifying all code migrated to features)
- [ ] T092 Remove old lib/providers/ directory (after verifying all providers migrated to features)
- [ ] T093 Remove old lib/screens/ directory (after verifying all pages migrated to features)
- [ ] T094 Remove old lib/core/constants/ directory (moved to core/config and core/theme)

### Final Import Validation

- [ ] T095 Run `flutter analyze` to catch import errors (should show 0 errors)
- [ ] T096 Run `flutter pub run build_runner build --delete-conflicting-outputs` one final time
- [ ] T097 Search for any remaining old imports: `grep -r "lib/models\|lib/providers\|lib/screens" lib/` (should return empty)

**Checkpoint**: All imports updated, old directories removed, project builds successfully

**Verification**:
```bash
flutter analyze  # 0 errors
flutter pub run build_runner build --delete-conflicting-outputs  # Successful
grep -r "from 'package:app/models/" lib/  # Empty (no old imports)
flutter run  # App runs, all features work
```

---

## Phase 8: Testing & Validation

**Purpose**: Verify all functionality works post-refactoring; no regressions

**Duration**: 1.5-2 hours

### Functional Testing (Manual)

- [ ] T098 Test home feature: Can view templates, toggle favorite, navigate to template preview
- [ ] T099 Test resume editor: Can edit all fields, add/remove work experience, save changes
- [ ] T100 Test PDF preview: Can generate PDF with edited resume data
- [ ] T101 Test navigation: All routes work (home → template preview → editor → PDF preview)
- [ ] T102 Test state persistence: Close and reopen app, resume data persists

### Architecture Validation

- [ ] T103 Run dependency check script from T074: `dart scripts/check_dependencies.dart` (zero violations)
- [ ] T104 Verify layer boundaries:
  - `find lib/features -name "*.dart" -path "*/presentation/*" | xargs grep -l "import.*data/"` (should be empty or only data layer)
  - `find lib/features -name "*.dart" -path "*/domain/*" | xargs grep -l "import.*flutter"` (should be empty)
  
- [ ] T105 Code quality check:
  - `flutter analyze` (0 errors)
  - `dart format --set-exit-if-changed lib/` (all files formatted)

### Integration Testing

- [ ] T106 End-to-end flow test:
  - App starts → home shows templates
  - Select template → navigate to preview
  - Go to editor → edit resume fields
  - Save → navigate to PDF
  - PDF displays resume correctly with edits

**Checkpoint**: All features work as before; no regressions; architecture valid

**Verification**:
```bash
flutter analyze  # 0 errors
dart scripts/check_dependencies.dart  # 0 violations
flutter test  # All tests pass (if any exist)
flutter run -v  # App launches successfully
```

---

## Phase 9: Documentation & Handoff

**Purpose**: Document decisions, patterns, and future migration path

**Duration**: 45 minutes - 1 hour

### Architecture Documentation

- [ ] T107 Create REFACTORING_SUMMARY.md documenting:
  - What changed (old structure → new structure)
  - Why each change was made (alignment with Constitution, team scalability)
  - Migration path for remaining work (Bloc adoption in Phase 2+, GoRouter in Phase 2+)
  - Breaking changes (none for end users, but import structure different)

- [ ] T108 Create FUTURE_IMPROVEMENTS.md with:
  - Phase 2+ migration: Provider → Flutter Bloc (when freezed is stable)
  - Phase 2+ routing: MaterialApp routes → GoRouter → auto_route
  - Performance optimizations: Build scope reduction, caching
  - Testing improvements: Unit tests for Blocs, widget tests for screens
  - Feature expansion guidelines

### Team Communication

- [ ] T109 Update README.md with new project structure overview
- [ ] T110 Create or update CONTRIBUTING.md with:
  - Where to find architecture guidelines
  - How to add a new feature (reference ONBOARDING.md)
  - Code review checklist (reference ARCHITECTURE_GUIDELINES.md)
  - Common pitfalls and how to avoid them

### Final Checklist

- [ ] T111 Verify all generated documentation files:
  - ✅ ONBOARDING.md (new developer guide)
  - ✅ ARCHITECTURE_GUIDELINES.md (team standards)
  - ✅ STRUCTURE_REFERENCE.md (visual reference)
  - ✅ DEVELOPER_WORKFLOWS.md (common tasks)
  - ✅ REFACTORING_SUMMARY.md (what changed and why)
  - ✅ FUTURE_IMPROVEMENTS.md (next steps)

- [ ] T112 Final repo cleanup:
  - Remove any commented code or TODOs from migration
  - Commit organization: one logical commit per phase (or per major feature)
  - No merge conflicts; main branch is clean

**Checkpoint**: All documentation complete; team is ready to contribute; future work is clearly outlined

**Verification**:
```bash
ls -la *.md  # All docs exist
grep -l "Architecture\|Onboarding\|Structure\|Workflow" *.md  # All key docs present
git log --oneline -20  # Recent commits show logical grouping
```

---

## Dependencies & Execution Order

### Phase Sequencing (CRITICAL)

```
Phase 1: Setup
    ↓ (must complete before Phase 2)
Phase 2: Foundational ← BLOCKER for all user stories
    ↓ (must complete before user stories)
Phase 3: US1 (P1) ← MVP - Stop here for initial release
    ↓ (parallel possible, sequential recommended for stability)
Phase 4: US2 (P2)
    ↓ (parallel possible)
Phase 5: US3 (P2)
    ↓
Phase 6: US4 (P3)
    ↓
Phase 7: Import Cleanup
    ↓
Phase 8: Testing & Validation
    ↓
Phase 9: Documentation
```

### User Story Execution Order

**Recommended sequence** (for team of 1-2 developers):

1. **Complete Phase 1 & 2** together (setup + foundational) — ~2 hours
2. **Complete Phase 3** (US1: Home feature) — ~2 hours — **STOP AND TEST (MVP ready)**
3. **Complete Phase 4** (US2: Resume feature) — ~4 hours
4. **Complete Phase 5** (US3: Dependencies) — ~1.5 hours
5. **Complete Phase 6** (US4: Onboarding) — ~2 hours
6. **Complete Phase 7-9** (cleanup, testing, docs) — ~3.5 hours

**Total estimated time**: 14-16 hours (1-2 developer days)

### Parallel Opportunities (if team available)

After Phase 2 completion, could run in parallel:
- Developer A: Phase 3 (US1 Home feature) + Phase 4 Part A (Domain layer)
- Developer B: Phase 4 Part B (Presentation layer) + Phase 5 (Dependencies)
- Developer C: Phase 6 (Documentation) + Phase 9 (Final docs)

Then reconverge for Phase 7-8 (cleanup, testing, validation)

---

## Implementation Strategy

### MVP First (Recommended)

✅ **Phase 1-3 Only** (Complete in ~4-5 hours)
- Setup + Foundational + Home feature working
- **STOP** and validate the pattern
- Get team feedback before proceeding
- Commit, test, demo to stakeholders
- **Deploy if ready** (though incomplete)

### Incremental Delivery

✅ **Phase 1-3**: MVP - Home feature discoverable, architecture pattern clear  
✅ **Phase 1-4**: Resume feature complete, all screens migrated  
✅ **Phase 1-5**: Cross-feature dependencies validated and documented  
✅ **Phase 1-6**: New developers can onboard independently  
✅ **Phase 1-9**: Full refactoring complete, all docs finalized  

### Team Coordination

**Single Developer**: Follow recommended sequence (Phases 1-9 in order)

**Two Developers**:
- Dev 1: Phases 1-3 (setup + home feature)
- Dev 2: Phases 4-6 (resume + docs) in parallel
- Both: Phases 7-9 (cleanup, testing, validation) together

**Three+ Developers**:
- After Phase 2, run all user story phases in parallel
- Reconverge for cleanup and validation

---

## Blockers & Risks

### Known Blockers

- **T010 blocks all code gen tasks**: Must configure build.yaml correctly
- **T014 blocks all DI-dependent tasks**: Injection container must be initialized
- **T020 blocks route-dependent tasks**: Route structure must be defined
- **Phase 2 blocks all user stories**: Must complete foundational before proceeding

### Risk Mitigation

| Risk | Mitigation | Task |
|------|-----------|------|
| Code generation fails | Test after T013 with `flutter pub run build_runner build` | T013 |
| DI not resolving | Verify setup with simple test (GetIt.I.get<DioClient>()) | T017 |
| Circular dependencies | Run check script from T074 frequently | T074-T075 |
| Import conflicts | Update all imports in single phase (T085-T090) | T085-T090 |
| Regressions in features | Test each feature independently (T098-T102) | T098-T102 |

---

## Success Criteria by Phase

### Phase 1 ✅
- [ ] New lib/features/, lib/core/, lib/config/, lib/shared/ directories created
- [ ] All dependencies installed successfully
- [ ] build.yaml configured and tested
- [ ] `flutter pub run build_runner build` completes with 0 errors

### Phase 2 ✅
- [ ] `flutter analyze` shows 0 errors
- [ ] DI container initializes without errors
- [ ] Route constants defined
- [ ] Core and shared modules organized
- [ ] First code generation successful (includes base classes)

### Phase 3 (US1) ✅
- [ ] Home feature compiles and runs
- [ ] Template list displays
- [ ] Toggle favorite works
- [ ] Developer can identify exact files and patterns used

### Phase 4 (US2) ✅
- [ ] Resume feature compiles and runs
- [ ] Editor shows all fields
- [ ] Save functionality works
- [ ] Architecture guidelines documented

### Phase 5 (US3) ✅
- [ ] Cross-feature flow works (template selection → resume)
- [ ] Dependency check script shows 0 violations
- [ ] Circular dependencies prevented by structure

### Phase 6 (US4) ✅
- [ ] ONBOARDING.md, STRUCTURE_REFERENCE.md created
- [ ] New developer can follow example
- [ ] Documentation is readable and accurate

### Phase 7 ✅
- [ ] Old lib/models/, lib/providers/, lib/screens/ removed
- [ ] All imports updated
- [ ] `flutter analyze` shows 0 errors

### Phase 8 ✅
- [ ] All manual tests pass
- [ ] No regressions observed
- [ ] Architecture validation clean

### Phase 9 ✅
- [ ] All documentation complete and linked
- [ ] Team is prepared for future work
- [ ] Commit history is clean and logical

---

## Validation Checkpoints

After each phase, validate:

```bash
# After Phase 1 (Setup)
flutter pub get
flutter pub run build_runner build

# After Phase 2 (Foundational)
flutter analyze  # 0 errors expected
dart scripts/check_dependencies.dart  # Will be added in T074

# After Phase 3 (US1: Home)
flutter run  # Should launch successfully
# Manual test: templates display, favorites toggle works

# After Phase 4 (US2: Resume)
flutter run  # All features work
# Manual test: home → select template → preview → editor → PDF

# After Phase 5 (US3: Dependencies)
dart scripts/check_dependencies.dart  # 0 violations
# Manual test: cross-feature flow works end-to-end

# After Phase 6 (US4: Onboarding)
ls docs/ONBOARDING.md  # Documentation exists

# After Phase 7 (Import Cleanup)
flutter analyze  # 0 errors
grep -r "lib/models" lib/  # Empty (no old imports)

# After Phase 8 (Testing)
flutter run  # App works
# Manual validation of all features

# After Phase 9 (Documentation)
grep -l "Architecture\|Onboarding\|Workflow" *.md  # All docs present
```

---

## Notes

- **[P] tasks**: Can run in parallel (different files, no dependencies)
- **[Story] labels**: Maps task to user story for traceability
- **Each user story**: Should be independently completable and testable
- **Commit strategy**: One commit per task or logical grouping (not one giant commit)
- **Testing**: Run tests after foundational phase completes; before user story completion
- **Documentation**: Review and refine incrementally (not all at end)

---

## Next Steps

1. **Review this task list** with team and stakeholders
2. **Assign tasks** to team members (or follow sequentially)
3. **Track progress** (checkboxes, commit references)
4. **Stop at Phase 3 checkpoint** (MVP) for team review
5. **Iterate Phases 4-6** based on feedback
6. **Complete Phases 7-9** for full refactoring

---

**Total Estimated Duration**: 14-16 hours (1-2 developer days)

**Recommended Start Date**: Next development sprint

**Expected Completion**: Within 2-3 days of focused development

**Blockers**: None identified - Phase 2 must complete before user stories begin

---

**Status**: ✅ READY FOR IMPLEMENTATION

**Last Updated**: 2026-05-19

**Approved By**: [Team/Lead Review]
