---
name: design-inspiration
description: Curated DESIGN.md token references from awesome-design-md (Linear, Notion, Cal, Mintlify, Cursor, Claude, Intercom). Use when designing new UI surfaces, picking color/typography/spacing tokens, briefing visual direction, or when the user mentions "design", "look like X", "make it pretty", "north star", or names a reference brand.
allowed-tools: Read, Grep, Glob
---

# Design Inspiration

Token + pattern references for AegisX UI surfaces. Sourced from [VoltAgent/awesome-design-md](https://github.com/VoltAgent/awesome-design-md) (MIT).

## When Claude Should Use This Skill

- User asks to design a new page/surface ("ทำหน้า...", "build dashboard...")
- User says "ให้สวย", "ให้ดูดี", "เหมือน Linear/Notion/...", "design system"
- User wants to update colors/typography/spacing tokens
- Briefing visual direction before implementing UI
- User asks for "north star" or design references

## Available References

| Brand    | File                                           | Best for                                                                                |
| -------- | ---------------------------------------------- | --------------------------------------------------------------------------------------- |
| Linear   | `docs/design/inspiration/linear.app/DESIGN.md` | **Dashboards (north star)** — dark surface system, border opacity, Inter 510 type scale |
| Notion   | `docs/design/inspiration/notion/DESIGN.md`     | Document/form layouts, content density                                                  |
| Cal      | `docs/design/inspiration/cal/DESIGN.md`        | Booking modals, scheduling flows                                                        |
| Mintlify | `docs/design/inspiration/mintlify/DESIGN.md`   | Docs site (`pnpm run docs:dev`)                                                         |
| Cursor   | `docs/design/inspiration/cursor/DESIGN.md`     | AI feature surfaces, command palette                                                    |
| Claude   | `docs/design/inspiration/claude/DESIGN.md`     | AI chat / message UI                                                                    |
| Intercom | `docs/design/inspiration/intercom/DESIGN.md`   | Enterprise settings panes                                                               |

## How to Use

1. **Identify the surface type** the user wants → pick ONE north-star brand from the table above.
2. **Read** the relevant `DESIGN.md` for color/typography/spacing tokens.
3. **DO NOT clone the look 1:1** — trade dress matters. Treat as token + pattern reference only.
4. **Compose existing components** — per `.claude/rules/ui-component-usage.md`:
   - Priority: `@aegisx/ui` → Angular Material → Tailwind for layout only
   - Never recreate components from scratch just because a DESIGN.md looks cool
5. **If a token should apply globally** → update `libs/aegisx-ui/src/lib/styles/themes/_aegisx-tokens.scss` instead of inlining.

## Example Brief Pattern

> "Build the budget dashboard following `docs/design/inspiration/linear.app/DESIGN.md` token system (dark surfaces, border opacity, type scale), using `@aegisx/ui` cards + Material table. Don't recreate primitives."

## Anti-Patterns

- ❌ Copying brand identity (Linear violet, Apple SF) verbatim into customer modules
- ❌ Building custom buttons/cards because the DESIGN.md is prettier than Material
- ❌ Reading multiple DESIGN.md files for one surface — pick ONE north-star
- ❌ Applying Ferrari/BMW/luxury design to a healthcare CRUD form

## Related Rules

- `.claude/rules/ui-component-usage.md` — component priority
- `libs/aegisx-ui/src/lib/styles/themes/_aegisx-tokens.scss` — global tokens
- `docs/design/inspiration/README.md` — full usage notes
