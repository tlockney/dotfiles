# Completion styles and configuration

# Enable completion menu
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive completion
# shellcheck disable=SC2296  # zsh-specific parameter expansion syntax
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"    # Colored completion