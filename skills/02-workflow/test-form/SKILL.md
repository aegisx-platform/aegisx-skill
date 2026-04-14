---
name: test-form
description: Test form validation and submission workflows. Use when testing form inputs, validation rules, or form submission processes.
allowed-tools: mcp__claude-in-chrome__*, Read, Bash
---

# Test Form Validation

Automated form testing including validation rules, input handling, and submission workflows.

## When Claude Should Use This Skill

- User asks to "test form", "check validation", or "verify form submission"
- After implementing form components
- When debugging form validation issues
- Testing TypeBox schema validation in UI
- Verifying error messages and user feedback

## Testing Process

### Step 1: Navigate to Form

```typescript
// Get context
const context = await tabs_context_mcp({ createIfEmpty: true });
const tabId = context.tabs[0].id;

// Navigate to form page
await navigate(formUrl, tabId);
await computer({ action: "wait", duration: 2, tabId });
```

### Step 2: Test Empty Submission (Validation Trigger)

```typescript
// Find submit button
const submitBtn = await find({ query: "Submit button", tabId });

// Click submit without filling form
await computer({ action: "left_click", ref: submitBtn.ref, tabId });

// Wait for validation
await computer({ action: "wait", duration: 1, tabId });

// Check for validation errors
const errors = await find({ query: "error message", tabId });
const hasErrors = errors.length > 0;

console.log(`✅ Validation triggered: ${hasErrors ? "YES" : "NO"}`);
```

### Step 3: Test Individual Fields

```typescript
/**
 * Test each field's validation rules
 */
async function testFieldValidation(fieldName, testCases) {
  for (const testCase of testCases) {
    // Find field
    const field = await find({ query: `${fieldName} input`, tabId });

    // Clear field
    await computer({ action: "left_click", ref: field.ref, tabId });
    await computer({ action: "key", text: "cmd+a", tabId });
    await computer({ action: "key", text: "Backspace", tabId });

    // Enter test value
    await form_input({ ref: field.ref, value: testCase.value, tabId });

    // Blur field (trigger validation)
    await computer({ action: "key", text: "Tab", tabId });
    await computer({ action: "wait", duration: 0.5, tabId });

    // Check for error
    const error = await find({ query: `${fieldName} error`, tabId });
    const hasError = error.length > 0;

    const passed = testCase.shouldFail ? hasError : !hasError;
    console.log(`${passed ? "✅" : "❌"} ${fieldName}: ${testCase.label}`);
  }
}

// Example test cases
const emailTests = [
  { label: "Empty email", value: "", shouldFail: true },
  { label: "Invalid format", value: "notanemail", shouldFail: true },
  { label: "Valid email", value: "user@example.com", shouldFail: false }
];

await testFieldValidation("Email", emailTests);
```

### Step 4: Test Complete Valid Submission

```typescript
/**
 * Fill form with valid data and submit
 */
async function testValidSubmission(formData) {
  // Fill each field
  for (const [fieldName, value] of Object.entries(formData)) {
    const field = await find({ query: `${fieldName} input`, tabId });
    await form_input({ ref: field.ref, value, tabId });
  }

  // Submit
  const submitBtn = await find({ query: "Submit button", tabId });
  await computer({ action: "left_click", ref: submitBtn.ref, tabId });

  // Wait for response
  await computer({ action: "wait", duration: 2, tabId });

  // Check for success
  const success = await find({ query: "success message", tabId });
  const error = await find({ query: "error message", tabId });

  return {
    succeeded: success.length > 0,
    failed: error.length > 0
  };
}
```

### Step 5: Test Form Reset/Cancel

```typescript
// Fill some fields
await form_input({ ref: "ref_1", value: "Test", tabId });
await form_input({ ref: "ref_2", value: "Data", tabId });

// Click cancel/reset
const cancelBtn = await find({ query: "Cancel button", tabId });
await computer({ action: "left_click", ref: cancelBtn.ref, tabId });

// Verify form cleared or dialog closed
await computer({ action: "wait", duration: 1, tabId });
const formStillVisible = await find({ query: "form", tabId });
```

### Step 6: Verify Network Request

```typescript
// Monitor network during submission
await read_network_requests({ tabId, urlPattern: "/api/" });

// Check request payload
const requests = await read_network_requests({ tabId });
const createRequest = requests.find(r => r.method === "POST");

if (createRequest) {
  console.log("✅ API called:", createRequest.url);
  console.log("Status:", createRequest.status);
}
```

## Common Form Test Scenarios

### Scenario 1: Required Field Validation

```typescript
/**
 * Test all required fields show errors when empty
 */
async function testRequiredFields(requiredFields) {
  // Submit empty form
  const submitBtn = await find({ query: "Submit button", tabId });
  await computer({ action: "left_click", ref: submitBtn.ref, tabId });
  await computer({ action: "wait", duration: 1, tabId });

  // Check each required field has error
  const results = [];
  for (const fieldName of requiredFields) {
    const error = await find({ query: `${fieldName} error`, tabId });
    results.push({
      field: fieldName,
      hasError: error.length > 0
    });
  }

  return results;
}

// Example
const required = ["Code", "Name", "Price"];
const results = await testRequiredFields(required);

// Report
results.forEach(r => {
  const icon = r.hasError ? "✅" : "❌";
  console.log(`${icon} ${r.field} shows required error`);
});
```

### Scenario 2: Data Type Validation

```typescript
/**
 * Test number/decimal fields
 */
const priceTests = [
  { value: "abc", shouldFail: true, label: "Text in number field" },
  { value: "-10", shouldFail: true, label: "Negative number" },
  { value: "0", shouldFail: true, label: "Zero" },
  { value: "10.99", shouldFail: false, label: "Valid decimal" },
  { value: "1000", shouldFail: false, label: "Valid integer" }
];

await testFieldValidation("Price", priceTests);
```

### Scenario 3: Dropdown/Select Validation

```typescript
/**
 * Test dropdown selection
 */
async function testDropdown(fieldName, options) {
  // Find dropdown
  const dropdown = await find({ query: `${fieldName} select`, tabId });

  // Click to open
  await computer({ action: "left_click", ref: dropdown.ref, tabId });
  await computer({ action: "wait", duration: 0.5, tabId });

  // Check options available
  const availableOptions = await find({ query: "option", tabId });
  console.log(`Options found: ${availableOptions.length}`);

  // Select first valid option
  if (availableOptions.length > 0) {
    await computer({ action: "left_click", ref: availableOptions[0].ref, tabId });
    await computer({ action: "wait", duration: 0.5, tabId });

    // Verify selected
    const selected = await find({ query: "selected option", tabId });
    console.log(`✅ Option selected: ${selected.length > 0}`);
  }
}

await testDropdown("Budget Type", ["Capital", "Operational"]);
```

### Scenario 4: Date Picker Validation

```typescript
/**
 * Test date picker
 */
async function testDatePicker() {
  // Find date input
  const dateField = await find({ query: "date input", tabId });

  // Click to open picker
  await computer({ action: "left_click", ref: dateField.ref, tabId });
  await computer({ action: "wait", duration: 0.5, tabId });

  // Select today
  const today = await find({ query: "today", tabId });
  if (today.length > 0) {
    await computer({ action: "left_click", ref: today.ref, tabId });
  } else {
    // Type date manually
    await form_input({ ref: dateField.ref, value: "2025-12-21", tabId });
  }

  // Verify date filled
  await computer({ action: "wait", duration: 0.5, tabId });
}
```

### Scenario 5: File Upload Validation

```typescript
/**
 * Test file upload (if applicable)
 */
async function testFileUpload() {
  // Note: File upload through browser automation has limitations
  // Best to test via API or manual testing

  const fileInput = await find({ query: "file input", tabId });
  if (fileInput.length > 0) {
    console.log("⚠️ File upload field found - test manually or via API");
  }
}
```

## Validation Rules to Test

### Common Validation Types

```typescript
const validationTests = {
  required: {
    empty: { value: "", shouldFail: true },
    filled: { value: "value", shouldFail: false }
  },

  email: {
    invalid: { value: "notanemail", shouldFail: true },
    valid: { value: "user@example.com", shouldFail: false }
  },

  number: {
    text: { value: "abc", shouldFail: true },
    negative: { value: "-1", shouldFail: true },
    zero: { value: "0", shouldFail: true },
    valid: { value: "10", shouldFail: false }
  },

  decimal: {
    invalid: { value: "10.999", shouldFail: true }, // Too many decimals
    valid: { value: "10.99", shouldFail: false }
  },

  minLength: {
    tooShort: { value: "ab", shouldFail: true }, // If min = 3
    valid: { value: "abc", shouldFail: false }
  },

  maxLength: {
    tooLong: { value: "a".repeat(300), shouldFail: true }, // If max = 255
    valid: { value: "a".repeat(100), shouldFail: false }
  },

  pattern: {
    invalid: { value: "123", shouldFail: true }, // If pattern requires letters
    valid: { value: "ABC-123", shouldFail: false }
  }
};
```

## Report Format

```markdown
## Form Validation Test Results

**Form:** Drug Create Form
**URL:** http://localhost:4200/inventory/master-data/drugs/new
**Time:** 2025-12-21T10:30:00.000Z

### Empty Submission Test:
✅ Validation triggered on empty submit
✅ All required fields show errors
✅ Form not submitted

### Field Validation Tests:

**Code Field:**
✅ Required - shows error when empty
✅ Min length - rejects < 3 chars
✅ Max length - rejects > 50 chars
✅ Valid - accepts "DRG-001"

**Name Field:**
✅ Required - shows error when empty
✅ Valid - accepts "Paracetamol"

**Price Field:**
✅ Required - shows error when empty
❌ Negative - should reject but accepts -10 (BUG!)
✅ Decimal - accepts 10.99
✅ Valid - accepts 100

**Budget Type Dropdown:**
✅ Required - shows error when empty
✅ Options load correctly
✅ Selection works

### Valid Submission Test:
✅ Form accepts all valid data
✅ Submit button enabled
✅ API call succeeds (201 Created)
✅ Success message displayed
✅ Redirected to list page

**Summary:** 14/15 passed (93%)

### Issues Found:
- Price field accepts negative numbers (should be rejected)

### Recommendation:
Update TypeBox schema to add `minimum: 0` to price field
```

## Best Practices

1. **Test empty submission first** - Trigger all validations at once
2. **Test one field at a time** - Isolate validation rules
3. **Test boundary values** - Min/max, edge cases
4. **Verify error messages** - Check they're user-friendly
5. **Test valid submission** - Ensure happy path works
6. **Check network requests** - Verify API calls correct
7. **Test cancel/reset** - Ensure cleanup works

## Quick Reference

```typescript
// Setup
tabs_context_mcp({ createIfEmpty: true })
navigate(formUrl, tabId)

// Find & fill fields
find({ query: "field name input", tabId })
form_input({ ref: "ref_1", value: "text", tabId })

// Trigger validation
computer({ action: "key", text: "Tab", tabId })
computer({ action: "left_click", ref: submitRef, tabId })

// Check errors
find({ query: "error message", tabId })

// Monitor network
read_network_requests({ tabId, urlPattern: "/api/" })
```

---

**Remember:** Form validation tests help catch schema mismatches and UX issues early!
