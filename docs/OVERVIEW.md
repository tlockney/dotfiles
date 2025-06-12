# YADM Dotfiles Repository Overview

This repository contains personal dotfiles managed with [YADM](https://yadm.io/) (Yet Another Dotfiles Manager), providing a comprehensive development environment configuration that works across macOS and Linux systems.

## Repository Structure

### Core Configuration Files

#### Shell Environment (`.zshrc`)

The centerpiece of the configuration, providing:

- **Smart PATH Management**: Automatic deduplication and intelligent path ordering
- **Advanced History**: Extensive history with search, sharing, and deduplication
- **Tool Integration**: Seamless integration with modern CLI tools
- **Platform Detection**: Automatic OS and architecture detection with conditional loading
- **Performance Optimizations**: Lazy loading and conditional initialization

#### Terminal & Git

- **`.tmux.conf`**: Custom tmux configuration with backtick prefix and TPM plugin management
- **`.gitconfig`**: Git setup with conditional includes for work/personal contexts
- **`starship.toml`**: Modern, customizable shell prompt

#### Tool Management

- **`mise/config.toml`**: Version management for development tools (deno, python, node, bun, go)
- Multiple package managers supported: Homebrew, cargo, uv (Python), pnpm

### Utility Scripts (`bin/`)

#### System Maintenance

- **`tool-update`**: One-command update for all installed tools and package managers
- **`setup-tools`**: Initial development environment setup with optional dev tools

#### Development Utilities

- **`tc`**: Smart tmux session management based on current directory
- **`rcode`**: Remote VS Code connection helper
- **`get-aws-creds`**: AWS credentials management
- **`start-jupyter-session`**: Jupyter notebook launcher with conda environment support

#### Daily Tools

- **`findmyip`**: Quick IP address lookup
- **`yank`**: Cross-platform clipboard utility
- **`daily-cal-map`** & **`daily-cal-to-md`**: Calendar conversion utilities

## Key Features

### Modern CLI Tools

Replaces traditional Unix tools with modern alternatives:

- `eza` → enhanced `ls` with git integration
- `bat` → `cat` with syntax highlighting
- `ripgrep` → blazing fast grep alternative
- `fd` → user-friendly find replacement
- `atuin` → advanced shell history with sync capabilities

### Development Environment

- **Multi-language Support**: Python (via uv), Node.js, Deno, Go, Rust
- **Version Management**: mise (formerly rtx) for consistent tool versions
- **Editor Integration**: VS Code settings and extension tracking
- **Container Support**: Docker and containerd configurations

### Platform Intelligence

- Automatic detection of macOS vs Linux
- Architecture-aware configuration (x86_64 vs ARM64)
- Conditional loading based on tool availability
- Homebrew path detection for both Intel and Apple Silicon Macs

### Security & Secrets

- Integration with 1Password CLI
- AWS credentials management
- SSH and GPG configurations
- Secure handling of sensitive environment variables

## Working with This Repository

### Using YADM

```bash
# Check status of tracked files
yadm status

# Add new dotfiles
yadm add ~/.config/newapp/config

# Commit changes
yadm commit -m "feat: add newapp configuration"

# Push to remote
yadm push
```

### Updating Tools

```bash
# Update all installed tools
~/bin/tool-update

# Setup new machine
~/bin/setup-tools
```

### Directory Structure

```
~/
├── .zshrc                    # Main shell configuration
├── .tmux.conf               # Tmux configuration
├── .gitconfig               # Git configuration
├── .config/                 # Application configurations
│   ├── bat/                 # Bat (better cat) config
│   ├── atuin/              # Shell history config
│   ├── nvim/               # Neovim configuration
│   └── ...
├── .claude/                 # AI assistant configuration
├── bin/                     # Personal scripts
└── mise/                    # Tool version management
```

## Philosophy

This dotfiles setup follows several key principles:

1. **Tool Availability**: Check for tool existence before use
2. **Performance**: Lazy load where possible
3. **Portability**: Support multiple platforms seamlessly
4. **Maintainability**: Clear organization and documentation
5. **Modern Tooling**: Embrace newer, faster alternatives when beneficial

The configuration aims to provide a powerful, efficient development environment while remaining flexible enough to work across different systems and adapt to various development needs.
