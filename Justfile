# Justfile for dotfiles management
# Run `just --list` to see all available commands

# Default recipe shows help
default:
    @just --list

# Run environment sanity checks
check:
    ~/bin/check-env

# Lint all shell scripts with shellcheck
lint:
    ~/bin/lint-shell

# Bootstrap a fresh system (first-time setup)
bootstrap *ARGS:
    ~/bin/bootstrap {{ ARGS }}

# Update all development tools
update *ARGS:
    tool-update {{ ARGS }}

# Preview what would be updated (dry-run)
update-check:
    tool-update --check

# Update only homebrew packages
update-homebrew:
    tool-update --tags homebrew

# Update only mise-managed tools
update-mise:
    tool-update --tags mise

# Update rust toolchain and cargo packages
update-rust:
    tool-update --tags rust

# Update uv-managed Python tools
update-uv:
    tool-update --tags uv

# Sync 1Password secrets to dotfiles
sync-secrets:
    ~/bin/sync-secrets

# Update shell completions
update-completions:
    ~/.config/zsh/update-completions.sh

# Show mise-managed tool versions
mise-list:
    mise ls

# Show what files are tracked by yadm (when in home directory)
yadm-list:
    yadm ls-files

# Show yadm status (when in home directory)
yadm-status:
    yadm status

# Run git status (when in git worktree)
git-status:
    git status

# Install dev tools with bootstrap
bootstrap-dev:
    ~/bin/bootstrap --dev

# Update with dev tools included
update-dev:
    tool-update --dev
