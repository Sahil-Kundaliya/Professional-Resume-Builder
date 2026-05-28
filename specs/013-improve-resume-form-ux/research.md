# Research: Modern Template-Aware Resume Form UX

## Decision 1: Use Sectioned Card-Based Form Composition

- Decision: Redesign the form into visually separated, reusable section containers for personal information, work experience, education, skills, hobbies, references, and awards.
- Rationale: Card-style grouping improves scanability, reduces cognitive load, and avoids a long uninterrupted field list.
- Alternatives considered:
  - Keep single-list vertical fields with minor spacing tweaks: rejected because hierarchy remains weak.
  - Split into multiple pages: rejected because it adds navigation friction for this scope.

## Decision 2: Make Template Accent Colors a First-Class Form Input

- Decision: Drive key form accents from selected template style values and apply them to section headers, highlights, focus states, and action buttons.
- Rationale: Aligning form styling with the selected template improves perceived quality and experience continuity.
- Alternatives considered:
  - Keep static form colors regardless of template: rejected because output and editing experiences feel disconnected.
  - Allow user-custom colors inside form: rejected because it expands scope beyond template-aware styling.

## Decision 3: Standardize Dynamic Section Interaction Patterns

- Decision: Use consistent add/edit/remove interaction flows and bottom-sheet behavior across repeatable sections.
- Rationale: Consistency lowers user error rates and improves learnability when editing multiple sections.
- Alternatives considered:
  - Keep per-section custom interactions: rejected due to inconsistent UX and duplicated logic.
  - Replace bottom sheets everywhere with full-screen editors: rejected as unnecessary for current constraints.

## Decision 4: Replace Image Path Display With In-Form Preview

- Decision: Show selected profile image preview in a dedicated styled container and reserve path as internal state only.
- Rationale: Users need visual confirmation of selected image quality and cropping context.
- Alternatives considered:
  - Continue showing only image path string: rejected as non-user-friendly.
  - Open preview only in a separate modal: rejected because immediate inline confirmation is faster.

## Decision 5: Add Skill Rating as a Core Skill Attribute

- Decision: Extend skill editing to include a required 1-5 star rating with persisted edit support.
- Rationale: Skill proficiency is a key resume signal; star UI is quick to understand and edit.
- Alternatives considered:
  - Numeric text input for skill level: rejected because slower and less intuitive.
  - Optional skill rating: rejected because inconsistent downstream rendering and data quality.

## Decision 6: Preserve Existing Feature Architecture While Introducing Reusable UI Units

- Decision: Keep feature boundaries in `lib/features/resume/` and introduce reusable form section/pattern widgets instead of one-off page-only code.
- Rationale: Meets production-grade scalability requirement without architectural churn.
- Alternatives considered:
  - Large one-file page rewrite: rejected due to maintainability risk.
  - Global shared UI refactor outside resume feature: rejected as out of scope.

## Clarification Resolution

All technical context unknowns are resolved; no remaining NEEDS CLARIFICATION items.
