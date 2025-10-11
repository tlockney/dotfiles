# Personal Utility Scripts

This directory contains personal utility scripts that are part of my dotfiles setup. These scripts are added to my PATH through `~/bin` and provide various development and system administration utilities.

## System Setup and Maintenance

### `bootstrap`

**Purpose:** Initial system setup script for fresh installations
**Usage:** `bootstrap [--dev]`
**Description:**

- Installs uv package manager if not present
- Runs Ansible playbook to set up all development tools
- Use `--dev` flag to include development tools (Python, Jupyter, etc.)
- This is the first script to run on a new system

### `tool-update`

**Purpose:** Update all development tools and package managers
**Usage:** `tool-update [OPTIONS]`
**Flags:**

- `--check`: Show what would be updated (dry-run)
- `--diff`: Show changes that would be made
- `--tags <tag>`: Update only specific tools (e.g., `homebrew`, `mise`)
- `--dev`: Include dev tools in updates
- `-v`: Verbose output

**Description:** Wrapper around Ansible playbook for convenient daily/weekly tool updates.

## File and System Utilities

### `findmyip`

**Purpose:** Display current public IP address
**Usage:** `findmyip`
**Description:** Quick utility to fetch and display your external IP address.

### `unlock-keychain`

**Purpose:** Unlock macOS login keychain
**Usage:** `unlock-keychain`
**Description:** Unlocks the login keychain, useful for automation scripts that need keychain access.

## Development Utilities

### `check-env`

**Purpose:** Validate environment setup and configuration
**Usage:** `check-env`
**Description:** Comprehensive environment checker that validates:

- Required tools are installed
- Configuration files are present
- Environment variables are set correctly
- System dependencies are available

### `lint-shell`

**Purpose:** Lint all shell scripts in the repository
**Usage:** `lint-shell`
**Description:**

- Uses shellcheck to validate shell scripts
- Finds and checks all shell scripts in the repository
- Requires shellcheck to be installed

### `rcode`

**Purpose:** Open files or directories in VS Code from terminal
**Usage:** `rcode [path]`
**Description:** Wrapper for launching VS Code with specific configurations or from remote sessions.

### `tc`

**Purpose:** Terminal color and capability testing
**Usage:** `tc`
**Description:** Tests terminal color support and displays color capabilities for debugging terminal configurations.

## tmux Utilities

### `rtmux`

**Purpose:** Remote tmux session selector
**Usage:** `rtmux [OPTIONS] [PROJECT_NAME|REMOTE_HOST]`
**Flags:**

- `-d DIR`: Remote base directory
- `-p NAME`: Project name (skip selection)
- `-h`: Show help

**Description:** Quickly select and open/attach to tmux sessions for remote projects via SSH.

### `tmux-session-menu`

**Purpose:** Interactive tmux session switcher
**Usage:** `tmux-session-menu`
**Description:** Displays a tmux menu of all active sessions for quick switching between sessions.

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

## Library Files

### `lib/common.sh`

**Purpose:** Shared utilities and functions for shell scripts
**Description:** Common library functions used across multiple scripts. Source this file in scripts that need shared functionality.

---

## Installation Notes

These scripts are automatically available when the dotfiles are installed via YADM, as `~/bin` is added to the PATH in the shell configuration. Most scripts include built-in help and error handling.

For platform-specific functionality, scripts detect the operating system and adjust behavior accordingly (macOS vs Linux).
