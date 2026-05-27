# Research: Replace Resume Canvas with Form Flow

## Decision 1: Keep `ResumeDocument` as the canonical template-rendering payload

- **Decision**: Continue using `ResumeDocument` as the single source passed into template rendering and PDF generation, while the new form flow edits that data through structured UI rather than direct canvas mutation.
- **Rationale**: The existing template preview page, `ResumeCanvas`, PDF preview page, repository mapper, and prefill mapper already accept `ResumeDocument`. Keeping that aggregate stable avoids rewriting the render stack and narrows the migration to creation UX and bloc behavior.
- **Alternatives considered**:
  - Introduce a brand-new persisted resume aggregate for the form flow: rejected because it would force a second mapping layer into every renderer and repository path before user value is delivered.
  - Keep full-document canvas editing and wrap it in more controls: rejected because the feature explicitly replaces direct canvas editing with a structured form experience.

## Decision 2: Replace the editor screen with a dedicated resume form page in the creation flow

- **Decision**: Route the "Use this template" action to a dedicated resume form page and treat preview as a downstream step from that form, rather than continuing to send users into `ResumeEditorPage`.
- **Rationale**: The requested flow is Template -> Preview -> Resume Form -> Preview -> Generate. A dedicated form page provides a clear separation between data entry and render confirmation, which is not achievable by preserving the current inline canvas-editing screen.
- **Alternatives considered**:
  - Keep the current `/editor` page name and retrofit it into a mixed form/editor screen: rejected because it preserves conceptual coupling to canvas editing and makes cleanup boundaries ambiguous.
  - Send users directly from template preview to PDF preview: rejected because the feature requires editable structured inputs before previewing the result.

## Decision 3: Reuse proven repeatable-section and bottom-sheet patterns from the profile feature

- **Decision**: Use the profile feature's interaction model as the implementation precedent for repeatable lightweight sections and structured bottom-sheet editors, while keeping ownership of the actual resume form widgets inside the resume feature.
- **Rationale**: `edit_profile_page.dart`, `experience_bottom_sheet.dart`, `education_bottom_sheet.dart`, and related profile widgets already demonstrate workable UX for list sections, add actions, validation messaging, and bottom-sheet record editing. Reusing those patterns reduces design risk and preserves consistency across the app.
- **Alternatives considered**:
  - Build new interaction patterns from scratch for every resume section: rejected because the repository already contains validated examples that match the requested UX.
  - Move the entire resume form into the profile feature: rejected because resume creation still belongs to the `resume` feature and should only consume profile data through explicit prefill seams.

## Decision 4: Favor targeted bloc events and draft-state updates over full-document replacement

- **Decision**: Evolve `ResumeBloc` toward field- and section-level updates for the resume form, using a draft-oriented loaded state instead of relying on `UpdateDocument` from inline canvas widgets.
- **Rationale**: The current canvas editor emits whole-document replacements and maintains `selectedFieldId`, undo/redo stacks, and formatting state that are tied to direct on-canvas editing. A structured form flow is easier to test and reason about when the state model is explicit about which field or section changed.
- **Alternatives considered**:
  - Keep `UpdateDocument` as the primary mutation path for the form: rejected because it makes form behavior coarse-grained and keeps canvas-driven coupling alive.
  - Replace `ResumeBloc` entirely with local page state: rejected because preview, persistence, and creation flow already depend on shared feature state.

## Decision 5: Preserve the existing prefill and repository seams

- **Decision**: Continue to create the base resume through `CreateResume`, retain optional prefill through `ProfileToResumePrefillMapper`, and keep local persistence behind `IResumeRepository`.
- **Rationale**: The current flow already supports profile-aware resume creation and repository-backed persistence. Preserving those seams keeps cross-feature dependencies stable and prevents this UX migration from becoming a storage or integration rewrite.
- **Alternatives considered**:
  - Remove profile prefill from the new form flow: rejected because the current creation choice is already implemented and can continue to add value before the user lands on the form.
  - Bypass the repository because the draft is form-based: rejected because preview/generate still benefits from existing resume-domain persistence and future save flows.

## Decision 6: Treat canvas-editing widgets and formatting helpers as cleanup candidates, not renderer dependencies

- **Decision**: Preserve `ResumeCanvas` only as a non-editable renderer for template preview and downstream preview/generation, while removing or retiring editor-only elements such as formatting toolbars, selected-field logic, and canvas mutation helpers once the form flow covers creation.
- **Rationale**: The renderer remains useful, but the inline-edit surface, field selection model, and related action logic conflict with the requested form-driven architecture and create maintenance overhead if left active without a user-facing path.
- **Alternatives considered**:
  - Delete all canvas code immediately: rejected because template preview and rendered output still rely on the visual canvas renderer.
  - Keep editor-only canvas controls dormant in the codebase: rejected because unused logic will make the resume feature harder to understand and evolve.