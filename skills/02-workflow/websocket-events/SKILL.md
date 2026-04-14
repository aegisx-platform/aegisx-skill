---
name: websocket-events
version: 1.0.0
description: >
  WebSocket event patterns for AegisX CRUD modules using `--with-events` flag. Covers
  event naming, payload schemas, room/channel strategy (per-module, per-user, broadcast),
  reconnection, and frontend subscription patterns. Use when generating CRUD with events,
  adding real-time updates to existing modules, or debugging WebSocket disconnects.
  Triggers on: WebSocket, WS, real-time, live updates, --with-events, event broadcast,
  ws:subscribe, fastify-websocket, socket, room, channel, reconnect, ping-pong.
---

# WebSocket Events

## Purpose

Real-time notifications when CRUD data changes — list pages update without refresh, multiple users see each other's edits, import progress streams. Enabled by `aegisx-cli generate TABLE --with-events`.

## When to Use --with-events

| Scenario | Use? |
|---|---|
| Collaborative editing (multiple users same record) | ✅ Yes |
| Live dashboard (stats update on CRUD) | ✅ Yes |
| Import progress | ✅ Yes |
| Notifications (new PR approved) | ✅ Yes |
| Simple master-data (rarely changes) | ❌ No |
| Read-only reports | ❌ No |

## Standard Event Names

Generated CRUD emits these events:

```
<module>:created         { id, data, userId, timestamp }
<module>:updated         { id, data, userId, timestamp, previousData? }
<module>:deleted         { id, userId, timestamp }
<module>:bulk-updated    { ids[], data, userId, timestamp }
```

Examples:
- `drugs:created`
- `purchase-requests:updated`
- `budget-allocations:deleted`

## Custom Events

For domain-specific events (workflow transitions, approvals):

```typescript
// Backend
fastify.ws.broadcast('purchase-requests:submitted', {
  id: pr.id,
  submittedBy: user.id,
  timestamp: new Date().toISOString(),
});

fastify.ws.broadcast('import:progress', {
  jobId: 'abc123',
  done: 500,
  total: 10000,
});
```

## Backend Emit Pattern

```typescript
// In service after successful mutation
async createDrug(data: CreateDrugDto, userId: string) {
  const drug = await this.repo.create(data);

  // Emit after commit
  this.fastify.ws.broadcast('drugs:created', {
    id: drug.id,
    data: drug,
    userId,
    timestamp: new Date().toISOString(),
  });

  return drug;
}
```

**CRITICAL:** Emit AFTER database commit, never inside the transaction.

## Frontend Subscribe Pattern

```typescript
@Injectable({ providedIn: 'root' })
export class DrugsWsService {
  private ws = inject(WebSocketService);
  private destroyRef = inject(DestroyRef);

  created$ = this.ws.on<DrugCreatedEvent>('drugs:created');
  updated$ = this.ws.on<DrugUpdatedEvent>('drugs:updated');
  deleted$ = this.ws.on<DrugDeletedEvent>('drugs:deleted');
}

// In list component
export class DrugsListComponent {
  constructor() {
    merge(
      this.wsService.created$,
      this.wsService.updated$,
      this.wsService.deleted$,
    )
    .pipe(takeUntilDestroyed(this.destroyRef))
    .subscribe(() => this.reload());
  }
}
```

## Room / Channel Strategy

### Broadcast (all authenticated users)
```typescript
fastify.ws.broadcast('drugs:created', payload);
```
Use for: master-data changes visible to all.

### Per-user (targeted)
```typescript
fastify.ws.toUser(userId, 'notifications:new', payload);
```
Use for: personal notifications, private mentions.

### Per-module room
```typescript
// Client joins: ws.join('purchase-request:12345')
fastify.ws.toRoom('purchase-request:12345', 'pr:comment-added', payload);
```
Use for: collaborative editing on specific record.

## Reconnection

Generated client auto-reconnects with exponential backoff:

```typescript
// Client (aegisx-ui provides this)
WebSocketService {
  private reconnectDelay = 1000;  // 1s, 2s, 4s, 8s, max 30s

  onDisconnect() {
    setTimeout(() => this.connect(), this.reconnectDelay);
    this.reconnectDelay = Math.min(this.reconnectDelay * 2, 30000);
  }
}
```

## Ping/Pong Heartbeat

Server sends ping every 30s. Client must respond within 10s or disconnect:

```typescript
// Configured in apps/api/src/core/websocket/
fastify.ws.heartbeatInterval = 30_000;
fastify.ws.heartbeatTimeout = 10_000;
```

## Debugging

| Symptom | Fix |
|---|---|
| Events not received on client | Check `fastify.ws.broadcast` is called AFTER commit |
| "connection closed" loops | Check JWT expiry — WS uses JWT auth |
| Missed events during reconnect | Server doesn't queue — client must refetch state on reconnect |
| CORS error | Add WS origin to Fastify config |
| Event fires twice | Duplicate subscribe — check `takeUntilDestroyed` |

## Performance

- **Broadcast cost** = O(N connected clients)
- For high-frequency events (>10/sec), batch:
  ```typescript
  // Instead of 10 events/sec:
  fastify.ws.broadcast('stock:changed', { items: [...] });  // Once per sec
  ```
- For user-specific + >1k users: use `toRoom` not `broadcast`

## Security

- All WS connections authenticated via JWT (same token as REST)
- Authorization enforced per event type:
  ```typescript
  fastify.ws.on('admin:action', { roles: ['inventory-admin'] }, handler);
  ```
- Never emit sensitive data in broadcast — use `toUser` instead

## Related Skills

- **aegisx-auth-rbac** — WS auth uses same JWT
- **aegisx-cli-library** — `--with-events` flag generates boilerplate
- **excel-import-patterns** — uses `import:progress` events
- **aegisx-common-patterns** — reload trigger pattern for list pages

## References

- `apps/api/src/core/websocket/` (server implementation)
- `libs/aegisx-ui/src/lib/services/websocket.service.ts` (client)
- `libs/aegisx-cli/templates/ws-events.hbs` (generator template)
