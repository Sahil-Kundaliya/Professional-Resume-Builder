# Quickstart: Profile Page UI Redesign

## Goal

Update the existing Profile page presentation to a premium visual design while keeping all behavior unchanged.

## Relevant files

- `lib/features/profile/presentation/pages/profile_page.dart`
- `lib/features/profile/presentation/widgets/profile_identity_card.dart`
- `lib/features/profile/presentation/widgets/profile_summary_section.dart`
- `lib/features/profile/presentation/widgets/profile_contact_section.dart`
- `lib/features/profile/presentation/widgets/profile_skills_section.dart`
- `lib/features/profile/presentation/widgets/profile_experience_section.dart`
- `lib/features/profile/presentation/widgets/profile_education_section.dart`
- `lib/features/profile/presentation/widgets/profile_awards_section.dart`
- `lib/features/profile/presentation/widgets/profile_certifications_section.dart`
- `lib/features/profile/presentation/widgets/profile_hobbies_section.dart`
- `lib/features/profile/presentation/widgets/profile_section_card.dart`
- `lib/features/profile/presentation/widgets/profile_section_header.dart`

## Implementation approach

1. Preserve the `ProfileBloc` and navigation behavior in `profile_page.dart`.
2. Replace the top-level page layout with a stronger visual hierarchy and premium spacing, using a single-column scroll view.
3. Enhance the header card to include a larger avatar, gradient or layered background, bold title text, and a more polished summary preview.
4. Refine each section card with consistent border radius, shadows, padding, and section spacing.
5. Improve typographic scale for headings, subheadings, and detail text while keeping content structure unchanged.
6. Verify the redesigned page with profiles containing all section types and with missing optional data.

## Notes

- No business logic, state management, navigation, storage, or model changes are allowed.
- The redesign should be responsive for phone and tablet widths.
