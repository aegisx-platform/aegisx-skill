# Login Form Component (ax-login-form)

**Category:** Authentication
**Selector:** `ax-login-form`
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
7. [Best Practices](#best-practices)
8. [Related Components](#related-components)

---

## Overview

The Login Form component provides a pre-built, production-ready authentication form with email/password fields, remember me functionality, social login options, and configurable UI elements. It follows security best practices and Material Design guidelines.

**Features:**

- Email and password validation
- Password visibility toggle
- "Remember me" checkbox
- Forgot password link
- Social login buttons (Google, GitHub)
- Sign up link
- Loading state with loading button
- Fully configurable text and visibility options
- Built-in form validation with error messages
- Responsive design

**Use Cases:**

- User login/sign-in pages
- Authentication flows
- Multi-factor authentication initial step
- SSO integration entry point

---

## Security Considerations

### Critical Security Guidelines

> **WARNING: NEVER store passwords in plain text or log them to console**

1. **Password Handling:**
   - The component emits form data through the `formSubmit` event
   - Your backend MUST hash passwords using bcrypt, Argon2, or similar
   - Never transmit passwords over non-HTTPS connections
   - Implement rate limiting on your login endpoint

```typescript
// ❌ WRONG - Logging sensitive data
onLogin(data: LoginFormData) {
  console.log('Password:', data.password); // NEVER DO THIS
}

// ✅ CORRECT - Handle securely
onLogin(data: LoginFormData) {
  this.authService.login(data).subscribe({
    next: (response) => {
      // Store only tokens, never passwords
      this.tokenService.saveToken(response.access_token);
    },
    error: (error) => {
      // Don't reveal if email exists
      this.showError('Invalid credentials');
    }
  });
}
```

2. **Token Storage:**
   - Use HttpOnly cookies for refresh tokens (preferred)
   - If using localStorage, encrypt tokens
   - Implement token expiration and rotation
   - Clear tokens on logout

3. **Remember Me Feature:**
   - Use secure session cookies
   - Limit "remember me" duration (e.g., 30 days max)
   - Require re-authentication for sensitive operations

4. **Social Login:**
   - Use OAuth 2.0 / OpenID Connect flows
   - Validate state parameter to prevent CSRF
   - Never trust client-side token validation alone

5. **Error Messages:**
   - Don't reveal whether email exists ("Invalid credentials" not "Email not found")
   - Implement account lockout after failed attempts
   - Log failed login attempts for security monitoring

### Example Secure Implementation

```typescript
import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { AxLoginFormComponent, LoginFormData } from '@aegisx/ui';
import { AuthService } from './auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [AxLoginFormComponent],
  template: ` <ax-login-form [config]="loginConfig" [loading]="isLoading" (formSubmit)="onLogin($event)" (forgotPassword)="onForgotPassword()" (socialLogin)="onSocialLogin($event)" (signupClick)="onSignup()" /> `,
})
export class LoginPageComponent {
  isLoading = false;
  loginConfig = {
    title: 'Welcome back',
    showRememberMe: true,
    showSocialLogin: true,
  };

  constructor(
    private authService: AuthService,
    private router: Router,
  ) {}

  onLogin(data: LoginFormData) {
    this.isLoading = true;

    // Secure login implementation
    this.authService
      .login({
        email: data.email,
        password: data.password, // Will be hashed by backend
        rememberMe: data.rememberMe,
      })
      .subscribe({
        next: (response) => {
          // Store only access token (HttpOnly cookie preferred for refresh token)
          this.authService.setAccessToken(response.access_token);

          // Navigate to dashboard
          this.router.navigate(['/dashboard']);
          this.isLoading = false;
        },
        error: (error) => {
          // Generic error message (don't reveal if email exists)
          this.showError('Invalid email or password');
          this.isLoading = false;
        },
      });
  }

  onSocialLogin(provider: string) {
    // Redirect to OAuth provider with state parameter
    const state = this.authService.generateStateToken(); // CSRF protection
    const redirectUri = encodeURIComponent('https://yourapp.com/auth/callback');

    if (provider === 'google') {
      // PLACEHOLDER: Replace with your OAuth client ID
      const clientId = 'YOUR_GOOGLE_CLIENT_ID';
      window.location.href = `https://accounts.google.com/o/oauth2/v2/auth?` + `client_id=${clientId}&` + `redirect_uri=${redirectUri}&` + `response_type=code&` + `scope=email profile&` + `state=${state}`;
    }
  }
}
```

---

## API Reference

### Inputs

| Property  | Type                       | Default   | Description                     |
| --------- | -------------------------- | --------- | ------------------------------- |
| `config`  | `Partial<LoginFormConfig>` | See below | Form configuration options      |
| `loading` | `boolean`                  | `false`   | Loading state for submit button |

### LoginFormConfig Interface

```typescript
interface LoginFormConfig {
  title?: string; // Form title
  subtitle?: string; // Form subtitle
  submitButtonText?: string; // Submit button label
  showRememberMe?: boolean; // Show/hide remember me checkbox
  showForgotPassword?: boolean; // Show/hide forgot password link
  showSocialLogin?: boolean; // Show/hide social login buttons
  showSignupLink?: boolean; // Show/hide signup link
  forgotPasswordText?: string; // Forgot password link text
  signupText?: string; // Signup prompt text
  signupLinkText?: string; // Signup link text
}
```

**Default Config:**

```typescript
{
  title: 'Welcome back',
  subtitle: 'Sign in to your account to continue',
  submitButtonText: 'Sign In',
  showRememberMe: true,
  showForgotPassword: true,
  showSocialLogin: true,
  showSignupLink: true,
  forgotPasswordText: 'Forgot password?',
  signupText: "Don't have an account?",
  signupLinkText: 'Sign up'
}
```

### Outputs

| Event            | Payload         | Description                                                 |
| ---------------- | --------------- | ----------------------------------------------------------- |
| `formSubmit`     | `LoginFormData` | Emitted when form is valid and submitted                    |
| `forgotPassword` | `void`          | Emitted when "Forgot password" link is clicked              |
| `socialLogin`    | `string`        | Emitted when social login button is clicked (provider name) |
| `signupClick`    | `void`          | Emitted when signup link is clicked                         |

### LoginFormData Interface

```typescript
interface LoginFormData {
  email: string; // User email
  password: string; // User password (will be sent to backend for hashing)
  rememberMe: boolean; // Remember me preference
}
```

### Form Validation

The component includes built-in validation:

- **Email field:**
  - Required
  - Must be valid email format

- **Password field:**
  - Required
  - Minimum 6 characters

---

## Usage Examples

### Basic Login Form

```typescript
import { Component } from '@angular/core';
import { AxLoginFormComponent, LoginFormData } from '@aegisx/ui';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [AxLoginFormComponent],
  template: ` <ax-login-form (formSubmit)="onLogin($event)" /> `,
})
export class LoginComponent {
  onLogin(data: LoginFormData) {
    console.log('Login attempt:', { email: data.email }); // Never log password!
    // Handle login
  }
}
```

### Custom Configuration

```typescript
@Component({
  template: ` <ax-login-form [config]="customConfig" [loading]="isLoading" (formSubmit)="onLogin($event)" (forgotPassword)="navigateToForgotPassword()" (signupClick)="navigateToSignup()" /> `,
})
export class LoginComponent {
  isLoading = false;

  customConfig = {
    title: 'Sign in to Dashboard',
    subtitle: 'Enter your credentials',
    submitButtonText: 'Login',
    showRememberMe: false,
    showSocialLogin: false,
    signupLinkText: 'Create account',
  };
}
```

### Without Social Login

```typescript
@Component({
  template: ` <ax-login-form [config]="{ showSocialLogin: false }" (formSubmit)="onLogin($event)" /> `,
})
export class LoginComponent {}
```

### With Loading State

```typescript
@Component({
  template: ` <ax-login-form [loading]="isAuthenticating" (formSubmit)="onLogin($event)" /> `,
})
export class LoginComponent {
  isAuthenticating = false;

  async onLogin(data: LoginFormData) {
    this.isAuthenticating = true;
    try {
      await this.authService.login(data);
      this.router.navigate(['/dashboard']);
    } catch (error) {
      this.showError('Login failed');
    } finally {
      this.isAuthenticating = false;
    }
  }
}
```

### Complete Authentication Flow

```typescript
import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';
import { AxLoginFormComponent, LoginFormData } from '@aegisx/ui';
import { AuthService } from './services/auth.service';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [AxLoginFormComponent],
  template: `
    <div class="login-container">
      <ax-login-form [config]="loginConfig" [loading]="isLoading" (formSubmit)="handleLogin($event)" (forgotPassword)="handleForgotPassword()" (socialLogin)="handleSocialLogin($event)" (signupClick)="handleSignup()" />
    </div>
  `,
  styles: [
    `
      .login-container {
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
export class LoginPageComponent {
  private authService = inject(AuthService);
  private router = inject(Router);
  private snackBar = inject(MatSnackBar);

  isLoading = false;
  loginConfig = {
    title: 'Welcome to AegisX',
    subtitle: 'Sign in to continue to your account',
  };

  handleLogin(data: LoginFormData): void {
    this.isLoading = true;

    this.authService.login(data.email, data.password, data.rememberMe).subscribe({
      next: (response) => {
        this.snackBar.open('Login successful!', 'OK', { duration: 3000 });
        this.router.navigate(['/dashboard']);
      },
      error: (error) => {
        this.snackBar.open('Invalid credentials. Please try again.', 'OK', {
          duration: 5000,
        });
        this.isLoading = false;
      },
      complete: () => {
        this.isLoading = false;
      },
    });
  }

  handleForgotPassword(): void {
    this.router.navigate(['/auth/forgot-password']);
  }

  handleSocialLogin(provider: string): void {
    // PLACEHOLDER: Implement OAuth flow
    console.log(`Social login with ${provider}`);
    this.authService.socialLogin(provider);
  }

  handleSignup(): void {
    this.router.navigate(['/auth/register']);
  }
}
```

---

## Styling

### CSS Custom Properties

The component uses Material theming tokens. Customize via CSS variables:

```scss
ax-login-form {
  --ax-brand-default: #1976d2;
  --ax-text-subtle: #6b7280;
}
```

### Component Styling

```scss
// Override card appearance
ax-login-form ::ng-deep mat-card {
  max-width: 450px;
  padding: 2rem;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
}

// Customize links
ax-login-form ::ng-deep .link {
  color: #1976d2;
  font-weight: 500;
}
```

### Responsive Design

The component is responsive by default. Additional breakpoints:

```scss
@media (max-width: 640px) {
  ax-login-form ::ng-deep mat-card {
    margin: 1rem;
    padding: 1.5rem;
  }
}
```

---

## Accessibility

### WCAG 2.1 AA Compliance

- **Keyboard Navigation:** Full keyboard support (Tab, Enter, Space)
- **Screen Readers:** Proper ARIA labels and roles
- **Focus Management:** Visible focus indicators on all interactive elements
- **Error Messages:** Associated with form fields via aria-describedby

### Keyboard Shortcuts

| Key           | Action                                        |
| ------------- | --------------------------------------------- |
| `Tab`         | Navigate between fields and buttons           |
| `Shift + Tab` | Navigate backwards                            |
| `Enter`       | Submit form (when focused on input or button) |
| `Space`       | Toggle checkboxes                             |

### ARIA Attributes

```html
<!-- Password visibility toggle -->
<button mat-icon-button [attr.aria-label]="'Hide password'" [attr.aria-pressed]="!hidePassword()">
  <mat-icon>visibility_off</mat-icon>
</button>
```

### Testing Recommendations

```typescript
// Accessibility test example
describe('LoginForm Accessibility', () => {
  it('should have proper ARIA labels', () => {
    const compiled = fixture.nativeElement;
    const emailInput = compiled.querySelector('input[type="email"]');
    expect(emailInput.getAttribute('autocomplete')).toBe('email');
  });

  it('should show error messages with aria-live', () => {
    // Test implementation
  });
});
```

---

## Best Practices

### 1. Always Use HTTPS

```typescript
// ✅ CORRECT - Enforce HTTPS
if (location.protocol !== 'https:' && !this.isDevelopment) {
  location.replace(`https:${location.href.substring(location.protocol.length)}`);
}
```

### 2. Implement Rate Limiting

Backend implementation example (Node.js/Express):

```typescript
// Backend rate limiting (EXAMPLE)
import rateLimit from 'express-rate-limit';

const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // 5 attempts
  message: 'Too many login attempts, please try again later',
});

app.post('/api/auth/login', loginLimiter, authController.login);
```

### 3. Token Management

```typescript
// Use HttpOnly cookies (backend sets this)
// Frontend just makes request:
this.http
  .post('/api/auth/login', credentials, {
    withCredentials: true, // Include cookies
  })
  .subscribe();

// If using localStorage (less secure):
class TokenService {
  private readonly TOKEN_KEY = 'access_token';

  setToken(token: string): void {
    // PLACEHOLDER: Add encryption if storing in localStorage
    localStorage.setItem(this.TOKEN_KEY, token);
  }

  getToken(): string | null {
    return localStorage.getItem(this.TOKEN_KEY);
  }

  clearToken(): void {
    localStorage.removeItem(this.TOKEN_KEY);
  }
}
```

### 4. Handle Errors Gracefully

```typescript
onLogin(data: LoginFormData) {
  this.authService.login(data).subscribe({
    error: (error) => {
      // Generic message (don't reveal if user exists)
      let message = 'Invalid email or password';

      if (error.status === 429) {
        message = 'Too many attempts. Please try again later.';
      } else if (error.status === 403) {
        message = 'Account locked. Please contact support.';
      }

      this.showError(message);
    }
  });
}
```

### 5. Clear Sensitive Data on Logout

```typescript
logout() {
  // Clear tokens
  this.tokenService.clearToken();

  // Clear sensitive data from memory
  this.userData = null;

  // Navigate to login
  this.router.navigate(['/login']);
}
```

---

## Related Components

- **[Register Form](./register-form.md)** - User registration component
- **[Forgot Password Form](./forgot-password-form.md)** - Password recovery
- **[Reset Password Form](./reset-password-form.md)** - Password reset with token
- **[Social Login](./social-login.md)** - Standalone social authentication buttons
- **[Loading Button](../feedback/loading-button.md)** - Button with loading state

---

## Migration Guide

### From v1.x to v2.x

```typescript
// v1.x
<ax-login-form
  title="Login"
  subtitle="Welcome"
/>

// v2.x (config-based)
<ax-login-form
  [config]="{ title: 'Login', subtitle: 'Welcome' }"
/>
```

---

## Changelog

**v2.0.0** (2025-01-19)

- Added configuration-based API
- Improved accessibility (WCAG 2.1 AA)
- Enhanced security documentation

**v1.0.0** (2024-06-01)

- Initial release
