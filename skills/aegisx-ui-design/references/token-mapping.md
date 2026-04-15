# Untitled UI → AegisX Token Mapping

> **Reality check**: AegisX adopts Untitled UI _patterns_ but uses a **Zinc + Indigo** palette
> (not Untitled UI's cool gray + blue). Source of truth for all tokens is
> `libs/aegisx-ui/src/lib/styles/themes/aegisx/_colors.scss` and `_light.scss` in the
> `aegisx-starter-1` monorepo. Semantic tokens use the `--ax-*` prefix, not `--aegis-*`.

## Table of Contents

1. [Color Primitives](#color-primitives)
2. [Semantic Color Tokens](#semantic-color-tokens)
3. [Typography Tokens](#typography-tokens)
4. [Spacing & Sizing](#spacing--sizing)
5. [Shadow / Elevation](#shadow--elevation)
6. [Radius](#radius)
7. [Tailwind Config Extension](#tailwind-config-extension)
8. [Angular Material Overrides](#angular-material-overrides)

---

## Color Primitives

### Gray — **Tailwind Zinc** (AegisX actual)

| Shade | Hex     | SCSS Var           | CSS Var         |
| ----- | ------- | ------------------ | --------------- |
| 50    | #fafafa | `$aegisx-zinc-50`  | `--ax-gray-50`  |
| 100   | #f4f4f5 | `$aegisx-zinc-100` | `--ax-gray-100` |
| 200   | #e4e4e7 | `$aegisx-zinc-200` | `--ax-gray-200` |
| 300   | #d4d4d8 | `$aegisx-zinc-300` | `--ax-gray-300` |
| 400   | #a1a1aa | `$aegisx-zinc-400` | `--ax-gray-400` |
| 500   | #71717a | `$aegisx-zinc-500` | `--ax-gray-500` |
| 600   | #52525b | `$aegisx-zinc-600` | `--ax-gray-600` |
| 700   | #3f3f46 | `$aegisx-zinc-700` | `--ax-gray-700` |
| 800   | #27272a | `$aegisx-zinc-800` | `--ax-gray-800` |
| 900   | #18181b | `$aegisx-zinc-900` | `--ax-gray-900` |
| 950   | #09090b | `$aegisx-zinc-950` | —               |

### Brand — **Tailwind Indigo** (AegisX actual)

| Shade | Hex     | SCSS Var             | Semantic Token                              |
| ----- | ------- | -------------------- | ------------------------------------------- |
| 50    | #eef2ff | `$aegisx-indigo-50`  | `--ax-brand-faint`                          |
| 100   | #e0e7ff | `$aegisx-indigo-100` |                                             |
| 200   | #c7d2fe | `$aegisx-indigo-200` | `--ax-brand-muted/border`                   |
| 300   | #a5b4fc | `$aegisx-indigo-300` | `--ax-primary-light`                        |
| 400   | #818cf8 | `$aegisx-indigo-400` |                                             |
| 500   | #6366f1 | `$aegisx-indigo-500` | `--ax-primary` / `--ax-brand-default`       |
| 600   | #4f46e5 | `$aegisx-indigo-600` | `--ax-nav-text-active`                      |
| 700   | #4338ca | `$aegisx-indigo-700` | `--ax-primary-dark` / `--ax-brand-emphasis` |
| 800   | #3730a3 | `$aegisx-indigo-800` |                                             |
| 900   | #312e81 | `$aegisx-indigo-900` |                                             |

### Success / Warning / Error / Info

AegisX uses standard **Tailwind** palettes (full 50-900 scales in `_colors.scss`):

| Role    | Palette        | 500 hex   | Semantic token         |
| ------- | -------------- | --------- | ---------------------- |
| Success | Tailwind Green | `#22c55e` | `--ax-success-default` |
| Error   | Tailwind Red   | `#ef4444` | `--ax-error-default`   |
| Warning | Tailwind Amber | `#f59e0b` | `--ax-warning-default` |
| Info    | Tailwind Blue  | `#3b82f6` | `--ax-info-default`    |

Each has `-faint` (50), `-muted` (200), `-default` (500), `-emphasis` (700), `-surface` (50),
`-border` (200) semantic variants. See `_light.scss` for the complete list.
| 900 | #00359E | `--aegis-brand-900` | `bg-brand-900` |
| 950 | #002266 | `--aegis-brand-950` | `bg-brand-950` |

### Error (Red)

| Shade | Hex     | CSS Variable        |
| ----- | ------- | ------------------- |
| 25    | #FFFBFA | `--aegis-error-25`  |
| 50    | #FEF3F2 | `--aegis-error-50`  |
| 100   | #FEE4E2 | `--aegis-error-100` |
| 200   | #FECDCA | `--aegis-error-200` |
| 300   | #FDA29B | `--aegis-error-300` |
| 400   | #F97066 | `--aegis-error-400` |
| 500   | #F04438 | `--aegis-error-500` |
| 600   | #D92D20 | `--aegis-error-600` |
| 700   | #B42318 | `--aegis-error-700` |
| 800   | #912018 | `--aegis-error-800` |
| 900   | #7A271A | `--aegis-error-900` |
| 950   | #55160C | `--aegis-error-950` |

### Warning (Amber/Orange)

| Shade | Hex     | CSS Variable          |
| ----- | ------- | --------------------- |
| 25    | #FFFCF5 | `--aegis-warning-25`  |
| 50    | #FFFAEB | `--aegis-warning-50`  |
| 100   | #FEF0C7 | `--aegis-warning-100` |
| 200   | #FEDF89 | `--aegis-warning-200` |
| 300   | #FEC84B | `--aegis-warning-300` |
| 400   | #FDB022 | `--aegis-warning-400` |
| 500   | #F79009 | `--aegis-warning-500` |
| 600   | #DC6803 | `--aegis-warning-600` |
| 700   | #B54708 | `--aegis-warning-700` |
| 800   | #93370D | `--aegis-warning-800` |
| 900   | #7A2E0E | `--aegis-warning-900` |
| 950   | #4E1D09 | `--aegis-warning-950` |

### Success (Green)

| Shade | Hex     | CSS Variable          |
| ----- | ------- | --------------------- |
| 25    | #F6FEF9 | `--aegis-success-25`  |
| 50    | #ECFDF3 | `--aegis-success-50`  |
| 100   | #D1FADF | `--aegis-success-100` |
| 200   | #A6F4C5 | `--aegis-success-200` |
| 300   | #6CE9A6 | `--aegis-success-300` |
| 400   | #32D583 | `--aegis-success-400` |
| 500   | #12B76A | `--aegis-success-500` |
| 600   | #039855 | `--aegis-success-600` |
| 700   | #027A48 | `--aegis-success-700` |
| 800   | #05603A | `--aegis-success-800` |
| 900   | #054F31 | `--aegis-success-900` |
| 950   | #053321 | `--aegis-success-950` |

---

## Semantic Color Tokens

These map primitive tokens to functional roles:

```css
:root {
  /* ── Background ── */
  --aegis-bg-primary: var(--aegis-white); /* main page bg */
  --aegis-bg-primary-alt: var(--aegis-gray-25); /* alternate page bg */
  --aegis-bg-secondary: var(--aegis-gray-50); /* card bg, table stripe */
  --aegis-bg-secondary-hover: var(--aegis-gray-100); /* hover on secondary */
  --aegis-bg-tertiary: var(--aegis-gray-100); /* nested section bg */
  --aegis-bg-active: var(--aegis-brand-50); /* selected row, active tab */
  --aegis-bg-disabled: var(--aegis-gray-50); /* disabled input bg */

  /* ── Text ── */
  --aegis-text-primary: var(--aegis-gray-900); /* headings, strong text */
  --aegis-text-secondary: var(--aegis-gray-600); /* body text default */
  --aegis-text-tertiary: var(--aegis-gray-500); /* helper text, captions */
  --aegis-text-placeholder: var(--aegis-gray-400); /* input placeholder */
  --aegis-text-disabled: var(--aegis-gray-300); /* disabled text */
  --aegis-text-brand: var(--aegis-brand-600); /* links, brand accent */
  --aegis-text-error: var(--aegis-error-600); /* error messages */
  --aegis-text-success: var(--aegis-success-600); /* success messages */
  --aegis-text-warning: var(--aegis-warning-600); /* warning messages */
  --aegis-text-on-brand: var(--aegis-white); /* text on brand bg */

  /* ── Border ── */
  --aegis-border-primary: var(--aegis-gray-200); /* card borders, dividers */
  --aegis-border-secondary: var(--aegis-gray-300); /* input borders */
  --aegis-border-disabled: var(--aegis-gray-200); /* disabled borders */
  --aegis-border-brand: var(--aegis-brand-300); /* focused input ring */
  --aegis-border-error: var(--aegis-error-300); /* error input border */

  /* ── Icon ── */
  --aegis-icon-primary: var(--aegis-gray-500); /* default icons */
  --aegis-icon-secondary: var(--aegis-gray-400); /* muted icons */
  --aegis-icon-brand: var(--aegis-brand-600); /* action icons */
  --aegis-icon-error: var(--aegis-error-600);
  --aegis-icon-success: var(--aegis-success-600);
  --aegis-icon-warning: var(--aegis-warning-600);

  /* ── Focus ring ── */
  --aegis-ring-brand: var(--aegis-brand-100); /* ring-offset around focused inputs */
  --aegis-ring-error: var(--aegis-error-100);
}
```

---

## Typography Tokens

### CSS Custom Properties

```css
:root {
  /* Font family */
  --aegis-font-family: 'IBM Plex Sans Thai', 'IBM Plex Sans', -apple-system, BlinkMacSystemFont, sans-serif;

  /* Display (marketing/page titles — tighter letter-spacing) */
  --aegis-display-2xl: 600 72px/90px var(--aegis-font-family); /* letter-spacing: -2% */
  --aegis-display-xl: 600 60px/72px var(--aegis-font-family);
  --aegis-display-lg: 600 48px/60px var(--aegis-font-family);
  --aegis-display-md: 600 36px/44px var(--aegis-font-family);
  --aegis-display-sm: 600 30px/38px var(--aegis-font-family);
  --aegis-display-xs: 600 24px/32px var(--aegis-font-family);

  /* Text (UI content) */
  --aegis-text-xl: 400 20px/30px var(--aegis-font-family);
  --aegis-text-lg: 400 18px/28px var(--aegis-font-family);
  --aegis-text-md: 400 16px/24px var(--aegis-font-family);
  --aegis-text-sm: 400 14px/20px var(--aegis-font-family); /* ← AegisX body base */
  --aegis-text-xs: 400 12px/18px var(--aegis-font-family);
}
```

### Mapping to Angular Material Typography

```scss
@use '@angular/material' as mat;

// Override Material typography levels to match Untitled UI
$aegisx-typography: mat.m3-define-typography(
  (
    plain-family: 'IBM Plex Sans Thai, IBM Plex Sans, -apple-system, sans-serif',
    brand-family: 'IBM Plex Sans Thai, IBM Plex Sans, -apple-system, sans-serif',
  )
);

// Additional overrides via CSS
.mat-headline-large {
  font: var(--aegis-display-sm);
} // 30/38
.mat-headline-medium {
  font: var(--aegis-display-xs);
} // 24/32
.mat-headline-small {
  font: var(--aegis-text-xl);
} // 20/30
.mat-title-large {
  font: var(--aegis-text-lg);
} // 18/28
.mat-title-medium {
  font: var(--aegis-text-md);
} // 16/24
.mat-body-large {
  font: var(--aegis-text-md);
} // 16/24
.mat-body-medium {
  font: var(--aegis-text-sm);
} // 14/20
.mat-body-small {
  font: var(--aegis-text-xs);
} // 12/18
.mat-label-large {
  font: 500 14px/20px var(--aegis-font-family);
}
.mat-label-medium {
  font: 500 12px/18px var(--aegis-font-family);
}
```

---

## Spacing & Sizing

| Untitled UI | px  | rem   | Tailwind | CSS Variable        |
| ----------- | --- | ----- | -------- | ------------------- |
| none        | 0   | 0     | `0`      | `--aegis-space-0`   |
| xxs         | 2   | 0.125 | `0.5`    | `--aegis-space-0.5` |
| xs          | 4   | 0.25  | `1`      | `--aegis-space-1`   |
| sm          | 8   | 0.5   | `2`      | `--aegis-space-2`   |
| md          | 12  | 0.75  | `3`      | `--aegis-space-3`   |
| lg          | 16  | 1     | `4`      | `--aegis-space-4`   |
| xl          | 20  | 1.25  | `5`      | `--aegis-space-5`   |
| 2xl         | 24  | 1.5   | `6`      | `--aegis-space-6`   |
| 3xl         | 32  | 2     | `8`      | `--aegis-space-8`   |
| 4xl         | 40  | 2.5   | `10`     | `--aegis-space-10`  |
| 5xl         | 48  | 3     | `12`     | `--aegis-space-12`  |
| 6xl         | 64  | 4     | `16`     | `--aegis-space-16`  |

---

## Shadow / Elevation

Untitled UI shadows → Tailwind utility classes:

| Untitled UI | CSS                                                                        | Tailwind     | AegisX Usage    |
| ----------- | -------------------------------------------------------------------------- | ------------ | --------------- |
| shadow-xs   | `0 1px 2px 0 rgba(16,24,40,0.05)`                                          | `shadow-xs`  | Buttons         |
| shadow-sm   | `0 1px 3px 0 rgba(16,24,40,0.1), 0 1px 2px 0 rgba(16,24,40,0.06)`          | `shadow-sm`  | Cards (default) |
| shadow-md   | `0 4px 8px -2px rgba(16,24,40,0.1), 0 2px 4px -2px rgba(16,24,40,0.06)`    | `shadow-md`  | Dropdowns       |
| shadow-lg   | `0 12px 16px -4px rgba(16,24,40,0.08), 0 4px 6px -2px rgba(16,24,40,0.03)` | `shadow-lg`  | Modals          |
| shadow-xl   | `0 20px 24px -4px rgba(16,24,40,0.08), 0 8px 8px -4px rgba(16,24,40,0.03)` | `shadow-xl`  | Toasts          |
| shadow-2xl  | `0 24px 48px -12px rgba(16,24,40,0.18)`                                    | `shadow-2xl` | Rarely used     |

Note: Untitled UI shadow colors use `rgba(16,24,40,...)` which is gray-900. This gives a cooler
shadow tone vs the warm brown shadows of default Tailwind.

### Custom Tailwind Shadow Config (optional)

```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      boxShadow: {
        xs: '0 1px 2px 0 rgba(16, 24, 40, 0.05)',
        sm: '0 1px 3px 0 rgba(16, 24, 40, 0.1), 0 1px 2px 0 rgba(16, 24, 40, 0.06)',
        md: '0 4px 8px -2px rgba(16, 24, 40, 0.1), 0 2px 4px -2px rgba(16, 24, 40, 0.06)',
        lg: '0 12px 16px -4px rgba(16, 24, 40, 0.08), 0 4px 6px -2px rgba(16, 24, 40, 0.03)',
        xl: '0 20px 24px -4px rgba(16, 24, 40, 0.08), 0 8px 8px -4px rgba(16, 24, 40, 0.03)',
        '2xl': '0 24px 48px -12px rgba(16, 24, 40, 0.18)',
      },
    },
  },
};
```

---

## Radius

| Untitled UI | px   | CSS Variable          | Tailwind         |
| ----------- | ---- | --------------------- | ---------------- |
| none        | 0    | `--aegis-radius-none` | `rounded-none`   |
| xxs         | 2    | `--aegis-radius-xxs`  | `rounded-sm`     |
| xs          | 4    | `--aegis-radius-xs`   | `rounded`        |
| sm          | 6    | `--aegis-radius-sm`   | `rounded-md`     |
| md          | 8    | `--aegis-radius-md`   | `rounded-lg`     |
| lg          | 10   | `--aegis-radius-lg`   | `rounded-[10px]` |
| xl          | 12   | `--aegis-radius-xl`   | `rounded-xl`     |
| 2xl         | 16   | `--aegis-radius-2xl`  | `rounded-2xl`    |
| 3xl         | 20   | `--aegis-radius-3xl`  | `rounded-[20px]` |
| 4xl         | 24   | `--aegis-radius-4xl`  | `rounded-3xl`    |
| full        | 9999 | `--aegis-radius-full` | `rounded-full`   |

---

## Tailwind Config Extension

Complete Tailwind config to match Untitled UI tokens:

```js
// tailwind.config.js
const colors = require('tailwindcss/colors');

module.exports = {
  theme: {
    extend: {
      colors: {
        gray: {
          25: '#FCFCFD',
          50: '#F9FAFB',
          100: '#F2F4F7',
          200: '#E4E7EC',
          300: '#D0D5DD',
          400: '#98A2B3',
          500: '#667085',
          600: '#475467',
          700: '#344054',
          800: '#182230',
          900: '#101828',
          950: '#0C111D',
        },
        brand: {
          25: '#F5F8FF',
          50: '#EFF4FF',
          100: '#D1E0FF',
          200: '#B2CCFF',
          300: '#84ADFF',
          400: '#528BFF',
          500: '#2970FF',
          600: '#155EEF',
          700: '#004EEB',
          800: '#0040C1',
          900: '#00359E',
          950: '#002266',
        },
        error: {
          25: '#FFFBFA',
          50: '#FEF3F2',
          100: '#FEE4E2',
          200: '#FECDCA',
          300: '#FDA29B',
          400: '#F97066',
          500: '#F04438',
          600: '#D92D20',
          700: '#B42318',
          800: '#912018',
          900: '#7A271A',
          950: '#55160C',
        },
        warning: {
          25: '#FFFCF5',
          50: '#FFFAEB',
          100: '#FEF0C7',
          200: '#FEDF89',
          300: '#FEC84B',
          400: '#FDB022',
          500: '#F79009',
          600: '#DC6803',
          700: '#B54708',
          800: '#93370D',
          900: '#7A2E0E',
          950: '#4E1D09',
        },
        success: {
          25: '#F6FEF9',
          50: '#ECFDF3',
          100: '#D1FADF',
          200: '#A6F4C5',
          300: '#6CE9A6',
          400: '#32D583',
          500: '#12B76A',
          600: '#039855',
          700: '#027A48',
          800: '#05603A',
          900: '#054F31',
          950: '#053321',
        },
      },
      fontFamily: {
        sans: ['IBM Plex Sans Thai', 'IBM Plex Sans', '-apple-system', 'BlinkMacSystemFont', 'sans-serif'],
      },
      fontSize: {
        'display-2xl': ['72px', { lineHeight: '90px', letterSpacing: '-0.02em', fontWeight: '600' }],
        'display-xl': ['60px', { lineHeight: '72px', letterSpacing: '-0.02em', fontWeight: '600' }],
        'display-lg': ['48px', { lineHeight: '60px', letterSpacing: '-0.02em', fontWeight: '600' }],
        'display-md': ['36px', { lineHeight: '44px', letterSpacing: '-0.02em', fontWeight: '600' }],
        'display-sm': ['30px', { lineHeight: '38px', fontWeight: '600' }],
        'display-xs': ['24px', { lineHeight: '32px', fontWeight: '600' }],
      },
    },
  },
};
```

---

## Angular Material Overrides

Key Material component overrides to align with Untitled UI aesthetic:

```scss
// styles/material-overrides.scss

// ── Cards ──
.mat-mdc-card {
  box-shadow: none !important;
  border: 1px solid var(--aegis-gray-200);
  border-radius: 12px;
  &:hover {
    box-shadow:
      0 1px 3px 0 rgba(16, 24, 40, 0.1),
      0 1px 2px 0 rgba(16, 24, 40, 0.06);
  }
}

// ── Buttons ──
.mat-mdc-button,
.mat-mdc-raised-button,
.mat-mdc-outlined-button {
  border-radius: 8px;
  font-weight: 600;
  font-size: 14px;
  line-height: 20px;
  letter-spacing: normal; // Material adds letter-spacing we don't want
}

// ── Form Fields ──
.mat-mdc-form-field {
  .mdc-text-field--outlined .mdc-notched-outline__leading,
  .mdc-text-field--outlined .mdc-notched-outline__trailing {
    border-color: var(--aegis-gray-300);
    border-radius: 8px;
  }
  &.mat-focused .mdc-notched-outline__leading,
  &.mat-focused .mdc-notched-outline__trailing {
    border-color: var(--aegis-brand-300) !important;
    box-shadow: 0 0 0 4px var(--aegis-brand-100);
  }
}

// ── Tables ──
.mat-mdc-header-row {
  background-color: var(--aegis-gray-50);
}
.mat-mdc-header-cell {
  color: var(--aegis-gray-500);
  font-size: 12px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
.mat-mdc-row:hover {
  background-color: var(--aegis-gray-50);
}
.mat-mdc-cell {
  color: var(--aegis-gray-600);
  font-size: 14px;
  border-bottom-color: var(--aegis-gray-200);
}

// ── Dialogs ──
.mat-mdc-dialog-container .mdc-dialog__surface {
  border-radius: 12px !important;
}

// ── Tabs ──
.mat-mdc-tab {
  font-size: 14px;
  font-weight: 500;
  letter-spacing: normal;
}

// ── Snack bar ──
.mat-mdc-snack-bar-container {
  border-radius: 12px;
}

// ── Chips ──
.mat-mdc-chip {
  border-radius: 9999px;
  font-size: 12px;
  font-weight: 500;
}

// ── Suppress Material ripple for cleaner feel ──
.mat-mdc-button .mat-mdc-button-ripple,
.mat-mdc-icon-button .mat-mdc-button-ripple {
  display: none;
}
```

---

## Clinical-Specific Color Usage

Quick reference for drug/pharmacy inventory context:

| Status           | Badge Color | Icon Color  | Background |
| ---------------- | ----------- | ----------- | ---------- |
| In Stock         | success-700 | success-600 | success-50 |
| Low Stock        | warning-700 | warning-600 | warning-50 |
| Out of Stock     | error-700   | error-600   | error-50   |
| Expired          | error-700   | error-600   | error-50   |
| Expiring Soon    | warning-700 | warning-600 | warning-50 |
| Active           | success-700 | success-600 | success-50 |
| Inactive         | gray-700    | gray-500    | gray-50    |
| Draft            | gray-700    | gray-400    | gray-50    |
| Pending Approval | warning-700 | warning-600 | warning-50 |
| Approved         | success-700 | success-600 | success-50 |
| Rejected         | error-700   | error-600   | error-50   |
| Locked           | gray-700    | gray-500    | gray-100   |
