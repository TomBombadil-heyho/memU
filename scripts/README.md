# Scripts

This directory contains utility scripts for repository maintenance and automation.

## cleanup-branches.sh

A script to delete all remote branches except `main`.

### Usage

```bash
# Show branches that would be deleted (dry run)
./scripts/cleanup-branches.sh --dry-run

# Delete all remote branches except main (with confirmation)
./scripts/cleanup-branches.sh

# Show help
./scripts/cleanup-branches.sh --help
```

### Using with Make

```bash
# Dry run
make cleanup-branches-dry-run

# Delete branches (requires confirmation)
make cleanup-branches
```

### Features

- **Safe**: The `main` branch is protected and will never be deleted
- **Confirmation**: Prompts for confirmation before deleting branches
- **Dry Run Mode**: Preview branches that would be deleted without making changes
- **Color Output**: Uses colored terminal output for better readability
- **Error Handling**: Reports success/failure for each branch deletion

### Example Output

```
Branch Cleanup Script
================================================

Fetching latest remote information...

Finding branches to delete...

The following branches will be deleted:
  - feat/old-feature
  - fix/old-bugfix
  - copilot/test-branch

Total: 3 branch(es)

Are you sure you want to delete these branches? (yes/no): yes

Deleting branches...
Deleting feat/old-feature... ✓
Deleting fix/old-bugfix... ✓
Deleting copilot/test-branch... ✓

Branch cleanup completed!
Deleted: 3 branch(es)
```

### When to Use

This script is useful for:
- Cleaning up old feature branches after merging PRs
- Removing experimental or copilot branches
- Maintaining a clean repository with only active branches
- Preparing for repository archival or handoff

### Important Notes

- Always run with `--dry-run` first to preview changes
- Make sure you have pushed any important work before running
- Consider protecting important branches via GitHub settings
- The script requires push permissions to the remote repository
