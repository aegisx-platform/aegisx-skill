---
name: aegisx-ui-types
version: 1.0.0
description: >
  TypeScript type catalog for @aegisx/ui — type file structure, documentation standards,
  migration guide, and catalog of all public types. Use when adding new types, refactoring
  existing types, auditing type coverage, or migrating types between versions in the
  aegisx-ui library. Triggers on: aegisx-ui types, @aegisx/ui types, type catalog,
  type migration, type documentation, type structure, type audit, TS types for aegisx,
  aegisx interfaces. For component API, see aegisx-ui-library.
  For design tokens, see aegisx-ui-design.
---

# AegisX UI Type System

## Purpose

This skill covers the TypeScript type architecture of `@aegisx/ui` — how types are organized,
documented, and migrated between versions. It ensures consistency across 35+ components.

## When to Use

- Adding a new public type to `libs/aegisx-ui`
- Refactoring or splitting an existing type file
- Migrating types during a major version bump
- Auditing type coverage (are all components properly typed?)
- Reviewing type documentation standards

## References

Progressive disclosure — read only the file relevant to your task:

| Task | Reference |
|---|---|
| Find existing types | `references/type-catalog.md` |
| Write new type docs | `references/type-documentation-standards.md` |
| Understand file layout | `references/type-file-structure-audit.md` |
| Migrate types (major version) | `references/type-migration-guide.md` |

## Key Principles

1. **One domain per file** — auth types in `auth.types.ts`, not scattered across components
2. **Public API re-exported from `index.ts`** — don't deep-import internal types
3. **JSDoc required on exported types** — purpose, example, version added
4. **Breaking changes require migration guide entry** — add to `type-migration-guide.md`
5. **Prefer `interface` over `type` for object shapes** — better DX in IDEs

## Related Skills

- **aegisx-ui-library** — Component API (uses these types)
- **aegisx-ui-design** — Design tokens (colors, spacing — typed as values)
- **typebox-schema-generator** — Backend schema → frontend type pipeline
