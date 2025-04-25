# Initialize completion system once
fpath=(~/.zsh $fpath)
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

test -f "/usr/libexec/path_helper" && eval "$(/usr/libexec/path_helper)"

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

# Add brew completions if available
if type brew &>/dev/null
then
    if test -d "$BREW_PREFIX/share/zsh-completions"; then
	FPATH="$BREW_PREFIX/share/zsh-completions:$FPATH"
    fi
fi

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

# Man path setup
if test -f /etc/manpaths; then
    for dir in $(cat /etc/manpaths); do
	export MANPATH="$MANPATH:$dir"
    done
fi
export MANPATH="/usr/local/man:$MANPATH"

# Locale settings
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# Editor configuration
export EDITOR="emacsclient -a 'emacs'"
export ALTERNATE_EDITOR="code"

# Development environments
export JAVA_OPTIONS="-Djava.awt.headless=true"
export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"
export ANDROID_NDK_ROOT="/usr/local/share/android-ndk"
export NVM_DIR="$HOME/.nvm"
export PICO_SDK_PATH="$HOME/src/pico/pick-sdk"

# System information
export CURRENT_OS=$(uname -s)
export CURRENT_ARCH=$(uname -p)

if [[ -x $HOME/.local/bin/mise ]]; then
    eval "$($HOME/.local/bin/mise activate zsh)"
fi

# set up homebrew paths
# Set up homebrew once and store its prefix
if test $CURRENT_OS = "Darwin"; then
    if test -d /opt/homebrew; then
	eval $(/opt/homebrew/bin/brew shellenv)
	BREW_PREFIX="$(/opt/homebrew/bin/brew --prefix)"
    elif test -d /usr/local/Cellar; then
	eval $(/usr/local/bin/brew shellenv)
	BREW_PREFIX="$(/usr/local/bin/brew --prefix)"
    fi
fi

if [ -z "$XDG_RUNTIME_DIR" ]; then
  XDG_RUNTIME_DIR=/run/user/$(id -u)
  if [ -d "$XDG_RUNTIME_DIR" ] && [ -w "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR
  else
    unset XDG_RUNTIME_DIR
  fi
fi

case "$CURRENT_OS" in
    Linux*)
	export EMACS_SOCKET_NAME="$XDG_RUNTIME_DIR/emacs/server"
	;;
    Darwin*)
	export EMACS_SOCKET_NAME="${TMPDIR}emacs$(id -u)/server"
	;;
esac

# fd is installed as fdfind on Ubuntu/Debian
command -v fdfind > /dev/null && alias fd=fdfind

# set up cargo
if test -d "$HOME/.cargo"; then
    . "$HOME/.cargo/env"
fi

# Lazy-load NVM for faster shell startup
nvm() {
    unset -f nvm
    if test -s "$NVM_DIR/nvm.sh"; then
        source "$NVM_DIR/nvm.sh"
        if test -s "$NVM_DIR/bash_completion"; then
            source "$NVM_DIR/bash_completion"
        fi
    fi
    nvm "$@"
}

if type rustup &>/dev/null && ! test -d $HOME/.zfunc; then
    mkdir $HOME/.zfunc &>/dev/null
    rustup completions zsh > $HOME/.zfunc/_rustup
    fpath+=$HOME/.zfunc
fi

# set up Java paths
if test $CURRENT_OS = "Darwin"; then
    export JAVA_HOME=$(/usr/libexec/java_home)
elif test $CURRENT_OS = "Linux"; then
    export JAVA_HOME=/usr/lib/jvm/default-java
fi
export PATH=$JAVA_HOME/bin:$PATH

# set up Maven path
if test -d /opt/maven; then
    export MAVEN_HOME=/opt/maven
    prepend_to_path $MAVEN_HOME/bin
fi

if test -d $HOME/go; then
    export GOPATH="$HOME/go"
    prepend_to_path $GOPATH/bin
fi

test -e "$HOME/.shellfishrc" && source "$HOME/.shellfishrc"

# opam configuration
test ! -r ~/.opam/opam-init/init.zsh || source ~/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# Remove duplicated starship section

if test -d "/opt/homebrew/opt/llvm/bin"; then
    prepend_to_path /opt/homebrew/opt/llvm/bin
    export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
fi

# Don't automatically enable emsdk until this issue is addressed or I find a good
# workaround:
#   * https://github.com/emscripten-core/emsdk/issues/1142
#
# if test -d ~/src/emsdk; then
#     export EMSDK_QUIET=1
#     source ~/src/emsdk/emsdk_env.sh
# fi

if test -d ~/src/wabt ; then
    prepend_to_path ~/src/wabt/bin
fi

if test -d ~/.wasmtime; then
    export WASMTIME_HOME="$HOME/.wasmtime"
    prepend_to_path $WASMTIME_HOME/bin
fi

if test -d ~/.wasmer; then
    export WASMER_DIR=~/.wasmer
    if test -s $WASMER_DIR/wasmer.sh; then
	source $WASMER_DIR/wasmer.sh
    fi
fi

# if test -d "${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims" &>/dev/null; then
#     prepend_to_path "${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims"
#     eval "$(mise activate zsh)"
#     # run this just in case we need to update the end before getting a prompt
#     eval "$(mise hook-env)"
# fi

if type op &>/dev/null; then
    eval "$(op completion zsh)"; compdef _op op
fi
if test -f ~/.config/op/plugins.sh; then
    source ~/.config/op/plugins.sh
fi

if test -d "$HOME/.atuin/bin"; then
    prepend_to_path $HOME/.atuin/bin
    eval "$(atuin init zsh)"
fi

# Move these aliases to the aliases section

if type brew &>/dev/null && test -e "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"; then
    source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif test -e /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# pnpm
if test $CURRENT_OS = "Darwin"; then
    export PNPM_HOME="$HOME/Library/pnpm"
else
    export PNPM_HOME="$HOME/.local/share/pnpm"
fi
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

if type brew &>/dev/null && test -d "$BREW_PREFIX/share/zsh-syntax-highlighting"; then
    source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    # Disable underline
    (( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
    ZSH_HIGHLIGHT_STYLES[path]=none
    ZSH_HIGHLIGHT_STYLES[path_prefix]=none
fi

if test -d /opt/homebrew/opt/uutils-coreutils/libexec/uubin; then
    prepend_to_path /opt/homebrew/opt/uutils-coreutils/libexec/uubin
fi

if type brew &>/dev/null && test -f "$BREW_PREFIX/etc/brew-wrap"; then
  source "$BREW_PREFIX/etc/brew-wrap"
fi

if test -d /opt/homebrew/opt/libpq; then
    prepend_to_path /opt/homebrew/opt/libpq/bin
fi

# ===== Aliases =====

# System and utility aliases
alias mkdir="mkdir -p"
alias pip-up="pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip install -U"
alias git-scrub="git branch --merged | grep -v master | xargs git branch -d"
alias e="emacsclient -a 'emacs' --socket-name $EMACS_SOCKET_NAME"
alias serve="deno run --allow-read --allow-net jsr:@std/http/file-server"
alias less="less --mouse -INF"
alias get_uuid="echo ${(L)$(uuidgen)}"
alias metron-op='op --account metron.1password.com'
alias tc='tmux new -s `basename $(pwd)`'

# File system navigation and viewing
if type eza &>/dev/null; then
    STD_OPTIONS='-g --group-directories-first --icons --hyperlink'
    TREE_IGNORE="cache|log|logs|node_modules|vendor"
    alias l="eza $STD_OPTIONS"
    alias ls="l"
    alias la="l -a"
    alias ll="la -l"
    alias lg="l --git -l"
    alias lt='l --tree -D --level=2 -I "${TREE_IGNORE}"'
    alias llt='lt -l'
    alias ltt='l --tree -D --level=2 -I "${TREE_IGNORE}"'
    alias lltt='ltt -l'
    alias lttt='l --tree -D --level=3 -I "${TREE_IGNORE}"'
    alias llttt='lttt -l'
fi

# Enhanced command alternatives
if type bat &>/dev/null; then
    alias cat='bat --theme Catppuccin-macchiato --pager "less --mouse -RIF"'
fi

if type rlwrap &>/dev/null; then
    alias sqlite='rlwrap -a -N -c -i -f ~/.rlwrap/sqlite3_completions sqlite3'
fi

if type podman &>/dev/null; then
    alias docker=podman
fi

# Application shortcuts
if test -e $HOME/Applications/IntelliJ\ IDEA\ Community\ Edition.app/Contents/MacOS/idea; then
    alias idea="$HOME/Applications/IntelliJ\ IDEA\ Community\ Edition.app/Contents/MacOS/idea > /dev/null 2>&1 &"
fi

if test -e ~/.claude/local/claude; then
    alias claude=~/.claude/local/claude
fi
