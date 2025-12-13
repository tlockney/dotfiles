# Shell aliases and functions
# shellcheck shell=bash disable=SC2139,SC2296

# System and utility aliases
alias mkdir="mkdir -p"
alias git-scrub="git branch --merged | grep -v main | grep -v master | xargs git branch -d"

# fd is installed as fdfind on Ubuntu/Debian
command -v fdfind > /dev/null && alias fd=fdfind

# Emacs client with proper socket
alias e="emacsclient -a 'emacs' --socket-name $EMACS_SOCKET_NAME"

# Deno web server
alias serve="deno run --allow-read --allow-net jsr:@std/http/file-server"

# Enhanced less with mouse support when available
if command -v less >/dev/null 2>&1 && less --help 2>&1 | grep -q -- '--mouse'; then
  alias less="less --mouse -INF"
else
  alias less="less -INF"
fi

# UUID generation - handles both macOS and Linux
if command -v uuidgen >/dev/null 2>&1; then
  alias get_uuid="echo ${(L)$(uuidgen)}"
elif command -v uuid >/dev/null 2>&1; then
  alias get_uuid="uuid | tr '[:upper:]' '[:lower:]'"
fi

# 1Password account aliases
if command -v op >/dev/null 2>&1; then
  alias metron-op='op --account metron.1password.com'
fi

# File system navigation and viewing with eza/exa
if command -v eza >/dev/null 2>&1; then
  STD_OPTIONS='-g --group-directories-first --icons --hyperlink'
  TREE_IGNORE="cache|log|logs|node_modules|vendor"
  alias l="eza $STD_OPTIONS"
  alias ls="l"
  alias la="l -a"
  alias ll="la -l"
  alias lg="l --git -l"
  alias lt="l --tree -D --level=2 -I $TREE_IGNORE"
  alias llt="lt -l"
else
  # Fallback to standard ls with colors if available
  [[ "$CURRENT_OS" == "Darwin" ]] && alias ls="ls -G"
  [[ "$CURRENT_OS" == "Linux" ]] && alias ls="ls --color=auto"
  alias l="ls"
  alias la="ls -a"
  alias ll="ls -la"
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat'
fi

# SQLite with rlwrap if available
alias sqlite='rlwrap -a -N -c -i -f ~/.rlwrap/sqlite3_completions sqlite3'

if command -v uvx >/dev/null 2>&1; then
  alias docx2pdf='uvx docx2pdf'
fi
