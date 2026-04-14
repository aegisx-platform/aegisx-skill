# Contributing to aegisx-skill

## Adding a New Skill

### 1. Choose the right tier

| Tier | When to use |
|---|---|
| `01-aegisx-core/` | AegisX-specific, references AegisX code paths, libraries, or CLI |
| `02-workflow/` | General dev workflow tuned for AegisX (testing, QA, security) |
| `03-curated/` | Adapted from an external source (must add attribution) |
| `04-meta/` | Skills about managing skills or Claude Code itself |

### 2. Scaffold the skill

```bash
./scripts/add-skill.sh 01-aegisx-core my-new-skill
```

This creates:
```
skills/01-aegisx-core/my-new-skill/
└── SKILL.md
```

### 3. Write SKILL.md

Frontmatter required:

```yaml
---
name: my-new-skill
description: >
  One-sentence description that tells Claude WHEN to use this skill.
  List trigger keywords/phrases clearly. Keep under 500 characters.
version: 1.0.0
---
```

Body structure:

```markdown
# Skill Title

## Purpose
What problem this solves in 1-2 sentences.

## When to Use
- User says "X"
- User does Y
- Task involves Z

## Instructions for Claude
Step-by-step or principle-based guidance.

## Examples
Real examples from the codebase.

## References (if complex)
- See `references/foo.md` for detail on X
- See `references/bar.md` for detail on Y
```

### 4. Progressive disclosure for large skills

If your skill needs more than ~300 lines, use `references/`:

```
my-skill/
├── SKILL.md              # Short index + when-to-use
└── references/
    ├── topic-a.md
    ├── topic-b.md
    └── topic-c.md
```

Instruct Claude in SKILL.md: *"Read `references/topic-a.md` when user asks about A."*

### 5. Validate

```bash
./scripts/validate.sh
```

Checks:
- SKILL.md frontmatter is valid YAML
- Required fields present (`name`, `description`)
- `name` matches folder name
- No duplicate names across tiers

### 6. Commit

```
feat(skills/01-aegisx-core): add my-new-skill for X
```

---

## Editing Existing Skills

1. Bump version in frontmatter (`version: 1.0.0` → `1.1.0`)
2. Add entry to CHANGELOG.md
3. If adapted from ECC or other source, keep attribution in frontmatter:
   ```yaml
   source: ECC/everything-claude-code v1.9.0
   adapted: 2026-04-15
   modified: 2026-05-01
   ```

---

## Syncing aegisx-ui Docs

When `libs/aegisx-ui/docs/` changes in the main `aegisx-starter` repo, sync into this repo:

```bash
./scripts/sync-ui-docs.sh /path/to/aegisx-starter
git add skills/01-aegisx-core/aegisx-ui-library/references/
git commit -m "sync: aegisx-ui docs @ <short-sha>"
```

---

## Syncing from ECC

When ECC releases a new version with improvements to curated skills:

```bash
./scripts/sync-ecc.sh
# Review diff, resolve conflicts
git add skills/03-curated/
git commit -m "sync: ECC curated skills to v<version>"
```

---

## Style

- **Thai and English both OK** in skill body — match the existing skill's language
- **Avoid emoji in SKILL.md frontmatter** — breaks some parsers
- **Triggers should be specific** — vague descriptions cause over-triggering
- **Code examples MUST be real** — prefer snippets copied from aegisx-starter over invented examples

---

## Questions?

Open an issue at https://github.com/aegisx-platform/aegisx-skill/issues.
