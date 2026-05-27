# Quickstart: Implement Resume Canvas Editing

## Goal
Deliver configurable Resume Canvas editing for delete rules, section visibility, section title overrides, and profile image editing while preserving existing editor architecture.

## Scope Guardrails
- Change only resume feature files, primarily Resume Canvas flow.
- Do not alter template creation flow.
- Do not modify unrelated modules.

## Suggested Implementation Sequence

1. Add section presentation state in resume feature domain model
- Extend resume document state to carry section visibility and title overrides.
- Define defaults for all supported modules.

2. Add selection-to-action mapping in Resume Canvas
- Parse selected field ID into section key and item index.
- Centralize action eligibility rules.

3. Implement deletion behavior
- Wire existing delete controls to conditional delete handler.
- Block deletion for `fullName`, `jobPosition`, `careerGoals`.
- For repeatable sections, remove only selected item.

4. Implement section visibility controls
- Add hide/remove interaction for supported modules.
- Ensure hidden modules do not render.
- Ensure hidden module data is preserved for restore.

5. Implement editable section titles
- Make section headers editable for supported modules.
- Validate title input and persist override.
- Render override or default title.

6. Implement profile image editing flow
- Add edit entry point from profile photo selection.
- Provide crop, reposition, center, preview, apply/cancel behavior.
- Commit only on apply.

7. Add integrity tests
- Protected field deletion/hide blocking.
- Item-specific deletion behavior per list section.
- Hide/restore preserves data.
- Title override persistence and fallback.
- Image edit preview/apply/cancel behavior.

## Verification Checklist
- Delete button performs conditional delete correctly.
- Mandatory fields are always present and protected.
- Optional modules can be hidden and restored without data loss.
- Custom titles render correctly after updates.
- Profile image edit preview matches applied output.
- Existing resume editor interactions remain functional.
