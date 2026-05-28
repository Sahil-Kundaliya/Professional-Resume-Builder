# Implementation Plan: Skill Rating Support

**Branch**: `[015-skill-rating-support]` | **Date**: 2026-05-28 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/015-skill-rating-support/spec.md`

## Summary

Upgrade the Skills section in `ResumeFormPage` so skill entries carry an explicit 1-5 expertise rating, render that rating with stars, and reuse the established skill editing pattern already present in `EditProfilePage` without changing unrelated resume form sections.

## Technical Context

**Language/Version**: Dart `>=3.3.0 <4.0.0` with the current Flutter SDK

**Primary Dependencies**:
- `flutter_bloc` for resume form state updates
- `freezed_annotation` and generated models for skill data
- `google_fonts` for existing UI typography
- Existing resume/profile domain entities and presentation widgets

**Storage**: Existing in-memory form state and current resume/profile persistence flow; no new storage layer

**Testing**: `flutter_test` for widget and interaction regression coverage

**Target Platform**: Flutter mobile, desktop, and web targets already supported by the app

**Project Type**: Single Flutter application with feature-based organization

**Performance Goals**: Keep skill add/edit interactions immediate and maintain smooth scrolling in the resume form

**Constraints**:
- Limit scope to the Skills section and its shared skill UI
- Preserve all other `ResumeFormPage` sections and behavior
- Keep the 1-5 rating semantics consistent with the existing profile editing flow
- Avoid introducing a separate skill model that duplicates existing skill data

**Scale/Scope**:
- Primary page: `lib/features/resume/presentation/pages/resume_form_page.dart`
- Shared skill UI: reusable widgets under a shared presentation location, reused by both resume and profile flows
- Existing supporting entities: `lib/features/resume/domain/entities/resume_document.dart` and `lib/features/profile/domain/entities/resume_profile.dart`
- Focused tests under `test/features/resume/` and `test/features/profile/` as needed

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

✅ **Constitution Status**: PASS
- `.specify/memory/constitution.md` is still a placeholder template and does not define enforceable project-specific gates.

✅ **Architecture Boundary Gate**: PASS
- The feature stays inside the existing Flutter app and reuses current feature-based boundaries.

✅ **Scope Gate**: PASS
- The plan is limited to skill rating, skill display, and the add/edit skill flow.

✅ **Post-Design Re-check**: PASS
- Phase 1 artifacts define only internal UI and data-shape decisions; no external interface contracts are required.

## Project Structure

### Documentation (this feature)

```text
specs/015-skill-rating-support/
├── plan.md
├── research.md
├── data-model.md
└── quickstart.md
```

### Source Code (repository root)

```text
lib/
├── core/
│   └── widgets/
├── features/
│   ├── profile/
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       └── resume_profile.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── edit_profile_page.dart
│   │       └── widgets/
│   │           └── skill_bottom_sheet.dart
│   └── resume/
│       ├── domain/
│       │   └── entities/
│       │       └── resume_document.dart
│       └── presentation/
│           ├── pages/
│           │   └── resume_form_page.dart
│           └── widgets/
│               ├── resume_form_section_support.dart
│               └── resume_repeatable_text_section.dart

test/
├── features/
│   ├── profile/
│   └── resume/
└── widget_test.dart
```

**Structure Decision**: Keep the feature in the current single Flutter application structure and introduce reusable skill UI at a shared presentation boundary so both `EditProfilePage` and `ResumeFormPage` consume the same skill-rating experience.

## Complexity Tracking

No constitution violations or complexity waivers are required.

## Implementation Roadmap

### Phase 0: Research Complete
- Confirmed the resume form currently uses a text-only repeatable section for skills.
- Confirmed the profile editing flow already models skills as name plus 1-5 rating.
- Selected a shared reusable skill editor/display pattern to keep both pages consistent.
- Chosen to keep the change isolated to skills rather than widening the form redesign.

### Phase 1: Design Complete
- Documented the skill entry shape, validation rules, and display semantics.
- Defined the shared skill UI behavior that should be reused by both pages.
- Captured quickstart validation scenarios for add, edit, and display flows.
- Updated the agent context reference in `.github/copilot-instructions.md` to this feature plan.

### Phase 2: Implementation Planning Boundary
- `/speckit-tasks` should break work into:
  1. Extract or introduce a reusable skill editor and display widget for 1-5 ratings
  2. Wire `ResumeFormPage` to the shared skill UI instead of the text-only repeatable section
  3. Keep the existing `EditProfilePage` skill flow aligned with the shared component
  4. Preserve the current resume form sections outside Skills
  5. Add focused widget and regression coverage for rating persistence and display
