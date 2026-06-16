# Data Model: Home Page UI Components

**Feature**: Improve Home Page UI Design

**Date**: 2026-06-16

**Purpose**: Define UI component structure and data relationships for the redesigned home page

---

## UI Component Hierarchy

### 1. HomePage Widget Tree

```
HomePageView (StatelessWidget)
├── Scaffold
│   ├── AppBar (enhanced styling)
│   └── BlocBuilder<HomeBloc, HomeState>
│       └── Column
│           ├── FilterChip (Favorites Only)
│           └── Expanded
│               └── TemplateGrid (if templates available)
```

**Component State**: Managed by `HomeBloc`
- Templates list
- Favorites filter status
- Loading/Error states

---

### 2. TemplateGrid Widget Tree

```
TemplateGrid (StatelessWidget)
├── LayoutBuilder (for responsive detection)
│   └── GridView.builder
│       └── TemplateThumbnail (repeated)
```

**Props**:
- `templates: List<ResumeTemplate>` - List of templates to display
- `onTemplateSelected: Function(ResumeTemplate)` - Navigation callback
- `onFavoriteToggled: Function(String)` - Favorite toggle callback

**Responsive Configuration**:
- **Mobile** (<600px): 2 columns
- **Tablet** (600-900px): 3 columns
- **Desktop** (>900px): 4 columns

**Spacing**:
- Grid padding: 24px
- Cross-axis spacing: 16px
- Main-axis spacing: 20px
- Child aspect ratio: 0.8

---

### 3. TemplateThumbnail Card

```
TemplateThumbnail (StatelessWidget)
├── GestureDetector (tap handler)
│   └── Card (elevation: 4)
│       └── Container (rounded corners, border)
│           └── Stack
│               ├── Container (gradient background)
│               │   └── Column (template preview + name)
│               │       ├── Container (color preview)
│               │       └── Text (template name)
│               └── Positioned (favorite icon overlay)
│                   └── GestureDetector
│                       └── Container (icon background)
│                           └── Icon (heart)
```

**Props**:
- `template: ResumeTemplate` - Template data
- `onTap: VoidCallback` - Selection handler
- `onFavoriteTap: VoidCallback?` - Favorite toggle handler

**State Dependencies**:
- `template.name` - Display name
- `template.accentColor` - Brand color
- `template.isFavorite` - Heart icon state

---

## Data Structures

### ResumeTemplate Entity

```dart
class ResumeTemplate {
  final String id;
  final String name;
  final Color accentColor;
  final bool isFavorite;
  final String? description;
  final String? previewImageUrl;
  
  // State management
  ResumeTemplate copyWith({
    bool? isFavorite,
    // ... other fields
  });
}
```

**Visual Mapping**:
- `id` → Card key (for Flutter rendering)
- `name` → Title text (16-18px, bold, accent color)
- `accentColor` → Gradient background, icon color
- `isFavorite` → Heart icon state (filled/outline)

---

## Component Styling

### Spacing Values (8px Scale)

| Name | Value | Usage |
|------|-------|-------|
| `xs` | 4px | Mini gaps |
| `sm` | 8px | Icon padding |
| `md` | 12px | Favorite icon position |
| `lg` | 16px | Card spacing |
| `xl` | 24px | Grid padding |
| `xxl` | 32px | Section spacing |

### Shadow System

**Primary Shadow** (Card elevation):
- `BlurRadius`: 8.0
- `SpreadRadius`: 0.0
- `Offset`: (0, 4)
- `Color opacity`: 0.12

**Secondary Shadow** (Accent):
- `BlurRadius`: 4.0
- `SpreadRadius`: 0.0
- `Offset`: (0, 2)
- `Color opacity`: 0.08

### Border Radius

| Element | Value | Reason |
|---------|-------|--------|
| Card | 16px | Modern primary component |
| Icon container | 12px | Accent element |
| Preview box | 8px | Tertiary detail |

### Typography

| Element | Size | Weight | Color |
|---------|------|--------|-------|
| Template Name | 16-18px | Bold (700) | accent color |
| Description (future) | 12px | Regular (400) | secondary text |

---

## Event Flow (State Management)

### User Interactions

1. **Tap Template Card**
   - Trigger: `onTemplateSelected(template)`
   - Handler: HomePageView → navigate to preview
   - State: Load template details

2. **Toggle Favorite**
   - Trigger: `onFavoriteTap()` → `HomeBloc.add(toggleFavorite(templateId))`
   - Handler: HomeBloc → update state
   - State: Update `template.isFavorite` in list
   - UI: Icon updates from outline to filled

3. **Toggle Favorites Filter**
   - Trigger: FilterChip selection
   - Handler: HomeBloc.add(favoritesFilterChanged(value))
   - State: Update `favoritesOnly` flag
   - UI: Grid filters visible templates

---

## No Changes to Data Flow

✓ **Preserved**:
- API data structure
- BLoC event handling
- State management
- Navigation parameters
- Favorite persistence
- Filter logic

✓ **UI-Only Changes**:
- Card styling and shadows
- Grid responsiveness
- Icon positioning
- Typography rendering
- Spacing and padding
- Border radius

---

## Responsive Breakpoints

```dart
const breakpoints = {
  'mobile': 600.0,    // < 600px: 2 columns
  'tablet': 900.0,    // 600-900px: 3 columns
  'desktop': double.infinity, // > 900px: 4 columns
};
```

**Implementation**:
```dart
LayoutBuilder(
  builder: (context, constraints) {
    int columns = constraints.maxWidth < 600
        ? 2
        : constraints.maxWidth < 900
            ? 3
            : 4;
    // Apply column count to grid
  },
)
```

---

## Key Design Decisions

1. **Stack for Icon Overlay**: Maintains clean separation of concerns
2. **Positioned for Placement**: Precise control over icon location
3. **LayoutBuilder for Responsiveness**: Clean, maintainable breakpoint logic
4. **Material 3 Shadows**: Professional, device-optimized appearance
5. **8px Spacing Scale**: Consistency and maintainability
6. **Gradient Background**: Maintains brand identity via accent colors

---

## Testing Considerations

**Widget Tests Should Verify**:
- Card renders with correct accent color
- Icon appears overlaid on thumbnail
- Favorite toggle updates icon state
- Grid adapts to screen size changes
- Text renders without overflow
- Shadows render correctly
- Tap handlers execute correctly

**Manual Testing Should Verify**:
- Consistent spacing on different devices
- Shadow depth appropriate on different brightness levels
- Icon visibility against all background colors
- Grid columns adjust correctly on device rotation
