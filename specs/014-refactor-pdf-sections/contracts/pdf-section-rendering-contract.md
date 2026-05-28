# Contract: PDF Section Rendering

## Purpose

Define the internal behavioral contract for modular PDF section rendering in resume generation.

## Scope

Applies to the PDF generation flow for:
- profile
- summary
- work experience
- education
- skills
- references
- awards
- certifications
- hobbies

## Section Rendering Contract

1. Section Independence
- Each section is implemented as a reusable renderer unit with isolated formatting and content logic.
- Updating one section must not require changing unrelated section renderer behavior.

2. Deterministic Ordering
- Section rendering follows a fixed composition order defined by the orchestrator.
- Order does not depend on map iteration or incidental list transformations.

3. Visibility Rules
- A section must be omitted when its data is null.
- A section must be omitted when its list data is empty.
- A section must be omitted when string-based content is empty or whitespace-only.
- Omitted sections must not render heading, body, or section spacing artifacts.

4. Design Preservation
- Shared section styles preserve existing typography, spacing, and template appearance.
- Refactor must not introduce user-visible design changes for populated sections.

5. Render Safety
- Section render failure conditions must be contained to section-level handling where possible.
- Valid sections continue to render when unrelated sections are hidden due to empty data.

## Acceptance Contract Scenarios

1. Full Data Scenario
- Given all sections have valid content
- When PDF is generated
- Then all sections render in defined order with current visual style

2. Single Empty Section Scenario
- Given work experience has no renderable entries
- When PDF is generated
- Then work experience is fully omitted and remaining sections render normally

3. Multi Empty Section Scenario
- Given skills, references, and hobbies are empty
- When PDF is generated
- Then those sections are omitted with no blank section gaps

4. Whitespace Data Scenario
- Given a section contains only whitespace values
- When PDF is generated
- Then that section is treated as empty and omitted

## Non-Goals

- Introducing new resume sections beyond current scope
- Changing template look-and-feel
- Adding external service/API interfaces

## Extension Workflow

To add a new PDF section while preserving architecture guarantees:

1. Add a stable section key in `PdfSectionKeys`.
2. Create a dedicated section builder file under `lib/core/utils/pdf_sections/`.
3. Implement section-specific visibility guards for null/empty/whitespace data.
4. Register the section in `PdfSectionRegistry` in the intended render column and order.
5. If the section is user-toggleable, ensure it participates in `sectionVisibility` checks.
6. Run targeted analysis for `lib/core/utils/pdf_generator.dart` and `lib/core/utils/pdf_sections`.

Required outcome:
- Existing sections remain unaffected.
- Hidden sections leave no heading/body/spacing artifacts.
- Deterministic order remains intact.
