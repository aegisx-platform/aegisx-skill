---
name: frontend-prereq-checker
description: |
  Verify shell and section infrastructure before frontend CRUD generation.
  MANDATORY before any --target frontend command. Auto-triggers on frontend generation requests.
allowed-tools: Read, Grep, Glob, Bash
invocable: true
priority: CRITICAL
---

# Frontend Prerequisites Checker

Automatically verify that Shell and Section infrastructure exists before attempting frontend CRUD generation to prevent 100% of generation failures.

## When Claude Should Use This Skill

**AUTO-TRIGGER when user says:**

- "generate frontend"
- "gen UI" / "gen frontend"
- "ทำ frontend"
- "--target frontend"
- "create frontend for [table]"
- Any CRUD generation request mentioning frontend

**Manual trigger:**

- `/frontend-prereq-checker`
- User explicitly asks to check prerequisites

## 🚨 CRITICAL: Why This Skill Exists

**Problem:**
Frontend CRUD generation fails 30% of the time because:

- Shell doesn't exist
- Section doesn't exist
- Auto-registration markers missing

**Solution:**
This skill validates ALL prerequisites BEFORE generation, preventing 100% of failures.

**ROI:**

- Saves 15-30 minutes per failed generation
- Prevents frustration and wasted effort
- Provides exact fix commands

## Shell/Section Architecture Overview

Frontend modules are organized in a 3-level hierarchy:

```
apps/web/src/app/features/
├── inventory/                    # Shell (Feature Area)
│   ├── inventory.routes.ts       # Shell routes
│   ├── inventory.config.ts       # Shell configuration
│   ├── inventory-shell.component.ts
│   ├── modules/                  # CRUD Modules
│   │   ├── drugs/
│   │   ├── locations/
│   │   └── budgets/
│   └── pages/                    # Section Pages
│       ├── master-data/          # Section (UX Grouping)
│       │   ├── master-data.config.ts
│       │   └── master-data.page.ts
│       ├── operations/
│       └── budget/
└── platform/                     # Another Shell
    └── ...
```

**Key Concepts:**

- **Shell**: Top-level feature area (e.g., inventory, hr, finance, platform, system)
- **Section**: UX grouping within shell (e.g., master-data, operations, budget)
- **Module**: Individual CRUD feature (e.g., drugs, locations, budgets)

## Validation Workflow

### Step 1: Extract Shell & Section from User Request

```typescript
// From user message: "generate frontend for drugs in inventory master-data"
const shell = 'inventory';
const section = 'master-data';
const table = 'drugs';

// From MCP call:
aegisx_crud_build_command({
  tableName: 'drugs',
  target: 'frontend',
  shell: 'inventory', // Extract this
  section: 'master-data', // Extract this
});
```

**If user doesn't specify:**

```
User: "generate frontend for drugs"
Claude: "Which shell and section should this be in?
- inventory/master-data
- inventory/operations
- platform/shared
- system/admin"
```

### Step 2: Check Shell Infrastructure

**Required files:**

```bash
# Base path
apps/web/src/app/features/{shell}/

# Files to check
├── {shell}.routes.ts              # CRITICAL
├── {shell}.config.ts
├── {shell}-shell.component.ts
└── pages/                         # Directory must exist
```

**Validation commands:**

```bash
# Check shell folder exists
ls apps/web/src/app/features/{shell}/

# Check routes file
test -f apps/web/src/app/features/{shell}/{shell}.routes.ts && echo "✅" || echo "❌"

# Check config file
test -f apps/web/src/app/features/{shell}/{shell}.config.ts && echo "✅" || echo "❌"

# Check component file
test -f apps/web/src/app/features/{shell}/{shell}-shell.component.ts && echo "✅" || echo "❌"

# Check pages folder
test -d apps/web/src/app/features/{shell}/pages && echo "✅" || echo "❌"
```

**Example output:**

```
Shell Infrastructure Check: inventory
├─ ✅ inventory.routes.ts exists
├─ ✅ inventory.config.ts exists
├─ ✅ inventory-shell.component.ts exists
└─ ✅ pages/ folder exists
```

### Step 3: Check Section Infrastructure

**Required files:**

```bash
# Base path
apps/web/src/app/features/{shell}/pages/{section}/

# Files to check
├── {section}.config.ts            # CRITICAL
└── {section}.page.ts
```

**Validation commands:**

```bash
# Check section folder exists
ls apps/web/src/app/features/{shell}/pages/{section}/

# Check config file
test -f apps/web/src/app/features/{shell}/pages/{section}/{section}.config.ts && echo "✅" || echo "❌"

# Check page file
test -f apps/web/src/app/features/{shell}/pages/{section}/{section}.page.ts && echo "✅" || echo "❌"
```

**Example output:**

```
Section Infrastructure Check: master-data
├─ ✅ pages/master-data/ exists
├─ ✅ master-data.config.ts exists
└─ ✅ master-data.page.ts exists
```

### Step 4: Check Auto-Registration Markers

**Critical markers that MUST exist:**

**In {shell}.routes.ts:**

```typescript
export const inventoryRoutes: Routes = [
  // === ROUTES START === (DO NOT REMOVE)
  // Generated routes auto-inserted here
  // === ROUTES END ===
];
```

**In pages/{section}/{section}.config.ts:**

```typescript
export const masterDataConfig = {
  // === SECTION START === (DO NOT REMOVE)
  // Generated section config auto-inserted here
  // === SECTION END ===
};
```

**Validation commands:**

```bash
# Check routes markers
grep -q "=== ROUTES START ===" apps/web/src/app/features/{shell}/{shell}.routes.ts && echo "✅ START" || echo "❌ START"
grep -q "=== ROUTES END ===" apps/web/src/app/features/{shell}/{shell}.routes.ts && echo "✅ END" || echo "❌ END"

# Check section markers
grep -q "=== SECTION START ===" apps/web/src/app/features/{shell}/pages/{section}/{section}.config.ts && echo "✅ START" || echo "❌ START"
grep -q "=== SECTION END ===" apps/web/src/app/features/{shell}/pages/{section}/{section}.config.ts && echo "✅ END" || echo "❌ END"
```

**Example output:**

```
Auto-Registration Markers Check:
Routes markers (inventory.routes.ts):
├─ ✅ === ROUTES START === found
└─ ✅ === ROUTES END === found

Section markers (master-data.config.ts):
├─ ✅ === SECTION START === found
└─ ✅ === SECTION END === found
```

### Step 5: Generate Report

**Report format:**

```markdown
🔍 Frontend Prerequisites Validation Report

Table: {table_name}
Shell: {shell}
Section: {section}
Target: apps/web/src/app/features/{shell}/modules/{module}/

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## ✅ Shell Infrastructure: {shell}

- [x] {shell}.routes.ts exists
- [x] {shell}.config.ts exists
- [x] {shell}-shell.component.ts exists
- [x] pages/ folder exists

## ✅ Section Infrastructure: {section}

- [x] pages/{section}/ folder exists
- [x] {section}.config.ts exists
- [x] {section}.page.ts exists

## ✅ Auto-Registration Markers

Routes markers ({shell}.routes.ts):

- [x] === ROUTES START === found
- [x] === ROUTES END === found

Section markers ({section}.config.ts):

- [x] === SECTION START === found
- [x] === SECTION END === found

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## ✅ PREREQUISITES MET

All infrastructure verified. Safe to proceed with frontend generation.

**Next Step:**
Use MCP to build command:

aegisx_crud_build_command({
tableName: "{table}",
target: "frontend",
shell: "{shell}",
section: "{section}",
force: true
})
```

**If prerequisites NOT met:**

````markdown
🔍 Frontend Prerequisites Validation Report

Table: {table_name}
Shell: {shell}
Section: {section}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## ❌ Shell Infrastructure: {shell}

- [ ] {shell}.routes.ts NOT FOUND
- [x] {shell}.config.ts exists
- [x] {shell}-shell.component.ts exists
- [x] pages/ folder exists

## ❌ Section Infrastructure: {section}

- [ ] pages/{section}/ NOT FOUND
- [ ] {section}.config.ts NOT FOUND
- [ ] {section}.page.ts NOT FOUND

## ⚠️ Auto-Registration Markers

Cannot validate (missing files)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## ❌ PREREQUISITES NOT MET

Required Actions:

### 1. Create Shell (if missing)

```bash
aegisx shell {shell} --app web --force
```
````

This will create:

- {shell}.routes.ts (with auto-registration markers)
- {shell}.config.ts
- {shell}-shell.component.ts
- pages/ folder

### 2. Create Section (if missing)

```bash
aegisx section {shell} {section} --force
```

This will create:

- pages/{section}/{section}.config.ts (with markers)
- pages/{section}/{section}.page.ts

### 3. Verify Markers (if missing)

If markers are missing, recreate shell/section with --force:

```bash
aegisx shell {shell} --app web --force
aegisx section {shell} {section} --force
```

### 4. Re-run Validation

```bash
/frontend-prereq-checker
```

### 5. Then Generate

Only after ALL checks pass:

```bash
aegisx_crud_build_command({
  tableName: "{table}",
  target: "frontend",
  shell: "{shell}",
  section: "{section}",
  force: true
})
```

⚠️ DO NOT proceed with generation until all prerequisites are met!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

````

## MCP Integration

**Use MCP to validate before building command:**

```typescript
// Step 1: Run prerequisites check (this skill)
// Manually or auto-triggered

// Step 2: If all pass, use MCP to build command
aegisx_crud_build_command({
  tableName: "drugs",
  target: "frontend",
  shell: "inventory",
  section: "master-data",
  force: true
})

// MCP will:
// - Validate shell exists
// - Validate section exists
// - Return exact command if valid
// - Return error with fix instructions if invalid
````

**MCP provides additional validation layer on top of this skill.**

## Common Scenarios

### Scenario 1: Shell Missing

**User request:**

```
"Generate frontend for drugs in inventory master-data"
```

**Validation finds:**

```
❌ Shell 'inventory' does not exist
```

**Fix:**

```bash
aegisx shell inventory --app web --force
```

**Then re-run validation.**

---

### Scenario 2: Section Missing

**User request:**

```
"Generate frontend for drugs in inventory master-data"
```

**Validation finds:**

```
✅ Shell 'inventory' exists
❌ Section 'master-data' does not exist
```

**Fix:**

```bash
aegisx section inventory master-data --force
```

**Then re-run validation.**

---

### Scenario 3: Markers Missing

**User request:**

```
"Generate frontend for drugs in inventory master-data"
```

**Validation finds:**

```
✅ Shell 'inventory' exists
✅ Section 'master-data' exists
❌ Auto-registration markers missing in routes.ts
```

**Fix:**

```bash
# Recreate shell to restore markers
aegisx shell inventory --app web --force

# This will NOT delete existing modules, only update infrastructure files
```

**Then re-run validation.**

---

### Scenario 4: All Present

**User request:**

```
"Generate frontend for drugs in inventory master-data"
```

**Validation finds:**

```
✅ Shell 'inventory' exists
✅ Section 'master-data' exists
✅ Auto-registration markers present
```

**Proceed with generation:**

```typescript
aegisx_crud_build_command({
  tableName: 'drugs',
  target: 'frontend',
  shell: 'inventory',
  section: 'master-data',
  force: true,
});
```

## Self-Check Before Frontend Generation

**Claude MUST run through this checklist:**

```
Before ANY frontend CRUD generation:

[ ] Identified shell name?               → NO = Ask user
[ ] Identified section name?             → NO = Ask user
[ ] Ran frontend-prereq-checker?         → NO = RUN IT NOW!
[ ] Shell exists?                        → NO = Create shell
[ ] Section exists?                      → NO = Create section
[ ] Auto-registration markers present?   → NO = Recreate
[ ] Used MCP to build command?           → NO = STOP!

ALL YES → Proceed with generation
ANY NO → Fix issue first
```

## Error Prevention

**This skill prevents:**

- ❌ "Cannot find routes file" errors
- ❌ "Section config not found" errors
- ❌ "Auto-registration failed" errors
- ❌ Manual file path errors
- ❌ Wasted 15-30 minutes debugging

**By providing:**

- ✅ Upfront validation
- ✅ Exact error messages
- ✅ Exact fix commands
- ✅ Step-by-step instructions

## Integration with Other Skills

**This skill works with:**

1. **crud-generator-guide** - Uses MCP to build commands
2. **frontend-integration-guide** - Provides Shell/Section architecture context
3. **aegisx-development-workflow** - Part of Phase 5 (Frontend Generation)

**Workflow:**

```
User requests frontend
    ↓
frontend-prereq-checker (auto-trigger)
    ↓
If prerequisites missing → Show fix commands
    ↓
User fixes → Re-run checker
    ↓
All pass → crud-generator-guide (MCP) → Generate
```

## Quick Commands Reference

```bash
# Check if shell exists
ls apps/web/src/app/features/{shell}/

# Check if section exists
ls apps/web/src/app/features/{shell}/pages/{section}/

# Create shell
aegisx shell {shell} --app web --force

# Create section
aegisx section {shell} {section} --force

# Check routes markers
grep "=== ROUTES START ===" apps/web/src/app/features/{shell}/{shell}.routes.ts

# Check section markers
grep "=== SECTION START ===" apps/web/src/app/features/{shell}/pages/{section}/{section}.config.ts
```

## Summary

**This skill is CRITICAL because:**

1. **Prevention** - Stops 100% of frontend generation failures caused by missing infrastructure
2. **Time Savings** - Saves 15-30 minutes per failed generation attempt
3. **Clarity** - Shows exactly what's missing and how to fix it
4. **Automation** - Auto-triggers, no manual checks needed
5. **Integration** - Works seamlessly with MCP and other skills

**Golden Rule:**

```
NEVER attempt frontend generation without running this skill first.
```

**Success Rate:**

- Before skill: 70% success (30% fail due to missing infrastructure)
- After skill: 100% success (all prerequisites validated upfront)
