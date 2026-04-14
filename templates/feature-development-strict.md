# Feature Development - API-First Strict Workflow Template

> **📋 Ready-to-use command template for feature development**
>
> **Copy this template and fill in [PLACEHOLDERS]**

---

## 🚀 Quick Start Commands

### Short Command (Thai)

```
ทำ feature "[FEATURE_NAME]" แบบ API-First Strict Workflow:

ห้ามข้ามขั้นตอน! แต่ละ phase ต้องผ่านก่อนไป phase ถัดไป

Phase 1: Database → Migration + test + แสดงผล schema
Phase 2: Backend API → TypeBox + Repository + Service + Routes → Build (0 errors)
Phase 3: API Testing ⚠️ CRITICAL → curl ทุก endpoint → แสดงผล request/response
Phase 4: API Contract → /api-contract-validator ต้องผ่าน 100%
Phase 5: Frontend → Service + Components (เรียก API จริง!) → Build (0 errors)
Phase 6: Alignment Check ⚠️ CRITICAL → /alignment-checker ต้องผ่าน 100%
Phase 7: UI Testing → Manual test CRUD → แสดงผลสรุป
Phase 8: Automated Testing → Unit + E2E → ต้องผ่านหมด
Phase 9: Documentation → /feature-done

MANDATORY:
- ทุก phase แสดงผลการทดสอบ
- API ต้องทดสอบด้วย curl จริง
- Frontend เรียก API จริง (ห้าม mock!)
- Alignment check ต้องผ่าน 100%
- Build ต้องผ่าน 0 errors ทุกครั้ง
```

### Short Command (English)

```
Implement feature "[FEATURE_NAME]" using API-First Strict Workflow:

NO SKIPPING PHASES! Each phase must pass before proceeding to next.

Phase 1: Database → Migration + test + display schema
Phase 2: Backend API → TypeBox + Repository + Service + Routes → Build (0 errors)
Phase 3: API Testing ⚠️ CRITICAL → curl all endpoints → show request/response
Phase 4: API Contract → /api-contract-validator must pass 100%
Phase 5: Frontend → Service + Components (call REAL API!) → Build (0 errors)
Phase 6: Alignment Check ⚠️ CRITICAL → /alignment-checker must pass 100%
Phase 7: UI Testing → Manual CRUD test → show summary
Phase 8: Automated Testing → Unit + E2E → all must pass
Phase 9: Documentation → /feature-done

MANDATORY:
- Show test results for every phase
- Test API with real curl commands
- Frontend calls real API (NO MOCKING!)
- Alignment check must be 100%
- Build must pass with 0 errors every time
```

---

## 📋 Detailed Command Template

### Full 9-Phase Workflow

```markdown
Implement feature "[FEATURE_NAME]" using API-First Strict Workflow.

CRITICAL RULES:

- NO skipping phases
- MUST show test results for every phase
- MUST test API with curl before frontend
- Frontend MUST call real API (no mocking)
- Alignment check MUST be 100%
- Build MUST pass with 0 errors

────────────────────────────────────────────────────────────────
PHASE 1: Database & Schema
────────────────────────────────────────────────────────────────
[ ] 1.1 Create migration file
Database: [DATABASE_NAME] (e.g., inventory)
Table: [TABLE_NAME] (e.g., drug_categories)
Schema: [SCHEMA_NAME] (e.g., inventory)

        Command: cd apps/api && npx knex migrate:make create_[table_name]_table

        Migration fields:
        - id (UUID, primary key, default: gen_random_uuid())
        - [FIELD_1] ([TYPE], [CONSTRAINTS])
        - [FIELD_2] ([TYPE], [CONSTRAINTS])
        - created_at (timestamp, default: now())
        - updated_at (timestamp, default: now())

[ ] 1.2 Run migration
Command: pnpm run db:migrate

[ ] 1.3 Verify in database - psql or DBeaver - Check table exists - Verify columns

[ ] 1.4 Display schema structure
Show: table name, columns, types, constraints

✅ GATE: Database tables must exist before Phase 2

────────────────────────────────────────────────────────────────
PHASE 2: Backend API Implementation
────────────────────────────────────────────────────────────────
[ ] 2.1 Create TypeBox schemas ([module].schemas.ts)
Required schemas: - Create[Module]Schema (all required fields) - Update[Module]Schema (partial of Create) - [Module]ResponseSchema (matches database) - [Module]IdParamSchema (UUID validation) - [Module]ListResponseSchema (pagination)

[ ] 2.2 Create Repository ([module].repository.ts) - Extend BaseRepository - Use schema prefix: [schema].[table_name] - Implement custom queries (if needed)

[ ] 2.3 Create Service ([module].service.ts) - Business logic - Validation - Error handling

[ ] 2.4 Create Controller ([module].controller.ts) - Request handling - Call service methods - Standard responses

[ ] 2.5 Create Routes ([module].route.ts)
Domain: [DOMAIN] (e.g., inventory/master-data)
Routes: - POST / (create) - GET / (list with pagination) - GET /:id (get by ID) - PUT /:id (update) - DELETE /:id (delete)

        - Use schemas for validation
        - Use SchemaRefs for errors
        - Add fastify.authenticate
        - Add fastify.verifyPermission('[resource]', 'action')

[ ] 2.6 Register plugin in domain index.ts

[ ] 2.7 Build project
Command: pnpm run build

[ ] 2.8 Display build output
MUST show: 0 errors, 0 warnings

✅ GATE: Build must pass with 0 TypeScript errors before Phase 3

────────────────────────────────────────────────────────────────
PHASE 3: API Testing (CRITICAL - DO NOT SKIP!)
────────────────────────────────────────────────────────────────
[ ] 3.1 Start API server
Command: pnpm run dev:api
Verify: Server running on port [PORT]

[ ] 3.2 Login and get access token
curl -X POST http://localhost:[PORT]/api/auth/login \
 -H "Content-Type: application/json" \
 -d '{"email":"admin@example.com","password":"[PASSWORD]"}'

        Save TOKEN for subsequent requests

[ ] 3.3 Test POST (Create)
curl -X POST http://localhost:[PORT]/api/[ENDPOINT] \
 -H "Authorization: Bearer [TOKEN]" \
 -H "Content-Type: application/json" \
 -d '{
"[FIELD_1]": "[VALUE_1]",
"[FIELD_2]": "[VALUE_2]"
}'

        ✅ Verify: Status 201
        ✅ Verify: Response has 'id' field
        ✅ Display: Full request + response

[ ] 3.4 Test GET list
curl http://localhost:[PORT]/api/[ENDPOINT] \
 -H "Authorization: Bearer [TOKEN]"

        ✅ Verify: Status 200
        ✅ Verify: Response is array
        ✅ Display: Response structure

[ ] 3.5 Test GET by ID
curl http://localhost:[PORT]/api/[ENDPOINT]/[ID] \
 -H "Authorization: Bearer [TOKEN]"

        ✅ Verify: Status 200
        ✅ Verify: Response matches created object
        ✅ Display: Response

[ ] 3.6 Test PUT (Update)
curl -X PUT http://localhost:[PORT]/api/[ENDPOINT]/[ID] \
 -H "Authorization: Bearer [TOKEN]" \
 -H "Content-Type: application/json" \
 -d '{
"[FIELD_TO_UPDATE]": "[NEW_VALUE]"
}'

        ✅ Verify: Status 200
        ✅ Verify: Updated fields changed
        ✅ Display: Response

[ ] 3.7 Test DELETE
curl -X DELETE http://localhost:[PORT]/api/[ENDPOINT]/[ID] \
 -H "Authorization: Bearer [TOKEN]"

        ✅ Verify: Status 200
        ✅ Verify: Record deleted from database

[ ] 3.8 Test error cases - 400 Bad Request (invalid data)
curl -X POST .../api/[ENDPOINT] -d '{"invalid": "data"}'

        - 401 Unauthorized (no token)
          curl .../api/[ENDPOINT]

        - 404 Not Found (invalid ID)
          curl .../api/[ENDPOINT]/invalid-uuid

        - 409 Conflict (duplicate)
          curl -X POST .../api/[ENDPOINT] -d '{...duplicate...}'

[ ] 3.9 Display summary table
Show: All endpoints tested with status codes

✅ GATE: ALL endpoints must return correct status codes before Phase 4

────────────────────────────────────────────────────────────────
PHASE 4: API Contract & Validation
────────────────────────────────────────────────────────────────
[ ] 4.1 Create API contract documentation
File: docs/features/[feature]/API_CONTRACTS.md

        Document:
        - All endpoints (method, path, description)
        - Request body schema
        - Response schema
        - Error responses (400, 401, 403, 404, 409, 500)
        - Authentication requirements

[ ] 4.2 Run API contract validator
Skill: /api-contract-validator

[ ] 4.3 Display validation results
Show: Pass/fail for each endpoint

[ ] 4.4 Fix mismatches (if any)

[ ] 4.5 Re-run validator

[ ] 4.6 Confirm 100% validation success

✅ GATE: API contract validation must be 100% before Phase 5

────────────────────────────────────────────────────────────────
PHASE 5: Frontend Implementation
────────────────────────────────────────────────────────────────
[ ] 5.1 Create Angular Service ([module].service.ts)
Location: apps/web/src/app/features/[domain]/services/

        Implements:
        - getAll(page?, limit?) → GET /api/[endpoint]
        - getById(id) → GET /api/[endpoint]/:id
        - create(data) → POST /api/[endpoint]
        - update(id, data) → PUT /api/[endpoint]/:id
        - delete(id) → DELETE /api/[endpoint]/:id

        CRITICAL: Use HttpClient, call REAL API endpoints
        NO MOCKING ALLOWED!

[ ] 5.2 Create List Component ([module]-list.component.ts) - Use AegisX DataTable or Material Table - Call service.getAll() - Pagination - Filters (if needed) - Search (if needed)

[ ] 5.3 Create Detail Component ([module]-detail.component.ts) - Call service.getById(id) - Display all fields - Format dates, numbers - Edit button → Open dialog

[ ] 5.4 Create Create/Edit Dialog ([module]-dialog.component.ts) - Reactive form with FormBuilder - Validation rules matching backend - Call service.create() or service.update() - Handle validation errors from API - Success/error toast messages

[ ] 5.5 Implement Delete - Confirmation dialog (MatDialog) - Call service.delete(id) - Remove from list on success - Error handling

[ ] 5.6 Add routing
File: apps/web/src/app/app.routes.ts

        Add route:
        {
          path: '[path]',
          loadComponent: () => import('./features/[...]/[module]-list.component')
        }

[ ] 5.7 Build project
Command: pnpm run build

[ ] 5.8 Display build output
MUST show: 0 errors, 0 warnings

✅ GATE: Build must pass with 0 errors before Phase 6

CRITICAL RULES FOR THIS PHASE:

- Frontend MUST call real API endpoints
- NO mock data allowed
- NO hardcoded API responses
- Service methods MUST match backend endpoints exactly
- TypeScript types MUST match backend schemas

────────────────────────────────────────────────────────────────
PHASE 6: Frontend-Backend Alignment Check (CRITICAL!)
────────────────────────────────────────────────────────────────
[ ] 6.1 Run alignment checker
Skill: /alignment-checker

[ ] 6.2 Display alignment validation results
Show: Pass/fail for each check

[ ] 6.3 Review mismatches
Check: - Service methods → API endpoints - Request types → API schemas - Response types → API schemas - Error handling → API errors - HTTP methods match

[ ] 6.4 Fix ALL misalignments - Update service if endpoints wrong - Update types if structure wrong - Add error handling if missing

[ ] 6.5 Re-run alignment checker

[ ] 6.6 Confirm 100% alignment
MUST show: 100% pass

✅ GATE: Alignment must be 100% before Phase 7

────────────────────────────────────────────────────────────────
PHASE 7: UI Manual Testing
────────────────────────────────────────────────────────────────
[ ] 7.1 Start dev servers
Terminal 1: pnpm run dev:api
Terminal 2: pnpm run dev:admin

        Verify: Frontend on http://localhost:[PORT]

[ ] 7.2 Test Create Workflow 1. Navigate to [MODULE] page 2. Click "Create" button 3. Fill form with valid data: - [FIELD_1]: [TEST_VALUE_1] - [FIELD_2]: [TEST_VALUE_2] 4. Click "Save" 5. Verify: Success toast message 6. Verify: New record in list 7. Verify: Network tab shows POST request

[ ] 7.3 Test Read Workflow 1. Click on record to view details 2. Verify: All fields displayed correctly 3. Verify: Data matches what was created

[ ] 7.4 Test Update Workflow 1. Click "Edit" button 2. Modify fields: - Change [FIELD_1] to [NEW_VALUE] 3. Click "Save" 4. Verify: Success toast message 5. Verify: Changes in list 6. Verify: Network tab shows PUT request

[ ] 7.5 Test Delete Workflow 1. Click "Delete" button 2. Confirm in dialog 3. Verify: Success toast message 4. Verify: Record removed from list 5. Verify: Network tab shows DELETE request

[ ] 7.6 Test Error Handling - Submit invalid data → Verify error message - Try to delete non-existent → Verify error - Logout and access → Verify redirect

[ ] 7.7 Display UI testing summary
Show: Table of test cases and results

✅ GATE: All test cases must pass before Phase 8

────────────────────────────────────────────────────────────────
PHASE 8: Automated Testing
────────────────────────────────────────────────────────────────
[ ] 8.1 Backend Unit Tests - Repository tests - Service tests - Validation tests - Target: >80% coverage

[ ] 8.2 Frontend Unit Tests - Component tests - Service tests (mock HttpClient) - Form validation tests - Target: >80% coverage

[ ] 8.3 E2E Tests (Playwright) - Complete CRUD workflow - Error scenarios - Authentication flow

[ ] 8.4 Run all tests
Command: pnpm run test

[ ] 8.5 Display test results
Show: Pass/fail counts, coverage %

[ ] 8.6 Run final build
Command: pnpm run build

[ ] 8.7 Display final build output
MUST show: 0 errors, 0 warnings

✅ GATE: All tests must pass, build must succeed

────────────────────────────────────────────────────────────────
PHASE 9: Documentation & Completion
────────────────────────────────────────────────────────────────
[ ] 9.1 Update API documentation - Ensure API_CONTRACTS.md is complete - Add usage examples - Document edge cases

[ ] 9.2 Run feature completion
Skill: /feature-done

[ ] 9.3 Review completion report
Check: All sections filled

[ ] 9.4 Commit changes
Command: git add [specific files]
Message: feat([scope]): [description]

        Follow git workflow rules:
        - NO "Generated with Claude Code"
        - NO "BREAKING CHANGE:"
        - Add specific files only

[ ] 9.5 Display final summary
Show: - Files created/modified - Test results - Coverage - Alignment score - Build status

✅ GATE: Documentation complete, feature committed

────────────────────────────────────────────────────────────────
FINAL CHECKLIST
────────────────────────────────────────────────────────────────
[ ] All 9 phases completed in order
[ ] No phases skipped
[ ] Test results displayed for every phase
[ ] API tested with curl (real HTTP)
[ ] Frontend calls real API (no mocks)
[ ] Build passed with 0 errors (backend + frontend)
[ ] API contract validation: 100%
[ ] Frontend-backend alignment: 100%
[ ] All UI tests passed
[ ] Automated tests: >80% coverage
[ ] Documentation created
[ ] Commit follows standards
[ ] User confirmed complete

✅ FEATURE COMPLETE!
```

---

## 📝 Usage Examples

### Example 1: Simple CRUD Module

```
Implement feature "Drug Categories" using API-First Strict Workflow.

[Fill in placeholders:]
- FEATURE_NAME: Drug Categories
- DATABASE_NAME: inventory
- TABLE_NAME: drug_categories
- SCHEMA_NAME: inventory
- DOMAIN: inventory/master-data
- ENDPOINT: /api/inventory/master-data/drug-categories
- FIELDS:
  - code (string, 50 chars, unique)
  - name (string, 255 chars)
  - description (text, optional)
  - is_active (boolean, default: true)
```

### Example 2: Complex Feature

```
Implement feature "Budget Control Tracking" using API-First Strict Workflow.

[Fill in placeholders:]
- FEATURE_NAME: Budget Control Tracking
- DATABASE_NAME: inventory
- TABLE_NAME: budget_control_settings
- SCHEMA_NAME: inventory
- DOMAIN: inventory/budget
- ENDPOINT: /api/inventory/budget/budget-control-settings
- FIELDS:
  - budget_id (uuid, foreign key)
  - threshold_percentage (decimal, 0-100)
  - alert_enabled (boolean)
  - notification_recipients (jsonb)
```

---

## 🎯 Quick Reference

### Phase Order (NEVER SKIP!)

```
1. Database ✓
2. Backend API ✓
3. API Testing (curl) ✓ CRITICAL
4. API Contract ✓
5. Frontend ✓
6. Alignment Check ✓ CRITICAL
7. UI Testing ✓
8. Automated Testing ✓
9. Documentation ✓
```

### Mandatory Rules

```
✅ Show test results every phase
✅ API tested with curl before frontend
✅ Frontend calls real API only
✅ Alignment must be 100%
✅ Build must be 0 errors
```

---

## 📚 Related Documentation

- **Rule File**: `.claude/rules/api-first-workflow.md`
- **API Debugging**: `.claude/rules/api-debugging.md`
- **Task Structure**: `.claude/rules/task-structure.md`
- **Git Workflow**: `.claude/rules/git-workflow.md`

---

**Template Version**: 1.0.0
**Created**: 2025-12-23
**Ready to Use**: Copy and fill placeholders
