# Research: Add Profile Navigation

## Decision 1: Add a dedicated `profile` feature instead of storing reusable profile state in the existing resume feature

- **Decision**: Create a new `lib/features/profile/` slice with its own entities, datasource, repository, use cases, bloc, and pages, while keeping the current `home` and `resume` features focused on browsing templates and editing resume documents.
- **Rationale**: The new profile data has a longer-lived purpose than a single resume draft and needs to support viewing, editing, persistence, and reuse across future flows. A dedicated feature keeps responsibilities clear and aligns with the repository's feature-based structure.
- **Alternatives considered**:
  - Store profile fields directly on `ResumeDocument`: rejected because a reusable profile and a template-specific resume are different aggregates with different lifecycle rules.
  - Extend the Home feature to own profile state: rejected because the Home feature currently handles only template discovery and favorites.

## Decision 2: Persist one reusable profile as JSON in the app documents directory

- **Decision**: Implement local file-backed persistence for a single profile record and store the selected profile image as a copied file path under the same app-local directory.
- **Rationale**: The app already depends on `path_provider`, and a file-backed JSON payload is a good fit for one nested profile object with repeated lists such as skills, hobbies, work experience, and education. It avoids introducing a new database dependency for a single-record use case while remaining easy to replace later.
- **Alternatives considered**:
  - Keep profile data only in memory: rejected because the spec now requires persistence for future reuse.
  - Add a key-value dependency for serialized profile blobs: rejected because the existing dependency set already supports file-based storage and image path management.

## Decision 3: Preserve the Home flow by placing it inside an app shell instead of rewriting the flow itself

- **Decision**: Add an app-level bottom navigation container that hosts the existing Home experience and the new Profile section as peer tabs.
- **Rationale**: The Home flow must remain unchanged from a user perspective. Wrapping the current Home page in a shell minimizes disruption while allowing Profile to become a top-level section.
- **Alternatives considered**:
  - Rebuild Home into a new composite page: rejected because it increases regression risk in the template browsing journey.
  - Route directly between Home and Profile without a persistent shell: rejected because the requirement calls for bottom navigation with two main tabs.

## Decision 4: Add an explicit template start decision dialog before the resume editor opens

- **Decision**: When the user taps Use this template on the preview page, show a confirmation dialog with Start From Scratch and Use Your Data actions before creating or opening the editor document.
- **Rationale**: This preserves the current template-first flow while making profile reuse a deliberate decision at the point where the user starts editing. It also keeps the two initialization paths easy to reason about and test.
- **Alternatives considered**:
  - Always prefill when profile data exists: rejected because the spec requires a user choice.
  - Move the choice into the editor page after opening: rejected because the decision belongs to template startup and would complicate editor initialization.

## Decision 5: Use a dedicated mapper to transform saved profile data into a new resume document

- **Decision**: Create a focused mapping path that merges a selected template with either a blank resume or a new resume derived from the saved profile, only filling fields for which saved profile values exist.
- **Rationale**: This makes the Start From Scratch and Use Your Data branches explicit, testable, and future-friendly. Partial profile data can be handled predictably without polluting editor code with ad hoc mapping rules.
- **Alternatives considered**:
  - Populate the editor widget directly from profile state: rejected because initialization logic belongs before the editor page is shown.
  - Mutate the saved profile into a resume document in the preview page itself: rejected because it mixes UI flow with data transformation responsibilities.

## Decision 6: Keep all profile fields optional and use empty-state-friendly repeated sections

- **Decision**: Model profile fields and repeated entries as optional or empty-by-default collections, and allow the profile summary screen plus edit flow to render and save partial data without blocking requirements.
- **Rationale**: The spec explicitly states that all profile fields remain optional. The UX should therefore support incremental profile building and partial reuse in prefill scenarios.
- **Alternatives considered**:
  - Require a minimum subset such as name or job title before save: rejected because it contradicts the feature requirements.
  - Hide empty sections completely from the summary screen: rejected because users still need visibility into the areas they can fill next.