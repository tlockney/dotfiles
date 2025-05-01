# Initialize completion system once
[[ -d ~/.zsh ]] && fpath=(~/.zsh $fpath)
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
if [[ "$CURRENT_OS" == "Darwin" && -f "/usr/libexec/path_helper" ]]; then
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

# System information - detect OS and architecture
export CURRENT_OS=$(uname -s)
export CURRENT_ARCH=$(uname -m)

# Development environment settings
export JAVA_OPTIONS="-Djava.awt.headless=true"
export NVM_DIR="$HOME/.nvm"

# Platform-specific SDK paths
if [[ "$CURRENT_OS" == "Darwin" ]]; then
    # macOS paths
    [[ -d "/usr/local/share/android-sdk" ]] && export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"
    [[ -d "/usr/local/share/android-ndk" ]] && export ANDROID_NDK_ROOT="/usr/local/share/android-ndk"
elif [[ "$CURRENT_OS" == "Linux" ]]; then
    # Linux paths - adjust these if needed
    [[ -d "$HOME/Android/Sdk" ]] && export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
    [[ -d "$HOME/Android/Ndk" ]] && export ANDROID_NDK_ROOT="$HOME/Android/Ndk"
fi

# Set project paths if directories exist
[[ -d "$HOME/src/pico/pick-sdk" ]] && export PICO_SDK_PATH="$HOME/src/pico/pick-sdk"

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
if [[ "$CURRENT_OS" == "Darwin" ]]; then
    if [[ -d /opt/homebrew && -x /opt/homebrew/bin/brew ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
	BREW_PREFIX="$(/opt/homebrew/bin/brew --prefix)"
    elif [[ -d /usr/local/Cellar && -x /usr/local/bin/brew ]]; then
	eval "$(/usr/local/bin/brew shellenv)"
	BREW_PREFIX="$(/usr/local/bin/brew --prefix)"
    fi
elif [[ "$CURRENT_OS" == "Linux" ]]; then
    # Handle Homebrew on Linux if installed
    if [[ -d /home/linuxbrew/.linuxbrew && -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	BREW_PREFIX="$(/home/linuxbrew/.linuxbrew/bin/brew --prefix)"
    elif [[ -d "$HOME/.linuxbrew" && -x "$HOME/.linuxbrew/bin/brew" ]]; then
	eval "$($HOME/.linuxbrew/bin/brew shellenv)"
	BREW_PREFIX="$($HOME/.linuxbrew/bin/brew --prefix)"
    fi
fi

# Set up XDG runtime directory if not already set
if [[ -z "$XDG_RUNTIME_DIR" ]]; then
    if [[ "$CURRENT_OS" == "Linux" ]]; then
	XDG_RUNTIME_DIR=/run/user/$(id -u)
    elif [[ "$CURRENT_OS" == "Darwin" ]]; then
	XDG_RUNTIME_DIR="${TMPDIR%/}user/$(id -u)"
	mkdir -p "$XDG_RUNTIME_DIR" 2>/dev/null || true
    else
	# Fallback for other Unix systems
	XDG_RUNTIME_DIR="/tmp/runtime-$(id -u)"
	mkdir -p "$XDG_RUNTIME_DIR" 2>/dev/null || true
    fi

    # Only set if directory exists and is writable
    if [[ -d "$XDG_RUNTIME_DIR" && -w "$XDG_RUNTIME_DIR" ]]; then
	export XDG_RUNTIME_DIR
    else
	unset XDG_RUNTIME_DIR
    fi
fi

# Configure Emacs socket name based on platform
case "$CURRENT_OS" in
    Linux*)
	export EMACS_SOCKET_NAME="${XDG_RUNTIME_DIR:-/tmp}/emacs/server"
	;;
    Darwin*)
	export EMACS_SOCKET_NAME="${TMPDIR:-/tmp}emacs$(id -u)/server"
	;;
    *)
	# Fallback for other Unix systems
	export EMACS_SOCKET_NAME="/tmp/emacs$(id -u)/server"
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

# Set up Java environment
# Try to detect Java home across different platforms
if [[ "$CURRENT_OS" == "Darwin" && -x /usr/libexec/java_home ]]; then
    # macOS has a helper to find the correct JAVA_HOME
    export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
elif [[ "$CURRENT_OS" == "Linux" ]]; then
    # Try different common Linux Java locations
    if [[ -d "/usr/lib/jvm/default-java" ]]; then
	export JAVA_HOME=/usr/lib/jvm/default-java
    elif [[ -d "/usr/lib/jvm/java-11-openjdk-amd64" ]]; then
	export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
    elif [[ -d "/usr/lib/jvm/java-17-openjdk-amd64" ]]; then
	export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
    elif [[ -L "/etc/alternatives/java_sdk" ]]; then
	export JAVA_HOME=$(readlink -f /etc/alternatives/java_sdk)
    fi
fi

# Add Java to PATH if JAVA_HOME was found
if [[ -n "$JAVA_HOME" && -d "$JAVA_HOME/bin" ]]; then
    prepend_to_path "$JAVA_HOME/bin"
fi

# Set up Maven if installed
for maven_path in /opt/maven "$HOME/opt/maven" "/usr/local/opt/maven"; do
    if [[ -d "$maven_path" ]]; then
	export MAVEN_HOME="$maven_path"
	prepend_to_path "$MAVEN_HOME/bin"
	break
    fi
done

# Set up Go if installed
if [[ -d "$HOME/go" ]]; then
    export GOPATH="$HOME/go"
    prepend_to_path "$GOPATH/bin"
fi

test -e "$HOME/.shellfishrc" && source "$HOME/.shellfishrc"

# opam configuration
test ! -r ~/.opam/opam-init/init.zsh || source ~/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

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

if type brew &>/dev/null && test -e "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"; then
    source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif test -e /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Set up PNPM if installed
if command -v pnpm >/dev/null 2>&1 || [[ -d "$HOME/Library/pnpm" ]] || [[ -d "$HOME/.local/share/pnpm" ]]; then
    # Set PNPM_HOME based on platform
    case "$CURRENT_OS" in
	Darwin*)
	    export PNPM_HOME="$HOME/Library/pnpm"
	    ;;
	Linux*|*BSD*|MSYS*|MINGW*)
	    export PNPM_HOME="$HOME/.local/share/pnpm"
	    ;;
	*)
	    # Fallback for other systems
	    export PNPM_HOME="$HOME/.pnpm"
	    ;;
    esac

    # Create directory if it doesn't exist
    mkdir -p "$PNPM_HOME" 2>/dev/null || true

    # Add to PATH if not already there
    case ":$PATH:" in
	*":$PNPM_HOME:"*) ;;
	*) export PATH="$PNPM_HOME:$PATH" ;;
    esac
fi

if type brew &>/dev/null && test -d "$BREW_PREFIX/share/zsh-syntax-highlighting"; then
    source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    # Disable underline
    (( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
    ZSH_HIGHLIGHT_STYLES[path]=none
    ZSH_HIGHLIGHT_STYLES[path_prefix]=none
fi

# Add Homebrew-specific paths on macOS if available
if [[ "$CURRENT_OS" == "Darwin" ]]; then
    # Rust-based coreutils if installed
    if [[ -d "/opt/homebrew/opt/uutils-coreutils/libexec/uubin" ]]; then
	prepend_to_path "/opt/homebrew/opt/uutils-coreutils/libexec/uubin"
    fi

    # PostgreSQL client if installed
    if [[ -d "/opt/homebrew/opt/libpq/bin" ]]; then
	prepend_to_path "/opt/homebrew/opt/libpq/bin"
    fi
fi

# Brew wrap support if available
if [[ -n "$BREW_PREFIX" && -f "$BREW_PREFIX/etc/brew-wrap" ]]; then
    source "$BREW_PREFIX/etc/brew-wrap"
fi

# ===== Aliases =====

# System and utility aliases
alias mkdir="mkdir -p"
alias pip-up="pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip install -U"
alias git-scrub="git branch --merged | grep -v main | grep -v master | xargs git branch -d"

# Emacs client with proper socket
if command -v emacsclient >/dev/null 2>&1; then
    alias e="emacsclient -a 'emacs' --socket-name $EMACS_SOCKET_NAME"
fi

# Deno web server if available
if command -v deno >/dev/null 2>&1; then
    alias serve="deno run --allow-read --allow-net jsr:@std/http/file-server"
fi

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

# Tmux session creation
if command -v tmux >/dev/null 2>&1; then
    alias tc='tmux new -s `basename $(pwd)`'
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
    alias lt='l --tree -D --level=2 -I "${TREE_IGNORE}"'
    alias llt='lt -l'
    alias ltt='l --tree -D --level=2 -I "${TREE_IGNORE}"'
    alias lltt='ltt -l'
    alias lttt='l --tree -D --level=3 -I "${TREE_IGNORE}"'
    alias llttt='lttt -l'
elif command -v exa >/dev/null 2>&1; then
    # For older exa versions
    STD_OPTIONS='-g --group-directories-first'
    TREE_IGNORE="cache|log|logs|node_modules|vendor"
    alias l="exa $STD_OPTIONS"
    alias ls="l"
    alias la="l -a"
    alias ll="la -l"
    alias lg="l --git -l"
    alias lt='l --tree -D -L 2 -I "${TREE_IGNORE}"'
    alias llt='lt -l'
    alias ltt='l --tree -D -L 2 -I "${TREE_IGNORE}"'
    alias lltt='ltt -l'
    alias lttt='l --tree -D -L 3 -I "${TREE_IGNORE}"'
    alias llttt='lttt -l'
else
    # Fallback to standard ls with colors if available
    case "$CURRENT_OS" in
	Darwin*)
	    alias ls="ls -G"
	    ;;
	Linux*)
	    alias ls="ls --color=auto"
	    ;;
    esac
    alias l="ls"
    alias la="ls -a"
    alias ll="ls -la"
fi

# Enhanced command alternatives with fallbacks
if command -v bat >/dev/null 2>&1; then
    # Check if the Catppuccin theme is available
    if bat --list-themes 2>/dev/null | grep -q "Catppuccin-macchiato"; then
	alias cat='bat --theme Catppuccin-macchiato --pager "less -RIF"'
    else
	alias cat='bat --pager "less -RIF"'
    fi
fi

# SQLite with rlwrap if available
if command -v rlwrap >/dev/null 2>&1 && command -v sqlite3 >/dev/null 2>&1; then
    # Create directory if it doesn't exist
    mkdir -p ~/.rlwrap 2>/dev/null
    alias sqlite='rlwrap -a -N -c -i -f ~/.rlwrap/sqlite3_completions sqlite3'
fi

# Podman as Docker alternative, but check if Docker Desktop is installed on macOS
if [[ "$CURRENT_OS" == "Darwin" && -e "/Applications/Docker.app" ]]; then
    # Keep Docker as is on macOS if Docker Desktop is installed
    true
elif command -v podman >/dev/null 2>&1; then
    alias docker=podman
fi

# Platform-specific application shortcuts
if [[ "$CURRENT_OS" == "Darwin" ]]; then
    # macOS application paths
    if [[ -e "$HOME/Applications/IntelliJ IDEA Community Edition.app/Contents/MacOS/idea" ]]; then
	alias idea="$HOME/Applications/IntelliJ\ IDEA\ Community\ Edition.app/Contents/MacOS/idea > /dev/null 2>&1 &"
    elif [[ -e "/Applications/IntelliJ IDEA CE.app/Contents/MacOS/idea" ]]; then
	alias idea="/Applications/IntelliJ\ IDEA\ CE.app/Contents/MacOS/idea > /dev/null 2>&1 &"
    fi
elif [[ "$CURRENT_OS" == "Linux" ]]; then
    # Linux application paths if needed
    if command -v intellij-idea-community >/dev/null 2>&1; then
	alias idea="intellij-idea-community > /dev/null 2>&1 &"
    fi
fi
