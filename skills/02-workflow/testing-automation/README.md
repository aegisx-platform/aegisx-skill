# Testing Automation Skill - Human Guide

A practical testing skill for writing unit and integration tests in the AegisX platform.

## Overview

This skill helps you write tests efficiently by providing:

- Real test patterns extracted from existing codebase
- Copy-paste templates for common test scenarios
- Realistic guidelines (no 100% coverage obsession)
- Quick commands for running tests

## When to Write Tests

### Do Write Tests For:

- New CRUD modules
- Authentication/authorization features
- Payment or financial logic
- Data validation rules
- Complex business logic
- Bug fixes (regression tests)

### Don't Waste Time On:

- Documentation changes
- Configuration files
- Simple getters/setters
- Mock data utilities
- 100% code coverage goals

## Test Types Available

### 1. Unit Tests

**Controller Tests**

- Mock the service layer
- Test HTTP responses
- Test error handling
- File: `*.controller.spec.ts`

**Service Tests**

- Mock repository and Redis
- Test business logic
- Test validation rules
- Test caching behavior
- File: `*.service.spec.ts`

**Repository Tests**

- Mock Knex query chains
- Test database queries
- Test filters and pagination
- File: `*.repository.spec.ts`

### 2. Integration Tests

- Test with real database
- Test API endpoints end-to-end
- File: `*.integration.spec.ts`

### 3. E2E Tests

- Test user flows in browser
- Uses Playwright
- File: `*.e2e.ts`

## Quick Start

### 1. Copy Template

Choose the appropriate template from `SKILL.md`:

- Controller test template (for HTTP handlers)
- Service test template (for business logic)
- Repository test template (for database queries)

### 2. Replace Placeholders

```typescript
// Replace these in the template:
YourController → ActivityLogsController
YourService → ActivityLogsService
YourRepository → ActivityLogsRepository
your_table_name → user_activity_logs
```

### 3. Add Your Test Cases

Focus on:

- Critical validation rules
- Error paths
- Edge cases (null, empty, invalid data)

### 4. Run Tests

```bash
# Run all tests
pnpm test

# Run specific file
pnpm test activity-logs.controller.spec.ts

# Watch mode (auto-rerun on changes)
pnpm test -- --watch

# With coverage report
pnpm test -- --coverage
```

## Common Commands

```bash
# Unit tests only
pnpm test:unit

# Integration tests
pnpm test:integration

# Integration tests with verbose output
pnpm test:integration:verbose

# E2E tests
pnpm test:e2e

# Run tests matching pattern
pnpm test -- --testNamePattern="should create"
```

## Test Structure

Every test follows this structure:

```typescript
describe('ComponentName', () => {
  // Setup
  let component: ComponentName;

  beforeEach(() => {
    // Reset mocks, create instances
    jest.clearAllMocks();
    component = new ComponentName(dependencies);
  });

  describe('methodName', () => {
    it('should do something successfully', async () => {
      // Arrange - set up mocks
      mockService.method.mockResolvedValue(data);

      // Act - call the method
      const result = await component.method(params);

      // Assert - verify results
      expect(result).toEqual(expected);
      expect(mockService.method).toHaveBeenCalledWith(params);
    });

    it('should handle errors', async () => {
      // Test error case
      mockService.method.mockRejectedValue(new Error('Failed'));

      await expect(component.method(params)).rejects.toThrow('Failed');
    });
  });
});
```

## Realistic Coverage Goals

- **Critical code**: 80-100% (auth, payments, validation)
- **Business logic**: 60-80% (services, complex calculations)
- **Simple code**: 40-60% (utilities, helpers)
- **Don't test**: Configuration, mocks, trivial code

## Common Patterns

### Mock Service in Controller

```typescript
const mockService = {
  findAll: jest.fn(),
  create: jest.fn(),
};
```

### Mock Repository in Service

```typescript
jest.mock('../your.repository');
const mockRepository = {
  /* methods */
};
```

### Mock Knex in Repository

```typescript
const mockKnexChain = {
  select: jest.fn().mockReturnThis(),
  where: jest.fn().mockReturnThis(),
  // ... chainable methods
};
const mockKnex = jest.fn().mockReturnValue(mockKnexChain);
```

### Test Async Functions

```typescript
// Success case
mockService.getData.mockResolvedValue({ data: 'test' });

// Error case
mockService.getData.mockRejectedValue(new Error('Failed'));
```

## Examples from Codebase

Real examples you can reference:

**Controller Test**

```
apps/api/src/layers/core/audit/activity-logs/__tests__/activity-logs.controller.spec.ts
```

**Service Test**

```
apps/api/src/layers/core/audit/activity-logs/__tests__/activity-logs.service.spec.ts
```

**Repository Test**

```
apps/api/src/layers/core/audit/activity-logs/__tests__/activity-logs.repository.spec.ts
```

## Troubleshooting

### Tests Hang/Timeout

- Add `await` to async calls
- Check mocks are properly set up
- Verify promises resolve/reject

### Mock Not Working

- Clear mocks: `jest.clearAllMocks()` in beforeEach
- Check mock structure matches real object
- Use `mockReturnThis()` for chainable methods

### Type Errors

- Import type extensions if needed
- Use `as any` for complex mock types
- Check mock implements correct interface

## Tips

1. **Write tests incrementally** - Don't write all tests at once
2. **Test behavior, not implementation** - Focus on what, not how
3. **One assertion per test is a myth** - Group related assertions
4. **Use descriptive test names** - "should return user when ID exists"
5. **Don't mock everything** - Integration tests are valuable too

## What NOT to Do

- Don't aim for 100% coverage
- Don't test third-party libraries
- Don't test implementation details
- Don't write duplicate tests
- Don't test trivial code

## Need Help?

1. Check `SKILL.md` for detailed patterns
2. Check `REFERENCE.md` for quick lookup
3. Look at existing test files in codebase
4. Run tests to see if patterns work

## Integration with Development Workflow

Tests fit into the workflow at these points:

1. **After CRUD generation** - Generate basic CRUD tests
2. **Before bug fix** - Write failing test first
3. **After feature implementation** - Add tests for critical paths
4. **Before PR** - Run full test suite

## Summary

This skill provides:

- Practical test patterns from real code
- Copy-paste templates
- Realistic coverage goals (not 100%)
- Quick test commands
- Focus on critical business logic

Use it when the user asks for tests or when adding critical features. Don't waste time testing trivial code.
