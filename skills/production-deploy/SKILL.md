---
name: production-deploy
version: 1.0.0
description: >
  AegisX production deployment via Docker images (no source code needed on server) and
  dev fresh install via `production-install.sh --fresh`. Covers one-command install,
  environment setup, migration + seed order, and rollback. Use when deploying to
  production/staging, doing a clean dev reset, or debugging installation failures.
  Triggers on: production install, production-install.sh, --fresh, fresh install,
  clean install, deployment, docker deploy, deploy/install.sh, NODE_ENV=production,
  GITHUB_TOKEN, one-command install.
---

# AegisX Production Deployment

## Purpose

Deploy AegisX to production servers **without shipping source code** — server only pulls Docker images. Also covers the "fresh install" dev reset workflow.

## Two Install Modes

### 1. Production (server, no source)

```bash
# On production server
bash deploy/install.sh --github-token "$GITHUB_TOKEN"
```

Pulls Docker images from GHCR, runs migrations + seeds, starts containers. See `deploy/README.md`.

### 2. Dev Fresh Reset (wipe everything, start clean)

```bash
# Inside monorepo
bash scripts/production-install.sh --fresh
```

Equivalent to manual:
```bash
docker compose down -v                      # Remove all volumes
docker compose up -d                        # Restart infrastructure
pnpm run db:migrate                         # Main system (77 migrations)
docker exec aegisx_postgres psql -U postgres -d aegisx_db \
  -c "CREATE SCHEMA IF NOT EXISTS inventory;"
pnpm run db:migrate:inventory               # Inventory (269 migrations)
pnpm run db:seed                            # All seeds
```

## Critical: NODE_ENV Seeds Protection

```
NEVER: Run `db:seed` or `db:seed:inventory` in production without NODE_ENV=production
ALWAYS: Use `bash scripts/production-install.sh --fresh` for dev resets
        — handles NODE_ENV automatically
```

Production seeds are **different** from dev seeds (no demo users, no sample data). The check:
```typescript
if (process.env.NODE_ENV !== 'production') {
  // Dev-only seeds: demo users, sample drugs, etc.
}
```

## Install Flow (Verified 2026-03-10)

```
Step 1: Infrastructure
┌────────────────────────────────────┐
│ docker compose up -d               │
│ Wait for PostgreSQL + Redis health │
└────────────────────────────────────┘
Step 2: Main System (public schema)
┌────────────────────────────────────┐
│ pnpm run db:migrate  (77 files)    │
└────────────────────────────────────┘
Step 3: Inventory Schema
┌────────────────────────────────────┐
│ CREATE SCHEMA IF NOT EXISTS        │
│ pnpm run db:migrate:inventory      │
│ (269 files)                        │
└────────────────────────────────────┘
Step 4: Seed All
┌────────────────────────────────────┐
│ pnpm run db:seed                   │
│ 18 files: users, nav, RBAC,        │
│ geography, TMT drug catalog        │
└────────────────────────────────────┘
Step 5: Start Servers
┌────────────────────────────────────┐
│ pnpm run dev:api:fresh             │
│   (first run: compile + start)     │
│ pnpm run dev:web                   │
│ Or: pnpm run dev (both)            │
└────────────────────────────────────┘
```

## Rollback Strategy

### Dev rollback
```bash
# Last migration only
pnpm run db:rollback

# To specific migration
pnpm run db:migrate:down --to 20260301120000
```

### Production rollback
1. Stop new containers
2. Restore previous image tag in `docker-compose.prod.yml`
3. If DB migrations need rollback: run migration:down BEFORE downgrading image
4. Restart containers

## Common Issues

| Symptom | Fix |
|---|---|
| `relation "X" does not exist` | Missed `db:migrate:inventory` step |
| No inventory tables visible | Missed `CREATE SCHEMA inventory` step |
| Seed fails with FK error | Seed order wrong — run `db:seed` not individual files |
| `.env` missing | Copy `.env.example` → `.env`, fill in secrets |
| Docker postgres healthy but migration fails | Wait for healthy state before migrating |

## Environment Variables (required)

```bash
# apps/api/.env
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/aegisx_db
REDIS_URL=redis://localhost:6379
JWT_SECRET=<strong-secret>
JWT_REFRESH_SECRET=<different-strong-secret>
NODE_ENV=production   # or development

# For Docker image pull
GITHUB_TOKEN=<ghp_...>   # deploy/install.sh reads this
```

## Related Skills

- **aegisx-multi-schema-db** — schema creation + migration details
- **database-management** — migration/seed commands
- **docker-patterns** (curated) — Docker Compose patterns
- **deployment-patterns** (curated) — general CI/CD patterns

## References

- `scripts/production-install.sh` (source)
- `deploy/install.sh` + `deploy/README.md` (prod deploy)
- `docker-compose.yml` + `docker-compose.prod.yml`
- CLAUDE.md "Clean Install Flow" section
