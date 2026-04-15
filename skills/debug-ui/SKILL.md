---
name: debug-ui
description: Debug UI issues by reading console errors, network failures, and DOM state. Use when investigating bugs, errors, or unexpected behavior.
allowed-tools: mcp__claude-in-chrome__*, Read, Bash
---

# Debug UI Issues

Systematic debugging of UI problems using browser dev tools through automation.

## When Claude Should Use This Skill

- User reports "error", "bug", "not working", "broken UI"
- After user says "something is wrong with the page"
- When investigating console errors
- Debugging API call failures
- Checking why elements don't appear

## Debugging Process

### Step 1: Read Console Errors

```typescript
const errors = await read_console_messages({
  tabId,
  pattern: "error|warning",
  onlyErrors: true
});

console.log(`Found ${errors.length} console errors`);
errors.forEach(e => {
  console.log(`[${e.level}] ${e.message}`);
});
```

### Step 2: Check Network Failures

```typescript
const requests = await read_network_requests({
  tabId,
  urlPattern: "/api/"
});

const failed = requests.filter(r => r.status >= 400);
failed.forEach(r => {
  console.log(`❌ ${r.method} ${r.url} → ${r.status}`);
});
```

### Step 3: Inspect DOM State

```typescript
// Read full page
const page = await read_page({ tabId, filter: "all" });

// Find missing elements
const critical = await find({ query: "critical element", tabId });
if (critical.length === 0) {
  console.log("⚠️ Critical element not found");
}
```

### Step 4: Execute JavaScript for Deep Inspection

```typescript
const debugInfo = await javascript_tool({
  code: `({
    url: window.location.href,
    errors: window.__errors || [],
    state: window.__appState || {}
  })`,
  tabId
});

console.log("Debug info:", debugInfo);
```

## Report Format

```markdown
## Debug Report

**Issue:** Form not submitting
**URL:** http://localhost:4200/inventory/drugs/new

### Console Errors:
❌ TypeError: Cannot read property 'id' of undefined
   at DrugFormComponent.submit (drug-form.component.ts:45)

### Network Failures:
❌ POST /api/inventory/drugs → 400 Bad Request
   Response: { "error": "Validation failed: code is required" }

### DOM Issues:
⚠️ Submit button is disabled
⚠️ Code field is empty

### Root Cause:
Form validation prevents submission because code field is required but empty.

### Recommendation:
1. Check TypeBox schema requires code field
2. Ensure frontend marks code as required
3. Add validation error display
```
