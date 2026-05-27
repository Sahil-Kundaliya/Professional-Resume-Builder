# Data Model: Improve Resume Form Validation and Preview Reliability

## Entity: ResumeDocument (existing, reused)

Purpose: Canonical editable and renderable resume payload.

Primary fields in scope:
- Required profile fields: `fullName`, `jobPosition`, `careerGoals`, `email`, `phone`, `address`, `birthday`, `website`, `photoPath`
- Structured modules: `workExperience`, `education`, `skills`, `awards`, `certifications`
- Text list modules: `hobbies`, `references`
- Section metadata: `sectionVisibility`, `sectionTitleOverrides`

Validation-relevant rules:
- Required textual fields must be non-empty after trim and not placeholder-only.
- Optional modules should be treated as empty if all items are null/blank/whitespace-only.

## Entity: ValidationResult (derived runtime model)

Purpose: Encapsulates current form preview eligibility.

Fields:
- `fieldErrors: Map<String, String>`: format and rule violations per field key
- `missingRequiredFields: Set<String>`: required fields with no meaningful value
- `canPreview: bool` (derived): true when both collections are empty

Validation rules:
- `email` must be syntactically valid when non-empty.
- `phone` must meet minimum valid digit rules when non-empty.
- Required collection fields pass only if at least one meaningful item exists.

State transitions:
- On field update: recompute `ValidationResult`.
- On preview request: recompute and gate navigation by `canPreview`.

## Entity: UserFeedbackMessage (runtime presentation model)

Purpose: Standardized Snackbar payload for user-facing failures.

Fields:
- `type`: one of `validation`, `missing_required`, `preview_failure`, `render_failure`, `unexpected_error`
- `title`: short readable context
- `message`: user-friendly explanation
- `resolutionHint`: explicit action to unblock user

Rules:
- Must never expose internal stack details.
- Must guide corrective action in plain language.

## Entity: SectionRenderDecision (derived runtime model)

Purpose: Reusable decision for optional section visibility in preview/PDF.

Fields:
- `sectionKey: String`
- `isEnabledByTemplate: bool`
- `hasMeaningfulData: bool`
- `shouldRender: bool` where `shouldRender = isEnabledByTemplate && hasMeaningfulData`

Meaningful data rules by module:
- `workExperience`: at least one entry with meaningful date/title/company/description content.
- `education`: at least one entry with meaningful date/course/school/description content.
- `skills`: at least one skill with non-blank name.
- `hobbies`, `references`: at least one non-blank string.
- `awards`, `certifications`: at least one entry with non-blank name and/or date value.

## Relationships

- `ResumeDocument` -> evaluated by `ValidationResult` to determine preview eligibility.
- `ResumeDocument` + template rules -> evaluated into `SectionRenderDecision` per optional module.
- `ValidationResult` and runtime exceptions -> transformed to `UserFeedbackMessage` for Snackbar display.

## Invariants

- Preview navigation is permitted only when `ValidationResult.canPreview == true`.
- Optional sections render only when `SectionRenderDecision.shouldRender == true`.
- Empty optional modules must not leave visual section placeholders or blank spacing.
