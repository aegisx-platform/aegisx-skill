---
name: security-best-practices
description: Security best practices for the AegisX platform. Use when implementing authentication, authorization, input validation, or reviewing code for security vulnerabilities. Covers OWASP Top 10 basics, TypeBox validation patterns, and Fastify preValidation hooks.
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# Security Best Practices

Comprehensive security guide for implementing secure APIs in the AegisX platform.

## When Claude Should Use This Skill

- User asks about "security", "authentication", "authorization", "permissions", or "validation"
- User requests security review or security audit of code
- User mentions OWASP, SQL injection, XSS, CSRF, or other security vulnerabilities
- User needs to implement protected routes or role-based access control
- User asks about input validation, sanitization, or data validation
- User needs to add authentication to existing endpoints
- User mentions JWT, tokens, or session management

## Critical Security Rules

### RULE 1: NEVER Throw Errors in preValidation Hooks

**THIS IS CRITICAL - REQUEST WILL HANG IF VIOLATED!**

```typescript
// WRONG - Request will hang indefinitely
fastify.decorate('authenticate', async function (request, reply) {
  if (!request.headers.authorization) {
    throw new Error('No token'); // DON'T DO THIS!
  }
});

// CORRECT - Always return reply methods
fastify.decorate('authenticate', async function (request, reply) {
  if (!request.headers.authorization) {
    return reply.unauthorized('No token'); // Use reply methods
  }
});
```

**Why?** Fastify's preValidation hooks expect proper reply handling. Throwing errors bypasses the reply mechanism and causes the request to timeout.

**Reference:** See `apps/api/src/layers/core/auth/strategies/auth.strategies.ts` for correct patterns.

### RULE 2: All Routes MUST Use TypeBox Schemas

```typescript
// CORRECT - TypeBox validation at route level
fastify.post('/', {
  schema: {
    body: CreateUserSchema,
    response: {
      200: UserResponseSchema,
      400: ValidationErrorResponseSchema,
    },
  },
  handler: async (req, reply) => {
    // req.body is validated and typed
    const user = await createUser(req.body);
    return reply.success(user);
  },
});

// WRONG - No validation
fastify.post('/', async (req, reply) => {
  // req.body is not validated - dangerous!
  const user = await createUser(req.body);
});
```

**Why?** TypeBox provides runtime validation AND type safety. It prevents malformed data from reaching your business logic.

## OWASP Top 10 Prevention Basics

### 1. SQL Injection Prevention

**Status:** PROTECTED by default via Knex query builder

```typescript
// SAFE - Knex uses parameterized queries
async findByEmail(email: string) {
  return this.knex('users')
    .where('email', email) // Automatically parameterized
    .first();
}

// ALSO SAFE - Named bindings
async findByStatus(status: string) {
  return this.knex.raw(
    'SELECT * FROM users WHERE status = :status',
    { status } // Named parameters prevent injection
  );
}

// DANGEROUS - Avoid raw SQL without bindings
async dangerousQuery(input: string) {
  // DON'T DO THIS
  return this.knex.raw(`SELECT * FROM users WHERE name = '${input}'`);
}
```

**Key Points:**

- Use Knex query builder methods (`.where()`, `.select()`, etc.)
- If using `.raw()`, ALWAYS use parameter bindings
- Never concatenate user input into SQL strings

### 2. Cross-Site Scripting (XSS) Prevention

**Strategy:** Validate input at API level, sanitize on frontend

```typescript
// API Layer - TypeBox validation
const UserInputSchema = Type.Object({
  name: Type.String({
    minLength: 1,
    maxLength: 100,
    pattern: '^[a-zA-Z0-9 .-]+$', // Restrict characters
  }),
  email: Type.String({ format: 'email' }),
  bio: Type.String({ maxLength: 500 }), // Limit length
});

// Repository Layer - Store as-is
async create(data: CreateUser) {
  // No need to sanitize - validation already happened
  return this.query().insert(data);
}
```

**Frontend Responsibility:**

- Angular automatically escapes HTML in templates
- Use `[innerHTML]` with `DomSanitizer` only when necessary
- Never use `bypassSecurityTrust*` without careful review

### 3. Authentication & Authorization

**Pattern 1: JWT Authentication**

```typescript
// Route with authentication
fastify.get('/profile', {
  preValidation: [fastify.authenticate],
  schema: {
    security: [{ bearerAuth: [] }],
    response: { 200: ProfileResponseSchema },
  },
  handler: async (req, reply) => {
    // req.user is populated by fastify.authenticate
    const userId = req.user.id;
    const profile = await getProfile(userId);
    return reply.success(profile);
  },
});
```

**Pattern 2: Role-Based Access Control**

```typescript
// Require specific roles
fastify.post('/admin/users', {
  preValidation: [fastify.authenticate, fastify.verifyRole(['admin', 'super_admin'])],
  handler: async (req, reply) => {
    // Only admin or super_admin can access
  },
});
```

**Pattern 3: Permission-Based Access**

```typescript
// Require specific permission
fastify.delete('/users/:id', {
  preValidation: [fastify.authenticate, fastify.verifyPermission('users', 'delete')],
  handler: async (req, reply) => {
    // Only users with 'users:delete' permission can access
  },
});
```

**Pattern 4: Resource Ownership**

```typescript
// User can only access their own resource
fastify.get('/profile/:id', {
  preValidation: [
    fastify.authenticate,
    fastify.verifyOwnership('id'), // Checks req.params.id === req.user.id
  ],
  handler: async (req, reply) => {
    // User can only view their own profile (unless admin)
  },
});
```

### 4. CSRF Protection

**Strategy:** Token validation for state-changing operations

```typescript
// For session-based auth (cookies)
// AegisX uses JWT in Authorization header - CSRF not applicable

// If implementing cookie-based sessions:
fastify.register(require('@fastify/csrf-protection'));

fastify.post('/transfer-money', {
  preValidation: [fastify.csrfProtection],
  handler: async (req, reply) => {
    // CSRF token validated
  },
});
```

**Key Points:**

- JWT in `Authorization` header is not vulnerable to CSRF
- Only needed if using cookie-based authentication
- All state-changing operations (POST/PUT/DELETE) should be protected

### 5. Broken Access Control

**Prevention:** Always validate authorization in route handlers

```typescript
// WRONG - Only checking authentication
fastify.delete('/users/:id', {
  preValidation: [fastify.authenticate],
  handler: async (req, reply) => {
    // Any authenticated user can delete any user - BAD!
    await deleteUser(req.params.id);
  },
});

// CORRECT - Checking authorization
fastify.delete('/users/:id', {
  preValidation: [fastify.authenticate, fastify.verifyPermission('users', 'delete')],
  handler: async (req, reply) => {
    // Only users with permission can delete
    await deleteUser(req.params.id);
  },
});

// ALSO CORRECT - Manual authorization check
fastify.delete('/users/:id', {
  preValidation: [fastify.authenticate],
  handler: async (req, reply) => {
    const targetUserId = req.params.id;
    const currentUserId = req.user.id;

    // Users can only delete their own account
    if (targetUserId !== currentUserId && !req.user.roles.includes('admin')) {
      return reply.forbidden('Cannot delete other users');
    }

    await deleteUser(targetUserId);
  },
});
```

### 6. Sensitive Data Exposure

**Prevention:** Never return sensitive fields in responses

```typescript
// Repository - Define safe fields
async findById(id: string) {
  return this.query()
    .select([
      'id',
      'email',
      'username',
      'first_name',
      'last_name',
      'created_at',
      // DO NOT select: password, password_hash, reset_token, etc.
    ])
    .where('id', id)
    .first();
}

// Controller - Strip sensitive fields before response
async getUser(req, reply) {
  const user = await this.service.findById(req.params.id);

  // Remove sensitive fields if they somehow got included
  const { password, password_hash, reset_token, ...safeUser } = user;

  return reply.success(safeUser);
}

// Schema - Define what can be returned
const UserResponseSchema = Type.Object({
  id: Type.String({ format: 'uuid' }),
  email: Type.String({ format: 'email' }),
  username: Type.String(),
  // password NOT included in schema
});
```

**Key Points:**

- Never return password hashes, tokens, or internal IDs
- Use `.select()` to explicitly choose fields
- Define response schemas that exclude sensitive data

### 7. Insufficient Logging & Monitoring

**Pattern:** Use built-in request logging and audit logging

```typescript
// Request logging (automatic via Fastify)
fastify.log.info({ userId: req.user.id, action: 'login' }, 'User logged in');

// Security event logging
fastify.log.warn(
  {
    userId: req.user.id,
    attemptedResource: req.params.id,
    timestamp: new Date().toISOString(),
  },
  'Unauthorized access attempt',
);

// Error logging (never log sensitive data)
try {
  await processPayment(paymentData);
} catch (error) {
  fastify.log.error(
    {
      error: error.message, // Don't log full error (may contain sensitive data)
      userId: req.user.id,
    },
    'Payment processing failed',
  );
  return reply.serverError('Payment failed');
}
```

**What to Log:**

- Authentication attempts (success and failure)
- Authorization failures
- Input validation failures
- Unexpected errors

**What NOT to Log:**

- Passwords
- Tokens
- Credit card numbers
- Full error stack traces in production

## TypeBox Validation Patterns

### Pattern 1: String Validation with Constraints

```typescript
const UsernameSchema = Type.String({
  minLength: 3,
  maxLength: 50,
  pattern: '^[a-zA-Z0-9_-]+$', // Alphanumeric, underscore, hyphen only
  description: 'Username (3-50 characters, alphanumeric)',
});

const EmailSchema = Type.String({
  format: 'email',
  maxLength: 255,
  description: 'Valid email address',
});

const PhoneSchema = Type.String({
  pattern: '^\\+?[1-9]\\d{1,14}$', // E.164 format
  description: 'Phone number in E.164 format',
});

const URLSchema = Type.String({
  format: 'uri',
  description: 'Valid URL',
});
```

### Pattern 2: UUID Validation

```typescript
// ALWAYS use UUID format for ID fields
const UuidParamSchema = Type.Object({
  id: Type.String({
    format: 'uuid',
    description: 'Resource UUID',
  }),
});

// BaseRepository automatically validates UUIDs
// No manual validation needed in most cases
```

### Pattern 3: Number Validation

```typescript
const AgeSchema = Type.Number({
  minimum: 0,
  maximum: 150,
  description: 'Age in years',
});

const PriceSchema = Type.Number({
  minimum: 0,
  multipleOf: 0.01, // Allow cents
  description: 'Price in dollars',
});

const QuantitySchema = Type.Integer({
  minimum: 1,
  description: 'Item quantity (positive integer)',
});
```

### Pattern 4: Enum Validation

```typescript
const StatusSchema = Type.Union([Type.Literal('active'), Type.Literal('inactive'), Type.Literal('suspended'), Type.Literal('pending')]);

const RoleSchema = Type.Union([Type.Literal('admin'), Type.Literal('user'), Type.Literal('guest')]);
```

### Pattern 5: Array Validation

```typescript
const TagsSchema = Type.Array(Type.String(), {
  minItems: 1,
  maxItems: 10,
  uniqueItems: true,
  description: 'List of tags (1-10 unique items)',
});

const IdsSchema = Type.Array(Type.String({ format: 'uuid' }), {
  minItems: 1,
  maxItems: 100,
  description: 'List of UUIDs (max 100)',
});
```

### Pattern 6: Nested Object Validation

```typescript
const AddressSchema = Type.Object({
  street: Type.String({ maxLength: 255 }),
  city: Type.String({ maxLength: 100 }),
  state: Type.String({ maxLength: 50 }),
  postalCode: Type.String({ pattern: '^\\d{5}(-\\d{4})?$' }),
  country: Type.String({ maxLength: 50 }),
});

const UserWithAddressSchema = Type.Object({
  name: Type.String({ maxLength: 100 }),
  email: Type.String({ format: 'email' }),
  address: Type.Optional(AddressSchema), // Optional nested object
});
```

### Pattern 7: Date/Time Validation

```typescript
const DateTimeSchema = Type.String({
  format: 'date-time',
  description: 'ISO 8601 date-time',
});

const DateSchema = Type.String({
  format: 'date',
  description: 'ISO 8601 date (YYYY-MM-DD)',
});

// Custom validation for date ranges
const DateRangeSchema = Type.Object({
  startDate: Type.String({ format: 'date-time' }),
  endDate: Type.String({ format: 'date-time' }),
});
```

## Authentication Implementation Patterns

### Pattern 1: Public Route (No Auth Required)

```typescript
fastify.post('/auth/login', {
  schema: {
    body: LoginRequestSchema,
    response: {
      200: AuthResponseSchema,
      401: UnauthorizedResponseSchema,
    },
  },
  handler: async (req, reply) => {
    const { email, password } = req.body;
    const result = await authService.login(email, password);
    return reply.success(result);
  },
});
```

### Pattern 2: Authenticated Route

```typescript
fastify.get('/profile', {
  preValidation: [fastify.authenticate],
  schema: {
    description: 'Get user profile',
    tags: ['User Profile'],
    security: [{ bearerAuth: [] }], // Swagger documentation
    response: {
      200: ProfileResponseSchema,
      401: UnauthorizedResponseSchema,
    },
  },
  handler: async (req, reply) => {
    // req.user is available (populated by fastify.authenticate)
    const profile = await profileService.getProfile(req.user.id);
    return reply.success(profile);
  },
});
```

### Pattern 3: Role-Based Access

```typescript
fastify.post('/admin/settings', {
  preValidation: [fastify.authenticate, fastify.verifyRole(['admin', 'super_admin'])],
  schema: {
    description: 'Update system settings',
    tags: ['Admin'],
    security: [{ bearerAuth: [] }],
    body: SettingsUpdateSchema,
    response: {
      200: SettingsResponseSchema,
      401: UnauthorizedResponseSchema,
      403: ForbiddenResponseSchema,
    },
  },
  handler: async (req, reply) => {
    // Only admin or super_admin can access
    const settings = await settingsService.update(req.body);
    return reply.success(settings);
  },
});
```

### Pattern 4: Permission-Based Access

```typescript
fastify.delete('/users/:id', {
  preValidation: [fastify.authenticate, fastify.verifyPermission('users', 'delete')],
  schema: {
    description: 'Delete user',
    tags: ['Users'],
    security: [{ bearerAuth: [] }],
    params: UuidParamSchema,
    response: {
      200: ApiSuccessResponseSchema,
      401: UnauthorizedResponseSchema,
      403: ForbiddenResponseSchema,
      404: NotFoundResponseSchema,
    },
  },
  handler: async (req, reply) => {
    // Only users with 'users:delete' permission can access
    await userService.delete(req.params.id);
    return reply.success({ message: 'User deleted' });
  },
});
```

### Pattern 5: Multiple Auth Strategies (OR Logic)

```typescript
// User can access if they have EITHER role
fastify.get('/reports', {
  preValidation: [
    fastify.authenticate,
    async (req, reply) => {
      const hasManagerRole = req.user.roles.includes('manager');
      const hasAnalystRole = req.user.roles.includes('analyst');

      if (!hasManagerRole && !hasAnalystRole) {
        return reply.forbidden('Requires manager or analyst role');
      }
    },
  ],
  handler: async (req, reply) => {
    // Accessible by managers OR analysts
  },
});
```

### Pattern 6: Complex Authorization Logic

```typescript
fastify.put('/documents/:id', {
  preValidation: [fastify.authenticate],
  handler: async (req, reply) => {
    const document = await documentService.findById(req.params.id);

    if (!document) {
      return reply.notFound('Document not found');
    }

    // Users can edit if they:
    // 1. Own the document, OR
    // 2. Have 'documents:edit_all' permission, OR
    // 3. Are in the document's shared_with list
    const isOwner = document.created_by === req.user.id;
    const hasEditPermission = req.user.permissions.includes('documents:edit_all');
    const isSharedWith = document.shared_with?.includes(req.user.id);

    if (!isOwner && !hasEditPermission && !isSharedWith) {
      return reply.forbidden('Cannot edit this document');
    }

    // Authorized - proceed with update
    const updated = await documentService.update(req.params.id, req.body);
    return reply.success(updated);
  },
});
```

## Common Security Mistakes

### Mistake 1: Throwing Errors in preValidation

```typescript
// WRONG - Request hangs
fastify.decorate('authenticate', async (req, reply) => {
  if (!req.headers.authorization) {
    throw new Error('No auth'); // HANGS REQUEST!
  }
});

// CORRECT
fastify.decorate('authenticate', async (req, reply) => {
  if (!req.headers.authorization) {
    return reply.unauthorized('No auth'); // Proper response
  }
});
```

### Mistake 2: Missing Input Validation

```typescript
// WRONG - No validation
fastify.post('/users', async (req, reply) => {
  const user = await createUser(req.body); // Dangerous!
});

// CORRECT
fastify.post('/users', {
  schema: {
    body: CreateUserSchema, // Validates before handler
  },
  handler: async (req, reply) => {
    const user = await createUser(req.body); // Safe!
  },
});
```

### Mistake 3: Not Checking Authorization

```typescript
// WRONG - Only checking authentication
fastify.delete('/users/:id', {
  preValidation: [fastify.authenticate],
  handler: async (req, reply) => {
    // Any authenticated user can delete anyone!
    await deleteUser(req.params.id);
  },
});

// CORRECT
fastify.delete('/users/:id', {
  preValidation: [fastify.authenticate, fastify.verifyPermission('users', 'delete')],
  handler: async (req, reply) => {
    await deleteUser(req.params.id);
  },
});
```

### Mistake 4: Exposing Sensitive Data

```typescript
// WRONG - Returning password hash
async findById(id: string) {
  return this.query()
    .select('*') // Includes password_hash!
    .where('id', id)
    .first();
}

// CORRECT
async findById(id: string) {
  return this.query()
    .select(['id', 'email', 'username', 'first_name', 'last_name'])
    .where('id', id)
    .first();
}
```

### Mistake 5: Weak Password Validation

```typescript
// WRONG - Weak validation
const PasswordSchema = Type.String({ minLength: 6 });

// CORRECT - Strong validation
const PasswordSchema = Type.String({
  minLength: 8,
  maxLength: 128,
  description: 'Password (minimum 8 characters)',
});

// BETTER - Enforce complexity in service layer
async validatePassword(password: string): Promise<void> {
  if (password.length < 8) {
    throw new AppError('Password must be at least 8 characters', 400);
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

### Mistake 6: Logging Sensitive Data

```typescript
// WRONG - Logging sensitive data
fastify.log.info({ user: req.body }, 'User registration');
// This logs the password!

// CORRECT
fastify.log.info({ email: req.body.email, username: req.body.username }, 'User registration');
```

### Mistake 7: Not Validating UUIDs

```typescript
// WRONG - No UUID validation
fastify.get('/users/:id', async (req, reply) => {
  const user = await findById(req.params.id); // Could be SQL injection attempt
});

// CORRECT - TypeBox validates UUID format
fastify.get('/users/:id', {
  schema: {
    params: Type.Object({
      id: Type.String({ format: 'uuid' }),
    }),
  },
  handler: async (req, reply) => {
    const user = await findById(req.params.id); // Safe
  },
});
```

## Quick Security Checklist

Before deploying any endpoint, verify:

### Authentication & Authorization

- [ ] Public routes are intentionally public (auth not required)
- [ ] Protected routes use `preValidation: [fastify.authenticate]`
- [ ] Role-based routes use `fastify.verifyRole([...])`
- [ ] Permission-based routes use `fastify.verifyPermission(resource, action)`
- [ ] Resource ownership is verified when needed
- [ ] No errors are thrown in preValidation hooks (use `return reply.*()`)

### Input Validation

- [ ] All routes have TypeBox schema validation
- [ ] Body, query, params are validated
- [ ] UUID fields use `format: 'uuid'`
- [ ] String fields have `minLength` and `maxLength`
- [ ] Email fields use `format: 'email'`
- [ ] Enums use `Type.Union([Type.Literal(...)]))`
- [ ] Arrays have `minItems` and `maxItems`
- [ ] Numbers have `minimum` and `maximum`

### Data Security

- [ ] Password fields are never returned in responses
- [ ] Sensitive fields are excluded from SELECT queries
- [ ] Response schemas don't include sensitive data
- [ ] Passwords are hashed (never stored plain text)
- [ ] Tokens are stored securely
- [ ] No sensitive data in logs

### Database Security

- [ ] All queries use Knex query builder
- [ ] No raw SQL with string concatenation
- [ ] Raw queries use parameter bindings
- [ ] UUIDs are validated before queries
- [ ] Soft deletes use `deleted_at` checks

### Error Handling

- [ ] No sensitive data in error messages
- [ ] Generic error messages for auth failures
- [ ] Detailed errors only in development
- [ ] All errors are logged properly
- [ ] No stack traces in production responses

### Business Logic

- [ ] Business validations in service layer
- [ ] Rate limiting on sensitive endpoints
- [ ] Account lockout after failed attempts
- [ ] Email verification for new accounts
- [ ] Password reset tokens expire

## Reference Files

Key files in the project:

```
apps/api/src/layers/core/auth/strategies/auth.strategies.ts
  - Authentication strategies (verifyJWT, verifyRole, verifyPermission)
  - CRITICAL: Shows correct preValidation patterns (no throwing)

apps/api/src/layers/core/auth/auth.schemas.ts
  - Authentication schemas (login, register, password reset)
  - Example of strong validation patterns

apps/api/src/layers/platform/user-profile/routes/profile.routes.ts
  - Example of authenticated routes
  - Shows proper use of preValidation hooks

apps/api/src/shared/repositories/base.repository.ts
  - BaseRepository with UUID validation
  - Safe database query patterns

docs/reference/api/typebox-schema-standard.md
  - Complete TypeBox schema patterns
  - Validation best practices
```

## Additional Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [TypeBox Documentation](https://github.com/sinclairzx81/typebox)
- [Fastify Security Guide](https://fastify.dev/docs/latest/Guides/Getting-Started/#security)
- Project: `/docs/reference/api/typebox-schema-standard.md`
