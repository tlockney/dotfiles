# Personal Utility Scripts

This directory contains personal utility scripts that are part of my dotfiles setup. These scripts are added to my PATH through `~/bin` and provide various development and system administration utilities.

## Core Tool Management

### `tool-manager`

**Purpose:** Unified tool installation and update management
**Usage:** `tool-manager [options]`
**Flags:**

- `--setup`: Install missing tools and update existing ones
- `--dev`: Include development tools (Python, Jupyter, etc.)
- `--force-install`: Force reinstall all tools
- `--help`: Show usage information

**Description:** Combined tool management script that handles both installation and updates:
- Default behavior: Update existing tools only
- With `--setup`: Install missing tools and update existing ones
- Manages: Homebrew, Rust, mise, Deno, Node, Python, UV tools, and more
- Smart detection of what needs installing vs updating

### `tool-update` (Legacy)

**Purpose:** Updates all installed development tools and package managers
**Usage:** `tool-update`
**Description:** Original update script (kept for compatibility). Use `tool-manager` for new workflows.

### `setup-tools` (Legacy)

**Purpose:** Initial setup and installation of development tools
**Usage:** `setup-tools [--dev] [--help]`
**Description:** Original setup script (kept for compatibility). Use `tool-manager --setup` for new workflows.

## File and System Utilities

### `yank`

**Purpose:** Copy file contents or stdin to system clipboard via OSC 52 escape sequences
**Usage:** `yank [FILE...]`
**Description:**

- Copies to terminal clipboard and tmux buffer if in tmux session
- Works over SSH connections
- Limit: 74,994 bytes of input (base64 encoding overhead)
- Useful for copying text in terminal-only environments

### `findmyip`

**Purpose:** Display current public IP address
**Usage:** `findmyip`
**Description:** Quick utility to fetch and display your external IP address.

### `remount.scpt`

**Purpose:** AppleScript for remounting network drives
**Usage:** Run from Finder or via `osascript`
**Description:** macOS-specific script for reconnecting to network shares.

## Development Utilities

### `tc`

**Purpose:** Terminal color and capability testing
**Usage:** `tc`
**Description:** Tests terminal color support and displays color capabilities for debugging terminal configurations.

### `rcode`

**Purpose:** Open files or directories in VS Code from terminal
**Usage:** `rcode [path]`
**Description:** Wrapper for launching VS Code with specific configurations or from remote sessions.

### `start-jupyter-session`

**Purpose:** Launch Jupyter Lab/Notebook with optimal settings
**Usage:** `start-jupyter-session`
**Description:** Starts Jupyter with predefined configurations for data science work.

## Cloud and Security Tools

### `get-aws-creds`

**Purpose:** Retrieve AWS credentials from 1Password or other secure sources
**Usage:** `get-aws-creds [profile]`
**Description:** Securely fetches AWS credentials and configures them for CLI use.

### `ssh-1p-toggle`

**Purpose:** Toggle 1Password SSH agent integration
**Usage:** `ssh-1p-toggle`
**Description:** Enables/disables 1Password as SSH agent for secure key management.

### `sync-secrets`

**Purpose:** Synchronize secrets and credentials across systems
**Usage:** `sync-secrets`
**Description:** Safely syncs encrypted secrets and configuration files.

## Calendar and Productivity

### `daily-cal-map`

**Purpose:** Generate calendar activity visualization
**Usage:** `daily-cal-map`
**Description:** Creates visual calendar maps for productivity tracking.

### `daily-cal-to-md`

**Purpose:** Convert calendar data to Markdown format
**Usage:** `daily-cal-to-md`
**Description:** Exports calendar information as Markdown for documentation.

## Environment and Validation

### `check-env`

**Purpose:** Validate environment setup and configuration
**Usage:** `check-env`
**Description:** Comprehensive environment checker that validates:

- Required tools are installed
- Configuration files are present
- Environment variables are set correctly
- System dependencies are available

---

## Installation Notes

These scripts are automatically available when the dotfiles are installed via YADM, as `~/bin` is added to the PATH in the shell configuration. Most scripts include built-in help and error handling.

For platform-specific functionality, scripts detect the operating system and adjust behavior accordingly (macOS vs Linux).
