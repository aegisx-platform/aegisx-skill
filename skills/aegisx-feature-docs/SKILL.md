---
name: aegisx-feature-docs
version: 1.0.0
description: >
  AegisX feature documentation workflow using `pnpm run docs:feature` helper. Features live
  under `docs/features/{01-completed,02-active,03-planned,99-archived}/` where folder location
  equals status. Use when creating, activating, completing, archiving features, or updating the
  auto-generated feature index. Triggers on: feature docs, docs/features/, feature registry,
  new feature, activate feature, complete feature, archive feature, feature README, shipped,
  feature-index, --no-index, FEATURE_REGISTRY, docs:feature command.
---

# AegisX Feature Documentation

## Purpose

AegisX tracks features as folders (not flat files) where **folder location = feature status**. The `pnpm run docs:feature` helper automates state transitions and index regeneration.

## One Command for Everything

```bash
pnpm run docs:feature <subcommand> [args]
pnpm run docs:feature help    # show full usage
```

## Subcommands

| Command | Action |
|---|---|
| `new <slug> --domain <inventory\|platform\|core>` | Create `docs/features/03-planned/<slug>/README.md` |
| `activate <slug>` | Move 03-planned → 02-active |
| `complete <slug>` | Move 02-active → 01-completed (stamps today's date) |
| `archive <slug>` | Move 01-completed → 99-archived |
| `index` | Regenerate `docs/features/README.md` (auto-index) |

## Folder Conventions

```
docs/features/
├── 01-completed/       # Shipped features (historical record)
├── 02-active/          # In-progress features
├── 03-planned/         # Designed but not started
├── 99-archived/        # Deprecated / removed features
└── README.md           # Auto-generated index (DO NOT EDIT manually)
```

## Required Files

Only `README.md` is MANDATORY. With YAML frontmatter:

```yaml
---
status: active | completed | planned | archived
version: 1.0.0
shipped: 2026-03-15              # completed only
owner: sathit
domain: inventory | platform | core
---
```

Optional (add only when they carry weight):
- `spec.md` — detailed specification
- `api.md` — API contracts / endpoint docs
- `CHANGELOG.md` — version history

**DO NOT** require 8 files per feature. Minimal is fine.

## Worktree-Safe Workflow (CRITICAL)

Parallel feature branches can conflict on the auto-generated index. Solution:

```bash
# In a feature branch / worktree:
pnpm run docs:feature new my-feature --domain inventory --no-index

# Skip index regen to avoid merge conflicts. Run once after merge:
git checkout develop
pnpm run docs:feature index
git add docs/features/README.md && git commit -m "docs: regenerate feature index"
```

## Classification Rule (IMPORTANT)

When classifying an EXISTING feature, **trust the code, NOT the old README**:

```bash
# Search apps/ for evidence first
grep -r "drug-management" apps/

# Is it actually in production?
# Then it's completed, regardless of what README says.
```

The old `docs/FEATURE_REGISTRY.md` (deprecated) drifted badly — e.g., `drug-management` was marked "Planned" while running in production.

## Forbidden Actions

- ❌ Copy `_template/` folder manually — use `docs:feature new`
- ❌ `git mv` folders by hand when the helper works
- ❌ Hand-edit `docs/features/README.md` between `<!-- FEATURE-INDEX:START/END -->`
- ❌ Maintain `docs/FEATURE_REGISTRY.md` — redirect only, deprecated
- ❌ Require `spec.md` + `api.md` + 6 more files — only README is mandatory

## Allowed Fallback

If the helper doesn't fit (edge case):
```bash
git mv docs/features/02-active/my-feature docs/features/01-completed/
# Then manually update README frontmatter's status + shipped fields
pnpm run docs:feature index
```

## Related Skills

- **spec-validator** — validate implementation matches spec.md
- **api-contract-generator** — generate api.md from routes
- **doc-updater** (agent) — sync READMEs and feature docs

## References

- `docs/guides/documentation/feature-docs-standard.md` (full spec)
- `scripts/feature.sh` (helper source)
- `docs/features/README.md` (auto-index)
