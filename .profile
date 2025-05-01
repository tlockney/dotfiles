# Common profile settings for all POSIX-compatible shells
# This file is sourced by login shells

# Detect OS and architecture for platform-specific settings
export CURRENT_OS=$(uname -s)
export CURRENT_ARCH=$(uname -m)

# Set up XDG runtime directory if not already set
if [ -z "$XDG_RUNTIME_DIR" ]; then
  XDG_RUNTIME_DIR=/run/user/$(id -u)
  if [ -d "$XDG_RUNTIME_DIR" ] && [ -w "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR
  else
    unset XDG_RUNTIME_DIR
  fi
fi

# Ensure PATH includes user's private bin directories
if [ -d "$HOME/bin" ] && [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
  export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# Set up homebrew paths on macOS if available
if [ "$CURRENT_OS" = "Darwin" ]; then
  if [ -d /opt/homebrew ] && [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)" 
  elif [ -d /usr/local/Cellar ] && [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# Set up man pages if system has custom manpaths file
if [ -f /etc/manpaths ]; then
  for dir in $(cat /etc/manpaths); do
    export MANPATH="$MANPATH:$dir"
  done
fi
export MANPATH="/usr/local/man:$MANPATH"

# Set up Rust environment if installed
if [ -d "$HOME/.cargo" ]; then
  . "$HOME/.cargo/env"
fi

# Set up Atuin shell history if installed
if [ -d "$HOME/.atuin" ] && [ -f "$HOME/.atuin/bin/env" ]; then
  . "$HOME/.atuin/bin/env"
fi

# Set default editor
export EDITOR="vi"
if command -v emacsclient >/dev/null 2>&1; then
  export EDITOR="emacsclient -a 'emacs'"
elif command -v code >/dev/null 2>&1; then
  export EDITOR="code"
elif command -v nano >/dev/null 2>&1; then
  export EDITOR="nano"
fi

# Source .bashrc for bash login shells
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi