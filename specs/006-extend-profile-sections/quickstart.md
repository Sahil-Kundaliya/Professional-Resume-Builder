# Quickstart: Extend Profile Sections

## Goal

Add experience, hobbies, education, awards, and certifications to the existing Profile feature as repeatable sections while preserving all current basic field behavior and minimizing code changes.

## Planned Behavior

- Existing fields remain unchanged in both Profile view and Edit Profile flows.
- Profile view shows section lists when data exists and a clear add/empty state when no data exists.
- Edit Profile provides plus actions for experience, education, awards, and certifications.
- Tapping plus opens a section-specific bottom-sheet form.
- Users can add multiple items per section.
- Saved section items appear in profile view after save and reload.

## Implementation Steps

1. Keep existing `BasicDetailsSection` and existing field wiring unchanged.
2. Add profile-view widgets for list rendering of experience, hobbies, education, awards, and certifications with empty/add states.
3. Extend Edit Profile layout with section cards and add controls.
4. Add bottom-sheet forms for experience, education, awards, and certifications with required-field checks.
5. On successful bottom-sheet submit, append item to the corresponding list in the edit draft.
6. Reuse existing profile save flow so all section lists persist with the profile record.
7. Verify profile summary correctly reflects added items and preserves all original field values.

## Focused Validation

1. Open Edit Profile and confirm existing fields (image, full name, job title, summary, email, address, country code, phone number, portfolio link, birth date) are unchanged.
2. Add one experience via plus button and bottom sheet; save and verify it appears in Profile view list.
3. Add one education via plus button and bottom sheet; save and verify it appears in Profile view list.
4. Add one award and one certification via their bottom sheets; save and verify both appear in Profile view.
5. Add multiple items in each section and verify list order and persistence.
6. Leave a required field empty in a bottom sheet and confirm item is not added until corrected.
7. Cancel a bottom sheet and confirm no data is changed.
8. Verify empty sections provide clear add/empty state without breaking existing profile cards.

## Expected Code Areas

- `lib/features/profile/presentation/pages/profile_page.dart`
- `lib/features/profile/presentation/pages/edit_profile_page.dart`
- `lib/features/profile/presentation/widgets/`
- `lib/features/profile/presentation/bloc/`
- `lib/features/profile/domain/entities/resume_profile.dart`
- `lib/features/profile/data/models/resume_profile_model.dart`
- `lib/features/profile/data/mappers/resume_profile_mapper.dart`
- `test/features/profile/`

## Validation Status

- Planning artifacts generated; implementation and executable verification are deferred to `/speckit-tasks` and implementation execution.