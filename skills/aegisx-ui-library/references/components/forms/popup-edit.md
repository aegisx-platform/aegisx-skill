# Popup Edit

## Overview

The Popup Edit component (`ax-popup-edit`) provides inline editing functionality with an overlay input popup. Perfect for editable table cells, inline form fields, and quick updates without navigating away from the current view.

**Key Features:**

- ✏️ Click-to-edit inline interface
- 📝 Support for text, number, and textarea inputs
- ⌨️ Keyboard shortcuts (Enter to save, Escape to cancel)
- 🎯 Material Design integration
- ✅ Optional validation function
- 🎨 Customizable appearance
- ♿ Accessible with proper ARIA attributes

## Installation & Import

```typescript
import { AxPopupEditComponent } from '@aegisx/ui';

// Required Material modules
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';

@Component({
  standalone: true,
  imports: [AxPopupEditComponent, MatInputModule, MatButtonModule, MatIconModule],
})
export class MyComponent {}
```

## Basic Usage

### Text Input

```typescript
@Component({
  template: `
    <ax-popup-edit [(value)]="userName" label="Name" (saveEvent)="onSave($event)">
      {{ userName }}
    </ax-popup-edit>
  `,
})
export class Component {
  userName = 'John Doe';

  onSave(newValue: string | number) {
    console.log('Saved:', newValue);
    // API call to update
  }
}
```

### Number Input

```typescript
<ax-popup-edit
  [(value)]="price"
  type="number"
  label="Price"
  (saveEvent)="updatePrice($event)">
  {{ price | currency }}
</ax-popup-edit>
```

### Textarea

```typescript
<ax-popup-edit
  [(value)]="description"
  type="textarea"
  [rows]="3"
  label="Description"
  (saveEvent)="updateDescription($event)">
  {{ description }}
</ax-popup-edit>
```

## API Reference

### Inputs

| Name          | Type                                   | Default     | Description                 |
| ------------- | -------------------------------------- | ----------- | --------------------------- |
| `value`       | `string \| number`                     | `''`        | Current value               |
| `type`        | `'text' \| 'number' \| 'textarea'`     | `'text'`    | Input type                  |
| `label`       | `string`                               | `''`        | Form field label            |
| `placeholder` | `string`                               | `''`        | Placeholder text            |
| `rows`        | `number`                               | `3`         | Number of rows for textarea |
| `disabled`    | `boolean`                              | `false`     | Disable editing             |
| `showButtons` | `boolean`                              | `true`      | Show action buttons         |
| `saveLabel`   | `string`                               | `'Save'`    | Save button label           |
| `cancelLabel` | `string`                               | `'Cancel'`  | Cancel button label         |
| `validate`    | `(value: string \| number) => boolean` | `undefined` | Validation function         |

### Outputs

| Name          | Type                             | Description              |
| ------------- | -------------------------------- | ------------------------ |
| `valueChange` | `EventEmitter<string \| number>` | Emits when value changes |
| `saveEvent`   | `EventEmitter<string \| number>` | Emits on save            |
| `cancelEvent` | `EventEmitter<void>`             | Emits on cancel          |
| `opened`      | `EventEmitter<void>`             | Emits when popup opens   |
| `closed`      | `EventEmitter<void>`             | Emits when popup closes  |

### Methods

| Name       | Signature  | Description              |
| ---------- | ---------- | ------------------------ |
| `open()`   | `(): void` | Open the edit popup      |
| `save()`   | `(): void` | Save changes and close   |
| `cancel()` | `(): void` | Cancel changes and close |

## Advanced Usage

### With Validation

```typescript
@Component({
  template: `
    <ax-popup-edit [(value)]="email" label="Email" [validate]="validateEmail" (saveEvent)="onEmailSave($event)">
      {{ email }}
    </ax-popup-edit>
  `,
})
export class Component {
  email = 'user@example.com';

  validateEmail = (value: string | number): boolean => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(value.toString());
  };

  onEmailSave(newEmail: string | number) {
    console.log('Valid email saved:', newEmail);
  }
}
```

### In Data Table

```typescript
@Component({
  template: `
    <table>
      <thead>
        <tr>
          <th>Name</th>
          <th>Price</th>
          <th>Description</th>
        </tr>
      </thead>
      <tbody>
        @for (item of items; track item.id) {
          <tr>
            <td>
              <ax-popup-edit [(value)]="item.name" label="Name" (saveEvent)="updateItem(item.id, 'name', $event)">
                {{ item.name }}
              </ax-popup-edit>
            </td>
            <td>
              <ax-popup-edit [(value)]="item.price" type="number" label="Price" (saveEvent)="updateItem(item.id, 'price', $event)">
                {{ item.price | currency }}
              </ax-popup-edit>
            </td>
            <td>
              <ax-popup-edit [(value)]="item.description" type="textarea" [rows]="2" (saveEvent)="updateItem(item.id, 'description', $event)">
                {{ item.description }}
              </ax-popup-edit>
            </td>
          </tr>
        }
      </tbody>
    </table>
  `,
})
export class ProductTableComponent {
  items = [
    { id: 1, name: 'Widget', price: 19.99, description: 'A great widget' },
    { id: 2, name: 'Gadget', price: 29.99, description: 'An awesome gadget' },
  ];

  updateItem(id: number, field: string, value: string | number) {
    this.api.updateProduct(id, { [field]: value }).subscribe();
  }
}
```

### Custom Buttons

```typescript
<ax-popup-edit
  [(value)]="status"
  label="Status"
  saveLabel="Update"
  cancelLabel="Discard"
  (saveEvent)="onStatusUpdate($event)">
  {{ status }}
</ax-popup-edit>
```

### Without Action Buttons

```typescript
<ax-popup-edit
  [(value)]="note"
  label="Quick Note"
  [showButtons]="false"
  (saveEvent)="autoSave($event)">
  {{ note }}
</ax-popup-edit>
<!-- Saves automatically on Enter or focus loss -->
```

### Lifecycle Hooks

```typescript
@Component({
  template: `
    <ax-popup-edit [(value)]="data" (opened)="onEditStart()" (closed)="onEditEnd()" (saveEvent)="onSave($event)" (cancelEvent)="onCancel()">
      {{ data }}
    </ax-popup-edit>
  `,
})
export class Component {
  data = 'Edit me';

  onEditStart() {
    console.log('Editing started');
    // Track analytics, lock record, etc.
  }

  onEditEnd() {
    console.log('Editing ended');
    // Release lock, cleanup
  }

  onSave(value: string | number) {
    console.log('Saved:', value);
  }

  onCancel() {
    console.log('Cancelled');
  }
}
```

## Styling & Theming

### CSS Variables

```css
.ax-popup-edit {
  --popup-edit-icon-color: #6b7280;
  --popup-edit-hover-bg: #f3f4f6;
  --popup-edit-panel-width: 300px;
  --popup-edit-panel-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
}
```

### Custom Styling

```scss
.custom-popup-edit {
  .ax-popup-edit {
    padding: 0.5rem;
    border-radius: 0.25rem;
    transition: background-color 0.2s;

    &:hover:not(.ax-popup-edit--disabled) {
      background-color: var(--popup-edit-hover-bg);
    }

    .ax-popup-edit__icon {
      opacity: 0;
      transition: opacity 0.2s;
    }

    &:hover .ax-popup-edit__icon {
      opacity: 1;
    }
  }

  .ax-popup-edit__panel {
    border: 1px solid #e5e7eb;
    border-radius: 0.5rem;
    box-shadow: var(--popup-edit-panel-shadow);
  }
}
```

## Accessibility

### ARIA Attributes

```html
<div class="ax-popup-edit" tabindex="0" role="button" aria-label="Edit field" (click)="open()">
  <ng-content></ng-content>
  <mat-icon aria-hidden="true">edit</mat-icon>
</div>

<div class="ax-popup-edit__panel" role="dialog" aria-modal="true" aria-label="Edit dialog">
  <input matInput aria-label="Edit value" />
</div>
```

### Keyboard Navigation

| Key      | Action                               |
| -------- | ------------------------------------ |
| `Enter`  | Open popup (when focused on trigger) |
| `Enter`  | Save changes (when focused in input) |
| `Escape` | Cancel and close popup               |
| `Tab`    | Navigate between input and buttons   |

**Behavior:**

- Focus automatically moves to input when popup opens
- Input text is pre-selected for easy replacement
- Enter key saves (except in textarea mode)
- Escape always cancels
- Click outside backdrop cancels

### Screen Reader Support

```typescript
// Announcements
'Edit field button';
'Edit dialog opened';
'Text input, Name, Edit me';
'Changes saved';
'Changes cancelled';
```

## Validation Patterns

### Email Validation

```typescript
validateEmail = (value: string | number): boolean => {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value.toString());
};

<ax-popup-edit
  [(value)]="email"
  [validate]="validateEmail">
  {{ email }}
</ax-popup-edit>
```

### Number Range Validation

```typescript
validatePrice = (value: string | number): boolean => {
  const price = Number(value);
  return !isNaN(price) && price >= 0 && price <= 10000;
};

<ax-popup-edit
  [(value)]="price"
  type="number"
  [validate]="validatePrice">
  {{ price }}
</ax-popup-edit>
```

### Length Validation

```typescript
validateLength = (value: string | number): boolean => {
  return value.toString().length >= 3 && value.toString().length <= 100;
};

<ax-popup-edit
  [(value)]="description"
  [validate]="validateLength">
  {{ description }}
</ax-popup-edit>
```

### Custom Validation with Feedback

```typescript
@Component({
  template: `
    <ax-popup-edit [(value)]="username" [validate]="validateUsername" (saveEvent)="onSave($event)">
      {{ username }}
    </ax-popup-edit>

    @if (validationError) {
      <span class="error">{{ validationError }}</span>
    }
  `,
})
export class Component {
  username = 'john_doe';
  validationError = '';

  validateUsername = (value: string | number): boolean => {
    const username = value.toString();

    if (username.length < 3) {
      this.validationError = 'Username must be at least 3 characters';
      return false;
    }

    if (!/^[a-zA-Z0-9_]+$/.test(username)) {
      this.validationError = 'Only letters, numbers, and underscores allowed';
      return false;
    }

    this.validationError = '';
    return true;
  };

  onSave(newUsername: string | number) {
    console.log('Username saved:', newUsername);
    this.validationError = '';
  }
}
```

## Use Cases

### Profile Editor

```typescript
@Component({
  template: `
    <div class="profile-card">
      <div class="field">
        <label>Name:</label>
        <ax-popup-edit [(value)]="profile.name" label="Full Name" (saveEvent)="updateProfile('name', $event)">
          {{ profile.name }}
        </ax-popup-edit>
      </div>

      <div class="field">
        <label>Email:</label>
        <ax-popup-edit [(value)]="profile.email" label="Email Address" [validate]="validateEmail" (saveEvent)="updateProfile('email', $event)">
          {{ profile.email }}
        </ax-popup-edit>
      </div>

      <div class="field">
        <label>Bio:</label>
        <ax-popup-edit [(value)]="profile.bio" type="textarea" [rows]="4" label="Biography" (saveEvent)="updateProfile('bio', $event)">
          {{ profile.bio }}
        </ax-popup-edit>
      </div>
    </div>
  `,
})
export class ProfileEditorComponent {
  profile = {
    name: 'John Doe',
    email: 'john@example.com',
    bio: 'Software developer',
  };

  validateEmail = (value: string | number): boolean => {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value.toString());
  };

  updateProfile(field: string, value: string | number) {
    this.profileService.update({ [field]: value }).subscribe();
  }
}
```

### Inventory Management

```typescript
@Component({
  template: `
    <table class="inventory-table">
      <thead>
        <tr>
          <th>Product</th>
          <th>SKU</th>
          <th>Stock</th>
          <th>Price</th>
        </tr>
      </thead>
      <tbody>
        @for (product of inventory; track product.id) {
          <tr>
            <td>
              <ax-popup-edit [(value)]="product.name" (saveEvent)="save(product.id, 'name', $event)">
                {{ product.name }}
              </ax-popup-edit>
            </td>
            <td>
              <ax-popup-edit [(value)]="product.sku" [validate]="validateSKU" (saveEvent)="save(product.id, 'sku', $event)">
                {{ product.sku }}
              </ax-popup-edit>
            </td>
            <td>
              <ax-popup-edit [(value)]="product.stock" type="number" [validate]="validateStock" (saveEvent)="save(product.id, 'stock', $event)">
                {{ product.stock }}
              </ax-popup-edit>
            </td>
            <td>
              <ax-popup-edit [(value)]="product.price" type="number" [validate]="validatePrice" (saveEvent)="save(product.id, 'price', $event)">
                {{ product.price | currency }}
              </ax-popup-edit>
            </td>
          </tr>
        }
      </tbody>
    </table>
  `,
})
export class InventoryComponent {
  inventory = [
    { id: 1, name: 'Widget', sku: 'WDG-001', stock: 50, price: 19.99 },
    { id: 2, name: 'Gadget', sku: 'GDG-002', stock: 30, price: 29.99 },
  ];

  validateSKU = (value: string | number): boolean => {
    return /^[A-Z]{3}-\d{3}$/.test(value.toString());
  };

  validateStock = (value: string | number): boolean => {
    const stock = Number(value);
    return !isNaN(stock) && stock >= 0 && Number.isInteger(stock);
  };

  validatePrice = (value: string | number): boolean => {
    const price = Number(value);
    return !isNaN(price) && price > 0;
  };

  save(id: number, field: string, value: string | number) {
    this.inventoryService.updateProduct(id, { [field]: value }).subscribe();
  }
}
```

## Integration with Material Design

The component uses Material components internally:

```typescript
// Required Material modules
imports: [
  MatInputModule, // For form fields
  MatButtonModule, // For action buttons
  MatFormFieldModule, // For form field wrapper
  MatIconModule, // For edit icon
  OverlayModule, // For popup positioning
];
```

### Material Theming

```scss
@use '@angular/material' as mat;

$theme: mat.define-theme(
  (
    color: (
      theme-type: light,
      primary: mat.$azure-palette,
    ),
  )
);

// Apply to popup edit
.ax-popup-edit {
  @include mat.all-component-themes($theme);
}
```

## Browser Compatibility

- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+
- ✅ Mobile Safari (iOS 14+)
- ✅ Chrome Mobile (Android 8+)

## Related Components

- [Input OTP](./input-otp.md) - OTP code input
- [Date Picker](./date-picker.md) - Date selection
- [Time Slots](./time-slots.md) - Time slot selection
