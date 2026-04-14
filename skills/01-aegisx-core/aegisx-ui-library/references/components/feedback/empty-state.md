# Empty State Component

## Overview

The **Empty State** (`ax-empty-state`) is a user-friendly component for displaying situations where there is no content to show. It serves as a helpful placeholder that explains why content is missing and provides clear next steps, converting a frustrating blank screen into a helpful, actionable experience.

### When to Use

- **No search results**: User searches for items but finds none
- **Empty lists**: A list view with no items to display
- **First-time experience**: New user hasn't created any items yet
- **Filtered empty**: All items filtered out by current criteria
- **Deleted all items**: User removed all content
- **No data available**: Feature not available in this context

### UX Best Practices

1. **Explain the why**: Help users understand why content is missing
2. **Suggest actions**: Provide clear next steps (create new, adjust filters, etc.)
3. **Friendly tone**: Use positive, encouraging language
4. **Appropriate icon**: Use relevant icon that matches the context
5. **Primary action**: Always include one main action users should take
6. **Contextual help**: Explain how to populate content or find what they need
7. **Avoid blame**: "No items yet" not "You haven't created anything"

## Installation & Import

```typescript
import { AxEmptyStateComponent } from '@aegisx/ui';

// In your component
import { Component } from '@angular/core';
import { AxEmptyStateComponent } from '@aegisx/ui';

@Component({
  selector: 'app-items-list',
  standalone: true,
  imports: [AxEmptyStateComponent],
  template: `...`,
})
export class ItemsListComponent {}
```

## Basic Usage

### New User Empty State

```html
<ax-empty-state
  icon="note_add"
  title="No notes yet"
  message="Create your first note to get started"
  [actions]="[
    { label: 'Create Note', primary: true, callback: onCreate }
  ]"
></ax-empty-state>
```

### No Search Results

```html
<ax-empty-state
  icon="search"
  title="No results found"
  message="We couldn't find any items matching your search"
  [actions]="[
    { label: 'Clear Search', callback: onClearSearch }
  ]"
></ax-empty-state>
```

### Empty List

```html
<ax-empty-state icon="inbox" title="Your inbox is empty" message="All done! No pending items right now"></ax-empty-state>
```

### Filtered Empty

```html
<ax-empty-state
  icon="filter_list"
  title="No items match this filter"
  message="Try adjusting your filters to see more items"
  [actions]="[
    { label: 'Reset Filters', primary: true, callback: resetFilters }
  ]"
></ax-empty-state>
```

## API Reference

### Inputs

| Name      | Type                  | Default     | Description                                              |
| --------- | --------------------- | ----------- | -------------------------------------------------------- |
| `icon`    | `string \| undefined` | `undefined` | Material icon name (e.g., 'inbox', 'search', 'note_add') |
| `title`   | `string \| undefined` | `undefined` | Main heading explaining the empty state                  |
| `message` | `string \| undefined` | `undefined` | Description providing context and next steps             |
| `compact` | `boolean`             | `false`     | Compact layout with smaller padding and icon             |
| `actions` | `EmptyStateAction[]`  | `[]`        | Array of action buttons with callbacks                   |

### Outputs

None - Empty state is primarily a presentational component

### Interfaces

#### EmptyStateAction

```typescript
interface EmptyStateAction {
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
<ax-empty-state title="No items" message="Create new items to get started">
  <!-- Custom content inserted here -->
  <div>Additional context or suggestions</div>
</ax-empty-state>

<!-- ng-content select for action slot -->
<ax-empty-state title="No items" message="Create new items">
  <!-- Custom action buttons -->
  <button empty-state-actions>Custom Action</button>
</ax-empty-state>
```

## Advanced Usage

### Search with Empty State

```typescript
export class SearchComponent {
  items: any[] = [];
  searchTerm = '';
  isLoading = false;

  onSearch(term: string) {
    this.searchTerm = term;
    this.isLoading = true;

    this.itemService.search(term).subscribe({
      next: (results) => {
        this.items = results;
        this.isLoading = false;
      },
      error: () => {
        this.items = [];
        this.isLoading = false;
      },
    });
  }

  clearSearch() {
    this.searchTerm = '';
    this.items = [];
  }
}
```

```html
<div class="search-container">
  <input type="search" [(ngModel)]="searchTerm" (input)="onSearch(searchTerm)" placeholder="Search items..." />

  @if (isLoading) {
  <!-- Show loading skeleton -->
  <div class="item-list">
    @for (let i of [1, 2, 3]; track i) {
    <ax-skeleton variant="text" [lines]="2"></ax-skeleton>
    }
  </div>
  } @else if (items.length === 0 && searchTerm) {
  <!-- No results for search term -->
  <ax-empty-state
    icon="search"
    title="No results for '{{ searchTerm }}'"
    message="Try different keywords or adjust your filters"
    [actions]="[
        { label: 'Clear Search', primary: true, callback: clearSearch }
      ]"
  ></ax-empty-state>
  } @else if (items.length === 0) {
  <!-- No items at all -->
  <ax-empty-state
    icon="note_add"
    title="No items yet"
    message="Create your first item to get started"
    [actions]="[
        { label: 'Create Item', primary: true, callback: onCreate }
      ]"
  ></ax-empty-state>
  } @else {
  <!-- Show results -->
  <div class="item-list">
    @for (let item of items; track item.id) {
    <div class="item">{{ item.name }}</div>
    }
  </div>
  }
</div>
```

### Filtered List with Empty State

```typescript
export class ListComponent {
  allItems: any[] = [];
  filteredItems: any[] = [];
  activeFilter = 'all';

  applyFilter(filterType: string) {
    this.activeFilter = filterType;

    switch (filterType) {
      case 'completed':
        this.filteredItems = this.allItems.filter((i) => i.completed);
        break;
      case 'pending':
        this.filteredItems = this.allItems.filter((i) => !i.completed);
        break;
      default:
        this.filteredItems = this.allItems;
    }
  }

  resetFilter() {
    this.activeFilter = 'all';
    this.filteredItems = this.allItems;
  }
}
```

```html
<div class="filter-bar">
  <button (click)="applyFilter('all')" [class.active]="activeFilter === 'all'">All Items</button>
  <button (click)="applyFilter('completed')" [class.active]="activeFilter === 'completed'">Completed</button>
  <button (click)="applyFilter('pending')" [class.active]="activeFilter === 'pending'">Pending</button>
</div>

@if (filteredItems.length === 0) {
<ax-empty-state
  icon="filter_list"
  [title]="'No ' + activeFilter + ' items'"
  message="Try adjusting your filters or create new items"
  [actions]="[
      {
        label: 'Reset Filters',
        primary: true,
        callback: resetFilter
      },
      {
        label: 'Create Item',
        callback: onCreate
      }
    ]"
></ax-empty-state>
} @else {
<div class="item-list">
  @for (let item of filteredItems; track item.id) {
  <div class="item">{{ item.name }}</div>
  }
</div>
}
```

### Multi-State Empty Component

```typescript
export class MultiStateComponent {
  items: any[] = [];
  isLoading = false;
  error: string | null = null;
  activeFilter = 'all';

  ngOnInit() {
    this.loadItems();
  }

  loadItems() {
    this.isLoading = true;
    this.error = null;

    this.itemService.getItems().subscribe({
      next: (items) => {
        this.items = items;
        this.isLoading = false;
      },
      error: (err) => {
        this.error = 'Failed to load items. Please try again.';
        this.isLoading = false;
      },
    });
  }

  get filteredItems() {
    // Apply active filter logic
    return this.items;
  }

  retry() {
    this.loadItems();
  }

  resetFilter() {
    this.activeFilter = 'all';
  }

  onCreate() {
    // Create new item
  }
}
```

```html
@if (isLoading) {
<!-- Loading state with skeleton -->
<div class="item-list">
  @for (let i of [1, 2, 3]; track i) {
  <ax-skeleton variant="text" [lines]="2"></ax-skeleton>
  }
</div>
} @else if (error) {
<!-- Error state -->
<ax-error-state
  title="Failed to Load"
  [message]="error"
  [actions]="[
      { label: 'Retry', primary: true, callback: retry }
    ]"
></ax-error-state>
} @else if (filteredItems.length === 0) {
<!-- Empty state -->
<ax-empty-state
  icon="inbox"
  title="No items"
  message="Create your first item to get started"
  [actions]="[
      { label: 'Create Item', primary: true, callback: onCreate },
      { label: 'Reset Filter', callback: resetFilter }
    ]"
></ax-empty-state>
} @else {
<!-- Content -->
<div class="item-list">
  @for (let item of filteredItems; track item.id) {
  <div class="item">{{ item.name }}</div>
  }
</div>
}
```

### First-Time Experience (Onboarding)

```typescript
export class OnboardingComponent {
  userItems: any[] = [];
  isFirstTime = true;

  ngOnInit() {
    this.checkFirstTime();
  }

  checkFirstTime() {
    this.itemService.getUserItems().subscribe((items) => {
      this.userItems = items;
      this.isFirstTime = items.length === 0;
    });
  }

  startTutorial() {
    // Launch onboarding tutorial
  }

  createFirstItem() {
    // Open create dialog with guidance
  }
}
```

```html
@if (isFirstTime && userItems.length === 0) {
<!-- First-time experience empty state -->
<ax-empty-state
  icon="rocket_launch"
  title="Welcome! Let's get started"
  message="Create your first item to explore all features. We'll guide you through it."
  [actions]="[
      { label: 'Create First Item', primary: true, callback: createFirstItem },
      { label: 'Take a Tour', callback: startTutorial }
    ]"
>
  <div class="onboarding-tips">
    <h4>Quick Tips:</h4>
    <ul>
      <li>Items are organized by category</li>
      <li>Use tags for easy searching</li>
      <li>Collaborate with team members</li>
    </ul>
  </div>
</ax-empty-state>
} @else if (userItems.length === 0) {
<!-- Regular empty state -->
<ax-empty-state
  icon="note_add"
  title="No items yet"
  message="Create your first item"
  [actions]="[
      { label: 'Create Item', primary: true, callback: createFirstItem }
    ]"
></ax-empty-state>
} @else {
<!-- Show items -->
@for (let item of userItems; track item.id) {
<div class="item">{{ item.name }}</div>
} }
```

### Deleted State

```typescript
export class DeleteComponent {
  items: any[] = [];
  justDeleted = false;

  onDelete(id: string) {
    this.itemService.delete(id).subscribe(() => {
      this.items = this.items.filter((i) => i.id !== id);
      this.justDeleted = true;

      // Auto-hide deleted message after 3 seconds
      setTimeout(() => {
        this.justDeleted = false;
      }, 3000);
    });
  }

  undo() {
    // Restore deleted item
  }
}
```

```html
@if (justDeleted) {
<!-- Deleted confirmation -->
<div class="deleted-message">
  Item deleted
  <button (click)="undo()">Undo</button>
</div>
} @if (items.length === 0) {
<ax-empty-state
  [icon]="justDeleted ? 'done' : 'inbox'"
  [title]="justDeleted ? 'All items deleted' : 'No items'"
  message="Create a new item to get started"
  [actions]="[
      { label: 'Create Item', primary: true, callback: onCreate }
    ]"
></ax-empty-state>
} @else { @for (let item of items; track item.id) {
<div class="item">{{ item.name }}</div>
} }
```

## Empty State Patterns

### State Machine

```
┌──────────────┐
│ LOADING      │
│ Show skeleton│
└────────┬─────┘
         │
    ┌────┴─────┐
    ▼          ▼
┌────────┐  ┌──────┐
│ EMPTY  │  │ERROR │
│ State  │  │State │
└────┬───┘  └──────┘
     │
     ▼
┌──────────────┐
│ LOADED       │
│ Show content │
└──────────────┘
```

### Message Hierarchy

```
CLEAR TITLE
↓
Explains the situation (1-2 sentences)
↓
Suggests action
↓
ACTIONABLE BUTTON(S)
```

### Icon Selection Guide

| Scenario      | Icon             | Title           | Message                  |
| ------------- | ---------------- | --------------- | ------------------------ |
| New user      | `rocket_launch`  | "Welcome!"      | "Create your first item" |
| No results    | `search`         | "No results"    | "Try different keywords" |
| Empty list    | `inbox`          | "All done!"     | "No items right now"     |
| Filtered      | `filter_list`    | "No matches"    | "Adjust your filters"    |
| Deleted all   | `delete_outline` | "All deleted"   | "Create new items"       |
| No permission | `lock`           | "Access denied" | "You don't have access"  |

## Styling & Theming

### CSS Variables

```css
--ax-background-default   /* Container background */
--ax-border-default       /* Border color */
--ax-text-heading         /* Title color */
--ax-text-secondary       /* Message color */
--ax-text-disabled        /* Icon color (subtle) */
--ax-radius-lg            /* Border radius */
--ax-spacing-3xl          /* Padding (normal) */
--ax-spacing-2xl          /* Padding (compact) */
```

### Compact Mode

```html
<!-- Normal size -->
<ax-empty-state title="No items" message="Create new items"></ax-empty-state>

<!-- Compact (inline in form) -->
<ax-empty-state compact title="No items" message="Create new items"></ax-empty-state>
```

### Custom Content

```html
<ax-empty-state title="Premium Feature" message="Upgrade to unlock this feature">
  <!-- Custom content -->
  <div class="upgrade-info">
    <p>Premium includes:</p>
    <ul>
      <li>Advanced features</li>
      <li>Priority support</li>
      <li>More storage</li>
    </ul>
  </div>
</ax-empty-state>
```

## Accessibility

### ARIA & Semantic HTML

- **role="status"**: Component announces empty state to screen readers
- **aria-label**: Provides descriptive label for assistive technology
- **Semantic headings**: `<h3>` for titles for proper document structure
- **No color dependency**: Text conveys message, not color alone

### Screen Reader Support

```html
<!-- Good: Clear, contextual messaging -->
<ax-empty-state
  role="status"
  title="Your search for 'typescript' returned no results"
  message="Try broader keywords or check your filters"
  [actions]="[
    { label: 'Clear Search', primary: true, callback: clear }
  ]"
></ax-empty-state>

<!-- Screen reader announces: "Status. Your search for typescript returned no results..." -->
```

### Keyboard Navigation

- **Tab**: Navigate through action buttons
- **Space/Enter**: Activate button callbacks
- **No focus trap**: Focus flows naturally
- **Never hidden**: Empty state always visible when applicable

### High Contrast Mode

- Works with high contrast themes
- Sufficient text contrast maintained
- Icons not sole indicator
- Colors from CSS variables

## Related Components

- **[Skeleton](./skeleton.md)** - Show placeholder while loading content
- **[Error State](./error-state.md)** - Display when operations fail
- **[Loading Button](./loading-button.md)** - Use to create new content from empty state
