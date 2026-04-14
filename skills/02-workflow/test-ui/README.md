# Test UI Skill

Automated UI testing using browser automation to verify user workflows and interactions.

## When to Use

- User asks to "test UI", "check the page", or "verify the interface"
- After implementing new UI components
- When verifying navigation flows
- Testing user interactions

## What It Does

1. **Gets browser context** and navigates to target URL
2. **Reads page state** using accessibility tree
3. **Performs interactions** (clicks, scrolls, navigation)
4. **Verifies results** (visual, console, network)
5. **Reports findings** with screenshots and pass/fail status

## Example Usage

```
User: "Test the drugs list page UI"

Claude:
1. Opens http://localhost:4200/inventory/master-data/drugs
2. Checks page loads correctly
3. Verifies data table displays
4. Checks for console errors
5. Verifies network requests succeed
6. Takes screenshots
7. Reports: ✅ 5/5 checks passed
```

## Common Test Scenarios

- **Navigation Flow** - Verify menu navigation works
- **Data Display** - Check tables and lists render correctly
- **Button Visibility** - Verify action buttons appear based on permissions
- **Responsive Design** - Test at different screen sizes

## Output

Provides structured test report:
- Test name and URL
- Individual check results (✅/❌)
- Summary (passed/failed/total)
- Issues found
- Screenshots for evidence

## See Also

- `/test-form` - Test form validation
- `/test-crud` - Test CRUD operations
- `/debug-ui` - Debug UI issues
- `/record-workflow` - Record GIF workflows
