---
name: test-ui
description: Test UI workflows and user interactions through browser automation. Use when verifying UI functionality, testing navigation flows, or checking visual elements.
allowed-tools: mcp__claude-in-chrome__*, Read, Bash
---

# Test UI Workflow

Automated UI testing using browser automation to verify user workflows and interactions.

## When Claude Should Use This Skill

- User asks to "test UI", "check the page", or "verify the interface"
- After implementing new UI components
- When verifying navigation flows
- Testing user interactions (clicks, navigation, data display)
- Checking if UI elements are properly rendered
- Validating responsive design

## Testing Process

### Step 1: Get Browser Context

```typescript
// ALWAYS start with context
const context = await tabs_context_mcp({ createIfEmpty: true });

// Get or create tab
const tabId = context.tabs.length > 0
  ? context.tabs[0].id
  : await tabs_create_mcp();
```

### Step 2: Navigate to URL

Determine URL from user request or default:

```typescript
const urls = {
  // Inventory
  drugs: "http://localhost:4200/inventory/master-data/drugs",
  drugGenerics: "http://localhost:4200/inventory/master-data/drug-generics",
  inventory: "http://localhost:4200/inventory/operations/inventory",

  // Budget
  budgets: "http://localhost:4200/inventory/master-data/budgets",
  budgetRequests: "http://localhost:4200/inventory/budget/budget-requests",
  budgetAllocations: "http://localhost:4200/inventory/operations/budget-allocations",

  // Procurement
  purchaseRequests: "http://localhost:4200/inventory/procurement/purchase-requests",
  purchaseOrders: "http://localhost:4200/inventory/procurement/purchase-orders",

  // Default
  dashboard: "http://localhost:4200",
}

// Navigate
await navigate(targetUrl, tabId);
await computer({ action: "wait", duration: 2, tabId });
```

### Step 3: Read Page State

```typescript
// Read accessibility tree
const page = await read_page({ tabId, filter: "interactive" });

// Find specific elements
const elements = await find({
  query: "button", // or specific element description
  tabId
});

// Check for specific text/content
const pageText = await get_page_text({ tabId });
```

### Step 4: Perform Interactions

#### Click Elements

```typescript
// Find element first
const button = await find({ query: "Add button", tabId });

// Click using reference
await computer({
  action: "left_click",
  ref: button.ref,
  tabId
});
```

#### Navigate Through Menu

```typescript
// Click main menu
const menu = await find({ query: "Inventory menu", tabId });
await computer({ action: "left_click", ref: menu.ref, tabId });

// Wait for submenu
await computer({ action: "wait", duration: 0.5, tabId });

// Click submenu item
const submenu = await find({ query: "Drugs submenu", tabId });
await computer({ action: "left_click", ref: submenu.ref, tabId });

// Verify navigation
await computer({ action: "wait", duration: 1, tabId });
const currentPage = await read_page({ tabId });
```

#### Scroll Elements

```typescript
// Scroll to specific element
const element = await find({ query: "footer", tabId });
await computer({
  action: "scroll_to",
  ref: element.ref,
  tabId
});

// Scroll page
await computer({
  action: "scroll",
  scroll_direction: "down",
  scroll_amount: 3,
  coordinate: [500, 400],
  tabId
});
```

### Step 5: Verify Results

#### Visual Verification

```typescript
// Take screenshot
await computer({ action: "screenshot", tabId });

// Check if element exists
const elements = await find({ query: "success message", tabId });
const exists = elements.length > 0;
```

#### Console Verification

```typescript
// Read console for errors
const consoleLogs = await read_console_messages({
  tabId,
  pattern: "error|warning",
  onlyErrors: true
});

// Report errors found
if (consoleLogs.length > 0) {
  console.log("❌ Console Errors Found:");
  consoleLogs.forEach(log => {
    console.log(`  - ${log.level}: ${log.message}`);
  });
}
```

#### Network Verification

```typescript
// Check network requests
const requests = await read_network_requests({
  tabId,
  urlPattern: "/api/"
});

// Filter failed requests
const failedRequests = requests.filter(r => r.status >= 400);

if (failedRequests.length > 0) {
  console.log("❌ Failed API Requests:");
  failedRequests.forEach(req => {
    console.log(`  - ${req.method} ${req.url}: ${req.status}`);
  });
}
```

### Step 6: Report Results

```typescript
/**
 * Standard test report format
 */
const report = {
  testName: "Drug List Page UI Test",
  url: "http://localhost:4200/inventory/master-data/drugs",
  timestamp: new Date().toISOString(),

  checks: [
    { name: "Page loads", passed: true },
    { name: "Data table displayed", passed: true },
    { name: "Add button visible", passed: true },
    { name: "No console errors", passed: consoleLogs.length === 0 },
    { name: "All API calls successful", passed: failedRequests.length === 0 },
  ],

  summary: {
    total: 5,
    passed: 4,
    failed: 1,
    success: false
  },

  issues: [
    "API call to /api/drugs failed with 500 error"
  ],

  screenshots: ["screenshot-1.png"]
};

// Format output
console.log("## UI Test Results\n");
console.log(`**Test:** ${report.testName}`);
console.log(`**URL:** ${report.url}`);
console.log(`**Time:** ${report.timestamp}\n`);
console.log("### Checks:");
report.checks.forEach(check => {
  const icon = check.passed ? "✅" : "❌";
  console.log(`${icon} ${check.name}`);
});
console.log(`\n**Summary:** ${report.summary.passed}/${report.summary.total} passed`);
if (report.issues.length > 0) {
  console.log("\n### Issues Found:");
  report.issues.forEach(issue => console.log(`- ${issue}`));
}
```

## Common Test Scenarios

### Scenario 1: Test Navigation Flow

```typescript
/**
 * Verify user can navigate from dashboard to specific module
 */
async function testNavigation() {
  // 1. Start at dashboard
  await navigate("http://localhost:4200", tabId);
  await computer({ action: "wait", duration: 2, tabId });

  // 2. Click main menu
  const inventoryMenu = await find({ query: "Inventory menu", tabId });
  await computer({ action: "left_click", ref: inventoryMenu.ref, tabId });

  // 3. Wait for submenu
  await computer({ action: "wait", duration: 0.5, tabId });

  // 4. Click submenu
  const drugsMenu = await find({ query: "Drugs", tabId });
  await computer({ action: "left_click", ref: drugsMenu.ref, tabId });

  // 5. Verify arrived at correct page
  await computer({ action: "wait", duration: 2, tabId });
  const page = await get_page_text({ tabId });

  const checks = [
    { name: "URL contains /drugs", passed: page.includes("drugs") },
    { name: "Page title correct", passed: page.includes("Drugs") || page.includes("ยา") },
    { name: "Data table visible", passed: await find({ query: "table", tabId }).length > 0 }
  ];

  return checks;
}
```

### Scenario 2: Test Data Display

```typescript
/**
 * Verify data is properly displayed in table
 */
async function testDataDisplay() {
  // 1. Navigate to list page
  await navigate("http://localhost:4200/inventory/master-data/drugs", tabId);
  await computer({ action: "wait", duration: 3, tabId });

  // 2. Read page content
  const page = await read_page({ tabId, filter: "all" });

  // 3. Check table elements
  const checks = [
    { name: "Table exists", passed: await find({ query: "table", tabId }).length > 0 },
    { name: "Table headers visible", passed: page.includes("Code") && page.includes("Name") },
    { name: "Table has rows", passed: await find({ query: "table row", tabId }).length > 0 },
    { name: "Pagination exists", passed: await find({ query: "pagination", tabId }).length > 0 }
  ];

  // 4. Check data quality
  const tableText = await get_page_text({ tabId });
  const hasData = !tableText.includes("No data") && !tableText.includes("ไม่มีข้อมูล");

  checks.push({ name: "Table has data", passed: hasData });

  return checks;
}
```

### Scenario 3: Test Button Visibility

```typescript
/**
 * Verify action buttons are visible based on permissions
 */
async function testButtonVisibility() {
  // 1. Navigate to page
  await navigate(targetUrl, tabId);
  await computer({ action: "wait", duration: 2, tabId });

  // 2. Find buttons
  const buttons = {
    add: await find({ query: "Add button", tabId }),
    edit: await find({ query: "Edit button", tabId }),
    delete: await find({ query: "Delete button", tabId }),
    export: await find({ query: "Export button", tabId })
  };

  // 3. Report visibility
  const checks = [
    { name: "Add button visible", passed: buttons.add.length > 0 },
    { name: "Edit button visible", passed: buttons.edit.length > 0 },
    { name: "Delete button visible", passed: buttons.delete.length > 0 },
    { name: "Export button visible", passed: buttons.export.length > 0 }
  ];

  return checks;
}
```

### Scenario 4: Test Responsive Design

```typescript
/**
 * Test page at different viewport sizes
 */
async function testResponsive() {
  const sizes = [
    { name: "Desktop", width: 1920, height: 1080 },
    { name: "Laptop", width: 1366, height: 768 },
    { name: "Tablet", width: 768, height: 1024 },
    { name: "Mobile", width: 375, height: 667 }
  ];

  const results = [];

  for (const size of sizes) {
    // Resize window
    await resize_window({ width: size.width, height: size.height, tabId });
    await computer({ action: "wait", duration: 1, tabId });

    // Take screenshot
    await computer({ action: "screenshot", tabId });

    // Check layout
    const page = await read_page({ tabId });
    const hasMobileMenu = await find({ query: "mobile menu", tabId }).length > 0;
    const hasDesktopMenu = await find({ query: "desktop menu", tabId }).length > 0;

    results.push({
      size: size.name,
      width: size.width,
      mobileMenu: hasMobileMenu,
      desktopMenu: hasDesktopMenu,
      layoutOk: size.width < 768 ? hasMobileMenu : hasDesktopMenu
    });
  }

  return results;
}
```

## Error Handling

### Common Issues

#### Issue 1: Element Not Found

```typescript
try {
  const element = await find({ query: "specific button", tabId });
  if (element.length === 0) {
    throw new Error("Element not found");
  }
} catch (error) {
  // Retry with broader search
  const allButtons = await find({ query: "button", tabId });
  console.log("Available buttons:", allButtons.map(b => b.description));

  // Or wait longer
  await computer({ action: "wait", duration: 2, tabId });
  const retry = await find({ query: "specific button", tabId });
}
```

#### Issue 2: Page Not Loading

```typescript
// Check if page loaded
await computer({ action: "wait", duration: 5, tabId });
const page = await read_page({ tabId });

if (page.children.length === 0) {
  console.log("❌ Page appears empty");

  // Check console for errors
  const errors = await read_console_messages({ tabId, onlyErrors: true });
  console.log("Console errors:", errors);

  // Try refresh
  await navigate(sameUrl, tabId);
}
```

#### Issue 3: Click Not Working

```typescript
// Method 1: Use ref
const button = await find({ query: "save button", tabId });
await computer({ action: "left_click", ref: button.ref, tabId });

// Method 2: Scroll into view first
await computer({ action: "scroll_to", ref: button.ref, tabId });
await computer({ action: "wait", duration: 0.5, tabId });
await computer({ action: "left_click", ref: button.ref, tabId });

// Method 3: Try double click
await computer({ action: "double_click", ref: button.ref, tabId });

// Method 4: Use JavaScript (last resort)
await javascript_tool({
  code: `document.querySelector('[data-test="save-button"]').click()`,
  tabId
});
```

## Best Practices

### 1. Always Wait After Navigation

```typescript
await navigate(url, tabId);
await computer({ action: "wait", duration: 2, tabId }); // MANDATORY
```

### 2. Find Before Click

```typescript
// ❌ WRONG
await computer({ action: "left_click", coordinate: [100, 200], tabId });

// ✅ CORRECT
const button = await find({ query: "Add button", tabId });
await computer({ action: "left_click", ref: button.ref, tabId });
```

### 3. Verify After Action

```typescript
// Click button
await computer({ action: "left_click", ref: buttonRef, tabId });

// Wait for result
await computer({ action: "wait", duration: 1, tabId });

// Verify action succeeded
const success = await find({ query: "success message", tabId });
if (success.length === 0) {
  console.log("❌ Action may have failed - no success message");
}
```

### 4. Clean Up After Test

```typescript
// Close unnecessary tabs
// Clear test data
// Logout if needed
```

## Output Format

```markdown
## UI Test Results

**Test:** Navigation Flow Test
**URL:** http://localhost:4200/inventory/master-data/drugs
**Time:** 2025-12-21T10:30:00.000Z

### Checks:
✅ Page loads successfully
✅ Navigation menu works
✅ Submenu appears correctly
✅ Redirected to correct page
✅ Data table displayed
❌ No console errors (1 warning found)

**Summary:** 5/6 passed

### Issues Found:
- Console warning: "Deprecated API usage in component"

### Screenshots:
- Initial page: screenshot-1.png
- After navigation: screenshot-2.png
```

## Quick Reference

```typescript
// Setup
tabs_context_mcp({ createIfEmpty: true })
navigate(url, tabId)
computer({ action: "wait", duration: 2, tabId })

// Interaction
read_page({ tabId, filter: "interactive" })
find({ query: "element description", tabId })
computer({ action: "left_click", ref: "ref_1", tabId })
computer({ action: "scroll_to", ref: "ref_1", tabId })

// Verification
get_page_text({ tabId })
read_console_messages({ tabId, onlyErrors: true })
read_network_requests({ tabId, urlPattern: "/api/" })
computer({ action: "screenshot", tabId })

// Resize (responsive test)
resize_window({ width: 1920, height: 1080, tabId })
```

## Success Criteria

A successful UI test should:

- ✅ Have clear test objective
- ✅ Navigate to correct URL
- ✅ Verify page loads completely
- ✅ Check critical UI elements
- ✅ Verify no console errors
- ✅ Confirm network requests succeed
- ✅ Take screenshots for evidence
- ✅ Report clear pass/fail results
- ✅ List any issues found

---

**Remember:** UI testing complements but doesn't replace unit/integration tests. Focus on user-facing workflows and visual verification.
