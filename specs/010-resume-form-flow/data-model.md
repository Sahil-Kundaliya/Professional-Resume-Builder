# Data Model: Replace Resume Canvas with Form Flow

## 1. ResumeDocument

**Purpose**: Represents the canonical resume payload used for template rendering, PDF generation, and persisted resume storage.

**Fields**:
- `id`: stable identifier for the draft or saved resume
- `fullName`: display name shown in the selected template
- `jobPosition`: target role or headline
- `careerGoals`: summary/about text shown near the header
- `email`: contact email value
- `phone`: formatted phone value
- `address`: location or mailing text
- `birthday`: birth-date display text
- `website`: portfolio or website link text
- `photoPath`: optional local image path
- `workExperience`: ordered list of `WorkExperienceEntry`
- `education`: ordered list of `EducationEntry`
- `skills`: ordered list of `SkillEntry`
- `hobbies`: ordered list of text values
- `awards`: ordered list of `AwardEntry`
- `certifications`: ordered list of `CertEntry`
- `references`: ordered list of text values
- `sectionVisibility`, `sectionTitleOverrides`, `headerStyles`, `fieldStyles`: legacy rendering metadata that should be reviewed and trimmed where no longer required by the form-based flow

**Relationships**:
- Owned by `ResumeBloc` during the creation flow
- Persisted through `IResumeRepository`
- Rendered by `ResumeCanvas` and the PDF generation path

**Validation Rules**:
- Must remain render-safe with partial user data so Preview can work before every field is complete
- Ordered repeatable sections must preserve item order after add/edit/remove actions
- Legacy canvas-specific metadata should not be expanded further unless a renderer still depends on it

## 2. ResumeFormDraft

**Purpose**: Represents the in-progress structured form state used by the resume creation page before the user previews or generates the final result.

**Fields**:
- `template`: selected `ResumeTemplate`
- `document`: working `ResumeDocument` snapshot
- `fieldErrors`: keyed validation messages for scalar and repeatable fields
- `supportedSections`: resolved list of template-supported sections used to show or hide form groups
- `hasUnsavedChanges`: derived change flag for navigation and preview refresh behavior

**Relationships**:
- Derived from `CreateResume` output and optional prefill
- Maps back into `ResumeDocument` for preview and persistence

**Validation Rules**:
- Invalid values should stay in the draft until the user edits or removes them
- Draft state must survive navigation to and from Preview without losing entered values

## 3. ResumeTemplate

**Purpose**: Represents one selectable resume design and the visual rules used when rendering the current resume.

**Fields**:
- `id`: stable template identifier
- `name`: user-visible template name
- `layout`: layout selection used by the renderer
- `accentColor`: template accent color
- `headerBgColor`: header background color
- `hasPhoto`: indicates whether photo rendering is supported
- `hasSidebar`: indicates whether sidebar layout is used
- `isFavorite`: local favorite state in the preview catalogue

**Relationships**:
- Selected in the template list and preview flow
- Carried into `ResumeFormDraft`, `ResumeBloc`, preview, and generation

**Validation Rules**:
- Must be present before entering the resume form or preview flow
- Unsupported sections should not produce editable UI in the form

## 4. WorkExperienceEntry

**Purpose**: Represents one work experience item in the resume draft and render payload.

**Fields**:
- `dateRange`: formatted start/end range
- `position`: job title
- `companyName`: company or employer name
- `description`: multiline detail text

**Relationships**:
- Belongs to `ResumeDocument.workExperience`
- Edited through a structured bottom-sheet flow in the resume form

**Validation Rules**:
- Required fields must be complete before a bottom-sheet save succeeds
- Editing one item must not mutate siblings in the same list

## 5. EducationEntry

**Purpose**: Represents one education record in the resume draft and render payload.

**Fields**:
- `dateRange`: formatted start/end range
- `coursesSubjects`: degree, course, or subject text
- `schoolName`: school or college name
- `description`: additional education detail text

**Relationships**:
- Belongs to `ResumeDocument.education`
- Edited through a structured bottom-sheet flow in the resume form

**Validation Rules**:
- Required fields must be complete before a bottom-sheet save succeeds
- Multiple text fields must remain editable without losing sibling values

## 6. SkillEntry

**Purpose**: Represents one skill item shown in the resume and managed through lightweight repeatable form controls.

**Fields**:
- `name`: skill label
- `rating`: supported skill level value

**Validation Rules**:
- `rating` must stay within the supported range used by the renderer
- Empty skill values should not corrupt saved draft state

## 7. AwardEntry

**Purpose**: Represents one award item in the resume.

**Fields**:
- `year`: formatted date or year label
- `name`: award title

**Validation Rules**:
- Saved entries should include enough information to render meaningfully in preview

## 8. CertEntry

**Purpose**: Represents one certification item in the resume.

**Fields**:
- `year`: formatted date or year label
- `name`: certification title

**Validation Rules**:
- Saved entries should include enough information to render meaningfully in preview

## 9. TextListEntry

**Purpose**: Represents a lightweight repeatable text item for sections such as hobbies or references.

**Fields**:
- `value`: user-entered text

**Relationships**:
- Maps to `ResumeDocument.hobbies` or `ResumeDocument.references`

**Validation Rules**:
- Empty transient rows may exist during editing, but persisted preview state should not accumulate meaningless blank values

## 10. SectionEditorSession

**Purpose**: Represents the temporary add/edit state for a structured bottom-sheet section such as work experience or education.

**Fields**:
- `mode`: add or edit
- `sectionType`: work experience or education
- `initialIndex`: optional existing item index
- `fieldValues`: current entered values for the section
- `validationMessages`: field-level messages shown inside the bottom sheet

**State Transitions**:
- `idle -> opened`: user taps add or edit
- `opened -> invalid`: save attempted with missing or invalid values
- `opened -> saved`: valid values returned to the form draft and list updates immediately
- `opened -> dismissed`: user closes the sheet without committing changes

## 11. ResumePreviewSession

**Purpose**: Represents the current rendered preview context for the selected template and latest form draft.

**Fields**:
- `template`: currently selected template
- `document`: latest mapped `ResumeDocument`
- `source`: current form draft that produced the preview
- `isCurrent`: derived flag indicating whether preview reflects the latest edited values

**Relationships**:
- Produced from `ResumeFormDraft`
- Consumed by `ResumeCanvas` and PDF generation

**Validation Rules**:
- Preview must always render the latest committed draft values when the user requests it
- Returning from preview must preserve the underlying form draft without data loss