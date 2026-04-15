---
name: db-backup
description: Automate PostgreSQL database backups for main system and domain schemas. Use before deployments, migrations, or for scheduled backups. Supports full backups, schema-specific backups, and backup verification.
allowed-tools: Bash, Read, Write, Glob
---

# Database Backup Skill

> **💾 Automated PostgreSQL database backup and management**
>
> **Complete backup, verification, and retention management**

---

## 🎯 Purpose

**Problem:**

- Data loss risk without backups
- Manual backup is error-prone
- No backup verification
- No retention policy

**Solution:**

- Automated backup procedures
- Multiple backup strategies
- Backup verification
- Retention management
- Easy restore procedures

---

## 📋 When to Use

**MANDATORY before:**

- ✅ Production deployments
- ✅ Database migrations
- ✅ Major data changes
- ✅ Schema modifications

**RECOMMENDED for:**

- ✅ Daily scheduled backups
- ✅ Before bulk operations
- ✅ Staging environment snapshots

---

## 🚀 Usage

```bash
User: /db-backup full                    # Full database backup
User: /db-backup schema inventory        # Specific schema backup
User: /db-backup before-migration        # Pre-migration backup
User: /db-backup verify latest           # Verify latest backup
User: /db-backup list                    # List all backups
User: /db-backup cleanup 30              # Remove backups older than 30 days
```

---

## 💾 Backup Types

### 1. Full Database Backup

**What it includes:**

- All schemas (public, inventory, etc.)
- All tables and data
- All sequences and indexes
- All functions and triggers
- All permissions

**Command:**

```bash
pg_dump -U postgres -h localhost -p 5432 \
  -F c \
  -f "/backups/full_backup_$(date +%Y%m%d_%H%M%S).dump" \
  aegisx
```

**Use when:**

- Before production deployment
- Before major migrations
- For disaster recovery preparation

---

### 2. Schema-Specific Backup

**What it includes:**

- Single schema only (e.g., inventory)
- All tables in that schema
- Schema-specific objects

**Command:**

```bash
pg_dump -U postgres -h localhost -p 5432 \
  -F c \
  -n inventory \
  -f "/backups/inventory_backup_$(date +%Y%m%d_%H%M%S).dump" \
  aegisx
```

**Use when:**

- Before domain-specific migrations
- For domain data exports
- Testing domain separation

---

### 3. Table-Specific Backup

**What it includes:**

- Single table only
- Table structure and data

**Command:**

```bash
pg_dump -U postgres -h localhost -p 5432 \
  -F c \
  -t inventory.drugs \
  -f "/backups/drugs_backup_$(date +%Y%m%d_%H%M%S).dump" \
  aegisx
```

**Use when:**

- Before risky table operations
- For data migration testing
- Table structure changes

---

### 4. Data-Only Backup

**What it includes:**

- Data without schema
- Useful for data migration

**Command:**

```bash
pg_dump -U postgres -h localhost -p 5432 \
  -F c \
  --data-only \
  -f "/backups/data_only_backup_$(date +%Y%m%d_%H%M%S).dump" \
  aegisx
```

---

### 5. Schema-Only Backup

**What it includes:**

- Structure without data
- Useful for schema comparison

**Command:**

```bash
pg_dump -U postgres -h localhost -p 5432 \
  -F c \
  --schema-only \
  -f "/backups/schema_only_backup_$(date +%Y%m%d_%H%M%S).dump" \
  aegisx
```

---

## 🔧 Backup Scripts

### Full Backup Script

```bash
#!/bin/bash
# Full Database Backup Script

set -e  # Exit on error

# Configuration
DB_NAME="aegisx"
DB_USER="postgres"
DB_HOST="localhost"
DB_PORT="5432"
BACKUP_DIR="/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/full_backup_$TIMESTAMP.dump"

echo "🗄️  Starting Full Database Backup"
echo "=================================="
echo "Database: $DB_NAME"
echo "Timestamp: $TIMESTAMP"
echo ""

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Step 1: Create backup
echo "Step 1: Creating backup..."
pg_dump -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" \
  -F c \
  -f "$BACKUP_FILE" \
  "$DB_NAME"

if [ $? -eq 0 ]; then
    echo "✅ Backup created successfully"
else
    echo "❌ Backup failed"
    exit 1
fi

# Step 2: Verify backup
echo ""
echo "Step 2: Verifying backup..."
pg_restore --list "$BACKUP_FILE" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Backup verified successfully"
else
    echo "❌ Backup verification failed"
    exit 1
fi

# Step 3: Check backup size
echo ""
echo "Step 3: Checking backup size..."
BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
echo "Backup size: $BACKUP_SIZE"

# Step 4: Create metadata file
echo ""
echo "Step 4: Creating metadata..."
cat > "$BACKUP_FILE.meta" <<EOF
Database: $DB_NAME
Timestamp: $TIMESTAMP
Date: $(date)
Size: $BACKUP_SIZE
Type: full
Host: $DB_HOST
Port: $DB_PORT
EOF

echo "✅ Metadata created"

# Step 5: List recent backups
echo ""
echo "Recent backups:"
ls -lh "$BACKUP_DIR" | tail -5

echo ""
echo "=================================="
echo "✅ Backup Complete!"
echo "File: $BACKUP_FILE"
echo "Size: $BACKUP_SIZE"
echo "=================================="
```

---

### Schema-Specific Backup Script

```bash
#!/bin/bash
# Schema-Specific Backup Script

set -e

# Configuration
DB_NAME="aegisx"
DB_USER="postgres"
DB_HOST="localhost"
DB_PORT="5432"
BACKUP_DIR="/backups"
SCHEMA_NAME="$1"  # Pass schema name as argument
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/${SCHEMA_NAME}_backup_$TIMESTAMP.dump"

if [ -z "$SCHEMA_NAME" ]; then
    echo "❌ Error: Schema name required"
    echo "Usage: $0 <schema_name>"
    echo "Example: $0 inventory"
    exit 1
fi

echo "🗄️  Starting Schema Backup: $SCHEMA_NAME"
echo "======================================"
echo ""

# Create backup
echo "Creating backup..."
pg_dump -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" \
  -F c \
  -n "$SCHEMA_NAME" \
  -f "$BACKUP_FILE" \
  "$DB_NAME"

if [ $? -eq 0 ]; then
    echo "✅ Backup created: $BACKUP_FILE"
    echo "Size: $(du -h "$BACKUP_FILE" | cut -f1)"
else
    echo "❌ Backup failed"
    exit 1
fi
```

---

### Before Migration Backup

```bash
#!/bin/bash
# Pre-Migration Backup Script

set -e

DB_NAME="aegisx"
BACKUP_DIR="/backups/migrations"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
MIGRATION_NAME="$1"

if [ -z "$MIGRATION_NAME" ]; then
    MIGRATION_NAME="migration"
fi

echo "🗄️  Pre-Migration Backup: $MIGRATION_NAME"
echo "========================================"
echo ""

# Create migration backup directory
mkdir -p "$BACKUP_DIR"

# Full backup before migration
BACKUP_FILE="$BACKUP_DIR/before_${MIGRATION_NAME}_$TIMESTAMP.dump"

pg_dump -U postgres -h localhost \
  -F c \
  -f "$BACKUP_FILE" \
  "$DB_NAME"

echo "✅ Pre-migration backup complete!"
echo "File: $BACKUP_FILE"
echo ""
echo "⚠️  IMPORTANT: Keep this backup until migration is verified!"
echo "To restore: pg_restore -U postgres -d $DB_NAME --clean --if-exists $BACKUP_FILE"
```

---

## ✅ Backup Verification

### Verify Backup Integrity

```bash
#!/bin/bash
# Backup Verification Script

BACKUP_FILE="$1"

if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: $0 <backup_file>"
    exit 1
fi

echo "🔍 Verifying Backup: $BACKUP_FILE"
echo "==================================="
echo ""

# Check file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ File not found: $BACKUP_FILE"
    exit 1
fi

# Check file size
FILE_SIZE=$(stat -f%z "$BACKUP_FILE" 2>/dev/null || stat -c%s "$BACKUP_FILE" 2>/dev/null)
if [ "$FILE_SIZE" -lt 1000 ]; then
    echo "⚠️  WARNING: Backup file is very small (${FILE_SIZE} bytes)"
fi

# Verify with pg_restore
echo "Checking backup structure..."
pg_restore --list "$BACKUP_FILE" > /tmp/backup_list.txt 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Backup structure is valid"

    # Count tables
    TABLE_COUNT=$(grep "TABLE DATA" /tmp/backup_list.txt | wc -l)
    echo "Tables: $TABLE_COUNT"

    # Count sequences
    SEQUENCE_COUNT=$(grep "SEQUENCE SET" /tmp/backup_list.txt | wc -l)
    echo "Sequences: $SEQUENCE_COUNT"

    echo ""
    echo "✅ Backup verification passed!"
else
    echo "❌ Backup verification failed!"
    cat /tmp/backup_list.txt
    exit 1
fi

rm /tmp/backup_list.txt
```

---

## 📋 Backup Listing and Management

### List All Backups

```bash
#!/bin/bash
# List Backups Script

BACKUP_DIR="/backups"

echo "📋 Available Backups"
echo "==================="
echo ""

# Full backups
echo "Full Backups:"
ls -lh "$BACKUP_DIR"/full_backup_* 2>/dev/null | awk '{print $9, "-", $5}' || echo "  No full backups found"

echo ""
echo "Schema Backups:"
ls -lh "$BACKUP_DIR"/inventory_backup_* 2>/dev/null | awk '{print $9, "-", $5}' || echo "  No inventory backups found"

echo ""
echo "Migration Backups:"
ls -lh "$BACKUP_DIR"/migrations/before_* 2>/dev/null | awk '{print $9, "-", $5}' || echo "  No migration backups found"

echo ""
echo "Total backup size:"
du -sh "$BACKUP_DIR" 2>/dev/null || echo "  No backups directory"
```

---

### Cleanup Old Backups

```bash
#!/bin/bash
# Backup Cleanup Script

BACKUP_DIR="/backups"
DAYS_TO_KEEP="${1:-30}"  # Default: keep 30 days

echo "🗑️  Cleaning Up Old Backups"
echo "=========================="
echo "Keep backups newer than: $DAYS_TO_KEEP days"
echo ""

# Find and delete old backups
OLD_BACKUPS=$(find "$BACKUP_DIR" -name "*.dump" -type f -mtime +$DAYS_TO_KEEP)

if [ -z "$OLD_BACKUPS" ]; then
    echo "✅ No old backups to clean up"
    exit 0
fi

echo "Backups to delete:"
echo "$OLD_BACKUPS"
echo ""

read -p "Delete these backups? (yes/no): " confirm
if [ "$confirm" = "yes" ]; then
    find "$BACKUP_DIR" -name "*.dump" -type f -mtime +$DAYS_TO_KEEP -delete
    find "$BACKUP_DIR" -name "*.meta" -type f -mtime +$DAYS_TO_KEEP -delete
    echo "✅ Old backups deleted"
else
    echo "❌ Cleanup cancelled"
fi
```

---

## 📅 Backup Schedule

### Recommended Schedule

**Production:**

- **Daily:** Full backup at 2 AM
- **Weekly:** Archive backup (Sunday 3 AM)
- **Monthly:** Long-term archive (1st of month)
- **Before Each:** Deployment, migration

**Staging:**

- **Daily:** Full backup at 3 AM
- **Before Each:** Deployment, major testing

**Development:**

- **Weekly:** Full backup (optional)
- **Before:** Major migrations

---

### Cron Job Setup

```bash
# Edit crontab
crontab -e

# Add these lines:

# Daily full backup at 2 AM (production)
0 2 * * * /path/to/backup-scripts/full-backup.sh >> /var/log/db-backup.log 2>&1

# Weekly cleanup - keep 30 days
0 4 * * 0 /path/to/backup-scripts/cleanup.sh 30 >> /var/log/db-backup.log 2>&1

# Monthly archive - first day of month
0 3 1 * * cp /backups/full_backup_*.dump /backups/archives/
```

---

## 🔐 Backup Security

### Encryption

```bash
# Backup with encryption
pg_dump -U postgres -F c aegisx | \
  gpg --encrypt --recipient backup@aegisx.com \
  > "/backups/encrypted_backup_$(date +%Y%m%d).dump.gpg"

# Decrypt backup
gpg --decrypt /backups/encrypted_backup_20251220.dump.gpg | \
  pg_restore -U postgres -d aegisx --clean --if-exists
```

### Compression

```bash
# Backup with gzip compression
pg_dump -U postgres aegisx | \
  gzip > "/backups/backup_$(date +%Y%m%d).sql.gz"

# Restore from compressed backup
gunzip < /backups/backup_20251220.sql.gz | \
  psql -U postgres aegisx
```

---

## 💾 Backup Storage

### Local Storage

**Location:** `/backups/`
**Retention:** 30 days
**Pros:** Fast, easy access
**Cons:** Same server, not disaster-proof

### Remote Storage (Recommended)

**Options:**

- AWS S3
- Google Cloud Storage
- Azure Blob Storage
- Dedicated backup server

**Script Example (S3):**

```bash
# Upload to S3 after backup
aws s3 cp "$BACKUP_FILE" \
  s3://aegisx-backups/$(date +%Y/%m/%d)/ \
  --storage-class STANDARD_IA
```

---

## 📊 Backup Report

```markdown
# Database Backup Report

**Date:** 2025-12-20 02:00:00
**Type:** Full Database Backup
**Database:** aegisx
**Status:** ✅ SUCCESS

---

## Backup Details

- **File:** /backups/full_backup_20251220_020000.dump
- **Size:** 2.3 GB
- **Duration:** 5 minutes 23 seconds
- **Method:** pg_dump (custom format)

## Verification

- ✅ File integrity check passed
- ✅ Backup structure valid
- ✅ Table count: 156 tables
- ✅ Sequence count: 156 sequences

## Contents

- Schemas: public, inventory
- Tables: 156
- Data rows: ~5,000,000
- Indexes: 312
- Functions: 45

## Retention

- Local: 30 days
- Remote (S3): 90 days
- Archive: 1 year

## Next Backup

Scheduled: 2025-12-21 02:00:00

---

**Backup completed successfully**
```

---

## 🚨 Backup Best Practices

### 1. Test Restores Regularly

```bash
# Monthly restore test
# 1. Create test database
createdb -U postgres aegisx_test

# 2. Restore backup
pg_restore -U postgres -d aegisx_test --clean /backups/latest.dump

# 3. Verify data
psql -U postgres aegisx_test -c "SELECT COUNT(*) FROM users;"

# 4. Drop test database
dropdb -U postgres aegisx_test
```

### 2. Multiple Backup Locations

- ✅ Local backup (fast recovery)
- ✅ Remote backup (disaster recovery)
- ✅ Archive backup (long-term retention)

### 3. Monitor Backup Success

```bash
# Check last backup age
LAST_BACKUP=$(ls -t /backups/full_backup_*.dump | head -1)
BACKUP_AGE=$(( ($(date +%s) - $(stat -f%m "$LAST_BACKUP")) / 3600 ))

if [ "$BACKUP_AGE" -gt 48 ]; then
    echo "⚠️  WARNING: Last backup is $BACKUP_AGE hours old!"
fi
```

### 4. Document Backup Locations

```bash
# Keep backup inventory
cat > /backups/inventory.txt <<EOF
Latest Full Backup: $(ls -t /backups/full_backup_*.dump | head -1)
Latest Schema Backup: $(ls -t /backups/inventory_backup_*.dump | head -1)
Remote S3 Bucket: s3://aegisx-backups/
Archive Location: /backups/archives/
Retention Policy: 30 days local, 90 days remote
EOF
```

---

## 🎯 Quick Reference

```bash
# Full backup
pg_dump -U postgres -F c -f /backups/full_$(date +%Y%m%d).dump aegisx

# Schema backup
pg_dump -U postgres -F c -n inventory -f /backups/inventory_$(date +%Y%m%d).dump aegisx

# Verify backup
pg_restore --list /backups/backup.dump

# List backups
ls -lh /backups/*.dump

# Cleanup old backups (30 days)
find /backups -name "*.dump" -mtime +30 -delete
```

---

**Version**: 1.0.0
**Priority**: CRITICAL
**Backup Time**: ~5 min for 2 GB database
**Verification Time**: ~30 seconds
