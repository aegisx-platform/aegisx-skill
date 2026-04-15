---
name: aegisx-common-patterns
version: 1.0.0
description: >
  AegisX learned patterns (NEVER/ALWAYS/PREFER) from real session experience — server-side
  stats, FK dropdowns, route registration order, TypeBox serialization, button spinner layout,
  database type transforms, hierarchy/tree components, template/generator fixes, dropdown API
  response format. Use before implementing any CRUD frontend, stats card, dropdown, button,
  or modifying generated code. Triggers on: stats cards, KPI cards, dropdown, foreign key,
  route order, button spinner, TypeBox serialization, database transform, template.hbs,
  hierarchy, tree, TreeNode, dropdown response format, NEVER/ALWAYS patterns.
---

# AegisX Common Patterns

## Purpose

Avoid repeating past mistakes. Every rule here came from a real bug or UX failure in the codebase — documented so Claude never makes the same mistake twice.

## Format

Each rule uses NEVER / ALWAYS / PREFER with context on WHY.

---

## 1. Stats/KPI Cards — Server-Side Only

```
NEVER: Calculate stats from `list.filter()` on the current page
  - list() returns 25 items per page — NOT all records
  - Wrong: "0 active out of 10,000" when there are actually 8,000 active
ALWAYS: Server-side stats via repository.getStats() with SQL COUNT(*) FILTER
  - Frontend: statsFromServer signal + effect(reloadTrigger)
NEVER: Put getStats() call inside the data-load effect
  - Causes double HTTP on every sort/page change
ALWAYS: Separate effect that only reacts to reloadTrigger (init + CUD only)
NEVER: Apply generic { total, available, unavailable, recentWeek } to modules with
       custom stats (warehouse-transfers, budget-requests, PR, drug-returns, etc.)
```

## 2. Foreign Key Fields — MUST Use Dropdown

```
NEVER: Show text/number input for FK fields (parent_id, budget_request_id, location_id)
  - Users do NOT know database IDs
  - Typing IDs is always a UX failure
ALWAYS: <mat-select> dropdown or autocomplete
  - Load from related module's /dropdown or /list endpoint
  - Display human-readable label (code + name)
  - Map selected option back to ID for payload
ALWAYS: Year/period FK scenarios:
  - Dropdown for fiscal year first
  - Load related records filtered by year
  - Auto-select if only one result
```

## 3. Dropdown API Response Format (CRITICAL)

```
NEVER: Assume dropdown API returns { data: Array } directly
ALWAYS: Generated CRUD dropdown returns:
  { success: true, data: { options: [{ value: string, label: string }], total: number } }
ALWAYS: Map correctly:
  ❌ this.options = res.data;  // data is { options, total } — NOT an array!
  ✅ this.options = res.data.options.map(opt => ({
       id: Number(opt.value),
       name: opt.label
     }));
- Standard endpoint: GET /module/dropdown → DropdownResponseSchema
- value is always string, label is always string — convert types as needed
```

## 4. Route Registration Order (CRITICAL)

```
NEVER: Register named routes (/dropdown, /stats, /export) AFTER /:id
  - Fastify matches in registration order
  - /dropdown gets caught by /:id handler → 404
ALWAYS: Order:  /stats → /export → /dropdown → /:id → /
```

## 5. TypeBox & Fastify Serialization

```
NEVER: Assume schema includes all fields repository returns
ALWAYS: Verify response schema matches repository return type
  - Fastify serialization ONLY includes fields defined in schema
  - Missing from schema = stripped from response
  - Fix: Add `items: Type.Optional(Type.Array(ItemSchema))` to schema
```

## 6. Database Type Conversion

```
NEVER: Return raw PostgreSQL types from repository without conversion
ALWAYS: Use transformDatabaseRows() or autoTransformDatabaseRows()
  - Location: apps/api/src/shared/utils/database-transform.utils.ts
  - DECIMAL → parseFloat
  - DATE → .toISOString().split('T')[0]
  - TIMESTAMP → .toISOString()
  - Configs: TRANSFORM_CONFIGS.purchaseRequestItem, purchaseRequest, budgetAllocation
```

## 7. Template & Generator

```
NEVER: Fix generated code manually when template is the root cause
ALWAYS: Fix template → Regenerate → Test
NEVER: Use {{variable}} for raw TypeScript union types (double braces escape quotes)
ALWAYS: Use {{{variable}}} (triple braces) for raw TS types
ALWAYS: Check ALL template sections (Entity, CreateRequest, UpdateRequest, Query)
ALWAYS: Check templateVersion in frontend-generator.js (template.hbs vs template-v2.hbs)
```

## 8. Button Spinner Layout

```
NEVER: Use @if inside <button> to conditionally show <mat-spinner>
  - @if adds/removes element from DOM → button width changes → layout shift
  - Text jumps left/right when spinner appears/disappears
ALWAYS: Keep <mat-spinner> always in DOM, toggle visibility with [class.invisible]
  ✅ <button mat-flat-button>
       <div class="flex items-center justify-center gap-2">
         <mat-spinner [diameter]="20" [class.invisible]="!saving()"></mat-spinner>
         <span>บันทึก</span>
       </div>
     </button>
NEVER: Use *ngIf on spinner either — same layout shift problem
ALWAYS: Wrap button content in flex container for consistent alignment
```

## 9. Hierarchy/Tree Components

```
NEVER: Access entity fields directly on TreeNode (node.created_at)
ALWAYS: Use node.data?.field_name — TreeNode stores entity data in node.data
ALWAYS: Include referencedSchema in foreignKeyInfo for FK dropdown URLs
ALWAYS: Platform/core modules need /v1/platform/ prefix
```

## 10. Fastify preValidation Hook

```
NEVER: throw Error in preValidation hooks — causes request timeout
ALWAYS: return reply.unauthorized() or return reply.forbidden()
- See apps/api/src/core/auth/strategies/auth.strategies.ts
```

## Related Skills

- **aegisx-auth-rbac** — detailed auth patterns
- **aegisx-schema-compilation** — schema workflow
- **aegisx-domain-architecture** — classification before CRUD
- **fastify-error-debugger** — error serialization debugging

## How This Skill Evolves

When a new pattern is learned (via `/reflect` or session review):
1. Add NEVER/ALWAYS/PREFER block here
2. Include WHY (past bug / UX issue)
3. Cross-reference the skill it relates to
4. Do NOT remove old patterns — they're historical record

See `.claude/rules/learned-patterns-recent.md` for the latest running log.
