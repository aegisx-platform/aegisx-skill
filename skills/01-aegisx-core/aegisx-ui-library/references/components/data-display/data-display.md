# Data Display Components Overview

## Introduction

The Data Display components category provides a comprehensive set of Angular components for presenting data in various formats. These components are optimized for clarity, accessibility, and integration with Angular's reactive forms and signals. Use these components to build information-rich interfaces with proper visual hierarchy and semantic structure.

## Component Catalog

### Core Container Components

#### Card (`ax-card`)

**Selector**: `ax-card`

Flexible container for grouping related information with multiple appearance options.

**Key Features**:

- Multiple appearances: default, flat, outlined, elevated
- Header with icon, title, and subtitle support
- Header action slot for controls
- Footer action area for buttons

**Use Cases**:

- Product/service cards in lists
- User profile cards
- Settings groups
- Content containers

**Documentation**: [Card Component](./card.md)

#### Calendar (`ax-calendar`)

**Selector**: `ax-calendar`

Feature-rich calendar interface for displaying and managing events.

**Key Features**:

- Multiple views: month, week, day, list
- Drag-and-drop event management
- Event customization with colors and properties
- Business hours support
- Dark mode and responsive design

**Use Cases**:

- Event scheduling
- Meeting management
- Project timeline views
- Resource availability

**Documentation**: [Calendar Component](./calendar.md)

### Data Presentation Components

#### KPI Card (`ax-kpi-card`)

**Selector**: `ax-kpi-card`

Displays key performance indicators with metrics and trends.

**Key Features**:

- Large value display with units
- Trend indicators (up/down/neutral)
- Optional sparkline chart
- Color-coded status

**Use Cases**:

- Dashboard metrics
- Business intelligence displays
- Performance monitoring
- Real-time metrics

#### Stats Card (`ax-stats-card`)

**Selector**: `ax-stats-card`

Shows aggregated statistics with visual indicators.

**Key Features**:

- Multiple statistics in one card
- Icon support for categories
- Comparison metrics
- Historical data trends

**Use Cases**:

- Analytics dashboards
- Report summaries
- Data comparisons
- Performance reviews

#### Badge (`ax-badge`)

**Selector**: `ax-badge`

Small inline component for displaying status, tags, or notifications.

**Key Features**:

- Multiple color variants
- Dot, label, and combo variants
- Status indicators
- Count displays

**Use Cases**:

- Status indicators (online, offline, away)
- Tag lists
- Notification counts
- Category labels

#### Avatar (`ax-avatar`)

**Selector**: `ax-avatar`

Displays user or entity avatars with fallbacks.

**Key Features**:

- Image or initials display
- Multiple sizes
- Presence indicators
- Fallback text

**Use Cases**:

- User profile pictures
- Team member lists
- Author attribution
- Presence indicators

### Progress & Status Components

#### Circular Progress (`ax-circular-progress`)

**Selector**: `ax-circular-progress`

Circular progress indicator for operations and percentages.

**Key Features**:

- Animated progress ring
- Percentage display
- Custom colors
- Multiple sizes

**Use Cases**:

- Upload/download progress
- Loading states
- Percentage metrics
- Process completion

#### Segmented Progress (`ax-segmented-progress`)

**Selector**: `ax-segmented-progress`

Displays progress in discrete segments.

**Key Features**:

- Step-based progress
- Color coding per segment
- Label support
- Milestone markers

**Use Cases**:

- Multi-step processes
- Wizard progress
- Timeline progress
- Milestone tracking

#### Sparkline (`ax-sparkline`)

**Selector**: `ax-sparkline`

Mini line chart for showing data trends in small spaces.

**Key Features**:

- Lightweight chart rendering
- Trend visualization
- Color-coded lines
- Minimal axes

**Use Cases**:

- Trend indicators in cards
- Historical data visualization
- Performance trends
- Quick data overview

### Information Display Components

#### List (`ax-list`)

**Selector**: `ax-list`

Semantic list component for displaying structured data.

**Key Features**:

- Single and multi-select modes
- Avatar and icon support
- Secondary text display
- Action items

**Use Cases**:

- Item selection
- Directory listings
- Navigation lists
- Data tables alternative

#### Timeline (`ax-timeline`)

**Selector**: `ax-timeline`

Displays events in chronological order.

**Key Features**:

- Vertical timeline layout
- Event markers
- Connection lines
- Status indicators

**Use Cases**:

- Activity feeds
- Project history
- Event chronology
- Process steps

#### Description List (`ax-description-list`)

**Selector**: `ax-description-list`

Displays term-description pairs semantically.

**Key Features**:

- Semantic HTML structure
- Term and description formatting
- Multiple layout options
- Accessibility support

**Use Cases**:

- Specifications
- Feature descriptions
- Glossaries
- Metadata display

#### Field Display (`ax-field-display`)

**Selector**: `ax-field-display`

Displays field labels with values in read-only format.

**Key Features**:

- Label and value layout
- Customizable formatting
- Copy functionality
- Value masking

**Use Cases**:

- Form display mode
- Profile information
- Configuration display
- Reference data

#### Divider (`ax-divider`)

**Selector**: `ax-divider`

Semantic divider for separating content sections.

**Key Features**:

- Horizontal and vertical orientation
- Optional labels
- Custom styling
- Spacing control

**Use Cases**:

- Content separation
- Visual grouping
- Section breaks
- Layout organization

#### Keyboard Display (`ax-kbd`)

**Selector**: `ax-kbd`

Displays keyboard keys and shortcuts visually.

**Key Features**:

- Multiple key styles
- Modifier key support
- Shortcut sequences
- Clear visual style

**Use Cases**:

- Keyboard shortcuts documentation
- Help sections
- Tutorial instructions
- Accessibility guides

### Code Display Component

#### Code Tabs (`ax-code-tabs`)

**Selector**: `ax-code-tabs`

Displays code examples with syntax highlighting.

**Key Features**:

- Multi-language syntax highlighting
- Tabbed interface
- Copy-to-clipboard button
- Prism.js integration

**Supported Languages**:

- HTML
- TypeScript / JavaScript
- SCSS / CSS
- Bash
- JSON

**Use Cases**:

- Documentation
- Tutorial examples
- API documentation
- Code snippets

**Documentation**: [Code Tabs Component](./code-tabs.md)

## Component Selection Guide

### By Use Case

#### Displaying User Information

- **User Profile**: Card + Avatar + Field Display
- **User List**: List + Avatar + Badge (for status)
- **Team Members**: Multiple Cards with Avatars

#### Showing Metrics & Analytics

- **Dashboard**: KPI Cards + Stats Cards + Sparklines
- **Real-time Metrics**: Circular Progress + KPI Card
- **Trend Data**: Sparkline + Stats Card

#### Organizing Content

- **Grouped Content**: Card containers with Dividers
- **Step Process**: Timeline or Segmented Progress
- **Information Reference**: Description List or Field Display

#### Code & Documentation

- **Code Examples**: Code Tabs with multiple languages
- **Inline Code**: Keyboard Display (ax-kbd)
- **Documentation Site**: Code Tabs + Description List

#### Event Management

- **Calendar Display**: Calendar component
- **Event Timeline**: Timeline component
- **Event List**: List component

## Accessibility Guidelines

All data display components follow accessibility best practices:

### Color Contrast

- Minimum 4.5:1 ratio for text
- Multiple visual cues beyond color alone
- Dark mode variants included

### Semantic HTML

- Proper heading hierarchy
- Semantic elements (list, dl, time, etc.)
- ARIA roles and labels where needed

### Keyboard Navigation

- All components keyboard accessible
- Tab order logical and predictable
- No keyboard traps
- Focus indicators visible

### Screen Readers

- Proper alt text for images
- ARIA descriptions for complex components
- Meaningful link text
- Form labels properly associated

## Dark Mode Support

All data display components include dark mode support:

```html
<div class="dark">
  <!-- Components automatically adapt to dark mode -->
  <ax-card title="Dark Mode Card"> Content automatically styled for dark backgrounds </ax-card>
</div>
```

CSS Variables used:

- `--ax-background-default` / `--ax-background-elevated`
- `--ax-text-primary` / `--ax-text-secondary`
- `--ax-border-default`
- `--ax-shadow-sm` / `--ax-shadow-md` / `--ax-shadow-lg`

## Responsive Design

Data display components are designed to be responsive:

### Breakpoints

```
- Mobile: < 640px
- Tablet: 640px - 1024px
- Desktop: > 1024px
```

### Responsive Patterns

```typescript
// Responsive card grid
<div class="grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
  <ax-card *ngFor="let item of items">
    <!-- Card content -->
  </ax-card>
</div>
```

### Mobile Considerations

- Cards stack vertically on mobile
- Table-like components use list view on mobile
- Calendar switches to day view on small screens
- Touch-friendly tap targets (minimum 48px)

## Theming

### Design Tokens

All components use consistent design tokens:

```scss
// Colors
--ax-primary-default: #6366f1;
--ax-success-default: #10b981;
--ax-warning-default: #f59e0b;
--ax-danger-default: #ef4444;

// Spacing
--ax-spacing-xs: 0.25rem;
--ax-spacing-sm: 0.5rem;
--ax-spacing-md: 1rem;
--ax-spacing-lg: 1.5rem;

// Typography
--ax-font-family: system-ui, -apple-system, sans-serif;
--ax-font-size-sm: 0.875rem;
--ax-font-size-base: 1rem;
--ax-font-size-lg: 1.125rem;

// Shadows
--ax-shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
--ax-shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
--ax-shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
```

### Custom Theme

Override tokens at root level:

```scss
:root {
  --ax-primary-default: #8b5cf6; // Custom purple
  --ax-spacing-base: 1.25rem;
}

.dark {
  --ax-background-default: #1f2937;
  --ax-text-primary: #f3f4f6;
}
```

## Performance Best Practices

### Large Lists

- Use virtual scrolling for 100+ items
- Paginate data in tables/lists
- Lazy load images in avatars

```typescript
import { ScrollingModule } from '@angular/cdk/scrolling';

@Component({
  imports: [ScrollingModule],
})
export class LargeListComponent {
  items = Array(1000)
    .fill(null)
    .map((_, i) => ({ id: i }));
}
```

```html
<cdk-virtual-scroll-viewport itemSize="50" class="example-viewport">
  <ax-list-item *cdkVirtualFor="let item of items"> {{ item.id }} </ax-list-item>
</cdk-virtual-scroll-viewport>
```

### Change Detection

- Use OnPush strategy for performance
- Update component inputs immutably

```typescript
@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class MyCardComponent {}
```

### Memory Optimization

- Unsubscribe from observables
- Clean up interval/timeout subscriptions
- Destroy large component trees

## Integration Patterns

### With Forms

```typescript
<ax-field-display
  label="Email"
  [value]="form.get('email')?.value">
</ax-field-display>
```

### With Reactive Data

```typescript
<ax-list [items]="items$ | async">
  <!-- List content -->
</ax-list>
```

### With Angular Material

```typescript
// Data display components complement Material components
<ax-card title="Material Integration">
  <mat-form-field>
    <input matInput>
  </mat-form-field>
</ax-card>
```

## Common Patterns

### Dashboard Layout

```html
<div class="dashboard-grid">
  <ax-kpi-card title="Revenue" value="$125,430"></ax-kpi-card>
  <ax-kpi-card title="Users" value="8,234"></ax-kpi-card>
  <ax-stats-card [stats]="stats"></ax-stats-card>
</div>
```

### Card Grid

```html
<div class="card-grid">
  <ax-card *ngFor="let item of items" [title]="item.name"> {{ item.description }} </ax-card>
</div>
```

### Timeline View

```html
<ax-timeline [events]="activities">
  <!-- Timeline events -->
</ax-timeline>
```

### Tabular Display

```html
<div class="data-table">
  <ax-list [items]="tableData" [selectable]="true">
    <!-- List items as table rows -->
  </ax-list>
</div>
```

## Next Steps

1. Choose appropriate components for your use case
2. Review individual component documentation
3. Integrate with your data sources
4. Customize styling using design tokens
5. Test accessibility with keyboard and screen readers
6. Monitor performance with large datasets

## Additional Resources

- [Component Overview](../component-overview.md)
- [Theming Guide](../THEMING_GUIDE.md)
- [Token Reference](../TOKEN_REFERENCE.md)
- [Accessibility Guidelines](../accessibility-guide.md)

## Component Matrix

| Component        | Icon Support | Dark Mode | Mobile Optimized | Responsive | Selectable |
| ---------------- | ------------ | --------- | ---------------- | ---------- | ---------- |
| Card             | ✓            | ✓         | ✓                | ✓          | -          |
| Calendar         | -            | ✓         | ✓                | ✓          | ✓          |
| KPI Card         | -            | ✓         | ✓                | ✓          | -          |
| Stats Card       | ✓            | ✓         | ✓                | ✓          | -          |
| Badge            | ✓            | ✓         | ✓                | ✓          | -          |
| Avatar           | ✓            | ✓         | ✓                | ✓          | -          |
| Progress         | -            | ✓         | ✓                | ✓          | -          |
| List             | ✓            | ✓         | ✓                | ✓          | ✓          |
| Timeline         | -            | ✓         | ✓                | ✓          | -          |
| Code Tabs        | -            | ✓         | ✓                | ✓          | -          |
| Field Display    | -            | ✓         | ✓                | ✓          | -          |
| Description List | -            | ✓         | ✓                | ✓          | -          |

## Troubleshooting

### Components Not Rendering

- Ensure component imports in module/standalone configuration
- Check console for import errors
- Verify component selectors match template

### Styling Issues

- Check CSS variable definitions
- Verify design token values
- Clear browser cache and rebuild

### Performance Problems

- Profile with Chrome DevTools Performance tab
- Check for change detection issues
- Use OnPush change detection strategy
- Implement virtual scrolling for large lists

### Accessibility Issues

- Test with keyboard navigation
- Use screen reader (NVDA, JAWS, VoiceOver)
- Check color contrast ratios
- Verify ARIA labels
