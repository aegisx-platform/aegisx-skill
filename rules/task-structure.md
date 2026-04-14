# Task Structure & Progress Management

## Workflow: UNDERSTAND → PLAN → APPROVE → EXECUTE → VALIDATE → REPORT

## When to Use TodoWrite

MANDATORY if: > 3 steps, > 30 min, multiple files, backend+frontend, or DB changes.

## Model Selection (Agent Spawning)

- **Haiku**: Simple/mechanical (path updates, formatting)
- **Sonnet**: Moderate complexity (refactoring, API design, code review)
- **Opus**: High complexity/risk (security, architecture, debugging)

## Task Size

| Size               | TodoWrite | Checkpoints  |
| ------------------ | --------- | ------------ |
| Tiny/Small (< 30m) | Optional  | End only     |
| Medium (30m-2h)    | MANDATORY | Every 30 min |
| Large (> 2h)       | MANDATORY | Every phase  |

## Red Flags - STOP Immediately

1. Working > 30 min without reporting
2. Scope expanding beyond request
3. Stuck > 15 min on subtask
4. Token > 50% and not halfway done

## Completion Report

```
Summary: [what] | Changes: [files] | Testing: Build PASSED | Next: [if any]
```
