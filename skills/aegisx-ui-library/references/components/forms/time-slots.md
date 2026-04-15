# Time Slots

## Overview

The Time Slots component (`ax-time-slots`) provides a visual time slot selection interface with configurable layouts and auto-generation capabilities. Perfect for appointment booking, schedule selection, and time-based reservations.

**Key Features:**

- 🕐 Auto-generate time slots with configurable intervals
- 📋 Custom time slots with labels and metadata
- 🎯 Single or multiple selection modes
- 📱 Grid or list layout options
- 🌍 Localization support (EN, TH)
- ⏰ 12-hour and 24-hour time formats
- ✅ Built-in validation (ControlValueAccessor + Validator)
- ♿ Full keyboard accessibility

## Installation & Import

```typescript
import { AxTimeSlotsComponent } from '@aegisx/ui';

@Component({
  standalone: true,
  imports: [AxTimeSlotsComponent],
})
export class MyComponent {}
```

## Basic Usage

### Single Selection

```typescript
@Component({
  template: `
    <ax-time-slots [(selectedValue)]="selectedTime" label="Select Time" (slotSelect)="onTimeSelect($event)"> </ax-time-slots>

    <p>Selected: {{ selectedTime }}</p>
  `,
})
export class Component {
  selectedTime: string | null = null;

  onTimeSelect(slot: TimeSlot) {
    console.log('Selected:', slot.time, slot.label);
  }
}
```

### Multiple Selection

```typescript
@Component({
  template: `
    <ax-time-slots [(selectedValue)]="selectedTimes" mode="multiple" label="Select Multiple Times" [columns]="3"> </ax-time-slots>

    <p>Selected: {{ selectedTimes.join(', ') }}</p>
  `,
})
export class Component {
  selectedTimes: string[] = [];
}
```

### Reactive Forms

```typescript
@Component({
  template: `
    <form [formGroup]="form">
      <ax-time-slots formControlName="appointmentTime" label="Appointment Time" [required]="true" [errorMessage]="getError()"> </ax-time-slots>
    </form>
  `,
})
export class Component {
  form = this.fb.group({
    appointmentTime: [null, Validators.required],
  });

  getError(): string {
    const control = this.form.get('appointmentTime');
    return control?.hasError('required') ? 'Please select a time' : '';
  }
}
```

## API Reference

### Inputs

| Name           | Type                          | Default     | Description            |
| -------------- | ----------------------------- | ----------- | ---------------------- |
| `label`        | `string`                      | `''`        | Label text             |
| `size`         | `'sm' \| 'md' \| 'lg'`        | `'md'`      | Slot size              |
| `layout`       | `'grid' \| 'list'`            | `'grid'`    | Display layout         |
| `mode`         | `'single' \| 'multiple'`      | `'single'`  | Selection mode         |
| `timeFormat`   | `'12h' \| '24h'`              | `'12h'`     | Time display format    |
| `locale`       | `'en' \| 'th'`                | `'en'`      | Localization           |
| `columns`      | `number`                      | `4`         | Grid columns           |
| `disabled`     | `boolean`                     | `false`     | Disable all slots      |
| `required`     | `boolean`                     | `false`     | Required validation    |
| `helperText`   | `string`                      | `''`        | Helper text            |
| `errorMessage` | `string`                      | `''`        | Error message          |
| `slots`        | `TimeSlot[]`                  | `[]`        | Custom time slots      |
| `config`       | `TimeSlotConfig \| undefined` | `undefined` | Auto-generation config |

### Outputs

| Name          | Type                               | Description             |
| ------------- | ---------------------------------- | ----------------------- |
| `slotSelect`  | `EventEmitter<TimeSlot>`           | Emits on slot selection |
| `valueChange` | `EventEmitter<string \| string[]>` | Emits current value(s)  |

### Interfaces

```typescript
interface TimeSlot {
  time: string; // HH:mm format (e.g., "09:00", "14:30")
  label?: string; // Optional custom label
  disabled?: boolean; // Disable this slot
  available?: boolean; // Mark as available/unavailable
  data?: unknown; // Optional custom data
}

interface TimeSlotConfig {
  startTime?: string; // HH:mm format, default "09:00"
  endTime?: string; // HH:mm format, default "17:00"
  interval?: number; // Minutes, default 30
  excludeTimes?: string[]; // Times to exclude completely
  disabledTimes?: string[]; // Times to show but disable
}
```

### FormControl Integration

```typescript
// Single selection
form = this.fb.group({
  time: [null, Validators.required]
});

// Multiple selection
form = this.fb.group({
  times: [[], Validators.required]
});

// Template
<ax-time-slots formControlName="time"></ax-time-slots>
<ax-time-slots formControlName="times" mode="multiple"></ax-time-slots>

// Programmatic control
this.form.get('time')?.setValue('14:30');
this.form.get('times')?.setValue(['09:00', '10:30', '15:00']);

// Get value
const time = this.form.value.time;
const times = this.form.value.times;
```

## Advanced Usage

### Auto-Generated Time Slots

```typescript
@Component({
  template: ` <ax-time-slots [(selectedValue)]="time" [config]="timeConfig" label="Business Hours"> </ax-time-slots> `,
})
export class Component {
  time: string | null = null;

  timeConfig: TimeSlotConfig = {
    startTime: '09:00',
    endTime: '17:00',
    interval: 30, // 30-minute intervals
    excludeTimes: ['12:00', '12:30'], // Lunch break
    disabledTimes: ['16:30'], // Last slot disabled
  };
}
```

### Custom Time Slots

```typescript
@Component({
  template: ` <ax-time-slots [(selectedValue)]="time" [slots]="customSlots" label="Workshop Sessions"> </ax-time-slots> `,
})
export class Component {
  time: string | null = null;

  customSlots: TimeSlot[] = [
    {
      time: '09:00',
      label: 'Morning Session',
      available: true,
      data: { duration: 120, instructor: 'John Doe' },
    },
    {
      time: '11:30',
      label: 'Late Morning',
      available: true,
    },
    {
      time: '13:00',
      label: 'Lunch Session',
      available: false,
      disabled: true,
    },
    {
      time: '15:00',
      label: 'Afternoon Session',
      available: true,
    },
    {
      time: '17:30',
      label: 'Evening Session',
      available: true,
      data: { premium: true },
    },
  ];
}
```

### Layout Options

```typescript
<!-- Grid layout with 4 columns (default) -->
<ax-time-slots
  [(selectedValue)]="time"
  layout="grid"
  [columns]="4">
</ax-time-slots>

<!-- Grid layout with 3 columns -->
<ax-time-slots
  [(selectedValue)]="time"
  layout="grid"
  [columns]="3">
</ax-time-slots>

<!-- List layout (single column) -->
<ax-time-slots
  [(selectedValue)]="time"
  layout="list">
</ax-time-slots>
```

### Time Format and Localization

```typescript
<!-- 12-hour format, English -->
<ax-time-slots
  [(selectedValue)]="time"
  timeFormat="12h"
  locale="en">
</ax-time-slots>
<!-- Displays: 9:00 AM, 2:30 PM -->

<!-- 24-hour format, English -->
<ax-time-slots
  [(selectedValue)]="time"
  timeFormat="24h"
  locale="en">
</ax-time-slots>
<!-- Displays: 09:00, 14:30 -->

<!-- 12-hour format, Thai -->
<ax-time-slots
  [(selectedValue)]="time"
  timeFormat="12h"
  locale="th">
</ax-time-slots>
<!-- Displays: 9:00 เช้า, 2:30 บ่าย -->
```

### Size Variants

```typescript
<!-- Small -->
<ax-time-slots [(selectedValue)]="time" size="sm"></ax-time-slots>

<!-- Medium (default) -->
<ax-time-slots [(selectedValue)]="time" size="md"></ax-time-slots>

<!-- Large -->
<ax-time-slots [(selectedValue)]="time" size="lg"></ax-time-slots>
```

## Styling & Theming

### CSS Variables

```css
.ax-time-slots {
  --time-slot-gap: 0.5rem;
  --time-slot-padding: 0.75rem 1rem;
  --time-slot-border-color: #e5e7eb;
  --time-slot-hover-bg: #f3f4f6;
  --time-slot-selected-bg: #3b82f6;
  --time-slot-selected-color: #ffffff;
  --time-slot-disabled-bg: #f9fafb;
  --time-slot-disabled-color: #d1d5db;
  --time-slot-unavailable-bg: #fef2f2;
  --time-slot-unavailable-border: #fecaca;
}
```

### Custom Styling

```scss
.custom-time-slots {
  .ax-time-slot {
    border-radius: 0.5rem;
    font-weight: 500;
    transition: all 0.2s;

    &:hover:not(.ax-time-slot-disabled) {
      transform: translateY(-2px);
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    &.ax-time-slot-selected {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
    }

    &.ax-time-slot-unavailable {
      opacity: 0.5;
      text-decoration: line-through;
    }
  }
}
```

### Layout-Specific Styling

```scss
// Grid layout
.ax-time-slots-grid {
  display: grid;
  gap: var(--time-slot-gap);
  // Columns set dynamically via [columns] input
}

// List layout
.ax-time-slots-list {
  display: flex;
  flex-direction: column;
  gap: var(--time-slot-gap);
  max-width: 400px;
}
```

## Accessibility

### ARIA Attributes

```html
<div class="ax-time-slots-container" role="group" aria-labelledby="time-slots-label">
  <label id="time-slots-label">Select Time</label>

  <div class="ax-time-slots-grid" role="radiogroup">
    <button class="ax-time-slot" role="radio" aria-checked="false" aria-label="9:00 AM">9:00 AM</button>
    <!-- More slots -->
  </div>
</div>
```

**ARIA Properties:**

- `role="radiogroup"` (single mode) or `role="group"` (multiple mode)
- `role="radio"` or `role="checkbox"` for individual slots
- `aria-checked`: Indicates selection state
- `aria-disabled`: Indicates disabled state
- `aria-label`: Descriptive label for each slot

### Keyboard Navigation

| Key           | Action                       |
| ------------- | ---------------------------- |
| `Tab`         | Navigate between slots       |
| `Shift+Tab`   | Navigate backward            |
| `Space/Enter` | Select/deselect slot         |
| `Arrow Keys`  | Navigate slots (grid layout) |
| `Home`        | Focus first slot             |
| `End`         | Focus last slot              |

### Screen Reader Support

```typescript
// Announcements
"Select time, time slot group"
"9:00 AM, not selected"
"9:00 AM, selected"
"12:00 PM, unavailable, disabled"
"3 of 10 time slots selected" (multiple mode)
```

## Validation

### Built-in Validators

```typescript
// Required validation (single mode)
@if (form.get('time')?.errors?.['required']) {
  <span>Please select a time</span>
}

// Required validation (multiple mode)
@if (form.get('times')?.errors?.['required']) {
  <span>Please select at least one time</span>
}
```

### Custom Validators

```typescript
export class TimeSlotValidators {
  /** Validate minimum selections (multiple mode) */
  static minSelections(min: number) {
    return (control: AbstractControl): ValidationErrors | null => {
      const value = control.value as string[];
      if (!Array.isArray(value)) return null;

      return value.length >= min
        ? null
        : {
            minSelections: `Select at least ${min} time slots`,
          };
    };
  }

  /** Validate maximum selections (multiple mode) */
  static maxSelections(max: number) {
    return (control: AbstractControl): ValidationErrors | null => {
      const value = control.value as string[];
      if (!Array.isArray(value)) return null;

      return value.length <= max
        ? null
        : {
            maxSelections: `Select at most ${max} time slots`,
          };
    };
  }

  /** Validate time is within business hours */
  static businessHours(control: AbstractControl): ValidationErrors | null {
    const time = control.value as string;
    if (!time) return null;

    const [hours] = time.split(':').map(Number);
    const isBusinessHours = hours >= 9 && hours < 17;

    return isBusinessHours
      ? null
      : {
          businessHours: 'Please select business hours (9 AM - 5 PM)',
        };
  }

  /** Validate consecutive time slots (multiple mode) */
  static consecutive(control: AbstractControl): ValidationErrors | null {
    const times = control.value as string[];
    if (!Array.isArray(times) || times.length < 2) return null;

    // Sort times
    const sorted = times
      .map((t) => {
        const [h, m] = t.split(':').map(Number);
        return h * 60 + m;
      })
      .sort((a, b) => a - b);

    // Check if consecutive (30-min intervals)
    for (let i = 1; i < sorted.length; i++) {
      if (sorted[i] - sorted[i - 1] !== 30) {
        return { consecutive: 'Please select consecutive time slots' };
      }
    }

    return null;
  }
}

// Usage
form = this.fb.group({
  time: [null, [Validators.required, TimeSlotValidators.businessHours]],
  times: [[], [Validators.required, TimeSlotValidators.minSelections(2), TimeSlotValidators.maxSelections(4), TimeSlotValidators.consecutive]],
});
```

## Use Cases

### Appointment Booking

```typescript
@Component({
  template: `
    <div class="booking-form">
      <h3>Select Appointment Time</h3>

      <ax-time-slots [(selectedValue)]="selectedTime" [slots]="availableSlots" label="Available Times" timeFormat="12h" layout="grid" [columns]="4" (slotSelect)="onSlotSelect($event)"> </ax-time-slots>

      @if (selectedTime) {
        <div class="confirmation">
          <p>Selected: {{ formatSelectedTime() }}</p>
          <button (click)="confirmBooking()">Confirm Booking</button>
        </div>
      }
    </div>
  `,
})
export class AppointmentComponent implements OnInit {
  selectedTime: string | null = null;
  availableSlots: TimeSlot[] = [];

  async ngOnInit() {
    this.availableSlots = await this.loadAvailableSlots();
  }

  async loadAvailableSlots(): Promise<TimeSlot[]> {
    const slots = await this.api.getAvailableAppointments();
    return slots.map((slot) => ({
      time: slot.time,
      available: slot.isAvailable,
      disabled: !slot.isAvailable,
      data: { doctorId: slot.doctorId },
    }));
  }

  onSlotSelect(slot: TimeSlot) {
    console.log('Selected slot:', slot);
  }

  formatSelectedTime(): string {
    if (!this.selectedTime) return '';

    const [hours, minutes] = this.selectedTime.split(':').map(Number);
    const period = hours >= 12 ? 'PM' : 'AM';
    const displayHours = hours % 12 || 12;

    return `${displayHours}:${minutes.toString().padStart(2, '0')} ${period}`;
  }

  confirmBooking() {
    if (this.selectedTime) {
      this.api.bookAppointment(this.selectedTime).subscribe();
    }
  }
}
```

### Meeting Room Reservation

```typescript
@Component({
  template: `
    <form [formGroup]="form">
      <ax-time-slots formControlName="timeSlots" mode="multiple" [config]="roomConfig" label="Reserve Time Slots (Select multiple for longer meetings)" [columns]="6" size="sm" [required]="true"> </ax-time-slots>

      @if (selectedDuration) {
        <p>Duration: {{ selectedDuration }} minutes</p>
      }

      <button [disabled]="form.invalid" (click)="reserve()">Reserve Room</button>
    </form>
  `,
})
export class RoomReservationComponent {
  form = this.fb.group({
    timeSlots: [[], [Validators.required, TimeSlotValidators.minSelections(1), TimeSlotValidators.consecutive]],
  });

  roomConfig: TimeSlotConfig = {
    startTime: '08:00',
    endTime: '18:00',
    interval: 30,
  };

  get selectedDuration(): number | null {
    const slots = this.form.value.timeSlots;
    return slots?.length ? slots.length * 30 : null;
  }

  reserve() {
    if (this.form.valid) {
      const slots = this.form.value.timeSlots;
      this.roomService.reserve(slots).subscribe();
    }
  }
}
```

## Integration with Scheduler

The Time Slots component is used internally by the Scheduler component:

```typescript
import { AxSchedulerComponent } from '@aegisx/ui';

// Scheduler uses ax-time-slots internally
<ax-scheduler
  [(value)]="appointment"
  [timeConfig]="config">
</ax-scheduler>
```

See [Scheduler documentation](./scheduler.md) for combined date and time selection.

## Browser Compatibility

- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+
- ✅ Mobile Safari (iOS 14+)
- ✅ Chrome Mobile (Android 8+)

## Related Components

- [Scheduler](./scheduler.md) - Combined date and time selection
- [Date Picker](./date-picker.md) - Date selection
- [Knob](./knob.md) - Circular value control
