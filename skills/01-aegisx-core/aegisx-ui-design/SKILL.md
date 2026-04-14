---
name: aegisx-ui-design
version: 1.0.0
description: >
  AegisX UI design system — the "Clean Clinical SaaS" aesthetic used across the AegisX platform.
  Covers design tokens (Tailwind Zinc palette + Angular Material v3), typography scale, spacing,
  surface/elevation system, component anatomy (cards, forms, tables, modals, empty/error states),
  and page layout templates. Use this skill whenever building, designing, or reviewing any UI in
  AegisX: pages, components, forms, tables, modals, dashboards. Trigger on: AegisX UI, aegisx-ui,
  design tokens, color palette, typography, component styling, form layout, table design, card
  pattern, modal, empty state, page template, shadow/elevation, "style this component",
  "make it look good". Also trigger when adapting Figma/Untitled UI designs to AegisX.
  For @aegisx/ui component API, see aegisx-ui-library instead.
  For type definitions, see aegisx-ui-types.
---

# AegisX UI Design System

## Purpose

AegisX follows a **"Clean Clinical SaaS"** design language — calm, high-contrast, enterprise-grade
UI suited for hospital information systems and business operations. This skill defines the design
tokens, patterns, and composition rules that every AegisX UI component must follow.

## Attribution

The patterns in this skill are inspired by [Untitled UI](https://www.untitledui.com/) (Figma
community), but the palette, tokens, and component anatomy have been adapted for the AegisX
platform and its actual `@aegisx/ui` library shipped at `libs/aegisx-ui` in the monorepo.

## Design Inspiration References (per-surface north-star)

For picking a north-star brand for a specific surface (Linear for dashboards, Notion for docs,
Cal for modals, etc.), see `references/design-inspiration.md`. Rules:
- Pick ONE north-star per surface, not multiple
- Use as **token/pattern** reference — NEVER clone brand identity 1:1
- Update `libs/aegisx-ui/src/lib/styles/themes/_aegisx-tokens.scss` for global tokens
- Compose `@aegisx/ui` components — don't rebuild primitives

## Design Tokens

- **Gray scale** → **Tailwind Zinc** (`#fafafa` → `#09090b`)
- **Brand** → **Tailwind Indigo** (`#6366f1` / `#4f46e5`)
- **Success / Warning / Error / Info** → **Tailwind** green / amber / red / blue
- **Semantic token prefix** → `--ax-*` (e.g. `--ax-text-secondary`)

When generating code, always use Zinc/Indigo hex values and `--ax-*` tokens.
For detailed token reference, see `references/TOKEN_REFERENCE.md` and `references/THEMING_GUIDE.md`.

## AegisX UI Stack

- **Framework**: Angular 19+
- **Component lib**: Angular Material v3 (MDC-based)
- **Utility CSS**: TailwindCSS v3/v4
- **Design system**: `aegisx-platform/aegisx-ui` (standalone library, GitHub Pages docs)
- **Font**: IBM Plex Sans Thai / IBM Plex Sans (Thai-first stack, NOT Inter)

## Core Design Principles

1. **Neutral & clean** — Gray-dominant surfaces, color used sparingly for actions & status
2. **Low elevation** — Prefer subtle borders (`border-gray-200`) over heavy box shadows
3. **Dense but readable** — Clinical apps need density; use 14px base, tighter spacing
4. **Consistent hierarchy** — Type scale + color + spacing create clear visual order
5. **Accessible** — WCAG 2.1 AA minimum; check contrast on all gray-on-white combinations

## Token Architecture

**CRITICAL**: Never use raw Tailwind color classes like `text-zinc-600` directly.
Always use **semantic tokens** like `color: var(--ax-text-secondary)` (which resolves to Zinc 500
in light mode and auto-flips in dark mode). This is how `aegisx-ui` lib works internally.

AegisX uses a 3-layer token system inspired by Untitled UI:

```
┌─────────────────────────────────────┐
│  Primitive Tokens (raw values)      │  ← Zinc/Indigo 50-950 scale
│  $aegisx-zinc-500: #71717a          │
├─────────────────────────────────────┤
│  Semantic Tokens (meaning)          │  ← role-based aliases
│  --ax-text-secondary: zinc-500      │
├─────────────────────────────────────┤
│  Component Tokens (scoped)          │  ← per-component overrides
│  --ax-table-header-bg: ...          │
└─────────────────────────────────────┘
```

**Reference files (read as needed):**

- → `references/token-mapping.md` — Full color/typography/spacing/shadow token mapping with Tailwind config & Angular Material theme
- → `references/component-css.md` — Untitled UI component CSS patterns (extracted from source) mapped to Angular Material overrides: buttons, inputs, badges, tables, modals, dropdowns, tabs, toggles, checkboxes, empty states, pagination, focus rings, shadows
- → `references/aegisx-material-overrides.scss` — **Production-ready** Angular Material v3 global override file (988 lines, 20 sections). Copy to `src/styles/` and import in `angular.json`. Covers ALL Material components: buttons, form fields, cards, tables, dialogs, menus, tabs, checkbox, radio, toggle, chips, snackbar, tooltip, progress bar, autocomplete, expansion panel, bottom sheet. Includes semantic CSS custom properties (60+ tokens) for dark mode readiness.
- → `references/source-css/theme.css` — Original Untitled UI React theme CSS (from GitHub repo) with all CSS variables including dark mode inversions

## Typography System

Based on Untitled UI's type scale, adapted for clinical density:

| Role        | Untitled UI | AegisX Token          | CSS                              |
| ----------- | ----------- | --------------------- | -------------------------------- |
| Display 2xl | 72/90 -2%   | `--aegis-display-2xl` | `text-7xl tracking-tight`        |
| Display xl  | 60/72 -2%   | `--aegis-display-xl`  | `text-6xl tracking-tight`        |
| Display lg  | 48/60 -2%   | `--aegis-display-lg`  | `text-5xl tracking-tight`        |
| Display md  | 36/44 -2%   | `--aegis-display-md`  | `text-4xl tracking-tight`        |
| Display sm  | 30/38       | `--aegis-display-sm`  | `text-3xl`                       |
| Display xs  | 24/32       | `--aegis-display-xs`  | `text-2xl`                       |
| Text xl     | 20/30       | `--aegis-text-xl`     | `text-xl`                        |
| Text lg     | 18/28       | `--aegis-text-lg`     | `text-lg`                        |
| Text md     | 16/24       | `--aegis-text-md`     | `text-base`                      |
| Text sm     | 14/20       | `--aegis-text-sm`     | `text-sm` ← **AegisX body base** |
| Text xs     | 12/18       | `--aegis-text-xs`     | `text-xs`                        |

**Key difference**: AegisX uses `text-sm` (14px) as the default body size for clinical density,
while Untitled UI uses `text-md` (16px). Adjust accordingly.

### Font Weights

| Weight   | Untitled UI | AegisX Usage                        |
| -------- | ----------- | ----------------------------------- |
| Regular  | 400         | Body text, table cells              |
| Medium   | 500         | Labels, nav items, form field names |
| Semibold | 600         | Section headers, card titles        |
| Bold     | 700         | Page titles, emphasis (sparingly)   |

## Color System

Untitled UI uses 12-shade scales (25-950) per color. AegisX maps these to CSS custom properties
and extends Tailwind's color config:

### Gray scale — **Tailwind Zinc** (matches `aegisx-ui` lib)

```
50:  #fafafa  ← page background, table stripe
100: #f4f4f5  ← hover state bg, divider
200: #e4e4e7  ← borders, input outlines (--ax-border-default)
300: #d4d4d8  ← border emphasis, disabled text
400: #a1a1aa  ← subtle text, icon default (--ax-text-subtle)
500: #71717a  ← secondary text (--ax-text-secondary)
600: #52525b  ← strong secondary
700: #3f3f46  ← body text, heading mid (--ax-text-default/primary)
800: #27272a  ← strong emphasis
900: #18181b  ← near-black text (--ax-text-strong)
950: #09090b  ← darkest, heading (--ax-text-heading)
```

### Brand — **Tailwind Indigo** (matches `--ax-primary`)

```
50:  #eef2ff  ← brand-faint, surface
100: #e0e7ff
200: #c7d2fe  ← brand-muted, border
300: #a5b4fc  ← brand-light (hover)
400: #818cf8
500: #6366f1  ← brand-default, --ax-primary
600: #4f46e5  ← nav-text-active
700: #4338ca  ← brand-emphasis, --ax-primary-dark
800: #3730a3
900: #312e81
```

### Semantic Color Roles (use `--ax-*` CSS variables)

| Role    | Surface              | Primary Token          | Palette                   |
| ------- | -------------------- | ---------------------- | ------------------------- |
| Brand   | `--ax-brand-faint`   | `--ax-brand-default`   | Indigo 50 → 500/700       |
| Success | `--ax-success-faint` | `--ax-success-default` | Green (#f0fdf4 → #22c55e) |
| Error   | `--ax-error-faint`   | `--ax-error-default`   | Red (#fef2f2 → #ef4444)   |
| Warning | `--ax-warning-faint` | `--ax-warning-default` | Amber (#fffbeb → #f59e0b) |
| Info    | `--ax-info-faint`    | `--ax-info-default`    | Blue (#eff6ff → #3b82f6)  |

Full semantic token list lives in
`libs/aegisx-ui/src/lib/styles/themes/aegisx/_light.scss` — that is the source of truth.
Always prefer `--ax-*` tokens over raw hex or Tailwind classes for dark-mode readiness.

## Component Pattern Quick-Reference

### Tables (most common AegisX pattern)

Untitled UI table anatomy → AegisX Angular Material mat-table:

```
┌──────────────────────────────────────────────────────┐
│ Card Header: title + description + action buttons    │  ← Section header component
├──────────────────────────────────────────────────────┤
│ Filter bar: search + filter chips + column toggle    │  ← mat-form-field + chips
├──────────────────────────────────────────────────────┤
│ TH row: gray-50 bg, text-xs font-medium gray-500    │  ← mat-header-cell
│ TD row: text-sm gray-600, py-4 px-6                 │  ← mat-cell
│ TD row (hover): gray-50 bg                           │  ← mat-row:hover
├──────────────────────────────────────────────────────┤
│ Pagination: text-sm, button-group style              │  ← mat-paginator custom
└──────────────────────────────────────────────────────┘
```

Key CSS (use semantic tokens via `var(--ax-*)`, Zinc fallbacks shown):

- Header cell: `background: var(--ax-background-muted); color: var(--ax-text-secondary);` — `text-xs font-medium uppercase tracking-wider`
- Body cell: `color: var(--ax-text-default);` — `text-sm py-4 px-6`
- Row hover: `background: var(--ax-background-muted);` with `transition-colors`
- Border: `border-bottom: 1px solid var(--ax-border-default);` (zinc-200)

### Forms

Untitled UI form patterns → AegisX form layouts:

- **Label**: `text-sm font-medium` with `color: var(--ax-text-default)` above the field (not floating)
- **Helper text**: `text-sm` with `color: var(--ax-text-secondary)` below the field
- **Error text**: `text-sm` with `color: var(--ax-error-default)` below the field
- **Input border**: `var(--ax-border-default)` → focused: `var(--ax-primary)` + `ring-indigo-100`
- **Disabled**: `background: var(--ax-background-muted); color: var(--ax-text-disabled); border-color: var(--ax-border-subtle)`
- **Form sections**: Use the AegisX 4-layer surface system from `AEGISX-FORM-LAYOUT-SPEC.md`

### Cards

```scss
mat-card {
  border-radius: 12px;
  border: 1px solid var(--ax-border-default); /* zinc-200 */
  box-shadow: var(--ax-shadow-sm);
  /* NO heavy Material elevation — subtle border + shadow-sm only */
}
```

- Card header: `px-6 py-5 border-b` with `border-color: var(--ax-border-default)`
- Card body: `px-6 py-5`
- Card footer: `px-6 py-4` with `background: var(--ax-background-muted); border-top: 1px solid var(--ax-border-default);` + `rounded-b-xl`

### Modals / Dialogs

- Rounded corners: `rounded-xl`
- Close button: top-right, `color: var(--ax-text-subtle)` hover `var(--ax-text-secondary)`
- Header: `px-6 pt-6 pb-0`, title `text-lg font-semibold` with `color: var(--ax-text-heading)`
- Body: `px-6 py-5`
- Footer: `px-6 pb-6 flex justify-end gap-3`
- Buttons: secondary (outline) left, primary right

### Empty States

- Centered layout with featured icon (`--ax-brand-faint` circle + `--ax-brand-default` icon)
- Title: `text-md font-semibold` with `color: var(--ax-text-heading)`
- Description: `text-sm` with `color: var(--ax-text-secondary)`
- Action button below

### Badges / Status Indicators

Use Untitled UI pill badges for clinical status:

```html
<!-- Success badge — uses --ax-* semantic tokens -->
<span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium" style="background: var(--ax-success-faint); color: var(--ax-success-emphasis);"> Active </span>
```

Color mapping for clinical contexts (all via `--ax-*` tokens):

- **Active / In-stock**: `--ax-success-*` (green)
- **Pending / Processing**: `--ax-warning-*` (amber)
- **Discontinued / Expired**: `--ax-error-*` (red)
- **Draft / Inactive**: `--ax-background-muted` + `--ax-text-secondary` (zinc)
- **Info / New**: `--ax-brand-*` (indigo) or `--ax-info-*` (blue)

## Surface & Elevation System

AegisX uses a lighter elevation model than Material default:

| Level | Name     | CSS                                          | Usage                       |
| ----- | -------- | -------------------------------------------- | --------------------------- |
| 0     | Flat     | `border: 1px solid var(--ax-border-default)` | Inline sections, table rows |
| 1     | Raised   | `border + var(--ax-shadow-sm)`               | Cards, panels (default)     |
| 2     | Floating | `var(--ax-shadow-md)`                        | Dropdowns, popovers         |
| 3     | Overlay  | `var(--ax-shadow-lg)`                        | Modals, slideouts           |
| 4     | Toast    | `var(--ax-shadow-lg)` or stronger            | Notifications, toasts       |

**Untitled UI signature**: Buttons use a **skeuomorphic inner shadow** (`inset ring + bottom
inset shadow`) for a subtle 3D effect. See `references/component-css.md` for exact values.

**Override Material's default elevation** in your Angular Material theme:

```scss
// aegisx-theme.scss — suppress Material shadows, use Untitled UI style
.mat-mdc-card {
  box-shadow: none !important;
  @apply border border-gray-200 shadow-sm rounded-xl;
}
```

## Spacing

Untitled UI and Tailwind share the same 4px base grid:

| Token | px  | Tailwind | Common usage                      |
| ----- | --- | -------- | --------------------------------- |
| 1     | 4   | `p-1`    | Icon padding, tight gaps          |
| 2     | 8   | `p-2`    | Inline element gaps               |
| 3     | 12  | `p-3`    | Input padding, small card padding |
| 4     | 16  | `p-4`    | Standard card padding             |
| 5     | 20  | `p-5`    | Section padding                   |
| 6     | 24  | `p-6`    | Card body padding (Untitled std)  |
| 8     | 32  | `p-8`    | Page section gaps                 |

## Radius

| Token | px   | Tailwind       | Usage                           |
| ----- | ---- | -------------- | ------------------------------- |
| xs    | 4    | `rounded`      | Small badges, checkboxes        |
| sm    | 6    | `rounded-md`   | Buttons, inputs                 |
| md    | 8    | `rounded-lg`   | Cards, dropdowns                |
| lg    | 12   | `rounded-xl`   | Modals, large cards (preferred) |
| full  | 9999 | `rounded-full` | Avatars, pill badges            |

## Implementation Checklist

When building any AegisX UI component, verify:

- [ ] **Colors**: Using CSS vars from token system, not hardcoded hex
- [ ] **Typography**: Using IBM Plex Sans Thai, correct weight for role, `text-sm` base for clinical
- [ ] **Spacing**: 4px grid, `p-6` for card body padding
- [ ] **Borders**: `border-gray-200` for separators, not heavy shadows
- [ ] **Radius**: `rounded-xl` for cards/modals, `rounded-md` for inputs/buttons
- [ ] **Hover**: Subtle `bg-gray-50` or `bg-gray-100` transitions
- [ ] **Focus ring**: `ring-2 ring-brand-300 ring-offset-2` for accessibility
- [ ] **Status colors**: Using semantic color roles, not arbitrary colors
- [ ] **Dark mode ready**: Using CSS vars that can be swapped (future-proof)
- [ ] **Material overrides**: Heavy Material shadows/ripples suppressed

## Angular Material Theme Integration

**Quick start**: Copy `references/aegisx-material-overrides.scss` to `src/styles/` and add to `angular.json`:

```json
{
  "styles": ["src/styles/aegisx-material-overrides.scss", "src/styles.scss"]
}
```

This single file overrides ALL Material components to match Untitled UI. No per-component `::ng-deep` needed.

For custom Angular Material palette configuration:

```scss
// Override Material palette to match Untitled UI tokens
@use '@angular/material' as mat;

$aegisx-brand: mat.m3-define-theme(
  (
    color: (
      primary: mat.$blue-palette,
      // or custom palette matching brand-600
      tertiary: mat.$green-palette,
    ),
    typography: (
      plain-family: 'IBM Plex Sans Thai, IBM Plex Sans, system-ui, sans-serif',
      brand-family: 'IBM Plex Sans Thai, IBM Plex Sans, system-ui, sans-serif',
    ),
    density: -1,
    // clinical density
  )
);
```

## Dark Mode Tokens

AegisX ships a full dark theme (`[data-theme='aegisx-dark']` in
`libs/aegisx-ui/src/lib/styles/themes/aegisx/_dark.scss`). Because components use
`var(--ax-*)`, they auto-flip without code changes. Key inversions:

| Token                      | Light (Zinc)    | Dark                           |
| -------------------------- | --------------- | ------------------------------ |
| `--ax-background-page`     | `#fafafa` (50)  | `#09090b` (950)                |
| `--ax-background-default`  | `#ffffff`       | `#18181b` (900)                |
| `--ax-background-subtle`   | `#f4f4f5` (100) | `#27272a` (800)                |
| `--ax-background-muted`    | `#fafafa` (50)  | `#3f3f46` (700)                |
| `--ax-background-emphasis` | `#3f3f46` (700) | `#52525b` (600)                |
| `--ax-text-heading`        | `#09090b` (950) | `#fafafa`                      |
| `--ax-text-default`        | `#3f3f46` (700) | `#e5e5e5`                      |
| `--ax-text-secondary`      | `#71717a` (500) | `#a3a3a3`                      |
| `--ax-text-subtle`         | `#a1a1aa` (400) | `#737373`                      |
| `--ax-border-default`      | `#e4e4e7` (200) | `#3f3f46` (700)                |
| `--ax-primary`             | `#6366f1` (500) | `#818cf8` (400, softer)        |
| `--ax-success-default`     | `#22c55e` (500) | `#4ade80` (400)                |
| `--ax-error-default`       | `#ef4444` (500) | `#f87171` (400)                |
| `--ax-shadow-sm`           | 5% black        | 50% black (stronger for depth) |

**Rules for dark-mode-safe components**:

1. Never use raw hex in styles — always `var(--ax-*)`.
2. Never use Tailwind color utility classes (`bg-zinc-100`, `text-gray-600`) for
   semantic surfaces/text — they don't flip. Use inline `style` with vars or
   custom classes that reference vars.
3. Status semantics (success/warning/error/info) use _softer 400-level_ hues in
   dark mode — the tokens handle this automatically.
4. Shadows are darker/more opaque in dark mode to preserve perceived depth.
5. Brand tints use `rgba()` overlays in dark mode, not solid 50/100 fills.

## Dark Header Pattern

AegisX uses a dark navy header (from `AEGISX_UI_STANDARD.md`):

```html
<header style="background: var(--ax-background-emphasis); color: #fff;">
  <!-- or the lib's default light navigation using --ax-nav-* tokens -->
</header>
```

Note: `aegisx-ui` light theme ships a **light sidebar** by default (`--ax-nav-bg: #fff`, `--ax-nav-text: zinc-600`, active `indigo-600`). Only use the dark-header pattern when you explicitly need a dark top bar — then map to `--ax-background-emphasis` (`zinc-700` #3f3f46) rather than Untitled UI's `#101828`.
