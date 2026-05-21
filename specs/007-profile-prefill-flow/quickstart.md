# Quickstart: Template Preview Profile Prefill Flow

## Goal

Implement conditional template-start behavior that asks users to choose create-new or prefill only when stored profile data is usable, while preserving direct navigation when profile data is absent.

## Planned Behavior

- Tap "Use this template" triggers profile availability check.
- No usable profile data: directly create resume and navigate to editor (no dialog).
- Usable profile data: show dialog titled "Select contest to create CV" with actions "Create new" and "Use profile data".
- Create new: proceed with current empty resume behavior.
- Use profile data: apply field-wise prefill and proceed.
- Null/empty individual fields are skipped, not blocking other field prefills.

## Implementation Steps

1. Identify current create flow entry in `TemplatePreviewPage` and extract tap handling into a dedicated async flow method.
2. Add a profile availability reader that determines whether saved profile has usable mapped values.
3. Keep direct create-new path as default for unavailable/empty/error states.
4. Add conditional dialog presentation only when profile is available.
5. Route dialog actions into explicit creation choices (`createNew`, `useProfileData`).
6. Add a profile-to-resume mapping layer that builds partial prefill updates field-by-field.
7. Apply prefill patch only for valid fields, then continue to editor navigation with selected template.
8. Guard against duplicate event dispatch/navigation in asynchronous dialog flow.

## Focused Validation

1. With no saved profile file or placeholder-only profile, tap "Use this template" and verify no dialog appears.
2. With partial profile data (for example full name only), choose "Use profile data" and verify only full name is prefilled.
3. With fuller profile data, choose "Use profile data" and verify mapped fields populate image, name, job title, birth date, and additional values.
4. With available profile data, choose "Create new" and verify editor opens with non-prefilled baseline content.
5. Dismiss dialog and verify no resume is created and preview page remains visible.
6. Stress test repeated quick taps and verify only one creation/navigation happens per completed user choice.

## Expected Code Areas

- `lib/features/resume/presentation/pages/template_preview_page.dart`
- `lib/features/resume/presentation/bloc/resume_event.dart`
- `lib/features/resume/presentation/bloc/resume_bloc.dart`
- `lib/features/resume/domain/entities/resume_document.dart`
- `lib/features/profile/domain/entities/resume_profile.dart`
- `lib/features/profile/domain/repositories/profile_repository.dart`
- `lib/features/profile/data/datasources/profile_local_data_source.dart`
- `test/features/resume/`

## Validation Status

- Implementation complete for phased flow behavior in template preview and resume creation.
- Manual validation targets remain as the final verification checklist for QA and release sign-off.