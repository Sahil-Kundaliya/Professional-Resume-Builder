# Data Model: Add Profile Navigation

## 1. ResumeProfile

**Purpose**: Represents the user's single reusable profile for resume creation and future template prefilling.

**Fields**:
- `id`: stable local identifier for the saved profile record
- `profileImagePath`: optional local image path
- `fullName`: optional string
- `jobTitle`: optional string
- `summary`: optional string
- `email`: optional string
- `phoneNumber`: optional string
- `address`: optional string
- `birthDate`: optional string
- `portfolioLink`: optional string
- `hobbies`: list of `HobbyItem`
- `skills`: list of `ProfileSkill`
- `workExperiences`: list of `ProfileWorkExperience`
- `educationItems`: list of `ProfileEducation`
- `hasUserProvidedContent`: derived indicator for whether placeholder-only first-open state has been replaced with saved content

**Relationships**:
- Owns repeated profile items for hobbies, skills, work experiences, and education
- Feeds both the Profile summary screen and the Edit Profile flow
- Can be transformed into a `ResumeDocument` for the Use Your Data startup path

**Validation Rules**:
- Every scalar field is optional
- Repeated collections may be empty
- If the profile has never been saved, summary presentation should fall back to placeholder image, full name, and job title values

## 2. HobbyItem

**Purpose**: Represents one reusable hobby or personal interest entry.

**Fields**:
- `value`: optional string

**Validation Rules**:
- Empty values are allowed while editing but should not break profile persistence or rendering

## 3. ProfileSkill

**Purpose**: Represents one reusable skill and its rating.

**Fields**:
- `name`: optional string
- `rating`: optional integer from 1 through 5

**Validation Rules**:
- `rating` must be within the supported 1-5 range when provided
- Empty name plus empty rating must remain saveable because all fields are optional

## 4. ProfileWorkExperience

**Purpose**: Represents one reusable employment entry that can later prefill resume work history.

**Fields**:
- `companyName`: optional string
- `jobPosition`: optional string
- `startDate`: optional string
- `endDate`: optional string
- `description`: optional string

**Validation Rules**:
- Any subset of fields may be saved
- Empty `endDate` is valid for current or unfinished roles

## 5. ProfileEducation

**Purpose**: Represents one reusable education entry.

**Fields**:
- `title`: optional string
- `instituteName`: optional string
- `description`: optional string
- `startDate`: optional string
- `endDate`: optional string

**Validation Rules**:
- Any subset of fields may be saved
- Empty dates must not block save behavior

## 6. ProfileViewState

**Purpose**: Derived state used by the Profile summary screen.

**Fields**:
- `displayImagePath`
- `displayName`
- `displayJobTitle`
- `showingPlaceholderIdentity`
- `profileSections`
- `canEdit`

**Relationships**:
- Derived from `ResumeProfile`
- Consumed by the Profile tab summary UI

**Validation Rules**:
- When no saved profile exists, `displayImagePath`, `displayName`, and `displayJobTitle` resolve to placeholder values
- Empty optional sections remain renderable without crashing the screen

## 7. TemplateStartChoice

**Purpose**: Represents the user's decision when starting a resume from a template preview.

**Allowed Values**:
- `startFromScratch`
- `useYourData`

**Relationships**:
- Chosen in the template preview confirmation dialog
- Determines which resume initialization path is executed

## 8. PrefilledResumeDraft

**Purpose**: Represents a new editable resume document created from a selected template and the currently saved profile.

**Fields**:
- `templateId`
- `resumeDocument`
- `prefilledFieldSet`: derived list of fields populated from saved profile data

**Relationships**:
- Produced by a profile-to-resume mapping step
- Loaded into the existing resume editor flow

**Validation Rules**:
- Only saved profile values should prefill resume fields
- Missing profile values must leave corresponding resume fields editable and unset to their scratch defaults

## 9. LocalProfileRecord

**Purpose**: Storage representation of the reusable profile in the local datasource.

**Fields**:
- Serialized equivalents of `ResumeProfile`
- Metadata needed to detect whether a saved profile exists

**Relationships**:
- Read and written by the profile local datasource
- Mapped to and from the domain `ResumeProfile`

**Validation Rules**:
- Must be serializable as a single local document
- Storage schema should preserve repeated item order so the UI and prefill path remain stable