# ResumeBloc Contract

## Event Interface

```dart
sealed class ResumeEvent {
  const ResumeEvent();
}

class LoadResume extends ResumeEvent {
  final String resumeId;
  const LoadResume(this.resumeId);
}

class CreateResume extends ResumeEvent {
  const CreateResume();
}

class EditField extends ResumeEvent {
  final String fieldId;
  final dynamic value;
  const EditField(this.fieldId, this.value);
}

class SaveResume extends ResumeEvent {
  const SaveResume();
}

class DeleteResume extends ResumeEvent {
  final String resumeId;
  const DeleteResume(this.resumeId);
}

class SelectField extends ResumeEvent {
  final String? fieldId;
  const SelectField(this.fieldId);
}
```

## State Interface

```dart
sealed class ResumeState {
  const ResumeState();
}

class ResumeInitial extends ResumeState {
  const ResumeInitial();
}

class ResumeLoading extends ResumeState {
  const ResumeLoading();
}

class ResumeLoaded extends ResumeState {
  final ResumeDocument document;
  final String? selectedFieldId;
  const ResumeLoaded({required this.document, this.selectedFieldId});
}

class ResumeSaving extends ResumeState {
  const ResumeSaving();
}

class ResumeSaved extends ResumeState {
  const ResumeSaved();
}

class ResumeError extends ResumeState {
  final String message;
  const ResumeError(this.message);
}
```

## State Transitions

| Current State | Event | Next State | Side Effects |
|---------------|-------|-----------|--------------|
| Initial | LoadResume | Loading → Loaded / Error | Fetch from repository |
| Initial | CreateResume | Loaded | Initialize blank document |
| Loaded | EditField | Loaded (updated) | Update document in memory |
| Loaded | SelectField | Loaded (selection updated) | Track selected field |
| Loaded | SaveResume | Saving → Saved / Error | Persist to repository |
| Loaded | DeleteResume | Initial / Error | Remove from repository |
| Any | Error | Error | Display error to user |

## Error Contract

All errors are wrapped in `ResumeState.error(String message)`:

| Error Type | Message | Recoverable |
|-----------|---------|-----------|
| Network | "Failed to load resume: [details]" | Yes |
| NotFound | "Resume not found" | Yes (show create option) |
| Validation | "Invalid [fieldName]: [constraint]" | Yes (hint to user) |
| Storage | "Failed to save resume: [details]" | Yes (retry) |
| Unknown | "An unexpected error occurred" | Yes |

## Usage Contract

### Initialization

```dart
context.read<ResumeBloc>().add(LoadResume('123'));
```

### Listening

```dart
BlocListener<ResumeBloc, ResumeState>(
  listener: (context, state) {
    // React to state changes
  },
);
```

### Building

```dart
BlocBuilder<ResumeBloc, ResumeState>(
  builder: (context, state) {
    // Render based on state
  },
);
```

### Dispatching

```dart
context.read<ResumeBloc>().add(EditField('fullName', 'New Name'));
```
