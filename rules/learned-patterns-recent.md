# Learned Patterns (Unique - not covered by other rules)

## TypeBox & Fastify Serialization

```
NEVER: Assume schema includes all fields repository returns
ALWAYS: Verify response schema matches repository return type
- Fastify serialization ONLY includes fields defined in schema
- Fix: Add `items: Type.Optional(Type.Array(ItemSchema))` to schema
```

## Database Type Conversion

```
NEVER: Return raw PostgreSQL types from repository without conversion
ALWAYS: Use transformDatabaseRows() or autoTransformDatabaseRows()
- Utility: apps/api/src/shared/utils/database-transform.utils.ts
- DECIMAL → parseFloat, DATE → .toISOString().split('T')[0], TIMESTAMP → .toISOString()
- Configs: TRANSFORM_CONFIGS.purchaseRequestItem, purchaseRequest, budgetAllocation
```

## Template & Generator

```
NEVER: Fix generated code manually when template is root cause
ALWAYS: Fix template → Regenerate → Test
NEVER: Use {{variable}} for raw TypeScript union types
ALWAYS: Use {{{variable}}} (triple braces) — double braces escape quotes
ALWAYS: Check ALL template sections (Entity, CreateRequest, UpdateRequest, Query)
ALWAYS: Check templateVersion in frontend-generator.js (template.hbs vs template-v2.hbs)
```

## Dropdown API Response Format (CRITICAL)

```
NEVER: Assume dropdown API returns { data: Array } directly
ALWAYS: Check actual API response format FIRST — generated CRUD dropdown returns:
  { success: true, data: { options: [{ value: string, label: string }], total: number } }
ALWAYS: Map dropdown response correctly:
  ❌ this.options = res.data;  // data is { options, total } NOT array!
  ✅ this.options = res.data.options.map(opt => ({ id: Number(opt.value), name: opt.label }));
- Standard dropdown endpoint: GET /module/dropdown → DropdownResponseSchema
- value is always string, label is always string — convert types as needed
- This applies to ALL generated CRUD modules using aegisx-cli
```

## Stats/KPI Cards — Server-Side Only (CRITICAL)

```
NEVER: Calculate stats (available/unavailable/recentWeek) from list.filter() on current page data
  - list() only contains 25 items per page, NOT all records in DB
  - Stats will show wrong numbers (e.g., 0 active out of 10,000)
ALWAYS: Use server-side stats API:
  Backend: repository.getStats() with SQL COUNT(*) FILTER (WHERE ...)
  Frontend: statsFromServer signal + separate effect(reloadTrigger)
NEVER: Put getStats() call inside the data-load effect (causes double HTTP on every sort/page)
ALWAYS: Use separate effect that only reacts to reloadTrigger (fires on init + CUD only)
NEVER: Apply generic { total, available, unavailable, recentWeek } to modules with custom stats
  - warehouse-transfers, budget-requests, purchase-requests, drug-returns,
    drug-vendor-returns, inventory-levels, receipt-inspectors, companies,
    stock-counts, budget-adjustments, budget-allocations have domain-specific stats
  - These modules use custom stat shapes (draft/submitted/approved etc.)
ALWAYS: Check if module has custom stats header before applying generic pattern
```

## Route Registration Order (CRITICAL)

```
NEVER: Register named routes (e.g., /dropdown, /stats, /export) AFTER /:id
  - Fastify matches in registration order
  - /dropdown will be caught by /:id handler → 404
ALWAYS: Register named routes BEFORE /:id
  - Order: /stats → /export → /dropdown → /:id → /
```

## Foreign Key Fields — MUST Use Dropdown (CRITICAL)

```
NEVER: Show a text/number input for FK fields (parent_id, budget_request_id, location_id, etc.)
  - Users do NOT know database IDs — forcing them to type IDs is unusable
  - This applies to ALL foreign key references in forms, filters, and search
ALWAYS: Use <mat-select> dropdown or autocomplete for FK fields
  - Load options from the related module's list/dropdown API
  - Display human-readable label (name, title, code) — NOT the raw ID
  - Map selected option back to ID for the API payload
ALWAYS: For "select by year/period" scenarios:
  - Provide fiscal year dropdown first (ปีงบประมาณ)
  - Then load related records filtered by that year
  - Auto-select if only one result
NEVER: Assume users can look up IDs from another screen and type them manually
  - This is ALWAYS a UX failure regardless of how "temporary" the feature is
ALWAYS: When a field references another table:
  - Check if the referenced module has a /dropdown endpoint → use it
  - If no dropdown, use the /list endpoint with limit + search
  - Show: code + name (e.g., "PH-001 — ห้องจ่ายยา OPD")
```

## Button Spinner Layout (CRITICAL)

```
NEVER: Use @if inside <button> to conditionally show <mat-spinner>
  - @if adds/removes element from DOM → button width changes → layout shift
  - Text jumps left/right when spinner appears/disappears
ALWAYS: Keep <mat-spinner> always in DOM, toggle with [class.invisible]
  ❌ WRONG:
    <button mat-flat-button>
      @if (saving()) {
        <mat-spinner [diameter]="20"></mat-spinner>
      }
      บันทึก
    </button>

  ✅ CORRECT:
    <button mat-flat-button>
      <div class="flex items-center justify-center gap-2">
        <mat-spinner [diameter]="20" [class.invisible]="!saving()"></mat-spinner>
        <span>บันทึก</span>
      </div>
    </button>
NEVER: Use *ngIf on spinner inside button either — same layout problem
ALWAYS: Wrap button content in flex container for consistent alignment
```

## Hierarchy/Tree Components

```
NEVER: Access entity fields directly on TreeNode (node.created_at)
ALWAYS: Use node.data?.field_name — TreeNode stores entity data in node.data
ALWAYS: Include referencedSchema in foreignKeyInfo for FK dropdown URLs
- Platform/core modules need /v1/platform/ prefix
```

## Feature Docs Workflow (CRITICAL)

```
ALWAYS: Use `pnpm run docs:feature` for anything under docs/features/**
  - new <slug> --domain <inventory|platform|core>   # create 03-planned/<slug>/
  - activate <slug>                                 # planned → active
  - complete <slug>                                 # active → completed (stamps today)
  - archive  <slug>                                 # completed → archived
  - index                                           # regen docs/features/README.md
ALWAYS: Pass --no-index in feature branches / worktrees to avoid
        merge conflicts on the auto-generated FEATURE-INDEX block,
        then run `pnpm run docs:feature index` once on develop after merge
ALWAYS: Folder location = feature status. Four state folders:
        docs/features/{01-completed,02-active,03-planned,99-archived}/
ALWAYS: When classifying an existing feature, TRUST THE CODE, NOT THE README.
        Grep apps/ for evidence — the old FEATURE_REGISTRY drifted badly
        (e.g. drug-management claimed "Planned" while running in prod)
NEVER: `cp -R _template` or raw `git mv` by hand when the helper works
NEVER: Hand-edit docs/features/README.md between
        <!-- FEATURE-INDEX:START/END --> — auto-generated, will be
        overwritten by the next regen
NEVER: Maintain docs/FEATURE_REGISTRY.md — deprecated, now a redirect
NEVER: Require 8 files per feature — only README.md is mandatory,
        spec.md / api.md / CHANGELOG.md are optional
- Standard: docs/guides/documentation/feature-docs-standard.md
- Helper:   scripts/feature.sh
- Index:    docs/features/README.md (auto-generated)
```

## Unified Layout System (CRITICAL)

```
NEVER: Hardcode a single layout in shell template — use @switch (config.layout)
NEVER: Use CommonModule in layout/shell components — import NgTemplateOutlet directly
NEVER: Use isDarkMode input or .dark class for dark mode — use --ax-* CSS tokens only
NEVER: Use Subject/takeUntil for teardown — use DestroyRef + takeUntilDestroyed
ALWAYS: Add ChangeDetectionStrategy.OnPush to all layout components
ALWAYS: Use var(--ax-*, fallback) for all semantic colors — zero raw hex
ALWAYS: Add ARIA labels on nav, sidebar toggle, user menu buttons
ALWAYS: Use isPlatformBrowser guard before accessing window/document
- 3 layouts share Common API: appName, logoUrl, navigation, showFooter,
  showSettingsMenuItem, profileClicked, settingsClicked, logoutClicked,
  #headerActions, #userMenu, #footerContent slots
- Switch layout: change `layout: 'enterprise'` in app config (1 line)
- Light/Dark: <ax-theme-switcher /> in header, user toggle, localStorage
- Spec: docs/superpowers/specs/2026-04-12-unified-layout-system-design.md
```
