---
name: security-scan
description: Run automated security scanning for vulnerabilities, dependency issues, and security best practices. Use before deployments, after dependency updates, or for security audits.
allowed-tools: Bash, Read, Grep, Glob
---

# Security Scan Skill

> **🔐 Automated security scanning and vulnerability detection**
>
> **Comprehensive security analysis before deployment**

---

## 🎯 Purpose

**Problem:**

- Security vulnerabilities go undetected
- Outdated dependencies with known CVEs
- No automated security checks
- Manual security review is time-consuming

**Solution:**

- Automated dependency vulnerability scanning
- Security best practices validation
- Pre-deployment security gates
- Continuous security monitoring

---

## 📋 When to Use

**MANDATORY before:**

- ✅ Production deployments
- ✅ Staging deployments
- ✅ Creating pull requests
- ✅ After dependency updates
- ✅ Weekly security audits

**OPTIONAL for:**

- Security research
- Compliance audits
- Security training

---

## 🚀 Usage

```bash
User: /security-scan full          # Complete security scan
User: /security-scan dependencies  # Dependency vulnerabilities only
User: /security-scan code          # Code security patterns only
User: /security-scan api           # API security validation
User: /security-scan quick         # Quick pre-commit scan
```

---

## 🛡️ Security Scan Types

### 1. Dependency Vulnerability Scan

**Tool:** `pnpm audit`

**What it checks:**

- Known CVEs in npm packages
- Security advisories
- Outdated packages with fixes
- Severity levels (low, moderate, high, critical)

**Command:**

```bash
pnpm audit --audit-level=moderate
```

**Pass Criteria:**

- ✅ No critical vulnerabilities
- ✅ No high vulnerabilities
- ⚠️ Moderate vulnerabilities documented and justified
- ℹ️ Low vulnerabilities acceptable

---

### 2. Code Security Patterns

**What it checks:**

- SQL injection vulnerabilities
- XSS vulnerabilities
- Authentication/Authorization issues
- Secrets in code
- Unsafe eval() usage
- Console.log in production code

**Patterns to Check:**

#### SQL Injection Prevention

```bash
# Check for string concatenation in SQL (dangerous)
grep -r "WHERE.*+.*req\." apps/api/src/
grep -r "\`SELECT.*\${" apps/api/src/

# Should use: Parameterized queries or Knex query builder
# ✅ GOOD: db.where('id', userId)
# ❌ BAD: db.raw(`WHERE id = ${userId}`)
```

#### XSS Prevention

```bash
# Check for innerHTML usage (dangerous)
grep -r "innerHTML" apps/web/src/

# Check for unsafe sanitization bypass
grep -r "bypassSecurityTrust" apps/web/src/

# Should use: Angular's built-in sanitization
# ✅ GOOD: {{ data }} (auto-escaped)
# ❌ BAD: [innerHTML]="data" (unsafe)
```

#### Secrets Detection

```bash
# Check for hardcoded secrets
grep -ri "password.*=.*['\"]" apps/ | grep -v "node_modules" | grep -v ".env"
grep -ri "api.*key.*=.*['\"]" apps/ | grep -v "node_modules"
grep -ri "secret.*=.*['\"]" apps/ | grep -v "node_modules" | grep -v ".env"

# Should use: Environment variables
# ✅ GOOD: process.env.API_KEY
# ❌ BAD: const API_KEY = "abc123"
```

#### Authentication Issues

```bash
# Check for missing authentication
grep -r "fastify\\.get\\|fastify\\.post" apps/api/src/layers/domains/ -A 5 | \
  grep -v "preValidation.*authenticate"

# All routes should have authentication
# ✅ GOOD: preValidation: [fastify.authenticate]
# ❌ BAD: No preValidation (public endpoint unintended)
```

---

### 3. API Security Validation

**What it checks:**

- Missing authentication on protected routes
- Missing authorization checks
- Missing input validation (TypeBox schemas)
- Missing rate limiting
- CORS configuration
- Security headers

**Checks:**

#### Route Security

```bash
# Find routes without authentication
find apps/api/src/layers/domains -name "*.route.ts" -exec grep -L "authenticate" {} \;

# Find routes without schemas (validation)
grep -r "fastify\\.post\\|fastify\\.put" apps/api/src/ -A 10 | grep -v "schema:"
```

#### CORS Configuration

```bash
# Check CORS settings
grep -r "fastify-cors\\|@fastify/cors" apps/api/src/

# Verify not using wildcard in production
# ❌ BAD: origin: "*"
# ✅ GOOD: origin: ["https://app.aegisx.com"]
```

#### Security Headers

```bash
# Check if helmet is used
grep -r "fastify-helmet\\|@fastify/helmet" apps/api/src/

# Should have security headers:
# - X-Frame-Options
# - X-Content-Type-Options
# - Strict-Transport-Security
```

---

### 4. Environment Security

**What it checks:**

- .env files not committed
- Secrets in .env.example
- Production environment variables

**Checks:**

```bash
# Verify .env not in git
git ls-files | grep "\.env$"
# Should be empty

# Check .env.example has no real secrets
cat .env.example | grep -i "password\|secret\|key" | grep -v "YOUR_"
# Should use placeholders like YOUR_PASSWORD_HERE

# Check required production env vars documented
cat docs/deployment/environment-variables.md
```

---

## 📊 Security Scan Report Format

````markdown
# Security Scan Report

**Date:** 2025-12-20 14:30:00
**Environment:** Production
**Scan Type:** Full
**Status:** ✅ PASS / ⚠️ WARNINGS / ❌ FAIL

---

## Summary

- 🛡️ **Dependency Vulnerabilities:** 0 critical, 0 high, 2 moderate, 5 low
- 🔍 **Code Security:** 0 critical issues, 3 warnings
- 🔐 **API Security:** All routes protected
- 🌐 **Environment:** No secrets exposed

**Overall:** ✅ SAFE TO DEPLOY

---

## Dependency Vulnerabilities (2 moderate, 5 low)

### Moderate (2)

| Package | Severity | Issue                           | Fix Available |
| ------- | -------- | ------------------------------- | ------------- |
| axios   | Moderate | SSRF vulnerability              | ✅ 1.6.0      |
| ws      | Moderate | ReDoS in Sec-Websocket-Protocol | ✅ 8.14.0     |

**Action Required:**

```bash
pnpm update axios@1.6.0 ws@8.14.0
```
````

### Low (5)

| Package | Severity | Issue               | Fix Available |
| ------- | -------- | ------------------- | ------------- |
| semver  | Low      | ReDoS vulnerability | ✅ 7.5.3      |
| ...     | ...      | ...                 | ...           |

**Action:** Update in next maintenance window

---

## Code Security Issues (3 warnings)

### ⚠️ Warning: console.log in production code

**Location:** `apps/api/src/layers/domains/inventory/drugs/drugs.service.ts:45`

```typescript
console.log('Drug created:', drug); // Line 45
```

**Recommendation:** Remove or use proper logging

**Impact:** Low - Information disclosure in logs

---

### ⚠️ Warning: innerHTML usage

**Location:** `apps/web/src/app/features/inventory/modules/drugs/components/drug-detail.component.ts:78`

```typescript
element.innerHTML = description; // Line 78
```

**Recommendation:** Use Angular's safe binding or sanitize

**Impact:** Medium - Potential XSS if description is user-controlled

---

## API Security (✅ All Protected)

**Total Routes:** 156
**Protected:** 156
**Public:** 0
**With Validation:** 156
**With Authorization:** 148 (8 admin-only routes)

✅ All routes have authentication
✅ All routes have input validation (TypeBox schemas)
✅ All routes return proper error schemas

---

## Environment Security (✅ Pass)

✅ No .env files in git
✅ .env.example uses placeholders
✅ All production env vars documented
✅ No hardcoded secrets found

---

## Recommendations

### Immediate (Before Deploy)

1. Update axios and ws packages (moderate vulnerabilities)
2. Remove console.log from drugs.service.ts
3. Sanitize HTML in drug-detail.component.ts

### Next Maintenance

1. Update 5 packages with low vulnerabilities
2. Add rate limiting to public endpoints
3. Implement Content Security Policy headers

### Long Term

1. Setup automated security scanning in CI/CD
2. Implement dependency update automation (Dependabot)
3. Add OWASP ZAP dynamic security testing

---

**Scan completed in:** 45 seconds
**Next scan:** Before next deployment

````

---

## 🔍 Automated Scan Script

### Full Security Scan

```bash
#!/bin/bash
# Full Security Scan Script

echo "🔐 Starting Security Scan"
echo "========================"

CRITICAL_COUNT=0
HIGH_COUNT=0
MODERATE_COUNT=0
WARNINGS=0

# 1. Dependency Vulnerabilities
echo ""
echo "📦 Scanning Dependencies..."
pnpm audit --json > /tmp/audit.json

# Parse audit results
CRITICAL_COUNT=$(cat /tmp/audit.json | grep -o '"severity":"critical"' | wc -l)
HIGH_COUNT=$(cat /tmp/audit.json | grep -o '"severity":"high"' | wc -l)
MODERATE_COUNT=$(cat /tmp/audit.json | grep -o '"severity":"moderate"' | wc -l)

echo "   Critical: $CRITICAL_COUNT"
echo "   High: $HIGH_COUNT"
echo "   Moderate: $MODERATE_COUNT"

if [ "$CRITICAL_COUNT" -gt 0 ] || [ "$HIGH_COUNT" -gt 0 ]; then
    echo "   ❌ FAIL: Critical or high vulnerabilities found"
    echo "   Run: pnpm audit --audit-level=high"
    exit 1
fi

# 2. SQL Injection Patterns
echo ""
echo "🛡️  Checking SQL Injection Patterns..."
SQL_ISSUES=$(grep -r "WHERE.*+.*req\." apps/api/src/ 2>/dev/null | wc -l)
if [ "$SQL_ISSUES" -gt 0 ]; then
    echo "   ⚠️  WARNING: Found $SQL_ISSUES potential SQL injection patterns"
    grep -rn "WHERE.*+.*req\." apps/api/src/
    WARNINGS=$((WARNINGS + SQL_ISSUES))
fi

# 3. XSS Patterns
echo ""
echo "🌐 Checking XSS Patterns..."
XSS_ISSUES=$(grep -r "innerHTML" apps/web/src/ 2>/dev/null | grep -v "node_modules" | wc -l)
if [ "$XSS_ISSUES" -gt 0 ]; then
    echo "   ⚠️  WARNING: Found $XSS_ISSUES innerHTML usages"
    grep -rn "innerHTML" apps/web/src/ | grep -v "node_modules"
    WARNINGS=$((WARNINGS + XSS_ISSUES))
fi

# 4. Hardcoded Secrets
echo ""
echo "🔑 Checking for Hardcoded Secrets..."
SECRET_ISSUES=$(grep -ri "password.*=.*['\"]" apps/ | grep -v "node_modules" | grep -v ".env" | grep -v "example" | wc -l)
if [ "$SECRET_ISSUES" -gt 0 ]; then
    echo "   ⚠️  WARNING: Found $SECRET_ISSUES potential hardcoded secrets"
    grep -rni "password.*=.*['\"]" apps/ | grep -v "node_modules" | grep -v ".env" | grep -v "example"
    WARNINGS=$((WARNINGS + SECRET_ISSUES))
fi

# 5. console.log in production code
echo ""
echo "📢 Checking for console.log..."
CONSOLE_LOGS=$(grep -r "console\.log" apps/api/src/ apps/web/src/ | grep -v "node_modules" | wc -l)
if [ "$CONSOLE_LOGS" -gt 0 ]; then
    echo "   ℹ️  INFO: Found $CONSOLE_LOGS console.log statements"
    echo "   (Consider removing before production deploy)"
fi

# 6. .env files in git
echo ""
echo "🔒 Checking .env Files..."
ENV_IN_GIT=$(git ls-files | grep "\.env$" | wc -l)
if [ "$ENV_IN_GIT" -gt 0 ]; then
    echo "   ❌ CRITICAL: .env files found in git!"
    git ls-files | grep "\.env$"
    exit 1
fi

# 7. Authentication on routes
echo ""
echo "🔐 Checking Route Authentication..."
UNAUTH_ROUTES=$(find apps/api/src/layers/domains -name "*.route.ts" -exec grep -L "authenticate" {} \; | wc -l)
if [ "$UNAUTH_ROUTES" -gt 0 ]; then
    echo "   ⚠️  WARNING: Found $UNAUTH_ROUTES routes without authentication"
    find apps/api/src/layers/domains -name "*.route.ts" -exec grep -L "authenticate" {} \;
    WARNINGS=$((WARNINGS + UNAUTH_ROUTES))
fi

# Summary
echo ""
echo "========================"
echo "📊 Security Scan Summary"
echo "========================"
echo "Dependencies:"
echo "  Critical: $CRITICAL_COUNT"
echo "  High: $HIGH_COUNT"
echo "  Moderate: $MODERATE_COUNT"
echo ""
echo "Code Issues:"
echo "  Warnings: $WARNINGS"
echo "  console.log: $CONSOLE_LOGS"
echo ""

if [ "$CRITICAL_COUNT" -eq 0 ] && [ "$HIGH_COUNT" -eq 0 ]; then
    echo "✅ SECURITY SCAN PASSED"
    echo "   Safe to deploy"
    exit 0
else
    echo "❌ SECURITY SCAN FAILED"
    echo "   Fix critical/high issues before deploying"
    exit 1
fi
````

---

## 🎯 Quick Security Checks

### Pre-Commit

```bash
# Quick 30-second scan before commit
pnpm audit --audit-level=high
grep -r "console\.log" apps/api/src/ | wc -l
git diff --cached | grep -i "password.*=.*['\"]"
```

### Pre-Deploy

```bash
# Full scan before deployment (~2 minutes)
pnpm audit --audit-level=moderate
# Run full security scan script above
```

### Weekly Audit

```bash
# Comprehensive weekly security audit
pnpm audit
pnpm outdated
# Review all warnings
# Update dependencies
```

---

## 🔧 Integration with CI/CD

### GitHub Actions Security Check

```yaml
name: Security Scan

on:
  pull_request:
    branches: [main, develop]
  schedule:
    # Run weekly on Mondays at 9 AM
    - cron: '0 9 * * 1'

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install pnpm
        run: npm install -g pnpm

      - name: Install dependencies
        run: pnpm install

      - name: Run Security Audit
        run: pnpm audit --audit-level=high

      - name: Check for Secrets
        run: |
          ! grep -ri "password.*=.*['\"]" apps/ | grep -v "node_modules" | grep -v ".env" | grep -v "example"

      - name: Check .env Files
        run: |
          ! git ls-files | grep "\.env$"
```

---

## 📋 Security Checklist

### Before Every Deployment

- [ ] Run `pnpm audit --audit-level=high` (MUST pass)
- [ ] Check for hardcoded secrets
- [ ] Verify .env not in git
- [ ] Check console.log count
- [ ] Verify all routes have authentication
- [ ] Check SQL injection patterns
- [ ] Check XSS vulnerabilities

### After Dependency Updates

- [ ] Run `pnpm audit`
- [ ] Review breaking changes
- [ ] Test critical functionality
- [ ] Check for new vulnerabilities

### Weekly Security Audit

- [ ] Run full security scan
- [ ] Review all warnings
- [ ] Update dependencies with fixes
- [ ] Document accepted risks

---

## 🚨 Common Security Issues

### 1. SQL Injection

**❌ Vulnerable:**

```typescript
const query = `SELECT * FROM users WHERE id = ${req.params.id}`;
```

**✅ Safe:**

```typescript
const user = await db('users').where('id', req.params.id).first();
```

### 2. XSS

**❌ Vulnerable:**

```typescript
element.innerHTML = userInput;
```

**✅ Safe:**

```angular
<div>{{ userInput }}</div>
<!-- Auto-escaped -->
```

### 3. Secrets in Code

**❌ Vulnerable:**

```typescript
const JWT_SECRET = 'my-secret-key-123';
```

**✅ Safe:**

```typescript
const JWT_SECRET = process.env.JWT_SECRET;
```

### 4. Missing Authentication

**❌ Vulnerable:**

```typescript
fastify.get('/api/admin/users', handler);
```

**✅ Safe:**

```typescript
fastify.get(
  '/api/admin/users',
  {
    preValidation: [fastify.authenticate, fastify.verifyPermission('users', 'read')],
  },
  handler,
);
```

---

**Version**: 1.0.0
**Priority**: CRITICAL
**Scan Time**: Quick scan ~30s, Full scan ~2 min
**Frequency**: Before every deployment + Weekly audit
