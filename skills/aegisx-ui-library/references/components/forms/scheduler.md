# Scheduler

## Overview

The Scheduler component (`ax-scheduler`) combines date and time selection into a unified booking interface. Perfect for appointment scheduling, event registration, and calendar-based time slot booking.

**Key Features:**

- 📅 Integrated date and time selection
- 🕐 Auto-generated time slots with customizable intervals
- 🚫 Availability-based time slot filtering
- 📱 Responsive layouts (horizontal, vertical, stacked)
- ⌨️ Full keyboard accessibility
- ✅ Built-in validation (ControlValueAccessor + Validator)
- 🌍 Localization support (EN, TH)

## Installation & Import

```typescript
import { AxSchedulerComponent } from '@aegisx/ui';

@Component({
  standalone: true,
  imports: [AxSchedulerComponent],
})
export class MyComponent {}
```

## Basic Usage

### Standalone

```typescript
@Component({
  template: ` <ax-scheduler [(value)]="appointment" label="Select Appointment Time" (valueChange)="onScheduleChange($event)"> </ax-scheduler> `,
})
export class BookingComponent {
  appointment: SchedulerValue = { date: null, time: null };

  onScheduleChange(value: SchedulerValue) {
    console.log('Selected:', value.date, value.time);
  }
}
```

### Reactive Forms

```typescript
@Component({
  template: `
    <form [formGroup]="form">
      <ax-scheduler formControlName="appointmentTime" label="Appointment Date & Time" dateLabel="Select Date" timeLabel="Select Time" [required]="true" [minDate]="minDate" [maxDate]="maxDate"> </ax-scheduler>

      @if (form.get('appointmentTime')?.errors as errors) {
        @if (errors['required']) {
          <span class="error">Please select date and time</span>
        }
        @if (errors['missingDate']) {
          <span class="error">Please select a date</span>
        }
        @if (errors['missingTime']) {
          <span class="error">Please select a time slot</span>
        }
      }
    </form>
  `,
})
export class AppointmentComponent {
  minDate = new Date(); // Today onwards
  maxDate = new Date();

  form = this.fb.group({
    appointmentTime: [null, Validators.required],
  });

  constructor(private fb: FormBuilder) {
    this.maxDate.setDate(this.maxDate.getDate() + 30); // Next 30 days
  }
}
```

## API Reference

### Inputs

| Name                  | Type                                      | Default        | Description                                     |
| --------------------- | ----------------------------------------- | -------------- | ----------------------------------------------- |
| `label`               | `string`                                  | `''`           | Main label for the scheduler                    |
| `dateLabel`           | `string`                                  | `''`           | Label for date picker section                   |
| `timeLabel`           | `string`                                  | `''`           | Label for time slots section                    |
| `layout`              | `'horizontal' \| 'vertical' \| 'stacked'` | `'horizontal'` | Layout orientation                              |
| `size`                | `'sm' \| 'md' \| 'lg'`                    | `'md'`         | Component size                                  |
| `timeFormat`          | `'12h' \| '24h'`                          | `'12h'`        | Time display format                             |
| `locale`              | `'en' \| 'th'`                            | `'en'`         | Localization                                    |
| `columns`             | `number`                                  | `4`            | Grid columns for time slots                     |
| `timeSlotsLayout`     | `'grid' \| 'list'`                        | `'grid'`       | Time slots layout                               |
| `disabled`            | `boolean`                                 | `false`        | Disable interaction                             |
| `required`            | `boolean`                                 | `false`        | Mark as required (validation)                   |
| `helperText`          | `string`                                  | `''`           | Helper text below component                     |
| `errorMessage`        | `string`                                  | `''`           | Error message (overrides helperText)            |
| `minDate`             | `Date \| undefined`                       | `undefined`    | Minimum selectable date                         |
| `maxDate`             | `Date \| undefined`                       | `undefined`    | Maximum selectable date                         |
| `timeConfig`          | `TimeSlotConfig \| undefined`             | `undefined`    | Time slot configuration                         |
| `timeSlots`           | `TimeSlot[]`                              | `[]`           | Custom time slots (overrides timeConfig)        |
| `availability`        | `SchedulerAvailability \| undefined`      | `undefined`    | Date-specific availability map                  |
| `autoSelectFirstTime` | `boolean`                                 | `false`        | Auto-select first available time on date change |

### Outputs

| Name          | Type                           | Description                    |
| ------------- | ------------------------------ | ------------------------------ |
| `dateChange`  | `EventEmitter<Date \| null>`   | Emits when date changes        |
| `timeChange`  | `EventEmitter<string \| null>` | Emits when time slot changes   |
| `valueChange` | `EventEmitter<SchedulerValue>` | Emits combined date/time value |

### Interfaces

```typescript
interface SchedulerValue {
  date: Date | null;
  time: string | null; // HH:mm format
}

interface SchedulerAvailability {
  [dateString: string]: string[]; // "YYYY-MM-DD" -> ["09:00", "10:00", ...]
}

interface TimeSlotConfig {
  startTime?: string; // Default: "09:00"
  endTime?: string; // Default: "17:00"
  interval?: number; // Minutes, default: 30
  excludeTimes?: string[]; // Times to completely hide
  disabledTimes?: string[]; // Times to show but disable
}
```

### FormControl Integration

```typescript
// Reactive Forms setup
form = this.fb.group({
  meeting: [
    { date: null, time: null },
    [Validators.required]
  ]
});

// Template
<ax-scheduler formControlName="meeting"></ax-scheduler>

// Programmatic control
this.form.patchValue({
  meeting: {
    date: new Date(2024, 5, 15),
    time: '14:30'
  }
});

// Get value
const { date, time } = this.form.value.meeting;

// Validation
this.form.get('meeting')?.setErrors({ custom: 'Slot unavailable' });
```

## Advanced Usage

### With Availability Map

```typescript
@Component({
  template: ` <ax-scheduler [(value)]="booking" [availability]="availableSlots" [autoSelectFirstTime]="true"> </ax-scheduler> `,
})
export class DoctorBookingComponent implements OnInit {
  booking: SchedulerValue = { date: null, time: null };
  availableSlots: SchedulerAvailability = {};

  async ngOnInit() {
    // Load available slots from API
    this.availableSlots = await this.api.getDoctorAvailability();
    // Example result:
    // {
    //   "2024-06-15": ["09:00", "10:00", "11:00", "14:00"],
    //   "2024-06-16": ["09:00", "09:30", "15:00", "16:00"],
    //   "2024-06-17": [] // No availability
    // }
  }
}
```

### Custom Time Slots

```typescript
@Component({
  template: ` <ax-scheduler [(value)]="event" [timeSlots]="customSlots" timeFormat="24h"> </ax-scheduler> `,
})
export class EventComponent {
  event: SchedulerValue = { date: null, time: null };

  customSlots: TimeSlot[] = [
    { time: '08:00', label: 'Early Bird Session', available: true },
    { time: '10:00', label: 'Morning Session', available: true },
    { time: '13:00', label: 'Lunch Session', available: false, disabled: true },
    { time: '15:00', label: 'Afternoon Session', available: true },
    { time: '18:00', label: 'Evening Session', available: true, data: { premium: true } },
  ];
}
```

### Layout Variants

```typescript
<!-- Horizontal (default) - Date and time side-by-side -->
<ax-scheduler layout="horizontal"></ax-scheduler>

<!-- Vertical - Date on top, time below -->
<ax-scheduler layout="vertical"></ax-scheduler>

<!-- Stacked - Compact single column -->
<ax-scheduler layout="stacked" size="sm"></ax-scheduler>
```

### Time Configuration

```typescript
@Component({
  template: ` <ax-scheduler [(value)]="appointment" [timeConfig]="businessHours"> </ax-scheduler> `,
})
export class BusinessComponent {
  appointment: SchedulerValue = { date: null, time: null };

  businessHours: TimeSlotConfig = {
    startTime: '08:00',
    endTime: '18:00',
    interval: 60, // 1-hour slots
    excludeTimes: ['12:00', '13:00'], // Lunch break
    disabledTimes: ['17:00'], // Last hour shown but disabled
  };
}
```

## Styling & Theming

### CSS Variables

```css
.ax-scheduler {
  --scheduler-gap: 1.5rem;
  --scheduler-date-width: 300px;
  --scheduler-time-width: 100%;
  --scheduler-border-color: #e5e7eb;
  --scheduler-focus-color: #3b82f6;
}
```

### Layout-Specific Styling

```scss
// Horizontal layout
.ax-scheduler-horizontal {
  display: grid;
  grid-template-columns: var(--scheduler-date-width) 1fr;
  gap: var(--scheduler-gap);

  @media (max-width: 768px) {
    grid-template-columns: 1fr; // Stack on mobile
  }
}

// Vertical layout
.ax-scheduler-vertical {
  display: flex;
  flex-direction: column;
  gap: var(--scheduler-gap);
}

// Stacked layout
.ax-scheduler-stacked {
  max-width: 400px;
}
```

## Accessibility

### ARIA Implementation

```html
<!-- Generated structure -->
<div class="ax-scheduler" role="group" aria-labelledby="scheduler-label">
  <label id="scheduler-label">Select Appointment Time</label>

  <!-- Date picker with ARIA -->
  <div role="region" aria-label="Date selection">
    <ax-date-picker ...></ax-date-picker>
  </div>

  <!-- Time slots with ARIA -->
  <div role="region" aria-label="Time selection">
    <ax-time-slots ...></ax-time-slots>
  </div>
</div>
```

### Keyboard Navigation

**Date Navigation:**

- Arrow keys: Navigate calendar days
- Enter/Space: Select date
- Page Up/Down: Navigate months
- Tab: Move between date and time sections

**Time Navigation:**

- Arrow keys: Navigate time slots
- Enter/Space: Select time
- Home/End: First/last available slot
- Tab: Navigate between slots

### Screen Reader Support

```typescript
// Announcements
'Select appointment time';
'Date selection: June 15, 2024 selected';
'Time selection: 2:30 PM selected';
'Appointment scheduled for June 15, 2024 at 2:30 PM';

// Error states
'Error: Please select a date';
'Error: Please select a time slot';
```

## Validation

### Built-in Validators

The component implements the `Validator` interface:

```typescript
interface SchedulerValidationErrors {
  required?: boolean;
  missingDate?: boolean;
  missingTime?: boolean;
}

// Validation rules
if (required && !selectedDate) {
  return { required: true, missingDate: true };
}
if (required && !selectedTime) {
  return { required: true, missingTime: true };
}
```

### Custom Validators

```typescript
export class SchedulerValidators {
  /** Validate date is in the future */
  static futureDate(control: AbstractControl): ValidationErrors | null {
    const value = control.value as SchedulerValue;
    if (!value?.date) return null;

    const selected = new Date(value.date);
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    return selected >= today ? null : { pastDate: 'Date must be in the future' };
  }

  /** Validate business hours (9 AM - 5 PM) */
  static businessHours(control: AbstractControl): ValidationErrors | null {
    const value = control.value as SchedulerValue;
    if (!value?.time) return null;

    const [hours] = value.time.split(':').map(Number);
    const isBusinessHours = hours >= 9 && hours < 17;

    return isBusinessHours ? null : { outsideBusinessHours: 'Please select 9 AM - 5 PM' };
  }

  /** Validate minimum advance booking (e.g., 24 hours) */
  static minAdvance(hours: number) {
    return (control: AbstractControl): ValidationErrors | null => {
      const value = control.value as SchedulerValue;
      if (!value?.date || !value?.time) return null;

      const [h, m] = value.time.split(':').map(Number);
      const selected = new Date(value.date);
      selected.setHours(h, m, 0, 0);

      const minTime = new Date();
      minTime.setHours(minTime.getHours() + hours);

      return selected >= minTime
        ? null
        : {
            minAdvance: `Booking requires ${hours} hours advance notice`,
          };
    };
  }
}

// Usage
form = this.fb.group({
  appointment: [null, [Validators.required, SchedulerValidators.futureDate, SchedulerValidators.businessHours, SchedulerValidators.minAdvance(24)]],
});
```

## Use Cases

### Appointment Booking

```typescript
@Component({
  template: `
    <div class="booking-form">
      <h2>Book Appointment</h2>

      <form [formGroup]="form" (ngSubmit)="submit()">
        <ax-scheduler formControlName="appointmentTime" label="Select Date & Time" [minDate]="tomorrow" [maxDate]="maxBookingDate" [availability]="doctorAvailability" [autoSelectFirstTime]="true" [required]="true" layout="vertical" timeFormat="12h"> </ax-scheduler>

        @if (selectedSummary) {
          <div class="summary">
            <h3>Appointment Summary</h3>
            <p>{{ selectedSummary }}</p>
          </div>
        }

        <button type="submit" [disabled]="form.invalid">Confirm Booking</button>
      </form>
    </div>
  `,
})
export class AppointmentBookingComponent {
  tomorrow = new Date();
  maxBookingDate = new Date();
  doctorAvailability: SchedulerAvailability = {};

  form = this.fb.group({
    appointmentTime: [null, [Validators.required, SchedulerValidators.minAdvance(24)]],
  });

  constructor(
    private fb: FormBuilder,
    private api: BookingService,
  ) {
    this.tomorrow.setDate(this.tomorrow.getDate() + 1);
    this.maxBookingDate.setDate(this.maxBookingDate.getDate() + 60);

    this.loadAvailability();
  }

  get selectedSummary(): string | null {
    const value = this.form.value.appointmentTime;
    if (!value?.date || !value?.time) return null;

    const dateStr = value.date.toLocaleDateString('en-US', {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    });

    return `${dateStr} at ${this.formatTime(value.time)}`;
  }

  async loadAvailability() {
    this.doctorAvailability = await this.api.getDoctorSchedule();
  }

  async submit() {
    if (this.form.valid) {
      const { date, time } = this.form.value.appointmentTime;
      await this.api.bookAppointment(date, time);
    }
  }

  private formatTime(time: string): string {
    const [h, m] = time.split(':').map(Number);
    const period = h >= 12 ? 'PM' : 'AM';
    const hours = h % 12 || 12;
    return `${hours}:${m.toString().padStart(2, '0')} ${period}`;
  }
}
```

### Event Registration

```typescript
@Component({
  template: ` <ax-scheduler [(value)]="sessionTime" label="Select Workshop Session" [timeSlots]="workshopSessions" [minDate]="eventStartDate" [maxDate]="eventEndDate" layout="horizontal" (valueChange)="onSessionSelect($event)"> </ax-scheduler> `,
})
export class WorkshopRegistrationComponent {
  eventStartDate = new Date(2024, 6, 1);
  eventEndDate = new Date(2024, 6, 3);
  sessionTime: SchedulerValue = { date: null, time: null };

  workshopSessions: TimeSlot[] = [
    { time: '09:00', label: 'Introduction to Angular', available: true },
    { time: '11:00', label: 'Advanced RxJS', available: true },
    { time: '14:00', label: 'State Management', available: false }, // Full
    { time: '16:00', label: 'Testing Strategies', available: true },
  ];

  onSessionSelect(value: SchedulerValue) {
    console.log('Workshop session selected:', value);
  }
}
```

## Performance Considerations

### Optimizing Availability Loading

```typescript
@Component({
  template: ` <ax-scheduler [(value)]="appointment" [availability]="availability$ | async" [timeConfig]="config"> </ax-scheduler> `,
})
export class OptimizedComponent {
  // Use async pipe for reactive updates
  availability$ = this.loadAvailability();

  config: TimeSlotConfig = {
    startTime: '09:00',
    endTime: '17:00',
    interval: 30,
  };

  private loadAvailability(): Observable<SchedulerAvailability> {
    return this.api.getAvailability().pipe(
      shareReplay(1), // Cache result
      catchError(() => of({})), // Fallback
    );
  }
}
```

## Related Components

- [Date Picker](./date-picker.md) - Standalone date selection
- [Time Slots](./time-slots.md) - Standalone time selection
- [Input OTP](./input-otp.md) - OTP input for verification
