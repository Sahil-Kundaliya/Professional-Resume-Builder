# Implementation Plan: Modern Resume Form and Template-Aware Preview

**Branch**: `011-run-pre-spec-hook` | **Date**: 2026-05-27 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/011-modern-resume-form-flow/spec.md`

**Note**: This plan modernizes the resume form and preview flow while preserving the existing resume generation architecture, renderer, repositories, and feature boundaries.

## Summary

Deliver a production-grade redesign of `ResumeFormPage` and related bottom sheets, introduce template-owned visible/required field rules, block preview until required fields are valid, hide empty optional modules in preview, and improve preview inspection with zoom controls. The technical approach preserves `ResumeDocument` as the canonical render payload, keeps template rendering and PDF generation intact, and focuses changes inside the resume presentation/domain seams.

## Technical Context

**Language/Version**: Dart `>=3.3.0 <4.0.0` with current Flutter SDK

**Primary Dependencies**:
- `flutter_bloc` for resume form and preview eligibility state
- `get_it` for feature DI registration
- `freezed`/`freezed_annotation` for immutable state and entities
- `google_fonts` for visual hierarchy and typography consistency
- `image_picker` for profile image field handling
- `printing` and `pdf` for preview/generation continuity

**Storage**: Existing local resume persistence via `IResumeRepository` and current local data source

**Testing**: `flutter_test` for widget/bloc coverage plus focused integration-style route/form/preview assertions in feature tests

**Target Platform**: Flutter app targeting Android, iOS, web, macOS, Linux, and Windows (mobile-first interaction expectations)

**Project Type**: Single Flutter application with feature-based architecture under `lib/features/`

**Performance Goals**:
- Resume form interactions remain responsive during typing and dynamic section edits
- Preview opens on first attempt after passing validation
- Zoom interactions update document scale without visible stutter in normal testing conditions

**Constraints**:
- Preserve existing resume generation architecture and template rendering pipeline
- Keep redesign scoped to resume form and preview flow only
- Introduce scalable and reusable UI patterns for section and bottom-sheet composition
- Enforce template-specific requiredness before preview navigation
- Avoid unnecessary cross-feature redesign and maintain current domain boundaries

**Scale/Scope**:
- 1 major form page redesign (`resume_form_page.dart`)
- 2 structured record bottom-sheet improvements (work experience, education)
- N dynamic text/list section behavior updates shared across optional modules
- 1 template field-rule configuration path (enabled/hidden/required)
- 1 validation gate for preview eligibility
- 1 preview UX enhancement set (prominent action, template-aligned styling, zoom in/out, empty-section omission)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

✅ **Constitution Status**: PASS
- `.specify/memory/constitution.md` is currently a placeholder template with no ratified enforceable principles. No explicit constitutional gates are active beyond repository standards.

✅ **Architecture Preservation Gate**: PASS
- Plan keeps existing `resume` data/domain rendering architecture and avoids introducing parallel resume-generation stacks.

✅ **Scope Isolation Gate**: PASS
- All required work is constrained to resume form and preview flow with no broad app redesign.

✅ **Post-Design Re-check**: PASS
- Phase 1 artifacts define reusable components and validation contracts while retaining existing template rendering and repository seams.

## Project Structure

### Documentation (this feature)

```text
specs/011-modern-resume-form-flow/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── resume-form-preview-contract.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/
├── app.dart
├── config/
│   └── di/
│       └── injection_container.dart
├── core/
│   └── constants/
│       └── app_routes.dart
└── features/
    ├── profile/
    │   └── presentation/
    │       └── widgets/
    │           ├── education_bottom_sheet.dart
    │           └── experience_bottom_sheet.dart
    └── resume/
        ├── data/
        │   ├── datasources/
        │   ├── mappers/
        │   ├── models/
        │   └── repositories/
        ├── domain/
        │   ├── entities/
        │   ├── repositories/
        │   └── services/
        └── presentation/
            ├── bloc/
            ├── constants/
            ├── pages/
            │   ├── resume_form_page.dart
            │   ├── template_preview_page.dart
            │   └── pdf_preview_page.dart
            └── widgets/
                ├── resume_basic_info_section.dart
                ├── resume_work_experience_bottom_sheet.dart
                ├── resume_education_bottom_sheet.dart
                ├── resume_repeatable_text_section.dart
                ├── resume_dynamic_record_tile.dart
                ├── resume_form_validators.dart
                ├── resume_form_section_support.dart
                └── resume_form_mappers.dart

test/
└── features/
    └── resume/
```

**Structure Decision**: Keep the existing single-project Flutter architecture and implement modernization within `lib/features/resume/presentation/` with minimal supporting updates in resume domain/model seams for template field configuration and validation behavior.

## Complexity Tracking

No active constitution violations or exceptional complexity justifications are required.

## Implementation Roadmap

### Phase 0: Research Complete
- Confirmed best approach is to preserve `ResumeDocument` as canonical render payload while introducing template-specific field rule metadata.
- Confirmed reusable bottom-sheet and dynamic-list patterns should be standardized in resume feature widgets rather than rebuilding ad hoc interactions.
- Confirmed preview should become validation-gated and template-aware without replacing existing renderer/generation infrastructure.

### Phase 1: Design Complete
- Defined data entities and validation state for template-enabled/hidden/required fields, form sections, and preview eligibility.
- Defined behavioral contract for section rendering omission when optional modules are empty.
- Defined preview interaction contract for template-aligned action styling plus zoom controls.
- Updated agent context marker to this plan path for downstream `/speckit-tasks` execution.

### Phase 2: Implementation Planning Boundary
- `/speckit-tasks` should decompose work into: form page redesign, reusable bottom-sheet modernization, template field rule integration, validation gate + feedback flow, preview button redesign, conditional section rendering, zoom controls, and focused regression tests.
