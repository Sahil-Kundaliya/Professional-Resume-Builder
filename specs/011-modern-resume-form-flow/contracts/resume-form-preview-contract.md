# Contract: Resume Form and Preview Modernization

## Scope

Defines functional contracts for modernized resume form UX, template-driven field rules, validation-gated preview navigation, conditional section rendering, and preview zoom behavior while preserving current architecture.

## Template Field Configuration Contract

| Element | Requirement | Expected Behavior |
| --- | --- | --- |
| Enabled fields | Must be template-defined | Only enabled fields are rendered on resume form |
| Hidden fields | Must be template-defined | Hidden fields are excluded from form and not validated as required |
| Required fields | Must be template-defined | Required fields are clearly indicated and enforced before preview |
| Rule consistency | Must be valid | A field cannot be both hidden and required |

## Resume Form Layout Contract

1. Form must present explicit grouped sections: personal information, work experience, education, skills, hobbies, awards, references.
2. Section layout must support responsive spacing and readable visual hierarchy.
3. Dynamic sections must provide clear add, edit, and remove actions.
4. Form interactions must be non-destructive for untouched data.

## Bottom Sheet Interaction Contract

| Section Type | Entry Action | Edit Surface | Save Behavior | Cancel Behavior |
| --- | --- | --- | --- | --- |
| Work experience | Add or edit tap | Bottom sheet | Persist only valid values and update targeted entry | No mutation of parent list |
| Education | Add or edit tap | Bottom sheet | Persist only valid values and update targeted entry | No mutation of parent list |
| Other dynamic list modules | Add or edit tap | Reusable bottom sheet or consistent inline editor | Persist only valid values | No mutation when canceled |

## Preview Button Contract

1. Form must expose a visually prominent preview button.
2. Preview button styling must align with selected template branding.
3. Placement must keep preview action discoverable without disrupting form completion.
4. Preview action must represent current validation state clearly (enabled or blocked feedback).

## Validation Contract

1. Before preview navigation, system evaluates required fields from selected template configuration.
2. If any required field is invalid or empty, preview navigation is blocked.
3. Field-level feedback must identify what is missing or invalid.
4. Validation state must re-evaluate as fields change.

## Conditional Section Rendering Contract

1. Optional modules with no meaningful data are omitted from preview output.
2. Empty-section omission applies consistently to all optional modules, including skills, hobbies, awards, references, and other optional sections.
3. Omission logic must not hide required sections that have valid data.

## Preview Experience Contract

1. Preview page supports zoom in and zoom out controls.
2. Zoom updates document scale without breaking readability or inspection workflow.
3. Preview rendering remains based on existing template renderer and document pipeline.

## Architecture Preservation Contract

1. Existing resume generation architecture remains intact.
2. Existing template rendering and PDF generation contracts remain intact.
3. Feature changes stay scoped to resume form and preview flow.
4. No unrelated feature redesign is introduced as part of this implementation.
