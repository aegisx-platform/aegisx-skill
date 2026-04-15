---
name: test-workflows
version: 1.0.0
description: >
  Umbrella skill for manual UI + integration test workflows — covers full CRUD flow testing,
  form validation testing, and general UI interaction testing via Chrome MCP browser
  automation. Use when verifying features after implementation, testing generated CRUD
  modules, validating form rules, or running exploratory UI checks. Progressive disclosure:
  reads references/ files based on task type. Triggers on: test UI, test CRUD, test form,
  manual test, exploratory test, verify feature, browser test, Chrome MCP, UI workflow,
  form validation test, list page test, detail page test, create/edit/delete test.
---

# Test Workflows

## Purpose

Consolidated entry point for three test scenarios that share tooling (Chrome MCP) but differ in focus. Progressive disclosure — read the specific reference file based on what you're testing.

## Decision Tree

```
What are you testing?
├─ A full CRUD module (list → create → view → edit → delete)
│   → Read references/test-crud.md
├─ A form (validation rules, submission, error states)
│   → Read references/test-form.md
└─ General UI interaction, navigation, or workflow
    → Read references/test-ui.md
```

## References

| File | When to load | Focus |
|---|---|---|
| `references/test-crud.md` | Testing a generated CRUD module end-to-end | CRUD flow, list pagination, filters, edit dialog |
| `references/test-form.md` | Testing form rules in isolation | Field validation, submit, error UX, conditional fields |
| `references/test-ui.md` | General UI / navigation / exploratory | Browser automation, Chrome MCP tools, selectors |

## Common Setup (all scenarios)

1. Ensure dev servers running:
   ```bash
   pnpm run dev:api        # localhost:3333
   pnpm run dev:web        # localhost:4200
   ```
2. Login with appropriate test account (see **aegisx-auth-rbac** for 8 accounts)
3. Use Chrome MCP tools (`mcp__claude-in-chrome__*`)

## Quick Start — Testing a CRUD Module

```
1. Navigate to the list page
2. Verify stats cards (server-side values)
3. Create a new record → verify in list
4. Edit the record → verify persistence after reload
5. Delete the record → verify gone
6. Test pagination + search + sort if applicable
```

Full checklist: `references/test-crud.md`

## Quick Start — Testing a Form

```
1. Open form (create mode)
2. Submit empty → all required fields show errors
3. Fill each field with invalid value → specific error
4. Fill with valid values → submit succeeds
5. Reload → data persisted
6. Open form (edit mode) → fields prefilled
```

Full checklist: `references/test-form.md`

## Chrome MCP Essentials

```
tabs_context_mcp         # Get current tabs (ALWAYS call first)
tabs_create_mcp          # Create new tab
navigate                 # Navigate to URL
read_page                # Get page text
find                     # Find element by selector
form_input               # Fill form fields
read_console_messages    # Check JS errors (filter with regex pattern)
read_network_requests    # Check API calls
gif_creator              # Record workflow for bug report
```

**CRITICAL:** Never trigger JavaScript `alert()` / `confirm()` dialogs — they block the extension.

## Related Skills

- **test-crud** (legacy — content now in `references/test-crud.md`)
- **test-form** (legacy — content now in `references/test-form.md`)
- **test-ui** (legacy — content now in `references/test-ui.md`)
- **testing-automation** — automated test generation (unit / integration / E2E)
- **e2e-testing** (global) — Playwright E2E patterns
- **debug-ui** — diagnose UI bugs via console / network
- **record-workflow** (meta) — capture workflow as GIF
