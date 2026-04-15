---
name: deployment-workflow
description: Automate deployment workflow to staging and production environments. Use when deploying to staging/production, creating releases, or managing deployment processes.
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Deployment Workflow Skill

> **🚀 Automated deployment to staging and production environments**
>
> **Complete deployment checklist and verification**

---

## 🎯 Purpose

**Problem:**

- Manual deployment is error-prone
- Missing steps cause production issues
- No standard deployment process
- Inconsistent environment configurations

**Solution:**

- Automated deployment workflow
- Pre-deployment checklist
- Post-deployment verification
- Rollback procedures

---

## 📋 When to Use

**Use this skill when:**

- ✅ Deploying to staging environment
- ✅ Deploying to production environment
- ✅ Creating release candidates
- ✅ Managing deployment processes
- ✅ Verifying deployment health

**Do NOT use for:**

- ❌ Local development deployments
- ❌ Testing deployments (use test skills)

---

## 🚀 Usage

```bash
User: /deployment-workflow staging
User: /deployment-workflow production
User: /deployment-workflow rollback
User: /deployment-workflow verify
```

---

## 🔄 Deployment Environments

### 1. Staging Environment

**Purpose:** Pre-production testing and validation
**URL:** https://staging.aegisx.com (or configured URL)
**Docker Compose:** `docker-compose.staging.yml`

**When to Deploy:**

- After feature completion
- Before production deployment
- For stakeholder review
- For integration testing

### 2. Production Environment

**Purpose:** Live production system
**URL:** https://app.aegisx.com (or configured URL)
**Docker Compose:** `docker-compose.prod.yml`

**When to Deploy:**

- After staging verification
- After approval from stakeholders
- During maintenance windows
- For critical hotfixes (with caution)

---

## ✅ Pre-Deployment Checklist

### 1. Code Quality

```bash
# Run build
pnpm run build
# MUST pass - no TypeScript errors

# Run tests
pnpm run test
# MUST pass - all tests green

# Run linting
pnpm run lint
# MUST pass - no lint errors

# Check for console.log statements
grep -r "console\.log" apps/api/src/ apps/web/src/ | grep -v "node_modules"
# SHOULD be empty or justified
```

### 2. Database Migrations

```bash
# Check migration status
pnpm run db:status
pnpm run db:status:inventory

# Verify all migrations are up
# All migrations should show "up"

# Test rollback (in staging only!)
pnpm run db:rollback
pnpm run db:migrate
# MUST succeed - migrations are reversible
```

### 3. Environment Variables

```bash
# Check required environment variables
cat .env.production.example

# Verify all required vars are set:
# - DATABASE_URL
# - JWT_SECRET
# - REDIS_URL (if using cache)
# - SMTP settings (if using email)
# - External API keys
```

### 4. Dependencies

```bash
# Check for security vulnerabilities
pnpm audit --audit-level=high

# MUST fix high/critical vulnerabilities before deploy

# Check for outdated dependencies
pnpm outdated

# Update if needed (test thoroughly!)
```

### 5. Documentation

```bash
# Verify API contracts are up to date
find docs/features -name "API_CONTRACTS.md"

# Verify FEATURES.md is updated
git diff HEAD~5 docs/features/FEATURES.md

# Verify CHANGELOG exists (if applicable)
cat CHANGELOG.md
```

---

## 🚀 Deployment Process

### Staging Deployment

```bash
#!/bin/bash
# Staging Deployment Script

echo "🚀 Starting Staging Deployment"

# Step 1: Pre-deployment checks
echo "Step 1: Running pre-deployment checks..."
pnpm run build || { echo "❌ Build failed"; exit 1; }
pnpm run test || { echo "❌ Tests failed"; exit 1; }

# Step 2: Backup database
echo "Step 2: Backing up staging database..."
# Run /db-backup skill for staging

# Step 3: Pull latest code
echo "Step 3: Pulling latest code..."
git checkout develop
git pull origin develop

# Step 4: Install dependencies
echo "Step 4: Installing dependencies..."
pnpm install

# Step 5: Build application
echo "Step 5: Building application..."
pnpm run build

# Step 6: Run migrations
echo "Step 6: Running database migrations..."
pnpm run db:migrate
pnpm run db:migrate:inventory

# Step 7: Restart services
echo "Step 7: Restarting services..."
docker-compose -f docker-compose.staging.yml down
docker-compose -f docker-compose.staging.yml up -d

# Step 8: Wait for services
echo "Step 8: Waiting for services to start..."
sleep 10

# Step 9: Health check
echo "Step 9: Running health checks..."
curl -f http://localhost:3000/health || { echo "❌ Health check failed"; exit 1; }

# Step 10: Smoke tests
echo "Step 10: Running smoke tests..."
# Test critical endpoints
curl -f http://localhost:3000/api/profile || { echo "⚠️  Profile endpoint failed"; }

echo "✅ Staging deployment complete!"
echo "🔗 URL: http://staging.aegisx.com"
```

### Production Deployment

```bash
#!/bin/bash
# Production Deployment Script

echo "🚀 Starting Production Deployment"
echo "⚠️  WARNING: This will deploy to PRODUCTION"
read -p "Are you sure? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "❌ Deployment cancelled"
    exit 1
fi

# Step 1: Pre-deployment checks (STRICT)
echo "Step 1: Running pre-deployment checks..."
pnpm run build || { echo "❌ Build failed"; exit 1; }
pnpm run test || { echo "❌ Tests failed"; exit 1; }
pnpm audit --audit-level=high || { echo "❌ Security vulnerabilities found"; exit 1; }

# Step 2: Backup database (CRITICAL!)
echo "Step 2: Backing up production database..."
# Run /db-backup skill for production
# MUST verify backup succeeded before proceeding

# Step 3: Create release tag
echo "Step 3: Creating release tag..."
version=$(cat package.json | grep version | cut -d'"' -f4)
git tag -a "v$version" -m "Production release v$version"
git push origin "v$version"

# Step 4: Pull latest code
echo "Step 4: Pulling latest code..."
git checkout main
git pull origin main

# Step 5: Install dependencies
echo "Step 5: Installing dependencies..."
pnpm install --prod

# Step 6: Build application
echo "Step 6: Building application..."
NODE_ENV=production pnpm run build

# Step 7: Run migrations (with backup!)
echo "Step 7: Running database migrations..."
pnpm run db:migrate
pnpm run db:migrate:inventory

# Step 8: Restart services (blue-green if available)
echo "Step 8: Restarting services..."
docker-compose -f docker-compose.prod.yml down
docker-compose -f docker-compose.prod.yml up -d

# Step 9: Wait for services
echo "Step 9: Waiting for services to start..."
sleep 15

# Step 10: Health check
echo "Step 10: Running health checks..."
curl -f https://app.aegisx.com/health || { echo "❌ Health check failed - ROLLBACK!"; exit 1; }

# Step 11: Smoke tests (critical paths)
echo "Step 11: Running smoke tests..."
# Test critical endpoints
curl -f https://app.aegisx.com/api/profile || { echo "⚠️  Warning: Profile endpoint failed"; }

# Step 12: Monitor for 5 minutes
echo "Step 12: Monitoring for 5 minutes..."
echo "Watch logs: docker-compose -f docker-compose.prod.yml logs -f"
echo "Check errors in logs manually..."

echo "✅ Production deployment complete!"
echo "🔗 URL: https://app.aegisx.com"
echo "📊 Monitor: Check application logs and metrics"
```

---

## 🔄 Rollback Procedure

### When to Rollback

- ❌ Health checks fail after deployment
- ❌ Critical functionality broken
- ❌ Database migration failed
- ❌ Severe performance degradation
- ❌ Security vulnerability discovered

### Rollback Steps

```bash
#!/bin/bash
# Rollback Script

echo "🔄 Starting Rollback"

# Step 1: Identify previous version
echo "Step 1: Finding previous version..."
previous_tag=$(git describe --tags --abbrev=0 HEAD^)
echo "Previous version: $previous_tag"

# Step 2: Confirm rollback
read -p "Rollback to $previous_tag? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "❌ Rollback cancelled"
    exit 1
fi

# Step 3: Checkout previous version
echo "Step 3: Checking out previous version..."
git checkout "$previous_tag"

# Step 4: Restore database (if migrations were run)
echo "Step 4: Checking if database restore needed..."
read -p "Restore database from backup? (yes/no): " restore_db
if [ "$restore_db" = "yes" ]; then
    # Run /db-restore skill
    echo "Run /db-restore to restore from backup"
fi

# Step 5: Install dependencies
echo "Step 5: Installing dependencies..."
pnpm install --prod

# Step 6: Build application
echo "Step 6: Building application..."
NODE_ENV=production pnpm run build

# Step 7: Restart services
echo "Step 7: Restarting services..."
docker-compose -f docker-compose.prod.yml down
docker-compose -f docker-compose.prod.yml up -d

# Step 8: Health check
echo "Step 8: Running health checks..."
sleep 10
curl -f https://app.aegisx.com/health || { echo "❌ Health check failed after rollback!"; exit 1; }

echo "✅ Rollback complete!"
echo "Version: $previous_tag"
```

---

## ✅ Post-Deployment Verification

### 1. Health Checks

```bash
# API health endpoint
curl https://app.aegisx.com/health

# Expected response:
# {
#   "status": "ok",
#   "timestamp": "2025-12-20T10:00:00.000Z",
#   "uptime": 123.45,
#   "database": "connected",
#   "redis": "connected"
# }
```

### 2. Critical Endpoints

```bash
# Test authentication
curl -X POST https://app.aegisx.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password"}'

# Test profile endpoint (with valid token)
curl https://app.aegisx.com/api/profile \
  -H "Authorization: Bearer <token>"

# Test inventory endpoint
curl https://app.aegisx.com/api/inventory/master-data/drugs?page=1&limit=10 \
  -H "Authorization: Bearer <token>"
```

### 3. Database Connectivity

```bash
# Connect to database
docker exec -it aegisx-db psql -U postgres -d aegisx

# Check critical tables
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM inventory.drugs;

# Check recent activity
SELECT * FROM audit_logs ORDER BY created_at DESC LIMIT 10;
```

### 4. Frontend Accessibility

```bash
# Check frontend loads
curl -I https://app.aegisx.com

# Expected: 200 OK

# Check static assets
curl -I https://app.aegisx.com/assets/main.js

# Expected: 200 OK
```

### 5. Monitoring Metrics

```bash
# Check application logs
docker-compose -f docker-compose.prod.yml logs --tail=100 api

# Check for errors
docker-compose logs api | grep ERROR | tail -20

# Check response times
# Use /monitor-health skill for detailed metrics
```

---

## 📊 Deployment Checklist Template

```markdown
# Deployment Checklist - [Environment] - [Date]

## Pre-Deployment

- [ ] All tests passing locally
- [ ] Build succeeds without errors
- [ ] No security vulnerabilities (high/critical)
- [ ] Database migrations tested
- [ ] Environment variables configured
- [ ] API contracts up to date
- [ ] FEATURES.md updated
- [ ] Stakeholder approval (for production)

## Deployment

- [ ] Database backup completed
- [ ] Code pulled from correct branch
- [ ] Dependencies installed
- [ ] Application built successfully
- [ ] Database migrations run
- [ ] Services restarted
- [ ] Health check passed

## Post-Deployment

- [ ] Health endpoint responding
- [ ] Critical endpoints tested
- [ ] Database connectivity verified
- [ ] Frontend accessible
- [ ] No errors in logs (first 5 minutes)
- [ ] Performance acceptable
- [ ] Monitoring active

## Rollback Plan (if needed)

- Previous version: [git tag]
- Database backup location: [path]
- Estimated rollback time: [X minutes]
- Rollback decision maker: [name]

---

**Deployed by:** [name]
**Date:** [YYYY-MM-DD HH:MM]
**Version:** [v.X.X.X]
**Status:** ✅ Success / ❌ Failed / 🔄 Rolled back
```

---

## 🔧 Docker Compose Configurations

### Staging (`docker-compose.staging.yml`)

```yaml
version: '3.8'

services:
  api:
    image: aegisx-api:staging
    build:
      context: .
      dockerfile: apps/api/Dockerfile
      target: production
    environment:
      - NODE_ENV=staging
      - DATABASE_URL=${DATABASE_URL_STAGING}
      - JWT_SECRET=${JWT_SECRET_STAGING}
      - REDIS_URL=${REDIS_URL_STAGING}
    ports:
      - '3001:3000'
    depends_on:
      - db
      - redis

  web:
    image: aegisx-web:staging
    build:
      context: .
      dockerfile: apps/web/Dockerfile
      target: production
    environment:
      - API_URL=http://api:3000
    ports:
      - '4201:80'

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_DB=aegisx_staging
      - POSTGRES_USER=${DB_USER}
      - POSTGRES_PASSWORD=${DB_PASSWORD}
    volumes:
      - staging_db_data:/var/lib/postgresql/data
    ports:
      - '5433:5432'

  redis:
    image: redis:7-alpine
    ports:
      - '6380:6379'

volumes:
  staging_db_data:
```

### Production (`docker-compose.prod.yml`)

```yaml
version: '3.8'

services:
  api:
    image: aegisx-api:production
    build:
      context: .
      dockerfile: apps/api/Dockerfile
      target: production
    environment:
      - NODE_ENV=production
      - DATABASE_URL=${DATABASE_URL}
      - JWT_SECRET=${JWT_SECRET}
      - REDIS_URL=${REDIS_URL}
    ports:
      - '3000:3000'
    depends_on:
      - db
      - redis
    restart: unless-stopped
    healthcheck:
      test: ['CMD', 'curl', '-f', 'http://localhost:3000/health']
      interval: 30s
      timeout: 10s
      retries: 3

  web:
    image: aegisx-web:production
    build:
      context: .
      dockerfile: apps/web/Dockerfile
      target: production
    environment:
      - API_URL=http://api:3000
    ports:
      - '80:80'
      - '443:443'
    restart: unless-stopped

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_DB=aegisx
      - POSTGRES_USER=${DB_USER}
      - POSTGRES_PASSWORD=${DB_PASSWORD}
    volumes:
      - prod_db_data:/var/lib/postgresql/data
      - ./backups:/backups
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    restart: unless-stopped

volumes:
  prod_db_data:
```

---

## 🎯 Quick Commands

```bash
# Deploy to staging
/deployment-workflow staging

# Deploy to production
/deployment-workflow production

# Verify deployment
/deployment-workflow verify

# Rollback
/deployment-workflow rollback

# Check deployment status
docker-compose -f docker-compose.prod.yml ps

# View logs
docker-compose -f docker-compose.prod.yml logs -f api

# Health check
curl https://app.aegisx.com/health
```

---

## 🚨 Emergency Procedures

### Service Down

```bash
# 1. Check service status
docker-compose -f docker-compose.prod.yml ps

# 2. Check logs
docker-compose logs --tail=100 api

# 3. Restart service
docker-compose restart api

# 4. If still down, rollback
/deployment-workflow rollback
```

### Database Issues

```bash
# 1. Check database connectivity
docker exec -it aegisx-db psql -U postgres -c "SELECT 1"

# 2. Check database size
docker exec -it aegisx-db psql -U postgres -c "\l+"

# 3. If corrupted, restore from backup
/db-restore latest
```

### High CPU/Memory

```bash
# 1. Check resource usage
docker stats

# 2. Check application logs for loops
docker-compose logs api | grep ERROR

# 3. Restart service
docker-compose restart api

# 4. If persists, rollback
/deployment-workflow rollback
```

---

**Version**: 1.0.0
**Priority**: CRITICAL
**Estimated Time**: Deploy staging ~15 min, Deploy production ~30 min
