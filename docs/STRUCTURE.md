# Repository Structure

## Tier System (4 folders)

Skills are organized by **stability + ownership**, not by topic. This makes updates predictable.

| Tier | Purpose | Update cadence | Source |
|---|---|---|---|
| **01-aegisx-core** | AegisX-specific — tightly coupled to AegisX code | Every release | Original |
| **02-workflow** | Dev workflow tuned for AegisX | Occasional | Mostly original |
| **03-curated** | Cherry-picked from external plugins | Sync from upstream | Adapted (see [ATTRIBUTION.md](ATTRIBUTION.md)) |
| **04-meta** | Skills about using skills | Rare | Mixed |

---

## Full Skill Index

### 01-aegisx-core/ (18 skills)

**UI/Design cluster:**
- `aegisx-ui-design` — Design patterns, Tailwind Zinc palette, Material v3 tokens
- `aegisx-ui-library` — Component API (35+ components, progressive disclosure via `references/`)
- `aegisx-ui-types` — TypeScript type catalog
- `aegisx-icons` — 59 custom SVG icons

**CRUD/Codegen cluster:**
- `aegisx-cli-library` — `@aegisx/crud-generator` NPM package guide
- `aegisx-mcp-server` — `@aegisx/mcp` MCP server guide
- `crud-generator-guide` — High-level CRUD generator usage
- `unified-crud-validator` — Pre-flight check before generation
- `layer-architecture-validator` — Core/Platform/Domains validation
- `frontend-prereq-checker` — Shell/section check before frontend CRUD

**Conventions:**
- `angular-conventions` — Project-specific Angular/Fastify patterns

**API/Schema:**
- `api-contract-generator` — Generate `API_CONTRACTS.md` from routes
- `api-contract-validator` — Validate routes match contracts
- `api-endpoint-tester` — Curl-based endpoint testing
- `typebox-schema-generator` — Generate TypeBox from PostgreSQL tables
- `enum-type-generator` — Generate types from PostgreSQL enums
- `database-management` — Migration/seed operations

**Debug:**
- `fastify-error-debugger` — FST_ERR_FAILED_ERROR_SERIALIZATION debugger

**Integration:**
- `frontend-integration-guide` — Wire Angular frontend to generated APIs
- `backend-customization-guide` — Customize generated backend beyond CRUD

### 02-workflow/ (10 skills)

- `quality-gate` — 10-point checklist before completion
- `spec-validator` — Validate implementation vs spec
- `quick-build-test` — Fast TS check + build
- `testing-automation` — Create unit/integration/E2E tests
- `test-ui` — UI test automation via Chrome MCP
- `test-crud` — Full CRUD test workflow
- `test-form` — Form validation testing
- `security-best-practices` — Security checklist
- `debug-ui` — Browser console + network debugging
- `documentation-automation` — Doc generation

### 03-curated/ (12 skills)

From [ECC](ATTRIBUTION.md):
- `postgres-patterns`, `database-migrations`, `api-design`
- `docker-patterns`, `deployment-patterns`, `mcp-server-patterns`
- `context-budget`, `skill-stocktake`, `prompt-optimizer`
- `click-path-audit`, `codebase-onboarding`, `architecture-decision-records`

### 04-meta/ (2 skills)

- `design-inspiration` — DESIGN.md token references (Linear, Notion, etc.)
- `record-workflow` — Record GIFs for docs/tutorials

---

## Commands (10)

Located at `commands/`, loaded by Claude Code as slash commands:

| Command | Purpose |
|---|---|
| `/reflect` | Extract lessons from last task |
| `/diary` | Session summary |
| `/review` | Self-review code |
| `/weekly` | Consolidate week's patterns |
| `/eod` | End-of-day summary |
| `/session-status` | Current session state |
| `/resume` | Resume from last session |
| `/feature-done` | Generate feature documentation |
| `/cost` | Cost summary |
| `/worktree-list` | List active git worktrees |

---

## Rules (7)

Rule snippets at `rules/` that can be included in `CLAUDE.md` or loaded on demand:

- `task-structure.md` — Workflow phases + size buckets
- `context-management.md` — Token budget discipline
- `api-first-workflow.md` — 3-phase API-first validation
- `field-addition-checklist.md` — 5-layer checklist for new fields
- `ui-component-usage.md` — AegisX UI > Material > Tailwind priority
- `learned-patterns-recent.md` — NEVER/ALWAYS/PREFER rules
- `api-endpoints.md` — API calling standards

---

## Why This Structure?

1. **Separate ownership from topic.** Tier = who maintains it. Knowing ownership tells you the update risk.
2. **Keep curated skills isolated.** External skills go in `03-curated/` with clear attribution. Core stays clean.
3. **UI cluster is 4 skills, not 1.** Split by role (design vs. API vs. types vs. icons) so each can be triggered independently.
4. **Progressive disclosure for aegisx-ui-library.** 35+ components live in `references/` — SKILL.md is a short index pointing to files, not a 10,000-token wall.
