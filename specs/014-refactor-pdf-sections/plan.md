# Implementation Plan: Refactor PDF Section Architecture

**Branch**: `[014-specify-feature-branch]` | **Date**: 2026-05-28 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/014-refactor-pdf-sections/spec.md`

## Summary

Refactor `lib/core/utils/pdf_generator.dart` from monolithic inline section rendering into reusable PDF section builders with centralized section visibility guards, deterministic section order, and preserved visual output so architecture improves without changing user-facing design.

## Technical Context

**Language/Version**: Dart `>=3.3.0 <4.0.0` with current Flutter SDK

**Primary Dependencies**:
- `pdf` for PDF widget composition and export
- `printing` for preview/print integration
- Existing resume domain entities (`ResumeDocument`, `ResumeTemplate`)

**Storage**: N/A (uses in-memory resume entity input for generation)

**Testing**: `flutter_test` with unit/integration-style PDF generation and regression assertions

**Target Platform**: Flutter multi-platform app (mobile/desktop/web) where PDF output is consumed by preview/export flows

**Project Type**: Single Flutter mobile-first application

**Performance Goals**:
- Preserve current PDF generation responsiveness for typical resume content
- Avoid additional perceptible delay when all sections are populated
- Keep output generation deterministic for stable regression checks

**Constraints**:
- Preserve existing layout, typography, spacing, and template appearance
- Keep changes isolated to PDF generation architecture and related helper files
- Ensure null/empty/whitespace section data is fully omitted from output
- Preserve section order for all rendered sections

**Scale/Scope**:
- Primary refactor target: `lib/core/utils/pdf_generator.dart`
- Introduce reusable section builders/helpers under `lib/core/utils/` (or adjacent PDF utility area)
- Cover section modularization for profile, summary, work experience, education, skills, references, awards, certifications, and hobbies
- Add/adjust focused tests in `test/features/resume/` and/or core utility test locations

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

✅ **Constitution Status**: PASS
- `.specify/memory/constitution.md` is still an unratified placeholder template with no enforceable governance gates.

✅ **Architecture Isolation Gate**: PASS
- Plan keeps refactor scoped to PDF generation module and avoids cross-feature architectural drift.

✅ **Behavior Preservation Gate**: PASS
- Requirements and artifacts enforce design fidelity and deterministic output ordering for populated sections.

✅ **Post-Design Re-check**: PASS
- Phase 1 artifacts define internal PDF rendering contracts only; no external API or persistence contracts introduced.

## Project Structure

### Documentation (this feature)

```text
specs/014-refactor-pdf-sections/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── pdf-section-rendering-contract.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/
├── core/
│   └── utils/
│       └── pdf_generator.dart
└── features/
    └── resume/
        ├── domain/
        │   └── entities/
        │       ├── resume_document.dart
        │       └── resume_template.dart
        └── presentation/
            └── pages/
                └── pdf_preview_page.dart

test/
└── features/
    └── resume/
        ├── fixtures/
        ├── helpers/
        ├── presentation/
        └── resume_form_flow_test.dart
```

**Structure Decision**: Continue within the existing single-project Flutter architecture. Implement reusable PDF section rendering components and guard helpers in the current core utility boundary without introducing a new feature module.

## Complexity Tracking

No constitution violations or complexity waivers are required.

## Implementation Roadmap

### Phase 0: Research Complete
- Selected reusable section-builder architecture with shared style/spacing helpers.
- Defined layered visibility-guard approach for null, empty-list, and whitespace-only data.
- Chosen deterministic section composition order independent of map iteration behavior.
- Defined regression strategy focused on behavior and structural consistency rather than pixel-perfect coupling.

### Phase 1: Design Complete
- Documented rendering entities, visibility rules, and section composition relationships.
- Defined internal PDF rendering contract covering section interfaces, ordering, and omission behavior.
- Authored quickstart validation scenarios for full-data, partial-data, and empty-section outputs.
- Updated agent context pointer to this feature plan for downstream commands.

### Phase 2: Implementation Planning Boundary
- `/speckit-tasks` should break work into:
  1. Introduce shared PDF section primitives (header, spacing, visibility helpers)
  2. Extract each section into reusable builders/components
  3. Replace inline composition with ordered orchestrator in `PdfGenerator.generate`
  4. Enforce conditional rendering guards for every section data type
  5. Add/update tests for omission behavior and rendering regressions
  6. Validate output parity for populated sections and no-render behavior for empty sections
