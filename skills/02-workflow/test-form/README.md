# Test Form Skill

Automated form validation testing including input rules, error messages, and submission workflows.

## When to Use

- User asks to "test form", "check validation", or "verify form submission"
- After implementing form components
- When debugging form validation issues
- Testing TypeBox schema validation in UI

## What It Does

1. **Tests empty submission** - Triggers all validation errors
2. **Tests individual fields** - Validates each field's rules
3. **Tests valid submission** - Verifies happy path works
4. **Verifies network requests** - Checks API calls
5. **Reports findings** - Detailed pass/fail per field

## Example

```
User: "Test the budget request form validation"

Claude:
✅ Empty submission triggers validation
✅ Code field: required, min/max length
✅ Amount field: required, positive number
❌ Date field: accepts invalid dates (BUG)
✅ Valid submission succeeds

Summary: 4/5 checks passed
Issue: Date validation needs fixing
```

## See Also

- `/test-ui` - Test general UI
- `/test-crud` - Test CRUD operations
- `/debug-ui` - Debug UI issues
