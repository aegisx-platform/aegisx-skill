---
name: aegisx-ui-library
version: 1.0.0
description: >
  Complete API reference for @aegisx/ui — 35+ Angular components across auth, data-display,
  feedback, forms, inventory, layout, navigation, theme, and integrations categories. Use when
  building any UI in AegisX: import paths, component props/events, variants, accessibility.
  Triggers on: ax-card, ax-data-table, ax-drawer, ax-launcher, ax-navigation, ax-theme-switcher,
  ax-empty-state, ax-skeleton, ax-barcode-scanner, ax-batch-selector, ax-expiry-badge,
  ax-stock-level, ax-transfer-wizard, login-form, register-form, calendar, date-picker,
  scheduler, time-slots, knob, gridster, layout-switcher, qrcode, signature-pad, code-tabs,
  theme-builder, error-state, loading-button, popup-edit, stock-alert-panel,
  stock-movement-timeline, variant-selector, quantity-input, location-picker, input-otp.
  For design patterns/tokens, see aegisx-ui-design.
  For TypeScript types, see aegisx-ui-types.
allowed-tools: Read, Grep, Glob, Write, Bash, WebFetch
---

# AegisX UI Library (@aegisx/ui)

Enterprise Angular UI library with layouts, components, and services built on Angular Material and TailwindCSS.

## Progressive Disclosure — Component Docs

Detailed docs for 35+ components live under `references/components/`. **Do NOT load all of them upfront.** Instead, when the user asks about a specific component, read the matching file:

| Category | Components | Reference path |
|---|---|---|
| **auth** | login-form, register-form, forgot-password-form, reset-password-form | `references/components/auth/<name>.md` |
| **data-display** | card, calendar, code-tabs, data-display | `references/components/data-display/<name>.md` |
| **feedback** | empty-state, error-state, loading-button, skeleton | `references/components/feedback/<name>.md` |
| **forms** | date-picker, input-otp, knob, popup-edit, scheduler, time-slots | `references/components/forms/<name>.md` |
| **inventory** | barcode-scanner, batch-selector, expiry-badge, location-picker, quantity-input, stock-alert-panel, stock-level, stock-movement-timeline, transfer-wizard, variant-selector | `references/components/inventory/<name>.md` |
| **layout** | gridster, layout-switcher | `references/components/layout/<name>.md` |
| **navigation** | drawer, launcher, navigation | `references/components/navigation/<name>.md` |
| **theme** | theme-builder, theme-switcher | `references/components/theme/<name>.md` |
| **integrations** | qrcode, signature-pad | `references/components/integrations/<name>.md` |

**Examples:**
- User says "เพิ่ม barcode scanner" → Read `references/components/inventory/barcode-scanner.md`
- User says "ทำ login form" → Read `references/components/auth/login-form.md`
- User says "ต้องใช้ empty state" → Read `references/components/feedback/empty-state.md`

Overview docs (load only when user asks for holistic view):
- `references/component-overview.md` — all components at a glance
- `references/COMPONENT_USAGE.md` — usage patterns across the library
- `references/ax-kpi-card-component.md` — KPI card deep-dive

## When Claude Should Use This Skill

- User asks about "@aegisx/ui" NPM package
- User wants to install the UI library in an Angular project
- User needs component documentation or examples
- User asks about available components and their usage
- User mentions "AegisX UI components" or "aegisx design system"
- User needs to understand component props and events
- User wants to customize or theme the UI library

## Package Information

### NPM Package

```bash
# Package name
@aegisx/ui

# Installation
npm install @aegisx/ui
# or
pnpm add @aegisx/ui
```

### Repository

- **Monorepo**: `libs/aegisx-ui/` in aegisx-starter-1
- **Standalone**: https://github.com/aegisx-platform/aegisx-ui
- **NPM**: https://www.npmjs.com/package/@aegisx/ui

### Current Version

- **v0.2.0** - Latest release with inventory management components

## Library Architecture

### Core Structure

```
@aegisx/ui
├── /core          - Core services and utilities
├── /layouts       - Layout components (navigation, sidebars)
├── /components    - Reusable UI components
└── /widgets       - Complex composite components
```

### Component Categories

1. **Data Display** (15+ components)
   - Tables, Lists, Cards, Charts, Badges

2. **Forms** (20+ components)
   - Inputs, Selects, Date Pickers, File Upload

3. **Feedback** (10+ components)
   - Alerts, Toasts, Modals, Loading States

4. **Navigation** (8+ components)
   - Navbar, Sidebar, Breadcrumbs, Tabs

5. **Layout** (6+ components)
   - Container, Grid, Flex, Spacer

6. **Auth** (5+ components)
   - Login, Register, Forgot Password

7. **Advanced** (12+ components)
   - QR Scanner, Signature Pad, Calendar, Rich Text Editor

8. **Inventory** (10 NEW components - v0.2.0)
   - Stock Level, Barcode Scanner, Batch Selector, etc.

## Installation Guide

### Step 1: Install Package

```bash
pnpm add @aegisx/ui
```

### Step 2: Install Peer Dependencies

```bash
pnpm add @angular/material @angular/cdk tailwindcss
```

### Step 3: Configure Angular Module

```typescript
// app.config.ts or app.module.ts
import { AegisxUiModule } from '@aegisx/ui';

export const appConfig: ApplicationConfig = {
  providers: [
    provideAnimations(),
    // ... other providers
  ],
};

// Or in NgModule:
@NgModule({
  imports: [
    AegisxUiModule,
    // ... other modules
  ],
})
export class AppModule {}
```

### Step 4: Include Styles

```scss
// styles.scss
@import '@aegisx/ui/styles';

// Or specific modules
@import '@aegisx/ui/core';
@import '@aegisx/ui/components';
```

### Step 5: Configure TailwindCSS

```javascript
// tailwind.config.js
module.exports = {
  content: ['./src/**/*.{html,ts}', './node_modules/@aegisx/ui/**/*.{html,ts,js}'],
  theme: {
    extend: {
      // Custom theme extensions
    },
  },
};
```

## Component Usage

### Inventory Components (v0.2.0)

#### Stock Level Indicator

```typescript
import { AxStockLevelComponent } from '@aegisx/ui/components';

@Component({
  selector: 'app-product',
  template: ` <ax-stock-level [currentStock]="product.quantity" [minStock]="product.min_quantity" [maxStock]="product.max_quantity" [unit]="product.unit" size="md" colorScheme="traffic-light" /> `,
  imports: [AxStockLevelComponent],
})
export class ProductComponent {
  product = {
    quantity: 50,
    min_quantity: 20,
    max_quantity: 200,
    unit: 'units',
  };
}
```

#### Barcode Scanner

```typescript
import { AxBarcodeScannerComponent } from '@aegisx/ui/components';

@Component({
  selector: 'app-inventory',
  template: ` <ax-barcode-scanner [formats]="['QR_CODE', 'EAN_13', 'CODE_128']" [continuous]="true" [showManualInput]="true" (scanSuccess)="onScan($event)" (scanError)="onError($event)" /> `,
  imports: [AxBarcodeScannerComponent],
})
export class InventoryComponent {
  onScan(result: string) {
    console.log('Scanned:', result);
  }

  onError(error: string) {
    console.error('Scan error:', error);
  }
}
```

#### Quantity Input

```typescript
import { AxQuantityInputComponent } from '@aegisx/ui/components';
import { FormControl } from '@angular/forms';

@Component({
  selector: 'app-order',
  template: ` <ax-quantity-input [formControl]="quantityControl" [unit]="'boxes'" [min]="1" [max]="1000" [step]="1" [showStepper]="true" [multipliers]="[10, 50, 100]" /> `,
  imports: [AxQuantityInputComponent],
})
export class OrderComponent {
  quantityControl = new FormControl(1);
}
```

#### Batch Selector

```typescript
import { AxBatchSelectorComponent } from '@aegisx/ui/components';

@Component({
  selector: 'app-transaction',
  template: ` <ax-batch-selector [strategy]="'FIFO'" [availableBatches]="batches" [requiredQuantity]="100" [multiSelect]="true" (batchesSelected)="onSelect($event)" /> `,
  imports: [AxBatchSelectorComponent],
})
export class TransactionComponent {
  batches = [
    {
      batchNumber: 'BATCH001',
      quantity: 50,
      expiryDate: new Date('2025-06-30'),
      status: 'safe' as const,
    },
    // ... more batches
  ];

  onSelect(selected: SelectedBatch[]) {
    console.log('Selected batches:', selected);
  }
}
```

### Form Components

#### File Upload

```typescript
import { AxFileUploadComponent } from '@aegisx/ui/components';

@Component({
  template: ` <ax-file-upload [accept]="'image/*,.pdf'" [maxSize]="5242880" [multiple]="true" [showPreview]="true" (filesSelected)="onFilesSelected($event)" /> `,
  imports: [AxFileUploadComponent],
})
export class UploadComponent {
  onFilesSelected(files: File[]) {
    console.log('Selected files:', files);
  }
}
```

#### Signature Pad

```typescript
import { AxSignaturePadComponent } from '@aegisx/ui/components';

@Component({
  template: ` <ax-signature-pad [width]="400" [height]="200" (signatureSaved)="onSave($event)" /> `,
  imports: [AxSignaturePadComponent],
})
export class SignatureComponent {
  onSave(signature: string) {
    // Base64 encoded signature
    console.log('Signature:', signature);
  }
}
```

### Navigation Components

#### Navbar

```typescript
import { AxNavigationComponent } from '@aegisx/ui/layouts';

@Component({
  template: ` <ax-navigation [logo]="logoUrl" [title]="'My App'" [menuItems]="menuItems" [userInfo]="currentUser" (menuClick)="onMenuClick($event)" /> `,
  imports: [AxNavigationComponent],
})
export class AppComponent {
  menuItems = [
    { label: 'Dashboard', route: '/dashboard', icon: 'home' },
    { label: 'Inventory', route: '/inventory', icon: 'inventory' },
  ];

  currentUser = {
    name: 'John Doe',
    email: 'john@example.com',
    avatar: 'https://...',
  };
}
```

## Theming & Customization

### Custom Theme

```scss
// styles.scss
@import '@aegisx/ui/styles';

// Override default theme
:root {
  --ax-primary: #1976d2;
  --ax-accent: #ff4081;
  --ax-warn: #f44336;
  --ax-background: #fafafa;
  --ax-surface: #ffffff;
  --ax-text-primary: rgba(0, 0, 0, 0.87);
  --ax-text-secondary: rgba(0, 0, 0, 0.54);
}

// Dark mode
[data-theme='dark'] {
  --ax-background: #303030;
  --ax-surface: #424242;
  --ax-text-primary: #ffffff;
  --ax-text-secondary: rgba(255, 255, 255, 0.7);
}
```

### Component Customization

```scss
// Custom styles for specific components
ax-button {
  &.custom-primary {
    --ax-button-bg: #custom-color;
    --ax-button-color: #ffffff;
  }
}

ax-table {
  --ax-table-header-bg: #f5f5f5;
  --ax-table-row-hover-bg: #e3f2fd;
}
```

## Advanced Features

### Real-Time Updates (WebSocket)

```typescript
import { AxStockAlertPanelComponent } from '@aegisx/ui/components';

@Component({
  template: ` <ax-stock-alert-panel [wsEndpoint]="'ws://localhost:3000/stock-alerts'" [autoRefresh]="true" [refreshInterval]="30000" [soundEnabled]="true" (alertClick)="onAlertClick($event)" /> `,
  imports: [AxStockAlertPanelComponent],
})
export class DashboardComponent {
  onAlertClick(alert: StockAlert) {
    // Handle alert click
  }
}
```

### Data Export

```typescript
import { AxStockMovementTimelineComponent } from '@aegisx/ui/components';

@Component({
  template: ` <ax-stock-movement-timeline [movements]="movements" [showChart]="true" [exportFormats]="['pdf', 'excel', 'csv']" (export)="onExport($event)" /> `,
  imports: [AxStockMovementTimelineComponent],
})
export class ReportsComponent {
  onExport(data: { format: string; data: any }) {
    console.log('Exporting to', data.format);
  }
}
```

## Type System

### Component Props Types

```typescript
import { StockLevelConfig, BatchInfo, BarcodeScanConfig, ProductVariant } from '@aegisx/ui/types';

// Use exported types for type safety
const config: StockLevelConfig = {
  minStock: 10,
  maxStock: 100,
  warningThreshold: 20,
  criticalThreshold: 5,
};

const batch: BatchInfo = {
  batchNumber: 'BATCH001',
  quantity: 100,
  expiryDate: new Date('2025-12-31'),
  status: 'safe',
};
```

## Best Practices

### DO:

- ✅ Import only components you need
- ✅ Use standalone components for better tree-shaking
- ✅ Follow Angular style guide conventions
- ✅ Leverage TypeScript types provided by the library
- ✅ Use reactive forms with components
- ✅ Test components in isolation

### DON'T:

- ❌ Import the entire library if you only need a few components
- ❌ Override internal component styles directly
- ❌ Ignore accessibility features
- ❌ Skip peer dependency installation

## Troubleshooting

### Common Issues

1. **"Module not found"**

   ```bash
   # Ensure package is installed
   pnpm install @aegisx/ui

   # Clear cache and reinstall
   rm -rf node_modules .angular
   pnpm install
   ```

2. **Styles not loading**

   ```scss
   // Ensure styles are imported in styles.scss
   @import '@aegisx/ui/styles';
   ```

3. **Components not rendering**

   ```typescript
   // Make sure to import component
   import { AxButtonComponent } from '@aegisx/ui/components';

   @Component({
     imports: [AxButtonComponent], // Add to imports
   })
   ```

## Migration Guide

### From v0.1.x to v0.2.0

```typescript
// BEFORE (v0.1.x)
import { StockLevel } from '@aegisx/ui';

// AFTER (v0.2.0)
import { AxStockLevelComponent } from '@aegisx/ui/components';
```

## Resources

- **Documentation**: [Component Usage Guide](https://github.com/aegisx-platform/aegisx-ui/blob/main/COMPONENT_USAGE.md)
- **Examples**: Storybook (coming soon)
- **Issues**: https://github.com/aegisx-platform/aegisx-ui/issues
- **Changelog**: [CHANGELOG.md](https://github.com/aegisx-platform/aegisx-ui/blob/main/CHANGELOG.md)

## Related Skills

- `angular-frontend-expert` - Angular development expertise
- `angular-ui-designer` - UI design and implementation
- `ui-ux-expert` - UX best practices
- `frontend-integration-guide` - Component integration guide
