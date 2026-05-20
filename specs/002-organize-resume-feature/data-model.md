# Data Model & Architecture: Resume Feature

**Date**: 2026-05-19 | **Feature**: Organize Resume Feature

## Overview

This document defines the data structures, entity relationships, and Bloc architecture for the resume feature. All models are implemented with Freezed for immutability and serialization support.

## Domain Entities

### ResumeDocument (Root Entity)

The primary aggregate root representing a complete resume.

```dart
@freezed
class ResumeDocument with _$ResumeDocument {
  const factory ResumeDocument({
    required String id,
    required String fullName,
    required String jobPosition,
    required String careerGoals,
    required String email,
    required String phone,
    required String address,
    required String birthday,
    required String website,
    required String photoPath,
    required List<WorkExperienceEntry> workExperience,
    required List<EducationEntry> education,
    required List<String> references,
    required List<String> hobbies,
    required List<SkillEntry> skills,
    required List<AwardEntry> awards,
    required List<CertEntry> certifications,
    @Default(DateTime.now()) DateTime createdAt,
    @Default(DateTime.now()) DateTime updatedAt,
  }) = _ResumeDocument;
}
```

**Key Attributes**:
- `id`: Unique identifier (UUID)
- `fullName`, `jobPosition`, `careerGoals`: Header section
- Contact info: `email`, `phone`, `address`, `birthday`, `website`
- `photoPath`: Path to profile photo asset
- Lists: Work, education, skills, awards, certifications
- Timestamps: Creation and modification dates

### Sub-Entities

```dart
@freezed
class WorkExperienceEntry with _$WorkExperienceEntry {
  const factory WorkExperienceEntry({
    required String dateRange,
    required String position,
    required String companyName,
    required String description,
  }) = _WorkExperienceEntry;
}

@freezed
class EducationEntry with _$EducationEntry {
  const factory EducationEntry({
    required String dateRange,
    required String coursesSubjects,
    required String schoolName,
    required String description,
  }) = _EducationEntry;
}

@freezed
class SkillEntry with _$SkillEntry {
  const factory SkillEntry({
    required String name,
    required int rating, // 1-5 scale
  }) = _SkillEntry;
}

@freezed
class AwardEntry with _$AwardEntry {
  const factory AwardEntry({
    required String year,
    required String name,
  }) = _AwardEntry;
}

@freezed
class CertEntry with _$CertEntry {
  const factory CertEntry({
    required String year,
    required String name,
  }) = _CertEntry;
}
```

## Data Transfer Objects (DTOs)

DTOs mirror domain entities for API/storage communication.

```dart
@freezed
class ResumeDocumentDto with _$ResumeDocumentDto {
  const factory ResumeDocumentDto({
    required String id,
    required String fullName,
    // ... all fields from entity
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ResumeDocumentDto;

  factory ResumeDocumentDto.fromJson(Map<String, dynamic> json) =>
      _$ResumeDocumentDtoFromJson(json);
}
```

## Bloc Architecture

### ResumeBloc States

```dart
@freezed
class ResumeState with _$ResumeState {
  const factory ResumeState.initial() = _Initial;
  const factory ResumeState.loading() = _Loading;
  const factory ResumeState.loaded({
    required ResumeDocument document,
    required String? selectedFieldId,
  }) = _Loaded;
  const factory ResumeState.saving() = _Saving;
  const factory ResumeState.saved() = _Saved;
  const factory ResumeState.error(String message) = _Error;
}
```

**State Variants**:
- `Initial`: Bloc not yet initialized
- `Loading`: Fetching resume data
- `Loaded`: Resume ready for display/editing (includes selected field for editor)
- `Saving`: Persisting changes
- `Saved`: Changes persisted successfully
- `Error`: Operation failed with error message

### ResumeBloc Events

```dart
@freezed
class ResumeEvent with _$ResumeEvent {
  const factory ResumeEvent.loadResume(String resumeId) = LoadResume;
  const factory ResumeEvent.createResume() = CreateResume;
  const factory ResumeEvent.editField(String fieldId, dynamic value) = EditField;
  const factory ResumeEvent.saveResume() = SaveResume;
  const factory ResumeEvent.deleteResume(String resumeId) = DeleteResume;
  const factory ResumeEvent.selectField(String? fieldId) = SelectField;
}
```

**Event Types**:
- `LoadResume`: Fetch existing resume by ID
- `CreateResume`: Initialize new blank resume
- `EditField`: Update a single field (selection, work entry, etc.)
- `SaveResume`: Persist current state
- `DeleteResume`: Remove resume
- `SelectField`: Track selected field for editor UI

## Repository Interface

```dart
abstract class IResumeRepository {
  Future<ResumeDocument> getResume(String id);
  Future<List<ResumeDocument>> getAllResumes();
  Future<String> createResume(ResumeDocument document);
  Future<void> updateResume(ResumeDocument document);
  Future<void> deleteResume(String id);
}
```

## Data Flow

```
User Action (Widget)
    ↓
    +→ ResumeBloc.add(Event)
    ↓
ResumeBloc processes event
    ↓
    +→ Calls repository/usecase
    ↓
Repository queries data layer
    ↓
    +→ Data source (local/API)
    ↓
Data returned (DTO)
    ↓
    +→ Mapper converts DTO → Entity
    ↓
Bloc emits new State
    ↓
    +→ Widgets rebuild via BlocListener/BlocBuilder
    ↓
UI reflects new state
```

## Validation Rules

- `fullName`: Non-empty, max 100 characters
- `email`: Valid email format
- `phone`: Valid phone format (flexible international)
- `skillRating`: Integer 1-5
- `dateRange`: Must be formatted "From • To"

## Error Handling

All errors propagate through ResumeState.error(message):
- Network errors → "Failed to load resume"
- Validation errors → Specific field error message
- Storage errors → "Failed to save resume"

## Key Design Decisions

1. **Freezed Models**: Immutability + pattern matching + serialization
2. **Bloc Pattern**: Centralized state management, predictable state transitions
3. **Repository Pattern**: Data source abstraction for testability
4. **DTO Mapping**: Clear separation of data and domain layers
5. **Selected Field Tracking**: Enables editor UI to highlight active field
