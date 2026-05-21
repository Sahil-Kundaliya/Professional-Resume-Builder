# Feature Specification: Profile Resume Prefill Flow

**Feature Branch**: `007-create-feature-branch`

**Created**: 2026-05-21

**Status**: Draft

**Input**: User description: "I want to add a profile-based resume prefill flow to the app. On the TemplatePreviewPage, there is a button named \"Use this template\". When the user taps this button: first check whether stored profile data exists; if profile data is empty or null, continue navigation normally without showing any dialog; if profile data exists, open a dialog before continuing. The dialog should have the title \"Select contest to create CV\" and show two buttons: \"Create new\" and \"Use profile data\". This flow should let the user choose whether to start a new resume from scratch or prefill the resume using stored profile information." 

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Continue Quickly Without Profile Data (Priority: P1)

As a user selecting a resume template, I can proceed immediately when no stored profile data exists so I can start editing without extra decisions.

**Why this priority**: This preserves the current fastest path and avoids unnecessary interruption for users without stored profile information.

**Independent Test**: Can be fully tested by selecting a template while profile data is missing or empty and confirming the app proceeds directly to resume editing with no dialog.

**Acceptance Scenarios**:

1. **Given** a user selects a template and no stored profile data exists, **When** they tap "Use this template", **Then** the app creates a resume from the selected template and continues to the editor without showing a choice dialog.
2. **Given** a user selects a template and stored profile data is present but empty, **When** they tap "Use this template", **Then** the app behaves as if no profile data exists and continues without showing a choice dialog.

---

### User Story 2 - Choose Resume Creation Method When Profile Data Exists (Priority: P1)

As a user with stored profile data, I can choose whether to create a new resume from scratch or use profile data to prefill the resume so I can control how my resume starts.

**Why this priority**: This is the core business value of the feature, enabling profile-aware resume creation.

**Independent Test**: Can be fully tested by selecting a template with valid stored profile data and confirming the dialog appears with both options and each option leads to the expected result.

**Acceptance Scenarios**:

1. **Given** a user selects a template and stored profile data exists, **When** they tap "Use this template", **Then** the app shows a dialog titled "Select contest to create CV" before creating the resume.
2. **Given** the dialog is shown, **When** the user selects "Create new", **Then** the app creates a new resume from the chosen template without prefilling profile information and continues to the editor.
3. **Given** the dialog is shown, **When** the user selects "Use profile data", **Then** the app creates a resume from the chosen template and prefills resume content using stored profile data before continuing to the editor.

---

### User Story 3 - Respect Explicit User Choice (Priority: P2)

As a user, I can make an explicit one-time choice each time I create a resume from a template so I can decide based on my current goal.

**Why this priority**: This ensures user control and predictability in resume creation behavior.

**Independent Test**: Can be fully tested by repeating the same flow multiple times and confirming the system prompts again when profile data exists, then applies only the currently selected option.

**Acceptance Scenarios**:

1. **Given** stored profile data exists, **When** the user starts creating a resume from a template on a later attempt, **Then** the same selection dialog is shown again before resume creation.

---

### Edge Cases

- What happens when stored profile data retrieval fails unexpectedly at selection time? The system should fail safely by continuing with "Create new" behavior so resume creation is not blocked.
- How does the system handle partially filled profile data? The system should prefill only fields with valid values and leave missing fields empty for manual entry.
- What happens if the user dismisses the dialog without selecting an option? The system should keep the user on the template preview screen and avoid creating a resume until an option is chosen.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST check for stored profile data when the user taps "Use this template" on the template preview screen.
- **FR-002**: System MUST treat null or empty stored profile data as unavailable profile data.
- **FR-003**: If profile data is unavailable, system MUST continue resume creation and navigation without showing any dialog.
- **FR-004**: If profile data is available, system MUST show a decision dialog before resume creation continues.
- **FR-005**: The dialog title MUST be exactly "Select contest to create CV".
- **FR-006**: The dialog MUST present two user actions: "Create new" and "Use profile data".
- **FR-007**: Selecting "Create new" MUST create the resume from the selected template without profile prefill and then continue to the editor.
- **FR-008**: Selecting "Use profile data" MUST create the resume from the selected template with profile-based prefill and then continue to the editor.
- **FR-009**: System MUST not create duplicate resumes from a single tap and selection.
- **FR-010**: System MUST preserve the currently selected template for both creation paths.

### Key Entities *(include if feature involves data)*

- **Stored Profile Data**: User profile information saved in the app that can be used to prefill resume fields during creation.
- **Resume Creation Choice**: User-selected mode for resume initialization, either "Create new" or "Use profile data".
- **Template Selection Context**: The chosen resume template and associated metadata used as the base for creating a new resume instance.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of template selections with unavailable profile data continue to editor navigation without showing the decision dialog.
- **SC-002**: 100% of template selections with available profile data show the decision dialog before resume creation proceeds.
- **SC-003**: At least 95% of users complete the selection-to-editor flow in under 8 seconds for both "Create new" and "Use profile data" paths under normal conditions.
- **SC-004**: In validation tests, 100% of "Create new" choices produce resumes without profile-prefilled values, and 100% of "Use profile data" choices produce resumes with available profile values populated.
- **SC-005**: User-reported confusion about the creation path decreases by at least 30% in post-release feedback for template-based resume creation.

## Assumptions

- Stored profile data is already collected and available from existing app flows.
- Existing template-based resume creation and editor navigation remain valid and should be reused.
- Prefill behavior only applies during new resume creation from template selection and does not retroactively modify existing resumes.
- If profile data access fails unexpectedly, non-prefilled creation remains available as a fallback path.