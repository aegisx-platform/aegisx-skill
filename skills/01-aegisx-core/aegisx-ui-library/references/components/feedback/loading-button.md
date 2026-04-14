# Loading Button Component

## Overview

The **Loading Button** (`ax-loading-button`) is a modern, accessible button component that provides clear visual feedback during async operations. It combines gradient backgrounds, shimmer effects, pulse animations, and CSS-only spinners to create engaging loading states without compromising performance.

### When to Use

- **Form submissions**: Sign up, login, or any form completion action
- **Data operations**: Save, delete, or update operations that take time
- **Async processes**: File uploads, API calls, or long-running operations
- **Action buttons**: Any primary action where user feedback is critical

### UX Best Practices

1. **Clear loading text**: Always provide contextual loading text (e.g., "Signing in..." not just "Loading...")
2. **Disabled during loading**: Prevent duplicate submissions by disabling the button
3. **Appropriate icon positioning**: Use end position for icons (arrow-forward pattern)
4. **Consistent styling**: Match your app's color scheme and use appropriate variants
5. **Quick feedback**: Display for at least 400ms to avoid flicker on fast operations

## Installation & Import

```typescript
import { AxLoadingButtonComponent } from '@aegisx/ui';

// In your component
import { Component } from '@angular/core';
import { AxLoadingButtonComponent } from '@aegisx/ui';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [AxLoadingButtonComponent],
  template: `...`,
})
export class LoginComponent {}
```

## Basic Usage

### Simple Loading State

```html
<ax-loading-button [loading]="isLoading" loadingText="Signing in..." (buttonClick)="onSubmit()"> Sign In </ax-loading-button>
```

```typescript
export class LoginComponent {
  isLoading = false;

  async onSubmit() {
    this.isLoading = true;
    try {
      await this.authService.login(credentials);
    } finally {
      this.isLoading = false;
    }
  }
}
```

### With Icon

```html
<ax-loading-button [loading]="isLoading" loadingText="Sending..." icon="send" iconPosition="end" (buttonClick)="onSend()"> Send Email </ax-loading-button>
```

### Full Width Button

```html
<ax-loading-button [loading]="isLoading" [fullWidth]="true" loadingText="Processing..." (buttonClick)="onProcess()"> Process Payment </ax-loading-button>
```

## API Reference

### Inputs

| Name                 | Type                                         | Default        | Description                                                                     |
| -------------------- | -------------------------------------------- | -------------- | ------------------------------------------------------------------------------- |
| `variant`            | `'raised' \| 'stroked' \| 'flat' \| 'basic'` | `'raised'`     | Button style variant. Use `raised` for primary actions, `stroked` for secondary |
| `color`              | `'primary' \| 'accent' \| 'warn' \| ''`      | `'primary'`    | Material color theme                                                            |
| `loading`            | `boolean`                                    | `false`        | Whether button is in loading state. Triggers spinner and text change            |
| `loadingText`        | `string`                                     | `'Loading...'` | Text displayed during loading state. Should be contextual (e.g., "Saving...")   |
| `disabled`           | `boolean`                                    | `false`        | Disables button interaction completely                                          |
| `disableWhenLoading` | `boolean`                                    | `true`         | Automatically disable button during loading to prevent duplicate submissions    |
| `type`               | `'button' \| 'submit' \| 'reset'`            | `'button'`     | HTML button type attribute                                                      |
| `icon`               | `string`                                     | `''`           | Material icon name (e.g., 'send', 'check', 'download')                          |
| `iconPosition`       | `'start' \| 'end'`                           | `'end'`        | Position of icon relative to text                                               |
| `fullWidth`          | `boolean`                                    | `false`        | Makes button 100% width of parent container                                     |

### Outputs

| Name          | Type                       | Description                                                                                 |
| ------------- | -------------------------- | ------------------------------------------------------------------------------------------- |
| `buttonClick` | `EventEmitter<MouseEvent>` | Emitted when button is clicked (only when not loading). Use instead of native click handler |

### Methods

| Name      | Signature                     | Description                                  |
| --------- | ----------------------------- | -------------------------------------------- |
| `onClick` | `(event: MouseEvent) => void` | Internal click handler. Do not call directly |

## Advanced Usage

### Loading State Transitions

```typescript
export class DataSaveComponent {
  isLoading = false;
  saveStatus: 'idle' | 'saving' | 'success' | 'error' = 'idle';

  async saveData(data: FormData) {
    this.isLoading = true;
    this.saveStatus = 'saving';

    try {
      await this.dataService.save(data);
      this.saveStatus = 'success';

      // Brief success feedback before resetting
      setTimeout(() => {
        this.isLoading = false;
        this.saveStatus = 'idle';
      }, 1500);
    } catch (error) {
      this.saveStatus = 'error';
      this.isLoading = false;
      this.showErrorNotification(error.message);
    }
  }
}
```

```html
<ax-loading-button [loading]="isLoading" [disabled]="saveStatus === 'error'" [loadingText]="loadingText" (buttonClick)="saveData(formData)"> {{ buttonLabel }} </ax-loading-button>

<ng-container [ngSwitch]="saveStatus">
  <div *ngSwitchCase="'success'" class="success-message">Data saved successfully!</div>
  <div *ngSwitchCase="'error'" class="error-message">Failed to save. Please try again.</div>
</ng-container>
```

### Multiple Button Variants

```html
<div class="button-group">
  <!-- Primary action -->
  <ax-loading-button variant="raised" [loading]="isSubmitting" loadingText="Submitting..." (buttonClick)="onSubmit()"> Submit </ax-loading-button>

  <!-- Secondary action -->
  <ax-loading-button variant="stroked" [loading]="isSaving" loadingText="Saving..." (buttonClick)="onDraft()"> Save as Draft </ax-loading-button>

  <!-- Tertiary action -->
  <ax-loading-button variant="flat" [loading]="isDeleting" loadingText="Deleting..." (buttonClick)="onDelete()"> Delete </ax-loading-button>
</div>
```

### Error Handling with Retry

```typescript
export class UploadComponent {
  isLoading = false;
  uploadError: string | null = null;

  async onUpload(file: File) {
    this.isLoading = true;
    this.uploadError = null;

    try {
      await this.fileService.upload(file);
      // Success - show confirmation
    } catch (error) {
      this.uploadError = error.message;
      this.isLoading = false;
      // User can retry immediately
    }
  }
}
```

```html
<div class="upload-container">
  <ax-loading-button [loading]="isLoading" [disabled]="!file" loadingText="Uploading..." icon="cloud_upload" (buttonClick)="onUpload(selectedFile)"> Upload </ax-loading-button>

  <div *ngIf="uploadError" class="error-message">
    {{ uploadError }}
    <!-- User can retry by clicking button again -->
  </div>
</div>
```

### Form Submission Pattern

```html
<form [formGroup]="form">
  <input formControlName="email" />
  <input formControlName="password" />

  <ax-loading-button type="submit" [loading]="isSubmitting" [disabled]="form.invalid" loadingText="Signing in..." icon="login" [fullWidth]="true" (buttonClick)="onSubmit()"> Sign In </ax-loading-button>
</form>
```

## Loading State Patterns

### Loading State Lifecycle

```
┌─────────────────────────────────────────────────────┐
│ IDLE STATE                                          │
│ - Normal appearance                                 │
│ - Button clickable                                  │
│ - Icon visible (if provided)                        │
└────────────────┬────────────────────────────────────┘
                 │ User clicks button
                 ▼
┌─────────────────────────────────────────────────────┐
│ LOADING STATE                                       │
│ - Gradient background (raised variant)              │
│ - Shimmer effect overlay                            │
│ - Pulse animation (opacity)                         │
│ - CSS spinner visible                               │
│ - Loading text displayed                            │
│ - Button disabled (if disableWhenLoading=true)     │
│ - Pointer events blocked                            │
└────────────────┬────────────────────────────────────┘
                 │ Operation completes
                 ▼
┌─────────────────────────────────────────────────────┐
│ RETURN TO IDLE                                      │
│ - Normal appearance restored                        │
│ - Button clickable again                            │
└─────────────────────────────────────────────────────┘
```

### Animation Details

**Raised Variant (Primary):**

- Gradient: 135° from brand-default to brand-emphasis
- Pulse: 2s cubic-bezier, opacity 1 → 0.85 → 1
- Shimmer: 1.5s linear, white transparent gradient moving left to right
- Spinner: 0.8s linear rotation

**Stroked/Flat/Basic Variants:**

- No gradient background
- Opacity reduced to 0.8
- Spinner color matches text color
- Pulse animation not applied

## Error Handling Examples

### Network Error Handling

```typescript
export class ApiCallComponent {
  isLoading = false;

  async fetchData() {
    this.isLoading = true;

    try {
      const data = await this.api.getData();
      this.processData(data);
    } catch (error) {
      if (error.status === 408) {
        this.showMessage('Request timed out. Please try again.');
      } else if (error.status === 429) {
        this.showMessage('Too many requests. Please wait before retrying.');
      } else if (error.status >= 500) {
        this.showMessage('Server error. Our team has been notified.');
      } else {
        this.showMessage('Something went wrong. Please try again.');
      }
      this.isLoading = false;
    }
  }
}
```

### User-Friendly Error Messages

```typescript
export class DeleteComponent {
  isDeleting = false;
  deleteError: string | null = null;

  async onDelete(id: string) {
    this.isDeleting = true;
    this.deleteError = null;

    try {
      await this.service.delete(id);
      // Success
    } catch (error) {
      // Translate technical errors to user-friendly messages
      if (error.code === 'FOREIGN_KEY_CONSTRAINT') {
        this.deleteError = 'Cannot delete - this item is used elsewhere';
      } else if (error.code === 'PERMISSION_DENIED') {
        this.deleteError = 'You do not have permission to delete this item';
      } else {
        this.deleteError = 'Failed to delete. Please try again.';
      }
      this.isDeleting = false;
    }
  }
}
```

```html
<ax-loading-button [loading]="isDeleting" loadingText="Deleting..." (buttonClick)="onDelete(itemId)"> Delete Item </ax-loading-button>

<div *ngIf="deleteError" class="error-alert" role="alert">{{ deleteError }}</div>
```

### Validation Before Loading

```html
<form [formGroup]="form">
  <input formControlName="email" />
  <input formControlName="password" />

  <ax-loading-button type="submit" [loading]="isLoading" [disabled]="form.invalid || isLoading" loadingText="Validating..." (buttonClick)="onSubmit()"> Proceed </ax-loading-button>
</form>
```

## Styling & Theming

### CSS Variables

The component respects theme tokens for color, spacing, and radius:

```css
--ax-brand-default        /* Primary color */
--ax-brand-emphasis       /* Hover/focused state */
--ax-brand-subtle         /* Light background */
--ax-brand-muted          /* Muted variant */
--ax-radius-md            /* Border radius */
--ax-shadow-sm            /* Raised shadow */
--ax-shadow-md            /* Hover shadow */
--ax-background-muted     /* Basic variant hover */
```

### Custom Styling

```css
/* Override button height */
ax-loading-button {
  --button-height: 52px;
}

/* Override spinner color for specific button */
ax-loading-button.custom-spinner .spinner-ring {
  border-top-color: var(--custom-accent);
}
```

### Dark Mode

The component automatically adapts to dark mode:

- Background colors adjust via CSS variables
- Text contrast maintained
- Spinner colors adjust for visibility

## Accessibility

### ARIA & Semantic HTML

- Uses native `<button>` element with semantic HTML
- Respects `disabled` attribute state
- Announces loading state via content changes
- Button type (`submit`, `button`) properly configured

### Keyboard Navigation

- **Tab**: Navigate to button
- **Space/Enter**: Activate button (when not loading)
- **No focus trap**: Loading state doesn't trap keyboard focus
- **Disabled state**: Skipped in tab order when disabled

### Screen Readers

```html
<!-- Good: Loading text provides context -->
<ax-loading-button [loading]="isProcessing" loadingText="Processing payment..."> Pay Now </ax-loading-button>

<!-- Screen reader announces: "Button, Processing payment..." -->
```

### Color & Icons

- Does not rely on color alone to communicate status
- Icon combined with text for clarity
- Loading spinner is CSS-based (no image dependencies)
- Works with high contrast mode

## Related Components

- **[Skeleton](./skeleton.md)** - Use to show placeholder content while loading
- **[Error State](./error-state.md)** - Display error messages after failed operations
- **[Empty State](./empty-state.md)** - Show when no results are available
- **Material Button** - Base Material Design button styling
