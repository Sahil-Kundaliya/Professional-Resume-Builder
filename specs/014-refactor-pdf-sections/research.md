# Research: Refactor PDF Section Architecture

## Decision 1: Section Builder Composition Model

Decision: Use reusable section builder units that return optional PDF widgets and are orchestrated by a deterministic section composition pipeline.

Rationale:
- Removes large inline rendering blocks from the primary generator.
- Enables isolated ownership of each section's formatting and validation behavior.
- Supports future section expansion without increasing generator complexity.

Alternatives considered:
- Keep inline rendering with helper methods only: rejected due to continued orchestration complexity.
- Introduce deep inheritance hierarchy for sections: rejected as unnecessary complexity for stateless rendering logic.

## Decision 2: Layered Section Visibility Rules

Decision: Apply layered guards for section visibility: data normalization checks, section-level semantic checks, and composition-level null filtering.

Rationale:
- Ensures all null/empty/whitespace-only sections are fully omitted.
- Prevents orphan section headers and empty spacing blocks.
- Keeps behavior testable and predictable across all section types.

Alternatives considered:
- Single global guard in orchestration only: rejected because it cannot capture section-specific validity rules.
- Template-only section visibility flags: rejected because enabled sections still need data-based omission.

## Decision 3: Design Fidelity Protection

Decision: Centralize shared section style/spacing primitives and preserve explicit render order to keep output visually consistent.

Rationale:
- Protects typography, spacing, and section hierarchy from accidental drift.
- Reduces repeated magic values and duplicated text styles.
- Keeps current template appearance while improving architecture.

Alternatives considered:
- Re-style sections during refactor: rejected as out of scope and high regression risk.
- Depend on implicit collection iteration order: rejected due to long-term maintainability risk.

## Decision 4: Regression Verification Strategy

Decision: Use a test approach with guard-level unit checks and PDF generation regression scenarios using representative data sets.

Rationale:
- Validates section omission behavior directly for each data condition.
- Confirms populated-section output remains equivalent in behavior after refactor.
- Balances reliability and maintainability without brittle visual-only checks.

Alternatives considered:
- Manual visual verification only: rejected because it is non-repeatable and error-prone.
- Pixel-perfect screenshot comparison as primary gate: rejected due to fragility across environments.

## Decision 5: Future-Section Scalability Pattern

Decision: Define a consistent section contract for title rendering, spacing, list/body rendering, and visibility evaluation.

Rationale:
- New sections can be added with localized changes.
- Existing sections remain unaffected by unrelated section updates.
- Enforces production-grade separation of concerns in PDF architecture.

Alternatives considered:
- Section-specific ad hoc patterns: rejected due to inconsistent behavior and maintenance overhead.
