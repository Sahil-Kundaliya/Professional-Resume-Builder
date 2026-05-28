# Research: Skill Rating Support

## Decision 1: Reuse the existing 1-5 skill rating model
- **Decision**: Keep skills represented as a name plus a 1-5 expertise rating.
- **Rationale**: The profile editing flow already uses this shape, so reusing it avoids duplicate semantics and keeps rating meaning consistent across the app.
- **Alternatives considered**:
  - Keep skills as plain text only. Rejected because it does not satisfy the expertise requirement.
  - Introduce a second resume-only skill type. Rejected because it fragments the skill experience.

## Decision 2: Standardize the skill editor and display pattern
- **Decision**: Use a shared reusable skill UI pattern for adding, editing, and rendering skills.
- **Rationale**: A shared component reduces drift between `EditProfilePage` and `ResumeFormPage` and lowers the risk of inconsistent star behavior.
- **Alternatives considered**:
  - Duplicate the profile skill flow inside the resume form. Rejected because the two experiences would diverge over time.
  - Build a resume-only interaction pattern. Rejected because the user explicitly asked for consistency.

## Decision 3: Keep scope limited to the Skills section
- **Decision**: Change only the skills editing and rendering path in the resume form.
- **Rationale**: The request is narrowly scoped and unrelated form sections should remain untouched to minimize regression risk.
- **Alternatives considered**:
  - Refresh the full resume form UI. Rejected because it exceeds the requested scope.
  - Modify other resume sections for consistency. Rejected because no requirement asks for broader changes.

## Decision 4: No external interface contract is needed
- **Decision**: Skip the `/contracts` artifact for this feature.
- **Rationale**: The work is internal UI and state-shape alignment inside the Flutter app; it does not expose a new public API, CLI command, or service endpoint.
- **Alternatives considered**:
  - Add a contract document for the skill widget. Rejected because the widget is internal, not an external interface.
