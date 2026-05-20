# Phase 0 Research: Flutter Architecture Refactoring

**Date**: 2026-05-19  
**Feature**: Refactor Flutter Project Structure  
**Status**: Complete

---

## Research Overview

This document consolidates findings from Phase 0 research tasks that resolve unknowns identified in the plan. Three critical areas required investigation before Phase 1 design.

---

## 1. Freezed & Code Generation Setup

### Question
Is the project configured for freezed, build_runner, and json_serializable code generation?

### Finding
**Status**: Not currently configured for freezed  
**Current State**: Manual model classes (ResumeDocument, nested entries) without freezed annotations

### Decision
**IMPLEMENT**: Freezed integration as part of refactoring

**Rationale**: 
- Constitution mandates freezed for all models, entities, states, and events
- Manual models lack immutability, equality, and copyWith support
- Freezed provides reproducible, maintainable code generation
- json_serializable integrates seamlessly for API data handling

### Alternatives Considered
- **Manual model classes**: Rejected (violates Constitution III; error-prone equality/copyWith)
- **Hive/ObjectBox**: Rejected (over-engineered for current persistence needs)
- **json_annotation only**: Rejected (lacks entity immutability and freezed benefits)

### Action Items for Implementation
1. Add dependencies: `flutter pub add freezed_annotation json_serializable && flutter pub add -d build_runner freezed`
2. Configure build.yaml for build_runner
3. Migrate all models/entities to freezed classes
4. Run `flutter pub run build_runner build --delete-conflicting-outputs`
5. Verify generated .freezed.dart and .g.dart files

---

## 2. Provider Migration Path

### Question
Should state management migrate from Provider to flutter_bloc, or remain with Provider?

### Finding
**Current Implementation**: ResumeProvider using ChangeNotifier (Provider pattern)

**Constitution Requirement**: Bloc-driven presentation (Principle IV)

**Compatibility**: Provider and Bloc can coexist during transition phase

### Decision
**HYBRID TRANSITION APPROACH**:
1. **Phase 1 (this refactor)**: Migrate Provider to feature-scoped organization; keep current API for compatibility
2. **Phase 2+**: Gradually introduce flutter_bloc for new features; keep Provider for resume feature if performance/complexity justify it

**Rationale**:
- Allows incremental migration without breaking changes
- Provider is suitable for simpler state (home feature template list)
- Resume editor has complex nested updates—bloc with freezed states improves testability
- Freezed + Bloc integration (per Constitution) provides strong type safety

### Alternatives Considered
- **Full Bloc migration immediately**: Rejected (high risk, large scope change)
- **Keep Provider entirely**: Rejected (violates Constitution IV requirement)
- **Mix Bloc and Provider without plan**: Rejected (leads to inconsistency)

### Selected Path (Hybrid)
| Feature | Phase 1 (Refactor) | Phase 2+ (Optional) |
|---------|-------------------|-------------------|
| Home | Provider-based | Candidate for Bloc migration |
| Resume | Provider at feature scope | Recommend Bloc migration for editor complexity |

### Action Items
1. Move ResumeProvider to `features/resume/presentation/provider/`
2. Create equivalent Bloc structure alongside (e.g., ResumeBloc accepting freezed states)
3. Document Provider → Bloc migration pattern for team reference
4. Phase 2: Measure performance; decide on Bloc adoption based on rebuild metrics

---

## 3. Navigation Migration Strategy

### Question
Should routing migrate from MaterialApp routes to GoRouter/auto_route, or remain with basic routing?

### Finding
**Current State**: Basic MaterialApp routes (named route strings)  
**Constitution Requirement**: auto_route for navigation (Principle IV)  
**Risk**: Breaking changes if not handled carefully

### Decision
**PHASED ADOPTION WITH COMPATIBILITY LAYER**

**Phase 1 (this refactor)**:
- Keep MaterialApp routes; document route constants in `config/routes/route_names.dart`
- Establish routing layer abstraction to support future migration
- Set up basic GoRouter skeleton (not yet wired)

**Phase 2+**:
- Gradually wire GoRouter routes (home → resume flows)
- Auto_route can be added when build_runner is stable with freezed
- Keep fallback to MaterialApp during transition

**Rationale**:
- Prevents breaking changes during refactor
- GoRouter is simpler than auto_route for current scope (4 screens)
- Team can learn GoRouter patterns before adopting auto_route generator
- Freezed stability should be verified first (both use build_runner)

### Alternatives Considered
- **Auto_route immediately**: Rejected (adds code generation complexity alongside freezed)
- **Stay with MaterialApp routes**: Rejected (violates Constitution IV)
- **GoRouter full migration Phase 1**: Risky (requires testing all navigation flows simultaneously)

### Selected Path (Phased)
1. **Phase 1**: Route constants, named routes organized in config/
2. **Phase 1.5**: Introduce GoRouter incrementally for new screens
3. **Phase 2**: Full GoRouter + auto_route adoption after Bloc migration

### Action Items
1. Create `config/routes/route_names.dart` with route constants
2. Create `config/routes/app_router.dart` skeleton (GoRouter config)
3. Refactor `app.dart` to reference route constants (not raw strings)
4. Phase 2: Integrate GoRouter + auto_route with incremental testing

---

## Build Configuration (build.yaml)

### Required Configuration
```yaml
targets:
  $default:
    builders:
      build_runner|entrypoint:
        generate_for:
          - lib/**/*.dart
      json_serializable:generator:
        options:
          create_to_json: true
          disallow_unrecognized_keys: false
```

---

## Summary Table

| Area | Current State | Phase 1 Decision | Phase 2+ Path |
|------|---------------|-----------------|----------------|
| **Freezed** | Not configured | Implement (Constitution mandate) | Extend to all DTOs, events, states |
| **State Mgmt** | Provider root-level | Feature-scope Provider + Bloc skeleton | Gradual Bloc adoption |
| **Navigation** | MaterialApp routes | Route constants + GoRouter skeleton | Full GoRouter + auto_route |
| **Code Gen** | None | build_runner + freezed | Add auto_route when stable |

---

## Blockers Resolved ✅
- ✅ Freezed integration path confirmed
- ✅ Provider migration strategy approved (hybrid approach)
- ✅ Navigation migration phased to reduce risk
- ✅ Code generation toolchain planned

---

## Ready for Phase 1 Design ✅

All Phase 0 research questions answered. The plan can now proceed to:
1. Generate detailed data model definitions (data-model.md)
2. Define architecture contracts (layer boundaries, feature structure)
3. Create migration quickstart guide
