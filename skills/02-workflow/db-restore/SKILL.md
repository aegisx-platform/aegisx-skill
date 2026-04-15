---
name: db-restore
description: Restore PostgreSQL database from backups with safety checks and verification. Use for disaster recovery, rollback after failed migrations, or data recovery scenarios.
allowed-tools: Bash, Read, Glob
---

# Database Restore Skill

> **🔄 Safe and verified database restoration**
>
> **Complete restore procedures with rollback protection**

---

## 🎯 Purpose

**Problem:**

- Data loss from failed migrations
- Need to rollback to previous state
- Disaster recovery scenarios
- Testing requires production data

**Solution:**

- Safe restore procedures
- Pre-restore validation
- Post-restore verification
- Rollback protection

---

## 📋 When to Use

**Use this skill when:**

- ✅ Migration failed and need to rollback
- ✅ Disaster recovery (server crash, data corruption)
- ✅ Restore production data to staging
- ✅ Testing database restore procedures
- ✅ Recovering deleted data

**⚠️ CRITICAL:**

- Always backup current database before restore
- Verify backup before restore
- Test restore in non-production first

---

## 🚀 Usage

```bash
User: /db-restore latest                    # Restore latest backup
User: /db-restore before-migration          # Restore pre-migration backup
User: /db-restore /backups/backup.dump      # Restore specific backup
User: /db-restore schema inventory          # Restore specific schema
User: /db-restore verify /backups/backup    # Verify backup before restore
User: /db-restore test /backups/backup      # Test restore (dry run)
```

---

## 🔒 Safety Checks

### Pre-Restore Checklist

**MANDATORY checks before ANY restore:**

```bash
#!/bin/bash
# Pre-Restore Safety Checks

BACKUP_FILE="$1"

echo "🔍 Pre-Restore Safety Checks"
echo "============================"
echo ""

# 1. Verify backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ ERROR: Backup file not found: $BACKUP_FILE"
    exit 1
fi
echo "✅ Backup file exists"

# 2. Verify backup file integrity
pg_restore --list "$BACKUP_FILE" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❌ ERROR: Backup file is corrupted or invalid"
    exit 1
fi
echo "✅ Backup file is valid"

# 3. Check backup file size
FILE_SIZE=$(stat -f%z "$BACKUP_FILE" 2>/dev/null || stat -c%s "$BACKUP_FILE" 2>/dev/null)
if [ "$FILE_SIZE" -lt 1000 ]; then
    echo "❌ ERROR: Backup file is too small ($FILE_SIZE bytes)"
    exit 1
fi
echo "✅ Backup file size ok: $(numfmt --to=iec $FILE_SIZE 2>/dev/null || echo "$FILE_SIZE bytes")"

# 4. Check backup metadata
if [ -f "$BACKUP_FILE.meta" ]; then
    echo "📋 Backup metadata:"
    cat "$BACKUP_FILE.meta"
else
    echo "⚠️  WARNING: No metadata file found"
fi

echo ""
echo "✅ All safety checks passed"
echo "Ready to restore"
```

---

## 🔄 Restore Procedures

### 1. Full Database Restore

**⚠️ DANGER: This will replace ALL data!**

```bash
#!/bin/bash
# Full Database Restore Script

set -e

BACKUP_FILE="$1"
DB_NAME="aegisx"
DB_USER="postgres"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: $0 <backup_file>"
    exit 1
fi

echo "🔄 Full Database Restore"
echo "======================="
echo "Database: $DB_NAME"
echo "Backup: $BACKUP_FILE"
echo ""
echo "⚠️  WARNING: This will REPLACE ALL data in $DB_NAME"
read -p "Are you absolutely sure? (type 'yes' to confirm): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Restore cancelled"
    exit 1
fi

# Step 1: Backup current database
echo ""
echo "Step 1: Backing up current database..."
SAFETY_BACKUP="/backups/before_restore_$TIMESTAMP.dump"
pg_dump -U "$DB_USER" -F c -f "$SAFETY_BACKUP" "$DB_NAME"
echo "✅ Safety backup created: $SAFETY_BACKUP"

# Step 2: Verify backup to restore
echo ""
echo "Step 2: Verifying backup to restore..."
pg_restore --list "$BACKUP_FILE" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❌ Backup file is invalid"
    exit 1
fi
echo "✅ Backup file verified"

# Step 3: Disconnect all active connections
echo ""
echo "Step 3: Disconnecting active connections..."
psql -U "$DB_USER" postgres <<EOF
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = '$DB_NAME' AND pid <> pg_backend_pid();
EOF
echo "✅ Active connections terminated"

# Step 4: Restore database
echo ""
echo "Step 4: Restoring database..."
pg_restore -U "$DB_USER" \
  -d "$DB_NAME" \
  --clean \
  --if-exists \
  --no-owner \
  --no-privileges \
  "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Database restored successfully"
else
    echo "❌ Restore failed!"
    echo ""
    echo "🔄 Attempting to restore from safety backup..."
    pg_restore -U "$DB_USER" -d "$DB_NAME" --clean --if-exists "$SAFETY_BACKUP"
    echo "⚠️  Rolled back to pre-restore state"
    exit 1
fi

# Step 5: Verify restore
echo ""
echo "Step 5: Verifying restore..."
psql -U "$DB_USER" "$DB_NAME" -c "SELECT COUNT(*) FROM users;" > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ Database is accessible"
else
    echo "❌ Database verification failed"
    exit 1
fi

# Step 6: Update sequences
echo ""
echo "Step 6: Updating sequences..."
psql -U "$DB_USER" "$DB_NAME" <<'EOF'
DO $$
DECLARE
    seq_record RECORD;
BEGIN
    FOR seq_record IN
        SELECT schemaname, tablename
        FROM pg_tables
        WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
    LOOP
        EXECUTE format('SELECT setval(pg_get_serial_sequence(%L, %L), COALESCE(MAX(id), 1)) FROM %I.%I',
                      seq_record.schemaname || '.' || seq_record.tablename,
                      'id',
                      seq_record.schemaname,
                      seq_record.tablename);
    END LOOP;
END $$;
EOF
echo "✅ Sequences updated"

echo ""
echo "============================="
echo "✅ Restore Complete!"
echo "============================="
echo "Database: $DB_NAME"
echo "Restored from: $BACKUP_FILE"
echo "Safety backup: $SAFETY_BACKUP"
echo ""
echo "⚠️  Important: Test the application thoroughly!"
```

---

### 2. Schema-Specific Restore

**Restore only specific schema (e.g., inventory)**

```bash
#!/bin/bash
# Schema Restore Script

BACKUP_FILE="$1"
SCHEMA_NAME="$2"
DB_NAME="aegisx"

if [ -z "$SCHEMA_NAME" ]; then
    echo "Usage: $0 <backup_file> <schema_name>"
    echo "Example: $0 /backups/inventory.dump inventory"
    exit 1
fi

echo "🔄 Schema Restore: $SCHEMA_NAME"
echo "=============================="
echo ""

# Backup current schema
echo "Backing up current schema..."
pg_dump -U postgres -F c -n "$SCHEMA_NAME" \
  -f "/backups/${SCHEMA_NAME}_before_restore_$(date +%Y%m%d_%H%M%S).dump" \
  "$DB_NAME"

# Restore schema
echo "Restoring schema..."
pg_restore -U postgres \
  -d "$DB_NAME" \
  -n "$SCHEMA_NAME" \
  --clean \
  --if-exists \
  "$BACKUP_FILE"

echo "✅ Schema $SCHEMA_NAME restored"
```

---

### 3. Table-Specific Restore

**Restore single table**

```bash
#!/bin/bash
# Table Restore Script

BACKUP_FILE="$1"
TABLE_NAME="$2"
DB_NAME="aegisx"

if [ -z "$TABLE_NAME" ]; then
    echo "Usage: $0 <backup_file> <table_name>"
    echo "Example: $0 /backups/backup.dump inventory.drugs"
    exit 1
fi

echo "🔄 Table Restore: $TABLE_NAME"
echo "============================"
echo ""

# Restore table
pg_restore -U postgres \
  -d "$DB_NAME" \
  -t "$TABLE_NAME" \
  --clean \
  --if-exists \
  "$BACKUP_FILE"

echo "✅ Table $TABLE_NAME restored"
```

---

### 4. Point-in-Time Recovery (PITR)

**Restore to specific timestamp (requires WAL archiving)**

```bash
#!/bin/bash
# Point-in-Time Recovery Script

TARGET_TIME="$1"  # Format: 2025-12-20 14:30:00

if [ -z "$TARGET_TIME" ]; then
    echo "Usage: $0 '<timestamp>'"
    echo "Example: $0 '2025-12-20 14:30:00'"
    exit 1
fi

echo "🕒 Point-in-Time Recovery"
echo "========================"
echo "Target time: $TARGET_TIME"
echo ""
echo "⚠️  Requires WAL archiving to be enabled"
echo ""

# Note: This requires PostgreSQL configuration:
# - wal_level = replica
# - archive_mode = on
# - archive_command set
# - WAL archives available

read -p "Continue? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    exit 1
fi

# Stop PostgreSQL
echo "Stopping PostgreSQL..."
systemctl stop postgresql

# Restore base backup
echo "Restoring base backup..."
rm -rf /var/lib/postgresql/15/main/*
cp -r /backups/base_backup/* /var/lib/postgresql/15/main/

# Create recovery.signal
echo "Creating recovery.signal..."
touch /var/lib/postgresql/15/main/recovery.signal

# Configure recovery.conf
cat > /var/lib/postgresql/15/main/recovery.conf <<EOF
restore_command = 'cp /backups/wal_archive/%f %p'
recovery_target_time = '$TARGET_TIME'
recovery_target_action = 'promote'
EOF

# Start PostgreSQL
echo "Starting PostgreSQL..."
systemctl start postgresql

echo "✅ Point-in-Time Recovery initiated"
echo "Monitor PostgreSQL logs for completion"
```

---

## ✅ Post-Restore Verification

### Verification Checklist

```bash
#!/bin/bash
# Post-Restore Verification Script

DB_NAME="aegisx"

echo "✅ Post-Restore Verification"
echo "==========================="
echo ""

# 1. Database connectivity
echo "1. Testing database connectivity..."
psql -U postgres -d "$DB_NAME" -c "SELECT 1;" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "   ✅ Database is accessible"
else
    echo "   ❌ Database connection failed"
    exit 1
fi

# 2. Count tables
echo "2. Checking tables..."
TABLE_COUNT=$(psql -U postgres -d "$DB_NAME" -t -c "
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_schema NOT IN ('pg_catalog', 'information_schema');
")
echo "   Tables: $TABLE_COUNT"

# 3. Check critical tables
echo "3. Checking critical tables..."
TABLES=("users" "inventory.drugs" "inventory.budgets")
for table in "${TABLES[@]}"; do
    COUNT=$(psql -U postgres -d "$DB_NAME" -t -c "SELECT COUNT(*) FROM $table;" 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "   ✅ $table: $COUNT rows"
    else
        echo "   ❌ $table: MISSING or ERROR"
    fi
done

# 4. Check sequences
echo "4. Checking sequences..."
SEQ_COUNT=$(psql -U postgres -d "$DB_NAME" -t -c "
    SELECT COUNT(*)
    FROM information_schema.sequences
    WHERE sequence_schema NOT IN ('pg_catalog', 'information_schema');
")
echo "   Sequences: $SEQ_COUNT"

# 5. Check indexes
echo "5. Checking indexes..."
INDEX_COUNT=$(psql -U postgres -d "$DB_NAME" -t -c "
    SELECT COUNT(*)
    FROM pg_indexes
    WHERE schemaname NOT IN ('pg_catalog', 'information_schema');
")
echo "   Indexes: $INDEX_COUNT"

# 6. Check foreign keys
echo "6. Checking foreign keys..."
FK_COUNT=$(psql -U postgres -d "$DB_NAME" -t -c "
    SELECT COUNT(*)
    FROM information_schema.table_constraints
    WHERE constraint_type = 'FOREIGN KEY';
")
echo "   Foreign keys: $FK_COUNT"

# 7. Test sample queries
echo "7. Testing sample queries..."
psql -U postgres -d "$DB_NAME" -c "
    SELECT 'Users' as table_name, COUNT(*) as count FROM users
    UNION ALL
    SELECT 'Drugs', COUNT(*) FROM inventory.drugs
    UNION ALL
    SELECT 'Budgets', COUNT(*) FROM inventory.budgets
    ORDER BY table_name;
" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "   ✅ Sample queries successful"
else
    echo "   ❌ Sample queries failed"
fi

echo ""
echo "============================="
echo "Verification Complete"
echo "============================="
```

---

## 🧪 Test Restore (Dry Run)

**Test restore without affecting production**

```bash
#!/bin/bash
# Test Restore Script (Safe)

BACKUP_FILE="$1"
TEST_DB="aegisx_restore_test"

echo "🧪 Test Restore (Dry Run)"
echo "========================"
echo "Backup: $BACKUP_FILE"
echo "Test DB: $TEST_DB"
echo ""

# Create test database
echo "Creating test database..."
createdb -U postgres "$TEST_DB"

# Restore to test database
echo "Restoring to test database..."
pg_restore -U postgres \
  -d "$TEST_DB" \
  --clean \
  --if-exists \
  --no-owner \
  "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Test restore successful"

    # Show statistics
    echo ""
    echo "Test database statistics:"
    psql -U postgres "$TEST_DB" -c "
        SELECT
            schemaname,
            COUNT(*) as table_count
        FROM pg_tables
        WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
        GROUP BY schemaname;
    "

    # Cleanup
    echo ""
    read -p "Drop test database? (yes/no): " cleanup
    if [ "$cleanup" = "yes" ]; then
        dropdb -U postgres "$TEST_DB"
        echo "✅ Test database dropped"
    fi
else
    echo "❌ Test restore failed"
    dropdb -U postgres "$TEST_DB" 2>/dev/null
    exit 1
fi
```

---

## 🎯 Common Restore Scenarios

### Scenario 1: Migration Failed

```bash
# 1. Find pre-migration backup
ls -lt /backups/migrations/before_*

# 2. Restore from pre-migration backup
BACKUP="/backups/migrations/before_add_columns_20251220_140000.dump"
./restore-full.sh "$BACKUP"

# 3. Verify application works
curl http://localhost:3000/health

# 4. If ok, delete failed migration
pnpm run db:rollback
```

### Scenario 2: Accidental Data Deletion

```bash
# 1. Find backup before deletion
ls -lt /backups/full_backup_*

# 2. Restore specific table
BACKUP="/backups/full_backup_20251220_020000.dump"
pg_restore -U postgres -d aegisx -t inventory.drugs --clean "$BACKUP"

# 3. Verify data restored
psql -U postgres aegisx -c "SELECT COUNT(*) FROM inventory.drugs;"
```

### Scenario 3: Disaster Recovery

```bash
# 1. Get latest backup from remote storage
aws s3 cp s3://aegisx-backups/latest/full_backup.dump /tmp/

# 2. Create new database
createdb -U postgres aegisx

# 3. Restore
pg_restore -U postgres -d aegisx /tmp/full_backup.dump

# 4. Verify and start application
systemctl start aegisx-api
systemctl start aegisx-web
```

### Scenario 4: Clone Production to Staging

```bash
# 1. Get production backup
PROD_BACKUP="/backups/production/full_backup_latest.dump"

# 2. Drop staging database
dropdb -U postgres aegisx_staging

# 3. Create staging database
createdb -U postgres aegisx_staging

# 4. Restore production data
pg_restore -U postgres -d aegisx_staging "$PROD_BACKUP"

# 5. Sanitize sensitive data
psql -U postgres aegisx_staging <<EOF
UPDATE users SET email = id || '@staging.local';
UPDATE users SET password = 'hashed_password';
EOF

echo "✅ Production data cloned to staging (sanitized)"
```

---

## 📋 Restore Checklist Template

```markdown
# Database Restore Checklist

**Date:** [YYYY-MM-DD HH:MM]
**Reason:** [Migration rollback / Disaster recovery / Data recovery]
**Backup:** [file path]

## Pre-Restore

- [ ] Backup file exists and verified
- [ ] Backup file integrity checked
- [ ] Current database backed up (safety backup)
- [ ] Active connections terminated
- [ ] Team notified (if production)
- [ ] Maintenance mode enabled (if applicable)

## Restore

- [ ] Restore command executed
- [ ] No errors during restore
- [ ] Sequences updated

## Post-Restore Verification

- [ ] Database connectivity tested
- [ ] Table count matches expected
- [ ] Critical tables verified
- [ ] Sample queries work
- [ ] Application health check passed
- [ ] User authentication works
- [ ] Critical features tested

## Rollback Plan (if failed)

- Safety backup location: [path]
- Restore command: pg_restore -U postgres -d aegisx [safety backup]
- Estimated rollback time: [X minutes]

---

**Restored by:** [name]
**Status:** ✅ Success / ❌ Failed
**Notes:** [any observations]
```

---

## 🚨 Emergency Restore Procedure

### Quick Restore (Production Emergency)

```bash
#!/bin/bash
# EMERGENCY RESTORE - Use only in production emergency!

echo "🚨 EMERGENCY RESTORE"
echo "=================="
echo ""
echo "⚠️  This will IMMEDIATELY restore database"
echo "⚠️  All current data will be LOST"
echo ""

read -p "Confirm emergency restore (type 'EMERGENCY'): " confirm
if [ "$confirm" != "EMERGENCY" ]; then
    echo "Cancelled"
    exit 1
fi

# Find latest backup
LATEST_BACKUP=$(ls -t /backups/full_backup_*.dump | head -1)
echo "Using: $LATEST_BACKUP"

# Safety backup
pg_dump -U postgres -F c -f "/backups/emergency_pre_restore_$(date +%Y%m%d_%H%M%S).dump" aegisx

# Restore
pg_restore -U postgres -d aegisx --clean --if-exists "$LATEST_BACKUP"

# Restart services
systemctl restart aegisx-api
systemctl restart aegisx-web

echo "✅ Emergency restore complete"
echo "🔍 CHECK APPLICATION IMMEDIATELY"
```

---

## 🎯 Quick Reference

```bash
# Full restore
pg_restore -U postgres -d aegisx --clean --if-exists /backups/backup.dump

# Schema restore
pg_restore -U postgres -d aegisx -n inventory --clean /backups/inventory.dump

# Table restore
pg_restore -U postgres -d aegisx -t inventory.drugs --clean /backups/backup.dump

# Test restore
pg_restore -U postgres -d aegisx_test /backups/backup.dump

# Verify backup
pg_restore --list /backups/backup.dump
```

---

**Version**: 1.0.0
**Priority**: CRITICAL
**Restore Time**: ~10-30 min depending on database size
**Risk**: HIGH - Always test first!
