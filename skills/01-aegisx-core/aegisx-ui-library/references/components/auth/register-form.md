# Register Form Component (ax-register-form)

**Category:** Authentication
**Selector:** `ax-register-form`
**Standalone:** Yes
**Since:** v1.0.0

---

## Table of Contents

1. [Overview](#overview)
2. [Security Considerations](#security-considerations)
3. [API Reference](#api-reference)
4. [Usage Examples](#usage-examples)
5. [Styling](#styling)
6. [Accessibility](#accessibility)
7. [Related Components](#related-components)

---

## Overview

The Register Form component provides a complete user registration interface with name, email, password fields, password confirmation, terms acceptance, and social signup options. It includes built-in validation and follows security best practices.

**Features:**

- First name and last name fields
- Email validation
- Password and confirm password with match validation
- Password visibility toggles
- Terms and conditions acceptance
- Privacy policy link
- Social registration options (Google, GitHub)
- Login link for existing users
- Loading state support
- Fully configurable UI elements

---

## Security Considerations

### Critical Security Guidelines

> **WARNING: User Registration Must Be Secured**

1. **Password Security:**
   - Frontend validates minimum length (8 characters)
   - Backend MUST enforce strong password requirements
   - Hash passwords with bcrypt (cost factor 12+) or Argon2
   - Never store or log plain-text passwords

```typescript
// ❌ WRONG
onRegister(data: RegisterFormData) {
  console.log('Password:', data.password); // NEVER LOG PASSWORDS
  this.http.post('/api/register', data).subscribe(); // Missing validation
}

// ✅ CORRECT
onRegister(data: RegisterFormData) {
  // Validate on backend, hash password
  this.authService.register({
    firstName: data.firstName,
    lastName: data.lastName,
    email: data.email,
    password: data.password, // Will be hashed by backend
    acceptTerms: data.acceptTerms
  }).subscribe({
    next: () => this.router.navigate(['/verify-email']),
    error: (err) => this.handleRegistrationError(err)
  });
}
```

2. **Email Verification:**
   - Always send verification email after registration
   - Don't activate accounts until email is verified
   - Use secure tokens (cryptographically random, expire in 24h)

```typescript
// Backend example (Node.js)
const verificationToken = crypto.randomBytes(32).toString('hex');
const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours

await sendVerificationEmail(user.email, verificationToken);
```

3. **Prevent Email Enumeration:**
   - Don't reveal if email already exists during registration
   - Use generic success message
   - Send email to existing users (inform them of attempt)

```typescript
// ✅ CORRECT - Generic response
onRegister(data: RegisterFormData) {
  this.authService.register(data).subscribe({
    next: () => {
      // Same message whether new or existing email
      this.showMessage('Check your email for verification link');
      this.router.navigate(['/check-email']);
    }
  });
}
```

4. **Terms Acceptance:**
   - Store acceptance timestamp and version
   - Log IP address and user agent
   - Allow users to review terms later

5. **Social Registration:**
   - Verify OAuth tokens server-side
   - Link social accounts securely
   - Handle account merging carefully

---

## API Reference

### Inputs

| Property  | Type                          | Default   | Description                     |
| --------- | ----------------------------- | --------- | ------------------------------- |
| `config`  | `Partial<RegisterFormConfig>` | See below | Form configuration options      |
| `loading` | `boolean`                     | `false`   | Loading state for submit button |

### RegisterFormConfig Interface

```typescript
interface RegisterFormConfig {
  title?: string;
  subtitle?: string;
  submitButtonText?: string;
  showTermsCheckbox?: boolean;
  showSocialLogin?: boolean;
  showLoginLink?: boolean;
  termsText?: string;
  termsLinkText?: string;
  privacyLinkText?: string;
  loginText?: string;
  loginLinkText?: string;
}
```

**Default Config:**

```typescript
{
  title: 'Create an account',
  subtitle: 'Enter your details to get started',
  submitButtonText: 'Create Account',
  showTermsCheckbox: true,
  showSocialLogin: true,
  showLoginLink: true,
  termsText: 'I agree to the',
  termsLinkText: 'Terms of Service',
  privacyLinkText: 'Privacy Policy',
  loginText: 'Already have an account?',
  loginLinkText: 'Sign in'
}
```

### Outputs

| Event          | Payload            | Description                                  |
| -------------- | ------------------ | -------------------------------------------- |
| `formSubmit`   | `RegisterFormData` | Emitted when form is valid and submitted     |
| `socialLogin`  | `string`           | Emitted when social signup button is clicked |
| `loginClick`   | `void`             | Emitted when login link is clicked           |
| `termsClick`   | `void`             | Emitted when terms link is clicked           |
| `privacyClick` | `void`             | Emitted when privacy policy link is clicked  |

### RegisterFormData Interface

```typescript
interface RegisterFormData {
  firstName: string;
  lastName: string;
  email: string;
  password: string;
  confirmPassword: string;
  acceptTerms: boolean;
}
```

### Form Validation

- **First Name:** Required
- **Last Name:** Required
- **Email:** Required, valid email format
- **Password:** Required, minimum 8 characters
- **Confirm Password:** Required, must match password
- **Accept Terms:** Must be checked (requiredTrue)

---

## Usage Examples

### Basic Registration

```typescript
import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { AxRegisterFormComponent, RegisterFormData } from '@aegisx/ui';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [AxRegisterFormComponent],
  template: ` <ax-register-form [loading]="isRegistering" (formSubmit)="onRegister($event)" (loginClick)="navigateToLogin()" /> `,
})
export class RegisterPageComponent {
  isRegistering = false;

  constructor(
    private authService: AuthService,
    private router: Router,
  ) {}

  onRegister(data: RegisterFormData) {
    this.isRegistering = true;

    this.authService.register(data).subscribe({
      next: (response) => {
        // Show verification message
        this.router.navigate(['/verify-email'], {
          queryParams: { email: data.email },
        });
      },
      error: (error) => {
        this.handleError(error);
        this.isRegistering = false;
      },
    });
  }

  navigateToLogin() {
    this.router.navigate(['/login']);
  }
}
```

### With Terms and Privacy Dialogs

```typescript
import { Component, inject } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { AxRegisterFormComponent } from '@aegisx/ui';
import { TermsDialogComponent } from './terms-dialog.component';
import { PrivacyDialogComponent } from './privacy-dialog.component';

@Component({
  template: ` <ax-register-form (formSubmit)="onRegister($event)" (termsClick)="showTerms()" (privacyClick)="showPrivacy()" /> `,
})
export class RegisterPageComponent {
  private dialog = inject(MatDialog);

  showTerms() {
    this.dialog.open(TermsDialogComponent, {
      width: '800px',
      maxHeight: '80vh',
    });
  }

  showPrivacy() {
    this.dialog.open(PrivacyDialogComponent, {
      width: '800px',
      maxHeight: '80vh',
    });
  }
}
```

### Custom Configuration

```typescript
@Component({
  template: ` <ax-register-form [config]="customConfig" [loading]="isLoading" (formSubmit)="onRegister($event)" /> `,
})
export class RegisterComponent {
  customConfig = {
    title: 'Join AegisX',
    subtitle: 'Start your journey today',
    submitButtonText: 'Sign Up',
    showSocialLogin: false,
    termsLinkText: 'Terms & Conditions',
  };
}
```

### Complete Registration Flow

```typescript
import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';
import { MatSnackBar } from '@angular/material/snack-bar';
import { AxRegisterFormComponent, RegisterFormData } from '@aegisx/ui';
import { AuthService } from './services/auth.service';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [AxRegisterFormComponent],
  template: `
    <div class="register-container">
      <ax-register-form [config]="registerConfig" [loading]="isRegistering" (formSubmit)="handleRegister($event)" (socialLogin)="handleSocialSignup($event)" (loginClick)="navigateToLogin()" (termsClick)="openTerms()" (privacyClick)="openPrivacy()" />
    </div>
  `,
  styles: [
    `
      .register-container {
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        padding: 2rem;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      }
    `,
  ],
})
export class RegisterPageComponent {
  private authService = inject(AuthService);
  private router = inject(Router);
  private snackBar = inject(MatSnackBar);

  isRegistering = false;
  registerConfig = {
    title: 'Create Your Account',
    subtitle: 'Join thousands of users worldwide',
  };

  handleRegister(data: RegisterFormData): void {
    this.isRegistering = true;

    // Register user (backend will hash password and send verification email)
    this.authService
      .register({
        firstName: data.firstName,
        lastName: data.lastName,
        email: data.email,
        password: data.password,
        termsAccepted: data.acceptTerms,
        termsVersion: '1.0',
        acceptedAt: new Date().toISOString(),
      })
      .subscribe({
        next: () => {
          this.snackBar.open('Registration successful! Check your email to verify your account.', 'OK', { duration: 5000 });
          this.router.navigate(['/verify-email'], {
            queryParams: { email: data.email },
          });
        },
        error: (error) => {
          let message = 'Registration failed. Please try again.';

          if (error.status === 409) {
            // Email already exists
            message = 'An account with this email already exists.';
          } else if (error.status === 422) {
            // Validation error
            message = error.error?.message || 'Please check your input.';
          }

          this.snackBar.open(message, 'OK', { duration: 5000 });
          this.isRegistering = false;
        },
        complete: () => {
          this.isRegistering = false;
        },
      });
  }

  handleSocialSignup(provider: string): void {
    // PLACEHOLDER: Implement OAuth signup
    const redirectUri = encodeURIComponent('https://yourapp.com/auth/callback');
    const state = this.generateStateToken();

    if (provider === 'google') {
      const clientId = 'YOUR_GOOGLE_CLIENT_ID'; // PLACEHOLDER
      window.location.href = `https://accounts.google.com/o/oauth2/v2/auth?` + `client_id=${clientId}&` + `redirect_uri=${redirectUri}&` + `response_type=code&` + `scope=email profile&` + `state=${state}`;
    }
  }

  navigateToLogin(): void {
    this.router.navigate(['/login']);
  }

  openTerms(): void {
    window.open('/legal/terms', '_blank');
  }

  openPrivacy(): void {
    window.open('/legal/privacy', '_blank');
  }

  private generateStateToken(): string {
    // CSRF protection
    const array = new Uint8Array(32);
    crypto.getRandomValues(array);
    return Array.from(array, (byte) => byte.toString(16).padStart(2, '0')).join('');
  }
}
```

---

## Styling

### CSS Custom Properties

```scss
ax-register-form {
  --ax-brand-default: #1976d2;
  --ax-text-subtle: #6b7280;
}
```

### Responsive Layout

```scss
@media (max-width: 640px) {
  ax-register-form ::ng-deep .name-row {
    flex-direction: column;
  }

  ax-register-form ::ng-deep mat-card {
    padding: 1.5rem;
  }
}
```

---

## Accessibility

- **WCAG 2.1 AA Compliant**
- **Keyboard Navigation:** Full support
- **Screen Readers:** Proper ARIA labels
- **Password Visibility:** Accessible toggle buttons
- **Error Messages:** Associated with form fields

---

## Related Components

- **[Login Form](./login-form.md)** - User login component
- **[Forgot Password Form](./forgot-password-form.md)** - Password recovery
- **[Email Verification](./confirm-email.md)** - Email confirmation component

---

## Changelog

**v2.0.0** (2025-01-19)

- Enhanced security documentation
- Improved password validation (min 8 characters)
- Added terms acceptance tracking

**v1.0.0** (2024-06-01)

- Initial release
