# API Contract Validator Skill

Automatically validates that Fastify backend API implementations match their documented contracts in `docs/features/*/API_CONTRACTS.md`.

## What This Skill Does

Claude will **automatically use this skill** when you:

- Ask to "validate API" or "check API contract"
- Implement new API endpoints and need verification
- Review API changes for correctness
- Investigate frontend-backend integration issues

## How It Works

1. **Reads API Contract** - Parses `docs/features/[feature]/API_CONTRACTS.md`
2. **Locates Backend Implementation** - Finds corresponding `.routes.ts` file
3. **Compares Details**:
   - HTTP methods (GET, POST, PUT, DELETE)
   - Route paths and prefixes
   - Request schemas (body, query, params)
   - Response schemas (200, 400, 404, etc.)
   - Authentication requirements
   - Permission checks
4. **Reports Findings** - Lists matches, partial matches, and mismatches

## Quick Start

### Example 1: Validate Departments API

```
You: "Validate the departments API against its contract"
```

Claude will:

- Read `docs/features/departments/API_CONTRACTS.md`
- Find `apps/api/src/layers/platform/departments/departments.routes.ts`
- Compare all endpoints
- Report any mismatches

### Example 2: After Implementing New Feature

```
You: "I just implemented the products API, can you validate it?"
```

Claude will verify your implementation matches the contract.

### Example 3: Check Specific Endpoint

```
You: "Check if the POST /api/v1/users endpoint matches the contract"
```

Claude will focus on that specific endpoint.

## Files in This Skill

```
api-contract-validator/
├── SKILL.md           # Main skill instructions for Claude
├── REFERENCE.md       # Detailed validation rules & patterns
├── README.md          # This file (human-readable overview)
└── scripts/
    └── validate.sh    # Helper script for quick checks
```

## Helper Script Usage

Quick validation from command line:

```bash
# Validate specific feature
./.claude/skills/api-contract-validator/scripts/validate.sh departments

# List available features
./.claude/skills/api-contract-validator/scripts/validate.sh
```

**Note:** The script does basic checks. For thorough validation, ask Claude to do it.

## What Gets Validated

### ✅ Endpoint Matching

- HTTP method (GET, POST, PUT, DELETE)
- Route path matches contract
- Path parameters defined

### ✅ Request Validation

- Body schema for POST/PUT requests
- Query parameter schema for GET requests
- Path parameter schema for `:id` routes

### ✅ Response Validation

- Success response schema (200, 201)
- Error response schemas (400, 404, etc.)
- Response format matches standard

### ✅ Security Validation

- Authentication middleware present when required
- Permission checks configured
- Protected routes properly secured

### ✅ TypeBox Schema Quality

- All fields properly typed
- String fields have maxLength constraints
- Optional vs required fields clearly marked
- Enum values properly defined

## Example Validation Report

```
## API Contract Validation Report
Feature: departments
Contract: docs/features/departments/API_CONTRACTS.md
Implementation: apps/api/src/layers/platform/departments/departments.routes.ts

### ✅ Matches (4/5 endpoints)
1. GET /api/v1/departments - ✅ Complete
2. GET /api/v1/departments/:id - ✅ Complete
3. POST /api/v1/departments - ✅ Complete
4. PUT /api/v1/departments/:id - ✅ Complete

### ❌ Mismatches (1 endpoint)
1. DELETE /api/v1/departments/:id
   - Missing: Authentication middleware
   - Missing: Permission check for 'departments.delete'

### 📝 Recommendations
1. File: apps/api/src/layers/platform/departments/departments.routes.ts:145
   - Add: preValidation: [authenticate, requirePermission('departments.delete')]

### Summary
- Total endpoints: 5
- Fully matching: 4
- Mismatches: 1
- Contract coverage: 80%
```

## Benefits

### For Developers

- Catch mismatches before PR review
- Ensure API implementation completeness
- Maintain frontend-backend alignment
- Follow project standards automatically

### For Code Reviews

- Quick validation of API changes
- Verify all schemas are defined
- Ensure security measures in place
- Reduce manual checking effort

### For API-First Development

- Enforce contract-driven development
- Keep documentation in sync
- Prevent API drift
- Maintain consistency across features

## Integration with Workflow

### 1. Before Committing

```
You: "Validate my API changes"
```

### 2. During Code Review

```
Reviewer asks: "Does this match the contract?"
You: "Claude, validate the users API"
```

### 3. After Merging Feature Branch

```
You: "Validate all APIs in the inventory feature"
```

## Troubleshooting

### Skill Not Triggering?

Make sure your question mentions:

- "validate" or "check" + "API" or "contract"
- A feature name (e.g., "departments", "users")

**Good prompts:**

- "Validate the departments API"
- "Check if products API matches contract"
- "Verify users endpoints against contract"

**Less clear prompts:**

- "Is my API correct?" (too vague)
- "Check my code" (doesn't mention API/contract)

### Can't Find Route File?

Claude will search multiple locations:

- `apps/api/src/layers/platform/[feature]/`
- `apps/api/src/layers/domains/[domain]/[feature]/`
- `apps/api/src/modules/[feature]/`
- `apps/api/src/core/[feature]/`

If still not found, you can specify the path:

```
You: "Validate departments API, routes are in layers/platform/departments/"
```

### Contract File Not Found?

Ensure contract exists at:

```
docs/features/[feature]/API_CONTRACTS.md
```

## Related Skills

Consider creating these complementary skills:

- `api-endpoint-tester` - Test API endpoints with curl
- `typebox-schema-generator` - Generate TypeBox schemas
- `api-doc-generator` - Generate API documentation

## Project Standards

This skill enforces project standards from:

- [API Calling Standard](../../../docs/guides/development/api-calling-standard.md)
- [API Response Standard](../../../docs/reference/api/api-response-standard.md)
- [TypeBox Schema Standard](../../../docs/reference/api/typebox-schema-standard.md)

## Maintenance

To update this skill:

1. Edit `SKILL.md` to change Claude's behavior
2. Edit `REFERENCE.md` to add more validation patterns
3. Update `scripts/validate.sh` to add helper functionality

Changes take effect immediately - no restart needed.

## Share with Team

This skill is project-scoped (`.claude/skills/`), so:

```bash
# Commit to git
git add .claude/skills/api-contract-validator/
git commit -m "Add API contract validator skill"
git push

# Team members get it automatically
git pull
```

Everyone on the team can now use this skill!

## Questions?

Ask Claude:

- "How does the API contract validator skill work?"
- "What does the API validator check for?"
- "Show me an example validation report"
