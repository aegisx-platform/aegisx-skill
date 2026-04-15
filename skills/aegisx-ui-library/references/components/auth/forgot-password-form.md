# Forgot Password Form Component (ax-forgot-password-form)

**Category:** Authentication
**Selector:** `ax-forgot-password-form`
**Standalone:** Yes
**Since:** v1.0.0

---

## Overview

The Forgot Password Form component provides a secure interface for users to request password reset links. It includes email validation, success state management, and rate limiting support.

**Features:**

- Email input with validation
- Success state with confirmation message
- Resend email functionality
- Back to login navigation
- Loading states
- Responsive design

---

## Security Considerations

### Critical Security Guidelines

> **WARNING: Password Reset Must Be Secured**

1. **Token Generation:**
   - Use cryptographically secure random tokens (32+ bytes)
   - Set expiration (15-60 minutes recommended)
   - One-time use only
   - Store hashed version in database

```typescript
// Backend token generation example
import crypto from 'crypto';

function generateResetToken(): string {
  return crypto.randomBytes(32).toString('hex');
}

function hashToken(token: string): string {
  return crypto.createHash('sha256').update(token).digest('hex');
}
```

2. **Rate Limiting:**
   - Limit requests per email (e.g., 3 per hour)
   - Implement backend rate limiting
   - Don't reveal if email exists

```typescript
// ✅ CORRECT - Generic response
onForgotPassword(data: ForgotPasswordFormData) {
  this.authService.requestPasswordReset(data.email).subscribe({
    next: () => {
      // Same message whether email exists or not
      this.success = true;
    },
    error: () => {
      // Same message for errors (don't reveal details)
      this.success = true;
    }
  });
}
```

3. **Email Security:**
   - Send reset link to registered email only
   - Include token in URL parameter
   - Use HTTPS links only
   - Log all reset requests

```typescript
// Email template example
const resetLink = `https://yourapp.com/reset-password?token=${resetToken}`;

// NEVER use HTTP
// ❌ WRONG: http://yourapp.com/reset-password?token=...
```

---

## API Reference

### Inputs

| Property  | Type                                | Default   | Description                        |
| --------- | ----------------------------------- | --------- | ---------------------------------- |
| `config`  | `Partial<ForgotPasswordFormConfig>` | See below | Form configuration                 |
| `loading` | `boolean`                           | `false`   | Loading state                      |
| `success` | `boolean`                           | `false`   | Success state (shows confirmation) |

### ForgotPasswordFormConfig Interface

```typescript
interface ForgotPasswordFormConfig {
  title?: string;
  subtitle?: string;
  submitButtonText?: string;
  backToLoginText?: string;
  successTitle?: string;
  successMessage?: string;
}
```

**Default Config:**

```typescript
{
  title: 'Forgot password?',
  subtitle: "No worries, we'll send you reset instructions.",
  submitButtonText: 'Send Reset Link',
  backToLoginText: 'Back to login',
  successTitle: 'Check your email',
  successMessage: "We've sent a password reset link to your email address."
}
```

### Outputs

| Event         | Payload                  | Description                           |
| ------------- | ------------------------ | ------------------------------------- |
| `formSubmit`  | `ForgotPasswordFormData` | Emitted when form is submitted        |
| `backToLogin` | `void`                   | Emitted when back to login is clicked |
| `resendEmail` | `void`                   | Emitted when resend button is clicked |

### ForgotPasswordFormData Interface

```typescript
interface ForgotPasswordFormData {
  email: string;
}
```

---

## Usage Examples

### Basic Usage

```typescript
import { Component } from '@angular/core';
import { AxForgotPasswordFormComponent } from '@aegisx/ui';

@Component({
  selector: 'app-forgot-password',
  standalone: true,
  imports: [AxForgotPasswordFormComponent],
  template: ` <ax-forgot-password-form [loading]="isLoading" [success]="emailSent" (formSubmit)="onSubmit($event)" (backToLogin)="navigateToLogin()" (resendEmail)="onResend()" /> `,
})
export class ForgotPasswordComponent {
  isLoading = false;
  emailSent = false;
  private email = '';

  onSubmit(data: ForgotPasswordFormData) {
    this.email = data.email;
    this.isLoading = true;

    this.authService.requestPasswordReset(data.email).subscribe({
      next: () => {
        this.emailSent = true;
        this.isLoading = false;
      },
      error: () => {
        // Don't reveal if email doesn't exist
        this.emailSent = true;
        this.isLoading = false;
      },
    });
  }

  onResend() {
    this.onSubmit({ email: this.email });
  }

  navigateToLogin() {
    this.router.navigate(['/login']);
  }
}
```

### Complete Implementation

```typescript
import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';
import { MatSnackBar } from '@angular/material/snack-bar';
import { AxForgotPasswordFormComponent, ForgotPasswordFormData } from '@aegisx/ui';

@Component({
  selector: 'app-forgot-password',
  standalone: true,
  imports: [AxForgotPasswordFormComponent],
  template: `
    <div class="container">
      <ax-forgot-password-form [config]="formConfig" [loading]="isProcessing" [success]="emailSent" (formSubmit)="handleSubmit($event)" (backToLogin)="handleBackToLogin()" (resendEmail)="handleResend()" />
    </div>
  `,
  styles: [
    `
      .container {
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        padding: 2rem;
      }
    `,
  ],
})
export class ForgotPasswordPageComponent {
  private authService = inject(AuthService);
  private router = inject(Router);
  private snackBar = inject(MatSnackBar);

  isProcessing = false;
  emailSent = false;
  private lastEmail = '';
  private resendCount = 0;
  private readonly MAX_RESEND = 3;

  formConfig = {
    title: 'Forgot Your Password?',
    subtitle: "We'll send you a link to reset it",
  };

  handleSubmit(data: ForgotPasswordFormData): void {
    this.lastEmail = data.email;
    this.isProcessing = true;
    this.resendCount = 0;

    this.authService.requestPasswordReset(data.email).subscribe({
      next: () => {
        this.emailSent = true;
        this.isProcessing = false;

        // Log attempt (don't reveal if email exists)
        console.log('Password reset requested');
      },
      error: (error) => {
        // Show success even on error (security)
        this.emailSent = true;
        this.isProcessing = false;

        if (error.status === 429) {
          this.snackBar.open('Too many requests. Please try again later.', 'OK', { duration: 5000 });
        }
      },
    });
  }

  handleResend(): void {
    if (this.resendCount >= this.MAX_RESEND) {
      this.snackBar.open('Maximum resend attempts reached. Please contact support.', 'OK', { duration: 5000 });
      return;
    }

    this.resendCount++;
    this.handleSubmit({ email: this.lastEmail });
  }

  handleBackToLogin(): void {
    this.router.navigate(['/login']);
  }
}
```

---

## Related Components

- **[Reset Password Form](./reset-password-form.md)** - Password reset with token
- **[Login Form](./login-form.md)** - Login component

---

## Changelog

**v2.0.0** (2025-01-19)

- Enhanced security documentation
- Added resend functionality
- Improved success state handling
