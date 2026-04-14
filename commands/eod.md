# End of Day Summary

สรุปงานประจำวัน merge session logs และคำนวณ total cost

## Instructions

1. อ่านไฟล์ทั้งหมดใน `docs/sessions/.current/*.log`

2. รวมข้อมูลจากทุก sessions:
   - Total sessions
   - Total tasks completed
   - Total tokens
   - Total cost

3. สร้าง `docs/sessions/daily/{YYYY-MM-DD}.md`:

```markdown
# Daily Summary: {DATE}

## Overview

| Metric          | Value   |
| --------------- | ------- |
| Sessions        | {COUNT} |
| Tasks Completed | {COUNT} |
| Total Tokens    | {SUM}   |
| Estimated Cost  | ${COST} |

---

## Sessions Detail

### Session: {NAME}

- Duration: {START} - {END}
- Model: {MODEL}
- Tasks: {COUNT}
- Tokens: {SUM}
- Cost: ${COST}

| Time | Task ID | Description | Tokens | Cost | Status |
| ---- | ------- | ----------- | ------ | ---- | ------ |

{rows}

---

## All Tasks Completed

| Session | Task ID | Description | Tokens | Cost |
| ------- | ------- | ----------- | ------ | ---- |

{all tasks from all sessions}

**Total: {X} tasks, {Y} tokens, ${Z}**

---

## Specs Progress

{list specs that were worked on with % progress}

---

## Files Changed

### Created

{list}

### Modified

{list}

---

## Issues & Notes

{any issues from sessions}

---

## Tomorrow's Priority

1. [ ] {next tasks}
```

4. Update `docs/PROGRESS.md`:
   - Update Recent Activity section
   - Update module progress %

5. Archive session logs:

   ```bash
   mkdir -p docs/sessions/archive/{DATE}
   mv docs/sessions/.current/*.log docs/sessions/archive/{DATE}/
   ```

6. แสดงสรุป:

   ```
   📊 EOD Summary: {DATE}
   ├── Sessions: {X}
   ├── Tasks: {Y}
   ├── Tokens: {Z}
   └── Cost: ${W}

   ✅ Daily summary created
   ✅ Session logs archived
   ```

## Cost Calculation

### Haiku

```
cost = tokens * 0.0000022
```

### Sonnet

```
cost = tokens * 0.000012
```

### Quick Reference

| Tokens | Haiku | Sonnet |
| ------ | ----- | ------ |
| 50k    | $0.11 | $0.60  |
| 100k   | $0.22 | $1.20  |
| 200k   | $0.44 | $2.40  |
