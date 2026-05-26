# Data Model: Resume Editor Interaction Improvements

## 1. EditableFieldContext

- Description: Runtime selection context for the currently edited resume field.
- Key fields:
  - `fieldId`: unique string identifier for editable field instances (header, profile, education, work experience, skills, hobbies, references, awards, certifications, custom content).
  - `isSelected`: whether the field is active in editor interactions.
  - `supportsFormatting`: whether field participates in toolbar style updates (target: all editable text fields).
- Relationships:
  - Drives `FormattingToolbar` enabled state.
  - Binds interaction commands (delete clear, text-size updates, style toggles) to a specific field.
- Validation rules:
  - `fieldId` must resolve to an editable field in the rendered document.

## 2. ResumeFieldStyleSpec

- Description: Styling state applied to each editable text field.
- Key fields:
  - `isBold`: boolean
  - `isItalic`: boolean
  - `isUnderline`: boolean
  - `fontFamily`: string from supported family options
  - `textColorValue`: integer color value (existing style option)
  - `fontSize`: numeric text size
- Relationships:
  - Associated with each editable field through field style mapping.
  - Read by canvas rendering for styled text output.
- Validation rules:
  - `fontSize` must stay within configured bounds (min 8, max 13).
  - `fontFamily` must be a supported option or fallback to default.
  - Boolean style toggles are idempotent and independently combinable.
- State transitions:
  - Toggle operations invert style booleans for the selected field.
  - Font family and color updates replace current values.
  - Text-size increment/decrement applies one-step change and clamps to bounds.

## 3. SkillRatingState

- Description: Editable rating model for each skill entry in resume editor.
- Key fields:
  - `skillId` (or index-based field reference)
  - `rating`: integer
- Relationships:
  - Skill name text and skill rating are edited within the same skill item context.
  - Rating affects five-star visualization and persisted resume document value.
- Validation rules:
  - `rating` is integer between 0 and 5 inclusive.
  - Rendering shows exactly five stars; filled count equals rating.
- State transitions:
  - User edit action updates rating and re-renders immediately.
  - Out-of-range values are rejected or clamped before state persistence.

## 4. FieldContentState

- Description: Current text content for each editable field.
- Key fields:
  - `fieldId`
  - `textValue`
- Relationships:
  - Linked to `EditableFieldContext` for selection and delete behavior.
  - Styled by `ResumeFieldStyleSpec` during render.
- Validation rules:
  - Delete action clears `textValue` only; field structure remains in document.
- State transitions:
  - Text input updates field content.
  - Delete action transitions `textValue` to empty or placeholder-safe cleared value, without removing the field.

## 5. EditorTopBarActionState

- Description: Visible AppBar actions for the Resume Editor screen.
- Key fields:
  - `showSaveAction`: boolean (target false)
  - `showPdfAction`: boolean (unchanged existing behavior)
- Validation rules:
  - Save button is not rendered in the AppBar for this feature.
  - Existing non-AppBar save/autosave behavior remains available.
