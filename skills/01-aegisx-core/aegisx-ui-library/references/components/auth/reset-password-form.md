# Reset Password Form Component (ax-reset-password-form)

**Category:** Authentication
**Selector:** `ax-reset-password-form`
**Standalone:** Yes
**Since:** v1.0.0

---

## Overview

The Reset Password Form component provides a secure interface for users to set a new password after receiving a reset token. It includes password validation, confirmation matching, and success state management.

**Features:**

- New password input with visibility toggle
- Confirm password with match validation
- Password strength requirements (min 8 characters)
- Success state with confirmation
- Back to login navigation
- Loading states

---

## Security Considerations

### Critical Security Guidelines

> **WARNING: Password Reset Must Validate Tokens Securely**

1. **Token Validation:**
   - Validate token server-side before allowing password reset
   - Check token expiration
   - Ensure one-time use
   - Invalidate token after successful reset

```typescript
// ✅ CORRECT - Validate token first
async validateResetToken(token: string): Promise<boolean> {
  try {
    const response = await this.http.post('/api/auth/validate-token', {
      token
    }).toPromise();
    return response.valid;
  } catch {
    return false;
  }
}

onResetPassword(data: ResetPasswordFormData) {
  const token = this.route.snapshot.queryParams['token'];

  this.authService.resetPassword(token, data.password).subscribe({
    next: () => this.success = true,
    error: (err) => {
      if (err.status === 401) {
        this.showError('Invalid or expired token');
      }
    }
  });
}
```

2. **Password Requirements:**
   - Minimum 8 characters (enforced by component)
   - Backend should enforce additional requirements:
     - At least one uppercase letter
     - At least one lowercase letter
     - At least one number
     - At least one special character
   - Check against common passwords list
   - Prevent password reuse (check against password history)

3. **Secure Password Storage:**
   - Hash with bcrypt (cost factor 12+) or Argon2
   - Never log or store plain-text passwords
   - Salt automatically handled by bcrypt

```typescript
// Backend example (Node.js)
import bcrypt from 'bcrypt';

async function hashPassword(password: string): Promise<string> {
  const saltRounds = 12;
  return bcrypt.hash(password, saltRounds);
}
```

---

## API Reference

### Inputs

| Property  | Type                               | Default   | Description                        |
| --------- | ---------------------------------- | --------- | ---------------------------------- |
| `config`  | `Partial<ResetPasswordFormConfig>` | See below | Form configuration                 |
| `loading` | `boolean`                          | `false`   | Loading state                      |
| `success` | `boolean`                          | `false`   | Success state (shows confirmation) |

### ResetPasswordFormConfig Interface

```typescript
interface ResetPasswordFormConfig {
  title?: string;
  subtitle?: string;
  submitButtonText?: string;
  backToLoginText?: string;
  successTitle?: string;
  successMessage?: string;
  successButtonText?: string;
}
```

**Default Config:**

```typescript
{
  title: 'Set new password',
  subtitle: 'Your new password must be different from previously used passwords.',
  submitButtonText: 'Reset Password',
  backToLoginText: 'Back to login',
  successTitle: 'Password reset!',
  successMessage: 'Your password has been successfully reset.',
  successButtonText: 'Continue to login'
}
```

### Outputs

| Event         | Payload                 | Description                           |
| ------------- | ----------------------- | ------------------------------------- |
| `formSubmit`  | `ResetPasswordFormData` | Emitted when form is submitted        |
| `backToLogin` | `void`                  | Emitted when back to login is clicked |

### ResetPasswordFormData Interface

```typescript
interface ResetPasswordFormData {
  password: string;
  confirmPassword: string;
}
```

### Validation

- **Password:** Required, minimum 8 characters
- **Confirm Password:** Required, must match password

---

## Usage Examples

### Basic Usage

```typescript
import { Component } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { AxResetPasswordFormComponent } from '@aegisx/ui';

@Component({
  selector: 'app-reset-password',
  standalone: true,
  imports: [AxResetPasswordFormComponent],
  template: ` <ax-reset-password-form [loading]="isResetting" [success]="passwordReset" (formSubmit)="onReset($event)" (backToLogin)="navigateToLogin()" /> `,
})
export class ResetPasswordComponent {
  isResetting = false;
  passwordReset = false;
  private resetToken = '';

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private authService: AuthService,
  ) {
    // Get token from URL
    this.resetToken = this.route.snapshot.queryParams['token'] || '';
  }

  onReset(data: ResetPasswordFormData) {
    if (!this.resetToken) {
      this.showError('Invalid reset link');
      return;
    }

    this.isResetting = true;

    this.authService.resetPassword(this.resetToken, data.password).subscribe({
      next: () => {
        this.passwordReset = true;
        this.isResetting = false;
      },
      error: (err) => {
        this.handleError(err);
        this.isResetting = false;
      },
    });
  }

  navigateToLogin() {
    this.router.navigate(['/login']);
  }
}
```

### Complete Implementation with Token Validation

```typescript
import { Component, inject, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { MatSnackBar } from '@angular/material/snack-bar';
import { AxResetPasswordFormComponent, ResetPasswordFormData } from '@aegisx/ui';

@Component({
  selector: 'app-reset-password',
  standalone: true,
  imports: [AxResetPasswordFormComponent],
  template: `
    <div class="container">
      @if (tokenValid) {
        <ax-reset-password-form [config]="formConfig" [loading]="isResetting" [success]="passwordReset" (formSubmit)="handleReset($event)" (backToLogin)="handleBackToLogin()" />
      } @else if (tokenChecked) {
        <div class="error-container">
          <h2>Invalid or Expired Link</h2>
          <p>This password reset link is invalid or has expired.</p>
          <button mat-raised-button (click)="requestNewLink()">Request New Link</button>
        </div>
      }
    </div>
  `,
})
export class ResetPasswordPageComponent implements OnInit {
  private authService = inject(AuthService);
  private route = inject(ActivatedRoute);
  private router = inject(Router);
  private snackBar = inject(MatSnackBar);

  isResetting = false;
  passwordReset = false;
  tokenValid = false;
  tokenChecked = false;
  private resetToken = '';

  formConfig = {
    title: 'Create New Password',
    subtitle: 'Choose a strong password for your account',
  };

  ngOnInit(): void {
    // Get and validate token
    this.resetToken = this.route.snapshot.queryParams['token'] || '';

    if (!this.resetToken) {
      this.tokenChecked = true;
      this.tokenValid = false;
      return;
    }

    // Validate token with backend
    this.authService.validateResetToken(this.resetToken).subscribe({
      next: (valid) => {
        this.tokenValid = valid;
        this.tokenChecked = true;

        if (!valid) {
          this.snackBar.open('This reset link has expired or is invalid.', 'OK', { duration: 5000 });
        }
      },
      error: () => {
        this.tokenValid = false;
        this.tokenChecked = true;
      },
    });
  }

  handleReset(data: ResetPasswordFormData): void {
    this.isResetting = true;

    this.authService.resetPassword(this.resetToken, data.password).subscribe({
      next: () => {
        this.passwordReset = true;
        this.isResetting = false;

        this.snackBar.open('Password reset successfully!', 'OK', { duration: 3000 });

        // Auto-navigate to login after 2 seconds
        setTimeout(() => {
          this.handleBackToLogin();
        }, 2000);
      },
      error: (error) => {
        let message = 'Failed to reset password. Please try again.';

        if (error.status === 401) {
          message = 'Reset link has expired. Please request a new one.';
        } else if (error.status === 422) {
          message = error.error?.message || 'Password does not meet requirements.';
        }

        this.snackBar.open(message, 'OK', { duration: 5000 });
        this.isResetting = false;
      },
    });
  }

  handleBackToLogin(): void {
    this.router.navigate(['/login']);
  }

  requestNewLink(): void {
    this.router.navigate(['/forgot-password']);
  }
}
```

---

## Related Components

- **[Forgot Password Form](./forgot-password-form.md)** - Request password reset
- **[Login Form](./login-form.md)** - Login component

---

## Changelog

**v2.0.0** (2025-01-19)

- Enhanced security validation
- Improved password requirements (min 8 characters)
- Added success state with auto-navigation
