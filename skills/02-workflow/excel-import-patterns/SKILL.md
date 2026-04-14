---
name: excel-import-patterns
version: 1.0.0
description: >
  Patterns for Excel/CSV import in AegisX — used extensively in PR/PO workflow, Migration
  Wizard, and bulk master-data seeding. Covers file parsing (xlsx), validation (TypeBox +
  row-level errors), chunked upload, progress reporting, error rollback, and downloadable
  error reports. Use when implementing any bulk import feature. Triggers on: Excel import,
  CSV import, xlsx, bulk import, import wizard, Migration Wizard, PR import, bulk upload,
  row validation, error report, chunked upload, streaming upload, import progress.
---

# Excel/CSV Import Patterns

## Purpose

Consistent approach to bulk imports across AegisX — PR items, drug master, inventory transactions, legacy hospital data (Migration Wizard). Avoid re-inventing validation/error-reporting every time.

## Standard Flow (5 phases)

```
Phase 1: Upload & Parse
  ↓ File upload (multer) → Parse with xlsx → Array<RowData>

Phase 2: Schema Validation (per row)
  ↓ TypeBox schema check → Collect { row: N, errors: [...] }

Phase 3: Business Validation (per row)
  ↓ FK existence, uniqueness, date ranges → More row errors

Phase 4: Commit or Report
  ↓ If all valid → Batch insert in chunks
  ↓ If any invalid → Return error report (downloadable Excel)

Phase 5: Progress & Rollback
  ↓ WebSocket progress events
  ↓ On error: DB transaction ROLLBACK, log to import_history
```

## Backend (Fastify Route)

```typescript
// apps/api/src/.../import.route.ts
fastify.post('/import', {
  preHandler: [authenticate, authorize('inventory-admin')],
  schema: {
    consumes: ['multipart/form-data'],
    response: { 200: ImportResultSchema }
  }
}, async (req, reply) => {
  const file = await req.file();
  const rows = parseExcel(await file.toBuffer());

  const errors: RowError[] = [];
  const validRows: ValidRow[] = [];

  for (const [index, row] of rows.entries()) {
    // Phase 2: Schema
    const parsed = SchemaCheck(RowSchema, row);
    if (!parsed.success) {
      errors.push({ row: index + 2, errors: parsed.errors });
      continue;
    }

    // Phase 3: Business rules
    const businessErrors = await validateRow(parsed.data, fastify);
    if (businessErrors.length) {
      errors.push({ row: index + 2, errors: businessErrors });
      continue;
    }
    validRows.push(parsed.data);
  }

  if (errors.length) {
    const reportUrl = await uploadErrorReport(errors);
    return { success: false, errors, reportUrl, validCount: validRows.length };
  }

  // Phase 4: Commit in chunks within transaction
  await fastify.knex.transaction(async (trx) => {
    for (const chunk of chunkArray(validRows, 500)) {
      await trx(TABLE).insert(chunk);
      fastify.ws.broadcast('import:progress', { done: chunk.length });
    }
  });

  return { success: true, imported: validRows.length };
});
```

## Frontend (Angular Import Wizard)

```typescript
@Component({ ... })
export class ImportWizardComponent {
  step = signal<1 | 2 | 3>(1);  // upload → preview → commit
  errors = signal<RowError[]>([]);
  progress = signal(0);

  async uploadFile(file: File) {
    const form = new FormData();
    form.append('file', file);

    this.http.post<ImportResult>('/api/drugs/import', form).subscribe({
      next: (res) => {
        if (!res.success) {
          this.errors.set(res.errors);
          this.step.set(2);
        } else {
          this.step.set(3);
        }
      }
    });

    // Subscribe to WebSocket progress
    this.ws.on('import:progress').subscribe(ev => {
      this.progress.update(p => p + ev.done);
    });
  }
}
```

## Error Row Format (standard)

```typescript
interface RowError {
  row: number;         // 1-indexed, 1 = header, 2 = first data row
  errors: {
    field: string;     // e.g., "quantity"
    value: any;        // the bad value
    message: string;   // human-readable, Thai OK
  }[];
}

// Example response:
{
  success: false,
  totalRows: 100,
  validCount: 87,
  errors: [
    {
      row: 15,
      errors: [
        { field: "tmt_code", value: "TMT999", message: "ไม่พบรหัส TMT ในระบบ" },
        { field: "quantity", value: -5, message: "จำนวนต้องเป็นบวก" }
      ]
    }
  ],
  reportUrl: "/api/imports/report/abc123.xlsx"
}
```

## Error Report File

Generate downloadable Excel with original data + error column:

```typescript
import * as XLSX from 'xlsx';

function generateErrorReport(errors: RowError[]): Buffer {
  const sheet = XLSX.utils.json_to_sheet(
    errors.map(e => ({
      'แถว': e.row,
      'Field': e.errors[0].field,
      'ค่า': e.errors[0].value,
      'ข้อผิดพลาด': e.errors.map(x => x.message).join('; '),
    }))
  );
  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, sheet, 'Errors');
  return XLSX.write(wb, { type: 'buffer', bookType: 'xlsx' });
}
```

## Chunk Size Tuning

| Record size | Chunk size | Why |
|---|---|---|
| Small (PR items) | 1000 rows | Fits single INSERT query |
| Medium (drugs with TMT) | 500 rows | TMT lookup cost |
| Large (transactions with history) | 100 rows | Trigger processing |

## Rollback Strategy

- **Always wrap Phase 4 in transaction** — partial imports are the #1 bug source
- Log every import attempt to `import_history` table (success + failed)
- For large imports (>10k rows): offer "rollback" within 24h via history record

## Migration Wizard Specific

Migration Wizard has 3 phases (not 5) because it imports across many tables:
1. Parse + validate ALL sheets
2. Dry-run commit to staging schema
3. User approves → swap staging → main
4. 72h rollback window before staging cleanup

See `docs/features/01-completed/migration-wizard/`.

## Related Skills

- **typebox-schema-generator** — generate RowSchema from table definition
- **fastify-error-debugger** — debug serialization failures in error responses
- **websocket-events** — progress event patterns
- **aegisx-common-patterns** — stats card patterns apply to import summary

## References

- `libs/aegisx-cli/templates/import-route.hbs` (CLI template)
- `apps/api/src/shared/utils/excel-parser.ts`
- PR #66 (Migration Wizard)
