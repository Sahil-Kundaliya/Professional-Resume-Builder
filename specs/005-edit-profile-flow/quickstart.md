# Quickstart: Edit Profile Flow

## Goal

Turn the current placeholder Profile tab into a reusable profile management flow with a Profile summary page, a dedicated Edit Profile page, validated dynamic sections, bottom-sheet editors for structured records, and local persistence for one scalable reusable profile.

## Planned Behavior

- The Profile page shows the latest saved profile information instead of static placeholder copy.
- The Profile page exposes an Edit button that opens a dedicated Edit Profile page.
- The Edit Profile page supports image selection, editable basic details, and repeatable profile sections.
- Skills and hobbies start with one visible editable item and support add/remove behavior.
- Work experience and education are managed through bottom sheets with required-field validation.
- Awards and certifications support multiple editable entries with title and date.
- Validation messages are clear and keep the user's entered values intact.
- Saved profile data persists locally and remains structured for future reuse.

## Implementation Steps

1. Replace the placeholder-only Profile page with a state-driven summary screen and Edit entry point.
2. Build the `profile` feature layers for reusable profile entities, storage models, repository contracts, persistence, and use cases.
3. Add an Edit Profile page that loads the saved profile into a draft form state.
4. Implement basic-details validation for email, phone, birth date, and gallery-backed image selection.
5. Create inline repeatable widgets for skills, hobbies, awards, and certifications.
6. Create bottom-sheet editors for experience and education with record-level required-field validation.
7. Save the validated profile locally, then refresh the Profile summary view from persisted data.
8. Keep the resulting profile aggregate reusable for downstream resume or export flows without coupling edit UI to those consumers.

## Focused Validation

1. Open the Profile tab and confirm the page shows current saved data plus an Edit action.
2. Tap Edit and confirm the Edit Profile page opens in one tap.
3. Change basic profile details, save, and confirm the Profile page refreshes with the saved values.
4. Attempt to select a future birth date and confirm the flow prevents it.
5. Enter invalid email and phone values and confirm validation messages appear without clearing unaffected fields.
6. Add and remove skills, hobbies, awards, and certifications, save, and confirm the saved state reflects the exact remaining items.
7. Add an experience and an education record through bottom sheets, verify required-field validation, save valid records, and confirm they render on the Profile page after reload.
8. Reopen the app flow and confirm saved profile data still appears.

## Expected Code Areas

- `lib/app.dart`
- `lib/config/di/injection_container.dart`
- `lib/core/constants/app_routes.dart`
- `lib/features/profile/profile_injection.dart`
- `lib/features/profile/data/`
- `lib/features/profile/domain/`
- `lib/features/profile/presentation/pages/`
- `lib/features/profile/presentation/widgets/`
- `lib/features/profile/presentation/bloc/`
- `lib/features/resume/domain/entities/`
- `test/features/profile/`

## Validation Status

- Planning artifacts only; implementation validation is deferred to `/speckit-tasks` and execution.
- Recommended post-implementation checks: `flutter analyze`, targeted widget tests for form flows and bottom sheets, and manual verification of profile persistence and validation states.