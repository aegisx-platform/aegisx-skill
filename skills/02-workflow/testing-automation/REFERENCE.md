# Testing Quick Reference

Quick lookup for common test patterns and commands.

## Test Commands

```bash
# Run all tests
pnpm test

# Unit tests only
pnpm test:unit

# Integration tests
pnpm test:integration

# Integration tests (verbose)
pnpm test:integration:verbose

# E2E tests
pnpm test:e2e

# Watch mode
pnpm test -- --watch

# Coverage report
pnpm test -- --coverage

# Specific file
pnpm test activity-logs.controller.spec.ts

# Match test name
pnpm test -- --testNamePattern="should create"
```

## Test File Structure

```typescript
describe('ClassName', () => {
  let instance: ClassName;

  beforeEach(() => {
    jest.clearAllMocks();
    instance = new ClassName(dependencies);
  });

  describe('methodName', () => {
    it('should do something', async () => {
      // Arrange
      mockDep.method.mockResolvedValue(data);

      // Act
      const result = await instance.method(params);

      // Assert
      expect(result).toEqual(expected);
    });
  });
});
```

## Mock Patterns

### Controller Mocks

```typescript
const mockService = {
  findAll: jest.fn(),
  findById: jest.fn(),
  create: jest.fn(),
  update: jest.fn(),
  delete: jest.fn(),
};

const mockRequest = {
  query: {},
  params: {},
  body: {},
  user: { id: 'user-1' },
  log: { info: jest.fn(), error: jest.fn() },
} as any;

const mockReply = {
  send: jest.fn().mockReturnThis(),
  success: jest.fn().mockReturnThis(),
  error: jest.fn().mockReturnThis(),
  notFound: jest.fn().mockReturnThis(),
} as any;
```

### Service Mocks

```typescript
const mockRedis = {
  get: jest.fn(),
  setex: jest.fn(),
  del: jest.fn(),
  keys: jest.fn(),
};

const mockKnex = jest.fn() as any;

jest.mock('../your.repository');
const mockRepository = {
  findAll: jest.fn(),
  create: jest.fn(),
};

beforeEach(() => {
  (YourRepository as jest.MockedClass<typeof YourRepository>).mockImplementation(() => mockRepository as any);

  service = new YourService(mockKnex, mockRedis);
  service['repository'] = mockRepository as any;
});
```

### Repository Mocks

```typescript
const mockKnexChain = {
  select: jest.fn().mockReturnThis(),
  from: jest.fn().mockReturnThis(),
  where: jest.fn().mockReturnThis(),
  orderBy: jest.fn().mockReturnThis(),
  limit: jest.fn().mockReturnThis(),
  offset: jest.fn().mockReturnThis(),
  first: jest.fn(),
  then: jest.fn(),
  insert: jest.fn().mockReturnThis(),
  update: jest.fn().mockReturnThis(),
  delete: jest.fn().mockReturnThis(),
  returning: jest.fn().mockReturnThis(),
};

const mockKnex = jest.fn().mockReturnValue(mockKnexChain) as any;
mockKnex.raw = jest.fn();
mockKnex.fn = { now: jest.fn() };
```

## Common Test Cases

### Controller Tests

```typescript
// Success case
it('should return paginated results', async () => {
  mockService.findAll.mockResolvedValue({ data: [], total: 0 });
  mockRequest.query = { page: 1, limit: 10 };

  await controller.findAll(mockRequest, mockReply);

  expect(mockService.findAll).toHaveBeenCalled();
  expect(mockReply.send).toHaveBeenCalled();
});

// Error handling
it('should handle errors', async () => {
  mockService.findAll.mockRejectedValue(new Error('DB error'));

  await controller.findAll(mockRequest, mockReply);

  expect(mockReply.error).toHaveBeenCalledWith('FETCH_ERROR', expect.any(String), 500);
});

// Not found
it('should return 404 if not found', async () => {
  mockService.findById.mockRejectedValue(new Error('ERROR_NOT_FOUND'));

  await controller.findById(mockRequest, mockReply);

  expect(mockReply.notFound).toHaveBeenCalled();
});
```

### Service Tests

```typescript
// Validation error
it('should throw error if field missing', async () => {
  await expect(service.create({})).rejects.toThrow('FIELD_REQUIRED');
});

// Cache hit
it('should return from cache', async () => {
  mockRedis.get.mockResolvedValue(JSON.stringify({ data: 'cached' }));

  const result = await service.getData();

  expect(mockRepository.getData).not.toHaveBeenCalled();
});

// Cache miss
it('should fetch from DB and cache', async () => {
  mockRedis.get.mockResolvedValue(null);
  mockRepository.getData.mockResolvedValue({ data: 'db' });

  await service.getData();

  expect(mockRedis.setex).toHaveBeenCalled();
});

// Cache invalidation
it('should invalidate cache on update', async () => {
  mockRedis.keys.mockResolvedValue(['key:1', 'key:2']);

  await service.update('id', { data: 'new' });

  expect(mockRedis.del).toHaveBeenCalled();
});
```

### Repository Tests

```typescript
// Query with filters
it('should filter by name', async () => {
  mockKnexChain.then = jest.fn((resolve) => resolve([]));

  await repository.findAll({ name: 'Test', limit: 10, page: 1 });

  expect(mockKnexChain.where).toHaveBeenCalledWith('name', 'Test');
});

// Create
it('should create and return ID', async () => {
  mockKnexChain.returning.mockResolvedValue([{ id: 'new-id' }]);

  const result = await repository.create({ name: 'Test' });

  expect(mockKnexChain.insert).toHaveBeenCalled();
  expect(result).toBe('new-id');
});

// Find by ID
it('should return item by ID', async () => {
  mockKnexChain.first.mockResolvedValue({ id: '1', name: 'Test' });

  const result = await repository.findById('1');

  expect(mockKnexChain.where).toHaveBeenCalledWith('id', '1');
  expect(result).toEqual({ id: '1', name: 'Test' });
});

// Aggregation
it('should group by category', async () => {
  mockKnexChain.then = jest.fn((resolve) => resolve([{ category: 'A', count: '10' }]));

  const result = await repository.getStatsByCategory();

  expect(mockKnexChain.groupBy).toHaveBeenCalledWith('category');
});
```

## Async Testing

```typescript
// Resolved promise
mockService.getData.mockResolvedValue({ data: 'test' });

// Rejected promise
mockService.getData.mockRejectedValue(new Error('Failed'));

// Test rejection
await expect(service.method()).rejects.toThrow('Error message');

// Test resolution
const result = await service.method();
expect(result).toEqual(expected);
```

## Mock Return Values

```typescript
// Simple value
mock.method.mockReturnValue(value);

// Promise
mock.method.mockResolvedValue(value);
mock.method.mockRejectedValue(error);

// Chain (for fluent APIs)
mock.method.mockReturnThis();

// Different values per call
mock.method.mockResolvedValueOnce(value1).mockResolvedValueOnce(value2);

// Custom implementation
mock.method.mockImplementation((arg) => {
  return arg * 2;
});
```

## Assertions

```typescript
// Equality
expect(result).toBe(value); // Same reference
expect(result).toEqual(value); // Deep equality

// Truthiness
expect(result).toBeTruthy();
expect(result).toBeFalsy();
expect(result).toBeNull();
expect(result).toBeUndefined();
expect(result).toBeDefined();

// Numbers
expect(result).toBeGreaterThan(5);
expect(result).toBeLessThan(10);

// Strings
expect(result).toContain('substring');
expect(result).toMatch(/regex/);

// Arrays
expect(result).toContain(item);
expect(result).toHaveLength(3);

// Objects
expect(result).toHaveProperty('key');
expect(result).toHaveProperty('key', value);
expect(result).toMatchObject({ key: value });

// Functions
expect(mock).toHaveBeenCalled();
expect(mock).toHaveBeenCalledTimes(2);
expect(mock).toHaveBeenCalledWith(arg1, arg2);
expect(mock).toHaveBeenLastCalledWith(arg);

// Exceptions
expect(() => fn()).toThrow();
expect(() => fn()).toThrow('Error message');
await expect(asyncFn()).rejects.toThrow();
```

## Test Lifecycle

```typescript
// Before all tests in file
beforeAll(async () => {
  // Setup that runs once
});

// Before each test
beforeEach(() => {
  jest.clearAllMocks();
  // Reset state
});

// After each test
afterEach(() => {
  // Cleanup
});

// After all tests in file
afterAll(async () => {
  // Final cleanup
  await app.close();
});
```

## Coverage Goals

| Code Type      | Target  | Priority |
| -------------- | ------- | -------- |
| Auth/Security  | 80-100% | MUST     |
| Business Logic | 60-80%  | SHOULD   |
| Utilities      | 40-60%  | NICE     |
| Config/Mocks   | 0%      | SKIP     |

## What to Test

### YES

- Validation rules
- Error handling
- Business logic
- Database queries
- API endpoints
- Edge cases

### NO

- Getters/setters
- Third-party libs
- Configuration
- Mock data
- Trivial code

## File Naming

```
feature.controller.spec.ts    # Controller unit test
feature.service.spec.ts       # Service unit test
feature.repository.spec.ts    # Repository unit test
feature.integration.spec.ts   # Integration test
feature.e2e.ts               # E2E test
```

## Common Errors

### Test Hangs

- Missing `await` keyword
- Mock doesn't resolve/reject
- No timeout set

**Fix**: Add `await`, check mock setup

### Type Error

```typescript
// Import type extensions
import type {} from '../path/to/plugin';

// Use 'as any' for complex mocks
const mock = { ... } as any;
```

### Mock Not Called

- Check `jest.clearAllMocks()` in beforeEach
- Verify mock is passed to instance
- Check method name spelling

## Example Files

```
apps/api/src/layers/core/audit/activity-logs/__tests__/
  - activity-logs.controller.spec.ts
  - activity-logs.service.spec.ts
  - activity-logs.repository.spec.ts
```

## Quick Template

```typescript
import { ClassName } from '../class-name';

const mockDependency = {
  method: jest.fn(),
};

describe('ClassName', () => {
  let instance: ClassName;

  beforeEach(() => {
    jest.clearAllMocks();
    instance = new ClassName(mockDependency as any);
  });

  describe('method', () => {
    it('should work', async () => {
      mockDependency.method.mockResolvedValue('result');

      const result = await instance.method();

      expect(mockDependency.method).toHaveBeenCalled();
      expect(result).toBe('result');
    });

    it('should handle errors', async () => {
      mockDependency.method.mockRejectedValue(new Error('Failed'));

      await expect(instance.method()).rejects.toThrow('Failed');
    });
  });
});
```

## Integration Test Template

```typescript
import request from 'supertest';
import { FastifyInstance } from 'fastify';

describe('Feature API', () => {
  let app: FastifyInstance;
  let token: string;

  beforeAll(async () => {
    app = await createTestApp();
    const res = await request(app.server).post('/api/auth/login').send({ username: 'test', password: 'test' });
    token = res.body.data.accessToken;
  });

  afterAll(async () => {
    await app.close();
  });

  it('should GET /api/resource', async () => {
    const res = await request(app.server).get('/api/resource').set('Authorization', `Bearer ${token}`).expect(200);

    expect(res.body.success).toBe(true);
  });

  it('should POST /api/resource', async () => {
    const res = await request(app.server).post('/api/resource').set('Authorization', `Bearer ${token}`).send({ name: 'Test' }).expect(201);

    expect(res.body.data).toHaveProperty('id');
  });
});
```
