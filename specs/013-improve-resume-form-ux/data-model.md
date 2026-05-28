# Data Model: Modern Template-Aware Resume Form UX

## Entity: ResumeFormViewModel (existing aggregate, expanded)

Purpose: Editable state for ResumeFormPage UI and dynamic section content.

Fields in scope:
- Basic profile fields (name, role, contact, summary)
- Dynamic section collections (work experiences, educations, skills, hobbies, references, awards)
- `profileImagePath: String?`
- `profileImagePreviewState: {empty, loading, ready, error}`
- Template context pointer for form accents

Validation rules:
- Required profile fields must remain validated with existing rules.
- Dynamic section entries must preserve existing required/optional constraints.
- Image preview state must never block non-image form edits.

## Entity: TemplateFormStyle (derived)

Purpose: Runtime style values for template-aware form accents.

Fields:
- `primaryAccent`
- `secondaryAccent`
- `headerAccent`
- `highlightAccent`
- `focusAccent`
- `progressAccent` (if progress indicator exists)

Rules:
- Values are sourced from selected resume template.
- Accent usage must maintain readable contrast for text and controls.

## Entity: FormSectionDescriptor (new reusable UI descriptor)

Purpose: Standardized section metadata for reusable section containers.

Fields:
- `sectionKey`
- `title`
- `icon` (optional)
- `order`
- `isRepeatable`
- `isExpanded`
- `supportsAddAction`

Rules:
- Sections render in deterministic order.
- Repeatable sections expose consistent add/edit/remove controls.

## Entity: ProfileImageSelection (existing concept, refined)

Purpose: Image selection metadata for inline preview behavior.

Fields:
- `path: String?`
- `previewStatus: {none, available, unavailable}`
- `errorMessage: String?`

State transitions:
- None -> Available when a valid image is selected.
- Available -> Unavailable when image cannot be loaded.
- Any -> None when image is removed.

## Entity: SkillItem (expanded)

Purpose: Skill entry for dynamic skill section.

Fields:
- `name: String`
- `level: int` (1..5)

Validation rules:
- `name` must be non-empty after trim.
- `level` must be between 1 and 5 inclusive.

State transitions:
- On add: initialize with default level (project default, e.g., 3) or selected value.
- On edit: existing level is displayed and can be updated.

## Relationships

- `ResumeFormViewModel` references `TemplateFormStyle` to render form accents.
- `ResumeFormViewModel` contains ordered `FormSectionDescriptor` instances for UI grouping.
- `ResumeFormViewModel` contains `ProfileImageSelection` and a list of `SkillItem` entries.
- Dynamic section editors update the aggregate state through existing resume form state flow.

## Invariants

- Existing resume form functionality and data persistence flow remain intact.
- Skill levels are always persisted in the allowed 1-5 range.
- Section grouping and interactions are consistent across repeatable form sections.
- Image path is never shown as the primary user-facing representation when preview is available.
