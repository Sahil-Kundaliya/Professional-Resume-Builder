# Data Model: Extend Profile Sections

## 1. ResumeProfile

**Purpose**: Primary aggregate for persisted profile data, including existing immutable basic fields and new repeatable sections.

**Fields**:
- `id`: stable record identifier
- Existing basic fields (unchanged behavior):
  - `profileImagePath`
  - `fullName`
  - `jobTitle`
  - `summary`
  - `email`
  - `address`
  - `phoneCountryCode`
  - `phoneNumber`
  - `portfolioLink`
  - `birthDate`
- Existing repeatable fields:
  - `skills`
  - `hobbies`
- New/extended repeatable fields:
  - `experiences`
  - `educationRecords`
  - `awards`
  - `certifications`
- `updatedAt`

**Relationships**:
- Owns all section entry records listed below
- Feeds both Profile view and Edit Profile draft

**Validation Rules**:
- Existing basic field validation behavior is preserved
- Section collections support multiple items
- Persisted item order remains stable across save/load

## 2. ProfileExperience

**Purpose**: Work experience item added through Experience bottom sheet.

**Fields**:
- `companyName` (required)
- `position` (required)
- `startDate` (required)
- `endDate` (required)
- `detailLines` (required topic-based details, one or more non-empty lines)

**Validation Rules**:
- Required fields must be present before item can be added
- `endDate` must not be earlier than `startDate`

## 3. ProfileEducation

**Purpose**: Education record item added through Education bottom sheet.

**Fields**:
- `schoolName` (required)
- `degreeName` (required)
- `startDate` (required)
- `endDate` (required)

**Validation Rules**:
- Required fields must be present before item can be added
- `endDate` must not be earlier than `startDate`

## 4. ProfileAward

**Purpose**: Award item added through Awards bottom sheet.

**Fields**:
- `title` (required)
- `date` (required)

**Validation Rules**:
- Both fields required before item add/save

## 5. ProfileCertification

**Purpose**: Certification item added through Certifications bottom sheet.

**Fields**:
- `title` (required)
- `date` (required)

**Validation Rules**:
- Both fields required before item add/save

## 6. ProfileHobby

**Purpose**: Simple list-based hobby entry for profile enrichment.

**Fields**:
- `name` (required to retain as a saved entry)

**Validation Rules**:
- Empty entries are not retained as saved list items

## 7. ProfileEditDraft

**Purpose**: In-progress edit state holding a working `ResumeProfile` copy and validation state.

**Fields**:
- `profile`
- `validationErrors`
- `hasUnsavedChanges`

**State Transitions**:
- `loaded -> editing`: when user changes any field or list section
- `editing -> saving`: user taps save
- `saving -> loaded`: persistence succeeds, new lists visible in profile view
- `editing -> editing (error state)`: validation fails, values remain intact

## 8. BottomSheetDraft (UI contract-level entity)

**Purpose**: Temporary section-form data before committing an item into the draft profile collection.

**Fields**:
- `sectionType` (`experience`, `education`, `award`, `certification`)
- `fieldValues`
- `fieldErrors`

**Validation Rules**:
- Section-specific required fields block add when invalid
- Cancel/dismiss causes no mutation in `ResumeProfile`