---
name: test-crud
description: Test complete CRUD operations (Create, Read, Update, Delete) through the UI. Use when testing generated CRUD modules or verifying full data lifecycle.
allowed-tools: mcp__claude-in-chrome__*, Read, Bash
---

# Test CRUD Operations

End-to-end testing of Create, Read, Update, Delete operations through the user interface.

## When Claude Should Use This Skill

- User asks to "test CRUD", "test the module", or "verify CRUD operations"
- After generating new CRUD module with aegisx-cli
- When verifying data lifecycle workflows
- Testing generated frontend components

## Testing Process

### Step 1: Setup & Navigate

```typescript
const context = await tabs_context_mcp({ createIfEmpty: true });
const tabId = context.tabs[0].id;

// Navigate to list page
await navigate("http://localhost:4200/inventory/master-data/drugs", tabId);
await computer({ action: "wait", duration: 2, tabId });
```

### Step 2: Test CREATE

```typescript
// Click Add button
const addBtn = await find({ query: "Add button", tabId });
await computer({ action: "left_click", ref: addBtn.ref, tabId });
await computer({ action: "wait", duration: 1, tabId });

// Fill form with test data
const testData = {
  code: `TEST-${Date.now()}`,
  name: "Test Drug",
  price: "100.00"
};

for (const [field, value] of Object.entries(testData)) {
  const input = await find({ query: `${field} input`, tabId });
  await form_input({ ref: input.ref, value, tabId });
}

// Submit
const saveBtn = await find({ query: "Save button", tabId });
await computer({ action: "left_click", ref: saveBtn.ref, tabId });
await computer({ action: "wait", duration: 2, tabId });

// Verify created
const success = await find({ query: "success message", tabId });
console.log(`✅ CREATE: ${success.length > 0 ? "PASSED" : "FAILED"}`);
```

### Step 3: Test READ

```typescript
// Verify item appears in table
const table = await read_page({ tabId });
const itemInTable = table.includes(testData.code);

console.log(`✅ READ (List): ${itemInTable ? "PASSED" : "FAILED"}`);

// Click item to view details
const item = await find({ query: testData.code, tabId });
await computer({ action: "left_click", ref: item.ref, tabId });
await computer({ action: "wait", duration: 1, tabId });

// Verify details displayed
const details = await read_page({ tabId });
const hasAllData = Object.values(testData).every(v => details.includes(v));

console.log(`✅ READ (Detail): ${hasAllData ? "PASSED" : "FAILED"}`);
```

### Step 4: Test UPDATE

```typescript
// Click Edit button
const editBtn = await find({ query: "Edit button", tabId });
await computer({ action: "left_click", ref: editBtn.ref, tabId });
await computer({ action: "wait", duration: 1, tabId });

// Modify data
const newName = "Updated Test Drug";
const nameInput = await find({ query: "name input", tabId });
await form_input({ ref: nameInput.ref, value: newName, tabId });

// Save
const saveBtn = await find({ query: "Save button", tabId });
await computer({ action: "left_click", ref: saveBtn.ref, tabId });
await computer({ action: "wait", duration: 2, tabId });

// Verify updated
const updated = await read_page({ tabId });
const isUpdated = updated.includes(newName);

console.log(`✅ UPDATE: ${isUpdated ? "PASSED" : "FAILED"}`);
```

### Step 5: Test DELETE

```typescript
// Click Delete button
const deleteBtn = await find({ query: "Delete button", tabId });
await computer({ action: "left_click", ref: deleteBtn.ref, tabId });
await computer({ action: "wait", duration: 0.5, tabId });

// Confirm deletion
const confirmBtn = await find({ query: "Confirm button", tabId });
await computer({ action: "left_click", ref: confirmBtn.ref, tabId });
await computer({ action: "wait", duration: 2, tabId });

// Verify deleted
const afterDelete = await read_page({ tabId });
const isDeleted = !afterDelete.includes(testData.code);

console.log(`✅ DELETE: ${isDeleted ? "PASSED" : "FAILED"}`);
```

## Report Format

```markdown
## CRUD Test Results

**Module:** Drugs (inventory/master-data/drugs)
**Time:** 2025-12-21T10:30:00.000Z

### Operations:
✅ CREATE - Item created successfully
✅ READ (List) - Item appears in table
✅ READ (Detail) - All data displayed
✅ UPDATE - Changes saved correctly
✅ DELETE - Item removed

### Network Requests:
✅ POST /api/inventory/master-data/drugs → 201 Created
✅ GET /api/inventory/master-data/drugs → 200 OK
✅ GET /api/inventory/master-data/drugs/:id → 200 OK
✅ PUT /api/inventory/master-data/drugs/:id → 200 OK
✅ DELETE /api/inventory/master-data/drugs/:id → 200 OK

**Summary:** 5/5 operations passed ✅
```

## Quick Reference

```typescript
// CREATE
click Add → fill form → submit → verify success

// READ (List)
verify item in table

// READ (Detail)
click item → verify details displayed

// UPDATE
click Edit → modify data → save → verify changes

// DELETE
click Delete → confirm → verify removed
```
