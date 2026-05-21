# Research: Extend Profile Sections

## Decision 1: Use additive extension over existing profile implementation

- **Decision**: Implement the new sections by extending current profile entities, draft flow, and page composition, without rewriting existing basic-details logic.
- **Rationale**: The primary business constraint is code safety and no regression for existing fields; additive extension minimizes risk and keeps implementation auditable.
- **Alternatives considered**:
  - Rebuild Edit Profile into a new screen architecture: rejected because it violates minimal-change intent and increases regression risk.
  - Fork profile flow into a parallel feature module: rejected because it creates duplicate state and storage paths.

## Decision 2: Reuse current local profile persistence and mapper pipeline

- **Decision**: Continue using `ProfileLocalDataSource`, `ResumeProfileModel`, and `ResumeProfileMapper` for all new section data.
- **Rationale**: The existing storage path already persists list-based section fields and supports the required scalability for multiple items.
- **Alternatives considered**:
  - Introduce a new storage engine or database layer: rejected as unnecessary for current single-profile scope.
  - Store new section data separately from the profile record: rejected because it complicates load/save consistency.

## Decision 3: Keep existing basic details widget untouched and append new section widgets

- **Decision**: Retain the existing basic details section exactly as-is, and append new section blocks beneath it in Edit Profile.
- **Rationale**: This directly satisfies the requirement to preserve current fields and logic while introducing incremental functionality.
- **Alternatives considered**:
  - Merge basic and new sections into one dynamic schema form: rejected because it changes existing UX and behavior.

## Decision 4: Use section-specific bottom sheets for structured records

- **Decision**: Add dedicated bottom-sheet forms for experience, education, awards, and certifications, each with section-specific required fields.
- **Rationale**: Structured records have multiple fields and fit naturally in focused bottom-sheet workflows that do not disrupt the main form.
- **Alternatives considered**:
  - Inline editing for all structured records: rejected due to form complexity and poorer usability.
  - One generic bottom sheet for all section types: rejected because each section has distinct data requirements.

## Decision 5: Render list sections conditionally on profile view with explicit add affordance

- **Decision**: On profile summary, show populated list sections when data exists and show a clear empty/add state when no data exists.
- **Rationale**: This satisfies both visibility and discoverability requirements while keeping UI uncluttered.
- **Alternatives considered**:
  - Hide empty sections entirely with no add affordance: rejected because it makes section entry harder to discover.
  - Always show full empty section cards: rejected because it increases visual noise.

## Decision 6: Preserve existing draft-save pattern and apply scoped validation

- **Decision**: Keep `ProfileEditDraft` update/save behavior and add validation checks only for newly introduced bottom-sheet inputs and list items.
- **Rationale**: Existing save semantics already work; scoped validation adds required safety without disturbing current field behavior.
- **Alternatives considered**:
  - Introduce a new form engine for all profile fields: rejected because it is high-impact and unnecessary for this scope.
  - Validate only on final save with no section-level checks: rejected because bottom sheets require immediate required-field feedback.