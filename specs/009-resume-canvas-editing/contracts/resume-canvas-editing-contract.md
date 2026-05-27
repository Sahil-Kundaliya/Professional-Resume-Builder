# Resume Canvas Editing Contract

## Purpose
Define behavioral contracts between Resume Canvas UI interactions and resume feature state updates.

## Contract Surface

### 1) Selection Contract
Input:
- `selectedFieldId: String?`

Expected patterns:
- Header fields: `fullName`, `jobPosition`, `careerGoals`, `photoPath`
- Work: `exp_date_{i}`, `exp_pos_{i}`, `exp_company_{i}`, `exp_desc_{i}`
- Education: `edu_date_{i}`, `edu_course_{i}`, `edu_school_{i}`, `edu_desc_{i}`
- Skills: `skill_{i}`
- Hobbies: `hobby_{i}`
- Awards: `award_year_{i}`, `award_name_{i}`
- Certifications: `cert_year_{i}`, `cert_name_{i}`
- References: `ref_{i}`
- Profile fields: `profile_email`, `profile_phone`, `profile_address`, `profile_birthday`, `profile_website`

Guarantee:
- Every edit/delete/title/visibility action resolves from current selection or section key deterministically.

### 2) Deletion Contract
Input:
- User action: delete on selected canvas element

Rules:
- Protected field IDs `fullName`, `jobPosition`, `careerGoals` MUST NOT be deleted.
- Deletion supported only for repeatable/list sections:
  - work experience, education, skills, hobbies, awards, certifications, references
- Only the selected item index is removed.

Output:
- Updated `ResumeDocument` with exactly one targeted list item removed, or unchanged document with user feedback when blocked.

### 3) Section Visibility Contract
Input:
- User toggles visibility for section key in:
  - `profile`, `work_experience`, `education`, `skills`, `hobbies`, `awards`, `certifications`, `references`

Rules:
- Hidden section is not rendered in canvas.
- Hidden section data remains intact for restore.
- Protected mandatory header fields remain visible regardless of section toggles.

Output:
- Updated section visibility state and rerendered canvas.

### 4) Section Title Contract
Input:
- User edits title for supported section key

Rules:
- Supported: profile, work experience, education, skills, hobbies, awards, certifications, references.
- Invalid empty titles must resolve to either validation error or default title fallback.
- Title override does not mutate section content.

Output:
- Updated title override and immediate reflected heading in canvas.

### 5) Profile Image Editing Contract
Input:
- User initiates photo edit, then crop/reposition/center actions

Rules:
- Preview must represent pending edits before commit.
- Cancel must preserve previously applied image.
- Apply commits edited result to document photo field.

Output:
- On apply: updated `photoPath` (or equivalent persisted result)
- On cancel: unchanged persisted image

## Non-Functional Contract
- All changes remain scoped to resume feature modules and current editor architecture.
- No template flow changes.
- No modifications to unrelated features/modules.
