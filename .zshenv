# .zshenv - Always sourced for ALL zsh shells (interactive and non-interactive)
# Keep this file minimal and fast - it runs for every zsh invocation

# Add mise shims to PATH for non-interactive shells
# Interactive shells will get full mise activation in .zshrc via tools.zsh
if [[ -d "$HOME/.local/share/mise/shims" ]]; then
  export PATH="$HOME/.local/share/mise/shims:$PATH"
fi

# Cargo environment
# ~/.cargo is a symlink to /Volumes/Secondary which can hang in uninterruptible
# D-state I/O wait if the volume is unresponsive. Any filesystem operation on
# the symlink (stat, test, source) will block indefinitely — perl alarm() cannot
# interrupt kernel I/O wait. So we add the path directly without touching the
# filesystem. A non-existent path on PATH is harmless.
case ":$PATH:" in
  *":$HOME/.cargo/bin:"*) ;;  # already in PATH
  *) export PATH="$HOME/.cargo/bin:$PATH" ;;
esac

# Source local environment if it exists
if [[ -f "/usr/local/env" ]]; then
  . "/usr/local/env"
fi

# Handle Homebrew initialization
if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
