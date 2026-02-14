# Shell aliases and functions
# shellcheck shell=bash disable=SC2139,SC2296

# System and utility aliases
alias mkdir="mkdir -p"

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

# zmv convenience aliases (zmv loaded in init.zsh)
alias zcp='zmv -C'  # Copy with patterns
alias zln='zmv -L'  # Link with patterns

# Suffix aliases - open files by typing their name
# Markdown files with glow (pager mode)
if command -v glow >/dev/null 2>&1; then
  alias -s md='glow -p'
fi

# JSON with jless if available, otherwise bat
if command -v jless >/dev/null 2>&1; then
  alias -s json=jless
elif command -v bat >/dev/null 2>&1; then
  alias -s json=bat
fi

# Text and log files with bat
if command -v bat >/dev/null 2>&1; then
  alias -s txt=bat
  alias -s log=bat
fi

# Source files open in editor
# alias -s go='$EDITOR'
# alias -s rs='$EDITOR'
# alias -s py='$EDITOR'
# alias -s js='$EDITOR'
# alias -s ts='$EDITOR'
# alias -s tsx='$EDITOR'
# alias -s jsx='$EDITOR'

if command -v claude >/dev/null 2>&1; then
  alias obc='cd ~/Obsidian/Personal; claude'
fi
