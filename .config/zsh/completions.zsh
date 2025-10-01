# Completion styles and configuration

# Enable completion menu
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case insensitive completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"    # Colored completion

# Add brew completions if available
[[ -d "$BREW_PREFIX/share/zsh-completions" ]] && FPATH="$BREW_PREFIX/share/zsh-completions:$FPATH"