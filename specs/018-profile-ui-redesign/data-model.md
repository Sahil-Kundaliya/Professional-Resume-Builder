# Data Model: Profile Page UI Redesign

## UI Entities and Presentation Groups

This feature does not introduce new data models. It reuses the existing profile data entity and adds presentation-focused groupings.

### ResumeProfile

- Existing entity representing user-entered profile values.
- Fields used by this feature:
  - `fullName`
  - `jobTitle`
  - `profileImagePath`
  - `summary`
  - `email`
  - `phoneCountryCode`
  - `phoneNumber`
  - `address`
  - `portfolioLink`
  - `birthDate`
  - `skills`
  - `experiences`
  - `educationRecords`
  - `awards`
  - `certifications`
  - `hobbies`
  - `references`

### Presentation Groups

- `ProfileHeader`: visual container for the avatar, name, job title, and summary highlight.
- `ProfileSectionCard`: reusable card wrapper for each profile content group.
- `ProfileSectionHeader`: standard section heading style for visuals.
- `ProfileDetails`: distinct cards for contact info, experience, education, skills, hobbies, awards, certifications, and references.

## Validation and Constraints

- No storage schema changes are required.
- The redesign must preserve all currently available profile values.
- The feature is limited to presentation only, with no additional persistence or data flow changes.
