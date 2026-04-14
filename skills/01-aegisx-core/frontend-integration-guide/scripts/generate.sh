#!/bin/bash

# Frontend Integration Helper Script
# Quick component generation from templates

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/../templates"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Frontend Integration Helper${NC}"
echo "============================"
echo ""

# Check if feature name provided
if [ -z "$1" ]; then
    echo -e "${YELLOW}Usage:${NC}"
    echo "  $0 <feature-name> [options]"
    echo ""
    echo -e "${YELLOW}Options:${NC}"
    echo "  --service-only     Generate service only"
    echo "  --list-only        Generate list component only"
    echo "  --dialog-only      Generate dialog component only"
    echo "  --types-only       Generate types only"
    echo "  --dry-run          Preview what would be generated"
    echo ""
    echo -e "${YELLOW}Examples:${NC}"
    echo "  $0 products"
    echo "  $0 categories --service-only"
    echo "  $0 users --dry-run"
    echo ""
    echo -e "${YELLOW}Available templates:${NC}"
    ls -1 "$TEMPLATES_DIR" | sed 's/^/  - /'
    exit 1
fi

FEATURE_NAME="$1"
SERVICE_ONLY=false
LIST_ONLY=false
DIALOG_ONLY=false
TYPES_ONLY=false
DRY_RUN=false

# Parse options
shift
while [[ $# -gt 0 ]]; do
    case $1 in
        --service-only)
            SERVICE_ONLY=true
            shift
            ;;
        --list-only)
            LIST_ONLY=true
            shift
            ;;
        --dialog-only)
            DIALOG_ONLY=true
            shift
            ;;
        --types-only)
            TYPES_ONLY=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}Feature:${NC} $FEATURE_NAME"
echo ""

# Recommendation
echo -e "${YELLOW}[RECOMMENDATION]${NC}"
echo "For complete component generation with proper patterns,"
echo "it's better to ask Claude directly:"
echo ""
echo -e "${GREEN}  \"Claude, create Angular components for $FEATURE_NAME\"${NC}"
echo ""
echo -e "${BLUE}Why use Claude?${NC}"
echo "  • Analyzes backend API automatically"
echo "  • Generates proper type definitions from API"
echo "  • Creates all components with correct relationships"
echo "  • Adds proper validation and error handling"
echo "  • Integrates AegisX UI components correctly"
echo "  • Follows project standards automatically"
echo ""
echo -e "${YELLOW}This script is for manual template copying only.${NC}"
echo ""

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}[DRY RUN]${NC} Would generate:"
    echo ""

    if [ "$SERVICE_ONLY" = true ]; then
        echo "  - services/${FEATURE_NAME}.service.ts"
    elif [ "$LIST_ONLY" = true ]; then
        echo "  - components/${FEATURE_NAME}-list.component.ts"
        echo "  - components/${FEATURE_NAME}-list.component.html"
    elif [ "$DIALOG_ONLY" = true ]; then
        echo "  - components/${FEATURE_NAME}-dialog.component.ts"
    elif [ "$TYPES_ONLY" = true ]; then
        echo "  - types/${FEATURE_NAME}.types.ts"
    else
        echo "  - services/${FEATURE_NAME}.service.ts"
        echo "  - types/${FEATURE_NAME}.types.ts"
        echo "  - components/${FEATURE_NAME}-list.component.ts"
        echo "  - components/${FEATURE_NAME}-list.component.html"
        echo "  - components/${FEATURE_NAME}-dialog.component.ts"
    fi

    echo ""
    echo -e "${BLUE}To execute:${NC}"
    echo "  Remove --dry-run flag"
    echo ""
    echo -e "${BLUE}Or better, use Claude:${NC}"
    echo "  \"Claude, create components for $FEATURE_NAME\""
    exit 0
fi

# Show available templates
echo -e "${YELLOW}[TEMPLATES]${NC}"
echo "Available in: $TEMPLATES_DIR"
echo ""
ls -lh "$TEMPLATES_DIR" | grep -v '^total' | awk '{print "  " $9 " (" $5 ")"}'
echo ""

# Manual copy instructions
echo -e "${YELLOW}[MANUAL COPY INSTRUCTIONS]${NC}"
echo ""
echo "1. Copy templates manually:"
echo ""

if [ "$SERVICE_ONLY" = true ]; then
    echo "   cp $TEMPLATES_DIR/service.template \\"
    echo "      apps/web/src/app/features/.../services/${FEATURE_NAME}.service.ts"
elif [ "$LIST_ONLY" = true ]; then
    echo "   cp $TEMPLATES_DIR/list.component.template \\"
    echo "      apps/web/src/app/features/.../components/${FEATURE_NAME}-list.component.ts"
    echo ""
    echo "   cp $TEMPLATES_DIR/list.component.template.html \\"
    echo "      apps/web/src/app/features/.../components/${FEATURE_NAME}-list.component.html"
elif [ "$DIALOG_ONLY" = true ]; then
    echo "   cp $TEMPLATES_DIR/form-dialog.component.template \\"
    echo "      apps/web/src/app/features/.../components/${FEATURE_NAME}-dialog.component.ts"
elif [ "$TYPES_ONLY" = true ]; then
    echo "   cp $TEMPLATES_DIR/types.template \\"
    echo "      apps/web/src/app/features/.../types/${FEATURE_NAME}.types.ts"
else
    echo "   # Service"
    echo "   cp $TEMPLATES_DIR/service.template \\"
    echo "      apps/web/src/app/features/.../services/${FEATURE_NAME}.service.ts"
    echo ""
    echo "   # Types"
    echo "   cp $TEMPLATES_DIR/types.template \\"
    echo "      apps/web/src/app/features/.../types/${FEATURE_NAME}.types.ts"
    echo ""
    echo "   # List Component"
    echo "   cp $TEMPLATES_DIR/list.component.template \\"
    echo "      apps/web/src/app/features/.../components/${FEATURE_NAME}-list.component.ts"
    echo ""
    echo "   cp $TEMPLATES_DIR/list.component.template.html \\"
    echo "      apps/web/src/app/features/.../components/${FEATURE_NAME}-list.component.html"
    echo ""
    echo "   # Dialog Component"
    echo "   cp $TEMPLATES_DIR/form-dialog.component.template \\"
    echo "      apps/web/src/app/features/.../components/${FEATURE_NAME}-dialog.component.ts"
fi

echo ""
echo "2. Replace placeholders in files:"
echo ""
echo "   [FEATURE_NAME]       → ${FEATURE_NAME}"
echo "   [FEATURE_TITLE]      → $(echo $FEATURE_NAME | sed 's/.*/\u&/')"
echo "   [ENTITY_NAME]        → $(echo $FEATURE_NAME | sed 's/.*/\u&/' | sed 's/s$//')"
echo "   [feature]            → ${FEATURE_NAME}"
echo "   [feature-name]       → ${FEATURE_NAME}"
echo ""
echo "3. Customize logic as needed"
echo ""
echo -e "${YELLOW}[BETTER APPROACH]${NC}"
echo ""
echo "Instead of manual copying, use Claude for intelligent generation:"
echo ""
echo -e "${GREEN}  \"Claude, use frontend-integration-guide to create ${FEATURE_NAME} components\"${NC}"
echo ""
echo "Claude will:"
echo "  ✓ Read your backend API"
echo "  ✓ Generate proper types from API schema"
echo "  ✓ Create service with correct endpoints"
echo "  ✓ Build components with proper validation"
echo "  ✓ Add error handling automatically"
echo "  ✓ Integrate AegisX UI components"
echo ""
echo -e "${GREEN}Done!${NC}"
