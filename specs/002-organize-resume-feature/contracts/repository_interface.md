# ResumeRepository Contract

## Interface Definition

```dart
abstract class IResumeRepository {
  /// Fetch a resume by ID
  /// Throws: NotFoundException, StorageException
  Future<ResumeDocument> getResume(String id);

  /// Fetch all resumes (or favorites)
  /// Throws: StorageException
  Future<List<ResumeDocument>> getAllResumes();

  /// Create a new resume
  /// Returns: ID of created resume
  /// Throws: ValidationException, StorageException
  Future<String> createResume(ResumeDocument document);

  /// Update an existing resume
  /// Throws: NotFoundException, ValidationException, StorageException
  Future<void> updateResume(ResumeDocument document);

  /// Delete a resume by ID
  /// Throws: NotFoundException, StorageException
  Future<void> deleteResume(String id);
}
```

## Implementation Layers

### Data Layer (Implementation)

```dart
class ResumeRepositoryImpl implements IResumeRepository {
  final IResumeLocalDatasource localDatasource;

  ResumeRepositoryImpl({required this.localDatasource});

  @override
  Future<ResumeDocument> getResume(String id) async {
    try {
      final dto = await localDatasource.getResume(id);
      return ResumeDocumentMapper.toDomain(dto);
    } catch (e) {
      // Handle and rethrow as domain exception
      rethrow;
    }
  }

  // ... other methods
}
```

### Data Source Interface

```dart
abstract class IResumeLocalDatasource {
  Future<ResumeDocumentDto> getResume(String id);
  Future<List<ResumeDocumentDto>> getAllResumes();
  Future<String> createResume(ResumeDocumentDto dto);
  Future<void> updateResume(ResumeDocumentDto dto);
  Future<void> deleteResume(String id);
}
```

### Mapper (DTO ↔ Domain)

```dart
class ResumeDocumentMapper {
  static ResumeDocument toDomain(ResumeDocumentDto dto) {
    return ResumeDocument(
      id: dto.id,
      fullName: dto.fullName,
      // ... map all fields
    );
  }

  static ResumeDocumentDto toDto(ResumeDocument domain) {
    return ResumeDocumentDto(
      id: domain.id,
      fullName: domain.fullName,
      // ... map all fields
    );
  }
}
```

## Error Contract

Errors propagate from datasource → repository → bloc:

| Scenario | Exception Type | Message to UI |
|----------|---|---|
| Document not found | NotFoundException | "Resume not found" |
| Storage unavailable | StorageException | "Failed to load resume" |
| Invalid data | ValidationException | Field-specific error |
| Unexpected error | GenericException | "An unexpected error occurred" |

## Operation Contracts

### GetResume

**Input**: `id` (String, non-empty)

**Output**: `ResumeDocument`

**Preconditions**: Resume with given ID exists

**Postconditions**: Document returned with all fields populated

**Exceptions**: NotFoundException, StorageException

---

### CreateResume

**Input**: `ResumeDocument` (with all required fields)

**Output**: `String` (resume ID)

**Preconditions**: Document is valid, storage is available

**Postconditions**: Document persisted, ID returned

**Exceptions**: ValidationException, StorageException

---

### UpdateResume

**Input**: `ResumeDocument` (with existing ID)

**Output**: None

**Preconditions**: Resume with given ID exists, document is valid

**Postconditions**: Document updated in storage

**Exceptions**: NotFoundException, ValidationException, StorageException

---

### DeleteResume

**Input**: `id` (String, non-empty)

**Output**: None

**Preconditions**: Resume with given ID exists

**Postconditions**: Document removed from storage

**Exceptions**: NotFoundException, StorageException

## Storage Contract

- **Format**: JSON (for serialization via Freezed)
- **Location**: Local device storage (SharedPreferences, Hive, or equivalent)
- **Persistence**: Immediate on write
- **Retrieval**: In-memory after first load (caching optional)

## Dependency Injection

```dart
// In resume_injection.dart
void setupResumeFeature(GetIt getIt) {
  // Register datasource
  getIt.registerSingleton<IResumeLocalDatasource>(
    ResumeLocalDatasourceImpl(),
  );

  // Register repository
  getIt.registerSingleton<IResumeRepository>(
    ResumeRepositoryImpl(
      localDatasource: getIt<IResumeLocalDatasource>(),
    ),
  );

  // Register Bloc
  getIt.registerSingleton<ResumeBloc>(
    ResumeBloc(
      repository: getIt<IResumeRepository>(),
    ),
  );
}
```

## Testing Contract

Mock implementations MUST:

1. Implement `IResumeRepository` interface
2. Return deterministic data for test scenarios
3. Support error simulation (throw exceptions on demand)
4. Track call history for verification

Example:

```dart
class MockResumeRepository implements IResumeRepository {
  List<ResumeDocument> _documents = [];

  @override
  Future<ResumeDocument> getResume(String id) async {
    final doc = _documents.firstWhereOrNull((d) => d.id == id);
    if (doc == null) throw NotFoundException('Resume not found');
    return doc;
  }

  // ... other methods
}
```
