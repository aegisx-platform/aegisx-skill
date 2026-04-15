---
name: quality-gate
description: Run 10-point automated quality checklist before feature completion. Use to validate build success, code quality, testing, documentation, and production readiness.
allowed-tools: Bash, Read, Grep, Glob
---

# Quality Gate Skill

> **10-Point Automated Quality Checklist**
>
> **MANDATORY before feature completion**

---

## 🎯 Purpose

**Problem:**

- Build passing ≠ production ready
- Easy to miss quality issues
- No standardized quality criteria

**Solution:**

- Automated 10-point quality checklist
- Scored validation (0-100)
- Pass/fail gates before completion
- Detailed quality report

---

## 📋 The 10 Quality Gates

### Gate 1: Build Success ✅

**Criteria:**

```bash
pnpm run build → EXIT CODE 0
No TypeScript errors
No compilation errors
```

**Check:**

```typescript
run_command("pnpm run build")
if exit_code != 0:
    FAIL: "Build failed with errors"
else:
    PASS: "Build successful"
```

**Weight:** 15 points (CRITICAL)

---

### Gate 2: Test Coverage ✅

**Criteria:**

```bash
All new code has tests
Unit tests pass
Integration tests pass (if applicable)
Coverage > 70% for new files
```

**Check:**

```typescript
run_command("pnpm run test")
check_coverage_report()
if new_files_coverage < 70:
    WARN: "Coverage below 70%"
if tests_failed > 0:
    FAIL: "Tests failing"
else:
    PASS: "All tests passing"
```

**Weight:** 15 points (CRITICAL)

---

### Gate 3: API Contract Compliance ✅

**Criteria:**

```bash
All API endpoints match contracts
Request/response schemas valid
TypeBox validation present
Authentication/authorization correct
```

**Check:**

```typescript
if has_api_changes:
    contracts = read_api_contracts()
    for endpoint in contracts:
        if not endpoint_exists(endpoint):
            FAIL: f"Missing endpoint: {endpoint}"
        if not has_validation(endpoint):
            FAIL: f"Missing validation: {endpoint}"
```

**Weight:** 10 points (HIGH)

---

### Gate 4: TypeScript Strict Mode ✅

**Criteria:**

```bash
No 'any' types (unless documented)
No type assertions without justification
Strict null checks pass
No implicit any
```

**Check:**

```typescript
scan_for_patterns([
    r'\bany\b',
    r'as \w+(?!\s*/\*)',  # Type assertion without comment
    r'@ts-ignore',
    r'@ts-expect-error'
])
for match in matches:
    if not has_justification_comment(match):
        WARN: f"Unjustified use at {match.file}:{match.line}"
```

**Weight:** 10 points (MEDIUM)

---

### Gate 5: Production Code Hygiene ✅

**Criteria:**

```bash
No console.log in production code
No debugger statements
No commented-out code blocks
No TODO without issue link
```

**Check:**

```typescript
production_files = get_production_files()
for file in production_files:
    if contains(file, 'console.log'):
        FAIL: f"console.log found in {file}"
    if contains(file, 'debugger'):
        FAIL: f"debugger found in {file}"
    if has_commented_code(file):
        WARN: f"Commented code in {file}"
    if has_unlinked_todo(file):
        WARN: f"TODO without issue in {file}"
```

**Weight:** 10 points (MEDIUM)

---

### Gate 6: Documentation Complete ✅

**Criteria:**

```bash
Complex functions have JSDoc
API endpoints documented
README updated (if needed)
COMPLETION.md exists
```

**Check:**

```typescript
complex_functions = find_complex_functions()  # Cyclomatic > 10
for func in complex_functions:
    if not has_jsdoc(func):
        WARN: f"Missing docs: {func.name} in {func.file}"

if has_new_apis:
    if not api_contracts_updated:
        FAIL: "API contracts not updated"

if is_feature:
    if not exists("COMPLETION.md"):
        FAIL: "COMPLETION.md missing"
```

**Weight:** 10 points (MEDIUM)

---

### Gate 7: Spec Compliance ✅

**Criteria:**

```bash
Spec compliance > 95%
All requirements implemented
All tasks completed
No major gaps
```

**Check:**

```typescript
if has_spec:
    score = run_spec_validator()
    if score < 95:
        FAIL: f"Spec compliance {score}% < 95%"
    else:
        PASS: f"Spec compliance {score}%"
else:
    SKIP: "No spec to validate"
```

**Weight:** 15 points (CRITICAL)

---

### Gate 8: Performance Benchmarks ✅

**Criteria:**

```bash
API response < 200ms (p95)
Database queries optimized
No N+1 queries
Bundle size acceptable
```

**Check:**

```typescript
if has_api_endpoints:
    perf = measure_api_performance()
    if perf.p95 > 200:
        WARN: f"API p95 {perf.p95}ms > 200ms"

if has_db_queries:
    queries = analyze_queries()
    if has_n_plus_one(queries):
        FAIL: "N+1 query detected"
```

**Weight:** 5 points (LOW - not always applicable)

---

### Gate 9: Security Scan ✅

**Criteria:**

```bash
No hardcoded secrets
No SQL injection vulnerabilities
Input validation present
XSS prevention in place
```

**Check:**

```typescript
scan_for_security_issues([
    'password.*=.*["\']',  # Hardcoded passwords
    'api.*key.*=.*["\']',  # Hardcoded API keys
    'raw SQL without params',
    'innerHTML without sanitization'
])
for issue in security_issues:
    FAIL: f"Security issue: {issue}"
```

**Weight:** 10 points (HIGH)

---

### Gate 10: Git Hygiene ✅

**Criteria:**

```bash
Meaningful commit messages
No merge conflicts
No accidentally committed files
Branch up to date with base
```

**Check:**

```typescript
commits = get_commits_since_branch()
for commit in commits:
    if len(commit.message) < 10:
        WARN: f"Short commit message: {commit.hash}"
    if not follows_convention(commit.message):
        WARN: f"Non-standard message: {commit.hash}"

if has_merge_conflicts:
    FAIL: "Merge conflicts present"

if has_unwanted_files(['.env', 'node_modules']):
    FAIL: "Unwanted files committed"
```

**Weight:** 0 points (Informational)

---

## 📊 Scoring System

### Total Points: 100

```
Gate 1: Build Success          15 pts (CRITICAL)
Gate 2: Test Coverage          15 pts (CRITICAL)
Gate 3: API Contracts          10 pts (HIGH)
Gate 4: TypeScript Strict      10 pts (MEDIUM)
Gate 5: Code Hygiene          10 pts (MEDIUM)
Gate 6: Documentation         10 pts (MEDIUM)
Gate 7: Spec Compliance       15 pts (CRITICAL)
Gate 8: Performance            5 pts (LOW)
Gate 9: Security              10 pts (HIGH)
Gate 10: Git Hygiene           0 pts (INFO)
---
Total:                        100 pts
```

### Pass Thresholds

```
Score >= 90: ✅ EXCELLENT - Production ready
Score >= 80: ✅ GOOD - Minor issues
Score >= 70: ⚠️  ACCEPTABLE - Fix warnings
Score >= 60: ⚠️  NEEDS WORK - Fix failures
Score < 60:  ❌ FAIL - Major issues
```

---

## 📝 Quality Report Format

````markdown
# Quality Gate Report

**Feature:** Stock Alerts
**Date:** 2025-12-20 15:00
**Score:** 92/100 ✅ EXCELLENT

---

## Summary

✅ **PASS** - Production ready with minor recommendations

**Breakdown:**

- Critical gates: 3/3 ✅
- High priority: 2/2 ✅
- Medium priority: 3/4 ⚠️ (1 warning)
- Low priority: 1/1 ✅

---

## Gate Results

### ✅ Gate 1: Build Success (15/15)

```bash
$ pnpm run build
✓ Build completed successfully
✓ No TypeScript errors
✓ All dependencies resolved
```
````

**Status:** PASS
**Time:** 45s

---

### ✅ Gate 2: Test Coverage (15/15)

```bash
$ pnpm run test
✓ 45/45 tests passing
✓ Coverage: 85% (target: 70%)
✓ No flaky tests
```

**Coverage Breakdown:**

- Statements: 87%
- Branches: 82%
- Functions: 89%
- Lines: 85%

**Status:** PASS

---

### ✅ Gate 3: API Contract Compliance (10/10)

**Endpoints Validated:** 12/12

| Method | Path                 | Contract | Implementation | Status |
| ------ | -------------------- | -------- | -------------- | ------ |
| GET    | /api/alerts          | ✓        | ✓              | PASS   |
| POST   | /api/alerts/settings | ✓        | ✓              | PASS   |
| PUT    | /api/alerts/:id      | ✓        | ✓              | PASS   |
| DELETE | /api/alerts/:id      | ✓        | ✓              | PASS   |

**Status:** PASS

---

### ⚠️ Gate 4: TypeScript Strict (8/10)

**Issues Found:** 2 warnings

1. ⚠️ Line 245: `as any` without justification

   ```typescript
   // apps/api/src/services/alert.service.ts:245
   const config = options as any;
   ```

   **Recommendation:** Add comment explaining why

2. ⚠️ Line 312: Implicit any parameter
   ```typescript
   // apps/web/src/app/alerts/utils.ts:312
   function formatDate(date) {  // Missing type
   ```
   **Recommendation:** Add type annotation

**Status:** PASS (with warnings)
**Score:** 8/10 (-2 for warnings)

---

### ✅ Gate 5: Code Hygiene (10/10)

**Scanned:** 24 files

✓ No console.log in production
✓ No debugger statements
✓ No large commented blocks
✓ All TODOs linked to issues

**Status:** PASS

---

### ✅ Gate 6: Documentation (10/10)

**Documented:**

- ✓ API contracts (12 endpoints)
- ✓ Complex functions (5/5 have JSDoc)
- ✓ README updated
- ✓ COMPLETION.md exists

**Status:** PASS

---

### ✅ Gate 7: Spec Compliance (15/15)

**Compliance Score:** 96%

- Requirements: 18/19 (95%)
- Design: 24/24 (100%)
- Tasks: 12/12 (100%)

**Missing:** 1 nice-to-have feature (documented)

**Status:** PASS

---

### ✅ Gate 8: Performance (5/5)

**API Performance:**

- p50: 45ms ✓
- p95: 178ms ✓ (target: < 200ms)
- p99: 245ms ⚠️ (slightly high)

**Database:**

- No N+1 queries detected ✓
- All queries use indexes ✓

**Bundle Size:**

- Main bundle: 245 KB (acceptable)

**Status:** PASS

---

### ✅ Gate 9: Security (10/10)

**Scanned:** 24 files

✓ No hardcoded secrets
✓ No SQL injection risks
✓ Input validation present
✓ XSS prevention implemented
✓ Authentication required
✓ Authorization checked

**Status:** PASS

---

### ℹ️ Gate 10: Git Hygiene (INFO)

**Commits:** 8 commits

✓ All commit messages meaningful
✓ Follows conventional commits
✓ No merge conflicts
✓ No unwanted files
✓ Branch up to date

**Status:** PASS

---

## Recommendations

### Before Completion:

1. **Fix TypeScript warnings (Gate 4)**
   - Add justification comment for `as any` at line 245
   - Add type annotation for `formatDate` parameter

2. **Optional: Optimize p99 performance**
   - Current: 245ms
   - Target: < 200ms
   - Impact: LOW (only 1% of requests)

### After Fixes:

Expected score: 100/100
Re-run quality gate to confirm.

---

## ✅ Approval

**Status:** APPROVED FOR COMPLETION
**Confidence:** HIGH
**Ready for:** /feature-done

---

**Scan Duration:** 12 seconds
**Validation Method:** Automated + manual verification
**Next Steps:** Address warnings → Re-scan → Complete feature

````

---

## 🚀 Usage

### Command

```bash
User: /quality-gate
User: /quality-gate [feature-name]
````

### When to Run

**MANDATORY:**

- Before `/feature-done`
- Before creating PR
- After all tasks complete

**OPTIONAL:**

- After each phase
- Mid-development check
- After major refactoring

---

## 🔧 Implementation

### For Claude:

```typescript
async function runQualityGate(featureName?: string) {
  console.log('🔍 Running Quality Gate...\n');

  const results = [];

  // Gate 1: Build
  results.push(await checkBuild());

  // Gate 2: Tests
  results.push(await checkTests());

  // Gate 3: API Contracts
  if (hasApiChanges()) {
    results.push(await checkApiContracts());
  }

  // Gate 4: TypeScript
  results.push(await checkTypeScript());

  // Gate 5: Code Hygiene
  results.push(await checkCodeHygiene());

  // Gate 6: Documentation
  results.push(await checkDocumentation());

  // Gate 7: Spec Compliance
  if (hasSpec(featureName)) {
    results.push(await checkSpecCompliance(featureName));
  }

  // Gate 8: Performance
  if (hasPerformanceTests()) {
    results.push(await checkPerformance());
  }

  // Gate 9: Security
  results.push(await checkSecurity());

  // Gate 10: Git
  results.push(await checkGitHygiene());

  // Calculate score
  const score = calculateScore(results);

  // Generate report
  const report = generateReport(results, score);

  // Present to user
  presentReport(report);

  // Return pass/fail
  return score >= 80 ? 'PASS' : 'FAIL';
}
```

---

## 📊 Integration

### With Spec Validator:

```
Quality Gate → Gate 7 → Runs Spec Validator
            → Uses compliance score
            → Integrates results
```

### With Session System:

```
Quality Gate → Save results to session
            → Track fixes applied
            → Re-run after fixes
```

### With Feature Tracking:

```
Quality Gate PASS → Ready for /feature-done
                 → Update FEATURES.md
                 → Mark as complete
```

---

## 💡 Best Practices

### For Users:

**Run early, run often:**

```bash
# Don't wait until the end
User: /quality-gate  # Mid-development check
[Fix issues]
User: /quality-gate  # Before completion
```

**Don't ignore warnings:**

```
Warnings = Technical debt
Address them before completion
```

### For Claude:

**Auto-run before completion:**

```typescript
if user_says_done:
    score = run_quality_gate()
    if score < 80:
        "Please fix these issues first:"
        list_issues()
        return
    else:
        proceed_to_completion()
```

**Provide actionable feedback:**

```
❌ BAD: "TypeScript errors found"
✅ GOOD: "Fix type error at alert.service.ts:245 - add parameter type"
```

---

## 🎯 Example Scenarios

### Scenario 1: Perfect Score

```
$ /quality-gate stock-alerts

🔍 Running Quality Gate...

✅ Gate 1: Build Success (15/15)
✅ Gate 2: Test Coverage (15/15)
✅ Gate 3: API Contracts (10/10)
✅ Gate 4: TypeScript Strict (10/10)
✅ Gate 5: Code Hygiene (10/10)
✅ Gate 6: Documentation (10/10)
✅ Gate 7: Spec Compliance (15/15)
✅ Gate 8: Performance (5/5)
✅ Gate 9: Security (10/10)
✅ Gate 10: Git Hygiene (PASS)

Score: 100/100 ✅ EXCELLENT

Status: APPROVED FOR COMPLETION
Next: Run /feature-done
```

### Scenario 2: Minor Issues

```
$ /quality-gate budget-control

🔍 Running Quality Gate...

✅ Gate 1: Build Success (15/15)
✅ Gate 2: Test Coverage (15/15)
✅ Gate 3: API Contracts (10/10)
⚠️ Gate 4: TypeScript Strict (8/10) - 2 warnings
✅ Gate 5: Code Hygiene (10/10)
⚠️ Gate 6: Documentation (8/10) - Missing JSDoc
✅ Gate 7: Spec Compliance (15/15)
✅ Gate 8: Performance (5/5)
✅ Gate 9: Security (10/10)
✅ Gate 10: Git Hygiene (PASS)

Score: 96/100 ✅ GOOD

Issues:
1. Add type annotations (Gate 4)
2. Document complex functions (Gate 6)

Status: APPROVED (fix warnings recommended)
```

### Scenario 3: Critical Failures

```
$ /quality-gate inventory-import

🔍 Running Quality Gate...

❌ Gate 1: Build Success (0/15) - BUILD FAILED
⚠️ Gate 2: Test Coverage (10/15) - 3 tests failing
✅ Gate 3: API Contracts (10/10)
✅ Gate 4: TypeScript Strict (10/10)
❌ Gate 5: Code Hygiene (0/10) - console.log found
⚠️ Gate 6: Documentation (6/10) - Incomplete
❌ Gate 7: Spec Compliance (8/15) - Only 65% compliant
N/A Gate 8: Performance (0/5) - Can't test (build failed)
✅ Gate 9: Security (10/10)
✅ Gate 10: Git Hygiene (PASS)

Score: 54/100 ❌ FAIL

Critical Issues:
1. Fix build errors (BLOCKER)
2. Fix failing tests (BLOCKER)
3. Remove console.log (BLOCKER)
4. Improve spec compliance to 95%+ (BLOCKER)

Status: NOT READY - Fix critical issues
```

---

## 🔍 Advanced Features

### Custom Gates

```typescript
// Add project-specific gates
const customGates = [
  {
    name: 'Accessibility Check',
    weight: 5,
    check: () => checkA11y(),
  },
  {
    name: 'i18n Complete',
    weight: 5,
    check: () => checkTranslations(),
  },
];
```

### Continuous Quality

```typescript
// Run on every commit (CI/CD)
git_hook('pre-push', () => {
  const score = runQualityGate();
  if (score < 70) {
    console.error('Quality score too low. Fix issues before pushing.');
    exit(1);
  }
});
```

---

**Version**: 1.0.0
**Gates**: 10 (configurable)
**Automation**: Fully automated
**Runtime**: ~10-30 seconds
**Pass Threshold**: 80/100
