#!/usr/bin/env bash
# Scaffold a new skill.
# Usage: ./scripts/add-skill.sh <tier> <skill-name>
#   tier: 01-aegisx-core | 02-workflow | 03-curated | 04-meta
set -euo pipefail

TIER="${1:-}"
NAME="${2:-}"

if [ -z "$TIER" ] || [ -z "$NAME" ]; then
  echo "Usage: $0 <tier> <skill-name>"
  echo "  tiers: 01-aegisx-core | 02-workflow | 03-curated | 04-meta"
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_DIR="$ROOT/skills/$TIER/$NAME"

if [ ! -d "$ROOT/skills/$TIER" ]; then
  echo "Error: tier '$TIER' does not exist"
  exit 1
fi

if [ -d "$SKILL_DIR" ]; then
  echo "Error: skill '$NAME' already exists at $SKILL_DIR"
  exit 1
fi

mkdir -p "$SKILL_DIR"
cat > "$SKILL_DIR/SKILL.md" <<EOF
---
name: $NAME
description: >
  TODO: Write a specific description that tells Claude WHEN to use this skill.
  List trigger keywords and phrases. Keep under 500 characters.
version: 1.0.0
---

# TODO: Skill Title

## Purpose

What problem this skill solves in 1-2 sentences.

## When to Use

- When user says "..."
- When task involves ...

## Instructions for Claude

Step-by-step or principle-based guidance.

## Examples

Real examples from the AegisX codebase.
EOF

echo "✓ Created $SKILL_DIR/SKILL.md"
echo "  Edit the frontmatter and body, then commit."
