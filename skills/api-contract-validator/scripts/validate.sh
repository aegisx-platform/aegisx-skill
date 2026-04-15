#!/bin/bash

# API Contract Validator Helper Script
# Usage: ./validate.sh [feature-name]

set -e

FEATURE=$1
PROJECT_ROOT=$(pwd)
DOCS_DIR="$PROJECT_ROOT/docs/features"
API_DIR="$PROJECT_ROOT/apps/api/src"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== API Contract Validator ===${NC}"

if [ -z "$FEATURE" ]; then
  echo -e "${RED}Error: Feature name required${NC}"
  echo "Usage: $0 <feature-name>"
  echo ""
  echo "Available features:"
  find "$DOCS_DIR" -name "API_CONTRACTS.md" -type f | while read -r file; do
    feature=$(basename "$(dirname "$file")")
    echo "  - $feature"
  done
  exit 1
fi

CONTRACT_FILE="$DOCS_DIR/$FEATURE/API_CONTRACTS.md"

if [ ! -f "$CONTRACT_FILE" ]; then
  echo -e "${RED}Error: Contract file not found: $CONTRACT_FILE${NC}"
  exit 1
fi

echo -e "${GREEN}✓ Contract found:${NC} $CONTRACT_FILE"
echo ""

# Extract endpoints from contract (simplified - Claude will do detailed parsing)
echo -e "${BLUE}Endpoints in contract:${NC}"
grep -E "^(GET|POST|PUT|PATCH|DELETE)\s+" "$CONTRACT_FILE" || echo "No endpoints found in contract"
echo ""

# Find route files
echo -e "${BLUE}Searching for route implementation...${NC}"
ROUTE_FILES=$(find "$API_DIR" -type f -name "*${FEATURE}*.routes.ts" 2>/dev/null || true)

if [ -z "$ROUTE_FILES" ]; then
  echo -e "${YELLOW}⚠ No route files found matching: *${FEATURE}*.routes.ts${NC}"
  echo ""
  echo "Searching for feature references in plugin.loader.ts..."
  grep -n "$FEATURE" "$API_DIR/bootstrap/plugin.loader.ts" 2>/dev/null || echo "No references found"
else
  echo -e "${GREEN}✓ Route files found:${NC}"
  echo "$ROUTE_FILES" | while read -r file; do
    echo "  - $file"
  done
fi

echo ""
echo -e "${BLUE}=== Validation Complete ===${NC}"
echo "Run Claude with: 'Validate the $FEATURE API against its contract'"
