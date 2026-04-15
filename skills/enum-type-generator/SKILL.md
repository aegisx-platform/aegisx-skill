---
name: enum-type-generator
description: Generate TypeBox schemas and TypeScript types from PostgreSQL enum types. Auto-discovers enums and generates type-safe code
invocable: true
priority: HIGH
---

# Enum Type Generator

Auto-generate TypeBox validation schemas and TypeScript union types from PostgreSQL enum definitions for type-safe CRUD operations.

## 🎯 What This Skill Does

**3-Step Generation:**

1. **Discover PostgreSQL Enums** - Query database for enum types
2. **Generate TypeBox Schema** - Type.Union([Type.Literal(...), ...])
3. **Generate TypeScript Type** - 'VALUE1' | 'VALUE2' | 'VALUE3'

**Result:** Type-safe enums in backend schemas, frontend types, and templates

## When to Use

ใช้ skill นี้เมื่อ:

- 🔴 **After creating enum in migration** - Generate schemas immediately
- Need TypeBox schema for new enum type
- Want to add enum validation to existing module
- Frontend needs TypeScript enum types
- Regenerating CRUD with new enum fields

## 📋 Enum Discovery

### Step 1: List All Enums in Database

```bash
# List all enum types (all schemas)
psql -U postgres -d aegisx_starter_1 -c "
SELECT
  n.nspname AS schema,
  t.typname AS enum_name,
  e.enumlabel AS enum_value
FROM pg_type t
JOIN pg_enum e ON t.oid = e.enumtypid
JOIN pg_namespace n ON t.typnamespace = n.oid
ORDER BY n.nspname, t.typname, e.enumsortorder;
"
```

**Example output:**

```
   schema   |    enum_name     |  enum_value
------------+------------------+-------------
 inventory  | budget_status    | DRAFT
 inventory  | budget_status    | PENDING
 inventory  | budget_status    | APPROVED
 inventory  | unit_type        | WEIGHT
 inventory  | unit_type        | VOLUME
 inventory  | unit_type        | QUANTITY
 public     | user_role        | ADMIN
 public     | user_role        | USER
```

### Step 2: Get Values for Specific Enum

```bash
# Get enum values for specific enum type
psql -U postgres -d aegisx_starter_1 -c "
SELECT enumlabel AS value
FROM pg_enum
WHERE enumtypid = 'inventory.unit_type'::regtype
ORDER BY enumsortorder;
"
```

**Example output:**

```
  value
----------
 WEIGHT
 VOLUME
 QUANTITY
 POTENCY
```

## 🔧 Generation Workflow

### Step 1: Identify Enum Column in Migration

```typescript
// Example migration
export async function up(knex: Knex): Promise<void> {
  // 1. Create enum type FIRST
  await knex.raw(`
    CREATE TYPE inventory.unit_type AS ENUM (
      'WEIGHT',    -- grams, kilograms
      'VOLUME',    -- milliliters, liters
      'QUANTITY',  -- tablets, capsules
      'POTENCY'    -- mg, mcg
    );
  `);

  // 2. Use enum in table
  await knex.schema.withSchema('inventory').createTable('drug_units', (table) => {
    table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
    table.specificType('unit_type', 'inventory.unit_type').notNullable();
    // ⬆️ This column uses enum - needs TypeBox schema!
  });
}
```

### Step 2: Generate TypeBox Schema

**Input:** Enum name + schema + values
**Output:** TypeBox validation schema

```typescript
// ✅ GENERATED: apps/api/src/layers/domains/inventory/master-data/drug-units/drug-units.schemas.ts

import { Type, Static } from '@sinclair/typebox';

// Step 2.1: Generate TypeBox enum
export const UnitTypeEnum = Type.Union([Type.Literal('WEIGHT'), Type.Literal('VOLUME'), Type.Literal('QUANTITY'), Type.Literal('POTENCY')], {
  description: 'Unit type for drug measurements',
  errorMessage: 'must be one of: WEIGHT, VOLUME, QUANTITY, POTENCY',
});

// Step 2.2: Generate TypeScript type from schema
export type UnitType = Static<typeof UnitTypeEnum>;
// Result: type UnitType = 'WEIGHT' | 'VOLUME' | 'QUANTITY' | 'POTENCY'

// Step 2.3: Use in entity schema
export const DrugUnitSchema = Type.Object({
  id: Type.String({ format: 'uuid' }),
  code: Type.String(),
  name: Type.String(),
  unit_type: UnitTypeEnum, // ✅ Type-safe enum!
  is_active: Type.Boolean(),
  created_at: Type.String({ format: 'date-time' }),
  updated_at: Type.String({ format: 'date-time' }),
});

export type DrugUnit = Static<typeof DrugUnitSchema>;
```

### Step 3: Generate Frontend TypeScript Type

**Input:** Enum values
**Output:** TypeScript union type

```typescript
// ✅ GENERATED: apps/web/src/app/features/inventory/modules/drug-units/types/drug-units.types.ts

export type UnitType = 'WEIGHT' | 'VOLUME' | 'QUANTITY' | 'POTENCY';

export interface DrugUnit {
  id: string;
  code: string;
  name: string;
  unit_type: UnitType; // ✅ Type-safe enum!
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

// Optional: Enum helper for dropdowns
export const UNIT_TYPE_OPTIONS: Array<{ value: UnitType; label: string }> = [
  { value: 'WEIGHT', label: 'น้ำหนัก (กรัม, กิโลกรัม)' },
  { value: 'VOLUME', label: 'ปริมาตร (มิลลิลิตร, ลิตร)' },
  { value: 'QUANTITY', label: 'จำนวน (เม็ด, แคปซูล)' },
  { value: 'POTENCY', label: 'ความแรง (mg, mcg)' },
];
```

### Step 4: Update Templates (If Regenerating)

```typescript
// Template: types.hbs (line ~53-76)

export interface {{pascalCase name}}Query {
  {{#each queryableFields}}
  {{#if isEnum}}
  {{name}}?: {{{tsType}}};  // ⬅️ Triple braces for raw output!
  {{else}}
  {{name}}?: {{tsType}};
  {{/if}}
  {{/each}}
}
```

**Key Points:**

- Use `{{{tsType}}}` (triple braces) for enum types to avoid HTML escaping
- `{{tsType}}` outputs `'A' | 'B'` correctly
- `{{{tsType}}}` would escape quotes → `&quot;A&quot; | &quot;B&quot;`

## 📊 Generation Templates

### Template 1: Backend TypeBox Enum

```typescript
// Pattern for generating TypeBox enum schema
import { Type, Static } from '@sinclair/typebox';

export const {{pascalCase enumName}}Enum = Type.Union([
  {{#each enumValues}}
  Type.Literal('{{this}}'){{#unless @last}},{{/unless}}
  {{/each}}
], {
  description: '{{description}}',
  errorMessage: 'must be one of: {{join enumValues ", "}}'
});

export type {{pascalCase enumName}} = Static<typeof {{pascalCase enumName}}Enum>;
```

### Template 2: Frontend TypeScript Enum

```typescript
// Pattern for generating TypeScript union type
export type {{pascalCase enumName}} = {{#each enumValues}}'{{this}}'{{#unless @last}} | {{/unless}}{{/each}};

// Optional: Helper for dropdowns
export const {{constantCase enumName}}_OPTIONS: Array<{ value: {{pascalCase enumName}}; label: string }> = [
  {{#each enumValues}}
  { value: '{{this}}', label: '{{humanize this}}' }{{#unless @last}},{{/unless}}
  {{/each}}
];
```

### Template 3: Zod (If Needed)

```typescript
// Pattern for Zod enum schema
import { z } from 'zod';

export const {{pascalCase enumName}}Schema = z.enum([
  {{#each enumValues}}
  '{{this}}'{{#unless @last}},{{/unless}}
  {{/each}}
]);

export type {{pascalCase enumName}} = z.infer<typeof {{pascalCase enumName}}Schema>;
```

## 🔍 Complete Example

### Given: PostgreSQL Enum

```sql
-- Migration: 20260108000000_create_budget_status_enum.ts
CREATE TYPE inventory.budget_status AS ENUM (
  'DRAFT',
  'PENDING',
  'APPROVED',
  'REJECTED',
  'CANCELLED'
);
```

### Generate: Backend TypeBox

```typescript
// apps/api/src/layers/domains/inventory/budget/budget-requests.schemas.ts

import { Type, Static } from '@sinclair/typebox';

// ✅ Generated enum schema
export const BudgetStatusEnum = Type.Union([Type.Literal('DRAFT'), Type.Literal('PENDING'), Type.Literal('APPROVED'), Type.Literal('REJECTED'), Type.Literal('CANCELLED')], {
  description: 'Budget request approval status',
  errorMessage: 'must be one of: DRAFT, PENDING, APPROVED, REJECTED, CANCELLED',
});

export type BudgetStatus = Static<typeof BudgetStatusEnum>;

// ✅ Use in entity schema
export const BudgetRequestSchema = Type.Object({
  id: Type.String({ format: 'uuid' }),
  request_number: Type.String(),
  status: BudgetStatusEnum, // Type-safe!
  requested_amount: Type.Number(),
  created_at: Type.String({ format: 'date-time' }),
});
```

### Generate: Frontend TypeScript

```typescript
// apps/web/src/app/features/inventory/modules/budget-requests/types/budget-requests.types.ts

export type BudgetStatus = 'DRAFT' | 'PENDING' | 'APPROVED' | 'REJECTED' | 'CANCELLED';

export interface BudgetRequest {
  id: string;
  request_number: string;
  status: BudgetStatus; // Type-safe!
  requested_amount: number;
  created_at: string;
}

// ✅ Helper for status badges
export const BUDGET_STATUS_CONFIG: Record<BudgetStatus, { label: string; color: string }> = {
  DRAFT: { label: 'ฉบับร่าง', color: 'gray' },
  PENDING: { label: 'รออนุมัติ', color: 'orange' },
  APPROVED: { label: 'อนุมัติแล้ว', color: 'green' },
  REJECTED: { label: 'ไม่อนุมัติ', color: 'red' },
  CANCELLED: { label: 'ยกเลิก', color: 'gray' },
};
```

### Generate: Form Dropdown

```typescript
// apps/web/src/app/features/inventory/modules/budget-requests/components/budget-request-form.component.ts

import { BUDGET_STATUS_CONFIG, BudgetStatus } from '../types/budget-requests.types';

@Component({
  template: `
    <mat-form-field>
      <mat-label>สถานะ</mat-label>
      <mat-select formControlName="status">
        @for (status of statusOptions; track status.value) {
          <mat-option [value]="status.value">
            <ax-badge [variant]="status.color">{{ status.label }}</ax-badge>
          </mat-option>
        }
      </mat-select>
    </mat-form-field>
  `,
})
export class BudgetRequestFormComponent {
  statusOptions = Object.entries(BUDGET_STATUS_CONFIG).map(([value, config]) => ({
    value: value as BudgetStatus,
    ...config,
  }));
}
```

## 🚨 Common Issues & Fixes

### Issue 1: Template Escaping Quotes

**Problem:**

```typescript
// ❌ WRONG OUTPUT (quotes escaped)
status?: &quot;DRAFT&quot; | &quot;PENDING&quot;
```

**Fix:**

```handlebars
{{! Use triple braces for raw output }}
{{#if isEnum}}
  status?:
  {{{tsType}}};
  <!-- ✅ Correct -->
{{else}}
  status?:
  {{tsType}};
{{/if}}
```

### Issue 2: Schema Prefix Missing

**Problem:**

```sql
-- ❌ WRONG: Enum created without schema prefix
CREATE TYPE unit_type AS ENUM ('A', 'B');
```

**Fix:**

```sql
-- ✅ CORRECT: Always use schema prefix
CREATE TYPE inventory.unit_type AS ENUM ('A', 'B');
```

### Issue 3: Enum Not in Migration Order

**Problem:**

```typescript
// ❌ WRONG: Table created BEFORE enum
await knex.schema.createTable('items', (table) => {
  table.specificType('status', 'inventory.status_type'); // Error: type doesn't exist!
});

await knex.raw(`CREATE TYPE inventory.status_type AS ENUM (...)`);
```

**Fix:**

```typescript
// ✅ CORRECT: Create enum FIRST
await knex.raw(`CREATE TYPE inventory.status_type AS ENUM ('A', 'B')`);

await knex.schema.createTable('items', (table) => {
  table.specificType('status', 'inventory.status_type'); // ✅ Works!
});
```

### Issue 4: TypeBox Using Type.String Instead of Enum

**Problem:**

```typescript
// ❌ WRONG: No validation
status: Type.String(); // Accepts ANY string value!
```

**Fix:**

```typescript
// ✅ CORRECT: Type-safe enum
status: Type.Union([Type.Literal('DRAFT'), Type.Literal('APPROVED')]); // Only accepts 'DRAFT' or 'APPROVED'
```

## 🔗 Integration with Other Skills

**Use with:**

- **database-management** - For creating enum migrations
- **unified-crud-validator** - Validates enum columns in tables
- **crud-generator-guide** - Generates enum-aware CRUD modules
- **typebox-schema-generator** - Auto-generates schemas from tables

**Workflow:**

```
1. Create enum in migration (database-management)
    ↓
2. Run migration
    ↓
3. Generate TypeBox + TypeScript (enum-type-generator)
    ↓
4. Use in CRUD generation (crud-generator-guide)
    ↓
5. Validate with unified-crud-validator
```

## 📊 Quick Commands

```bash
# List all enums in database
psql -U postgres -d aegisx_starter_1 -c "
SELECT n.nspname, t.typname, array_agg(e.enumlabel ORDER BY e.enumsortorder)
FROM pg_type t
JOIN pg_enum e ON t.oid = e.enumtypid
JOIN pg_namespace n ON t.typnamespace = n.oid
GROUP BY n.nspname, t.typname
ORDER BY n.nspname, t.typname;
"

# Get enum values for specific type
psql -U postgres -d aegisx_starter_1 -c "
SELECT enumlabel FROM pg_enum
WHERE enumtypid = 'inventory.unit_type'::regtype
ORDER BY enumsortorder;
"

# Check if enum exists
psql -U postgres -d aegisx_starter_1 -c "
SELECT typname FROM pg_type
WHERE typname = 'unit_type' AND typnamespace = 'inventory'::regnamespace;
"
```

## 📝 Summary

**Enum Type Generator = 3-Step Type Safety**

✅ **Discover:** Query PostgreSQL enums from database
✅ **Generate:** TypeBox schemas + TypeScript types
✅ **Integrate:** Use in CRUD modules, forms, dropdowns

**Result:** Type-safe enums across backend + frontend

**Usage:** After creating enum in migration, generate immediately

**Time Investment:** 5-10 minutes generation
**Time Saved:** 20-30 minutes debugging runtime enum errors

**Golden Rule:**

```
NEVER use Type.String() for enum columns.
ALWAYS generate Type.Union([Type.Literal(...)]) schemas.
```

---

**See also:**

- [database-management](../database-management/SKILL.md) - Enum migration patterns
- [typebox-schema-generator](../typebox-schema-generator/SKILL.md) - Auto schema generation
- [crud-generator-guide](../crud-generator-guide/SKILL.md) - Enum-aware CRUD
