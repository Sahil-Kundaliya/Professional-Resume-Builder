# Contract: Favorite Template Interaction

## Purpose
Define the expected interaction contract for favorite behavior across Home and Template Preview flows.

## Participants
- **Home Template List**: Displays template cards and filter controls.
- **Template Thumbnail**: Emits favorite toggle intent for a template ID.
- **Template Preview Page**: Displays selected template and emits favorite toggle intent for the same template ID.
- **Favorite Management Layer**: Persists favorite IDs and returns merged template state.

## Input Events
- **LoadTemplatesRequested**: Triggered when Home initializes.
- **FavoriteToggled(templateId)**: Triggered from thumbnail or preview icon tap.
- **FavoritesFilterChanged(favoritesOnly)**: Triggered when Home filter is changed.

## Required Behaviors
1. On `LoadTemplatesRequested`, system returns template catalog with favorite flags merged from persisted favorite IDs.
2. On `FavoriteToggled(templateId)`, system updates persistence and emits updated template state immediately.
3. Any surface rendering the same `templateId` must reflect the same favorite state without manual refresh choreography.
4. On `FavoritesFilterChanged(true)`, Home shows only templates where `isFavorite = true`.
5. On `FavoritesFilterChanged(false)`, Home shows full template catalog.
6. If filtered result is empty, Home shows explicit empty-result messaging.

## Error/Resilience Rules
- If local favorite data read fails, system falls back to an empty favorite set for the session and keeps catalog browsable.
- Unknown favorite IDs are ignored when merging with current catalog.
- Duplicate persisted IDs are normalized to a unique set before merge.

## Non-Goals
- Cross-device sync of favorites.
- Any changes to template selection/creation flow beyond favorite and filtering behavior.
