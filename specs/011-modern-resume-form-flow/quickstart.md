# Quickstart: Modern Resume Form and Template-Aware Preview

## Goal

Modernize resume form and preview UX while preserving current resume generation architecture and template rendering pipeline.

## Planned Behavior

- Template selection and template preview remain the entry path.
- Resume form is redesigned with clearer section grouping, hierarchy, and spacing.
- Form-related bottom sheets provide consistent add/edit interactions for dynamic records.
- Preview action is visually stronger and aligned with selected template branding.
- Selected template defines enabled, hidden, and required fields.
- Preview is blocked until required fields are complete with field-level feedback.
- Optional modules are omitted from preview when empty.
- Preview supports zoom in/out for document inspection.

## Implementation Steps

1. Redesign `resume_form_page.dart` with reusable section shells and responsive layout spacing.
2. Standardize bottom-sheet UI for work experience, education, and reusable dynamic list editing patterns.
3. Add template field configuration support for enabled/hidden/required field sets.
4. Introduce validation orchestrator that derives `canPreview` from template-required fields and field states.
5. Update preview action component styling and placement for stronger emphasis and template alignment.
6. Add conditional section filtering before preview rendering to hide empty optional modules.
7. Add zoom controls in preview page with stable scaling behavior.
8. Add/adjust tests for field validation, preview gating, bottom-sheet editing, section omission, and zoom interactions.

## Focused Validation

1. Choose two templates with different required-field rules and verify visible/required indicators differ correctly.
2. Leave one required field empty, tap preview, and verify navigation is blocked with field-level feedback.
3. Fill all required fields and verify preview navigation succeeds on first attempt.
4. Add/edit/remove entries in work experience and education bottom sheets and verify only targeted records change.
5. Leave skills/hobbies/awards/references empty and verify those sections are not rendered in preview.
6. Use zoom in/out in preview and verify readability and smooth inspection at multiple levels.
7. Verify template rendering output remains consistent with existing generation architecture.

## Expected Code Areas

- `lib/features/resume/presentation/pages/resume_form_page.dart`
- `lib/features/resume/presentation/pages/pdf_preview_page.dart`
- `lib/features/resume/presentation/widgets/`
- `lib/features/resume/presentation/bloc/`
- `lib/features/resume/domain/entities/`
- `lib/features/resume/data/mappers/`
- `lib/features/resume/data/models/`
- `lib/features/resume/data/repositories/`
- `test/features/resume/`

## Validation Status

- Planning artifacts only. Implementation validation occurs after task generation and execution.
- Recommended post-implementation checks: `flutter analyze`, targeted widget/bloc tests, and manual flow verification from template selection to preview.
