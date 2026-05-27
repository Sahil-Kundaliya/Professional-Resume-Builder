# Contract: Resume Form Flow

## Scope

This contract defines the expected behavior for template selection continuity, resume form navigation, structured input sections, dynamic list management, preview rendering, and cleanup of obsolete canvas-editing behavior.

## Template Entry Contract

| Element | Requirement | Expected Behavior |
| --- | --- | --- |
| Template list | Must remain available as the flow entry point | Users can browse available resume templates before making a selection |
| Template preview | Must remain available before commitment | Users can inspect the selected template in a non-editable preview |
| Use this template action | Must no longer enter canvas editing | Tapping the action opens the resume form flow for the selected template |

## Resume Form Navigation Contract

1. The form opens in the context of the template selected from the preview flow.
2. If profile prefill is available and selected, the form opens with those values already mapped into the draft.
3. The user can move from the form to preview and back without losing entered values.
4. The creation flow must not expose the old direct canvas-editing page as the primary editing surface.

## Resume Form Section Contract

| Section | Required Behavior |
| --- | --- |
| Basic information | Support image, full name, job position, summary, birth date, email, phone, address, and portfolio when supported by the template |
| Skills | Support multiple items and safe update/removal behavior |
| Hobbies | Support multiple items and safe update/removal behavior |
| Awards | Support multiple items and editable values that render meaningfully in preview |
| Certifications | Support multiple items and editable values that render meaningfully in preview |
| References | Support multiple items as text-based references |

## Structured Record Contract

| Record Type | Trigger | Editing Surface | Save Rule |
| --- | --- | --- | --- |
| Work experience | User taps add or edit | Bottom sheet | Required fields must be complete before save, and saved changes update only the targeted list item |
| Education | User taps add or edit | Bottom sheet | Multiple text inputs remain editable, required fields must be complete before save, and saved changes update only the targeted list item |

## Dynamic List Behavior Contract

1. Add actions must append a new entry to the targeted section only after successful validation.
2. Edit actions must load the selected item into its editing surface without mutating sibling items.
3. Delete actions must remove only the targeted item.
4. Dismissing an add or edit bottom sheet without saving must leave the parent form unchanged.
5. Empty repeatable sections must still show a clear entry point for adding the first item.

## Preview Contract

1. The resume form exposes a Preview action from within the page.
2. Preview must render the selected template using the latest available form data.
3. The preview surface must stay read-only for this flow; edits happen in the form, not on the rendered template.
4. Returning from preview must reopen the form with the latest draft values intact.
5. Generate or PDF preview actions must continue to operate on the same rendered resume payload used by preview.

## Validation and Failure Handling Contract

1. Invalid scalar values should surface clear feedback without discarding unrelated entered data.
2. Invalid work experience or education records must stay in their bottom-sheet context until the user fixes the issue or cancels.
3. Image-selection cancellation or failure must not block the rest of the form.
4. Partial drafts may still be previewed as long as the renderer can safely display the available data.

## Cleanup Contract

1. Obsolete canvas-only editing controls must be removed or retired when they no longer serve a reachable user flow.
2. Selection-based formatting logic must not remain as a hidden dependency of resume creation.
3. Renderer behavior used by template preview and generated output must remain intact.
4. Cleanup must not break template selection, template preview, profile-prefill choice, or preview/generation behavior.