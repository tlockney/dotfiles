# Common shell configuration for bash and zsh
# This file should be POSIX-compatible (no bash/zsh-specific syntax)
# shellcheck shell=sh

# Detect current OS
CURRENT_OS=$(uname -s)
export CURRENT_OS

# PATH helper function - prepends to PATH if directory exists and not already in PATH
prepend_path() {
  case ":$PATH:" in
    *":$1:"*) ;;  # Already in PATH
    *) [ -d "$1" ] && PATH="$1:$PATH" ;;
  esac
}

# PATH helper function - appends to PATH if directory exists and not already in PATH
append_path() {
  case ":$PATH:" in
    *":$1:"*) ;;  # Already in PATH
    *) [ -d "$1" ] && PATH="$PATH:$1" ;;
  esac
}

# User binary directories
prepend_path "$HOME/.local/bin"
prepend_path "$HOME/bin"
prepend_path "$HOME/.deno/bin" # deno-installed global tools (e.g. reading-room)

# Cargo environment
# ~/.cargo is a symlink to /Volumes/Secondary which can hang in uninterruptible
# D-state I/O wait if the volume is unresponsive. Any filesystem operation on
# the symlink (stat, test, source) will block indefinitely — perl alarm() cannot
# interrupt kernel I/O wait. So we add the path directly without touching the
# filesystem. A non-existent path on PATH is harmless.
case ":$PATH:" in
  *":$HOME/.cargo/bin:"*) ;;  # already in PATH
  *) PATH="$HOME/.cargo/bin:$PATH" ;;
esac

# Atuin shell history
if [ -d "$HOME/.atuin/bin" ]; then
  prepend_path "$HOME/.atuin/bin"
fi

# Go environment
if [ -d "$HOME/go" ]; then
  GOPATH="$HOME/go"
  export GOPATH
  prepend_path "$GOPATH/bin"
fi

# Deno environment - keep `deno install -g` global tools in ~/.deno/bin
# consistently across machines (matches the prepend_path above), rather than
# alongside the active mise-managed runtime.
export DENO_INSTALL_ROOT="$HOME/.deno"

# System-local binaries (e.g. tailscale, manually-installed tools). Appended so
# it sits behind Homebrew/mise rather than shadowing them.
append_path "/usr/local/bin"

export PATH
