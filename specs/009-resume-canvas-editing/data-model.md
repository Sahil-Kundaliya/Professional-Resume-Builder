# Data Model: Resume Canvas Editing

## Overview
This feature extends resume editing data with section-level presentation controls and profile image edit staging while preserving existing resume content entities.

## Entities

### 1) ResumeDocument (existing, extended)
Primary aggregate edited by Resume Canvas and persisted through existing repository flow.

Current fields include:
- Header fields: `fullName`, `jobPosition`, `careerGoals`
- Profile fields: `email`, `phone`, `address`, `birthday`, `website`, `photoPath`
- Repeatable sections: `workExperience[]`, `education[]`, `skills[]`, `hobbies[]`, `awards[]`, `certifications[]`, `references[]`

Planned additions for this feature:
- `sectionVisibility`: map of section key -> visible/hidden state
- `sectionTitleOverrides`: map of section key -> custom display title
- Profile image edit metadata (or equivalent persistable representation) supporting crop/reposition/centered result

Validation rules:
- `fullName`, `jobPosition`, `careerGoals` are protected and always visible.
- Visibility map may only target supported modules:
  - `profile`, `work_experience`, `education`, `skills`, `hobbies`, `awards`, `certifications`, `references`
- Title override can be empty only if system safely falls back to default title.
- Hidden module content data must be retained.

### 2) SectionModulePresentationState (new conceptual entity)
Represents per-module view configuration.

Fields:
- `sectionKey` (enum-like identifier)
- `isVisible` (bool)
- `titleOverride` (nullable string)

Rules:
- Protected mandatory header fields are not represented as removable modules.
- `isVisible=false` means section does not render but data remains unchanged.
- `titleOverride=null` falls back to default title.

### 3) CanvasSelectionContext (derived runtime entity)
Computed from selected field ID to route actions.

Fields:
- `selectedFieldId` (string?)
- `sectionKey` (nullable)
- `itemIndex` (nullable int)
- `actionEligibility` (delete/hide/title-edit booleans)

Rules:
- Delete eligibility is false for `fullName`, `jobPosition`, `careerGoals`.
- For repeatable sections, delete target must resolve to exactly one `itemIndex`.

### 4) ProfileImageEditState (new runtime + persisted output)
Tracks non-destructive image edits before apply.

Fields:
- `sourceImageRef` (selected source image path/base64 ref)
- `cropRect` (normalized bounds)
- `positionOffset` (x/y)
- `isCentered` (bool)
- `previewImageRef` (derived preview)

Rules:
- Cancel discards staged edits.
- Apply commits preview result to `photoPath` (or equivalent persisted field).
- Center action resets position offset to canonical center.

## Relationships
- `ResumeDocument` owns section content arrays and section presentation state.
- `CanvasSelectionContext` is derived from UI selection and maps to `ResumeDocument` mutation targets.
- `ProfileImageEditState` is derived from `ResumeDocument.photoPath` and writes back an edited result upon apply.

## State Transitions

### Deletion flow
1. User selects field -> `CanvasSelectionContext` resolved.
2. Delete action requested.
3. Eligibility check:
- Protected field -> reject with feedback.
- Repeatable item -> remove only item at resolved index.
4. Emit updated `ResumeDocument`.

### Visibility flow
1. User toggles section visibility.
2. `sectionVisibility[sectionKey]` updated.
3. Canvas render filters hidden modules.
4. Section data remains unchanged for future restore.

### Title edit flow
1. User edits section title.
2. Title validated (non-empty usable string or fallback behavior).
3. `sectionTitleOverrides[sectionKey]` updated.
4. Canvas title render uses override if present.

### Profile image edit flow
1. User opens image edit from selected photo.
2. Stage crop/reposition edits and preview.
3. Cancel -> discard staged state, keep current image.
4. Apply -> commit edited image result to document.
