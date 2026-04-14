# Diary Command

Create a session diary entry at the end of your work session.

## Instructions

Capture what happened in this session for future reference:

### Session Diary Format

```markdown
# Session: [DATE]

## ✅ Accomplished

- [List what was completed]
- [Specific tasks finished]
- [Features implemented]

## 🎯 Decisions Made

- **[Decision]**: [Reasoning]
- **[Choice]**: [Why this option was chosen]

## 🚧 Challenges Encountered

- **[Challenge]**: [How it was resolved or needs follow-up]
- **[Issue]**: [Workaround or solution applied]

## 💡 Learnings

- [New pattern discovered]
- [Insight gained]
- [Better approach identified]

## 📝 Notes for Next Session

- [What the next developer/session should know]
- [Incomplete work to resume]
- [Context needed to continue]

## 🔗 Related Files

- [List of files modified]
- [New files created]
```

### Where to Save

Save to: `.claude/diary/[YYYY-MM-DD].md`

**Example:** `.claude/diary/2026-01-01.md`

### After Creating Diary

Review learnings and consider:

1. Should any learning become a learned pattern rule?
2. Run `/reflect` if you haven't already
3. Update `.claude/rules/learned-patterns-recent.md` with important patterns

## Usage

Simply type: `/diary`

Or say: "Create session diary entry"

## Tips

- Be specific about decisions (not just "decided to use X")
- Include WHY behind choices
- Note what worked well AND what didn't
- Keep it concise but informative
- Future you will thank you for good notes!

## Note for Phase 2

In Phase 2 (with claude-mem), this will be automated - observations will be captured automatically. For now, manual diary entries help build the habit.
