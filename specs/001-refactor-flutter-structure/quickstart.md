# Quickstart: Using the New Architecture

**Date**: 2026-05-19  
**Feature**: Refactor Flutter Project Structure

---

## Quick Navigation

- [Task 1: Add a New Field to Resume](#task-1-add-a-new-field-to-resume)
- [Task 2: Create a New Feature](#task-2-create-a-new-feature)
- [Task 3: Run Code Generation](#task-3-run-code-generation)
- [Task 4: Test State Changes](#task-4-test-state-changes)
- [Task 5: Common Patterns](#task-5-common-patterns)

---

## Task 1: Add a New Field to Resume

### Scenario
You want to add a "LinkedIn URL" field to the resume editor.

### Steps

**Step 1: Add to Domain Entity**
```dart
// features/resume/domain/entities/resume_document.dart
@freezed
class ResumeDocument with _$ResumeDocument {
  const factory ResumeDocument({
    required String fullName,
    required String email,
    required String linkedinUrl,  // ← NEW
    required List<WorkExperience> workExperience,
    // ... other fields
  }) = _ResumeDocument;
}
```

**Step 2: Update Data Model**
```dart
// features/resume/data/models/resume_document_model.dart
@freezed
class ResumeDocumentModel with _$ResumeDocumentModel {
  const factory ResumeDocumentModel({
    required String fullName,
    required String email,
    required String linkedinUrl,  // ← NEW
    // ... other fields
  }) = _ResumeDocumentModel;

  factory ResumeDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$ResumeDocumentModelFromJson(json);
}
```

**Step 3: Update Mapper**
```dart
// features/resume/data/mappers/resume_mapper.dart
static ResumeDocument toDomain(ResumeDocumentModel model) {
  return ResumeDocument(
    fullName: model.fullName,
    email: model.email,
    linkedinUrl: model.linkedinUrl,  // ← NEW
    // ... map other fields
  );
}

static ResumeDocumentModel toModel(ResumeDocument entity) {
  return ResumeDocumentModel(
    fullName: entity.fullName,
    email: entity.email,
    linkedinUrl: entity.linkedinUrl,  // ← NEW
    // ... map other fields
  );
}
```

**Step 4: Create Editor Widget**
```dart
// features/resume/presentation/widgets/linkedin_url_editor.dart
class LinkedinUrlEditor extends StatelessWidget {
  final String value;
  final Function(String) onChanged;

  const LinkedinUrlEditor({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: 'LinkedIn URL',
        hintText: 'https://linkedin.com/in/yourprofile',
      ),
      onChanged: onChanged,
    );
  }
}
```

**Step 5: Add Editor Event & State**
```dart
// features/resume/presentation/bloc/resume_event.dart
@freezed
abstract class ResumeEvent with _$ResumeEvent {
  const factory ResumeEvent.updateLinkedinUrl(String url) = _UpdateLinkedinUrl;
}

// features/resume/presentation/bloc/resume_state.dart
@freezed
abstract class ResumeState with _$ResumeState {
  const factory ResumeState.editing(
    ResumeDocument document,
    String? selectedFieldId,
  ) = _Editing;
  // ... other states
}
```

**Step 6: Update Bloc Handler**
```dart
// features/resume/presentation/bloc/resume_bloc.dart
on<_UpdateLinkedinUrl>((event, emit) {
  final currentState = state as _Editing;
  final updated = currentState.document.copyWith(
    linkedinUrl: event.url,
  );
  emit(ResumeState.editing(updated, null));
  _saveResume(updated);
});
```

**Step 7: Use in Editor Page**
```dart
// features/resume/presentation/pages/editor_page.dart
BlocBuilder<ResumeBloc, ResumeState>(
  builder: (context, state) {
    if (state is _Editing) {
      return LinkedinUrlEditor(
        value: state.document.linkedinUrl,
        onChanged: (url) {
          context.read<ResumeBloc>().add(
            ResumeEvent.updateLinkedinUrl(url),
          );
        },
      );
    }
    return SizedBox();
  },
);
```

**Step 8: Run Code Generation**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Step 9: Test**
```bash
flutter run
```

---

## Task 2: Create a New Feature

### Scenario
You want to create a new "Templates" feature (separate from home).

### Steps

**Step 1: Create Directory Structure**
```bash
mkdir -p lib/features/templates/{presentation/{pages,widgets,bloc},data/{models,datasources,repositories,mappers},domain/{entities,repositories,usecases}}
```

**Step 2: Create Domain Entity**
```dart
// features/templates/domain/entities/template.dart
@freezed
class Template with _$Template {
  const factory Template({
    required String id,
    required String name,
    required String previewImage,
    @Default(false) bool isFavorite,
  }) = _Template;
}
```

**Step 3: Create Domain Repository Abstract**
```dart
// features/templates/domain/repositories/template_repository.dart
abstract class ITemplateRepository {
  Future<List<Template>> getTemplates();
  Future<void> toggleFavorite(String templateId);
}
```

**Step 4: Create Data Model**
```dart
// features/templates/data/models/template_model.dart
@freezed
class TemplateModel with _$TemplateModel {
  const factory TemplateModel({
    required String id,
    required String name,
    required String previewImage,
    required bool isFavorite,
  }) = _TemplateModel;

  factory TemplateModel.fromJson(Map<String, dynamic> json) =>
      _$TemplateModelFromJson(json);
}
```

**Step 5: Create Mapper**
```dart
// features/templates/data/mappers/template_mapper.dart
class TemplateMapper {
  static Template toDomain(TemplateModel model) {
    return Template(
      id: model.id,
      name: model.name,
      previewImage: model.previewImage,
      isFavorite: model.isFavorite,
    );
  }

  static TemplateModel toModel(Template entity) {
    return TemplateModel(
      id: entity.id,
      name: entity.name,
      previewImage: entity.previewImage,
      isFavorite: entity.isFavorite,
    );
  }
}
```

**Step 6: Create Datasource**
```dart
// features/templates/data/datasources/template_local_datasource.dart
abstract class ITemplateLocalDatasource {
  Future<List<TemplateModel>> getTemplates();
  Future<void> toggleFavorite(String templateId);
}

class TemplateLocalDatasource implements ITemplateLocalDatasource {
  // Implement with SharedPreferences or local database
}
```

**Step 7: Create Repository Implementation**
```dart
// features/templates/data/repositories/template_repository_impl.dart
class TemplateRepositoryImpl implements ITemplateRepository {
  final ITemplateLocalDatasource localDatasource;

  TemplateRepositoryImpl(this.localDatasource);

  @override
  Future<List<Template>> getTemplates() async {
    final models = await localDatasource.getTemplates();
    return models.map((m) => TemplateMapper.toDomain(m)).toList();
  }

  @override
  Future<void> toggleFavorite(String templateId) async {
    await localDatasource.toggleFavorite(templateId);
  }
}
```

**Step 8: Create Usecase**
```dart
// features/templates/domain/usecases/get_templates.dart
class GetTemplates {
  final ITemplateRepository repository;

  GetTemplates(this.repository);

  Future<List<Template>> call() => repository.getTemplates();
}
```

**Step 9: Create Bloc**
```dart
// features/templates/presentation/bloc/templates_bloc.dart
@freezed
abstract class TemplatesEvent with _$TemplatesEvent {
  const factory TemplatesEvent.loadTemplates() = _LoadTemplates;
}

@freezed
abstract class TemplatesState with _$TemplatesState {
  const factory TemplatesState.initial() = _Initial;
  const factory TemplatesState.loading() = _Loading;
  const factory TemplatesState.loaded(List<Template> templates) = _Loaded;
  const factory TemplatesState.error(String message) = _Error;
}

class TemplatesBloc extends Bloc<TemplatesEvent, TemplatesState> {
  final GetTemplates getTemplates;

  TemplatesBloc(this.getTemplates) : super(const TemplatesState.initial()) {
    on<_LoadTemplates>((event, emit) async {
      emit(const TemplatesState.loading());
      try {
        final templates = await getTemplates();
        emit(TemplatesState.loaded(templates));
      } catch (e) {
        emit(TemplatesState.error(e.toString()));
      }
    });
  }
}
```

**Step 10: Create Page**
```dart
// features/templates/presentation/pages/templates_page.dart
class TemplatesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TemplatesBloc(
        context.read<GetTemplates>(),
      )..add(const TemplatesEvent.loadTemplates()),
      child: TemplatesView(),
    );
  }
}

class TemplatesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Templates')),
      body: BlocBuilder<TemplatesBloc, TemplatesState>(
        builder: (context, state) {
          if (state is _Loading) return Center(child: CircularProgressIndicator());
          if (state is _Loaded) {
            return ListView.builder(
              itemCount: state.templates.length,
              itemBuilder: (context, index) {
                final template = state.templates[index];
                return TemplateCard(template: template);
              },
            );
          }
          if (state is _Error) return Center(child: Text(state.message));
          return SizedBox();
        },
      ),
    );
  }
}
```

**Step 11: Create Feature Injection**
```dart
// features/templates/templates_injection.dart
void setupTemplatesFeature(GetIt getIt) {
  // Datasources
  getIt.registerSingleton<ITemplateLocalDatasource>(
    TemplateLocalDatasource(),
  );

  // Repositories
  getIt.registerSingleton<ITemplateRepository>(
    TemplateRepositoryImpl(getIt()),
  );

  // Usecases
  getIt.registerSingleton(GetTemplates(getIt()));

  // Bloc
  getIt.registerSingleton(TemplatesBloc(getIt()));
}
```

**Step 12: Register in Global DI**
```dart
// config/di/injection_container.dart
void setupDependencies() {
  setupHomeFeature(getIt);
  setupResumeFeature(getIt);
  setupTemplatesFeature(getIt);  // ← NEW
}
```

**Step 13: Add Route**
```dart
// config/routes/route_names.dart
abstract class AppRoutes {
  static const String templates = '/templates';
  // ...
}

// app.dart
routes: {
  AppRoutes.templates: (_) => TemplatesPage(),
  // ...
}
```

**Step 14: Run Code Generation**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Task 3: Run Code Generation

### When to Run
- After adding/modifying `@freezed` classes
- After adding `@JsonSerializable()` annotations
- After adding `@injectable()` or `@singleton()` annotations
- Before committing code

### Commands

```bash
# One-time build (recommended for CI/CD)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (for active development)
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean and rebuild
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Verify Generated Files
```bash
# Check that these exist after generation:
ls lib/features/resume/domain/entities/*.freezed.dart
ls lib/features/resume/data/models/*.g.dart
ls lib/config/di/*.config.dart  # For injectable
```

---

## Task 4: Test State Changes

### Unit Test (Bloc)

```dart
// test/features/resume/presentation/bloc/resume_bloc_test.dart
void main() {
  group('ResumeBloc', () {
    late ResumBloc resumeBloc;
    late MockLoadResume mockLoadResume;

    setUp(() {
      mockLoadResume = MockLoadResume();
      resumeBloc = ResumeBloc(mockLoadResume);
    });

    test('emits [Loading, Loaded] when LoadResume succeeds', () async {
      final mockDocument = ResumeDocument.blank();

      when(mockLoadResume()).thenAnswer((_) async => Right(mockDocument));

      expect(
        resumeBloc.stream,
        emitsInOrder([
          const ResumeState.loading(),
          ResumeState.loaded(mockDocument),
        ]),
      );

      resumeBloc.add(const ResumeEvent.loadResume('123'));
    });

    test('emits [Loading, Error] when LoadResume fails', () async {
      when(mockLoadResume()).thenAnswer(
        (_) async => Left(ServerFailure('Server error')),
      );

      expect(
        resumeBloc.stream,
        emitsInOrder([
          const ResumeState.loading(),
          isA<_Error>()
              .having((state) => state.message, 'message', contains('Server error')),
        ]),
      );

      resumeBloc.add(const ResumeEvent.loadResume('123'));
    });
  });
}
```

### Widget Test

```dart
// test/features/resume/presentation/pages/editor_page_test.dart
void main() {
  group('EditorPage', () {
    testWidgets('displays resume document when loaded', (tester) async {
      final mockDocument = ResumeDocument.blank();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<ResumeBloc>(
            create: (_) => MockResumeBloc(
              initialState: ResumeState.loaded(mockDocument),
            ),
            child: const EditorPage(),
          ),
        ),
      );

      expect(find.byType(ResumeCanvas), findsOneWidget);
      expect(find.text(mockDocument.fullName), findsOneWidget);
    });
  });
}
```

---

## Task 5: Common Patterns

### Pattern 1: Update Nested List Item

```dart
// In Bloc event handler
on<_UpdateSkillName>((event, emit) {
  final currentState = state as _Editing;
  final updatedSkills = [
    ...currentState.document.skills,
  ];
  updatedSkills[event.skillIndex] = updatedSkills[event.skillIndex].copyWith(
    name: event.newName,
  );
  final updated = currentState.document.copyWith(skills: updatedSkills);
  emit(ResumeState.editing(updated, null));
});
```

### Pattern 2: Convert Failure to UI Message

```dart
// In Bloc
_handleFailure(Failure failure) {
  if (failure is ServerFailure) {
    return 'Server error. Please try again.';
  } else if (failure is NetworkFailure) {
    return 'No internet connection.';
  } else if (failure is CacheFailure) {
    return 'Could not load data locally.';
  }
  return 'Unknown error.';
}
```

### Pattern 3: Conditional Widget Rendering

```dart
// In Presentation
BlocBuilder<ResumeBloc, ResumeState>(
  buildWhen: (previous, current) {
    // Only rebuild if document actually changed
    return previous is _Editing &&
        current is _Editing &&
        previous.document != current.document;
  },
  builder: (context, state) {
    if (state is _Editing) {
      return ResumePreview(document: state.document);
    }
    return SizedBox();
  },
);
```

### Pattern 4: Field Validation Before Save

```dart
// In Domain Usecase
class ValidateAndSaveResume {
  final IResumeRepository repository;

  ValidateAndSaveResume(this.repository);

  Future<Either<Failure, void>> call(ResumeDocument document) async {
    if (document.fullName.isEmpty) {
      return Left(ValidationFailure('Name is required'));
    }
    if (document.workExperience.isEmpty) {
      return Left(ValidationFailure('At least one work experience required'));
    }
    return await repository.saveResume(document);
  }
}
```

---

## Architecture Summary

```
User Input (Widget)
    ↓
  Event (Bloc/Provider)
    ↓
  Bloc/Provider (Orchestration)
    ↓
  Usecase (Business Logic)
    ↓
  Repository (Abstraction)
    ↓
  Datasource (Concrete Implementation)
    ↓
  Database/API
```

**Golden Rule**: Only presentation talks to bloc/provider. Only bloc/provider talks to domain. Only data talks to external APIs.

---

## Troubleshooting

### Q: Generated files not updating?
**A**: Run `flutter pub run build_runner clean` then `build_runner build --delete-conflicting-outputs`

### Q: Import error after adding new feature?
**A**: Check that feature has `feature_injection.dart` and is registered in `config/di/injection_container.dart`

### Q: Freezed class not generating copyWith?
**A**: Ensure class is decorated with `@freezed` and extends `_$ClassName with _$ClassName`

### Q: Bloc not emitting state changes?
**A**: Check that event is added: `context.read<MyBloc>().add(MyEvent())`

---

✅ **Quickstart Complete**

You now know how to:
- Add new fields to existing features
- Create entirely new features
- Run code generation properly
- Write tests for blocs and widgets
- Follow common architectural patterns
