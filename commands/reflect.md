# Reflect Command

Reflect on the last task completed, identify learnings, and update CLAUDE.md with new rules.

## Instructions

After completing a task, analyze what happened:

### 1. What worked well?

- Identify successful patterns
- What decisions led to success?
- Which tools/approaches were effective?

### 2. What could be improved?

- Spot mistakes or suboptimal decisions
- What caused delays or errors?
- Where did you guess instead of verify?

### 3. Abstract the lesson

- Generalize into a reusable rule
- Make it concrete and actionable
- Use NEVER/ALWAYS/PREFER format

### 4. Update Learned Patterns

Add new rule to `.claude/rules/learned-patterns-recent.md`:

**Format:**

```
NEVER: [specific anti-pattern] - because [concrete reason]
ALWAYS: [specific practice] - because [concrete benefit]
PREFER: [option A] over [option B] - when [condition]
  - Because: [reason]
  - Learned: [date]
```

**File to update:** `.claude/rules/learned-patterns-recent.md`

**Section:** Add to the ```block under`## 📚 Learned Patterns`

### 5. Examples

**Good Entry:**

```
NEVER: Generate CRUD without checking domain classification
ALWAYS: Read domain-architecture-guide.md first
PREFER: inventory/master-data for lookup tables over inventory/operations
  - Because: Master data = reference/configuration data
  - Learned: 2026-01-01
```

**Bad Entry (too vague):**

```
ALWAYS: Use MCP
```

**Bad Entry (not actionable):**

```
NEVER: Make mistakes
```

## Usage

Simply type: `/reflect`

Or say: "Reflect on what just happened and update CLAUDE.md"
