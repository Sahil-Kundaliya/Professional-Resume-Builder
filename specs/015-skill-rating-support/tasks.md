# Tasks: Skill Rating Support

**Input**: Design documents from `/specs/015-skill-rating-support/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, quickstart.md

**Tests**: Included because the feature request explicitly asks to validate rating updates, star rendering, and add/edit parity with `EditProfilePage`.

**Organization**: Tasks are grouped by user story so each story can be implemented and validated independently.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Establish the reusable skill-rating module boundary used by both resume and profile flows

- [x] T001 [P] Create the shared skill-rating barrel export and folder scaffold in `lib/core/widgets/skill_rating/skill_rating.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core reusable skill components that MUST exist before any user story implementation

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T002 [P] Add shared 1-5 rating clamp and expertise label helpers in `lib/core/widgets/skill_rating/skill_rating_utils.dart`
- [x] T003 [P] Implement the reusable shared skill bottom sheet editor with star selection in `lib/core/widgets/skill_rating/skill_rating_bottom_sheet.dart`
- [x] T004 [P] Implement the reusable shared skill display row with name, rating text, and stars in `lib/core/widgets/skill_rating/skill_rating_row.dart`
- [x] T005 [P] Add shared helper tests for rating clamping and label mapping in `test/core/widgets/skill_rating/skill_rating_utils_test.dart`

**Checkpoint**: Shared skill-rating components are ready for page-level integration

---

## Phase 3: User Story 1 - Add and Edit Skill Ratings in ResumeFormPage (Priority: P1) 🎯 MVP

**Goal**: Users can add, edit, rate, and remove skills in `ResumeFormPage` with a 1-5 star experience.

**Independent Test**: Add a skill, edit its rating, remove a skill, save the form, and confirm the stored skill list reflects the changes.

### Tests for User Story 1

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [x] T006 [P] [US1] Add failing widget tests for resume skill add, edit, remove, and rating persistence in `test/features/resume/resume_form_page_skill_rating_test.dart`

### Implementation for User Story 1

- [x] T007 [US1] Replace the Skills section add/edit entry point in `lib/features/resume/presentation/pages/resume_form_page.dart` so it opens the shared skill bottom sheet editor
- [x] T008 [US1] Replace the Skills list mutation and remove handling in `lib/features/resume/presentation/pages/resume_form_page.dart` so resume skills preserve their selected ratings

**Checkpoint**: Resume skill add/edit/remove flows should now work independently

---

## Phase 4: User Story 2 - Improve Skill Display in ResumeFormPage (Priority: P2)

**Goal**: Each skill in `ResumeFormPage` clearly shows the skill name, the selected expertise level, and a visual star indicator.

**Independent Test**: Open a resume with multiple skills and verify each skill item renders the name, rating text, and correct number of stars.

### Tests for User Story 2

- [x] T009 [P] [US2] Add failing display tests for skill name, rating label, and star rendering in `test/features/resume/skill_rating_display_test.dart`

### Implementation for User Story 2

- [x] T010 [US2] Render the shared skill display row in the Skills section of `lib/features/resume/presentation/pages/resume_form_page.dart` so each item shows the rating and stars

**Checkpoint**: Resume skill display should now communicate expertise level clearly

---

## Phase 5: User Story 3 - Keep Profile and Resume Skill UX Consistent (Priority: P3)

**Goal**: The skill rating interaction and display behavior matches between `EditProfilePage` and `ResumeFormPage`.

**Independent Test**: Add or edit a skill in `EditProfilePage` and verify the same 1-5 semantics, star meaning, and display style are used as in the resume form.

### Tests for User Story 3

- [x] T011 [P] [US3] Add failing parity tests for shared skill rating behavior in `test/features/profile/skill_rating_parity_test.dart`

### Implementation for User Story 3

- [x] T012 [US3] Refactor `lib/features/profile/presentation/widgets/skill_bottom_sheet.dart` to delegate to the shared skill bottom sheet editor
- [x] T013 [P] [US3] Refactor `lib/features/profile/presentation/pages/edit_profile_page.dart` and `lib/features/profile/presentation/widgets/profile_skills_section.dart` to render the shared skill display row and preserve the same expertise semantics

**Checkpoint**: Both pages should now share the same skill interaction pattern

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final cleanup and validation across the feature

- [ ] T014 [P] Remove any obsolete resume-only skill text fallback from `lib/features/resume/presentation/widgets/resume_repeatable_text_section.dart` if it is no longer used by the Skills section
- [ ] T015 [P] Run `flutter test` and verify the skill flows documented in `specs/015-skill-rating-support/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel if needed
  - Implement in priority order for the MVP-first path
- **Polish (Final Phase)**: Depends on the skill stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - establishes the MVP skill editor and rating flow in `ResumeFormPage`
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - depends on the shared display row but remains independently testable
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - reuses the shared editor/display patterns to align `EditProfilePage`

### Within Each User Story

- Tests (if included) MUST be written and fail before implementation
- Shared components before page wiring
- Page wiring before cleanup
- Story complete before moving to the next priority

### Parallel Opportunities

- T002 through T005 can run in parallel because they touch different shared files and test files
- T006 can run in parallel with T009 and T011 once the shared components exist
- T013 can run in parallel with T014 because they touch different files

---

## Parallel Example: User Story 1

```bash
# Launch the shared foundational work together:
Task: "Add shared 1-5 rating clamp and expertise label helpers in lib/core/widgets/skill_rating/skill_rating_utils.dart"
Task: "Implement the reusable shared skill bottom sheet editor with star selection in lib/core/widgets/skill_rating/skill_rating_bottom_sheet.dart"
Task: "Implement the reusable shared skill display row with name, rating text, and stars in lib/core/widgets/skill_rating/skill_rating_row.dart"
Task: "Add shared helper tests for rating clamping and label mapping in test/core/widgets/skill_rating/skill_rating_utils_test.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Verify add, edit, remove, and rating persistence in `ResumeFormPage`
5. Demo or merge once the skill editing MVP is stable

### Incremental Delivery

1. Setup + Foundational complete the reusable skill-rating foundation
2. Add User Story 1 to make the resume skill editor production-ready
3. Add User Story 2 to make skill expertise visible and understandable
4. Add User Story 3 to align the profile and resume skill experiences
5. Finish with cleanup and full validation

### Parallel Team Strategy

With multiple developers:

1. One developer builds the shared skill-rating components
2. One developer wires `ResumeFormPage` to the new components
3. One developer aligns `EditProfilePage` with the shared pattern
4. Another developer covers the widget tests and parity checks

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps each task to a specific user story for traceability
- The MVP is User Story 1 because it delivers the core rating workflow in `ResumeFormPage`
- Keep all changes limited to the Skills section and the reusable skill UI used by both pages