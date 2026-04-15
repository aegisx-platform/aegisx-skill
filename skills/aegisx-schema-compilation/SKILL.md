---
name: aegisx-schema-compilation
version: 1.0.0
description: >
  AegisX TypeBox schema compilation workflow — MANDATORY `pnpm run build:schemas` after
  modifying any *.schemas.ts file. Without this step, API returns stale schemas or fails.
  Use when editing/creating schemas, after pulling changes, debugging schema-related errors,
  or seeing "FST_ERR_VALIDATION" / missing fields in API response. Triggers on:
  TypeBox, *.schemas.ts, build:schemas, dev:api:fresh, schema compilation, stale schema,
  .compiled folder, Fastify serialization, response schema, missing fields in response,
  schema not updating, FST_ERR_FAILED_ERROR_SERIALIZATION.
---

# AegisX Schema Compilation

## Purpose

AegisX uses TypeBox schemas that must be **pre-compiled** into `.compiled/` before Fastify can use them. Forgetting this step causes:
- Stale validation (old schema in use)
- Missing fields in response (new fields stripped)
- API server fails to start
- `FST_ERR_FAILED_ERROR_SERIALIZATION`

## The Rule

**ALWAYS run `pnpm run build:schemas` after editing ANY `*.schemas.ts` file.**

## Two Commands

### Normal: `build:schemas`
```bash
pnpm run build:schemas
```
Compiles all TypeBox schemas → `.compiled/`. Fast (~5 sec).

Run this:
- After editing any `*.schemas.ts` file
- After creating a new schema file
- Before running `pnpm run dev:api` if schemas changed

### Full reset: `dev:api:fresh`
```bash
pnpm run dev:api:fresh
```
Equivalent to:
```bash
rm -rf .compiled && pnpm run build:schemas && pnpm run dev:api
```

Run this:
- First clone / fresh install
- After major refactor of schemas
- When `build:schemas` misbehaves
- After git branch switch with schema conflicts

## Symptoms of Stale Schemas

| Symptom | Likely Cause |
|---|---|
| API response missing fields you just added | Schema compiled but response schema doesn't include field |
| Validation accepts old fields you removed | `.compiled` has old schema |
| Dev server fails to start | Schema file has syntax error |
| `FST_ERR_VALIDATION` for valid payloads | Request schema strips valid fields |
| `FST_ERR_FAILED_ERROR_SERIALIZATION` | Error schema mismatch |

## Workflow

```
┌─────────────────────────────────────┐
│ Edit MODULE.schemas.ts              │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ pnpm run build:schemas              │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ Restart dev:api (or it's auto)      │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ Test API endpoint                   │
└─────────────────────────────────────┘
```

## When NOT Needed

You do NOT need `build:schemas` after editing:
- `*.route.ts` files (inline route schemas don't use .compiled)
- `*.controller.ts` / `*.service.ts` / `*.repository.ts`
- Frontend files
- Database migrations

## Field Addition Gotcha

When adding a new field, `build:schemas` is necessary but **not sufficient**. You also need:
- Entity/Response schema updated (otherwise Fastify strips from response)
- Create/Update schema updated (otherwise REST can't accept value)
- Route inline body schema updated (for batch endpoints)
- Repository `transformToEntity` + `transformToDb` updated
- Controller `transformCreateSchema` / `transformUpdateSchema` updated

See `.claude/rules/field-addition-checklist.md` for full 5-layer checklist.

## Related Skills

- **typebox-schema-generator** — generate schemas from PostgreSQL
- **fastify-error-debugger** — diagnose schema serialization errors
- **api-contract-validator** — check routes match contracts

## References

- CLAUDE.md section 6 (Schema Compilation CRITICAL)
- `.claude/rules/field-addition-checklist.md`
