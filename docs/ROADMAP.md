# Roadmap

Upcoming skills and improvements tracked here. Not a commitment — just a wishlist.

## Planned Skills

### 01-aegisx-core/

- [ ] `aegisx-auth-flows` — JWT, RBAC, session strategies specific to AegisX
- [ ] `aegisx-domain-architecture` — Domain classification (master-data vs. operations)
- [ ] `aegisx-layout-migration` — ax-page-shell + --ax-* token migration patterns
- [ ] `aegisx-event-system` — WebSocket events for CRUD modules

### 02-workflow/

- [ ] `worktree-workflow` — Parallel feature dev patterns
- [ ] `subtree-sync` — Sync shared libs (aegisx-cli, aegisx-ui, aegisx-mcp)

### 03-curated/

Candidates to pull from ECC when needed:
- [ ] `docker-compose-patterns` — if we move beyond basic compose
- [ ] `ai-regression-testing` — sandbox-mode API testing
- [ ] `santa-method` — multi-agent adversarial verification (for critical features)
- [ ] `regex-vs-llm-structured-text` — decision framework when parsing migration data

### 04-meta/

- [ ] `skill-creator` — Template-driven skill creation
- [ ] `skill-metrics` — Track which skills actually trigger (audit bloat)

---

## Tooling

- [ ] CI: GitHub Actions running `validate.sh` on PR
- [ ] `scripts/sync-ecc.sh` — Auto-pull ECC updates with 3-way merge
- [ ] `scripts/sync-ui-docs.sh` — Auto-pull from aegisx-starter
- [ ] Plugin manifest: add agents section once we define custom agents
- [ ] Generate `skills/INDEX.md` automatically from SKILL.md frontmatter

---

## Documentation

- [ ] `docs/SKILL_DESIGN_PATTERNS.md` — Patterns for writing effective skills
- [ ] `docs/TRIGGER_GUIDE.md` — How to write descriptions that trigger reliably
- [ ] Screencast: "Installing aegisx-skill in 2 minutes"

---

## Versioning Plan

- **v1.0.0** — Initial release (42 skills, 10 commands, 7 rules)
- **v1.1.0** — Add missing aegisx-* skills (auth, domain, layout, events)
- **v1.2.0** — Automated ECC sync
- **v2.0.0** — Restructure if skill count exceeds ~60 (split into sub-plugins?)

---

## Open Questions

- Should `aegisx-icons` live in main repo and auto-sync here, OR live here authoritatively?
- Will we eventually publish this as a public Claude Code plugin for the community?
- How do we handle AegisX **client forks** — one skill repo per client, or a single "AegisX core + plugins" model?
