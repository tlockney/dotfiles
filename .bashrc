# Bash initialization file
# This is only loaded for interactive non-login shells in bash

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Load bash-preexec if available (enables Atuin shell history)
[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh

# Set a basic prompt if not already defined
if [ -z "$PS1" ]; then
    PS1='\u@\h:\w\$ '
fi

# Enable Atuin shell history if available
if type atuin &>/dev/null; then
    eval "$(atuin init bash)"
fi

# Source shellfish functions for iOS terminal support
if [ -f "$HOME/.shellfishrc" ]; then
    source "$HOME/.shellfishrc"
fi

# Enable programmable completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# History settings
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend

# Update window size after each command
shopt -s checkwinsize

# Use ** for recursive globbing
shopt -s globstar 2>/dev/null || true

# Customize ls output based on platform
if [[ "$(uname -s)" == "Darwin" ]] || [[ "$(uname -s)" == "FreeBSD" ]]; then
    alias ls="ls -G"
else
    alias ls="ls --color=auto"
fi

# Common aliases
alias ll="ls -la"
alias la="ls -A"
alias grep="grep --color=auto"