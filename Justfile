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

# Provision system (setup and updates)
provision *ARGS:
    ~/bin/provision {{ ARGS }}

# First-time setup (runs only setup tasks)
setup *ARGS:
    ~/bin/provision --setup-only {{ ARGS }}

# Preview what would be updated (dry-run)
check:
    ~/bin/provision --check

# Provision only homebrew packages
homebrew:
    ~/bin/provision --tags homebrew

# Provision only mise-managed tools
mise:
    ~/bin/provision --tags mise

# Provision rust toolchain and cargo packages
rust:
    ~/bin/provision --tags rust

# Provision uv-managed Python tools
uv:
    ~/bin/provision --tags uv

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

# Provision without dev tools (minimal setup)
minimal:
    ~/bin/provision --no-dev
