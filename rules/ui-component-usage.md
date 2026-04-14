# UI Component Usage Rules

> **🎯 CRITICAL: Use existing components first, avoid custom implementation**

---

## 🚨 Golden Rule

**Priority Order:**

1. **AegisX UI** (`@aegisx/ui`) - First priority
2. **Angular Material** - Second priority
3. **TailwindCSS** - For layout/spacing ONLY

**NEVER create custom unless:** No existing fits, user explicitly requests, or blocking limitations

---

## 📚 Component Libraries

### 1. AegisX UI (@aegisx/ui) - Check FIRST

```bash
aegisx_components_list              # List all
aegisx_components_search query="table"  # Search
aegisx_components_get name="Badge"      # Get details
```

| Category     | Components                                                   |
| ------------ | ------------------------------------------------------------ |
| Data Display | Badge, Card, Chip, DataTable, Stats, Timeline                |
| Forms        | Form, Input, Select, Checkbox, Radio, DatePicker, FileUpload |
| Feedback     | Alert, Dialog, Drawer, Loading, Progress, Skeleton, Toast    |
| Navigation   | Breadcrumb, Menu, Navbar, Pagination, Sidebar, Tabs          |
| Layout       | Container, Grid, Stack, Divider                              |

### 2. Angular Material - When AegisX doesn't have it

| Category | Components                                                    |
| -------- | ------------------------------------------------------------- |
| Forms    | MatFormField, MatInput, MatSelect, MatCheckbox, MatDatepicker |
| Buttons  | MatButton, MatIconButton, MatFab                              |
| Layout   | MatCard, MatToolbar, MatSidenav, MatExpansionPanel            |
| Data     | MatTable, MatPaginator, MatSort                               |
| Dialogs  | MatDialog, MatSnackBar, MatBottomSheet                        |

### 3. TailwindCSS - Layout/Spacing ONLY

| ✅ Allowed                       | ❌ Forbidden                |
| -------------------------------- | --------------------------- |
| `flex`, `grid`, `gap-*`          | `bg-*`, `text-*` (colors)   |
| `p-*`, `m-*`, `space-*`          | `border-*`, `rounded-*`     |
| `w-*`, `h-*`, `max-w-*`          | `shadow-*`                  |
| `hidden`, `block`, `inline-flex` | `text-xl`, `font-bold`      |
| `relative`, `absolute`, `sticky` | `transition-*`, `animate-*` |
| `md:*`, `lg:*`, `xl:*`           |                             |

---

## 🔍 Decision Flow

```
Step 1: aegisx_components_search → Found? → Use it ✅
                                 → Not found? ↓
Step 2: Check Angular Material → Found? → Use it ✅
                               → Not found? ↓
Step 3: Check docs/patterns/ui-components.md → Found? → Adapt it ✅
                                             → Not found? ↓
Step 4: Ask user for approval before creating custom
```

---

## ✅ Quick Examples

```typescript
// ❌ WRONG: Custom badge with Tailwind
<span class="px-2 py-1 bg-green-500 text-white rounded">Active</span>

// ✅ CORRECT: AegisX Badge
<ax-badge variant="success">Active</ax-badge>

// ❌ WRONG: Custom button
<button class="px-4 py-2 bg-blue-500 text-white rounded">Save</button>

// ✅ CORRECT: Material Button
<button mat-raised-button color="primary">Save</button>

// ✅ CORRECT: Tailwind for spacing + existing component
<div class="flex gap-4">
  <button mat-raised-button color="primary">Save</button>
  <button mat-button>Cancel</button>
</div>
```

---

## 🎯 When Custom IS Allowed

| Condition                | Example                              |
| ------------------------ | ------------------------------------ |
| Business-specific logic  | Budget calculator widget             |
| Composition of existing  | FormModal = MatDialog + MatFormField |
| User explicitly requests | "Create custom component for X"      |
| No alternative exists    | After searching all libraries        |

**Custom components MUST compose existing ones:**

```typescript
@Component({
  imports: [MatCardModule, BadgeComponent], // Uses existing!
  template: `<mat-card><ax-badge>...</ax-badge></mat-card>`,
})
export class CustomBusinessComponent {}
```

---

## 📋 Pre-Implementation Checklist

```
- [ ] Searched AegisX UI (aegisx_components_search)
- [ ] Checked Angular Material
- [ ] Reviewed docs/patterns/ui-components.md
- [ ] If no match → Asked user for approval
- [ ] Tailwind ONLY for layout/spacing
- [ ] NOT recreating existing components
```

---

## 🔧 Quick Reference

```
Priority: AegisX UI → Material → Compose existing → Ask user → Custom

MCP Tools:
- aegisx_components_list
- aegisx_components_search query="..."
- aegisx_components_get name="..."
```

**Remember: If it exists, use it. If not, ask first.** ✅
