# API Contract Validator - Technical Reference

## Project-Specific Patterns

### Route File Locations by Layer

This project uses layered architecture:

```
apps/api/src/
├── layers/
│   ├── platform/           # Core platform features (users, departments, auth)
│   │   └── [feature]/
│   │       └── [feature].routes.ts
│   ├── core/               # Shared business logic
│   └── domains/            # Business domain features (inventory, hr, finance)
│       └── [domain]/
│           └── [feature]/
│               └── [feature].routes.ts
├── modules/                # Legacy location (being migrated)
└── core/                   # Core system features (auth, permissions)
```

### TypeBox Schema Patterns

#### Standard Schema Structure

```typescript
import { Type, Static } from '@sinclair/typebox';

// Request Schemas
export const DepartmentCreateSchema = Type.Object({
  dept_code: Type.String({ maxLength: 10 }),
  dept_name: Type.String({ maxLength: 100 }),
  parent_id: Type.Optional(Type.Integer()),
  is_active: Type.Optional(Type.Boolean({ default: true })),
});

// Response Schemas
export const DepartmentResponseSchema = Type.Object({
  success: Type.Boolean(),
  data: Type.Object({
    id: Type.Integer(),
    dept_code: Type.String(),
    dept_name: Type.String(),
    parent_id: Type.Union([Type.Integer(), Type.Null()]),
    is_active: Type.Boolean(),
    created_at: Type.String({ format: 'date-time' }),
    updated_at: Type.String({ format: 'date-time' }),
  }),
  message: Type.Optional(Type.String()),
});

// Type Exports (for TypeScript)
export type DepartmentCreate = Static<typeof DepartmentCreateSchema>;
export type DepartmentResponse = Static<typeof DepartmentResponseSchema>;
```

#### Pagination Schema

```typescript
export const PaginatedQuerySchema = Type.Object({
  page: Type.Optional(Type.Integer({ minimum: 1, default: 1 })),
  limit: Type.Optional(Type.Integer({ minimum: 1, maximum: 100, default: 20 })),
  search: Type.Optional(Type.String()),
  sort_by: Type.Optional(Type.String()),
  sort_order: Type.Optional(Type.Union([Type.Literal('asc'), Type.Literal('desc')])),
});

export const PaginatedResponseSchema = <T>(itemSchema: T) =>
  Type.Object({
    success: Type.Boolean(),
    data: Type.Object({
      items: Type.Array(itemSchema),
      total: Type.Integer(),
      page: Type.Integer(),
      limit: Type.Integer(),
      total_pages: Type.Integer(),
    }),
  });
```

### Authentication Patterns

#### Pattern 1: preValidation Hook

```typescript
import { authenticate } from '../../core/auth/strategies/auth.strategies';

fastify.get(
  '/:id',
  {
    preValidation: [authenticate],
    schema: {
      params: Type.Object({ id: Type.Integer() }),
      response: { 200: DepartmentResponseSchema },
    },
  },
  async (request, reply) => {
    // Handler logic
  },
);
```

#### Pattern 2: Permission Checks

```typescript
import { authenticate, requirePermission } from '../../core/auth/strategies/auth.strategies';

fastify.delete(
  '/:id',
  {
    preValidation: [authenticate, requirePermission('departments.delete')],
    schema: {
      params: Type.Object({ id: Type.Integer() }),
    },
  },
  async (request, reply) => {
    // Handler logic
  },
);
```

#### Pattern 3: Plugin-Level Protection

```typescript
// In plugin.loader.ts or routes registration
fastify.register(departmentsRoutes, {
  prefix: '/api/v1/admin/departments',
  // All routes under this prefix are protected
});
```

### Response Format Standards

#### Success Response (Single Item)

```typescript
{
  success: true,
  data: {
    id: 1,
    dept_code: "IT",
    dept_name: "Information Technology"
  },
  message: "Department retrieved successfully"
}
```

#### Success Response (List)

```typescript
{
  success: true,
  data: {
    items: [...],
    total: 50,
    page: 1,
    limit: 20,
    total_pages: 3
  }
}
```

#### Error Response

```typescript
{
  success: false,
  error: {
    code: "VALIDATION_ERROR",
    message: "dept_code is required",
    details: [
      {
        field: "dept_code",
        message: "must be a string"
      }
    ]
  }
}
```

### Common Schema Validations

#### UUID Fields

```typescript
Type.String({ format: 'uuid' });
```

#### Integer IDs

```typescript
Type.Integer({ minimum: 1 });
```

#### Enum Fields

```typescript
Type.Union([Type.Literal('active'), Type.Literal('inactive'), Type.Literal('pending')]);
```

#### Date Fields

```typescript
Type.String({ format: 'date' }); // YYYY-MM-DD
Type.String({ format: 'date-time' }); // ISO 8601
```

#### Email Fields

```typescript
Type.String({ format: 'email' });
```

## Validation Rules by Endpoint Type

### GET /resource (List)

**Required:**

- Query schema for filters/pagination
- Response schema with paginated format
- Optional: Authentication

**Example:**

```typescript
fastify.get('/', {
  schema: {
    querystring: PaginatedQuerySchema,
    response: {
      200: PaginatedResponseSchema(DepartmentSchema),
    },
  },
});
```

### GET /resource/:id (Detail)

**Required:**

- Params schema with id validation
- Response schema for single item
- Response schema for 404 error
- Optional: Authentication

**Example:**

```typescript
fastify.get('/:id', {
  preValidation: [authenticate],
  schema: {
    params: Type.Object({
      id: Type.Integer(),
    }),
    response: {
      200: DepartmentResponseSchema,
      404: ErrorResponseSchema,
    },
  },
});
```

### POST /resource (Create)

**Required:**

- Body schema for creation
- Response schema with created item
- Response schema for 400 validation error
- Authentication required (usually)

**Example:**

```typescript
fastify.post('/', {
  preValidation: [authenticate, requirePermission('departments.create')],
  schema: {
    body: DepartmentCreateSchema,
    response: {
      201: DepartmentResponseSchema,
      400: ErrorResponseSchema,
    },
  },
});
```

### PUT /resource/:id (Update)

**Required:**

- Params schema with id
- Body schema for update
- Response schema with updated item
- Response schemas for 400, 404 errors
- Authentication required

**Example:**

```typescript
fastify.put('/:id', {
  preValidation: [authenticate, requirePermission('departments.update')],
  schema: {
    params: Type.Object({ id: Type.Integer() }),
    body: DepartmentUpdateSchema,
    response: {
      200: DepartmentResponseSchema,
      400: ErrorResponseSchema,
      404: ErrorResponseSchema,
    },
  },
});
```

### DELETE /resource/:id (Delete)

**Required:**

- Params schema with id
- Response schema for success
- Response schema for 404 error
- Authentication required

**Example:**

```typescript
fastify.delete('/:id', {
  preValidation: [authenticate, requirePermission('departments.delete')],
  schema: {
    params: Type.Object({ id: Type.Integer() }),
    response: {
      200: Type.Object({ success: Type.Boolean(), message: Type.String() }),
      404: ErrorResponseSchema,
    },
  },
});
```

## API Contract Document Structure

Standard `API_CONTRACTS.md` structure:

````markdown
# [Feature] API Contracts

## Base URL

`/api/v1/[resource]`

## Endpoints

### 1. List [Resource]

**GET** `/api/v1/[resource]`

**Authentication:** Required
**Permissions:** `[resource].list`

**Query Parameters:**

- `page` (integer, optional): Page number (default: 1)
- `limit` (integer, optional): Items per page (default: 20)
- `search` (string, optional): Search term

**Response (200):**

```json
{
  "success": true,
  "data": {
    "items": [...],
    "total": 50,
    "page": 1,
    "limit": 20
  }
}
```
````

### 2. Get [Resource] Detail

**GET** `/api/v1/[resource]/:id`

...

````

## Validation Checklist Details

### 1. Contract File Validation

- [ ] File exists at `docs/features/[feature]/API_CONTRACTS.md`
- [ ] Has Base URL section
- [ ] All endpoints documented with:
  - HTTP method
  - Path
  - Authentication requirements
  - Request schema
  - Response schema
  - Status codes

### 2. Route Registration

- [ ] Route file exists in correct layer
- [ ] Exported as plugin function
- [ ] Registered in `plugin.loader.ts` or parent routes
- [ ] Prefix matches contract base URL

### 3. HTTP Method Match

- [ ] GET for retrieval
- [ ] POST for creation
- [ ] PUT/PATCH for updates
- [ ] DELETE for removal
- [ ] OPTIONS for CORS (if needed)

### 4. Schema Validation

**Request Schemas:**
- [ ] Body schema for POST/PUT
- [ ] Query schema for GET with filters
- [ ] Params schema for :id routes
- [ ] Headers schema (if custom headers)

**Response Schemas:**
- [ ] 200/201 success schema
- [ ] 400 validation error schema
- [ ] 401 authentication error schema
- [ ] 403 permission error schema
- [ ] 404 not found schema
- [ ] 500 server error schema (optional)

### 5. Authentication Check

- [ ] `preValidation: [authenticate]` for protected routes
- [ ] Permission checks: `requirePermission('[resource].[action]')`
- [ ] Public endpoints clearly marked (no auth)

### 6. TypeBox Schema Quality

- [ ] All fields have type definitions
- [ ] String fields have maxLength
- [ ] Number fields have min/max (if applicable)
- [ ] Required vs optional clearly marked
- [ ] Enum values use Type.Union with Type.Literal
- [ ] Date fields use proper format
- [ ] Static types exported for TypeScript

## Common Mismatch Scenarios

### Scenario 1: Missing Response Schema

**Contract says:**
```markdown
Response (404):
{ "success": false, "error": "Department not found" }
````

**Implementation missing:**

```typescript
// Missing 404 schema
schema: {
  response: {
    200: DepartmentResponseSchema
    // ❌ No 404 schema
  }
}
```

**Fix:**

```typescript
schema: {
  response: {
    200: DepartmentResponseSchema,
    404: ErrorResponseSchema  // ✅ Added
  }
}
```

### Scenario 2: Wrong HTTP Method

**Contract says:** `POST /api/v1/departments`
**Implementation has:** `fastify.put('/', ...)`

**Fix:** Change to `fastify.post('/', ...)`

### Scenario 3: Missing Authentication

**Contract says:** "Authentication: Required"
**Implementation missing:** No `preValidation` hook

**Fix:**

```typescript
{
  preValidation: [authenticate],  // ✅ Added
  schema: { ... }
}
```

### Scenario 4: Path Mismatch

**Contract:** `/api/v1/departments/:id`
**Implementation:** `/api/v1/department/:id` (missing 's')

**Fix:** Correct the route registration prefix or path

## Performance Considerations

When validating large APIs:

1. **Batch file reads** - Read all relevant files once
2. **Cache schemas** - Don't re-parse TypeBox definitions
3. **Limit scope** - Validate specific feature if specified
4. **Use Grep efficiently** - Filter before reading full files

## Integration with Development Workflow

### When to Validate

1. **Before PR approval** - Ensure API matches contract
2. **After feature implementation** - Verify completeness
3. **During code review** - Catch mismatches early
4. **CI/CD pipeline** - Automated validation (future)

### Validation Script Usage

```bash
# Validate specific feature
./scripts/validate-api-contract.sh departments

# Validate all features
./scripts/validate-api-contract.sh --all

# Show detailed diff
./scripts/validate-api-contract.sh departments --verbose
```
