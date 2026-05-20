<!--
Sync Impact Report
Version change: template -> 1.0.0
Modified principles:
- Template Principle 1 -> I. Production-Grade Flutter Only
- Template Principle 2 -> II. Clean Architecture and Feature-First Boundaries
- Template Principle 3 -> III. Mandatory Toolchain and Code Generation
- Template Principle 4 -> IV. Bloc-Driven Presentation and Navigation Discipline
- Template Principle 5 -> V. Performance, Readability, and Maintainability Gates
Added sections:
- Architecture and Folder Standards
- Delivery Workflow and Quality Gates
Removed sections:
- None
Templates requiring updates:
- ✅ .specify/templates/plan-template.md
- ✅ .specify/templates/spec-template.md
- ✅ .specify/templates/tasks-template.md
- ✅ README.md
- ✅ specs/001-bloc-state-management/plan.md
Follow-up TODOs:
- None
-->

# flutter_skill Constitution

## Core Principles

### I. Production-Grade Flutter Only
Every change MUST produce production-grade Flutter code that is safe to ship,
maintainable under team ownership, and readable without tribal knowledge.
Experimental shortcuts, tutorial-grade scaffolding, placeholder implementations,
or architecture that only works for a demo are prohibited. All code MUST use
meaningful names, snake_case file names, documentation comments that explain
what the code does and why it exists, and classes sized for reviewability. No
class may exceed 300 lines; larger responsibilities MUST be split into smaller
components. Rationale: production quality is the baseline, not an aspirational
cleanup step.

### II. Clean Architecture and Feature-First Boundaries
The application MUST follow clean architecture with a feature-first layout.
Each feature MUST separate data, domain, and presentation concerns. Business
logic MUST live only in blocs or cubits, use cases, repositories, or data
sources as appropriate; it MUST NOT live in widgets, pages, route builders, or
UI helper functions. Data transfer models MUST be mapped into domain entities
before crossing into the domain layer. Repositories MUST be defined in the
domain layer and implemented in the data layer, backed by explicit data source
abstractions. Rationale: strict dependency direction keeps the codebase scalable,
testable, and resilient to change.

### III. Mandatory Toolchain and Code Generation
The approved stack is mandatory: flutter_bloc for state management, injectable
plus get_it for dependency injection, build_runner for code generation, freezed
plus json_serializable for models, entities, bloc states, and bloc events, dio
for networking, auto_route for navigation, and flutter_gen for generated asset
and font access. Developers MUST add dependencies via `flutter pub add`
commands. Developers MUST NOT manually create model classes when Freezed output
is required, and MUST NOT manually edit generated files. All generated artifacts
MUST be reproducible from source annotations and builder configuration.
Rationale: a single enforced toolchain avoids inconsistent patterns and broken
generation workflows.

### IV. Bloc-Driven Presentation and Navigation Discipline
Presentation code MUST be thin. Screens and widgets may render state and forward
user intent, but MUST NOT perform business decisions, data mapping, or side
effect orchestration. Bloc architecture MUST be production-grade: states and
events MUST be Freezed types, side effects MUST be explicit, and navigation MUST
use auto_route exclusively. Direct calls to `Navigator.push`, `Navigator.of`, or
equivalent imperative routing APIs are prohibited unless routed through
auto_route internals. Widget helper functions inside pages are prohibited;
reusable or isolated view fragments MUST be extracted into small private
StatelessWidget classes or dedicated widget files. Rationale: predictable UI
composition and state flow reduce regressions and simplify testing.

### V. Performance, Readability, and Maintainability Gates
Performance and maintainability are release gates. Code MUST optimize rebuilds
using BlocSelector, buildWhen, listenWhen, and const widgets where applicable.
Features handling lists or remote queries MUST evaluate lazy loading,
pagination, debouncing, and caching of expensive work. Deep widget trees and
overly broad rebuild scopes are prohibited when a smaller composition is
available. Hardcoded colors, strings, dimensions, and asset paths are
prohibited; themes, constants, colors, typography, spacing, and generated asset
references MUST be centralized and MUST support light and dark themes.
Rationale: predictable performance and centralized design tokens keep the app
fast and coherent as the project grows.

## Architecture and Folder Standards

The repository MUST converge on the following Flutter structure for all
production work:

```text
lib/
├── core/
│   ├── constants/
│   ├── network/
│   ├── error/
│   ├── services/
│   ├── utils/
│   ├── widgets/
│   └── theme/
├── config/
│   ├── routes/
│   ├── env/
│   └── di/
├── features/
│   └── feature_name/
│       ├── data/
│       │   ├── datasource/
│       │   ├── models/
│       │   ├── repository/
│       │   └── mapper/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repository/
│       │   └── usecases/
│       ├── presentation/
│       │   ├── pages/
│       │   ├── widgets/
│       │   ├── bloc/
│       │   ├── provider/
│       │   └── controller/
│       └── feature_injection.dart
├── app.dart
└── main.dart
```

Additional architectural rules are non-negotiable:

- Domain code MUST remain framework-light and MUST NOT depend on Flutter UI,
	Dio DTOs, or generated route classes.
- Data sources MUST be the only layer that talks directly to remote or local
	persistence APIs.
- Repository implementations MUST translate failures into domain-safe error
	models before returning to use cases or blocs.
- UI state, bloc events, bloc states, entities, and DTO models MUST use Freezed.
- Asset paths and fonts MUST be accessed through flutter_gen output instead of
	raw string literals.
- Dependency registration MUST be centralized under `config/di/` and feature
	injection entry points.

## Delivery Workflow and Quality Gates

Every plan, task list, and implementation review MUST enforce these gates:

- Architecture reviews MUST reject features that bypass the data, domain, and
	presentation split.
- New work MUST declare the feature path, DI wiring, generated files required,
	and the commands needed to regenerate code.
- Before merge, developers MUST run code generation when annotations change and
	MUST verify that no generated file was hand-edited.
- Tests MUST cover business logic and UI behavior at the smallest practical
	level. At minimum, bloc or cubit behavior and the primary widget flow MUST be
	validated for feature work that changes behavior.
- Reviews MUST check rebuild scope, const usage, selector usage, and avoidance
	of page-level helper builders for performance-sensitive UI.
- Any exception to the approved stack or folder structure MUST be documented in
	the feature plan's Complexity Tracking section and approved before
	implementation.

## Governance

This constitution supersedes local habits, starter-template defaults, and ad hoc
preferences. Every specification, plan, task list, and code review MUST include
an explicit constitution compliance check. Amendments require: (1) the proposed
rule change and rationale, (2) updates to dependent templates or guidance files,
and (3) a semantic version decision recorded in this document. Versioning policy
is strict: MAJOR for incompatible governance changes or removed principles,
MINOR for new principles or materially stronger requirements, and PATCH for
clarifications that do not alter enforcement. Compliance reviews MUST treat any
unapproved deviation as a blocker until corrected or formally exempted in the
active plan.

**Version**: 1.0.0 | **Ratified**: 2026-05-09 | **Last Amended**: 2026-05-09
