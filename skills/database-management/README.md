# Database Management Skill - Quick Guide

> For detailed instructions, see `SKILL.md`

## What is This?

This skill helps you manage database migrations in a project with **domain-separated architecture**. Think of it as having multiple mini-databases inside one database:

- **Main System** (public schema) - Core features like users, authentication
- **Inventory Domain** (inventory schema) - Inventory-specific features
- **Future Domains** (hr, finance, etc.) - Other business domains

## Quick Start

### I want to create a new table...

**Step 1: Which domain?**

Is it for:

- Users, roles, permissions? → Use Main System
- Drugs, budgets, inventory? → Use Inventory Domain
- Employees, payroll? → Use HR Domain (future)

**Step 2: Create migration**

```bash
# Main System
pnpm knex migrate:make create_TABLE_NAME --knexfile=knexfile.ts

# Inventory Domain
pnpm knex migrate:make create_TABLE_NAME --knexfile=knexfile-inventory.ts
```

**Step 3: Edit the migration file**

See templates in `SKILL.md` → "Migration Template" section

**Step 4: Run it**

```bash
# Main System
pnpm run db:migrate

# Inventory Domain
pnpm run db:migrate:inventory
```

**Step 5: Test rollback**

```bash
# Main System
pnpm run db:rollback

# Inventory Domain
pnpm run db:migrate:inventory:rollback
```

**Step 6: Re-apply and test build**

```bash
# Re-apply
pnpm run db:migrate                 # Main
pnpm run db:migrate:inventory       # Inventory

# Test build
pnpm run build

# Now safe to commit
```

### I want to check what migrations have run

```bash
# Main System
pnpm run db:status

# Inventory Domain
pnpm run db:migrate:inventory:status
```

### I want to rollback a migration

```bash
# Main System - rollback last batch
pnpm run db:rollback

# Inventory Domain - rollback last batch
pnpm run db:migrate:inventory:rollback
```

### I want to seed the database

```bash
# Main System
pnpm run db:seed

# Inventory Domain
pnpm run db:seed:inventory

# Both together
pnpm run db:migrate && pnpm run db:migrate:inventory
pnpm run db:seed && pnpm run db:seed:inventory
```

## Common Mistakes

### Mistake 1: Wrong Command

```bash
# ❌ WRONG - trying to create inventory table with main system command
pnpm run db:migrate  # Won't find migrations-inventory/

# ✅ CORRECT - use inventory command
pnpm run db:migrate:inventory
```

### Mistake 2: Forgetting Schema

```typescript
// ❌ WRONG - creates table in public schema
await knex.schema.createTable('drugs', (table) => {
  table.bigIncrements('id');
});

// ✅ CORRECT - creates table in inventory schema
await knex.schema.withSchema('inventory').createTable('drugs', (table) => {
  table.bigIncrements('id');
});
```

### Mistake 3: No Rollback Function

```typescript
// ❌ WRONG - can't undo the migration
export async function down(knex: Knex): Promise<void> {
  // Empty!
}

// ✅ CORRECT - proper rollback
export async function down(knex: Knex): Promise<void> {
  await knex.schema.withSchema('inventory').dropTableIfExists('drugs');
}
```

## File Locations

```
Project Root
├── knexfile.ts                          ← Main System config
├── knexfile-inventory.ts                ← Inventory Domain config
└── apps/api/src/database/
    ├── migrations/                      ← Main System migrations
    ├── migrations-inventory/            ← Inventory migrations
    ├── seeds/                           ← Main System seeds
    └── seeds-inventory/                 ← Inventory seeds
```

## When to Use What

| Task                          | Main System | Inventory Domain |
| ----------------------------- | ----------- | ---------------- |
| Create user table             | ✅          | ❌               |
| Create roles table            | ✅          | ❌               |
| Create permissions table      | ✅          | ❌               |
| Create drugs table            | ❌          | ✅               |
| Create budgets table          | ❌          | ✅               |
| Create departments table      | ❌          | ✅               |
| Create inventory_transactions | ❌          | ✅               |

## Testing Checklist

Before committing a migration:

- [ ] Migration runs successfully (`pnpm run db:migrate:inventory`)
- [ ] Rollback works (`pnpm run db:migrate:inventory:rollback`)
- [ ] Re-apply works (`pnpm run db:migrate:inventory`)
- [ ] Build passes (`pnpm run build`)
- [ ] Status shows migration in history (`pnpm run db:migrate:inventory:status`)

## Need More Help?

- See `SKILL.md` for detailed workflows and templates
- See `REFERENCE.md` for all available commands
- See `docs/guides/infrastructure/domain-separated-migrations.md` for architecture details

## Emergency Fixes

### Everything is broken, I need to start fresh

```bash
# 1. Rollback everything
pnpm run db:rollback --all
pnpm run db:migrate:inventory:rollback --all

# 2. Re-run from scratch
pnpm run db:migrate
pnpm run db:migrate:inventory
pnpm run db:seed
pnpm run db:seed:inventory
```

### I need to see what's in the database

```bash
# Connect to database
docker exec -it aegisx_postgres psql -U postgres -d aegisx_db

# List all schemas
\dn

# List tables in public schema
\dt public.*

# List tables in inventory schema
\dt inventory.*

# View migration history
SELECT * FROM public.knex_migrations ORDER BY id DESC;
SELECT * FROM inventory.knex_migrations_inventory ORDER BY id DESC;

# Exit
\q
```

## Quick Reference Card

```bash
# MAIN SYSTEM
pnpm knex migrate:make NAME --knexfile=knexfile.ts     # Create
pnpm run db:migrate                                     # Run
pnpm run db:rollback                                    # Undo
pnpm run db:status                                      # Check
pnpm run db:seed                                        # Seed

# INVENTORY DOMAIN
pnpm knex migrate:make NAME --knexfile=knexfile-inventory.ts  # Create
pnpm run db:migrate:inventory                                  # Run
pnpm run db:migrate:inventory:rollback                        # Undo
pnpm run db:migrate:inventory:status                          # Check
pnpm run db:seed:inventory                                    # Seed
```
