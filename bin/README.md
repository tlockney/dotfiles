# Personal Utility Scripts

This directory contains personal utility scripts that are part of my dotfiles setup. These scripts are added to my PATH through `~/bin` and provide various development and system administration utilities.

## System Setup and Maintenance

### `provision`

**Purpose:** System setup and maintenance via Ansible
**Usage:** `provision [OPTIONS]`
**Flags:**

- `--no-dev`: Exclude dev tools (dev tools included by default)
- `--setup-only`: Run only initial setup tasks (for first-time bootstrap)
- `--check`: Show what would be updated (dry-run)
- `--diff`: Show changes that would be made
- `--tags <tag>`: Run only specific tags (e.g., `homebrew`, `mise`, `rust`, `uv`)
- `--no-sudo`: Skip sudo password prompt (for passwordless sudo)
- `--extra-vars "key=value"`: Pass variables to Ansible (e.g., `is_desktop=false`)
- `-v`: Verbose output

**Desktop vs Server Mode:**

The playbook auto-detects desktop vs server environments:
- macOS: Always treated as desktop
- Linux: Detects via systemd target (`graphical.target` = desktop)

Desktop systems install full GUI apps (VS Code, 1Password). Server systems install CLI-only versions. Override with `--extra-vars "is_desktop=false"`.

**Description:** Unified script that handles both initial setup and ongoing maintenance. Installs uv if not present.

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

### `tc`

**Purpose:** Create or attach to a tmux session named after the current directory
**Usage:** `tc`
**Description:** If a tmux session with the current directory's name exists, attaches to it. Otherwise, creates a new session with that name. Useful for project-based tmux workflows.

## tmux Utilities

### `tmux-session-menu`

**Purpose:** Interactive tmux session switcher
**Usage:** `tmux-session-menu`
**Description:** Displays a tmux menu of all active sessions for quick switching between sessions.

## Remote Development

### `rproj`

**Purpose:** Unified remote project tool for listing, opening in tmux, or opening in VS Code
**Usage:** `rproj <command> [options] [project]`
**Commands:**

- `list`: List remote projects (supports `--json` for Alfred integration)
- `tmux`: Open tmux session for a remote project
- `code`: Open VS Code for a remote project
- `open`: Open project from Alfred (uses `host|path` format)

**Options:**

- `-h, --host HOST`: Remote host (configurable via `~/.config/rproj/config`)
- `-d DIR`: Remote base directory
- `-p NAME`: Project name (skip interactive fzf selection)
- `--json`: Output as Alfred-compatible JSON (list command)
- `-q QUERY`: Filter projects by query (with --json)

**Description:** Discovers projects on a remote host via SSH and provides interactive selection with fzf. Integrates with Alfred workflows for quick project access.

### `rtmux`

**Purpose:** Open tmux session for a remote project
**Usage:** `rtmux [options] [project]`
**Description:** Thin wrapper that delegates to `rproj tmux`. Maintained for backward compatibility.

### `rcode`

**Purpose:** Open VS Code for a remote project
**Usage:** `rcode [options] [project]`
**Description:** Thin wrapper that delegates to `rproj code`. Maintained for backward compatibility.

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

## Media and Document Utilities

### `grab-yt-audio`

**Purpose:** Download audio from YouTube videos
**Usage:** `grab-yt-audio <url>`
**Description:** Downloads the best available audio from a YouTube URL and converts to MP3. Requires yt-dlp.

### `grab-yt-video`

**Purpose:** Download video from YouTube
**Usage:** `grab-yt-video <url>`
**Description:** Downloads the best available video and audio from a YouTube URL. Requires yt-dlp.

### `md2pdf`

**Purpose:** Convert Markdown files to PDF
**Usage:** `md2pdf <input.md>`
**Description:** Converts GitHub-flavored Markdown to PDF via an intermediate Word document. Requires pandoc and docx2pdf (installed via uvx).

## Library Files

### `lib/common.sh`

**Purpose:** Shared utilities and functions for shell scripts
**Description:** Common library functions used across multiple scripts. Source this file in scripts that need shared functionality.

---

## Installation Notes

These scripts are automatically available when the dotfiles are installed via YADM, as `~/bin` is added to the PATH in the shell configuration. Most scripts include built-in help and error handling.

For platform-specific functionality, scripts detect the operating system and adjust behavior accordingly (macOS vs Linux).
