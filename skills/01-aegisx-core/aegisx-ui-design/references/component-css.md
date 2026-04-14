# Untitled UI Complete Component CSS Reference → AegisX

> Extracted from `untitleduico/react` GitHub source (Tailwind CSS v4 + React Aria).
> **47 sections — ALL components from untitledui.com/react/components**

---

## 1. Semantic Token System

Components use semantic classes → CSS vars → raw colors. See token-mapping.md for full list.

Key pattern: `text-primary` → `--color-text-primary` → `neutral-900` (light) / `neutral-50` (dark)

---

## 2. Featured Icons

```
THEMES: light | gradient | dark | modern

LIGHT (most used):
  base: rounded-full
  sizes: sm=size-8 md=size-10 lg=size-12 xl=size-14
  brand:   bg-brand-secondary text-brand-600
  gray:    bg-tertiary text-neutral-500
  error:   bg-error-secondary text-red-600
  warning: bg-warning-secondary text-yellow-600
  success: bg-success-secondary text-green-600

MODERN (card header icons):
  bg-primary shadow-xs-skeuomorphic ring-1 ring-primary ring-inset
  sm=rounded-md md=rounded-lg lg=rounded-[10px] xl=rounded-xl

DARK (solid fill):
  text-white shadow-xs-skeuomorphic + inner white border gradient
  bg-brand-solid / bg-error-solid / bg-success-solid etc.

GRADIENT:
  outer ring: border-utility-{color}-200 bg-utility-{color}-50
  inner circle: bg-{color}-solid (brand/error/success etc.)
  icon: text-white
```

---

## 3. Rating Stars & Badge

```
Star:     size-5 text-yellow-400 (filled via clipPath) / bg-tertiary (empty)
Badge:    flex items-center wreath + stars + title/subtitle
Title:    text-sm font-semibold text-primary
Subtitle: text-xs font-medium text-secondary
```

---

## 4. Buttons

```
COMMON BASE:
  inline-flex items-center justify-center whitespace-nowrap rounded-lg
  font-semibold transition duration-100 ease-linear
  focus-visible:outline-2 focus-visible:outline-offset-2
  disabled:cursor-not-allowed disabled:opacity-50
  icon: size-5 shrink-0 pointer-events-none

SIZES:
  xs: gap-1   px-2.5 py-1.5 text-sm  icon-only:p-2    icon:size-4 stroke-[2.25px]
  sm: gap-1   px-3   py-2   text-sm  icon-only:p-2
  md: gap-1   px-3.5 py-2.5 text-sm  icon-only:p-2.5
  lg: gap-1.5 px-4   py-2.5 text-md  icon-only:p-3
  xl: gap-1.5 px-4.5 py-3   text-md  icon-only:p-3.5

COLORS:
  primary:            bg-brand-solid text-white shadow-xs-skeuomorphic
                      ::before inset-px border-white/12 mask-b-from-0% (gradient shine)
                      hover:bg-brand-solid_hover  icon:text-white/60→70
  secondary:          bg-primary text-secondary shadow-xs-skeuomorphic ring-1 ring-primary
                      hover:bg-primary_hover text-secondary_hover  icon:fg-quaternary→hover
  tertiary:           text-tertiary no-bg no-shadow
                      hover:bg-primary_hover text-tertiary_hover
  link-color:         p-0! text-brand-secondary underline-transparent
                      hover:text-brand-secondary_hover decoration-fg-brand-secondary_alt
  link-gray:          p-0! text-tertiary underline-transparent
                      hover:text-tertiary_hover decoration-fg-quaternary
  primary-destructive:  bg-error-solid text-white shadow-xs-skeuomorphic outline-error
  secondary-destructive: bg-primary text-error-primary ring-1 ring-error_subtle outline-error
  tertiary-destructive:  text-error-primary hover:bg-error-primary
  link-destructive:      p-0! text-error-primary hover:text-error-primary_hover

LOADING STATE:
  data-loading pointer-events-none
  spinner: SVG animate-spin size-5 stroke-current
  text hidden (or visible with showTextWhileLoading)
```

---

## 5. Button Groups

```
Container: inline-flex -space-x-px rounded-lg shadow-xs
Item:      secondary button pattern with:
  first-child: rounded-l-lg rounded-r-none
  last-child:  rounded-r-lg rounded-l-none
  middle:      rounded-none
  Sizes: xs/sm/md/lg/xl same as buttons
  Icon: size-4(xs/sm) size-5(md+)
```

---

## 6. Utility Buttons & Close Button

```
UTILITY (icon-only actions):
  rounded-lg transition duration-100
  sm: p-2  md: p-2.5  lg: p-3
  colors: same primary/secondary/tertiary/destructive as buttons

CLOSE BUTTON:
  sm: size-9  md: size-10  lg: size-11
  rounded-lg flex items-center justify-center
  light: text-fg-quaternary hover:text-fg-quaternary_hover hover:bg-primary_hover
  dark:  text-white/70 hover:text-white hover:bg-white/10
```

---

## 7. Inputs

```
WRAPPER:
  relative flex w-full rounded-lg bg-primary shadow-xs
  ring-1 ring-primary ring-inset transition-shadow duration-100

STATES:
  focus:    ring-2 ring-brand
  invalid:  ring-error_subtle → focus: ring-2 ring-error
  disabled: cursor-not-allowed opacity-50

SIZES:
  sm: px-3 py-2 text-sm       leading-icon:left-3 size-4 stroke-[2.25px]
  md: px-3 py-2 text-md       leading-icon:left-3 size-5
  lg: px-3.5 py-2.5 text-md   leading-icon:left-3.5 size-5

LABEL:   text-sm font-medium text-secondary (above)
HINT:    text-sm text-tertiary (below)
ERROR:   text-sm text-error-primary (below, replaces hint)
TOOLTIP: HelpCircle icon → tooltip on hover

VARIANTS: input-tags, input-number(+/−), input-payment(card icon),
          input-date(calendar icon), input-file, pin-input(verification 6-box)
```

---

## 8. Textarea

```
Same wrapper/states/sizes as Input
min-height controlled by rows attribute
resize: vertical (optional)
```

---

## 9. Select & Multi-Select

```
TRIGGER: same visual as Input wrapper
  text-primary(selected) / text-placeholder(empty)
  trailing: chevron-down size-4/5 text-fg-quaternary

POPOVER:
  rounded-xl bg-primary shadow-xl ring-1 ring-secondary_alt p-1.5

ITEM:
  flex items-center gap-2 px-2 py-2.5 rounded-md text-sm text-secondary
  hover: bg-primary_hover  selected: bg-active font-medium
  with avatar/icon/check/supporting-text

MULTI-SELECT:
  selected as tag pills inside trigger
  tag: rounded-md bg-secondary ring-1 ring-secondary text-xs font-medium
```

---

## 10. Checkbox

```
size-4 rounded-md border border-primary bg-primary
checked: bg-brand-solid border-brand-solid (white check icon)
focus:   ring-4 ring-brand-100
indeterminate: bg-brand-solid (minus icon)
disabled: opacity-50

Label: text-sm font-medium text-secondary ml-3
Hint:  text-sm text-tertiary (below label, same indent)

CARD VARIANT:
  border border-secondary rounded-xl p-4
  selected: ring-2 ring-brand border-brand bg-brand-primary
```

---

## 11. Radio Buttons

```
size-4 rounded-full border border-primary
selected: border-brand-solid + inner dot size-1.5 bg-brand-solid
focus: ring-4 ring-brand-100
Label/Hint/Card: same as checkbox
```

---

## 12. Toggle / Switch

```
DEFAULT sizes:
  sm: track=h-5 w-9 p-0.5   thumb=size-4 translate-x-4(on)
  md: track=h-6 w-11 p-0.5  thumb=size-5 translate-x-5(on)
SLIM sizes:
  sm: track=h-4 w-8          thumb=size-4 translate-x-4(on)
  md: track=h-5 w-10         thumb=size-5 translate-x-5(on)

Track:  rounded-full bg-tertiary ring-[0.5px] ring-secondary ring-inset transition-150
  on:   bg-brand-solid  slim+on border: bg-brand-solid
Thumb:  rounded-full bg-white shadow-sm

Label: text-sm/md font-medium text-secondary
Hint:  text-sm/md text-tertiary
```

---

## 13. Slider

```
Container: h-6 w-full (touch target)
Track:     h-2 rounded-full bg-quaternary
Fill:      h-2 rounded-full bg-brand-solid
Thumb:     size-6 rounded-full bg-white shadow-md border-2 border-brand-solid
           cursor-grab → pressed:cursor-grabbing pressed:shadow-xl
           focus: ring-4 ring-brand-100

Label positions:
  hidden:       display-none
  bottom:       absolute text-md font-medium text-primary
  top-floating: absolute tooltip: rounded-lg bg-primary px-2 py-1.5
                text-xs font-semibold text-secondary shadow-lg ring-1 ring-secondary_alt
```

---

## 14. Avatars

```
SIZES: xs=size-6 sm=size-8 md=size-10 lg=size-12 xl=size-14 2xl=size-16
BASE: rounded-full overflow-hidden bg-tertiary
  image:    img object-cover size-full
  initials: text-quaternary font-semibold (xs→text-xs ... 2xl→text-display-xs)
  icon:     text-fg-quaternary (size-4→size-8 by size)

STATUS: absolute right-0 bottom-0 rounded-full bg-success-500 ring-[1.5px] ring-white
GROUPS: flex -space-x-1.5(xs)/-space-x-2(sm+) each ring-[1.5px] ring-white
LABEL GROUP: flex items-center gap-3 + name(font-semibold) + subtitle(text-tertiary)
```

---

## 15. Badges

```
BASE: inline-flex items-center whitespace-nowrap rounded-full ring-1 ring-inset
SIZES:
  sm: gap-1 px-2 py-0.5 text-xs font-medium     dot:size-1.5 icon:size-3
  md: gap-1 px-2.5 py-0.5 text-sm font-medium    dot:size-1.5 icon:size-3.5
  lg: gap-1.5 px-3 py-1 text-sm font-medium       dot:size-2 icon:size-4

12 COLORS (each has bg + text + ring):
  gray/brand/error/warning/success/blue/indigo/purple/pink/orange/sky/slate
  Pattern: bg-utility-{color}-50 text-utility-{color}-700 ring-utility-{color}-200

TYPES: pillColor, pillOutline, badge, modern(with dot indicator)
```

---

## 16. Badge Groups

```
Container: inline-flex items-center gap-1 rounded-full
Inner badge: bg-utility-{color}-50 px-1 py-0.5 rounded-full text-xs
Outer text: text-sm font-medium text-utility-{color}-700
```

---

## 17. Tags

```
BASE: inline-flex items-center rounded-md border border-secondary
sm: gap-0.5 h-5 px-1 text-xs
md: gap-1 h-6 px-1.5 text-xs
lg: gap-1 h-7 px-1.5 text-sm

With avatar/count/close-x/online-dot
```

---

## 18. Dropdowns

```
POPOVER: rounded-xl bg-primary shadow-lg ring-1 ring-secondary p-1.5
ITEM: flex items-center gap-2 rounded-md px-2.5 py-2 text-sm text-secondary
      hover:bg-primary_hover  icon:size-4 text-fg-quaternary
      shortcut:ml-auto text-xs text-tertiary
SEPARATOR: h-px bg-border-secondary my-1
SECTION LABEL: px-2.5 py-1.5 text-xs font-medium text-tertiary
SEARCH: top input border-b border-secondary
ACCOUNT: avatar + name + email variants (xs/sm/md)
```

---

## 19. Tooltips

```
rounded-lg bg-bg-primary-solid(neutral-950) px-3 py-2 shadow-lg max-w-320px
Title: text-xs font-semibold text-white
Desc:  text-xs font-medium text-tooltip-supporting-text(neutral-300)
Arrow: size-2.5 fill-bg-primary-solid (rotates per placement)
```

---

## 20. Progress Indicators

```
BAR: track=h-2 rounded-md bg-quaternary  fill=bg-fg-brand-primary transition-75
  labels: text-sm font-medium text-secondary tabular-nums
  floating: tooltip bubble rounded-lg shadow-lg
CIRCLE: SVG stroke-width=3  bg=bg-tertiary  fill=fg-brand-primary
  center text: text-sm font-semibold text-secondary
```

---

## 21. File Upload Trigger

```
rounded-xl border border-dashed border-secondary p-6 text-center
hover: border-brand bg-brand-primary/5
drag-over: border-brand bg-brand-primary
Icon: featured-icon modern
Text: "Click to upload" font-semibold text-brand-secondary
File item: flex gap-3 rounded-lg border border-secondary p-3
```

---

## 22. Tables

```
CARD: overflow-hidden rounded-xl bg-primary shadow-xs ring-1 ring-secondary
HEADER: border-b border-secondary px-5/6 py-4/5
  title: text-md font-semibold text-primary  badge: Badge
TH: text-xs font-medium text-tertiary px-4/5 py-2/3
TD: text-sm text-tertiary px-4/5 py-2/3
ROW: border-b border-secondary  hover:bg-primary_hover  selected:bg-active
FOOTER: border-t border-secondary px-4 py-3
```

---

## 23. Tabs

```
6 TYPES: button-brand/button-gray/button-border/button-minimal/underline/line
SIZES: sm(text-sm py-2 px-2.5) md(text-md py-2.5 px-2.5)
button-border container: rounded-[10px] bg-secondary_alt p-1 ring-1 ring-secondary
underline: border-b-2 selected:border-fg-brand-primary_alt text-brand-secondary
```

---

## 24. Modals / Dialogs

```
Overlay:   bg-overlay/70  Container: rounded-xl shadow-xl ring-1 ring-secondary
Header:    px-6 pt-6   title:text-lg font-semibold  desc:text-sm text-tertiary
Body:      px-6 py-5   Footer: flex justify-end gap-3 px-6 pb-6
Close:     absolute top-4 right-4 CloseButton
```

---

## 25. Slideout Menus / Drawers

```
fixed right-0 top-0 h-full max-w-md bg-primary shadow-xl
Header: px-4/6 pt-6  close:absolute top-3 right-3
Body: flex flex-col gap-6 overflow-y-auto px-4/6
Footer: p-4/6 shadow-[inset_0_1px_0] shadow-border-secondary
```

---

## 26. Sidebar Navigation

```
w-240px border-r border-secondary bg-primary
Logo: px-4 py-5  Nav: flex flex-col gap-0.5 px-3
Item: p-2 rounded-md text-sm font-medium text-tertiary icon:fg-quaternary
  hover: bg-primary_hover  active: bg-active font-semibold
Section label: text-xs font-medium text-quaternary uppercase
Account: border-t p-4 avatar+name+subtitle
```

---

## 27. Header Navigation

```
h-16 bg-primary max-w-container px-8 flex items-center
Logo: h-6  Nav: flex gap-0.5  text-sm font-semibold text-tertiary
active: text-brand-secondary  Notification dot: size-3.5 bg-fg-error-primary
```

---

## 28. Pagination

```
flex justify-between border-t border-secondary pt-4
Text: text-sm text-fg-secondary  page:font-medium
Page items: size-9 rounded-md  active:bg-active font-medium
Prev/Next: Button secondary sm with arrow
```

---

## 29. Empty States

```
max-w-lg flex flex-col items-center text-center
Icon: featured-icon in gradient circle OR avatar cluster
Decorative rings: concentric border-secondary circles
Title: text-md font-semibold text-primary mt-4
Desc: text-sm text-tertiary  Actions: flex gap-3 mt-6
```

---

## 30. Date Picker / Calendar

```
Popover: rounded-2xl shadow-xl ring ring-secondary_alt
Header: month/year text-sm font-semibold + nav arrows
Day: size-10 rounded-full  selected:bg-brand-solid text-white
today:font-semibold  range:bg-brand-primary  disabled:text-disabled
Footer: grid-cols-2 gap-3 border-t p-4 (Cancel+Apply)
```

---

## 31. File Upload (Drag & Drop)

```
rounded-xl border-2 border-dashed border-secondary p-10 text-center
drag-active: border-brand bg-brand-primary ring-4 ring-brand-100
File list: flex flex-col gap-3 (items with progress bar + remove button)
```

---

## 32. Loading Indicators

```
Types: line-simple(circle) / line-spinner(lines) / dot-circle(dots)
Sizes: sm=size-8 md=size-12 lg=size-14 xl=size-16
SVG: animate-spin stroke-fg-brand-primary bg-ring:stroke-bg-tertiary
Label: font-medium text-secondary
```

---

## 33. Alerts / Notifications

```
Alert: rounded-xl border border-{color}_subtle p-4 + featured-icon
Notification/Toast: rounded-xl bg-primary shadow-xl ring-1 ring-secondary p-4
Both: title(text-sm font-semibold) + desc(text-sm text-tertiary) + close button
```

---

## 34. Breadcrumbs

```
flex items-center gap-2
text-sm font-medium text-tertiary  separator:text-fg-quaternary
current: text-brand-secondary (or text-primary)
overflow: ... dropdown trigger
```

---

## 35. Metrics / Stat Cards

```
rounded-xl border border-secondary p-5
label: text-sm font-medium text-tertiary
value: text-display-sm font-semibold text-primary
change: text-sm font-medium success-700(up)/error-700(down) + arrow icon
```

---

## 36. Card / Section / Page Headers

```
CARD: flex justify-between border-b border-secondary px-6 py-5
  title: text-md font-semibold  desc: text-sm text-tertiary
SECTION: flex justify-between border-b pb-5
  title: text-lg font-semibold
PAGE: pt-8 pb-6 border-b
  breadcrumbs → title(display-sm) → desc(text-md) → tabs(mt-5)
```

---

## 37. Content Dividers

```
line: h-px bg-border-secondary
with text: flex items-center gap-3 → flex-1 line + text-sm text-tertiary + flex-1 line
```

---

## 38. Filter Bars

```
flex items-center gap-2 flex-wrap
search: Input sm with search icon
filter chips: Badge/Chip with X  add-filter: Button tertiary
active count: Badge brand sm  view toggle: ButtonGroup list/grid
```

---

## 39. Charts

```
Recharts-based. brand-600 primary color.
grid: stroke=border-secondary strokeDasharray="3 3"
axis: text-xs fill=text-quaternary
tooltip: rounded-lg bg-primary shadow-lg ring-1 ring-secondary p-3
pie segments: stroke-white strokeWidth=2
```

---

## 40. Carousel

```
relative overflow-hidden rounded-xl
Slides: flex transition-transform  each:basis-full
Dots: size-2 rounded-full bg-quaternary  active:bg-brand-solid
Arrows: absolute top-1/2 Button secondary rounded-full shadow-md
```

---

## 41. Command Menu

```
fixed centered max-w-lg rounded-xl bg-primary shadow-2xl ring-1 ring-secondary
Search: h-12 px-4 border-b  icon:fg-quaternary  input:text-md
Results: max-h-80 p-2  group:text-xs text-quaternary
Item: px-3 py-2 rounded-md text-sm text-secondary hover:bg-primary_hover
Footer: border-t px-4 py-3 text-xs text-tertiary
```

---

## 42. Tree View

```
Item: flex items-center gap-2 py-1.5 rounded-md text-sm text-secondary
  indent: each level adds pl-6
  expand: chevron size-4 rotate-90(open)
  selected: bg-active text-primary font-medium
  folder: text-fg-warning-primary  file: text-fg-quaternary
```

---

## 43. Messaging / Chat

```
sent:     bg-brand-solid text-white rounded-2xl rounded-br-md px-4 py-2.5
received: bg-secondary text-secondary rounded-2xl rounded-bl-md px-4 py-2.5
timestamp: text-xs text-quaternary  avatar: size-8 rounded-full
Input bar: border-t p-4  input:rounded-xl  send:Button primary icon-only
```

---

## 44. Progress Steps

```
HORIZONTAL:
  circle: size-8 rounded-full
    completed: bg-brand-solid text-white(check)
    current:   ring-2 ring-brand bg-brand-primary text-brand-600
    upcoming:  bg-secondary text-quaternary
  connector: h-0.5 flex-1 bg-border-secondary  completed:bg-brand-solid
  label: text-sm font-medium  desc: text-sm text-tertiary

VERTICAL: same but connector=w-0.5 h-full ml-4
```

---

## 45. Focus Ring

```
ALL interactive: focus-visible:outline-2 outline-offset-2 outline-brand-500
Inputs:          ring-2 ring-brand (no offset, wraps input)
Error:           ring-2 ring-error / outline-error-500
```

---

## 46. Shadow System

```
xs:             0px 1px 2px rgba(0,0,0,0.05)
sm:             0px 1px 3px rgba(0,0,0,0.1), 0px 1px 2px -1px rgba(0,0,0,0.1)
md:             0px 4px 6px -1px rgba(0,0,0,0.1), 0px 2px 4px -2px rgba(0,0,0,0.06)
lg:             0px 12px 16px -4px rgba(0,0,0,0.08), ...
xl:             0px 20px 24px -4px rgba(0,0,0,0.08), ...
2xl:            0px 24px 48px -12px rgba(0,0,0,0.18), ...
skeuomorphic:   inset 0 0 0 1px rgba(0,0,0,0.18), inset 0 -2px 0 rgba(0,0,0,0.05)

USAGE: buttons=xs-skeuomorphic inputs=xs cards=xs/sm dropdowns=lg
       modals=xl toasts=xl tooltips=lg datepicker=xl command=2xl
```

---

## 47. Typography Prose

```
body: text-md text-tertiary  headings: text-primary font-600
h1=display-sm h2=display-xs h3=text-xl h4=text-lg
links: underline offset-3px  code: text-sm font-700 rounded-md bg-secondary ring-1
blockquote: border-l-2 border-brand text-xl font-500 italic
```
