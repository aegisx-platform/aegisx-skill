---
name: performance-test
description: Run performance and load testing using k6 and Artillery. Use before production deployments, after optimizations, or to establish performance baselines. Tests API endpoints, database queries, and frontend performance.
allowed-tools: Bash, Read, Write, Edit
---

# Performance Test Skill

> **⚡ Automated performance and load testing**
>
> **Measure performance, identify bottlenecks, prevent regressions**

---

## 🎯 Purpose

**Problem:**

- No performance testing before deployment
- Unknown system capacity
- Performance regressions go undetected
- No performance budgets

**Solution:**

- Automated load testing
- Performance benchmarking
- Regression detection
- Capacity planning

---

## 📋 When to Use

**RECOMMENDED before:**

- ✅ Production deployments
- ✅ After performance optimizations
- ✅ Infrastructure changes
- ✅ Database migrations
- ✅ Major feature releases

**OPTIONAL for:**

- Capacity planning
- Performance baselines
- Regression testing
- Stress testing

---

## 🚀 Usage

```bash
User: /performance-test api            # Test API endpoints
User: /performance-test load           # Load test (1000 users)
User: /performance-test stress         # Stress test (find limits)
User: /performance-test spike          # Spike test (sudden traffic)
User: /performance-test baseline       # Create performance baseline
User: /performance-test regression     # Compare against baseline
```

---

## 🛠️ Performance Testing Tools

### 1. k6 (API Load Testing)

**Why k6:**

- Modern, developer-friendly
- JavaScript-based tests
- Excellent metrics and reporting
- CI/CD integration
- Cloud and local execution

**Installation:**

```bash
# macOS
brew install k6

# Linux
sudo gpg -k
sudo gpg --no-default-keyring --keyring /usr/share/keyrings/k6-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69
echo "deb [signed-by=/usr/share/keyrings/k6-archive-keyring.gpg] https://dl.k6.io/deb stable main" | sudo tee /etc/apt/sources.list.d/k6.list
sudo apt-get update
sudo apt-get install k6

# Docker
docker pull grafana/k6
```

---

### 2. Artillery (Load Testing)

**Why Artillery:**

- Simple YAML configuration
- Real-world scenario testing
- Socket.io and WebSocket support
- Good for complex flows

**Installation:**

```bash
npm install -g artillery
```

---

## 📊 Performance Test Types

### 1. Smoke Test (Sanity Check)

**Purpose:** Verify system works under minimal load
**Users:** 1-10
**Duration:** 1-2 minutes

**k6 Script:**

```javascript
// tests/performance/smoke-test.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 5, // 5 virtual users
  duration: '2m', // 2 minutes
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% of requests < 500ms
    http_req_failed: ['rate<0.01'], // < 1% errors
  },
};

const BASE_URL = __ENV.API_URL || 'http://localhost:3000';

export default function () {
  // Test health endpoint
  const healthRes = http.get(`${BASE_URL}/health`);
  check(healthRes, {
    'health check status 200': (r) => r.status === 200,
    'health check duration < 100ms': (r) => r.timings.duration < 100,
  });

  sleep(1);

  // Test API endpoint
  const apiRes = http.get(`${BASE_URL}/api/profile`, {
    headers: {
      Authorization: `Bearer ${__ENV.AUTH_TOKEN}`,
    },
  });
  check(apiRes, {
    'API status 200': (r) => r.status === 200,
    'API duration < 200ms': (r) => r.timings.duration < 200,
  });

  sleep(1);
}
```

**Run:**

```bash
k6 run tests/performance/smoke-test.js
```

---

### 2. Load Test (Normal Traffic)

**Purpose:** Test system under normal expected load
**Users:** 100-1000
**Duration:** 10-30 minutes

**k6 Script:**

```javascript
// tests/performance/load-test.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '5m', target: 100 }, // Ramp up to 100 users
    { duration: '10m', target: 100 }, // Stay at 100 users
    { duration: '5m', target: 0 }, // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500', 'p(99)<1000'], // 95% < 500ms, 99% < 1s
    http_req_failed: ['rate<0.01'], // < 1% errors
  },
};

const BASE_URL = __ENV.API_URL || 'http://localhost:3000';
const AUTH_TOKEN = __ENV.AUTH_TOKEN;

export default function () {
  // Simulated user behavior

  // 1. Load drugs list
  let res = http.get(`${BASE_URL}/api/inventory/master-data/drugs?page=1&limit=10`, {
    headers: { Authorization: `Bearer ${AUTH_TOKEN}` },
  });
  check(res, {
    'drugs list status 200': (r) => r.status === 200,
    'drugs list has data': (r) => JSON.parse(r.body).data.length > 0,
  });
  sleep(2);

  // 2. Load single drug
  const drugId = 'some-uuid-here';
  res = http.get(`${BASE_URL}/api/inventory/master-data/drugs/${drugId}`, {
    headers: { Authorization: `Bearer ${AUTH_TOKEN}` },
  });
  check(res, {
    'drug detail status 200': (r) => r.status === 200,
  });
  sleep(3);

  // 3. Search drugs
  res = http.get(`${BASE_URL}/api/inventory/master-data/drugs?search=para`, {
    headers: { Authorization: `Bearer ${AUTH_TOKEN}` },
  });
  check(res, {
    'search status 200': (r) => r.status === 200,
  });
  sleep(2);
}
```

**Run:**

```bash
k6 run tests/performance/load-test.js \
  --env API_URL=https://staging.aegisx.com \
  --env AUTH_TOKEN=$TOKEN
```

---

### 3. Stress Test (Breaking Point)

**Purpose:** Find system limits
**Users:** Gradually increase until failure
**Duration:** 15-30 minutes

**k6 Script:**

```javascript
// tests/performance/stress-test.js
import http from 'k6/http';
import { check } from 'k6';

export const options = {
  stages: [
    { duration: '2m', target: 100 }, // Ramp to 100
    { duration: '5m', target: 100 }, // Hold 100
    { duration: '2m', target: 200 }, // Ramp to 200
    { duration: '5m', target: 200 }, // Hold 200
    { duration: '2m', target: 300 }, // Ramp to 300
    { duration: '5m', target: 300 }, // Hold 300
    { duration: '2m', target: 400 }, // Ramp to 400
    { duration: '5m', target: 400 }, // Hold 400 (likely to fail)
    { duration: '5m', target: 0 }, // Ramp down
  ],
};

const BASE_URL = __ENV.API_URL || 'http://localhost:3000';

export default function () {
  const res = http.get(`${BASE_URL}/api/inventory/master-data/drugs?page=1&limit=10`, {
    headers: { Authorization: `Bearer ${__ENV.AUTH_TOKEN}` },
  });

  check(res, {
    'status 200': (r) => r.status === 200,
  });
}
```

---

### 4. Spike Test (Sudden Traffic)

**Purpose:** Test sudden traffic spikes
**Users:** 0 → 1000 → 0 quickly
**Duration:** 5-10 minutes

**k6 Script:**

```javascript
// tests/performance/spike-test.js
import http from 'k6/http';

export const options = {
  stages: [
    { duration: '10s', target: 1000 }, // SPIKE to 1000 users
    { duration: '1m', target: 1000 }, // Hold spike
    { duration: '10s', target: 0 }, // Drop to 0
  ],
};

const BASE_URL = __ENV.API_URL || 'http://localhost:3000';

export default function () {
  http.get(`${BASE_URL}/api/inventory/master-data/drugs?page=1`);
}
```

---

## 📊 Performance Metrics

### Key Metrics to Track

**Response Time:**

- **p50 (median):** 50% of requests
- **p95:** 95% of requests
- **p99:** 99% of requests
- **max:** Slowest request

**Throughput:**

- **RPS (Requests Per Second):** Total throughput
- **Data Transferred:** Bandwidth used

**Errors:**

- **Error Rate:** % of failed requests
- **Error Types:** 4xx vs 5xx

**Resource Utilization:**

- **CPU:** % usage
- **Memory:** % usage
- **Database connections:** Active connections
- **Network:** I/O

---

## 🎯 Performance Thresholds

### API Endpoints

```javascript
// Good thresholds for REST API
thresholds: {
  http_req_duration: [
    'p(50)<100',  // 50% of requests < 100ms
    'p(95)<200',  // 95% of requests < 200ms
    'p(99)<500',  // 99% of requests < 500ms
    'max<2000',   // No request > 2s
  ],
  http_req_failed: ['rate<0.01'],  // < 1% errors
  http_reqs: ['rate>100'],  // > 100 req/s throughput
}
```

### Database Queries

```javascript
// Good thresholds for database queries
thresholds: {
  query_duration: [
    'p(95)<50',   // 95% of queries < 50ms
    'p(99)<100',  // 99% of queries < 100ms
  ],
}
```

---

## 📋 Performance Test Scenarios

### Scenario 1: User Registration Flow

```javascript
// tests/performance/scenarios/user-registration.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 50,
  duration: '5m',
};

const BASE_URL = __ENV.API_URL;

export default function () {
  // 1. Load registration page
  http.get(`${BASE_URL}/register`);
  sleep(2);

  // 2. Submit registration
  const payload = JSON.stringify({
    email: `test${__VU}@example.com`,
    password: 'password123',
    name: `Test User ${__VU}`,
  });

  const res = http.post(`${BASE_URL}/api/auth/register`, payload, {
    headers: { 'Content-Type': 'application/json' },
  });

  check(res, {
    'registration success': (r) => r.status === 201,
  });

  sleep(1);
}
```

---

### Scenario 2: Drug Search and Filter

```javascript
// tests/performance/scenarios/drug-search.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 100,
  duration: '10m',
};

const BASE_URL = __ENV.API_URL;
const AUTH_TOKEN = __ENV.AUTH_TOKEN;

export default function () {
  // Random search term
  const searchTerms = ['para', 'aspirin', 'ibupro', 'amox', 'metro'];
  const term = searchTerms[Math.floor(Math.random() * searchTerms.length)];

  // Search
  const res = http.get(`${BASE_URL}/api/inventory/master-data/drugs?search=${term}&page=1&limit=20`, {
    headers: { Authorization: `Bearer ${AUTH_TOKEN}` },
  });

  check(res, {
    'search status 200': (r) => r.status === 200,
    'search duration < 300ms': (r) => r.timings.duration < 300,
    'search has results': (r) => JSON.parse(r.body).data.length > 0,
  });

  sleep(1);
}
```

---

### Scenario 3: CRUD Operations

```javascript
// tests/performance/scenarios/crud-operations.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 50,
  duration: '10m',
};

const BASE_URL = __ENV.API_URL;
const AUTH_TOKEN = __ENV.AUTH_TOKEN;

export default function () {
  const headers = {
    'Content-Type': 'application/json',
    Authorization: `Bearer ${AUTH_TOKEN}`,
  };

  // CREATE
  const createPayload = JSON.stringify({
    code: `DRUG${__VU}_${Date.now()}`,
    name: `Test Drug ${__VU}`,
    price: 100.5,
    is_active: true,
  });

  let res = http.post(`${BASE_URL}/api/inventory/master-data/drugs`, createPayload, {
    headers,
  });

  check(res, {
    'create success': (r) => r.status === 201,
  });

  const drugId = JSON.parse(res.body).data.id;
  sleep(1);

  // READ
  res = http.get(`${BASE_URL}/api/inventory/master-data/drugs/${drugId}`, {
    headers,
  });

  check(res, {
    'read success': (r) => r.status === 200,
  });
  sleep(1);

  // UPDATE
  const updatePayload = JSON.stringify({
    price: 150.75,
  });

  res = http.put(`${BASE_URL}/api/inventory/master-data/drugs/${drugId}`, updatePayload, {
    headers,
  });

  check(res, {
    'update success': (r) => r.status === 200,
  });
  sleep(1);

  // DELETE
  res = http.del(`${BASE_URL}/api/inventory/master-data/drugs/${drugId}`, null, {
    headers,
  });

  check(res, {
    'delete success': (r) => r.status === 200,
  });
  sleep(2);
}
```

---

## 📊 Performance Report

```markdown
# Performance Test Report

**Date:** 2025-12-20 14:00:00
**Environment:** Staging
**Test Type:** Load Test
**Duration:** 20 minutes
**Virtual Users:** 100

---

## Summary

**Status:** ✅ PASS - All thresholds met

**Key Metrics:**

- Average Response Time: 145ms
- 95th Percentile: 285ms
- 99th Percentile: 450ms
- Error Rate: 0.02%
- Throughput: 250 req/s

---

## Response Times

| Metric | Target   | Actual | Status  |
| ------ | -------- | ------ | ------- |
| p50    | < 100ms  | 85ms   | ✅ PASS |
| p95    | < 200ms  | 285ms  | ⚠️ WARN |
| p99    | < 500ms  | 450ms  | ✅ PASS |
| max    | < 2000ms | 1250ms | ✅ PASS |

## Throughput

| Metric              | Target | Actual | Status  |
| ------------------- | ------ | ------ | ------- |
| Requests/sec        | > 100  | 250    | ✅ PASS |
| Data transferred    | -      | 125 MB | -       |
| Successful requests | > 99%  | 99.98% | ✅ PASS |

## Resource Utilization

| Resource       | Average | Peak    | Notes                  |
| -------------- | ------- | ------- | ---------------------- |
| CPU            | 45%     | 68%     | Acceptable             |
| Memory         | 62%     | 75%     | Acceptable             |
| DB Connections | 25      | 45      | Within limit (max 100) |
| Network I/O    | 15 Mbps | 30 Mbps | -                      |

## Bottlenecks Identified

1. **Database Query:** Drug search query taking 200ms+
   - **Recommendation:** Add index on name column
   - **Priority:** High

2. **API Response:** Some endpoints >500ms at p99
   - **Recommendation:** Implement caching
   - **Priority:** Medium

## Recommendations

### Immediate

1. Add database index: `CREATE INDEX idx_drugs_name ON inventory.drugs(name);`
2. Implement Redis caching for drug list (5 min TTL)

### Next Sprint

3. Optimize drug search query (LIKE → Full-text search)
4. Add pagination caching
5. Implement response compression

---

**Test Report By:** [Name]
**Next Test:** [Date - after optimizations]
```

---

## 🎯 Quick Scripts

### Run All Performance Tests

```bash
#!/bin/bash
# run-all-perf-tests.sh

echo "🚀 Running All Performance Tests"
echo "================================"

# 1. Smoke test
echo "1. Smoke Test..."
k6 run tests/performance/smoke-test.js

# 2. Load test
echo "2. Load Test..."
k6 run tests/performance/load-test.js

# 3. Generate report
echo ""
echo "✅ All tests complete!"
echo "Review results above"
```

### Create Baseline

```bash
#!/bin/bash
# create-baseline.sh

echo "📊 Creating Performance Baseline"
echo "================================"

k6 run tests/performance/load-test.js \
  --out json=baseline.json

echo "✅ Baseline created: baseline.json"
```

### Compare Against Baseline

```bash
#!/bin/bash
# compare-baseline.sh

echo "📊 Comparing Against Baseline"
echo "============================="

# Run current test
k6 run tests/performance/load-test.js \
  --out json=current.json

# Compare (requires custom script)
node scripts/compare-performance.js baseline.json current.json
```

---

## 🎯 Quick Reference

```bash
# Install k6
brew install k6

# Run smoke test
k6 run tests/performance/smoke-test.js

# Run load test
k6 run tests/performance/load-test.js --vus 100 --duration 10m

# Run with environment variables
k6 run tests/performance/load-test.js \
  --env API_URL=https://staging.aegisx.com \
  --env AUTH_TOKEN=$TOKEN

# Run and save results
k6 run tests/performance/load-test.js --out json=results.json

# Run with custom thresholds
k6 run tests/performance/load-test.js --threshold http_req_duration=p(95)<300
```

---

**Version**: 1.0.0
**Priority**: HIGH
**Test Duration**: Smoke 2min, Load 20min, Stress 30min
**Recommended Frequency**: Before each production deployment
