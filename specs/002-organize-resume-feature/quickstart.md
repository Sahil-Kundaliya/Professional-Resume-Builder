# Quickstart: Resume Feature Bloc

**Date**: 2026-05-19 | **Feature**: Organize Resume Feature

Quick reference for accessing and using the Resume feature after migration.

## Feature Location

```
lib/features/resume/
├── domain/
│   ├── entities/resume_document.dart
│   ├── repositories/resume_repository.dart
│   └── usecases/
├── data/
│   ├── models/resume_document_model.dart
│   └── repositories/
├── presentation/
│   ├── bloc/
│   │   ├── resume_bloc.dart
│   │   ├── resume_event.dart
│   │   └── resume_state.dart
│   ├── pages/
│   │   ├── resume_editor_page.dart
│   │   └── resume_preview_page.dart
│   └── widgets/
└── resume_injection.dart
```

## Accessing ResumeBloc in Widgets

### 1. Listen to State Changes

```dart
BlocListener<ResumeBloc, ResumeState>(
  listener: (context, state) {
    state.whenOrNull(
      saved: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resume saved!')),
        );
      },
      error: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
    );
  },
  child: const YourWidget(),
);
```

### 2. Watch State for Rebuilds

```dart
BlocBuilder<ResumeBloc, ResumeState>(
  builder: (context, state) {
    return state.whenOrNull(
      loaded: (document, selectedFieldId) {
        return ResumeCanvas(document: document);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (message) => Center(child: Text('Error: $message')),
    ) ?? const SizedBox.shrink();
  },
);
```

### 3. Select Specific State Data

```dart
BlocSelector<ResumeBloc, ResumeState, ResumeDocument?>(
  selector: (state) {
    return state.maybeWhen(
      loaded: (document, _) => document,
      orElse: () => null,
    );
  },
  builder: (context, document) {
    if (document == null) return const SizedBox.shrink();
    return Text(document.fullName);
  },
);
```

## Dispatching Events

### Load an Existing Resume

```dart
context.read<ResumeBloc>().add(
  ResumeEvent.loadResume('resume-id-123'),
);
```

### Create a New Resume

```dart
context.read<ResumeBloc>().add(
  const ResumeEvent.createResume(),
);
```

### Edit a Field

```dart
context.read<ResumeBloc>().add(
  ResumeEvent.editField('fullName', 'John Doe'),
);

// For complex fields
context.read<ResumeBloc>().add(
  ResumeEvent.editField('workExperience', [
    WorkExperienceEntry(
      dateRange: 'Jan 2020 - Present',
      position: 'Senior Developer',
      companyName: 'Tech Corp',
      description: 'Leading development...',
    ),
  ]),
);
```

### Save Current Resume

```dart
context.read<ResumeBloc>().add(
  const ResumeEvent.saveResume(),
);
```

### Select a Field for Editing

```dart
context.read<ResumeBloc>().add(
  ResumeEvent.selectField('skillsSection'),
);
```

## Dependency Injection Setup

In `resume_injection.dart`, the feature registers its dependencies:

```dart
void setupResumeFeature(GetIt getIt) {
  // Register datasources
  getIt.registerSingleton<IResumeLocalDatasource>(
    ResumeLocalDatasourceImpl(),
  );

  // Register repositories
  getIt.registerSingleton<IResumeRepository>(
    ResumeRepositoryImpl(
      localDatasource: getIt<IResumeLocalDatasource>(),
    ),
  );

  // Register Bloc
  getIt.registerSingleton<ResumeBloc>(
    ResumeBloc(getIt<IResumeRepository>()),
  );
}
```

**Called from**: `config/di/injection_container.dart`

```dart
void setupFeatures(GetIt getIt) {
  setupHomeFeature(getIt);
  setupResumeFeature(getIt);  // ← Resume feature DI
}
```

## Widget Example: Editor Screen

```dart
class ResumeEditorPage extends StatelessWidget {
  const ResumeEditorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResumeBloc, ResumeState>(
      builder: (context, state) {
        return state.whenOrNull(
          loaded: (document, selectedFieldId) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Edit Resume'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: () {
                      context.read<ResumeBloc>().add(
                        const ResumeEvent.saveResume(),
                      );
                    },
                  ),
                ],
              ),
              body: ResumeCanvas(
                document: document,
                selectedFieldId: selectedFieldId,
                onFieldSelected: (fieldId) {
                  context.read<ResumeBloc>().add(
                    ResumeEvent.selectField(fieldId),
                  );
                },
              ),
            );
          },
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (message) => Scaffold(
            body: Center(child: Text('Error: $message')),
          ),
        ) ?? const Scaffold();
      },
    );
  }
}
```

## Testing Example

```dart
void main() {
  group('ResumeBloc', () {
    late ResumeBloc resumeBloc;
    late MockResumeRepository mockRepository;

    setUp(() {
      mockRepository = MockResumeRepository();
      resumeBloc = ResumeBloc(mockRepository);
    });

    tearDown(() => resumeBloc.close());

    test('emits [Loading, Loaded] when LoadResume succeeds', () async {
      when(mockRepository.getResume('123')).thenAnswer(
        (_) async => ResumeDocument(...),
      );

      expect(
        resumeBloc.stream,
        emitsInOrder([
          const ResumeState.loading(),
          isA<_Loaded>(),
        ]),
      );

      resumeBloc.add(const ResumeEvent.loadResume('123'));
    });
  });
}
```

## Common Patterns

### Pattern 1: Load on Init

```dart
@override
void initState() {
  super.initState();
  context.read<ResumeBloc>().add(
    ResumeEvent.loadResume(widget.resumeId),
  );
}
```

### Pattern 2: Debounce Field Edits

Use `BlocEvent` with a debounce duration:

```dart
context.read<ResumeBloc>().add(
  ResumeEvent.editField('fullName', textValue),
);
```

(Bloc can internally debounce if needed)

### Pattern 3: Conditional UI Based on Save State

```dart
BlocBuilder<ResumeBloc, ResumeState>(
  builder: (context, state) {
    final isSaving = state is _Saving;
    return FloatingActionButton(
      onPressed: isSaving ? null : () => _save(context),
      child: isSaving
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(),
            )
          : const Icon(Icons.save),
    );
  },
);
```

## Migration Checklist

After migration, verify:

- [ ] All resume screens moved to `lib/features/resume/presentation/pages/`
- [ ] All models converted to Freezed and placed in `data/models/` and `domain/entities/`
- [ ] ResumeProvider replaced with ResumeBloc
- [ ] All imports updated (no more `import 'package:...lib/screens/...'`)
- [ ] All imports updated (no more `import 'package:...lib/models/...'`)
- [ ] All imports updated (no more `import 'package:...lib/providers/...'`)
- [ ] App builds and runs without errors
- [ ] All resume functionality works as before
- [ ] Old `lib/screens/`, `lib/models/`, `lib/providers/` directories deleted

## References

- **Bloc Documentation**: https://bloclibrary.dev/
- **Freezed Documentation**: https://pub.dev/packages/freezed
- **Feature**: `specs/002-organize-resume-feature/`
