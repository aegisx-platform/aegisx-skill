# ax-gridster

**Category:** Layout
**Since:** 2.0.0
**Status:** Stable

---

## Overview

`ax-gridster` is a powerful drag-and-drop grid layout component built on `angular-gridster2`. It provides a flexible, responsive grid system for building customizable dashboards, widget containers, and dynamic layouts. The component supports content projection, edit modes, preset configurations, and real-time layout persistence.

**Key Features:**

- Drag-and-drop positioning
- Resize grid items
- Responsive breakpoints
- Multiple preset configurations (dashboard, launcher, widget, kanban)
- Content projection via ng-template
- Edit mode toggling
- Layout change events
- Type-safe generic implementation

---

## API Reference

### Selector

```html
<ax-gridster></ax-gridster>
```

### Inputs

| Name        | Type                             | Default             | Description                        |
| ----------- | -------------------------------- | ------------------- | ---------------------------------- |
| `items`     | `T[] extends AxGridsterItemBase` | `[]`                | Array of grid items to display     |
| `editMode`  | `boolean`                        | `false`             | Enable/disable drag and resize     |
| `preset`    | `AxGridsterPreset`               | `'dashboard'`       | Preset configuration to use        |
| `settings`  | `Partial<AxGridsterSettings>`    | `undefined`         | Custom settings (overrides preset) |
| `trackByFn` | `(item: T) => string \| number`  | `(item) => item.id` | Track function for ngFor           |

### Outputs

| Name             | Type                                      | Description                                   |
| ---------------- | ----------------------------------------- | --------------------------------------------- |
| `editModeChange` | `EventEmitter<boolean>`                   | Emits when edit mode changes                  |
| `itemChange`     | `EventEmitter<AxGridsterItemChange<T>>`   | Emits when item position/size changes         |
| `layoutChange`   | `EventEmitter<AxGridsterLayoutChange<T>>` | Emits when layout changes (after drag/resize) |

### Types

```typescript
// Item base interface
export interface AxGridsterItemBase {
  id: string | number;
  x: number; // Grid column position (0-based)
  y: number; // Grid row position (0-based)
  cols: number; // Number of columns item spans
  rows: number; // Number of rows item spans
  minItemCols?: number; // Minimum columns when resizing
  minItemRows?: number; // Minimum rows when resizing
  maxItemCols?: number; // Maximum columns when resizing
  maxItemRows?: number; // Maximum rows when resizing
  dragEnabled?: boolean; // Per-item drag override
  resizeEnabled?: boolean; // Per-item resize override
}

// Preset types
export type AxGridsterPreset = 'dashboard' | 'launcher' | 'widget' | 'kanban' | 'custom';

// Grid types
export type AxGridType = 'fit' | 'scrollVertical' | 'scrollHorizontal' | 'fixed' | 'verticalFixed' | 'horizontalFixed';

// Compact types
export type AxCompactType = 'none' | 'compactUp' | 'compactLeft' | 'compactUp&Left' | 'compactLeft&Up' | 'compactRight' | 'compactUp&Right' | 'compactRight&Up' | 'compactDown' | 'compactDown&Left' | 'compactLeft&Down' | 'compactDown&Right' | 'compactRight&Down';
```

### Methods

| Method              | Parameters                              | Return Type                     | Description                          |
| ------------------- | --------------------------------------- | ------------------------------- | ------------------------------------ |
| `toggleEditMode()`  | None                                    | `void`                          | Toggle between view and edit modes   |
| `enableEditMode()`  | None                                    | `void`                          | Enable edit mode                     |
| `disableEditMode()` | None                                    | `void`                          | Disable edit mode                    |
| `applySettings()`   | `settings: Partial<AxGridsterSettings>` | `void`                          | Apply new settings                   |
| `resetSettings()`   | None                                    | `void`                          | Reset to preset defaults             |
| `getLayoutData()`   | None                                    | `Array<{id, x, y, cols, rows}>` | Get current layout data (for saving) |

---

## Preset Configurations

### Dashboard Preset (Default)

**Best for:** General-purpose dashboards with mixed content

```typescript
{
  gridType: 'fit',
  columns: 12,           // 12-column grid
  margin: 16,            // 16px spacing between items
  minRows: 6,
  maxRows: 100,
  displayGrid: 'onDrag&Resize',
  pushItems: true,       // Items push others when moved
  swap: false,           // Items don't swap positions
  compactType: 'none'    // Free positioning
}
```

### Launcher Preset

**Best for:** App launchers, icon grids, tile-based UIs

```typescript
{
  gridType: 'fit',
  columns: 6,            // 6-column grid
  margin: 12,            // Tighter spacing
  minRows: 4,
  maxRows: 20,
  displayGrid: 'onDrag&Resize',
  pushItems: true,
  swap: true,            // Items can swap positions
  compactType: 'compactUp&Left'  // Auto-compact to top-left
}
```

### Widget Preset

**Best for:** Widget containers, scrollable dashboards

```typescript
{
  gridType: 'scrollVertical',  // Vertical scroll
  columns: 8,
  margin: 8,
  minRows: 1,
  maxRows: 100,
  displayGrid: 'onDrag&Resize',
  pushItems: true,
  swap: false,
  compactType: 'compactUp'     // Auto-compact upward
}
```

### Kanban Preset

**Best for:** Kanban boards, horizontal scrolling columns

```typescript
{
  gridType: 'scrollHorizontal',  // Horizontal scroll
  columns: 100,          // Wide grid for many columns
  margin: 16,
  minRows: 1,
  maxRows: 1,            // Single row
  displayGrid: 'none',
  pushItems: true,
  swap: false,
  compactType: 'compactLeft',    // Auto-compact to left
  fixedColWidth: 320     // Fixed column width (320px)
}
```

---

## Usage Examples

### Basic Dashboard

```typescript
import { Component, signal } from '@angular/core';
import { AxGridsterComponent, AxGridsterItemBase } from '@aegisx/ui';

interface DashboardWidget extends AxGridsterItemBase {
  id: string;
  title: string;
  type: 'chart' | 'stats' | 'table';
}

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [AxGridsterComponent],
  template: `
    <div class="dashboard-container">
      <!-- Edit Mode Toggle -->
      <button (click)="isEditing.set(!isEditing())">
        {{ isEditing() ? 'Save Layout' : 'Edit Layout' }}
      </button>

      <!-- Gridster -->
      <ax-gridster [items]="widgets()" [editMode]="isEditing()" (layoutChange)="onLayoutChange($event)">
        <!-- Widget Template -->
        <ng-template #itemTemplate let-item let-editMode="editMode">
          <app-widget-card [widget]="item" [isEditing]="editMode"> </app-widget-card>
        </ng-template>
      </ax-gridster>
    </div>
  `,
})
export class DashboardComponent {
  widgets = signal<DashboardWidget[]>([
    { id: '1', x: 0, y: 0, cols: 4, rows: 2, title: 'Revenue Chart', type: 'chart' },
    { id: '2', x: 4, y: 0, cols: 4, rows: 2, title: 'Users Stats', type: 'stats' },
    { id: '3', x: 8, y: 0, cols: 4, rows: 2, title: 'Orders Table', type: 'table' },
  ]);

  isEditing = signal(false);

  onLayoutChange(event: AxGridsterLayoutChange<DashboardWidget>): void {
    // Save layout to backend or localStorage
    const layout = event.items.map((item) => ({
      id: item.id,
      x: item.x,
      y: item.y,
      cols: item.cols,
      rows: item.rows,
    }));
    localStorage.setItem('dashboard-layout', JSON.stringify(layout));
  }
}
```

### App Launcher Grid

```typescript
interface LauncherApp extends AxGridsterItemBase {
  id: string;
  name: string;
  icon: string;
  color: string;
}

@Component({
  selector: 'app-launcher',
  standalone: true,
  imports: [AxGridsterComponent],
  template: `
    <ax-gridster [items]="apps()" preset="launcher" [editMode]="editMode()">
      <ng-template #itemTemplate let-app>
        <div class="launcher-app" [style.background]="app.color">
          <mat-icon>{{ app.icon }}</mat-icon>
          <span>{{ app.name }}</span>
        </div>
      </ng-template>
    </ax-gridster>
  `,
})
export class AppLauncherComponent {
  apps = signal<LauncherApp[]>([
    { id: '1', x: 0, y: 0, cols: 1, rows: 1, name: 'Email', icon: 'mail', color: '#3b82f6' },
    { id: '2', x: 1, y: 0, cols: 1, rows: 1, name: 'Calendar', icon: 'event', color: '#10b981' },
    { id: '3', x: 2, y: 0, cols: 1, rows: 1, name: 'Files', icon: 'folder', color: '#f59e0b' },
  ]);

  editMode = signal(false);
}
```

### Custom Settings

```typescript
@Component({
  template: `
    <ax-gridster
      [items]="items()"
      [settings]="customSettings"
      [editMode]="true">
      <ng-template #itemTemplate let-item>
        <custom-item [data]="item"></custom-item>
      </ng-template>
    </ax-gridster>
  `
})
export class CustomGridComponent {
  customSettings: Partial<AxGridsterSettings> = {
    gridType: 'fit',
    columns: 16,           // 16-column grid
    margin: 24,            // Larger margin
    displayGrid: 'always', // Always show grid
    pushItems: false,      // Overlapping allowed
    compactType: 'compactUp&Left'
  };

  items = signal([...]);
}
```

### Responsive Breakpoints

```typescript
import { Component, inject, signal } from '@angular/core';
import { BreakpointObserver, Breakpoints } from '@angular/cdk/layout';

@Component({
  selector: 'app-responsive-grid',
  template: `
    <ax-gridster
      [items]="widgets()"
      [settings]="gridSettings()">
      <ng-template #itemTemplate let-widget>
        <app-widget [data]="widget"></app-widget>
      </ng-template>
    </ax-gridster>
  `
})
export class ResponsiveGridComponent {
  private breakpointObserver = inject(BreakpointObserver);

  widgets = signal([...]);
  gridSettings = signal<Partial<AxGridsterSettings>>({});

  constructor() {
    // Adjust grid columns based on screen size
    this.breakpointObserver
      .observe([Breakpoints.XSmall, Breakpoints.Small, Breakpoints.Medium, Breakpoints.Large])
      .subscribe(result => {
        if (result.breakpoints[Breakpoints.XSmall]) {
          // Mobile: 1 column
          this.gridSettings.set({ columns: 1, margin: 8 });
        } else if (result.breakpoints[Breakpoints.Small]) {
          // Tablet: 4 columns
          this.gridSettings.set({ columns: 4, margin: 12 });
        } else if (result.breakpoints[Breakpoints.Medium]) {
          // Desktop: 8 columns
          this.gridSettings.set({ columns: 8, margin: 16 });
        } else {
          // Large Desktop: 12 columns
          this.gridSettings.set({ columns: 12, margin: 16 });
        }
      });
  }
}
```

---

## Grid System

### Column Grid

The gridster uses a **12-column grid system** by default (customizable via `columns` setting):

```
┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│  1  │  2  │  3  │  4  │  5  │  6  │  7  │  8  │  9  │ 10  │ 11  │ 12  │
└─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘
```

**Column Span Examples:**

- `cols: 12` = Full width
- `cols: 6` = Half width
- `cols: 4` = One-third width
- `cols: 3` = One-quarter width

### Row Grid

Rows are automatically sized based on `gridType`:

- **fit:** Rows fill container height
- **scrollVertical:** Rows have fixed height, scroll when needed
- **fixed:** Custom `fixedRowHeight` in pixels

### Positioning

Items are positioned using zero-based coordinates:

```typescript
{
  x: 0,    // Column position (0 = first column)
  y: 0,    // Row position (0 = first row)
  cols: 4, // Spans 4 columns
  rows: 2  // Spans 2 rows
}
```

**Example Layout:**

```
┌─────────────┬─────────────┬─────────────┐
│   Item 1    │   Item 2    │   Item 3    │
│ (0,0) 4x2   │ (4,0) 4x2   │ (8,0) 4x2   │
├─────────────┴─────────────┴─────────────┤
│              Item 4 (0,2) 12x1           │
└──────────────────────────────────────────┘
```

---

## Responsive Breakpoints

### Recommended Breakpoints

```typescript
// Mobile
@media (max-width: 599px) {
  columns: 1,
  margin: 8
}

// Tablet
@media (min-width: 600px) and (max-width: 959px) {
  columns: 4,
  margin: 12
}

// Desktop
@media (min-width: 960px) and (max-width: 1279px) {
  columns: 8,
  margin: 16
}

// Large Desktop
@media (min-width: 1280px) {
  columns: 12,
  margin: 16
}
```

### Implementation with CDK Layout

```typescript
import { BreakpointObserver } from '@angular/cdk/layout';

// Observe specific breakpoints
breakpointObserver.observe(['(max-width: 599px)', '(min-width: 1280px)']).subscribe((result) => {
  if (result.matches) {
    // Adjust grid settings
  }
});
```

---

## Styling

### Theme Integration

The component uses CSS custom properties for theming:

```scss
// Edit mode background pattern
.ax-gridster-edit-mode gridster {
  background: var(
    --ax-gridster-edit-bg,
    linear-gradient(45deg, #f4f4f5 25%, transparent 25%) // ... pattern definition
  );
}

// Grid background
gridster {
  background: var(--ax-background-subtle, #f4f4f5);
  border-radius: var(--ax-radius-lg, 12px);
}
```

### Custom Styling

```css
/* Custom grid background */
::ng-deep ax-gridster gridster {
  background: linear-gradient(to bottom, #fafafa, #f0f0f0);
}

/* Custom item spacing */
::ng-deep ax-gridster {
  --gridster-margin: 20px;
}

/* Edit mode indicator color */
::ng-deep .ax-gridster-edit-mode gridster {
  border: 2px dashed #6366f1;
}
```

See [THEMING_GUIDE.md](../../THEMING_GUIDE.md) for detailed theming documentation.

---

## Accessibility

### Keyboard Navigation

| Key          | Action                             |
| ------------ | ---------------------------------- |
| `Tab`        | Navigate between grid items        |
| `Enter`      | Focus on grid item content         |
| `Arrow Keys` | Move focused item (edit mode only) |
| `Escape`     | Cancel drag operation              |

### Screen Readers

```html
<!-- Add ARIA labels to items -->
<ng-template #itemTemplate let-item>
  <div role="article" [attr.aria-label]="item.title + ' widget'" tabindex="0">{{ item.content }}</div>
</ng-template>
```

### Focus Management

```typescript
// Ensure keyboard accessibility
<ng-template #itemTemplate let-item>
  <div
    tabindex="0"
    (keydown.enter)="onItemActivate(item)"
    (keydown.delete)="onItemDelete(item)">
    {{ item.content }}
  </div>
</ng-template>
```

---

## Performance Optimization

### Track Function

Always provide a trackBy function for better performance:

```typescript
trackByFn = (item: GridItem) => item.id; // Use unique ID

// In template
<ax-gridster [items]="items" [trackByFn]="trackByFn">
```

### Change Detection

The component uses `OnPush` change detection strategy. Update items immutably:

```typescript
// ✅ Good: Create new array reference
addItem(newItem: GridItem): void {
  this.items.update(current => [...current, newItem]);
}

// ❌ Bad: Mutate existing array
addItem(newItem: GridItem): void {
  this.items().push(newItem); // Won't trigger change detection
}
```

### Large Grids

For grids with many items (>50), consider:

1. Virtual scrolling for very large datasets
2. Lazy loading content templates
3. Debouncing layout change events

---

## Common Patterns

### Save/Load Layout

```typescript
// Save layout
saveLayout(): void {
  const layout = this.gridsterComponent.getLayoutData();
  localStorage.setItem('my-layout', JSON.stringify(layout));
}

// Load layout
loadLayout(): void {
  const saved = localStorage.getItem('my-layout');
  if (saved) {
    const layout = JSON.parse(saved);
    this.items.set(layout);
  }
}
```

### Add/Remove Items

```typescript
addWidget(): void {
  const newWidget = {
    id: crypto.randomUUID(),
    x: 0,
    y: 0,
    cols: 4,
    rows: 2,
    title: 'New Widget'
  };
  this.widgets.update(current => [...current, newWidget]);
}

removeWidget(id: string): void {
  this.widgets.update(current => current.filter(w => w.id !== id));
}
```

---

## Related Components

- **ax-layout-switcher** - Switch between layout modes
- **ax-card** - Card wrapper for grid items
- **ax-drawer** - Sidebar for grid configuration

---

## Related Documentation

- [THEMING_GUIDE.md](../../THEMING_GUIDE.md) - Theme customization
- [Angular Gridster2 Docs](https://tiberiuzuld.github.io/angular-gridster2/) - Underlying library documentation
- [Responsive Design Guide](../../patterns/responsive.md) - Breakpoints and responsive patterns

---

**Last Updated:** 2025-12-17
**Component Version:** 2.0.0
