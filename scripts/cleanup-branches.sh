#!/bin/bash
# Script to delete all remote branches except main
# Usage: ./scripts/cleanup-branches.sh [--dry-run]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
DRY_RUN=false
PROTECTED_BRANCH="main"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help)
            echo "Usage: $0 [--dry-run]"
            echo ""
            echo "Options:"
            echo "  --dry-run    Show what would be deleted without actually deleting"
            echo "  --help       Show this help message"
            echo ""
            echo "This script deletes all remote branches except '${PROTECTED_BRANCH}'"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

echo -e "${YELLOW}Branch Cleanup Script${NC}"
echo "================================================"
echo ""

# Fetch latest remote information
echo "Fetching latest remote information..."
git fetch --prune origin

# Get all remote branches except main and HEAD
echo ""
echo "Finding branches to delete..."
branches_to_delete=$(git branch -r | grep -v "/${PROTECTED_BRANCH}$" | grep -v "HEAD" | sed 's/origin\///' | tr -d ' ')

if [ -z "$branches_to_delete" ]; then
    echo -e "${GREEN}No branches to delete. Only '${PROTECTED_BRANCH}' exists.${NC}"
    exit 0
fi

# Display branches that will be deleted
echo ""
echo -e "${YELLOW}The following branches will be deleted:${NC}"
echo "$branches_to_delete" | while read -r branch; do
    echo "  - $branch"
done

# Count branches
branch_count=$(echo "$branches_to_delete" | wc -l)
echo ""
echo -e "${YELLOW}Total: $branch_count branch(es)${NC}"

if [ "$DRY_RUN" = true ]; then
    echo ""
    echo -e "${GREEN}DRY RUN MODE - No branches were actually deleted${NC}"
    exit 0
fi

# Confirmation prompt
echo ""
read -p "Are you sure you want to delete these branches? (yes/no): " confirmation

if [ "$confirmation" != "yes" ]; then
    echo -e "${YELLOW}Operation cancelled.${NC}"
    exit 0
fi

# Delete branches
echo ""
echo "Deleting branches..."
deleted_count=0
failed_count=0

echo "$branches_to_delete" | while read -r branch; do
    if [ -n "$branch" ]; then
        echo -n "Deleting $branch... "
        if git push origin --delete "$branch" 2>/dev/null; then
            echo -e "${GREEN}✓${NC}"
            ((deleted_count++))
        else
            echo -e "${RED}✗${NC}"
            ((failed_count++))
        fi
    fi
done

echo ""
echo -e "${GREEN}Branch cleanup completed!${NC}"
echo "Deleted: $deleted_count branch(es)"
if [ $failed_count -gt 0 ]; then
    echo -e "${RED}Failed: $failed_count branch(es)${NC}"
fi
