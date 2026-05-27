# Quickstart: Improve Resume Form Validation and Preview Reliability

## Goal

Validate that Resume Form preview gating, Snackbar feedback, UI refresh, and conditional rendering behave correctly.

## Prerequisites

- Flutter SDK installed and project dependencies resolved
- App launches successfully to template selection and resume form flow

## 1) Launch and Reach Resume Form

1. Start the app.
2. Select a template and enter Resume Form.
3. Confirm form sections are visible and editable.

Expected result:
- Resume Form page loads without errors.

## 2) Validate Preview Gating (Missing Required Fields)

1. Leave one or more required fields empty (or placeholder/whitespace-only).
2. Tap Preview.

Expected result:
- Preview navigation does not occur.
- Snackbar appears with specific missing field guidance.

## 3) Validate Preview Gating (Invalid Values)

1. Enter invalid values (for example malformed email or invalid phone format).
2. Tap Preview.

Expected result:
- Preview navigation does not occur.
- Snackbar identifies invalid field(s) and correction hint.

## 4) Validate Successful Preview Path

1. Fill all required fields with valid values.
2. Tap Preview once.

Expected result:
- Preview opens successfully.
- No validation Snackbar shown.
- No duplicate navigation when tapping rapidly.

## 5) Validate Preview Failure Handling

1. Trigger preview generation/render failure path (test stub or induced runtime failure).
2. Attempt preview with otherwise valid data.

Expected result:
- User sees readable failure Snackbar with retry guidance.
- App remains stable and responsive.

## 6) Validate Conditional Optional Section Rendering

Run each scenario below and verify in preview/PDF output:

1. Empty education -> Education section not rendered.
2. Empty work experience -> Work experience section not rendered.
3. Empty skills/hobbies/references -> corresponding sections not rendered.
4. Empty awards/certifications -> corresponding sections not rendered.
5. Mixed empty + valid items -> only meaningful content is rendered.

Expected result:
- No empty optional section headings appear.
- No blank spacing artifacts from omitted sections.

## 7) Regression Check

1. Save/continue flow still works.
2. Existing non-related features remain unchanged.

Expected result:
- No regressions outside Resume Form and dependent rendering behavior.
