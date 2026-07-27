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
- **Automated setup**: Ansible-based tool management with `provision`
- **Cross-platform**: Works on macOS (Intel & Apple Silicon) and Linux

### Shell Configuration

- **Modular zsh setup**: Organized into logical modules for maintainability
- **Performance optimized**: Lazy loading and efficient initialization
- **Starship prompt**: Fast, customizable prompt with git integration
- **Smart completions**: Pre-generated completions for faster shell startup

## Prerequisites

### macOS

```sh
# Install Homebrew (will prompt for Xcode CLI tools if needed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install prerequisites
/opt/homebrew/bin/brew install tmux 1password-cli
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

# 4. Run provision to install all tools
~/bin/provision              # Full setup (dev tools included by default)
~/bin/provision --no-dev     # Minimal setup without dev tools
~/bin/provision --setup-only # First-time setup tasks only
```

**Note:** The `op signin` step is required because yadm bootstrap calls `sync-secrets`, which injects credentials from 1Password into config files.

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

### Development Workflow

Each piece of work gets its own worktree on its own branch.
`~/src/personal/dotfiles` is the launcher: a checkout kept detached at
`origin/main`, used to read the tree and start tasks from, never to edit in.
Detached rather than on a branch for two reasons — a linked worktree cannot
check out `main`, because `$HOME` already has it, and having no branch there
means there is nowhere for a stray edit to accumulate.

```sh
# From ~/src/personal/dotfiles — start a task
just worktree <task>
cd ../dotfiles-worktrees/<task>

# ... edit, then validate before anything reaches $HOME ...
just check

git add -- <specific paths>
git commit
git push -u origin <task>
gh pr create --base main
```

After the PR merges, apply it to the live dotfiles and clean up:

```sh
# From $HOME — this is the yadm main worktree, checked out on main
yadm fetch && yadm merge origin/main

# From ~/src/personal/dotfiles
just worktree-done <task>     # removes the worktree, deletes the branch,
                              # and re-parks this checkout at origin/main
```

`just worktree` handles the `mise trust` step for you, which matters because
**it is not optional**. This repo ships `.config/mise/config.toml`, so mise
treats any checkout of it as a project config — and refuses to run until that
specific path is trusted. A newly created worktree is untrusted by default,
and until you trust it every mise-shimmed binary (`python3`, `node`, `uvx`, …)
exits 1 with a trust error instead of running. The symptom is confusing,
because the failure surfaces wherever the shim was called rather than as
anything about mise.

Conventions worth keeping to:

- **Branch from `origin/main`, not from whatever is checked out.** Worktrees
  are cheap precisely because they don't inherit each other's state.
- **Stage with explicit paths.** `git add -- <paths>` then `git commit`, never a
  bare `git commit` after a `git rm` — a bare commit takes the whole index and
  will quietly sweep unrelated staged changes into your commit.
- **Never `git checkout main` in a linked worktree.** `main` is checked out by
  the yadm main worktree at `$HOME`; git will refuse, and forcing it is how you
  end up with `$HOME` on a detached HEAD.
- **`just check` before pushing.** It runs exactly what CI runs, against the
  checkout you are standing in, so a shell that would fail to start is caught
  before `yadm merge` rather than after.
- **One worktree per task, removed when merged.** `git worktree list` should be
  short; stale worktrees hold branch checkouts and get stale silently.

Why not edit directly in `$HOME`? It is the yadm main worktree on `main`, so
there is no staging step between an edit and your live environment — a broken
`.zshrc` locks you out of new terminals immediately.

### Tool Management

The repository includes automated tool management via Ansible:

```sh
# Full provisioning (dev tools included by default)
provision

# Preview what would change (dry-run)
provision --check

# First-time setup only (limited to setup tasks)
provision --setup-only

# Provision specific category
provision --tags homebrew
provision --tags mise

# Minimal setup without dev tools
provision --no-dev

# Force server mode (CLI-only tools, no desktop apps)
provision --extra-vars "is_desktop=false"
```

**Desktop vs Server Detection:**
- macOS is always treated as a desktop system
- Linux auto-detects based on systemd target (`graphical.target` = desktop)
- Desktop systems get full GUI apps (VS Code, 1Password app)
- Server systems get CLI-only tools (VS Code CLI, 1Password CLI)
- Override with `--extra-vars "is_desktop=true"` or `"is_desktop=false"`

To add new tools, edit `.config/dotfiles/playbook.yml`. To change runtime versions (node, python, etc.), edit `.mise.toml`.

### Checks

`just check` runs the same checks CI runs, against the checkout you are
standing in. Run it before pushing.

```sh
just check            # everything
just check shell      # one section: syntax | configs | shell | emacs | ansible
```

| Section | What it does |
|---|---|
| `syntax` | `zsh -n` over the zsh files, `bash -n` over the bash and sh files |
| `configs` | TOML, YAML, JSON and Lua parse checks (VS Code's JSONC included) |
| `shell` | Stages the tracked shell config into an empty `HOME` and actually starts `zsh -i`, `zsh -l` and `bash -l` there |
| `emacs` | Boots `init.el` against an empty init-directory, the way a new machine does |
| `ansible` | `--syntax-check` on the provisioning playbook |

The `shell` section is the one that earns its keep: it catches an unguarded
`source` of a file that happens to exist on this machine but not on a fresh
one, which is a class of bug no syntax-level tool can see. A check whose tool
is missing reports `SKIP` rather than passing, and the script refuses to
report success if it matched no files at all.

`~/bin/lint-shell` still runs shellcheck over `bin/`, as an advisory local
tool. It is not part of CI: shellcheck cannot parse zsh, which is what most of
this configuration is written in.

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

### Raycast

Custom Raycast extension source lives in `~/.config/raycast-extensions/`
(see [toolbox/README.md](.config/raycast-extensions/toolbox/README.md)).
Raycast's own directory (`~/.config/raycast/`) contains credentials and
build artifacts and is intentionally untracked; app settings travel via
Raycast's Export/Import or Cloud Sync, not this repo.

### Cross-Platform Support

Scripts should handle both macOS and Linux:
- Use platform conditionals: `if [ "$CURRENT_OS" = "Darwin" ]`
- Test commands exist before execution: `command -v tool_name`
- Provide fallbacks for missing tools
- Shared profile settings in `~/.config/shell/common-profile.sh` (sourced by both `.profile` and `.zprofile`)

## Using Claude Code (or similar tools) to work on these files

Since yadm places all the files in situ, it's unlikely going to be a good idea to run `claude` in your home directory. Instead, run it in this checkout and follow the standard development workflow:

1. `cd ~/src/personal/dotfiles` (or wherever this repo is checked out)
2. Start a task worktree: `just worktree <task>`, then `cd` into the path it prints.
3. Run `claude` there and make whatever changes you need.
4. Run `just check`, then commit and push with standard `git` commands and open a PR.
5. After it merges, apply to your home directory: `yadm fetch && yadm merge origin/main`

Run `claude` in the task worktree, not in `~/src/personal/dotfiles` itself —
that checkout is detached at `origin/main` and is only there to read from and
launch tasks from.
