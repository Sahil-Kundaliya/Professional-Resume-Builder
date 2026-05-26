# Research: Resume Editor Interaction Improvements

## Decision 1: Scope all behavior changes to resume presentation/editor surfaces

- Decision: Implement keyboard dismissal, AppBar cleanup, action cleanup, and toolbar expansion strictly inside Resume Editor presentation files (`resume_editor_page.dart`, `resume_canvas.dart`, `formatting_toolbar.dart`) with only minimal supporting updates in resume domain/bloc for style metadata if needed.
- Rationale: This satisfies the hard requirement to avoid unrelated module changes and preserves navigation/storage/template/profile flows.
- Alternatives considered:
  - Cross-feature abstraction refactor for editor interactions: rejected due to unnecessary risk and scope expansion.
  - Global app-level gesture handling for keyboard dismissal: rejected because behavior is feature-specific and may affect unrelated screens.

## Decision 2: Use explicit focus dismissal for outside taps

- Decision: On outside-tap in Resume Editor, call focus-unfocus behavior in addition to selection clear, ensuring keyboard dismissal across all editable sections.
- Rationale: Current flow clears selected field but does not reliably dismiss keyboard. Explicit focus management is deterministic and low-risk.
- Alternatives considered:
  - Rely on implicit focus loss from gesture wrappers: rejected as inconsistent across nested editable widgets.
  - Wrap each text field with custom focus listeners only: rejected as high-duplication and error-prone.

## Decision 3: Extend formatting eligibility from header-only to all editable field IDs

- Decision: Replace header-only formatting gate with field-id based formatting applicability for all editable text fields while reusing existing bold/italic/underline/font-family/color behavior.
- Rationale: Existing toolbar and style pipeline already works for header fields; extending eligibility and style storage is the most maintainable path to full-field formatting support.
- Alternatives considered:
  - Separate formatting toolbar per section: rejected because it duplicates behavior and risks inconsistent UX.
  - Keep header-only formatting and add ad-hoc per-field style toggles: rejected because it violates requirement for every editable field.

## Decision 4: Enforce bounded text size updates in style state

- Decision: Add bounded text-size controls with min/max clamping (default range 8-13) and block invalid updates outside the range.
- Rationale: Centralized value constraints in style state guarantees consistent rendering and prevents out-of-range edits.
- Alternatives considered:
  - UI-only disabling of increment/decrement buttons: rejected because it does not protect state updates from programmatic paths.
  - Unbounded text size with warning only: rejected because requirement demands controlled limits.

## Decision 5: Make delete clear text content only

- Decision: Keep selected field/widget structure intact and map delete action to field-value reset/clear behavior only.
- Rationale: Requirement explicitly forbids removing fields/widgets; content clear preserves layout and compatibility.
- Alternatives considered:
  - Remove item from list fields: rejected due to structural side effects and potential data-model changes.
  - Delete action performs deselect only (current behavior): rejected because it does not satisfy requested cleanup behavior.

## Decision 6: Normalize skill ratings to editable 0-5 with five-star display

- Decision: Constrain skill rating values to 0-5, provide direct edit controls in edit mode, and render exactly five stars.
- Rationale: Current seven-dot rendering and non-editable rating control are inconsistent with requirements.
- Alternatives considered:
  - Keep seven indicators and remap scale: rejected due to explicit requirement to remove extra star.
  - Freeform numeric input for ratings: rejected for poorer UX and higher validation complexity.

## Decision 7: Preserve backward compatibility and existing flows through targeted regression checks

- Decision: Keep existing event architecture and persistence contracts, then validate unchanged behavior in undo/redo, preview generation, template rendering, and profile prefill.
- Rationale: The feature is additive and must be backward compatible while improving editor usability.
- Alternatives considered:
  - Deep refactor of resume bloc editing model: rejected as high risk and unnecessary for requested outcomes.
