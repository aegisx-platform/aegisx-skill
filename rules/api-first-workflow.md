# API-First Development Workflow

## The Rule: NO feature complete until ALL phases pass

```
Phase 1: Backend API → Test with curl → ALL CRUD 200 OK
Phase 2: API Contract → docs/features/[feature]/API_CONTRACTS.md → Validate
Phase 2.5: Spec Critic (if auth/payments/complex) → Review edge cases
Phase 3: Frontend → Read contract FIRST → Test full integration
```

**FORBIDDEN:** "I'll test later", skip phases, proceed on failure
**REQUIRED:** Test immediately, show evidence, fix before proceeding

## Phase 1 Checkpoint

- Build SUCCESS + Server starts
- GET 200, POST 201, PUT 200, DELETE 200
- If ANY fail → STOP, fix, re-test

## Phase 2: Use `api-contract-generator` + `api-contract-validator` skills

## Phase 2.5: MANDATORY for auth/payments/PII/external APIs/complex logic

## Phase 3 Checkpoint

- Build SUCCESS (API + Web)
- All CRUD works in browser
- No 404/500 in console
