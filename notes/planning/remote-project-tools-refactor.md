# Remote Project Tools Refactoring Plan

## Overview

Consolidate `rtmux`, `rcode`, and the Alfred workflow into a unified `rproj` command with subcommands, eliminating code duplication and adding config file support.

## Current State

Three tools with ~80% duplicated code:
- `bin/rtmux` - Opens tmux sessions on remote projects (most complete)
- `bin/rcode` - Opens VS Code on remote projects (missing features)
- Alfred workflow - VS Code launcher with Alfred UI (JSON output)

## Target Architecture

```
~/.config/rproj/config     # Configuration file
bin/rproj                  # Unified script with subcommands
bin/rtmux                  # Thin wrapper: exec rproj tmux "$@"
bin/rcode                  # Thin wrapper: exec rproj code "$@"
Alfred workflow            # Calls: rproj list --json, rproj code
```

## Implementation Steps

### Step 1: Create Configuration System

Create `~/.config/rproj/config` with simple shell-sourceable format:

```bash
# Default remote host
RPROJ_HOST="workmbp"

# Default remote directory
RPROJ_DIR="/Users/thomas.lockney/src/metron"

# Additional hosts can be defined as:
# RPROJ_HOST_work="workmbp"
# RPROJ_DIR_work="/Users/thomas.lockney/src/metron"
```

### Step 2: Create Unified `bin/rproj` Script

**Subcommands:**
- `rproj list [--json] [-h HOST] [-d DIR]` - List projects
- `rproj tmux [-h HOST] [-d DIR] [PROJECT]` - Open tmux session
- `rproj code [-h HOST] [-d DIR] [PROJECT]` - Open VS Code
- `rproj help` - Show usage

**Shared Functions (internal):**
- `load_config()` - Read config file with fallback defaults
- `test_connection()` - SSH connectivity check
- `discover_projects()` - SSH find command
- `select_project()` - fzf interactive selection
- `log_info/success/error()` - Colored output (when not --json)

**Key Features:**
- Direct project argument skips interactive selection
- `--json` flag outputs Alfred-compatible JSON
- Config file overridden by command-line flags
- Quiet mode for Alfred (no colored output)

### Step 3: Update Alfred Workflow

**Script Filter (`remote_project_selector.sh`):**
Replace SSH/find logic with:
```bash
rproj list --json -h "$REMOTE_HOST" -d "$REMOTE_DIR" --query "$QUERY"
```

**Action Script (`open_project.sh`):**
Replace with:
```bash
rproj code --host "$host" --path "$path"
```

**Benefits:**
- Single source of truth for project discovery
- Alfred workflow becomes thin UI layer
- Configuration shared with CLI tools

### Step 4: Create Backward-Compatible Wrappers

**bin/rtmux:**
```bash
#!/usr/bin/env bash
exec rproj tmux "$@"
```

**bin/rcode:**
```bash
#!/usr/bin/env bash
exec rproj code "$@"
```

These preserve muscle memory while using unified implementation.

### Step 5: Testing & Cleanup

- Test all subcommands manually
- Test Alfred workflow integration
- Verify backward compatibility (old command-line patterns)
- Remove duplicate code from Alfred workflow scripts
- Update any documentation

## File Changes Summary

| Action | File |
|--------|------|
| CREATE | `~/.config/rproj/config` |
| CREATE | `bin/rproj` (unified script) |
| REPLACE | `bin/rtmux` (thin wrapper) |
| REPLACE | `bin/rcode` (thin wrapper) |
| MODIFY | Alfred workflow `remote_project_selector.sh` |
| MODIFY | Alfred workflow `open_project.sh` |

## Future Enhancements (JXA)

For later consideration:
- JXA-based Alfred script filter for caching
- Richer Alfred UI (icons per project type, recent projects)
- Async project loading with progress indicator

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Breaking existing workflows | Wrapper scripts maintain compatibility |
| SSH connection differences | Same SSH options as current scripts |
| Config file missing | Fallback to hardcoded defaults |

## Questions Resolved

- **Script design:** Unified command with subcommands
- **Alfred integration:** Shell script (start simple)
- **Configuration:** Config file at `~/.config/rproj/`
