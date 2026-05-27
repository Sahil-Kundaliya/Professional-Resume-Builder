# Feature Specification: Replace Resume Canvas with Form Flow

**Feature Branch**: `010-resume-form-flow`

**Created**: 2026-05-27

**Status**: Draft

**Input**: User description: "Replace the current Resume Canvas editing experience with a form-based resume creation flow."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Start a Resume Through Structured Entry (Priority: P1)

As a job seeker, I want choosing a template to take me into a guided resume form instead of direct canvas editing, so I can enter my information in a clear and predictable way.

**Why this priority**: This is the core flow change. Without it, the new form-based resume creation experience does not exist.

**Independent Test**: Can be fully tested by selecting a template from the list, opening its preview, choosing "Use this template," and verifying the user lands on a resume form that exposes the selected template's editable content areas.

**Acceptance Scenarios**:

1. **Given** a user is viewing available templates, **When** the user opens one template and taps "Use this template," **Then** the system opens a resume form page instead of navigating directly to canvas editing.
2. **Given** a user opens the resume form page from a selected template, **When** the page loads, **Then** the form shows structured inputs for the data supported by that template.
3. **Given** a template does not support a specific optional content area, **When** the user opens the resume form page, **Then** the form excludes unsupported inputs while keeping the rest of the form usable.

---

### User Story 2 - Manage Resume Content in Dynamic Form Sections (Priority: P1)

As a job seeker, I want to add, edit, and remove repeatable resume entries through dedicated form controls, so I can build complete work history and education details without editing directly on the final layout.

**Why this priority**: Repeatable sections such as work experience and education are essential resume content and must remain practical to manage in the new flow.

**Independent Test**: Can be fully tested by entering profile information, adding multiple work experience and education items through the form, editing one item, removing another, and verifying all other entered content remains intact.

**Acceptance Scenarios**:

1. **Given** a user is on the resume form page, **When** the user adds a work experience entry, **Then** the system collects the entry through a dedicated bottom-sheet flow and adds it to the form.
2. **Given** a user already has one or more work experience entries, **When** the user chooses to edit one entry, **Then** the system opens that entry for update without changing other entries.
3. **Given** a user already has one or more education entries, **When** the user removes one entry, **Then** only the selected education entry is removed.
4. **Given** a user has entered content into repeatable sections, **When** the user returns to the main form after adding or editing an item, **Then** the updated list is shown immediately.

---

### User Story 3 - Preview the Resume Before Finalizing (Priority: P2)

As a job seeker, I want to preview the selected template using the information I entered in the form, so I can verify how my resume will look before continuing.

**Why this priority**: Preview is the confirmation step that connects structured input to the final resume output while preserving template-driven presentation.

**Independent Test**: Can be fully tested by completing the form, tapping Preview, and confirming the selected template renders with the entered data instead of blank or placeholder content.

**Acceptance Scenarios**:

1. **Given** a user has entered resume data in the form, **When** the user taps Preview, **Then** the system renders the selected template using the current form data.
2. **Given** a user is reviewing the preview, **When** the user returns to the form, **Then** all previously entered data remains available for further editing.
3. **Given** a user updates any form value and reopens Preview, **When** the preview is shown again, **Then** the rendered resume reflects the latest saved form values.

### Edge Cases

- When a template supports fewer sections than the full resume data model, the form should show only supported sections and still allow resume completion.
- When a user opens the add or edit flow for work experience or education and dismisses it without saving, the main form should remain unchanged.
- When a repeatable section has no entries yet, the form should still provide a clear way to add the first item.
- When a user attempts to preview with only partial data entered, the preview should render whatever valid data is available without losing the draft.
- When obsolete canvas-edit actions or canvas-only controls are no longer reachable in the creation flow, the user should not encounter dead-end navigation or conflicting editing options.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST continue to present a list of available resume templates for selection.
- **FR-002**: System MUST allow users to open a preview of a selected template before choosing it.
- **FR-003**: System MUST route the "Use this template" action to a resume form page instead of direct resume canvas editing.
- **FR-004**: System MUST create the resume form in the context of the template selected by the user.
- **FR-005**: System MUST display structured form inputs for all resume data fields supported by the selected template.
- **FR-006**: System MUST support direct editing of core personal details including profile image, full name, job position, summary, birth date, email, phone, address, and portfolio link when those fields are supported by the selected template.
- **FR-007**: System MUST support direct editing of optional resume content including skills, hobbies, awards, certifications, and references when those sections are supported by the selected template.
- **FR-008**: System MUST support work experience as a repeatable section with the ability to add, edit, and remove multiple items.
- **FR-009**: System MUST collect new work experience entries through a bottom-sheet interaction.
- **FR-010**: System MUST support education as a repeatable section with the ability to add, edit, and remove multiple items.
- **FR-011**: System MUST collect new and edited education entries through a bottom-sheet interaction that supports multiple text fields.
- **FR-012**: System MUST preserve existing repeatable entries when a user edits or removes a different entry in the same section.
- **FR-013**: System MUST provide a Preview action from within the resume form page.
- **FR-014**: System MUST render the selected template using the user’s current form data when Preview is requested.
- **FR-015**: System MUST preserve entered form data when the user moves between form editing and preview.
- **FR-016**: System MUST maintain template support so the same template catalogue and template-specific presentation remain available in the new creation flow.
- **FR-017**: System MUST remove direct creation-flow dependencies on resume canvas editing where they are no longer needed.
- **FR-018**: System MUST remove or retire obsolete canvas-editing logic that is unclear, unused, or conflicts with the new form-driven creation flow.
- **FR-019**: System MUST keep the resume creation experience consistent and production-ready, including clear user actions, predictable state handling, and non-destructive editing behavior.

### Key Entities *(include if feature involves data)*

- **Resume Template**: A selectable resume design that determines which data sections are supported and how entered information is presented in preview output.
- **Resume Form Draft**: The in-progress set of user-entered resume data associated with a selected template.
- **Form Section**: A structured group of related resume inputs, such as personal details, work experience, education, skills, or references.
- **Repeatable Entry**: A user-managed item within a list-based section, such as one work experience record or one education record.
- **Resume Preview**: A rendered view of the selected template populated with the current draft data.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: At least 95% of users who select a template reach the resume form page on their first attempt without entering the previous canvas editing flow.
- **SC-002**: At least 90% of users can complete the initial resume form with core personal information and at least one experience entry in under 8 minutes.
- **SC-003**: At least 95% of add, edit, and remove actions for work experience and education are completed successfully without unintended changes to other entries.
- **SC-004**: At least 95% of preview attempts render the selected template with the latest entered form data on the first try.
- **SC-005**: At least 90% of users report that the form-based flow is clearer than direct canvas editing for entering resume data.
- **SC-006**: Release validation confirms that all supported templates remain selectable, previewable, and renderable within the new form-driven resume creation flow.

## Assumptions

- The current template list and template preview capabilities remain part of the user journey and do not need to be redesigned from scratch.
- The selected template defines which fields and sections should appear in the form.
- Users are creating or updating one resume draft at a time from a single selected template.
- Preview is read-only confirmation of the current draft and does not introduce a separate editing model.
- Removing canvas-related creation logic does not require removing template rendering itself, only the obsolete direct canvas-editing path and unused supporting behavior.