---
name: record-workflow
description: Record user workflows as animated GIFs for documentation, bug reports, or demos. Use when creating tutorials or capturing user interactions.
allowed-tools: mcp__claude-in-chrome__*, Read, Bash
---

# Record Workflow as GIF

Record browser interactions as animated GIFs for documentation and demonstration purposes.

## When Claude Should Use This Skill

- User asks to "record", "make GIF", "capture workflow"
- Creating documentation or tutorials
- Demonstrating features
- Recording bug reproductions
- Creating visual guides

## Recording Process

### Step 1: Start Recording

```typescript
// Get context
const context = await tabs_context_mcp({ createIfEmpty: true });
const tabId = context.tabs[0].id;

// Start recording
await gif_creator({ action: "start_recording", tabId });

// Take first frame (initial state)
await computer({ action: "screenshot", tabId });
```

### Step 2: Perform Workflow

```typescript
// Navigate to start point
await navigate("http://localhost:4200/inventory/drugs", tabId);
await computer({ action: "wait", duration: 2, tabId });

// Take screenshot after each major step
await computer({ action: "screenshot", tabId });

// Click Add button
const addBtn = await find({ query: "Add button", tabId });
await computer({ action: "left_click", ref: addBtn.ref, tabId });
await computer({ action: "wait", duration: 1, tabId });
await computer({ action: "screenshot", tabId });

// Fill form
const codeInput = await find({ query: "code input", tabId });
await form_input({ ref: codeInput.ref, value: "DRG-001", tabId });
await computer({ action: "wait", duration: 0.5, tabId });

const nameInput = await find({ query: "name input", tabId });
await form_input({ ref: nameInput.ref, value: "Paracetamol", tabId });
await computer({ action: "wait", duration: 0.5, tabId });
await computer({ action: "screenshot", tabId });

// Submit
const saveBtn = await find({ query: "Save button", tabId });
await computer({ action: "left_click", ref: saveBtn.ref, tabId });
await computer({ action: "wait", duration: 2, tabId });

// Take final frame
await computer({ action: "screenshot", tabId });
```

### Step 3: Stop Recording

```typescript
// Stop recording
await gif_creator({ action: "stop_recording", tabId });
```

### Step 4: Export GIF

```typescript
// Export with meaningful filename
await gif_creator({
  action: "export",
  download: true,
  filename: "drug-creation-workflow.gif",
  options: {
    showClickIndicators: true,
    showActionLabels: true,
    showProgressBar: true,
    quality: 10
  },
  tabId
});

console.log("✅ GIF exported: drug-creation-workflow.gif");
```

## Recording Tips

### 1. Plan Your Workflow

```typescript
// Define steps before recording
const workflow = [
  "Navigate to drugs page",
  "Click Add button",
  "Fill drug code: DRG-001",
  "Fill drug name: Paracetamol",
  "Fill price: 100.00",
  "Click Save",
  "Verify success message"
];
```

### 2. Add Pauses

```typescript
// Pause between actions for clarity
await computer({ action: "wait", duration: 1, tabId });

// Longer pause for user to read
await computer({ action: "wait", duration: 2, tabId });
```

### 3. Take Strategic Screenshots

```typescript
// After navigation
await computer({ action: "screenshot", tabId });

// After dialog opens
await computer({ action: "screenshot", tabId });

// After form fill
await computer({ action: "screenshot", tabId });

// After success
await computer({ action: "screenshot", tabId });
```

### 4. Optimize GIF Settings

```typescript
{
  showClickIndicators: true,  // Orange circles on clicks
  showActionLabels: true,     // Black labels describing actions
  showProgressBar: true,      // Orange progress bar
  showWatermark: true,        // Claude logo
  quality: 10                 // 1-30 (lower = better quality)
}
```

## Common Workflows to Record

### 1. Create New Item

```typescript
// Record: Navigate → Click Add → Fill Form → Submit → Verify
```

### 2. Edit Existing Item

```typescript
// Record: Find item → Click Edit → Modify → Save → Verify
```

### 3. Delete Item

```typescript
// Record: Find item → Click Delete → Confirm → Verify removed
```

### 4. Search/Filter

```typescript
// Record: Type search → Results update → Click result → View detail
```

### 5. Navigation Flow

```typescript
// Record: Dashboard → Menu → Submenu → Page loaded
```

## Example: Complete Recording Session

```typescript
async function recordDrugCreationWorkflow() {
  const context = await tabs_context_mcp({ createIfEmpty: true });
  const tabId = context.tabs[0].id;

  // Start recording
  await gif_creator({ action: "start_recording", tabId });

  // Step 1: Navigate
  await navigate("http://localhost:4200/inventory/drugs", tabId);
  await computer({ action: "wait", duration: 2, tabId });
  await computer({ action: "screenshot", tabId });

  // Step 2: Click Add
  const addBtn = await find({ query: "Add button", tabId });
  await computer({ action: "left_click", ref: addBtn.ref, tabId });
  await computer({ action: "wait", duration: 1, tabId });
  await computer({ action: "screenshot", tabId });

  // Step 3: Fill form
  await form_input({
    ref: (await find({ query: "code input", tabId })).ref,
    value: "DRG-001",
    tabId
  });
  await computer({ action: "wait", duration: 0.5, tabId });

  await form_input({
    ref: (await find({ query: "name input", tabId })).ref,
    value: "Paracetamol",
    tabId
  });
  await computer({ action: "wait", duration: 0.5, tabId });
  await computer({ action: "screenshot", tabId });

  // Step 4: Submit
  const saveBtn = await find({ query: "Save button", tabId });
  await computer({ action: "left_click", ref: saveBtn.ref, tabId });
  await computer({ action: "wait", duration: 2, tabId });
  await computer({ action: "screenshot", tabId });

  // Stop and export
  await gif_creator({ action: "stop_recording", tabId });
  await gif_creator({
    action: "export",
    download: true,
    filename: "drug-creation-demo.gif",
    options: {
      showClickIndicators: true,
      showActionLabels: true,
      quality: 10
    },
    tabId
  });

  console.log("✅ Workflow recorded: drug-creation-demo.gif");
}
```

## Best Practices

1. **Short workflows** - 5-10 steps maximum
2. **Clear actions** - Wait between steps
3. **Strategic screenshots** - Capture key moments
4. **Meaningful filenames** - Describe the workflow
5. **Optimize settings** - Balance quality and file size

## Quick Reference

```typescript
// Start
gif_creator({ action: "start_recording", tabId })
computer({ action: "screenshot", tabId })

// Perform actions
[... workflow steps ...]
computer({ action: "screenshot", tabId }) // After each major step

// Stop
gif_creator({ action: "stop_recording", tabId })

// Export
gif_creator({
  action: "export",
  download: true,
  filename: "workflow-name.gif",
  tabId
})
```
