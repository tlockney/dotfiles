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

# User binary directories
prepend_path "$HOME/.local/bin"
prepend_path "$HOME/bin"

# Rust/Cargo environment
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

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

export PATH
