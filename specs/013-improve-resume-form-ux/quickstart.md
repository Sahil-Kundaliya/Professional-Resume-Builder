# Quickstart: Modern Template-Aware Resume Form UX

## Goal

Verify that ResumeFormPage delivers a modern, sectioned, template-aware, and user-friendly form experience while preserving existing functionality.

## Prerequisites

- Flutter SDK installed and dependencies resolved.
- App launches to resume editing flow.
- At least one resume template is available for selection.

## 1) Open Resume Form

1. Launch app and navigate to ResumeFormPage.
2. Confirm page renders without errors.

Expected result:
- Form appears with grouped visual sections and modern hierarchy.

## 2) Validate Section Grouping and Readability

1. Scroll through all form sections.
2. Confirm personal information, work experience, education, skills, hobbies, references, and awards are visually separated.

Expected result:
- No single long plain list of text fields.
- Consistent spacing, section titles, and container styling.

## 3) Validate Template-Aware Styling

1. Select template A and open form.
2. Observe accents on buttons, section headers, highlights, and focused inputs.
3. Switch to template B and reopen form.

Expected result:
- Accent styling updates to selected template.
- Readability remains intact in all form states.

## 4) Validate Dynamic Section Interactions

1. In each repeatable section, add a new item.
2. Edit the same item.
3. Remove the item.

Expected result:
- Add/edit/remove interactions are consistent across sections.
- Bottom-sheet behavior remains predictable and reusable.

## 5) Validate Profile Image Preview

1. Select a valid profile image.
2. Observe the image area.

Expected result:
- Inline image preview is displayed.
- Raw file path is not shown as the primary UI.

3. Select an invalid or missing image path scenario.

Expected result:
- Graceful fallback placeholder appears.
- Form remains usable.

## 6) Validate Skill Rating (1-5 Stars)

1. Add a skill and assign rating via star control.
2. Save and reopen the skill editor.
3. Update the rating.

Expected result:
- Rating accepts only values from 1 to 5.
- Existing rating is shown during edit.
- Updated rating persists after save.

## 7) Regression Verification

1. Continue through save/preview pathways used before this feature.
2. Confirm existing data and form behavior still function.

Expected result:
- No regressions outside intended form UX and styling improvements.
