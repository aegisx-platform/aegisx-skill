---
name: monitor-health
description: Monitor application health, metrics, and system status. Use to check service health, view metrics, investigate performance issues, or verify deployments.
allowed-tools: Bash, Read
---

# Monitor Health Skill

> **📊 Application health monitoring and metrics**
>
> **Real-time health checks and system metrics**

---

## 🎯 Purpose

**Problem:**

- No visibility into production health
- Unknown when services are down
- Can't diagnose performance issues
- No metrics tracking

**Solution:**

- Real-time health monitoring
- Metrics collection and visualization
- Automated alerting
- Performance tracking

---

## 📋 When to Use

**Use this skill for:**

- ✅ Post-deployment verification
- ✅ Investigating performance issues
- ✅ Checking service status
- ✅ Debugging production issues
- ✅ Capacity planning

**Frequency:**

- After every deployment
- During incidents
- Regular health checks (hourly/daily)
- Before major changes

---

## 🚀 Usage

```bash
User: /monitor-health status          # Overall system status
User: /monitor-health api              # API health check
User: /monitor-health database         # Database health
User: /monitor-health metrics          # System metrics
User: /monitor-health logs             # Recent error logs
User: /monitor-health alerts           # Active alerts
```

---

## 🏥 Health Check Endpoints

### 1. Basic Health Check

**Endpoint:** `GET /health`

**Purpose:** Quick liveness check

**Response:**

```json
{
  "status": "ok",
  "timestamp": "2025-12-20T10:00:00.000Z",
  "uptime": 123.45
}
```

**Implementation:**

```typescript
// apps/api/src/health.route.ts
export async function healthRoutes(fastify: FastifyInstance) {
  fastify.get('/health', async (request, reply) => {
    return reply.send({
      status: 'ok',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
    });
  });
}
```

---

### 2. Detailed Health Check

**Endpoint:** `GET /health/detailed`

**Purpose:** Comprehensive system status

**Response:**

```json
{
  "status": "healthy",
  "timestamp": "2025-12-20T10:00:00.000Z",
  "uptime": 123.45,
  "version": "1.0.0",
  "services": {
    "database": {
      "status": "healthy",
      "responseTime": 5,
      "connections": 25
    },
    "redis": {
      "status": "healthy",
      "responseTime": 2,
      "memory": "45MB"
    }
  },
  "metrics": {
    "cpu": 45.2,
    "memory": 62.5,
    "requests": {
      "total": 1234567,
      "last_minute": 250
    }
  }
}
```

**Implementation:**

```typescript
// apps/api/src/health.route.ts
export async function detailedHealthRoutes(fastify: FastifyInstance) {
  fastify.get('/health/detailed', async (request, reply) => {
    const dbHealth = await checkDatabaseHealth(fastify.knex);
    const redisHealth = await checkRedisHealth();
    const metrics = await getSystemMetrics();

    return reply.send({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      version: process.env.npm_package_version,
      services: {
        database: dbHealth,
        redis: redisHealth,
      },
      metrics,
    });
  });
}

async function checkDatabaseHealth(knex: Knex) {
  const start = Date.now();
  try {
    await knex.raw('SELECT 1');
    const responseTime = Date.now() - start;

    const poolStats = await knex.client.pool;

    return {
      status: 'healthy',
      responseTime,
      connections: {
        used: poolStats.numUsed(),
        free: poolStats.numFree(),
        pending: poolStats.numPendingAcquires(),
      },
    };
  } catch (error) {
    return {
      status: 'unhealthy',
      error: error.message,
    };
  }
}

async function getSystemMetrics() {
  const cpuUsage = process.cpuUsage();
  const memUsage = process.memoryUsage();

  return {
    cpu: (cpuUsage.user + cpuUsage.system) / 1000000, // Convert to seconds
    memory: {
      rss: Math.round(memUsage.rss / 1024 / 1024), // MB
      heapUsed: Math.round(memUsage.heapUsed / 1024 / 1024), // MB
      heapTotal: Math.round(memUsage.heapTotal / 1024 / 1024), // MB
    },
  };
}
```

---

## 📊 Health Check Scripts

### Quick Health Check

```bash
#!/bin/bash
# quick-health-check.sh

echo "🏥 Quick Health Check"
echo "===================="
echo ""

# API health
echo "1. API Health:"
curl -s http://localhost:3000/health | jq '.'

# Database connectivity
echo ""
echo "2. Database:"
docker exec aegisx-db psql -U postgres -c "SELECT 1;" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "   ✅ Database is accessible"
else
    echo "   ❌ Database connection failed"
fi

# Service status
echo ""
echo "3. Docker Services:"
docker-compose ps

# Disk space
echo ""
echo "4. Disk Space:"
df -h | grep -E '(Filesystem|/$)'

echo ""
echo "===================="
echo "Health check complete"
```

---

### Detailed System Status

```bash
#!/bin/bash
# detailed-system-status.sh

echo "📊 Detailed System Status"
echo "========================"
echo ""

# 1. API Health
echo "1. API Health Check:"
HEALTH=$(curl -s http://localhost:3000/health/detailed)
echo "$HEALTH" | jq '.'

# 2. Database Statistics
echo ""
echo "2. Database Statistics:"
docker exec aegisx-db psql -U postgres aegisx <<EOF
SELECT
    'Active Connections' as metric,
    COUNT(*) as value
FROM pg_stat_activity
WHERE datname = 'aegisx'
UNION ALL
SELECT
    'Database Size',
    pg_size_pretty(pg_database_size('aegisx'))
UNION ALL
SELECT
    'Total Tables',
    COUNT(*)::text
FROM information_schema.tables
WHERE table_schema NOT IN ('pg_catalog', 'information_schema');
EOF

# 3. CPU & Memory
echo ""
echo "3. System Resources:"
echo "CPU Usage:"
top -bn1 | grep "Cpu(s)" | awk '{print "   " $2 " user, " $4 " system"}'
echo "Memory Usage:"
free -h | grep Mem | awk '{print "   " $3 " used / " $2 " total (" $3/$2*100 "%)"}'

# 4. Docker Stats
echo ""
echo "4. Docker Container Stats:"
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# 5. Disk I/O
echo ""
echo "5. Disk I/O:"
iostat -x 1 2 | grep -A 5 "Device"

# 6. Network
echo ""
echo "6. Network Connections:"
echo "Active connections:"
netstat -an | grep ESTABLISHED | wc -l
echo "   ESTABLISHED connections"

# 7. Recent Logs
echo ""
echo "7. Recent Error Logs (last 10):"
docker-compose logs --tail=10 api | grep ERROR

echo ""
echo "========================"
echo "Status check complete"
```

---

## 📈 Metrics Collection

### Application Metrics

```typescript
// apps/api/src/metrics/metrics.service.ts
export class MetricsService {
  private metrics = {
    requests: {
      total: 0,
      success: 0,
      error: 0,
    },
    responseTime: [] as number[],
    endpoints: new Map<string, number>(),
  };

  recordRequest(endpoint: string, duration: number, success: boolean) {
    this.metrics.requests.total++;
    if (success) {
      this.metrics.requests.success++;
    } else {
      this.metrics.requests.error++;
    }

    this.metrics.responseTime.push(duration);
    this.metrics.endpoints.set(endpoint, (this.metrics.endpoints.get(endpoint) || 0) + 1);
  }

  getMetrics() {
    const responseTimes = this.metrics.responseTime.sort((a, b) => a - b);
    const p50 = responseTimes[Math.floor(responseTimes.length * 0.5)];
    const p95 = responseTimes[Math.floor(responseTimes.length * 0.95)];
    const p99 = responseTimes[Math.floor(responseTimes.length * 0.99)];

    return {
      requests: this.metrics.requests,
      responseTime: {
        p50,
        p95,
        p99,
        avg: responseTimes.reduce((a, b) => a + b, 0) / responseTimes.length,
      },
      topEndpoints: Array.from(this.metrics.endpoints.entries())
        .sort((a, b) => b[1] - a[1])
        .slice(0, 10),
    };
  }
}
```

### Metrics Endpoint

```typescript
// apps/api/src/routes/metrics.route.ts
export async function metricsRoutes(fastify: FastifyInstance) {
  fastify.get('/metrics', async (request, reply) => {
    const metrics = metricsService.getMetrics();

    return reply.send({
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      metrics,
    });
  });
}
```

---

## 🔔 Alerting

### Health Check with Alerts

```bash
#!/bin/bash
# health-check-with-alerts.sh

# Configuration
SLACK_WEBHOOK="your-slack-webhook-url"
EMAIL="admin@aegisx.com"

# Health check
HEALTH_STATUS=$(curl -s http://localhost:3000/health)
STATUS=$(echo $HEALTH_STATUS | jq -r '.status')

if [ "$STATUS" != "ok" ]; then
    # Send Slack alert
    curl -X POST $SLACK_WEBHOOK \
        -H 'Content-Type: application/json' \
        -d "{\"text\": \"🚨 ALERT: API health check failed! Status: $STATUS\"}"

    # Send email
    echo "API health check failed" | mail -s "AegisX Health Alert" $EMAIL

    echo "❌ Health check failed - alerts sent"
    exit 1
else
    echo "✅ Health check passed"
fi
```

---

## 📊 Monitoring Dashboard

### Simple Text Dashboard

```bash
#!/bin/bash
# monitoring-dashboard.sh

while true; do
    clear
    echo "========================================"
    echo "   AegisX Monitoring Dashboard"
    echo "========================================"
    echo "Last Updated: $(date)"
    echo ""

    # API Status
    echo "🌐 API Status:"
    API_HEALTH=$(curl -s http://localhost:3000/health 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "   ✅ API is UP"
        echo "   Uptime: $(echo $API_HEALTH | jq -r '.uptime') seconds"
    else
        echo "   ❌ API is DOWN"
    fi

    # Database Status
    echo ""
    echo "🗄️  Database Status:"
    docker exec aegisx-db psql -U postgres -c "SELECT 1;" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "   ✅ Database is UP"
        CONN_COUNT=$(docker exec aegisx-db psql -U postgres aegisx -t -c "SELECT COUNT(*) FROM pg_stat_activity WHERE datname='aegisx';")
        echo "   Active connections: $CONN_COUNT"
    else
        echo "   ❌ Database is DOWN"
    fi

    # System Resources
    echo ""
    echo "💻 System Resources:"
    echo "   CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}') user"
    echo "   Memory: $(free -h | grep Mem | awk '{print $3 " / " $2}')"
    echo "   Disk: $(df -h / | tail -1 | awk '{print $3 " / " $2 " (" $5 " used)"}')"

    # Docker Containers
    echo ""
    echo "🐳 Docker Containers:"
    docker-compose ps | tail -n +3 | awk '{print "   " $1 ": " $3}'

    # Recent Errors
    echo ""
    echo "⚠️  Recent Errors (last 5 min):"
    ERROR_COUNT=$(docker-compose logs --since=5m api 2>/dev/null | grep ERROR | wc -l)
    echo "   Error count: $ERROR_COUNT"

    echo ""
    echo "========================================"
    echo "Refreshing in 10 seconds... (Ctrl+C to exit)"
    sleep 10
done
```

---

## 🎯 Monitoring Checklist

```markdown
# Production Monitoring Checklist

## Application Health

- [ ] API responding (< 2s response time)
- [ ] All endpoints accessible
- [ ] No 5xx errors (last hour)
- [ ] Error rate < 1%

## Database

- [ ] Database accessible
- [ ] Connection pool healthy (< 80% used)
- [ ] Query performance acceptable (p95 < 100ms)
- [ ] Disk space > 20% free

## System Resources

- [ ] CPU usage < 80%
- [ ] Memory usage < 85%
- [ ] Disk space > 20% free
- [ ] Network latency < 100ms

## Services

- [ ] All Docker containers running
- [ ] Redis accessible (if used)
- [ ] Background jobs processing
- [ ] Email service working

## Security

- [ ] No failed login attempts spike
- [ ] SSL certificate valid (> 7 days)
- [ ] No suspicious network activity
- [ ] Firewall rules active

## Backups

- [ ] Latest backup < 24 hours old
- [ ] Backup size reasonable
- [ ] Backup integrity verified
- [ ] Remote backup successful

---

**Checked By:** [Name]
**Date:** [YYYY-MM-DD HH:MM]
**Status:** ✅ All Good / ⚠️ Issues Found
```

---

## 🚨 Incident Response

### When Health Check Fails

```bash
#!/bin/bash
# incident-response.sh

echo "🚨 Health Check Failed - Starting Incident Response"
echo "================================================="
echo ""

# 1. Gather information
echo "Step 1: Gathering system information..."

# API logs
echo "API Logs (last 100 lines):" > /tmp/incident-logs.txt
docker-compose logs --tail=100 api >> /tmp/incident-logs.txt

# Database logs
echo "Database Logs:" >> /tmp/incident-logs.txt
docker-compose logs --tail=100 db >> /tmp/incident-logs.txt

# System stats
echo "System Stats:" >> /tmp/incident-logs.txt
top -bn1 >> /tmp/incident-logs.txt
free -h >> /tmp/incident-logs.txt
df -h >> /tmp/incident-logs.txt

# 2. Attempt automatic recovery
echo ""
echo "Step 2: Attempting automatic recovery..."

# Restart API service
echo "Restarting API service..."
docker-compose restart api

# Wait and check
sleep 10
curl -s http://localhost:3000/health > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Recovery successful!"
    echo "Incident auto-resolved at $(date)" >> /tmp/incident-logs.txt
else
    echo "❌ Auto-recovery failed"
    echo "Manual intervention required!"

    # Notify team
    echo "Step 3: Notifying team..."
    # Send alerts

    # Create incident report
    cp /tmp/incident-logs.txt "/var/log/incidents/incident_$(date +%Y%m%d_%H%M%S).txt"
fi
```

---

## 📊 Metrics to Monitor

### Application Metrics

- **Request Rate:** Requests per second
- **Response Time:** p50, p95, p99
- **Error Rate:** % of failed requests
- **Throughput:** Data transferred
- **Active Users:** Concurrent users

### Database Metrics

- **Query Performance:** Query duration
- **Connection Pool:** Used/free connections
- **Database Size:** Growth rate
- **Slow Queries:** Queries > 1s
- **Deadlocks:** Deadlock count

### System Metrics

- **CPU Usage:** % utilization
- **Memory Usage:** % utilization
- **Disk Usage:** % utilization
- **Network I/O:** In/out traffic
- **Disk I/O:** Read/write operations

---

## 🎯 Quick Reference

```bash
# Quick health check
curl http://localhost:3000/health

# Detailed health
curl http://localhost:3000/health/detailed | jq '.'

# Database check
docker exec aegisx-db psql -U postgres -c "SELECT 1;"

# System resources
top -bn1 | head -10
free -h
df -h

# Docker stats
docker stats --no-stream

# Recent errors
docker-compose logs --tail=50 api | grep ERROR

# Active connections
docker exec aegisx-db psql -U postgres aegisx -c "SELECT COUNT(*) FROM pg_stat_activity;"
```

---

**Version**: 1.0.0
**Priority**: HIGH
**Frequency**: Continuous monitoring + manual checks after deployments
**Alert Response Time**: < 5 minutes
