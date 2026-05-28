# Data Model: Favorite Template Support

## Template Catalog Item
Represents one available resume template shown in Home and preview flows.

### Fields
- **id**: Stable unique identifier for the template.
- **name**: User-facing template name.
- **description**: User-facing summary for browsing.
- **accent metadata**: Visual style values used by existing template UI.
- **isFavorite**: Derived boolean indicating whether `id` exists in the persisted favorite set.

### Validation Rules
- `id` must be non-empty and unique within the catalog.
- `isFavorite` must be computed from favorite storage state, not hardcoded per screen.

## Favorite Template Set
Represents the persisted favorite selection on device.

### Fields
- **favoriteIds**: Unique collection of template IDs.
- **lastUpdatedAt** (optional metadata): Timestamp for diagnostics/analytics when needed.

### Validation Rules
- IDs are unique; duplicates collapse to one entry.
- Unknown IDs are tolerated and ignored at render time.
- Empty set is valid.

### State Transitions
- **Initialized**: Loaded from local storage on app startup.
- **Added**: Template ID inserted after favorite action.
- **Removed**: Template ID removed after unfavorite action.
- **Recovered**: If storage read fails, app falls back to an empty set for the current session.

## Template Filter State
Represents Home page filter mode.

### Fields
- **favoritesOnly**: Boolean flag controlling list visibility.

### Validation Rules
- `false` means show full template catalog.
- `true` means show only templates with `isFavorite = true`.

### State Transitions
- **All Templates** -> **Favorites Only** when filter is enabled.
- **Favorites Only** -> **All Templates** when filter is disabled.

## Home Template View State
Represents rendered templates plus filter and loading status.

### Fields
- **templates**: Current catalog with merged favorite flags.
- **favoritesOnly**: Current filter mode.
- **visibleTemplates**: Derived list after filter application.
- **status**: Initial/loading/loaded/error.

### Validation Rules
- `visibleTemplates` must be deterministic from `templates + favoritesOnly`.
- If `favoritesOnly = true` and `visibleTemplates` is empty, UI must show an explicit empty-result state.
