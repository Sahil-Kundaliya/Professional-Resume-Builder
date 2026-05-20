# Phase 1 Design: Data Model Definition

**Date**: 2026-05-19  
**Feature**: Refactor Flutter Project Structure  
**Status**: Complete

---

## Entity Definitions

This document defines all domain entities, data models, and their relationships for the resume builder application.

---

## Domain Entities (features/*/domain/entities/)

### 1. ResumeDocument

**Purpose**: Represents the complete resume content being edited

**Fields**:
- `photoPath: String` — Path to user profile photo
- `fullName: String` — User's full name
- `jobPosition: String` — Job title or position
- `careerGoals: String` — Career objectives
- `email: String` — Contact email
- `phone: String` — Contact phone
- `address: String` — Contact address
- `birthday: String` — Date of birth
- `website: String` — Portfolio or website URL
- `workExperience: List<WorkExperience>` — Employment history
- `education: List<Education>` — Educational background
- `skills: List<SkillEntry>` — Technical and soft skills
- `awards: List<Award>` — Achievements and awards
- `certifications: List<Certification>` — Professional certifications
- `references: List<String>` — Professional references
- `hobbies: List<String>` — Personal interests

**Relationships**:
- Contains 1..* WorkExperience entries (min 1, default template)
- Contains 1..* Education entries (min 1, default template)
- Contains 0..* SkillEntry entries
- Contains 0..* Award/Certification entries
- References ResumeTemplate (implicit—selected during editing)

**Validation**:
- `fullName` must not be empty
- `email` must follow email format when provided
- At least one WorkExperience or Education entry required
- Photo path must point to valid file or be empty

**Serialization**: JSON (for save/load); Freezed (for immutability)

---

### 2. ResumeTemplate

**Purpose**: Defines visual layout and styling for resume rendering

**Fields**:
- `id: String` — Unique template identifier
- `name: String` — Display name
- `description: String` — Template description
- `previewImagePath: String` — Path to template preview image
- `isFavorite: bool` — User's favorite status
- `layoutConfig: LayoutConfig` — Template layout rules
- `colorScheme: ColorScheme` — Template colors

**Relationships**:
- One ResumeTemplate can be used to render many ResumeDocuments
- Contains 1 LayoutConfig

**Validation**:
- `id` must be unique across all templates
- `name` must not be empty
- Preview image must exist or be a placeholder

**Serialization**: JSON; Freezed

---

### 3. ResumeElement

**Purpose**: Represents an editable field or section in the editor (internal structure)

**Fields**:
- `id: String` — Unique field identifier
- `type: ElementType` — Type of element (text, number, date, list, etc.)
- `label: String` — Display label for editor UI
- `value: String` — Current value
- `placeholder: String` — Placeholder text in editor
- `isRequired: bool` — Whether field is mandatory
- `maxLength: int?` — Character limit

**Supported Types**: 
- `text` → Text input (name, position, etc.)
- `number` → Numeric input
- `date` → Date picker
- `email` → Email validation
- `list_item` → Repeatable item (for skills, awards, etc.)

**Relationships**:
- Belongs to ResumeDocument (implicit mapping)

**Serialization**: JSON; Freezed

---

## Domain Sub-Entities (nested)

### WorkExperience

**Fields**:
- `id: String` — Unique identifier (for edit/delete)
- `dateRange: String` — "MM/YYYY – MM/YYYY" format
- `position: String` — Job title
- `companyName: String` — Employer name
- `description: String` — Responsibilities and achievements

**Validation**:
- `position` and `companyName` must not be empty
- `dateRange` must follow expected format or be empty for current role

---

### Education

**Fields**:
- `id: String` — Unique identifier
- `dateRange: String` — "MM/YYYY – MM/YYYY" format
- `schoolName: String` — Institution name
- `coursesSubjects: String` — Degree/major or subjects
- `description: String` — Additional details (GPA, honors, etc.)

**Validation**:
- `schoolName` and `coursesSubjects` must not be empty

---

### SkillEntry

**Fields**:
- `id: String` — Unique identifier
- `name: String` — Skill name
- `rating: int` — Proficiency level (1-5)

**Validation**:
- `name` must not be empty
- `rating` must be between 1 and 5

---

### Award

**Fields**:
- `id: String` — Unique identifier
- `year: String` — Year awarded
- `name: String` — Award name

**Validation**:
- `name` must not be empty

---

### Certification

**Fields**:
- `id: String` — Unique identifier
- `year: String` — Year obtained
- `name: String` — Certification name
- `issuer: String` — Issuing organization (optional)

**Validation**:
- `name` must not be empty

---

## Data Models (features/*/data/models/)

All data models are **DTO** (Data Transfer Object) representations that mirror domain entities. They include:
- JSON serialization/deserialization (via freezed + json_serializable)
- Conversion methods (toEntity()) to domain entities
- Same field structure as entities but marked as data layer

### Naming Convention
- Domain: `ResumeDocument.dart`
- DTO: `ResumeDocumentModel.dart` or `ResumeDocumentDto.dart`
- Mapper: `ResumeDocumentMapper.dart` (converts Model → Entity)

### Example Structure
```dart
// data/models/resume_document_model.dart
@freezed
class ResumeDocumentModel with _$ResumeDocumentModel {
  const factory ResumeDocumentModel({
    required String fullName,
    required String jobPosition,
    required List<WorkExperienceModel> workExperience,
    // ... other fields
  }) = _ResumeDocumentModel;

  factory ResumeDocumentModel.fromJson(Map<String, dynamic> json) =>
    _$ResumeDocumentModelFromJson(json);
}
```

---

## Repository Contracts

### IResumeRepository (domain/repositories/)
Defines read/write operations for resume data. Implementation lives in data layer.

**Methods**:
- `Future<ResumeDocument> loadResume(String id)` — Load resume by ID
- `Future<void> saveResume(ResumeDocument resume)` — Persist resume
- `Future<void> deleteResume(String id)` — Delete resume
- `Future<List<ResumeDocument>> listResumes()` — List all saved resumes

**Error Handling**: Returns Either<Failure, Data> or throws domain-safe exceptions

### ITemplateRepository (domain/repositories/)

**Methods**:
- `Future<List<ResumeTemplate>> getTemplates()` — Fetch all templates
- `Future<ResumeTemplate> getTemplate(String id)` — Fetch single template
- `Future<void> toggleFavorite(String id)` — Mark/unmark favorite

---

## State Models (for Bloc/Provider)

### HomeState (features/home/presentation/)
- `initial` — Page loaded, templates not fetched yet
- `loading` — Fetching templates
- `loaded(List<ResumeTemplate> templates, String? selectedId)` — Templates ready
- `error(String message)` — Fetch failed

### ResumeEditorState (features/resume/presentation/)
- `initial` — Editor page loaded
- `loading` — Loading resume content
- `editing(ResumeDocument document, String selectedFieldId?)` — Editing active
- `saving` — Persisting changes
- `saved` — Changes persisted
- `error(String message)` — Operation failed

---

## Relationships Diagram

```
ResumeDocument
├── 1..* WorkExperience (list)
├── 1..* Education (list)
├── 0..* SkillEntry (list)
├── 0..* Award (list)
├── 0..* Certification (list)
├── List<String> hobbies
└── List<String> references

ResumeTemplate
└── LayoutConfig (1:1)

ResumeElement (internal field mapping)
├── type: ElementType
└── value: String
```

---

## Transition Rules (State Machines)

### Resume Editing Workflow
```
initial → loading → editing
              ↓        ↓
            error    saving → saved
                     ↓
                   error
```

### Template Selection Workflow
```
initial → loading → loaded (with selection)
              ↓        ↓
            error    (re-fetch available)
```

---

## Code Generation Requirements

All entities and models MUST be Freezed:

```bash
# Run after modifying any entity or model class
flutter pub run build_runner build --delete-conflicting-outputs
```

Generated files:
- `*.freezed.dart` — Immutability, equality, copyWith
- `*.g.dart` — JSON serialization (models only)

---

## Phase 1 Design: COMPLETE ✅

This data model definition establishes:
- ✅ Entity structures with validation rules
- ✅ Repository contracts (data access)
- ✅ State machines (Bloc/Provider)
- ✅ Freezed generation requirements
- ✅ Layer mapping (Domain → Data → DTO)

**Next**: Generate architecture contracts and quickstart guide.
