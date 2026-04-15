---
name: api-contract-validator
description: Validate that backend API implementations match their API contracts defined in docs/features/*/API_CONTRACTS.md. Use when implementing APIs, reviewing API changes, or ensuring frontend-backend alignment. Checks HTTP methods, paths, request/response schemas, and authentication requirements.
allowed-tools: Read, Grep, Glob
---

# API Contract Validator

Validates that Fastify backend routes match the API contracts documented in `docs/features/[feature]/API_CONTRACTS.md`.

## When Claude Should Use This Skill

- User asks to "validate API", "check API contract", or "verify API implementation"
- After implementing new API endpoints
- Before marking API implementation tasks as complete
- When investigating frontend-backend integration issues
- When reviewing API changes

## Validation Process

### Step 1: Locate the API Contract

```bash
# Find API_CONTRACTS.md for the feature
find docs/features -name "API_CONTRACTS.md" | grep [feature-name]
```

Read the contract to identify:

- Base URL path
- All endpoints (method + path)
- Request schemas (body, query params, path params)
- Response schemas (success + error)
- Authentication requirements

### Step 2: Locate Backend Implementation

Common locations:

```
apps/api/src/layers/platform/[feature]/[feature].routes.ts
apps/api/src/layers/domains/[domain]/[feature]/[feature].routes.ts
apps/api/src/modules/[feature]/[feature].routes.ts
apps/api/src/core/[feature]/[feature].routes.ts
```

Use Grep to find route registration:

```bash
grep -r "fastify.register" apps/api/src | grep [feature]
```

### Step 3: Compare Contract vs Implementation

For each endpoint in the contract, verify:

#### ✅ HTTP Method Match

```typescript
// Contract: POST /api/v1/departments
// Implementation: fastify.post('/') // Inside /api/v1/departments prefix
```

#### ✅ Path Match

```typescript
// Contract: /api/v1/departments/:id
// Implementation: fastify.get('/:id') // With correct prefix
```

#### ✅ Request Schema

```typescript
// Contract defines request body schema
// Implementation uses: { schema: { body: DepartmentCreateSchema } }
```

#### ✅ Response Schema

```typescript
// Contract defines response format
// Implementation uses: { schema: { response: { 200: DepartmentResponseSchema } } }
```

#### ✅ Authentication

```typescript
// Contract: "Requires authentication: Yes"
// Implementation: { preValidation: [authenticate] } or authMiddleware
```

### Step 4: Report Findings

Create a validation report with:

**✅ Matches Found:**

- List endpoints that match contract perfectly

**⚠️ Partial Matches:**

- Endpoints with minor differences (e.g., missing response schema)

**❌ Mismatches:**

- Missing endpoints
- Wrong HTTP methods
- Missing authentication
- Schema mismatches

**📝 Recommendations:**

- Specific fixes needed
- Files to modify

## Examples

### Example 1: Complete Validation

```
User: "Validate the departments API against its contract"

Claude:
1. Read docs/features/departments/API_CONTRACTS.md
2. Identify 5 endpoints: GET, POST, PUT, DELETE, GET /dropdown
3. Grep for departments.routes.ts
4. Compare each endpoint
5. Generate report:

✅ All 5 endpoints match contract
✅ All schemas defined
✅ Authentication properly configured
```

### Example 2: Finding Mismatches

```
User: "Check if the users API matches the contract"

Claude:
1. Read docs/features/users/API_CONTRACTS.md
2. Find users.routes.ts
3. Compare:

❌ Mismatches Found:
- POST /users: Missing request body schema
- PUT /users/:id: Response schema not defined
- DELETE /users/:id: Missing authentication middleware

📝 Recommendations:
- Add UserCreateSchema to POST route
- Add UserUpdateResponseSchema to PUT route
- Add authenticate preValidation hook to DELETE
```

### Example 3: After API Implementation

```
User: "I just implemented the products API, can you validate it?"

Claude:
1. Read docs/features/products/API_CONTRACTS.md
2. Find products.routes.ts
3. Validate all endpoints
4. Report:

✅ 4/5 endpoints match perfectly
⚠️ 1 partial match:
- GET /products: Missing pagination schema in response

📝 Fix: Add PaginatedResponseSchema wrapper
```

## Best Practices

### 1. Always Read Contract First

Never assume contract structure - always read the actual API_CONTRACTS.md file.

### 2. Check TypeBox Schemas

Verify that TypeBox schemas are defined and referenced correctly:

```typescript
// Good
const DepartmentCreateSchema = Type.Object({
  dept_code: Type.String({ maxLength: 10 }),
  dept_name: Type.String({ maxLength: 100 }),
});

fastify.post('/', {
  schema: { body: DepartmentCreateSchema },
});
```

### 3. Verify Authentication

Check for authentication in routes:

```typescript
// Method 1: preValidation hook
{
  preValidation: [authenticate];
}

// Method 2: Middleware
{
  preHandler: [authMiddleware];
}

// Method 3: Plugin-level
fastify.register(routes, { prefix: '/api/v1/admin' }); // Protected prefix
```

### 4. Check Response Status Codes

Validate that documented status codes are implemented:

```typescript
schema: {
  response: {
    200: SuccessSchema,
    400: ErrorSchema,
    404: NotFoundSchema
  }
}
```

### 5. Path Parameter Validation

Ensure path params have TypeBox schemas:

```typescript
// Contract: GET /departments/:id (id must be integer)
schema: {
  params: Type.Object({
    id: Type.Integer(),
  });
}
```

## Common Validation Patterns

### Pattern 1: CRUD Endpoints

Standard CRUD should have:

- GET /resource (list) - with query params for filters/pagination
- GET /resource/:id (detail) - with id param validation
- POST /resource (create) - with body schema
- PUT /resource/:id (update) - with params + body schema
- DELETE /resource/:id (delete) - with params validation + auth

### Pattern 2: Authentication Flow

Check that protected endpoints have:

```typescript
preValidation: [authenticate]; // or authMiddleware
```

### Pattern 3: Response Wrapping

Check if responses use standard format:

```typescript
{
  success: true,
  data: { ... },
  message: "Success"
}
```

## Troubleshooting

### Issue: Can't find route file

**Solution:** Use broader search:

```bash
grep -r "register.*[feature-name]" apps/api/src
```

### Issue: Route prefix unclear

**Solution:** Check plugin registration in plugin.loader.ts or server.ts

### Issue: Schema imported from different file

**Solution:** Search for schema definitions:

```bash
grep -r "[SchemaName]" apps/api/src
```

## Related Documentation

- [API Calling Standard](../../../docs/guides/development/api-calling-standard.md)
- [API Response Standard](../../../docs/reference/api/api-response-standard.md)
- [TypeBox Schema Standard](../../../docs/reference/api/typebox-schema-standard.md)

## Validation Checklist

Use this checklist for thorough validation:

- [ ] Contract file exists and readable
- [ ] All endpoints documented in contract
- [ ] Backend routes file located
- [ ] HTTP methods match
- [ ] Paths match (including prefixes)
- [ ] Request body schemas defined
- [ ] Request query/params schemas defined
- [ ] Response schemas defined (200, 400, 404, etc.)
- [ ] Authentication configured where required
- [ ] Permission checks where specified
- [ ] Path parameters validated
- [ ] Error responses standardized

## Output Format

Always provide validation results in this format:

```
## API Contract Validation Report
Feature: [feature-name]
Contract: docs/features/[feature]/API_CONTRACTS.md
Implementation: apps/api/src/.../[feature].routes.ts

### ✅ Matches (X/Y endpoints)
1. GET /api/v1/[resource] - ✅ Complete
2. POST /api/v1/[resource] - ✅ Complete

### ⚠️ Partial Matches (X endpoints)
1. PUT /api/v1/[resource]/:id
   - Missing: Response schema for 404

### ❌ Mismatches (X endpoints)
1. DELETE /api/v1/[resource]/:id
   - Missing: Authentication middleware
   - Missing: Request params validation

### 📝 Recommendations
1. File: apps/api/src/.../[feature].routes.ts:123
   - Add: { preValidation: [authenticate] }
2. File: apps/api/src/.../[feature].routes.ts:145
   - Add: params: Type.Object({ id: Type.Integer() })

### Summary
- Total endpoints: Y
- Fully matching: X
- Partial matches: X
- Mismatches: X
- Contract coverage: X%
```
