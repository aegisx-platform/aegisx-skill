# Security Best Practices - Quick Reference

> Quick security checklist and reference patterns

## Quick Security Checklist

### Before Deploying Any Endpoint

#### Authentication & Authorization

- [ ] Public routes are intentionally public (no auth required)
- [ ] Protected routes use `preValidation: [fastify.authenticate]`
- [ ] Admin routes use `fastify.verifyRole(['admin', ...])`
- [ ] Permission-based routes use `fastify.verifyPermission(resource, action)`
- [ ] Resource ownership verified when needed (`fastify.verifyOwnership()`)
- [ ] **CRITICAL:** No errors thrown in preValidation (use `return reply.*()`)

#### Input Validation

- [ ] All routes have TypeBox schema validation
- [ ] Body validated with schema
- [ ] Query parameters validated with schema
- [ ] URL params validated with schema
- [ ] UUID fields use `format: 'uuid'`
- [ ] Email fields use `format: 'email'`
- [ ] String fields have `minLength` and `maxLength`
- [ ] Number fields have `minimum` and `maximum`
- [ ] Arrays have `minItems` and `maxItems`
- [ ] Enums use `Type.Union([Type.Literal(...)])`

#### Data Security

- [ ] Password fields never returned in responses
- [ ] Sensitive fields excluded from SELECT queries
- [ ] Response schemas don't include sensitive data (tokens, hashes)
- [ ] Passwords are hashed (bcrypt/argon2)
- [ ] Tokens stored securely (not in localStorage)
- [ ] No sensitive data in logs (passwords, tokens, credit cards)

#### Database Security

- [ ] All queries use Knex query builder
- [ ] No raw SQL with string concatenation
- [ ] Raw queries use parameter bindings (`:param` syntax)
- [ ] UUIDs validated before queries
- [ ] Soft deletes check `deleted_at` field

#### Error Handling

- [ ] No sensitive data in error messages
- [ ] Generic error messages for auth failures
- [ ] Detailed errors only in development
- [ ] All errors logged properly
- [ ] No stack traces in production responses

#### Business Logic Security

- [ ] Business validations in service layer
- [ ] Rate limiting on authentication endpoints
- [ ] Account lockout after failed login attempts
- [ ] Email verification for new accounts
- [ ] Password reset tokens expire (15-60 minutes)
- [ ] Audit logging for sensitive operations

## Critical Security Rules

### Rule 1: NEVER Throw Errors in preValidation

```typescript
// WRONG - Request hangs
preValidation: [
  async (req, reply) => {
    if (!valid) throw new Error('Invalid'); // DON'T!
  },
];

// CORRECT - Return reply method
preValidation: [
  async (req, reply) => {
    if (!valid) return reply.unauthorized('Invalid');
  },
];
```

### Rule 2: ALWAYS Use TypeBox Schemas

```typescript
// WRONG
fastify.post('/users', async (req, reply) => {
  // No validation!
});

// CORRECT
fastify.post('/users', {
  schema: { body: CreateUserSchema },
  handler: async (req, reply) => {
    // Validated!
  },
});
```

### Rule 3: Check Authorization, Not Just Authentication

```typescript
// WRONG - Any authenticated user can delete
preValidation: [fastify.authenticate];

// CORRECT - Only authorized users
preValidation: [fastify.authenticate, fastify.verifyPermission('users', 'delete')];
```

### Rule 4: Never Return Sensitive Data

```typescript
// WRONG
select('*'); // Includes password_hash!

// CORRECT
select(['id', 'email', 'username', 'first_name', 'last_name']);
```

## Quick Reference Patterns

### Authentication Patterns

```typescript
// Public route (no auth)
fastify.post('/auth/login', {
  schema: { body: LoginSchema },
  handler: async (req, reply) => { ... },
});

// Authenticated route
fastify.get('/profile', {
  preValidation: [fastify.authenticate],
  handler: async (req, reply) => {
    // req.user is available
  },
});

// Role-based access
fastify.post('/admin/settings', {
  preValidation: [
    fastify.authenticate,
    fastify.verifyRole(['admin', 'super_admin']),
  ],
  handler: async (req, reply) => { ... },
});

// Permission-based access
fastify.delete('/users/:id', {
  preValidation: [
    fastify.authenticate,
    fastify.verifyPermission('users', 'delete'),
  ],
  handler: async (req, reply) => { ... },
});

// Resource ownership
fastify.get('/profile/:id', {
  preValidation: [
    fastify.authenticate,
    fastify.verifyOwnership('id'), // Checks req.params.id === req.user.id
  ],
  handler: async (req, reply) => { ... },
});
```

### TypeBox Validation Patterns

```typescript
// Email
Type.String({ format: 'email', maxLength: 255 });

// Username
Type.String({
  minLength: 3,
  maxLength: 50,
  pattern: '^[a-zA-Z0-9_-]+$',
});

// Password
Type.String({ minLength: 8, maxLength: 128 });

// UUID
Type.String({ format: 'uuid' });

// Phone (E.164)
Type.String({ pattern: '^\\+?[1-9]\\d{1,14}$' });

// URL
Type.String({ format: 'uri' });

// Date/Time
Type.String({ format: 'date-time' });

// Number (with range)
Type.Number({ minimum: 0, maximum: 100 });

// Integer
Type.Integer({ minimum: 1 });

// Price (with decimals)
Type.Number({ minimum: 0, multipleOf: 0.01 });

// Enum
Type.Union([Type.Literal('active'), Type.Literal('inactive'), Type.Literal('suspended')]);

// Array
Type.Array(Type.String(), {
  minItems: 1,
  maxItems: 10,
  uniqueItems: true,
});

// Optional field
Type.Optional(Type.String());

// Nested object
Type.Object({
  name: Type.String(),
  address: Type.Object({
    street: Type.String(),
    city: Type.String(),
  }),
});
```

### Database Security Patterns

```typescript
// SAFE - Parameterized query
await knex('users').where('email', email).first();

// SAFE - Named parameters
await knex.raw('SELECT * FROM users WHERE email = :email', { email });

// DANGEROUS - Avoid!
await knex.raw(`SELECT * FROM users WHERE email = '${email}'`);

// Exclude sensitive fields
await knex('users').select(['id', 'email', 'username', 'first_name', 'last_name']).where('id', id);

// Check soft delete
await knex('users').where('id', id).whereNull('deleted_at').first();
```

### Error Handling Patterns

```typescript
// In preValidation hooks
if (!valid) {
  return reply.unauthorized('Invalid credentials');
}

// In route handlers
if (!resource) {
  return reply.notFound('Resource not found');
}

if (!hasPermission) {
  return reply.forbidden('Insufficient permissions');
}

// Generic error for security
try {
  await processPayment(data);
} catch (error) {
  fastify.log.error({ userId: req.user.id }, 'Payment failed');
  return reply.serverError('Payment processing failed');
}
```

## OWASP Top 10 Quick Prevention

| Vulnerability                                   | Prevention                                              |
| ----------------------------------------------- | ------------------------------------------------------- |
| **SQL Injection**                               | Use Knex query builder with parameterized queries       |
| **XSS**                                         | Validate input with TypeBox, Angular escapes by default |
| **Broken Auth**                                 | JWT with `fastify.authenticate`, check `deleted_at`     |
| **Broken Access Control**                       | Always check authorization, not just authentication     |
| **Security Misconfiguration**                   | Secure defaults, no debug in production                 |
| **Sensitive Data Exposure**                     | Exclude password/tokens from responses                  |
| **Insufficient Logging**                        | Log auth failures, access violations                    |
| **Injection**                                   | Use ORM/query builder, validate all input               |
| **Using Components with Known Vulnerabilities** | `pnpm audit`, keep dependencies updated                 |
| **Insufficient Monitoring**                     | Request logging, error tracking, audit trails           |

## Response Status Codes

```typescript
// Success
reply.success(data); // 200 OK

// Client errors
reply.badRequest(message); // 400 Bad Request
reply.unauthorized(message); // 401 Unauthorized
reply.forbidden(message); // 403 Forbidden
reply.notFound(message); // 404 Not Found
reply.conflict(message); // 409 Conflict

// Server errors
reply.serverError(message); // 500 Internal Server Error
```

## Available Auth Decorators

```typescript
// JWT verification
fastify.authenticate;

// Role-based access
fastify.verifyRole(['admin', 'user']);

// Permission-based access
fastify.verifyPermission('resource', 'action');

// Resource ownership
fastify.verifyOwnership('paramName');

// Alias for verifyRole
fastify.authorize(['admin']);
```

## Common Validation Schemas

```typescript
import { ApiSuccessResponseSchema, ValidationErrorResponseSchema, UnauthorizedResponseSchema, ForbiddenResponseSchema, NotFoundResponseSchema, ServerErrorResponseSchema, PaginationQuerySchema, SearchQuerySchema, UuidParamSchema } from '../../schemas/base.schemas';
```

## Security Testing Checklist

### Manual Testing

- [ ] Try accessing protected routes without auth token
- [ ] Try accessing admin routes as regular user
- [ ] Try accessing other users' resources
- [ ] Try sending malformed input (missing fields, wrong types)
- [ ] Try sending XSS payloads in text fields
- [ ] Try sending SQL injection in search fields
- [ ] Try sending very long strings (buffer overflow)
- [ ] Try sending negative numbers where not allowed
- [ ] Try accessing deleted resources

### Automated Testing

- [ ] Unit tests for validation logic
- [ ] Integration tests for auth flows
- [ ] Tests for authorization checks
- [ ] Tests for input validation
- [ ] Tests for error handling

## Common Vulnerability Patterns

### Pattern: Missing Authorization Check

```typescript
// VULNERABLE
fastify.delete('/users/:id', {
  preValidation: [fastify.authenticate],
  handler: async (req, reply) => {
    // Any authenticated user can delete any user!
    await deleteUser(req.params.id);
  },
});

// SECURE
fastify.delete('/users/:id', {
  preValidation: [fastify.authenticate, fastify.verifyPermission('users', 'delete')],
  handler: async (req, reply) => {
    await deleteUser(req.params.id);
  },
});
```

### Pattern: Sensitive Data Exposure

```typescript
// VULNERABLE
async findById(id: string) {
  return this.query().select('*').where('id', id).first();
  // Returns password_hash, reset_token, etc.
}

// SECURE
async findById(id: string) {
  return this.query()
    .select(['id', 'email', 'username', 'first_name', 'last_name'])
    .where('id', id)
    .first();
}
```

### Pattern: Missing Input Validation

```typescript
// VULNERABLE
fastify.post('/users', async (req, reply) => {
  const user = await createUser(req.body);
  // No validation - dangerous!
});

// SECURE
fastify.post('/users', {
  schema: {
    body: Type.Object({
      email: Type.String({ format: 'email' }),
      username: Type.String({ minLength: 3, maxLength: 50 }),
      password: Type.String({ minLength: 8 }),
    }),
  },
  handler: async (req, reply) => {
    const user = await createUser(req.body);
  },
});
```

### Pattern: Logging Sensitive Data

```typescript
// VULNERABLE
fastify.log.info({ user: req.body }, 'User registration');
// Logs password!

// SECURE
fastify.log.info(
  {
    email: req.body.email,
    username: req.body.username,
  },
  'User registration',
);
```

## Security Headers (Configured in Fastify)

The platform automatically sets these security headers:

- `X-Frame-Options: DENY` - Prevent clickjacking
- `X-Content-Type-Options: nosniff` - Prevent MIME sniffing
- `X-XSS-Protection: 1; mode=block` - XSS filter
- `Strict-Transport-Security` - Force HTTPS
- `Content-Security-Policy` - Restrict resource loading

## Password Security

### Hashing

```typescript
import bcrypt from 'bcrypt';

// Hash password
const hash = await bcrypt.hash(password, 10);

// Verify password
const isValid = await bcrypt.compare(password, hash);
```

### Validation

```typescript
const PasswordSchema = Type.String({
  minLength: 8,
  maxLength: 128,
  description: 'Password (minimum 8 characters)',
});

// Additional validation in service layer
protected async validatePassword(password: string): Promise<void> {
  if (password.length < 8) {
    throw new AppError('Password too short', 400);
  }

  const hasUpperCase = /[A-Z]/.test(password);
  const hasLowerCase = /[a-z]/.test(password);
  const hasNumber = /[0-9]/.test(password);
  const hasSpecialChar = /[!@#$%^&*]/.test(password);

  if (!(hasUpperCase && hasLowerCase && hasNumber && hasSpecialChar)) {
    throw new AppError(
      'Password must contain uppercase, lowercase, number, and special character',
      400
    );
  }
}
```

## Reference Files

```
apps/api/src/layers/core/auth/strategies/auth.strategies.ts
  - Auth decorators (authenticate, verifyRole, verifyPermission)
  - CRITICAL: Shows correct preValidation patterns

apps/api/src/layers/core/auth/auth.schemas.ts
  - Auth schemas (login, register, password reset)

apps/api/src/layers/platform/user-profile/routes/profile.routes.ts
  - Example authenticated routes

apps/api/src/shared/repositories/base.repository.ts
  - Safe database query patterns

docs/reference/api/typebox-schema-standard.md
  - Complete TypeBox validation guide
```

## Quick Tips

1. **Start with authentication** - Add `preValidation: [fastify.authenticate]` first
2. **Add authorization** - Then add role/permission checks
3. **Validate everything** - Use TypeBox schemas for all input
4. **Exclude sensitive data** - Explicitly select safe fields
5. **Use reply methods** - Never throw in preValidation hooks
6. **Log security events** - Track auth failures and access violations
7. **Test authorization** - Try accessing as different user types
8. **Review regularly** - Security is ongoing, not one-time

## Emergency Security Fixes

If you discover a security vulnerability:

1. **Assess severity** - Is data exposed? Can attackers exploit it?
2. **Fix immediately** - Don't wait for next sprint
3. **Test thoroughly** - Verify fix doesn't break functionality
4. **Audit similar code** - Look for same pattern elsewhere
5. **Document lesson** - Update this guide if needed
6. **Inform team** - Share learning with other developers
