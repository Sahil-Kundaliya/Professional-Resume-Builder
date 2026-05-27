# Contract: Resume Form Preview and Optional Section Rendering

## Purpose

Define the behavioral contract between Resume Form UI, Resume BLoC validation flow, and preview/PDF rendering for this feature.

## Scope

- Resume form preview action handling
- Validation result handling and user feedback expectations
- Optional section rendering rules for preview output

## Actors

- User (resume creator)
- Resume Form page (`resume_form_page.dart`)
- Resume BLoC (`resume_bloc.dart`)
- Preview/PDF rendering path (canvas/PDF service)

## Inputs

### Form Input Payload
- Source: Editable `ResumeDocument` state
- Includes scalar fields and optional module collections

### Preview Request Event
- Trigger: User taps Preview button
- Event contract: Validation must run before any preview navigation attempt

## Output Contract

### Validation Pass
- Condition: No field errors and no missing required fields
- Result:
  - `canPreview` true in loaded state
  - Navigation to preview route allowed
  - No validation Snackbar shown

### Validation Fail
- Condition: Missing required fields and/or invalid values
- Result:
  - `canPreview` false in loaded state
  - Navigation to preview route blocked
  - Snackbar shown with:
    - human-readable missing/invalid field guidance
    - corrective next step

### Preview/Render Failure
- Condition: Exception during preview generation/render path after validation pass
- Result:
  - Navigation completion blocked or preview failure surfaced safely
  - Snackbar shown with retry guidance
  - App remains stable (no crash)

### Unexpected Error
- Condition: Non-domain exception in preview flow
- Result:
  - Safe failure path
  - Generic but actionable Snackbar guidance

## Error Message Contract

Feedback categories and expectations:
- `missing_required`: identify exactly which required fields are missing
- `validation`: identify invalid field values and expected format
- `preview_failure`: indicate preview generation failed, suggest retry
- `render_failure`: indicate rendering failed, suggest checking data and retrying
- `unexpected_error`: indicate something went wrong, suggest retry

Message quality rules:
- Plain language
- Action-oriented guidance
- No raw exception dumps

## Optional Section Rendering Contract

Applies to:
- education
- work experience
- skills
- hobbies
- awards
- certifications
- references
- other optional modules in resume form scope

Render rule:
- Section should render only when:
  1) template allows section visibility, and
  2) section has meaningful data

Meaningful data rule:
- Null -> empty
- Empty list -> empty
- List with only blank/whitespace values -> empty
- Composite records with all meaningful fields blank -> empty

Layout rule:
- Section heading, content, and spacing are rendered atomically
- If section is empty, none of these artifacts should be emitted

## Non-Goals

- No changes to unrelated feature modules
- No architecture rewrites or storage-model redesign
- No broad UI redesign outside Resume Form scope
