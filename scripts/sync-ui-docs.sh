#!/usr/bin/env bash
# Sync aegisx-ui docs from main aegisx-starter repo into this skill's references/.
# Usage: ./scripts/sync-ui-docs.sh /path/to/aegisx-starter
set -euo pipefail

STARTER="${1:-}"
if [ -z "$STARTER" ] || [ ! -d "$STARTER/libs/aegisx-ui" ]; then
  echo "Usage: $0 /path/to/aegisx-starter"
  echo "  (must contain libs/aegisx-ui/docs/)"
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
UI_DOCS="$STARTER/libs/aegisx-ui/docs"

# aegisx-ui-library: component docs
LIB_REF="$ROOT/skills/01-aegisx-core/aegisx-ui-library/references"
mkdir -p "$LIB_REF"
rsync -a --delete "$UI_DOCS/components/" "$LIB_REF/components/"
for f in component-overview.md ax-kpi-card-component.md; do
  [ -f "$UI_DOCS/$f" ] && cp "$UI_DOCS/$f" "$LIB_REF/"
done
[ -f "$STARTER/libs/aegisx-ui/COMPONENT_USAGE.md" ] && \
  cp "$STARTER/libs/aegisx-ui/COMPONENT_USAGE.md" "$LIB_REF/"

# aegisx-ui-design: theming + tokens
DESIGN_REF="$ROOT/skills/01-aegisx-core/aegisx-ui-design/references"
mkdir -p "$DESIGN_REF"
for f in THEMING_GUIDE.md TOKEN_REFERENCE.md; do
  [ -f "$UI_DOCS/$f" ] && cp "$UI_DOCS/$f" "$DESIGN_REF/"
done

# aegisx-ui-types: type catalog
TYPES_REF="$ROOT/skills/01-aegisx-core/aegisx-ui-types/references"
mkdir -p "$TYPES_REF"
for f in type-catalog.md type-documentation-standards.md type-file-structure-audit.md type-migration-guide.md; do
  [ -f "$UI_DOCS/$f" ] && cp "$UI_DOCS/$f" "$TYPES_REF/"
done

# aegisx-icons: (optional) if main repo has icon registry changes
ICON_REG="$STARTER/apps/web/src/assets/icons/aegisx/aegisx-icon-registry.ts"
if [ -f "$ICON_REG" ]; then
  ICONS_REF="$ROOT/skills/01-aegisx-core/aegisx-icons/references"
  mkdir -p "$ICONS_REF"
  cp "$ICON_REG" "$ICONS_REF/aegisx-icon-registry.ts"
fi

# Git SHA for traceability
SHA=$(cd "$STARTER" && git rev-parse --short HEAD 2>/dev/null || echo "unknown")
echo
echo "✓ Synced aegisx-ui docs from $STARTER @ $SHA"
echo "  Library:  $(ls "$LIB_REF/components" 2>/dev/null | wc -l | tr -d ' ') component categories"
echo "  Design:   $(ls "$DESIGN_REF" 2>/dev/null | wc -l | tr -d ' ') files"
echo "  Types:    $(ls "$TYPES_REF" 2>/dev/null | wc -l | tr -d ' ') files"
echo
echo "Next:  git add -A && git commit -m 'sync: aegisx-ui docs @ $SHA'"
