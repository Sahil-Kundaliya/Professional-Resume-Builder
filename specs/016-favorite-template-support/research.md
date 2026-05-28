# Research: Favorite Template Persistence and Sync

## Decision 1: Persist favorites as a local set of template IDs
- **Decision**: Store favorites as a unique list/set of template IDs in local key-value storage.
- **Rationale**: The feature only needs lightweight persistence for identifiers, not full template snapshots. Storing IDs avoids duplication and naturally survives catalog content updates.
- **Alternatives considered**:
  - Persist full template objects. Rejected because it creates stale data risk and unnecessary storage complexity.
  - Keep in-memory favorites only. Rejected because favorites are lost on restart.

## Decision 2: Introduce a reusable favorite state manager behind repository boundaries
- **Decision**: Use a dedicated favorite management abstraction in the data/domain flow, consumed by Home and preview surfaces via shared repository/use case behavior.
- **Rationale**: A single source of truth for favorite IDs prevents drift between `TemplateThumbnail`, `TemplatePreviewPage`, and Home list/filter logic.
- **Alternatives considered**:
  - Duplicate favorite toggling logic in each UI surface. Rejected due to inconsistency risk and poor maintainability.
  - Keep favorite logic only in `HomeBloc`. Rejected because preview page also needs synchronized behavior.

## Decision 3: Merge favorite state onto template catalog during load
- **Decision**: Build effective template state by combining catalog templates with persisted favorite IDs at load time and after toggles.
- **Rationale**: Catalog remains authoritative for template metadata while local persistence remains authoritative for favorite selection.
- **Alternatives considered**:
  - Mutate static template registries directly per surface. Rejected because this causes local-only UI state and cross-screen desynchronization.
  - Treat template model `isFavorite` as long-term persistence itself. Rejected because existing in-memory data source behavior is not app-restart persistent.

## Decision 4: Add Favorites Only as a view filter state, not a separate catalog source
- **Decision**: Keep one loaded template set and apply a `favoritesOnly` filter in presentation state.
- **Rationale**: This keeps behavior predictable, minimizes duplicate loading logic, and allows immediate toggling between full and filtered views.
- **Alternatives considered**:
  - Separate fetch path for favorites-only results. Rejected because it duplicates logic and complicates synchronization.
  - Hard-wire Home to favorites list permanently. Rejected because full catalog visibility remains required.

## Decision 5: Handle invalid and stale favorite IDs defensively
- **Decision**: Ignore unknown IDs when rendering templates and sanitize duplicates into a unique set.
- **Rationale**: Template catalogs can evolve; persistence must remain resilient without breaking UI flows.
- **Alternatives considered**:
  - Throw errors on unknown IDs. Rejected because it harms user experience for benign stale data.
  - Clear all favorites on any mismatch. Rejected because it discards valid user choices unnecessarily.

## Decision 6: Testing strategy prioritizes repository + bloc + widget integration
- **Decision**: Validate persistence and synchronization using focused data/repository tests plus Home and preview interaction/widget tests.
- **Rationale**: The feature is state-heavy across layers; tests must verify both persisted behavior and cross-surface UI consistency.
- **Alternatives considered**:
  - Widget-only coverage. Rejected because persistence correctness can be missed.
  - Data-layer-only coverage. Rejected because UI filter/toggle behavior is central to user value.
