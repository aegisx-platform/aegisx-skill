# Repository Structure

## Flat Skills

All 61 skills live directly under `skills/<name>/SKILL.md` (flat, no tier folders).
Claude Code's plugin system scans `skills/*/SKILL.md` — nested tier folders are not detected.

## Groupings (logical, via naming + description)

Skills are organized by naming prefix and description tags:

### Core AegisX (aegisx-*)
`aegisx-cli-library`, `aegisx-mcp-server`, `aegisx-ui-library`, `aegisx-ui-design`,
`aegisx-ui-types`, `aegisx-icons`, `aegisx-domain-architecture`, `aegisx-auth-rbac`,
`aegisx-schema-compilation`, `aegisx-multi-schema-db`, `aegisx-feature-docs`,
`aegisx-common-patterns`, `aegisx-layout-migration`

### CRUD / Codegen
`crud-generator-guide`, `unified-crud-validator`, `layer-architecture-validator`,
`frontend-prereq-checker`, `frontend-integration-guide`, `backend-customization-guide`

### API / Schema
`api-contract-generator`, `api-contract-validator`, `api-endpoint-tester`,
`typebox-schema-generator`, `enum-type-generator`, `database-management`

### Workflow / Testing
`quality-gate`, `spec-validator`, `quick-build-test`, `testing-automation`,
`test-workflows`, `chrome-mcp-testing`, `documentation-automation`

### Ops
`db-backup`, `db-restore`, `disaster-recovery`, `monitor-health`, `performance-test`,
`security-scan`, `deployment-workflow`, `production-deploy`

### Integration
`excel-import-patterns`, `websocket-events`

### Development
`worktree-workflow`, `subtree-sync`, `debug-ui`, `fastify-error-debugger`,
`security-best-practices`, `angular-conventions`

### Curated (from ECC)
`postgres-patterns`, `database-migrations`, `api-design`, `docker-patterns`,
`deployment-patterns`, `mcp-server-patterns`, `context-budget`, `skill-stocktake`,
`prompt-optimizer`, `click-path-audit`, `codebase-onboarding`,
`architecture-decision-records`

### Meta
`record-workflow`

## Commands (10)

At `commands/` — loaded as slash commands:
`/reflect`, `/diary`, `/review`, `/weekly`, `/eod`, `/session-status`,
`/resume`, `/feature-done`, `/cost`, `/worktree-list`

## Rules (7)

At `rules/` — reusable rule snippets for inclusion in CLAUDE.md:
`task-structure`, `context-management`, `api-first-workflow`,
`field-addition-checklist`, `ui-component-usage`, `learned-patterns-recent`,
`api-endpoints`
