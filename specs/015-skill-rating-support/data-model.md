# Data Model: Skill Rating Support

## Skill Entry
Represents a single skill shown in the resume form and profile editing flow.

### Fields
- **name**: Display label for the skill.
- **rating**: Expertise level from 1 to 5.

### Validation Rules
- The name must be trimmed before save.
- Empty names must not be persisted as valid skills.
- The rating must remain within the 1-5 range.
- Existing skill order must be preserved when a skill is edited.

### Relationships
- Belongs to the Skills list on the resume document.
- Mirrors the same concept used by the profile editing flow so both pages present the same meaning.

## Resume Document Skills Collection
Represents the ordered set of skills displayed in the resume form.

### Fields
- **skills**: Ordered list of skill entries.

### Validation Rules
- The collection may be empty.
- Each item in the collection must be a valid skill entry.
- Display logic must show the skill name and its rating using stars.

### State Transitions
- **Empty**: No skills are displayed, and the user is prompted to add one.
- **Added**: A new skill is inserted with a valid rating.
- **Edited**: The selected skill keeps its position while its content or rating changes.
- **Rendered**: The list shows name, rating label, and star feedback.

## Skill Rating Presentation
Represents the user-facing interpretation of the 1-5 rating.

### Fields
- **value**: Integer from 1 to 5.
- **label**: Beginner, intermediate, advanced, or expert-level meaning derived from the numeric value.

### Validation Rules
- The presentation must never imply a rating outside the supported scale.
- The same rating semantics must be used in both `EditProfilePage` and `ResumeFormPage`.
