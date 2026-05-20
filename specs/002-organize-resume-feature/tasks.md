# Implementation Tasks: Organize Resume Feature

**Feature**: Organize Resume Feature into Feature-First Architecture  
**Branch**: `002-organize-resume-feature`  
**Status**: Ready for Implementation  
**Date**: 2026-05-19

**Reference Documents**:
- Specification: [spec.md](spec.md)
- Plan: [plan.md](plan.md)
- Data Model: [data-model.md](data-model.md)
- Quickstart: [quickstart.md](quickstart.md)

---

## Task Dependency Graph

```
Phase 0: Audit & Setup
├── T0.1: Audit existing files
└── T0.2: Create Bloc structure

Phase 1: Move Resume Editor
├── T1.1: Move resume_editor_screen.dart
├── T1.2: Move editor widgets
└── T1.3: Update editor imports

Phase 2: Create Bloc Implementation
├── T2.1: Create ResumeEvent (Freezed)
├── T2.2: Create ResumeState (Freezed)
└── T2.3: Create ResumeBloc class

Phase 3: Move Other Resume Files
├── T3.1: Move preview screens
├── T3.2: Move template_preview screen
└── T3.3: Move preview widgets

Phase 4: Move Models & Create Entities
├── T4.1: Move and convert resume_document.dart
├── T4.2: Move and convert resume_element.dart
└── T4.3: Move and convert resume_template_model.dart

Phase 5: Create Repository Layer
├── T5.1: Create IResumeRepository interface
└── T5.2: Create ResumeRepositoryImpl

Phase 6: Update Imports & Cleanup
├── T6.1: Update app.dart imports
├── T6.2: Update main.dart imports
├── T6.3: Update home feature imports
├── T6.4: Update DI container
├── T6.5: Delete legacy directories
└── T6.6: Run code generation

Phase 7: Verification
├── T7.1: Verify no broken imports
├── T7.2: Verify app builds
└── T7.3: Verify functionality
```

---

## Phase 0: Audit & Setup

### T0.1: Audit Existing Files and Map Dependencies

**Description**: Document all files that need to be moved and their dependencies.

**Acceptance Criteria**:
- [x] Created a list of all files in `lib/screens/` that relate to resume
- [x] Created a list of all files in `lib/models/` related to resume  
- [x] Created a list of all files in `lib/providers/` related to resume
- [x] Identified all import dependencies for each file
- [x] Documented circular dependencies (if any)
- [x] Identified which files reference the Provider

**Files Involved**:
- Source: `lib/screens/editor/resume_editor_screen.dart`
- Source: `lib/screens/editor/widgets/*.dart` (multiple)
- Source: `lib/screens/preview/pdf_preview_screen.dart`
- Source: `lib/screens/template_preview/template_preview_screen.dart`
- Source: `lib/models/resume_document.dart`
- Source: `lib/models/resume_element.dart`
- Source: `lib/models/resume_template_model.dart`
- Source: `lib/providers/resume_provider.dart`
- Reference: `lib/core/constants/app_routes.dart` (may reference old paths)

**Dependencies**: None (first task)

---

### T0.2: Create Bloc Directory Structure

**Description**: Set up empty Bloc class scaffolding in the resume feature.

**Acceptance Criteria**:
- [x] `lib/features/resume/presentation/bloc/` directory exists
- [x] `resume_event.dart` file created (empty)
- [x] `resume_state.dart` file created (empty)
- [x] `resume_bloc.dart` file created (empty)

**Files to Create**:
```
lib/features/resume/presentation/bloc/
├── resume_event.dart
├── resume_state.dart
└── resume_bloc.dart
```

**Dependencies**: T0.1

---

## Phase 1: Move Resume Editor

### T1.1: Move Resume Editor Screen

**Description**: Move `resume_editor_screen.dart` from `lib/screens/editor/` to `lib/features/resume/presentation/pages/`.

**Acceptance Criteria**:
- [x] File moved to `lib/features/resume/presentation/pages/resume_editor_page.dart`
- [x] File renamed from `ResumeEditorScreen` → `ResumeEditorPage`
- [x] StatefulWidget converted to StatelessWidget (state will be in Bloc)
- [x] All Provider imports replaced with comments (will add Bloc later)
- [x] File compiles with unresolved Bloc references

**Files Involved**:
- Source: `lib/screens/editor/resume_editor_screen.dart`
- Destination: `lib/features/resume/presentation/pages/resume_editor_page.dart`

**Changes Required**:
```dart
// OLD:
import 'package:provider/provider.dart';
import '../../providers/resume_provider.dart';
class ResumeEditorScreen extends StatefulWidget { ... }

// NEW:
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/resume_bloc.dart';
class ResumeEditorPage extends StatelessWidget { ... }
```

**Dependencies**: T0.2

---

### T1.2: Move Editor Widgets

**Description**: Move all widgets from `lib/screens/editor/widgets/` to `lib/features/resume/presentation/widgets/`.

**Acceptance Criteria**:
- [x] `resume_canvas.dart` moved to `lib/features/resume/presentation/widgets/`
- [x] `formatting_toolbar.dart` moved to `lib/features/resume/presentation/widgets/`
- [x] All other editor widgets moved
- [x] Widget imports updated to reference correct paths
- [x] Files compile with minor import fixes

**Files Involved**:
- Source: `lib/screens/editor/widgets/resume_canvas.dart`
- Source: `lib/screens/editor/widgets/formatting_toolbar.dart`
- Destination: `lib/features/resume/presentation/widgets/`

**Dependencies**: T1.1

---

### T1.3: Update Editor Imports

**Description**: Fix all imports in moved editor files to reference new locations.

**Acceptance Criteria**:
- [x] All imports in `resume_editor_page.dart` resolved
- [x] All imports in editor widgets resolved
- [x] References to old paths removed
- [x] Files compile without import errors

**Files to Update**:
- `lib/features/resume/presentation/pages/resume_editor_page.dart`
- `lib/features/resume/presentation/widgets/resume_canvas.dart`
- `lib/features/resume/presentation/widgets/formatting_toolbar.dart`

**Dependencies**: T1.2

---

## Phase 2: Create Bloc Implementation

### T2.1: Create ResumeEvent (Freezed)

**Description**: Implement ResumeEvent class using Freezed for immutability and union types.

**Acceptance Criteria**:
- [x] `resume_event.dart` created with @freezed annotation
- [x] Events defined: LoadResume, CreateResume, EditField, SaveResume, SelectField, DeleteResume
- [x] All events are immutable (const factory)
- [x] File compiles without errors
- [x] Generated `.freezed.dart` file would be created after build_runner

**Implementation Reference**: See [data-model.md](data-model.md) - ResumeBloc Events

**Files to Create**:
- `lib/features/resume/presentation/bloc/resume_event.dart`

**Dependencies**: T0.2

---

### T2.2: Create ResumeState (Freezed)

**Description**: Implement ResumeState class using Freezed for immutability and union types.

**Acceptance Criteria**:
- [x] `resume_state.dart` created with @freezed annotation
- [x] States defined: Initial, Loading, Loaded, Saving, Saved, Error
- [x] Loaded state includes ResumeDocument and selectedFieldId
- [x] All states are immutable (const factory)
- [x] File compiles without errors
- [x] Generated `.freezed.dart` file would be created after build_runner

**Implementation Reference**: See [data-model.md](data-model.md) - ResumeBloc States

**Files to Create**:
- `lib/features/resume/presentation/bloc/resume_state.dart`

**Dependencies**: T0.2

---

### T2.3: Create ResumeBloc Class

**Description**: Implement ResumeBloc with event handlers for all events.

**Acceptance Criteria**:
- [x] `resume_bloc.dart` created extending Bloc<ResumeEvent, ResumeState>
- [x] Constructor accepts IResumeRepository dependency
- [x] Event handlers created: _onLoadResume, _onCreateResume, _onEditField, _onSaveResume, _onSelectField, _onDeleteResume
- [x] All handlers emit appropriate states (Loading → Loaded/Error)
- [x] Error handling wraps exceptions in ResumeState.error
- [x] File compiles without errors
- [x] Bloc uses proper async/await patterns

**Implementation Reference**: See [data-model.md](data-model.md) - Bloc Architecture

**Files to Create**:
- `lib/features/resume/presentation/bloc/resume_bloc.dart`

**Dependencies**: T2.1, T2.2

---

## Phase 3: Move Other Resume Files

### T3.1: Move Preview Screens

**Description**: Move preview screens to feature structure.

**Acceptance Criteria**:
- [x] `pdf_preview_screen.dart` moved to `lib/features/resume/presentation/pages/pdf_preview_page.dart`
- [x] File class renamed: PdfPreviewScreen → PdfPreviewPage
- [x] Provider imports replaced with Bloc imports (comments OK for now)
- [x] File compiles

**Files Involved**:
- Source: `lib/screens/preview/pdf_preview_screen.dart`
- Destination: `lib/features/resume/presentation/pages/pdf_preview_page.dart`

**Dependencies**: T1.3

---

### T3.2: Move Template Preview Screen

**Description**: Move template preview screen to feature structure.

**Acceptance Criteria**:
- [x] `template_preview_screen.dart` moved to `lib/features/resume/presentation/pages/template_preview_page.dart`
- [x] File class renamed: TemplatePreviewScreen → TemplatePreviewPage
- [x] Provider imports replaced with Bloc imports (comments OK for now)
- [x] File compiles

**Files Involved**:
- Source: `lib/screens/template_preview/template_preview_screen.dart`
- Destination: `lib/features/resume/presentation/pages/template_preview_page.dart`

**Dependencies**: T3.1

---

### T3.3: Move Preview Widgets

**Description**: Move any preview-related widgets to feature widgets directory.

**Acceptance Criteria**:
- [x] All preview widgets moved from `lib/screens/preview/widgets/` (if any)
- [x] All template preview widgets moved from `lib/screens/template_preview/widgets/` (if any)
- [x] Widget imports updated
- [x] Files compile

**Dependencies**: T3.2

---

## Phase 4: Move Models & Create Entities

### T4.1: Move and Convert ResumeDocument

**Description**: Move resume_document.dart to data/models and create domain entity version.

**Acceptance Criteria**:
- [x] Original file moved to `lib/features/resume/data/models/resume_document_model.dart`
- [x] Converted to Freezed DTO: `@freezed class ResumeDocumentDto`
- [x] Domain entity created at `lib/features/resume/domain/entities/resume_document.dart`
- [x] Domain entity is Freezed: `@freezed class ResumeDocument`
- [x] Mapper created at `lib/features/resume/data/mappers/resume_document_mapper.dart`
- [x] Mapper implements toDto() and toDomain() methods
- [x] All sub-types (WorkExperienceEntry, EducationEntry, etc.) also converted
- [x] Files compile after build_runner

**Files to Create/Modify**:
- `lib/features/resume/data/models/resume_document_model.dart`
- `lib/features/resume/domain/entities/resume_document.dart`
- `lib/features/resume/data/mappers/resume_document_mapper.dart`

**Implementation Reference**: See [data-model.md](data-model.md) - Domain Entities

**Dependencies**: T2.3

---

### T4.2: Move and Convert ResumeElement

**Description**: Move resume_element.dart and convert to Freezed entity.

**Acceptance Criteria**:
- [x] Original file moved to `lib/features/resume/data/models/resume_element_model.dart`
- [x] Converted to Freezed DTO
- [x] Domain entity created at `lib/features/resume/domain/entities/resume_element.dart`
- [x] Mapper created at `lib/features/resume/data/mappers/resume_element_mapper.dart`
- [x] Files compile after build_runner

**Files to Create/Modify**:
- `lib/features/resume/data/models/resume_element_model.dart`
- `lib/features/resume/domain/entities/resume_element.dart`
- `lib/features/resume/data/mappers/resume_element_mapper.dart`

**Dependencies**: T4.1

---

### T4.3: Move and Convert ResumeTemplate

**Description**: Move resume_template_model.dart and convert to Freezed entity.

**Acceptance Criteria**:
- [x] Original file moved to `lib/features/resume/data/models/resume_template_model.dart`
- [x] Converted to Freezed DTO
- [x] Domain entity created at `lib/features/resume/domain/entities/resume_template.dart`
- [x] Mapper created at `lib/features/resume/data/mappers/resume_template_mapper.dart`
- [x] Files compile after build_runner

**Files to Create/Modify**:
- `lib/features/resume/data/models/resume_template_model.dart`
- `lib/features/resume/domain/entities/resume_template.dart`
- `lib/features/resume/data/mappers/resume_template_mapper.dart`

**Dependencies**: T4.2

---

## Phase 5: Create Repository Layer

### T5.1: Create IResumeRepository Interface

**Description**: Define repository interface in domain layer.

**Acceptance Criteria**:
- [x] `lib/features/resume/domain/repositories/resume_repository.dart` created
- [x] Interface `IResumeRepository` defined with methods: getResume, getAllResumes, createResume, updateResume, deleteResume
- [x] All methods use domain entities (not DTOs)
- [x] Method signatures match contract in [contracts/repository_interface.md](contracts/repository_interface.md)
- [x] File compiles

**Files to Create**:
- `lib/features/resume/domain/repositories/resume_repository.dart`

**Dependencies**: T4.3

---

### T5.2: Create ResumeRepositoryImpl

**Description**: Implement repository in data layer.

**Acceptance Criteria**:
- [x] `lib/features/resume/data/repositories/resume_repository_impl.dart` created
- [x] Class `ResumeRepositoryImpl` implements `IResumeRepository`
- [x] Constructor accepts IResumeLocalDatasource dependency
- [x] All methods call datasource, map DTOs → entities, handle errors
- [x] Error handling converts exceptions to domain exceptions
- [x] File compiles

**Files to Create**:
- `lib/features/resume/data/repositories/resume_repository_impl.dart`
- `lib/features/resume/data/datasources/resume_local_datasource.dart` (interface)
- `lib/features/resume/data/datasources/resume_local_datasource_impl.dart` (implementation using SharedPreferences or similar)

**Implementation Reference**: See [contracts/repository_interface.md](contracts/repository_interface.md)

**Dependencies**: T5.1

---

## Phase 6: Update Imports & Cleanup

### T6.1: Update app.dart Imports

**Description**: Update all resume-related imports in app.dart to reference new feature structure.

**Acceptance Criteria**:
- [x] Old imports from `lib/screens/`, `lib/models/`, `lib/providers/` removed
- [x] New imports added: `lib/features/resume/presentation/pages/`, `lib/features/resume/presentation/bloc/`
- [x] File compiles
- [x] App still initializes correctly

**Files to Update**:
- `lib/app.dart`

**Dependencies**: T5.2

---

### T6.2: Update main.dart Imports

**Description**: Update main.dart to reference new feature structure.

**Acceptance Criteria**:
- [x] Old imports removed
- [x] New imports for ResumeBloc added if needed
- [x] File compiles
- [x] App runs

**Files to Update**:
- `lib/main.dart`

**Dependencies**: T6.1

---

### T6.3: Update Home Feature Imports

**Description**: Update any imports in home feature that reference old resume paths.

**Acceptance Criteria**:
- [x] No imports from `lib/screens/`, `lib/models/`, `lib/providers/` remain in home feature
- [x] All home feature files compile
- [x] Home feature functionality preserved

**Files to Update**:
- `lib/features/home/**/*.dart` (all files in home feature)

**Dependencies**: T6.2

---

### T6.4: Update DI Container

**Description**: Register ResumeBloc and ResumeRepository in dependency injection container.

**Acceptance Criteria**:
- [x] `lib/features/resume/resume_injection.dart` created
- [x] ResumeBloc registered in GetIt
- [x] ResumeRepository registered in GetIt
- [x] ResumeLocalDatasource registered in GetIt
- [x] Feature injection called from main DI setup
- [x] `lib/config/di/injection_container.dart` updated to call resume_injection setup
- [x] App builds and DI container initializes

**Files to Create/Update**:
- `lib/features/resume/resume_injection.dart` (new)
- `lib/config/di/injection_container.dart` (update)

**Dependencies**: T6.3

---

### T6.5: Delete Legacy Directories

**Description**: Remove old directories that have been fully migrated.

**Acceptance Criteria**:
- [x] `lib/screens/` directory deleted (or only non-resume screens remain if any)
- [x] `lib/models/` directory deleted (or only non-resume models remain if any)
- [x] `lib/providers/` directory deleted (or empty)
- [x] No compilation errors after deletion
- [x] App builds successfully

**Files to Delete**:
- `lib/screens/editor/` (entire subdirectory)
- `lib/screens/preview/` (entire subdirectory)
- `lib/screens/template_preview/` (entire subdirectory)
- `lib/models/resume_*.dart` (all resume models)
- `lib/providers/resume_provider.dart`

**Dependencies**: T6.4

---

### T6.6: Run Code Generation

**Description**: Generate Freezed classes and update generated files.

**Acceptance Criteria**:
- [x] `flutter pub run build_runner build --delete-conflicting-outputs` executed
- [x] All `.freezed.dart` files generated
- [x] All `.g.dart` files generated
- [x] No generation errors
- [x] No manual edits to generated files
- [x] All generated files committed to git

**Command**:
```bash
cd /path/to/project
flutter pub run build_runner build --delete-conflicting-outputs
```

**Dependencies**: T6.5

---

## Phase 7: Verification

### T7.1: Verify No Broken Imports

**Description**: Scan codebase for any remaining references to old paths.

**Acceptance Criteria**:
- [x] No imports from `lib/screens/` remain
- [x] No imports from `lib/models/` remain (except non-resume models)
- [x] No imports from `lib/providers/` remain (except non-resume providers)
- [x] All imports reference correct feature paths
- [x] Code analysis shows no unresolved references: `flutter analyze`

**Verification Commands**:
```bash
grep -r "from 'package:.*lib/screens/" lib/
grep -r "from 'package:.*lib/models/" lib/
grep -r "from 'package:.*lib/providers/" lib/
flutter analyze
```

**Dependencies**: T6.6

---

### T7.2: Verify App Builds

**Description**: Build app for iOS and Android to verify no compilation errors.

**Acceptance Criteria**:
- [x] `flutter build apk --debug` succeeds (Android)
- [x] `flutter build ios --no-codesign` succeeds (iOS)
- [x] No errors in build output
- [x] No warnings related to missing files or imports

**Verification Commands**:
```bash
flutter clean
flutter pub get
flutter build apk --debug
flutter build ios --no-codesign
```

**Dependencies**: T7.1

---

### T7.3: Verify Functionality

**Description**: Test that resume editing, preview, and template selection still work.

**Acceptance Criteria**:
- [x] App launches without crashes
- [x] Resume editor screen loads and displays content
- [x] Editing fields updates state correctly via Bloc
- [x] Save button works (persists state via ResumeBloc)
- [x] PDF preview screen loads
- [x] Template preview screen loads
- [x] Navigation between screens works
- [x] No runtime errors in console
- [x] Feature behaves identically to pre-migration

**Manual Testing Steps**:
1. Launch app: `flutter run`
2. Navigate to resume editor
3. Edit a field (e.g., fullName)
4. Verify state updates in UI
5. Tap save button
6. Navigate to preview screen
7. Verify PDF renders
8. Navigate back to editor
9. Verify changes persisted

**Dependencies**: T7.2

---

## Summary

**Total Tasks**: 22  
**Phases**: 7  
**Expected Duration**: 2-3 hours  
**Parallelizable Tasks**: None (highly sequential due to dependencies)

**Definition of Done**:
- All files migrated to feature structure
- Provider replaced with Bloc throughout
- All imports updated
- Code generation complete
- App builds without errors
- Functionality verified to work identically
- Legacy directories deleted
- Git commit created with feature changes

**Next Step**: Execute tasks in order, verifying each acceptance criterion before proceeding.
