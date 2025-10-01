# Prompt configuration

# Default prompt (fallback if starship isn't available)
PS1='%B%F{yellow1}%~@%m%f -> %b'

# Enable starship prompt if available
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi