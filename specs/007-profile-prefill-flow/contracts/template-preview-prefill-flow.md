# Contract: Template Preview Profile Prefill Flow

## Scope

This contract defines required behavior for the "Use this template" action on Template Preview when integrating optional profile-based prefill.

## Trigger Contract

1. The flow starts when user taps "Use this template" on template preview.
2. System must read stored profile data before deciding whether to show a dialog.

## Availability Decision Contract

1. If profile data is null or effectively empty, system must not show any dialog.
2. If profile data contains usable values, system must show a decision dialog.
3. Profile read failures must not block resume creation; system must continue with create-new behavior.

## Dialog Contract

| Property | Required Value |
| --- | --- |
| Title | Select contest to create CV |
| Action 1 | Create new |
| Action 2 | Use profile data |

### Dialog Behavior

1. Dialog appears only when profile availability check passes.
2. Dismissing the dialog without selecting an action must not create a resume and must keep user on preview page.

## Action Outcome Contract

| User Action | Required Result |
| --- | --- |
| Create new | Create resume from selected template without profile prefill; navigate to editor |
| Use profile data | Create resume from selected template, apply available profile values as prefill, then navigate to editor |

## Field-Level Prefill Contract

1. Prefill logic must evaluate each mapped field independently.
2. For each field:
   - If source value is null/empty, skip only that field.
   - If source value is valid, apply it to target resume field.
3. Missing values in one field must not block other fields from prefilling.
4. Resulting resume must remain fully editable in editor.

## Required Mapping Coverage

The prefill pipeline must support at least these fields when available:
- image
- full name
- job title / position
- birth date
- additional available profile fields (contact, summary, links, and repeatable sections)

## Safety and Consistency Contract

1. Selected template must be preserved for both actions.
2. Single user action must result in only one resume creation flow.
3. No duplicate create events or duplicate navigation transitions are allowed.
4. Existing no-prefill flow behavior must remain unchanged when profile data is unavailable.

## Validation Note

- Implementation aligns with this contract: conditional dialog display, exact required dialog title and actions, and field-level prefill skipping missing values.