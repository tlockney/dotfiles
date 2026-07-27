# Common profile settings for all POSIX-compatible shells
# This file is sourced by login shells
# shellcheck shell=sh

# Source shared shell configuration
[ -f "$HOME/.config/shell/common.sh" ] && . "$HOME/.config/shell/common.sh"

# Set up man pages if system has custom manpaths file
if [ -f /etc/manpaths ]; then
  while IFS= read -r dir; do
    MANPATH="$MANPATH:$dir"
  done < /etc/manpaths
fi
MANPATH="/usr/local/man:$MANPATH"
export MANPATH

# Source .bashrc for bash login shells
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

# Written by the uv/rustup installers; absent on a machine that has not run
# them, where sourcing it unconditionally aborts the shell with status 127.
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Cargo environment. Deliberately not sourced, and deliberately not tested
# with [ -f ]: ~/.cargo is a symlink to /Volumes/Secondary, and any filesystem
# operation on it blocks indefinitely in uninterruptible D-state I/O wait when
# that volume is unresponsive. .zshenv and .bash_profile add the path this way
# for the same reason; this file was the one place still touching it.
case ":$PATH:" in
  *":$HOME/.cargo/bin:"*) ;;  # already in PATH
  *) export PATH="$HOME/.cargo/bin:$PATH" ;;
esac

# Hermes Agent — ensure ~/.local/bin is on PATH
export PATH="$HOME/.local/bin:$PATH"
