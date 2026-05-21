# Contract: Profile Edit Flow

## Scope

This contract defines the user-facing behavior for the Profile summary page, Edit Profile page, repeatable profile sections, structured bottom-sheet entry flows, validation handling, and reusable local profile persistence.

## Profile Summary Contract

| Element | Requirement | Expected Behavior |
| --- | --- | --- |
| Saved profile view | Must display the latest saved profile information | Users see current identity, contact, and repeated profile sections without entering edit mode |
| Edit action | Must be available on the Profile page | Tapping Edit opens the Edit Profile page |
| Empty sections | Must not block the page | Sections with no saved data render safely as empty or lightweight placeholders |

## Edit Profile Navigation Contract

1. The user can enter Edit Profile from the Profile page in one tap.
2. The Edit Profile page loads the latest saved values when they exist.
3. Leaving the Edit Profile page after a successful save returns the user to a Profile page that reflects the saved changes.

## Basic Details Contract

| Field | Required Behavior |
| --- | --- |
| Profile image | User can choose an image from the device gallery and replace it later |
| Full name | Editable text field with validation feedback when invalid |
| Job title | Editable text field |
| Summary | Multiline editable field limited to five visible lines |
| Email | Editable text field with email validation |
| Address | Editable text field |
| Phone | Numeric phone entry paired with a country code selector |
| Portfolio link | Editable text field |
| Birth date | Date-only input that does not allow future dates |

## Repeatable Section Contract

| Section | Initial State | Required Behavior |
| --- | --- | --- |
| Skills | One visible row | User can add, edit, rate from 1-5, and remove skill rows |
| Hobbies | One visible field | User can add, edit, and remove hobby entries |
| Awards | Existing saved items or empty state | User can add, edit, and remove award entries with title and date |
| Certifications | Existing saved items or empty state | User can add, edit, and remove certification entries with title and date |

## Structured Record Contract

| Record Type | Trigger | Editing Surface | Save Rule |
| --- | --- | --- | --- |
| Work experience | User taps add or edit | Bottom sheet | Company, position, start date, end date, and all detail lines required before save |
| Education | User taps add or edit | Bottom sheet | School/college, degree, start date, and end date required before save |

## Validation Contract

1. Invalid birth dates cannot be selected or saved.
2. Email values must be validated before save when provided.
3. Phone input must support country-code selection and numeric phone content.
4. Work experience and education records must not save while required fields are missing.
5. Validation failures must preserve the user's other entered values.
6. Validation feedback must be clear enough for the user to identify and fix the problem field.

## Persistence Contract

1. Saving the profile stores the latest profile data locally.
2. Reopening the Profile page or Edit Profile page loads the latest saved state.
3. Removing an entry and saving removes it from the stored profile.
4. Repeated item order remains stable after save and reload.
5. The saved profile structure remains reusable for future profile-driven flows.

## Failure Handling Contract

1. If image selection fails or is canceled, the rest of the form remains usable.
2. If one bottom sheet record is invalid, the rest of the profile draft remains intact.
3. If save validation fails, the user stays in the current edit context with entered values preserved.