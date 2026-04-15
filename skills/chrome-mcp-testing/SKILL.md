---
name: chrome-mcp-testing
version: 1.0.0
description: >
  Chrome browser automation via claude-in-chrome MCP for manual/exploratory testing.
  Covers tool loading via ToolSearch, tab management, navigation, form filling, console
  log reading with regex filters, network inspection, GIF recording, and dialog avoidance
  (CRITICAL - alerts break the extension). Use for any Chrome-based test or UI verification.
  Triggers on: Chrome MCP, claude-in-chrome, browser automation, Chrome test, navigate,
  click, tabs_context_mcp, form_input, read_console_messages, gif_creator, mcp browser,
  tool deferred, ToolSearch chrome.
---

# Chrome MCP Testing

## Purpose

Standardize Chrome browser automation using the `claude-in-chrome` MCP server. Chrome tools are **deferred** — schemas must be loaded before use. Avoiding footguns like blocking dialogs.

## Loading Tools (MANDATORY First Step)

Chrome MCP tools require schema load before use:

```
1. ToolSearch with query "select:mcp__claude-in-chrome__<tool_name>"
2. Then call the tool
```

Example:
```
# Step 1
ToolSearch → "select:mcp__claude-in-chrome__tabs_context_mcp"

# Step 2
mcp__claude-in-chrome__tabs_context_mcp()
```

## Session Start — ALWAYS Call tabs_context_mcp First

```
ALWAYS call mcp__claude-in-chrome__tabs_context_mcp at session start
  - Get fresh tab IDs
  - Understand current browser state
  - Never reuse tab IDs from a previous session
NEVER assume a tab ID is still valid across sessions
```

## Tab Management

```
tabs_context_mcp         # Get all tabs + IDs (call first)
tabs_create_mcp          # Create new tab
switch_browser           # Switch active browser

# If tool returns "tab does not exist":
→ Call tabs_context_mcp again to get fresh IDs
```

## Navigation & Reading

```
navigate(tabId, url)             # Go to URL
read_page(tabId)                 # Get visible text
get_page_text(tabId)             # Full page text
read_console_messages(tabId, pattern?)   # JS console (use regex filter!)
read_network_requests(tabId)     # HTTP calls
```

### Console Logs — ALWAYS Use Pattern Filter

```
NEVER: Read all console messages (noisy, wastes context)
ALWAYS: Filter with regex pattern
  read_console_messages(tabId, pattern: "\\[MyModule\\]")
  read_console_messages(tabId, pattern: "ERROR|WARN")
```

## Interaction

```
find(tabId, selector)            # Find element
form_input(tabId, selector, value)   # Fill input
computer(tabId, action)          # Keyboard/mouse (last resort)
shortcuts_list                   # Available keyboard shortcuts
shortcuts_execute                # Run a shortcut
upload_image(tabId, path)        # File upload
```

## Recording Workflows

For multi-step flows user may want to replay/share:

```
ALWAYS capture extra frames before/after actions (smooth playback)
ALWAYS name the file meaningfully
  gif_creator(filename: "drug-import-flow.gif")
```

## CRITICAL: Dialog Avoidance

JavaScript alerts, confirms, prompts, and browser modals BLOCK all subsequent Chrome MCP commands until dismissed manually.

```
NEVER: Click buttons that trigger alert() / confirm()
  - "Delete" buttons with confirmation dialogs
  - Leave-without-saving prompts
ALWAYS: Warn the user before clicking dialog-triggering elements
ALWAYS: Check for existing dialogs before proceeding:
  javascript_tool(tabId, "return document.activeElement")
```

If a dialog gets triggered accidentally:
```
1. Inform user: "I triggered a dialog — please dismiss it in the browser"
2. Wait for user confirmation before continuing
3. Re-verify tab state: tabs_context_mcp
```

## Rabbit Hole Avoidance

```
STOP and ask for guidance when:
- Same tool fails 2-3 times
- Page elements don't respond to clicks
- Pages timeout / don't load
- Unable to complete task despite multiple approaches
- Browser extension unresponsive

DON'T: retry indefinitely, explore unrelated tabs, keep switching selectors
```

## Common Patterns

### Login Flow

```
1. tabs_context_mcp → get tab IDs
2. navigate(tab, 'http://localhost:4200/login')
3. form_input(tab, '[name="email"]', 'admin@aegisx.local')
4. form_input(tab, '[name="password"]', 'Admin123!')
5. find(tab, 'button[type="submit"]') + click
6. read_page(tab) → verify logged in (look for username)
```

### CRUD List Test

```
1. Navigate to list page
2. read_console_messages(tab, pattern: "ERROR")  # Check errors
3. find(tab, 'mat-table') → verify data loaded
4. read_network_requests(tab) → check API response
5. Click "Create" button → navigate to form
6. Fill form + submit
7. Back to list → verify new row
```

### Import Workflow (with progress)

```
1. Navigate to import page
2. upload_image(tab, '/path/to/test.xlsx')
3. find(tab, '[data-testid="upload-submit"]') + click
4. Loop: read_page(tab) until "imported: N" appears
5. gif_creator(filename: "import-flow.gif")  # for bug report
```

## JavaScript Tool (Advanced)

For reading state not exposed in DOM:

```typescript
javascript_tool(tabId, `
  return {
    signals: window.__debugSignals,
    storage: localStorage.getItem('aegisx-user'),
    url: location.href
  };
`)
```

## Related Skills

- **test-workflows** — umbrella for UI/CRUD/form testing using Chrome MCP
- **debug-ui** — diagnose bugs via console + network
- **test-crud** → `test-workflows/references/test-crud.md`
- **record-workflow** (meta) — GIF capture for documentation

## References

- MCP docs: https://github.com/anthropics/claude-in-chrome
- Available tools: `mcp__claude-in-chrome__*` (20+ tools)
