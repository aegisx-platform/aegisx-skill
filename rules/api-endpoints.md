---
paths: apps/api/src/**/*.route.ts
---

# API Endpoint Development Rules

> **See `inventory-domain.md` for complete route examples and plugin patterns**

---

## 🚨 CRITICAL: Fastify Error Handling

### ❌ NEVER throw in preValidation hooks (causes timeout!)

```typescript
// ❌ WRONG - Request will hang!
throw new Error('Unauthorized');

// ✅ CORRECT - Use reply methods
return reply.unauthorized('Missing authorization');
return reply.forbidden('Insufficient permissions');
```

### Reply Methods

| Method                        | Status |
| ----------------------------- | ------ |
| `reply.badRequest()`          | 400    |
| `reply.unauthorized()`        | 401    |
| `reply.forbidden()`           | 403    |
| `reply.notFound()`            | 404    |
| `reply.conflict()`            | 409    |
| `reply.internalServerError()` | 500    |

---

## 🔐 Authentication & Authorization

```typescript
// ✅ CORRECT: Use fastify decorators
preValidation: [
  fastify.authenticate, // NOT authenticate()
  fastify.verifyPermission('drugs', 'create'), // NOT authorize()
];

// ❌ WRONG: Don't call as functions
preValidation: [authenticate(), authorize('drugs')];
```

---

## 📋 Schema Registry

```typescript
import { SchemaRefs } from '../../../../../schemas/registry';

// ✅ CORRECT: Use centralized schemas
response: {
  200: DrugsResponseSchema,
  400: SchemaRefs.ValidationError,
  401: SchemaRefs.Unauthorized,
  403: SchemaRefs.Forbidden,
  404: SchemaRefs.NotFound,
  500: SchemaRefs.ServerError,
}

// ❌ WRONG: Don't define error schemas inline
```

---

## 🔍 TypeBox Validation

```typescript
import { Type } from '@sinclair/typebox';

const Schema = Type.Object({
  // ✅ UUID - MUST have format
  id: Type.String({ format: 'uuid' }),

  // ✅ String - with limits
  name: Type.String({ minLength: 1, maxLength: 255 }),
  code: Type.String({ pattern: '^[A-Z0-9-]+$' }),

  // ✅ Number - with constraints
  quantity: Type.Number({ minimum: 0 }),
  price: Type.Number({ minimum: 0, maximum: 999999999.99 }),

  // ✅ Date
  date: Type.String({ format: 'date' }),

  // ✅ Enum
  status: Type.Union([Type.Literal('active'), Type.Literal('inactive')]),

  // ✅ Optional
  description: Type.Optional(Type.String()),
});
```

---

## 📝 Standard CRUD URLs

```
GET    /api/.../resources           # List
POST   /api/.../resources           # Create
GET    /api/.../resources/:id       # Get one
PUT    /api/.../resources/:id       # Update
DELETE /api/.../resources/:id       # Delete
```

---

## ✅ Quick Checklist

```
[ ] SchemaRefs for error responses
[ ] fastify.authenticate (not authenticate())
[ ] UUID fields have format: 'uuid'
[ ] Return reply methods in hooks (never throw)
[ ] Response schemas match actual data
[ ] Input validation for all fields
```

**Complete examples:** See `inventory-domain.md`
