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
