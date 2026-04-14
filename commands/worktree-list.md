# Worktree List Command

List all active git worktrees with their status and provide quick navigation commands.

## Purpose

- Show all worktrees in this repository
- Display branch, path, and last commit
- Detect which worktree you're currently in
- Provide quick cd commands for navigation

## When to Use

- Starting a work session (to see available worktrees)
- Before creating new worktree (check if already exists)
- Switching between features
- Cleaning up old worktrees

## Instructions

### 1. Run git worktree list

```bash
git worktree list
```

### 2. Parse and enhance output

For each worktree, show:

- Path (absolute)
- Branch name
- Status (current, clean, dirty)
- Last commit message (first line)
- Quick cd command

### 3. Detect current worktree

```bash
WORKTREE_PATH=$(git rev-parse --git-common-dir 2>/dev/null)
if [ -f "$WORKTREE_PATH/commondir" ]; then
  echo "🌳 Current worktree: $(git branch --show-current)"
else
  echo "📂 Main repository"
fi
```

### 4. Check for context files

For each worktree, check if context file exists:

```bash
BRANCH=$(git branch --show-current)
CONTEXT_FILE=".claude/worktree-context/${BRANCH}.md"

if [ -f "$CONTEXT_FILE" ]; then
  echo "📖 Has context file"
else
  echo "⚠️  No context file (create one!)"
fi
```

### 5. Display formatted output

```
🌳 Git Worktrees (3 active)

1. 📂 Main Repository (Current)
   Path: /Users/sathitseethaphon/projects/aegisx-platform/aegisx-starter-1
   Branch: develop
   Commit: abc123 feat(auth): add JWT refresh
   Status: Clean
   Context: ✅ Has context

2. 🌿 Feature Worktree
   Path: /Users/sathitseethaphon/projects/aegisx-drg
   Branch: feature/drg-grouper
   Commit: def456 feat(drg): implement ICD-10 mapping
   Status: Dirty (3 uncommitted files)
   Context: ✅ Has context
   👉 cd /Users/sathitseethaphon/projects/aegisx-drg

3. 🐛 Bugfix Worktree
   Path: /Users/sathitseethaphon/projects/aegisx-fix-patients
   Branch: fix/patient-search
   Commit: ghi789 fix(patients): correct search query
   Status: Clean
   Context: ⚠️  Missing context file
   👉 cd /Users/sathitseethaphon/projects/aegisx-fix-patients

Quick Actions:
- Create new worktree: git worktree add ../aegisx-<name> <branch>
- Remove worktree: git worktree remove <path>
- Prune deleted: git worktree prune
```

### 6. Suggest cleanup if needed

```bash
# Check for gone worktrees (directory deleted but not removed)
git worktree list | grep "prunable"

if [ $? -eq 0 ]; then
  echo ""
  echo "⚠️  Found prunable worktrees!"
  echo "Run: git worktree prune"
fi
```

## Example Output

```
🌳 Git Worktrees (2 active)

📂 Main Repository (Current)
├─ Path: ~/projects/aegisx-starter-1
├─ Branch: develop
├─ Commit: f564810 feat(ai-learning): add learned patterns
├─ Status: Clean ✅
└─ Context: ✅ .claude/worktree-context/develop.md

🌿 Feature: DRG Grouper
├─ Path: ~/projects/aegisx-drg
├─ Branch: feature/drg-grouper
├─ Commit: abc1234 wip: ICD-10 mapping in progress
├─ Status: Dirty ⚠️ (5 files changed)
├─ Context: ✅ .claude/worktree-context/feature-drg-grouper.md
└─ 👉 cd ~/projects/aegisx-drg

Actions:
  Create: git worktree add ../aegisx-<name> <branch>
  Remove: git worktree remove ~/projects/aegisx-drg
  Prune:  git worktree prune
```

## Usage

Simply say:

- "List worktrees"
- "Show worktrees"
- "What worktrees do I have?"

Or use slash command pattern:

- `/worktrees`
- `/wt`

## Implementation Notes

- Use `git worktree list --porcelain` for machine-readable output
- Parse branch from worktree path or git command
- Check dirty status with `git status --porcelain`
- Suggest creating context file if missing
- Highlight current worktree (where Claude is running)

## Error Handling

### Not a git repository

```
❌ Error: Not a git repository
Current directory: /some/path
```

### No worktrees

```
📂 Only main repository exists

Create first worktree:
git worktree add ../aegisx-feature-name feature/feature-name
```

## Related Commands

- `/resume` - Resume work in current worktree
- `/diary` - Save session notes (worktree-specific)
- Create context file if missing:
  ```bash
  cp .claude/worktree-context/TEMPLATE.md \
     .claude/worktree-context/$(git branch --show-current).md
  ```

---

**Auto-run:** When Claude detects new session in worktree
**Purpose:** Quick orientation + context loading
**Output:** Formatted list + navigation commands
