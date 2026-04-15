# Database Management - Quick Commands Reference

## Main System Commands

### Migration Management

```bash
# Create new migration
pnpm knex migrate:make MIGRATION_NAME --knexfile=knexfile.ts

# Examples
pnpm knex migrate:make create_users_table --knexfile=knexfile.ts
pnpm knex migrate:make add_email_to_users --knexfile=knexfile.ts
pnpm knex migrate:make create_roles_permissions --knexfile=knexfile.ts
```

```bash
# Run all pending migrations
pnpm run db:migrate

# Production
pnpm run db:migrate:prod
```

```bash
# Rollback last batch of migrations
pnpm run db:rollback

# Rollback all migrations (DANGEROUS)
pnpm knex migrate:rollback --all --knexfile=knexfile.ts

# Production
pnpm run db:rollback:prod
```

```bash
# Check migration status
pnpm run db:status

# Production
pnpm run db:status:prod
```

### Seed Management

```bash
# Run all seed files
pnpm run db:seed

# Run specific seed file
pnpm knex seed:run --knexfile=knexfile.ts --specific=001_users.ts

# Production
pnpm run db:seed:prod
```

### Full Reset

```bash
# Rollback + Migrate + Seed
pnpm run db:reset

# DANGEROUS: Drops everything and rebuilds
pnpm run db:rollback --all && pnpm run db:migrate && pnpm run db:seed
```

## Inventory Domain Commands

### Migration Management

```bash
# Create new migration
pnpm knex migrate:make MIGRATION_NAME --knexfile=knexfile-inventory.ts

# Examples
pnpm knex migrate:make create_drugs_table --knexfile=knexfile-inventory.ts
pnpm knex migrate:make add_generic_name_to_drugs --knexfile=knexfile-inventory.ts
pnpm knex migrate:make create_budget_requests --knexfile=knexfile-inventory.ts
```

```bash
# Run all pending migrations
pnpm run db:migrate:inventory
```

```bash
# Rollback last batch of migrations
pnpm run db:migrate:inventory:rollback

# Rollback all migrations (DANGEROUS)
pnpm knex migrate:rollback --all --knexfile=knexfile-inventory.ts
```

```bash
# Check migration status
pnpm run db:migrate:inventory:status
```

### Seed Management

```bash
# Run all seed files
pnpm run db:seed:inventory

# Run specific seed file
pnpm knex seed:run --knexfile=knexfile-inventory.ts --specific=001_drugs.ts
```

### Full Setup

```bash
# Migrate + Seed
pnpm run inventory:setup

# Full reset
pnpm run db:migrate:inventory:rollback --all
pnpm run db:migrate:inventory
pnpm run db:seed:inventory
```

### Import TMT Data

```bash
# Import TMT Excel file
pnpm run inventory:import-tmt
```

## Database Connection

### Test Connection

```bash
# Quick ping test
pnpm run db:ping
```

### Direct Access (PostgreSQL CLI)

```bash
# Connect to database
docker exec -it aegisx_postgres psql -U postgres -d aegisx_db

# Or using environment variables
docker exec -it aegisx_postgres psql -U ${DATABASE_USER} -d ${DATABASE_NAME}
```

## PostgreSQL Commands (psql)

### Schema Operations

```sql
-- List all schemas
\dn

-- Create schema manually
CREATE SCHEMA IF NOT EXISTS inventory;

-- Drop schema (DANGEROUS)
DROP SCHEMA IF EXISTS inventory CASCADE;

-- Set search path
SET search_path TO inventory, public;
```

### Table Operations

```sql
-- List all tables in all schemas
\dt *.*

-- List tables in public schema
\dt public.*

-- List tables in inventory schema
\dt inventory.*

-- Describe table structure
\d public.users
\d inventory.drugs

-- Show table with indexes and constraints
\d+ public.users
```

### Migration History

```sql
-- Main system migration history
SELECT * FROM public.knex_migrations ORDER BY id DESC;

-- Inventory domain migration history
SELECT * FROM inventory.knex_migrations_inventory ORDER BY id DESC;

-- Count migrations per domain
SELECT
  'public' as domain,
  COUNT(*) as migration_count
FROM public.knex_migrations
UNION ALL
SELECT
  'inventory' as domain,
  COUNT(*) as migration_count
FROM inventory.knex_migrations_inventory;
```

### Table Information

```sql
-- Count tables per schema
SELECT
  schemaname,
  COUNT(*) as table_count
FROM pg_tables
WHERE schemaname IN ('public', 'inventory')
GROUP BY schemaname;

-- List all columns in a table
SELECT
  column_name,
  data_type,
  character_maximum_length,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_schema = 'inventory'
  AND table_name = 'drugs'
ORDER BY ordinal_position;

-- Check if column exists
SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'inventory'
  AND table_name = 'drugs'
  AND column_name = 'generic_name';
```

### Foreign Keys

```sql
-- List foreign keys for a table
SELECT
  tc.table_schema,
  tc.constraint_name,
  tc.table_name,
  kcu.column_name,
  ccu.table_schema AS foreign_table_schema,
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
  AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_name = 'drugs';
```

### Indexes

```sql
-- List indexes on a table
SELECT
  indexname,
  indexdef
FROM pg_indexes
WHERE tablename = 'drugs'
  AND schemaname = 'inventory';
```

### Exit psql

```sql
-- Exit psql
\q
```

## Docker Commands

### PostgreSQL Container

```bash
# Start PostgreSQL
pnpm run docker:up

# Stop PostgreSQL
pnpm run docker:down

# Restart PostgreSQL with fresh database (DANGEROUS)
pnpm run docker:reset

# View PostgreSQL logs
docker logs -f aegisx_postgres

# Check PostgreSQL status
docker ps | grep postgres
```

### Container Migrations (Production)

```bash
# Run migrations in production container
pnpm run db:migrate:container

# Run seeds in production container
pnpm run db:seed:container

# Check migration status in production container
pnpm run db:status:container
```

## Full System Setup Workflow

### Fresh Installation

```bash
# 1. Start Docker services
pnpm run docker:up

# 2. Wait for PostgreSQL to be ready (5 seconds)
sleep 5

# 3. Run main system migrations
pnpm run db:migrate

# 4. Run inventory domain migrations
pnpm run db:migrate:inventory

# 5. Seed main system data
pnpm run db:seed

# 6. Seed inventory domain data
pnpm run db:seed:inventory

# 7. Verify everything
pnpm run db:status
pnpm run db:migrate:inventory:status
```

### Quick Setup (All-in-One)

```bash
# Run entire setup
pnpm run setup

# Internally runs:
# - Setup environment variables
# - Start Docker
# - Wait 5 seconds
# - Run main migrations
# - Run main seeds
```

**Note**: Default `setup` script doesn't include inventory domain. Run inventory setup separately:

```bash
pnpm run setup
pnpm run inventory:setup
```

## Development Workflow

### Before Creating Migration

```bash
# 1. Check current migration status
pnpm run db:status                         # Main
pnpm run db:migrate:inventory:status       # Inventory

# 2. Check database schema
docker exec -it aegisx_postgres psql -U postgres -d aegisx_db
\dt inventory.*
\d inventory.drugs
\q

# 3. Create migration
pnpm knex migrate:make create_new_table --knexfile=knexfile-inventory.ts
```

### After Creating Migration

```bash
# 1. Run migration
pnpm run db:migrate:inventory

# 2. Verify it worked
pnpm run db:migrate:inventory:status
docker exec -it aegisx_postgres psql -U postgres -d aegisx_db
\d inventory.new_table
\q

# 3. Test rollback
pnpm run db:migrate:inventory:rollback

# 4. Verify rollback worked
docker exec -it aegisx_postgres psql -U postgres -d aegisx_db
\dt inventory.*
\q

# 5. Re-apply
pnpm run db:migrate:inventory

# 6. Test build
pnpm run build

# 7. Commit
git add apps/api/src/database/migrations-inventory/...
git commit -m "feat(db): add new_table migration"
```

## Troubleshooting Commands

### Check Database Connectivity

```bash
# Ping database
pnpm run db:ping

# Check Docker status
docker ps | grep postgres

# View PostgreSQL logs
docker logs aegisx_postgres
```

### Reset Everything (Nuclear Option)

```bash
# 1. Stop Docker
pnpm run docker:down

# 2. Remove volumes (deletes all data)
docker volume rm aegisx_postgres_data

# 3. Start fresh
pnpm run docker:up
sleep 5

# 4. Run migrations
pnpm run db:migrate
pnpm run db:migrate:inventory

# 5. Run seeds
pnpm run db:seed
pnpm run db:seed:inventory
```

### Check What's Running

```bash
# Docker services status
pnpm run docker:ps

# All Docker containers
docker ps -a

# Disk usage
docker system df
```

## Environment Variables

### Default Values (from .env.local)

```bash
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=aegisx_db
DATABASE_USER=postgres
DATABASE_PASSWORD=postgres
```

### Override for Testing

```bash
# Run migration with different database
DATABASE_NAME=test_db pnpm run db:migrate

# Run migration with different user
DATABASE_USER=testuser pnpm run db:migrate:inventory
```

## Common Patterns

### Check Before Create

```typescript
// Always check before adding columns
const columnCheck = await knex.raw(`
  SELECT column_name
  FROM information_schema.columns
  WHERE table_schema = 'inventory'
    AND table_name = 'drugs'
    AND column_name = 'new_column'
`);

if (columnCheck.rows.length === 0) {
  await knex.schema.withSchema('inventory').alterTable('drugs', (table) => {
    table.string('new_column', 100).nullable();
  });
}
```

### Conditional Table Creation

```typescript
// Check if table exists
const tableExists = await knex.schema.withSchema('inventory').hasTable('drugs');

if (!tableExists) {
  await knex.schema.withSchema('inventory').createTable('drugs', (table) => {
    // Table definition
  });
}
```

### Safe Index Creation

```typescript
// Check if index exists before creating
const indexExists = await knex.raw(`
  SELECT indexname
  FROM pg_indexes
  WHERE schemaname = 'inventory'
    AND tablename = 'drugs'
    AND indexname = 'drugs_code_index'
`);

if (indexExists.rows.length === 0) {
  await knex.raw(`
    CREATE INDEX drugs_code_index
    ON inventory.drugs (code)
  `);
}
```

## Backup and Restore

### Backup Database

```bash
# Backup entire database
docker exec aegisx_postgres pg_dump -U postgres aegisx_db > backup.sql

# Backup specific schema
docker exec aegisx_postgres pg_dump -U postgres -n inventory aegisx_db > inventory_backup.sql
```

### Restore Database

```bash
# Restore entire database
docker exec -i aegisx_postgres psql -U postgres aegisx_db < backup.sql

# Restore specific schema
docker exec -i aegisx_postgres psql -U postgres aegisx_db < inventory_backup.sql
```

## Performance Monitoring

### Check Migration Performance

```bash
# Enable timing in psql
docker exec -it aegisx_postgres psql -U postgres -d aegisx_db
\timing on
```

### Check Table Sizes

```sql
SELECT
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname IN ('public', 'inventory')
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

### Check Index Usage

```sql
SELECT
  schemaname,
  tablename,
  indexname,
  idx_scan as index_scans
FROM pg_stat_user_indexes
WHERE schemaname = 'inventory'
ORDER BY idx_scan DESC;
```
