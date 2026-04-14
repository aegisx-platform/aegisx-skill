---
name: aegisx-layout-migration
version: 1.0.0
description: >
  Migrate legacy pages to unified `ax-page-shell` + `--ax-*` CSS token system. Covers
  page shell adoption, hardcoded hex → semantic token replacement, sidebar/enterprise
  layout switching, dark mode via tokens (NOT .dark class or isDarkMode input), and
  ChangeDetectionStrategy.OnPush + DestroyRef patterns. Use when migrating master-data,
  operations, or dispensing modules to the new layout system. Triggers on: ax-page-shell,
  --ax-* tokens, layout migration, unified layout, enterprise layout, sidebar layout,
  dark mode, theme-switcher, aegisx-tokens.scss, hardcoded hex, page shell adoption.
---

# AegisX Layout Migration

## Purpose

Migrate pre-unification pages (hardcoded layouts, raw hex colors, `.dark` class) to the unified layout system introduced in 2026-04-12. New pages MUST start in the unified system; legacy pages are migrated incrementally.

## The 3 Laws

1. **Layout = 1-line config change.** Never hardcode layout in shell template.
2. **Dark mode = CSS tokens only.** Never use `isDarkMode` input or `.dark` class.
3. **Colors = `var(--ax-*)`.** Never raw hex for semantic colors.

## Available Layouts (shared Common API)

```typescript
// apps/web/src/app/features/<shell>/<shell>.config.ts
layout: 'enterprise' as AxLayoutType,   // top nav
// OR
layout: 'sidebar' as AxLayoutType,      // left nav
```

Both use the same API:

```html
<ax-[enterprise|sidebar]-layout
  [appName]="'AegisX Inventory'"
  [logoUrl]="'/assets/logo.svg'"
  [navigation]="navItems"
  [showFooter]="true"
  [showSettingsMenuItem]="true"
  (profileClicked)="..."
  (settingsClicked)="..."
  (logoutClicked)="...">

  <ng-template #headerActions>
    <ax-theme-switcher />
  </ng-template>

  <ng-template #userMenu>...</ng-template>       <!-- optional -->
  <ng-template #footerContent>...</ng-template>  <!-- optional -->

  <router-outlet />
</ax-[enterprise|sidebar]-layout>
```

## Migration Checklist (per page)

```
□ Wrap page in <ax-page-shell> (header + content slots)
□ Remove custom layout templates — use shell
□ Replace hardcoded hex colors → var(--ax-*, fallback)
□ Remove .dark class usage → rely on tokens
□ Remove isDarkMode input anywhere
□ Add ChangeDetectionStrategy.OnPush to components
□ Use DestroyRef + takeUntilDestroyed (not Subject/takeUntil)
□ Add ARIA labels on nav, sidebar toggle, user menu
□ Use isPlatformBrowser guard before window/document access
□ Verify light + dark both render correctly
```

## Token Mapping (legacy → unified)

| Legacy | Unified | Use for |
|---|---|---|
| `#0f172a` | `var(--ax-bg-primary)` | Main background |
| `#1e293b` | `var(--ax-bg-secondary)` | Card / panel background |
| `#64748b` | `var(--ax-text-secondary)` | Muted text |
| `#f1f5f9` | `var(--ax-text-primary)` | Primary text |
| `#6366f1` | `var(--ax-brand)` | Brand / CTA |
| `#22c55e` | `var(--ax-success)` | Success badge |
| `#ef4444` | `var(--ax-error)` | Error badge |
| `.dark .foo` | `.foo` with `--ax-*` tokens | Dark mode |

Full token list: `libs/aegisx-ui/src/lib/styles/themes/_aegisx-tokens.scss`

## Component Template Pattern

```typescript
// ✅ CORRECT
@Component({
  selector: 'ax-drugs-browse-page',
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <ax-page-shell>
      <ax-page-header
        title="ข้อมูลยา"
        subtitle="จัดการข้อมูลยาทั้งหมด">
        <ng-template #actions>
          <button mat-flat-button color="primary">เพิ่มรายการ</button>
        </ng-template>
      </ax-page-header>

      <!-- content -->
      <mat-card>...</mat-card>
    </ax-page-shell>
  `,
})
export class DrugsBrowsePage {
  private destroyRef = inject(DestroyRef);

  ngOnInit() {
    this.service.data$
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe(...);
  }
}
```

## Anti-Patterns

```typescript
// ❌ WRONG: hardcoded layout
template: `<app-enterprise-layout>...</app-enterprise-layout>`

// ✅ CORRECT: config-driven
template: `
  @switch (config.layout) {
    @case ('enterprise') { <ax-enterprise-layout>...</ax-enterprise-layout> }
    @case ('sidebar') { <ax-sidebar-layout>...</ax-sidebar-layout> }
  }
`

// ❌ WRONG: CommonModule in layout
@Component({ imports: [CommonModule] })

// ✅ CORRECT: NgTemplateOutlet direct
@Component({ imports: [NgTemplateOutlet] })

// ❌ WRONG: isDarkMode input
<ax-card [isDarkMode]="darkMode$ | async">

// ✅ CORRECT: CSS tokens handle it
<ax-card>  <!-- tokens auto-flip -->

// ❌ WRONG: Subject + takeUntil
private destroy$ = new Subject<void>();
ngOnDestroy() { this.destroy$.next(); this.destroy$.complete(); }

// ✅ CORRECT: DestroyRef
private destroyRef = inject(DestroyRef);
```

## Migration Status (from session memory)

| Module | Status |
|---|---|
| PO / PR / vendor / contracts | ✅ DONE (2026-04-14) |
| master-data (drugs, budgets, locations) | 🚧 IN PROGRESS |
| operations (allocations, transactions) | 📋 TODO |
| dispensing | 📋 TODO |

Track progress: memory `project_layout_migration_checklist.md`

## Related Skills

- **aegisx-ui-design** — full design system reference
- **aegisx-ui-library** — `<ax-*>` component API
- **aegisx-common-patterns** — button spinner, FK dropdown rules also apply
- **untitled-ui-ref** → merged into aegisx-ui-design

## References

- Spec: `docs/superpowers/specs/2026-04-12-unified-layout-system-design.md`
- Spec: `docs/superpowers/specs/2026-04-14-layout-migration-master-data.md`
- Feature doc: `docs/features/01-completed/unified-layout-system/`
- Tokens: `libs/aegisx-ui/src/lib/styles/themes/_aegisx-tokens.scss`
