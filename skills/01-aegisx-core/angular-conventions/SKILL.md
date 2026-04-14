---
name: angular-conventions
description: AegisX project-specific Angular/Fastify coding conventions. Use when writing new components, services, routes, or modules to ensure consistency with existing codebase patterns.
allowed-tools: Read, Grep, Glob
---

# AegisX Angular/Fastify Conventions

Use this skill when writing ANY new code in the AegisX project to ensure consistency.

## When to Use

- Creating new Angular components, services, dialogs
- Creating new Fastify routes, controllers, services, repositories
- Reviewing code for convention compliance
- Unsure about naming, structure, or patterns

---

## 1. Angular Component Conventions

### Standalone Components Only
```typescript
@Component({
  selector: 'app-entity-list',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, MatButtonModule, ...],
  template: `...`,
  styles: [`...`],
})
```

### Signal-Based State (MANDATORY)
```typescript
// Service — private writable, public readonly
private loadingSignal = signal<boolean>(false);
readonly loading = this.loadingSignal.asReadonly();
readonly totalPages = computed(() => Math.ceil(this.totalSignal() / this.pageSizeSignal()));

// Component — reloadTrigger pattern for refresh
private reloadTrigger = signal(0);
reload() { this.reloadTrigger.update(n => n + 1); }

// Two-stage filter pattern (input vs active)
protected searchInputSignal = signal('');    // bound to input
protected searchTermSignal = signal('');      // sent to API on Apply
```

### inject() Only — No Constructor Injection
```typescript
export class EntityListComponent {
  private service = inject(EntityService);
  private snackBar = inject(MatSnackBar);
  private dialog = inject(MatDialog);
  private axDialog = inject(AxDialogService);
  private cdr = inject(ChangeDetectorRef);
  private destroyRef = inject(DestroyRef);
  private fb = inject(FormBuilder);  // forms only
}
```

### Template — New Control Flow Only
```html
<!-- CORRECT -->
@if (loading()) { <mat-spinner diameter="20"></mat-spinner> }
@for (item of items(); track item.id) { ... }

<!-- FORBIDDEN: *ngIf, *ngFor -->
```

### Material Component Standards
- `mat-form-field` with `appearance="outline"`
- Dialog width: `600px` standard
- SnackBar: success `3000ms`, error `5000ms` with `panelClass: ['error-snackbar']`
- Buttons: `mat-flat-button` (primary), `mat-button` (secondary), `mat-icon-button` (toolbar)

### AegisX UI Components — Use First
- `AxKpiCardComponent` — stats cards
- `AxCardComponent`, `AxEmptyStateComponent`, `AxErrorStateComponent`
- `AxEnterpriseLayoutComponent` — shell layout
- `AxDialogService` — `confirmDelete()`, `confirmBulkDelete()`
- `BreadcrumbComponent` with `BreadcrumbItem[]`

### CSS Variables (Not Tailwind Colors)
```css
color: var(--ax-text-default);
color: var(--ax-text-secondary);
border-color: var(--ax-border-default);
background: var(--ax-info-faint);
```
Tailwind allowed for: `flex`, `grid`, `gap-*`, `p-*`, `m-*`, `w-*`, `h-*`, responsive breakpoints.

---

## 2. Fastify Backend Conventions

### TypeBox Schemas
```typescript
import { Type, Static } from '@sinclair/typebox';

export const EntitySchema = Type.Object({
  id: Type.Integer(),
  name: Type.String(),
  uuid_field: Type.String({ format: 'uuid' }),  // UUID MUST have format
  optional_field: Type.Optional(Type.String()),
});
export type Entity = Static<typeof EntitySchema>;

// Response wrapper
export const EntityResponseSchema = ApiSuccessResponseSchema(EntitySchema);
```

### Route Registration — Order Matters!
```typescript
// CORRECT ORDER: named routes BEFORE /:id
fastify.get('/stats', { schema: statsSchema, handler: controller.getStats.bind(controller) });
fastify.get('/export', { schema: exportSchema, handler: controller.export.bind(controller) });
fastify.get('/dropdown', { schema: dropdownSchema, handler: controller.getDropdown.bind(controller) });
fastify.get('/:id', { schema: getByIdSchema, handler: controller.getById.bind(controller) });
fastify.get('/', { schema: listSchema, handler: controller.getList.bind(controller) });
```

### Controller Response Pattern
```typescript
// Success
reply.send({ success: true, data: result });
reply.code(201).send({ success: true, data: result });

// Error
reply.code(404).send({ success: false, error: { code: 'NOT_FOUND', message: '...' } });
```

### Service — BaseService Lifecycle
```typescript
export class EntityService extends BaseService<Entity, CreateDto, UpdateDto> {
  // Override hooks as needed
  async validateCreate(data: CreateDto) { /* throw { statusCode: 422, code: '...' } */ }
  async beforeCreate(data: CreateDto) { /* transform data */ }
  async afterCreate(entity: Entity, data: CreateDto) { /* side effects */ }
}
```

### Repository — Knex with Schema Prefix
```typescript
this.knex.select('*').from('inventory.entities as e')
  .join('inventory.related as r', 'r.id', 'e.related_id')
  .whereILike('e.name', `%${search}%`)
  .returning(['id', 'name', 'updated_at']);
```

---

## 3. Project Structure

### Frontend: Shell > Section > Module
```
apps/web/src/app/features/
  inventory/                    ← Shell
    inventory.routes.ts         ← Lazy routes with AuthGuard
    inventory.config.ts         ← Navigation, subApps, roles
    pages/<section>/            ← Section pages
    modules/<entity>/           ← CRUD modules (kebab-case folders)
      components/
        entity-list.component.ts
        entity-form.component.ts
        entity-create.dialog.ts
        entity-edit.dialog.ts
        entity-view.dialog.ts
      services/entity.service.ts
      types/entity.types.ts
```

### Backend: Domain > Subdomain > Module
```
apps/api/src/layers/domains/
  inventory/                    ← Domain
    master-data/                ← Subdomain
      entityName/               ← Module (camelCase folder!)
        entity-name.route.ts    ← kebab-case files
        entity-name.controller.ts
        entity-name.service.ts
        entity-name.repository.ts
        entity-name.schemas.ts
        index.ts
```

### Naming Convention Summary

| What | Convention | Example |
|---|---|---|
| API folder | camelCase | `budgetRequests/` |
| API files | kebab-case | `budget-requests.route.ts` |
| Angular folder | kebab-case | `budget-requests/` |
| Angular files | kebab-case | `budget-requests-list.component.ts` |
| URL paths | snake_case | `/budget_requests` |
| TypeBox schema | PascalCase + Schema | `BudgetRequestSchema` |
| TypeBox type | PascalCase | `BudgetRequest` |
| Angular signal (private) | camelCase + Signal | `loadingSignal` |
| Angular signal (public) | camelCase | `loading` |
| Classes | PascalCase | `BudgetRequestService` |
| Permissions | colon-separated | `'inventory:budget-requests:read'` |

---

## 4. Dialog Pattern (Create/Edit/View)

### Create Dialog
```typescript
async onFormSubmit(formData: FormData) {
  this.loading.set(true);
  try {
    const result = await this.service.create(formData as unknown as CreateRequest);
    this.snackBar.open('สร้างสำเร็จ', 'ปิด', { duration: 3000 });
    this.dialogRef.close(result);
  } catch (error: any) {
    const msg = this.service.permissionError()
      ? 'ไม่มีสิทธิ์ดำเนินการ'
      : error?.message || 'ไม่สามารถสร้างได้';
    this.snackBar.open(msg, 'ปิด', { duration: 5000, panelClass: ['error-snackbar'] });
  } finally {
    this.loading.set(false);
  }
}
```

---

## 5. API Response Shapes

```typescript
// Success
{ success: true, data: T, message?: string }

// Paginated
{ success: true, data: T[], pagination: { page, limit, total, totalPages, hasNext, hasPrev } }

// Error
{ success: false, error: { code: string, message: string } }

// Dropdown
{ success: true, data: { options: [{ value: string, label: string }], total: number } }
```

---

## Quick Checklist Before Writing Code

```
- [ ] Standalone component with imports[]
- [ ] Signals for state (not BehaviorSubject)
- [ ] inject() not constructor injection
- [ ] @if/@for not *ngIf/*ngFor
- [ ] TypeBox schema with format:'uuid' on UUID fields
- [ ] Named routes BEFORE /:id
- [ ] BaseService lifecycle hooks
- [ ] Schema prefix on DB queries (inventory.table_name)
- [ ] build:schemas after schema changes
```
