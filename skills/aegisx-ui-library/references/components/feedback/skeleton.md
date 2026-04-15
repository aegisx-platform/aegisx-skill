# Skeleton Component

## Overview

The **Skeleton** (`ax-skeleton`) is a placeholder component that displays animated loading states while content is being fetched from the server. It creates a visually accurate preview of the final content structure, reducing perceived wait time and providing clear feedback that content is loading.

### When to Use

- **Content loading**: Display while fetching data from an API
- **List placeholders**: Multiple skeletons for list items
- **Card loading**: Replace entire cards during data fetch
- **Image placeholders**: Use circular variant for avatar/image loading
- **Perceived performance**: Improve UX by showing content structure early

### UX Best Practices

1. **Match final layout**: Skeleton should match the shape of final content
2. **Multiple lines for text**: Show expected line count for text content
3. **Use animation**: Pulse or wave animation clearly indicates loading
4. **Appropriate sizing**: Set exact dimensions to match final content
5. **Group skeletons**: Show multiple skeletons together for lists
6. **Minimum duration**: Keep loading state visible for 200ms+ to avoid flicker

## Installation & Import

```typescript
import { AxSkeletonComponent } from '@aegisx/ui';

// In your component
import { Component } from '@angular/core';
import { AxSkeletonComponent } from '@aegisx/ui';

@Component({
  selector: 'app-user-list',
  standalone: true,
  imports: [AxSkeletonComponent],
  template: `...`,
})
export class UserListComponent {}
```

## Basic Usage

### Simple Text Skeleton

```html
<ax-skeleton variant="text" width="200px"></ax-skeleton>
```

### Avatar Skeleton

```html
<ax-skeleton variant="circular" width="48px" height="48px"></ax-skeleton>
```

### Card Skeleton

```html
<ax-skeleton variant="rounded" width="100%" height="200px"></ax-skeleton>
```

### Multiple Lines

```html
<ax-skeleton variant="text" [lines]="3"></ax-skeleton>
```

## API Reference

### Inputs

| Name            | Type                                                 | Default     | Description                                                                           |
| --------------- | ---------------------------------------------------- | ----------- | ------------------------------------------------------------------------------------- |
| `variant`       | `'text' \| 'circular' \| 'rectangular' \| 'rounded'` | `'text'`    | Shape variant. Use `text` for paragraphs, `circular` for avatars, `rounded` for cards |
| `animation`     | `'pulse' \| 'wave' \| 'none'`                        | `'pulse'`   | Animation type. `pulse` fades in/out, `wave` shows shimmer effect, `none` is static   |
| `width`         | `string (CSS value)`                                 | `'100%'`    | Width of skeleton (e.g., '200px', '100%', '80%')                                      |
| `height`        | `string (CSS value)`                                 | `undefined` | Height of skeleton. If not set, uses variant-appropriate default (1em for text)       |
| `lines`         | `number`                                             | `1`         | Number of lines to display. Use for multi-line text content                           |
| `lastLineWidth` | `string (CSS value)`                                 | `'60%'`     | Width of last line when `lines > 1`. Creates natural paragraph appearance             |

### Outputs

None - Skeleton is a presentational component

### Methods

None - Public API is input-only

## Advanced Usage

### Loading a Card

```html
<div class="card">
  @if (isLoading) {
  <!-- Loading state with skeleton -->
  <div class="card-header">
    <ax-skeleton variant="text" width="150px" height="24px"></ax-skeleton>
  </div>
  <div class="card-body">
    <ax-skeleton variant="text" [lines]="4" [lastLineWidth]="'80%'"></ax-skeleton>
  </div>
  } @else {
  <!-- Actual content -->
  <div class="card-header">{{ title }}</div>
  <div class="card-body">{{ content }}</div>
  }
</div>
```

### User Card List

```html
<div class="user-list">
  @if (isLoading) {
  <!-- Show multiple skeleton cards while loading -->
  @for (let i of [1, 2, 3]; track i) {
  <div class="user-card-skeleton">
    <div class="user-header">
      <ax-skeleton variant="circular" width="48px" height="48px"></ax-skeleton>
      <div class="user-info">
        <ax-skeleton variant="text" width="120px" height="16px"></ax-skeleton>
        <ax-skeleton variant="text" width="100px" height="14px"></ax-skeleton>
      </div>
    </div>
    <ax-skeleton variant="text" [lines]="2"></ax-skeleton>
  </div>
  } } @else {
  <!-- Actual user list -->
  @for (let user of users; track user.id) {
  <div class="user-card">
    <img [src]="user.avatar" />
    <div class="user-info">
      <h3>{{ user.name }}</h3>
      <p>{{ user.email }}</p>
    </div>
    <p>{{ user.bio }}</p>
  </div>
  } }
</div>
```

### Data Table Loading

```html
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Email</th>
      <th>Role</th>
    </tr>
  </thead>
  <tbody>
    @if (isLoading) {
    <!-- Skeleton rows -->
    @for (let i of [1, 2, 3, 4, 5]; track i) {
    <tr class="skeleton-row">
      <td><ax-skeleton variant="text" width="150px"></ax-skeleton></td>
      <td><ax-skeleton variant="text" width="200px"></ax-skeleton></td>
      <td><ax-skeleton variant="text" width="100px"></ax-skeleton></td>
    </tr>
    } } @else {
    <!-- Actual data -->
    @for (let row of data; track row.id) {
    <tr>
      <td>{{ row.name }}</td>
      <td>{{ row.email }}</td>
      <td>{{ row.role }}</td>
    </tr>
    } }
  </tbody>
</table>
```

### Image Gallery Skeleton

```html
<div class="image-grid">
  @if (isLoading) { @for (let i of [1, 2, 3, 4]; track i) {
  <div class="image-skeleton">
    <ax-skeleton variant="rounded" width="100%" height="200px"></ax-skeleton>
    <ax-skeleton variant="text" width="80%" height="16px"></ax-skeleton>
  </div>
  } } @else { @for (let image of images; track image.id) {
  <div class="image-card">
    <img [src]="image.url" />
    <p>{{ image.title }}</p>
  </div>
  } }
</div>
```

### Chat Message Skeleton

```html
<div class="chat-messages">
  @if (isLoading) {
  <!-- Multiple message skeletons -->
  @for (let i of [1, 2, 3]; track i) {
  <div class="message-skeleton">
    <div class="message-avatar">
      <ax-skeleton variant="circular" width="40px" height="40px"></ax-skeleton>
    </div>
    <div class="message-content">
      <ax-skeleton variant="text" width="100px" height="14px"></ax-skeleton>
      <ax-skeleton variant="text" [lines]="2" [lastLineWidth]="'70%'"></ax-skeleton>
    </div>
  </div>
  } } @else {
  <!-- Actual messages -->
  @for (let msg of messages; track msg.id) {
  <div class="message">
    <img [src]="msg.avatar" />
    <div>
      <strong>{{ msg.sender }}</strong>
      <p>{{ msg.text }}</p>
    </div>
  </div>
  } }
</div>
```

## Loading State Patterns

### Skeleton State Lifecycle

```
┌──────────────────────────────────┐
│ INITIAL LOAD                     │
│ - Show skeleton immediately      │
│ - Matches target content layout  │
│ - Animation starts (pulse/wave)  │
└────────────┬─────────────────────┘
             │ Data arrives
             ▼
┌──────────────────────────────────┐
│ CONTENT LOADED                   │
│ - Replace skeleton with content  │
│ - Smooth transition              │
│ - Component unmounted            │
└──────────────────────────────────┘
```

### Animation Options

**Pulse Animation:**

- Smooth opacity fade: 1 → 0.4 → 1
- Duration: 1.5 seconds
- Best for: Simple, calm loading feedback
- Recommended for: Cards, lists, detailed content

**Wave Animation:**

- Shimmer gradient moves left to right
- Duration: 1.5 seconds
- Creates "reflection" effect
- Best for: Dynamic, engaging feedback
- Recommended for: Image galleries, hero sections

**No Animation:**

- Static placeholder
- Used when animation is distracting
- Not recommended for UX feedback

### Animation Comparison

```
PULSE:
███████████ ░░░░░░░░░ ███████████
(opacity fades)

WAVE:
███ ▓▓▓ ░░░░░░░░░░
(shimmer moves)
```

## Component Variants

### Text Variant

```html
<!-- Single line -->
<ax-skeleton variant="text" width="300px"></ax-skeleton>

<!-- Multiple lines (natural paragraph) -->
<ax-skeleton variant="text" [lines]="4" [lastLineWidth]="'60%'"></ax-skeleton>

<!-- Custom heights -->
<ax-skeleton variant="text" width="100%" height="20px"></ax-skeleton>
```

### Circular Variant

```html
<!-- Avatar size -->
<ax-skeleton variant="circular" width="48px" height="48px"></ax-skeleton>

<!-- Large profile picture -->
<ax-skeleton variant="circular" width="120px" height="120px"></ax-skeleton>

<!-- Small icon placeholder -->
<ax-skeleton variant="circular" width="32px" height="32px"></ax-skeleton>
```

### Rectangular Variant

```html
<!-- Full width banner -->
<ax-skeleton variant="rectangular" width="100%" height="300px"></ax-skeleton>

<!-- Image with aspect ratio -->
<ax-skeleton variant="rectangular" width="100%" height="400px"></ax-skeleton>

<!-- Thumbnail -->
<ax-skeleton variant="rectangular" width="100px" height="100px"></ax-skeleton>
```

### Rounded Variant

```html
<!-- Card-like placeholder -->
<ax-skeleton variant="rounded" width="100%" height="200px"></ax-skeleton>

<!-- Button placeholder -->
<ax-skeleton variant="rounded" width="120px" height="40px"></ax-skeleton>

<!-- Flexible box -->
<ax-skeleton variant="rounded" width="80px" height="80px"></ax-skeleton>
```

## Accessibility

### ARIA & Semantic HTML

- **role="presentation"**: Skeletons are decorative
- **aria-hidden="true"**: Hidden from screen readers
- No interactive elements in skeleton
- Loading announcement via page state changes

### Screen Readers

For screen reader users, the page should announce loading status separately:

```html
<div role="status" aria-live="polite" aria-label="Loading content">
  @if (isLoading) {
  <div class="sr-only">Loading content, please wait...</div>
  }
</div>

<div aria-busy="isLoading">
  @if (isLoading) {
  <!-- Skeleton layout -->
  } @else {
  <!-- Actual content -->
  }
</div>
```

### Keyboard Navigation

- **No interaction**: Skeletons are not keyboard accessible (presentational)
- **No focus**: Skeletons don't receive focus
- **Content after loading**: Interactive elements appear after skeleton is removed

### High Contrast Mode

- Works in high contrast mode
- Background color adjusts automatically
- Animation remains visible

## Dark Mode Support

The component automatically adapts to dark mode:

```css
/* Light mode */
.ax-skeleton {
  background-color: #f4f4f5; /* Light gray */
}

/* Dark mode */
:host-context(.dark) .ax-skeleton {
  background-color: rgba(255, 255, 255, 0.1); /* Subtle white overlay */
}
```

## Error Handling Examples

### Timeout Handling

```typescript
export class ContentComponent {
  isLoading = true;
  content: any = null;
  loadError: string | null = null;

  ngOnInit() {
    this.loadContentWithTimeout();
  }

  private loadContentWithTimeout() {
    const timeout = setTimeout(() => {
      if (this.isLoading) {
        this.loadError = 'Content is taking longer than expected';
        this.isLoading = false;
      }
    }, 15000); // 15 second timeout

    this.fetchContent()
      .then((data) => {
        clearTimeout(timeout);
        this.content = data;
        this.isLoading = false;
      })
      .catch((error) => {
        clearTimeout(timeout);
        this.loadError = 'Failed to load content';
        this.isLoading = false;
      });
  }

  private fetchContent() {
    return this.api.getContent();
  }
}
```

```html
@if (isLoading) {
<ax-skeleton variant="text" [lines]="5"></ax-skeleton>
} @else if (loadError) {
<div class="error-message">{{ loadError }}</div>
} @else {
<div class="content">{{ content }}</div>
}
```

### Retry on Error

```typescript
export class ListComponent {
  items: any[] = [];
  isLoading = true;
  loadError: string | null = null;

  ngOnInit() {
    this.loadItems();
  }

  loadItems() {
    this.isLoading = true;
    this.loadError = null;

    this.itemService.getItems().subscribe({
      next: (items) => {
        this.items = items;
        this.isLoading = false;
      },
      error: (error) => {
        this.loadError = 'Failed to load items. Please try again.';
        this.isLoading = false;
      },
    });
  }

  retry() {
    this.loadItems();
  }
}
```

```html
@if (isLoading) { @for (let i of [1, 2, 3]; track i) {
<div class="item-skeleton">
  <ax-skeleton variant="text" width="100%"></ax-skeleton>
  <ax-skeleton variant="text" width="80%"></ax-skeleton>
</div>
} } @else if (loadError) {
<div class="error">
  {{ loadError }}
  <button (click)="retry()">Retry</button>
</div>
} @else { @for (let item of items; track item.id) {
<div class="item">{{ item.name }}</div>
} }
```

## Performance Considerations

### Rendering Multiple Skeletons

For large lists, consider pagination or virtualization:

```typescript
// Good: Show 3-5 skeleton rows
const skeletonCount = 5;

// Avoid: Rendering 100+ skeletons (impacts performance)
const skeletonCount = 100; // Not recommended
```

### CSS Animation Performance

- Uses GPU-accelerated CSS animations (transform, opacity)
- No JavaScript reflow/repaint needed
- Smooth 60fps animation even with many skeletons
- CSS-only implementation ensures performance

## Styling & Theming

### CSS Variables

```css
--ax-background-subtle    /* Background color */
--ax-radius-sm            /* Text skeleton border radius */
--ax-radius-lg            /* Rounded variant border radius */
```

### Custom Styling

```css
/* Adjust animation speed */
ax-skeleton {
  --skeleton-animation-duration: 2s;
}

/* Change colors */
ax-skeleton {
  --skeleton-background: #e0e0e0;
}

/* Customize dark mode */
ax-skeleton.dark {
  --skeleton-background: rgba(255, 255, 255, 0.15);
}
```

## Related Components

- **[Loading Button](./loading-button.md)** - Use for action feedback during operations
- **[Error State](./error-state.md)** - Display when loading fails
- **[Empty State](./empty-state.md)** - Show when no results found after loading
