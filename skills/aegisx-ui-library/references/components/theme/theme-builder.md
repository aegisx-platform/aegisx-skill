# ax-theme-builder

**Category:** Theme
**Since:** 2.0.0
**Status:** Stable

---

## Overview

`ax-theme-builder` is a comprehensive visual theme customization tool that enables users to create, edit, and export custom themes for AegisX UI applications. It provides an interactive interface for adjusting colors, typography, spacing, shadows, and other design tokens with real-time preview and Material Design 3 integration.

**Key Features:**

- Visual color palette editor with 10-shade system
- Material Design 3 color scheme generator
- Image color extraction
- Typography, spacing, and shadow controls
- Preset themes (AegisX, Material, Tailwind, Bootstrap)
- WCAG 2.1 contrast checker
- Export to CSS, SCSS, JSON, Tailwind
- Local theme storage and management
- Real-time preview panel
- Import/Export theme configurations

---

## API Reference

### Selector

```html
<ax-theme-builder></ax-theme-builder>
```

### Inputs

| Name | Type | Default | Description                                                     |
| ---- | ---- | ------- | --------------------------------------------------------------- |
| None | -    | -       | This component manages state internally via ThemeBuilderService |

### Outputs

| Name | Type | Description                                 |
| ---- | ---- | ------------------------------------------- |
| None | -    | Changes are managed via ThemeBuilderService |

### Dependencies

```typescript
// Required Service
import { ThemeBuilderService } from '@aegisx/ui';

// The component automatically injects the service
```

### Sections

The theme builder provides these customization sections:

| Section            | Purpose                                                    |
| ------------------ | ---------------------------------------------------------- |
| `colors`           | Edit color palettes (brand, success, warning, error, info) |
| `image-extractor`  | Extract colors from uploaded images                        |
| `m3-colors`        | Generate Material Design 3 color schemes                   |
| `typography`       | Customize fonts, sizes, weights, line heights              |
| `spacing`          | Configure spacing scale                                    |
| `radius`           | Define border radius values                                |
| `shadows`          | Adjust shadow effects                                      |
| `contrast-checker` | Validate color contrast for accessibility                  |
| `saved-themes`     | Manage saved custom themes                                 |
| `code-export`      | Preview and export theme code                              |

---

## Usage Examples

### Basic Integration

```typescript
import { Component } from '@angular/core';
import { AxThemeBuilderComponent } from '@aegisx/ui';

@Component({
  selector: 'app-theme-customizer',
  standalone: true,
  imports: [AxThemeBuilderComponent],
  template: `
    <div class="customizer-page">
      <ax-theme-builder></ax-theme-builder>
    </div>
  `,
  styles: [
    `
      .customizer-page {
        height: 100vh;
        overflow: hidden;
      }
    `,
  ],
})
export class ThemeCustomizerComponent {}
```

### As a Route

```typescript
// app.routes.ts
import { Routes } from '@angular/router';
import { AxThemeBuilderComponent } from '@aegisx/ui';

export const routes: Routes = [
  {
    path: 'theme-builder',
    component: AxThemeBuilderComponent,
    data: { title: 'Theme Customization' },
  },
];
```

### In Settings Dialog

```typescript
import { Component, inject } from '@angular/core';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { AxThemeBuilderComponent } from '@aegisx/ui';

@Component({
  selector: 'app-settings',
  template: `
    <button mat-raised-button (click)="openThemeBuilder()">
      <mat-icon>palette</mat-icon>
      Customize Theme
    </button>
  `,
})
export class SettingsComponent {
  private dialog = inject(MatDialog);

  openThemeBuilder(): void {
    this.dialog.open(AxThemeBuilderComponent, {
      width: '95vw',
      height: '90vh',
      maxWidth: '1800px',
      panelClass: 'theme-builder-dialog',
    });
  }
}
```

### Programmatic Theme Control

```typescript
import { Component, inject } from '@angular/core';
import { ThemeBuilderService } from '@aegisx/ui';

@Component({
  selector: 'app-theme-manager',
  template: `
    <div class="theme-controls">
      <button (click)="applyPreset('tailwind')">Apply Tailwind</button>
      <button (click)="exportTheme()">Export Theme</button>
      <button (click)="resetTheme()">Reset</button>
    </div>
  `,
})
export class ThemeManagerComponent {
  themeService = inject(ThemeBuilderService);

  applyPreset(presetId: string): void {
    this.themeService.applyPreset(presetId);
    this.themeService.applyToDocument();
  }

  exportTheme(): void {
    const scssCode = this.themeService.exportTheme('scss');
    console.log(scssCode);

    // Download as file
    const blob = new Blob([scssCode], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'custom-theme.scss';
    a.click();
  }

  resetTheme(): void {
    this.themeService.resetToDefault();
    this.themeService.applyToDocument();
  }
}
```

---

## Theme Customization Sections

### 1. Colors Section

Edit semantic color palettes with 10-shade system (50-900):

```typescript
// Color palette structure
interface ColorPalette {
  50: string; // Lightest shade
  100: string;
  200: string;
  300: string;
  400: string;
  500: string; // Main color (base)
  600: string;
  700: string;
  800: string;
  900: string; // Darkest shade
}

// Available semantic colors
-brand - // Primary brand color
  success - // Success states
  warning - // Warning states
  error - // Error states
  info; // Informational states
```

**Features:**

- Visual color picker per shade
- Hex color input
- Generate full palette from base color
- Background, text, and border colors
- Real-time preview

### 2. Image Color Extractor

Extract color palettes from uploaded images:

```typescript
// Extracted palette
interface ExtractedPalette {
  dominantColor: string;
  palette: string[]; // 10 colors
  colors: Array<{
    hex: string;
    percentage: number;
  }>;
}
```

**Features:**

- Upload image (PNG, JPG, WebP)
- Extract dominant colors
- Generate palette from image
- Apply to brand/semantic colors
- Auto-generate M3 scheme

### 3. Material Design 3 Colors

Generate complete M3 color schemes from seed color:

```typescript
// M3 Color Scheme
interface M3ColorScheme {
  // Primary palette
  primary: string;
  onPrimary: string;
  primaryContainer: string;
  onPrimaryContainer: string;

  // Surface palette
  surface: string;
  onSurface: string;
  surfaceVariant: string;
  onSurfaceVariant: string;

  // Outline
  outline: string;
  outlineVariant: string;

  // And more...
}
```

**Features:**

- Auto-generate from brand color
- Light and dark schemes
- Preview all tones
- Apply to theme
- Export as CSS/SCSS

See [Material Design 3](https://m3.material.io/styles/color/the-color-system/color-roles) for color role documentation.

### 4. Typography

Customize font settings:

```typescript
interface TypographyConfig {
  fontFamily: string;
  fontSize: {
    xs: string; // 0.75rem
    sm: string; // 0.875rem
    base: string; // 1rem
    lg: string; // 1.125rem
    xl: string; // 1.25rem
    '2xl': string; // 1.5rem
    '3xl': string; // 1.875rem
    '4xl': string; // 2.25rem
  };
  fontWeight: {
    normal: number; // 400
    medium: number; // 500
    semibold: number; // 600
    bold: number; // 700
  };
  lineHeight: {
    tight: number; // 1.25
    normal: number; // 1.5
    relaxed: number; // 1.75
  };
}
```

**Features:**

- Font family input
- Size sliders (0.5rem - 4rem)
- Weight sliders (100-900)
- Line height sliders (1-2.5)
- Live text preview

### 5. Spacing Scale

Configure spacing tokens:

```typescript
interface SpacingConfig {
  '2xs': string; // 0.125rem
  xs: string; // 0.25rem
  sm: string; // 0.5rem
  md: string; // 1rem
  lg: string; // 1.5rem
  xl: string; // 2rem
  '2xl': string; // 3rem
  '3xl': string; // 4rem
  '4xl': string; // 6rem
}
```

**Features:**

- Slider controls (0-6rem)
- Visual spacing preview
- Consistent spacing system

### 6. Border Radius

Define border radius values:

```typescript
interface RadiusConfig {
  sm: string; // 0.25rem
  md: string; // 0.5rem
  lg: string; // 0.75rem
  xl: string; // 1rem
  '2xl': string; // 1.5rem
  full: string; // 9999px (circle)
}
```

**Features:**

- Slider controls (0-2rem)
- Visual radius preview
- Full circle option

### 7. Shadows

Customize elevation shadows:

```typescript
interface ShadowConfig {
  sm: string; // Subtle elevation
  md: string; // Medium elevation
  lg: string; // Strong elevation
}
```

**Features:**

- Blur slider (0-30px)
- Spread slider (-10px to 10px)
- Opacity slider (0-50%)
- Live shadow preview

### 8. Contrast Checker

Validate color combinations against WCAG 2.1:

```typescript
interface ContrastCheck {
  name: string;
  foreground: string;
  background: string;
  result: {
    ratio: number; // e.g., 7.2
    wcagAA: boolean; // ≥4.5:1
    wcagAALarge: boolean; // ≥3:1
    wcagAAA: boolean; // ≥7:1
    level: 'AAA' | 'AA' | 'AA-large' | 'fail';
  };
}
```

**WCAG 2.1 Requirements:**

- **AAA:** 7:1 ratio - Enhanced contrast
- **AA:** 4.5:1 ratio - Minimum for normal text
- **AA Large:** 3:1 ratio - Large text (18pt+)

**Features:**

- Real-time contrast calculation
- Visual pass/fail indicators
- Accessibility compliance badges

### 9. Saved Themes

Manage custom theme configurations:

```typescript
interface SavedTheme {
  id: string;
  name: string;
  config: ThemeBuilderConfig;
  createdAt: Date;
  updatedAt: Date;
}
```

**Features:**

- Save current theme
- Load saved theme
- Update theme
- Duplicate theme
- Delete theme
- localStorage persistence

### 10. Code Export

Export theme in multiple formats:

```typescript
type ExportFormat = 'scss' | 'css' | 'json' | 'tailwind';
type ExportMode = 'light' | 'dark' | 'both';
```

**Export Formats:**

**SCSS:**

```scss
// Color variables
$brand-50: #eef2ff;
$brand-500: #6366f1;
$brand-900: #312e81;

// Usage
.button {
  background: $brand-500;
}
```

**CSS Custom Properties:**

```css
:root {
  --brand-50: #eef2ff;
  --brand-500: #6366f1;
  --brand-900: #312e81;
}

.dark {
  --brand-50: #312e81;
  --brand-500: #6366f1;
  --brand-900: #eef2ff;
}
```

**JSON:**

```json
{
  "name": "Custom Theme",
  "mode": "light",
  "colors": {
    "brand": {
      "50": "#eef2ff",
      "500": "#6366f1",
      "900": "#312e81"
    }
  }
}
```

**Tailwind Config:**

```javascript
module.exports = {
  theme: {
    extend: {
      colors: {
        brand: {
          50: '#eef2ff',
          500: '#6366f1',
          900: '#312e81',
        },
      },
    },
  },
};
```

---

## Preset Themes

### Available Presets

| Preset ID                   | Name                         | Description                    |
| --------------------------- | ---------------------------- | ------------------------------ |
| `aegisx`                    | AegisX Default               | Official AegisX design system  |
| `material-indigo-pink`      | Material Indigo & Pink       | Material Design preset         |
| `material-deeppurple-amber` | Material Deep Purple & Amber | Material Design preset         |
| `material-pink-bluegrey`    | Material Pink & Blue Grey    | Material Design preset         |
| `material-purple-green`     | Material Purple & Green      | Material Design preset         |
| `tailwind`                  | Tailwind CSS                 | Tailwind-inspired color system |
| `bootstrap`                 | Bootstrap                    | Bootstrap-inspired design      |
| `dracula`                   | Dracula                      | Popular dark theme             |
| `nord`                      | Nord                         | Arctic-inspired color palette  |
| `solarized-light`           | Solarized Light              | Low-contrast light theme       |
| `solarized-dark`            | Solarized Dark               | Low-contrast dark theme        |

---

## Import/Export

### Export Theme

```typescript
// Export as SCSS
const scss = themeService.exportTheme('scss');

// Export as CSS
const css = themeService.exportTheme('css');

// Export as JSON
const json = themeService.exportTheme('json');

// Export for Tailwind
const tailwind = themeService.exportTheme('tailwind');
```

### Import Theme from JSON

```typescript
// Import from file
const file: File = event.target.files[0];
const result = await themeService.importFromFile(file);

if (result.success) {
  console.log('Theme imported:', result.theme);
} else {
  console.error('Import failed:', result.error);
}

// Import from JSON string
const themeJson = '{"name":"Custom","colors":{...}}';
themeService.importFromJson(themeJson);
```

**JSON Format:**

```json
{
  "name": "My Custom Theme",
  "mode": "light",
  "colors": {
    "brand": {
      "50": "#...",
      "100": "#...",
      ...
      "900": "#..."
    },
    "success": { "50": "#...", ... },
    ...
  },
  "background": {
    "muted": "#...",
    "subtle": "#...",
    "default": "#...",
    "emphasis": "#..."
  },
  "text": {
    "disabled": "#...",
    ...
  },
  "typography": { ... },
  "spacing": { ... },
  "radius": { ... },
  "shadows": { ... }
}
```

---

## Responsive Behavior

The theme builder adapts to screen sizes:

### Desktop (>1200px)

- Three-column layout: Sidebar | Editor | Preview
- Full feature set visible

### Tablet (768px-1200px)

- Two-column layout: Sidebar | Editor
- Preview panel hidden
- Responsive controls

### Mobile (<768px)

- Single column layout
- Horizontal scrolling sidebar
- Stacked editor sections

**Responsive Breakpoints:**

```scss
// Large Desktop
@media (min-width: 1200px) {
  grid-template-columns: 200px 1fr 500px;
}

// Tablet
@media (max-width: 1200px) {
  grid-template-columns: 180px 1fr;
}

// Mobile
@media (max-width: 768px) {
  grid-template-columns: 1fr;
}
```

---

## Accessibility

### Keyboard Navigation

| Section       | Keyboard Support                         |
| ------------- | ---------------------------------------- |
| Color Pickers | `Tab`, `Enter`, `Arrow Keys`             |
| Sliders       | `Tab`, `Arrow Left/Right`, `Home`, `End` |
| Menus         | `Arrow Up/Down`, `Enter`, `Escape`       |
| Tabs          | `Arrow Left/Right`, `Home`, `End`        |

### Screen Reader Support

All controls include proper ARIA labels:

```html
<!-- Color input -->
<input type="color" aria-label="Brand color 500 shade" [value]="color.value" />

<!-- Slider -->
<mat-slider aria-label="Font size extra large">
  <input matSliderThumb />
</mat-slider>

<!-- Section navigation -->
<nav aria-label="Theme builder sections">
  <button role="tab" aria-selected="true">Colors</button>
</nav>
```

### Contrast Validation

The built-in contrast checker ensures theme accessibility:

- Validates all text/background combinations
- Highlights WCAG failures
- Provides remediation suggestions

---

## Best Practices

### Do's

- Test theme changes in light and dark modes
- Validate contrast ratios for accessibility
- Save themes before major changes
- Export themes for version control
- Use semantic color names appropriately

### Don'ts

- Don't use too many color variations (stick to semantic colors)
- Avoid extremely low contrast combinations
- Don't export sensitive data in theme files
- Avoid hardcoding colors (use tokens)

---

## Common Patterns

### Pattern 1: Brand Theme Creation

```typescript
@Component({
  selector: 'app-onboarding',
  template: ` <ax-theme-builder></ax-theme-builder> `,
})
export class BrandOnboardingComponent implements OnInit {
  themeService = inject(ThemeBuilderService);

  ngOnInit(): void {
    // Set company brand colors
    this.themeService.updateColor('brand', 500, '#6366f1');

    // Generate full palette
    const palette = this.themeService.generateColorPalette('#6366f1');
    this.themeService.updateColorPalette('brand', palette);

    // Apply and save
    this.themeService.applyToDocument();
    this.themeService.saveThemeAs('Company Brand');
  }
}
```

### Pattern 2: Multi-Tenant Theming

```typescript
@Component({
  selector: 'app-tenant-settings',
  template: `<ax-theme-builder></ax-theme-builder>`,
})
export class TenantSettingsComponent {
  themeService = inject(ThemeBuilderService);
  tenantService = inject(TenantService);

  async saveTenantTheme(): Promise<void> {
    const theme = this.themeService.exportTheme('json');

    await this.tenantService.saveThemeConfig({
      tenantId: this.tenantService.currentTenant().id,
      themeConfig: JSON.parse(theme),
    });
  }

  async loadTenantTheme(): Promise<void> {
    const config = await this.tenantService.getThemeConfig();

    if (config) {
      this.themeService.importFromJson(JSON.stringify(config));
      this.themeService.applyToDocument();
    }
  }
}
```

---

## Related Components

- **ax-theme-switcher** - Quick theme selection menu
- **AxThemeService** - Core theme management service
- **ax-color-palette-editor** - Standalone color palette editor (internal)
- **ax-m3-color-preview** - Material Design 3 color preview (internal)

---

## Related Documentation

- [THEMING_GUIDE.md](../../THEMING_GUIDE.md) - Material-First theming philosophy and token system
- [Material Design 3 Color System](https://m3.material.io/styles/color) - Google's M3 color documentation
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/) - Web accessibility guidelines
- [Theme Service API](../../services/theme-service.md) - Theme service documentation

---

## Advanced Topics

### Custom Color Generation

The theme builder uses advanced color generation algorithms:

```typescript
// Generate 10-shade palette from base color
function generateColorShades(baseColor: string): string[] {
  // Uses HSL color space
  // Lightness ranges: 95%, 90%, 80%, 70%, 60%, 50%, 40%, 30%, 20%, 10%
  // Maintains hue and saturation
}
```

### M3 Color Scheme Generation

Material Design 3 color schemes are generated using Material Color Utilities:

```typescript
import { argbFromHex, themeFromSourceColor, applyTheme } from '@material/material-color-utilities';

// Generate M3 scheme
const theme = themeFromSourceColor(argbFromHex('#6366f1'));
const lightScheme = theme.schemes.light;
const darkScheme = theme.schemes.dark;
```

---

**Last Updated:** 2025-12-17
**Component Version:** 2.0.0
