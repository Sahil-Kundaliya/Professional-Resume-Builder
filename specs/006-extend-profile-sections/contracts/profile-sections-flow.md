# Contract: Profile Sections Flow

## Scope

This contract defines user-facing behavior for extending the existing Profile feature with list-based sections (experience, hobbies, education, awards, certifications) while preserving all current basic profile field behavior.

## Preservation Contract (Non-Negotiable)

1. Existing profile fields remain intact and unchanged in behavior:
   - image
   - full name
   - job title
   - summary
   - email
   - address
   - country code
   - phone number
   - portfolio link
   - birth date
2. Existing save and load behavior for these fields must continue to work without regression.
3. New functionality is additive and must not replace current profile architecture.

## Profile View Contract

| Section | When Data Exists | When Data Does Not Exist |
| --- | --- | --- |
| Experience | Show list of entries | Show clear add or empty state |
| Hobbies | Show list of entries | Show clear add or empty state |
| Education | Show list of entries | Show clear add or empty state |
| Awards | Show list of entries | Show clear add or empty state |
| Certifications | Show list of entries | Show clear add or empty state |

## Edit Profile Contract

1. Existing basic field form remains unchanged.
2. Edit Profile includes section-level add controls.
3. Plus button behavior is required for:
   - Experience
   - Education
   - Awards
   - Certifications

## Bottom Sheet Form Contract

| Section | Required Fields |
| --- | --- |
| Experience | company name, job position, start date, end date, topic-based details |
| Education | school or college name, degree, start date, end date |
| Awards | title, date |
| Certifications | title, date |

## Add-Flow Contract

1. Tapping a section plus button opens the corresponding bottom sheet.
2. Required-field validation occurs before item creation.
3. On valid submit, item is appended to the section list in the current draft.
4. On cancel/dismiss, no list mutation occurs.
5. Multiple items per section are supported.

## Persistence and Consistency Contract

1. Saved section items must persist with the existing profile record.
2. Reopening Profile view must show persisted list items.
3. Existing basic fields must remain unchanged unless explicitly edited.
4. Section list behavior must remain consistent with current profile module patterns.

## Failure Handling Contract

1. Validation failures keep user-entered values visible for correction.
2. Invalid section submissions do not affect existing persisted profile data.
3. Any save failure must not clear existing profile or newly entered draft values.