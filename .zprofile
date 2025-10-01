# Initialize profile settings for zsh
# This file is read before .zshrc for login shells

# Source common profile settings
[ -f "$HOME/.config/shell/common-profile.sh" ] && source "$HOME/.config/shell/common-profile.sh"

export MANPAGER="less -R --use-color -Dd+r -Du+b" # colored man pages

export FZF_DEFAULT_OPTS="--style minimal --color 16 --layout=reverse --height 30% --preview='bat -p --color=always {}'"
