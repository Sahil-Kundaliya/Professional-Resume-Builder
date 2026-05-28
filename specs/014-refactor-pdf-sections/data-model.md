# Data Model: Refactor PDF Section Architecture

## Entity: ResumePdfContext

Description: Aggregated runtime context used by PDF generation to render sections consistently.

Fields:
- template: Optional template configuration including accent/header colors.
- document: Resume document containing all profile and section content.
- accentColor: Resolved PDF color token for section styling.
- headerColor: Resolved header background color token.
- photoWidget: Prepared photo widget resolved from image source.

Validation rules:
- `document` must be present.
- `accentColor` and `headerColor` must resolve to valid PDF colors.

Relationships:
- Provides data to each SectionRenderer through orchestration.

## Entity: SectionRenderer

Description: Reusable rendering unit responsible for producing one PDF section from relevant data.

Fields:
- sectionKey: Stable identifier (profile, summary, work_experience, education, skills, references, awards, certifications, hobbies).
- title: User-facing section heading.
- visibilityRule: Predicate to determine if section should render.
- renderBody: Body renderer producing section content widgets.
- spacingRule: Section-level spacing behavior.

Validation rules:
- `sectionKey` must be unique in composition order.
- `visibilityRule` must return false for null/empty/non-renderable data.

Relationships:
- Consumed by SectionCompositionPlan in deterministic order.

## Entity: SectionVisibilityRule

Description: Pure decision rule that determines whether section content is renderable.

Fields:
- ruleType: null-check, empty-list check, blank-string check, section-specific semantic check.
- inputData: Section-specific source data.
- isVisible: Boolean decision output.

Validation rules:
- Null data must produce `isVisible = false`.
- Empty list data must produce `isVisible = false`.
- Whitespace-only string values must produce `isVisible = false`.

Relationships:
- Owned by SectionRenderer and evaluated before body rendering.

## Entity: SectionCompositionPlan

Description: Ordered composition definition of all potential sections in the PDF body.

Fields:
- orderedSections: Deterministic ordered list of section keys.
- renderedSections: Materialized list of visible rendered section widgets.
- hiddenSections: List of section keys omitted due to visibility rules.

Validation rules:
- Order must remain deterministic between executions.
- Hidden sections must not produce titles, body content, or leftover spacing.

Relationships:
- Drives final widget list provided to PDF multi-page renderer.

## Entity: SharedSectionStyle

Description: Shared style/spacing primitives used by all section renderers.

Fields:
- headingStyle
- dividerStyle
- bodyTextStyle
- metadataTextStyle
- itemSpacing
- sectionSpacing

Validation rules:
- Must preserve existing output typography and spacing defaults.

Relationships:
- Referenced by all SectionRenderer instances to ensure design consistency.

## State Transitions

1. ResumePdfContext Prepared
- Input template/document resolved into render context.

2. Visibility Evaluation
- Each section data input evaluated by SectionVisibilityRule.

3. Section Rendering
- Visible sections render via SectionRenderer body logic.
- Hidden sections return no output.

4. Ordered Composition
- Rendered sections assembled in SectionCompositionPlan order.

5. Final PDF Build
- Header and body composed into final PDF pages.
