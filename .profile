# Common profile settings for all POSIX-compatible shells
# This file is sourced by login shells

# Source common profile settings
[ -f "$HOME/.config/shell/common-profile.sh" ] && . "$HOME/.config/shell/common-profile.sh"

# Ensure PATH includes user's private bin directories
if [ -d "$HOME/bin" ] && [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
  export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  export PATH="$HOME/.local/bin:$PATH"
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

# Source .bashrc for bash login shells
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi