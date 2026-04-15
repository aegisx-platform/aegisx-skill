---
name: aegisx-auth-rbac
version: 1.0.0
description: >
  AegisX authentication and RBAC — JWT strategies, 8 system accounts, role hierarchy,
  Fastify preValidation hooks (CRITICAL: never throw), permission checks, protected routes.
  Use when implementing auth, adding RBAC to a new module, debugging 401/403, or writing
  login/logout flows. Triggers on: auth, authentication, JWT, RBAC, roles, permissions,
  preValidation, login, logout, protected routes, inventory-admin, system admin,
  aegisx-auth, *:* permission, 401, 403, forbidden, unauthorized, fastify auth hook.
---

# AegisX Auth & RBAC

## Purpose

Ensure consistent authentication and authorization across all AegisX routes. Prevent common bugs like request timeouts from thrown errors in preValidation hooks, or accidentally exposing endpoints without auth.

## Critical Rules

### 1. NEVER throw in preValidation hooks

```typescript
// ❌ WRONG — request hangs / timeout
fastify.addHook('preValidation', async (req, reply) => {
  if (!valid) throw new Error('Unauthorized');
});

// ✅ CORRECT — use reply.unauthorized() or reply.forbidden()
fastify.addHook('preValidation', async (req, reply) => {
  if (!valid) return reply.unauthorized();
  if (!hasPermission) return reply.forbidden();
});
```

See `apps/api/src/core/auth/strategies/auth.strategies.ts` for reference.

### 2. Every protected route uses authPreHandler

```typescript
fastify.get('/inventory/drugs', {
  preHandler: [fastify.authenticate, fastify.authorize('inventory-admin', 'inventory-pharmacist')],
  schema: { ... }
}, handler);
```

### 3. Permission format: `<domain>:<action>` or `*:*`

```
*:*                              # System admin (full access)
inventory:*                      # All inventory actions
inventory:read                   # Read-only inventory
inventory.master-data:write      # Can edit inventory master data
```

## System Accounts (Dev)

| Email | Password | Role | Scope |
|---|---|---|---|
| admin@aegisx.local | Admin123! | system-admin | `*:*` (everything) |
| manager@aegisx.local | Manager123! | manager | Limited management |
| demo@aegisx.local | Demo123! | user | Basic user |
| inventory@aegisx.local | Inventory123! | inventory-admin | All inventory |
| procurement@aegisx.local | Procurement123! | inventory-procurement | PR/PO workflow |
| budget@aegisx.local | Budget123! | inventory-budget | Budget module |
| warehouse@aegisx.local | Warehouse123! | inventory-main-warehouse | Main warehouse |
| subwarehouse@aegisx.local | SubWarehouse123! | inventory-sub-warehouse | Sub warehouses |
| report@aegisx.local | Report123! | inventory-report | Reports read |
| masterdata@aegisx.local | MasterData123! | inventory-master-data | Master data edit |
| pharmacist@aegisx.local | Pharmacist123! | inventory-pharmacist | Dispensing |

## Role Selection Decision Tree

```
Who can see/edit this resource?
├─ All inventory staff       → inventory:read (view) / inventory:write (edit)
├─ Only procurement team     → inventory-procurement
├─ Only budget team          → inventory-budget
├─ Only warehouse staff      → inventory-main-warehouse OR inventory-sub-warehouse
├─ Only pharmacists          → inventory-pharmacist
├─ Master data only          → inventory-master-data
└─ Reports only (read)       → inventory-report
```

## Adding Auth to New Route

```typescript
// 1. Import auth preHandler from core
import { authenticate, authorize } from '@core/auth';

// 2. Wrap route with auth
fastify.register(async (instance) => {
  instance.addHook('preHandler', authenticate);

  // Role-specific routes
  instance.get('/admin-only', {
    preHandler: authorize('inventory-admin'),
  }, handler);

  // Multiple roles accepted
  instance.get('/budget-or-admin', {
    preHandler: authorize('inventory-admin', 'inventory-budget'),
  }, handler);
});
```

## Debugging 401 / 403

| Symptom | Likely Cause |
|---|---|
| 401 Unauthorized | Missing JWT, expired token, or invalid signature |
| 403 Forbidden | Valid JWT but role lacks permission |
| Request hangs (timeout) | `throw` in preValidation — change to `return reply.unauthorized()` |
| Always 403 even as admin | Permission check typo (`inventory:*` vs `inventory-*`) |

## Related Skills

- **security-best-practices** — broader security (input validation, secrets)
- **fastify-error-debugger** — error serialization issues
- **api-contract-validator** — validate route has auth preHandler

## References

- `apps/api/src/core/auth/strategies/auth.strategies.ts`
- `apps/api/src/database/seeds/` (role/permission seeds)
- CLAUDE.md section 7 (Fastify preValidation critical rule)
