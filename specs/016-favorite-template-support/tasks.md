# Tasks: Favorite Template Support

**Input**: Design documents from `/specs/016-favorite-template-support/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: No explicit TDD or automated-test requirement was specified in the feature spec, so this plan focuses on implementation and manual validation tasks.

**Organization**: Tasks are grouped by user story so each story can be implemented and validated independently.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare persistence prerequisites and confirm current UI-only favorite behavior before feature changes.

- [X] T001 Review current UI-only favorite behavior in `lib/features/home/presentation/widgets/template_thumbnail.dart` and `lib/features/resume/presentation/pages/template_preview_page.dart`
- [X] T002 Add local persistence package for favorite IDs in `pubspec.yaml`
- [X] T003 [P] Add storage key constants for favorite template persistence in `lib/core/constants/storage_keys.dart`
- [X] T004 [P] Add reusable favorite store contract in `lib/features/home/data/datasources/favorite_templates_store.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Build reusable persistence and synchronization infrastructure required by all user stories.

**⚠️ CRITICAL**: No user story implementation should start before this phase is complete.

- [X] T005 Implement local favorite ID persistence store in `lib/features/home/data/datasources/favorite_templates_store_impl.dart`
- [X] T006 Update datasource contract for persisted favorite loading/saving in `lib/features/home/data/datasources/template_local_datasource.dart`
- [X] T007 Implement favorite hydration and persisted toggle mutation in `lib/features/home/data/datasources/template_local_datasource_impl.dart`
- [X] T008 Update repository interfaces for reusable favorite synchronization operations in `lib/features/home/domain/repositories/template_repository.dart` and `lib/features/home/data/repositories/template_repository_impl.dart`
- [X] T009 Wire favorite store and updated datasource dependencies in `lib/features/home/home_injection.dart` and `lib/features/home/presentation/pages/home_page.dart`
- [X] T010 Add fallback handling for corrupted or stale persisted favorite IDs in `lib/features/home/data/datasources/template_local_datasource_impl.dart`

**Checkpoint**: Persistence and shared favorite infrastructure are ready for story delivery.

---

## Phase 3: User Story 1 - Keep Favorite Templates Persisted (Priority: P1) 🎯 MVP

**Goal**: Favorite templates remain marked after app restarts and initial app load.

**Independent Test**: Favorite templates, restart the app, and confirm Home + preview show the same persisted favorites.

- [X] T011 [US1] Load persisted favorite IDs during initial template loading in `lib/features/home/presentation/bloc/home_bloc.dart`
- [X] T012 [US1] Ensure merged favorite state is propagated through template mapping in `lib/features/home/data/mappers/template_mapper.dart`
- [X] T013 [US1] Resolve initial template favorite state from persisted source in `lib/features/resume/presentation/pages/template_preview_page.dart`
- [X] T014 [US1] Keep Home startup behavior stable when no favorites are stored in `lib/features/home/presentation/bloc/home_bloc.dart`

**Checkpoint**: User Story 1 is independently functional and validates persistence at startup.

---

## Phase 4: User Story 2 - Toggle Favorites From Template Surfaces (Priority: P2)

**Goal**: Users can favorite/unfavorite from thumbnails and preview with immediate UI updates and persisted state.

**Independent Test**: Toggle favorites from both Home thumbnails and preview page, then verify synchronized state after returning and after app restart.

- [X] T015 [US2] Add reusable toggle flow that returns updated favorite-aware templates in `lib/features/home/domain/usecases/toggle_favorite.dart`
- [X] T016 [US2] Apply immediate state updates for favorite toggle events in `lib/features/home/presentation/bloc/home_bloc.dart`
- [X] T017 [P] [US2] Keep thumbnail favorite tap wired to shared toggle behavior in `lib/features/home/presentation/widgets/template_thumbnail.dart` and `lib/features/home/presentation/widgets/template_grid.dart`
- [X] T018 [P] [US2] Replace preview local-only toggle with persisted shared toggle handling in `lib/features/resume/presentation/pages/template_preview_page.dart`
- [X] T019 [US2] Refresh/sync Home favorite state when returning from preview in `lib/features/home/presentation/pages/home_page_view.dart` and `lib/features/resume/presentation/pages/template_preview_page.dart`

**Checkpoint**: User Stories 1 and 2 work independently with synchronized favorite state.

---

## Phase 5: User Story 3 - Filter Templates by Favorites (Priority: P3)

**Goal**: Home page can switch between full catalog and Favorites Only view with correct empty-state handling.

**Independent Test**: Enable/disable Favorites Only and verify list + empty state behavior with and without favorited templates.

- [X] T020 [US3] Extend Home event model with favorites filter change event in `lib/features/home/presentation/bloc/home_event.dart`
- [X] T021 [US3] Extend Home loaded state with filter metadata and derived visible templates in `lib/features/home/presentation/bloc/home_state.dart`
- [X] T022 [US3] Implement Favorites Only filter behavior in `lib/features/home/presentation/bloc/home_bloc.dart`
- [X] T023 [US3] Add Favorites Only UI control and filtered rendering logic in `lib/features/home/presentation/pages/home_page_view.dart`
- [X] T024 [US3] Add explicit Favorites Only empty-result message in `lib/features/home/presentation/pages/home_page_view.dart`

**Checkpoint**: All three user stories are independently functional.

---

## Final Phase: Polish & Cross-Cutting Concerns

**Purpose**: Finalize generated artifacts and validate production readiness across the full flow.

- [X] T025 [P] Regenerate Freezed outputs after Home event/state changes in `lib/features/home/presentation/bloc/home_event.freezed.dart` and `lib/features/home/presentation/bloc/home_state.freezed.dart`
- [X] T026 Validate quickstart persistence/filter/sync scenarios and update verification notes in `specs/016-favorite-template-support/quickstart.md`
- [X] T027 Run targeted template-flow cleanup for maintainability in `lib/features/home/` and `lib/features/resume/presentation/pages/template_preview_page.dart`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: Starts immediately.
- **Phase 2 (Foundational)**: Depends on Phase 1 and blocks all user stories.
- **Phase 3 (US1)**: Starts after Phase 2 completion.
- **Phase 4 (US2)**: Starts after Phase 2 completion; depends on persisted state infrastructure from US1 outcomes.
- **Phase 5 (US3)**: Starts after Phase 2 completion; uses synced favorite state from prior stories.
- **Final Phase (Polish)**: Starts after desired user stories are complete.

### User Story Dependencies

- **US1 (P1)**: Depends only on foundational phase.
- **US2 (P2)**: Depends on foundational phase and should build on US1 persisted state behavior.
- **US3 (P3)**: Depends on foundational phase and consumes favorite state provided by US1/US2.

### Suggested Completion Order

- `Setup -> Foundational -> US1 -> US2 -> US3 -> Polish`

---

## Parallel Opportunities

- `T003` and `T004` can run in parallel during Setup.
- `T025` can run in parallel with other polish work after implementation stabilizes.

---

## Parallel Example: User Story 2

```bash
Task: "Keep thumbnail favorite tap wired to shared toggle behavior in lib/features/home/presentation/widgets/template_thumbnail.dart and lib/features/home/presentation/widgets/template_grid.dart"
Task: "Replace preview local-only toggle with persisted shared toggle handling in lib/features/resume/presentation/pages/template_preview_page.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 (Setup)
2. Complete Phase 2 (Foundational)
3. Complete Phase 3 (US1)
4. Validate app-restart persistence across Home and preview

### Incremental Delivery

1. Deliver US1 for startup persistence.
2. Deliver US2 for cross-surface toggle synchronization.
3. Deliver US3 for Favorites Only filtering.
4. Finish polish and validation pass.

### Parallel Team Strategy

1. One developer handles persistence infrastructure (`T005-T010`).
2. One developer handles Home presentation/filtering (`T020-T024`) after foundation.
3. One developer handles preview synchronization (`T018-T019`) after foundation.

---

## Notes

- Every task follows the required checklist format: checkbox, task ID, optional `[P]`, optional `[US#]`, and explicit file path.
- User-story tasks are isolated to keep each story independently testable.
- Scope is intentionally limited to favorite persistence, synchronization, and filter behavior.
