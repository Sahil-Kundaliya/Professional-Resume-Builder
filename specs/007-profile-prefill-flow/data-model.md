# Data Model: Template Preview Profile Prefill Flow

## 1. StoredProfileSnapshot

**Purpose**: Represents the currently saved reusable profile data loaded from local storage for prefill decision and mapping.

**Fields**:
- `profileImagePath`
- `fullName`
- `jobTitle`
- `summary`
- `email`
- `address`
- `phoneCountryCode`
- `phoneNumber`
- `birthDate`
- `portfolioLink`
- `skills`
- `hobbies`
- `experiences`
- `educationRecords`
- `awards`
- `certifications`

**Validation Rules**:
- Values are considered usable only when non-null and non-empty after trim (for string fields).
- Collection fields are usable when at least one item contains meaningful content.
- Missing fields are allowed and do not invalidate other usable fields.

## 2. ProfileAvailabilityResult

**Purpose**: Encapsulates whether profile data is available for prompting and prefill.

**Fields**:
- `hasUsableData` (boolean)
- `usableFieldKeys` (list of mapped field identifiers)
- `sourceState` (`loaded`, `empty`, `error`)

**State Transitions**:
- `unknown -> loaded`: profile read succeeds
- `loaded -> hasUsableData=true`: at least one mapped field is usable
- `loaded -> hasUsableData=false`: no mapped fields are usable
- `unknown -> error`: profile read fails

**Validation Rules**:
- `error` state must default to `hasUsableData=false` for flow continuity.

## 3. ResumeCreationChoice

**Purpose**: Captures user decision in template preview flow.

**Enum Values**:
- `createNew`
- `useProfileData`

**Behavioral Rules**:
- Choice is requested only when `hasUsableData=true`.
- `createNew` must bypass prefill mapping.
- `useProfileData` must trigger mapping before editor navigation.

## 4. ResumePrefillPatch

**Purpose**: Represents field-level updates derived from profile data to apply onto a new resume document.

**Fields**:
- `headerFields`:
  - `photoPath`
  - `fullName`
  - `jobPosition`
  - `careerGoals`
  - `email`
  - `phone`
  - `address`
  - `birthday`
  - `website`
- `sections`:
  - `skills`
  - `hobbies`
  - `workExperience`
  - `education`
  - `awards`
  - `certifications`

**Validation Rules**:
- Each field update is optional and independently applied.
- Empty/null source fields are omitted from patch.
- Patch can be partial and still valid.

## 5. ResumeCreationContext

**Purpose**: Aggregates template selection plus optional prefill patch for a single create operation.

**Fields**:
- `selectedTemplate`
- `creationChoice`
- `prefillPatch` (nullable)

**Behavioral Rules**:
- Exactly one context is created per user tap flow.
- Context must preserve selected template regardless of choice.
- Navigation to editor occurs only after context is resolved.

## 6. Field Mapping Pairs

**Purpose**: Defines canonical source-to-target mappings for prefill.

**Primary Mappings**:
- `profileImagePath -> photoPath`
- `fullName -> fullName`
- `jobTitle -> jobPosition`
- `summary -> careerGoals`
- `email -> email`
- `address -> address`
- `birthDate -> birthday` (formatted for resume field representation)
- `portfolioLink -> website`
- `phoneCountryCode + phoneNumber -> phone`

**Collection Mappings**:
- `skills -> skills`
- `hobbies -> hobbies`
- `experiences -> workExperience`
- `educationRecords -> education`
- `awards -> awards`
- `certifications -> certifications`

**Validation Rules**:
- Mapping must skip invalid source records within a collection while preserving valid ones.
- Formatting transformation failures on one field must not block other field mappings.