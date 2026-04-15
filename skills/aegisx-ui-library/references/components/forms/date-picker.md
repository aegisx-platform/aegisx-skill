# Date Picker

## Overview

The Date Picker component (`ax-date-picker`) is a comprehensive date selection component with calendar interface, supporting both single date and date range selection. Features full keyboard navigation, localization, and flexible display modes.

**Key Features:**

- 📅 Single date and date range selection modes
- 🌍 Multi-locale support (EN, TH) with Buddhist calendar
- 📱 Input dropdown or inline display modes
- ⌨️ Complete keyboard navigation (arrows, page up/down, home/end)
- ✅ Built-in validation (min/max dates, required)
- 🎨 Customizable date formats
- ♿ WCAG 2.1 Level AA compliant

## Installation & Import

```typescript
import { AxDatePickerComponent } from '@aegisx/ui';

@Component({
  standalone: true,
  imports: [AxDatePickerComponent],
})
export class MyComponent {}
```

## Basic Usage

### Single Date Selection

```typescript
@Component({
  template: ` <ax-date-picker [(value)]="selectedDate" label="Select Date" placeholder="Choose a date" (dateChange)="onDateChange($event)"> </ax-date-picker> `,
})
export class Component {
  selectedDate: Date | null = null;

  onDateChange(date: Date | null) {
    console.log('Selected:', date);
  }
}
```

### Date Range Selection

```typescript
@Component({
  template: ` <ax-date-picker [(rangeValue)]="dateRange" mode="range" label="Select Date Range" (rangeChange)="onRangeChange($event)"> </ax-date-picker> `,
})
export class Component {
  dateRange: DateRange = { start: null, end: null };

  onRangeChange(range: DateRange) {
    console.log('Range:', range.start, '-', range.end);
  }
}
```

### Reactive Forms

```typescript
@Component({
  template: `
    <form [formGroup]="form">
      <ax-date-picker formControlName="birthdate" label="Date of Birth" [required]="true" [maxDate]="today" [errorMessage]="getError('birthdate')"> </ax-date-picker>
    </form>
  `,
})
export class Component {
  today = new Date();

  form = this.fb.group({
    birthdate: [null, Validators.required],
  });

  getError(field: string): string {
    const control = this.form.get(field);
    if (control?.hasError('required')) return 'Date is required';
    if (control?.hasError('maxDate')) return 'Date cannot be in the future';
    return '';
  }
}
```

## API Reference

### Inputs

| Name                | Type                        | Default         | Description                          |
| ------------------- | --------------------------- | --------------- | ------------------------------------ |
| `label`             | `string`                    | `''`            | Label text                           |
| `placeholder`       | `string`                    | `'Select date'` | Placeholder text                     |
| `disabled`          | `boolean`                   | `false`         | Disabled state                       |
| `readonly`          | `boolean`                   | `false`         | Readonly state                       |
| `required`          | `boolean`                   | `false`         | Required validation                  |
| `size`              | `'sm' \| 'md'`              | `'md'`          | Component size                       |
| `minDate`           | `Date \| undefined`         | `undefined`     | Minimum selectable date              |
| `maxDate`           | `Date \| undefined`         | `undefined`     | Maximum selectable date              |
| `helperText`        | `string`                    | `''`            | Helper text below input              |
| `errorMessage`      | `string`                    | `''`            | Error message (overrides helperText) |
| `locale`            | `'en' \| 'th'`              | `'en'`          | Localization                         |
| `calendar`          | `'gregorian' \| 'buddhist'` | `'gregorian'`   | Calendar system                      |
| `monthFormat`       | `'full' \| 'short'`         | `'full'`        | Month display format                 |
| `firstDayOfWeek`    | `0-6`                       | `0`             | First day of week (0=Sunday)         |
| `dateFormat`        | `string \| undefined`       | `undefined`     | Custom date format pattern           |
| `showActionButtons` | `boolean`                   | `false`         | Show Today/Clear buttons             |
| `displayMode`       | `'input' \| 'inline'`       | `'input'`       | Display mode                         |
| `mode`              | `'single' \| 'range'`       | `'single'`      | Selection mode                       |

### Outputs

| Name          | Type                         | Description                        |
| ------------- | ---------------------------- | ---------------------------------- |
| `dateChange`  | `EventEmitter<Date \| null>` | Emits on date change (single mode) |
| `rangeChange` | `EventEmitter<DateRange>`    | Emits on range change (range mode) |

### Interfaces

```typescript
interface DateRange {
  start: Date | null;
  end: Date | null;
}
```

### Methods

| Name            | Signature  | Description               |
| --------------- | ---------- | ------------------------- |
| `clearValue()`  | `(): void` | Clear selected date/range |
| `selectToday()` | `(): void` | Select today's date       |

### FormControl Integration

```typescript
// Single date
form = this.fb.group({
  date: [new Date(), [Validators.required]]
});

// Date range
form = this.fb.group({
  dateRange: [{ start: null, end: null }, [Validators.required]]
});

// Validators
<ax-date-picker
  formControlName="date"
  [minDate]="minDate"
  [maxDate]="maxDate">
</ax-date-picker>

// Access
this.form.get('date')?.setValue(new Date());
const date = this.form.get('date')?.value;
```

## Advanced Usage

### Custom Date Format

```typescript
@Component({
  template: `
    <!-- DD/MM/YYYY -->
    <ax-date-picker [(value)]="date1" dateFormat="DD/MM/YYYY"> </ax-date-picker>

    <!-- MMM DD, YYYY -->
    <ax-date-picker [(value)]="date2" dateFormat="MMM DD, YYYY"> </ax-date-picker>

    <!-- YYYY-MM-DD -->
    <ax-date-picker [(value)]="date3" dateFormat="YYYY-MM-DD"> </ax-date-picker>
  `,
})
export class Component {
  date1: Date | null = null;
  date2: Date | null = null;
  date3: Date | null = null;
}
```

**Supported Format Tokens:**

- `YYYY`: Full year (2024, 2567 for Buddhist)
- `YY`: 2-digit year (24, 67)
- `MMMM`: Full month name (January, มกราคม)
- `MMM`: Short month name (Jan, ม.ค.)
- `MM`: Month with leading zero (01-12)
- `M`: Month without leading zero (1-12)
- `DD`: Day with leading zero (01-31)
- `D`: Day without leading zero (1-31)

### Thai Buddhist Calendar

```typescript
<ax-date-picker
  [(value)]="date"
  locale="th"
  calendar="buddhist"
  dateFormat="D MMMM YYYY">
</ax-date-picker>
<!-- Displays: 15 มิถุนายน 2567 -->
```

### Inline Calendar Mode

```typescript
@Component({
  template: ` <ax-date-picker [(value)]="selectedDate" displayMode="inline" [showActionButtons]="true"> </ax-date-picker> `,
})
export class Component {
  selectedDate: Date | null = new Date();
}
```

### Min/Max Date Constraints

```typescript
@Component({
  template: ` <ax-date-picker [(value)]="departureDate" label="Departure Date" [minDate]="tomorrow" [maxDate]="maxBooking"> </ax-date-picker> `,
})
export class FlightBookingComponent {
  tomorrow = new Date();
  maxBooking = new Date();

  constructor() {
    this.tomorrow.setDate(this.tomorrow.getDate() + 1);
    this.maxBooking.setDate(this.maxBooking.getDate() + 365);
  }
}
```

### Custom First Day of Week

```typescript
<!-- Week starts on Monday -->
<ax-date-picker
  [(value)]="date"
  [firstDayOfWeek]="1">
</ax-date-picker>

<!-- Week starts on Sunday (default) -->
<ax-date-picker
  [(value)]="date"
  [firstDayOfWeek]="0">
</ax-date-picker>
```

## Styling & Theming

### CSS Variables

```css
.ax-date-picker {
  --date-picker-width: 300px;
  --date-picker-header-bg: #f9fafb;
  --date-picker-cell-size: 2.5rem;
  --date-picker-border-color: #e5e7eb;
  --date-picker-selected-bg: #3b82f6;
  --date-picker-selected-color: #ffffff;
  --date-picker-today-border: #3b82f6;
  --date-picker-hover-bg: #f3f4f6;
  --date-picker-disabled-color: #d1d5db;
}
```

### Custom Styling

```scss
.custom-date-picker {
  .ax-date-picker__calendar {
    border-radius: 1rem;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
  }

  .ax-date-picker__day {
    &.ax-date-picker__day--today {
      font-weight: 600;
      border: 2px solid var(--date-picker-today-border);
    }

    &.ax-date-picker__day--selected {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
    }

    &.ax-date-picker__day--in-range {
      background: rgba(102, 126, 234, 0.1);
    }
  }
}
```

## Accessibility

### ARIA Attributes

```html
<div class="ax-date-picker-wrapper" role="group" aria-labelledby="date-picker-label">
  <input type="text" role="combobox" aria-haspopup="dialog" aria-expanded="false" aria-label="Choose date" />

  <div role="dialog" aria-label="Choose date">
    <div role="grid" aria-labelledby="month-year">
      <div role="row">
        <button role="gridcell" aria-label="June 15, 2024, Friday">15</button>
      </div>
    </div>
  </div>
</div>
```

### Keyboard Navigation

| Key               | Action                      |
| ----------------- | --------------------------- |
| `Enter/Space`     | Open calendar / Select date |
| `Escape`          | Close calendar              |
| `Arrow Keys`      | Navigate calendar days      |
| `Page Up`         | Previous month              |
| `Page Down`       | Next month                  |
| `Shift+Page Up`   | Previous year               |
| `Shift+Page Down` | Next year                   |
| `Home`            | First day of month          |
| `End`             | Last day of month           |
| `Tab`             | Navigate between elements   |

### Screen Reader Support

```typescript
// Screen reader announcements
'Date picker, Choose date';
'Calendar opened';
'June 15, 2024, Friday, selected';
'In range: June 10 to June 20, 2024';
'Minimum date: January 1, 2024';
'Maximum date: December 31, 2024';
```

## Validation

### Built-in Validators

```typescript
// Required validation
@if (form.get('date')?.errors?.['required']) {
  <span>Date is required</span>
}

// Min date validation
@if (form.get('date')?.errors?.['minDate'] as error) {
  <span>Date must be after {{ error.minDate }}</span>
}

// Max date validation
@if (form.get('date')?.errors?.['maxDate'] as error) {
  <span>Date must be before {{ error.maxDate }}</span>
}
```

### Custom Validators

```typescript
export class DateValidators {
  /** Validate date is a weekday (Mon-Fri) */
  static weekday(control: AbstractControl): ValidationErrors | null {
    const date = control.value as Date;
    if (!date) return null;

    const day = date.getDay();
    const isWeekday = day > 0 && day < 6;

    return isWeekday ? null : { weekday: 'Please select a weekday' };
  }

  /** Validate date is within N days from today */
  static withinDays(days: number) {
    return (control: AbstractControl): ValidationErrors | null => {
      const date = control.value as Date;
      if (!date) return null;

      const maxDate = new Date();
      maxDate.setDate(maxDate.getDate() + days);

      return date <= maxDate
        ? null
        : {
            withinDays: `Date must be within ${days} days`,
          };
    };
  }

  /** Validate date range has minimum duration */
  static minDuration(days: number) {
    return (control: AbstractControl): ValidationErrors | null => {
      const range = control.value as DateRange;
      if (!range?.start || !range?.end) return null;

      const duration = Math.floor((range.end.getTime() - range.start.getTime()) / (1000 * 60 * 60 * 24));

      return duration >= days
        ? null
        : {
            minDuration: `Range must be at least ${days} days`,
          };
    };
  }
}

// Usage
form = this.fb.group({
  date: [null, [Validators.required, DateValidators.weekday, DateValidators.withinDays(30)]],
  dateRange: [null, [Validators.required, DateValidators.minDuration(7)]],
});
```

## Use Cases

### Booking Form

```typescript
@Component({
  template: `
    <form [formGroup]="bookingForm">
      <ax-date-picker formControlName="checkIn" label="Check-in Date" [minDate]="today" [maxDate]="maxDate" (dateChange)="onCheckInChange($event)"> </ax-date-picker>

      <ax-date-picker formControlName="checkOut" label="Check-out Date" [minDate]="minCheckOut" [maxDate]="maxDate"> </ax-date-picker>
    </form>
  `,
})
export class BookingComponent {
  today = new Date();
  maxDate = new Date();
  minCheckOut = new Date();

  bookingForm = this.fb.group({
    checkIn: [null, Validators.required],
    checkOut: [null, Validators.required],
  });

  constructor(private fb: FormBuilder) {
    this.maxDate.setFullYear(this.maxDate.getFullYear() + 1);
    this.updateMinCheckOut();
  }

  onCheckInChange(date: Date | null) {
    if (date) {
      this.minCheckOut = new Date(date);
      this.minCheckOut.setDate(this.minCheckOut.getDate() + 1);

      // Reset check-out if before new minimum
      const checkOut = this.bookingForm.get('checkOut')?.value;
      if (checkOut && checkOut <= date) {
        this.bookingForm.patchValue({ checkOut: null });
      }
    }
  }

  private updateMinCheckOut() {
    this.minCheckOut = new Date(this.today);
    this.minCheckOut.setDate(this.minCheckOut.getDate() + 1);
  }
}
```

## Browser Compatibility

- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+
- ✅ Mobile Safari (iOS 14+)
- ✅ Chrome Mobile (Android 8+)

## Related Components

- [Scheduler](./scheduler.md) - Combined date and time selection
- [Time Slots](./time-slots.md) - Time slot selection
