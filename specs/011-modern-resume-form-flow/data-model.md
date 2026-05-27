# Data Model: Modern Resume Form and Template-Aware Preview

## 1. TemplateFieldConfiguration

**Purpose**: Defines template-specific rules for field visibility and requiredness used by form rendering and validation.

**Fields**:
- `templateId`: stable template identifier
- `enabledFields`: set of field identifiers shown in the form
- `hiddenFields`: set of field identifiers intentionally excluded from the form
- `requiredFields`: set of field identifiers that must be completed before preview

**Relationships**:
- Belongs to a `ResumeTemplate`
- Consumed by `ResumeFormDraft` and validation policy

**Validation Rules**:
- `requiredFields` must be a subset of `enabledFields`
- Any field in `hiddenFields` must not appear in `enabledFields`
- Unknown field identifiers are rejected during config load

## 2. ResumeFormDraft

**Purpose**: Represents in-progress form state for the selected template before preview.

**Fields**:
- `template`: selected `ResumeTemplate`
- `document`: current `ResumeDocument` snapshot
- `visibleSections`: derived section list from template field configuration
- `validationState`: current validation outcomes for required fields
- `dirtyFields`: optional set of fields changed in current session

**Relationships**:
- Uses `TemplateFieldConfiguration` to determine visibility and requiredness
- Maps to `ResumePreviewPayload` when preview is requested

**Validation Rules**:
- Required-field completeness is re-evaluated after each relevant change
- Draft preserves unsaved but user-entered values when navigating form/preview

## 3. ResumeFieldValidationState

**Purpose**: Captures field-level and form-level eligibility for preview navigation.

**Fields**:
- `fieldErrors`: map of field identifier to feedback message
- `missingRequiredFields`: set of required field identifiers without valid values
- `canPreview`: derived boolean
- `lastValidatedAt`: timestamp or sequence marker for latest validation pass

**State Transitions**:
- `idle -> validating`: user changes a relevant field or taps preview
- `validating -> invalid`: required fields missing or invalid
- `validating -> valid`: no required-field violations
- `valid -> invalid`: user clears or invalidates a required field

## 4. DynamicSectionEntry

**Purpose**: Unified conceptual model for repeatable items across work experience, education, and optional modules.

**Fields**:
- `entryId`: local stable identifier
- `sectionType`: module identifier (experience, education, skills, hobbies, awards, references, etc.)
- `payload`: section-specific values
- `updatedAt`: latest modification marker

**Relationships**:
- Stored inside corresponding lists in `ResumeDocument`
- Managed through section UI and bottom-sheet edit sessions

**Validation Rules**:
- Save from editor requires section-required fields to be complete
- Edit/remove operations must only mutate targeted entry

## 5. BottomSheetEditorSession

**Purpose**: Temporary add/edit state for dynamic records in bottom sheets.

**Fields**:
- `mode`: add or edit
- `targetSection`: section identifier
- `editingEntryId`: optional entry identifier for edit mode
- `draftValues`: current in-sheet values
- `editorErrors`: validation feedback displayed inside sheet

**State Transitions**:
- `closed -> open`
- `open -> invalid`
- `open -> saved`
- `open -> canceled`

## 6. ResumePreviewPayload

**Purpose**: Input contract used by preview and generation surfaces.

**Fields**:
- `template`: selected template
- `document`: latest validated or render-safe `ResumeDocument`
- `zoomLevel`: preview UI scale state
- `renderedSections`: derived list of non-empty sections included in preview

**Relationships**:
- Produced from `ResumeFormDraft`
- Consumed by preview page and existing renderer

**Validation Rules**:
- Optional sections with no meaningful data are excluded from `renderedSections`
- Preview navigation requires `canPreview == true`

## 7. ResumeDocument (Existing Canonical Entity)

**Purpose**: Existing architecture-level resume payload preserved for rendering and persistence.

**Relevant Fields**:
- Personal fields: name, job position, summary, birth date, email, phone, address, photo, links
- Structured lists: work experience, education
- Optional modules: skills, hobbies, awards, references, certifications

**Design Note**:
- This feature does not replace `ResumeDocument`; it adds template-aware form and validation behavior around it.
