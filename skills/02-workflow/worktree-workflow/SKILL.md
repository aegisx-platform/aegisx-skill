---
name: worktree-workflow
version: 1.0.0
description: >
  Parallel feature development using git worktrees — work on multiple features simultaneously
  without stashing. Supports 5+ concurrent worktrees with isolated dev servers, per-branch
  Claude context, and automated worktree detection. Use when starting a second feature while
  another is in progress, handling urgent hotfixes mid-feature, or coordinating parallel
  agents across branches. Triggers on: worktree, parallel dev, multiple features, hotfix,
  stash, git worktree add, isolated branch, .claude/worktree-context, aegisx-hotfix,
  aegisx-wt1, parallel branches.
---

# Git Worktree Workflow

## Purpose

Replace stashing with parallel worktrees. Work on 5 features at once, each with its own branch, node_modules, dev server, and Claude context. No more "let me stash this and switch branches" interruptions.

## When to Use Worktree

| Scenario | Worktree? |
|---|---|
| Urgent bug while feature in progress | ✅ Yes |
| Multiple features for different clients | ✅ Yes |
| Want to test develop while working on branch | ✅ Yes |
| Experimenting with refactor | ✅ Yes |
| Just switching branches briefly | ❌ No (use git switch) |
| Same branch, just need to compare file | ❌ No (just `git show`) |

## Creating a Worktree

```bash
# Pattern
git worktree add ../aegisx-<name> <branch>

# Hotfix
git worktree add ../aegisx-hotfix develop
cd ../aegisx-hotfix
git checkout -b hotfix/patient-search

# Feature
git worktree add ../aegisx-feat-ppk develop
cd ../aegisx-feat-ppk
git checkout -b feature/ppk-workflow
```

## Independent Setup per Worktree

Each worktree needs its own:

```bash
cd ../aegisx-feat-ppk
pnpm install              # separate node_modules
cp ../aegisx-starter/.env .env   # copy env (or symlink)

# Run independent dev servers on different ports if needed
PORT=3334 pnpm run dev:api
PORT=4201 pnpm run dev:web
```

## Listing / Removing Worktrees

```bash
# List all
git worktree list

# Remove when done
cd ../aegisx-starter
git worktree remove ../aegisx-hotfix

# Or: delete the folder + prune
rm -rf ../aegisx-hotfix
git worktree prune
```

## Real Example: PPK Hospital Workflow

From session memory — 5 worktrees concurrent:

```
~/aegisx-starter         (main — WT0, integration branch)
~/aegisx-wt1-smart-match (feature/smart-match)
~/aegisx-wt2-pr-workflow (feature/pr-workflow)
~/aegisx-wt3-rop-dashboard (feature/rop-dashboard)
~/aegisx-wt4-grn-stock   (feature/grn-stock)
~/aegisx-wt5-stock-pages (feature/stock-pages)
```

Each developed + tested + pushed independently. Merge order: WT1 → WT2 → WT3 → WT4 → WT5.

## Claude Context Per Worktree

`.claude/worktree-context/` holds per-branch notes that Claude auto-loads.

```
.claude/
├── worktree-context/
│   ├── feat-ppk.md           # Branch-specific context
│   ├── hotfix-patient-search.md
│   └── ...
```

Claude auto-detects which worktree it's running in and loads the matching context file.

## Parallel Claude Agents

Run independent Claude Code sessions per worktree:

```bash
# Terminal 1
cd ~/aegisx-wt1-smart-match && claude

# Terminal 2
cd ~/aegisx-wt2-pr-workflow && claude

# Both can work simultaneously — no context collision
```

## Common Pitfalls

| Pitfall | Fix |
|---|---|
| Forget `pnpm install` in new worktree | `node_modules` missing → install |
| Same port conflict | Use different PORT env |
| Docker containers shared | OK — intentional, don't split DB |
| Pre-commit hook fails in one worktree | Check husky install state |
| Database migrations applied by WT1 break WT2 | Coordinate — commit migrations early |

## Integration Back to Main

```bash
# Finish feature in worktree
cd ~/aegisx-wt1-smart-match
git push -u origin feature/smart-match

# Main repo: merge (via PR)
cd ~/aegisx-starter
gh pr create --base develop --head feature/smart-match
# ... review, merge ...

# Remove worktree after merge
git worktree remove ../aegisx-wt1-smart-match
```

## Related Skills

- **subtree-sync** — sync shared libs after merge
- **aegisx-feature-docs** — `--no-index` flag essential for worktrees
- **commit-commands** (plugin) — standard commit workflow

## References

- `docs/guides/infrastructure/git-worktree-guide.md` (full guide)
- CLAUDE.md section "Git Worktree" (quick reference)
