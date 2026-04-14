# AegisX UI - Component Usage Examples

> **Production-Ready Components** - Ready to use in your Angular applications

---

## 🚀 ax-button - Button Component

### Installation & Import

```typescript
// Import the standalone component
import { AxButtonComponent } from '@aegisx/ui';

// Or import from forms module
import { AxButtonComponent } from '@aegisx/ui/forms';

// Use in your component
@Component({
  standalone: true,
  imports: [AxButtonComponent],
  template: ` <ax-button>Click Me</ax-button> `,
})
export class MyComponent {}
```

### Basic Usage

```html
<!-- Default button (solid primary) -->
<ax-button>Default Button</ax-button>

<!-- Different variants -->
<ax-button variant="solid">Solid</ax-button>
<ax-button variant="outline">Outline</ax-button>
<ax-button variant="ghost">Ghost</ax-button>
<ax-button variant="link">Link</ax-button>
```

### Color Schemes

```html
<!-- Different colors -->
<ax-button color="primary">Primary</ax-button>
<ax-button color="success">Success</ax-button>
<ax-button color="warning">Warning</ax-button>
<ax-button color="error">Error</ax-button>
<ax-button color="neutral">Neutral</ax-button>
```

### Sizes

```html
<!-- Different sizes -->
<ax-button size="xs">Extra Small</ax-button>
<ax-button size="sm">Small</ax-button>
<ax-button size="md">Medium (default)</ax-button>
<ax-button size="lg">Large</ax-button>
<ax-button size="xl">Extra Large</ax-button>
```

### Combinations

```html
<!-- Outline Success Button -->
<ax-button variant="outline" color="success" size="lg"> Save Changes </ax-button>

<!-- Ghost Error Button -->
<ax-button variant="ghost" color="error" size="sm"> Delete </ax-button>

<!-- Solid Warning Button -->
<ax-button variant="solid" color="warning" size="md"> Warning! </ax-button>
```

### States

```html
<!-- Disabled button -->
<ax-button [disabled]="true">Disabled</ax-button>

<!-- Loading button (shows spinner) -->
<ax-button [loading]="isLoading"> Submit Form </ax-button>

<!-- Full width button -->
<ax-button [fullWidth]="true">Full Width Button</ax-button>
```

### Icon Buttons

```html
<!-- Icon only button (circular) -->
<ax-button [iconOnly]="true" size="md">
  <mat-icon>favorite</mat-icon>
</ax-button>

<!-- Button with icon -->
<ax-button>
  <mat-icon>save</mat-icon>
  Save
</ax-button>
```

### Click Events

```typescript
@Component({
  template: ` <ax-button (axClick)="handleClick($event)"> Click Me </ax-button> `,
})
export class MyComponent {
  handleClick(event: MouseEvent) {
    console.log('Button clicked!', event);
  }
}
```

### Form Usage

```html
<!-- Submit button -->
<form (ngSubmit)="onSubmit()">
  <ax-button type="submit" [loading]="isSubmitting"> Submit Form </ax-button>
</form>

<!-- Reset button -->
<ax-button type="reset">Reset</ax-button>
```

### Real-World Examples

#### 1. Form Actions

```html
<div class="form-actions" style="display: flex; gap: 12px;">
  <ax-button type="submit" variant="solid" color="primary" [loading]="isSubmitting"> Save Changes </ax-button>

  <ax-button variant="outline" color="neutral" (axClick)="onCancel()"> Cancel </ax-button>
</div>
```

#### 2. Delete Confirmation

```html
<ax-button variant="outline" color="error" size="sm" (axClick)="confirmDelete()"> Delete Item </ax-button>
```

#### 3. Loading States

```typescript
@Component({
  template: `
    <ax-button variant="solid" color="primary" [loading]="isLoading" [disabled]="!canSubmit" (axClick)="submitData()">
      {{ isLoading ? 'Submitting...' : 'Submit' }}
    </ax-button>
  `,
})
export class FormComponent {
  isLoading = false;
  canSubmit = true;

  async submitData() {
    this.isLoading = true;
    try {
      await this.api.submit();
      // Success
    } finally {
      this.isLoading = false;
    }
  }
}
```

#### 4. Icon Button Grid

```html
<div style="display: flex; gap: 8px;">
  <ax-button [iconOnly]="true" variant="ghost" size="sm">
    <mat-icon>edit</mat-icon>
  </ax-button>

  <ax-button [iconOnly]="true" variant="ghost" size="sm" color="error">
    <mat-icon>delete</mat-icon>
  </ax-button>

  <ax-button [iconOnly]="true" variant="ghost" size="sm">
    <mat-icon>more_vert</mat-icon>
  </ax-button>
</div>
```

#### 5. Button Group

```html
<div class="button-group" style="display: inline-flex; gap: 1px;">
  <ax-button variant="outline" size="sm">Left</ax-button>
  <ax-button variant="outline" size="sm">Center</ax-button>
  <ax-button variant="outline" size="sm">Right</ax-button>
</div>
```

---

## 🎨 Styling with Design Tokens

The button component uses CSS variables from the design token system. You can customize colors globally:

```scss
// In your styles.scss
:root {
  --ax-primary: #your-brand-color;
  --ax-primary-emphasis: #your-darker-shade;
  --ax-primary-faint: #your-lighter-shade;
}
```

Or use the theme builder:

```typescript
import { createCustomTheme } from '@aegisx/ui/theme';

const myTheme = createCustomTheme({
  name: 'my-app',
  primaryColor: '#your-brand-color',
});

myTheme.apply();
```

---

## 📱 Responsive Usage

```html
<!-- Different sizes on different screens -->
<ax-button class="btn-responsive" [size]="isMobile ? 'sm' : 'md'"> Responsive Button </ax-button>
```

```typescript
export class MyComponent {
  isMobile = window.innerWidth < 768;
}
```

---

## ♿ Accessibility

The button component includes:

- ✅ Proper ARIA attributes
- ✅ Keyboard navigation support
- ✅ Focus visible states
- ✅ Disabled state handling
- ✅ Loading state announcements

```html
<!-- Accessible button with aria-label -->
<ax-button [iconOnly]="true" attr.aria-label="Close dialog">
  <mat-icon>close</mat-icon>
</ax-button>
```

---

## 🎯 API Reference

### Inputs

| Input       | Type                                                          | Default     | Description                   |
| ----------- | ------------------------------------------------------------- | ----------- | ----------------------------- |
| `variant`   | `'solid' \| 'outline' \| 'ghost' \| 'link'`                   | `'solid'`   | Visual variant                |
| `color`     | `'primary' \| 'success' \| 'warning' \| 'error' \| 'neutral'` | `'primary'` | Color scheme                  |
| `size`      | `'xs' \| 'sm' \| 'md' \| 'lg' \| 'xl'`                        | `'md'`      | Button size                   |
| `disabled`  | `boolean`                                                     | `false`     | Disabled state                |
| `loading`   | `boolean`                                                     | `false`     | Loading state (shows spinner) |
| `fullWidth` | `boolean`                                                     | `false`     | Full width button             |
| `iconOnly`  | `boolean`                                                     | `false`     | Icon only mode (circular)     |
| `type`      | `'button' \| 'submit' \| 'reset'`                             | `'button'`  | HTML button type              |

### Outputs

| Output    | Type                       | Description                    |
| --------- | -------------------------- | ------------------------------ |
| `axClick` | `EventEmitter<MouseEvent>` | Emitted when button is clicked |

### CSS Classes

All buttons have these base classes:

- `.ax-btn` - Base button class
- `.ax-btn-{variant}` - Variant class
- `.ax-btn-{color}` - Color class
- `.ax-btn-{size}` - Size class
- `.ax-btn-loading` - Loading state
- `.ax-btn-icon-only` - Icon only mode

---

## 💡 Tips & Best Practices

1. **Use appropriate colors for actions**
   - Primary: Main actions (Save, Submit)
   - Success: Positive actions (Confirm, Accept)
   - Warning: Caution actions (Archive)
   - Error: Destructive actions (Delete, Remove)
   - Neutral: Secondary actions (Cancel, Close)

2. **Choose the right variant**
   - Solid: Primary actions
   - Outline: Secondary actions
   - Ghost: Tertiary actions
   - Link: Inline actions

3. **Size consistency**
   - Keep button sizes consistent within a context
   - Use smaller sizes for compact UIs
   - Use larger sizes for prominent actions

4. **Loading states**
   - Always show loading state for async operations
   - Disable button during loading to prevent double-clicks

5. **Accessibility**
   - Always provide text or aria-label for icon-only buttons
   - Use appropriate button types (submit, reset, button)
   - Ensure sufficient color contrast

---

_For more components and examples, see [REDESIGN_PROGRESS.md](./REDESIGN_PROGRESS.md)_
