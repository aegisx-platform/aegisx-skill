# ax-theme-switcher

**Category:** Theme
**Since:** 2.0.0
**Status:** Stable

---

## Overview

`ax-theme-switcher` provides a Material Design menu for switching between light/dark themes and different color schemes. It integrates seamlessly with `AxThemeService` to manage theme state, persistence, and application-wide theme changes.

**Key Features:**

- Material Design 3 menu interface
- Light/Dark mode toggle
- Multiple theme presets (AegisX, Material, Tailwind, Bootstrap)
- Automatic localStorage persistence
- Visual theme preview in menu
- Responsive and accessible

---

## API Reference

### Selector

```html
<ax-theme-switcher></ax-theme-switcher>
```

### Inputs

| Name | Type | Default | Description                  |
| ---- | ---- | ------- | ---------------------------- |
| None | -    | -       | This component has no inputs |

### Outputs

| Name | Type | Description                                      |
| ---- | ---- | ------------------------------------------------ |
| None | -    | Theme changes are handled internally via service |

### Dependencies

```typescript
// Required Service
import { AxThemeService } from '@aegisx/ui';

// The component injects AxThemeService automatically
```

### Signals (from AxThemeService)

```typescript
// Available themes
themes: Signal<ThemeOption[]>;

// Current active theme
currentTheme: Signal<ThemeOption>;
```

### Methods

| Method             | Parameters        | Return Type | Description                            |
| ------------------ | ----------------- | ----------- | -------------------------------------- |
| `selectTheme()`    | `themeId: string` | `void`      | Switch to a specific theme by ID       |
| `toggleDarkMode()` | None              | `void`      | Toggle between light and dark variants |
| `isDarkMode()`     | None              | `boolean`   | Check if current theme is dark mode    |

---

## Usage Examples

### Basic Usage

```typescript
import { Component } from '@angular/core';
import { AxThemeSwitcherComponent } from '@aegisx/ui';

@Component({
  selector: 'app-toolbar',
  standalone: true,
  imports: [AxThemeSwitcherComponent],
  template: `
    <mat-toolbar>
      <span>My App</span>
      <span class="spacer"></span>

      <!-- Theme Switcher -->
      <ax-theme-switcher></ax-theme-switcher>
    </mat-toolbar>
  `,
})
export class ToolbarComponent {}
```

### In App Shell Header

```typescript
import { Component } from '@angular/core';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { AxThemeSwitcherComponent } from '@aegisx/ui';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [MatToolbarModule, MatButtonModule, MatIconModule, AxThemeSwitcherComponent],
  template: `
    <mat-toolbar color="primary">
      <button mat-icon-button>
        <mat-icon>menu</mat-icon>
      </button>

      <span>Enterprise Dashboard</span>

      <span class="flex-spacer"></span>

      <!-- Notifications -->
      <button mat-icon-button>
        <mat-icon>notifications</mat-icon>
      </button>

      <!-- Theme Switcher -->
      <ax-theme-switcher></ax-theme-switcher>

      <!-- User Menu -->
      <button mat-icon-button>
        <mat-icon>account_circle</mat-icon>
      </button>
    </mat-toolbar>
  `,
  styles: [
    `
      .flex-spacer {
        flex: 1 1 auto;
      }
    `,
  ],
})
export class AppHeaderComponent {}
```

### With Theme Service Integration

```typescript
import { Component, inject, effect } from '@angular/core';
import { AxThemeSwitcherComponent, AxThemeService } from '@aegisx/ui';

@Component({
  selector: 'app-settings',
  standalone: true,
  imports: [AxThemeSwitcherComponent],
  template: `
    <div class="settings-panel">
      <h3>Theme Settings</h3>

      <!-- Theme Switcher -->
      <ax-theme-switcher></ax-theme-switcher>

      <!-- Display Current Theme Info -->
      <div class="current-theme-info">
        <p>Active Theme: {{ themeService.currentTheme().name }}</p>
        <p>Mode: {{ themeService.currentTheme().id.includes('dark') ? 'Dark' : 'Light' }}</p>
      </div>
    </div>
  `,
})
export class SettingsComponent {
  themeService = inject(AxThemeService);

  constructor() {
    // React to theme changes
    effect(() => {
      const theme = this.themeService.currentTheme();
      console.log('Theme changed to:', theme.name);

      // Analytics tracking
      this.trackThemeChange(theme.id);
    });
  }

  private trackThemeChange(themeId: string): void {
    // Send analytics event
  }
}
```

### Programmatic Theme Control

```typescript
import { Component, inject } from '@angular/core';
import { AxThemeSwitcherComponent, AxThemeService } from '@aegisx/ui';

@Component({
  selector: 'app-theme-demo',
  standalone: true,
  imports: [AxThemeSwitcherComponent],
  template: `
    <div class="demo-panel">
      <!-- Visual Theme Switcher -->
      <ax-theme-switcher></ax-theme-switcher>

      <!-- Programmatic Controls -->
      <div class="theme-controls">
        <button (click)="setLightTheme()">Light Mode</button>
        <button (click)="setDarkTheme()">Dark Mode</button>
        <button (click)="applyCustomTheme()">Custom Theme</button>
      </div>
    </div>
  `,
})
export class ThemeDemoComponent {
  private themeService = inject(AxThemeService);

  setLightTheme(): void {
    this.themeService.setTheme('aegisx-light');
  }

  setDarkTheme(): void {
    this.themeService.setTheme('aegisx-dark');
  }

  applyCustomTheme(): void {
    // Apply a custom theme (if defined in ThemeService)
    this.themeService.setTheme('custom-brand');
  }
}
```

---

## Available Themes

The theme switcher displays all themes registered in `AxThemeService`. Default themes include:

### AegisX Themes

- **aegisx-light** - AegisX light theme (default)
- **aegisx-dark** - AegisX dark theme

### Material Prebuilt Themes

- **indigo-pink** - Material Indigo & Pink
- **deeppurple-amber** - Material Deep Purple & Amber
- **pink-bluegrey** - Material Pink & Blue Grey
- **purple-green** - Material Purple & Green

### Framework-Inspired Themes

- **tailwind-light** - Tailwind CSS style (light)
- **tailwind-dark** - Tailwind CSS style (dark)
- **bootstrap-light** - Bootstrap style (light)
- **bootstrap-dark** - Bootstrap style (dark)

---

## Theme Toggle Behavior

### Light/Dark Toggle Logic

The `toggleDarkMode()` method intelligently switches between variants:

```typescript
toggleDarkMode(): void {
  const currentId = this.currentTheme()?.id;

  if (!currentId) {
    this.selectTheme('aegisx-light');
    return;
  }

  // Check if it's an AegisX theme (has -light or -dark suffix)
  const isAegisXTheme = currentId.includes('-light') || currentId.includes('-dark');

  if (isAegisXTheme) {
    if (currentId.includes('dark')) {
      // Switch to light version
      this.selectTheme(currentId.replace('-dark', '-light'));
    } else {
      // Switch to dark version
      this.selectTheme(currentId.replace('-light', '-dark'));
    }
  } else {
    // Material prebuilt themes don't have light/dark variants
    // Fall back to AegisX themes
    this.selectTheme(this.isDarkMode() ? 'aegisx-light' : 'aegisx-dark');
  }
}
```

**Examples:**

- `aegisx-light` → `aegisx-dark`
- `tailwind-dark` → `tailwind-light`
- `indigo-pink` → `aegisx-dark` (no dark variant exists)

---

## Theme Persistence

Themes are automatically persisted to `localStorage`:

```typescript
// Theme is saved when selected
selectTheme(themeId: string): void {
  this.themeService.setTheme(themeId);
  // AxThemeService handles localStorage.setItem('theme', themeId)
}

// Theme is restored on app load
// AxThemeService automatically loads saved theme in constructor
```

**Storage Key:**

```javascript
localStorage.getItem('theme'); // Returns theme ID, e.g., 'aegisx-dark'
```

**Clear Saved Theme:**

```javascript
localStorage.removeItem('theme');
// Reload page to apply default theme
```

---

## Styling

### Theme Integration

The component uses Material-First design tokens:

```scss
// Menu background
::ng-deep .theme-switcher-menu.mat-mdc-menu-panel {
  background-color: var(--ax-background-default) !important;
  backdrop-filter: blur(10px) !important;
  border-radius: var(--ax-radius-md) !important;
  border: 1px solid var(--ax-border-default) !important;
  box-shadow: var(--ax-shadow-lg) !important;
}

// Active theme item
.theme-option.theme-active {
  background-color: var(--ax-brand-faint) !important;
}

.theme-option.theme-active .theme-name {
  font-weight: 500;
  color: var(--ax-brand-emphasis) !important;
}
```

See [THEMING_GUIDE.md](../../THEMING_GUIDE.md) for the complete token reference.

### Custom Styling

```css
/* Custom menu width */
::ng-deep .theme-switcher-menu.mat-mdc-menu-panel {
  min-width: 280px !important;
}

/* Custom active state color */
::ng-deep .theme-option.theme-active {
  background: linear-gradient(to right, #f0f9ff, #e0f2fe) !important;
}

/* Custom hover effect */
::ng-deep .theme-option:hover {
  background-color: rgba(99, 102, 241, 0.1) !important;
}
```

---

## Accessibility

### Keyboard Navigation

| Key               | Action                      |
| ----------------- | --------------------------- |
| `Tab`             | Focus theme switcher button |
| `Enter` / `Space` | Open theme menu             |
| `Arrow Up/Down`   | Navigate theme options      |
| `Enter` / `Space` | Select theme                |
| `Escape`          | Close menu                  |

### Screen Reader Support

```html
<!-- Automatically provided by Material Menu -->
<button mat-icon-button [matMenuTriggerFor]="themeMenu" matTooltip="Change theme" aria-label="Change theme" aria-haspopup="true">
  <mat-icon>palette</mat-icon>
</button>
```

**Screen Reader Announcements:**

- "Change theme, button"
- "Menu opened, themes"
- "AegisX Light Theme, menu item, selected"
- "Switch to Dark Mode, menu item"

### ARIA Attributes

The component leverages Material Design's built-in ARIA support:

- `role="menu"` on menu container
- `role="menuitem"` on theme options
- `aria-selected="true"` on active theme
- `aria-label` on buttons

---

## Responsive Behavior

The theme switcher adapts to different screen sizes:

### Desktop (>1024px)

- Full icon button in toolbar
- Menu opens below button
- Displays theme names and icons

### Tablet (768px-1024px)

- Standard icon button
- Responsive menu width

### Mobile (<768px)

- Compact icon button
- Full-width menu overlay
- Touch-optimized menu items

---

## Integration with Theme Builder

The theme switcher can work alongside `ax-theme-builder` for advanced customization:

```typescript
import { Component } from '@angular/core';
import { AxThemeSwitcherComponent } from '@aegisx/ui';
import { Router } from '@angular/router';

@Component({
  selector: 'app-theme-settings',
  template: `
    <div class="theme-settings">
      <!-- Quick Switcher -->
      <div class="quick-switch">
        <h3>Quick Theme Switch</h3>
        <ax-theme-switcher></ax-theme-switcher>
      </div>

      <!-- Advanced Customization -->
      <div class="advanced">
        <h3>Advanced Customization</h3>
        <button (click)="openThemeBuilder()">Open Theme Builder</button>
      </div>
    </div>
  `,
})
export class ThemeSettingsComponent {
  constructor(private router: Router) {}

  openThemeBuilder(): void {
    this.router.navigate(['/theme-builder']);
  }
}
```

---

## Best Practices

### Do's

- Place theme switcher in a persistent header/toolbar
- Provide visual feedback for the active theme
- Respect user's system preference (prefers-color-scheme)
- Save theme preference across sessions

### Don'ts

- Don't hide the theme switcher on mobile
- Don't auto-switch themes without user action
- Avoid conflicting theme systems (use one source of truth)
- Don't forget to test all themes for accessibility

---

## Common Patterns

### Pattern 1: System Preference Detection

```typescript
import { Component, inject, effect } from '@angular/core';
import { AxThemeService } from '@aegisx/ui';

@Component({
  selector: 'app-root',
  template: `<ax-theme-switcher></ax-theme-switcher>`,
})
export class AppComponent {
  private themeService = inject(AxThemeService);

  constructor() {
    // Detect system preference on first load
    const savedTheme = localStorage.getItem('theme');
    if (!savedTheme) {
      const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      this.themeService.setTheme(prefersDark ? 'aegisx-dark' : 'aegisx-light');
    }

    // Listen for system preference changes
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
      if (!localStorage.getItem('theme')) {
        // Only auto-switch if user hasn't set a preference
        this.themeService.setTheme(e.matches ? 'aegisx-dark' : 'aegisx-light');
      }
    });
  }
}
```

### Pattern 2: Theme Sync Across Tabs

```typescript
import { Component, inject, OnInit } from '@angular/core';
import { AxThemeService } from '@aegisx/ui';

@Component({
  selector: 'app-root',
  template: `<ax-theme-switcher></ax-theme-switcher>`,
})
export class AppComponent implements OnInit {
  private themeService = inject(AxThemeService);

  ngOnInit(): void {
    // Sync theme changes across browser tabs
    window.addEventListener('storage', (event) => {
      if (event.key === 'theme' && event.newValue) {
        this.themeService.setTheme(event.newValue);
      }
    });
  }
}
```

### Pattern 3: Conditional Theme Options

```typescript
import { Component, inject, computed } from '@angular/core';
import { AxThemeService } from '@aegisx/ui';
import { AuthService } from './auth.service';

@Component({
  selector: 'app-toolbar',
  template: `
    @if (canCustomizeTheme()) {
      <ax-theme-switcher></ax-theme-switcher>
    }
  `,
})
export class ToolbarComponent {
  private themeService = inject(AxThemeService);
  private authService = inject(AuthService);

  // Only premium users can customize themes
  canCustomizeTheme = computed(() => this.authService.currentUser()?.isPremium ?? false);
}
```

---

## Related Components

- **ax-theme-builder** - Advanced theme customization tool
- **AxThemeService** - Core theme management service
- **ax-layout-switcher** - Layout mode switcher (complements theme switcher)

---

## Related Documentation

- [THEMING_GUIDE.md](../../THEMING_GUIDE.md) - Complete Material-First theming guide
- [AxThemeService API](../../services/theme-service.md) - Theme service documentation
- [Theme Builder Guide](./theme-builder.md) - Advanced theme builder component

---

**Last Updated:** 2025-12-17
**Component Version:** 2.0.0
