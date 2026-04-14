# Weekly Command

Analyze diary entries from the past week and consolidate learnings into CLAUDE.md.

## Instructions

At the end of each week, review all sessions and identify patterns:

### 1. Read All Diary Entries

```bash
ls -1 .claude/diary/*.md | tail -7
```

Read all entries from the last 7 days.

### 2. Identify Patterns

**Recurring Patterns:**

- What keeps coming up?
- Which tools/approaches used most?
- Common workflows?

**Repeated Mistakes:**

- What errors happened multiple times?
- Which rules were violated?
- What confusion occurred repeatedly?

**Successful Strategies:**

- What approaches worked well consistently?
- Which patterns led to success?
- Fast solutions that worked?

**Rule Violations:**

- Which CLAUDE.md rules were broken?
- Why were they broken?
- How to prevent next time?

### 3. Consolidate Rules

**Strengthen existing rules:**

- Add examples to vague rules
- Make rules more specific
- Add "Because:" explanations

**Add new rules:**

- For recurring issues
- For successful patterns
- For clarifications needed

**Remove/Update:**

- Outdated rules
- Rules that weren't helpful
- Rules that need refinement

### 4. Create Weekly Summary

Save to: `.claude/diary/week-[N]-summary.md`

**Format:**

```markdown
# Week [N] Summary ([Start Date] - [End Date])

## 📊 Overview

- Sessions: [N]
- Tasks completed: [list]
- Main focus: [areas]

## ⭐ Top Learnings

1. [Most important lesson]
2. [Second important lesson]
3. [Third important lesson]

## 🔄 Patterns Identified

- [Pattern 1]: Occurred [N] times
- [Pattern 2]: Occurred [N] times

## ✅ Rules Added/Updated

- [New rule or update]
- [Reason for change]

## 🎯 Focus for Next Week

- [Area to improve]
- [Practice to maintain]
```

### 5. Update Learned Patterns

Apply all consolidated changes to `.claude/rules/learned-patterns-recent.md`:

- Add stronger rules
- Remove outdated ones
- Add examples to existing rules

**After updating, run rotation:**

```bash
python3 scripts/rotate-patterns.py
```

This will:

- Keep recent/critical patterns in auto-load
- Move old patterns to archive (Chroma-indexed)

## Usage

Run at end of week (Friday or Sunday):

Type: `/weekly`

Or say: "Analyze this week's patterns and consolidate rules"

## Benefits

- Prevents rule bloat (remove unhelpful rules)
- Strengthens important patterns
- Identifies trends not visible day-to-day
- Improves CLAUDE.md quality over time

## Example

**Week 1 might reveal:**

- Used `aegisx_crud_build_command` 10 times → strengthen this rule
- Forgot domain classification 3 times → add reminder
- grep was faster than docs 5 times → add preference

**Actions:**

```
NEVER: Skip domain classification check
  ↑ Strengthen this - happened 3 times

PREFER: grep for quick lookups over reading full docs
  ↑ Add this new rule - proven pattern
```
