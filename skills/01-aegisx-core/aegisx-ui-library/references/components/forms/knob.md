# Knob

## Overview

The Knob component (`ax-knob`) is a circular input control for numeric values, controlled by mouse or touch drag. Perfect for dashboard gauges, volume controls, brightness settings, and any circular progress indicators.

**Key Features:**

- 🎛️ Circular drag-to-adjust interface
- 📱 Touch and mouse support
- 🔄 Angular Forms integration (ControlValueAccessor)
- 🎨 Multiple size variants (sm, md, lg, xl)
- 🌈 Color themes (primary, accent, success, warning, error)
- ⚙️ Configurable min/max, step, and arc angle
- 📊 Optional value display
- ♿ Accessible with ARIA attributes

## Installation & Import

```typescript
import { AxKnobComponent } from '@aegisx/ui';

@Component({
  standalone: true,
  imports: [AxKnobComponent],
})
export class MyComponent {}
```

## Basic Usage

### Standalone

```typescript
@Component({
  template: `
    <ax-knob [(value)]="volume" [min]="0" [max]="100" (valueChange)="onVolumeChange($event)"> </ax-knob>

    <p>Volume: {{ volume }}%</p>
  `,
})
export class Component {
  volume = 50;

  onVolumeChange(newVolume: number) {
    console.log('Volume changed to:', newVolume);
  }
}
```

### Reactive Forms

```typescript
@Component({
  template: `
    <form [formGroup]="form">
      <ax-knob formControlName="brightness" [min]="0" [max]="255" [showValue]="true" color="primary"> </ax-knob>

      <p>Brightness: {{ form.value.brightness }}</p>
    </form>
  `,
})
export class Component {
  form = this.fb.group({
    brightness: [128], // Default 50%
  });

  constructor(private fb: FormBuilder) {}
}
```

## API Reference

### Inputs

| Name          | Type                                                         | Default     | Description                         |
| ------------- | ------------------------------------------------------------ | ----------- | ----------------------------------- |
| `value`       | `number`                                                     | `0`         | Current value                       |
| `min`         | `number`                                                     | `0`         | Minimum value                       |
| `max`         | `number`                                                     | `100`       | Maximum value                       |
| `step`        | `number`                                                     | `1`         | Step increment                      |
| `size`        | `'sm' \| 'md' \| 'lg' \| 'xl'`                               | `'md'`      | Component size                      |
| `color`       | `'primary' \| 'accent' \| 'success' \| 'warning' \| 'error'` | `'primary'` | Progress color                      |
| `showValue`   | `boolean`                                                    | `true`      | Show value in center                |
| `valueSuffix` | `string`                                                     | `''`        | Value suffix (e.g., '%', 'dB')      |
| `disabled`    | `boolean`                                                    | `false`     | Disable interaction                 |
| `readonly`    | `boolean`                                                    | `false`     | Read-only mode                      |
| `startAngle`  | `number`                                                     | `-135`      | Starting angle in degrees (0 = top) |
| `arcAngle`    | `number`                                                     | `270`       | Arc angle in degrees                |

### Outputs

| Name          | Type                   | Description              |
| ------------- | ---------------------- | ------------------------ |
| `valueChange` | `EventEmitter<number>` | Emits when value changes |

### FormControl Integration

```typescript
// Reactive Forms
form = this.fb.group({
  volume: [50, [Validators.min(0), Validators.max(100)]],
  temperature: [20, [Validators.min(-20), Validators.max(40)]]
});

// Template
<ax-knob formControlName="volume"></ax-knob>
<ax-knob formControlName="temperature"></ax-knob>

// Programmatic control
this.form.get('volume')?.setValue(75);
const volume = this.form.value.volume;

// Disable/Enable
this.form.get('volume')?.disable();
this.form.get('volume')?.enable();
```

## Advanced Usage

### Size Variants

```typescript
<!-- Small - 60px -->
<ax-knob [(value)]="value1" size="sm" [min]="0" [max]="100"></ax-knob>

<!-- Medium - 80px (default) -->
<ax-knob [(value)]="value2" size="md" [min]="0" [max]="100"></ax-knob>

<!-- Large - 100px -->
<ax-knob [(value)]="value3" size="lg" [min]="0" [max]="100"></ax-knob>

<!-- Extra Large - 140px -->
<ax-knob [(value)]="value4" size="xl" [min]="0" [max]="100"></ax-knob>
```

### Color Themes

```typescript
<!-- Primary (blue) -->
<ax-knob [(value)]="value" color="primary"></ax-knob>

<!-- Accent (purple) -->
<ax-knob [(value)]="value" color="accent"></ax-knob>

<!-- Success (green) -->
<ax-knob [(value)]="value" color="success"></ax-knob>

<!-- Warning (yellow) -->
<ax-knob [(value)]="value" color="warning"></ax-knob>

<!-- Error (red) -->
<ax-knob [(value)]="value" color="error"></ax-knob>
```

### Custom Value Display

```typescript
@Component({
  template: `
    <!-- With percentage suffix -->
    <ax-knob [(value)]="volume" [min]="0" [max]="100" valueSuffix="%" [showValue]="true"> </ax-knob>

    <!-- With decibels -->
    <ax-knob [(value)]="audioLevel" [min]="-60" [max]="0" valueSuffix="dB" [showValue]="true"> </ax-knob>

    <!-- Custom content in center -->
    <ax-knob [(value)]="temperature" [min]="0" [max]="40" [showValue]="false">
      <div class="temp-display">
        <span class="value">{{ temperature }}°</span>
        <span class="unit">Celsius</span>
      </div>
    </ax-knob>
  `,
})
export class Component {
  volume = 75;
  audioLevel = -20;
  temperature = 22;
}
```

### Custom Arc Configuration

```typescript
<!-- Full circle (0° to 360°) -->
<ax-knob
  [(value)]="value"
  [startAngle]="0"
  [arcAngle]="360">
</ax-knob>

<!-- Half circle (bottom) -->
<ax-knob
  [(value)]="value"
  [startAngle]="-180"
  [arcAngle]="180">
</ax-knob>

<!-- Three-quarter circle -->
<ax-knob
  [(value)]="value"
  [startAngle]="-135"
  [arcAngle]="270">
</ax-knob>
```

### Step Increments

```typescript
<!-- Fine control (step = 1) -->
<ax-knob [(value)]="volume" [step]="1"></ax-knob>

<!-- Coarse control (step = 10) -->
<ax-knob [(value)]="volume" [step]="10"></ax-knob>

<!-- Decimal steps -->
<ax-knob
  [(value)]="brightness"
  [min]="0"
  [max]="1"
  [step]="0.1"
  valueSuffix="">
</ax-knob>
```

## Styling & Theming

### CSS Variables

```css
.ax-knob {
  --knob-track-color: #e5e7eb;
  --knob-track-width: 8px;

  /* Color-specific progress colors */
  --knob-primary: #3b82f6;
  --knob-accent: #8b5cf6;
  --knob-success: #10b981;
  --knob-warning: #f59e0b;
  --knob-error: #ef4444;
}
```

### Size Customization

```scss
.ax-knob {
  &--sm {
    width: 60px;
    height: 60px;
    --knob-track-width: 6px;
  }

  &--md {
    width: 80px;
    height: 80px;
    --knob-track-width: 8px;
  }

  &--lg {
    width: 100px;
    height: 100px;
    --knob-track-width: 10px;
  }

  &--xl {
    width: 140px;
    height: 140px;
    --knob-track-width: 12px;
  }
}
```

### Custom Styling

```scss
.custom-knob {
  .ax-knob__track {
    stroke: #f0f0f0;
    stroke-linecap: round;
  }

  .ax-knob__progress {
    stroke: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    stroke-linecap: round;
    filter: drop-shadow(0 0 8px rgba(102, 126, 234, 0.5));
  }

  .ax-knob__content {
    font-weight: 600;
    color: #1f2937;
  }

  &.ax-knob--dragging {
    .ax-knob__progress {
      filter: drop-shadow(0 0 12px rgba(102, 126, 234, 0.8));
    }
  }
}
```

### Gradient Progress

```scss
.gradient-knob {
  .ax-knob__svg {
    defs {
      linearGradient {
        id: 'knobGradient';
        stop {
          &[offset='0%'] {
            stop-color: #667eea;
          }
          &[offset='100%'] {
            stop-color: #764ba2;
          }
        }
      }
    }
  }

  .ax-knob__progress {
    stroke: url(#knobGradient);
  }
}
```

## Accessibility

### ARIA Attributes

```html
<div class="ax-knob" role="slider" aria-valuemin="0" aria-valuemax="100" aria-valuenow="50" aria-label="Volume control" tabindex="0">
  <svg class="ax-knob__svg" aria-hidden="true">
    <!-- Visual representation -->
  </svg>

  <div class="ax-knob__content">
    <span aria-live="polite">50</span>
  </div>
</div>
```

**ARIA Properties:**

- `role="slider"`: Identifies as a slider control
- `aria-valuemin`: Minimum value
- `aria-valuemax`: Maximum value
- `aria-valuenow`: Current value
- `aria-label`: Descriptive label
- `aria-live="polite"`: Announces value changes

### Keyboard Navigation

While the component is primarily mouse/touch-driven, keyboard support can be added:

```typescript
@Component({
  template: ` <ax-knob #knob [(value)]="volume" (keydown)="onKeyDown($event, knob)"> </ax-knob> `,
})
export class Component {
  volume = 50;

  onKeyDown(event: KeyboardEvent, knob: AxKnobComponent) {
    const step = event.shiftKey ? 10 : 1;

    switch (event.key) {
      case 'ArrowUp':
      case 'ArrowRight':
        event.preventDefault();
        knob.value = Math.min(knob.max, knob.value + step);
        break;

      case 'ArrowDown':
      case 'ArrowLeft':
        event.preventDefault();
        knob.value = Math.max(knob.min, knob.value - step);
        break;

      case 'Home':
        event.preventDefault();
        knob.value = knob.min;
        break;

      case 'End':
        event.preventDefault();
        knob.value = knob.max;
        break;
    }
  }
}
```

### Screen Reader Support

```typescript
// Announcements
'Volume control slider, 50 out of 100';
'Value changed to 60';
'Maximum value reached: 100';
'Minimum value reached: 0';
```

## Use Cases

### Audio Controls

```typescript
@Component({
  template: `
    <div class="audio-controls">
      <div class="control">
        <ax-knob [(value)]="volume" [min]="0" [max]="100" valueSuffix="%" color="primary" size="lg" (valueChange)="setVolume($event)"> </ax-knob>
        <label>Volume</label>
      </div>

      <div class="control">
        <ax-knob [(value)]="bass" [min]="-12" [max]="12" valueSuffix="dB" color="success" size="lg" (valueChange)="setBass($event)"> </ax-knob>
        <label>Bass</label>
      </div>

      <div class="control">
        <ax-knob [(value)]="treble" [min]="-12" [max]="12" valueSuffix="dB" color="success" size="lg" (valueChange)="setTreble($event)"> </ax-knob>
        <label>Treble</label>
      </div>
    </div>
  `,
})
export class AudioControlsComponent {
  volume = 75;
  bass = 0;
  treble = 0;

  setVolume(value: number) {
    this.audioService.setVolume(value / 100);
  }

  setBass(value: number) {
    this.audioService.setBass(value);
  }

  setTreble(value: number) {
    this.audioService.setTreble(value);
  }
}
```

### Dashboard Gauge

```typescript
@Component({
  template: `
    <div class="dashboard">
      <div class="gauge">
        <ax-knob [value]="cpuUsage" [min]="0" [max]="100" valueSuffix="%" [disabled]="true" [readonly]="true" [color]="cpuColor" size="xl"> </ax-knob>
        <label>CPU Usage</label>
      </div>

      <div class="gauge">
        <ax-knob [value]="memoryUsage" [min]="0" [max]="100" valueSuffix="%" [disabled]="true" [readonly]="true" [color]="memoryColor" size="xl"> </ax-knob>
        <label>Memory Usage</label>
      </div>

      <div class="gauge">
        <ax-knob [value]="diskUsage" [min]="0" [max]="100" valueSuffix="%" [disabled]="true" [readonly]="true" [color]="diskColor" size="xl"> </ax-knob>
        <label>Disk Usage</label>
      </div>
    </div>
  `,
})
export class DashboardComponent implements OnInit {
  cpuUsage = 0;
  memoryUsage = 0;
  diskUsage = 0;

  get cpuColor() {
    return this.cpuUsage > 80 ? 'error' : this.cpuUsage > 60 ? 'warning' : 'success';
  }

  get memoryColor() {
    return this.memoryUsage > 80 ? 'error' : this.memoryUsage > 60 ? 'warning' : 'success';
  }

  get diskColor() {
    return this.diskUsage > 80 ? 'error' : this.diskUsage > 60 ? 'warning' : 'success';
  }

  ngOnInit() {
    // Poll system metrics
    interval(2000).subscribe(() => {
      this.updateMetrics();
    });
  }

  updateMetrics() {
    this.monitoringService.getMetrics().subscribe((metrics) => {
      this.cpuUsage = metrics.cpu;
      this.memoryUsage = metrics.memory;
      this.diskUsage = metrics.disk;
    });
  }
}
```

### Temperature Control

```typescript
@Component({
  template: `
    <div class="thermostat">
      <ax-knob [(value)]="temperature" [min]="10" [max]="30" [step]="0.5" valueSuffix="°C" color="accent" size="xl" (valueChange)="setTemperature($event)"> </ax-knob>

      <div class="temp-info">
        <p>Target: {{ temperature }}°C</p>
        <p>Current: {{ currentTemp }}°C</p>
        <p>Status: {{ status }}</p>
      </div>
    </div>
  `,
})
export class ThermostatComponent {
  temperature = 22;
  currentTemp = 21.5;

  get status(): string {
    if (this.currentTemp < this.temperature - 0.5) return 'Heating';
    if (this.currentTemp > this.temperature + 0.5) return 'Cooling';
    return 'Idle';
  }

  setTemperature(temp: number) {
    this.hvacService.setTargetTemperature(temp).subscribe();
  }
}
```

## Touch and Mouse Interaction

### Interaction Behavior

- **Click/Tap**: Jump to clicked angle position
- **Drag**: Smoothly adjust value by dragging around the circle
- **Release**: Stop adjustment and trigger save
- **Visual Feedback**: Component shows dragging state

### Multi-Touch Support

```typescript
@Component({
  template: `
    <div class="multi-knob">
      @for (knob of knobs; track knob.id) {
        <ax-knob [(value)]="knob.value" [min]="knob.min" [max]="knob.max" [color]="knob.color" (valueChange)="onValueChange(knob.id, $event)"> </ax-knob>
      }
    </div>
  `,
})
export class MultiKnobComponent {
  knobs = [
    { id: 1, value: 50, min: 0, max: 100, color: 'primary' as const },
    { id: 2, value: 75, min: 0, max: 100, color: 'success' as const },
    { id: 3, value: 25, min: 0, max: 100, color: 'warning' as const },
  ];

  onValueChange(id: number, value: number) {
    console.log(`Knob ${id} changed to ${value}`);
  }
}
```

## Browser Compatibility

- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+
- ✅ Mobile Safari (iOS 14+) with touch support
- ✅ Chrome Mobile (Android 8+) with touch support

## Related Components

- [Popup Edit](./popup-edit.md) - Inline editing
- [Input OTP](./input-otp.md) - OTP input
- [Time Slots](./time-slots.md) - Time selection
