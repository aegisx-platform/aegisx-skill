# Security Best Practices

> Human-readable guide for implementing secure APIs in the AegisX platform

## Overview

This guide provides practical security patterns for building secure REST APIs in the AegisX platform. It covers authentication, authorization, input validation, and protection against common vulnerabilities.

## Quick Start

### Most Important Rules

1. **NEVER throw errors in `preValidation` hooks** - Use `return reply.unauthorized()` instead
2. **ALWAYS use TypeBox schemas** - Validate all input at route level
3. **ALWAYS check authorization** - Not just authentication
4. **NEVER return sensitive data** - Exclude passwords, tokens, etc.

### Common Security Tasks

#### Protect a Route with Authentication

```typescript
fastify.get('/profile', {
  preValidation: [fastify.authenticate],
  schema: {
    security: [{ bearerAuth: [] }],
    response: { 200: ProfileResponseSchema },
  },
  handler: async (req, reply) => {
    // req.user is available
    const profile = await getProfile(req.user.id);
    return reply.success(profile);
  },
});
```

#### Protect a Route with Role-Based Access

```typescript
fastify.post('/admin/settings', {
  preValidation: [fastify.authenticate, fastify.verifyRole(['admin'])],
  handler: async (req, reply) => {
    // Only admins can access
  },
});
```

#### Protect a Route with Permissions

```typescript
fastify.delete('/users/:id', {
  preValidation: [fastify.authenticate, fastify.verifyPermission('users', 'delete')],
  handler: async (req, reply) => {
    // Only users with 'users:delete' permission
  },
});
```

#### Validate User Input

```typescript
const CreateUserSchema = Type.Object({
  email: Type.String({ format: 'email' }),
  username: Type.String({
    minLength: 3,
    maxLength: 50,
    pattern: '^[a-zA-Z0-9_-]+$',
  }),
  password: Type.String({ minLength: 8 }),
});

fastify.post('/users', {
  schema: {
    body: CreateUserSchema,
  },
  handler: async (req, reply) => {
    // req.body is validated and typed
    const user = await createUser(req.body);
    return reply.success(user);
  },
});
```

## OWASP Top 10 Quick Reference

### 1. SQL Injection - PROTECTED

**How:** Knex query builder automatically uses parameterized queries

```typescript
// Safe - Knex handles parameterization
await knex('users').where('email', userInput);

// Also safe - Named parameters
await knex.raw('SELECT * FROM users WHERE email = :email', { email: userInput });

// Dangerous - Avoid!
await knex.raw(`SELECT * FROM users WHERE email = '${userInput}'`);
```

### 2. XSS (Cross-Site Scripting)

**How:** Validate input with TypeBox, sanitize output on frontend

```typescript
// Validate at API level
const CommentSchema = Type.Object({
  text: Type.String({ maxLength: 500 }),
  author: Type.String({ pattern: '^[a-zA-Z0-9 ]+$' }),
});

// Angular escapes by default
// <div>{{ userComment }}</div> - Safe
// [innerHTML]="userComment" - Needs sanitization
```

### 3. Authentication

**How:** Use JWT + preValidation hooks

```typescript
// Protected route
fastify.get('/profile', {
  preValidation: [fastify.authenticate],
  handler: async (req, reply) => {
    // req.user is populated
  },
});

// Check deleted users (built into verifyJWT)
// Checks user.deleted_at automatically
```

### 4. Authorization

**How:** Role and permission checks

```typescript
// Role-based
preValidation: [fastify.authenticate, fastify.verifyRole(['admin', 'manager'])];

// Permission-based
preValidation: [fastify.authenticate, fastify.verifyPermission('users', 'delete')];

// Resource ownership
preValidation: [fastify.authenticate, fastify.verifyOwnership('id')];
```

### 5. Sensitive Data Exposure

**How:** Exclude sensitive fields

```typescript
// In repository
async findById(id: string) {
  return this.query()
    .select(['id', 'email', 'username', 'first_name', 'last_name'])
    // DON'T select: password, password_hash, reset_token
    .where('id', id)
    .first();
}

// In schema
const UserResponseSchema = Type.Object({
  id: Type.String({ format: 'uuid' }),
  email: Type.String({ format: 'email' }),
  // password NOT included
});
```

## Critical Security Patterns

### Pattern 1: preValidation Hook Error Handling

**CRITICAL: This is the #1 cause of request timeouts!**

```typescript
// WRONG - Request will hang
fastify.decorate('authenticate', async (req, reply) => {
  if (!req.headers.authorization) {
    throw new Error('No token'); // DON'T DO THIS!
  }
});

// CORRECT - Always return reply methods
fastify.decorate('authenticate', async (req, reply) => {
  if (!req.headers.authorization) {
    return reply.unauthorized('No token');
  }

  try {
    await req.jwtVerify();
  } catch (err) {
    return reply.unauthorized('Invalid token');
  }
});
```

**Why?** Fastify's preValidation hooks expect proper reply handling. Throwing errors bypasses the reply mechanism and causes the request to timeout.

### Pattern 2: Input Validation at Route Level

```typescript
// ALWAYS define schema
fastify.post('/users', {
  schema: {
    body: CreateUserSchema, // Validates body
    params: UuidParamSchema, // Validates URL params
    querystring: QuerySchema, // Validates query params
    response: {
      200: UserResponseSchema, // Type-safe response
      400: ValidationErrorSchema, // Validation errors
    },
  },
  handler: async (req, reply) => {
    // req.body, req.params, req.query are validated and typed
  },
});
```

### Pattern 3: Layered Authorization

```typescript
fastify.put('/documents/:id', {
  preValidation: [fastify.authenticate],
  handler: async (req, reply) => {
    const document = await documentService.findById(req.params.id);

    if (!document) {
      return reply.notFound();
    }

    // Check multiple authorization criteria
    const isOwner = document.created_by === req.user.id;
    const hasPermission = req.user.permissions.includes('documents:edit_all');
    const isSharedWith = document.shared_with?.includes(req.user.id);

    if (!isOwner && !hasPermission && !isSharedWith) {
      return reply.forbidden('Cannot edit this document');
    }

    // Authorized - proceed
    const updated = await documentService.update(req.params.id, req.body);
    return reply.success(updated);
  },
});
```

## Common TypeBox Validation Patterns

### String Validation

```typescript
// Email
Type.String({ format: 'email' });

// Username
Type.String({
  minLength: 3,
  maxLength: 50,
  pattern: '^[a-zA-Z0-9_-]+$',
});

// Phone number (E.164)
Type.String({ pattern: '^\\+?[1-9]\\d{1,14}$' });

// URL
Type.String({ format: 'uri' });

// UUID
Type.String({ format: 'uuid' });

// Date-time
Type.String({ format: 'date-time' });
```

### Number Validation

```typescript
// Age
Type.Number({ minimum: 0, maximum: 150 });

// Price (allows cents)
Type.Number({ minimum: 0, multipleOf: 0.01 });

// Quantity (integers only)
Type.Integer({ minimum: 1 });
```

### Enum Validation

```typescript
Type.Union([Type.Literal('active'), Type.Literal('inactive'), Type.Literal('suspended')]);
```

### Array Validation

```typescript
Type.Array(Type.String(), {
  minItems: 1,
  maxItems: 10,
  uniqueItems: true,
});
```

## Security Checklist

Before deploying any endpoint:

### Authentication & Authorization

- [ ] Public routes are intentionally public
- [ ] Protected routes use `preValidation: [fastify.authenticate]`
- [ ] Admin routes use `fastify.verifyRole(['admin'])`
- [ ] No errors thrown in preValidation (use `return reply.*()`)

### Input Validation

- [ ] All routes have schema validation
- [ ] Body, params, querystring validated
- [ ] UUID fields use `format: 'uuid'`
- [ ] Email fields use `format: 'email'`
- [ ] Strings have `minLength` and `maxLength`
- [ ] Numbers have `minimum` and `maximum`

### Data Security

- [ ] Passwords never returned
- [ ] Sensitive fields excluded from SELECT
- [ ] Response schemas exclude sensitive data
- [ ] No sensitive data in logs

### Database Security

- [ ] Using Knex query builder
- [ ] No raw SQL with string concatenation
- [ ] Raw queries use parameter bindings

## Quick Tips

### Tip 1: Use Existing Auth Decorators

```typescript
// These are available globally via auth.strategies.ts
fastify.authenticate; // JWT verification
fastify.verifyRole([roles]); // Role check
fastify.verifyPermission(r, a); // Permission check
fastify.verifyOwnership(param); // Resource ownership
```

### Tip 2: Stack Multiple Validations

```typescript
preValidation: [
  fastify.authenticate, // Step 1: Verify JWT
  fastify.verifyRole(['admin']), // Step 2: Check role
  fastify.verifyPermission('users', 'delete'), // Step 3: Check permission
];
```

### Tip 3: Use Base Schemas

```typescript
import {
  ApiSuccessResponseSchema,
  ValidationErrorResponseSchema,
  UnauthorizedResponseSchema,
  ForbiddenResponseSchema,
  NotFoundResponseSchema,
  ServerErrorResponseSchema,
} from '../../schemas/base.schemas';

// Standard response structure
response: {
  200: ApiSuccessResponseSchema(YourDataSchema),
  400: ValidationErrorResponseSchema,
  401: UnauthorizedResponseSchema,
  403: ForbiddenResponseSchema,
  404: NotFoundResponseSchema,
  500: ServerErrorResponseSchema,
}
```

### Tip 4: Validate Business Logic in Service Layer

```typescript
// Service layer validation
protected async validateCreate(data: CreateProduct): Promise<void> {
  // Check unique constraints
  const existing = await this.repository.findBySku(data.sku);
  if (existing) {
    throw new AppError('SKU already exists', 409, 'SKU_EXISTS');
  }

  // Check business rules
  if (data.price < 0) {
    throw new AppError('Price cannot be negative', 400, 'INVALID_PRICE');
  }
}
```

## Common Mistakes to Avoid

1. **Throwing errors in preValidation** - Always use `return reply.*()` methods
2. **Skipping input validation** - All routes need schemas
3. **Only checking authentication** - Also check authorization
4. **Returning sensitive data** - Explicitly select safe fields
5. **Weak password validation** - Minimum 8 characters
6. **Logging sensitive data** - Never log passwords or tokens
7. **Not validating UUIDs** - Use `format: 'uuid'` in schemas

## Reference Implementation

See these files for examples:

- **Auth strategies:** `apps/api/src/layers/core/auth/strategies/auth.strategies.ts`
- **Auth schemas:** `apps/api/src/layers/core/auth/auth.schemas.ts`
- **Protected routes:** `apps/api/src/layers/platform/user-profile/routes/profile.routes.ts`
- **Base repository:** `apps/api/src/shared/repositories/base.repository.ts`

## Need More Detail?

- See `SKILL.md` for complete security patterns and detailed examples
- See `REFERENCE.md` for quick security checklist
- See `/docs/reference/api/typebox-schema-standard.md` for TypeBox patterns
