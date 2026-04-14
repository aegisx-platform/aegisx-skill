# Error State Component

## Overview

The **Error State** (`ax-error-state`) is a comprehensive feedback component for displaying errors, warnings, and informational messages. It combines visual hierarchy, actionable content slots, collapsible technical details, and user-friendly language to help users understand what went wrong and how to recover.

### When to Use

- **Failed operations**: Data load failures, save errors, API timeouts
- **User mistakes**: Invalid input, missing required fields, constraint violations
- **System issues**: Server errors, permission denied, maintenance mode
- **Fallback screens**: When core functionality is unavailable
- **Network problems**: Connection failures, timeout messages

### UX Best Practices

1. **User-friendly language**: Explain what happened without technical jargon
2. **Clear recovery path**: Provide actionable next steps (retry, contact support, etc.)
3. **Hide technical details**: Collapse error stack traces for advanced users
4. **Appropriate type**: Use error (default), warning, or info variants correctly
5. **Consistent positioning**: Use full-page or inline depending on severity
6. **Actionable primary button**: Always provide at least a "Retry" or "Go Back" action
7. **Avoid blame language**: Don't say "you failed" - say "we couldn't complete this"

## Installation & Import

```typescript
import { AxErrorStateComponent } from '@aegisx/ui';

// In your component
import { Component } from '@angular/core';
import { AxErrorStateComponent } from '@aegisx/ui';

@Component({
  selector: 'app-data-view',
  standalone: true,
  imports: [AxErrorStateComponent],
  template: `...`,
})
export class DataViewComponent {}
```

## Basic Usage

### Simple Error Message

```html
<ax-error-state
  title="Failed to Load Data"
  message="We couldn't retrieve your data. Please check your connection and try again."
  [actions]="[
    { label: 'Retry', primary: true, callback: onRetry }
  ]"
></ax-error-state>
```

### Warning Message

```html
<ax-error-state
  type="warning"
  title="Storage Quota Nearly Full"
  message="You are using 95% of your storage. Please delete some items."
  icon="storage"
  [actions]="[
    { label: 'Manage Storage', primary: true, callback: openStorage }
  ]"
></ax-error-state>
```

### Info Message

```html
<ax-error-state type="info" title="Maintenance Mode" message="We're performing scheduled maintenance. We'll be back online shortly." icon="info"></ax-error-state>
```

### With Status Code

```html
<ax-error-state
  [statusCode]="404"
  message="The page you are looking for could not be found."
  [actions]="[
    { label: 'Go Home', primary: true, callback: goHome }
  ]"
></ax-error-state>
```

## API Reference

### Inputs

| Name           | Type                             | Default     | Description                                                                            |
| -------------- | -------------------------------- | ----------- | -------------------------------------------------------------------------------------- |
| `title`        | `string \| undefined`            | `undefined` | Error title. If not provided and `statusCode` is set, generates title from status code |
| `message`      | `string \| undefined`            | `undefined` | User-friendly error message explaining what happened                                   |
| `icon`         | `string \| undefined`            | `undefined` | Material icon name (e.g., 'error_outline'). Overrides default icon                     |
| `errorDetails` | `string \| undefined`            | `undefined` | Technical error details (stack trace, error code). Hidden by default, collapsible      |
| `type`         | `'error' \| 'warning' \| 'info'` | `'error'`   | Error type determines color, icon, and styling                                         |
| `compact`      | `boolean`                        | `false`     | Compact layout with smaller padding and icon                                           |
| `statusCode`   | `number \| null`                 | `null`      | HTTP status code (400, 404, 500, etc.). Auto-generates title if `title` not provided   |
| `showDetails`  | `boolean`                        | `false`     | Show technical details by default (usually false for production)                       |
| `actions`      | `ErrorStateAction[]`             | `[]`        | Array of action buttons with callbacks                                                 |

### Outputs

None - Error state is primarily a presentational component

### Interfaces

#### ErrorStateAction

```typescript
interface ErrorStateAction {
  label: string; // Button text
  icon?: string; // Optional Material icon
  primary?: boolean; // Primary styling (raised button)
  callback: () => void; // Called when button clicked
}
```

### Methods

None - Input properties only

### Content Projection

```html
<!-- ng-content slot for custom content -->
<ax-error-state title="Error" message="Something went wrong.">
  <!-- Custom content inserted here -->
  <div>Additional troubleshooting steps</div>
</ax-error-state>

<!-- ng-content select for action slot -->
<ax-error-state title="Error" message="Something went wrong.">
  <!-- Custom action buttons -->
  <button error-state-actions>Custom Action</button>
</ax-error-state>
```

## Advanced Usage

### Error with Technical Details

```typescript
export class ApiErrorComponent {
  error: any = null;
  showTechDetails = false;

  async loadData() {
    try {
      await this.api.getData();
    } catch (err) {
      this.error = {
        title: 'Failed to Load',
        message: 'We encountered an unexpected error. Our team has been notified.',
        errorDetails: err.stack || JSON.stringify(err, null, 2),
        actions: [
          {
            label: 'Retry',
            primary: true,
            callback: () => this.loadData(),
          },
          {
            label: 'Contact Support',
            icon: 'mail',
            callback: () => this.contactSupport(),
          },
        ],
      };
    }
  }

  contactSupport() {
    // Open support contact form or email
  }
}
```

```html
<ax-error-state *ngIf="error" [title]="error.title" [message]="error.message" [errorDetails]="error.errorDetails" [showDetails]="showTechDetails" [actions]="error.actions" type="error"></ax-error-state>
```

### HTTP Status Code Handling

```typescript
export class HttpErrorComponent {
  errors: Record<number, any> = {
    400: {
      title: 'Invalid Input',
      message: 'Please review your input and try again.',
    },
    401: {
      title: 'Not Authenticated',
      message: 'Please log in to continue.',
    },
    403: {
      title: 'Access Forbidden',
      message: 'You do not have permission to access this resource.',
    },
    404: {
      title: 'Not Found',
      message: 'The resource you are looking for does not exist.',
    },
    429: {
      title: 'Too Many Requests',
      message: 'Please wait a moment before trying again.',
    },
    500: {
      title: 'Server Error',
      message: 'Something went wrong on our end. Please try again later.',
    },
    503: {
      title: 'Service Unavailable',
      message: 'We are currently performing maintenance. Please check back soon.',
    },
  };

  handleError(status: number) {
    const errorConfig = this.errors[status];
    return {
      ...errorConfig,
      actions: [{ label: 'Retry', primary: true, callback: () => this.retry() }],
    };
  }

  retry() {
    // Retry logic
  }
}
```

```html
<ax-error-state *ngIf="currentError" [statusCode]="currentError.status" [message]="currentError.message" [actions]="currentError.actions"></ax-error-state>
```

### User-Friendly Error Messages

```typescript
export class SaveComponent {
  saveError: string | null = null;

  async onSave(data: any) {
    try {
      await this.service.save(data);
    } catch (error) {
      this.saveError = this.getUserFriendlyMessage(error);
    }
  }

  private getUserFriendlyMessage(error: any): string {
    const code = error.code;

    if (code === 'DUPLICATE_KEY') {
      return 'This entry already exists. Please use a different name.';
    } else if (code === 'FOREIGN_KEY_CONSTRAINT') {
      return 'This item is used elsewhere and cannot be deleted.';
    } else if (code === 'PERMISSION_DENIED') {
      return 'You do not have permission to perform this action.';
    } else if (code === 'VALIDATION_ERROR') {
      return `Invalid data: ${error.details}`;
    } else if (error.status === 408) {
      return 'Request timed out. Please check your connection and try again.';
    } else if (error.status >= 500) {
      return 'Server error. Our team has been notified. Please try again later.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
```

```html
<ax-error-state
  *ngIf="saveError"
  type="error"
  title="Save Failed"
  [message]="saveError"
  [actions]="[
    { label: 'Try Again', primary: true, callback: onRetry }
  ]"
></ax-error-state>
```

### Multiple Action Buttons

```html
<ax-error-state
  title="Connection Lost"
  message="Your connection was interrupted. Would you like to retry or go back?"
  [actions]="[
    { label: 'Retry', primary: true, icon: 'refresh', callback: onRetry },
    { label: 'Go Back', icon: 'arrow_back', callback: onGoBack }
  ]"
></ax-error-state>
```

### Inline Error Display

```html
<!-- Compact variant for inline errors -->
<div class="form-section">
  <h3>Payment Information</h3>

  @if (paymentError) {
  <ax-error-state
    type="warning"
    compact
    title="Payment Issue"
    message="{{ paymentError }}"
    [actions]="[
        { label: 'Update Payment', primary: true, callback: updatePayment }
      ]"
  ></ax-error-state>
  }

  <!-- Form fields -->
</div>
```

### Network Error with Offline Detection

```typescript
export class DataComponent {
  isOnline = navigator.onLine;
  error: string | null = null;

  constructor() {
    window.addEventListener('online', () => {
      this.isOnline = true;
      this.error = null;
    });
    window.addEventListener('offline', () => {
      this.isOnline = false;
      this.error = 'No internet connection. Please check your network.';
    });
  }

  async loadData() {
    if (!this.isOnline) {
      this.error = 'No internet connection. Please check your network.';
      return;
    }

    try {
      // Load data
    } catch (err) {
      this.error = 'Failed to load. Please try again.';
    }
  }
}
```

```html
<ax-error-state
  *ngIf="error"
  [type]="isOnline ? 'error' : 'warning'"
  [title]="isOnline ? 'Loading Failed' : 'No Connection'"
  [message]="error"
  [actions]="isOnline ? [
    { label: 'Retry', primary: true, callback: loadData }
  ] : []"
></ax-error-state>
```

### Custom Recovery Actions

```typescript
export class FormComponent {
  formError: any = null;

  async onSubmit() {
    try {
      await this.service.submitForm(this.form.value);
    } catch (error) {
      this.formError = {
        title: 'Form Submission Failed',
        message: error.message,
        type: 'error',
        actions: [
          {
            label: 'Fix Form',
            primary: true,
            callback: () => this.scrollToFirstError(),
          },
          {
            label: 'Save Draft',
            icon: 'save',
            callback: () => this.saveDraft(),
          },
          {
            label: 'Get Help',
            icon: 'help_outline',
            callback: () => this.openHelp(),
          },
        ],
      };
    }
  }

  scrollToFirstError() {
    // Focus on first invalid field
  }

  saveDraft() {
    // Save form as draft
  }

  openHelp() {
    // Open help documentation
  }
}
```

## Error Handling Patterns

### Error Recovery Flow

```
┌─────────────────────────┐
│ User Action             │
│ (Load data, save, etc.) │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│ Operation Failed        │
│ Error caught            │
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│ Error State Shown       │
│ User-friendly message   │
│ Recovery actions        │
└────────────┬────────────┘
             │
      ┌──────┴──────┐
      ▼             ▼
   Retry      Other Action
      │             │
      └──────┬──────┘
             ▼
┌─────────────────────────┐
│ Attempt Recovery        │
└────────────┬────────────┘
             │
      ┌──────┴──────┐
      ▼             ▼
   Success       Failure
      │             │
      │      Show Error State
      │        Again
      ▼
┌─────────────────────────┐
│ Normal Operations       │
└─────────────────────────┘
```

### Appropriate Error Messages

```
GOOD MESSAGE:
"We couldn't save your changes. Please check your connection and try again."

BAD MESSAGE:
"Error: SAVE_OPERATION_FAILED_CONSTRAINT_VIOLATION"

GOOD MESSAGE:
"This email address is already in use. Please try a different one."

BAD MESSAGE:
"Error 400: Email must be unique in users table"

GOOD MESSAGE:
"You don't have permission to delete this item."

BAD MESSAGE:
"Authorization failed. User role 'viewer' lacks permission 'delete' on resource 'items'"
```

### Type Selection Guide

```typescript
// Use 'error' for serious issues
{
  type: 'error',           // Failed operations, broken features
  title: 'Save Failed',
  message: 'Unable to save changes'
}

// Use 'warning' for cautions
{
  type: 'warning',         // Quota limits, deprecations, risky actions
  title: 'Storage Full',
  message: 'You are using all available storage'
}

// Use 'info' for notifications
{
  type: 'info',            // Maintenance, updates, status changes
  title: 'Maintenance',
  message: 'System is undergoing maintenance'
}
```

## Styling & Theming

### CSS Variables

The component uses theme tokens for consistent styling:

```css
/* Error variant (default) */
--ax-error-default        /* Error color */
--ax-error-emphasis       /* Error hover/active */
--ax-error-faint          /* Error background */

/* Warning variant */
--ax-warning-default      /* Warning color */
--ax-warning-emphasis     /* Warning hover/active */
--ax-warning-faint        /* Warning background */

/* Info variant */
--ax-info-default         /* Info color */
--ax-info-emphasis        /* Info hover/active */
--ax-info-faint           /* Info background */

/* Common */
--ax-background-default   /* Container background */
--ax-border-default       /* Border color */
--ax-radius-lg            /* Border radius */
--ax-spacing-3xl          /* Padding */
```

### Compact Mode

```html
<!-- Full size (default) -->
<ax-error-state title="Error" message="Something went wrong"></ax-error-state>

<!-- Compact (smaller padding, icon) -->
<ax-error-state compact title="Error" message="Something went wrong"></ax-error-state>
```

## Accessibility

### ARIA & Semantic HTML

- **role="alert"**: Component announces errors to screen readers
- **aria-live="assertive"**: Dynamic content announced immediately
- **Semantic headings**: `<h3>` for titles for proper document structure
- **Color not sole indicator**: Messages use text, not color alone

### Screen Reader Support

```html
<!-- Good: Clear, descriptive title and message -->
<ax-error-state
  title="Password Reset Failed"
  message="The reset link has expired. Please request a new one."
  [actions]="[
    { label: 'Request New Link', primary: true, callback: requestNew }
  ]"
></ax-error-state>

<!-- Screen reader announcement: "Alert, Password Reset Failed. The reset link has expired..." -->
```

### Keyboard Navigation

- **Tab**: Navigate through action buttons
- **Space/Enter**: Activate button callbacks
- **No focus trap**: Focus escapes through all actions
- **Always accessible**: Actions never hidden behind interactions

### High Contrast Mode

- Works with high contrast themes
- All text has sufficient contrast
- Icons not used as sole indicator
- Colors defined by CSS variables

## Related Components

- **[Loading Button](./loading-button.md)** - Show loading state during operations that might fail
- **[Skeleton](./skeleton.md)** - Show while loading initial content
- **[Empty State](./empty-state.md)** - Display when operation succeeds but returns no results
