# Implementation Plan: Improve Resume Form Modern UX

**Branch**: `[013-improve-resume-form-ux]` | **Date**: 2026-05-28 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/013-improve-resume-form-ux/spec.md`

## Summary

Modernize ResumeFormPage into a premium sectioned form experience with template-aware visual accents, improved dynamic section interactions, inline profile image preview, and persisted 1-5 star skill ratings while preserving existing feature architecture and behavior.

## Technical Context

**Language/Version**: Dart `>=3.3.0 <4.0.0` with current Flutter SDK

**Primary Dependencies**:
- `flutter_bloc` for resume form state and interaction flows
- `google_fonts` for typography and hierarchy consistency
- `image_picker` for profile image selection
- Existing resume feature presentation widgets and bottom-sheet editors

**Storage**: Existing resume data persistence paths via current resume repository flow (no new storage system)

**Testing**: `flutter_test` for widget and resume feature regression tests

**Target Platform**: Flutter multi-platform app with mobile-first form interaction requirements

**Project Type**: Single Flutter application with feature-based architecture

**Performance Goals**:
- Maintain responsive form interactions during add/edit/remove actions
- Keep focus-state and section rendering updates immediate on user input
- Preserve smooth scrolling and interaction in long forms with many dynamic entries

**Constraints**:
- Preserve existing architecture boundaries and state-management approach
- Scope changes to ResumeFormPage and supporting reusable resume form widgets/models
- Maintain existing functionality and backward compatibility of existing resume data
- Keep visual states accessible (readable contrast and clear focus indication)

**Scale/Scope**:
- 1 primary page modernization: `lib/features/resume/presentation/pages/resume_form_page.dart`
- Supporting widget improvements under `lib/features/resume/presentation/widgets/`
- Skill model/edit flow expansion for 1-5 ratings
- Inline profile image preview behavior update
- Focused tests under `test/features/resume/`

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

✅ **Constitution Status**: PASS
- `.specify/memory/constitution.md` is still an unratified placeholder template with no enforceable gates.

✅ **Architecture Preservation Gate**: PASS
- Plan keeps all implementation work inside existing resume feature boundaries.

✅ **Scope Gate**: PASS
- Scope is restricted to form UI/UX modernization, styling alignment, image preview, and skill rating behavior.

✅ **Post-Design Re-check**: PASS
- Phase 1 artifacts define internal behavioral contracts only and do not introduce cross-feature coupling.

## Project Structure

### Documentation (this feature)

```text
specs/013-improve-resume-form-ux/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── resume-form-ui-contract.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/
├── app.dart
├── core/
└── features/
    ├── home/
    ├── profile/
    └── resume/
        ├── data/
        ├── domain/
        ├── presentation/
        │   ├── bloc/
        │   ├── constants/
        │   ├── pages/
        │   │   ├── resume_form_page.dart
        │   │   ├── resume_editor_page.dart
        │   │   ├── pdf_preview_page.dart
        │   │   └── template_preview_page.dart
        │   ├── provider/
        │   └── widgets/
        │       ├── resume_basic_info_section.dart
        │       ├── resume_work_experience_section.dart
        │       ├── resume_education_section.dart
        │       ├── resume_awards_certifications_section.dart
        │       ├── resume_repeatable_text_section.dart
        │       ├── resume_form_section_support.dart
        │       ├── resume_form_validators.dart
        │       ├── resume_form_feedback.dart
        │       └── resume_dynamic_record_tile.dart
        └── resume_injection.dart

test/
├── widget_test.dart
└── features/
    └── resume/
```

**Structure Decision**: Continue with the existing single-project Flutter architecture and implement reusable UI and interaction improvements entirely within the existing resume feature module.

## Complexity Tracking

No constitution violations or complexity waivers are required.

## Implementation Roadmap

### Phase 0: Research Complete
- Selected sectioned card/container form composition over plain field lists.
- Chosen template-aware accent propagation for interactive and structural form elements.
- Defined consistent dynamic section interaction patterns and image preview behavior.
- Defined skill rating as persisted 1-5 star attribute in skill editing flow.

### Phase 1: Design Complete
- Established updated data entities for template style accents, form sections, profile image preview state, and skill rating.
- Defined internal UI behavior contract for section rendering, styling, dynamic interactions, image preview, and star rating.
- Defined quickstart verification scenarios covering UX, styling, interaction consistency, and regression safety.
- Updated agent context reference in `.github/copilot-instructions.md` to this feature plan.

### Phase 2: Implementation Planning Boundary
- `/speckit-tasks` should decompose work into:
  1. ResumeFormPage structural redesign with reusable section containers
  2. Template-based accent propagation across form UI states and actions
  3. Dynamic section interaction consistency improvements (add/edit/remove)
  4. Profile image inline preview and fallback display behavior
  5. Skill rating model and 1-5 star editing interaction support
  6. Regression and acceptance test coverage for updated form experience
