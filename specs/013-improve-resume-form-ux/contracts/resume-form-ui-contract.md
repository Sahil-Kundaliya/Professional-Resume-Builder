# Contract: Resume Form UI Behavior

## Purpose

Define the behavioral contract for ResumeFormPage modernization, template-aware styling, dynamic section interactions, profile image preview, and skill rating support.

## Inputs

- Existing resume form state and event flows.
- Selected resume template style metadata.
- User interactions on sectioned form controls.

## Contract Rules

### 1. Sectioned Form Layout Contract

- ResumeFormPage MUST render inputs in grouped sections instead of one uninterrupted field list.
- Sections MUST include clear titles and visible container boundaries.
- Section ordering MUST remain stable across sessions.

### 2. Template Accent Contract

- Form UI MUST apply selected template accents to:
  - action buttons
  - section headers
  - highlight elements
  - focused input states
  - progress indicators (when shown)
- Accent application MUST not degrade readability or interaction clarity.

### 3. Dynamic Section Interaction Contract

- Repeatable sections (experience, education, skills, hobbies, references, awards) MUST provide consistent add/edit/remove affordances.
- Add/edit interactions MUST follow a consistent presentation pattern (including bottom-sheet usage where applicable).
- Edits MUST preserve existing data integrity and state synchronization behavior.

### 4. Profile Image Preview Contract

- Image selection MUST produce inline visual preview when image is available.
- Raw image path MUST not be presented as the primary UI outcome.
- If image cannot be rendered, UI MUST present graceful fallback state and keep form usable.

### 5. Skill Rating Contract

- Each skill MUST support `level` with valid range 1 to 5.
- Skill add/edit UI MUST provide a star-rating control for level selection.
- Existing skill level MUST be shown during edit and persisted on save.

## Acceptance Signals

- Users can complete form sections with improved readability and hierarchy.
- Template switch is reflected in form accents.
- Dynamic sections behave consistently across add/edit/remove operations.
- Image preview is visible after selection for valid images.
- Skill star ratings are editable and persisted.
