# Research: Improve Resume Form Validation and Preview Reliability

## Decision 1: Preview Navigation Must Be Validation-Gated by State

- Decision: Trigger validation first, then navigate to preview only when the loaded state indicates preview eligibility.
- Rationale: The current `ResumeFormPage` preview action navigates immediately after dispatching validation, which allows route changes even when validation fails.
- Alternatives considered:
  - Keep direct navigation from button handler: rejected because it bypasses validation outcome.
  - Move all routing into bloc: rejected to preserve presentation-layer ownership of navigation while still using bloc state for gating.

## Decision 2: Use Reusable Snackbar Feedback Categories

- Decision: Standardize user feedback into reusable categories: validation failure, missing required fields, preview generation failure, and unexpected system error.
- Rationale: Consistent messaging improves user correction speed and avoids silent failures in preview flow.
- Alternatives considered:
  - Inline-only error display: rejected because flow-level failures (preview/render) are not field-scoped.
  - Per-screen ad hoc messages: rejected because it causes inconsistency and duplicate logic.

## Decision 3: Keep Validation and Generation Failures Separate

- Decision: Keep required-field/format validation results separate from preview-generation/render exceptions and show distinct guidance for each.
- Rationale: Users need different corrective actions for data issues vs. system issues.
- Alternatives considered:
  - Merge all failures into one generic error: rejected because it reduces debuggability and user clarity.

## Decision 4: Add Preview Attempt Stability Guard

- Decision: Prevent duplicate preview attempts while validation/generation is in-flight (idempotent tap handling).
- Rationale: Rapid taps can trigger duplicate state transitions and unstable navigation.
- Alternatives considered:
  - Rely on navigation stack behavior: rejected because it does not prevent duplicate event dispatch.

## Decision 5: Use Meaningful-Content Predicates for Optional Section Rendering

- Decision: Introduce reusable content predicates that treat null, empty lists, whitespace-only strings, and placeholder-only values as empty; render optional sections only when predicates pass.
- Rationale: Current rendering paths can show empty section headers/content blocks in preview/PDF output.
- Alternatives considered:
  - Keep `isNotEmpty` list checks only: rejected because entries may exist but still be semantically empty.
  - Hardcode per-screen filtering: rejected because behavior would drift between resume canvas and PDF output.

## Decision 6: Render Sections Atomically (Header + Content + Spacing)

- Decision: Render section container, title, and spacing as a single conditional unit.
- Rationale: Prevents orphaned headers and blank gaps when optional content is empty.
- Alternatives considered:
  - Separate spacing from conditional section: rejected due to residual empty vertical whitespace.

## Decision 7: Scope Preservation

- Decision: Implement changes only in Resume Form and dependent rendering logic needed to enforce optional-section omission; avoid unrelated feature edits.
- Rationale: Matches requirement for production-grade but bounded change set.
- Alternatives considered:
  - Broader redesign across profile/template selection flows: rejected as out of scope.

## Clarification Resolution

All technical context unknowns are resolved; no remaining NEEDS CLARIFICATION items.
