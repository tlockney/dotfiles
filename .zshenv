# .zshenv - Always sourced for ALL zsh shells (interactive and non-interactive)
# Keep this file minimal and fast - it runs for every zsh invocation

# Add mise shims to PATH for non-interactive shells
# Interactive shells will get full mise activation in .zshrc via tools.zsh
if [[ -d "$HOME/.local/share/mise/shims" ]]; then
  export PATH="$HOME/.local/share/mise/shims:$PATH"
fi

# Set up cargo environment
if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi

# Source local environment if it exists
if [[ -f "/usr/local/env" ]]; then
  . "/usr/local/env"
fi
