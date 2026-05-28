# Feature Specification: Skill Rating Support

**Feature Branch**: `[015-skill-rating-support]`

**Created**: 2026-05-28

**Status**: Draft

**Input**: User description: "Improve the resume form Skills section so each skill supports a 1-5 expertise level, is displayed with stars, reuses the established skill editing pattern, and keeps the change limited to skills only."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Rate a Skill While Editing a Resume (Priority: P1)

A user editing a resume can add or edit a skill and assign an expertise level from 1 to 5 instead of entering skill text only.

**Why this priority**: This is the core value of the feature and the main reason the Skills section needs to change.

**Independent Test**: Open the resume form, add a skill, choose a rating, save the form, and verify the rating is retained and represented as stars.

**Acceptance Scenarios**:

1. **Given** a resume form with the Skills section visible, **When** the user adds a new skill and assigns an expertise level, **Then** the saved skill includes that level.
2. **Given** an existing skill entry, **When** the user edits the skill, **Then** the updated expertise level is preserved after saving.
3. **Given** a skill entry with an invalid or missing expertise level, **When** the user saves the form, **Then** the skill is not stored with an out-of-range level.

---

### User Story 2 - Read Skill Expertise Clearly (Priority: P2)

A user reviewing a resume can immediately understand how strong each skill is from the skill label and star display.

**Why this priority**: The feature only works if the expertise level is visible and understandable in the Skills section.

**Independent Test**: Open a resume containing several skills and confirm that each skill shows its name, a visible expertise level, and a star rating.

**Acceptance Scenarios**:

1. **Given** a resume with skills, **When** the Skills section is displayed, **Then** each skill shows the skill name and a 1-5 expertise indicator.
2. **Given** a skill with a low expertise level, **When** it is displayed, **Then** the star rating clearly communicates that the skill is closer to beginner than expert.
3. **Given** a skill with the highest expertise level, **When** it is displayed, **Then** the star rating clearly communicates expert-level strength.

---

### User Story 3 - Keep the Skill Experience Consistent (Priority: P3)

A user sees the same skill rating behavior and presentation in the resume form as in the existing profile editing experience.

**Why this priority**: Consistency reduces confusion and keeps the product’s skill editing behavior predictable.

**Independent Test**: Compare the skill editing experience in the resume form with the established skill editor and verify the rating scale and star semantics match.

**Acceptance Scenarios**:

1. **Given** the existing skill editing experience and the resume form, **When** the user adds or edits a skill in either place, **Then** the expertise level uses the same 1-5 scale.
2. **Given** a skill saved in one editing surface, **When** the user revisits it in the other surface, **Then** the expertise level appears with the same meaning and star representation.

### Edge Cases

- What happens when a user saves a skill name with leading or trailing spaces? The stored skill should treat the name as trimmed text.
- What happens when a skill is created without an expertise level? The skill should use a valid default level within the supported range.
- What happens when the Skills section is empty? The user should see a clear empty state and a path to add the first skill.
- What happens when a stored skill has an out-of-range expertise level? The displayed and saved value should stay within the supported 1-5 range.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Skills section in the resume form MUST allow users to add a skill name and assign an expertise level from 1 to 5.
- **FR-002**: The Skills section MUST present expertise selection using a star-based visual scale.
- **FR-003**: Each saved skill MUST retain its expertise level when the resume form is reopened or the skill is edited.
- **FR-004**: Each displayed skill MUST clearly show the skill name, the expertise level, and a star rating.
- **FR-005**: Editing an existing skill MUST preserve the previously selected expertise level unless the user changes it.
- **FR-006**: The resume form MUST use a consistent skill editing pattern with the existing profile skill experience so users encounter the same 1-5 meaning across both surfaces.
- **FR-007**: The scope of this feature MUST be limited to the Skills section and MUST not change unrelated resume form fields or other sections.
- **FR-008**: Empty or invalid skill names MUST not be accepted as saved skills.
- **FR-009**: Expertise levels outside the supported 1-5 range MUST not be saved or displayed as valid values.

### Key Entities *(include if feature involves data)*

- **Skill Entry**: A resume skill with a name and an expertise level.
- **Expertise Level**: A 1-5 rating where lower values indicate beginner-level skill and higher values indicate expert-level skill.
- **Skills Section**: The part of the resume form where skills are added, edited, and reviewed.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of displayed skill entries show the skill name and a visible 1-5 expertise indicator.
- **SC-002**: At least 90% of users in usability testing can add a skill and assign an expertise level on their first attempt.
- **SC-003**: At least 90% of users in usability testing can edit an existing skill and keep the intended expertise level without assistance.
- **SC-004**: Reviewers can confirm in a side-by-side check that the resume form and the existing profile skill experience use the same expertise scale and star meaning.
- **SC-005**: Changes made in the Skills section do not alter any non-skill resume form fields during save and reopen flows.

## Assumptions

- The current product already stores skill names and expertise levels, so this work focuses on exposing and editing that information in the resume form.
- A new skill may start with a reasonable default expertise level if the user does not choose one immediately.
- Users interpret the star scale consistently as 1 meaning beginner and 5 meaning expert.
- Only the Skills section is in scope for this feature; other resume sections remain unchanged.
