# Quickstart: Enable Resume Canvas Formatting

## Goal

Connect the existing floating toolbar to the resume canvas so full name, job position, and summary support immediate formatting updates, reversible history, and consistent preview rendering.

## Implemented Behavior

- Full name, job position, and summary remain selectable header fields inside the resume canvas.
- The floating toolbar now applies bold, italic, underline, font family, and text color changes to the currently selected supported field.
- Toolbar state follows the selected supported field and disables formatting actions for unsupported selections.
- Undo and redo now operate on supported header text and style changes.
- Header formatting is persisted on the resume document and reused during PDF preview/export rendering.
- Profile image selection now continues through a gallery picker flow without entering text-formatting history.

## Implementation Steps

1. Extend the resume domain and data models with persisted header style objects for `fullName`, `jobPosition`, and `careerGoals`.
2. Add bloc events and state support for:
   - selecting a supported editable header field
   - toggling bold, italic, and underline
   - changing font family and text color
   - undoing and redoing header edits
3. Remove toolbar formatting state from `ResumeEditorPage` and bind the toolbar directly to bloc-derived values.
4. Update `ResumeCanvas` so each supported header field renders its base template style merged with the persisted field-specific overrides.
5. Keep profile image upload behavior unchanged and ensure unsupported selections cannot receive formatting mutations.
6. Verify preview and PDF paths consume the same document formatting state used by the editor.

## Focused Validation

1. Select `fullName`, apply bold, and confirm the canvas updates immediately.
2. Select `jobPosition`, change font and color, and confirm `fullName` styling remains unchanged.
3. Select `careerGoals`, apply underline and italic, switch away, then return and confirm the toolbar reflects the saved styling.
4. Perform multiple supported edits, then use undo and redo to confirm state restoration order is correct.
5. Upload or change the profile image and confirm the image flow still works and is unaffected by text formatting controls.
6. Open the preview/PDF flow and confirm selected header formatting is preserved.

## Validation Status

- `flutter pub run build_runner build --delete-conflicting-outputs`: passed
- `flutter analyze lib/features/resume lib/core/utils/pdf_generator.dart`: passed with non-blocking warnings only
- `flutter test`: passed
- Manual editor, preview, export, and image-picker verification: still recommended on a running device or simulator

## Expected Code Areas

- `lib/features/resume/domain/entities/`
- `lib/features/resume/data/models/`
- `lib/features/resume/data/mappers/`
- `lib/features/resume/presentation/bloc/`
- `lib/features/resume/presentation/pages/resume_editor_page.dart`
- `lib/features/resume/presentation/widgets/resume_canvas.dart`
- `lib/features/resume/presentation/widgets/formatting_toolbar.dart`
- targeted widget/bloc tests under `test/`