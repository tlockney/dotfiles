# Initialize completion system once
[[ ! -d ~/.zsh/completions ]] && mkdir -p ~/.zsh/completions
fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit
compinit -u

# ===== Path Configuration =====

# prevent duplicate path entries
typeset -U path

function prepend_to_path {
  # Only add path if it exists and is not already in the path
  if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
    path=($1 $path)
    export PATH
  fi
}

# Standard directories
prepend_to_path /usr/local/bin
prepend_to_path /usr/local/sbin
prepend_to_path $HOME/bin
prepend_to_path $HOME/.local/bin

# Use macOS path_helper if available
if [[ -f "/usr/libexec/path_helper" ]]; then
  eval "$(/usr/libexec/path_helper)"
fi

# ===== Shell Options and Key Bindings =====

# Set emacs keybindings
set -o emacs

# Key bindings for better navigation
bindkey '^[[1;5C' forward-word     # Ctrl+right arrow: move forward one word
bindkey '^[[1;5D' backward-word    # Ctrl+left arrow: move backward one word
bindkey '^[[H' beginning-of-line   # Home key: beginning of line
bindkey '^[[F' end-of-line         # End key: end of line
bindkey '^[[3~' delete-char        # Delete key

# Add useful zsh options
setopt AUTO_CD                  # If a command is a directory name, cd to it
setopt AUTO_PUSHD               # Push dirs to the stack automatically
setopt PUSHD_IGNORE_DUPS        # Don't push multiple copies of the same directory
setopt PUSHD_SILENT             # Don't print the directory stack after pushd or popd
setopt CORRECT                  # Try to correct command spelling
setopt NO_FLOW_CONTROL          # Disable flow control (^S/^Q)
setopt INTERACTIVE_COMMENTS     # Allow comments even in interactive shells

# ===== History Configuration =====
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# ===== Completions Setup =====

# Enable completion menu
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"    # Colored completion

# ===== Prompt Configuration =====

# Default prompt (fallback if starship isn't available)
PS1='%B%F{yellow1}%~@%m%f -> %b'

# Enable starship prompt if available
if type starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# ===== Environment Variables =====

[[ "$TERM_PROGRAM" == "ghostty" ]] && export TERM="xterm-256color"

# System information - detect OS and architecture
export CURRENT_OS=$(uname -s)
export CURRENT_ARCH=$(uname -m)

# Editor configuration
if command -v emacsclient >/dev/null 2>&1; then
  export EDITOR="emacsclient -a 'emacs'"
  [[ "$(command -v code)" ]] && export ALTERNATE_EDITOR="code"
elif command -v code >/dev/null 2>&1; then
  export EDITOR="code"
elif command -v vim >/dev/null 2>&1; then
  export EDITOR="vim"
else
  export EDITOR="vi"
fi

# Locale settings - set default but don't override if already set
: ${LC_ALL:=en_US.UTF-8}
: ${LANG:=en_US.UTF-8}
: ${LANGUAGE:=en_US.UTF-8}
export LC_ALL LANG LANGUAGE

# Initialize mise tool version manager if installed
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
elif [[ -x $HOME/.local/bin/mise ]]; then
  eval "$($HOME/.local/bin/mise activate zsh)"
fi

# Set up homebrew paths and prefix if available
[[ "$CURRENT_OS" == "Darwin" ]] && {
  eval "$(/opt/homebrew/bin/brew shellenv)"
  BREW_PREFIX="$(/opt/homebrew/bin/brew --prefix)"
}

# Add brew completions if available
[[ -d "$BREW_PREFIX/share/zsh-completions" ]] && FPATH="$BREW_PREFIX/share/zsh-completions:$FPATH"

# Zsh autosuggestions
ZSH_AUTO_SCRIPT="zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -e "$BREW_PREFIX/share/$ZSH_AUTO_SCRIPT" ]] && source "$BREW_PREFIX/share/$ZSH_AUTO_SCRIPT"
[[ -e /usr/share/$ZSH_AUTO_SCRIPT ]] && source /usr/share/$ZSH_AUTO_SCRIPT

# Zsh syntax highlighting
[[ -d "$BREW_PREFIX/share/zsh-syntax-highlighting" ]] && {
  source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  # Disable underline
  (( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[path]=none
  ZSH_HIGHLIGHT_STYLES[path_prefix]=none
}

# Set up XDG runtime directory if not already set
if [[ -z "$XDG_RUNTIME_DIR" ]]; then
  [[ "$CURRENT_OS" == "Linux" ]] && XDG_RUNTIME_DIR=/run/user/$(id -u)
  [[ "$CURRENT_OS" == "Darwin" ]] && {
    XDG_RUNTIME_DIR="${TMPDIR%/}user/$(id -u)"
    mkdir -p "$XDG_RUNTIME_DIR" 2>/dev/null || true
  }

  # Only set if directory exists and is writable
  if [[ -d "$XDG_RUNTIME_DIR" && -w "$XDG_RUNTIME_DIR" ]]; then
    export XDG_RUNTIME_DIR
  else
    unset XDG_RUNTIME_DIR
  fi
fi

# Configure Emacs socket name based on platform
[[ "$CURRENT_OS" = "Darwin" ]] && export EMACS_SOCKET_NAME="${TMPDIR:-/tmp}emacs$(id -u)/server"
[[ "$CURRENT_OS" = "Linux" ]] && export EMACS_SOCKET_NAME="${XDG_RUNTIME_DIR:-/tmp}/emacs/server"

# set up cargo
[[ -d "$HOME/.cargo" ]] && source "$HOME/.cargo/env"

type rustup &>/dev/null && rustup completions zsh > $HOME/.zsh/completions/_rustup
type deno &>/dev/null && deno completions zsh > $HOME/.zsh/completions/_deno
type uv &>/dev/null && uv generate-shell-completion zsh > $HOME/.zsh/completions/_uv
type mise &>/dev/null && mise completions zsh > $HOME/.zsh/completions/_mise

# Set up Java environment
export JAVA_OPTIONS="-Djava.awt.headless=true"
# Try to detect Java home across different platforms
[[ "$CURRENT_OS" == "Darwin" && -x /usr/libexec/java_home ]] && {
  export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
}
[[ "$CURRENT_OS" == "Linux" ]] && {
  # Try different common Linux Java locations in order of preference
  [[ -d "/usr/lib/jvm/default-java" ]] && export JAVA_HOME=/usr/lib/jvm/default-java ||
  [[ -d "/usr/lib/jvm/java-21-openjdk-amd64" ]] && export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64 ||
  [[ -L "/etc/alternatives/java_sdk" ]] && export JAVA_HOME=$(readlink -f /etc/alternatives/java_sdk)
}

# Add Java to PATH if JAVA_HOME was found
[[ -n "$JAVA_HOME" && -d "$JAVA_HOME/bin" ]] && prepend_to_path "$JAVA_HOME/bin"


# Set up Go if installed
[[ -d "$HOME/go" ]] && { export GOPATH="$HOME/go"; prepend_to_path "$GOPATH/bin"; }

# opam configuration
[[ -r ~/.opam/opam-init/init.zsh ]] && source ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null

# 1Password integration
command -v op >/dev/null 2>&1 && { eval "$(op completion zsh)"; compdef _op op; }
[[ -f ~/.config/op/plugins.sh ]] && source ~/.config/op/plugins.sh

# Atuin shell history
[[ -d "$HOME/.atuin/bin" ]] && {
  prepend_to_path $HOME/.atuin/bin
  eval "$(atuin init zsh)"
}

# Set up PNPM if installed
(command -v pnpm >/dev/null 2>&1 || [[ -d "$HOME/Library/pnpm" ]] || [[ -d "$HOME/.local/share/pnpm" ]]) && {
  # Set PNPM_HOME based on platform
  [[ "$CURRENT_OS" = "Darwin" ]] && export PNPM_HOME="$HOME/Library/pnpm"
  [[ "$CURRENT_OS" = "Linux" ]] && export PNPM_HOME="$HOME/.local/share/pnpm"

  # Create directory if it doesn't exist and add to PATH if not already there
  mkdir -p "$PNPM_HOME" 2>/dev/null || true
  [[ ":$PATH:" != *":$PNPM_HOME:"* ]] && export PATH="$PNPM_HOME:$PATH"
}

# Add Homebrew-specific paths on macOS
[[ -d "$BREW_PREFIX/opt/uutils-coreutils/libexec/uubin" ]] && prepend_to_path "$BREW_PREFIX/opt/uutils-coreutils/libexec/uubin"
[[ -d "$BREW_PREFIX/opt/libpq/bin" ]] && prepend_to_path "$BREW_PREFIX/opt/libpq/bin"

# Brew wrap support if available
[[ -f "$BREW_PREFIX/etc/brew-wrap" ]] && source "$BREW_PREFIX/etc/brew-wrap"

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
command -v op >/dev/null 2>&1 && alias metron-op='op --account metron.1password.com'

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

command -v bat >/dev/null 2>&1 && alias cat='bat'

# SQLite with rlwrap if available
alias sqlite='rlwrap -a -N -c -i -f ~/.rlwrap/sqlite3_completions sqlite3'

command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

# Source optional configuration files
[[ -e "$HOME/.shellfishrc" ]] && source "$HOME/.shellfishrc"

[[ -x $HOME/.claude/local/claude ]] && alias claude=$HOME/.claude/local/claude
