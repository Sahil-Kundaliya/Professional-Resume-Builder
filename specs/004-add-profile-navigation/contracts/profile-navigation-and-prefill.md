# Contract: Profile Navigation And Template Prefill

## Scope

This contract defines the user-facing interaction rules for the new Home/Profile app shell, the reusable Profile experience, and the template-start choice that can initialize the editor from scratch or from saved profile data.

## Bottom Navigation Contract

| Element | Requirement | Expected Behavior |
| --- | --- | --- |
| Home tab | Must remain available as a top-level section | Opens the existing template browsing experience without altering its visible flow |
| Profile tab | Must be available as a top-level section | Opens the reusable profile summary experience |
| Tab switching | Must be immediate and predictable | Users can move between Home and Profile in one tap |

## Home Preservation Contract

1. The Home tab continues showing resume templates.
2. Selecting a template still opens the template preview flow.
3. The resume editor remains reachable from template preview.
4. The new navigation shell must not introduce extra required steps inside the existing Home journey.

## Profile Summary Contract

| State | Required Display |
| --- | --- |
| First open with no saved profile | Placeholder image, dummy full name, dummy job title, and editable access to start completing the profile |
| Existing saved profile | Latest saved identity, summary, contact information, repeated sections, and entry to Edit Profile |
| Empty optional sections | Render safely as empty or lightweight placeholders without blocking the page |

## Edit Profile Contract

| Section | Required Behavior |
| --- | --- |
| Identity | User can update image, full name, job title, and summary |
| Contact information | User can update email, phone number, address, birth date, and portfolio link |
| Hobbies | User can add multiple hobby entries |
| Skills | User can add multiple skill entries and assign ratings from 1 to 5 |
| Work experience | User can add multiple entries with company, role, dates, and description |
| Education | User can add multiple entries with title, institute, dates, and description |
| Save behavior | User can save with any subset of fields left empty |

## Local Persistence Contract

1. Saving the profile stores the latest profile data locally for later reuse.
2. Reopening the Profile tab must load the latest saved values.
3. Repeated item order must remain stable after save and reload.
4. Partial profiles must remain valid persisted state.

## Template Start Dialog Contract

| Trigger | Dialog Requirement | Result |
| --- | --- | --- |
| User taps Use this template | Show a confirmation dialog with title, description, and two actions | User must choose how the editor starts |
| Start From Scratch | One of the two required actions | Opens the editor with an empty resume document |
| Use Your Data | One of the two required actions | Loads saved profile data, prefills matching resume fields, then opens the editor |

## Prefill Mapping Contract

1. Use Your Data reads the currently saved local profile.
2. Only available saved values prefill the new resume document.
3. Missing profile values do not block editor launch.
4. The resulting resume remains fully editable after prefill.
5. Start From Scratch must ignore any previously saved profile data.

## Failure Handling Contract

1. If no complete profile exists, Use Your Data still opens the editor with whatever saved values are available.
2. If no user-saved profile exists beyond placeholder defaults, the app must still allow the user to proceed without breaking the template flow.
3. Profile image persistence failures must not corrupt the rest of the saved profile record.