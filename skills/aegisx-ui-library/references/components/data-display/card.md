# Card Component

## Overview

The `ax-card` component is a flexible container for displaying content with consistent styling and visual hierarchy. It provides multiple appearance options (default, flat, outlined, elevated) and supports headers with icons, subtitles, actions, and footer action areas. The card is ideal for grouping related information and creating modular layouts.

### Key Features

- **Multiple Appearances**: Default, flat, outlined, and elevated styles
- **Header Section**: Title, subtitle, and icon support with action slot
- **Content Area**: Flexible main content area for any content type
- **Footer Actions**: Optional action buttons area with alignment control
- **Dark Mode**: Full dark mode support with appropriate color adjustments
- **Responsive**: Scales gracefully on all screen sizes
- **Material Design**: Built on Angular Material Card foundation

## Installation & Import

```typescript
import { AegisxCardComponent } from '@aegisx/ui';
```

## Basic Usage

### Simple Card with Title

```typescript
// Component TypeScript
import { AegisxCardComponent } from '@aegisx/ui';

export class MyCardComponent {
  cardTitle = 'Card Title';
  cardSubtitle = 'Optional subtitle';
}
```

```html
<!-- Component Template -->
<ax-card [title]="cardTitle" [subtitle]="cardSubtitle">
  <p>This is the card content area.</p>
</ax-card>
```

### Card with Icon and Actions

```html
<ax-card title="User Profile" subtitle="John Doe" icon="person" appearance="elevated">
  <div card-header-actions>
    <button mat-icon-button>
      <mat-icon>more_vert</mat-icon>
    </button>
  </div>

  <div class="user-content">
    <p>Email: john@example.com</p>
    <p>Role: Developer</p>
  </div>

  <div card-actions>
    <button mat-stroked-button>Edit</button>
    <button mat-raised-button color="primary">Save</button>
  </div>
</ax-card>
```

## API Reference

### Inputs

| Name           | Type                                              | Default     | Description                           |
| -------------- | ------------------------------------------------- | ----------- | ------------------------------------- |
| `title`        | `string \| undefined`                             | `undefined` | Card header title                     |
| `subtitle`     | `string \| undefined`                             | `undefined` | Card header subtitle                  |
| `icon`         | `string \| undefined`                             | `undefined` | Material icon name for card header    |
| `appearance`   | `'default' \| 'flat' \| 'outlined' \| 'elevated'` | `'default'` | Visual appearance style               |
| `actionsAlign` | `'start' \| 'end'`                                | `'end'`     | Alignment of footer actions           |
| `hasFooter`    | `boolean`                                         | `false`     | Whether to display footer action area |

### Projected Content Slots

| Slot                    | Description                       |
| ----------------------- | --------------------------------- |
| Default slot            | Main card content area            |
| `[card-header-actions]` | Actions in header (right-aligned) |
| `[card-actions]`        | Footer action buttons             |

### Methods

| Name            | Signature                           | Description                                                      |
| --------------- | ----------------------------------- | ---------------------------------------------------------------- |
| `hasValidValue` | `(value?: string \| null): boolean` | Check if a string value is valid (not null, undefined, or empty) |

## Appearance Variants

### Default Appearance

```html
<ax-card title="Default Card" appearance="default">
  <p>Default card with subtle shadow on hover</p>
</ax-card>
```

**Characteristics**:

- Box shadow that transitions on hover
- Rounded corners
- Light background

### Flat Appearance

```html
<ax-card title="Flat Card" appearance="flat">
  <p>Flat card with minimal elevation</p>
</ax-card>
```

**Characteristics**:

- No shadow
- Thin border (1px)
- Suitable for dense layouts

### Outlined Appearance

```html
<ax-card title="Outlined Card" appearance="outlined">
  <p>Outlined card with prominent border</p>
</ax-card>
```

**Characteristics**:

- No shadow
- Thick border (2px)
- Clear visual separation
- Good for grouped content

### Elevated Appearance

```html
<ax-card title="Elevated Card" appearance="elevated">
  <p>Elevated card with prominent shadow</p>
</ax-card>
```

**Characteristics**:

- Strong box shadow that increases on hover
- Maximum visual prominence
- Ideal for key content

## Advanced Usage

### Card with Header Icon and Actions

```html
<ax-card title="Project Settings" subtitle="Configure project parameters" icon="settings" appearance="outlined">
  <div card-header-actions>
    <button mat-icon-button matTooltip="Help">
      <mat-icon>help_outline</mat-icon>
    </button>
    <button mat-icon-button matTooltip="Reset">
      <mat-icon>refresh</mat-icon>
    </button>
  </div>

  <mat-form-field appearance="fill" class="full-width">
    <mat-label>Project Name</mat-label>
    <input matInput placeholder="Enter project name" />
  </mat-form-field>

  <div card-actions>
    <button mat-stroked-button>Cancel</button>
    <button mat-raised-button color="primary">Save Changes</button>
  </div>
</ax-card>
```

### Card with Complex Content

```html
<ax-card title="Team Members" subtitle="Active project members" appearance="elevated" [hasFooter]="true">
  <mat-list>
    <mat-list-item *ngFor="let member of teamMembers">
      <mat-icon matListItemIcon>person</mat-icon>
      <div matListItemTitle>{{ member.name }}</div>
      <div matListItemLine>{{ member.role }}</div>
      <mat-icon matListItemMeta>
        <span class="status" [class.active]="member.active"></span>
      </mat-icon>
    </mat-list-item>
  </mat-list>

  <div card-actions>
    <button mat-stroked-button>
      <mat-icon>add</mat-icon>
      Add Member
    </button>
  </div>
</ax-card>
```

### Nested Cards Layout

```html
<div class="cards-grid">
  <ax-card *ngFor="let item of items" [title]="item.title" [icon]="item.icon" appearance="flat">
    <img [src]="item.image" alt="{{ item.title }}" />
    <p>{{ item.description }}</p>
  </ax-card>
</div>
```

## Styling & Theming

The card component uses CSS variables for theming:

### Theme Variables

```css
/* Shadow elevation */
--ax-shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
--ax-shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
--ax-shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
--ax-shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1);

/* Colors */
--ax-primary-faint: rgba(99, 102, 241, 0.1);
--ax-primary-default: #6366f1;

/* Spacing */
--ax-spacing-sm: 0.5rem;
--ax-spacing-md: 1rem;

/* Borders */
--ax-border-default: #e5e7eb;

/* Transitions */
--ax-transition-base: 0.15s ease;
```

### Dark Mode

```css
.dark ax-card {
  /* Automatically adapts through Material theme */
}
```

### Custom Card Styling

```scss
// Custom card with gradient background
::ng-deep .custom-gradient-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;

  mat-card-title {
    color: white;
  }

  mat-card-content {
    color: rgba(255, 255, 255, 0.9);
  }
}

// Apply custom class
<ax-card cardClass="custom-gradient-card">
  Custom styled content
</ax-card>
```

### Compact Card Style

```scss
::ng-deep .compact-card {
  .ax-card-header {
    padding: 0.5rem;
  }

  .ax-card-content {
    padding: 0.5rem;
  }

  .ax-card-actions {
    padding: 0.25rem 0.5rem;
  }
}
```

## Accessibility

The card component includes accessibility features:

### Semantic HTML

- Uses `<mat-card>` semantic container
- Proper heading hierarchy with title elements
- Logical content flow and structure

### Keyboard Navigation

- Header action buttons are focusable with Tab
- All interactive elements are keyboard accessible
- Focus indicators are visible on all interactive elements

### ARIA Support

```html
<ax-card title="Important Information" role="region" aria-labelledby="card-title">
  <h3 id="card-title" hidden>{{ title }}</h3>
  <!-- Content -->
</ax-card>
```

### Color Contrast

- Text colors meet WCAG AA standards (4.5:1 minimum)
- Icon colors provide sufficient contrast
- Appears option uses colors with adequate contrast

### Screen Reader Support

- Title and subtitle are readable by screen readers
- Action buttons have descriptive aria-labels
- Icon meanings are clarified through text or aria-label

```html
<div card-header-actions>
  <button mat-icon-button aria-label="Open options menu">
    <mat-icon>more_vert</mat-icon>
  </button>
</div>
```

## Content Organization

### Header Section Layout

```
┌─────────────────────────────────┐
│ [Icon] Title         [Actions]  │
│        Subtitle                 │
└─────────────────────────────────┘
```

- Icon: Left-aligned, 40px circle
- Title: Primary text
- Subtitle: Secondary text
- Actions: Right-aligned

### Content Area

- Full-width main content slot
- Flexible for any content type
- Automatic spacing and padding

### Footer Section

```
┌─────────────────────────────────┐
│ [Action Button] [Action Button] │
└─────────────────────────────────┘
```

- Top border separator
- Aligned buttons (start or end)
- Suitable for primary/secondary actions

## Related Components

- **[Button](../button.md)** - Use for actions in card footer
- **[Icon](../icon.md)** - Use for header icon
- **[List](./list.md)** - Display lists within cards
- **[Code Tabs](./code-tabs.md)** - Show code examples in cards
- **[Dialog](../../dialogs/)** - Extended content in modals

## Common Patterns

### Loading State Card

```typescript
export class LoadingCardComponent {
  isLoading = true;
  data: any;

  loadData() {
    this.isLoading = true;
    this.api.getData().subscribe((result) => {
      this.data = result;
      this.isLoading = false;
    });
  }
}
```

```html
<ax-card title="Data Display">
  <ng-container *ngIf="!isLoading; else loading">
    <div>{{ data | json }}</div>
  </ng-container>

  <ng-template #loading>
    <mat-spinner diameter="40"></mat-spinner>
  </ng-template>
</ax-card>
```

### Clickable Card

```html
<ax-card title="Clickable Item" appearance="flat" [ngClass]="{ selected: isSelected }" (click)="onCardClick()" role="button" tabindex="0" (keydown.enter)="onCardClick()" (keydown.space)="onCardClick()"> Content that triggers action on click </ax-card>
```

```scss
ax-card {
  cursor: pointer;
  transition: all 0.2s ease;

  &:hover {
    box-shadow: var(--ax-shadow-lg);
  }

  &.selected {
    border: 2px solid var(--ax-primary-default);
  }
}
```

### Form Card

```html
<ax-card title="Contact Information" icon="edit" appearance="outlined" [hasFooter]="true">
  <form [formGroup]="contactForm">
    <mat-form-field appearance="fill">
      <mat-label>Name</mat-label>
      <input matInput formControlName="name" />
      <mat-error>Name is required</mat-error>
    </mat-form-field>

    <mat-form-field appearance="fill">
      <mat-label>Email</mat-label>
      <input matInput type="email" formControlName="email" />
      <mat-error>Valid email required</mat-error>
    </mat-form-field>
  </form>

  <div card-actions>
    <button mat-stroked-button (click)="resetForm()">Clear</button>
    <button mat-raised-button color="primary" [disabled]="!contactForm.valid" (click)="submitForm()">Submit</button>
  </div>
</ax-card>
```

## Troubleshooting

### Header Not Showing

**Issue**: Card title, subtitle, or icon doesn't appear

**Solution**:

- Ensure `title`, `subtitle`, or `icon` inputs are set with non-empty values
- Check that string values are not `null` or empty (`''`)
- Verify Material icon name is valid if using custom icon

### Footer Actions Not Displaying

**Issue**: `card-actions` slot content doesn't appear

**Solution**:

- Set `[hasFooter]="true"` input
- Ensure content has `card-actions` attribute selector
- Check that footer section isn't hidden by CSS

### Shadow Not Showing in Elevated Mode

**Issue**: Elevated card doesn't have prominent shadow

**Solution**:

- Verify appearance is set to `'elevated'`
- Check that CSS variables are properly defined
- Ensure parent container doesn't have `overflow: hidden`
- Check browser DevTools for CSS override issues

### Content Overflow

**Issue**: Content exceeds card boundaries

**Solution**:

```html
<ax-card title="Content">
  <div class="content-wrapper">
    <!-- Content with scroll if needed -->
  </div>
</ax-card>
```

```scss
.content-wrapper {
  max-height: 400px;
  overflow-y: auto;
  padding: 1rem;
}
```
