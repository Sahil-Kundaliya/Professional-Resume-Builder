# Data Model: Enable Resume Canvas Formatting

## 1. ResumeTextStyleSpec

**Purpose**: Represents the formatting properties controlled by the floating toolbar for a single supported resume text field.

**Fields**:
- `isBold`: boolean toggle for bold emphasis
- `isItalic`: boolean toggle for italic emphasis
- `isUnderline`: boolean toggle for underline decoration
- `fontFamily`: selected font option identifier
- `textColor`: selected text color value used during editing and preview rendering

**Validation Rules**:
- `fontFamily` must match one of the supported toolbar font options
- `textColor` must resolve to a valid renderable color value
- Missing values should fall back to the field's default presentation style rather than producing a blank style

## 2. ResumeHeaderStyles

**Purpose**: Holds the persisted toolbar-controlled styling for the three supported header fields.

**Fields**:
- `fullNameStyle`: `ResumeTextStyleSpec`
- `jobPositionStyle`: `ResumeTextStyleSpec`
- `careerGoalsStyle`: `ResumeTextStyleSpec`

**Relationships**:
- Belongs to `ResumeDocument`
- Each entry corresponds to one selectable editable header field on the resume canvas

**Validation Rules**:
- Every supported header field must always resolve to a style object, even if it contains only default values
- Style changes for one field must not mutate or overwrite another field's style object

## 3. ResumeDocument

**Purpose**: Existing resume aggregate that now also carries persisted header formatting for editing, saving, and preview rendering.

**New/Changed Fields**:
- Existing text fields remain unchanged: `fullName`, `jobPosition`, `careerGoals`
- Add `headerStyles`: `ResumeHeaderStyles`

**Relationships**:
- Feeds `ResumeCanvas` for editor and preview rendering
- Flows through repository, mapper, and DTO layers for local persistence

**Validation Rules**:
- Supported header text values remain editable independently from their style objects
- Preview and PDF rendering must use the same persisted values as the canvas editor

## 4. EditableHeaderField

**Purpose**: Selection identity for the three header fields that support toolbar formatting.

**Allowed Values**:
- `fullName`
- `jobPosition`
- `careerGoals`

**Relationships**:
- Used by bloc selection state
- Used by toolbar commands to target the correct text/style slot

**Validation Rules**:
- Toolbar formatting actions are valid only when one of these values is selected
- Unsupported canvas elements, including the profile image, must not map to a formatting target

## 5. HeaderEditingSnapshot

**Purpose**: Undo/redo history payload for reversible header editing operations.

**Fields**:
- `fullName`: string
- `jobPosition`: string
- `careerGoals`: string
- `fullNameStyle`: `ResumeTextStyleSpec`
- `jobPositionStyle`: `ResumeTextStyleSpec`
- `careerGoalsStyle`: `ResumeTextStyleSpec`

**Relationships**:
- Managed by `ResumeBloc` as history stacks for undo and redo
- Derived from the current `ResumeDocument` header slice

**State Transitions**:
- Created before a reversible supported edit is applied
- Pushed to undo history on successful change
- Moved between undo and redo history when user invokes undo or redo

**Validation Rules**:
- Selection changes alone do not create snapshots
- History must exclude photo upload and unrelated resume section edits

## 6. ToolbarProjection

**Purpose**: Derived view model for the formatting toolbar based on the current selected field and persisted style.

**Fields**:
- `isFormattingEnabled`
- `isBold`
- `isItalic`
- `isUnderline`
- `selectedFontFamily`
- `selectedTextColor`
- `canUndo`
- `canRedo`

**Relationships**:
- Derived from `ResumeState.loaded`
- Consumed by `ResumeEditorPage` and `FormattingToolbar`

**Validation Rules**:
- Values must match the selected field's persisted styling when a supported field is selected
- When no supported field is selected, formatting controls must render disabled or inactive without mutating the document