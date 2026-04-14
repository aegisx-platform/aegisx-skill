#!/usr/bin/env bash
# Install aegisx-skill into an AegisX project via symlink (without /plugin).
# Usage: ./scripts/install.sh /path/to/your/aegisx-project
set -euo pipefail

TARGET="${1:-}"
if [ -z "$TARGET" ] || [ ! -d "$TARGET" ]; then
  echo "Usage: $0 /path/to/your/aegisx-project"
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$TARGET/.claude/skills/_aegisx"

mkdir -p "$(dirname "$DEST")"

if [ -L "$DEST" ] || [ -d "$DEST" ]; then
  echo "Warning: $DEST already exists. Remove or backup first."
  exit 1
fi

ln -s "$ROOT/skills" "$DEST"
echo "✓ Symlinked $DEST → $ROOT/skills"
echo
echo "Skills available:"
for tier in "$ROOT"/skills/*/; do
  count=$(ls "$tier" | wc -l | tr -d ' ')
  echo "  $(basename "$tier"): $count"
done
