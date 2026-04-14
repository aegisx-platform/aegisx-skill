# Attribution

This repo bundles skills adapted from multiple open-source sources. All original authors are credited below.

## Everything Claude Code (ECC)

- **License:** MIT
- **Repo:** https://github.com/everything-claude-code/everything-claude-code
- **Version adapted:** v1.9.0
- **Date:** 2026-04-15

### Skills copied and adapted

Located under `skills/03-curated/`:

| Skill | Original ECC name | Modifications |
|---|---|---|
| postgres-patterns | postgres-patterns | — |
| database-migrations | database-migrations | — |
| api-design | api-design | — |
| docker-patterns | docker-patterns | — |
| deployment-patterns | deployment-patterns | — |
| mcp-server-patterns | mcp-server-patterns | — |
| context-budget | context-budget | — |
| skill-stocktake | skill-stocktake | — |
| prompt-optimizer | prompt-optimizer | — |
| click-path-audit | click-path-audit | — |
| codebase-onboarding | codebase-onboarding | — |
| architecture-decision-records | architecture-decision-records | — |

Any future modifications to these skills will be noted in the skill's SKILL.md frontmatter (`modified: <date>` field) and in CHANGELOG.md.

---

## Untitled UI (Figma)

- **Source:** https://www.untitledui.com/ (Figma community)
- **License:** Free for commercial use (Untitled UI FREE)
- **Usage:** Design patterns only (layout, spacing, typography scale, component anatomy)
- **Not adopted:** Color palette (we use Tailwind Zinc instead)

Our `aegisx-ui-design` skill is inspired by Untitled UI patterns but uses the AegisX "Clean Clinical SaaS" color system.

---

## AegisX Platform (Original)

All skills under `skills/01-aegisx-core/` and `skills/02-workflow/` are original work by the AegisX Platform team:

- aegisx-cli-library, aegisx-mcp-server, aegisx-ui-library, aegisx-ui-design, aegisx-ui-types, aegisx-icons
- angular-conventions, crud-generator-guide, unified-crud-validator, layer-architecture-validator
- frontend-prereq-checker, frontend-integration-guide, backend-customization-guide
- fastify-error-debugger, typebox-schema-generator, enum-type-generator
- api-contract-generator, api-contract-validator, api-endpoint-tester, database-management
- quality-gate, spec-validator, quick-build-test, testing-automation
- test-ui, test-crud, test-form, security-best-practices, debug-ui

License: MIT

---

## Reporting Attribution Issues

If you believe a skill is missing proper attribution, please open an issue at https://github.com/aegisx-platform/aegisx-skill/issues.
