# Feature Specification: Edit Profile Flow

**Feature Branch**: `005-edit-profile-flow`

**Created**: 2026-05-21

**Status**: Draft

**Input**: User description: "I want to improve the Profile module by adding a complete Edit Profile flow.

On the Profile page:
- add an Edit button
- when the user taps Edit, navigate to the Edit Profile page

On the Edit Profile page, users should be able to edit all profile information.

Profile Information:

Basic Information:
- profile image (select from gallery)
- full name
- job title
- summary

Field requirements:
- full name → text field
- job title → text field
- summary → multiline text field with maximum 5 lines
- email → text field
- address → text field
- portfolio link → text field
- phone number → numeric keyboard only with country code selector
- birth date → date picker

Validation requirements:
- birth date must not allow future dates
- phone number must support all country codes
- image selection should support gallery upload
- proper field validation should be implemented

Dynamic Sections:

Skills:
- initially show one skill item
- allow adding multiple skills using a plus button
- each skill should contain:
  - skill title
  - rating from 1–5

Hobbies:
- initially show one hobby field
- allow adding multiple hobbies using a plus button

Work Experience:
- allow multiple experiences
- adding a new experience should open a bottom sheet
- all fields must be required before saving

Experience fields:
- company name
- job position
- start date
- end date
- topic-wise experience details

Example experience details:

- Developed and maintained scalable applications.
- Designed responsive UI and reusable components.
- Integrated APIs and optimized application performance.

Education:
- allow multiple education records
- adding should follow the same flow as experience

Education fields:
- school/college name
- degree name
- start date
- end date

Awards:
- support multiple awards
- fields:
  - title
  - date

Certifications:
- support multiple certifications
- fields:
  - title
  - date

All sections should support editing, adding, and removing entries."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Open And Complete Edit Profile (Priority: P1)

A profile owner can open the Edit Profile page from the Profile page, update their personal details, and save the changes so the Profile page reflects the latest information.

**Why this priority**: The feature is centered on giving users a complete editing path from the Profile page. If the entry point, editing surface, or save result fails, the feature does not deliver its core value.

**Independent Test**: Can be fully tested by opening Profile, tapping Edit, updating basic information and contact details, saving, and confirming the Profile page shows the saved values.

**Acceptance Scenarios**:

1. **Given** the user is viewing the Profile page, **When** they tap the Edit button, **Then** the system opens the Edit Profile page.
2. **Given** the user is on the Edit Profile page, **When** they update profile image, full name, job title, summary, email, address, portfolio link, phone number, and birth date with valid values and save, **Then** the changes are stored and shown on the Profile page.
3. **Given** the user has saved profile updates, **When** they return to the Profile page later, **Then** the latest saved information is still shown.

---

### User Story 2 - Manage Dynamic Profile Sections (Priority: P2)

A profile owner can add, edit, and remove multiple entries across skills, hobbies, work experience, education, awards, and certifications from one edit flow.

**Why this priority**: Resume-quality profile data depends on repeated sections. Users need to maintain lists of qualifications and history without being limited to a single item.

**Independent Test**: Can be fully tested by adding multiple entries in each dynamic section, editing one existing entry, removing another, saving, and confirming the remaining entries are preserved accurately.

**Acceptance Scenarios**:

1. **Given** the user opens the Edit Profile page, **When** the form loads, **Then** the skills section shows one skill item and the hobbies section shows one hobby field by default.
2. **Given** the user wants to add repeated information, **When** they use the add control in skills, hobbies, awards, or certifications, **Then** a new editable item is added to that section.
3. **Given** the user wants to add a work experience or education record, **When** they choose to add a new record, **Then** the system opens a bottom sheet for entering that record.
4. **Given** the user edits or removes one or more entries in any dynamic section and saves, **When** they view the saved profile, **Then** the edited entries remain updated and removed entries no longer appear.

---

### User Story 3 - Prevent Invalid Profile Data (Priority: P3)

A profile owner receives clear validation feedback that prevents invalid or incomplete data from being saved where the section rules require complete information.

**Why this priority**: The edit flow must protect data quality, especially for structured sections such as work experience and education where incomplete entries would reduce the usefulness of the saved profile.

**Independent Test**: Can be fully tested by attempting to save invalid birth dates, incomplete work experience entries, incomplete education entries, and improperly formatted basic fields, then confirming the system blocks saving until the issues are corrected.

**Acceptance Scenarios**:

1. **Given** the user tries to select a birth date after today, **When** they interact with the birth date field, **Then** the system prevents future dates from being chosen.
2. **Given** the user enters a phone number, **When** they choose a country code and provide digits, **Then** the system accepts phone numbers across supported country codes and limits entry to numeric phone content.
3. **Given** the user starts a new work experience or education record, **When** any required field in that record is missing, **Then** the system blocks saving that record and identifies the missing fields.
4. **Given** the user attempts to save the Edit Profile page with invalid field values, **When** validation runs, **Then** the system preserves entered data, highlights the invalid fields, and allows correction without re-entering unaffected fields.

### Edge Cases

- What happens when the user opens Edit Profile from a profile that still contains placeholder or empty values?
- What happens when the user selects an image from the gallery and then decides to replace or remove it before saving?
- How does the system handle a summary that exceeds the allowed visible input size for the field?
- What happens when the user adds several dynamic items and removes the first or middle item before saving?
- What happens when the user opens a bottom sheet for work experience or education, enters partial data, and tries to save?
- How does the system behave when the user has no awards, no certifications, no hobbies, or no skills after removing existing items?
- What happens when the user edits an existing work experience or education record and changes the date range?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST show an Edit action on the Profile page.
- **FR-002**: System MUST open the Edit Profile page when the user activates the Edit action from the Profile page.
- **FR-003**: System MUST allow users to review and modify all saved profile information from the Edit Profile page.
- **FR-004**: System MUST allow users to choose a profile image from the device gallery.
- **FR-005**: System MUST provide editable fields for full name, job title, summary, email, address, portfolio link, phone number, and birth date.
- **FR-006**: System MUST provide the summary field as a multiline input limited to five visible lines.
- **FR-007**: System MUST provide phone number entry with a country code selector and numeric phone input.
- **FR-008**: System MUST provide birth date entry through a date selection control that disallows future dates.
- **FR-009**: System MUST validate profile fields before saving and present clear, field-level feedback when values are invalid or incomplete.
- **FR-010**: System MUST show one editable skill item when the Edit Profile page first loads.
- **FR-011**: Each skill item MUST support a skill title and a rating from 1 to 5.
- **FR-012**: System MUST let users add, edit, and remove multiple skill items.
- **FR-013**: System MUST show one editable hobby field when the Edit Profile page first loads.
- **FR-014**: System MUST let users add, edit, and remove multiple hobby entries.
- **FR-015**: System MUST let users add, edit, and remove multiple work experience entries.
- **FR-016**: System MUST open a bottom sheet when the user adds or edits a work experience entry.
- **FR-017**: Each work experience entry MUST include company name, job position, start date, end date, and topic-wise experience details.
- **FR-018**: System MUST require all work experience fields to be completed before a work experience entry can be saved.
- **FR-019**: System MUST let users add, edit, and remove multiple education records.
- **FR-020**: System MUST use the same bottom-sheet interaction pattern for adding and editing education records.
- **FR-021**: Each education record MUST include school or college name, degree name, start date, and end date.
- **FR-022**: System MUST require all education fields to be completed before an education record can be saved.
- **FR-023**: System MUST let users add, edit, and remove multiple award entries.
- **FR-024**: Each award entry MUST include a title and date.
- **FR-025**: System MUST let users add, edit, and remove multiple certification entries.
- **FR-026**: Each certification entry MUST include a title and date.
- **FR-027**: System MUST preserve existing saved entries when users edit only one section of the profile.
- **FR-028**: System MUST remove deleted entries from the saved profile after the user saves changes.
- **FR-029**: System MUST keep user-entered values visible while validation issues are being corrected.
- **FR-030**: System MUST reflect the latest saved profile information on the Profile page after a successful save.

### Key Entities *(include if feature involves data)*

- **Editable Profile**: The complete set of profile information a user can maintain, including personal details, contact details, image, and repeated profile sections.
- **Skill Item**: A user-defined skill entry containing a title and a proficiency rating from 1 to 5.
- **Hobby Item**: A user-defined hobby entry containing a single hobby value.
- **Work Experience Record**: A structured employment history entry containing employer, role, dates, and topic-wise experience details that must all be completed before the record is saved.
- **Education Record**: A structured education history entry containing institution, degree, and dates that must all be completed before the record is saved.
- **Award Entry**: A dated recognition item containing a title and award date.
- **Certification Entry**: A dated certification item containing a title and certification date.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of validation runs for this feature confirm that users can reach the Edit Profile page from the Profile page in one tap.
- **SC-002**: In at least 95% of manual validation attempts, users can update basic profile information and save it successfully in under 3 minutes.
- **SC-003**: 100% of manual validation scenarios confirm that future birth dates cannot be selected or saved.
- **SC-004**: 100% of manual validation scenarios confirm that incomplete work experience and education records cannot be saved.
- **SC-005**: 100% of manual validation scenarios confirm that users can add, edit, and remove multiple entries in skills, hobbies, work experience, education, awards, and certifications.
- **SC-006**: In at least 95% of manual validation attempts, users can add and save a new work experience or education record from a bottom sheet in under 90 seconds.
- **SC-007**: 100% of post-save validation scenarios confirm that the Profile page reflects the latest saved edits without losing unchanged entries.
- **SC-008**: 100% of manual validation scenarios confirm that phone entry supports country-code selection and numeric phone input for the tested regions.

## Assumptions

- The existing Profile page and reusable profile storage from the previous profile feature remain the source of truth for viewing saved profile information.
- Existing profile data, if present, is preloaded into the Edit Profile page so users edit their current profile rather than starting over.
- Gallery image selection uses the device's standard media access flow available to the user on supported platforms.
- The summary field may contain more text than is visible at once, but the editing surface shows no more than five lines without expanding the field beyond its intended size.
- Phone validation follows standard country-code and numeric-entry expectations without restricting the feature to a small set of countries.
- Awards and certifications are part of the saved reusable profile even though they were not included in the earlier profile scope.
