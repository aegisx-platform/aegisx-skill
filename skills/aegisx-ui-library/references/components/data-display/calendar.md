# Calendar Component

## Overview

The `ax-calendar` component provides a feature-rich calendar interface for displaying, managing, and interacting with events. Built on top of FullCalendar, it integrates seamlessly with the AegisX design system and supports multiple views (month, week, day, list), drag-and-drop event management, and comprehensive event handling.

### Key Features

- **Multiple Views**: Month, week, day, and list views for flexible event visualization
- **Event Management**: Create, update, remove, and display events with drag-and-drop support
- **Responsive Design**: Adapts to different screen sizes and supports dark mode
- **Business Hours Support**: Display business hours and configure time slots
- **Event Customization**: Color, icons, and custom properties for events
- **Accessibility**: Full keyboard navigation and ARIA support

## Installation & Import

```typescript
import { AxCalendarComponent } from '@aegisx/ui';
```

## Basic Usage

### Simple Calendar with Events

```typescript
// Component TypeScript
import { AxCalendarComponent, AxCalendarEvent } from '@aegisx/ui';

export class MyCalendarComponent {
  events: AxCalendarEvent[] = [
    {
      id: '1',
      title: 'Team Meeting',
      start: new Date(2024, 11, 20, 10, 0),
      end: new Date(2024, 11, 20, 11, 0),
      color: 'primary',
    },
    {
      id: '2',
      title: 'Project Deadline',
      start: new Date(2024, 11, 25),
      allDay: true,
      color: 'warning',
    },
  ];

  onEventClick(event: any) {
    console.log('Event clicked:', event);
  }
}
```

```html
<!-- Component Template -->
<ax-calendar [events]="events" [initialView]="'dayGridMonth'" [editable]="true" [selectable]="true" (eventClick)="onEventClick($event)"> </ax-calendar>
```

## API Reference

### Inputs

| Name            | Type                               | Default          | Description                                         |
| --------------- | ---------------------------------- | ---------------- | --------------------------------------------------- |
| `events`        | `AxCalendarEvent[]`                | `[]`             | Array of events to display on the calendar          |
| `initialView`   | `AxCalendarView`                   | `'dayGridMonth'` | Initial calendar view type                          |
| `initialDate`   | `Date \| string`                   | `undefined`      | Initial date to display when calendar loads         |
| `editable`      | `boolean`                          | `false`          | Allow dragging and resizing events                  |
| `selectable`    | `boolean`                          | `false`          | Allow selecting dates to create new events          |
| `weekNumbers`   | `boolean`                          | `false`          | Show week numbers in the calendar                   |
| `firstDay`      | `number`                           | `0`              | First day of week (0=Sunday, 1=Monday, etc.)        |
| `locale`        | `string`                           | `'en'`           | Locale for date formatting                          |
| `height`        | `'auto' \| number \| string`       | `'auto'`         | Calendar height ('auto', pixels, or 'parent')       |
| `isLoading`     | `boolean`                          | `false`          | Show loading overlay                                |
| `headerToolbar` | `CalendarOptions['headerToolbar']` | Built-in config  | Custom header toolbar configuration                 |
| `enabledViews`  | `AxCalendarView[]`                 | All views        | Which calendar views are available                  |
| `businessHours` | `CalendarOptions['businessHours']` | `undefined`      | Business hours configuration                        |
| `slotDuration`  | `string`                           | `'00:30:00'`     | Slot duration for time grid views (HH:mm:ss format) |
| `slotMinTime`   | `string`                           | `'00:00:00'`     | Minimum time displayed in time views                |
| `slotMaxTime`   | `string`                           | `'24:00:00'`     | Maximum time displayed in time views                |
| `allDaySlot`    | `boolean`                          | `true`           | Show all-day event slot at top of time views        |
| `nowIndicator`  | `boolean`                          | `true`           | Show current time indicator in time views           |

### Outputs

| Name          | Type                                          | Description                                                 |
| ------------- | --------------------------------------------- | ----------------------------------------------------------- |
| `eventClick`  | `EventEmitter<AxEventClickEvent>`             | Emitted when an event is clicked                            |
| `dateSelect`  | `EventEmitter<AxDateSelectEvent>`             | Emitted when a date range is selected (for creating events) |
| `eventChange` | `EventEmitter<AxEventChangeEvent>`            | Emitted when an event is dragged or resized                 |
| `datesChange` | `EventEmitter<AxCalendarDateRange>`           | Emitted when the visible date range changes                 |
| `dateClick`   | `EventEmitter<{date: Date; allDay: boolean}>` | Emitted when a date is clicked                              |

### Methods

| Name            | Signature                              | Description                                    |
| --------------- | -------------------------------------- | ---------------------------------------------- |
| `gotoDate`      | `(date: Date \| string): void`         | Navigate to a specific date                    |
| `today`         | `(): void`                             | Navigate to today's date                       |
| `prev`          | `(): void`                             | Navigate to previous period                    |
| `next`          | `(): void`                             | Navigate to next period                        |
| `changeView`    | `(view: AxCalendarView): void`         | Change the current calendar view               |
| `getView`       | `(): AxCalendarView \| undefined`      | Get the current view type                      |
| `getDateRange`  | `(): AxCalendarDateRange \| undefined` | Get the current visible date range             |
| `refetchEvents` | `(): void`                             | Refetch all events (useful after data changes) |
| `addEvent`      | `(event: AxCalendarEvent): void`       | Add a single event programmatically            |
| `removeEvent`   | `(eventId: string): void`              | Remove an event by ID                          |
| `updateEvent`   | `(event: AxCalendarEvent): void`       | Update an existing event                       |

### Interfaces

**AxCalendarEvent**

```typescript
interface AxCalendarEvent {
  id: string;
  title: string;
  start: Date | string;
  end?: Date | string;
  allDay?: boolean;
  color?: 'primary' | 'success' | 'warning' | 'danger' | 'info' | 'secondary';
  backgroundColor?: string;
  borderColor?: string;
  textColor?: string;
  extendedProps?: Record<string, unknown>;
  editable?: boolean;
  resourceId?: string;
}
```

**AxCalendarView**

```typescript
type AxCalendarView = 'dayGridMonth' | 'timeGridWeek' | 'timeGridDay' | 'listWeek' | 'listMonth';
```

## Advanced Usage

### Custom Event Colors

```typescript
events: AxCalendarEvent[] = [
  {
    id: '1',
    title: 'Urgent Meeting',
    start: new Date(2024, 11, 20, 10, 0),
    color: 'danger',
    backgroundColor: '#ef4444',
    borderColor: '#dc2626',
    textColor: '#fff'
  }
];
```

### Event Handling with Updates

```typescript
export class CalendarComponent {
  @ViewChild(AxCalendarComponent) calendar!: AxCalendarComponent;

  onDateSelect(event: AxDateSelectEvent) {
    // Create new event from selected date range
    const newEvent: AxCalendarEvent = {
      id: Date.now().toString(),
      title: 'New Event',
      start: event.start,
      end: event.end,
      allDay: event.allDay,
    };

    this.calendar.addEvent(newEvent);
  }

  onEventChange(event: AxEventChangeEvent) {
    // Handle event drag/resize
    console.log('Event moved:', event.event);
    // Update backend with new event data
  }
}
```

### Business Hours Configuration

```typescript
export class BusinessCalendarComponent {
  businessHours = {
    daysOfWeek: [1, 2, 3, 4, 5], // Monday to Friday
    startTime: '09:00',
    endTime: '17:00',
  };

  slotMinTime = '08:00:00';
  slotMaxTime = '18:00:00';
}
```

### Programmatic Navigation

```typescript
export class CalendarNavComponent {
  @ViewChild(AxCalendarComponent) calendar!: AxCalendarComponent;

  goToToday() {
    this.calendar.today();
  }

  switchToWeekView() {
    this.calendar.changeView('timeGridWeek');
  }

  goToNextMonth() {
    this.calendar.next();
  }

  navigateToDate(date: Date) {
    this.calendar.gotoDate(date);
  }
}
```

## Styling & Theming

The calendar component uses CSS variables and AegisX design tokens for theming:

### Default Theme Variables

```css
/* Primary color for indicators and highlights */
--ax-primary-default: #6366f1;

/* Border colors */
--ax-border-default: #e5e7eb;

/* Spacing */
--ax-spacing-md: 1rem;
--ax-spacing-sm: 0.5rem;

/* Shadows */
--ax-shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);

/* Transitions */
--ax-transition-base: 0.15s ease;
```

### Dark Mode

The component automatically supports dark mode through the `.dark` class on the parent element:

```css
.dark .ax-calendar__loading-overlay {
  background-color: rgba(17, 24, 39, 0.7);
}
```

### Custom Styling

You can customize the calendar appearance with CSS overrides:

```scss
// Override calendar height
::ng-deep .ax-calendar {
  min-height: 700px;
}

// Custom event styling
::ng-deep .fc-event-primary {
  background-color: var(--ax-primary-default) !important;
}

// Custom header styling
::ng-deep .fc-toolbar {
  gap: 1rem;
}
```

## Accessibility

The calendar component includes comprehensive accessibility features:

### Keyboard Navigation

- **Tab**: Navigate between interactive elements
- **Arrow Keys**: Move between dates in month view
- **Enter/Space**: Select date or activate event
- **Escape**: Close dialogs or cancel selection

### ARIA Attributes

The component includes proper ARIA labels and roles:

- `role="presentation"` on decorative elements
- `aria-label` on button controls
- `aria-selected` on selected dates
- `aria-current="date"` on today's date

### Screen Reader Support

- Event titles are properly announced
- View changes are announced to screen readers
- Date selections provide feedback to assistive technologies

### Color Independence

Events use multiple visual indicators beyond color:

- Text labels for event information
- Icons can be used in extended props
- Border and text colors for additional distinction

## Related Components

- **[Code Tabs](../code-tabs.md)** - Display code examples alongside events
- **[Card](../card.md)** - Display event details in card format
- **[Dialog](../../dialogs/)** - Show event details in modal dialogs
- **[Data Display](./data-display.md)** - Integrate with other data display components

## Common Patterns

### Event CRUD Operations

```typescript
export class EventManagerComponent {
  @ViewChild(AxCalendarComponent) calendar!: AxCalendarComponent;

  // Create event
  createEvent(title: string, start: Date, end: Date) {
    const event: AxCalendarEvent = {
      id: UUID.v4(),
      title,
      start,
      end,
      color: 'primary',
    };
    this.calendar.addEvent(event);
  }

  // Update event
  updateEvent(id: string, updates: Partial<AxCalendarEvent>) {
    const event = this.events.find((e) => e.id === id);
    if (event) {
      this.calendar.updateEvent({ ...event, ...updates });
    }
  }

  // Delete event
  deleteEvent(id: string) {
    this.calendar.removeEvent(id);
  }

  // Fetch events from backend
  async loadEvents(startDate: Date, endDate: Date) {
    const events = await this.api.getEvents(startDate, endDate);
    this.calendar.events = events;
  }
}
```

### Real-time Event Updates

```typescript
export class RealtimeCalendarComponent {
  @ViewChild(AxCalendarComponent) calendar!: AxCalendarComponent;

  constructor(private websocket: WebSocketService) {}

  ngOnInit() {
    this.websocket.events$.subscribe((event) => {
      switch (event.type) {
        case 'eventAdded':
          this.calendar.addEvent(event.data);
          break;
        case 'eventUpdated':
          this.calendar.updateEvent(event.data);
          break;
        case 'eventRemoved':
          this.calendar.removeEvent(event.data.id);
          break;
      }
    });
  }
}
```

## Troubleshooting

### Calendar Not Rendering

**Issue**: Calendar appears blank or doesn't display events

**Solution**:

- Ensure `FullCalendarModule` is imported in the module
- Verify `events` array is populated with valid `AxCalendarEvent` objects
- Check browser console for JavaScript errors
- Ensure component is in a browser context (use `isPlatformBrowser` for SSR)

### Event Click Not Firing

**Issue**: `eventClick` output doesn't emit when clicking events

**Solution**:

- Verify `(eventClick)` handler is properly bound in template
- Check that events have valid `id` property
- Ensure event object contains expected properties

### Performance Issues with Large Event Lists

**Issue**: Calendar becomes slow with hundreds of events

**Solution**:

- Use pagination to load events in date ranges
- Use `dayMaxEvents` to limit visible events per day
- Consider using list view for large datasets
- Implement virtual scrolling for event lists

## Browser Support

- Chrome/Edge: Latest 2 versions
- Firefox: Latest 2 versions
- Safari: Latest 2 versions
- Mobile browsers: iOS Safari 12+, Chrome Android 60+
