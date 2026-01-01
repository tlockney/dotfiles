# My Dotfiles

Personal dotfiles managed with [YADM](https://yadm.io/), providing a modern development environment that works across macOS and Linux.

## Key Features

### Modern CLI Tools

Replaces traditional Unix tools with faster, more user-friendly alternatives:

- **eza** - Enhanced `ls` with git integration and colors
- **bat** - `cat` with syntax highlighting and git integration
- **ripgrep** - Blazing fast search (better than grep)
- **fd** - User-friendly file finder (better than find)
- **atuin** - Advanced shell history with search and sync

### Development Environment

- **Multi-language support**: Python (uv), Node.js, Deno, Go, Rust
- **Version management**: mise for consistent tool versions across projects
- **Automated setup**: Ansible-based tool management with `bootstrap` and `tool-update`
- **Cross-platform**: Works on macOS (Intel & Apple Silicon) and Linux

### Shell Configuration

- **Modular zsh setup**: Organized into logical modules for maintainability
- **Performance optimized**: Lazy loading and efficient initialization
- **Starship prompt**: Fast, customizable prompt with git integration
- **Smart completions**: Pre-generated completions for faster shell startup

## Prerequisites

### macOS

```sh
# Install Xcode command line tools
xcode-select --install

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install prerequisites
/opt/homebrew/bin/brew install tmux

# Install 1Password CLI (required for secret sync during bootstrap)
/opt/homebrew/bin/brew tap 1password/tap
/opt/homebrew/bin/brew install 1password-cli
```

### Linux

```sh
# Install base packages
sudo apt install zsh tmux git curl gpg

# Set zsh as default shell
chsh -s /usr/bin/zsh

# Install 1Password CLI (required for secret sync during bootstrap)
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
  sudo tee /etc/apt/sources.list.d/1password.list
sudo apt update && sudo apt install 1password-cli
```

## Installation

```sh
# 1. Sign into 1Password CLI (required for secret sync)
eval $(op signin)

# 2. Install yadm
mkdir -p ~/.local/bin
curl -fLo ~/.local/bin/yadm https://github.com/yadm-dev/yadm/raw/master/yadm && chmod a+x ~/.local/bin/yadm

# 3. Clone dotfiles (runs yadm bootstrap, which syncs secrets)
~/.local/bin/yadm clone https://github.com/tlockney/dotfiles.git

# 4. Run full bootstrap to install all tools
~/bin/bootstrap        # Standard setup
~/bin/bootstrap --dev  # Include dev tools (optional)
```

**Note:** The `op signin` step is required because the yadm bootstrap calls `sync-secrets`, which injects credentials from 1Password into config files.

## Tips

 - Get all currently tracked files:

```sh
yadm ls-files
```

 - Run 1password secret injection on all `.op_tpl` files:

```sh
for file in $(cd $HOME; yadm ls-files | grep '.op_tpl'); do
  out=${file%%.op_tpl}
  op inject -i $HOME/$file -o $HOME/$out
done
```

## Development

### YADM vs Git Commands

**IMPORTANT:** Command usage depends on your working directory:

**When in home directory (`~/`):**
- Use `yadm status`, `yadm add`, `yadm commit` commands
- YADM manages files in their installed locations

**When in a git checkout (e.g., `~/src/personal/yadm-dotfiles`):**
- Use standard `git status`, `git add`, `git commit` commands
- YADM commands will NOT work here

### Tool Management

The repository includes automated tool management via Ansible:

```sh
# Fresh system setup (first time)
bootstrap

# Update all installed tools
tool-update

# Preview what would be updated (dry-run)
tool-update --check

# Update specific category
tool-update --tags homebrew
tool-update --tags mise

# Include dev tools in update
tool-update --dev

# Force server mode (CLI-only tools, no desktop apps)
tool-update --extra-vars "is_desktop=false"
```

**Desktop vs Server Detection:**
- macOS is always treated as a desktop system
- Linux auto-detects based on systemd target (`graphical.target` = desktop)
- Desktop systems get full GUI apps (VS Code, 1Password app)
- Server systems get CLI-only tools (VS Code CLI, 1Password CLI)
- Override with `--extra-vars "is_desktop=true"` or `"is_desktop=false"`

To add new tools, edit `.config/dotfiles/playbook.yml`. To change runtime versions (node, python, etc.), edit `.mise.toml`.

### Shell Script Linting

All shell scripts should pass shellcheck:

```sh
~/bin/lint-shell
```

## Repository Structure

### Zsh Configuration

The zsh configuration is modular, split into `~/.config/zsh/`:
- `init.zsh` - Basic setup, completion system, keybindings
- `path.zsh` - PATH manipulation
- `history.zsh` - History configuration
- `completions.zsh` - Completion styles
- `prompt.zsh` - Prompt configuration
- `tools.zsh` - Tool initialization and environment
- `aliases.zsh` - Shell aliases

The main `.zshrc` simply loads these modular files. Completions are managed by `~/.config/zsh/update-completions.sh` and not generated on every shell startup.

### Shell Script Conventions

All scripts in `bin/` should follow these conventions:
- Start with `#!/usr/bin/env bash` and `set -euo pipefail`
- Use descriptive variable and function names
- Use 4-space indentation
- Check for command existence using `command -v` (POSIX-compliant)
- Include comments for complex operations

### Cross-Platform Support

Scripts should handle both macOS and Linux:
- Use platform conditionals: `if [ "$CURRENT_OS" = "Darwin" ]`
- Test commands exist before execution: `command -v tool_name`
- Provide fallbacks for missing tools
- Shared profile settings in `~/.config/shell/common-profile.sh` (sourced by both `.profile` and `.zprofile`)

## Using Claude Code (or similar tools) to work on these files

Since yadm places all the files in situ, it's unlikely going to be a good idea to
run `claude` in your home directory. Here's how to make this manageable.

1. Run `yadm worktree add -b claude-updates ~/src/personal/yadm-dotfiles`
2. `cd ~/src/personal/yadm-dotfiles`
3. Run `claude` and ask it to make whatever changes you deem appropriate.
4. `git commit -a -m "claude made some changes"`
5. yadm merge claude-updates

If you want to keep the `claude-updates` directory around, just be sure to run
`git merge main` before doing anything so it has the latest version of the code.
