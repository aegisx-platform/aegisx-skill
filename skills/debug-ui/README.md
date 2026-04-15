# Debug UI Skill

Systematic UI debugging using console logs, network requests, and DOM inspection.

## When to Use

- User reports errors or bugs
- Investigating "not working" issues
- Checking console errors
- Debugging failed API calls

## What It Does

1. **Reads console errors** - Finds JavaScript errors
2. **Checks network** - Identifies failed API calls
3. **Inspects DOM** - Finds missing elements
4. **Executes JS** - Deep state inspection
5. **Reports root cause** - Clear diagnosis

## Example

```
User: "The form won't submit"

Claude:
❌ Console: TypeError at line 45
❌ Network: POST /api/drugs → 400
⚠️ DOM: Submit button disabled
⚠️ Code field empty

Root cause: Validation prevents submission
Fix: Code field is required
```
