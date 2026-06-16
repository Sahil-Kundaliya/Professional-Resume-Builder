# Tasks: Profile Page UI Redesign

**Input**: Design documents from `/specs/018-profile-ui-redesign/`

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Gather current implementation details and prepare for the visual redesign.

- [ ] T001 Review `lib/features/profile/presentation/pages/profile_page.dart` to document current section order, scroll layout, and existing edit action behavior
- [ ] T002 Review existing profile presentation widgets in `lib/features/profile/presentation/widgets/` and identify styling gaps for the premium redesign

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish shared premium styling and reusable presentation foundations before section-specific updates.

- [ ] T003 [P] Update `lib/features/profile/presentation/widgets/profile_section_card.dart` with polished premium card styling, including elevated background, soft border radius, and consistent padding
- [ ] T004 [P] Update `lib/features/profile/presentation/widgets/profile_section_header.dart` to use refined section heading typography and spacing for a premium hierarchy
- [ ] T005 [P] Update `lib/features/profile/presentation/widgets/profile_identity_card.dart` to improve the shared avatar container, placeholder style, and header layout baseline

---

## Phase 3: User Story 1 - View premium profile layout (Priority: P1) 🎯 MVP

**Goal**: Redesign the Profile page layout, header, and all visible sections so the page feels premium, modern, and visually coherent.

**Independent Test**: Open `lib/features/profile/presentation/pages/profile_page.dart` and confirm the redesigned header, summary, contact, experience, education, skills, hobbies, awards, certifications, and references sections all render in distinct premium visual blocks.

- [ ] T006 [US1] Update `lib/features/profile/presentation/pages/profile_page.dart` to use the new premium page layout and section grouping while preserving current section order
- [ ] T007 [P] [US1] Redesign `lib/features/profile/presentation/widgets/profile_identity_card.dart` to present the profile image, name, and job title with improved spacing, alignment, and premium visual styling
- [ ] T008 [P] [US1] Redesign `lib/features/profile/presentation/widgets/profile_summary_section.dart` to use improved typography, spacing, and modern card visual language
- [ ] T009 [P] [US1] Redesign `lib/features/profile/presentation/widgets/profile_contact_section.dart` to present contact details in a premium card layout with cleaner label/value alignment
- [ ] T010 [P] [US1] Update `lib/features/profile/presentation/widgets/profile_experience_section.dart` to improve spacing, section hierarchy, and readability for experience entries
- [ ] T011 [P] [US1] Update `lib/features/profile/presentation/widgets/profile_education_section.dart` to improve spacing, typography, and visual grouping for education entries
- [ ] T012 [P] [US1] Update `lib/features/profile/presentation/widgets/profile_skills_section.dart` to use premium spacing and a more polished skills presentation style
- [ ] T013 [P] [US1] Update `lib/features/profile/presentation/widgets/profile_hobbies_section.dart` to improve hobby chips, spacing, and visual consistency with the premium design
- [ ] T014 [P] [US1] Update `lib/features/profile/presentation/widgets/profile_awards_section.dart` to improve awards presentation with premium typography and spacing
- [ ] T015 [P] [US1] Update `lib/features/profile/presentation/widgets/profile_certifications_section.dart` to improve certifications presentation with premium typography and spacing
- [ ] T016 [P] [US1] Review `lib/features/profile/presentation/pages/profile_page.dart` and `lib/features/profile/presentation/widgets/` for references presentation support and update any existing references UI styling if references are rendered

---

## Phase 4: User Story 2 - Preserve edit flow and existing behavior (Priority: P2)

**Goal**: Confirm the redesign preserves the existing edit functionality, navigation, and state handling.

**Independent Test**: From the redesigned Profile page, tap the edit button and verify the app navigates to the same edit workflow with current profile data intact.

- [ ] T017 [US2] Ensure `lib/features/profile/presentation/pages/profile_page.dart` retains the existing `TextButton` edit action and `AppRoutes.editProfile` navigation path
- [ ] T018 [US2] Ensure `lib/features/profile/presentation/pages/profile_page.dart` continues to use `BlocProvider` and `BlocBuilder` for profile state without changing state management
- [ ] T019 [US2] Ensure the existing draft merge logic in `lib/features/profile/presentation/pages/profile_page.dart` remains unchanged and profile data updates only after successful edit save

---

## Phase 5: User Story 3 - Responsive presentation across screen widths (Priority: P3)

**Goal**: Make the redesigned Profile page responsive across narrow phone widths and wider tablet widths.

**Independent Test**: Resize or preview the Profile page on narrow and wider screens and verify no overflow, clipping, or layout breakdown occurs.

- [ ] T020 [US3] Adjust `lib/features/profile/presentation/pages/profile_page.dart` padding and `SingleChildScrollView` behavior for responsive layout across screen widths
- [ ] T021 [US3] Review `lib/features/profile/presentation/widgets/profile_section_card.dart` and `lib/features/profile/presentation/widgets/profile_section_header.dart` to ensure card and heading styles scale cleanly on narrow and wider displays
- [ ] T022 [US3] Review `lib/features/profile/presentation/widgets/*.dart` and update any section-specific layouts that could overflow or shrink poorly on narrow screens

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Final consistency, visual polish, and validation across the redesigned profile experience.

- [ ] T023 [P] Review `lib/features/profile/presentation/widgets/` for consistent card radius, shadow, and typography across all profile sections
- [ ] T024 Review `lib/features/profile/presentation/pages/profile_page.dart` for final visual flow, section spacing, and consistent section hierarchy
- [ ] T025 Validate the redesigned Profile page visually on phone and tablet widths and confirm edit functionality, navigation, state handling, and profile content remain unchanged

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies, should complete first
- **Foundational (Phase 2)**: Depends on Setup completion; establishes shared styling foundations before section-level redesign
- **User Stories (Phase 3+)**: Depend on Foundational phase completion; can proceed once foundational visual styles are established
- **Polish (Final Phase)**: Depends on all user stories being implemented and reviewed

### User Story Dependencies

- **User Story 1 (P1)**: Must complete after Foundational phase; delivers the premium profile layout and all redesigned sections
- **User Story 2 (P2)**: Can be validated after the redesigned layout is in place and should confirm behavior preservation
- **User Story 3 (P3)**: Can be executed in parallel with P2 after Foundational phase, focusing on responsive results

### Parallel Opportunities

- `T003`, `T004`, and `T005` can run in parallel because they modify independent foundational widget files
- `T007` through `T016` can run in parallel where each task updates separate section widget files
- `T023` can run in parallel with `T024` as both are review and polish tasks across different files

### Parallel Example

- Work on premium card styling in `lib/features/profile/presentation/widgets/profile_section_card.dart` while another developer updates header layout in `lib/features/profile/presentation/widgets/profile_identity_card.dart`
- Work on summary and contact card styling in parallel using `lib/features/profile/presentation/widgets/profile_summary_section.dart` and `profile_contact_section.dart`

---

## Implementation Strategy

### MVP First

1. Complete Setup tasks to document the current implementation
2. Complete Foundational tasks to establish premium styling foundations
3. Complete User Story 1 section redesign tasks and verify the new layout
4. Validate User Story 1 independently before moving to User Story 2 or User Story 3

### Incremental Delivery

1. Finish Setup + Foundational phases
2. Deliver redesigned premium profile layout as the MVP (User Story 1)
3. Verify behavior preservation with User Story 2
4. Confirm responsiveness with User Story 3

---

## Summary

- Total task count: 25
- Task count per user story:
  - US1: 11
  - US2: 3
  - US3: 3
- Parallel opportunities identified: foundational widget updates and separate section widget redesigns
- Independent test criteria:
  - US1: verify premium layout and all profile sections render distinctly
  - US2: verify edit navigation and state behavior remain unchanged
  - US3: verify responsive behavior across phone and tablet sizes
- Suggested MVP scope: complete User Story 1 first to deliver the premium Profile page redesign while preserving existing behavior

---

## Format Validation

- All tasks use the checklist format `- [ ] T### [P?] [Story?] Description with file path`
- Setup and foundational tasks omit story labels
- User story tasks include `[US1]`, `[US2]`, or `[US3]` as required
- Exact file paths are used for each implementation task where applicable
