# Context Management Rules

> **🎯 CRITICAL: Prevent losing focus and reading unnecessary files**

---

## 📋 4-Phase Token Budget

| Phase         | Target | Action                                                    |
| ------------- | ------ | --------------------------------------------------------- |
| 1. Understand | < 10%  | Read task, relevant rules ONLY, ask if unclear            |
| 2. Plan       | < 20%  | TodoWrite, identify files (don't read yet!), get approval |
| 3. Execute    | < 60%  | Work ONE subtask at a time, report every 3 tasks          |
| 4. Validate   | < 10%  | Build, test, review, report completion                    |

---

## 📊 Token Checkpoints

| Token % | Action                                              |
| ------- | --------------------------------------------------- |
| **40%** | Alert: "Approaching half budget"                    |
| **50%** | MANDATORY: Summarize, ask user to continue or pause |
| **60%** | STOP: Report progress, wait for user decision       |
| **70%** | STOP IMMEDIATELY: Save state, suggest new session   |
| **80%** | NEVER exceed without explicit permission            |

---

## 📁 File Reading Limits

| Task Type         | Max Files | Token Budget |
| ----------------- | --------- | ------------ |
| Simple (< 30 min) | 5 files   | 20-40%       |
| Medium (30m - 2h) | 10 files  | 30-60%       |
| Complex (> 2h)    | 20 files  | 50-80%       |

---

## ✅ Read or Skip Decision Matrix

| Situation                | Decision                  |
| ------------------------ | ------------------------- |
| File mentioned in task   | ✅ READ                   |
| File I will modify       | ✅ READ                   |
| Direct import/dependency | ✅ READ (section only)    |
| Related feature          | ❌ SKIP                   |
| "Might be helpful"       | ❌ SKIP                   |
| Documentation in rules   | ❌ SKIP (already have it) |
| "Interesting" code       | ❌ SKIP                   |

**Rule:** Use `grep`/`glob` FIRST to find what you need, then read only that file/section.

---

## 🚫 Anti-Patterns

| ❌ Bad                                 | ✅ Good                            |
| -------------------------------------- | ---------------------------------- |
| "Let me understand the codebase first" | "I need UserService for this task" |
| Read 10 files before planning          | Plan first, read later             |
| Work 1 hour without update             | Report every 30 minutes            |
| "I noticed this could be improved too" | Do ONLY what was asked             |

---

## 🚨 Red Flags - STOP Immediately

1. Token > 60% and task not complete
2. Read > 15 files for simple task
3. Working > 30 min without reporting
4. Unsure what user wants
5. Exploring "interesting" code
6. Adding unrequested features

**Recovery:** STOP → Summarize → Ask user

---

## ⚡ Quick Tools

```bash
# Find first, read later
grep -r "functionName" apps/api/src/
glob "**/*service.ts"
git diff HEAD~1 --name-only
```

---

> **Remember:** grep/glob FIRST → Read specific files ONLY → Report often → Stay focused
