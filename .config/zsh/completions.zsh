# Completion styles and configuration

# Enable completion menu
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive completion
# shellcheck disable=SC2296  # zsh-specific parameter expansion syntax
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"    # Colored completion

# tc: complete with existing tmux session names
_tc() {
  local sessions
  sessions=("${(@f)$(tmux list-sessions -F '#S' 2>/dev/null)}")
  if (( ${#sessions} )); then
    compadd -a sessions
  fi
}
compdef _tc tc