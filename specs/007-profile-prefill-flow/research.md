# Research: Template Preview Profile Prefill Flow

## Decision 1: Gate dialog by usable profile content, not just record existence

- **Decision**: Determine profile availability by checking whether at least one mapped profile field has meaningful data instead of checking only whether a profile record file exists.
- **Rationale**: The local profile source can return a default profile object even when the user has not provided real data; record existence alone would incorrectly force the dialog.
- **Alternatives considered**:
  - Treat any stored profile object as available: rejected because it shows dialog for placeholder-only profiles.
  - Require all key fields to be present: rejected because partial profile data is a valid prefill source.

## Decision 2: Keep create-new as baseline fallback path

- **Decision**: Preserve current resume creation and navigation path as the fallback for null/empty profile and error cases.
- **Rationale**: The create-new behavior is already stable and must remain uninterrupted when profile retrieval fails or has no usable values.
- **Alternatives considered**:
  - Block resume creation on profile read failure: rejected because it harms core template flow.
  - Force dialog regardless of profile read result: rejected because spec requires no dialog when data is unavailable.

## Decision 3: Introduce explicit user choice dialog only when profile data exists

- **Decision**: Show a modal decision dialog with exact required title and two actions only after positive availability check.
- **Rationale**: This satisfies explicit-choice requirements and avoids friction for users without data.
- **Alternatives considered**:
  - Always show dialog: rejected due to unnecessary friction and spec violation.
  - Implicitly prefill whenever data exists: rejected because user intent must be explicit per feature goal.

## Decision 4: Apply field-by-field prefill mapping with per-field guards

- **Decision**: Map profile fields to resume document fields independently and apply updates only for non-null, non-empty values; skip empty fields without failing the flow.
- **Rationale**: Partial profile records are common, and the feature requires resilient prefill that never blocks on missing individual values.
- **Alternatives considered**:
  - All-or-nothing prefill transaction: rejected because one missing field would block valid data reuse.
  - Blind overwrite with empty strings: rejected because it can degrade default resume content and user experience.

## Decision 5: Keep mapping logic encapsulated and extensible

- **Decision**: Centralize profile-to-resume mapping rules in a dedicated, testable mapping boundary rather than scattering checks directly in the page UI.
- **Rationale**: The feature explicitly requires clean, scalable architecture and likely future extension of mapped fields.
- **Alternatives considered**:
  - Inline mapping in button onPressed callback: rejected due to reduced maintainability and testability.
  - Add hard-coded one-off events for each field: rejected due to high coupling and growth cost.

## Decision 6: Maintain idempotent user action handling

- **Decision**: Ensure a single tap and single dialog selection dispatches one create action and one navigation transition.
- **Rationale**: Duplicate dispatch or navigation creates inconsistent resume state and violates expected UX.
- **Alternatives considered**:
  - Rely on UI timing assumptions: rejected because asynchronous reads/dialog actions can race.
  - Permit repeated tap races: rejected because it risks duplicate resume initialization.