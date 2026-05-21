# Data Model: Edit Profile Flow

## 1. ResumeProfile

**Purpose**: Represents the user's single reusable professional profile that is shown on the Profile page and edited through the Edit Profile page.

**Fields**:
- `id`: stable local identifier for the saved profile record
- `profileImagePath`: optional app-local image path
- `fullName`: optional string
- `jobTitle`: optional string
- `summary`: optional string
- `email`: optional string
- `address`: optional string
- `phoneCountryCode`: optional string
- `phoneNumber`: optional string
- `birthDate`: optional date value
- `portfolioLink`: optional string
- `skills`: ordered list of `ProfileSkill`
- `hobbies`: ordered list of `ProfileHobby`
- `experiences`: ordered list of `ProfileExperience`
- `educationRecords`: ordered list of `ProfileEducation`
- `awards`: ordered list of `ProfileAward`
- `certifications`: ordered list of `ProfileCertification`
- `updatedAt`: last-saved timestamp for persistence and refresh behavior

**Relationships**:
- Owns all repeatable profile sections
- Feeds the Profile summary screen and Edit Profile page
- Remains reusable for future resume-prefill or export mapping paths

**Validation Rules**:
- Scalar fields may remain empty unless a section-specific rule requires completion
- `summary` remains a free-text value, with the five-line limit treated as an input presentation rule rather than a persisted data constraint
- `birthDate` must not be after the current date
- `email` must match the accepted email format when provided
- `phoneCountryCode` and `phoneNumber` must form a valid phone entry when either phone component is saved

## 2. ProfileSkill

**Purpose**: Represents one skill item managed inline on the Edit Profile page.

**Fields**:
- `name`: optional skill title while editing
- `rating`: optional integer from 1 through 5 while editing

**Validation Rules**:
- `rating` must remain within the supported 1-5 range
- A saved skill should not contain a rating outside the supported range

## 3. ProfileHobby

**Purpose**: Represents one hobby item managed inline on the Edit Profile page.

**Fields**:
- `name`: optional hobby text while editing

**Validation Rules**:
- Empty hobby rows may exist transiently during editing but should not corrupt persistence

## 4. ProfileExperience

**Purpose**: Represents one work experience record created or edited through a bottom sheet.

**Fields**:
- `companyName`: required non-empty string when saved
- `position`: required non-empty string when saved
- `startDate`: required date value when saved
- `endDate`: required date value when saved
- `detailLines`: ordered list of one or more non-empty experience detail lines

**Relationships**:
- Belongs to `ResumeProfile`
- Can later map to the existing resume work-experience representation

**Validation Rules**:
- All fields are required before the record can be saved from the bottom sheet
- `endDate` must not be earlier than `startDate`
- Empty detail lines are not valid saved state

## 5. ProfileEducation

**Purpose**: Represents one education record created or edited through a bottom sheet.

**Fields**:
- `schoolName`: required non-empty string when saved
- `degreeName`: required non-empty string when saved
- `startDate`: required date value when saved
- `endDate`: required date value when saved

**Relationships**:
- Belongs to `ResumeProfile`
- Uses the same interaction model as `ProfileExperience`

**Validation Rules**:
- All fields are required before the record can be saved from the bottom sheet
- `endDate` must not be earlier than `startDate`

## 6. ProfileAward

**Purpose**: Represents one award entry inside the reusable profile.

**Fields**:
- `title`: award title
- `date`: award date

**Validation Rules**:
- A retained saved award record must include both title and date

## 7. ProfileCertification

**Purpose**: Represents one certification entry inside the reusable profile.

**Fields**:
- `title`: certification title
- `date`: certification date

**Validation Rules**:
- A retained saved certification record must include both title and date

## 8. ProfileEditDraft

**Purpose**: Represents the in-progress form state on the Edit Profile page, including values that have not yet passed validation.

**Fields**:
- `profile`: mutable working copy of `ResumeProfile`
- `fieldErrors`: keyed validation messages for basic fields and inline repeatable sections
- `pendingImageSelection`: temporary image-selection result before save confirmation
- `hasUnsavedChanges`: derived flag for edit-session behavior

**Relationships**:
- Loaded from `ResumeProfile`
- Written back to persistence only after validation succeeds

**Validation Rules**:
- Invalid entries must remain in the draft until the user corrects them or removes them
- Failed validation must not discard unaffected entered values

## 9. BottomSheetDraft

**Purpose**: Represents the temporary state for adding or editing a work experience or education record.

**Fields**:
- `mode`: add or edit
- `recordType`: experience or education
- `initialIndex`: optional existing record index when editing
- `fieldValues`: current entered values
- `validationMessages`: field-level validation results

**State Transitions**:
- `idle -> opened`: user taps add or edit
- `opened -> invalid`: user attempts save with missing or invalid values
- `opened -> saved`: all required fields pass and the record is returned to the profile draft
- `opened -> dismissed`: user closes the sheet without saving

## 10. ProfileViewState

**Purpose**: Represents the read-only summary state displayed on the Profile page.

**Fields**:
- `identitySection`
- `summarySection`
- `contactSection`
- `skillsSection`
- `hobbiesSection`
- `experienceSection`
- `educationSection`
- `awardsSection`
- `certificationsSection`
- `canEdit`

**Relationships**:
- Derived from persisted `ResumeProfile`
- Supplies the visible Profile page sections and Edit button state

**Validation Rules**:
- Empty sections must render safely without blocking the page
- Saved repeated item order must remain stable after load