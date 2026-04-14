# /resume - Resume Work from Last Session

> **Resume feature development from exact stopping point**
>
> **Zero questions. Automatic context recovery.**

---

## 📋 Usage

```bash
User: /resume
```

**That's it!** Claude will automatically:

1. 🔍 Read `.claude/session/current-session.json`
2. 🌳 Detect git worktree (if applicable)
3. 📖 Load worktree context file (if exists)
4. 📖 Load session state (feature, phase, tasks)
5. 🧠 Read spec files (requirements.md, design.md, tasks.md)
6. 📊 Read progress log
7. 🎯 Continue from exact task
8. 💾 Auto-save state every 10 minutes

**Zero manual input required.**

---

## 🤖 What Claude Auto-Detects

### From Session State (current-session.json)

```json
✅ Session ID (timestamp-based)
✅ Feature name
✅ Spec path
✅ Current phase (planning/database/backend/frontend/integration/docs)
✅ Current task ID (e.g., "3.2")
✅ Completed tasks list
✅ Pending tasks list
✅ Blockers (if any)
✅ Key decisions made
✅ Files created/modified
✅ Worktree info (if working in worktree)
  - Path, branch, main repo
  - Context file path
✅ Token usage & checkpoints
```

### From Progress Log (progress.md)

```
✅ Completion percentage
✅ Task durations
✅ Decision history
✅ Blocker status
✅ Next steps
```

### From Spec Files (Auto-read)

```
✅ Requirements (what to build)
✅ Design decisions (how to build)
✅ Task breakdown (steps)
✅ Acceptance criteria
```

### From Worktree Context (if applicable)

```
✅ Current focus (specific to this branch)
✅ DO NOT TOUCH files (locked by other branches)
✅ Learned patterns (this feature)
✅ Bugs fixed (this branch)
✅ Next steps (before merge)
✅ Key decisions (branch-specific)
```

**Auto-detection:**

- Checks if `.git` is a file (worktree) vs directory (main repo)
- Reads worktree context from `.claude/worktree-context/[branch].md`
- Isolates context from other parallel features

---

## ⚡ Example Run

```
User: /resume

Claude:
  🔍 Loading session state...
     → Session: 2025-12-20-001
     → Feature: stock-alerts

  🌳 Worktree detected
     → Branch: feature/stock-alerts
     → Path: /Users/.../aegisx-stock-alerts
     → Context: .claude/worktree-context/feature-stock-alerts.md
     → DO NOT TOUCH: apps/api/src/core/auth/* (main branch)

  📖 Loading spec...
     → Spec: docs/specs/stock-alerts/

  📖 Reading spec files...
     → requirements.md ✓
     → design.md ✓
     → tasks.md ✓

  📊 Analyzing progress...
     → Phase: Implementation (3/6 phases)
     → Completed: 5/12 tasks (42%)
     → Current: Task 3.2 - Create AlertService
     → Blocked: None

  🧠 Loading context...
     → Key decisions: 3 loaded
     → Files modified: 8 files
     → Last checkpoint: 30 min ago

  🎯 Ready to continue!

  **Resuming from Task 3.2: Create AlertService**

  Context loaded:
  - Using WebSocket for real-time alerts (decision from 10:30)
  - AlertRepository already created (task 3.1 ✓)
  - Need to implement business logic for:
    * Min/max threshold checks
    * Alert triggering logic
    * Notification queueing

  Starting implementation now...

  [Continues working exactly where left off]
```

---

## 📝 Session State Structure

### current-session.json

```json
{
  "sessionId": "2025-12-20-001",
  "startedAt": "2025-12-20T10:00:00Z",
  "lastUpdated": "2025-12-20T12:30:00Z",
  "feature": "stock-alerts",
  "specPath": "docs/specs/stock-alerts",
  "phase": "implementation",
  "currentTask": "3.2",
  "completedTasks": ["1.1", "1.2", "2.1", "2.2", "3.1"],
  "pendingTasks": ["3.2", "3.3", "4.1", "4.2", "5.1", "6.1"],
  "blockers": [],
  "nextSteps": ["Complete AlertService implementation", "Create alert routes", "Test API endpoints"],
  "keyDecisions": [
    {
      "decision": "Use WebSocket for real-time alerts",
      "reason": "Better UX, already have WebSocket infrastructure",
      "date": "2025-12-20T10:30:00Z",
      "impact": "low"
    }
  ],
  "filesCreated": ["apps/api/src/layers/domains/inventory/alerts/alert.entity.ts", "apps/api/src/layers/domains/inventory/alerts/alert.repository.ts"],
  "filesModified": ["apps/api/src/database/migrations-inventory/20251220_create_alerts.ts"],
  "context": {
    "tokenUsage": 45000,
    "checkpoints": [
      {
        "task": "3.1",
        "timestamp": "2025-12-20T12:00:00Z",
        "tokenUsage": 35000
      }
    ],
    "notes": ["Using same pattern as budget-control for modal", "Alert thresholds stored in percentage (0-100)"]
  }
}
```

---

## 🔄 Auto-Save Behavior

Claude automatically saves session state:

**Frequency:**

- ✅ Every 10 minutes during work
- ✅ After completing each task
- ✅ Before spawning agents
- ✅ When token usage hits checkpoints (40%, 50%, 60%)
- ✅ When user asks to pause/stop

**What's Saved:**

- Current task progress
- Decisions made
- Files changed
- Context notes
- Token usage

---

## 🚨 Recovery Scenarios

### Scenario 1: Context Limit Reached

```
Session at 60% tokens → Auto-save state
Claude: "Token budget at 60%. Saving progress..."
[Saves current state]
Claude: "Resume with: /resume in new session"
```

### Scenario 2: Interrupted Mid-Task

```
User needs to stop urgently
User: "pause"
Claude: [Saves current state immediately]
       "Session saved. Resume with: /resume"
```

### Scenario 3: Error/Blocker Encountered

```
Claude encounters blocker
Claude: [Saves state with blocker noted]
       "Blocker: API endpoint not implemented yet"
       "Saved state. Fix blocker then: /resume"
```

### Scenario 4: Multi-Day Feature

```
Day 1: Work 3 hours → Stop
Day 2: /resume → Continue exactly where stopped
Day 3: /resume → Continue
...until feature done
```

---

## 💡 Best Practices

### For Users:

**Starting New Feature:**

```bash
# Claude auto-creates session when starting feature
User: "Let's start stock-alerts feature"
Claude: [Creates session automatically]
        [Saves initial state]
```

**Pausing Work:**

```bash
User: "pause" or "stop" or "break"
Claude: [Auto-saves immediately]
        "Session saved. Use /resume to continue."
```

**Resuming Work:**

```bash
User: /resume
Claude: [Loads everything, continues]
```

**Checking Progress:**

```bash
User: "show progress" or "where are we?"
Claude: [Reads progress.md, reports status]
```

### For Claude:

**Auto-save triggers:**

- ✅ Every task completion
- ✅ Every 10 minutes
- ✅ Before spawning agents
- ✅ Token checkpoints
- ✅ User requests pause

**What to save:**

- ✅ Update lastUpdated timestamp
- ✅ Update completedTasks array
- ✅ Update currentTask
- ✅ Add to keyDecisions if decision made
- ✅ Update filesCreated/Modified
- ✅ Add checkpoint to context
- ✅ Update tokenUsage

---

## 🎯 Integration with Other Systems

### With Spec Workflow:

```
/resume → Reads spec from specPath
       → Validates against requirements.md
       → Checks tasks.md for progress
       → Continues implementation
```

### With Feature Tracking:

```
Feature complete → Update FEATURES.md
                → Run /feature-done
                → Archive session state
```

### With Quality Gates:

```
Each task completion → Run quality checks
                    → Save results to session
                    → Proceed if passed
```

---

## ❓ FAQ

### Q: ต้อง manual save หรือไม่?

A: ไม่ต้อง - Claude auto-save ทุก 10 นาที และเมื่อเสร็จแต่ละ task

### Q: Session เก็บไว้นานแค่ไหน?

A: จนกว่า feature จะเสร็จ แล้วจะ archive ไปที่ `.claude/session/archive/`

### Q: ถ้ามีหลาย features พร้อมกัน?

A: ใช้ feature name แยก session:

- `current-session-stock-alerts.json`
- `current-session-budget-control.json`

### Q: /resume ทำงานในทุก session ไหม?

A: ใช่ - session ใหม่อ่าน state ได้เลย, ไม่จำกัด session

---

## 🔧 Advanced Usage

### Resume Specific Feature:

```bash
User: /resume stock-alerts
Claude: [Loads stock-alerts session specifically]
```

### Check Session Status:

```bash
User: /session-status
Claude: [Shows current session info without resuming]
```

### Archive Old Session:

```bash
User: /archive-session stock-alerts
Claude: [Moves to archive/, clears current]
```

---

**Version**: 1.0.0
**Auto-save**: Enabled by default
**Recovery**: 100% state preservation
