# Drawer Component

## Overview

The `ax-drawer` component provides a flexible, side-sliding panel that appears from the edge of the screen. It's perfect for supplementary navigation, filters, forms, and detail views without leaving the main content context.

**Key Features:**

- Multiple position options (left, right, top, bottom)
- Size presets (sm, md, lg, xl, full)
- Smooth slide animations with easing curves
- Backdrop overlay with click-to-close
- Header with icon and close button
- Optional footer slot for actions
- Keyboard support (Escape to close)
- Responsive design (full-width on mobile)
- CSS variables theming support

**Use Cases:**

- Navigation drawers on mobile
- Filter panels for data tables
- Settings/preferences panels
- Detail view overlays
- Mobile menu interfaces
- Shopping cart panels
- Chat interfaces

## Installation & Import

```typescript
import { AxDrawerComponent } from '@aegisx/ui';
```

The component is standalone and can be imported directly:

```typescript
import { Component } from '@angular/core';
import { AxDrawerComponent } from '@aegisx/ui';

@Component({
  selector: 'app-drawer-demo',
  imports: [AxDrawerComponent],
  template: `
    <button (click)="isOpen = true">Open Drawer</button>
    <ax-drawer [(open)]="isOpen" title="Settings">
      <p>Drawer content here</p>
    </ax-drawer>
  `,
})
export class DrawerDemoComponent {
  isOpen = false;
}
```

## Basic Usage

### Simple Drawer

```typescript
import { Component } from '@angular/core';
import { AxDrawerComponent } from '@aegisx/ui';

@Component({
  selector: 'app-simple-drawer',
  imports: [AxDrawerComponent],
  template: `
    <button (click)="isOpen = true">Open Menu</button>

    <ax-drawer [(open)]="isOpen" title="Menu">
      <p>Your menu content goes here</p>
    </ax-drawer>
  `,
})
export class SimpleDrawerComponent {
  isOpen = false;
}
```

### Drawer with Footer

Add action buttons in the footer:

```typescript
import { Component } from '@angular/core';
import { AxDrawerComponent } from '@aegisx/ui';
import { MatButtonModule } from '@angular/material/button';

@Component({
  selector: 'app-drawer-with-footer',
  imports: [AxDrawerComponent, MatButtonModule],
  template: `
    <button (click)="isOpen = true">Edit Item</button>

    <ax-drawer [(open)]="isOpen" title="Edit Item">
      <form>
        <input type="text" placeholder="Item name" />
        <textarea placeholder="Description"></textarea>
      </form>

      <ng-template #footer>
        <button mat-stroked-button (click)="close()">Cancel</button>
        <button mat-flat-button color="primary" (click)="save()">Save</button>
      </ng-template>
    </ax-drawer>
  `,
})
export class DrawerWithFooterComponent {
  isOpen = false;

  close() {
    this.isOpen = false;
  }

  save() {
    // Handle save logic
    this.close();
  }
}
```

### Positioned Drawer

```typescript
<ax-drawer
  [(open)]="isOpen"
  position="left"
  title="Filters"
>
  <p>Filter panel content</p>
</ax-drawer>

<ax-drawer
  [(open)]="isBottomOpen"
  position="bottom"
  size="sm"
  title="Quick Actions"
>
  <p>Bottom sheet content</p>
</ax-drawer>
```

## API Reference

### Inputs

| Name                   | Type                                     | Default   | Description                                            |
| ---------------------- | ---------------------------------------- | --------- | ------------------------------------------------------ |
| `open`                 | `boolean`                                | `false`   | Whether the drawer is open (two-way binding supported) |
| `position`             | `'left' \| 'right' \| 'top' \| 'bottom'` | `'right'` | Position where drawer slides from                      |
| `size`                 | `'sm' \| 'md' \| 'lg' \| 'xl' \| 'full'` | `'md'`    | Size preset for the drawer                             |
| `title`                | `string`                                 | -         | Drawer title shown in header                           |
| `subtitle`             | `string`                                 | -         | Drawer subtitle shown below title                      |
| `icon`                 | `string`                                 | -         | Material icon name shown in header                     |
| `showHeader`           | `boolean`                                | `true`    | Show/hide the header section                           |
| `showCloseButton`      | `boolean`                                | `true`    | Show/hide close button in header                       |
| `hasBackdrop`          | `boolean`                                | `true`    | Show/hide backdrop overlay                             |
| `closeOnBackdropClick` | `boolean`                                | `true`    | Close drawer when backdrop is clicked                  |
| `closeOnEscape`        | `boolean`                                | `true`    | Close drawer when Escape key is pressed                |

### Outputs

| Name         | Type                    | Description                     |
| ------------ | ----------------------- | ------------------------------- |
| `openChange` | `EventEmitter<boolean>` | Emitted when open state changes |

### Template References

| Reference | Type          | Description                      |
| --------- | ------------- | -------------------------------- |
| `footer`  | `ng-template` | Template for footer content slot |

### Methods

| Method    | Parameters | Return | Description                       |
| --------- | ---------- | ------ | --------------------------------- |
| `close()` | -          | `void` | Close the drawer programmatically |

## Size Reference

### Horizontal Positions (Left/Right)

| Size   | Width | Use Case                             |
| ------ | ----- | ------------------------------------ |
| `sm`   | 320px | Navigation drawers, compact menus    |
| `md`   | 400px | Standard forms, filters (default)    |
| `lg`   | 500px | Detailed content, large forms        |
| `xl`   | 640px | Rich layouts, side-by-side content   |
| `full` | 100%  | Maximum width, full-screen on mobile |

### Vertical Positions (Top/Bottom)

| Size   | Height | Use Case                      |
| ------ | ------ | ----------------------------- |
| `sm`   | 200px  | Quick actions, brief menus    |
| `md`   | 320px  | Standard forms (default)      |
| `lg`   | 480px  | Complex forms, detailed views |
| `xl`   | 640px  | Rich layouts, full content    |
| `full` | 100%   | Maximize height               |

## Angular Router Integration

### Navigation with Drawer

Use drawer for navigation that maintains context:

```typescript
import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { AxDrawerComponent } from '@aegisx/ui';
import { AxNavigationItem } from '@aegisx/ui/types';

@Component({
  selector: 'app-layout',
  imports: [AxDrawerComponent],
  template: `
    <button (click)="menuOpen = true">Menu</button>

    <ax-drawer [(open)]="menuOpen" position="left" title="Navigation">
      <nav>
        <a href="/dashboard" (click)="navigateTo('/dashboard')">Dashboard</a>
        <a href="/projects" (click)="navigateTo('/projects')">Projects</a>
        <a href="/settings" (click)="navigateTo('/settings')">Settings</a>
      </nav>
    </ax-drawer>

    <main>
      <router-outlet></router-outlet>
    </main>
  `,
})
export class LayoutComponent {
  menuOpen = false;

  constructor(private router: Router) {}

  navigateTo(route: string) {
    this.router.navigate([route]);
    this.menuOpen = false;
  }
}
```

### Dynamic Route Handling

```typescript
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-drawer-detail',
  template: `
    <button (click)="isOpen = true">View Details</button>

    <ax-drawer [(open)]="isOpen" title="Item Details" position="right">
      <p>{{ itemDetail }}</p>
    </ax-drawer>
  `,
})
export class DrawerDetailComponent implements OnInit {
  isOpen = false;
  itemDetail = '';

  constructor(private route: ActivatedRoute) {}

  ngOnInit() {
    this.route.params.subscribe((params) => {
      // Load item details based on route param
      this.itemDetail = `Details for item: ${params['id']}`;
    });
  }
}
```

## Navigation Patterns

### Pattern 1: Mobile Navigation

Slide-out menu for mobile interfaces:

```typescript
@Component({
  selector: 'app-mobile-nav',
  imports: [AxDrawerComponent, CommonModule],
  template: `
    <header>
      <button (click)="mobileMenuOpen = true">
        <mat-icon>menu</mat-icon>
      </button>
      <h1>App</h1>
    </header>

    <ax-drawer [(open)]="mobileMenuOpen" position="left" size="sm" title="Menu">
      <nav>
        <button *ngFor="let item of navItems" (click)="navigate(item.route)" class="nav-item">
          {{ item.label }}
        </button>
      </nav>
    </ax-drawer>

    <main>
      <router-outlet></router-outlet>
    </main>
  `,
})
export class MobileNavComponent {
  mobileMenuOpen = false;
  navItems = [
    { label: 'Home', route: '/' },
    { label: 'About', route: '/about' },
    { label: 'Contact', route: '/contact' },
  ];

  constructor(private router: Router) {}

  navigate(route: string) {
    this.router.navigate([route]);
    this.mobileMenuOpen = false;
  }
}
```

### Pattern 2: Filtering Panel

Right-side filter drawer for data tables:

```typescript
@Component({
  selector: 'app-filter-drawer',
  template: `
    <div class="data-view">
      <header>
        <h1>Products</h1>
        <button (click)="filterOpen = true">Filters</button>
      </header>

      <ax-drawer [(open)]="filterOpen" position="right" size="md" title="Filter Products">
        <div class="filter-group">
          <label>Category</label>
          <select [(ngModel)]="filters.category">
            <option value="">All</option>
            <option value="electronics">Electronics</option>
            <option value="clothing">Clothing</option>
          </select>
        </div>

        <div class="filter-group">
          <label>Price Range</label>
          <input type="range" min="0" max="1000" [(ngModel)]="filters.maxPrice" />
        </div>

        <ng-template #footer>
          <button (click)="applyFilters()">Apply</button>
          <button (click)="resetFilters()">Reset</button>
        </ng-template>
      </ax-drawer>

      <div class="products">
        <!-- Product list filtered by this.filters -->
      </div>
    </div>
  `,
})
export class FilterDrawerComponent {
  filterOpen = false;
  filters = { category: '', maxPrice: 1000 };

  applyFilters() {
    this.filterOpen = false;
    // Trigger data filtering
  }

  resetFilters() {
    this.filters = { category: '', maxPrice: 1000 };
  }
}
```

### Pattern 3: Settings/Preferences

Right-side panel for user settings:

```typescript
@Component({
  selector: 'app-settings',
  template: `
    <button (click)="settingsOpen = true">Settings</button>

    <ax-drawer [(open)]="settingsOpen" position="right" size="lg" title="Settings" subtitle="Manage your preferences" icon="settings">
      <section class="settings-group">
        <h3>Display</h3>
        <label>
          <input type="checkbox" [(ngModel)]="settings.darkMode" />
          Dark Mode
        </label>
        <label>
          <select [(ngModel)]="settings.theme">
            <option>Default</option>
            <option>Ocean</option>
            <option>Forest</option>
          </select>
        </label>
      </section>

      <section class="settings-group">
        <h3>Notifications</h3>
        <label>
          <input type="checkbox" [(ngModel)]="settings.emailNotifications" />
          Email Notifications
        </label>
      </section>

      <ng-template #footer>
        <button (click)="saveSettings()">Save Changes</button>
      </ng-template>
    </ax-drawer>
  `,
})
export class SettingsComponent {
  settingsOpen = false;
  settings = {
    darkMode: false,
    theme: 'Default',
    emailNotifications: true,
  };

  saveSettings() {
    // Save to backend
    this.settingsOpen = false;
  }
}
```

### Pattern 4: Bottom Sheet (Mobile)

Bottom-sliding sheet for mobile actions:

```typescript
@Component({
  selector: 'app-bottom-sheet',
  template: `
    <button (click)="bottomSheetOpen = true">Share</button>

    <ax-drawer [(open)]="bottomSheetOpen" position="bottom" size="sm" title="Share">
      <div class="share-options">
        <button *ngFor="let option of shareOptions" (click)="share(option)">
          <mat-icon>{{ option.icon }}</mat-icon>
          <span>{{ option.label }}</span>
        </button>
      </div>
    </ax-drawer>
  `,
})
export class BottomSheetComponent {
  bottomSheetOpen = false;
  shareOptions = [
    { label: 'Share on Facebook', icon: 'facebook' },
    { label: 'Share on Twitter', icon: 'twitter' },
    { label: 'Copy Link', icon: 'content_copy' },
  ];

  share(option: any) {
    console.log('Sharing via', option.label);
    this.bottomSheetOpen = false;
  }
}
```

## Keyboard Navigation

### Escape Key

Close the drawer by pressing Escape (enabled by default):

```typescript
// Automatically handled by component
// Set closeOnEscape="false" to disable
<ax-drawer
  [(open)]="isOpen"
  [closeOnEscape]="true"
  title="Menu"
>
  Content
</ax-drawer>
```

### Tab Navigation

Tab through drawer content while it's open:

- Tab moves focus to next focusable element
- Shift+Tab moves to previous element
- Focus wraps around (first and last elements)

### Implementing Focus Trap

Trap focus within drawer to prevent tabbing out:

```typescript
import { Component, ViewChild, AfterViewInit } from '@angular/core';
import { AxDrawerComponent } from '@aegisx/ui';

@Component({
  selector: 'app-focus-trap-drawer',
  template: `
    <ax-drawer #drawer [(open)]="isOpen" title="Form">
      <form>
        <input #firstInput type="text" placeholder="First name" />
        <input type="text" placeholder="Last name" />
        <button #lastButton>Submit</button>
      </form>
    </ax-drawer>
  `,
})
export class FocusTrapDrawerComponent implements AfterViewInit {
  isOpen = false;
  @ViewChild('firstInput') firstInput!: any;
  @ViewChild('lastButton') lastButton!: any;

  ngAfterViewInit() {
    if (this.isOpen) {
      this.firstInput.nativeElement.focus();
    }
  }
}
```

## Focus Management

### Initial Focus

Set focus to the first focusable element when drawer opens:

```typescript
import { Component, ViewChild, effect } from '@angular/core';

@Component({
  selector: 'app-drawer',
  template: `
    <ax-drawer [(open)]="isOpen" title="Dialog">
      <input #firstInput type="text" placeholder="Name" />
      <button>Submit</button>
    </ax-drawer>
  `,
})
export class DrawerComponent {
  isOpen = false;
  @ViewChild('firstInput') firstInput!: any;

  constructor() {
    effect(() => {
      if (this.isOpen && this.firstInput) {
        setTimeout(() => {
          this.firstInput.nativeElement.focus();
        });
      }
    });
  }
}
```

### Returning Focus

Return focus to the trigger button when drawer closes:

```typescript
import { Component, ViewChild } from '@angular/core';

@Component({
  selector: 'app-drawer-with-restore',
  template: `
    <button #trigger (click)="isOpen = true">Open</button>

    <ax-drawer [(open)]="isOpen" title="Menu">
      <p>Menu content</p>
    </ax-drawer>
  `,
})
export class DrawerWithRestoreComponent {
  isOpen = false;
  @ViewChild('trigger') trigger!: any;

  ngOnInit() {
    this.onOpenChange();
  }

  onOpenChange() {
    if (!this.isOpen && this.trigger) {
      this.trigger.nativeElement.focus();
    }
  }
}
```

### Focus Trap Implementation

Trap focus within drawer to prevent background interaction:

```typescript
import { Component, HostListener, ViewChildren, QueryList } from '@angular/core';

@Component({
  selector: 'app-focus-trapped-drawer',
  template: `
    <ax-drawer [(open)]="isOpen" title="Form">
      <input tabindex="0" type="text" />
      <input tabindex="0" type="text" />
      <button tabindex="0">Submit</button>
    </ax-drawer>
  `,
})
export class FocusTrappedDrawerComponent {
  isOpen = false;
  @ViewChildren('input, button') focusableElements!: QueryList<any>;

  @HostListener('keydown.tab', ['$event'])
  handleTab(event: KeyboardEvent) {
    if (!this.isOpen || this.focusableElements.length === 0) return;

    const elements = this.focusableElements.toArray();
    const focusedIndex = elements.findIndex((el) => el.nativeElement === document.activeElement);

    let nextIndex = focusedIndex + 1;
    if (event.shiftKey) {
      nextIndex = focusedIndex - 1;
    }

    // Wrap around
    nextIndex = (nextIndex + elements.length) % elements.length;

    event.preventDefault();
    elements[nextIndex].nativeElement.focus();
  }
}
```

## ARIA Navigation Landmarks

### Drawer as Navigation Region

Mark drawer as a navigation landmark:

```typescript
@Component({
  selector: 'app-nav-drawer',
  template: `
    <ax-drawer [(open)]="isOpen" position="left" title="Navigation" role="navigation" [attr.aria-label]="'Main Navigation'">
      <nav>
        <a href="/dashboard">Dashboard</a>
        <a href="/projects">Projects</a>
      </nav>
    </ax-drawer>
  `,
})
export class NavDrawerComponent {
  isOpen = false;
}
```

### ARIA Labels and Descriptions

Use ARIA attributes to describe drawer purpose:

```typescript
<ax-drawer
  [(open)]="isOpen"
  title="Filters"
  [attr.aria-label]="'Product Filters'"
  [attr.aria-describedby]="'filter-description'"
  role="region"
>
  <p id="filter-description">Select filters to narrow product results</p>
  <!-- Filter controls -->
</ax-drawer>
```

### Modal Role

For drawers that block interaction with background:

```typescript
<ax-drawer
  [(open)]="isOpen"
  [attr.role]="'dialog'"
  [attr.aria-modal]="'true'"
  [attr.aria-label]="'Confirmation Dialog'"
>
  <p>Are you sure?</p>
  <button (click)="confirm()">Yes</button>
  <button (click)="cancel()">No</button>
</ax-drawer>
```

### Accessibility Best Practices

```typescript
@Component({
  selector: 'app-accessible-drawer',
  template: `
    <!-- Trigger button with aria-controls -->
    <button (click)="isOpen = true" [attr.aria-controls]="'filter-drawer'" [attr.aria-expanded]="isOpen">
      <mat-icon>filter_alt</mat-icon>
      <span class="sr-only">Open filters</span>
    </button>

    <!-- Drawer with proper ARIA attributes -->
    <ax-drawer [(open)]="isOpen" id="filter-drawer" role="region" [attr.aria-label]="'Filter Options'" [attr.aria-live]="'polite'">
      <form>
        <fieldset>
          <legend>Filter by Category</legend>
          <input type="checkbox" id="cat1" />
          <label for="cat1">Electronics</label>
        </fieldset>
      </form>
    </ax-drawer>
  `,
})
export class AccessibleDrawerComponent {
  isOpen = false;
}
```

## Styling & Theming

### CSS Variables

The drawer uses design tokens for all styling:

```css
/* Drawer styling variables */
--ax-background-default    /* Drawer background */
--ax-border-default        /* Divider lines */
--ax-text-heading          /* Title text color */
--ax-text-secondary        /* Subtitle/secondary text */
--ax-shadow-xl             /* Drawer shadow */
--ax-radius-xl             /* Border radius (bottom only) */
```

### Position-Specific Styling

```css
/* Left drawer */
.ax-drawer-left {
  left: 0;
  border-right: 1px solid var(--ax-border-default);
}

/* Right drawer */
.ax-drawer-right {
  right: 0;
  border-left: 1px solid var(--ax-border-default);
}

/* Top drawer */
.ax-drawer-top {
  top: 0;
  border-bottom: 1px solid var(--ax-border-default);
}

/* Bottom drawer */
.ax-drawer-bottom {
  bottom: 0;
  border-top: 1px solid var(--ax-border-default);
  border-radius: var(--ax-radius-xl) var(--ax-radius-xl) 0 0;
}
```

### Size Variants

```css
/* Horizontal sizes */
.ax-drawer-sm {
  width: 320px;
}
.ax-drawer-md {
  width: 400px;
}
.ax-drawer-lg {
  width: 500px;
}
.ax-drawer-xl {
  width: 640px;
}
.ax-drawer-full {
  width: 100%;
}

/* Vertical sizes */
.ax-drawer-sm {
  height: 200px;
}
.ax-drawer-md {
  height: 320px;
}
.ax-drawer-lg {
  height: 480px;
}
.ax-drawer-xl {
  height: 640px;
}
.ax-drawer-full {
  height: 100%;
}
```

### Custom Styling

Override default styles:

```typescript
@Component({
  selector: 'app-custom-drawer',
  template: ` <ax-drawer [(open)]="isOpen" title="Custom" class="custom-drawer"> Content </ax-drawer> `,
  styles: [
    `
      ::ng-deep .custom-drawer {
        --ax-background-default: #f8f9fa;
        --ax-border-default: #dee2e6;
      }

      ::ng-deep .custom-drawer .ax-drawer-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
      }

      ::ng-deep .custom-drawer .ax-drawer-title {
        color: white;
        font-weight: 700;
      }
    `,
  ],
})
export class CustomDrawerComponent {
  isOpen = false;
}
```

### Dark Mode Support

Dark mode is automatically applied via CSS variables:

```typescript
// When .dark class is applied to root:

:root.dark {
  --ax-background-default: #1f2937;
  --ax-border-default: #374151;
  --ax-text-heading: #f9fafb;
  --ax-text-secondary: #9ca3af;
}
```

## Animation & Transitions

### Slide Animation

The component includes smooth slide animations:

```typescript
// Left position
transition('void => left', [style({ transform: 'translateX(-100%)' }), animate('300ms cubic-bezier(0.4, 0, 0.2, 1)', style({ transform: 'translateX(0)' }))]);

// Backdrop fade
transition(':enter', [style({ opacity: 0 }), animate('200ms ease-out', style({ opacity: 1 }))]);
```

### Custom Animation Timing

To customize animation timing, use component binding:

```typescript
@Component({
  selector: 'app-custom-animation-drawer',
  template: ` <ax-drawer [(open)]="isOpen" title="Menu" [@slidePanel]="isOpen ? 'left' : 'void'"> Content </ax-drawer> `,
  animations: [trigger('slidePanel', [transition('void => left', [style({ transform: 'translateX(-100%)' }), animate('500ms ease-in-out', style({ transform: 'translateX(0)' }))]), transition('left => void', [animate('300ms ease-in', style({ transform: 'translateX(-100%)' }))])])],
})
export class CustomAnimationComponent {
  isOpen = false;
}
```

## Advanced Usage

### Stacked Drawers

Open multiple drawers stacked on top of each other:

```typescript
@Component({
  selector: 'app-stacked-drawers',
  template: `
    <button (click)="drawer1Open = true">Open First</button>

    <ax-drawer [(open)]="drawer1Open" title="First Drawer">
      <p>First drawer content</p>
      <button (click)="drawer2Open = true">Open Second</button>
    </ax-drawer>

    <ax-drawer [(open)]="drawer2Open" title="Second Drawer">
      <p>Second drawer content</p>
    </ax-drawer>
  `,
})
export class StackedDrawersComponent {
  drawer1Open = false;
  drawer2Open = false;
}
```

### Animated Content

Animate content within the drawer:

```typescript
@Component({
  selector: 'app-drawer-animation',
  template: `
    <ax-drawer [(open)]="isOpen" title="Animated Content">
      <div [@fadeIn]="isOpen">
        <p>This content fades in when drawer opens</p>
      </div>
    </ax-drawer>
  `,
  animations: [trigger('fadeIn', [transition(':enter', [style({ opacity: 0 }), animate('300ms', style({ opacity: 1 }))])])],
})
export class DrawerAnimationComponent {
  isOpen = false;
}
```

### Drawer with Forms

Complex forms within drawer:

```typescript
@Component({
  selector: 'app-form-drawer',
  template: `
    <button (click)="isOpen = true">New Item</button>

    <ax-drawer [(open)]="isOpen" title="Create Item">
      <form [formGroup]="form">
        <input formControlName="name" placeholder="Name" />
        <textarea formControlName="description"></textarea>
        <select formControlName="category">
          <option value="">Select...</option>
          <option value="cat1">Category 1</option>
        </select>
      </form>

      <ng-template #footer>
        <button (click)="cancel()">Cancel</button>
        <button (click)="submit()" [disabled]="!form.valid">Create</button>
      </ng-template>
    </ax-drawer>
  `,
})
export class FormDrawerComponent {
  isOpen = false;
  form = new FormGroup({
    name: new FormControl('', Validators.required),
    description: new FormControl(''),
    category: new FormControl(''),
  });

  submit() {
    if (this.form.valid) {
      // Handle submission
      this.isOpen = false;
    }
  }

  cancel() {
    this.form.reset();
    this.isOpen = false;
  }
}
```

## Responsive Behavior

### Mobile Adaptation

On mobile devices, drawers automatically adjust:

```css
@media (max-width: 640px) {
  .ax-drawer-left,
  .ax-drawer-right {
    &.ax-drawer-sm,
    &.ax-drawer-md,
    &.ax-drawer-lg,
    &.ax-drawer-xl {
      width: 100%; /* Full width on mobile */
    }
  }
}
```

### Responsive Drawer Selection

Choose drawer size based on screen size:

```typescript
import { BreakpointObserver } from '@angular/cdk/layout';

@Component({
  selector: 'app-responsive-drawer',
  template: `
    <button (click)="isOpen = true">Menu</button>
    <ax-drawer [(open)]="isOpen" [size]="isMobile ? 'full' : 'md'" position="right" title="Menu"> Content </ax-drawer>
  `,
})
export class ResponsiveDrawerComponent {
  isOpen = false;
  isMobile = false;

  constructor(breakpoints: BreakpointObserver) {
    breakpoints.observe('(max-width: 768px)').subscribe((result) => {
      this.isMobile = result.matches;
    });
  }
}
```

## Related Components

- **[Navigation Component](./navigation.md)** - Standalone navigation menu
- **[Launcher Component](./launcher.md)** - Application launcher interface

## Browser Support

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## Accessibility Checklist

- [x] Semantic HTML (`role="dialog"` when appropriate)
- [x] Keyboard navigation (Escape to close, Tab through items)
- [x] Focus management (trap focus, restore focus)
- [x] ARIA landmarks (`aria-label`, `aria-modal`)
- [x] Screen reader support
- [x] Color contrast (meets WCAG AA)
- [x] Animation reduced preference support
- [x] Backdrop click handling

## Performance Tips

1. **Lazy Load Content** - Load drawer content on open
2. **Unsubscribe** - Clean up subscriptions in ngOnDestroy
3. **ChangeDetection** - Use OnPush when possible
4. **Animation Performance** - Use `will-change` CSS for smooth animations
5. **Form Validation** - Validate on blur instead of every keystroke
