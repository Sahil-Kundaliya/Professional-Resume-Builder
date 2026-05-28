# Quickstart: Favorite Template Support

## Prerequisites
- Flutter dependencies installed.
- App launches successfully on a local target.

## Validate Persistent Favorites
1. Launch the app and open Home template listing.
2. Mark at least two templates as favorites from thumbnail cards.
3. Open one favorited template in preview and verify favorite icon is active.
4. Close and relaunch the app.
5. Confirm the same templates remain favorited in Home and preview.

## Validate Favorite Toggle Flow
1. In Home, toggle a template from unfavorited to favorited.
2. Confirm icon state updates immediately.
3. Toggle the same template back to unfavorited.
4. Confirm icon state updates immediately and remains after relaunch.

## Validate Favorites Only Filter
1. In Home, enable **Favorites Only**.
2. Confirm only favorited templates are shown.
3. Disable **Favorites Only**.
4. Confirm full template catalog is shown.
5. Enable **Favorites Only** with no favorites and verify explicit empty-result messaging.

## Validate Cross-Surface Consistency
1. Favorite a template from Home thumbnail.
2. Open preview for the same template and confirm favorite icon matches.
3. Unfavorite from preview.
4. Return to Home and confirm state reflects immediately.

## Recommended Validation Commands
```bash
flutter test
```

```bash
flutter run
```

## Verification Notes
- 2026-05-28: Automated regression command `flutter test` completed successfully.
- 2026-05-28: Favorites persistence, synchronized toggle behavior, and Home Favorites Only filtering were implemented across Home and preview flows.
