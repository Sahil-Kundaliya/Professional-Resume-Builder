# Feature Specification: Add Profile Navigation

**Feature Branch**: `004-add-profile-navigation`

**Created**: 2026-05-20

**Status**: Draft

**Input**: User description: "I want to add a new bottom navigation flow to the Resume Builder application.

The application should now contain two main sections:

1. Home
2. Profile

The Home flow should remain exactly the same as the current implementation:
- show resume templates
- open template preview
- open resume editor canvas
- existing resume creation flow should not change

The new Profile section should allow users to manage reusable resume profile data that can later be used to prefill resume templates.

The Profile feature should support:
- profile image
- full name
- job title
- summary/about section
- email
- phone number
- address
- birth date
- portfolio link
- hobbies
- skills with rating (1-5)
- work experience
- education

Work experience should support:
- company name
- job position
- joining/start date
- ending date
- description/details

Education should support:
- title
- institute/school name
- description
- start/end date

Users should be able to add multiple:
- work experiences
- education items
- hobbies
- skills

When the Profile page is opened for the first time:
- show simple dummy placeholder data for:
  - profile image
  - full name
  - job title
- all other sections can remain empty

The Profile page should also include an Edit Profile flow where users can edit all profile information.

All fields should remain optional."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Switch Between Home And Profile (Priority: P1)

A resume builder user can move between the existing Home experience and the new Profile section from a persistent bottom navigation without disrupting the current resume creation journey.

**Why this priority**: The navigation change affects the app's primary entry flow. If switching sections breaks or alters the Home journey, the feature fails its most important requirement.

**Independent Test**: Can be fully tested by opening the app, moving between Home and Profile, and confirming the existing Home flow still supports template browsing, previewing, and opening the resume editor exactly as before.

**Acceptance Scenarios**:

1. **Given** the user opens the app, **When** they view the main navigation, **Then** they can see Home and Profile as the two available sections.
2. **Given** the user is on Home, **When** they browse templates, open a template preview, and open the resume editor canvas, **Then** the existing resume creation flow behaves the same as it did before the navigation change.
3. **Given** the user switches from Profile back to Home, **When** they resume browsing templates, **Then** the Home content and actions remain available without requiring a different workflow.

---

### User Story 2 - Review A Reusable Resume Profile (Priority: P2)

A user can open the Profile section and review a reusable personal profile that is intended to support future resume prefill use cases.

**Why this priority**: The Profile section is the new user-facing destination introduced by this feature. Users need a clear, accessible summary of the profile data they can maintain for future resume generation.

**Independent Test**: Can be fully tested by opening Profile for the first time and verifying the page shows placeholder profile image, full name, and job title while leaving the remaining optional sections empty.

**Acceptance Scenarios**:

1. **Given** the user opens Profile for the first time, **When** no profile data has been entered yet, **Then** the page shows placeholder values for profile image, full name, and job title.
2. **Given** the user opens Profile for the first time, **When** they review the remaining profile sections, **Then** summary, contact details, hobbies, skills, work experience, and education can appear empty without blocking the page.
3. **Given** the user has previously saved profile information, **When** they reopen Profile, **Then** the page shows the latest saved data instead of the first-time placeholder state.

---

### User Story 3 - Start A Template With Or Without Saved Profile Data (Priority: P3)

A user can choose whether to begin a resume from an empty editor or prefill it with saved profile information when they select a template from the preview page.

**Why this priority**: Reusable profile data only provides workflow value if users can apply it at the point where they begin resume creation.

**Independent Test**: Can be fully tested by opening a template preview, tapping Use this template, selecting each dialog action in separate runs, and confirming the editor opens with either empty data or saved profile data.

**Acceptance Scenarios**:

1. **Given** the user is on a template preview page, **When** they tap Use this template, **Then** a confirmation dialog appears with a title, description, and two actions: Start From Scratch and Use Your Data.
2. **Given** the confirmation dialog is open, **When** the user chooses Start From Scratch, **Then** the resume editor opens with an empty resume and no profile fields prefilled.
3. **Given** the user has saved profile information, **When** they choose Use Your Data from the confirmation dialog, **Then** the resume editor opens with the saved profile data prefilled into the resume and still allows further editing.
4. **Given** the user has not saved complete profile data, **When** they choose Use Your Data, **Then** the resume editor prefills only the saved values and leaves all other resume fields editable.

---

### User Story 4 - Edit Optional Profile Details (Priority: P4)

A user can open an Edit Profile flow and enter or update any combination of personal details, skills, hobbies, work experiences, and education records without being forced to complete every field.

**Why this priority**: The Profile section only becomes useful if users can maintain their own reusable resume information flexibly and incrementally.

**Independent Test**: Can be fully tested by editing a profile with partial data, adding multiple repeated items, saving the changes, and confirming the updated profile is shown when the user returns to the Profile page.

**Acceptance Scenarios**:

1. **Given** the user opens Edit Profile, **When** they update any single optional field such as email or summary and save, **Then** the Profile page shows the entered value and keeps untouched fields unchanged.
2. **Given** the user wants to record multiple repeated entries, **When** they add more than one hobby, skill, work experience, or education item, **Then** each entry is retained as a separate item in the saved profile.
3. **Given** the user leaves some or all fields empty, **When** they save the profile, **Then** the system accepts the profile without requiring missing fields to be completed.
4. **Given** the user adds a skill, **When** they assign a rating, **Then** the saved skill retains a rating from 1 through 5.

### Edge Cases

- What happens when a user opens Profile, makes no edits, and returns to Home?
- How does the system handle a work experience or education item where only some fields are filled because all fields are optional?
- What happens when a user leaves the end date blank for a current or unfinished work experience or education item?
- How does the Profile page behave when the user has no hobbies, no skills, no work experiences, and no education items saved?
- What happens when a user adds multiple repeated items and later removes content from one of them before saving?
- What happens when a user chooses Use Your Data but only a small subset of profile fields has been saved?
- What happens when a user chooses Start From Scratch after having previously saved profile information?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide a primary navigation structure with exactly two main sections: Home and Profile.
- **FR-002**: System MUST preserve the current Home experience so users can still browse resume templates, open template previews, and open the resume editor canvas without a changed creation workflow.
- **FR-003**: System MUST provide a Profile section where users can view reusable resume profile information.
- **FR-004**: System MUST show placeholder content for profile image, full name, and job title the first time the Profile section is opened before the user saves their own profile data.
- **FR-005**: System MUST allow the remaining profile sections to be empty on first view and after later edits because all profile fields are optional.
- **FR-006**: System MUST provide an Edit Profile flow from the Profile section.
- **FR-007**: System MUST allow users to add, update, and save the following profile fields as optional information: profile image, full name, job title, summary/about section, email, phone number, address, birth date, and portfolio link.
- **FR-008**: System MUST allow users to add, update, and save multiple hobby entries as optional items.
- **FR-009**: System MUST allow users to add, update, and save multiple skill entries, with each skill including a rating from 1 to 5.
- **FR-010**: System MUST allow users to add, update, and save multiple work experience entries.
- **FR-011**: Each work experience entry MUST support optional company name, job position, start date, end date, and description/details fields.
- **FR-012**: System MUST allow users to add, update, and save multiple education entries.
- **FR-013**: Each education entry MUST support optional title, institute or school name, description, start date, and end date fields.
- **FR-014**: System MUST retain each saved hobby, skill, work experience, and education item as a separate entry when more than one is provided.
- **FR-015**: System MUST allow users to save a profile even when any subset of fields is left blank.
- **FR-016**: System MUST show the latest saved profile information whenever the user returns to the Profile section.
- **FR-017**: System MUST persist saved profile information locally so it remains available across later visits for reuse.
- **FR-018**: System MUST show a confirmation dialog when the user chooses Use this template from the template preview page.
- **FR-019**: The confirmation dialog MUST include a title, a description, and exactly two actions: Start From Scratch and Use Your Data.
- **FR-020**: System MUST open the resume editor with an empty resume when the user chooses Start From Scratch.
- **FR-021**: System MUST load saved profile information from local storage when the user chooses Use Your Data.
- **FR-022**: System MUST prefill the resume editor with the saved profile information when the user chooses Use Your Data.
- **FR-023**: System MUST allow the user to continue editing the resume after profile-based prefill is applied.
- **FR-024**: When saved profile information is partial, system MUST prefill only the available values and leave the remaining resume fields editable.
- **FR-025**: The profile and template-start flows MUST remain organized in a scalable, reusable, feature-based structure consistent with the application architecture.

### Key Entities *(include if feature involves data)*

- **Resume Profile**: The reusable personal profile a user maintains for resume creation, including identity details, contact information, summary, links, and grouped profile sections.
- **Skill Entry**: A profile item containing a skill name and a user-assigned proficiency rating from 1 to 5.
- **Work Experience Entry**: A profile item describing one employment record with company, role, dates, and descriptive details.
- **Education Entry**: A profile item describing one education record with title, school or institute, dates, and descriptive details.
- **Hobby Entry**: A profile item representing one personal interest the user wants available for resume reuse.
- **Template Start Choice**: The user's decision to begin a selected template from an empty state or with saved profile data prefilled.
- **Prefilled Resume**: A new editable resume draft initialized by merging a selected template with the user's saved profile information.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of Home flow acceptance scenarios continue to pass after the navigation update, with no required change to the user's existing template-to-editor journey.
- **SC-002**: In 100% of first-time Profile validations, the page shows placeholder profile image, full name, and job title while allowing all other sections to remain empty.
- **SC-003**: Users can switch between Home and Profile in a single tap and reach the intended section in at least 95% of manual validation attempts.
- **SC-004**: Users can save a profile containing at least one skill, one work experience, and one education item in under 5 minutes during manual validation.
- **SC-005**: 100% of manual validation scenarios confirm that profiles can be saved successfully when any combination of optional fields is left blank.
- **SC-006**: 100% of manual validation scenarios confirm that multiple hobbies, skills, work experiences, and education items reappear accurately after the user revisits the Profile section.
- **SC-007**: 100% of template preview validations show the confirmation dialog before the editor opens.
- **SC-008**: In at least 95% of manual validation attempts, users can reach an empty editor or a prefilled editor from the template preview in no more than 2 taps after pressing Use this template.
- **SC-009**: 100% of manual validation scenarios confirm that saved profile information remains available for reuse after the app returns to the Profile section and the template preview flow.

## Assumptions

- The existing Home section already provides the current template browsing, preview, and resume editor flow that must remain behaviorally unchanged.
- Users are expected to manage one reusable profile for themselves within the app rather than switching between multiple named profiles.
- Placeholder profile image, full name, and job title are simple starter values intended to make the first Profile visit feel populated before any user data is entered.
- Optional repeated entries such as hobbies, skills, work experiences, and education items do not require a minimum item count.
- Resume prefill is based on the single locally saved profile available at the time the user selects Use Your Data.