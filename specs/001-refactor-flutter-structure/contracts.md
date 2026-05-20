# Architecture Contracts: Layer Boundaries & Feature Structure

**Date**: 2026-05-19  
**Feature**: Refactor Flutter Project Structure

---

## Contract 1: Layer Boundary Contract

Defines what each layer may import and export. Enforces dependency direction: **Presentation → Domain ← Data**.

### Presentation Layer (Blocs/Providers/Pages/Widgets)

**May Import**:
- Own feature's domain layer (repositories, entities, usecases)
- Own feature's presentation layer (pages, widgets, blocs, providers)
- `core/` (config, constants, theme, utils, extensions)
- `shared/` (widgets, utilities)
- Flutter framework (material, widgets, provider)
- `flutter_bloc` package

**Must NOT Import**:
- Own feature's data layer (models, datasources, mappers)
- Other features' data layers
- Other features' presentation layers (communicate via domain repository only)
- Raw Dio, database packages

**Example Violation** ❌:
```dart
// ❌ BAD: Presentation importing data model directly
import 'package:app/features/resume/data/models/resume_document_model.dart';
```

**Example Correct** ✅:
```dart
// ✅ GOOD: Presentation importing domain entity
import 'package:app/features/resume/domain/entities/resume_document.dart';
```

---

### Domain Layer (Entities, Usecases, Repositories)

**May Import**:
- Other domain entities within same feature
- Flutter basics only (if absolutely necessary: exceptions, annotations)
- Dart standard library
- Third-party libraries that are framework-agnostic (e.g., dartz for Either)

**Must NOT Import**:
- Flutter widgets or UI classes (Material, Scaffold, BuildContext)
- `provider` or `flutter_bloc` packages (no state management)
- Data layer (models, datasources, mappers)
- Presentation layer
- Any feature's code except domain

**Example Violation** ❌:
```dart
// ❌ BAD: Domain importing UI framework
import 'package:flutter/material.dart';
```

**Example Correct** ✅:
```dart
// ✅ GOOD: Domain uses plain Dart exceptions
class ResumeException implements Exception {
  final String message;
  ResumeException(this.message);
}
```

---

### Data Layer (Models, Datasources, Repositories)

**May Import**:
- Own feature's domain layer (repositories for implementation, entities for mapping targets)
- Other features' domain layers (if cross-feature data sharing needed)
- `core/` (network, error handling, services)
- `shared/` (utilities, models)
- Data libraries (Dio, database packages, json_serializable)
- Freezed, json annotations

**Must NOT Import**:
- Presentation layer (pages, widgets, blocs)
- Flutter UI framework
- `provider` or `flutter_bloc`

**Example Violation** ❌:
```dart
// ❌ BAD: Data layer returning UI directly
ResumeDocument loadResume() {
  return ResumeDocument.fromJson(json);
}
```

**Example Correct** ✅:
```dart
// ✅ GOOD: Data returns mapped domain entity
Future<ResumeDocument> loadResume() async {
  final model = await _remoteDataSource.fetchResume();
  return ResumeDocumentMapper.toDomain(model);
}
```

---

## Contract 2: Feature Structure Contract

Every feature MUST follow this directory layout and DI pattern.

### Directory Structure

```
features/feature_name/
├── presentation/
│   ├── pages/
│   │   ├── feature_page.dart          # Main page (StatelessWidget)
│   │   └── feature_detail_page.dart   # Detail page (if applicable)
│   ├── widgets/
│   │   ├── feature_widget.dart        # Reusable widgets
│   │   ├── feature_card.dart
│   │   └── feature_dialog.dart
│   ├── bloc/
│   │   ├── feature_bloc.dart          # Bloc class
│   │   ├── feature_event.dart         # Events (if using Bloc)
│   │   └── feature_state.dart         # States
│   └── provider/
│       └── feature_provider.dart      # Provider class (if using Provider)
│
├── data/
│   ├── datasources/
│   │   ├── feature_local_datasource.dart    # Local persistence
│   │   └── feature_remote_datasource.dart   # Remote API
│   ├── models/
│   │   ├── feature_model.dart         # DTO with @freezed
│   │   └── nested_model.dart          # Nested DTOs
│   ├── repositories/
│   │   └── feature_repository_impl.dart    # Repository implementation
│   └── mappers/
│       └── feature_mapper.dart        # Entity ↔ Model mapping
│
├── domain/
│   ├── entities/
│   │   ├── feature_entity.dart        # Domain entity with @freezed
│   │   └── nested_entity.dart         # Nested domain entities
│   ├── repositories/
│   │   └── feature_repository.dart    # Repository abstract class
│   └── usecases/
│       ├── get_feature.dart           # Usecase: fetch
│       ├── create_feature.dart        # Usecase: create
│       └── update_feature.dart        # Usecase: update
│
└── feature_injection.dart             # DI entry point for this feature
```

### Naming Conventions

| Artifact | Pattern | Example |
|----------|---------|---------|
| Entity class | `{Feature}Entity` | `ResumeDocument` |
| Model class | `{Feature}Model` or `{Feature}Dto` | `ResumeDocumentModel` |
| Page/Screen | `{Feature}Page` | `ResumePage` |
| Widget | `{Feature}Widget` or descriptive | `ResumeCanvas` |
| Bloc | `{Feature}Bloc` | `ResumeBloc` |
| Repository interface | `I{Feature}Repository` | `IResumeRepository` |
| Repository impl | `{Feature}RepositoryImpl` | `ResumeRepositoryImpl` |
| Datasource | `{Feature}{Local\|Remote}Datasource` | `ResumeRemoteDatasource` |
| Mapper | `{Feature}Mapper` | `ResumeMapper` |
| File names | `snake_case.dart` | `resume_document.dart` |

---

### DI Entry Point (feature_injection.dart)

Each feature MUST have a **feature_injection.dart** file that exports all dependencies needed by other features or the presentation layer:

```dart
// features/resume/resume_injection.dart
part of 'package:app/config/di/injection_container.dart';

// Step 1: Register datasources
_registerResumeDatasources() {
  getIt.registerSingleton<IResumeLocalDatasource>(
    ResumeLocalDatasource(getIt()),
  );
  getIt.registerSingleton<IResumeRemoteDatasource>(
    ResumeRemoteDatasource(getIt()),
  );
}

// Step 2: Register repositories
_registerResumeRepositories() {
  getIt.registerSingleton<IResumeRepository>(
    ResumeRepositoryImpl(
      localDatasource: getIt(),
      remoteDatasource: getIt(),
    ),
  );
}

// Step 3: Register usecases
_registerResumeUsecases() {
  getIt.registerSingleton(LoadResume(getIt()));
  getIt.registerSingleton(SaveResume(getIt()));
}

// Step 4: Register BLoCs/Providers
_registerResumeBlocs() {
  getIt.registerSingleton(ResumeBloc(getIt(), getIt(), getIt()));
}

// Main entry point
void setupResumeFeature() {
  _registerResumeDatasources();
  _registerResumeRepositories();
  _registerResumeUsecases();
  _registerResumeBlocs();
}
```

---

## Contract 3: Bloc/Provider Pattern Contract

Defines state shape, event handling, and side effect orchestration.

### Bloc Pattern (Recommended for Complex Features)

**State Shape** (with Freezed):
```dart
@freezed
abstract class ResumeState with _$ResumeState {
  const factory ResumeState.initial() = _Initial;
  const factory ResumeState.loading() = _Loading;
  const factory ResumeState.loaded(ResumeDocument document) = _Loaded;
  const factory ResumeState.saving() = _Saving;
  const factory ResumeState.saved() = _Saved;
  const factory ResumeState.error(String message) = _Error;
}
```

**Event Shape** (with Freezed):
```dart
@freezed
abstract class ResumeEvent with _$ResumeEvent {
  const factory ResumeEvent.loadResume(String id) = _LoadResume;
  const factory ResumeEvent.updateField(String fieldId, String value) = _UpdateField;
  const factory ResumeEvent.saveResume() = _SaveResume;
  const factory ResumeEvent.deleteResume() = _DeleteResume;
}
```

**Bloc Implementation Rules**:
1. **Thin presentation**: Bloc handles orchestration, not business logic
2. **Usecases in constructor**: Bloc calls injected usecases, never directly calls datasources
3. **Error mapping**: Convert data-layer exceptions to domain-safe failures
4. **Side effects**: Use stream.listen() or emit() for navigation/snackbars

**Example**:
```dart
class ResumeBloc extends Bloc<ResumeEvent, ResumeState> {
  final LoadResume loadResume;
  final SaveResume saveResume;
  
  ResumeBloc(this.loadResume, this.saveResume) : super(const ResumeState.initial()) {
    on<_LoadResume>((event, emit) async {
      emit(const ResumeState.loading());
      final result = await loadResume(event.id);
      result.fold(
        (failure) => emit(ResumeState.error(failure.message)),
        (document) => emit(ResumeState.loaded(document)),
      );
    });
  }
}
```

---

### Provider Pattern (For Simpler Features)

**Provider Structure** (with Freezed for state):
```dart
class HomeProvider extends ChangeNotifier {
  List<ResumeTemplate> _templates = [];
  
  List<ResumeTemplate> get templates => _templates;
  
  Future<void> loadTemplates() async {
    final result = await _getTemplatesUsecase();
    result.fold(
      (failure) { /* emit error */ },
      (templates) {
        _templates = templates;
        notifyListeners();
      },
    );
  }
}
```

---

## Contract 4: Import Organization Contract

Define which imports are permitted in each layer to maintain boundaries.

### Presentation Layer
```dart
// ✅ ALLOWED
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/config/app_routes.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/shared/widgets/app_button.dart';
import 'package:app/features/resume/domain/entities/resume_document.dart';
import 'package:app/features/resume/presentation/bloc/resume_bloc.dart';

// ❌ NOT ALLOWED
import 'package:app/features/resume/data/models/resume_document_model.dart';  // Use entity
import 'package:app/features/resume/data/datasources/...';                   // No data access
import 'package:dio/dio.dart';                                                // No raw networking
```

### Domain Layer
```dart
// ✅ ALLOWED
import 'package:app/features/resume/domain/entities/resume_document.dart';
import 'package:dartz/dartz.dart';  // For Either/Result pattern

// ❌ NOT ALLOWED
import 'package:flutter/material.dart';     // No UI
import 'package:provider/provider.dart';    // No state management
import 'package:dio/dio.dart';              // No networking
import 'package:app/features/resume/data/...';  // No data layer
```

### Data Layer
```dart
// ✅ ALLOWED
import 'package:dio/dio.dart';
import 'package:app/features/resume/domain/entities/resume_document.dart';
import 'package:app/features/resume/data/models/resume_document_model.dart';
import 'package:app/core/network/dio_client.dart';

// ❌ NOT ALLOWED
import 'package:flutter/material.dart';     // No UI
import 'package:provider/provider.dart';    // No state management
import 'package:app/features/resume/presentation/...';  // No presentation layer
```

---

## Enforcement Rules

These contracts are **mandatory** and subject to code review:

1. **Layer Boundary Violations**: Flagged as blocker in PR review
2. **Freezed Generation**: All entities and models MUST use @freezed
3. **Repository Pattern**: Data access ONLY through repositories
4. **DI Injection**: All dependencies via constructor injection + GetIt
5. **Naming Convention**: Snake_case files, PascalCase classes
6. **Feature Isolation**: No cross-feature imports except through domain

---

## Contract Summary ✅

This contract ensures:
- ✅ Predictable dependency flow (Presentation → Domain ← Data)
- ✅ Feature isolation and easy removal
- ✅ Testable code (easy to mock dependencies)
- ✅ Scalable architecture (new features follow same pattern)
- ✅ Team consistency (all developers follow same rules)
