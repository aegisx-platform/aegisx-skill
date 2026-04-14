# Navigation Component

## Overview

The `ax-navigation` component provides a flexible, recursive navigation menu system that integrates seamlessly with Angular Router. It supports vertical and horizontal layouts, multiple appearance modes, and dynamic content rendering including groups, dividers, and badge indicators.

**Key Features:**

- Angular Router integration with `routerLink` and `routerLinkActive`
- Recursive group support for nested navigation structures
- Multiple appearance modes (default, compact, dense)
- Dynamic badge support for notifications and indicators
- Material Design icons
- Flexible layout options (vertical/horizontal)

**Use Cases:**

- Application sidebars and navigation menus
- Main navigation bars
- Breadcrumb-like navigation structures
- Hierarchical menu systems
- Tabbed navigation interfaces

## Installation & Import

```typescript
import { AegisxNavigationComponent } from '@aegisx/ui';
```

The component is standalone and can be imported directly into your component or module:

```typescript
import { Component } from '@angular/core';
import { AegisxNavigationComponent } from '@aegisx/ui';
import { AxNavigationItem } from '@aegisx/ui/types';

@Component({
  selector: 'app-sidebar',
  imports: [AegisxNavigationComponent],
  template: ` <ax-navigation [navigation]="navItems" layout="vertical" appearance="default"></ax-navigation> `,
})
export class SidebarComponent {
  navItems: AxNavigationItem[] = [
    // Navigation items configuration
  ];
}
```

## Basic Usage

### Simple Navigation Menu

```typescript
import { Component } from '@angular/core';
import { AegisxNavigationComponent } from '@aegisx/ui';
import { AxNavigationItem } from '@aegisx/ui/types';

@Component({
  selector: 'app-main-nav',
  imports: [AegisxNavigationComponent],
  template: ` <ax-navigation [navigation]="menuItems"></ax-navigation> `,
})
export class MainNavComponent {
  menuItems: AxNavigationItem[] = [
    {
      id: 'dashboard',
      title: 'Dashboard',
      icon: 'dashboard',
      link: '/dashboard',
    },
    {
      id: 'projects',
      title: 'Projects',
      icon: 'folder',
      link: '/projects',
    },
    {
      id: 'settings',
      title: 'Settings',
      icon: 'settings',
      link: '/settings',
    },
  ];
}
```

### Navigation with Groups

Create hierarchical navigation structures with collapsible groups:

```typescript
menuItems: AxNavigationItem[] = [
  {
    id: 'main',
    title: 'Main Navigation',
    type: 'group',
    children: [
      {
        id: 'dashboard',
        title: 'Dashboard',
        icon: 'dashboard',
        link: '/dashboard'
      }
    ]
  },
  {
    id: 'admin',
    title: 'Administration',
    type: 'group',
    children: [
      {
        id: 'users',
        title: 'Users',
        icon: 'people',
        link: '/admin/users'
      },
      {
        id: 'roles',
        title: 'Roles',
        icon: 'security',
        link: '/admin/roles'
      }
    ]
  }
];
```

### Navigation with Badges

Add notification badges and status indicators:

```typescript
menuItems: AxNavigationItem[] = [
  {
    id: 'inbox',
    title: 'Inbox',
    icon: 'mail',
    link: '/inbox',
    badge: {
      content: '5',
      type: 'warn'
    }
  },
  {
    id: 'notifications',
    title: 'Notifications',
    icon: 'notifications',
    link: '/notifications',
    badge: {
      content: '12',
      type: 'info'
    }
  }
];
```

## API Reference

### Inputs

| Name         | Type                                | Default      | Description                               |
| ------------ | ----------------------------------- | ------------ | ----------------------------------------- |
| `navigation` | `AxNavigationItem[]`                | `[]`         | Array of navigation items to display      |
| `layout`     | `'vertical' \| 'horizontal'`        | `'vertical'` | Layout direction for the navigation menu  |
| `appearance` | `'default' \| 'compact' \| 'dense'` | `'default'`  | Visual appearance style of the navigation |

### Navigation Item Structure (AxNavigationItem)

| Property       | Type                                         | Required | Description                                                     |
| -------------- | -------------------------------------------- | -------- | --------------------------------------------------------------- |
| `id`           | `string`                                     | Yes      | Unique identifier for the navigation item                       |
| `title`        | `string`                                     | Yes      | Display text for the navigation item                            |
| `type`         | `'item' \| 'group' \| 'divider' \| 'spacer'` | No       | Item type determining rendering behavior                        |
| `icon`         | `string`                                     | No       | Material icon name                                              |
| `link`         | `string \| string[]`                         | No       | Router link for navigation (string or array for complex routes) |
| `children`     | `AxNavigationItem[]`                         | No       | Child items for groups                                          |
| `badge`        | `AxNavigationBadge`                          | No       | Badge configuration for indicators                              |
| `disabled`     | `boolean \| () => boolean`                   | No       | Disable the navigation item                                     |
| `hidden`       | `boolean \| () => boolean`                   | No       | Hide the navigation item                                        |
| `active`       | `boolean \| () => boolean`                   | No       | Mark as active                                                  |
| `exactMatch`   | `boolean`                                    | No       | Require exact URL match for active state                        |
| `externalLink` | `boolean`                                    | No       | Treat link as external URL                                      |
| `target`       | `'_blank' \| '_self' \| '_parent' \| '_top'` | No       | Link target attribute                                           |
| `permissions`  | `string[]`                                   | No       | RBAC permissions required (OR logic)                            |
| `classes`      | `string`                                     | No       | Custom CSS classes                                              |
| `meta`         | `Record<string, unknown>`                    | No       | Custom metadata                                                 |

### Badge Configuration (AxNavigationBadge)

| Property  | Type                                                     | Description                    |
| --------- | -------------------------------------------------------- | ------------------------------ |
| `content` | `string`                                                 | Badge text or number           |
| `type`    | `'primary' \| 'accent' \| 'warn' \| 'success' \| 'info'` | Badge color type               |
| `classes` | `string`                                                 | Custom CSS classes for styling |

## Angular Router Integration

### RouterLink Setup

The navigation component integrates directly with Angular Router using `routerLink` and `routerLinkActive`:

```typescript
import { Component } from '@angular/core';
import { RouterModule } from '@angular/router';
import { AegisxNavigationComponent } from '@aegisx/ui';
import { AxNavigationItem } from '@aegisx/ui/types';

@Component({
  selector: 'app-layout',
  imports: [RouterModule, AegisxNavigationComponent],
  template: `
    <div class="layout">
      <aside class="sidebar">
        <ax-navigation [navigation]="navItems"></ax-navigation>
      </aside>
      <main class="content">
        <router-outlet></router-outlet>
      </main>
    </div>
  `,
})
export class LayoutComponent {
  navItems: AxNavigationItem[] = [
    {
      id: 'dashboard',
      title: 'Dashboard',
      icon: 'dashboard',
      link: '/dashboard',
      exactMatch: true,
    },
    {
      id: 'projects',
      title: 'Projects',
      icon: 'folder',
      link: '/projects',
    },
  ];
}
```

### Active Route Detection

The component automatically applies the `.active` class to items matching the current route:

```typescript
// Navigation item with exact match
{
  id: 'dashboard',
  title: 'Dashboard',
  link: '/dashboard',
  exactMatch: true  // Only active when route is exactly /dashboard
}

// Navigation item with partial match
{
  id: 'projects',
  title: 'Projects',
  link: '/projects',
  exactMatch: false  // Active for /projects and /projects/123
}
```

The `.active` CSS class is applied automatically by the component when the current route matches the link.

### Complex Route Arrays

For routes with parameters or complex navigation:

```typescript
{
  id: 'user-profile',
  title: 'Profile',
  icon: 'person',
  link: ['/users', userId, 'profile']
}

{
  id: 'project-details',
  title: 'Project Details',
  icon: 'info',
  link: ['/projects', projectId, 'details']
}
```

### External Links

Navigate to external URLs:

```typescript
{
  id: 'github',
  title: 'GitHub',
  icon: 'github',
  link: 'https://github.com/aegisx/aegisx-ui',
  externalLink: true,
  target: '_blank'
}
```

## Navigation Patterns for Different App Structures

### Pattern 1: Single-Level Navigation (Flat)

Best for simple applications with few sections:

```typescript
navItems: AxNavigationItem[] = [
  { id: 'home', title: 'Home', icon: 'home', link: '/' },
  { id: 'about', title: 'About', icon: 'info', link: '/about' },
  { id: 'contact', title: 'Contact', icon: 'mail', link: '/contact' }
];
```

**Use Case:** Marketing websites, documentation sites, simple apps

### Pattern 2: Grouped Navigation (Hierarchical)

Organize related items into groups:

```typescript
navItems: AxNavigationItem[] = [
  {
    id: 'core',
    title: 'Core',
    type: 'group',
    children: [
      { id: 'dashboard', title: 'Dashboard', icon: 'dashboard', link: '/dashboard' }
    ]
  },
  {
    id: 'management',
    title: 'Management',
    type: 'group',
    children: [
      { id: 'users', title: 'Users', icon: 'people', link: '/users' },
      { id: 'roles', title: 'Roles', icon: 'security', link: '/roles' }
    ]
  }
];
```

**Use Case:** Enterprise applications, admin dashboards, content management systems

### Pattern 3: Multi-Level Navigation (Nested Groups)

Deep nesting for complex applications:

```typescript
navItems: AxNavigationItem[] = [
  {
    id: 'admin',
    title: 'Administration',
    type: 'group',
    children: [
      {
        id: 'user-mgmt',
        title: 'User Management',
        type: 'group',
        children: [
          { id: 'users', title: 'Users', link: '/admin/users' },
          { id: 'roles', title: 'Roles', link: '/admin/roles' },
          { id: 'permissions', title: 'Permissions', link: '/admin/permissions' }
        ]
      },
      {
        id: 'system',
        title: 'System',
        type: 'group',
        children: [
          { id: 'settings', title: 'Settings', link: '/admin/settings' },
          { id: 'audit', title: 'Audit Logs', link: '/admin/audit' }
        ]
      }
    ]
  }
];
```

**Use Case:** Large-scale enterprise applications, complex admin panels

### Pattern 4: Dynamic Navigation (Data-Driven)

Load navigation from API or configuration:

```typescript
import { Component, OnInit } from '@angular/core';
import { AxNavigationItem } from '@aegisx/ui/types';

@Component({
  selector: 'app-nav',
  template: `<ax-navigation [navigation]="navItems"></ax-navigation>`,
})
export class NavComponent implements OnInit {
  navItems: AxNavigationItem[] = [];

  constructor(private navService: NavigationService) {}

  ngOnInit() {
    this.navService.getNavigation().subscribe((items) => {
      this.navItems = items;
    });
  }
}
```

**Use Case:** RBAC-driven navigation, multi-tenant applications, configurable interfaces

### Pattern 5: Conditional Navigation (Permission-Based)

Show/hide items based on user permissions:

```typescript
navItems: AxNavigationItem[] = [
  {
    id: 'dashboard',
    title: 'Dashboard',
    icon: 'dashboard',
    link: '/dashboard'
  },
  {
    id: 'admin',
    title: 'Administration',
    icon: 'settings',
    link: '/admin',
    hidden: !this.authService.hasPermission('admin')
  },
  {
    id: 'audit',
    title: 'Audit Logs',
    icon: 'history',
    link: '/admin/audit',
    hidden: () => !this.authService.hasPermission('audit.view')
  }
];
```

**Use Case:** Permission-based UIs, role-based dashboards, secure applications

## Keyboard Navigation

### Tab Navigation

Users can tab through navigation items:

- Tab moves focus to the next item
- Shift+Tab moves to the previous item
- Focus is visually indicated

### Enter/Space Keys

When a navigation item has focus:

- Pressing Enter activates the link
- Pressing Space also activates the link

### Implementation

The component uses standard HTML `<a>` elements with `routerLink`, which automatically support keyboard navigation:

```typescript
// Keyboard-accessible navigation structure
{
  id: 'dashboard',
  title: 'Dashboard',
  icon: 'dashboard',
  link: '/dashboard'
  // Component renders as: <a routerLink="/dashboard" ...>Dashboard</a>
}
```

### Custom Keyboard Shortcuts

Implement keyboard shortcuts for navigation:

```typescript
import { Component, HostListener } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-layout',
})
export class LayoutComponent {
  constructor(private router: Router) {}

  @HostListener('document:keydown', ['$event'])
  handleKeyboardEvent(event: KeyboardEvent) {
    // Ctrl+D or Cmd+D for Dashboard
    if ((event.ctrlKey || event.metaKey) && event.key === 'd') {
      event.preventDefault();
      this.router.navigate(['/dashboard']);
    }

    // Ctrl+U or Cmd+U for Users
    if ((event.ctrlKey || event.metaKey) && event.key === 'u') {
      event.preventDefault();
      this.router.navigate(['/admin/users']);
    }
  }
}
```

## Focus Management

### Initial Focus

Set initial focus to the first navigable item when the sidebar opens:

```typescript
import { Component, ViewChild, AfterViewInit } from '@angular/core';

@Component({
  selector: 'app-nav',
  template: `<ax-navigation #nav [navigation]="navItems"></ax-navigation>`,
})
export class NavComponent implements AfterViewInit {
  @ViewChild('nav') nav!: any;

  ngAfterViewInit() {
    // Focus first navigation item
    const firstLink = document.querySelector('ax-navigation a');
    (firstLink as HTMLElement)?.focus();
  }

  navItems: AxNavigationItem[] = [];
}
```

### Returning Focus

When closing a navigation drawer, return focus to the trigger button:

```typescript
import { Component } from '@angular/core';

@Component({
  selector: 'app-layout',
  template: `
    <button #navToggle (click)="toggleNav()">Menu</button>
    <ax-navigation *ngIf="navOpen" [navigation]="navItems"></ax-navigation>
  `,
})
export class LayoutComponent {
  navOpen = false;
  @ViewChild('navToggle') toggleButton!: any;

  toggleNav() {
    this.navOpen = !this.navOpen;
    if (!this.navOpen) {
      // Return focus to toggle button when closing
      this.toggleButton.nativeElement.focus();
    }
  }

  navItems: AxNavigationItem[] = [];
}
```

### Focus Trap

For modal navigation (drawers, modals), trap focus within the navigation:

```typescript
import { Component, HostListener } from '@angular/core';

@Component({
  selector: 'app-nav-drawer',
  template: `
    <div class="drawer" [@slidePanel]="isOpen" role="navigation">
      <ax-navigation [navigation]="navItems"></ax-navigation>
    </div>
  `,
})
export class NavDrawerComponent {
  isOpen = false;

  @HostListener('document:keydown.tab', ['$event'])
  handleTabKey(event: KeyboardEvent) {
    if (!this.isOpen) return;

    const focusableElements = Array.from(document.querySelectorAll('ax-navigation a')) as HTMLElement[];

    if (focusableElements.length === 0) return;

    const currentIndex = focusableElements.indexOf(document.activeElement as HTMLElement);
    let nextIndex = currentIndex + 1;

    if (event.shiftKey) {
      nextIndex = currentIndex - 1;
    }

    // Wrap around
    nextIndex = (nextIndex + focusableElements.length) % focusableElements.length;

    event.preventDefault();
    focusableElements[nextIndex].focus();
  }
}
```

## ARIA Navigation Landmarks

### Navigation Landmark

Wrap the navigation component in a `<nav>` element with appropriate ARIA attributes:

```typescript
@Component({
  selector: 'app-sidebar',
  template: `
    <nav class="sidebar" aria-label="Main navigation">
      <ax-navigation [navigation]="navItems"></ax-navigation>
    </nav>
  `,
})
export class SidebarComponent {
  navItems: AxNavigationItem[] = [];
}
```

### Navigation with Multiple Areas

For multiple navigation regions, use distinct labels:

```typescript
<nav class="primary-nav" aria-label="Primary navigation">
  <ax-navigation [navigation]="primaryItems"></ax-navigation>
</nav>

<nav class="secondary-nav" aria-label="Secondary navigation">
  <ax-navigation [navigation]="secondaryItems"></ax-navigation>
</nav>

<nav class="footer-nav" aria-label="Footer navigation">
  <ax-navigation [navigation]="footerItems"></ax-navigation>
</nav>
```

### List Semantics

The component should use semantic list structure for screen readers:

```typescript
// Rendered structure should be:
<nav>
  <ul class="ax-navigation">
    <li><a>Item 1</a></li>
    <li><a>Item 2</a></li>
    <li>
      <span class="group-title">Group</span>
      <ul>
        <li><a>Nested Item 1</a></li>
        <li><a>Nested Item 2</a></li>
      </ul>
    </li>
  </ul>
</nav>
```

### ARIA Properties

| Property              | Purpose                        | Example                                   |
| --------------------- | ------------------------------ | ----------------------------------------- |
| `aria-label`          | Describe navigation purpose    | `aria-label="Main navigation"`            |
| `aria-current="page"` | Mark currently active page     | Applied automatically by routerLinkActive |
| `aria-disabled`       | Indicate disabled items        | Applied when item.disabled is true        |
| `aria-expanded`       | Indicate group expansion state | For collapsible groups                    |
| `aria-controls`       | Link button to content         | When drawer controls main content         |

### Accessible Navigation Implementation

```typescript
@Component({
  selector: 'app-layout',
  template: `
    <button #navToggle (click)="toggleDrawer()" aria-controls="nav-drawer" [attr.aria-expanded]="isDrawerOpen">
      <mat-icon>menu</mat-icon>
      <span class="sr-only">Toggle navigation</span>
    </button>

    <nav id="nav-drawer" aria-label="Main navigation" [class.open]="isDrawerOpen">
      <ax-navigation [navigation]="navItems"></ax-navigation>
    </nav>

    <main>
      <router-outlet></router-outlet>
    </main>
  `,
})
export class AppLayoutComponent {
  isDrawerOpen = false;
  navItems: AxNavigationItem[] = [];

  toggleDrawer() {
    this.isDrawerOpen = !this.isDrawerOpen;
  }
}
```

## Styling & Theming

### CSS Variables

The component uses design tokens for styling:

```css
/* Navigation styling variables */
--ax-spacing-sm       /* Item padding */
--ax-spacing-md       /* Item margins */
--ax-text-primary     /* Text color */
--ax-text-secondary   /* Secondary text */
--ax-background-hover /* Hover background */
--ax-primary-faint    /* Active background */
--ax-primary-emphasis /* Active text color */
--ax-border-default   /* Divider color */
--ax-radius-md        /* Border radius */
--ax-transition-fast  /* Transition timing */
```

### Appearance Modes

#### Default Appearance

Full-featured navigation with icons and text:

```css
.ax-navigation {
  padding: var(--ax-spacing-sm) 0;
}

.ax-nav-item {
  display: flex;
  align-items: center;
  padding: var(--ax-spacing-sm) var(--ax-spacing-md);
  margin: 0 var(--ax-spacing-sm);
  border-radius: var(--ax-radius-md);
}

.ax-nav-item-icon {
  margin-right: var(--ax-spacing-sm);
}

.ax-nav-item-title {
  flex: 1;
}

.ax-nav-item.active {
  background-color: var(--ax-primary-faint);
  color: var(--ax-primary-emphasis);
}
```

#### Compact Appearance

Icon-only navigation with centered alignment:

```typescript
<ax-navigation
  [navigation]="navItems"
  appearance="compact"
></ax-navigation>
```

```css
.ax-navigation-compact .ax-nav-item {
  justify-content: center;
  padding: var(--ax-spacing-sm);
}

.ax-navigation-compact .ax-nav-item-icon {
  margin-right: 0;
}

.ax-navigation-compact .ax-nav-item-title {
  display: none;
}

.ax-navigation-compact .ax-nav-item-badge {
  position: absolute;
  top: var(--ax-spacing-xs);
  right: var(--ax-spacing-xs);
}
```

**Use Case:** Sidebar navigation that collapses to icon-only view

#### Dense Appearance

Compact spacing for small screens or information-dense layouts:

```typescript
<ax-navigation
  [navigation]="navItems"
  appearance="dense"
></ax-navigation>
```

### Custom Styling

Override default styles with custom CSS:

```typescript
@Component({
  selector: 'app-custom-nav',
  template: ` <ax-navigation [navigation]="navItems" class="custom-nav"></ax-navigation> `,
  styles: [
    `
      ::ng-deep .custom-nav .ax-nav-item {
        border-left: 3px solid transparent;
        padding-left: calc(var(--ax-spacing-md) - 3px);
      }

      ::ng-deep .custom-nav .ax-nav-item.active {
        border-left-color: var(--ax-primary-emphasis);
        background-color: transparent;
      }

      ::ng-deep .custom-nav .ax-nav-item:hover {
        background-color: transparent;
        color: var(--ax-primary-emphasis);
      }
    `,
  ],
})
export class CustomNavComponent {
  navItems: AxNavigationItem[] = [];
}
```

### Dark Mode

The component automatically supports dark mode through CSS variables:

```typescript
// Dark mode is applied via CSS custom properties
// When .dark class is applied to root element:

:root.dark {
  --ax-text-primary: #f9fafb;
  --ax-background-hover: #374151;
  --ax-primary-faint: #1e3a5f;
  --ax-primary-emphasis: #60a5fa;
}
```

## Advanced Usage

### Dynamic Navigation Updates

Update navigation items reactively:

```typescript
import { Component, signal } from '@angular/core';

@Component({
  selector: 'app-dynamic-nav',
  template: `
    <ax-navigation [navigation]="navItems()"></ax-navigation>
    <button (click)="addItem()">Add Item</button>
  `,
})
export class DynamicNavComponent {
  navItems = signal<AxNavigationItem[]>([{ id: 'home', title: 'Home', link: '/' }]);

  addItem() {
    this.navItems.update((items) => [
      ...items,
      {
        id: `item-${Date.now()}`,
        title: `New Item`,
        icon: 'add',
        link: '/new',
      },
    ]);
  }
}
```

### Programmatic Navigation

Combine navigation component with programmatic routing:

```typescript
import { Component } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-nav-with-logic',
  template: ` <ax-navigation [navigation]="navItems" (itemClick)="onItemClick($event)"></ax-navigation> `,
})
export class NavWithLogicComponent {
  constructor(private router: Router) {}

  navItems: AxNavigationItem[] = [];

  onItemClick(item: AxNavigationItem) {
    if (item.link) {
      this.router.navigate([item.link]);
    }
  }
}
```

## Related Components

- **[Drawer Component](../drawer.md)** - Slide-out navigation panel
- **[Launcher Component](../launcher.md)** - Application launcher with navigation
- **Navbar Component** - Horizontal navigation bar

## Examples

### Complete Application Layout

```typescript
import { Component } from '@angular/core';
import { RouterModule } from '@angular/router';
import { AegisxNavigationComponent } from '@aegisx/ui';
import { AxNavigationItem } from '@aegisx/ui/types';

@Component({
  selector: 'app-root',
  imports: [RouterModule, AegisxNavigationComponent],
  template: `
    <div class="app-layout">
      <aside class="sidebar">
        <div class="logo">AegisX</div>
        <ax-navigation [navigation]="mainNav"></ax-navigation>
      </aside>

      <main class="content">
        <header class="top-bar">
          <h1>{{ pageTitle }}</h1>
        </header>
        <router-outlet></router-outlet>
      </main>
    </div>
  `,
  styles: [
    `
      .app-layout {
        display: grid;
        grid-template-columns: 250px 1fr;
        height: 100vh;
      }

      .sidebar {
        background: var(--ax-background-default);
        border-right: 1px solid var(--ax-border-default);
        overflow-y: auto;
      }

      .logo {
        padding: 1rem;
        font-weight: 600;
        font-size: 1.25rem;
      }

      .content {
        display: flex;
        flex-direction: column;
      }

      .top-bar {
        padding: 1rem 1.5rem;
        border-bottom: 1px solid var(--ax-border-default);
      }
    `,
  ],
})
export class AppComponent {
  pageTitle = 'Dashboard';

  mainNav: AxNavigationItem[] = [
    {
      id: 'dashboard',
      title: 'Dashboard',
      icon: 'dashboard',
      link: '/dashboard',
      exactMatch: true,
    },
    {
      id: 'projects',
      title: 'Projects',
      icon: 'folder',
      link: '/projects',
    },
    { id: 'divider1', type: 'divider' },
    {
      id: 'admin',
      title: 'Administration',
      type: 'group',
      children: [
        {
          id: 'users',
          title: 'Users',
          icon: 'people',
          link: '/admin/users',
        },
        {
          id: 'roles',
          title: 'Roles',
          icon: 'security',
          link: '/admin/roles',
        },
        {
          id: 'settings',
          title: 'Settings',
          icon: 'settings',
          link: '/admin/settings',
        },
      ],
    },
    { id: 'spacer1', type: 'spacer' },
    {
      id: 'help',
      title: 'Help',
      icon: 'help',
      link: '/help',
    },
  ];
}
```

## Browser Support

The component supports all modern browsers:

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## Accessibility Checklist

- [x] Semantic HTML (`<a>` for links, `<nav>` for regions)
- [x] Keyboard navigation (Tab, Enter, Space)
- [x] ARIA landmarks (`aria-label` on navigation)
- [x] Focus management (visible focus indicators)
- [x] Screen reader support (semantic structure)
- [x] Color contrast (meets WCAG AA standards)
- [x] Active state indication (visual + semantic)
- [x] Disabled state accessibility (aria-disabled)

## Performance Tips

1. **Lazy Load Navigation** - Load navigation items only when needed
2. **Memoize Computations** - Use signals for reactive updates
3. **Limit Nesting Depth** - Keep groups 3-4 levels maximum
4. **Use trackBy** - For `*ngFor` loops with large item lists
5. **Unsubscribe** - Clean up subscriptions in component destruction
