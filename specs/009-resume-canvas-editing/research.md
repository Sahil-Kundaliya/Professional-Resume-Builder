# Phase 0 Research: Resume Canvas Editing

## Decision 1: Keep editing orchestration in existing ResumeCanvas -> ResumeBloc document update flow
- Decision: Continue using canvas-local mutation helpers that emit a full updated `ResumeDocument` through `onDocumentChanged` and `UpdateDocument`.
- Rationale: Current editor architecture already treats `ResumeCanvas` as the inline editing surface and `ResumeBloc` as state owner. This minimizes risk and preserves undo/redo behavior already tied to document snapshots.
- Alternatives considered:
  - Add a separate canvas-specific bloc/cubit: rejected due to architecture expansion and duplicate state ownership risk.
  - Route each canvas action through dedicated new events only: rejected for high event surface area and unnecessary churn.

## Decision 2: Use explicit field-id parsing rules to determine deletability and target item index
- Decision: Derive deletion eligibility from current selected field ID patterns (`exp_*_{i}`, `edu_*_{i}`, `skill_{i}`, `hobby_{i}`, `ref_{i}`, `award_*_{i}`, `cert_*_{i}`) with protected hard-block list (`fullName`, `jobPosition`, `careerGoals`).
- Rationale: The existing canvas already encodes selection identity in field IDs, making this the least invasive and most reliable way to map selection to domain list items.
- Alternatives considered:
  - Add per-widget callback metadata objects for every editable field: rejected as broader widget refactor.
  - Infer section from widget tree position: rejected due to fragility.

## Decision 3: Persist section visibility and title overrides in resume feature domain state
- Decision: Add section-level presentation state to resume feature domain data used by the canvas (visibility flags and title overrides per supported module).
- Rationale: Hiding/showing modules and custom titles must survive rerenders and saves; storing only transient UI state would break persistence and restore behavior.
- Alternatives considered:
  - Store only in local widget state: rejected because data is lost on state reload and cannot be saved.
  - Hardcode title changes only in widget labels: rejected because user customization would not persist.

## Decision 4: Introduce an image editing layer that supports crop + reposition + centering + preview before commit
- Decision: Implement a dedicated image edit interaction for profile photo that provides a preview buffer and explicit apply/cancel commit model.
- Rationale: Current behavior replaces image immediately after pick; requested UX requires non-destructive preview with crop/reposition controls.
- Alternatives considered:
  - Keep image_picker-only flow: rejected because no crop/reposition/preview support.
  - Build raw pixel crop logic manually: rejected due to quality and maintenance risk for production-grade delivery.

## Decision 5: Enforce integrity guards as first-class rules
- Decision: Enforce protection and restore rules centrally in canvas editing logic:
  - Mandatory header fields cannot be deleted or hidden.
  - Deletion removes only selected list item.
  - Hidden modules do not render but retain data for restore.
- Rationale: These are non-negotiable behavior rules in feature requirements and must be deterministic regardless of UI path.
- Alternatives considered:
  - Best-effort UI-only disable states without backend guards: rejected because state could still be mutated indirectly.

## Decision 6: Keep feature scope isolated to resume feature module boundaries
- Decision: Limit implementation and tests to `lib/features/resume/**` and avoid template flow or unrelated module changes.
- Rationale: Explicit project constraint and lower regression risk.
- Alternatives considered:
  - Shared editor framework extraction: rejected as out of scope.
