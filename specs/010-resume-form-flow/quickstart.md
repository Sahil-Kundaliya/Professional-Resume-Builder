# Quickstart: Replace Resume Canvas with Form Flow

## Goal

Replace the direct resume canvas editing path with a form-driven creation experience that preserves template browsing, template preview, profile-prefill support, rendered preview, and template-based output generation.

## Planned Behavior

- The user continues to browse templates from the existing template list.
- Opening a template still shows a non-editable preview of that template.
- Tapping "Use this template" creates or prefills a resume draft, then opens a dedicated resume form page instead of the old canvas editor.
- The resume form exposes structured fields for core details plus repeatable content sections.
- Work experience and education are managed through bottom-sheet editors.
- Skills, hobbies, awards, certifications, and references are managed through scalable repeatable form sections.
- Preview renders the selected template using the current form draft.
- Returning from preview keeps all current values available for further editing.
- Obsolete canvas-editing controls and state are removed once the new flow covers creation.

## Implementation Steps

1. Replace the current editor navigation target in the template-preview flow with a dedicated resume form route and page.
2. Keep `CreateResume` plus optional profile-prefill behavior, but initialize the new form draft instead of the old canvas-edit page.
3. Build reusable form sections for basic details and lightweight repeatable sections inside `lib/features/resume/presentation/widgets/`.
4. Implement work experience and education bottom sheets using the profile feature's proven structure as the UX reference.
5. Update `ResumeBloc` and related state/events so form updates are explicit and no longer depend on selected-field canvas editing.
6. Connect the form's Preview action to the existing template-rendering and PDF-preview pipeline using the latest `ResumeDocument` draft.
7. Remove obsolete editor-only dependencies such as formatting toolbar wiring, selected-field behavior, and unreachable canvas-edit helpers.
8. Add focused tests around route flow, draft updates, dynamic section behavior, preview accuracy, and cleanup regressions.

## Focused Validation

1. Open the template list, select a template, open its preview, tap "Use this template," and confirm the app opens the resume form instead of the old editor.
2. If profile data is available, confirm the existing creation-choice behavior still works and the selected prefill appears in the form.
3. Edit basic information fields and confirm the draft updates immediately without any canvas selection controls.
4. Add, edit, and delete multiple work experience entries through bottom sheets, then confirm only the targeted entries change.
5. Add, edit, and delete multiple education entries through bottom sheets, including multiple text inputs, then confirm sibling entries remain intact.
6. Add and remove skills, hobbies, awards, certifications, and references, then confirm empty and populated states render correctly in the form.
7. Tap Preview and confirm the selected template renders using the latest draft values.
8. Return from preview to the form, make another change, preview again, and confirm the renderer reflects the updated values.
9. Verify no obsolete canvas-edit actions, formatting controls, or dead-end editor navigation remain reachable in the creation flow.

## Expected Code Areas

- `lib/app.dart`
- `lib/core/constants/app_routes.dart`
- `lib/config/di/injection_container.dart`
- `lib/features/resume/presentation/pages/`
- `lib/features/resume/presentation/widgets/`
- `lib/features/resume/presentation/bloc/`
- `lib/features/resume/domain/entities/`
- `lib/features/resume/data/`
- `lib/features/profile/presentation/widgets/` as reference-only reuse targets
- `test/features/resume/`

## Validation Status

- Planning artifacts only; implementation validation is deferred to `/speckit-tasks` and execution.
- Recommended post-implementation checks: `flutter analyze`, focused widget and bloc tests for form behavior, and manual end-to-end verification of template selection, form entry, preview, and generation.