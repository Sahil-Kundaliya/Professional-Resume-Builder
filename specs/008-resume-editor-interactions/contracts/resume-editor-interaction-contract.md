# Contract: Resume Editor Interaction Behavior

## Overview

This contract defines expected Resume Editor behavior for interaction controls and formatting expansion while preserving existing architecture and flows.

## 1. Scope Contract

- Applies only to Resume Editor module behavior.
- Must not change unrelated modules, navigation flow, storage flow, template flow, or unrelated UI.

## 2. Keyboard Interaction Contract

- Trigger: User taps outside an active editable input while keyboard is visible.
- Expected behavior:
  - Active input focus is cleared.
  - Keyboard is dismissed.
  - Existing editor content remains unchanged.

## 3. Formatting Eligibility Contract

- Trigger: User selects any editable text field in Resume Editor.
- Expected behavior:
  - `FormattingToolbar` becomes applicable to the selected editable field.
  - Supported operations remain: bold, italic, underline, font family, and existing text styling options.
  - Behavior is consistent across header, contact, education, work experience, skills, hobbies, custom sections, and other editable text fields.

## 4. Text Size Control Contract

- Trigger: User invokes text-size increase/decrease action on selected editable field.
- Input constraints:
  - Minimum allowed size: 8
  - Maximum allowed size: 13
- Expected behavior:
  - Increase/decrease changes size in controlled single steps.
  - Values outside valid range are blocked from persistence.
  - Rendering remains stable and consistent with existing formatting behavior.

## 5. Editing Action Cleanup Contract

- Green expand action:
  - Must not be shown for editable text fields.
- Delete action:
  - Clears field text content only.
  - Must not remove field widgets, list structure, or layout containers.

## 6. Skills Rating Contract

- Rating editability:
  - User can update skill ratings from the edit experience.
- Value constraints:
  - Range is 0 to 5 inclusive.
- Rendering:
  - Exactly five stars are displayed.
  - No extra sixth star appears.

## 7. AppBar Action Contract

- Resume Editor AppBar must not display Save button.
- Existing save/autosave behavior outside that button remains unchanged.

## 8. Compatibility Contract

- No regressions in:
  - canvas editing
  - template rendering
  - preview generation
  - undo/redo behavior
  - profile prefill behavior
- Backward compatibility:
  - Existing resume data remains valid.
  - Existing editor architecture and event flow are preserved.
