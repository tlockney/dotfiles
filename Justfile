# Justfile for dotfiles management
# Run `just --list` to see all available commands

# Default recipe shows help
default:
    @just --list

# Run environment sanity checks
check-env:
    ~/bin/check-env

# Start a task: new worktree on its own branch off origin/main, ready to use
worktree NAME:
    #!/usr/bin/env bash
    set -euo pipefail
    root="$(git rev-parse --show-toplevel)"
    parent="$(dirname "$root")"
    # Works whether this is run from the launcher checkout or from another task
    # worktree, which already sits inside dotfiles-worktrees/.
    case "$(basename "$parent")" in
        dotfiles-worktrees) dest="$parent/{{ NAME }}" ;;
        *)                  dest="$parent/dotfiles-worktrees/{{ NAME }}" ;;
    esac
    if [ -e "$dest" ]; then echo "already exists: $dest" >&2; exit 1; fi
    git fetch -q origin
    git worktree add "$dest" -b "{{ NAME }}" origin/main
    # Without this every mise-shimmed binary refuses to run in the new checkout.
    if command -v mise >/dev/null; then (cd "$dest" && mise trust >/dev/null); fi
    echo
    echo "  cd $dest"

# Finish a task: remove its worktree and branch, re-park this checkout at origin/main
worktree-done NAME:
    #!/usr/bin/env bash
    set -euo pipefail
    root="$(git rev-parse --show-toplevel)"
    parent="$(dirname "$root")"
    # Works whether this is run from the launcher checkout or from another task
    # worktree, which already sits inside dotfiles-worktrees/.
    case "$(basename "$parent")" in
        dotfiles-worktrees) dest="$parent/{{ NAME }}" ;;
        *)                  dest="$parent/dotfiles-worktrees/{{ NAME }}" ;;
    esac
    [ -d "$dest" ] && git worktree remove "$dest"
    git fetch -q origin
    # -d, never -D: refuses if the branch was not merged, which is the point.
    git branch -d "{{ NAME }}" 2>/dev/null || echo "branch {{ NAME }} not deleted (unmerged?)"
    # Re-park only the launcher checkout, and only when it has nothing to lose.
    # Run from another task worktree this would detach that worktree instead,
    # which is not what anyone means by "done with {{ NAME }}".
    if [ "$(basename "$parent")" = "dotfiles-worktrees" ]; then
        echo "not re-parking: this is a task worktree, not the launcher"
    elif ! git diff --quiet || ! git diff --cached --quiet; then
        echo "not re-parking: uncommitted changes in $root"
    else
        git checkout -q --detach origin/main
        echo "re-parked at origin/main ($(git rev-parse --short HEAD))"
    fi

# Run the same checks CI runs (syntax, config parsing, shell startup, emacs, ansible)
# Deliberately ./bin, not ~/bin: this validates the checkout you are standing
# in, so it does the right thing from a worktree. The other recipes below use
# ~/bin because they act on the live system instead.
check *SECTION:
    ./bin/check-dotfiles {{ SECTION }}

# Lint all shell scripts with shellcheck (advisory; not run in CI)
lint:
    ~/bin/lint-shell

# Provision system (setup and updates)
provision *ARGS:
    ~/bin/provision {{ ARGS }}

# First-time setup (runs only setup tasks)
setup *ARGS:
    ~/bin/provision --setup-only {{ ARGS }}

# Preview what would be updated (dry-run)
dry-run:
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

# Build the Obsidian quick capture dialog (macOS only)
build-capture-dialog:
    @mkdir -p ~/.local/bin
    xcrun swiftc -o ~/.local/bin/obsidian-capture-dialog ~/.config/obsidian-capture/dialog.swift -framework Cocoa
    @echo "Built ~/.local/bin/obsidian-capture-dialog"
