---
name: subtree-sync
version: 1.0.0
description: >
  Sync shared AegisX libraries (aegisx-cli, aegisx-ui, aegisx-mcp) from the main monorepo
  to their standalone GitHub repos using git subtree. Required before publishing npm
  packages or when consumers need the latest library. Use after committing lib changes in
  monorepo. Triggers on: subtree, sync-to-repo.sh, aegisx-cli, aegisx-ui, aegisx-mcp,
  publish, npm publish, shared library, git subtree split, git subtree push,
  separate repo sync, lib release.
---

# Git Subtree Sync for Shared Libs

## Purpose

AegisX shared libraries live inside the monorepo but are also published as separate GitHub repos + NPM packages. Subtree sync keeps the standalone repos in sync after changes land in the monorepo.

## Shared Libs

| Monorepo path | Standalone repo | NPM package |
|---|---|---|
| `libs/aegisx-cli` | `aegisx-platform/crud-generator` | `@aegisx/crud-generator` |
| `libs/aegisx-ui` | `aegisx-platform/aegisx-ui` | `@aegisx/ui` |
| `libs/aegisx-mcp` | `aegisx-platform/aegisx-mcp` | `@aegisx/mcp` |

## Workflow

```
┌─────────────────────────────────────┐
│ 1. Edit lib in monorepo             │
│    libs/aegisx-ui/src/...           │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ 2. Commit to monorepo FIRST         │
│    git commit -m "feat(ui): ..."    │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ 3. Run sync script                  │
│    bash libs/aegisx-ui/sync-to-repo │
│                                     │
│    Uses `git subtree split` +       │
│    `git push` to standalone repo    │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ 4. Publish to NPM                   │
│    cd libs/aegisx-ui                │
│    pnpm publish                     │
└─────────────────────────────────────┘
```

## Sync Scripts

Each lib has its own script:
- `libs/aegisx-cli/sync-to-repo.sh`
- `libs/aegisx-ui/sync-to-repo.sh`
- `libs/aegisx-mcp/sync-to-repo.sh`

Inspect script contents for exact subtree commands — they handle:
1. `git subtree split --prefix=libs/aegisx-<name>` → temp branch
2. Push temp branch → standalone repo's main
3. Push tags
4. Cleanup temp branch

## Critical Rules

### 1. Always commit to monorepo FIRST

Never edit the standalone repo directly. Standalone is a **read-only mirror**.

```
Correct flow:
monorepo (libs/aegisx-ui/) → commit → sync-to-repo.sh → standalone repo → NPM

Wrong flow:
standalone repo → edit → monorepo doesn't know → drift
```

### 2. Never force-push standalone repo

`sync-to-repo.sh` uses normal push. If conflict:
- Someone edited standalone directly (problem — see rule #1)
- Investigate, don't force-push
- Revert standalone to monorepo state

### 3. Version bump in monorepo first

```bash
# In monorepo
cd libs/aegisx-ui
pnpm version patch      # bumps package.json version
git commit -am "chore(ui): bump to 1.2.3"

# Then sync
bash sync-to-repo.sh

# Then publish
pnpm publish
```

## Subtree Setup (Initial Only)

Already done for existing libs. For new shared lib:

```bash
# 1. Create standalone GitHub repo
gh repo create aegisx-platform/new-lib --public

# 2. In monorepo, add as remote
git remote add new-lib-origin git@github.com:aegisx-platform/new-lib.git

# 3. First split + push
git subtree split --prefix=libs/new-lib -b split-new-lib
git push new-lib-origin split-new-lib:main
git branch -D split-new-lib

# 4. Create sync-to-repo.sh in libs/new-lib/
```

## Troubleshooting

| Symptom | Fix |
|---|---|
| `fatal: prefix does not exist` | Wrong path in `sync-to-repo.sh` |
| `non-fast-forward` | Someone edited standalone directly — investigate first |
| Tags missing in standalone | Add `git push --tags <remote>` to script |
| NPM publish: "file does not exist" | Run `pnpm build` in lib before publish |

## Related Skills

- **worktree-workflow** — often used together for lib dev in isolation
- **aegisx-cli-library** / **aegisx-ui-library** / **aegisx-mcp-server** — consumers of these libs

## References

- `docs/guides/infrastructure/git-subtree-guide.md`
- Each lib's `sync-to-repo.sh`
- CLAUDE.md section "Git Subtree"
