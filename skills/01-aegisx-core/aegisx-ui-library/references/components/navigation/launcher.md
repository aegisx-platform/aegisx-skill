# Launcher Component

## Overview

The `ax-launcher` component provides a comprehensive application launcher and dashboard with advanced features for discovering and accessing applications. It supports grid/list views, categories, favorites, pinned apps, recent history, and draggable layout customization.

**Key Features:**

- Flexible grid and list view modes
- Category-based organization with tabs
- Favorites and pinned applications
- Recently used app tracking
- Draggable app repositioning (edit mode)
- Search with keyboard shortcut (Cmd+K / Ctrl+K)
- Role-based access control (RBAC)
- Responsive design
- Notification badges
- Featured apps section
- localStorage persistence

**Use Cases:**

- Application launcher dashboards
- App store interfaces
- Desktop-like environments
- Navigation hubs for microservices
- Enterprise application portals
- Business process launchers

## Installation & Import

```typescript
import { AxLauncherComponent } from '@aegisx/ui';
```

The component is standalone and can be imported directly:

```typescript
import { Component } from '@angular/core';
import { AxLauncherComponent } from '@aegisx/ui';
import { LauncherApp, LauncherCategory } from '@aegisx/ui/types';

@Component({
  selector: 'app-launcher',
  imports: [AxLauncherComponent],
  template: ` <ax-launcher [apps]="applications" [categories]="categories" [userContext]="currentUser"></ax-launcher> `,
})
export class LauncherPageComponent {
  applications: LauncherApp[] = [];
  categories: LauncherCategory[] = [];
  currentUser = { roles: ['user'], permissions: [] };
}
```

## Basic Usage

### Simple Application Grid

```typescript
import { Component } from '@angular/core';
import { AxLauncherComponent } from '@aegisx/ui';

@Component({
  selector: 'app-simple-launcher',
  imports: [AxLauncherComponent],
  template: ` <ax-launcher [apps]="apps" title="Applications" subtitle="Choose an application to get started"></ax-launcher> `,
})
export class SimpleLauncherComponent {
  apps = [
    {
      id: 'dashboard',
      name: 'Dashboard',
      description: 'View your dashboard',
      icon: 'dashboard',
      route: '/dashboard',
      order: 1,
    },
    {
      id: 'projects',
      name: 'Projects',
      description: 'Manage projects',
      icon: 'folder',
      route: '/projects',
      order: 2,
    },
    {
      id: 'settings',
      name: 'Settings',
      description: 'Configure settings',
      icon: 'settings',
      route: '/settings',
      order: 3,
    },
  ];
}
```

### Launcher with Categories

```typescript
import { Component } from '@angular/core';

@Component({
  selector: 'app-categorized-launcher',
  template: ` <ax-launcher [apps]="apps" [categories]="categories" [config]="{ showCategoryTabs: true }"></ax-launcher> `,
})
export class CategorizedLauncherComponent {
  categories = [
    { id: 'admin', name: 'Administration', icon: 'admin_panel_settings', order: 1 },
    { id: 'analytics', name: 'Analytics', icon: 'analytics', order: 2 },
    { id: 'tools', name: 'Tools', icon: 'build', order: 3 },
  ];

  apps = [
    {
      id: 'users',
      name: 'Users',
      description: 'Manage users',
      categoryId: 'admin',
      icon: 'people',
      route: '/admin/users',
    },
    {
      id: 'reports',
      name: 'Reports',
      description: 'View analytics reports',
      categoryId: 'analytics',
      icon: 'bar_chart',
      route: '/analytics',
    },
    {
      id: 'terminal',
      name: 'Terminal',
      description: 'Command line interface',
      categoryId: 'tools',
      icon: 'terminal',
      route: '/terminal',
    },
  ];
}
```

## API Reference

### Inputs

| Name          | Type                      | Required | Default                          | Description                      |
| ------------- | ------------------------- | -------- | -------------------------------- | -------------------------------- |
| `apps`        | `LauncherApp[]`           | Yes      | -                                | Array of applications to display |
| `categories`  | `LauncherCategory[]`      | No       | `[]`                             | Categories for organizing apps   |
| `userContext` | `LauncherUserContext`     | No       | `{ roles: [], permissions: [] }` | Current user info for RBAC       |
| `config`      | `Partial<LauncherConfig>` | No       | `{}`                             | Component configuration          |
| `title`       | `string`                  | No       | `''`                             | Launcher title                   |
| `subtitle`    | `string`                  | No       | `''`                             | Launcher subtitle                |

### Outputs

| Name            | Type                                       | Description                                  |
| --------------- | ------------------------------------------ | -------------------------------------------- |
| `appClick`      | `EventEmitter<LauncherAppClickEvent>`      | Emitted when app is clicked                  |
| `menuAction`    | `EventEmitter<LauncherMenuActionEvent>`    | Emitted for menu actions                     |
| `statusChange`  | `EventEmitter<LauncherStatusChangeEvent>`  | Emitted when app status changes              |
| `enabledChange` | `EventEmitter<LauncherEnabledChangeEvent>` | Emitted when app enabled state changes       |
| `layoutChange`  | `EventEmitter<LauncherLayoutChangeEvent>`  | Emitted when layout changes (draggable mode) |

### Data Models

#### LauncherApp

| Property            | Type                                 | Required | Description              |
| ------------------- | ------------------------------------ | -------- | ------------------------ |
| `id`                | `string`                             | Yes      | Unique identifier        |
| `name`              | `string`                             | Yes      | Display name             |
| `description`       | `string`                             | No       | Brief description        |
| `icon`              | `string`                             | No       | Material icon name       |
| `route`             | `string`                             | No       | Internal route path      |
| `externalUrl`       | `string`                             | No       | External URL             |
| `categoryId`        | `string`                             | No       | Category ID              |
| `featured`          | `boolean`                            | No       | Show in featured section |
| `enabled`           | `boolean`                            | No       | Enable/disable app       |
| `status`            | `'active' \| 'disabled' \| 'hidden'` | No       | App visibility status    |
| `order`             | `number`                             | No       | Display order            |
| `notificationCount` | `number`                             | No       | Notification badge count |
| `tags`              | `string[]`                           | No       | Search tags              |
| `permission`        | `LauncherAppPermission`              | No       | RBAC configuration       |

#### LauncherCategory

| Property | Type     | Required | Description        |
| -------- | -------- | -------- | ------------------ |
| `id`     | `string` | Yes      | Unique identifier  |
| `name`   | `string` | Yes      | Display name       |
| `icon`   | `string` | No       | Material icon name |
| `order`  | `number` | No       | Display order      |

#### LauncherConfig

| Property           | Type                   | Default         | Description               |
| ------------------ | ---------------------- | --------------- | ------------------------- |
| `showSearch`       | `boolean`              | `true`          | Show search input         |
| `showCategoryTabs` | `boolean`              | `true`          | Show category tabs        |
| `showStatusFilter` | `boolean`              | `false`         | Show status filter        |
| `showViewToggle`   | `boolean`              | `false`         | Show grid/list toggle     |
| `defaultViewMode`  | `'grid' \| 'list'`     | `'grid'`        | Default view              |
| `defaultGroupBy`   | `'category' \| 'none'` | `'category'`    | Default grouping          |
| `emptyMessage`     | `string`               | -               | Message when no apps      |
| `noResultsMessage` | `string`               | -               | Message when search empty |
| `enableFavorites`  | `boolean`              | `true`          | Allow favoriting apps     |
| `enablePinned`     | `boolean`              | `true`          | Allow pinning apps        |
| `enableRecent`     | `boolean`              | `true`          | Track recently used       |
| `enableDraggable`  | `boolean`              | `false`         | Enable edit layout mode   |
| `maxRecentApps`    | `number`               | `5`             | Max recent apps to track  |
| `storageKeyPrefix` | `string`               | `'ax-launcher'` | localStorage key prefix   |
| `cardMinWidth`     | `number`               | `240`           | Card minimum width (px)   |
| `cardMaxWidth`     | `number`               | `320`           | Card maximum width (px)   |
| `cardGap`          | `number`               | `20`            | Grid gap (px)             |

## Angular Router Integration

### Route Navigation

Navigate to apps using router:

```typescript
import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { AxLauncherComponent } from '@aegisx/ui';
import { LauncherAppClickEvent } from '@aegisx/ui/types';

@Component({
  selector: 'app-launcher-with-routing',
  imports: [AxLauncherComponent],
  template: ` <ax-launcher [apps]="apps" (appClick)="onAppClick($event)"></ax-launcher> `,
})
export class LauncherWithRoutingComponent {
  apps: LauncherApp[] = [];

  constructor(private router: Router) {}

  onAppClick(event: LauncherAppClickEvent) {
    const { app, newTab } = event;

    if (app.route) {
      if (newTab) {
        const url = this.router.createUrlTree([app.route]).toString();
        window.open(url, '_blank');
      } else {
        this.router.navigate([app.route]);
      }
    } else if (app.externalUrl) {
      window.open(app.externalUrl, newTab ? '_blank' : '_self');
    }
  }
}
```

### Dynamic Route Parameters

Navigate with route parameters:

```typescript
onAppClick(event: LauncherAppClickEvent) {
  const { app } = event;

  // App with parameters
  if (app.id === 'user-dashboard') {
    this.router.navigate(['/dashboard', { userId: this.currentUserId }]);
  } else if (app.route) {
    this.router.navigate([app.route]);
  }
}
```

## Navigation Patterns for Different App Structures

### Pattern 1: Simple Flat Navigation

All apps at the same level without categories:

```typescript
@Component({
  template: ` <ax-launcher [apps]="allApps" [config]="{ defaultGroupBy: 'none', showCategoryTabs: false }"></ax-launcher> `,
})
export class FlatLauncherComponent {
  allApps: LauncherApp[] = [
    { id: 'app1', name: 'App 1', route: '/app1', icon: 'app1_icon' },
    { id: 'app2', name: 'App 2', route: '/app2', icon: 'app2_icon' },
    { id: 'app3', name: 'App 3', route: '/app3', icon: 'app3_icon' },
  ];
}
```

### Pattern 2: Categorized Navigation

Apps organized by business function:

```typescript
@Component({
  template: ` <ax-launcher [apps]="apps" [categories]="categories" [config]="{ showCategoryTabs: true, defaultGroupBy: 'category' }"></ax-launcher> `,
})
export class CategorizedLauncherComponent {
  categories = [
    { id: 'sales', name: 'Sales', icon: 'trending_up' },
    { id: 'marketing', name: 'Marketing', icon: 'campaign' },
    { id: 'operations', name: 'Operations', icon: 'business' },
  ];

  apps = [
    { id: 'crm', name: 'CRM', categoryId: 'sales', route: '/crm' },
    { id: 'campaigns', name: 'Campaigns', categoryId: 'marketing', route: '/campaigns' },
    { id: 'inventory', name: 'Inventory', categoryId: 'operations', route: '/inventory' },
  ];
}
```

### Pattern 3: Featured Apps with Sections

Highlight important apps with featured section:

```typescript
@Component({
  template: ` <ax-launcher [apps]="apps" [config]="{ showCategoryTabs: true }"></ax-launcher> `,
})
export class FeaturedLauncherComponent {
  apps: LauncherApp[] = [
    { id: 'dashboard', name: 'Dashboard', featured: true, route: '/dashboard', order: 1 },
    { id: 'reports', name: 'Reports', featured: true, route: '/reports', order: 2 },
    // Regular apps below featured section
    { id: 'settings', name: 'Settings', route: '/settings' },
  ];
}
```

### Pattern 4: Role-Based Navigation

Show different apps based on user role:

```typescript
@Component({
  template: ` <ax-launcher [apps]="filteredApps" [userContext]="currentUser"></ax-launcher> `,
})
export class RoleBasedLauncherComponent {
  currentUser = { roles: ['admin', 'user'], permissions: [], isAdmin: true };

  allApps: LauncherApp[] = [
    {
      id: 'admin-panel',
      name: 'Admin Panel',
      permission: { viewRoles: ['admin'] },
    },
    {
      id: 'user-settings',
      name: 'Settings',
      permission: { viewRoles: ['user', 'admin'] },
    },
  ];

  get filteredApps(): LauncherApp[] {
    return this.allApps.filter((app) => this.canView(app));
  }

  canView(app: LauncherApp): boolean {
    if (!app.permission) return true;
    if (this.currentUser.isAdmin) return true;
    if (app.permission.viewRoles) {
      return app.permission.viewRoles.some((role) => this.currentUser.roles.includes(role));
    }
    return false;
  }
}
```

## Keyboard Navigation

### Search Shortcut

Open search with Cmd+K or Ctrl+K:

```typescript
// Built-in support - users can press Cmd+K / Ctrl+K
// to focus the search input automatically
```

### Tab Navigation

Navigate through app cards using Tab:

- Tab moves focus to next app card
- Shift+Tab moves to previous app card
- Enter or Space activates the app

### Implementation

```typescript
@Component({
  template: ` <ax-launcher [apps]="apps" (appClick)="onAppClick($event)"></ax-launcher> `,
})
export class KeyboardNavigableLauncherComponent {
  apps: LauncherApp[] = [];

  onAppClick(event: LauncherAppClickEvent) {
    // Handle app click - works with keyboard too
    console.log('App activated:', event.app.name);
  }
}
```

### Custom Keyboard Shortcuts

Implement custom shortcuts for frequently used apps:

```typescript
import { HostListener } from '@angular/core';

@Component({
  selector: 'app-launcher',
  template: ` <ax-launcher [apps]="apps"></ax-launcher> `,
})
export class CustomShortcutsComponent {
  @HostListener('document:keydown', ['$event'])
  handleKeyboardShortcut(event: KeyboardEvent) {
    // Alt+D for Dashboard
    if (event.altKey && event.key === 'd') {
      event.preventDefault();
      this.router.navigate(['/dashboard']);
    }

    // Alt+S for Settings
    if (event.altKey && event.key === 's') {
      event.preventDefault();
      this.router.navigate(['/settings']);
    }
  }

  constructor(private router: Router) {}
}
```

## Focus Management

### Initial Focus

Focus search input when launcher mounts:

```typescript
import { Component, ViewChild, AfterViewInit } from '@angular/core';

@Component({
  selector: 'app-launcher',
  template: `
    <input #searchInput type="text" placeholder="Search apps..." />
    <ax-launcher [apps]="apps"></ax-launcher>
  `,
})
export class FocusedLauncherComponent implements AfterViewInit {
  @ViewChild('searchInput') searchInput!: any;
  apps: LauncherApp[] = [];

  ngAfterViewInit() {
    this.searchInput.nativeElement.focus();
  }
}
```

### Returning Focus

Return focus to launcher when closing detail view:

```typescript
import { Component } from '@angular/core';

@Component({
  selector: 'app-launcher-with-detail',
  template: `
    <ax-launcher #launcher [apps]="apps" (appClick)="onAppClick($event)"></ax-launcher>

    <app-detail *ngIf="selectedApp" [app]="selectedApp" (close)="onDetailClose()"> </app-detail>
  `,
})
export class LauncherWithDetailComponent {
  @ViewChild('launcher') launcher!: any;
  selectedApp: LauncherApp | null = null;
  apps: LauncherApp[] = [];

  onAppClick(event: LauncherAppClickEvent) {
    this.selectedApp = event.app;
  }

  onDetailClose() {
    this.selectedApp = null;
    // Return focus to launcher
    const firstCard = document.querySelector('.launcher-card');
    (firstCard as HTMLElement)?.focus();
  }
}
```

### List Focus Management

Manage focus in list view:

```typescript
@Component({
  selector: 'app-list-launcher',
  template: ` <ax-launcher [apps]="apps" [config]="{ defaultViewMode: 'list' }" (appClick)="onAppClick($event)"></ax-launcher> `,
})
export class ListLauncherComponent {
  apps: LauncherApp[] = [];

  onAppClick(event: LauncherAppClickEvent) {
    // In list view, focus moves naturally with keyboard
    console.log('App clicked:', event.app.name);
  }
}
```

## ARIA Navigation Landmarks

### Launcher as Main Landmark

Mark launcher as main content region:

```typescript
@Component({
  selector: 'app-launcher',
  template: `
    <main role="main" aria-label="Application Launcher">
      <ax-launcher [apps]="apps"></ax-launcher>
    </main>
  `,
})
export class LandmarkLauncherComponent {
  apps: LauncherApp[] = [];
}
```

### Accessible Tabs

Category tabs use semantic markup:

```typescript
// The component automatically renders:
<div role="tablist">
  <button role="tab" aria-selected="true" aria-controls="panel-0">Category 1</button>
  <button role="tab" aria-selected="false" aria-controls="panel-1">Category 2</button>
</div>

<div role="tabpanel" id="panel-0">
  <!-- Apps for category 1 -->
</div>
```

### Grid Role

App cards are semantically structured:

```typescript
// Component renders:
<div role="grid">
  <div role="row" *ngFor="let app of apps">
    <div role="gridcell">
      <button [attr.aria-label]="app.name">
        {{ app.name }}
      </button>
    </div>
  </div>
</div>
```

### Accessible Labels

Provide meaningful labels for interactive elements:

```typescript
<ax-launcher
  [apps]="apps"
  [config]="{
    emptyMessage: 'No applications available',
    noResultsMessage: 'No applications found matching your search'
  }"
  [attr.aria-label]="'Application launcher with ' + apps.length + ' apps'"
></ax-launcher>
```

### Notification Badges Accessibility

Announce notification counts to screen readers:

```typescript
// App with notifications
{
  id: 'inbox',
  name: 'Inbox',
  notificationCount: 5,
  route: '/inbox'
}

// Component renders:
<button [attr.aria-label]="'Inbox, 5 unread messages'">
  Inbox
  <span aria-hidden="true">5</span>
</button>
```

## Styling & Theming

### CSS Variables

The launcher uses design tokens:

```css
--ax-background-default     /* Main background */
--ax-text-heading           /* Title text */
--ax-text-secondary         /* Subtitle text */
--ax-text-muted             /* Muted text */
--ax-background-hover       /* Hover state */
--ax-background-subtle      /* Subtle backgrounds */
--ax-border-default         /* Divider lines */
--ax-radius-md              /* Border radius */
--ax-radius-lg              /* Large radius */
--ax-spacing-sm             /* Small spacing */
--ax-spacing-md             /* Medium spacing */
```

### Grid Customization

Adjust grid layout:

```typescript
@Component({
  template: `
    <ax-launcher
      [apps]="apps"
      [config]="{
        cardMinWidth: 200,    // Smaller cards
        cardMaxWidth: 300,
        cardGap: 16
      }"
    ></ax-launcher>
  `,
})
export class CustomGridComponent {
  apps: LauncherApp[] = [];
}
```

### Dark Mode

Automatically supported via CSS variables:

```typescript
// When .dark class applied to root:
:root.dark {
  --ax-background-default: #1f2937;
  --ax-text-heading: #f9fafb;
  --ax-background-hover: #374151;
}
```

## Advanced Usage

### Custom App Menu Actions

Add context menu to app cards:

```typescript
@Component({
  selector: 'app-launcher-with-menu',
  template: ` <ax-launcher [apps]="apps" (menuAction)="onMenuAction($event)"></ax-launcher> `,
})
export class MenuLauncherComponent {
  apps: LauncherApp[] = [];

  onMenuAction(event: LauncherMenuActionEvent) {
    const { action, app } = event;

    switch (action.id) {
      case 'open':
        this.openApp(app);
        break;
      case 'open_new_tab':
        this.openAppInNewTab(app);
        break;
      case 'copy_link':
        this.copyAppLink(app);
        break;
      case 'remove_from_favorites':
        this.removeFromFavorites(app);
        break;
    }
  }

  private openApp(app: LauncherApp) {
    // Navigate to app
  }

  private openAppInNewTab(app: LauncherApp) {
    // Open in new tab
  }

  private copyAppLink(app: LauncherApp) {
    // Copy to clipboard
  }

  private removeFromFavorites(app: LauncherApp) {
    // Update favorites
  }
}
```

### Draggable Layout Customization

Allow users to customize app positions:

```typescript
@Component({
  template: ` <ax-launcher [apps]="apps" [config]="{ enableDraggable: true }" (layoutChange)="onLayoutChange($event)"></ax-launcher> `,
})
export class DraggableLauncherComponent {
  apps: LauncherApp[] = [];

  onLayoutChange(event: LauncherLayoutChangeEvent) {
    // Save custom layout to backend
    console.log('Layout changed:', event.layout);
    // event.layout contains: { id, x, y, cols, rows }[]
  }
}
```

### Search Integration

Implement custom search:

```typescript
@Component({
  template: `
    <input #searchBox type="text" placeholder="Search applications..." (input)="onSearch($event)" />

    <ax-launcher [apps]="filteredApps" [config]="{ showSearch: false }"></ax-launcher>
  `,
})
export class SearchableLauncherComponent {
  allApps: LauncherApp[] = [];
  filteredApps: LauncherApp[] = [];

  onSearch(event: any) {
    const query = event.target.value.toLowerCase();
    this.filteredApps = this.allApps.filter((app) => app.name.toLowerCase().includes(query) || app.description?.toLowerCase().includes(query) || app.tags?.some((tag) => tag.toLowerCase().includes(query)));
  }
}
```

### Favorites and Pinned Apps

Manage user preferences:

```typescript
@Component({
  template: ` <ax-launcher [apps]="apps" [config]="{ enableFavorites: true, enablePinned: true }"></ax-launcher> `,
})
export class PreferencesLauncherComponent {
  apps: LauncherApp[] = [];

  // Component automatically persists:
  // - favorites in localStorage with key 'ax-launcher-favorites'
  // - pinned apps in 'ax-launcher-pinned'
  // - recent apps in 'ax-launcher-recent'
}
```

## Related Components

- **[Navigation Component](./navigation.md)** - Navigation menu system
- **[Drawer Component](./drawer.md)** - Side panel for supplementary content

## Browser Support

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## Accessibility Checklist

- [x] Semantic HTML (grid/gridcell roles)
- [x] Keyboard navigation (Tab through apps, Cmd+K search)
- [x] Tab management (aria-selected, aria-controls)
- [x] Focus management (visible focus indicators)
- [x] Screen reader support (aria-labels, roles)
- [x] Color contrast (WCAG AA)
- [x] Notification announcement (aria-label with counts)
- [x] Disabled state handling
- [x] Live regions for dynamic content (aria-live)

## Performance Tips

1. **Virtual Scrolling** - Use with large app lists
2. **Lazy Load Icons** - Load Material icons on demand
3. **Memoize Filtered Apps** - Cache search/category results
4. **OnPush Detection** - Use OnPush change detection strategy
5. **Unsubscribe** - Clean up subscriptions on destroy
6. **localStorage Limits** - Monitor storage size for preferences
7. **Defer Drag Setup** - Enable draggable only when needed

## Examples

### Complete App Portal

```typescript
import { Component, OnInit } from '@angular/core';
import { AxLauncherComponent } from '@aegisx/ui';
import { LauncherApp, LauncherCategory } from '@aegisx/ui/types';

@Component({
  selector: 'app-portal',
  imports: [AxLauncherComponent],
  template: ` <ax-launcher [apps]="apps" [categories]="categories" [userContext]="currentUser" [config]="launcherConfig" title="Application Portal" subtitle="Access all enterprise applications" (appClick)="onAppClick($event)"></ax-launcher> `,
  styles: [
    `
      :host {
        display: block;
        height: 100vh;
        overflow: hidden;
      }
    `,
  ],
})
export class AppPortalComponent implements OnInit {
  apps: LauncherApp[] = [];
  categories: LauncherCategory[] = [];
  currentUser = {
    roles: ['user'],
    permissions: [],
    isAdmin: false,
  };

  launcherConfig = {
    showSearch: true,
    showCategoryTabs: true,
    enableFavorites: true,
    enablePinned: true,
    enableRecent: true,
    defaultViewMode: 'grid' as const,
    cardMinWidth: 240,
  };

  constructor(
    private appService: ApplicationService,
    private router: Router,
  ) {}

  ngOnInit() {
    this.loadApplications();
    this.loadCategories();
  }

  loadApplications() {
    this.appService.getApps().subscribe((apps) => {
      this.apps = apps;
    });
  }

  loadCategories() {
    this.appService.getCategories().subscribe((cats) => {
      this.categories = cats;
    });
  }

  onAppClick(event: any) {
    const { app, newTab } = event;
    if (app.route) {
      this.router.navigate([app.route]);
    } else if (app.externalUrl) {
      window.open(app.externalUrl, newTab ? '_blank' : '_self');
    }
  }
}
```
