# Test CRUD Skill

End-to-end testing of Create, Read, Update, Delete operations through the UI.

## When to Use

- Testing generated CRUD modules
- Verifying complete data lifecycle
- After running `pnpm run crud`

## What It Does

Tests all CRUD operations:
1. **CREATE** - Add new item
2. **READ** - List & detail views
3. **UPDATE** - Edit existing item
4. **DELETE** - Remove item

## Example

```
User: "Test the drugs CRUD module"

Claude:
✅ CREATE - Drug created
✅ READ - Appears in table
✅ UPDATE - Name changed
✅ DELETE - Removed successfully

All operations passed!
```
