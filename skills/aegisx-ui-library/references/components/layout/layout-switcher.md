# ax-layout-switcher

**Category:** Layout
**Since:** 2.0.0
**Status:** Stable

---

## Overview

`ax-layout-switcher` is a dropdown menu component that allows users to switch between different application layout modes. It persists the user's layout preference in localStorage and provides an intuitive icon-based menu for layout selection.

**Use Cases:**

- Multi-layout applications with compact, enterprise, and empty layout modes
- Applications that support different user workflow preferences
- Dashboards requiring flexible layout options

---

## API Reference

### Selector

```html
<ax-layout-switcher></ax-layout-switcher>
```

### Inputs

| Name | Type | Default | Description                                            |
| ---- | ---- | ------- | ------------------------------------------------------ |
| None | -    | -       | This component has no inputs (uses signals internally) |

### Outputs

| Name           | Type                           | Description                                |
| -------------- | ------------------------------ | ------------------------------------------ |
| `layoutChange` | `OutputEmitterRef<LayoutType>` | Emits when user selects a different layout |

### Types

```typescript
export type LayoutType = 'compact' | 'enterprise' | 'empty' | 'docs';

export interface LayoutOption {
  value: LayoutType;
  label: string;
  icon: string;
  description: string;
}
```

### Signals

```typescript
// Current layout signal (internal)
currentLayout: Signal<LayoutType>

// Current layout label (computed)
currentLayoutLabel(): string

// Current layout icon (computed)
currentLayoutIcon(): string
```

### Methods

| Method                 | Parameters           | Return Type | Description                         |
| ---------------------- | -------------------- | ----------- | ----------------------------------- |
| `selectLayout()`       | `layout: LayoutType` | `void`      | Selects and persists a layout       |
| `currentLayoutLabel()` | None                 | `string`    | Returns the label of current layout |
| `currentLayoutIcon()`  | None                 | `string`    | Returns the icon of current layout  |

---

## Usage Examples

### Basic Usage

```typescript
import { Component } from '@angular/core';
import { AxLayoutSwitcherComponent, LayoutType } from '@aegisx/ui';

@Component({
  selector: 'app-toolbar',
  standalone: true,
  imports: [AxLayoutSwitcherComponent],
  template: `
    <div class="toolbar">
      <ax-layout-switcher (layoutChange)="onLayoutChange($event)"> </ax-layout-switcher>
    </div>
  `,
})
export class ToolbarComponent {
  onLayoutChange(layout: LayoutType): void {
    console.log('Layout changed to:', layout);
    // Apply layout to your application
    this.applyLayout(layout);
  }

  private applyLayout(layout: LayoutType): void {
    // Implementation depends on your layout system
    switch (layout) {
      case 'compact':
        // Show compact layout
        break;
      case 'enterprise':
        // Show enterprise layout
        break;
      case 'empty':
        // Show minimal layout
        break;
    }
  }
}
```

### Integration with Router-Based Layouts

```typescript
import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';
import { AxLayoutSwitcherComponent, LayoutType } from '@aegisx/ui';

@Component({
  selector: 'app-shell',
  standalone: true,
  imports: [AxLayoutSwitcherComponent],
  template: ` <ax-layout-switcher (layoutChange)="onLayoutChange($event)"> </ax-layout-switcher> `,
})
export class AppShellComponent {
  private router = inject(Router);

  onLayoutChange(layout: LayoutType): void {
    // Navigate to layout-specific route
    this.router.navigate(['/app', { layout }]);
  }
}
```

### With Signal-Based State Management

```typescript
import { Component, signal, effect } from '@angular/core';
import { AxLayoutSwitcherComponent, LayoutType } from '@aegisx/ui';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [AxLayoutSwitcherComponent, RouterOutlet],
  template: `
    <div class="app-container" [attr.data-layout]="currentLayout()">
      <!-- Layout Switcher in Header -->
      <header>
        <ax-layout-switcher (layoutChange)="currentLayout.set($event)"> </ax-layout-switcher>
      </header>

      <!-- Main Content -->
      <main>
        <router-outlet></router-outlet>
      </main>
    </div>
  `,
  styles: [
    `
      /* Layout-specific styles */
      [data-layout='compact'] main {
        max-width: 1200px;
        margin: 0 auto;
      }

      [data-layout='enterprise'] main {
        max-width: 100%;
        padding: 1rem 2rem;
      }

      [data-layout='empty'] main {
        max-width: 100%;
        padding: 0;
      }
    `,
  ],
})
export class AppComponent {
  currentLayout = signal<LayoutType>('compact');

  constructor() {
    // Log layout changes
    effect(() => {
      console.log('Current layout:', this.currentLayout());
    });
  }
}
```

---

## Layout Options

The component provides these built-in layout options:

### Compact Layout

- **Icon:** `view_quilt`
- **Description:** "Collapsible sidebar with compact navigation"
- **Use Case:** Standard application layout with space efficiency

### Enterprise Layout

- **Icon:** `dashboard_customize`
- **Description:** "Full-featured layout with multiple panels"
- **Use Case:** Complex dashboards requiring multiple information panels

### Empty Layout

- **Icon:** `crop_free`
- **Description:** "Minimal layout with no chrome"
- **Use Case:** Presentation mode, fullscreen content, authentication pages

---

## Styling

### Theme Integration

The component uses Material Design tokens and integrates with the theme system:

```scss
// Active menu item styling
.active {
  background-color: rgba(0, 0, 0, 0.04); // Light mode
}

:host-context(.dark) .active {
  background-color: rgba(255, 255, 255, 0.08); // Dark mode
}
```

### Custom Styling

Override component styles using CSS:

```css
/* Customize menu appearance */
::ng-deep ax-layout-switcher .mat-mdc-menu-content {
  padding: 12px 0;
}

::ng-deep ax-layout-switcher .mat-mdc-menu-item {
  min-height: 72px;
}
```

---

## Local Storage Integration

The component automatically persists the selected layout to `localStorage`:

```typescript
// Storage key
private readonly LAYOUT_KEY = 'layout-type';

// On component init, loads saved preference
ngOnInit(): void {
  const savedLayout = localStorage.getItem(this.LAYOUT_KEY);
  if (savedLayout && this.isValidLayout(savedLayout)) {
    this.currentLayout.set(savedLayout);
  }
}

// On layout selection, saves preference
selectLayout(layout: LayoutType): void {
  this.currentLayout.set(layout);
  localStorage.setItem(this.LAYOUT_KEY, layout);
  this.layoutChange.emit(layout);
}
```

**Clear Saved Layout:**

```javascript
// Clear layout preference
localStorage.removeItem('layout-type');
```

---

## Accessibility

### Keyboard Navigation

- **Menu Trigger:** Accessible via `Tab` key
- **Menu Items:** Navigate with arrow keys
- **Selection:** `Enter` or `Space` to select
- **Close Menu:** `Escape` key

### Screen Readers

- Menu button includes tooltip describing current layout
- Menu items include icon and descriptive text
- Active state indicated visually and via ARIA attributes

### ARIA Attributes

```html
<!-- Automatically handled by Material Menu -->
<button mat-icon-button [matMenuTriggerFor]="layoutMenu" [matTooltip]="'Switch Layout: ' + currentLayoutLabel()" role="button" aria-haspopup="true">
  <mat-icon>{{ currentLayoutIcon() }}</mat-icon>
</button>
```

---

## Responsive Behavior

The component adapts to different screen sizes:

- **Desktop (>1024px):** Full menu with icons and descriptions
- **Tablet (768px-1024px):** Condensed menu items
- **Mobile (<768px):** Icon-only button, responsive menu

---

## Best Practices

### Do's

- Place the layout switcher in a persistent header/toolbar
- Provide clear visual feedback for the active layout
- Test layout transitions for smooth user experience
- Consider user preferences and workflow patterns

### Don'ts

- Don't change layouts automatically without user action
- Don't hide the switcher on certain layouts (keep it accessible)
- Avoid too many layout options (3-4 is optimal)
- Don't forget to handle layout state across page navigations

---

## Common Patterns

### Pattern 1: Layout State Service

```typescript
// layout.service.ts
import { Injectable, signal } from '@angular/core';
import { LayoutType } from '@aegisx/ui';

@Injectable({ providedIn: 'root' })
export class LayoutService {
  currentLayout = signal<LayoutType>('compact');

  setLayout(layout: LayoutType): void {
    this.currentLayout.set(layout);
    // Additional logic like analytics tracking
  }
}

// In component
export class AppComponent {
  layoutService = inject(LayoutService);

  onLayoutChange(layout: LayoutType): void {
    this.layoutService.setLayout(layout);
  }
}
```

### Pattern 2: Conditional Feature Rendering

```typescript
@Component({
  template: `
    <ax-layout-switcher (layoutChange)="onLayoutChange($event)"> </ax-layout-switcher>

    <!-- Show advanced features only in enterprise layout -->
    @if (currentLayout() === 'enterprise') {
      <app-advanced-panels></app-advanced-panels>
    }
  `,
})
export class DashboardComponent {
  currentLayout = signal<LayoutType>('compact');

  onLayoutChange(layout: LayoutType): void {
    this.currentLayout.set(layout);
  }
}
```

---

## Related Components

- **ax-gridster** - Drag-and-drop dashboard grid (pairs well with enterprise layout)
- **ax-navigation** - Main navigation component (adapts to layout modes)
- **ax-drawer** - Sidebar drawer (used in compact layout)

---

## Related Documentation

- [THEMING_GUIDE.md](../../THEMING_GUIDE.md) - Material Design token system
- [Layout Architecture](../../layout/README.md) - Overview of layout system
- [Responsive Design Patterns](../../patterns/responsive.md) - Breakpoints and media queries

---

**Last Updated:** 2025-12-17
**Component Version:** 2.0.0
