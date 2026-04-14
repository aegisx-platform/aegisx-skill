# Changelog

All notable changes to `aegisx-skill` will be documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and [Semver](https://semver.org/).

## [Unreleased]

### Added
- Initial repo structure (4 tiers, commands, rules, templates, scripts, docs)
- Plugin manifest (`.claude-plugin/plugin.json`)
- Scripts: `validate.sh`, `add-skill.sh`, `sync-ui-docs.sh`, `install.sh`

## [1.0.0] - 2026-04-15

### Added

**Skills (42):**

01-aegisx-core (18):
- aegisx-cli-library, aegisx-mcp-server
- aegisx-ui-design (renamed from untitled-ui-ref + theming docs)
- aegisx-ui-library (with 35+ component references from libs/aegisx-ui/docs/)
- aegisx-ui-types (4 type catalog docs)
- aegisx-icons (59 SVG icons)
- angular-conventions, crud-generator-guide, unified-crud-validator
- layer-architecture-validator, frontend-prereq-checker
- frontend-integration-guide, backend-customization-guide
- fastify-error-debugger
- typebox-schema-generator, enum-type-generator
- api-contract-generator, api-contract-validator, api-endpoint-tester
- database-management

02-workflow (10):
- quality-gate, spec-validator, quick-build-test
- testing-automation, test-ui, test-crud, test-form
- security-best-practices, debug-ui, documentation-automation

03-curated (12) — adapted from ECC v1.9.0:
- postgres-patterns, database-migrations, api-design
- docker-patterns, deployment-patterns, mcp-server-patterns
- context-budget, skill-stocktake, prompt-optimizer
- click-path-audit, codebase-onboarding, architecture-decision-records

04-meta (2):
- design-inspiration, record-workflow

**Commands (10):**
cost, diary, eod, feature-done, reflect, resume, review,
session-status, weekly, worktree-list

**Rules (7):**
api-endpoints, api-first-workflow, context-management,
field-addition-checklist, learned-patterns-recent,
task-structure, ui-component-usage

**Templates (1):**
feature-development-strict
