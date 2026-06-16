# Research: Home Page UI Design Patterns

**Feature**: Improve Home Page UI Design

**Date**: 2026-06-16

**Purpose**: Resolve technical uncertainties and identify best practices for modern Flutter UI design

## Research Topics

### 1. Modern Card Design Patterns in Flutter

**Decision**: Use elevated Cards with Material 3 shadow patterns combined with responsive grid layout

**Rationale**: 
- Flutter's Material Design 3 provides built-in elevation and shadow systems that are device-optimized
- Elevation values (4-8dp) provide appropriate depth without excessive visual weight
- Works consistently across all target platforms (iOS, Android)

**Alternatives Evaluated**:
- **Custom shadow containers**: Provides more control but increases code complexity
- **Glassmorphism/Neumorphism**: Trendy but harder to maintain cross-platform consistency
- **Flat design with borders**: Simpler but less modern appearance

**Best Practices**:
- Use `Card` widget with `elevation` property (simpler than manual shadow)
- Apply `Material()` wrapper for elevation on custom containers
- Combine with `BoxShadow` for fine-tuned control
- Test shadows on actual devices (shadows render differently on different hardware)

---

### 2. Responsive Grid Layouts in Flutter

**Decision**: Use `GridView.builder` with `LayoutBuilder` or `MediaQuery` for adaptive column count

**Rationale**:
- `GridView.builder` is Flutter's standard for grid layouts
- `SliverGridDelegateWithFixedCrossAxisCount` simplifies responsive behavior
- `LayoutBuilder` provides clean separation of layout logic from build method
- Avoids complex nested Row/Column logic

**Alternatives Evaluated**:
- **Masonry layouts**: More complex, not needed for uniform card sizes
- **SingleChildScrollView with Wrap**: Less optimized for large lists
- **Custom RenderBox**: Overkill for standard grid layouts

**Best Practices**:
- Use `LayoutBuilder` to detect available width
- Implement breakpoints: Mobile (<600px) = 2 cols, Tablet (600-900px) = 3 cols, Desktop (>900px) = 4 cols
- Maintain aspect ratio with `childAspectRatio` parameter
- Use `SizedBox` to create consistent spacing

---

### 3. Icon Overlay Positioning with Stack

**Decision**: Use `Stack` with `Positioned` widget for favorite icon overlay

**Rationale**:
- `Stack` is Flutter's standard for layering widgets
- `Positioned` provides pixel-perfect control over icon placement
- Already used in current implementation
- Allows icon to float above card content without affecting layout

**Alternatives Evaluated**:
- **Alignment properties**: Less flexible for fine positioning
- **Transform widget**: More complex for positioning
- **Custom painter**: Overkill for simple overlay

**Best Practices**:
- Position icon at fixed pixel offsets from edges (12-16px from top/right)
- Use larger touch target area (48x48px) than visual icon (24x24px) for accessibility
- Layer z-order: background → content → overlay
- Test on various screen sizes for consistent visual balance

---

### 4. Typography Hierarchy in Mobile UI

**Decision**: Use template accent color for template names with bold font weight (16-18px)

**Rationale**:
- Color creates visual hierarchy and brand identity
- Bold weight adds emphasis
- 16-18px is readable on mobile screens (minimum 14px accessibility standard)
- Centered alignment draws focus to template name

**Alternatives Evaluated**:
- **Primary color for all text**: Less visual interest, harder to distinguish
- **Larger text (20px+)**: Takes too much space on grid
- **Multiple text styles**: Adds complexity without clarity

**Best Practices**:
- Maintain consistent font size across all cards
- Use font weights: Regular (400) for body, Bold (700) for titles
- Ensure sufficient contrast ratio (WCAG AA minimum 4.5:1)
- Test with system font scaling enabled

---

### 5. Spacing and Padding Standards

**Decision**: Implement 8px-based spacing scale (8, 12, 16, 24, 32px)

**Rationale**:
- 8px base unit is industry standard (Material Design, Apple HIG)
- Multiples of 8 maintain visual harmony
- Easier to maintain consistency across designs
- Responsive spacing scales naturally with different device sizes

**Alternatives Evaluated**:
- **4px base unit**: Too granular, harder to maintain consistency
- **Variable spacing**: Leads to inconsistency and maintenance issues
- **No system**: Results in ad-hoc spacing that looks unprofessional

**Best Practices**:
- Define spacing constants in a separate constants file
- Use consistent padding for cards (24px inside)
- Use consistent gaps between cards (16px cross-axis, 20px main-axis)
- Apply same padding consistently across all similar elements

---

### 6. Shadow and Depth Implementation

**Decision**: Use Material 3 shadow system with two-layer shadow effect

**Rationale**:
- Material 3 shadows are optimized for modern design
- Two layers (primary shadow + secondary shadow) create sophisticated depth
- Provides appropriate visual hierarchy
- Consistent with Flutter/Material Design standards

**Alternatives Evaluated**:
- **Single shadow**: Flat appearance, less depth
- **Harsh shadows**: Distracting and less professional
- **No shadows**: Flat design, harder to distinguish card boundaries

**Best Practices**:
- Primary shadow: `blurRadius: 8, offset: Offset(0, 4), opacity: 0.12`
- Secondary shadow: `blurRadius: 4, offset: Offset(0, 2), opacity: 0.08`
- Test shadows at different brightness levels
- Ensure shadows don't distract from content

---

### 7. Border Radius and Modern Design

**Decision**: Use 16px border radius for cards (increased from 12px)

**Rationale**:
- 16px is modern standard for contemporary mobile apps
- Balances professional appearance with approachability
- Consistent with Material Design 3 recommendations
- Creates smooth, pleasant visual appearance

**Alternatives Evaluated**:
- **8px**: Too sharp, dated appearance
- **20px+**: Too rounded, looks cartoonish
- **0px (square corners)**: Corporate appearance, not modern

**Best Practices**:
- Use consistent border radius across similar components
- Apply to both outer card and inner content containers
- Use 12px for smaller elements (icon containers, buttons)
- Test rendering at different device pixel densities

---

## Key Findings

1. **Stack Layout** is the correct approach for icon overlays
2. **Material 3 shadows** provide professional depth
3. **8px spacing scale** ensures visual consistency
4. **Responsive columns** require `LayoutBuilder` or `MediaQuery`
5. **Border radius of 16px** provides modern aesthetic
6. **Accent color for typography** creates visual interest and brand identity

---

## Recommendations for Implementation

1. Keep existing `Stack` widget but enhance shadow system
2. Add `LayoutBuilder` for responsive column count detection
3. Increase elevation from 2dp to 4dp for more depth
4. Increase border radius from 12px to 16px
5. Apply consistent spacing using 8px scale
6. Enhance favorite icon styling with better contrast and shadow
7. Test on multiple device sizes and screen densities

---

## Implementation Notes

- No new dependencies needed (all available in Flutter SDK)
- Changes are purely UI-focused, no architecture changes
- Backward compatible with existing BLoC implementation
- Widget tests should continue to pass after refactoring
