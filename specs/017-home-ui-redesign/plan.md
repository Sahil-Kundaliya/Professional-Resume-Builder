# Implementation Plan: Improve Home Page UI Design

**Branch**: `017-home-ui-redesign` | **Date**: 2026-06-16 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/017-home-ui-redesign/spec.md`

## Summary

Redesign the Home page template list UI with modern design principles while preserving all existing functionality. The redesign focuses on improving visual hierarchy, spacing, card styling, shadows, border radius, and typography. The favorite icon will be overlaid on the template thumbnail using an enhanced Stack layout pattern, matching the reference design. This is a pure UI redesign with no changes to business logic, state management, or architecture.

## Technical Context

**Language/Version**: Dart (Flutter) - Target SDK: Flutter 3.10+

**Primary Dependencies**: 
- flutter_bloc (state management)
- flutter (UI framework)

**Storage**: N/A (UI redesign only)

**Testing**: Flutter widget tests (existing test framework)

**Target Platform**: Mobile (iOS 12+, Android 6+)

**Project Type**: Mobile application (Flutter)

**Architecture**: Clean Architecture with BLoC pattern
- **Presentation Layer**: Pages, Widgets, BLoC
- **Domain Layer**: Entities, Repositories (interfaces)
- **Data Layer**: Repositories, Data sources

**Current Structure**:
- Home feature: `lib/features/home/`
  - presentation/pages/home_page_view.dart
  - presentation/widgets/template_grid.dart
  - presentation/widgets/template_thumbnail.dart
  - domain/entities/resume_template.dart
  - presentation/bloc/ (HomeBloc, HomeState, HomeEvent)

**Performance Goals**: Smooth 60fps rendering, responsive layout across all device sizes

**Constraints**: 
- Design-only changes (no business logic modifications)
- Must preserve all existing functionality
- Must maintain BLoC state management
- No changes to navigation, data flow, or filtering

**Scale/Scope**: Single-page redesign (Home page template list), affecting ~200 lines of UI code across 3 widgets

## Constitution Check

**Current Status**: No constitution file exists for this project (using template placeholders). 

**Design Principles Applied**:
- Clean code: Single responsibility for each widget
- Testability: Preserved all callback contracts for testing
- Maintainability: Improved spacing and styling with consistent constants
- User-focused: Enhanced visual hierarchy and modern aesthetics

**Gates Passed**:
✓ Architecture remains unchanged
✓ All business logic preserved
✓ State management unchanged
✓ No breaking API changes to widgets
✓ Backward compatible with existing BLoC events

## Design Approach

### Phase 0: Research (Completed)

**Research Focus**: Flutter design patterns and best practices for modern card-based layouts

**Findings**:

1. **Decision**: Use `Stack` widget with `Positioned` for favorite icon overlay
   - **Rationale**: Already implemented in current design; provides clean separation of icon from card content
   - **Alternatives**: FloatingActionButton (too heavy), Overlay widget (too complex)

2. **Decision**: Implement responsive grid using `GridView.builder` with adaptive column count
   - **Rationale**: Flutter's built-in responsive capabilities; matches spec requirement
   - **Alternatives**: `CustomMultiChildLayout` (more complex), `Column/Row` nesting (less flexible)

3. **Decision**: Apply modern shadow design with Material 3 elevation patterns
   - **Rationale**: Flutter 3.10+ supports Material 3 shadows; provides depth without harshness
   - **Alternatives**: Custom shadow containers (verbose), no shadows (flat design - rejected)

4. **Decision**: Use border radius of 12-16px for cards
   - **Rationale**: Modern design standard; balances professional appearance with accessibility
   - **Alternatives**: 8px (too sharp), 20px+ (too rounded)

5. **Decision**: Implement consistent spacing scale (8, 12, 16, 24px)
   - **Rationale**: Industry standard; maintains visual harmony across components
   - **Alternatives**: Variable spacing (creates visual chaos)

### Phase 1: Design Artifacts

**Design Specification**:

#### 1. TemplateThumbnail Card Design

**Card Structure**:
```
Card (elevated with modern shadow)
├── Container (gradient background with template accent color)
│   └── Stack
│       ├── Center: Column (template preview + name)
│       └── Positioned: Favorite Icon Overlay (top-right)
```

**Styling Details**:
- **Card Elevation**: 4dp (increased from 2dp for more depth)
- **Border Radius**: 16px (increased from 12px for modern feel)
- **Shadows**: Material 3 shadow pattern
  - `blurRadius: 8`, `spreadRadius: 0`, `offset: Offset(0, 4)`, `opacity: 0.12`
  - Secondary: `blurRadius: 4`, `spreadRadius: 0`, `offset: Offset(0, 2)`, `opacity: 0.08`
- **Background**: Gradient using template accent color (maintained)
- **Padding**: 24px (improved from implicit spacing)

**Favorite Icon Overlay**:
- **Position**: Top-right corner (top: 12px, right: 12px)
- **Container**: 40x40px with background color
- **Icon**: 24px heart icon
- **Shadow**: Subtle drop shadow (blurRadius: 4)
- **Styling**: 
  - Background: Semi-transparent white or accent color with opacity
  - Border radius: 12px
  - Tap area: 48x48px (for accessibility)

#### 2. TemplateGrid Layout

**Grid Configuration**:
```
GridView.builder:
- Mobile (<600px): 2 columns
- Tablet (600-900px): 3 columns  
- Desktop (>900px): 4 columns
- Padding: 24px
- Cross-axis spacing: 16px
- Main-axis spacing: 20px
- Child aspect ratio: 0.8
```

**Responsive Behavior**:
- Uses `LayoutBuilder` to detect screen width
- Adaptive column count via `MediaQuery`
- Maintains consistent spacing ratio

#### 3. Typography Hierarchy

**Template Name**:
- **Style**: Bold, 16-18px
- **Color**: Template accent color
- **Alignment**: Center
- **Overflow**: Text wrapping with max 2 lines

**Supporting Text** (if added):
- **Style**: Regular, 12px
- **Color**: Secondary text color
- **Alignment**: Center

#### 4. Spacing Scale

```
xs: 4px
sm: 8px
md: 12px
lg: 16px
xl: 24px
xxl: 32px
```

**Applied to**:
- Card padding: xl (24px)
- Grid spacing: lg/xl (16px cross, 20px main)
- Icon padding: sm (8px)
- Favorite icon position: md (12px from edges)

#### 5. Color and Visual Hierarchy

**Template Card**:
- **Background**: Gradient (accent color at 0.1 to 0.05 opacity)
- **Text**: Accent color (for template name), maintains contrast
- **Icon**: Accent color for consistency

**Favorite Icon Styling**:
- **Active**: Filled heart, accent color
- **Inactive**: Outline heart, secondary color
- **Background**: Semi-transparent white (for contrast on any background)

---

## Project Structure

### Documentation (this feature)

```text
specs/017-home-ui-redesign/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 research findings
├── data-model.md        # Phase 1 data model (N/A - UI only)
├── quickstart.md        # Phase 1 implementation guide
├── contracts/           # UI contracts (N/A - internal only)
└── checklists/
    └── requirements.md  # Quality validation checklist
```

### Source Code Structure (Flutter App)

```text
lib/features/home/
├── presentation/
│   ├── pages/
│   │   └── home_page_view.dart          # Main home page [ENHANCED]
│   ├── widgets/
│   │   ├── template_grid.dart           # Grid layout [ENHANCED]
│   │   └── template_thumbnail.dart      # Card design [ENHANCED]
│   └── bloc/
│       ├── home_bloc.dart               # [UNCHANGED]
│       ├── home_event.dart              # [UNCHANGED]
│       └── home_state.dart              # [UNCHANGED]
├── domain/
│   ├── entities/
│   │   └── resume_template.dart         # [UNCHANGED]
│   └── repositories/
│       └── template_repository.dart     # [UNCHANGED]
└── data/
    └── [repository implementations]     # [UNCHANGED]
```

## Implementation Tasks Summary

**Files to Modify**:
1. `template_thumbnail.dart` - Enhance card design, improve shadows, border radius, spacing
2. `template_grid.dart` - Add responsive column count based on screen width
3. `home_page_view.dart` - Optional: Enhance AppBar styling for visual consistency

**Task Categories**:
- **UI Design**: Card styling, shadows, border radius (30% complexity)
- **Layout**: Responsive grid columns (20% complexity)
- **Typography**: Text hierarchy improvements (10% complexity)
- **Icon Styling**: Favorite overlay enhancement (20% complexity)
- **Testing & Validation**: Widget tests for new styles (20% complexity)

**No Changes Required**:
- BLoC state management
- Navigation logic
- Event handling
- Data flow
- Business logic
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
