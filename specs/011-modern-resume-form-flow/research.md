# Research: Modern Resume Form and Template-Aware Preview

## Decision 1: Preserve `ResumeDocument` as the canonical render contract

- **Decision**: Keep `ResumeDocument` as the single source for template rendering, preview, and PDF generation; modernize form capture and validation around it.
- **Rationale**: This preserves architecture and avoids creating a second document model that would add mapping complexity and regression risk.
- **Alternatives considered**:
  - Create a new preview-only document aggregate: rejected because it duplicates mapping responsibilities and risks rendering drift.
  - Keep current canvas-edit-first behavior: rejected because requested UX is guided form-first with validation gates.

## Decision 2: Add template-owned field rules for visibility and requiredness

- **Decision**: Extend template configuration to define enabled fields, hidden fields, and required fields, then derive form rendering and validation from the selected template.
- **Rationale**: Feature requirements explicitly demand template-aware requiredness and field visibility while preserving template identity.
- **Alternatives considered**:
  - Hardcode required fields globally: rejected because requiredness must vary by template.
  - Keep visibility in UI-only conditions without template metadata: rejected because this does not scale and fractures template ownership.

## Decision 3: Redesign `ResumeFormPage` around reusable section composition

- **Decision**: Build a sectioned layout with clear hierarchy: personal info, work experience, education, skills, hobbies, awards, and references; use shared section wrappers and list controls.
- **Rationale**: Section-level composition improves scanability and supports scalable maintenance for dynamic modules.
- **Alternatives considered**:
  - Keep flat form layout and only adjust styling: rejected because it does not sufficiently improve grouping and task clarity.
  - Build unique UI logic for each section: rejected because reusable section components are required for production-grade scalability.

## Decision 4: Standardize modern bottom-sheet patterns for structured records

- **Decision**: Use consistent bottom-sheet architecture for add/edit of work experience, education, and other dynamic records with explicit validation and commit/cancel states.
- **Rationale**: This improves usability and consistency while reducing duplicate interaction logic.
- **Alternatives considered**:
  - Use full-screen edit pages for all record edits: rejected because it adds navigation overhead for short structured edits.
  - Keep mixed editing surfaces: rejected due to inconsistent user expectations and maintenance cost.

## Decision 5: Gate preview with a scalable validation layer

- **Decision**: Evaluate template-required fields before preview navigation, block preview on invalid state, and surface field-level validation feedback.
- **Rationale**: This directly satisfies the requirement to prevent incomplete preview and increases user confidence.
- **Alternatives considered**:
  - Validate only after entering preview: rejected because it violates explicit preview-blocking behavior.
  - Validate only touched fields: rejected because missing untouched required fields would still allow invalid progression.

## Decision 6: Omit empty optional sections at render time

- **Decision**: Apply section visibility filtering so optional modules with no meaningful data are excluded from preview rendering.
- **Rationale**: Produces cleaner output and meets required conditional rendering behavior across all optional modules.
- **Alternatives considered**:
  - Render empty section headers with placeholders: rejected because requirements call for omission when empty.
  - Hide only a fixed subset (skills/hobbies/awards/references): rejected because behavior must apply to all optional modules.

## Decision 7: Improve preview inspection with zoom controls and stable rendering

- **Decision**: Add zoom in/out interactions in preview while maintaining the existing rendering pipeline and document fidelity.
- **Rationale**: Users need better inspection without changing the architecture of preview generation.
- **Alternatives considered**:
  - Replace preview renderer completely: rejected due to architecture-preservation requirement and unnecessary risk.
  - Keep fixed-scale preview only: rejected because zoom support is an explicit requirement.
