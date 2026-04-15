# AegisX Skill

> Curated Claude Code skills, commands, and rules for **AegisX Platform** development.

AegisX is a full-stack enterprise application platform (Angular 17+ / Fastify / PostgreSQL) supporting multiple business domains (Inventory, HR, Finance, etc.). This repo bundles the Claude Code knowledge base that powers development across all AegisX-based projects.

---

## Installation

### Option A: As a Claude Code Plugin (recommended)

```bash
# Step 1: Add the marketplace
/plugin marketplace add aegisx-platform/aegisx-skill

# Step 2: Install the plugin
/plugin install aegisx-skill@aegisx-skill
```

### Option B: Git submodule in your AegisX project

```bash
cd your-aegisx-project
git submodule add git@github.com:aegisx-platform/aegisx-skill.git .claude/skills/_aegisx
```

Update later:
```bash
git submodule update --remote .claude/skills/_aegisx
```

### Option C: Clone and symlink

```bash
git clone git@github.com:aegisx-platform/aegisx-skill.git ~/code/aegisx-skill
ln -s ~/code/aegisx-skill/skills your-aegisx-project/.claude/skills/_aegisx
```

---

## What's Inside

### Skills (61)

```
skills/
├── 01-aegisx-core/        27  AegisX-specific — CRUD gen, UI (design/library/types/icons), domain, auth
├── 02-workflow/           21  Development workflow — testing, quality, deploy, ops, worktree, subtree
├── 03-curated/            12  Cherry-picked from ECC — postgres, API design, docker
└── 04-meta/                1  Skills about skills — workflow recording
```

See [docs/STRUCTURE.md](docs/STRUCTURE.md) for the full index.

### Commands (10)
Slash commands: `/reflect`, `/diary`, `/review`, `/weekly`, `/eod`, `/session-status`, `/resume`, `/feature-done`, `/cost`, `/worktree-list`

### Rules (7)
Shared rule snippets: task structure, context management, API-first workflow, field addition checklist, UI component usage, learned patterns

### Templates (1)
Feature development templates

---

## Highlights — Core Skills

| Skill | Purpose |
|---|---|
| **aegisx-ui-design** | Design patterns, Tailwind Zinc palette, Material v3 tokens |
| **aegisx-ui-library** | Component API reference — 35+ `<ax-*>` components |
| **aegisx-ui-types** | TypeScript type catalog for aegisx-ui |
| **aegisx-icons** | 59 custom SVG icons (drug inventory, HIS, admin) |
| **aegisx-cli-library** | `@aegisx/crud-generator` NPM package guide |
| **aegisx-mcp-server** | `@aegisx/mcp` MCP server guide |
| **angular-conventions** | Project-specific Angular/Fastify conventions |
| **unified-crud-validator** | Pre-flight check before CRUD generation |

---

## Documentation

- [docs/STRUCTURE.md](docs/STRUCTURE.md) — Why 4 tiers, full skill index
- [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) — How to add/edit skills
- [docs/ATTRIBUTION.md](docs/ATTRIBUTION.md) — Credit to ECC and other sources
- [docs/ROADMAP.md](docs/ROADMAP.md) — Upcoming skills wishlist
- [CHANGELOG.md](CHANGELOG.md) — Version history

---

## Development

```bash
# Validate all SKILL.md frontmatter
./scripts/validate.sh

# Sync aegisx-ui docs into skills/01-aegisx-core/aegisx-ui-library/references/
./scripts/sync-ui-docs.sh /path/to/aegisx-starter

# Scaffold a new skill
./scripts/add-skill.sh 01-aegisx-core my-new-skill
```

---

## License

MIT — see [LICENSE](LICENSE).

Skills adapted from [Everything Claude Code (ECC)](https://github.com/everything-claude-code/everything-claude-code) retain MIT license with attribution in [docs/ATTRIBUTION.md](docs/ATTRIBUTION.md).
