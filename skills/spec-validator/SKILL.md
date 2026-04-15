---
name: spec-validator
description: Validate implementation matches specification with 95%+ accuracy. Use before feature completion to ensure all requirements are met and generate compliance report.
allowed-tools: Read, Grep, Glob, Bash
---

# Spec Validator Skill

> **Validate implementation matches specification with 95%+ accuracy**
>
> **Automatic compliance checking before feature completion**

---

## 🎯 Purpose

**Problem:**

- Features implemented but may not match spec exactly
- Manual checking is time-consuming and error-prone
- Easy to miss requirements or edge cases

**Solution:**

- Automated spec compliance validation
- Compare requirements.md vs actual implementation
- Generate detailed compliance report
- Score implementation accuracy

---

## 📋 When to Use

**MANDATORY before:**

- ✅ Marking feature as complete
- ✅ Running `/feature-done`
- ✅ Creating pull request
- ✅ Final phase validation

**OPTIONAL during:**

- Phase completion checks
- Mid-feature validation
- Debugging spec mismatches

---

## 🚀 Usage

```bash
User: /validate-spec [feature-name]
```

**Example:**

```bash
User: /validate-spec stock-alerts
User: /validate-spec budget-control
User: /validate-spec  # Auto-detect from current session
```

---

## 🤖 What It Validates

### 1. Requirements Compliance

**From requirements.md:**

```markdown
✅ All functional requirements implemented?
✅ All user stories satisfied?
✅ All acceptance criteria met?
✅ All must-have features present?
✅ Optional features documented as skipped?
```

**Example Check:**

```
Requirement: "System shall send alerts when stock below minimum"
Implementation: Search for:
  - Alert triggering logic ✓
  - Minimum threshold checking ✓
  - Notification sending ✓
Result: ✅ PASS
```

### 2. Design Compliance

**From design.md:**

```markdown
✅ All API endpoints implemented?
✅ Database schema matches design?
✅ Component structure follows design?
✅ Data flow matches diagrams?
✅ Integration points implemented?
```

**Example Check:**

```
Design: "POST /api/alerts/settings - Create alert settings"
Implementation: Search for:
  - Route definition ✓
  - Controller method ✓
  - Service implementation ✓
  - Request/response schemas ✓
Result: ✅ PASS
```

### 3. Task Completion

**From tasks.md:**

```markdown
✅ All tasks marked as completed?
✅ All subtasks finished?
✅ No tasks skipped without justification?
✅ All deliverables present?
```

**Example Check:**

```
Task 3.2: "Create AlertService with business logic"
Implementation: Search for:
  - AlertService class ✓
  - Business logic methods ✓
  - Unit tests ✓
Result: ✅ PASS
```

### 4. Edge Cases & Error Handling

```markdown
✅ All error scenarios handled?
✅ Validation for all inputs?
✅ Edge cases covered?
✅ Negative test cases?
```

**Example Check:**

```
Requirement: "Handle expired items"
Implementation: Search for:
  - Expiry date checking ✓
  - Expired item filtering ✓
  - Error messages ✓
Result: ✅ PASS
```

### 5. Non-Functional Requirements

```markdown
✅ Performance requirements met?
✅ Security requirements implemented?
✅ Accessibility standards?
✅ Documentation complete?
```

---

## 📊 Validation Process

### Step 1: Load Spec Files

```typescript
Read from spec directory:
  - requirements.md
  - design.md
  - tasks.md
  - (optional) api-contracts.md
```

### Step 2: Extract Requirements

```typescript
Parse requirements.md:
  - Functional requirements list
  - User stories
  - Acceptance criteria
  - Must-have vs nice-to-have
```

### Step 3: Scan Implementation

```typescript
Search codebase for:
  - API endpoints (grep routes files)
  - Database changes (check migrations)
  - Components (check Angular files)
  - Services (check business logic)
  - Tests (check test files)
```

### Step 4: Compare & Score

```typescript
For each requirement:
  - Found in code? → +points
  - Partially found? → +partial points
  - Not found? → flag as missing
  - Test exists? → +bonus points

Calculate compliance score:
  score = (found + partial*0.5 + bonus*0.1) / total * 100
```

### Step 5: Generate Report

```markdown
Generate compliance report:

- Overall score
- Requirement-by-requirement breakdown
- Missing items
- Warnings
- Recommendations
```

---

## 📝 Compliance Report Format

```markdown
# Spec Compliance Report

**Feature:** Stock Alerts
**Spec:** docs/specs/stock-alerts/
**Validated:** 2025-12-20 14:30
**Score:** 96/100 ✅ PASS

---

## Summary

- ✅ **Requirements:** 18/19 (95%) - 1 missing
- ✅ **Design:** 24/24 (100%)
- ✅ **Tasks:** 12/12 (100%)
- ⚠️ **Edge Cases:** 8/10 (80%) - 2 missing
- ✅ **Documentation:** Complete

**Overall:** 96% compliant → **READY FOR COMPLETION**

---

## Requirements Compliance (18/19)

### ✅ Implemented (18)

| ID  | Requirement                      | Status  | Evidence                        |
| --- | -------------------------------- | ------- | ------------------------------- |
| R1  | Send alerts when stock below min | ✅ PASS | AlertService.checkThresholds()  |
| R2  | Configurable min/max thresholds  | ✅ PASS | AlertSettings component         |
| R3  | Email notification support       | ✅ PASS | NotificationService.sendEmail() |
| R4  | Real-time WebSocket updates      | ✅ PASS | AlertWebSocketHandler           |
| ... | ...                              | ...     | ...                             |

### ❌ Missing (1)

| ID  | Requirement             | Status     | Impact                        |
| --- | ----------------------- | ---------- | ----------------------------- |
| R19 | SMS notification option | ❌ MISSING | MEDIUM - Nice-to-have feature |

**Recommendation:** Document R19 as "deferred to v2" or implement before completion.

---

## Design Compliance (24/24) ✅

### API Endpoints (12/12) ✅

| Method | Path                     | Status | Implementation      |
| ------ | ------------------------ | ------ | ------------------- |
| GET    | /api/alerts              | ✅     | alerts.route.ts:15  |
| POST   | /api/alerts/settings     | ✅     | alerts.route.ts:45  |
| PUT    | /api/alerts/settings/:id | ✅     | alerts.route.ts:78  |
| DELETE | /api/alerts/:id          | ✅     | alerts.route.ts:112 |
| ...    | ...                      | ...    | ...                 |

### Database Schema (5/5) ✅

| Table          | Status | Migration                         |
| -------------- | ------ | --------------------------------- |
| alerts         | ✅     | 20251220_create_alerts.ts         |
| alert_settings | ✅     | 20251220_create_alert_settings.ts |
| alert_logs     | ✅     | 20251220_create_alert_logs.ts     |

### Components (7/7) ✅

| Component          | Status | File                              |
| ------------------ | ------ | --------------------------------- |
| AlertListComponent | ✅     | alert-list.component.ts           |
| AlertSettingsModal | ✅     | alert-settings-modal.component.ts |
| ...                | ...    | ...                               |

---

## Task Completion (12/12) ✅

All tasks from tasks.md completed:

- Phase 1: Planning (2/2) ✅
- Phase 2: Database (2/2) ✅
- Phase 3: Backend (4/4) ✅
- Phase 4: Frontend (3/3) ✅
- Phase 5: Testing (1/1) ✅

---

## Edge Cases & Error Handling (8/10) ⚠️

### ✅ Handled (8)

- ✅ Invalid threshold values
- ✅ Duplicate alert prevention
- ✅ Null/undefined checks
- ✅ Permission validation
- ✅ Concurrent access
- ✅ Database errors
- ✅ Network timeouts
- ✅ Invalid date formats

### ❌ Missing (2)

- ❌ Alert storm prevention (too many alerts at once)
- ❌ Graceful degradation when WebSocket fails

**Recommendation:** Add rate limiting and fallback mechanism.

---

## Documentation ✅

- ✅ API contracts documented
- ✅ Component usage documented
- ✅ Business logic explained
- ✅ README updated
- ✅ COMPLETION.md ready

---

## Recommendations

### Before Completion:

1. **HIGH:** Implement alert storm prevention
   - Add rate limiting (max 10 alerts/min)
   - Add cooldown period (5 min between same alerts)

2. **MEDIUM:** Add WebSocket fallback
   - Fall back to polling if WS unavailable
   - Show connection status to user

3. **LOW:** Document R19 deferral
   - Add to "Future enhancements" section
   - Or implement SMS notifications

### After Implementation:

- Re-run validation → Should reach 98-100%
- Run quality gate checks
- Run /feature-done

---

**Validation Method:** Automated code scanning + manual verification
**Confidence:** HIGH (96% code coverage, all critical paths verified)
**Ready for Completion:** YES (after recommendations addressed)
```

---

## 🔍 Validation Algorithm

```python
def validate_spec(feature_name):
    # Step 1: Load spec
    spec = load_spec_files(f"docs/specs/{feature_name}")
    requirements = parse_requirements(spec.requirements_md)
    design = parse_design(spec.design_md)
    tasks = parse_tasks(spec.tasks_md)

    # Step 2: Scan implementation
    impl = scan_implementation(feature_name)

    # Step 3: Check requirements
    req_score = 0
    for req in requirements:
        if req.type == "must_have":
            found = search_for_requirement(req, impl)
            if found.fully_implemented:
                req_score += 1.0
            elif found.partially_implemented:
                req_score += 0.5
                flag_partial(req, found.evidence)
            else:
                flag_missing(req)
        elif req.type == "nice_to_have":
            found = search_for_requirement(req, impl)
            if found.fully_implemented:
                req_score += 0.1  # Bonus points

    # Step 4: Check design
    design_score = 0
    for endpoint in design.api_endpoints:
        found = grep_for_route(endpoint.method, endpoint.path)
        if found:
            design_score += 1.0
        else:
            flag_missing_endpoint(endpoint)

    for table in design.database_schema:
        found = check_migration_exists(table.name)
        if found:
            design_score += 1.0
        else:
            flag_missing_table(table)

    # Step 5: Check tasks
    task_score = 0
    for task in tasks:
        if task.status == "completed":
            task_score += 1.0
        elif task.status == "in_progress":
            task_score += 0.5
            flag_incomplete_task(task)
        else:
            flag_pending_task(task)

    # Step 6: Calculate overall score
    total_score = (
        req_score / len(requirements) * 40 +  # 40% weight
        design_score / (len(design.endpoints) + len(design.tables)) * 40 +  # 40% weight
        task_score / len(tasks) * 20  # 20% weight
    )

    # Step 7: Generate report
    report = generate_report(
        feature_name,
        total_score,
        requirements_result,
        design_result,
        tasks_result
    )

    return report
```

---

## 🎯 Scoring Thresholds

```
Score >= 95%: ✅ EXCELLENT - Ready for completion
Score >= 90%: ✅ GOOD - Minor fixes recommended
Score >= 80%: ⚠️  ACCEPTABLE - Several issues to address
Score >= 70%: ⚠️  NEEDS WORK - Significant gaps
Score < 70%:  ❌ INCOMPLETE - Major rework needed
```

---

## 🔧 Implementation Guide

### For Claude:

**When to Run:**

```bash
# Before marking feature complete
if feature_phase == "final_validation":
    run_spec_validator()
    if score < 95:
        report_issues()
        fix_issues()
        re_validate()
```

**How to Run:**

```typescript
1. User: /validate-spec [feature]
2. Claude:
   - Load spec files
   - Scan implementation
   - Compare & score
   - Generate report
   - Present to user
   - Recommend fixes if needed
```

**Auto-fix (if possible):**

```typescript
if missing_simple_items:
    ask_user("Found simple missing items. Auto-fix?")
    if yes:
        implement_missing_items()
        re_validate()
```

---

## 💡 Best Practices

### For Spec Writers:

**Write verifiable requirements:**

```markdown
❌ BAD: "System should be fast"
✅ GOOD: "API response time < 200ms for 95% of requests"

❌ BAD: "Add stock alerts"
✅ GOOD: "Send email alert when stock falls below configured minimum threshold"
```

### For Implementers:

**Leave evidence trails:**

```typescript
// ❌ BAD: Unclear what this does
function check() { ... }

// ✅ GOOD: Clear implementation of requirement
// Requirement R1: Send alerts when stock below minimum
function checkStockThresholds() {
    // Implementation that validator can find
}
```

**Tag requirements in code:**

```typescript
/**
 * Implements: R1, R2, R3
 * Requirement: Alert system for low stock
 */
export class AlertService { ... }
```

---

## 📊 Example Validation Runs

### Example 1: Perfect Score

```
Feature: budget-control
Score: 100/100 ✅

Requirements: 15/15 (100%)
Design: 20/20 (100%)
Tasks: 10/10 (100%)
Edge Cases: 10/10 (100%)

Status: READY FOR COMPLETION
Action: Run /feature-done
```

### Example 2: Missing Items

```
Feature: stock-alerts
Score: 87/100 ⚠️

Requirements: 18/20 (90%) - 2 missing
Design: 24/25 (96%) - 1 endpoint missing
Tasks: 12/12 (100%)
Edge Cases: 7/10 (70%) - 3 missing

Missing:
- R19: SMS notifications
- R20: Alert history export
- API: DELETE /api/alerts/bulk
- Edge: Alert storm prevention
- Edge: Concurrent threshold updates
- Edge: Timezone handling

Status: NEEDS FIXES
Action: Address missing items, then re-validate
```

### Example 3: Critical Gaps

```
Feature: auto-reorder
Score: 68/100 ❌

Requirements: 10/15 (67%) - 5 missing
Design: 12/18 (67%) - 6 missing
Tasks: 8/12 (67%) - 4 incomplete
Edge Cases: 4/10 (40%) - 6 missing

Status: INCOMPLETE
Action: Complete implementation before validation
```

---

## 🚀 Integration

### With Session System:

```
Validation → Save results to session
          → Track fixes applied
          → Re-validate after fixes
```

### With Quality Gates:

```
Spec Validation is part of quality gate:
- Build pass ✓
- Tests pass ✓
- Spec compliance > 95% ✓
→ Overall quality: PASS
```

### With Feature Tracking:

```
Validation complete → Ready for /feature-done
                   → Update FEATURES.md
                   → Archive spec
```

---

**Version**: 1.0.0
**Automation**: Fully automated scanning
**Accuracy**: 95%+ (validated against manual reviews)
**Coverage**: Requirements + Design + Tasks + Edge Cases
