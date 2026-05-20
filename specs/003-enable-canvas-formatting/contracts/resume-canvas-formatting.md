# Contract: Resume Canvas Formatting Interactions

## Scope

This contract defines the user-facing interaction behavior for formatting the resume canvas header fields in the editor and preserving those choices in preview rendering.

## Supported Editable Targets

| Target Field | Canvas Identifier | Toolbar Enabled | Included in Undo/Redo |
| --- | --- | --- | --- |
| Full name | `fullName` | Yes | Yes |
| Job title | `jobPosition` | Yes | Yes |
| Summary | `careerGoals` | Yes | Yes |
| Profile image | `photoPath` | No | No |

## Toolbar Action Contract

| Action | Preconditions | Expected Result | Persistence Requirement |
| --- | --- | --- | --- |
| Bold | A supported text field is selected | Toggle bold for the selected field and repaint immediately | Stored on the selected field's style state |
| Italic | A supported text field is selected | Toggle italic for the selected field and repaint immediately | Stored on the selected field's style state |
| Underline | A supported text field is selected | Toggle underline for the selected field and repaint immediately | Stored on the selected field's style state |
| Font family | A supported text field is selected | Apply the chosen font to the selected field and repaint immediately | Stored on the selected field's style state |
| Text color | A supported text field is selected | Apply the chosen color to the selected field and repaint immediately | Stored on the selected field's style state |
| Undo | There is at least one reversible supported edit | Revert the most recent supported header edit | Restores the previous supported header snapshot |
| Redo | There is at least one redoable supported edit | Reapply the most recently undone supported header edit | Restores the next supported header snapshot |

## Selection Contract

1. Selecting `fullName`, `jobPosition`, or `careerGoals` exposes that field's current formatting in the toolbar.
2. Selecting an unsupported canvas element disables formatting mutations.
3. Clearing selection leaves the current document unchanged and prevents toolbar actions from mutating the resume.

## Rendering Contract

1. The canvas editor must update the selected field immediately after each supported toolbar action.
2. Formatting changes must remain isolated to the selected field.
3. Existing template-specific size, spacing, and structural layout remain intact unless explicitly overridden by supported formatting properties.
4. Resume preview and PDF rendering must reflect the same persisted header formatting state shown in the editor.

## History Contract

1. Undo and redo cover only supported header text and style changes.
2. Selection changes alone do not create history entries.
3. Profile image uploads remain functional but are excluded from text-formatting history.

## Failure Handling Contract

1. Toolbar actions triggered without a supported selected field must be ignored or blocked without corrupting editor state.
2. Invalid or unsupported formatting values must fall back to the nearest valid default for the selected field.