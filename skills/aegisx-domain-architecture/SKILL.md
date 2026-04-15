---
name: aegisx-domain-architecture
version: 1.0.0
description: >
  AegisX domain classification — decide whether a module belongs to master-data (lookup/reference)
  or operations (transactional) BEFORE generating CRUD. Also covers Layer Architecture
  (Core/Platform/Domains) for choosing schema and generator flags. MANDATORY before running
  `aegisx-cli generate` or the CRUD generator MCP. Triggers on: generate CRUD, new module,
  new table, new feature, domain classification, master-data vs operations, layer architecture,
  inventory domain, platform schema, core layer, --domain flag, --schema flag, --layer flag.
---

# AegisX Domain Architecture

## Purpose

Prevent misplaced CRUD modules — putting `budgets` in operations (wrong) instead of master-data (right), or putting `hospitals` in a domain schema instead of platform. Correct classification is irreversible without migration rewrite, so it MUST be decided upfront.

## Decision Tree

```
Is this technical infrastructure (auth, logging, cache, session)?
  YES → layer: core          --layer core
  NO  ↓

Is this master data shared across multiple apps (hospitals, departments, users)?
  YES → layer: platform      --layer platform --schema platform
  NO  ↓

This is app-specific (inventory, HR, finance) → layer: domains
      --domain <app>/<subdomain> --schema <app>

Now decide master-data vs operations:
  Does it change rarely + describe "what things are"?  (drugs, locations, units, budget_types)
    → subdomain: master-data  --domain <app>/master-data
  Does it record "what happened" + has dates/status/workflow?  (transactions, allocations, receipts)
    → subdomain: operations   --domain <app>/operations
```

## Golden Rule

**Master-Data** = Lookup/Reference. Configuration. Answers "what exists?"
**Operations** = Transactional. Events. Answers "what happened when?"

## Common Mistakes

| Mistake | Correct |
|---|---|
| ❌ `budgets` in operations | ✅ `budgets` in master-data (it's configuration — amounts per fiscal year) |
| ❌ `hospitals` in inventory domain | ✅ `hospitals` in platform (shared across HR, Finance, Inventory) |
| ❌ `auth_sessions` in domains | ✅ `auth_sessions` in core (technical infrastructure) |
| ❌ `budget_allocations` in master-data | ✅ `budget_allocations` in operations (has workflow, status, dates) |
| ❌ `drug_categories` in operations | ✅ `drug_categories` in master-data (lookup) |

## Section (Frontend) vs Domain (Backend)

They are **independent** — can differ.

```
Backend domain: inventory/master-data
Frontend section: (could be) operations    ← because the UI groups it under budget workflow
```

Check `.claude/rules/learned-patterns-recent.md` for examples.

## Pre-Generation Checklist

Before running CRUD generator:

```bash
# 1. Confirm domain classification
bash /tmp/check_domain.sh TABLE_NAME

# 2. Read related modules to confirm pattern
ls apps/api/src/layers/domains/inventory/master-data/
ls apps/api/src/layers/domains/inventory/operations/

# 3. Build the right command
aegisx_crud_build_command {
  tableName: "...",
  domain: "inventory/master-data",    # or "inventory/operations"
  schema: "inventory",
  layer: "domains"                     # or "core" / "platform"
}
```

## Related Skills

- **unified-crud-validator** — runs classification + validation automatically
- **layer-architecture-validator** — validates correct layer before generation
- **crud-generator-guide** — high-level CRUD generator usage
- **aegisx-cli-library** — CLI reference

## References

- `docs/architecture/domain-architecture-guide.md` (full Thai guide)
- `docs/architecture/quick-domain-reference.md` (quick lookup)
- `libs/aegisx-cli/docs/LAYER_ARCHITECTURE.md` (layer details)
