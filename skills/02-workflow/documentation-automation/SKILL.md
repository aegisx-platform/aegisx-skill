# Documentation Automation Skill

> Automatically generate and maintain project documentation from code comments, git commits, and API versions.

## When to Use This Skill

Use this skill when you need to:

- Generate feature documentation from JSDoc comments in TypeScript code
- Update CHANGELOG.md from git commit history
- Create versioned API documentation
- Generate migration guides between API versions
- Automate documentation as part of development workflow

## Available Tools

### 1. Feature Documentation Generator

**Purpose**: Extract JSDoc comments from TypeScript files and generate comprehensive feature documentation.

**Command**:

```bash
pnpm run docs:generate:feature [feature-name]
```

**What it does**:

- Scans TypeScript files for JSDoc comments
- Extracts documentation from controllers, services, schemas, repositories
- Generates organized markdown in `docs/features/{feature}/CODE_REFERENCE.md`
- Links back to source code with line numbers

**When to use**:

- After implementing a new feature with proper JSDoc comments
- When you want to update feature documentation
- As part of feature completion checklist

**Example**:

```bash
# Generate docs for departments feature
pnpm run docs:generate:feature departments

# Output: docs/features/departments/CODE_REFERENCE.md
```

**JSDoc Format Requirements**:

```typescript
/**
 * Brief one-line description
 *
 * Detailed description with multiple lines explaining what this does,
 * why it exists, and any important usage notes.
 *
 * @param {Type} paramName - Parameter description
 * @param {Type} anotherParam - Another parameter description
 * @returns {ReturnType} Description of return value
 *
 * @example
 * // Usage example
 * const result = await myFunction('test');
 *
 * @see {@link RelatedFunction} for related functionality
 * @throws {ErrorType} When error occurs
 */
```

### 2. Changelog Generator

**Purpose**: Generate CHANGELOG.md from git commit history using conventional commits format.

**Command**:

```bash
pnpm run docs:generate:changelog [--version VERSION] [--from REF] [--to REF]
```

**What it does**:

- Parses git commit messages following conventional commits
- Groups commits by type (feat, fix, docs, refactor, perf, test, chore)
- Generates formatted changelog with emoji prefixes
- Extracts PR numbers and breaking changes
- Updates CHANGELOG.md

**When to use**:

- Before creating a new release/tag
- After completing a sprint or milestone
- When you want to see what changed between versions

**Example**:

```bash
# Generate changelog for version 1.2.0
pnpm run docs:generate:changelog --version 1.2.0

# Generate from specific tag to HEAD
pnpm run docs:generate:changelog --from v1.0.0 --to HEAD
```

**Conventional Commit Format**:

```bash
<type>(<scope>): <subject>

<body>

<footer>
```

**Supported types**:

- `feat`: New feature (✨)
- `fix`: Bug fix (🐛)
- `docs`: Documentation changes (📚)
- `refactor`: Code refactoring (♻️)
- `perf`: Performance improvement (⚡)
- `test`: Test updates (✅)
- `chore`: Maintenance tasks (🔧)

**Example commits**:

```bash
feat(departments): add bulk import functionality
fix(auth): prevent session expiration during active use
docs(users): update profile API documentation
```

### 3. API Version Documentation

**Purpose**: Generate versioned API documentation and migration guides.

**Commands**:

```bash
# Generate docs for specific version
pnpm run docs:generate:api [--version VERSION]

# Compare two versions and generate migration guide
pnpm run docs:generate:api:compare [version1] [version2]
```

**What it does**:

- Scans route files to extract API endpoints
- Generates versioned documentation in `docs/api/versions/{version}.md`
- Compares API versions to identify changes
- Creates migration guides in `docs/api/migration-{v1}-to-{v2}.md`
- Identifies added, removed, modified, deprecated endpoints

**When to use**:

- After implementing new API endpoints
- When creating a new API version
- Before deprecating or removing endpoints
- When you need migration guides for API changes

**Example**:

```bash
# Generate docs for v2 API
pnpm run docs:generate:api --version v2

# Compare v1 and v2 to generate migration guide
pnpm run docs:generate:api:compare v1 v2
```

## Workflow Integration

### Feature Development Workflow

```bash
# 1. Develop feature with JSDoc comments
# (Write code with proper JSDoc comments)

# 2. Commit with conventional commits
git add apps/api/src/layers/platform/departments/
git commit -m "feat(departments): add bulk import functionality

Implemented bulk CSV/Excel import for departments with
validation and error handling."

# 3. Generate feature documentation
pnpm run docs:generate:feature departments

# 4. Review generated docs
cat docs/features/departments/CODE_REFERENCE.md

# 5. Commit generated docs
git add docs/features/departments/CODE_REFERENCE.md
git commit -m "docs(departments): update auto-generated feature docs"
```

### Release Workflow

```bash
# 1. Update version in package.json
npm version minor  # 1.1.0 -> 1.2.0

# 2. Generate changelog
pnpm run docs:generate:changelog --version 1.2.0

# 3. Generate API version docs
pnpm run docs:generate:api --version v1.2

# 4. Review changes
cat CHANGELOG.md
cat docs/api/versions/v1.2.md

# 5. Commit and tag
git add CHANGELOG.md docs/api/versions/v1.2.md package.json
git commit -m "chore(release): v1.2.0"
git tag v1.2.0
git push origin main --tags
```

### API Version Update Workflow

```bash
# 1. Create new API version
mkdir -p apps/api/src/api-versions/v2

# 2. Implement v2 routes
# (Write new route implementations)

# 3. Generate API docs for v2
pnpm run docs:generate:api --version v2

# 4. Compare with v1 and generate migration guide
pnpm run docs:generate:api:compare v1 v2

# 5. Review migration guide
cat docs/api/migration-v1-to-v2.md

# 6. Commit changes
git add apps/api/src/api-versions/v2/ docs/api/
git commit -m "feat(api): add v2 API with enhanced features

IMPORTANT: Authentication endpoint format has changed.
See migration guide for details."
```

## Best Practices

### JSDoc Comments

✅ **DO**:

- Write clear, concise descriptions
- Document all parameters with types
- Include usage examples for complex functions
- Link related functions with `@see`
- Document thrown errors with `@throws`
- Document all public API endpoints (controllers)
- Document core business logic methods (services)

❌ **DON'T**:

- Duplicate information (DRY)
- State the obvious
- Document private helper functions (unless complex)
- Document self-explanatory getters/setters
- Document test files

### Conventional Commits

✅ **DO**:

- Use semantic types (feat, fix, docs, etc.)
- Include scope when applicable
- Write clear, actionable subjects
- Add body for complex changes
- Reference issues/PRs in footer

❌ **DON'T**:

- Use vague messages like "update code"
- Commit unrelated changes together
- Skip the type prefix
- Use `BREAKING CHANGE:` (triggers v2.x.x release - FORBIDDEN in this project)
- Use alternative keywords: `IMPORTANT:`, `MAJOR UPDATE:`, `MIGRATION:` instead

### API Versioning

✅ **DO**:

- Use semantic versioning (semver)
- Deprecate before removing
- Provide migration guides
- Set sunset dates for old versions
- Test migrations thoroughly

❌ **DON'T**:

- Break compatibility without notice
- Remove endpoints suddenly
- Skip documentation for breaking changes

## Troubleshooting

### Feature Docs Not Generating

**Problem**: No output from `docs:generate:feature`

**Check**:

1. Verify JSDoc comment format matches the standard
2. Ensure files are in expected paths (apps/api/src/layers/platform/{feature}/)
3. Check that JSDoc comments start with `/**` not just `/*`
4. Verify function names are properly extracted

### Changelog Missing Commits

**Problem**: Some commits not appearing in CHANGELOG

**Check**:

1. Verify conventional commit format
2. Check git history: `git log --oneline`
3. Ensure commits are between specified refs
4. Verify commit messages match pattern: `type(scope): subject`

### API Docs Incomplete

**Problem**: Missing endpoints in API documentation

**Check**:

1. Verify route registration in route files
2. Ensure route files match pattern: `**/*.routes.ts`
3. Check that routes use standard Fastify methods (.get, .post, etc.)
4. Look for syntax errors in route files

## Tips for Claude

When helping users with documentation automation:

1. **Always check existing documentation first** - Read the generated docs to understand what's already documented
2. **Verify JSDoc format** - Ensure code comments follow the standard format before generating docs
3. **Check commit messages** - Verify they follow conventional commits before generating changelog
4. **Review generated output** - Always read the generated files to ensure quality
5. **Suggest improvements** - Point out missing documentation or poorly formatted comments
6. **Link related tasks** - Remind users to update docs when implementing features
7. **Automate in CI/CD** - Suggest adding these commands to GitHub Actions workflow

## Reference

For complete documentation, see:

- [Documentation Automation Guide](../../../docs/guides/development/documentation-automation.md)
- [Feature Development Standard](../../../docs/guides/development/feature-development-standard.md)
- [Git Flow & Release Guide](../../../docs/guides/infrastructure/version-management/git-flow-release-guide.md)

## Quick Reference

| Command                                        | Purpose                          | Output                                   |
| ---------------------------------------------- | -------------------------------- | ---------------------------------------- |
| `pnpm run docs:generate:feature [name]`        | Generate feature docs from JSDoc | `docs/features/{name}/CODE_REFERENCE.md` |
| `pnpm run docs:generate:changelog`             | Generate changelog from commits  | `CHANGELOG.md`                           |
| `pnpm run docs:generate:api --version [v]`     | Generate API version docs        | `docs/api/versions/{v}.md`               |
| `pnpm run docs:generate:api:compare [v1] [v2]` | Generate migration guide         | `docs/api/migration-{v1}-to-{v2}.md`     |
| `pnpm run docs:generate:all`                   | Run changelog + API docs         | Multiple files                           |
