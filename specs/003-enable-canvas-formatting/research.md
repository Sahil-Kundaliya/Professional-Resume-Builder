# Research: Enable Resume Canvas Formatting

## Decision 1: Persist formatting on the resume document with typed header style objects

- **Decision**: Add immutable styling value objects to the resume domain model for the three supported header fields instead of keeping formatting in `ResumeEditorPage` local state.
- **Rationale**: The canvas, save flow, and preview rendering all consume `ResumeDocument`, so placing formatting there makes the selected styles the single source of truth and keeps preview/export behavior aligned with editing.
- **Alternatives considered**:
  - Keep toolbar state only in the page widget: rejected because styling would not survive rebuilds cleanly or flow through save/preview paths.
  - Use a generic map keyed by field id: rejected because the current scope is fixed to three supported fields and explicit typed fields are safer and easier to validate.

## Decision 2: Move toolbar selection state into `ResumeBloc`

- **Decision**: Replace `_isBold`, `_isItalic`, `_isUnderline`, and `_selectedFont` in `ResumeEditorPage` with bloc-driven selection and formatting state.
- **Rationale**: The editor already uses `ResumeBloc` for document and selection changes. Keeping toolbar state in the same bloc prevents divergence between selected field state, rendered canvas state, and toolbar controls.
- **Alternatives considered**:
  - Keep the toolbar local and push only final values into the bloc: rejected because the toolbar would still be disconnected from field switching and undo/redo history.
  - Introduce a second editor-specific state manager: rejected because it adds unnecessary coordination overhead for one feature slice.

## Decision 3: Scope undo/redo history to supported header edits only

- **Decision**: Store reversible snapshots for full name, job position, summary, and their formatting properties, excluding profile image changes and unrelated resume sections.
- **Rationale**: Users expect undo and redo in this feature to target the text fields controlled by the formatting toolbar. A smaller history boundary keeps behavior predictable and easier to test.
- **Alternatives considered**:
  - Snapshot the full resume document on every edit: rejected because it makes undo noisy and couples unrelated changes to formatting actions.
  - Limit undo/redo to formatting toggles only: rejected because text updates and formatting updates are both part of header editing.

## Decision 4: Merge style overrides with each field's existing base presentation

- **Decision**: Keep the canvas header's current visual hierarchy and layer toolbar-controlled overrides on top of each field's base text style.
- **Rationale**: The full name, job position, and summary currently use different sizes and spacing. Merging only the supported style properties preserves template identity while enabling dynamic formatting.
- **Alternatives considered**:
  - Replace each header style wholesale from the toolbar state: rejected because it would erase template-specific defaults such as summary line height or title emphasis.
  - Apply one shared style to all header fields: rejected because the spec requires element-specific independence.

## Decision 5: Use a dedicated font resolver for toolbar options

- **Decision**: Centralize mapping between toolbar font choices and the concrete text style/font builder used during rendering.
- **Rationale**: The feature already depends on `google_fonts`, and a single resolver prevents inconsistency between the toolbar selection and canvas rendering.
- **Alternatives considered**:
  - Inline font mapping in multiple widgets: rejected because it invites drift and complicates later template support.
  - Restrict to system font families only: rejected because the current toolbar already exposes named choices including `Inter` and `Georgia`.

## Decision 6: Keep profile image behavior untouched while protecting it from formatting actions

- **Decision**: Leave existing gallery upload behavior in place and ensure formatting actions are disabled or ignored when no supported text field is selected.
- **Rationale**: The profile image is explicitly out of scope for formatting but must remain functional in the editor flow.
- **Alternatives considered**:
  - Bring the photo into the same selection/undo model: rejected because it expands scope without supporting the requested behavior.
  - Allow toolbar actions while nothing is selected: rejected because it would create ambiguous or misleading editor behavior.