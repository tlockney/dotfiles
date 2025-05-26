# Initialize profile settings for zsh
# This file is read before .zshrc for login shells

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

# follow XDG base dir specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Set default editor
export EDITOR="vi"
if command -v emacsclient >/dev/null 2>&1; then
  export EDITOR="emacsclient -a 'emacs'"
elif command -v code >/dev/null 2>&1; then
  export EDITOR="code"
elif command -v nano >/dev/null 2>&1; then
  export EDITOR="nano"
fi

# Handle Homebrew initialization on macOS if it exists
if [[ "$(uname -s)" == "Darwin" ]]; then
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi
