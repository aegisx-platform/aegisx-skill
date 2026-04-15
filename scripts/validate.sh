#!/usr/bin/env bash
# Validate all SKILL.md frontmatter across the repo.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="$ROOT/skills"

errors=0
total=0

for skill_md in "$SKILLS_DIR"/*/SKILL.md; do
  total=$((total + 1))
  dir=$(dirname "$skill_md")
  folder_name=$(basename "$dir")

  frontmatter=$(awk '/^---$/{c++; next} c==1' "$skill_md")

  if ! echo "$frontmatter" | grep -q "^name:"; then
    echo "✗ $skill_md: missing 'name' field"
    errors=$((errors + 1))
    continue
  fi

  if ! echo "$frontmatter" | grep -q "^description:"; then
    echo "✗ $skill_md: missing 'description' field"
    errors=$((errors + 1))
    continue
  fi

  skill_name=$(echo "$frontmatter" | awk -F': ' '/^name:/ {print $2; exit}')
  if [ "$skill_name" != "$folder_name" ]; then
    echo "✗ $skill_md: name '$skill_name' != folder '$folder_name'"
    errors=$((errors + 1))
    continue
  fi
done

echo "Validated $total skills, $errors errors"
[ "$errors" -eq 0 ]
