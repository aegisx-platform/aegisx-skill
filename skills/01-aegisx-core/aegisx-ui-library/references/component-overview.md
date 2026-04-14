# AegisX UI Component Library - Overview

**Version:** 2.0.0
**Last Updated:** 2025-01-19
**Status:** Official Reference

---

## Table of Contents

1. [Introduction](#introduction)
2. [Quick Start](#quick-start)
3. [Component Categories](#component-categories)
   - [Data Display](#data-display)
   - [Forms](#forms)
   - [Feedback](#feedback)
   - [Navigation](#navigation)
   - [Layout](#layout)
   - [Theme](#theme)
   - [Auth](#auth)
   - [Integrations](#integrations)
   - [Dialogs](#dialogs)
4. [Component Index](#component-index)
5. [Documentation Structure](#documentation-structure)
6. [Related Resources](#related-resources)

---

## Introduction

AegisX UI is a comprehensive Angular component library built on Material Design 3 principles. It provides 60+ production-ready components for building modern enterprise applications with consistent design, accessibility, and theming support.

**Key Features:**

- Material Design 3 token system
- Automatic light/dark theme support
- Full TypeScript support with type safety
- Accessibility-first (WCAG 2.1 AA compliant)
- Responsive and mobile-friendly
- Comprehensive API documentation
- Copy-paste ready code examples

---

## Quick Start

### Installation

```bash
npm install @aegisx/ui
```

### Basic Usage

```typescript
// app.config.ts (Standalone components)
import { ApplicationConfig } from '@angular/core';
import { provideAnimations } from '@angular/platform-browser/animations';

export const appConfig: ApplicationConfig = {
  providers: [
    provideAnimations(),
    // ... other providers
  ],
};
```

```typescript
// your.component.ts
import { Component } from '@angular/core';
import { AxCardComponent } from '@aegisx/ui';

@Component({
  selector: 'app-example',
  standalone: true,
  imports: [AxCardComponent],
  template: `
    <ax-card>
      <h2>Hello AegisX UI!</h2>
      <p>Your first component</p>
    </ax-card>
  `,
})
export class ExampleComponent {}
```

### Import Styles

Add to your `styles.scss`:

```scss
@import '@aegisx/ui/styles';
```

---

## Component Categories

### Data Display

Components for presenting data in various formats.

| Component              | Selector                | Purpose                                          |
| ---------------------- | ----------------------- | ------------------------------------------------ |
| **Avatar**             | `ax-avatar`             | Display user avatars with images or initials     |
| **Badge**              | `ax-badge`              | Show notification counts or status indicators    |
| **Calendar**           | `ax-calendar`           | Full-featured calendar with event management     |
| **Card**               | `ax-card`               | Container for content with elevation and borders |
| **Circular Progress**  | `ax-circular-progress`  | Circular progress indicator                      |
| **Code Tabs**          | `ax-code-tabs`          | Display code snippets with syntax highlighting   |
| **Description List**   | `ax-description-list`   | Key-value pairs in formatted list                |
| **Divider**            | `ax-divider`            | Visual separator between content sections        |
| **Field Display**      | `ax-field-display`      | Display form field values in read-only mode      |
| **KPI Card**           | `ax-kpi-card`           | Display key performance indicators               |
| **KBD**                | `ax-kbd`                | Display keyboard shortcuts                       |
| **List**               | `ax-list`               | Generic list component                           |
| **Segmented Progress** | `ax-segmented-progress` | Multi-step progress indicator                    |
| **Sparkline**          | `ax-sparkline`          | Mini line charts for trends                      |
| **Stats Card**         | `ax-stats-card`         | Statistical data display                         |
| **Timeline**           | `ax-timeline`           | Chronological event timeline                     |

**Documentation:** See [components/data-display/](./components/data-display/)

---

### Forms

Form input components with validation and accessibility support.

| Component       | Selector         | Purpose                                 |
| --------------- | ---------------- | --------------------------------------- |
| **Date Picker** | `ax-date-picker` | Date selection with calendar picker     |
| **Input OTP**   | `ax-input-otp`   | One-time password input with auto-focus |
| **Knob**        | `ax-knob`        | Rotary knob input for numeric values    |
| **Popup Edit**  | `ax-popup-edit`  | Inline editing with popup confirmation  |
| **Scheduler**   | `ax-scheduler`   | Schedule and appointment selector       |
| **Time Slots**  | `ax-time-slots`  | Time slot selection grid                |

**Documentation:** See [components/forms/](./components/forms/)

**Form Integration:**
All form components support Angular Reactive Forms and Template-driven Forms with `FormControl` integration.

---

### Feedback

Components for user feedback and loading states.

| Component           | Selector             | Purpose                              |
| ------------------- | -------------------- | ------------------------------------ |
| **Alert**           | `ax-alert`           | Display contextual feedback messages |
| **Empty State**     | `ax-empty-state`     | Show when no data is available       |
| **Error State**     | `ax-error-state`     | Display error messages with actions  |
| **Inner Loading**   | `ax-inner-loading`   | Loading spinner for content areas    |
| **Loading Bar**     | `ax-loading-bar`     | Top-of-page loading indicator        |
| **Loading Button**  | `ax-loading-button`  | Button with integrated loading state |
| **Skeleton**        | `ax-skeleton`        | Placeholder loading animation        |
| **Skeleton Card**   | `ax-skeleton-card`   | Card-shaped skeleton loader          |
| **Skeleton Avatar** | `ax-skeleton-avatar` | Avatar-shaped skeleton loader        |
| **Skeleton Table**  | `ax-skeleton-table`  | Table-shaped skeleton loader         |
| **Skeleton List**   | `ax-skeleton-list`   | List-shaped skeleton loader          |
| **Splash Screen**   | `ax-splash-screen`   | Full-screen app loading screen       |

**Documentation:** See [components/feedback/](./components/feedback/)

---

### Navigation

Navigation and routing components.

| Component              | Selector                | Purpose                           |
| ---------------------- | ----------------------- | --------------------------------- |
| **Breadcrumb**         | `ax-breadcrumb`         | Hierarchical navigation trail     |
| **Command Palette**    | `ax-command-palette`    | Keyboard-driven command interface |
| **Drawer**             | `ax-drawer`             | Side drawer navigation panel      |
| **Launcher**           | `ax-launcher`           | Application launcher grid         |
| **Launcher Card**      | `ax-launcher-card`      | Individual launcher item          |
| **Navigation**         | `ax-navigation`         | Main navigation component         |
| **Navbar**             | `ax-navbar`             | Top navigation bar                |
| **Navbar Actions**     | `ax-navbar-actions`     | Action buttons in navbar          |
| **Navbar Brand**       | `ax-navbar-brand`       | Logo/brand in navbar              |
| **Navbar Icon Button** | `ax-navbar-icon-button` | Icon buttons in navbar            |
| **Navbar Item**        | `ax-nav-item`           | Navigation menu item              |
| **Navbar Nav**         | `ax-navbar-nav`         | Navigation menu container         |
| **Navbar User**        | `ax-navbar-user`        | User profile in navbar            |

**Documentation:** See [components/navigation/](./components/navigation/)

**Router Integration:**
Navigation components integrate with Angular Router for seamless routing.

---

### Layout

Layout and container components.

| Component           | Selector             | Purpose                      |
| ------------------- | -------------------- | ---------------------------- |
| **Layout Switcher** | `ax-layout-switcher` | Switch between layout modes  |
| **Gridster**        | `ax-gridster`        | Drag-and-drop dashboard grid |
| **Splitter**        | `ax-splitter`        | Resizable split panels       |

**Documentation:** See [components/layout/](./components/layout/)

---

### Theme

Theming and customization components.

| Component                 | Selector                   | Purpose                              |
| ------------------------- | -------------------------- | ------------------------------------ |
| **Theme Builder**         | `ax-theme-builder`         | Interactive theme customization tool |
| **Theme Switcher**        | `ax-theme-switcher`        | Toggle light/dark theme              |
| **Color Palette Editor**  | `ax-color-palette-editor`  | Edit color palettes                  |
| **Image Color Extractor** | `ax-image-color-extractor` | Extract colors from images           |
| **M3 Color Preview**      | `ax-m3-color-preview`      | Preview Material 3 colors            |
| **Theme Preview Panel**   | `ax-theme-preview-panel`   | Preview theme changes                |

**Documentation:** See [components/theme/](./components/theme/)

**Related:** [THEMING_GUIDE.md](./THEMING_GUIDE.md) | [TOKEN_REFERENCE.md](./TOKEN_REFERENCE.md)

---

### Auth

Authentication and user management components.

| Component                | Selector                  | Purpose                       |
| ------------------------ | ------------------------- | ----------------------------- |
| **Auth Layout**          | `ax-auth-layout`          | Layout wrapper for auth pages |
| **Confirm Email**        | `ax-confirm-email`        | Email confirmation form       |
| **Forgot Password Form** | `ax-forgot-password-form` | Password reset request        |
| **Login Form**           | `ax-login-form`           | User login form               |
| **Register Form**        | `ax-register-form`        | User registration form        |
| **Reset Password Form**  | `ax-reset-password-form`  | Password reset form           |
| **Social Login**         | `ax-social-login`         | Social authentication buttons |

**Documentation:** See [components/auth/](./components/auth/)

**Security Note:** Auth components follow best practices for security including password hashing, CSRF protection, and secure token handling.

---

### Integrations

Third-party integrations and specialized components.

| Component         | Selector           | Purpose                        |
| ----------------- | ------------------ | ------------------------------ |
| **File Upload**   | `ax-file-upload`   | File upload with drag-and-drop |
| **QR Code**       | `ax-qrcode`        | Generate QR codes              |
| **Signature Pad** | `ax-signature-pad` | Digital signature capture      |

**Documentation:** See [components/integrations/](./components/integrations/)

---

### Dialogs

Dialog and modal components.

| Component                 | Selector                   | Purpose                                     |
| ------------------------- | -------------------------- | ------------------------------------------- |
| **Confirm Dialog**        | `ax-confirm-dialog`        | Confirmation dialog for destructive actions |
| **Calendar Event Dialog** | `ax-calendar-event-dialog` | Dialog for calendar event details           |
| **Sample JSON Dialog**    | `ax-sample-json-dialog`    | Display JSON data in dialog                 |

**Documentation:** Dialog components use Angular Material's `MatDialog` service. See individual component source code for detailed API.

**Usage:**
Dialogs are opened programmatically using Angular Material's `MatDialog` service.

---

## Component Index

### Alphabetical List

<details>
<summary>Click to expand complete alphabetical index (60+ components)</summary>

- `ax-alert` - Contextual feedback messages
- `ax-auth-layout` - Authentication page layout
- `ax-avatar` - User avatar display
- `ax-badge` - Notification badge
- `ax-breadcrumb` - Navigation breadcrumb
- `ax-calendar` - Full-featured calendar
- `ax-calendar-event-dialog` - Calendar event dialog
- `ax-card` - Content card container
- `ax-circular-progress` - Circular progress indicator
- `ax-code-tabs` - Code snippet tabs
- `ax-color-palette-editor` - Color palette editor
- `ax-command-palette` - Command palette interface
- `ax-confirm-dialog` - Confirmation dialog
- `ax-confirm-email` - Email confirmation form
- `ax-date-picker` - Date picker input
- `ax-description-list` - Description list
- `ax-divider` - Content divider
- `ax-drawer` - Navigation drawer
- `ax-empty-state` - Empty state placeholder
- `ax-error-state` - Error state display
- `ax-field-display` - Field value display
- `ax-file-upload` - File upload component
- `ax-forgot-password-form` - Forgot password form
- `ax-gridster` - Dashboard grid
- `ax-image-color-extractor` - Image color extractor
- `ax-inner-loading` - Loading spinner
- `ax-input-otp` - OTP input
- `ax-kbd` - Keyboard shortcut display
- `ax-knob` - Rotary knob input
- `ax-kpi-card` - KPI card
- `ax-launcher` - Application launcher
- `ax-launcher-card` - Launcher card item
- `ax-layout-switcher` - Layout mode switcher
- `ax-list` - Generic list
- `ax-loading-bar` - Loading progress bar
- `ax-loading-button` - Button with loading state
- `ax-login-form` - Login form
- `ax-m3-color-preview` - Material 3 color preview
- `ax-nav-item` - Navigation item
- `ax-navbar` - Navigation bar
- `ax-navbar-actions` - Navbar actions
- `ax-navbar-brand` - Navbar brand
- `ax-navbar-icon-button` - Navbar icon button
- `ax-navbar-nav` - Navbar navigation
- `ax-navbar-user` - Navbar user profile
- `ax-navigation` - Main navigation
- `ax-popup-edit` - Popup inline editor
- `ax-qrcode` - QR code generator
- `ax-register-form` - Registration form
- `ax-reset-password-form` - Password reset form
- `ax-sample-json-dialog` - JSON display dialog
- `ax-scheduler` - Appointment scheduler
- `ax-segmented-progress` - Segmented progress bar
- `ax-signature-pad` - Signature capture
- `ax-skeleton` - Skeleton loader
- `ax-skeleton-avatar` - Avatar skeleton
- `ax-skeleton-card` - Card skeleton
- `ax-skeleton-list` - List skeleton
- `ax-skeleton-table` - Table skeleton
- `ax-social-login` - Social login buttons
- `ax-sparkline` - Sparkline chart
- `ax-splash-screen` - Splash screen
- `ax-splitter` - Resizable splitter
- `ax-stats-card` - Statistics card
- `ax-theme-builder` - Theme builder
- `ax-theme-preview-panel` - Theme preview panel
- `ax-theme-switcher` - Theme switcher
- `ax-time-slots` - Time slot selector
- `ax-timeline` - Timeline component

</details>

---

## Documentation Structure

```
libs/aegisx-ui/docs/
├── README.md                    # Library overview and getting started
├── THEMING_GUIDE.md            # Material-First theming guide
├── TOKEN_REFERENCE.md          # Complete token reference
├── COMPONENT_OVERVIEW.md       # This file
└── components/                 # Detailed component documentation
    ├── data-display/
    │   ├── avatar.md
    │   ├── badge.md
    │   ├── calendar.md
    │   ├── card.md
    │   ├── circular-progress.md
    │   ├── code-tabs.md
    │   ├── description-list.md
    │   ├── divider.md
    │   ├── field-display.md
    │   ├── kbd.md
    │   ├── kpi-card.md
    │   ├── list.md
    │   ├── segmented-progress.md
    │   ├── sparkline.md
    │   ├── stats-card.md
    │   └── timeline.md
    ├── forms/
    │   ├── date-picker.md
    │   ├── input-otp.md
    │   ├── knob.md
    │   ├── popup-edit.md
    │   ├── scheduler.md
    │   └── time-slots.md
    ├── feedback/
    │   ├── alert.md
    │   ├── empty-state.md
    │   ├── error-state.md
    │   ├── inner-loading.md
    │   ├── loading-bar.md
    │   ├── loading-button.md
    │   ├── skeleton.md
    │   └── splash-screen.md
    ├── navigation/
    │   ├── breadcrumb.md
    │   ├── command-palette.md
    │   ├── drawer.md
    │   ├── launcher.md
    │   ├── navbar.md
    │   └── navigation.md
    ├── layout/
    │   ├── gridster.md
    │   ├── layout-switcher.md
    │   └── splitter.md
    ├── theme/
    │   ├── theme-builder.md
    │   └── theme-switcher.md
    ├── auth/
    │   ├── auth-layout.md
    │   ├── confirm-email.md
    │   ├── forgot-password-form.md
    │   ├── login-form.md
    │   ├── register-form.md
    │   ├── reset-password-form.md
    │   └── social-login.md
    ├── integrations/
    │   ├── file-upload.md
    │   ├── qrcode.md
    │   └── signature-pad.md
    └── dialogs/
        ├── confirm-dialog.md
        └── calendar-event-dialog.md
```

---

## Related Resources

### Documentation

- **[THEMING_GUIDE.md](./THEMING_GUIDE.md)** - Complete theming guide with Material-First approach
- **[TOKEN_REFERENCE.md](./TOKEN_REFERENCE.md)** - All available design tokens
- **[component-overview.md](./component-overview.md)** - This document - complete component index

### External Resources

- **[Angular Material](https://material.angular.io/)** - Base Material components
- **[Material Design 3](https://m3.material.io/)** - Design system specification
- **[Angular Documentation](https://angular.dev/)** - Angular framework docs

### Support

- **GitHub:** [aegisx-platform/aegisx-ui](https://github.com/aegisx-platform/aegisx-ui)
- **Issues:** Report bugs and feature requests
- **Discussions:** Ask questions and share ideas

---

## Component Documentation Template

Each component documentation file follows this structure:

1. **Overview** - Purpose and use cases
2. **Installation & Import** - How to import the component
3. **Basic Usage** - Simple examples
4. **API Reference** - Inputs, outputs, methods
5. **Advanced Usage** - Complex scenarios
6. **Styling & Theming** - Customization guide
7. **Accessibility** - ARIA attributes and keyboard navigation
8. **Related Components** - Links to related components

---

## Getting Started with Components

### Choose Your Category

1. **Building Data Views?** → Start with [Data Display](#data-display) components
2. **Creating Forms?** → Explore [Forms](#forms) components
3. **Need User Feedback?** → Check [Feedback](#feedback) components
4. **Implementing Navigation?** → See [Navigation](#navigation) components
5. **Customizing Layout?** → Review [Layout](#layout) components
6. **Theming Your App?** → Visit [Theme](#theme) components
7. **Adding Authentication?** → Use [Auth](#auth) components
8. **Integrating External Services?** → Browse [Integrations](#integrations)

### Next Steps

1. **Read the theming guide:** [THEMING_GUIDE.md](./THEMING_GUIDE.md)
2. **Browse component docs:** [components/](./components/)
3. **Check examples:** Each component doc includes copy-paste examples
4. **Explore tokens:** [TOKEN_REFERENCE.md](./TOKEN_REFERENCE.md)

---

**Last Updated:** 2025-01-19
**Version:** 2.0.0
**Maintained by:** AegisX UI Team
