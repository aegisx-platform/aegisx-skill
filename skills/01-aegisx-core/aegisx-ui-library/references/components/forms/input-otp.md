# Input OTP

## Overview

The Input OTP component (`ax-input-otp`) is an accessible one-time password input with intelligent copy/paste support. Perfect for authentication flows requiring PIN codes, verification codes, or security tokens.

**Key Features:**

- 🔢 Configurable length (4-8 digits)
- ✨ Pattern validation (digits, alphanumeric, alpha)
- 📋 Smart paste handling with auto-fill
- ⌨️ Full keyboard navigation (arrows, home, end, backspace)
- ♿ WCAG 2.1 Level AA compliant
- 🎨 Size variants (sm, md, lg)
- 🔄 Angular Forms integration (FormControl, validators)

## Installation & Import

```typescript
import { AxInputOtpComponent } from '@aegisx/ui';

@Component({
  standalone: true,
  imports: [AxInputOtpComponent],
})
export class MyComponent {}
```

## Basic Usage

### Standalone (Template-Driven)

```typescript
@Component({
  template: ` <ax-input-otp [(value)]="otpCode" [length]="6" (completed)="onOtpComplete($event)"> </ax-input-otp> `,
})
export class AuthComponent {
  otpCode = '';

  onOtpComplete(code: string) {
    console.log('OTP entered:', code);
    // Verify OTP
  }
}
```

### Reactive Forms Integration

```typescript
@Component({
  template: `
    <form [formGroup]="form">
      <ax-input-otp formControlName="otp" [length]="6" pattern="digits" [error]="form.get('otp')?.invalid && form.get('otp')?.touched"> </ax-input-otp>

      @if (form.get('otp')?.errors?.['required']) {
        <span class="error">OTP is required</span>
      }
    </form>
  `,
})
export class VerifyComponent {
  form = this.fb.group({
    otp: ['', [Validators.required, Validators.minLength(6)]],
  });

  constructor(private fb: FormBuilder) {}
}
```

## API Reference

### Inputs

| Name             | Type                                    | Default                     | Description                                    |
| ---------------- | --------------------------------------- | --------------------------- | ---------------------------------------------- |
| `value`          | `string`                                | `''`                        | Current OTP value (two-way bindable)           |
| `length`         | `4 \| 5 \| 6 \| 7 \| 8`                 | `6`                         | Number of OTP digits                           |
| `pattern`        | `'digits' \| 'alphanumeric' \| 'alpha'` | `'digits'`                  | Input pattern restriction                      |
| `size`           | `'sm' \| 'md' \| 'lg'`                  | `'md'`                      | Component size                                 |
| `separatorAfter` | `number \| undefined`                   | `undefined`                 | Show separator after this position (1-indexed) |
| `separatorChar`  | `string`                                | `'-'`                       | Separator character                            |
| `disabled`       | `boolean`                               | `false`                     | Disabled state                                 |
| `readonly`       | `boolean`                               | `false`                     | Readonly state                                 |
| `error`          | `boolean`                               | `false`                     | Error state (shows error styling)              |
| `autoFocus`      | `boolean`                               | `false`                     | Auto-focus first input on init                 |
| `autoSubmit`     | `boolean`                               | `true`                      | Auto-submit when complete                      |
| `ariaLabel`      | `string`                                | `'One-time password input'` | Aria label for the group                       |

### Outputs

| Name          | Type                   | Description                                           |
| ------------- | ---------------------- | ----------------------------------------------------- |
| `valueChange` | `EventEmitter<string>` | Emits the current OTP value on each change            |
| `completed`   | `EventEmitter<string>` | Emits when all slots are filled with valid characters |

### Methods

| Name      | Signature  | Description                                              |
| --------- | ---------- | -------------------------------------------------------- |
| `clear()` | `(): void` | Clear all slots and focus first input                    |
| `focus()` | `(): void` | Focus the first empty slot (or first slot if all filled) |

### FormControl Integration

The component implements `ControlValueAccessor` and integrates seamlessly with Angular Forms:

```typescript
// Reactive Forms
form = this.fb.group({
  otp: ['', [
    Validators.required,
    Validators.pattern(/^\d{6}$/) // 6 digits
  ]]
});

// Template
<ax-input-otp formControlName="otp" [length]="6"></ax-input-otp>

// Programmatic access
this.form.get('otp')?.setValue('123456');
const otpValue = this.form.get('otp')?.value;

// Disable/Enable
this.form.get('otp')?.disable();
this.form.get('otp')?.enable();
```

## Advanced Usage

### With Separator

```typescript
<ax-input-otp
  [(value)]="code"
  [length]="6"
  [separatorAfter]="3"
  separatorChar="-">
</ax-input-otp>
<!-- Displays: XXX-XXX -->
```

### Alphanumeric Pattern

```typescript
<ax-input-otp
  [(value)]="verifyCode"
  [length]="8"
  pattern="alphanumeric"
  (completed)="verifyAccount($event)">
</ax-input-otp>
<!-- Accepts: A-Z, a-z, 0-9 -->
```

### Custom Validation

```typescript
@Component({
  template: `
    <form [formGroup]="form">
      <ax-input-otp formControlName="securityCode" [length]="4" [error]="hasError"> </ax-input-otp>

      @if (hasError) {
        <span class="error-message">{{ errorMessage }}</span>
      }
    </form>
  `,
})
export class SecurityComponent {
  form = this.fb.group({
    securityCode: ['', [Validators.required, this.otpValidator]],
  });

  get hasError() {
    const control = this.form.get('securityCode');
    return control?.invalid && control?.touched;
  }

  get errorMessage() {
    const errors = this.form.get('securityCode')?.errors;
    if (errors?.['required']) return 'Security code is required';
    if (errors?.['invalidOtp']) return 'Invalid security code format';
    return '';
  }

  otpValidator(control: AbstractControl): ValidationErrors | null {
    const value = control.value;
    if (!value) return null;

    // Custom validation: no repeating digits
    if (/(.)\1{2,}/.test(value)) {
      return { invalidOtp: 'No repeating digits allowed' };
    }

    return null;
  }
}
```

### Size Variants

```typescript
<!-- Small -->
<ax-input-otp [(value)]="pin" size="sm" [length]="4"></ax-input-otp>

<!-- Medium (default) -->
<ax-input-otp [(value)]="code" size="md" [length]="6"></ax-input-otp>

<!-- Large -->
<ax-input-otp [(value)]="token" size="lg" [length]="8"></ax-input-otp>
```

## Styling & Theming

### CSS Variables

```css
.ax-input-otp {
  --otp-slot-size: 3rem;
  --otp-slot-gap: 0.5rem;
  --otp-border-color: #d1d5db;
  --otp-focus-color: #3b82f6;
  --otp-error-color: #ef4444;
  --otp-separator-color: #6b7280;
}
```

### Size Customization

```scss
// Small variant
.ax-input-otp--sm {
  --otp-slot-size: 2.5rem;
  --otp-slot-gap: 0.375rem;
  font-size: 0.875rem;
}

// Large variant
.ax-input-otp--lg {
  --otp-slot-size: 3.5rem;
  --otp-slot-gap: 0.75rem;
  font-size: 1.25rem;
}
```

### Custom Styling Example

```scss
.custom-otp {
  .ax-input-otp__slot {
    border: 2px solid #e5e7eb;
    border-radius: 0.5rem;
    background: #f9fafb;

    &:focus {
      border-color: #8b5cf6;
      box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.1);
    }

    &.ax-input-otp__slot--filled {
      background: white;
      border-color: #8b5cf6;
    }
  }

  .ax-input-otp__separator {
    color: #9ca3af;
  }
}
```

## Accessibility

### ARIA Attributes

The component implements comprehensive ARIA support:

```html
<!-- Generated HTML structure -->
<div class="ax-input-otp" role="group" aria-label="One-time password input">
  <input type="text" inputmode="numeric" aria-label="Digit 1 of 6" maxlength="1" autocomplete="one-time-code" />
  <!-- ... additional inputs -->
</div>
```

**ARIA Properties:**

- `role="group"`: Groups OTP inputs as a single logical unit
- `aria-label`: Descriptive label for screen readers
- Individual slot labels: "Digit X of N" for each input
- `inputmode`: Optimizes mobile keyboard display
- `autocomplete="one-time-code"`: Enables browser/OS autofill

### Keyboard Navigation

| Key          | Action                                            |
| ------------ | ------------------------------------------------- |
| `0-9`, `A-Z` | Enter character (based on pattern)                |
| `Backspace`  | Delete current character or move to previous slot |
| `Delete`     | Clear current slot                                |
| `ArrowLeft`  | Move to previous slot                             |
| `ArrowRight` | Move to next slot                                 |
| `Home`       | Move to first slot                                |
| `End`        | Move to last slot                                 |
| `Ctrl/Cmd+V` | Paste OTP (intelligent multi-slot paste)          |

**Copy/Paste Behavior:**

```typescript
// Full OTP paste: Fills from first slot regardless of cursor position
paste("123456") -> fills all 6 slots from beginning

// Partial paste: Fills from current cursor position
cursor at slot 3, paste("456") -> slots 3,4,5 filled

// Invalid characters filtered automatically
paste("12A34B") with pattern="digits" -> fills "1234" only
```

### Screen Reader Announcements

```typescript
// Focus announcement
'Digit 1 of 6, One-time password input';

// Value change
'1 entered';

// Navigation
'Digit 2 of 6';

// Complete
'All digits entered';

// Error state
'Invalid one-time password, Digit 1 of 6';
```

### Focus Management

```typescript
@Component({
  template: ` <ax-input-otp #otpInput [autoFocus]="true" (completed)="handleComplete($event)"> </ax-input-otp> `,
})
export class Component {
  @ViewChild('otpInput') otpInput!: AxInputOtpComponent;

  handleComplete(code: string) {
    // Verify OTP
    if (!this.verify(code)) {
      // On error, clear and refocus for retry
      this.otpInput.clear(); // Automatically focuses first slot
    }
  }
}
```

## Validation Patterns

### Built-in Pattern Validators

```typescript
// Digits only (0-9)
<ax-input-otp pattern="digits"></ax-input-otp>
// Regex: /^[0-9]$/

// Alphanumeric (A-Z, a-z, 0-9)
<ax-input-otp pattern="alphanumeric"></ax-input-otp>
// Regex: /^[a-zA-Z0-9]$/

// Alpha only (A-Z, a-z)
<ax-input-otp pattern="alpha"></ax-input-otp>
// Regex: /^[a-zA-Z]$/
```

### Custom Angular Validators

```typescript
export class OtpValidators {
  /** Validate OTP is all numeric */
  static numeric(control: AbstractControl): ValidationErrors | null {
    const value = control.value;
    if (!value) return null;
    return /^\d+$/.test(value) ? null : { numeric: true };
  }

  /** Validate no sequential numbers (123, 456, etc.) */
  static noSequential(control: AbstractControl): ValidationErrors | null {
    const value = control.value;
    if (!value || value.length < 3) return null;

    for (let i = 0; i < value.length - 2; i++) {
      const a = parseInt(value[i]);
      const b = parseInt(value[i + 1]);
      const c = parseInt(value[i + 2]);

      if (b === a + 1 && c === b + 1) {
        return { sequential: 'Sequential numbers not allowed' };
      }
    }

    return null;
  }

  /** Validate exact length */
  static exactLength(length: number) {
    return (control: AbstractControl): ValidationErrors | null => {
      const value = control.value;
      if (!value) return null;
      return value.length === length
        ? null
        : {
            exactLength: { required: length, actual: value.length },
          };
    };
  }
}

// Usage
form = this.fb.group({
  otp: ['', [Validators.required, OtpValidators.numeric, OtpValidators.noSequential, OtpValidators.exactLength(6)]],
});
```

## Use Cases

### Two-Factor Authentication (2FA)

```typescript
@Component({
  template: `
    <div class="auth-container">
      <h2>Verify Your Identity</h2>
      <p>Enter the 6-digit code sent to {{ maskedPhone }}</p>

      <ax-input-otp [(value)]="otpCode" [length]="6" pattern="digits" [autoFocus]="true" [error]="hasError" (completed)="verifyOtp($event)"> </ax-input-otp>

      @if (hasError) {
        <p class="error">Invalid code. Please try again.</p>
      }

      <button (click)="resendCode()" [disabled]="countdown > 0">
        {{ countdown > 0 ? 'Resend in ' + countdown + 's' : 'Resend Code' }}
      </button>
    </div>
  `,
})
export class TwoFactorComponent {
  otpCode = '';
  hasError = false;
  countdown = 60;
  maskedPhone = '***-***-1234';

  async verifyOtp(code: string) {
    try {
      await this.authService.verify2FA(code);
      this.router.navigate(['/dashboard']);
    } catch (error) {
      this.hasError = true;
      this.otpCode = ''; // Clear for retry
    }
  }

  resendCode() {
    this.authService.send2FA();
    this.countdown = 60;
    // Start countdown timer
  }
}
```

### Account Verification

```typescript
@Component({
  template: `
    <form [formGroup]="form" (ngSubmit)="submit()">
      <label>Email Verification Code</label>
      <ax-input-otp formControlName="verificationCode" [length]="8" pattern="alphanumeric" [separatorAfter]="4" separatorChar="-"> </ax-input-otp>

      <button type="submit" [disabled]="form.invalid">Verify Email</button>
    </form>
  `,
})
export class EmailVerificationComponent {
  form = this.fb.group({
    verificationCode: ['', [Validators.required, Validators.minLength(8)]],
  });

  submit() {
    if (this.form.valid) {
      const code = this.form.value.verificationCode;
      this.accountService.verifyEmail(code);
    }
  }
}
```

## Browser Compatibility

- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+
- ✅ Mobile Safari (iOS 14+)
- ✅ Chrome Mobile (Android 8+)

**Mobile-Specific Features:**

- Numeric keyboard on mobile devices (via `inputmode="numeric"`)
- SMS OTP autofill support (via `autocomplete="one-time-code"`)
- Touch-friendly input sizes

## Related Components

- [Date Picker](./date-picker.md) - Date selection form input
- [Time Slots](./time-slots.md) - Time selection form input
- [Scheduler](./scheduler.md) - Combined date/time form input
