# Review Command

Self-review the code just written, find issues, fix them, and document learnings.

## Instructions

After writing code, perform a thorough self-critique:

### Checklist

**1. Correctness**

- Does it do what's intended?
- Are all edge cases handled?
- null, empty, boundary conditions?

**2. Error Handling**

- Are errors caught properly?
- Is error handling appropriate?
- Are error messages helpful?

**3. TypeScript/Type Safety**

- No `any` types?
- Proper TypeBox schemas?
- Type guards where needed?

**4. Performance**

- Any N+1 queries?
- Unnecessary loops or operations?
- Efficient data structures?

**5. Security**

- SQL injection prevented? (use TypeBox)
- XSS prevented?
- Auth checks in place?
- Input validation?

**6. AegisX Patterns**

- Following existing patterns?
- Using correct layer (CORE/PLATFORM/DOMAINS)?
- Correct domain classification?
- Schema selection correct?

**7. Build & Tests**

- `pnpm run build` passes?
- Tests passing?
- No TypeScript errors?

### Report Format

For each issue found:

```
Severity: 🔴 Critical / 🟡 Warning / 🔵 Info
Location: [file:line]
Problem: [description]
Fix: [suggested solution]
```

### After Review

1. Fix all 🔴 Critical issues immediately
2. Fix 🟡 Warnings if time permits
3. Document 🔵 Info for future improvement
4. Run `/reflect` to capture learnings

### Example Review Output

```
🔴 Critical - apps/api/src/modules/products/routes.ts:45
Problem: No authentication check on POST endpoint
Fix: Add `@preValidation(authStrategies.jwt)` before route handler

🟡 Warning - apps/api/src/modules/products/service.ts:23
Problem: N+1 query loading related suppliers
Fix: Use JOIN or eager loading instead of sequential queries

🔵 Info - apps/web/src/app/features/products/list.component.ts:67
Problem: Magic number '10' for page size
Fix: Extract to constant DEFAULT_PAGE_SIZE
```

## Usage

Simply type: `/review`

Or say: "Review the code I just wrote"

## Tips

- Be honest with yourself - find real issues
- Don't just say "looks good" without checking
- If you find nothing, you're probably not looking hard enough
- Better to find bugs now than in production!
