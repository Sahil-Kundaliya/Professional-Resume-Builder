# Feature Specification: Enable Resume Canvas Formatting

**Feature Branch**: `003-enable-canvas-formatting`

**Created**: 2026-05-20

**Status**: Draft

**Input**: User description: "I want to improve the Resume Canvas Editing page. Currently, users can edit the full name, edit the job title, edit the summary, and upload a profile image from the gallery. I also already have a floating toolbar with bold, italic, underline, font family selection, text color options, and undo and redo actions. I want to fully enable and connect these toolbar features specifically for full name, job title, and summary. The selected formatting options should immediately reflect on the selected text element inside the resume canvas."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Format Selected Resume Text (Priority: P1)

A resume creator selects the full name, job title, or summary text on the resume canvas and applies formatting from the floating toolbar so the chosen text immediately reflects the selected style.

**Why this priority**: The core value of the feature is direct visual editing of the main text elements on the resume canvas. Without this, the toolbar exists but does not provide usable formatting control.

**Independent Test**: Can be fully tested by selecting each supported text element, applying bold, italic, underline, font family, and text color changes, and confirming the canvas updates immediately for the selected element only.

**Acceptance Scenarios**:

1. **Given** the user has selected the full name text element, **When** they enable bold from the floating toolbar, **Then** the full name on the resume canvas is immediately shown in bold.
2. **Given** the user has selected the job title text element, **When** they change the font family or text color from the floating toolbar, **Then** the job title on the resume canvas immediately reflects the chosen formatting.
3. **Given** the user has selected the summary text element, **When** they combine multiple formatting choices, **Then** the summary on the resume canvas reflects the latest active formatting selections without altering other text elements.

---

### User Story 2 - Preserve Element-Specific Formatting (Priority: P2)

A resume creator wants formatting changes to apply only to the currently selected text element so each part of the resume can be styled independently.

**Why this priority**: Users expect canvas editing to be precise. Applying formatting to the wrong field or sharing styles unintentionally would make the editor unreliable.

**Independent Test**: Can be fully tested by styling one supported text element, switching selection to another supported text element, and verifying each element keeps its own formatting state.

**Acceptance Scenarios**:

1. **Given** the full name already has custom formatting, **When** the user selects the job title and applies different formatting, **Then** the job title changes and the full name keeps its previous styling.
2. **Given** the user switches between full name, job title, and summary, **When** each element is selected, **Then** the toolbar state reflects that element's current formatting choices.

---

### User Story 3 - Reverse and Reapply Formatting Changes (Priority: P3)

A resume creator wants to undo and redo recent formatting changes while editing the supported text elements so experimentation is safe and fast.

**Why this priority**: Undo and redo reduce editing friction and make the toolbar practical for iterative styling.

**Independent Test**: Can be fully tested by applying formatting changes to supported text elements, using undo to revert the latest change, and using redo to restore it.

**Acceptance Scenarios**:

1. **Given** the user has made one or more formatting changes to a supported text element, **When** they choose undo, **Then** the most recent applicable change is reversed on the resume canvas.
2. **Given** the user has just undone a formatting change on a supported text element, **When** they choose redo, **Then** the reverted change is restored on the resume canvas.

### Edge Cases

- What happens when the user taps a toolbar action while no supported text element is selected?
- How does the editor behave when a user rapidly switches between full name, job title, and summary while changing formatting?
- What happens when undo or redo is triggered after the user has reached the beginning or end of the available change history?
- How does the system prevent formatting actions from affecting unsupported canvas items such as the profile image?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST allow users to select the full name, job title, and summary text elements directly from the resume canvas for formatting.
- **FR-002**: System MUST apply bold formatting to the currently selected supported text element when the user activates the bold toolbar action.
- **FR-003**: System MUST apply italic formatting to the currently selected supported text element when the user activates the italic toolbar action.
- **FR-004**: System MUST apply underline formatting to the currently selected supported text element when the user activates the underline toolbar action.
- **FR-005**: System MUST apply the chosen font family to the currently selected supported text element when the user changes the font selection.
- **FR-006**: System MUST apply the chosen text color to the currently selected supported text element when the user chooses a color option.
- **FR-007**: System MUST update the resume canvas immediately after each supported formatting action so the user can see the result on the selected text element without leaving the editing view.
- **FR-008**: System MUST keep formatting state independent for full name, job title, and summary so changes to one element do not overwrite formatting on another element.
- **FR-009**: System MUST present the current formatting state of the selected supported text element in the floating toolbar whenever selection changes.
- **FR-010**: System MUST support undo for the most recent editable change affecting the supported text elements.
- **FR-011**: System MUST support redo for the most recently undone editable change affecting the supported text elements.
- **FR-012**: System MUST ignore or safely block toolbar formatting actions when no supported text element is selected.
- **FR-013**: System MUST ensure unsupported canvas items, including the profile image, are not changed by text-formatting toolbar actions.

### Key Entities *(include if feature involves data)*

- **Resume Canvas Text Element**: A selectable text item on the resume canvas representing the full name, job title, or summary, including its displayed content and current formatting attributes.
- **Formatting Selection State**: The currently active styling choices shown in the floating toolbar for the selected resume canvas text element.
- **Edit History Entry**: A reversible change record for supported text-content or formatting actions used by undo and redo.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of supported text elements can be individually selected and styled using the floating toolbar during manual acceptance testing.
- **SC-002**: In at least 95% of formatting interactions, the selected text element visibly updates on the resume canvas within 1 second of the user action.
- **SC-003**: 100% of manual validation scenarios confirm that formatting changes affect only the selected supported text element and do not alter unsupported canvas items.
- **SC-004**: Users can complete a style change for full name, job title, or summary in no more than 2 interactions after selecting the target text element.
- **SC-005**: Undo and redo correctly reverse and restore the most recent supported change in 100% of manual validation scenarios covering the supported text elements.

## Assumptions

- The resume canvas already supports selecting the full name, job title, and summary as distinct editable text elements.
- The existing floating toolbar remains the primary control surface for text formatting on the Resume Canvas Editing page.
- Formatting choices made for one supported text element should persist while the user edits other supported text elements in the same session.
- Undo and redo are expected to operate on recent editing actions relevant to the supported text elements, not on unrelated navigation or media actions.
- Profile image upload remains available but is outside the scope of this enhancement except for ensuring it is not affected by text-formatting actions.