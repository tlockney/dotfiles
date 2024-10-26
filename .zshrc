# prevent duplicate path entries
typeset -U path

function prepend_to_path {
    path=($1 $path)
    export PATH
}

prepend_to_path /usr/local/bin
prepend_to_path /usr/local/sbin
prepend_to_path $HOME/bin
prepend_to_path $HOME/.local/bin

test -f "/usr/libexec/path_helper" && eval "$(/usr/libexec/path_helper)"

set -o emacs

autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit

if type brew &>/dev/null
then
    if test -d $(brew --prefix zsh-completions); then
	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    fi

    if test -d $(brew --prefix zsh-autosuggestions); then
	source $(brew --prefix zsh-autosuggestions)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    fi
else
    if test -d /usr/share/zsh-autosuggestions; then
	source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    fi
fi

###-begin-hs-completions-###
#
# yargs command completion script
#
# Installation: hs completion >> ~/.zshrc
#    or hs completion >> ~/.zsh_profile on OSX.
#
_hs_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" hs --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _hs_yargs_completions hs
###-end-hs-completions-###

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

PS1='%B%F{yellow1}%~@%m%f -> %b'

CURRENT_OS=$(uname -s)

if test -f /etc/manpaths; then
	for dir in $(cat /etc/manpaths); do
		export MANPATH="$MANPATH:$dir"
	done
fi
export MANPATH="/usr/local/man:$MANPATH"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export EDITOR="emacs"
export ALTERNATE_EDITOR="code"
export JAVA_OPTIONS="-Djava.awt.headless=true"
export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"
export ANDROID_NDK_ROOT="/usr/local/share/android-ndk"
export NVM_DIR="$HOME/.nvm"
export PICO_SDK_PATH="$HOME/src/pico/pick-sdk"

alias mkdir="mkdir -p"
alias pip-up="pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip install -U"
alias git-scrub="git branch --merged | grep -v master | xargs git branch -d"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

alias ll="ls -lG"
alias la="ls -alG"

# fd is installed as fdfind on Ubuntu/Debian
command -v fdfind > /dev/null && alias fd=fdfind

export CURRENT_OS=$(uname -s)
export CURRENT_ARCH=$(uname -p)

# set up homebrew paths
if test $CURRENT_OS = "Darwin"; then
	if test -d /opt/homebrew; then
		eval $(/opt/homebrew/bin/brew shellenv)
	fi
	if test -d /usr/local/Cellar; then
		eval $(/usr/local/bin/brew shellenv)
	fi
fi

if test -f /etc/manpaths; then
	for dir in $(cat /etc/manpaths); do
		export MANPATH="$MANPATH:$dir"
	done
fi

# set up cargo
if test -d "HOME/.cargo"; then
	. "$HOME/.cargo/env"
fi

# init nvm
export NVM_DIR="$HOME/.nvm"
test -s "$NVM_DIR/nvm.sh" && source "$NVM_DIR/nvm.sh"  # This loads nvm
test -s "$NVM_DIR/bash_completion" && source "$NVM_DIR/bash_completion"

# init pipx completions
if type pipx &>/dev/null; then
    eval "$(register-python-argcomplete pipx)"
fi

if type rustup &>/dev/null && ! test -d $HOME/.zfunc; then
    mkdir $HOME/.zfunc &>/dev/null
    rustup completions zsh > $HOME/.zfunc/_rustup
    fpath+=$HOME/.zfunc
fi

# set up Java paths
if test $CURRENT_OS = "Darwin"; then
    export JAVA_HOME=$(/usr/libexec/java_home)
elif test $CURRENT_OS = "Linux"; then
    export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
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

# Check for processing
if test -d /opt/processing/; then
    prepend_to_path /opt/processing/
fi

if test -f ~/.hubspot/shellrc; then
    . ~/.hubspot/shellrc
fi

test -e "$HOME/.shellfishrc" && source "$HOME/.shellfishrc"

# opam configuration
test ! -r ~/.opam/opam-init/init.zsh || source ~/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

if type starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

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

if test -d "${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims" &>/dev/null; then
    prepend_to_path "${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims"
    eval "$(mise activate zsh)"
    # run this just in case we need to update the end before getting a prompt
    eval "$(mise hook-env)"
fi

if test -d "$HOME/.asdf"; then
    . "$HOME/.asdf/asdf.sh"
fi

if test -f ~/.config/op/plugins.sh; then
    source ~/.config/op/plugins.sh
fi

if test -d "$HOME/.atuin/bin"; then
		prepend_to_path $HOME/.atuin/bin
		eval "$(atuin init zsh)"
fi

if type exa &>/dev/null; then
    TREE_IGNORE="cache|log|logs|node_modules|vendor"
    alias ls='exa --group-directories-first'
    alias la='ls -a'
    alias ll='ls --git -l'
    alias lt='ls --tree -D -L 2 -I ${TREE_IGNORE}'
    alias ltt='ls --tree -D -L 3 -I ${TREE_IGNORE}'
    alias lttt='ls --tree -D -L 4 -I ${TREE_IGNORE}'
    alias ltttt='ls --tree -D -L 5 -I ${TREE_IGNORE}'
fi

if type bat &>/dev/null; then
    alias cat='bat --theme Catppuccin-macchiato'
fi

if type rlwrap &>/dev/null; then
    alias sqlite='rlwrap -a -N -c -i -f ~/.rlwrap/sqlite3_completions sqlite3'
fi

if test -d $HOME/Tools/google-cloud-sdk; then
    # prepend_to_path $HOME/Tools/google-cloud-sdk/bin
    source $HOME/Tools/google-cloud-sdk/path.zsh.inc
    source $HOME/Tools/google-cloud-sdk/completion.zsh.inc
fi

if test -e $HOME/Applications/IntelliJ\ IDEA\ Community\ Edition.app/Contents/MacOS/idea; then
    alias idea="$HOME/Applications/IntelliJ\ IDEA\ Community\ Edition.app/Contents/MacOS/idea > /dev/null 2>&1 &"
fi

if test -e ~/.config/op/plugins.sh; then
	source ~/.config/op/plugins.sh
fi

if type brew &>/dev/null && test -e $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh; then
		source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif test -e /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh; then
		source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# pnpm
if test -e ~/.local/share/pnpm; then
    export PNPM_HOME="/home/tlockney/.local/share/pnpm"
    case ":$PATH:" in
	*":$PNPM_HOME:"*) ;;
	*) export PATH="$PNPM_HOME:$PATH" ;;
    esac
fi
# pnpm end
