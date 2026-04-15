---
name: testing-automation
description: Create unit tests, integration tests, and E2E tests for features and bug fixes. Use when user requests tests or when adding critical business logic that needs test coverage.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Testing Automation Skill

## When to Use This Skill

Use this skill when:

- User explicitly requests writing tests
- Adding a new CRUD module or feature that needs test coverage
- Fixing bugs (write regression tests)
- User asks to "test" or "add tests for" specific functionality

DO NOT use this skill for:

- Simple code changes without user request
- Documentation updates
- Configuration changes

## When to Write Tests (Realistic Guidelines)

### ALWAYS Write Tests For:

1. Critical business logic (authentication, authorization, payments)
2. Data validation and transformation
3. Complex calculations or algorithms
4. CRUD operations for core entities
5. API endpoints that handle money or sensitive data

### SOMETIMES Write Tests For:

6. Utility functions and helpers
7. Database queries with complex filters
8. Error handling flows
9. Service layer business rules

### OPTIONAL Tests:

10. Simple getters/setters
11. Trivial wrapper functions
12. Mock data generation utilities

### DON'T Waste Time On:

- 100% code coverage (aim for 60-80% on critical paths)
- Testing external libraries
- Over-mocking everything (integration tests are valuable)

## Test Patterns from Existing Code

### 1. Controller Tests (Mock Service Layer)

**Purpose**: Test HTTP request/response handling, error responses, data formatting

**Pattern**:

```typescript
import { YourController } from '../your.controller';
import { YourService } from '../your.service';
// IMPORTANT: Load FastifyReply type extensions
import type {} from '../../../../../plugins/response-handler.plugin';

// Mock Service
const mockService = {
  findAll: jest.fn(),
  findById: jest.fn(),
  create: jest.fn(),
  update: jest.fn(),
  delete: jest.fn(),
};

// Mock Fastify Request
const mockRequest = {
  query: {},
  params: {},
  body: {},
  user: { id: 'user-1' },
  log: {
    info: jest.fn(),
    error: jest.fn(),
    warn: jest.fn(),
    debug: jest.fn(),
  },
} as any;

// Mock Fastify Reply
const mockReply = {
  code: jest.fn().mockReturnThis(),
  send: jest.fn().mockReturnThis(),
  header: jest.fn().mockReturnThis(),
  success: jest.fn().mockReturnThis(),
  error: jest.fn().mockReturnThis(),
  notFound: jest.fn().mockReturnThis(),
  badRequest: jest.fn().mockReturnThis(),
} as any;

describe('YourController', () => {
  let controller: YourController;

  beforeEach(() => {
    jest.clearAllMocks();
    controller = new YourController(mockService as any);
  });

  describe('findAll', () => {
    it('should return paginated results', async () => {
      const mockData = [{ id: '1', name: 'Test' }];
      const mockResult = {
        data: mockData,
        page: 1,
        limit: 10,
        total: 1,
        totalPages: 1,
      };
      mockService.findAll.mockResolvedValue(mockResult);

      mockRequest.query = { page: 1, limit: 10 };

      await controller.findAll(mockRequest, mockReply);

      expect(mockService.findAll).toHaveBeenCalled();
      expect(mockReply.send).toHaveBeenCalledWith(
        expect.objectContaining({
          success: true,
          data: mockData,
        }),
      );
    });

    it('should handle errors gracefully', async () => {
      mockService.findAll.mockRejectedValue(new Error('Database error'));

      mockRequest.query = { page: 1, limit: 10 };

      await controller.findAll(mockRequest, mockReply);

      expect(mockRequest.log.error).toHaveBeenCalled();
      expect(mockReply.error).toHaveBeenCalledWith('FETCH_ERROR', expect.any(String), 500);
    });
  });

  describe('findById', () => {
    it('should return item by ID', async () => {
      const mockItem = { id: '1', name: 'Test' };
      mockService.findById.mockResolvedValue(mockItem);

      mockRequest.params = { id: '1' };

      await controller.findById(mockRequest, mockReply);

      expect(mockService.findById).toHaveBeenCalledWith('1');
      expect(mockReply.success).toHaveBeenCalledWith(mockItem);
    });

    it('should return 404 if not found', async () => {
      mockService.findById.mockRejectedValue(new Error('ERROR_NOT_FOUND'));

      mockRequest.params = { id: 'nonexistent' };

      await controller.findById(mockRequest, mockReply);

      expect(mockReply.notFound).toHaveBeenCalled();
    });
  });
});
```

### 2. Service Tests (Mock Repository + Redis)

**Purpose**: Test business logic, validation, caching, data transformation

**Pattern**:

```typescript
import { YourService } from '../your.service';
import { YourRepository } from '../your.repository';

// Mock Redis
const mockRedis = {
  get: jest.fn(),
  setex: jest.fn(),
  del: jest.fn(),
  keys: jest.fn(),
};

// Mock Knex
const mockKnex = jest.fn() as any;

// Mock Repository
jest.mock('../your.repository');

const mockRepository = {
  findAll: jest.fn(),
  findById: jest.fn(),
  create: jest.fn(),
  update: jest.fn(),
  delete: jest.fn(),
};

describe('YourService', () => {
  let service: YourService;

  beforeEach(() => {
    jest.clearAllMocks();

    // Mock the Repository constructor
    (YourRepository as jest.MockedClass<typeof YourRepository>).mockImplementation(() => mockRepository as any);

    service = new YourService(mockKnex, mockRedis as any);
    service['repository'] = mockRepository as any;
  });

  describe('create', () => {
    it('should create item and invalidate cache', async () => {
      const newItem = {
        name: 'Test Item',
        value: 100,
      };

      mockRepository.create.mockResolvedValue('new-id');
      mockRedis.keys.mockResolvedValue(['cache:key:1']);

      const result = await service.create(newItem);

      expect(mockRepository.create).toHaveBeenCalledWith(newItem);
      expect(mockRedis.del).toHaveBeenCalled();
      expect(result).toBe('new-id');
    });

    it('should throw error if name is missing', async () => {
      const invalidItem = { value: 100 };

      await expect(service.create(invalidItem as any)).rejects.toThrow('NAME_REQUIRED');
    });

    it('should throw error for invalid value', async () => {
      const invalidItem = { name: 'Test', value: -100 };

      await expect(service.create(invalidItem)).rejects.toThrow('INVALID_VALUE');
    });
  });

  describe('getStats with cache', () => {
    const mockStats = {
      total: 200,
      recent24h: 20,
    };

    it('should return stats from cache if available', async () => {
      mockRedis.get.mockResolvedValue(JSON.stringify(mockStats));

      const result = await service.getStats(7);

      expect(mockRedis.get).toHaveBeenCalledWith('stats:7');
      expect(mockRepository.getStats).not.toHaveBeenCalled();
      expect(result).toEqual(mockStats);
    });

    it('should fetch from database and cache on cache miss', async () => {
      mockRedis.get.mockResolvedValue(null);
      mockRepository.getStats.mockResolvedValue(mockStats);

      const result = await service.getStats(7);

      expect(mockRepository.getStats).toHaveBeenCalledWith(7);
      expect(mockRedis.setex).toHaveBeenCalledWith('stats:7', 300, JSON.stringify(mockStats));
      expect(result).toEqual(mockStats);
    });

    it('should work without Redis', async () => {
      const serviceWithoutRedis = new YourService(mockKnex, null);
      serviceWithoutRedis['repository'] = mockRepository as any;
      mockRepository.getStats.mockResolvedValue(mockStats);

      const result = await serviceWithoutRedis.getStats(7);

      expect(mockRepository.getStats).toHaveBeenCalledWith(7);
      expect(result).toEqual(mockStats);
    });
  });
});
```

### 3. Repository Tests (Mock Knex Query Chain)

**Purpose**: Test database queries, filters, pagination, aggregations

**Pattern**:

```typescript
import { YourRepository } from '../your.repository';

// Mock Knex chain
const mockKnexChain = {
  select: jest.fn().mockReturnThis(),
  from: jest.fn().mockReturnThis(),
  where: jest.fn().mockReturnThis(),
  whereRaw: jest.fn().mockReturnThis(),
  whereBetween: jest.fn().mockReturnThis(),
  whereIn: jest.fn().mockReturnThis(),
  whereNotNull: jest.fn().mockReturnThis(),
  orderBy: jest.fn().mockReturnThis(),
  limit: jest.fn().mockReturnThis(),
  offset: jest.fn().mockReturnThis(),
  count: jest.fn().mockReturnThis(),
  groupBy: jest.fn().mockReturnThis(),
  insert: jest.fn().mockReturnThis(),
  update: jest.fn().mockReturnThis(),
  delete: jest.fn().mockReturnThis(),
  returning: jest.fn().mockReturnThis(),
  first: jest.fn(),
  then: jest.fn(),
  increment: jest.fn().mockReturnThis(),
  clone: jest.fn().mockReturnThis(),
};

// Mock Knex function
const mockKnex = jest.fn().mockReturnValue(mockKnexChain) as any;
mockKnex.raw = jest.fn().mockReturnValue('mocked_raw');
mockKnex.fn = {
  now: jest.fn().mockReturnValue('mocked_now'),
};

describe('YourRepository', () => {
  let repository: YourRepository;

  beforeEach(() => {
    jest.clearAllMocks();
    repository = new YourRepository(mockKnex as any);
  });

  describe('findAll', () => {
    it('should return all items with pagination', async () => {
      const mockData = [{ id: '1', name: 'Item 1', createdAt: new Date().toISOString() }];

      // Mock count query
      mockKnexChain.first.mockResolvedValue({ count: '1' });
      // Mock data query
      mockKnexChain.then = jest.fn((resolve) => resolve(mockData));

      const result = await repository.findAll({ limit: 10, page: 1 });

      expect(mockKnexChain.select).toHaveBeenCalled();
      expect(mockKnexChain.limit).toHaveBeenCalledWith(10);
      expect(mockKnexChain.offset).toHaveBeenCalledWith(0);
      expect(result).toHaveProperty('data');
      expect(result.data).toEqual(mockData);
    });

    it('should filter by name', async () => {
      mockKnexChain.then = jest.fn((resolve) => resolve([]));

      await repository.findAll({ name: 'Test', limit: 10, page: 1 });

      expect(mockKnexChain.where).toHaveBeenCalledWith('name', 'Test');
    });

    it('should filter by date range', async () => {
      mockKnexChain.first.mockResolvedValue({ count: '0' });
      mockKnexChain.then = jest.fn((resolve) => resolve([]));

      const startDate = '2024-01-01';
      const endDate = '2024-01-31';

      await repository.findAll({ startDate, endDate, limit: 10, page: 1 });

      expect(mockKnexChain.where).toHaveBeenCalled();
    });
  });

  describe('findById', () => {
    it('should return item by ID', async () => {
      const mockItem = { id: '1', name: 'Test' };
      mockKnexChain.first = jest.fn().mockResolvedValue(mockItem);

      const result = await repository.findById('1');

      expect(mockKnexChain.where).toHaveBeenCalledWith('id', '1');
      expect(mockKnexChain.first).toHaveBeenCalled();
      expect(result).toEqual(mockItem);
    });

    it('should return null if not found', async () => {
      mockKnexChain.first = jest.fn().mockResolvedValue(null);

      const result = await repository.findById('nonexistent');

      expect(result).toBeNull();
    });
  });

  describe('create', () => {
    it('should create item and return ID', async () => {
      const newItem = { name: 'New Item', value: 100 };

      mockKnexChain.returning = jest.fn().mockResolvedValue([{ id: 'new-id' }]);

      const result = await repository.create(newItem);

      expect(mockKnex).toHaveBeenCalledWith('your_table_name');
      expect(mockKnexChain.insert).toHaveBeenCalled();
      expect(mockKnexChain.returning).toHaveBeenCalledWith('id');
      expect(result).toBe('new-id');
    });
  });

  describe('delete', () => {
    it('should delete item by ID', async () => {
      mockKnexChain.delete = jest.fn().mockResolvedValue(1);

      await repository.delete('1');

      expect(mockKnex).toHaveBeenCalledWith('your_table_name');
      expect(mockKnexChain.where).toHaveBeenCalledWith('id', '1');
      expect(mockKnexChain.delete).toHaveBeenCalled();
    });
  });

  describe('getStatsByCategory', () => {
    it('should return statistics grouped by category', async () => {
      const mockResults = [
        { category: 'A', count: '10' },
        { category: 'B', count: '5' },
      ];

      mockKnexChain.then = jest.fn((resolve) => resolve(mockResults));

      const result = await repository.getStatsByCategory();

      expect(mockKnex).toHaveBeenCalledWith('your_table_name');
      expect(mockKnexChain.select).toHaveBeenCalledWith('category');
      expect(mockKnexChain.groupBy).toHaveBeenCalledWith('category');
      expect(result).toEqual({
        A: 10,
        B: 5,
      });
    });

    it('should return zero counts for empty results', async () => {
      mockKnexChain.then = jest.fn((resolve) => resolve([]));

      const result = await repository.getStatsByCategory();

      expect(result).toBeDefined();
    });
  });
});
```

### 4. Integration Tests (Real Database/API)

**Purpose**: Test end-to-end flows with real dependencies

**Pattern**:

```typescript
import request from 'supertest';
import { FastifyInstance } from 'fastify';
import { createTestApp } from '../../../test-helpers/app-factory';

describe('Your API Integration Tests', () => {
  let app: FastifyInstance;
  let authToken: string;

  beforeAll(async () => {
    app = await createTestApp();

    // Get auth token
    const loginResponse = await request(app.server).post('/api/auth/login').send({ username: 'testuser', password: 'testpass' });

    authToken = loginResponse.body.data.accessToken;
  });

  afterAll(async () => {
    await app.close();
  });

  describe('GET /api/items', () => {
    it('should return items list', async () => {
      const response = await request(app.server).get('/api/items').set('Authorization', `Bearer ${authToken}`).expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data).toBeInstanceOf(Array);
    });

    it('should return 401 without auth token', async () => {
      await request(app.server).get('/api/items').expect(401);
    });
  });

  describe('POST /api/items', () => {
    it('should create new item', async () => {
      const newItem = {
        name: 'Test Item',
        value: 100,
      };

      const response = await request(app.server).post('/api/items').set('Authorization', `Bearer ${authToken}`).send(newItem).expect(201);

      expect(response.body.success).toBe(true);
      expect(response.body.data).toHaveProperty('id');
      expect(response.body.data.name).toBe(newItem.name);
    });

    it('should validate required fields', async () => {
      const invalidItem = { value: 100 }; // missing name

      const response = await request(app.server).post('/api/items').set('Authorization', `Bearer ${authToken}`).send(invalidItem).expect(400);

      expect(response.body.success).toBe(false);
    });
  });
});
```

## Common Mocking Patterns

### Mocking Dependencies in Constructor

```typescript
// Mock the dependency module
jest.mock('../your.repository');

const mockRepository = {
  findAll: jest.fn(),
  create: jest.fn(),
};

beforeEach(() => {
  // Reset mocks
  jest.clearAllMocks();

  // Mock constructor
  (YourRepository as jest.MockedClass<typeof YourRepository>).mockImplementation(() => mockRepository as any);

  // Create service with mocked dependency
  service = new YourService(mockKnex, mockRedis);
  service['repository'] = mockRepository as any;
});
```

### Testing Async/Promise Functions

```typescript
// Test successful promise
it('should resolve with data', async () => {
  mockService.getData.mockResolvedValue({ data: 'test' });

  const result = await controller.getData(mockRequest, mockReply);

  expect(result).toEqual({ data: 'test' });
});

// Test rejected promise
it('should handle errors', async () => {
  mockService.getData.mockRejectedValue(new Error('Failed'));

  await controller.getData(mockRequest, mockReply);

  expect(mockReply.error).toHaveBeenCalled();
});
```

### Testing Validation Errors

```typescript
it('should throw error for missing required field', async () => {
  const invalidData = {
    /* missing required fields */
  };

  await expect(service.create(invalidData)).rejects.toThrow('FIELD_REQUIRED');
});

it('should throw error for invalid format', async () => {
  const invalidData = { email: 'not-an-email' };

  await expect(service.create(invalidData)).rejects.toThrow('INVALID_EMAIL');
});
```

### Testing Cache Behavior

```typescript
describe('cache behavior', () => {
  it('should use cache when available', async () => {
    const cachedData = { data: 'cached' };
    mockRedis.get.mockResolvedValue(JSON.stringify(cachedData));

    const result = await service.getData();

    expect(mockRedis.get).toHaveBeenCalledWith('cache:key');
    expect(mockRepository.getData).not.toHaveBeenCalled();
    expect(result).toEqual(cachedData);
  });

  it('should query database on cache miss', async () => {
    mockRedis.get.mockResolvedValue(null);
    const dbData = { data: 'from-db' };
    mockRepository.getData.mockResolvedValue(dbData);

    const result = await service.getData();

    expect(mockRedis.get).toHaveBeenCalled();
    expect(mockRepository.getData).toHaveBeenCalled();
    expect(mockRedis.setex).toHaveBeenCalledWith('cache:key', expect.any(Number), JSON.stringify(dbData));
  });

  it('should invalidate cache on update', async () => {
    mockRedis.keys.mockResolvedValue(['cache:key:1', 'cache:key:2']);
    mockRepository.update.mockResolvedValue(true);

    await service.update('id', { data: 'updated' });

    expect(mockRedis.keys).toHaveBeenCalledWith('cache:*');
    expect(mockRedis.del).toHaveBeenCalledWith('cache:key:1', 'cache:key:2');
  });
});
```

## Running Tests

### Run All Tests

```bash
pnpm test
```

### Run Unit Tests Only

```bash
pnpm test:unit
```

### Run Integration Tests

```bash
pnpm test:integration
```

### Run E2E Tests

```bash
pnpm test:e2e
```

### Run Tests in Watch Mode

```bash
pnpm test -- --watch
```

### Run Tests with Coverage

```bash
pnpm test -- --coverage
```

### Run Specific Test File

```bash
pnpm test -- activity-logs.controller.spec.ts
```

### Run Tests Matching Pattern

```bash
pnpm test -- --testNamePattern="should create"
```

### Run Integration Tests Verbose

```bash
pnpm test:integration:verbose
```

## Test File Naming Conventions

```
# Unit Tests
feature.controller.spec.ts
feature.service.spec.ts
feature.repository.spec.ts

# Integration Tests
feature.integration.spec.ts

# E2E Tests (Playwright)
feature.e2e.ts
```

## Quick Test Generation Workflow

1. **Copy the appropriate template** from patterns above
2. **Replace placeholders**:
   - `YourController` → Actual controller name
   - `YourService` → Actual service name
   - `YourRepository` → Actual repository name
   - `your_table_name` → Actual database table
   - Mock methods → Actual methods from your class

3. **Add specific test cases** based on:
   - Critical validation rules
   - Error handling paths
   - Business logic branches
   - Edge cases (empty arrays, null values, etc.)

4. **Run tests** to verify they pass

## What NOT to Do

- Don't aim for 100% code coverage
- Don't test third-party libraries
- Don't over-mock (use integration tests when appropriate)
- Don't test implementation details (test behavior, not internals)
- Don't write tests for trivial getters/setters
- Don't duplicate tests (one good test > three similar tests)

## When Tests Are NOT Required

- Documentation changes
- Configuration files
- Static asset updates
- Simple type definitions
- Mock data files
- Scripts that run once
- Prototype/experimental code

## Test Priority Guidelines

**Priority 1 (MUST test)**:

- Authentication/Authorization
- Payment processing
- Data validation
- CRUD operations on core entities

**Priority 2 (SHOULD test)**:

- Complex business logic
- Data transformations
- API endpoints
- Database queries

**Priority 3 (NICE to test)**:

- Utility functions
- Helper methods
- Error formatters

**Priority 4 (SKIP testing)**:

- Simple wrappers
- Configuration
- Mock data
- Trivial code

## Troubleshooting

### Test hangs/timeouts

- Check for missing `await` keywords
- Verify mocks are properly set up
- Ensure async operations complete

### Mock not working

- Verify `jest.clearAllMocks()` in beforeEach
- Check mock implementation matches actual interface
- Use `mockReturnThis()` for chainable methods

### Type errors

- Import type extensions: `import type {} from '../path/to/plugin'`
- Use `as any` for complex mock types
- Check that mock structure matches real object

## Angular Signals Testing Patterns (Frontend)

**IMPORTANT**: This project uses Angular 17+ with Signals-based state management. DO NOT use old RxJS/BehaviorSubject patterns.

### Why Signals Testing is Different

**Old Pattern (BehaviorSubject) ❌:**

```typescript
// OLD - Don't use this anymore
const mockData$ = new BehaviorSubject<Product[]>([]);
service.products$.subscribe((products) => {
  expect(products).toEqual(mockProducts);
});
```

**New Pattern (Signals) ✅:**

```typescript
// NEW - Use this
expect(service.products()).toEqual(mockProducts);
```

**Key Differences:**

- Signals are synchronous → No `.subscribe()`, no async handling
- Read with `()` → `service.items()` not `service.items`
- Test `computed()` signals like regular signals
- Use `TestBed.flushEffects()` to trigger effects

---

### 1. Service Testing with Signals

**Service Pattern** (from project):

```typescript
@Injectable({ providedIn: 'root' })
export class ProductsService {
  private http = inject(HttpClient);

  // Private writable signal
  private _state = signal<ProductsState>({
    items: [],
    loading: false,
    error: null,
  });

  // Public read-only signals
  readonly items = computed(() => this._state().items);
  readonly loading = computed(() => this._state().loading);
  readonly error = computed(() => this._state().error);

  // Computed derived signals
  readonly activeItems = computed(() => this.items().filter((item) => item.isActive));

  loadItems(): Observable<Product[]> {
    this._state.update((s) => ({ ...s, loading: true }));

    return this.http.get<ApiResponse<Product[]>>('/api/products').pipe(
      tap((response) => {
        this._state.update((s) => ({
          ...s,
          items: response.data,
          loading: false,
        }));
      }),
    );
  }
}
```

**Test Pattern:**

```typescript
import { TestBed } from '@angular/core/testing';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { ProductsService } from './products.service';

describe('ProductsService (Signals)', () => {
  let service: ProductsService;
  let httpMock: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [ProductsService],
    });

    service = TestBed.inject(ProductsService);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    httpMock.verify();
  });

  it('should initialize with empty state', () => {
    expect(service.items()).toEqual([]);
    expect(service.loading()).toBe(false);
    expect(service.error()).toBeNull();
  });

  it('should update items signal on successful load', () => {
    const mockProducts = [
      { id: '1', name: 'Product 1', isActive: true },
      { id: '2', name: 'Product 2', isActive: false },
    ];

    // Verify initial state
    expect(service.items()).toEqual([]);
    expect(service.loading()).toBe(false);

    // Trigger load
    service.loadItems().subscribe();

    // Check loading state
    expect(service.loading()).toBe(true);

    // Mock HTTP response
    const req = httpMock.expectOne('/api/products');
    expect(req.request.method).toBe('GET');
    req.flush({ success: true, data: mockProducts });

    // Verify signal updates (synchronous!)
    expect(service.items()).toEqual(mockProducts);
    expect(service.loading()).toBe(false);
    expect(service.error()).toBeNull();
  });

  it('should compute active items correctly', () => {
    const mockProducts = [
      { id: '1', name: 'Active', isActive: true },
      { id: '2', name: 'Inactive', isActive: false },
      { id: '3', name: 'Active 2', isActive: true },
    ];

    service.loadItems().subscribe();

    const req = httpMock.expectOne('/api/products');
    req.flush({ success: true, data: mockProducts });

    // Test computed signal
    expect(service.activeItems().length).toBe(2);
    expect(service.activeItems()[0].name).toBe('Active');
  });

  it('should handle error and update error signal', () => {
    service.loadItems().subscribe({
      error: () => {}, // Handle error to prevent test failure
    });

    const req = httpMock.expectOne('/api/products');
    req.error(new ProgressEvent('error'));

    expect(service.loading()).toBe(false);
    expect(service.error()).toBeTruthy();
  });
});
```

**Key Points:**

- ✅ Read signals with `()` → `service.items()`
- ✅ No async handling needed for signal values
- ✅ Test `computed()` signals like regular signals
- ✅ HttpClient still returns Observable (test with `httpMock`)

---

### 2. Component Testing with Signals

**Component Pattern** (from project):

```typescript
@Component({
  selector: 'app-products-list',
  standalone: true,
  imports: [CommonModule, MatTableModule],
  template: `
    @if (service.loading()) {
      <mat-spinner></mat-spinner>
    } @else {
      <table mat-table [dataSource]="service.items()">
        <!-- columns -->
      </table>
    }
  `,
})
export class ProductsListComponent implements OnInit {
  protected service = inject(ProductsService);

  ngOnInit(): void {
    this.service.loadItems().subscribe();
  }
}
```

**Test Pattern:**

```typescript
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { ProductsListComponent } from './products-list.component';
import { ProductsService } from '../services/products.service';
import { signal } from '@angular/core';

describe('ProductsListComponent (Signals)', () => {
  let component: ProductsListComponent;
  let fixture: ComponentFixture<ProductsListComponent>;
  let mockService: jasmine.SpyObj<ProductsService>;

  beforeEach(async () => {
    // Create mock service with signal returns
    mockService = jasmine.createSpyObj('ProductsService', ['loadItems'], {
      // Mock signals as properties that return signals
      items: signal([{ id: '1', name: 'Test Product', isActive: true }]),
      loading: signal(false),
      error: signal(null),
      activeItems: signal([]),
    });

    mockService.loadItems.and.returnValue(of([]));

    await TestBed.configureTestingModule({
      imports: [ProductsListComponent],
      providers: [{ provide: ProductsService, useValue: mockService }],
    }).compileComponents();

    fixture = TestBed.createComponent(ProductsListComponent);
    component = fixture.componentInstance;
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('should display products from signal', () => {
    fixture.detectChanges();

    const table = fixture.nativeElement.querySelector('mat-table');
    expect(table).toBeTruthy();

    // Check if data is rendered
    const compiled = fixture.nativeElement;
    expect(compiled.textContent).toContain('Test Product');
  });

  it('should show spinner when loading', () => {
    // Update mock signal
    mockService.loading = signal(true);

    fixture.detectChanges();

    const spinner = fixture.nativeElement.querySelector('mat-spinner');
    expect(spinner).toBeTruthy();
  });

  it('should call loadItems on init', () => {
    fixture.detectChanges(); // Triggers ngOnInit

    expect(mockService.loadItems).toHaveBeenCalled();
  });
});
```

**Key Points:**

- ✅ Mock signals as properties (not methods)
- ✅ Use `signal()` to create mock signals
- ✅ Update mock signals with `.set()` or recreate
- ✅ Use `fixture.detectChanges()` to trigger change detection

---

### 3. Testing Signal Effects

**When component has effects:**

```typescript
@Component({...})
export class ProductsComponent {
  private service = inject(ProductsService);

  constructor() {
    effect(() => {
      const items = this.service.items();
      console.log('Items updated:', items.length);
    });
  }
}
```

**Test Pattern:**

```typescript
it('should trigger effect when signal changes', () => {
  const consoleSpy = spyOn(console, 'log');

  fixture.detectChanges();
  TestBed.flushEffects(); // Trigger effects

  expect(consoleSpy).toHaveBeenCalledWith('Items updated:', 1);

  // Update signal
  mockService.items.set([{ id: '2', name: 'New' }]);
  TestBed.flushEffects();

  expect(consoleSpy).toHaveBeenCalledWith('Items updated:', 1);
});
```

---

### 4. Testing Signals with Forms

**Component with Reactive Forms + Signals:**

```typescript
@Component({...})
export class ProductFormComponent {
  private service = inject(ProductsService);
  private fb = inject(FormBuilder);

  form = this.fb.group({
    name: ['', Validators.required],
    price: [0, [Validators.required, Validators.min(0)]]
  });

  saveSuccess = signal(false);

  onSubmit(): void {
    if (this.form.valid) {
      this.service.create(this.form.value).subscribe({
        next: () => this.saveSuccess.set(true)
      });
    }
  }
}
```

**Test Pattern:**

```typescript
it('should set success signal on save', fakeAsync(() => {
  mockService.create.and.returnValue(of({ id: '1', name: 'Test' }));

  component.form.patchValue({ name: 'Test', price: 100 });
  component.onSubmit();

  tick(); // Process async operations

  expect(component.saveSuccess()).toBe(true);
}));
```

---

### 5. Common Mistakes with Signal Testing

**❌ WRONG: Treating signals like observables**

```typescript
service.items.subscribe(...); // Error: signals don't have subscribe!
```

**✅ CORRECT: Read signals directly**

```typescript
expect(service.items()).toEqual(mockData);
```

---

**❌ WRONG: Forgetting `()` when reading signals**

```typescript
expect(service.items).toEqual(mockData); // Compares functions, not values!
```

**✅ CORRECT: Call signal to get value**

```typescript
expect(service.items()).toEqual(mockData);
```

---

**❌ WRONG: Using async/await for signals**

```typescript
const items = await service.items(); // Signals are synchronous!
```

**✅ CORRECT: Read synchronously**

```typescript
const items = service.items();
```

---

**❌ WRONG: Mocking signals as methods**

```typescript
mockService = {
  items: jasmine.createSpy().and.returnValue([]), // Wrong!
};
```

**✅ CORRECT: Mock as signal properties**

```typescript
mockService = {
  items: signal([]), // Correct!
  loading: signal(false),
};
```

---

### 6. Integration Tests with Signals

**Testing full component + service integration:**

```typescript
describe('ProductsListComponent (Integration)', () => {
  let component: ProductsListComponent;
  let fixture: ComponentFixture<ProductsListComponent>;
  let httpMock: HttpTestingController;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ProductsListComponent, HttpClientTestingModule],
      providers: [ProductsService], // Use real service
    }).compileComponents();

    fixture = TestBed.createComponent(ProductsListComponent);
    component = fixture.componentInstance;
    httpMock = TestBed.inject(HttpTestingController);
  });

  it('should load and display products', () => {
    const mockProducts = [{ id: '1', name: 'Test' }];

    fixture.detectChanges(); // Triggers ngOnInit → loadItems()

    const req = httpMock.expectOne('/api/products');
    req.flush({ success: true, data: mockProducts });

    fixture.detectChanges(); // Update view

    const compiled = fixture.nativeElement;
    expect(compiled.textContent).toContain('Test');
  });
});
```

---

### Quick Reference: Signals vs RxJS Testing

| Aspect       | RxJS (Old ❌)                        | Signals (New ✅)        |
| ------------ | ------------------------------------ | ----------------------- |
| Read value   | `.subscribe()` or `firstValueFrom()` | `signal()`              |
| Async        | `fakeAsync`, `tick()`                | Synchronous (no async)  |
| Mock         | `BehaviorSubject` or `of()`          | `signal()`              |
| Update       | `.next()`                            | `.set()` or `.update()` |
| Computed     | `combineLatest` + pipe               | `computed()`            |
| Test trigger | `.subscribe()`                       | Direct read `()`        |

---

### When to Use Each Test Type

**Unit Tests (with mocks):**

- Service with mocked HttpClient ✅
- Component with mocked Service ✅
- Isolated signal logic ✅

**Integration Tests (real service):**

- Component + Service + HttpClient ✅
- Full user flow ✅
- Signal effects integration ✅

---

## Reference Files

**Backend Tests:**

- Controller: `/apps/api/src/layers/core/audit/activity-logs/__tests__/activity-logs.controller.spec.ts`
- Service: `/apps/api/src/layers/core/audit/activity-logs/__tests__/activity-logs.service.spec.ts`
- Repository: `/apps/api/src/layers/core/audit/activity-logs/__tests__/activity-logs.repository.spec.ts`

**Frontend Tests (Signals):**

- Check `apps/web/src/app/` for Angular components using signals
- Look for `.spec.ts` files with signal testing patterns
