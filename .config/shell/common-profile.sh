# Common profile settings shared between all shells
# Sourced by both .profile and .zprofile

# Detect OS and architecture for platform-specific settings
export CURRENT_OS=$(uname -s)
export CURRENT_ARCH=$(uname -m)

# Set up XDG runtime directory if not already set
if [ -z "$XDG_RUNTIME_DIR" ]; then
  if [ "$CURRENT_OS" = "Linux" ]; then
    XDG_RUNTIME_DIR=/run/user/$(id -u)
  elif [ "$CURRENT_OS" = "Darwin" ]; then
    XDG_RUNTIME_DIR="${TMPDIR%/}user/$(id -u)"
    mkdir -p "$XDG_RUNTIME_DIR" 2>/dev/null || true
  fi

  # Only export if directory exists and is writable
  if [ -d "$XDG_RUNTIME_DIR" ] && [ -w "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR
  else
    unset XDG_RUNTIME_DIR
  fi
fi

# Follow XDG base dir specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Set default editor with fallback chain
export EDITOR="vi"
if command -v emacsclient >/dev/null 2>&1; then
  export EDITOR="emacsclient -a 'emacs'"
  [ "$(command -v code)" ] && export ALTERNATE_EDITOR="code"
elif command -v code >/dev/null 2>&1; then
  export EDITOR="code"
elif command -v vim >/dev/null 2>&1; then
  export EDITOR="vim"
elif command -v nano >/dev/null 2>&1; then
  export EDITOR="nano"
fi

# Handle Homebrew initialization on macOS
if [ "$CURRENT_OS" = "Darwin" ]; then
  if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -f /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi