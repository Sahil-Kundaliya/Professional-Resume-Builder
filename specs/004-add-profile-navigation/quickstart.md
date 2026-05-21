# Quickstart: Add Profile Navigation

## Goal

Add a two-tab app shell with Home and Profile, keep the existing Home template flow unchanged, persist one reusable local profile, and let users choose between starting a template from scratch or prefilling the editor from saved profile data.

## Planned Behavior

- The app opens into a shell that exposes Home and Profile in a bottom navigation bar.
- The Home tab preserves the current template list, preview page, and resume editor journey.
- The Profile tab shows a clean summary view with placeholder image, name, and job title when no saved profile exists.
- The Profile tab exposes an Edit Profile flow for optional personal details plus repeated hobbies, skills, work experience, and education entries.
- Saved profile data persists locally and is reused later.
- Tapping Use this template in preview opens a confirmation dialog with Start From Scratch and Use Your Data.
- Start From Scratch opens a blank resume editor.
- Use Your Data loads the saved profile, prefills matching resume fields, and opens the existing editor with those values still editable.

## Implementation Steps

1. Add an app shell that hosts Home and Profile as top-level tabs without rewriting the existing Home internals.
2. Create the `profile` feature slice with:
   - domain entities for reusable profile data and repeated items
   - a local datasource and repository for one persisted profile
   - bloc or equivalent presentation state for summary and edit flows
   - summary and edit pages/widgets
3. Add local persistence for the profile record and copied image path in the app documents directory.
4. Add a profile-to-resume mapping path that can initialize a new resume document from saved profile data.
5. Update template preview so Use this template opens a confirmation dialog before the editor is created.
6. Route Start From Scratch to the existing blank-resume path and Use Your Data to the new prefill path.
7. Register profile dependencies in DI and keep cross-feature usage explicit through repositories or use cases.

## Focused Validation

1. Launch the app and confirm Home and Profile appear in bottom navigation.
2. Move between tabs and verify Home still shows templates and opens preview and editor through the current flow.
3. Open Profile for the first time and verify placeholder image, name, and job title appear while the remaining sections can remain empty.
4. Save a partial profile with multiple repeated entries and confirm the data reappears when reopening Profile.
5. From template preview, choose Start From Scratch and confirm the editor opens without profile prefill.
6. Save profile data, return to template preview, choose Use Your Data, and confirm the editor opens with matching fields prefilled while still editable.
7. Save only partial profile data and confirm the prefill path fills only the available values.

## Expected Code Areas

- `lib/app.dart`
- `lib/main.dart`
- `lib/config/di/injection_container.dart`
- `lib/core/constants/app_routes.dart`
- `lib/features/profile/`
- `lib/features/home/presentation/`
- `lib/features/resume/presentation/pages/template_preview_page.dart`
- `lib/features/resume/domain/entities/`
- `lib/features/resume/presentation/bloc/`
- `test/features/profile/`
- `test/features/resume/`

## Validation Status

- Planning artifacts only; implementation validation is deferred to `/speckit-tasks` and execution.
- Recommended post-implementation checks: `flutter analyze`, targeted widget/bloc tests, and manual verification of tab switching, profile persistence, and template-start branching.