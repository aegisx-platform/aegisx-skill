---
name: aegisx-multi-schema-db
version: 1.0.0
description: >
  AegisX multi-schema PostgreSQL architecture — public (main system, 77 migrations),
  inventory (domain, 269 migrations), platform (shared master data), and future domains.
  Use when creating migrations, seeding data, initializing a new domain, or debugging
  schema-scoped queries. Triggers on: database migration, knex migration, db:migrate,
  db:seed, domain schema, inventory schema, platform schema, public schema, schema separation,
  multi-domain, new domain init, migrations-inventory, migrations-platform, knex config,
  SET search_path, cross-schema query.
---

# AegisX Multi-Schema Database

## Purpose

AegisX separates data by PostgreSQL **schemas** — not by database or table prefix. This isolates domains (inventory, HR, finance) while sharing a single database connection. Critical to know which schema your migration/seed/query belongs to.

## Schemas

| Schema | Purpose | Migrations | Seeds | Schema creation |
|---|---|---|---|---|
| **public** | Main system (auth, users, navigation, RBAC) | `apps/api/src/database/migrations/` (77) | `apps/api/src/database/seeds/` | Auto (default) |
| **inventory** | Drug inventory, budget, procurement | `apps/api/src/database/migrations-inventory/` (269) | `apps/api/src/database/seeds-inventory/` | Manual: `CREATE SCHEMA IF NOT EXISTS inventory;` |
| **platform** | Shared master data (hospitals, departments) | `apps/api/src/database/migrations-platform/` | `apps/api/src/database/seeds-platform/` | Manual |
| **<new>** | Future domains (HR, finance) | `apps/api/src/database/migrations-<name>/` | `apps/api/src/database/seeds-<name>/` | Manual |

## Commands

### Main system (public)
```bash
pnpm run db:migrate          # Run public migrations
pnpm run db:seed             # Seed public data
pnpm run db:status           # Check public migration status
pnpm run db:rollback         # Rollback last migration
```

### Inventory domain
```bash
pnpm run db:migrate:inventory        # Run inventory migrations
pnpm run db:seed:inventory           # Seed inventory data
pnpm run db:status:inventory         # Check inventory status
pnpm run inventory:setup             # Shortcut: migrate + seed
```

### New domain (HR example)
```bash
# 1. Initialize
pnpm run domain:init hr

# 2. Create schema in PostgreSQL
docker exec aegisx_postgres psql -U postgres -d aegisx_db \
  -c "CREATE SCHEMA IF NOT EXISTS hr;"

# 3. Run migrations
pnpm run db:migrate:hr

# 4. Seed
pnpm run db:seed:hr
```

## Clean Install Order (Verified)

```bash
# 1. Infrastructure
docker compose up -d

# 2. Main system (public)
pnpm run db:migrate

# 3. Inventory schema + migrations
docker exec aegisx_postgres psql -U postgres -d aegisx_db \
  -c "CREATE SCHEMA IF NOT EXISTS inventory;"
pnpm run db:migrate:inventory

# 4. All seeds
pnpm run db:seed            # 18 seed files: users, nav, RBAC, TMT, geography
```

Or one-shot:
```bash
bash scripts/production-install.sh --fresh
```

## Query Rules

### 1. Always specify schema in migrations
```typescript
// ❌ WRONG — defaults to public
export async function up(knex: Knex) {
  await knex.schema.createTable('drugs', ...);
}

// ✅ CORRECT — explicit schema
export async function up(knex: Knex) {
  await knex.schema.withSchema('inventory').createTable('drugs', ...);
}
```

### 2. Repository must use schema-qualified table names
```typescript
// Inside InventoryDrugRepository
const TABLE = 'inventory.drugs';
await knex(TABLE).select('*');

// OR use withSchema
await knex.withSchema('inventory').table('drugs').select('*');
```

### 3. Cross-schema queries
```typescript
// Query platform.hospitals FROM inventory code
await knex('platform.hospitals').select('*');
```

### 4. Foreign keys across schemas
```typescript
table.uuid('hospital_id')
  .references('id')
  .inTable('platform.hospitals')
  .onDelete('RESTRICT');
```

## Migration File Naming

```
apps/api/src/database/migrations-inventory/
  20260301120000_create_drugs_table.ts
  20260301120100_create_drug_categories_table.ts
  ...
```

Timestamps are CRITICAL — duplicate timestamps cause migration failures.

## Common Mistakes

| Mistake | Fix |
|---|---|
| ❌ Run `db:migrate` for inventory table | ✅ Use `db:migrate:inventory` |
| ❌ Forget `CREATE SCHEMA IF NOT EXISTS` | ✅ Add before first migration |
| ❌ Migration uses default schema | ✅ `.withSchema('inventory')` everywhere |
| ❌ `SELECT FROM drugs` cross-schema | ✅ `SELECT FROM inventory.drugs` |
| ❌ Mix inventory and public migrations | ✅ Keep separate directories |

## Related Skills

- **database-management** — high-level migration/seed ops
- **database-migrations** (curated) — zero-downtime migration patterns
- **aegisx-cli-library** — `--schema` flag for CRUD generation

## References

- `docs/guides/infrastructure/domain-separated-migrations.md`
- `docs/platform/multi-domain-strategy.md`
- `apps/api/knexfile.ts` + `knexfile.inventory.ts` + `knexfile.platform.ts`
