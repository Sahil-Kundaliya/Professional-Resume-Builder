# Research: Edit Profile Flow

## Decision 1: Keep reusable profile data as a dedicated aggregate separate from `ResumeDocument`

- **Decision**: Build the edit flow around a `ResumeProfile`-style aggregate in the `profile` feature instead of storing edit state directly on the existing resume editor document.
- **Rationale**: The profile serves a longer-lived purpose than a single resume draft and needs to support summary viewing, editing, persistence, and future reuse. Keeping it separate avoids coupling profile management to editor placeholders and template-specific state.
- **Alternatives considered**:
  - Reuse `ResumeDocument` as the edit model: rejected because it is optimized for template editing, includes editor placeholders, and would leak resume-specific defaults into reusable profile storage.
  - Keep the current placeholder-only Profile page and postpone data modeling: rejected because the feature requires a complete saveable edit flow now.

## Decision 2: Persist one reusable profile locally as a serialized record with an app-local image path

- **Decision**: Store a single reusable profile record in app-local storage and keep the chosen gallery image as an app-local file reference rather than only a transient picker result.
- **Rationale**: The project already depends on `path_provider` and `image_picker`, and the feature only needs one user profile at this stage. Local serialized storage is enough for nested repeated sections while staying simple to evolve later.
- **Alternatives considered**:
  - Keep profile data only in memory: rejected because the Profile page must show the latest saved information across later visits.
  - Introduce a heavier local database now: rejected because the current scope is one profile record with ordered collections, which does not justify extra storage complexity yet.

## Decision 3: Use a dedicated Edit Profile page launched from the Profile summary page

- **Decision**: Keep the Profile tab focused on viewing the saved profile and provide a separate Edit Profile page for form entry and saving.
- **Rationale**: The user explicitly requested an Edit button on the Profile page and navigation into a dedicated edit screen. This also prevents the summary screen from becoming a mixed read/write surface.
- **Alternatives considered**:
  - Make the Profile page directly editable inline: rejected because it weakens the view-versus-edit boundary and does not match the requested flow.
  - Use modal-only editing for the entire profile: rejected because the form is too large and section-heavy for a single modal container.

## Decision 4: Use inline repeatable rows for lightweight items and bottom sheets for structured records

- **Decision**: Render skills, hobbies, awards, and certifications inline on the Edit Profile page, while work experience and education use dedicated bottom sheets for add/edit flows.
- **Rationale**: This matches the requested UX and keeps simple items fast to edit while giving structured records enough space for required fields and validation feedback.
- **Alternatives considered**:
  - Put every repeated section in bottom sheets: rejected because lightweight items such as hobbies and awards would become slower to manage.
  - Keep work experience and education inline: rejected because the required-field rules and multiple fields per record would crowd the main form.

## Decision 5: Apply layered validation that preserves user-entered values

- **Decision**: Validate basic fields when values are provided, enforce `birthDate <= today`, require complete experience and education records before saving those records, and preserve the rest of the user-entered form state when validation fails.
- **Rationale**: The feature must balance data quality with incremental editing. Users should not lose their work because one field or one bottom sheet record is invalid.
- **Alternatives considered**:
  - Enforce a fully complete profile before save: rejected because the broader profile remains incrementally editable and reusable.
  - Allow incomplete experience and education records to save: rejected because the feature explicitly requires all fields for those record types before save.

## Decision 6: Represent topic-based experience details as ordered lines in the reusable profile model

- **Decision**: Store experience details as an ordered list of text lines rather than one opaque text blob, then map them into downstream consumers as needed.
- **Rationale**: The user requested topic-based details with multiple lines, and a list-based representation keeps editing, validation, removal, and future reuse more flexible.
- **Alternatives considered**:
  - Store details as one multiline string: rejected because it makes per-line editing and future mapping less predictable.
  - Limit experience to a single summary sentence: rejected because it does not satisfy the requested multi-line details behavior.

## Decision 7: Extend reusable profile scope to include awards and certifications now

- **Decision**: Add awards and certifications to the reusable profile aggregate in this phase, even though the current placeholder Profile screen does not yet render them.
- **Rationale**: The requested edit flow includes both sections, and the resume domain already has analogous repeated entry concepts that this profile data can align with later.
- **Alternatives considered**:
  - Defer awards and certifications to a later phase: rejected because it would leave the requested edit flow incomplete.
  - Store awards and certifications outside the profile aggregate: rejected because they belong to the same reusable professional profile concept.